local Ironvale = loadstring(game:HttpGet("https://raw.githubusercontent.com/Toluwerr/ironvale-ui/refs/heads/main/Ironvale.lua"))()

local Window = Ironvale.CreateWindow({
	Name = "IronvaleExample",
	Title = "Ironvale Control Panel",
	Subtitle = "Professional component showcase",
	Theme = "Crimson",
	Size = UDim2.fromOffset(680, 460),
	ToggleKey = Enum.KeyCode.K,
})

local Home = Window:Tab({
	Title = "Home",
	Icon = "◆",
})

local Player = Window:Tab({
	Title = "Player",
	Icon = "◇",
})

local Settings = Window:Tab({
	Title = "Settings",
	Icon = "◎",
})

local Info = Home:Section({
	Title = "Overview",
	Description = "Example interface built with Ironvale UI",
})

Info:Paragraph({
	Title = "Ironvale UI",
	Text = "This loadstring-friendly example uses Astra-style aliases while still running on Ironvale.",
})

Info:Button({
	Title = "Show Notification",
	Description = "Tests Ironvale's notification system",
	ActionText = "Notify",
	Callback = function()
		Window:Notify({
			Title = "Ironvale UI",
			Text = "The notification system is working.",
			Type = "Success",
			Duration = 3,
		})
	end,
})

Info:CodeBlock({
	Title = "Example Code",
	Code = [[
print("Ironvale UI loaded.")
print("Press K to hide or show the window.")
]],
	Height = 150,
})

local Movement = Player:Section({
	Title = "Movement",
	Description = "Example player controls",
})

local SpeedEnabled = false
local WalkSpeed = 16

Movement:Toggle({
	Title = "Custom WalkSpeed",
	Description = "Enables the selected walk speed",
	Default = false,
	Callback = function(value)
		SpeedEnabled = value

		local player = game:GetService("Players").LocalPlayer
		local character = player.Character or player.CharacterAdded:Wait()
		local humanoid = character:FindFirstChildOfClass("Humanoid")

		if humanoid then
			humanoid.WalkSpeed = value and WalkSpeed or 16
		end

		Window:Notify({
			Title = "WalkSpeed",
			Text = value and "Custom speed enabled." or "Custom speed disabled.",
			Type = value and "Success" or "Warning",
			Duration = 2,
		})
	end,
})

Movement:Slider({
	Title = "WalkSpeed Amount",
	Min = 16,
	Max = 100,
	Default = 24,
	Step = 1,
	Callback = function(value)
		WalkSpeed = value

		if SpeedEnabled then
			local player = game:GetService("Players").LocalPlayer
			local character = player.Character
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")

			if humanoid then
				humanoid.WalkSpeed = value
			end
		end
	end,
})

Movement:Input({
	Title = "Status Message",
	Placeholder = "Type something...",
	Default = "Ironvale is loaded.",
	Callback = function(text)
		Window:Notify({
			Title = "Input Changed",
			Text = text,
			Type = "Info",
			Duration = 2,
		})
	end,
})

local Appearance = Settings:Section({
	Title = "Appearance",
	Description = "Theme and keybind examples",
})

Appearance:Dropdown({
	Title = "Theme",
	Options = { "Forged", "Crimson", "Slate" },
	Default = "Crimson",
	Callback = function(theme)
		Window:SetTheme(theme)
	end,
})

Appearance:Keybind({
	Title = "Notification Key",
	Default = Enum.KeyCode.N,
	Callback = function()
		Window:Notify({
			Title = "Keybind Pressed",
			Text = "You pressed the custom notification key.",
			Type = "Success",
			Duration = 2,
		})
	end,
})

Appearance:Button({
	Title = "Destroy UI",
	Description = "Completely removes Ironvale from the screen",
	ActionText = "Destroy",
	Callback = function()
		Window:Destroy()
	end,
})
