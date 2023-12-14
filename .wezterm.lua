-- Lua config for wezterm
-- https://wezfurlong.org/wezterm/config/lua/general.html
local wezterm = require 'wezterm';
local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- => -> != ~ @ # $ % ^ & * ( ) _ + { } | : " < > ? ` - = [ ] \ ; ' , . /

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}
config.font = wezterm.font_with_fallback({
  { family = "Terminess Nerd Font" },
  { family = "Noto Color Emoji" }
})
-- Don't Italic Ever >:(
config.font_rules = {
  {
    italic = true,
    font = wezterm.font_with_fallback({
      { family = "Terminess Nerd Font", italic = false },
      { family = "Noto Color Emoji" }
    })
  }
}
config.freetype_load_target = "Normal"
config.font_size = 12
config.color_scheme = "GruvboxDarkHard"
config.colors = {
  cursor_bg = 'grey',
  cursor_fg = 'black',
  quick_select_label_bg = { AnsiColor = 'Grey' },
  quick_select_label_fg = { AnsiColor = 'Olive' },
  quick_select_match_bg = { AnsiColor = 'Grey' },
  quick_select_match_fg = { AnsiColor = 'Silver' },
}
config.quick_select_patterns = {
  "CH[0-9]+", -- Changes
  "[A-Z]{3}-[0-9]{3}-[0-9]{5}" -- Kayako
}
config.quick_select_alphabet = "asdfghjkl;"
config.hide_tab_bar_if_only_one_tab = true
config.audible_bell = "Disabled"

return config
