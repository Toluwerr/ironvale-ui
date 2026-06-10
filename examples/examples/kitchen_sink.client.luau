local Ironvale = require(script.Parent.Parent.Ironvale)

local window = Ironvale.new({
	Name = "IronvaleKitchenSink",
	Title = "Ironvale Control Deck",
	Subtitle = "Kitchen sink component pass",
	Icon = "panel-left",
	Size = UDim2.fromOffset(760, 540),
	Theme = {
		Accent = Color3.fromRGB(186, 128, 65),
		AccentSoft = Color3.fromRGB(78, 57, 34),
		Success = Color3.fromRGB(132, 158, 94),
	},
})

local general = window:Tab({ Name = "General", Icon = "layout-dashboard", Default = true })
local automation = window:Tab({ Name = "Automation", Icon = "rocket" })
local settings = window:Tab({ Name = "Settings", Icon = "settings" })

local identity = general:Section("Workspace", {
	Icon = "database",
	Description = "Text, buttons, progress, and notices.",
})

identity:Input({
	Title = "Profile name",
	Description = "Rename the active preset.",
	Placeholder = "Operator profile",
	Default = "Night Shift",
	Callback = function(text)
		print("Profile:", text)
	end,
})

identity:Button({
	Title = "Save preset",
	Description = "Commit the current values.",
	Icon = "save",
	Callback = function()
		window:Notify({
			Title = "Preset saved",
			Body = "The current Ironvale settings were written by the demo callback.",
			Kind = "success",
			Icon = "check",
		})
	end,
})

identity:Progress({
	Title = "Deployment progress",
	Description = "A presentation-only progress bar.",
	Default = 0.46,
})

local flow = automation:Section("Automation", {
	Icon = "rocket",
	Description = "Stateful controls return handles with Get and Set helpers.",
})

local enabled = flow:Toggle({
	Title = "Enable job runner",
	Description = "Starts background actions in your own code.",
	Default = false,
	Callback = function(value)
		print("Runner:", value)
	end,
})

flow:Slider({
	Title = "Retry delay",
	Description = "Seconds between attempts.",
	Min = 0.25,
	Max = 10,
	Default = 2.5,
	Decimals = 2,
	Callback = function(value)
		print("Retry delay:", value)
	end,
})

flow:Dropdown({
	Title = "Failure mode",
	Description = "How the runner should respond.",
	Options = { "Pause", "Warn", "Retry", "Ignore" },
	Default = "Warn",
	Callback = function(value)
		print("Failure mode:", value)
	end,
})

flow:Keybind({
	Title = "Panic key",
	Description = "Click the row to rebind.",
	Default = Enum.KeyCode.P,
	Changed = function(key)
		print("Panic key changed:", key.Name)
	end,
	Callback = function()
		enabled.Set(false)
		window:Notify({
			Title = "Runner stopped",
			Body = "The panic key callback disabled the job runner.",
			Kind = "warning",
			Icon = "alert-triangle",
		})
	end,
})

local appearance = settings:Section("Appearance", {
	Icon = "palette",
	Description = "Consistent accents, no random color jumps.",
})

appearance:ColorSwatch({
	Title = "Accent swatch",
	Description = "Use this callback to update your own theme state.",
	Callback = function(color, hex)
		print("Accent selected:", hex, color)
	end,
})

appearance:Paragraph({
	Title = "Lucide icons",
	Body = "The library includes an inline Lucide-style stroke renderer for common icons and accepts rbxassetid overrides through IconPack.",
})

appearance:Divider()

appearance:Button({
	Title = "Confirm destructive action",
	Description = "Opens the included dialog component.",
	Icon = "trash-2",
	ActionIcon = "alert-triangle",
	Callback = function()
		window:Dialog({
			Title = "Delete preset?",
			Body = "This demo dialog closes itself and runs your callback only after confirmation.",
			PrimaryText = "Delete",
			SecondaryText = "Cancel",
			Icon = "alert-triangle",
			OnConfirm = function()
				window:Notify({
					Title = "Preset deleted",
					Body = "The destructive callback was confirmed.",
					Kind = "danger",
					Icon = "trash-2",
				})
			end,
		})
	end,
})
