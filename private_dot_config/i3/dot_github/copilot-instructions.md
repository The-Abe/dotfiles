# i3 Configuration

This is an i3 window manager configuration split across multiple files for modularity.

## Architecture

The entry point is `config`, which sets shared variables (colors, workspace names, defaults) and then includes:

1. `conf.d/*.conf` — shared config loaded on all machines:
   - `conf.d/binds.conf` — all keybindings
   - `conf.d/bar.conf` — i3bar configuration (uses color variables from the active theme)
   - `conf.d/startup.conf` — autostart programs
2. `` `hostname`.conf `` — machine-specific overrides, loaded last so they take precedence. Current host configs: `abe-debian.conf`, `laptop-abe.conf`.

## Color / Theme System

Colors are defined as variables at the top of `config` (currently using a Dracula-ish palette, despite the comment saying "Gruvbox"). Alternative theme files exist as standalone drop-ins:

- `gruvbox.conf` — Gruvbox palette
- `tokyonight-night.conf` — Tokyo Night palette

These files define the same variable names (`$fg`, `$bg`, `$c0`–`$c8`, `$con`), so swapping themes means replacing the color block at the top of `config` with the contents of one of these files.

All theme files should include `# vim: ft=i3config` as a modeline.

## Workspace Convention

Workspaces are named `"N:KEY"` (e.g., `"1:Q"`, `"2:W"`). The number is stripped in the bar (`strip_workspace_numbers yes`), so only the letter label shows. Workspaces 1–4 (`Q`/`W`/`E`/`R`) are intended for the left monitor; 5–8 (`T`/`Y`/`U`/`I`) for the right. Navigation uses `$mod+<letter>` to switch and `$mod+Shift+<letter>` to move windows.

## Key Conventions

- **`$mod` is `Mod4`** (Super/Windows key).
- Window focus/movement uses **vim-style hjkl** keys.
- `$mod+Shift+d` enters a **`launch` mode** for opening specific apps (browser, file manager, audio, Bluetooth, screen layouts).
- Floating windows can be triggered by setting the window title or class to `float`.
- The `status` bar uses a custom script at `~/.config/i3/status` (outputs i3bar JSON protocol). It shows: current Timewarrior task + duration (or `idle`), today's total tracked time, volume, battery, day/date, and a 10-block workday progress bar (09:00–17:00) + clock. Requires `timew` and `pactl`.
- Machine-specific `exec` lines (input device tuning, screen layout, idle/lock daemons) go in the `hostname.conf`, not `startup.conf`.
