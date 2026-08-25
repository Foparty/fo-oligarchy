local active_border_color = {
	colors = {
		-- vibrant oligarchy gold (deep amber → hot gold → bright highlight)
		"rgba(8a4f12ff)",
		"rgba(c47a18ff)",
		"rgba(e8a820ff)",
		"rgba(ffd700ff)",
		"rgba(fff0a0ff)",
		"rgba(ffd700ff)",
		"rgba(e8a820ff)",
	},
	angle = 45,
}
local inactive_border_color = "rgba(322f2aaa)"

hl.config({
	general = {
		border_size = 2,
		col = {
			active_border = active_border_color,
			inactive_border = inactive_border_color,
		},
	},
	group = {
		col = {
			border_active = active_border_color,
			border_inactive = inactive_border_color,
		},
	},
})

-- loop = continuous spin; speed is duration in ds (1ds = 100ms), so higher = slower
hl.animation({ leaf = "borderangle", enabled = true, speed = 50, bezier = "linear", style = "loop" })
