--!nocheck
-- Ironvale UI
-- A single-file Luau UI library for professional Roblox client panels.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Ironvale = {}
Ironvale.Version = "1.1.0"

local Window = {}
Window.__index = Window

local Tab = {}
Tab.__index = Tab

local Section = {}
Section.__index = Section

local DEFAULT_THEME = {
	Font = Enum.Font.Gotham,
	FontMedium = Enum.Font.GothamMedium,
	FontBold = Enum.Font.GothamBold,

	Background = Color3.fromRGB(15, 16, 14),
	Surface = Color3.fromRGB(22, 24, 21),
	SurfaceHigh = Color3.fromRGB(30, 33, 28),
	SurfaceRaised = Color3.fromRGB(38, 41, 35),
	SurfaceSunken = Color3.fromRGB(17, 19, 16),

	Border = Color3.fromRGB(67, 71, 59),
	BorderSoft = Color3.fromRGB(47, 51, 43),

	Text = Color3.fromRGB(239, 240, 232),
	TextMuted = Color3.fromRGB(166, 171, 158),
	TextFaint = Color3.fromRGB(114, 120, 107),

	Accent = Color3.fromRGB(178, 132, 70),
	AccentSoft = Color3.fromRGB(75, 57, 36),
	AccentMuted = Color3.fromRGB(132, 108, 70),

	Success = Color3.fromRGB(137, 157, 94),
	Warning = Color3.fromRGB(203, 148, 72),
	Danger = Color3.fromRGB(188, 82, 75),
	Info = Color3.fromRGB(128, 137, 108),
	Shadow = Color3.fromRGB(0, 0, 0),
}

local THEME_PRESETS = {
	forged = {},
	graphite = {},
	midnight = {},
	crimson = {
		Accent = Color3.fromRGB(177, 83, 73),
		AccentSoft = Color3.fromRGB(73, 37, 34),
		AccentMuted = Color3.fromRGB(139, 78, 67),
		Success = Color3.fromRGB(134, 158, 94),
		Warning = Color3.fromRGB(202, 147, 72),
		Danger = Color3.fromRGB(201, 85, 77),
		Info = Color3.fromRGB(145, 126, 103),
	},
	slate = {
		Background = Color3.fromRGB(14, 16, 15),
		Surface = Color3.fromRGB(21, 24, 22),
		SurfaceHigh = Color3.fromRGB(29, 33, 30),
		SurfaceRaised = Color3.fromRGB(37, 42, 38),
		SurfaceSunken = Color3.fromRGB(17, 19, 18),
		Border = Color3.fromRGB(63, 70, 63),
		BorderSoft = Color3.fromRGB(43, 49, 44),
		Text = Color3.fromRGB(236, 239, 232),
		TextMuted = Color3.fromRGB(165, 174, 161),
		TextFaint = Color3.fromRGB(111, 122, 112),
		Accent = Color3.fromRGB(142, 153, 112),
		AccentSoft = Color3.fromRGB(49, 59, 43),
		AccentMuted = Color3.fromRGB(109, 124, 92),
		Success = Color3.fromRGB(137, 161, 102),
		Warning = Color3.fromRGB(199, 148, 76),
		Danger = Color3.fromRGB(187, 83, 76),
		Info = Color3.fromRGB(136, 145, 117),
	},
}

local ICONS = {
	["activity"] = { { "line", 2, 12, 6, 12 }, { "line", 6, 12, 9, 4 }, { "line", 9, 4, 14, 20 }, { "line", 14, 20, 17, 12 }, { "line", 17, 12, 22, 12 } },
	["alert-triangle"] = { { "line", 12, 3, 22, 20 }, { "line", 22, 20, 2, 20 }, { "line", 2, 20, 12, 3 }, { "line", 12, 9, 12, 14 }, { "dot", 12, 17, 1.25 } },
	["bell"] = { { "line", 5, 18, 19, 18 }, { "line", 6, 18, 7, 10 }, { "line", 7, 10, 10, 6 }, { "line", 10, 6, 14, 6 }, { "line", 14, 6, 17, 10 }, { "line", 17, 10, 18, 18 }, { "line", 10, 21, 14, 21 } },
	["check"] = { { "line", 5, 12, 10, 17 }, { "line", 10, 17, 20, 7 } },
	["chevron-down"] = { { "line", 6, 9, 12, 15 }, { "line", 12, 15, 18, 9 } },
	["chevron-right"] = { { "line", 9, 6, 15, 12 }, { "line", 15, 12, 9, 18 } },
	["circle"] = { { "circle", 12, 12, 8 } },
	["copy"] = { { "rect", 8, 8, 11, 11, 2 }, { "rect", 5, 5, 11, 11, 2 } },
	["database"] = { { "ellipse", 12, 5, 7, 3 }, { "line", 5, 5, 5, 18 }, { "line", 19, 5, 19, 18 }, { "ellipse", 12, 18, 7, 3 }, { "line", 5, 11, 19, 11 } },
	["download"] = { { "line", 12, 4, 12, 15 }, { "line", 8, 11, 12, 15 }, { "line", 16, 11, 12, 15 }, { "line", 5, 20, 19, 20 } },
	["eye"] = { { "line", 2, 12, 6, 8 }, { "line", 6, 8, 12, 6 }, { "line", 12, 6, 18, 8 }, { "line", 18, 8, 22, 12 }, { "line", 22, 12, 18, 16 }, { "line", 18, 16, 12, 18 }, { "line", 12, 18, 6, 16 }, { "line", 6, 16, 2, 12 }, { "circle", 12, 12, 2.5 } },
	["home"] = { { "line", 3, 11, 12, 4 }, { "line", 12, 4, 21, 11 }, { "line", 5, 10, 5, 20 }, { "line", 19, 10, 19, 20 }, { "line", 5, 20, 10, 20 }, { "line", 14, 20, 19, 20 }, { "line", 10, 20, 10, 14 }, { "line", 14, 20, 14, 14 } },
	["info"] = { { "circle", 12, 12, 9 }, { "line", 12, 11, 12, 17 }, { "dot", 12, 7.5, 1.2 } },
	["key"] = { { "circle", 7.5, 12, 3.5 }, { "line", 11, 12, 21, 12 }, { "line", 17, 12, 17, 15 }, { "line", 20, 12, 20, 15 } },
	["layout-dashboard"] = { { "rect", 3, 3, 7, 8, 2 }, { "rect", 14, 3, 7, 5, 2 }, { "rect", 14, 12, 7, 9, 2 }, { "rect", 3, 15, 7, 6, 2 } },
	["list-checks"] = { { "line", 4, 7, 6, 9 }, { "line", 6, 9, 9, 5 }, { "line", 12, 7, 21, 7 }, { "line", 4, 14, 6, 16 }, { "line", 6, 16, 9, 12 }, { "line", 12, 14, 21, 14 }, { "line", 12, 20, 21, 20 } },
	["lock"] = { { "rect", 5, 10, 14, 10, 2 }, { "line", 8, 10, 8, 7 }, { "line", 16, 10, 16, 7 }, { "line", 8, 7, 10, 5 }, { "line", 16, 7, 14, 5 }, { "line", 10, 5, 14, 5 }, { "line", 12, 14, 12, 17 } },
	["minus"] = { { "line", 5, 12, 19, 12 } },
	["mouse-pointer-click"] = { { "line", 5, 3, 17, 15 }, { "line", 5, 3, 8, 20 }, { "line", 8, 20, 12, 15 }, { "line", 12, 15, 16, 21 }, { "line", 16, 21, 19, 19 } },
	["palette"] = { { "circle", 12, 12, 9 }, { "dot", 8, 9, 1.2 }, { "dot", 12, 7, 1.2 }, { "dot", 16, 9, 1.2 }, { "dot", 9, 14, 1.2 }, { "line", 14, 17, 17, 17 } },
	["panel-left"] = { { "rect", 3, 4, 18, 16, 2 }, { "line", 9, 4, 9, 20 } },
	["plus"] = { { "line", 12, 5, 12, 19 }, { "line", 5, 12, 19, 12 } },
	["rocket"] = { { "line", 5, 19, 10, 17 }, { "line", 7, 14, 10, 17 }, { "line", 10, 17, 17, 10 }, { "line", 17, 10, 20, 4 }, { "line", 20, 4, 14, 7 }, { "line", 14, 7, 7, 14 }, { "circle", 15.5, 8.5, 1.6 } },
	["save"] = { { "rect", 4, 4, 16, 16, 2 }, { "line", 8, 4, 8, 10 }, { "line", 16, 4, 16, 10 }, { "line", 8, 10, 16, 10 }, { "rect", 8, 14, 8, 6, 1 } },
	["search"] = { { "circle", 10.5, 10.5, 6.5 }, { "line", 15, 15, 21, 21 } },
	["settings"] = { { "circle", 12, 12, 3.5 }, { "line", 12, 2, 12, 5 }, { "line", 12, 19, 12, 22 }, { "line", 2, 12, 5, 12 }, { "line", 19, 12, 22, 12 }, { "line", 5, 5, 7, 7 }, { "line", 17, 17, 19, 19 }, { "line", 19, 5, 17, 7 }, { "line", 7, 17, 5, 19 } },
	["shield"] = { { "line", 12, 3, 20, 7 }, { "line", 20, 7, 18, 16 }, { "line", 18, 16, 12, 21 }, { "line", 12, 21, 6, 16 }, { "line", 6, 16, 4, 7 }, { "line", 4, 7, 12, 3 } },
	["sliders-horizontal"] = { { "line", 4, 7, 10, 7 }, { "line", 14, 7, 20, 7 }, { "circle", 12, 7, 2 }, { "line", 4, 12, 6, 12 }, { "line", 10, 12, 20, 12 }, { "circle", 8, 12, 2 }, { "line", 4, 17, 15, 17 }, { "line", 19, 17, 20, 17 }, { "circle", 17, 17, 2 } },
	["sparkles"] = { { "line", 12, 3, 12, 8 }, { "line", 12, 16, 12, 21 }, { "line", 3, 12, 8, 12 }, { "line", 16, 12, 21, 12 }, { "line", 8, 8, 16, 16 }, { "line", 16, 8, 8, 16 } },
	["terminal-square"] = { { "rect", 3, 4, 18, 16, 2 }, { "line", 7, 9, 10, 12 }, { "line", 10, 12, 7, 15 }, { "line", 13, 15, 17, 15 } },
	["trash-2"] = { { "line", 5, 7, 19, 7 }, { "line", 9, 7, 9, 4 }, { "line", 15, 7, 15, 4 }, { "line", 9, 4, 15, 4 }, { "line", 7, 7, 8, 20 }, { "line", 17, 7, 16, 20 }, { "line", 8, 20, 16, 20 }, { "line", 11, 10, 11, 17 }, { "line", 13, 10, 13, 17 } },
	["upload"] = { { "line", 12, 20, 12, 9 }, { "line", 8, 13, 12, 9 }, { "line", 16, 13, 12, 9 }, { "line", 5, 4, 19, 4 } },
	["wrench"] = { { "line", 14, 5, 19, 10 }, { "line", 19, 10, 10, 19 }, { "line", 10, 19, 5, 14 }, { "line", 5, 14, 14, 5 }, { "circle", 7.5, 16.5, 1.3 } },
	["x"] = { { "line", 6, 6, 18, 18 }, { "line", 18, 6, 6, 18 } },
}

local function copy(source)
	local result = {}
	for key, value in pairs(source) do
		result[key] = value
	end
	return result
end

local function apply(theme, overrides)
	if overrides then
		for key, value in pairs(overrides) do
			theme[key] = value
		end
	end
end

local function resolveTheme(input)
	local theme = copy(DEFAULT_THEME)
	if typeof(input) == "string" then
		apply(theme, THEME_PRESETS[string.lower(input)])
	elseif typeof(input) == "table" then
		if typeof(input.Preset) == "string" then
			apply(theme, THEME_PRESETS[string.lower(input.Preset)])
		elseif typeof(input.Name) == "string" then
			apply(theme, THEME_PRESETS[string.lower(input.Name)])
		end
		apply(theme, input)
	end
	return theme
end

local function new(className, props, children)
	local instance = Instance.new(className)
	for key, value in pairs(props or {}) do
		instance[key] = value
	end
	for _, child in ipairs(children or {}) do
		child.Parent = instance
	end
	return instance
end

local function addCorner(parent, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = parent
	return corner
end

local function addStroke(parent, color, transparency, thickness)
	local stroke = Instance.new("UIStroke")
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Color = color
	stroke.Transparency = transparency or 0
	stroke.Thickness = thickness or 1
	stroke.Parent = parent
	return stroke
end

local function addPadding(parent, left, top, right, bottom)
	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, left)
	padding.PaddingTop = UDim.new(0, top or left)
	padding.PaddingRight = UDim.new(0, right or left)
	padding.PaddingBottom = UDim.new(0, bottom or top or left)
	padding.Parent = parent
	return padding
end

local function addList(parent, padding, horizontal)
	local list = Instance.new("UIListLayout")
	list.FillDirection = horizontal and Enum.FillDirection.Horizontal or Enum.FillDirection.Vertical
	list.SortOrder = Enum.SortOrder.LayoutOrder
	list.Padding = UDim.new(0, padding)
	list.Parent = parent
	return list
end

local function label(props)
	props.BackgroundTransparency = 1
	props.BorderSizePixel = 0
	props.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Left
	props.TextYAlignment = props.TextYAlignment or Enum.TextYAlignment.Center
	return new("TextLabel", props)
end

local function bind(window, signal, callback)
	local connection = signal:Connect(callback)
	table.insert(window._connections, connection)
	return connection
end

local function safeCall(callback, ...)
	if typeof(callback) ~= "function" then
		return
	end
	local ok, err = pcall(callback, ...)
	if not ok then
		warn("[Ironvale] callback failed:", err)
	end
end

local function tween(instance, goals, time)
	local animation = TweenService:Create(instance, TweenInfo.new(time or 0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), goals)
	animation:Play()
	return animation
end

local function paint(window, instance, property, key)
	instance[property] = window._theme[key]
	table.insert(window._paints, { instance, property, key })
end

local function setIconColor(holder, color)
	for _, item in ipairs(holder:GetDescendants()) do
		if item:IsA("Frame") then
			item.BackgroundColor3 = color
		elseif item:IsA("UIStroke") then
			item.Color = color
		elseif item:IsA("TextLabel") then
			item.TextColor3 = color
		elseif item:IsA("ImageLabel") then
			item.ImageColor3 = color
		end
	end
end

local function drawLine(parent, size, color, x1, y1, x2, y2, thickness)
	local scale = size / 24
	local sx, sy, ex, ey = x1 * scale, y1 * scale, x2 * scale, y2 * scale
	local dx, dy = ex - sx, ey - sy
	local line = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = color,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset((sx + ex) / 2, (sy + ey) / 2),
		Rotation = math.deg(math.atan2(dy, dx)),
		Size = UDim2.fromOffset(math.sqrt(dx * dx + dy * dy), thickness),
	})
	addCorner(line, math.max(1, thickness))
	line.Parent = parent
end

local function drawRect(parent, size, color, x, y, width, height, radius, thickness)
	local scale = size / 24
	local rect = new("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(x * scale, y * scale),
		Size = UDim2.fromOffset(width * scale, height * scale),
	})
	addCorner(rect, math.max(1, radius * scale))
	addStroke(rect, color, 0, thickness)
	rect.Parent = parent
end

local function drawCircle(parent, size, color, x, y, radius, thickness, filled)
	local scale = size / 24
	local circle = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = color,
		BackgroundTransparency = filled and 0 or 1,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(x * scale, y * scale),
		Size = UDim2.fromOffset(radius * 2 * scale, radius * 2 * scale),
	})
	addCorner(circle, 999)
	if not filled then
		addStroke(circle, color, 0, thickness)
	end
	circle.Parent = parent
end

local function drawEllipse(parent, size, color, x, y, radiusX, radiusY, thickness)
	local scale = size / 24
	local ellipse = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(x * scale, y * scale),
		Size = UDim2.fromOffset(radiusX * 2 * scale, radiusY * 2 * scale),
	})
	addCorner(ellipse, 999)
	addStroke(ellipse, color, 0, thickness)
	ellipse.Parent = parent
end

local function createIcon(window, name, size, color)
	local holder = new("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromOffset(size, size),
	})
	if name == nil or name == "" then
		return holder
	end

	local theme = window and window._theme or DEFAULT_THEME
	local finalColor = color or theme.TextMuted
	local iconPack = window and window._iconPack or nil
	local asset = iconPack and iconPack[name] or nil
	if typeof(asset) == "string" then
		new("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Image = asset,
			ImageColor3 = finalColor,
			Position = UDim2.fromScale(0.5, 0.5),
			ScaleType = Enum.ScaleType.Fit,
			Size = UDim2.fromScale(1, 1),
			Parent = holder,
		})
		return holder
	end

	local primitives = ICONS[name]
	if not primitives then
		if string.len(tostring(name)) <= 8 then
			label({
				AnchorPoint = Vector2.new(0.5, 0.5),
				Font = theme.FontBold,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(1, 1),
				Text = tostring(name),
				TextColor3 = finalColor,
				TextSize = math.max(12, size - 2),
				TextXAlignment = Enum.TextXAlignment.Center,
				Parent = holder,
			})
			return holder
		end
		primitives = ICONS.circle
	end

	local thickness = math.max(1.35, math.floor(size / 12))
	for _, primitive in ipairs(primitives) do
		local kind = primitive[1]
		if kind == "line" then
			drawLine(holder, size, finalColor, primitive[2], primitive[3], primitive[4], primitive[5], thickness)
		elseif kind == "rect" then
			drawRect(holder, size, finalColor, primitive[2], primitive[3], primitive[4], primitive[5], primitive[6] or 1, thickness)
		elseif kind == "circle" then
			drawCircle(holder, size, finalColor, primitive[2], primitive[3], primitive[4], thickness, false)
		elseif kind == "dot" then
			drawCircle(holder, size, finalColor, primitive[2], primitive[3], primitive[4], thickness, true)
		elseif kind == "ellipse" then
			drawEllipse(holder, size, finalColor, primitive[2], primitive[3], primitive[4], primitive[5], thickness)
		end
	end
	return holder
end

function Ironvale.RegisterIcon(name, primitives)
	ICONS[name] = primitives
end

function Ironvale.GetTheme()
	return copy(DEFAULT_THEME)
end

local function makeDraggable(window, handle, root)
	local dragging = false
	local dragStart = Vector2.zero
	local rootStart = UDim2.new()

	bind(window, handle.InputBegan, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = Vector2.new(input.Position.X, input.Position.Y)
			rootStart = root.Position
		end
	end)

	bind(window, handle.InputEnded, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	bind(window, UserInputService.InputChanged, function(input)
		if not dragging then
			return
		end
		if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		local current = Vector2.new(input.Position.X, input.Position.Y)
		local delta = current - dragStart
		root.Position = UDim2.new(rootStart.X.Scale, rootStart.X.Offset + delta.X, rootStart.Y.Scale, rootStart.Y.Offset + delta.Y)
	end)
end

local function utilityButton(window, iconName, parent, callback)
	local theme = window._theme
	local button = new("TextButton", {
		AutoButtonColor = false,
		BackgroundColor3 = theme.SurfaceHigh,
		BorderSizePixel = 0,
		Size = UDim2.fromOffset(38, 34),
		Text = "",
		Parent = parent,
	})
	addCorner(button, 6)
	addStroke(button, theme.BorderSoft, 0.2, 1)
	local icon = createIcon(window, iconName, 16, theme.TextMuted)
	icon.AnchorPoint = Vector2.new(0.5, 0.5)
	icon.Position = UDim2.fromScale(0.5, 0.5)
	icon.Parent = button
	bind(window, button.MouseEnter, function()
		tween(button, { BackgroundColor3 = window._theme.SurfaceRaised })
	end)
	bind(window, button.MouseLeave, function()
		tween(button, { BackgroundColor3 = window._theme.SurfaceHigh })
	end)
	bind(window, button.MouseButton1Click, callback)
	return button
end

function Ironvale.new(config)
	config = config or {}
	local player = Players.LocalPlayer
	assert(player, "Ironvale must be required from a LocalScript.")

	local parent = config.Parent or player:WaitForChild("PlayerGui")
	local self = setmetatable({
		_theme = resolveTheme(config.Theme),
		_iconPack = config.IconPack or {},
		_connections = {},
		_paints = {},
		_tabs = {},
		_selectedTab = nil,
		_visible = true,
		_minimized = false,
	}, Window)

	local theme = self._theme
	local size = config.Size or UDim2.fromOffset(700, 500)
	local rootPosition = config.Position or UDim2.fromScale(0.5, 0.5)

	local gui = new("ScreenGui", {
		DisplayOrder = config.DisplayOrder or 20,
		IgnoreGuiInset = config.IgnoreGuiInset == true,
		Name = config.Name or "Ironvale",
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	})
	self.Gui = gui
	self._fullSize = size

	local shadow = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = theme.Shadow,
		BackgroundTransparency = 0.72,
		BorderSizePixel = 0,
		Position = UDim2.new(rootPosition.X.Scale, rootPosition.X.Offset, rootPosition.Y.Scale, rootPosition.Y.Offset + 8),
		Size = UDim2.new(size.X.Scale, size.X.Offset + 8, size.Y.Scale, size.Y.Offset + 10),
		ZIndex = 0,
		Parent = gui,
	})
	addCorner(shadow, 8)
	self.Shadow = shadow

	local root = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = theme.Background,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Position = rootPosition,
		Size = size,
		ZIndex = 1,
		Parent = gui,
	})
	addCorner(root, 7)
	addStroke(root, theme.Border, 0.08, 1)
	paint(self, root, "BackgroundColor3", "Background")
	self.Root = root

	local header = new("Frame", {
		BackgroundColor3 = theme.Surface,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 74),
		Parent = root,
	})
	paint(self, header, "BackgroundColor3", "Surface")
	self.Header = header

	new("Frame", {
		AnchorPoint = Vector2.new(0, 1),
		BackgroundColor3 = theme.BorderSoft,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 1, 0),
		Size = UDim2.new(1, 0, 0, 1),
		Parent = header,
	})

	local brand = new("Frame", {
		BackgroundColor3 = theme.AccentSoft,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(20, 16),
		Size = UDim2.fromOffset(44, 42),
		Parent = header,
	})
	addCorner(brand, 8)
	addStroke(brand, theme.AccentMuted, 0.1, 1)
	local brandIcon = createIcon(self, config.Icon or "panel-left", 22, theme.Accent)
	brandIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	brandIcon.Position = UDim2.fromScale(0.5, 0.5)
	brandIcon.Parent = brand

	label({
		Font = theme.FontBold,
		Position = UDim2.fromOffset(78, 16),
		Size = UDim2.new(1, -220, 0, 25),
		Text = config.Title or config.Name or "Ironvale",
		TextColor3 = theme.Text,
		TextSize = 18,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = header,
	})

	label({
		Font = theme.Font,
		Position = UDim2.fromOffset(78, 42),
		Size = UDim2.new(1, -220, 0, 18),
		Text = config.Subtitle or "Client control deck",
		TextColor3 = theme.TextMuted,
		TextSize = 13,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = header,
	})

	local utility = new("Frame", {
		AnchorPoint = Vector2.new(1, 0),
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -18, 0, 20),
		Size = UDim2.fromOffset(84, 34),
		Parent = header,
	})
	addList(utility, 8, true)

	utilityButton(self, "minus", utility, function()
		self:SetMinimized(not self._minimized)
	end)
	utilityButton(self, "x", utility, function()
		self:Hide()
	end)

	local body = new("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(0, 74),
		Size = UDim2.new(1, 0, 1, -74),
		Parent = root,
	})
	self.Body = body

	local sidebar = new("Frame", {
		BackgroundColor3 = theme.SurfaceSunken,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 174, 1, 0),
		Parent = body,
	})
	paint(self, sidebar, "BackgroundColor3", "SurfaceSunken")
	self.Sidebar = sidebar

	new("Frame", {
		AnchorPoint = Vector2.new(1, 0),
		BackgroundColor3 = theme.BorderSoft,
		BorderSizePixel = 0,
		Position = UDim2.new(1, 0, 0, 0),
		Size = UDim2.new(0, 1, 1, 0),
		Parent = sidebar,
	})

	local tabList = new("ScrollingFrame", {
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		CanvasSize = UDim2.fromOffset(0, 0),
		Position = UDim2.fromOffset(10, 12),
		ScrollBarImageTransparency = 0.5,
		ScrollBarThickness = 3,
		Size = UDim2.new(1, -20, 1, -24),
		Parent = sidebar,
	})
	addList(tabList, 7, false)
	self.TabList = tabList

	local content = new("Frame", {
		BackgroundColor3 = theme.Background,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(174, 0),
		Size = UDim2.new(1, -174, 1, 0),
		Parent = body,
	})
	paint(self, content, "BackgroundColor3", "Background")
	self.Content = content

	local toastHost = new("Frame", {
		AnchorPoint = Vector2.new(1, 0),
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -24, 0, 24),
		Size = UDim2.fromOffset(310, 360),
		ZIndex = 50,
		Parent = gui,
	})
	addList(toastHost, 8, false)
	self.ToastHost = toastHost

	makeDraggable(self, header, root)
	if config.ToggleKey then
		bind(self, UserInputService.InputBegan, function(input, gameProcessed)
			if not gameProcessed and input.KeyCode == config.ToggleKey then
				self:Toggle()
			end
		end)
	end

	gui.Parent = parent
	return self
end

function Ironvale.CreateWindow(config)
	return Ironvale.new(config)
end

function Window:SetTheme(themeConfig)
	self._theme = resolveTheme(themeConfig)
	for _, entry in ipairs(self._paints) do
		local instance, property, key = entry[1], entry[2], entry[3]
		if instance and instance.Parent then
			instance[property] = self._theme[key]
		end
	end
	for _, tab in ipairs(self._tabs) do
		self:_syncTab(tab)
	end
	return self
end

function Window:_syncTab(tab)
	local theme = self._theme
	local active = tab == self._selectedTab
	tab.Page.Visible = active
	tab.Indicator.Visible = active
	tab.Button.BackgroundTransparency = active and 0 or 1
	tab.Button.BackgroundColor3 = active and theme.AccentSoft or theme.SurfaceSunken
	tab.TitleLabel.TextColor3 = active and theme.Text or theme.TextMuted
	setIconColor(tab.Icon, active and theme.Accent or theme.TextMuted)
end

function Window:SelectTab(target)
	local selected = target
	if typeof(target) ~= "table" then
		for _, tab in ipairs(self._tabs) do
			if tab.Name == target or tab.Title == target then
				selected = tab
				break
			end
		end
	end
	if not selected then
		return self
	end
	self._selectedTab = selected
	for _, tab in ipairs(self._tabs) do
		self:_syncTab(tab)
	end
	return self
end

function Window:Tab(config)
	config = config or {}
	if typeof(config) == "string" then
		config = { Name = config }
	end
	local tabName = tostring(config.Name or config.Title or ("Tab " .. tostring(#self._tabs + 1)))
	local theme = self._theme

	local button = new("TextButton", {
		AutoButtonColor = false,
		BackgroundColor3 = theme.SurfaceSunken,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 38),
		Text = "",
		Parent = self.TabList,
	})
	addCorner(button, 5)

	local indicator = new("Frame", {
		BackgroundColor3 = theme.Accent,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(0, 9),
		Size = UDim2.fromOffset(3, 20),
		Visible = false,
		Parent = button,
	})
	addCorner(indicator, 3)

	local icon = createIcon(self, config.Icon or "circle", 18, theme.TextMuted)
	icon.Position = UDim2.fromOffset(13, 10)
	icon.Parent = button

	local title = label({
		Font = theme.FontMedium,
		Position = UDim2.fromOffset(40, 0),
		Size = UDim2.new(1, -46, 1, 0),
		Text = tabName,
		TextColor3 = theme.TextMuted,
		TextSize = 12,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = button,
	})

	local page = new("ScrollingFrame", {
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		CanvasSize = UDim2.fromOffset(0, 0),
		Position = UDim2.fromOffset(18, 18),
		ScrollBarImageTransparency = 0.45,
		ScrollBarThickness = 4,
		Size = UDim2.new(1, -36, 1, -36),
		Visible = false,
		Parent = self.Content,
	})
	addList(page, 12, false)

	local tab = setmetatable({
		Window = self,
		Name = tabName,
		Title = tabName,
		Button = button,
		Indicator = indicator,
		Icon = icon,
		TitleLabel = title,
		Page = page,
		_sections = {},
	}, Tab)

	bind(self, button.MouseEnter, function()
		if self._selectedTab ~= tab then
			tween(button, { BackgroundTransparency = 0, BackgroundColor3 = self._theme.SurfaceHigh })
		end
	end)
	bind(self, button.MouseLeave, function()
		if self._selectedTab ~= tab then
			tween(button, { BackgroundTransparency = 1, BackgroundColor3 = self._theme.SurfaceSunken })
		end
	end)
	bind(self, button.MouseButton1Click, function()
		self:SelectTab(tab)
	end)

	table.insert(self._tabs, tab)
	if config.Default == true or not self._selectedTab then
		self:SelectTab(tab)
	else
		self:_syncTab(tab)
	end
	return tab
end

function Window:SetMinimized(value)
	self._minimized = value == true
	self.Body.Visible = not self._minimized
	local targetSize = self._minimized and UDim2.new(self._fullSize.X.Scale, self._fullSize.X.Offset, 0, 74) or self._fullSize
	tween(self.Root, { Size = targetSize }, 0.18)
	tween(self.Shadow, { Size = UDim2.new(targetSize.X.Scale, targetSize.X.Offset + 8, targetSize.Y.Scale, targetSize.Y.Offset + 10) }, 0.18)
	return self
end

function Window:Show()
	self._visible = true
	self.Gui.Enabled = true
	return self
end

function Window:Hide()
	self._visible = false
	self.Gui.Enabled = false
	return self
end

function Window:Toggle()
	return self._visible and self:Hide() or self:Show()
end

local function kindColor(theme, kind)
	kind = string.lower(tostring(kind or "info"))
	if kind == "success" then
		return theme.Success, "check"
	elseif kind == "warning" or kind == "warn" then
		return theme.Warning, "alert-triangle"
	elseif kind == "danger" or kind == "error" then
		return theme.Danger, "alert-triangle"
	end
	return theme.Info, "info"
end

function Window:Notify(config)
	config = config or {}
	local theme = self._theme
	local kind = config.Kind or config.Type or "info"
	local accent, defaultIcon = kindColor(theme, kind)
	local bodyText = config.Body or config.Text or ""

	local toast = new("Frame", {
		BackgroundColor3 = theme.Surface,
		BorderSizePixel = 0,
		Size = UDim2.fromOffset(310, 72),
		ZIndex = 51,
		Parent = self.ToastHost,
	})
	addCorner(toast, 6)
	addStroke(toast, theme.BorderSoft, 0.15, 1)

	new("Frame", {
		BackgroundColor3 = accent,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 3, 1, 0),
		ZIndex = 52,
		Parent = toast,
	})

	local icon = createIcon(self, config.Icon or defaultIcon, 18, accent)
	icon.Position = UDim2.fromOffset(16, 16)
	icon.ZIndex = 52
	icon.Parent = toast

	label({
		Font = theme.FontBold,
		Position = UDim2.fromOffset(46, 13),
		Size = UDim2.new(1, -58, 0, 18),
		Text = config.Title or "Ironvale",
		TextColor3 = theme.Text,
		TextSize = 13,
		TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 52,
		Parent = toast,
	})

	label({
		Font = theme.Font,
		Position = UDim2.fromOffset(46, 34),
		Size = UDim2.new(1, -58, 0, 28),
		Text = bodyText,
		TextColor3 = theme.TextMuted,
		TextSize = 12,
		TextWrapped = true,
		TextYAlignment = Enum.TextYAlignment.Top,
		ZIndex = 52,
		Parent = toast,
	})

	toast.BackgroundTransparency = 1
	tween(toast, { BackgroundTransparency = 0 }, 0.16)
	task.delay(config.Duration or 3, function()
		if toast and toast.Parent then
			tween(toast, { BackgroundTransparency = 1 }, 0.16)
			task.delay(0.18, function()
				if toast then
					toast:Destroy()
				end
			end)
		end
	end)
	return toast
end

function Window:Dialog(config)
	config = config or {}
	local theme = self._theme
	local overlay = new("Frame", {
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.42,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 80,
		Parent = self.Gui,
	})

	local panel = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = theme.Surface,
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(390, 190),
		ZIndex = 81,
		Parent = overlay,
	})
	addCorner(panel, 7)
	addStroke(panel, theme.Border, 0.08, 1)
	addPadding(panel, 18, 16, 18, 16)

	local icon = createIcon(self, config.Icon or "alert-triangle", 22, theme.Warning)
	icon.Position = UDim2.fromOffset(0, 0)
	icon.ZIndex = 82
	icon.Parent = panel

	label({
		Font = theme.FontBold,
		Position = UDim2.fromOffset(34, 0),
		Size = UDim2.new(1, -34, 0, 24),
		Text = config.Title or "Confirm action",
		TextColor3 = theme.Text,
		TextSize = 15,
		ZIndex = 82,
		Parent = panel,
	})

	label({
		Font = theme.Font,
		Position = UDim2.fromOffset(0, 42),
		Size = UDim2.new(1, 0, 0, 68),
		Text = config.Body or config.Text or "This action needs confirmation.",
		TextColor3 = theme.TextMuted,
		TextSize = 12,
		TextWrapped = true,
		TextYAlignment = Enum.TextYAlignment.Top,
		ZIndex = 82,
		Parent = panel,
	})

	local actions = new("Frame", {
		AnchorPoint = Vector2.new(1, 1),
		BackgroundTransparency = 1,
		Position = UDim2.new(1, 0, 1, 0),
		Size = UDim2.fromOffset(190, 34),
		ZIndex = 82,
		Parent = panel,
	})
	addList(actions, 8, true)

	local function close()
		if overlay then
			overlay:Destroy()
		end
	end

	local secondary = new("TextButton", {
		AutoButtonColor = false,
		BackgroundColor3 = theme.SurfaceHigh,
		BorderSizePixel = 0,
		Font = theme.FontBold,
		Size = UDim2.fromOffset(88, 34),
		Text = config.SecondaryText or "Cancel",
		TextColor3 = theme.TextMuted,
		TextSize = 12,
		ZIndex = 83,
		Parent = actions,
	})
	addCorner(secondary, 5)
	addStroke(secondary, theme.BorderSoft, 0.2, 1)
	bind(self, secondary.MouseButton1Click, function()
		close()
		safeCall(config.OnCancel)
	end)

	local primary = new("TextButton", {
		AutoButtonColor = false,
		BackgroundColor3 = theme.AccentSoft,
		BorderSizePixel = 0,
		Font = theme.FontBold,
		Size = UDim2.fromOffset(94, 34),
		Text = config.PrimaryText or "Confirm",
		TextColor3 = theme.Accent,
		TextSize = 12,
		ZIndex = 83,
		Parent = actions,
	})
	addCorner(primary, 5)
	addStroke(primary, theme.AccentMuted, 0.2, 1)
	bind(self, primary.MouseButton1Click, function()
		close()
		safeCall(config.OnConfirm)
	end)

	return overlay
end

function Window:Destroy()
	for _, connection in ipairs(self._connections) do
		if connection.Connected then
			connection:Disconnect()
		end
	end
	if self.Gui then
		self.Gui:Destroy()
	end
end

function Tab:Section(titleOrConfig, config)
	local sectionConfig
	if typeof(titleOrConfig) == "table" then
		sectionConfig = titleOrConfig
	else
		sectionConfig = config or {}
		sectionConfig.Title = tostring(titleOrConfig or sectionConfig.Title or "Section")
	end
	sectionConfig.Title = sectionConfig.Title or sectionConfig.Name or "Section"

	local theme = self.Window._theme
	local frame = new("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = theme.Surface,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
		Parent = self.Page,
	})
	addCorner(frame, 6)
	addStroke(frame, theme.BorderSoft, 0.18, 1)
	addPadding(frame, 14, 12, 14, 14)

	local icon = createIcon(self.Window, sectionConfig.Icon or "panel-left", 18, theme.Accent)
	icon.Position = UDim2.fromOffset(0, 0)
	icon.Parent = frame

	label({
		Font = theme.FontBold,
		Position = UDim2.fromOffset(28, 0),
		Size = UDim2.new(1, -28, 0, 20),
		Text = sectionConfig.Title,
		TextColor3 = theme.Text,
		TextSize = 14,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = frame,
	})

	local description = label({
		Font = theme.Font,
		Position = UDim2.fromOffset(28, 22),
		Size = UDim2.new(1, -28, 0, 18),
		Text = sectionConfig.Description or "",
		TextColor3 = theme.TextMuted,
		TextSize = 12,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = frame,
	})
	description.Visible = description.Text ~= ""

	local body = new("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(0, description.Visible and 50 or 32),
		Size = UDim2.new(1, 0, 0, 0),
		Parent = frame,
	})
	addList(body, 8, false)

	local section = setmetatable({
		Window = self.Window,
		Tab = self,
		Frame = frame,
		Body = body,
	}, Section)
	table.insert(self._sections, section)
	return section
end

function Tab:_section()
	if not self._defaultSection then
		self._defaultSection = self:Section({ Title = self.TitleLabel.Text or self.Name })
	end
	return self._defaultSection
end

function Tab:Button(config) return self:_section():Button(config) end
function Tab:Toggle(config) return self:_section():Toggle(config) end
function Tab:Slider(config) return self:_section():Slider(config) end
function Tab:Dropdown(config) return self:_section():Dropdown(config) end
function Tab:Input(config) return self:_section():Input(config) end
function Tab:Keybind(config) return self:_section():Keybind(config) end
function Tab:ColorSwatch(config) return self:_section():ColorSwatch(config) end
function Tab:Progress(config) return self:_section():Progress(config) end
function Tab:Paragraph(config) return self:_section():Paragraph(config) end
function Tab:CodeBlock(config) return self:_section():CodeBlock(config) end
function Tab:Divider() return self:_section():Divider() end

function Section:_row(config, defaultIcon, height, clickable)
	config = config or {}
	local theme = self.Window._theme
	local className = clickable and "TextButton" or "Frame"
	local props = {
		BackgroundColor3 = theme.SurfaceHigh,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, height or 56),
		Parent = self.Body,
	}
	if clickable then
		props.AutoButtonColor = false
		props.Text = ""
	end
	local row = new(className, props)
	addCorner(row, 5)
	addStroke(row, theme.BorderSoft, 0.25, 1)

	local icon = createIcon(self.Window, config.Icon or defaultIcon, 18, config.IconColor or theme.TextMuted)
	icon.Position = UDim2.fromOffset(14, 13)
	icon.Parent = row

	label({
		Font = theme.FontBold,
		Position = UDim2.fromOffset(44, 9),
		Size = UDim2.new(1, -166, 0, 18),
		Text = config.Title or config.Name or "Control",
		TextColor3 = theme.Text,
		TextSize = 13,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = row,
	})

	label({
		Font = theme.Font,
		Position = UDim2.fromOffset(44, 29),
		Size = UDim2.new(1, -166, 0, 17),
		Text = config.Description or config.Caption or "",
		TextColor3 = theme.TextMuted,
		TextSize = 12,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = row,
	})

	local right = new("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -12, 0.5, 0),
		Size = UDim2.fromOffset(118, 36),
		Parent = row,
	})

	if clickable then
		bind(self.Window, row.MouseEnter, function()
			tween(row, { BackgroundColor3 = self.Window._theme.SurfaceRaised })
		end)
		bind(self.Window, row.MouseLeave, function()
			tween(row, { BackgroundColor3 = self.Window._theme.SurfaceHigh })
		end)
	end
	return row, right
end

function Section:Button(config)
	config = config or {}
	local theme = self.Window._theme
	local row, right = self:_row(config, "mouse-pointer-click", 56, true)
	local actionText = config.ActionText ~= nil and tostring(config.ActionText) or nil
	local actionWidth = actionText and math.clamp((string.len(actionText) * 7) + 24, 54, 98) or 34
	local action = new("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundColor3 = theme.AccentSoft,
		BorderSizePixel = 0,
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(actionWidth, 28),
		Parent = right,
	})
	addCorner(action, 5)
	addStroke(action, theme.AccentMuted, 0.2, 1)
	if actionText then
		label({
			Font = theme.FontBold,
			Size = UDim2.fromScale(1, 1),
			Text = actionText,
			TextColor3 = theme.Accent,
			TextSize = 12,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextXAlignment = Enum.TextXAlignment.Center,
			Parent = action,
		})
	else
		local icon = createIcon(self.Window, config.ActionIcon or "chevron-right", 16, theme.Accent)
		icon.AnchorPoint = Vector2.new(0.5, 0.5)
		icon.Position = UDim2.fromScale(0.5, 0.5)
		icon.Parent = action
	end
	bind(self.Window, row.MouseButton1Click, function()
		safeCall(config.Callback)
	end)
	return { Instance = row, Fire = function() safeCall(config.Callback) end }
end

function Section:Toggle(config)
	config = config or {}
	local theme = self.Window._theme
	local value = config.Default == true
	local row, right = self:_row(config, "shield", 56, true)
	local track = new("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundColor3 = value and theme.Accent or theme.SurfaceSunken,
		BorderSizePixel = 0,
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(48, 24),
		Parent = right,
	})
	addCorner(track, 12)
	local knob = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = value and theme.Background or theme.TextMuted,
		BorderSizePixel = 0,
		Position = value and UDim2.new(1, -12, 0.5, 0) or UDim2.new(0, 12, 0.5, 0),
		Size = UDim2.fromOffset(16, 16),
		Parent = track,
	})
	addCorner(knob, 999)

	local api = {}
	local function set(nextValue, silent)
		value = nextValue == true
		tween(track, { BackgroundColor3 = value and self.Window._theme.Accent or self.Window._theme.SurfaceSunken })
		tween(knob, {
			BackgroundColor3 = value and self.Window._theme.Background or self.Window._theme.TextMuted,
			Position = value and UDim2.new(1, -12, 0.5, 0) or UDim2.new(0, 12, 0.5, 0),
		})
		if not silent then
			safeCall(config.Callback, value)
		end
	end
	bind(self.Window, row.MouseButton1Click, function()
		set(not value)
	end)
	api.Instance = row
	api.Set = set
	api.Get = function() return value end
	return api
end

function Section:Slider(config)
	config = config or {}
	local theme = self.Window._theme
	local min = config.Min or 0
	local max = config.Max or 100
	local decimals = config.Decimals or 0
	local step = config.Step
	local value = math.clamp(config.Default or min, min, max)
	local row = self:_row(config, "sliders-horizontal", 78, false)

	local valueLabel = label({
		AnchorPoint = Vector2.new(1, 0),
		Font = theme.FontBold,
		Position = UDim2.new(1, -14, 0, 9),
		Size = UDim2.fromOffset(92, 18),
		Text = "",
		TextColor3 = theme.Accent,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Right,
		Parent = row,
	})

	local track = new("Frame", {
		AnchorPoint = Vector2.new(0, 1),
		BackgroundColor3 = theme.SurfaceSunken,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 44, 1, -15),
		Size = UDim2.new(1, -60, 0, 7),
		Parent = row,
	})
	addCorner(track, 5)
	local fill = new("Frame", {
		BackgroundColor3 = theme.Accent,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 0, 1, 0),
		Parent = track,
	})
	addCorner(fill, 5)
	local knob = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = theme.Text,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.fromOffset(15, 15),
		Parent = track,
	})
	addCorner(knob, 999)

	local function snap(nextValue)
		if typeof(step) == "number" and step > 0 then
			nextValue = min + math.floor(((nextValue - min) / step) + 0.5) * step
		end
		if decimals > 0 then
			local mult = 10 ^ decimals
			nextValue = math.floor(nextValue * mult + 0.5) / mult
		else
			nextValue = math.floor(nextValue + 0.5)
		end
		return math.clamp(nextValue, min, max)
	end

	local function format(nextValue)
		if decimals > 0 then
			return string.format("%." .. tostring(decimals) .. "f", nextValue)
		end
		return tostring(math.floor(nextValue + 0.5))
	end

	local function set(nextValue, silent)
		value = snap(nextValue)
		local alpha = max == min and 0 or (value - min) / (max - min)
		fill.Size = UDim2.new(alpha, 0, 1, 0)
		knob.Position = UDim2.new(alpha, 0, 0.5, 0)
		valueLabel.Text = format(value)
		if not silent then
			safeCall(config.Callback, value)
		end
	end

	local dragging = false
	local function fromX(x)
		local alpha = math.clamp((x - track.AbsolutePosition.X) / math.max(1, track.AbsoluteSize.X), 0, 1)
		set(min + (max - min) * alpha)
	end
	bind(self.Window, track.InputBegan, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			fromX(input.Position.X)
		end
	end)
	bind(self.Window, knob.InputBegan, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
		end
	end)
	bind(self.Window, UserInputService.InputChanged, function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			fromX(input.Position.X)
		end
	end)
	bind(self.Window, UserInputService.InputEnded, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
	set(value, true)
	return { Instance = row, Set = set, Get = function() return value end }
end

function Section:Dropdown(config)
	config = config or {}
	local theme = self.Window._theme
	local options = config.Options or {}
	local value = config.Default or options[1]
	local open = false
	local row, right = self:_row(config, "list-checks", 56, true)

	local selected = label({
		AnchorPoint = Vector2.new(1, 0.5),
		Font = theme.FontBold,
		Position = UDim2.new(1, -24, 0.5, 0),
		Size = UDim2.fromOffset(92, 18),
		Text = tostring(value or "Select"),
		TextColor3 = theme.TextMuted,
		TextSize = 12,
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextXAlignment = Enum.TextXAlignment.Right,
		Parent = right,
	})
	local arrow = createIcon(self.Window, "chevron-down", 15, theme.TextMuted)
	arrow.AnchorPoint = Vector2.new(1, 0.5)
	arrow.Position = UDim2.new(1, 0, 0.5, 0)
	arrow.Parent = right

	local list = new("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = theme.SurfaceHigh,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
		Visible = false,
		Parent = self.Body,
	})
	addCorner(list, 5)
	addStroke(list, theme.BorderSoft, 0.2, 1)
	addPadding(list, 6, 6, 6, 6)
	addList(list, 5, false)

	local buttons = {}
	local function sync()
		for option, button in pairs(buttons) do
			button.BackgroundColor3 = option == value and self.Window._theme.AccentSoft or self.Window._theme.SurfaceHigh
			button.TextColor3 = option == value and self.Window._theme.Text or self.Window._theme.TextMuted
		end
	end
	local function set(nextValue, silent)
		value = nextValue
		selected.Text = tostring(value)
		sync()
		if not silent then
			safeCall(config.Callback, value)
		end
	end
	local function toggle()
		open = not open
		list.Visible = open
		arrow.Rotation = open and 180 or 0
	end
	for _, option in ipairs(options) do
		local item = new("TextButton", {
			AutoButtonColor = false,
			BackgroundColor3 = theme.SurfaceHigh,
			BorderSizePixel = 0,
			Font = theme.FontMedium,
			Size = UDim2.new(1, 0, 0, 30),
			Text = tostring(option),
			TextColor3 = theme.TextMuted,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = list,
		})
		addCorner(item, 4)
		addPadding(item, 10, 0, 10, 0)
		buttons[option] = item
		bind(self.Window, item.MouseButton1Click, function()
			set(option)
			toggle()
		end)
	end
	bind(self.Window, row.MouseButton1Click, toggle)
	set(value, true)
	return { Instance = row, Options = list, Set = set, Get = function() return value end }
end

function Section:Input(config)
	config = config or {}
	local theme = self.Window._theme
	local value = config.Default or ""
	local row, right = self:_row(config, "terminal-square", 58, false)
	right.Size = UDim2.fromOffset(154, 36)
	local box = new("TextBox", {
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundColor3 = theme.SurfaceSunken,
		BorderSizePixel = 0,
		ClearTextOnFocus = false,
		Font = theme.FontMedium,
		PlaceholderColor3 = theme.TextFaint,
		PlaceholderText = config.Placeholder or "Type...",
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(154, 32),
		Text = tostring(value),
		TextColor3 = theme.Text,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = right,
	})
	addCorner(box, 5)
	addStroke(box, theme.BorderSoft, 0.2, 1)
	addPadding(box, 10, 0, 10, 0)
	bind(self.Window, box.FocusLost, function(enterPressed)
		value = box.Text
		if config.FireOnFocusLost == true or enterPressed or config.SubmitOnEnter == false then
			safeCall(config.Callback, value)
		end
	end)
	return {
		Instance = row,
		TextBox = box,
		Set = function(nextValue, silent)
			value = tostring(nextValue)
			box.Text = value
			if not silent then
				safeCall(config.Callback, value)
			end
		end,
		Get = function() return value end,
	}
end

function Section:Keybind(config)
	config = config or {}
	local theme = self.Window._theme
	local key = config.Default or Enum.KeyCode.RightControl
	local listening = false
	local row, right = self:_row(config, "key", 56, true)
	local button = new("TextButton", {
		AnchorPoint = Vector2.new(1, 0.5),
		AutoButtonColor = false,
		BackgroundColor3 = theme.SurfaceSunken,
		BorderSizePixel = 0,
		Font = theme.FontBold,
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(94, 30),
		Text = key.Name,
		TextColor3 = theme.Text,
		TextSize = 12,
		Parent = right,
	})
	addCorner(button, 5)
	addStroke(button, theme.BorderSoft, 0.2, 1)
	local function listen()
		listening = true
		button.Text = "Press key"
		button.TextColor3 = self.Window._theme.Accent
	end
	bind(self.Window, row.MouseButton1Click, listen)
	bind(self.Window, button.MouseButton1Click, listen)
	bind(self.Window, UserInputService.InputBegan, function(input, gameProcessed)
		if listening then
			if input.KeyCode ~= Enum.KeyCode.Unknown then
				key = input.KeyCode
				button.Text = key.Name
				button.TextColor3 = self.Window._theme.Text
				listening = false
				safeCall(config.Changed, key)
			end
		elseif not gameProcessed and input.KeyCode == key then
			safeCall(config.Callback, key)
		end
	end)
	return {
		Instance = row,
		Set = function(nextKey) key = nextKey button.Text = key.Name end,
		Get = function() return key end,
	}
end

function Section:ColorSwatch(config)
	config = config or {}
	local theme = self.Window._theme
	local colors = config.Colors or { theme.Accent, theme.Success, theme.Warning, theme.Danger, Color3.fromRGB(132, 124, 103), Color3.fromRGB(91, 104, 83) }
	local value = config.Default or colors[1]
	local row, right = self:_row(config, "palette", 62, false)
	right.Size = UDim2.fromOffset(148, 34)
	local holder = new("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundTransparency = 1,
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(148, 28),
		Parent = right,
	})
	addList(holder, 6, true)
	local swatches = {}
	local function sync()
		for color, button in pairs(swatches) do
			local stroke = button:FindFirstChildOfClass("UIStroke")
			if stroke then
				stroke.Color = color == value and self.Window._theme.Text or self.Window._theme.BorderSoft
				stroke.Thickness = color == value and 2 or 1
			end
		end
	end
	local function hex(color)
		return string.format("#%02X%02X%02X", math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255))
	end
	local function set(nextColor, silent)
		value = nextColor
		sync()
		if not silent then
			safeCall(config.Callback, value, hex(value))
		end
	end
	for _, color in ipairs(colors) do
		local swatch = new("TextButton", {
			AutoButtonColor = false,
			BackgroundColor3 = color,
			BorderSizePixel = 0,
			Size = UDim2.fromOffset(18, 28),
			Text = "",
			Parent = holder,
		})
		addCorner(swatch, 4)
		addStroke(swatch, theme.BorderSoft, 0.15, 1)
		swatches[color] = swatch
		bind(self.Window, swatch.MouseButton1Click, function()
			set(color)
		end)
	end
	set(value, true)
	return { Instance = row, Set = set, Get = function() return value end }
end

function Section:Progress(config)
	config = config or {}
	local theme = self.Window._theme
	local value = math.clamp(config.Default or 0, 0, 1)
	local row = self:_row(config, "activity", 70, false)
	local percent = label({
		AnchorPoint = Vector2.new(1, 0),
		Font = theme.FontBold,
		Position = UDim2.new(1, -14, 0, 9),
		Size = UDim2.fromOffset(80, 18),
		Text = "",
		TextColor3 = theme.Accent,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Right,
		Parent = row,
	})
	local track = new("Frame", {
		AnchorPoint = Vector2.new(0, 1),
		BackgroundColor3 = theme.SurfaceSunken,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 44, 1, -15),
		Size = UDim2.new(1, -60, 0, 7),
		Parent = row,
	})
	addCorner(track, 5)
	local fill = new("Frame", {
		BackgroundColor3 = config.Color or theme.Success,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 0, 1, 0),
		Parent = track,
	})
	addCorner(fill, 5)
	local function set(nextValue)
		value = math.clamp(nextValue, 0, 1)
		fill.Size = UDim2.new(value, 0, 1, 0)
		percent.Text = tostring(math.floor(value * 100 + 0.5)) .. "%"
	end
	set(value)
	return { Instance = row, Set = set, Get = function() return value end }
end

function Section:Paragraph(config)
	config = config or {}
	local theme = self.Window._theme
	local bodyText = config.Body or config.Text or ""
	local block = new("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = theme.SurfaceHigh,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
		Parent = self.Body,
	})
	addCorner(block, 5)
	addStroke(block, theme.BorderSoft, 0.3, 1)
	addPadding(block, 12, 10, 12, 10)
	label({
		Font = theme.FontBold,
		Size = UDim2.new(1, 0, 0, 18),
		Text = config.Title or "Note",
		TextColor3 = theme.Text,
		TextSize = 13,
		Parent = block,
	})
	local body = label({
		AutomaticSize = Enum.AutomaticSize.Y,
		Font = theme.Font,
		Position = UDim2.fromOffset(0, 24),
		Size = UDim2.new(1, 0, 0, 0),
		Text = bodyText,
		TextColor3 = theme.TextMuted,
		TextSize = 12,
		TextWrapped = true,
		TextYAlignment = Enum.TextYAlignment.Top,
		Parent = block,
	})
	return { Instance = block, Set = function(nextBody) body.Text = nextBody end }
end

function Section:CodeBlock(config)
	config = config or {}
	local theme = self.Window._theme
	local height = config.Height or 140
	local block = new("Frame", {
		BackgroundColor3 = theme.SurfaceHigh,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, height),
		Parent = self.Body,
	})
	addCorner(block, 5)
	addStroke(block, theme.BorderSoft, 0.2, 1)
	addPadding(block, 12, 10, 12, 10)
	label({
		Font = theme.FontBold,
		Size = UDim2.new(1, 0, 0, 18),
		Text = config.Title or "Code",
		TextColor3 = theme.Text,
		TextSize = 13,
		Parent = block,
	})
	local surface = new("Frame", {
		BackgroundColor3 = theme.SurfaceSunken,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(0, 28),
		Size = UDim2.new(1, 0, 1, -28),
		Parent = block,
	})
	addCorner(surface, 4)
	addStroke(surface, theme.BorderSoft, 0.35, 1)
	addPadding(surface, 10, 8, 10, 8)
	local text = label({
		Font = Enum.Font.Code,
		Size = UDim2.fromScale(1, 1),
		Text = config.Code or "",
		TextColor3 = theme.TextMuted,
		TextSize = 12,
		TextWrapped = false,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		Parent = surface,
	})
	return { Instance = block, Set = function(nextCode) text.Text = nextCode end }
end

function Section:Divider()
	local divider = new("Frame", {
		BackgroundColor3 = self.Window._theme.BorderSoft,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 1),
		Parent = self.Body,
	})
	return divider
end

return Ironvale
