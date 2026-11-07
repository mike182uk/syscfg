-- https://www.superlogical.com/rex/docs/customize/config
-- https://www.superlogical.com/rex/docs/reference/lua

-- Keybindings
rex.bind("cmd+ctrl+alt+shift+/", "client.sidebar.toggle")
rex.bind("alt+cmd+[", "session.previous")
rex.bind("alt+cmd+]", "session.next")

local prefix = "ctrl+b"

rex.bind(prefix .. ">c", "client.tab.new")
rex.bind(prefix .. ">s", "session.new")
rex.bind(prefix .. ">r", "client.config.reload")
rex.bind(prefix .. ">z", "pane.zoom")
-- Keys are matched unshifted, so | and _ are written as shift+\ and shift+-
rex.bind(prefix .. ">shift+\\", "pane.split", { direction = "right" })
rex.bind(prefix .. ">shift+-", "pane.split", { direction = "down" })
-- The prefix no longer reaches the terminal on its own, so pressing it twice sends it
rex.bind(prefix .. ">" .. prefix, "pane.send_key", { key = prefix })

-- Machine-specific config
local config_dir = (os.getenv("XDG_CONFIG_HOME") or (os.getenv("HOME") .. "/.config")) .. "/rex"
local local_config = io.open(config_dir .. "/local.lua")
if local_config then
  local_config:close()
  require("local")
end
