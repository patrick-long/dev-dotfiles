local wezterm = require 'wezterm'
local config = wezterm.config_builder()

local is_windows = os.getenv("OS") and os.getenv("OS"):lower():find("windows")
local home = wezterm.home_dir:gsub('\\', '/')

-- Terminal
if is_windows then
  config.default_prog = { "C:\\Program Files\\Git\\bin\\bash.exe", "-l" }
end

-- UI 
-- Customize rose pine theme slightly
local scheme = wezterm.color.get_builtin_schemes()['rose-pine']

scheme.background = '#121019'
scheme.foreground = '#e8e6f7'
scheme.brights[1] = '#7f7a99'

config.color_schemes = { ['rose-pine-deep'] = scheme }
config.color_scheme = 'rose-pine-deep'

config.max_fps = 120
config.font_size = 10
config.win32_system_backdrop = "Acrylic"
config.window_background_opacity = 0.7

local function collect_dirs(path, depth, map)
  if depth == 0 then return end

  for _, entry in ipairs(wezterm.read_dir(path)) do
    entry = entry:gsub('\\', '/')

    if pcall(wezterm.read_dir, entry) then
      table.insert(map, { id = entry, label = entry:sub(#home + 2) })
      collect_dirs(entry, depth - 1, map)
    end
  end
end

wezterm.on('gui-startup', function(cmd)
  local _, pane, window = wezterm.mux.spawn_window(cmd or {})

  -- Project picker waits for this pane's shell_ready signal
  wezterm.GLOBAL.startup_pane_id = pane:pane_id()

  -- Maximize window
  window:gui_window():maximize()
end)

-- Sent by .bashrc once the ssh-agent prompts are done
wezterm.on('user-var-changed', function(window, pane, name)
  if name ~= 'shell_ready' or pane:pane_id() ~= wezterm.GLOBAL.startup_pane_id then return end

  wezterm.GLOBAL.startup_pane_id = nil

  local dirs = {}

  collect_dirs(home .. '/deepspacerobots', 2, dirs)
  collect_dirs(home .. '/personal-projects', 1, dirs)

  window:perform_action(wezterm.action.InputSelector {
    title = 'Pick a project',
    fuzzy = true,
    choices = dirs,
    action = wezterm.action_callback(function(_, first, dir)
      if not dir then return end

      -- cd into chosen directory in initial pane
      first:send_text('cd "' .. dir .. '" && clear\r')

      -- Split into panes with the cwd
      local right = first:split { direction = 'Right', cwd = dir }
      right:split { direction = 'Bottom', cwd = dir, size = 0.25 }
      first:split { direction = "Bottom", cwd = dir, size = 0.25 }
      --
      -- Start nvim in top right pane
      right:send_text('nvim\r')

      -- Focus initial pane and start Claude
      first:activate()
      first:send_text('claude\r')
    end),
  }, pane)
end)

-- Shortcuts
local action = wezterm.action

config.keys = {
  {
    key = "|",
    mods = "CTRL|SHIFT",
    action = action.SplitHorizontal {
      domain = "CurrentPaneDomain"
    }
  },
  {
    key = "_",
    mods = "CTRL|SHIFT",
    action = action.SplitVertical {
      domain = "CurrentPaneDomain"
    }
  },
  {
    key = "x",
    mods = "CTRL|SHIFT",
    action = action.CloseCurrentPane {
      confirm = true
    }
  },
  {
    key = "f",
    mods = "CTRL",
    action = action.Search { CaseSensitiveString = "" }
  },
  {
    key = "f",
    mods = "CTRL|SHIFT",
    action = action.DisableDefaultAssignment
  },
}

return config
