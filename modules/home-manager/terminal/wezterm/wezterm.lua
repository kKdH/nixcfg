local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.enable_tab_bar = false;
config.window_close_confirmation = 'NeverPrompt'

config.initial_rows = 48
config.initial_cols = 160

config.font = wezterm.font("JetBrains Mono")
config.font_size = 12.0

config.color_scheme = "Tomorrow Night"

return config
