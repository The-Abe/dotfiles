#!/usr/bin/env python3
"""
rofi-whichkey — A nested, key-driven launcher using rofi.

Reads a JSON config file and presents a rofi dmenu where each item is bound
to a single key press (via rofi's -kb-custom-N). Items can be leaf actions
(exec a command, open a terminal, open a file in an editor) or submenus
that push a new level onto the navigation stack.

Exit codes from rofi dmenu are the key signal mechanism:
  0  = user pressed Enter on a selection
  1  = user cancelled (Escape, or rofi lost focus)
  10 = custom key 1 was pressed
  11 = custom key 2 was pressed
  ... and so on

We map exit code 10 to BackSpace (navigate up) and 11+ to the actual items.
"""

import json
import os
import re
import subprocess
import sys
from datetime import datetime

# Config file lives next to this script so the whole directory is relocatable.
CONFIG_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "rofi-whichkey.json")

# An item is a "leaf" (does something) or a "folder" (has sub-items).
# A leaf must have exactly one of these keys.
# Having more than one is ambiguous and caught during validation.
ACTION_KEYS = {"exec", "terminal", "editor", "note"}

# Default Nerd Font icons per action type. Used when an item doesn't
# specify its own "icon" field.
DEFAULT_ICONS = {
    "terminal": "",
    "editor": "",
    "exec": "󱆃",
    "folder": "󰉋",
    "note": "",
}

# Theme injected into rofi via -theme-str.
#
# Why these specific settings:
#
# - window: border-radius for rounded corners; width keeps it compact.
#
# - mainbox must include "inputbar" in its children list, otherwise
#   the prompt (which carries our breadcrumb) is invisible even if
#   the theme below styles it. The original minimal theme only had
#   [listview] which hid the breadcrumb entirely.
#
# - entry: placeholder-color and cursor-color are set to transparent
#   because this is a which-key menu — we don't want a blinking
#   cursor or the "Search..." text distracting from the key hints.
#   We still need the entry widget for rofi's built-in filtering
#   (you can type to narrow the list), so we can't remove it entirely.
#
# - listview fixed-height: false — makes rows only as tall as their
#   text, giving a more compact appearance than rofi's default.
#
# - element normal.normal and element selected.normal use the rofi
#   variables @fg-color and @bg-color so the theme adapts to whatever
#   rofi theme the user has loaded globally (e.g. from ~/.config/rofi/).
#
# - element-text markup: true enables Pango markup in row labels,
#   which we use to color the key badges (e.g. [T] in gold).
THEME_STR = """\
window {
  width: 600px;
}
mainbox {
  children: [inputbar, listview];
}
inputbar {
  spacing: 2px;
  children: [prompt, entry];
}
prompt {
  background-color: transparent;
  text-color: @fg-color;
}
entry {
  background-color: transparent;
  text-color: @fg-color;
  placeholder-color: transparent;
  cursor-color: transparent;
}
listview {
  columns: 2;
  cycle: true;
  fixed-height: false;
  lines: 10;
  spacing: 4px;
  padding: 4px;
  border: 0px;
}
scrollbar {
  handle-width: 0px;
  width: 0px;
}
element {
  padding: 1px 8px;
}
element normal.normal {
  background-color: transparent;
  text-color: @fg-color;
}
element selected.normal {
  background-color: @fg-color;
  text-color: @bg-color;
}
element-text {
  font: "JetBrainsMono Nerd Font 11";
  markup: true;
}
"""

# Colors for the key badge (e.g. "[T]"). These are gruvbox hex values.
# If you change the theme, you probably want to update these too.
BADGE_BG = "#504945"
BADGE_FG = "#fabd2f"

# Text color for folder items (submenus). Different from the default
# @fg-color so folders visually stand out as navigable groups.
FOLDER_FG = "#83a598"


def load_json_with_trailing_commas(path):
    """Load a JSON file that may have trailing commas.

    Python's json module rejects trailing commas (e.g. [1, 2, ] or
    {"a": 1, }), but trailing commas are extremely common when humans
    hand-edit JSON configs. This strips them with a regex before parsing.
    """
    with open(path) as f:
        content = f.read()
    # Match a comma followed only by whitespace and a closing } or ]
    content = re.sub(r',(\s*[}\]])', r'\1', content)
    return json.loads(content)


class ConfigError(Exception):
    """Raised when the config file has structural problems."""
    pass


def validate(config, path="root"):
    """Recursively validate the config structure.

    Checks that every item has a label and key, that keys don't clash
    within the same menu level, and that leaf items have exactly one
    action key (exec/terminal/editor). Folder items (those with an
    "items" array) are recursed into.
    """
    if not isinstance(config, dict):
        raise ConfigError(f"{path}: config must be a JSON object")

    if "label" not in config:
        raise ConfigError(f'{path}: missing "label"')

    if "items" not in config:
        raise ConfigError(f'{path}: missing "items"')

    if not isinstance(config["items"], list) or len(config["items"]) == 0:
        raise ConfigError(f'{path}: "items" must be a non-empty array')

    seen_keys = set()
    for i, item in enumerate(config["items"]):
        item_path = f'{path} → {item.get("label", f"item {i}")}'

        if "label" not in item:
            raise ConfigError(f'{item_path}: missing "label"')
        if "key" not in item:
            raise ConfigError(f'{item_path}: missing "key"')
        if item["key"].lower() in seen_keys:
            raise ConfigError(f'{item_path}: duplicate key "{item["key"]}"')
        seen_keys.add(item["key"].lower())

        action_keys = ACTION_KEYS & set(item.keys())
        if len(action_keys) > 1:
            raise ConfigError(
                f'{item_path}: can only have one of {sorted(ACTION_KEYS)}, '
                f'found {sorted(action_keys)}'
            )

        if "items" in item:
            # This is a folder — recurse
            if not isinstance(item["items"], list) or len(item["items"]) == 0:
                raise ConfigError(f'{item_path}: "items" must be a non-empty array')
            validate(item, item_path)
        elif not action_keys:
            # Leaf with no action — config is incomplete
            raise ConfigError(f'{item_path}: leaf item must have one of {sorted(ACTION_KEYS)}')


def get_icon(item):
    """Return the icon for an item, falling back to defaults by type."""
    if "icon" in item:
        return item["icon"]
    if "items" in item:
        return DEFAULT_ICONS["folder"]
    for action in ("terminal", "editor", "exec", "note"):
        if action in item:
            return DEFAULT_ICONS[action]
    return DEFAULT_ICONS["exec"]


def sort_items(items):
    """Sort items with folders first, then alphabetically by label within each group.

    This makes navigation predictable — submenus are always at the top,
    and actions are in alphabetical order below them.
    """
    folders = [item for item in items if "items" in item]
    leaves = [item for item in items if "items" not in item]
    folders.sort(key=lambda x: x["label"].lower())
    leaves.sort(key=lambda x: x["label"].lower())
    return folders + leaves


def format_option(item):
    """Build the display string for a rofi row.

    Uses Pango markup (enabled via element-text { markup: true }) to
    color the key badge. The result looks like:

        󰉋  [C]  Config

    Folder items get a different text color (FOLDER_FG) to visually
    distinguish them from leaf actions.
    """
    icon = get_icon(item)
    key = item["key"]
    badge = f'<span fgcolor="{BADGE_FG}">[{key}]</span>'
    label = item["label"]

    if "items" in item:
        label = f'<span fgcolor="{FOLDER_FG}">{label}</span>'

    return f'{icon}  {badge}  {label}'


def build_breadcrumb(root_label, path_labels):
    """Join the root label and navigation path into a breadcrumb string.

    Example: "Main > Config > Neovim"

    This is shown in rofi's prompt area so the user always knows
    which submenu level they're in.
    """
    parts = [root_label] + path_labels
    return " > ".join(parts)


def get_daily_note_path(vault, folder):
    """Build the path to today's daily note.

    The file name is YYYY/MM/YYYY-MM-DD.md inside the given folder within
    the vault. Both vault and folder have tilde expansion applied.

    Example: ~/Obsidian/Daily/2026/08/2026-08-22.md
    """
    vault = os.path.expanduser(vault)
    folder = os.path.expanduser(folder)
    now = datetime.now()
    year = now.strftime("%Y")
    month = now.strftime("%m")
    day = now.strftime("%Y-%m-%d")
    return os.path.join(vault, folder, year, month, f"{day}.md")


def capture_text(prompt="Capture"):
    """Open a rofi dmenu to capture a single line of text from the user.

    Returns the entered text, or None if the user cancelled.
    Uses a minimal theme that only shows the input bar (no listview below).
    """
    result = subprocess.run(
        [
            "rofi", "-dmenu", "-p", f"{prompt}:",
            "-placeholder", "",
            "-theme-str", """
                mainbox { children: [inputbar]; }
                inputbar { children: [prompt, entry]; }
                prompt { text-color: @fg-color; }
                entry { placeholder-color: transparent; cursor-color: transparent; text-color: @fg-color; }
            """,
        ],
        capture_output=True,
        text=True,
    )
    text = result.stdout.strip()
    if not text:
        return None
    return text


def append_to_daily_note(text, note_type, vault, folder):
    """Format text according to note_type and append to today's daily note.

    Supported note types:
    - "log"  → "- Entered text [CAPTURED: HH:MM]"
    - "todo" → "- [ ] Entered text"

    Creates the daily note file (and parent directories) if they don't exist.
    """
    note_path = get_daily_note_path(vault, folder)
    os.makedirs(os.path.dirname(note_path), exist_ok=True)

    if note_type == "log":
        timestamp = datetime.now().strftime("%H:%M")
        line = f"- {text} [CAPTURED: {timestamp}]"
    elif note_type == "todo":
        line = f"- [ ] {text}"
    else:
        line = f"- {text}"

    with open(note_path, "a") as f:
        f.write(line + "\n")


def resolve_exec(item, defaults):
    """Resolve an item to a shell command string.

    Priority:
    1. "exec" — use the raw string as-is.
    2. "terminal" — combine the global/editor terminal command with the
       item's working directory (via --working-directory).
    3. "editor" — combine the global/editor command with the item's file
       path. Tilde expansion is applied so "~/.config/..." works.

    If the item uses terminal/editor without a default being defined
    anywhere up the tree, raises ConfigError.
    """
    if "exec" in item:
        return item["exec"]

    if "terminal" in item:
        terminal_cmd = defaults.get("terminal", "")
        if not terminal_cmd:
            raise ConfigError("terminal action used but no terminal default defined")
        cwd = item["terminal"]
        if cwd:
            return f'{terminal_cmd} --working-directory="{os.path.expanduser(cwd)}"'
        return terminal_cmd

    if "editor" in item:
        editor_cmd = defaults.get("editor", "")
        if not editor_cmd:
            raise ConfigError("editor action used but no editor default defined")
        file_path = item["editor"]
        if file_path:
            return f'{editor_cmd} "{os.path.expanduser(file_path)}"'
        return editor_cmd

    return None


def show_menu(items, prompt="Leader"):
    """Show a rofi dmenu for the given items and return the selected item.

    Key bindings:
    - BackSpace → custom-1 → exit code 10 → "BACK" signal (navigate up)
    - Each item's key → custom-2, custom-3, ... → exit code 11, 12, ...

    Why we rebind kb-remove-char-back:
    ────────────────────────────────────
    By default, BackSpace in rofi's entry field is bound to
    kb-remove-char-back (delete the character before the cursor).
    We want BackSpace to navigate up the menu hierarchy instead.
    So we rebind kb-remove-char-back to Shift+BackSpace (preserving
    the ability to delete characters if the user really wants to),
    and then bind BackSpace to our custom-1 slot.

    Why placeholder is empty:
    ─────────────────────────
    Without setting -placeholder "" and placeholder-color: transparent,
    rofi shows "Search..." in the entry field. That clashes visually
    with the breadcrumb in the prompt and makes the UI look like a
    search box rather than a key menu.

    Why item keys start at custom-2:
    ────────────────────────────────
    custom-1 is reserved for BackSpace (navigate up). So the first
    item maps to custom-2, second to custom-3, etc. This means exit
    code 10 = BackSpace, and exit code 11 = first item.
    """
    # Sort: folders first, then alphabetically within each group
    items = sort_items(items)

    options = [format_option(item) for item in items]

    rofi_args = [
        "rofi", "-dmenu", "-markup-rows",
        "-p", prompt,
        "-placeholder", "",
        "-theme-str", THEME_STR,
        # Rebind character deletion to Shift+BackSpace so plain BackSpace
        # is free to use as our "go up one level" key.
        "-kb-remove-char-back", "Shift+BackSpace",
        # custom-1 = BackSpace (navigate up), exit code 10
        "-kb-custom-1", "BackSpace",
    ]

    # custom-2, custom-3, ... bound to each item's key
    for i, item in enumerate(items):
        rofi_args += [f"-kb-custom-{i + 2}", item["key"]]

    result = subprocess.run(
        rofi_args,
        input="\n".join(options),
        capture_output=True,
        text=True,
    )

    # rofi dmenu exit codes:
    #   0 = Enter on selection
    #   1 = Cancel (Escape, lost focus)
    #   10 = custom-1 (BackSpace → navigate up)
    #   11+ = custom-2, custom-3, ... (item keys)
    if result.returncode == 10:
        return "BACK"

    if result.returncode >= 11:
        idx = result.returncode - 11
        if 0 <= idx < len(items):
            return items[idx]

    return None


def navigate(config):
    """Main navigation loop.

    Uses an explicit stack instead of recursion so the user can go
    back up the breadcrumb by pressing BackSpace. Each stack frame
    holds the current menu's items, breadcrumb prompt, and inherited
    defaults (terminal/editor commands).

    Stack structure: [(items, prompt, defaults), ...]
    - items: list of item dicts to display
    - prompt: breadcrumb string shown in rofi's prompt area
    - defaults: {"terminal": ..., "editor": ..., "vault": ..., "daily_notes_folder": ...}
      inherited from parent menus
    """
    root_label = config.get("label", "Leader")
    defaults = {
        "terminal": config.get("terminal", ""),
        "editor": config.get("editor", ""),
        "vault": config.get("vault", ""),
        "daily_notes_folder": config.get("daily_notes_folder", ""),
    }

    # Start at the root level
    stack = [(config.get("items", []), root_label, defaults)]

    while stack:
        items, prompt, defaults = stack[-1]
        selected = show_menu(items, prompt)

        # None = rofi was closed (Escape or lost focus)
        if selected is None:
            stack.pop()
            continue

        # "BACK" = user pressed BackSpace to go up one level
        if selected == "BACK":
            stack.pop()
            continue

        # Folder item — push a new frame onto the stack
        if "items" in selected:
            new_defaults = {
                "terminal": selected.get("terminal", defaults["terminal"]),
                "editor": selected.get("editor", defaults["editor"]),
                "vault": selected.get("vault", defaults["vault"]),
                "daily_notes_folder": selected.get("daily_notes_folder", defaults["daily_notes_folder"]),
            }
            # Build the breadcrumb from the stack: root + all parent labels + this one
            breadcrumb = build_breadcrumb(
                root_label,
                [lvl[1] for lvl in stack[1:]] + [selected["label"]]
            )
            stack.append((selected["items"], breadcrumb, new_defaults))
        elif "note" in selected:
            # Note item — capture text and append to daily note
            text = capture_text(prompt=f"{selected['label']}")
            if text:
                append_to_daily_note(
                    text,
                    selected["note"],
                    defaults["vault"],
                    defaults["daily_notes_folder"],
                )
            # Exit after capturing — don't return to the menu
            return
        else:
            # Leaf item — resolve and execute
            exec_cmd = resolve_exec(selected, defaults)
            if exec_cmd:
                # os.execvp replaces this process with the command.
                # This means the shell/terminal that launched this script
                # will not see it return, which is the desired behavior
                # for an application launcher.
                os.execvp("bash", ["bash", "-c", exec_cmd])
            return


if __name__ == "__main__":
    config = load_json_with_trailing_commas(CONFIG_FILE)
    validate(config)
    navigate(config)
