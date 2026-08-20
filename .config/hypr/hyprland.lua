require("config/variables")
require("config/monitors")
require("config/autostart")
require("config/binds")
require("config/decoration")
require("config/windowrules")

local mainMod = "SUPER"

hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))

for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end

hl.workspace_rule({ workspace = "1", monitor = "DP-1"})
hl.workspace_rule({ workspace = "2", monitor = "DP-2"})
hl.workspace_rule({ workspace = "3", monitor = "DP-1"})
hl.workspace_rule({ workspace = "4", monitor = "DP-2"})
hl.workspace_rule({ workspace = "5", monitor = "DP-1"})
hl.workspace_rule({ workspace = "6", monitor = "DP-2"})
hl.workspace_rule({ workspace = "7", monitor = "DP-1"})
hl.workspace_rule({ workspace = "8", monitor = "DP-2"})
hl.workspace_rule({ workspace = "9", monitor = "DP-1"})
hl.workspace_rule({ workspace = "0", monitor = "DP-2"})
