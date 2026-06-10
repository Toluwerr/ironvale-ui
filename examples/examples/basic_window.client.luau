local Ironvale = require(script.Parent.Parent.Ironvale)

local window = Ironvale.new({
	Name = "IronvaleDemo",
	Title = "Ironvale",
	Subtitle = "Moderation console",
	Icon = "shield",
	Size = UDim2.fromOffset(700, 500),
	ToggleKey = Enum.KeyCode.RightShift,
})

local overview = window:Tab({
	Name = "Overview",
	Icon = "layout-dashboard",
	Default = true,
})

local status = overview:Section("Runtime Status", {
	Icon = "activity",
	Description = "Clean operational controls with restrained contrast.",
})

status:Paragraph({
	Title = "Design direction",
	Body = "Ironvale uses a graphite, moss, and brass system instead of saturated blue accents. Corners stay tight and the layout favors clear operator workflows.",
})

status:Progress({
	Title = "Session health",
	Description = "Updated by your own game loop or telemetry code.",
	Default = 0.72,
})

status:Button({
	Title = "Send toast",
	Description = "Shows a compact notification.",
	Icon = "bell",
	Callback = function()
		window:Notify({
			Title = "Ironvale is running",
			Body = "The demo action fired successfully.",
			Kind = "success",
			Icon = "check",
		})
	end,
})

local controls = window:Tab({
	Name = "Controls",
	Icon = "sliders-horizontal",
})

local section = controls:Section("Gameplay Flags", {
	Icon = "settings",
	Description = "Use these rows as live configuration controls.",
})

section:Toggle({
	Title = "Guard mode",
	Description = "Keep sensitive actions gated.",
	Default = true,
	Callback = function(enabled)
		print("Guard mode:", enabled)
	end,
})

section:Slider({
	Title = "Scan radius",
	Description = "Example numeric input.",
	Min = 10,
	Max = 250,
	Default = 80,
	Callback = function(value)
		print("Scan radius:", value)
	end,
})

section:Dropdown({
	Title = "Priority lane",
	Description = "Select an operating profile.",
	Options = { "Balanced", "Strict", "Observe" },
	Default = "Balanced",
	Callback = function(value)
		print("Priority lane:", value)
	end,
})
