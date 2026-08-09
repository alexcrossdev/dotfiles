local MOD = "SUPER + "
local MOD_S = MOD .. "SHIFT + "

-- Control
hl.bind(MOD .. "Q", hl.dsp.window.close())
hl.bind(MOD .. "M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))

hl.bind(MOD .. "H", hl.dsp.focus({ direction = "left" }))
hl.bind(MOD .. "J", hl.dsp.focus({ direction = "down" }))
hl.bind(MOD .. "K", hl.dsp.focus({ direction = "up" }))
hl.bind(MOD .. "L", hl.dsp.focus({ direction = "right" }))

hl.bind(MOD_S .. "H", hl.dsp.window.move({ direction = "left" }))
hl.bind(MOD_S .. "J", hl.dsp.window.move({ direction = "down" }))
hl.bind(MOD_S .. "K", hl.dsp.window.move({ direction = "up" }))
hl.bind(MOD_S .. "L", hl.dsp.window.move({ direction = "right" }))

hl.bind(MOD .. " + mouse:272", hl.dsp.window.drag(),    { mouse = true })
hl.bind(MOD .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(MOD .. "Tab", hl.dsp.window.swap({ next = true }))

-- Programs
hl.bind(MOD .. "Return", hl.dsp.exec_cmd("alacritty"))
hl.bind(MOD .. "F", hl.dsp.exec_cmd("firefox"))
hl.bind(MOD .. "W", hl.dsp.exec_cmd("alacritty -e yazi"))
