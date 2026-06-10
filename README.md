# Ironvale UI

Ironvale is a professional Luau UI library for Roblox client panels. It is designed for tools, admin consoles, configuration decks, and polished in-game utilities where a simple rounded-card layout is not enough.

The default theme is graphite with brass and moss accents. It avoids saturated generic blue/purple palettes, keeps corner radii restrained, and uses a consistent visual language for borders, controls, icons, and state.

## Files

- `Ironvale.lua` - the single-file library source.
- `examples/basic_window.client.luau` - small starter window.
- `examples/kitchen_sink.client.luau` - component coverage example.
- `examples/loadstring_astra_style.luau` - loadstring-friendly compatibility example.

## Install

1. Put `Ironvale.lua` in `ReplicatedStorage`, `StarterPlayerScripts`, or next to your LocalScript.
2. Require it from a LocalScript.
3. Build a window and tabs with the API below.

```lua
local Ironvale = require(path.to.Ironvale)

local window = Ironvale.new({
	Title = "Ironvale",
	Subtitle = "Moderation console",
	Icon = "shield",
	Size = UDim2.fromOffset(700, 500),
	ToggleKey = Enum.KeyCode.RightShift,
})

local tab = window:Tab({
	Name = "Overview",
	Icon = "layout-dashboard",
	Default = true,
})

local section = tab:Section("Runtime Status", {
	Icon = "activity",
	Description = "Operational controls with restrained contrast.",
})

section:Toggle({
	Title = "Guard mode",
	Description = "Keep sensitive actions gated.",
	Default = true,
	Callback = function(enabled)
		print(enabled)
	end,
})
```

## Loadstring Use

Ironvale also works from a raw GitHub loadstring in executor-style LocalScript environments:

```lua
local Ironvale = loadstring(game:HttpGet("https://raw.githubusercontent.com/Toluwerr/ironvale-ui/refs/heads/main/Ironvale.lua"))()

local Window = Ironvale.CreateWindow({
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

local Info = Home:Section({
	Title = "Overview",
	Description = "Astra-style aliases are supported.",
})

Info:Button({
	Title = "Show Notification",
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
```

## Components

- `Ironvale.CreateWindow(config)` or `Ironvale.new(config)`
- `Window:Tab({ Name, Icon, Default })`
- `Window:Tab({ Title, Icon, Default })`
- `Tab:Section(title, { Icon, Description })`
- `Tab:Section({ Title, Icon, Description })`
- `Section:Button({ Title, Description, Icon, Callback })`
- `Section:Button({ Title, Description, ActionText, Callback })`
- `Section:Toggle({ Title, Description, Default, Callback })`
- `Section:Slider({ Title, Min, Max, Default, Step, Decimals, Callback })`
- `Section:Dropdown({ Title, Options, Default, Callback })`
- `Section:Input({ Title, Placeholder, Default, Callback })`
- `Section:Keybind({ Title, Default, Changed, Callback })`
- `Section:ColorSwatch({ Title, Colors, Default, Callback })`
- `Section:Progress({ Title, Default })`
- `Section:Paragraph({ Title, Body })` or `Section:Paragraph({ Title, Text })`
- `Section:CodeBlock({ Title, Code, Height })`
- `Section:Divider()`
- `Window:Notify({ Title, Body, Kind, Icon, Duration })`
- `Window:Notify({ Title, Text, Type, Icon, Duration })`
- `Window:Dialog({ Title, Body, PrimaryText, SecondaryText, OnConfirm, OnCancel })`
- `Window:SetTheme("Forged" | "Crimson" | "Slate")`

Most stateful controls return small handles with `Get` and `Set` methods.

## Icons

Ironvale ships with an inline Lucide-style stroke renderer for common names:

`activity`, `alert-triangle`, `bell`, `check`, `chevron-down`, `chevron-right`, `copy`, `database`, `download`, `eye`, `home`, `info`, `key`, `layout-dashboard`, `list-checks`, `lock`, `minus`, `mouse-pointer-click`, `palette`, `panel-left`, `plus`, `rocket`, `save`, `search`, `settings`, `shield`, `sliders-horizontal`, `sparkles`, `terminal-square`, `trash-2`, `upload`, `wrench`, `x`.

Unknown short icon strings such as `◆`, `◇`, and `◎` render as text-icon fallbacks, so Astra-style examples do not break.

You can also pass uploaded Lucide image assets through `IconPack`:

```lua
local window = Ironvale.new({
	IconPack = {
		["layout-dashboard"] = "rbxassetid://0000000000",
		["settings"] = "rbxassetid://0000000000",
	},
})
```

## Theme

Override only the colors you need. Keep accents intentional so the UI does not turn into a random-color dashboard.

Built-in theme names are `Forged`, `Crimson`, `Slate`, and `Midnight` as an alias for `Forged`.

```lua
local window = Ironvale.new({
	Theme = {
		Accent = Color3.fromRGB(186, 128, 65),
		AccentSoft = Color3.fromRGB(78, 57, 34),
		Success = Color3.fromRGB(132, 158, 94),
	},
})
```

## Notes

- Ironvale must be required from a LocalScript because it creates PlayerGui UI.
- The default close button hides the window. Press the configured `ToggleKey` to show it again.
- `Window:Destroy()` disconnects events and removes the ScreenGui.
