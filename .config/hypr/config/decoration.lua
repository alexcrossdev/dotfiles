local function load_pywal_colors()
  local colors = {}
  local wal = os.getenv("HOME") .. "/.cache/wal/colors.sh"
  local f = io.open(wal, "r")
  if not f then return colors end

  for line in f:lines() do
    local n, hex = line:match("^color(%d%d?)='(#[%da-fA-F]+)'")
    if n and hex then
      colors[tonumber(n)] = hex
    end
  end

  f:close()
  return colors
end

local wal = load_pywal_colors()

local function rgba_from_hex(hex, alpha)
  if not hex then return nil end
  local c = hex:gsub("#", "")
  return ("rgba(%s%s)"):format(c, alpha) -- rgba(RRGGBBAA) style
end

hl.config({
    general = {
        gaps_in  = 6,
        gaps_out = 14,
        border_size = 2,

        col = {
            active_border   = {
				colors = {
					rgba_from_hex(wal[4], "ff"),
					rgba_from_hex(wal[1], "ff"),
				},
				angle = 45
			},
            inactive_border = rgba_from_hex(wal[8], "aa"),
        },

        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",
    },

    decoration = {
        rounding       = 8,
        rounding_power = 2,

        active_opacity   = 1.0,
        inactive_opacity = 0.94,

        shadow = {
            enabled      = true,
            range        = 12,
            render_power = 3,
            color        = 0x661d2021,
        },

        blur = {
            enabled   = true,
            size      = 6,
            passes    = 2,
            vibrancy  = 0.2,
        },
    },

    animations = {
        enabled = true,
    },
})

-- Gruvbox Custom Curves & Animations
hl.curve("gruvEase",       { type = "bezier", points = { {0.25, 1},     {0.5, 1}     } })
hl.curve("gruvSmooth",     { type = "bezier", points = { {0.4, 0},      {0.2, 1}     } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},        {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},    {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.1, 0.9},    {0.1, 1}     } })
hl.curve("gruvSpring",     { type = "spring", mass = 0.8, stiffness = 300, dampening = 22 })

hl.animation({ leaf = "global",        enabled = true,  speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true,  speed = 6.0,  bezier = "gruvEase" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 5.5,  spring = "gruvSpring" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 5.0,  spring = "gruvSpring", style = "popin 80%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 3.0,  bezier = "linear",     style = "popin 80%" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 3.0,  bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 3.0,  bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 4.0,  bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true,  speed = 4.0,  bezier = "gruvEase" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4.0,  bezier = "gruvEase", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 3.0,  bezier = "linear",   style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 3.0,  bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 3.0,  bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true,  speed = 3.5,  bezier = "gruvSmooth", style = "slide" })
hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 3.5,  bezier = "gruvSmooth", style = "slide" })
hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 3.5,  bezier = "gruvSmooth", style = "slide" })
hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 7,    bezier = "quick" })

hl.config({
    dwindle = {
        preserve_split = true,
    },
    master = {
        new_status = "master",
    },
    scrolling = {
        fullscreen_on_one_column = true,
    },
})
