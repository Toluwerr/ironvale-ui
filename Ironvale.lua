--!strict
-- Ironvale UI
-- A compact Luau interface library for Roblox client tools and panels.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Ironvale = {}
Ironvale.Version = "1.0.0"

type Dictionary = { [string]: any }

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
	Surface = Color3.fromRGB(23, 25, 21),
	SurfaceHigh = Color3.fromRGB(30, 33, 28),
	SurfaceRaised = Color3.fromRGB(38, 41, 35),
	SurfaceSunken = Color3.fromRGB(18, 20, 17),

	Border = Color3.fromRGB(66, 70, 58),
	BorderSoft = Color3.fromRGB(46, 50, 42),

	Text = Color3.fromRGB(239, 240, 232),
	TextMuted = Color3.fromRGB(166, 171, 158),
	TextFaint = Color3.fromRGB(113, 119, 106),

	Accent = Color3.fromRGB(178, 132, 70),
	AccentSoft = Color3.fromRGB(76, 59, 37),
	AccentMuted = Color3.fromRGB(132, 108, 70),

	Success = Color3.fromRGB(137, 157, 94),
	Warning = Color3.fromRGB(203, 148, 72),
	Danger = Color3.fromRGB(188, 82, 75),
	Info = Color3.fromRGB(128, 137, 108),

	Shadow = Color3.fromRGB(0, 0, 0),
}

local LUCIDE_PRIMITIVES = {
	["activity"] = {
		{ "line", 2, 12, 6, 12 }, { "line", 6, 12, 9, 4 }, { "line", 9, 4, 14, 20 },
		{ "line", 14, 20, 17, 12 }, { "line", 17, 12, 22, 12 },
	},
	["alert-triangle"] = {
		{ "line", 12, 3, 22, 20 }, { "line", 22, 20, 2, 20 }, { "line", 2, 20, 12, 3 },
		{ "line", 12, 9, 12, 14 }, { "dot", 12, 17, 1.35 },
	},
	["bell"] = {
		{ "line", 5, 18, 19, 18 }, { "line", 6, 18, 7, 10 }, { "line", 7, 10, 10, 6 },
		{ "line", 10, 6, 14, 6 }, { "line", 14, 6, 17, 10 }, { "line", 17, 10, 18, 18 },
		{ "line", 10, 21, 14, 21 }, { "line", 11, 4, 13, 4 },
	},
	["check"] = {
		{ "line", 5, 12, 10, 17 }, { "line", 10, 17, 20, 7 },
	},
	["chevron-down"] = {
		{ "line", 6, 9, 12, 15 }, { "line", 12, 15, 18, 9 },
	},
	["chevron-right"] = {
		{ "line", 9, 6, 15, 12 }, { "line", 15, 12, 9, 18 },
	},
	["circle"] = {
		{ "circle", 12, 12, 8 },
	},
	["copy"] = {
		{ "rect", 8, 8, 11, 11, 2 }, { "rect", 5, 5, 11, 11, 2 },
	},
	["database"] = {
		{ "ellipse", 12, 5, 7, 3 }, { "line", 5, 5, 5, 18 }, { "line", 19, 5, 19, 18 },
		{ "ellipse", 12, 18, 7, 3 }, { "line", 5, 11, 19, 11 },
	},
	["download"] = {
		{ "line", 12, 4, 12, 15 }, { "line", 8, 11, 12, 15 }, { "line", 16, 11, 12, 15 },
		{ "line", 5, 20, 19, 20 },
	},
	["eye"] = {
		{ "line", 2, 12, 6, 8 }, { "line", 6, 8, 12, 6 }, { "line", 12, 6, 18, 8 },
		{ "line", 18, 8, 22, 12 }, { "line", 22, 12, 18, 16 }, { "line", 18, 16, 12, 18 },
		{ "line", 12, 18, 6, 16 }, { "line", 6, 16, 2, 12 }, { "circle", 12, 12, 2.5 },
	},
	["home"] = {
		{ "line", 3, 11, 12, 4 }, { "line", 12, 4, 21, 11 }, { "line", 5, 10, 5, 20 },
		{ "line", 19, 10, 19, 20 }, { "line", 5, 20, 10, 20 }, { "line", 14, 20, 19, 20 },
		{ "line", 10, 20, 10, 14 }, { "line", 14, 20, 14, 14 }, { "line", 10, 14, 14, 14 },
	},
	["info"] = {
		{ "circle", 12, 12, 9 }, { "line", 12, 11, 12, 17 }, { "dot", 12, 7.5, 1.2 },
	},
	["key"] = {
		{ "circle", 7.5, 12, 3.5 }, { "line", 11, 12, 21, 12 }, { "line", 17, 12, 17, 15 },
		{ "line", 20, 12, 20, 15 },
	},
	["layout-dashboard"] = {
		{ "rect", 3, 3, 7, 8, 2 }, { "rect", 14, 3, 7, 5, 2 },
		{ "rect", 14, 12, 7, 9, 2 }, { "rect", 3, 15, 7, 6, 2 },
	},
	["list-checks"] = {
		{ "line", 4, 7, 6, 9 }, { "line", 6, 9, 9, 5 }, { "line", 12, 7, 21, 7 },
		{ "line", 4, 14, 6, 16 }, { "line", 6, 16, 9, 12 }, { "line", 12, 14, 21, 14 },
		{ "line", 12, 20, 21, 20 },
	},
	["lock"] = {
		{ "rect", 5, 10, 14, 10, 2 }, { "line", 8, 10, 8, 7 }, { "line", 16, 10, 16, 7 },
		{ "line", 8, 7, 10, 5 }, { "line", 16, 7, 14, 5 }, { "line", 10, 5, 14, 5 },
		{ "line", 12, 14, 12, 17 },
	},
	["minus"] = {
		{ "line", 5, 12, 19, 12 },
	},
	["mouse-pointer-click"] = {
		{ "line", 5, 3, 17, 15 }, { "line", 5, 3, 8, 20 }, { "line", 8, 20, 12, 15 },
		{ "line", 12, 15, 16, 21 }, { "line", 16, 21, 19, 19 },
		{ "line", 18, 4, 20, 2 }, { "line", 20, 8, 23, 8 }, { "line", 16, 2, 16, 0 },
	},
	["palette"] = {
		{ "circle", 12, 12, 9 }, { "dot", 8, 9, 1.2 }, { "dot", 12, 7, 1.2 },
		{ "dot", 16, 9, 1.2 }, { "dot", 9, 14, 1.2 }, { "line", 14, 17, 17, 17 },
	},
	["panel-left"] = {
		{ "rect", 3, 4, 18, 16, 2 }, { "line", 9, 4, 9, 20 },
	},
	["plus"] = {
		{ "line", 12, 5, 12, 19 }, { "line", 5, 12, 19, 12 },
	},
	["rocket"] = {
		{ "line", 5, 19, 10, 17 }, { "line", 7, 14, 10, 17 }, { "line", 10, 17, 17, 10 },
		{ "line", 17, 10, 20, 4 }, { "line", 20, 4, 14, 7 }, { "line", 14, 7, 7, 14 },
		{ "circle", 15.5, 8.5, 1.6 }, { "line", 4, 20, 7, 17 },
	},
	["save"] = {
		{ "rect", 4, 4, 16, 16, 2 }, { "line", 8, 4, 8, 10 }, { "line", 16, 4, 16, 10 },
		{ "line", 8, 10, 16, 10 }, { "rect", 8, 14, 8, 6, 1 },
	},
	["search"] = {
		{ "circle", 10.5, 10.5, 6.5 }, { "line", 15, 15, 21, 21 },
	},
	["settings"] = {
		{ "circle", 12, 12, 3.5 }, { "line", 12, 2, 12, 5 }, { "line", 12, 19, 12, 22 },
		{ "line", 2, 12, 5, 12 }, { "line", 19, 12, 22, 12 }, { "line", 5, 5, 7, 7 },
		{ "line", 17, 17, 19, 19 }, { "line", 19, 5, 17, 7 }, { "line", 7, 17, 5, 19 },
	},
	["shield"] = {
		{ "line", 12, 3, 20, 7 }, { "line", 20, 7, 18, 16 }, { "line", 18, 16, 12, 21 },
		{ "line", 12, 21, 6, 16 }, { "line", 6, 16, 4, 7 }, { "line", 4, 7, 12, 3 },
	},
	["sliders-horizontal"] = {
		{ "line", 4, 7, 10, 7 }, { "line", 14, 7, 20, 7 }, { "circle", 12, 7, 2 },
		{ "line", 4, 12, 6, 12 }, { "line", 10, 12, 20, 12 }, { "circle", 8, 12, 2 },
		{ "line", 4, 17, 15, 17 }, { "line", 19, 17, 20, 17 }, { "circle", 17, 17, 2 },
	},
	["sparkles"] = {
		{ "line", 12, 3, 12, 8 }, { "line", 12, 16, 12, 21 }, { "line", 3, 12, 8, 12 },
		{ "line", 16, 12, 21, 12 }, { "line", 8, 8, 16, 16 }, { "line", 16, 8, 8, 16 },
	},
	["terminal-square"] = {
		{ "rect", 3, 4, 18, 16, 2 }, { "line", 7, 9, 10, 12 }, { "line", 10, 12, 7, 15 },
		{ "line", 13, 15, 17, 15 },
	},
	["trash-2"] = {
		{ "line", 5, 7, 19, 7 }, { "line", 9, 7, 9, 4 }, { "line", 15, 7, 15, 4 },
		{ "line", 9, 4, 15, 4 }, { "line", 7, 7, 8, 20 }, { "line", 17, 7, 16, 20 },
		{ "line", 8, 20, 16, 20 }, { "line", 11, 10, 11, 17 }, { "line", 13, 10, 13, 17 },
	},
	["upload"] = {
		{ "line", 12, 20, 12, 9 }, { "line", 8, 13, 12, 9 }, { "line", 16, 13, 12, 9 },
		{ "line", 5, 4, 19, 4 },
	},
	["wrench"] = {
		{ "line", 14, 5, 19, 10 }, { "line", 19, 10, 10, 19 }, { "line", 10, 19, 5, 14 },
		{ "line", 5, 14, 14, 5 }, { "circle", 7.5, 16.5, 1.3 },
	},
	["x"] = {
		{ "line", 6, 6, 18, 18 }, { "line", 18, 6, 6, 18 },
	},
}

local function copyDictionary(source: Dictionary): Dictionary
	local result = {}
	for key, value in pairs(source) do
		result[key] = value
	end
	return result
end

local function mergeTheme(overrides: Dictionary?): Dictionary
	local theme = copyDictionary(DEFAULT_THEME)
	if overrides then
		for key, value in pairs(overrides) do
			theme[key] = value
		end
	end
	return theme
end

local function create(className: string, properties: Dictionary?, children: { Instance }?): Instance
	local instance = Instance.new(className)
	if properties then
		for key, value in pairs(properties) do
			(instance :: any)[key] = value
		end
	end
	if children then
		for _, child in ipairs(children) do
			child.Parent = instance
		end
	end
	return instance
end

local function addCorner(parent: Instance, radius: number): UICorner
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = parent
	return corner
end

local function addStroke(parent: Instance, color: Color3, transparency: number?, thickness: number?): UIStroke
	local stroke = Instance.new("UIStroke")
	stroke.Color = color
	stroke.Transparency = transparency or 0
	stroke.Thickness = thickness or 1
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent = parent
	return stroke
end

local function addPadding(parent: Instance, left: number, top: number?, right: number?, bottom: number?): UIPadding
	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, left)
	padding.PaddingTop = UDim.new(0, top or left)
	padding.PaddingRight = UDim.new(0, right or left)
	padding.PaddingBottom = UDim.new(0, bottom or top or left)
	padding.Parent = parent
	return padding
end

local function addList(parent: Instance, padding: number, horizontal: boolean?): UIListLayout
	local list = Instance.new("UIListLayout")
	list.FillDirection = if horizontal then Enum.FillDirection.Horizontal else Enum.FillDirection.Vertical
	list.SortOrder = Enum.SortOrder.LayoutOrder
	list.Padding = UDim.new(0, padding)
	list.Parent = parent
	return list
end

local function addOffset(size: UDim2, x: number, y: number): UDim2
	return UDim2.new(size.X.Scale, size.X.Offset + x, size.Y.Scale, size.Y.Offset + y)
end

local function inputPosition(input: InputObject): Vector2
	return Vector2.new(input.Position.X, input.Position.Y)
end

local function bind(window: any, signal: RBXScriptSignal, callback: (...any) -> ()): RBXScriptConnection
	local connection = signal:Connect(callback)
	table.insert(window._connections, connection)
	return connection
end

local function tween(instance: Instance, info: TweenInfo, goals: Dictionary)
	local animation = TweenService:Create(instance, info, goals)
	animation:Play()
	return animation
end

local function safeCall(callback: any, ...)
	if typeof(callback) ~= "function" then
		return
	end

	local ok, err = pcall(callback, ...)
	if not ok then
		warn("[Ironvale] callback failed:", err)
	end
end

local function colorToHex(color: Color3): string
	return string.format("#%02X%02X%02X", math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255))
end

local function createLine(parent: Instance, size: number, color: Color3, x1: number, y1: number, x2: number, y2: number, thickness: number)
	local scale = size / 24
	local sx = x1 * scale
	local sy = y1 * scale
	local ex = x2 * scale
	local ey = y2 * scale
	local dx = ex - sx
	local dy = ey - sy
	local length = math.sqrt(dx * dx + dy * dy)

	local line = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = color,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset((sx + ex) / 2, (sy + ey) / 2),
		Rotation = math.deg(math.atan2(dy, dx)),
		Size = UDim2.fromOffset(length, thickness),
	}, nil)
	addCorner(line, math.max(1, thickness))
	line.Parent = parent
end

local function createRect(parent: Instance, size: number, color: Color3, x: number, y: number, width: number, height: number, radius: number, thickness: number)
	local scale = size / 24
	local rect = create("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(x * scale, y * scale),
		Size = UDim2.fromOffset(width * scale, height * scale),
	}, nil)
	addCorner(rect, math.max(1, radius * scale))
	addStroke(rect, color, 0, thickness)
	rect.Parent = parent
end

local function createCircle(parent: Instance, size: number, color: Color3, x: number, y: number, radius: number, thickness: number, filled: boolean?)
	local scale = size / 24
	local diameter = radius * 2 * scale
	local circle = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = color,
		BackgroundTransparency = if filled then 0 else 1,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(x * scale, y * scale),
		Size = UDim2.fromOffset(diameter, diameter),
	}, nil)
	addCorner(circle, 999)
	if not filled then
		addStroke(circle, color, 0, thickness)
	end
	circle.Parent = parent
end

local function createEllipse(parent: Instance, size: number, color: Color3, x: number, y: number, radiusX: number, radiusY: number, thickness: number)
	local scale = size / 24
	local ellipse = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(x * scale, y * scale),
		Size = UDim2.fromOffset(radiusX * 2 * scale, radiusY * 2 * scale),
	}, nil)
	addCorner(ellipse, 999)
	addStroke(ellipse, color, 0, thickness)
	ellipse.Parent = parent
end

local function createIcon(name: string?, size: number, color: Color3, iconPack: Dictionary?): Frame
	local holder = create("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = false,
		Size = UDim2.fromOffset(size, size),
	}, nil) :: Frame

	if name == nil or name == "" then
		return holder
	end

	local asset = if iconPack then iconPack[name] else nil
	if typeof(asset) == "string" then
		local image = create("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Image = asset,
			ImageColor3 = color,
			Position = UDim2.fromScale(0.5, 0.5),
			ScaleType = Enum.ScaleType.Fit,
			Size = UDim2.fromScale(1, 1),
		}, nil)
		image.Parent = holder
		return holder
	end

	local primitives = LUCIDE_PRIMITIVES[name] or LUCIDE_PRIMITIVES.circle
	local thickness = math.max(1.35, math.floor(size / 12))

	for _, primitive in ipairs(primitives) do
		local kind = primitive[1]
		if kind == "line" then
			createLine(holder, size, color, primitive[2], primitive[3], primitive[4], primitive[5], thickness)
		elseif kind == "rect" then
			createRect(holder, size, color, primitive[2], primitive[3], primitive[4], primitive[5], primitive[6] or 1, thickness)
		elseif kind == "circle" then
			createCircle(holder, size, color, primitive[2], primitive[3], primitive[4], thickness, false)
		elseif kind == "dot" then
			createCircle(holder, size, color, primitive[2], primitive[3], primitive[4], thickness, true)
		elseif kind == "ellipse" then
			createEllipse(holder, size, color, primitive[2], primitive[3], primitive[4], primitive[5], thickness)
		end
	end

	return holder
end

function Ironvale.RegisterIcon(name: string, primitives: { { any } })
	LUCIDE_PRIMITIVES[name] = primitives
end

function Ironvale.GetTheme()
	return copyDictionary(DEFAULT_THEME)
end

local function createUtilityButton(window: any, iconName: string, parent: Instance, onClick: () -> ())
	local theme = window._theme
	local button = create("TextButton", {
		AutoButtonColor = false,
		BackgroundColor3 = theme.SurfaceHigh,
		BorderSizePixel = 0,
		Size = UDim2.fromOffset(30, 30),
		Text = "",
	}, nil) :: TextButton
	addCorner(button, 5)
	addStroke(button, theme.BorderSoft, 0.25, 1)

	local icon = createIcon(iconName, 16, theme.TextMuted, window._iconPack)
	icon.AnchorPoint = Vector2.new(0.5, 0.5)
	icon.Position = UDim2.fromScale(0.5, 0.5)
	icon.Parent = button

	bind(window, button.MouseEnter, function()
		tween(button, TweenInfo.new(0.12), { BackgroundColor3 = theme.SurfaceRaised })
	end)
	bind(window, button.MouseLeave, function()
		tween(button, TweenInfo.new(0.12), { BackgroundColor3 = theme.SurfaceHigh })
	end)
	bind(window, button.MouseButton1Click, onClick)

	button.Parent = parent
	return button
end

local function createLabel(properties: Dictionary): TextLabel
	local label = create("TextLabel", properties, nil) :: TextLabel
	label.BackgroundTransparency = 1
	label.BorderSizePixel = 0
	label.TextXAlignment = properties.TextXAlignment or Enum.TextXAlignment.Left
	label.TextYAlignment = properties.TextYAlignment or Enum.TextYAlignment.Center
	return label
end

local function makeDraggable(window: any, handle: GuiObject, root: GuiObject)
	local dragging = false
	local dragStart = Vector2.zero
	local rootStart = UDim2.new()

	bind(window, handle.InputBegan, function(input: InputObject)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = inputPosition(input)
			rootStart = root.Position
		end
	end)

	bind(window, handle.InputEnded, function(input: InputObject)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	bind(window, UserInputService.InputChanged, function(input: InputObject)
		if not dragging then
			return
		end
		if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		local delta = inputPosition(input) - dragStart
		root.Position = UDim2.new(
			rootStart.X.Scale,
			rootStart.X.Offset + delta.X,
			rootStart.Y.Scale,
			rootStart.Y.Offset + delta.Y
		)
	end)
end

function Ironvale.new(config: Dictionary?)
	config = config or {}
	local player = Players.LocalPlayer
	assert(player, "Ironvale must be required from a LocalScript.")

	local theme = mergeTheme(config.Theme)
	local parent = config.Parent or player:WaitForChild("PlayerGui")

	local self = setmetatable({
		_theme = theme,
		_iconPack = config.IconPack or {},
		_connections = {},
		_tabs = {},
		_selectedTab = nil,
		_visible = true,
		_minimized = false,
	}, Window)

	local gui = create("ScreenGui", {
		DisplayOrder = config.DisplayOrder or 20,
		IgnoreGuiInset = config.IgnoreGuiInset == true,
		Name = config.Name or "Ironvale",
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	}, nil) :: ScreenGui
	self.Gui = gui

	local size = config.Size or UDim2.fromOffset(700, 500)
	local rootPosition = config.Position or UDim2.fromScale(0.5, 0.5)

	local shadow = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = theme.Shadow,
		BackgroundTransparency = 0.58,
		BorderSizePixel = 0,
		Position = addOffset(rootPosition, 0, 12),
		Size = addOffset(size, 12, 14),
		ZIndex = 0,
	}, nil) :: Frame
	addCorner(shadow, 8)
	shadow.Parent = gui
	self.Shadow = shadow

	local root = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = theme.Background,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Position = rootPosition,
		Size = size,
		ZIndex = 1,
	}, nil) :: Frame
	addCorner(root, 8)
	addStroke(root, theme.Border, 0.1, 1)
	root.Parent = gui
	self.Root = root

	bind(self, root:GetPropertyChangedSignal("Position"), function()
		shadow.Position = addOffset(root.Position, 0, 12)
	end)
	bind(self, root:GetPropertyChangedSignal("Size"), function()
		shadow.Size = addOffset(root.Size, 12, 14)
	end)

	local header = create("Frame", {
		BackgroundColor3 = theme.Surface,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 58),
		ZIndex = 2,
	}, nil) :: Frame
	header.Parent = root
	self.Header = header

	local headerLine = create("Frame", {
		AnchorPoint = Vector2.new(0, 1),
		BackgroundColor3 = theme.BorderSoft,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 1, 0),
		Size = UDim2.new(1, 0, 0, 1),
	}, nil)
	headerLine.Parent = header

	local brand = create("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(16, 10),
		Size = UDim2.new(1, -124, 0, 38),
	}, nil)
	brand.Parent = header

	local brandIconShell = create("Frame", {
		BackgroundColor3 = theme.AccentSoft,
		BorderSizePixel = 0,
		Size = UDim2.fromOffset(36, 36),
	}, nil)
	addCorner(brandIconShell, 6)
	addStroke(brandIconShell, theme.Accent, 0.35, 1)
	brandIconShell.Parent = brand

	local brandIcon = createIcon(config.Icon or "panel-left", 20, theme.Accent, self._iconPack)
	brandIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	brandIcon.Position = UDim2.fromScale(0.5, 0.5)
	brandIcon.Parent = brandIconShell

	local title = createLabel({
		Font = theme.FontBold,
		Position = UDim2.fromOffset(48, 2),
		Size = UDim2.new(1, -48, 0, 18),
		Text = config.Title or "Ironvale",
		TextColor3 = theme.Text,
		TextSize = 15,
		TextTruncate = Enum.TextTruncate.AtEnd,
	})
	title.Parent = brand

	local subtitle = createLabel({
		Font = theme.Font,
		Position = UDim2.fromOffset(48, 20),
		Size = UDim2.new(1, -48, 0, 16),
		Text = config.Subtitle or "Operations panel",
		TextColor3 = theme.TextMuted,
		TextSize = 12,
		TextTruncate = Enum.TextTruncate.AtEnd,
	})
	subtitle.Parent = brand

	local utilities = create("Frame", {
		AnchorPoint = Vector2.new(1, 0),
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -14, 0, 14),
		Size = UDim2.fromOffset(68, 30),
	}, nil)
	addList(utilities, 8, true)
	utilities.Parent = header

	createUtilityButton(self, "minus", utilities, function()
		self:SetMinimized(not self._minimized)
	end)

	createUtilityButton(self, "x", utilities, function()
		self:SetVisible(false)
	end)

	local body = create("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(0, 58),
		Size = UDim2.new(1, 0, 1, -58),
	}, nil) :: Frame
	body.Parent = root
	self.Body = body

	local sidebar = create("Frame", {
		BackgroundColor3 = theme.Surface,
		BorderSizePixel = 0,
		Size = UDim2.new(0, config.SidebarWidth or 180, 1, 0),
	}, nil) :: Frame
	sidebar.Parent = body
	self.Sidebar = sidebar

	local sidebarLine = create("Frame", {
		AnchorPoint = Vector2.new(1, 0),
		BackgroundColor3 = theme.BorderSoft,
		BorderSizePixel = 0,
		Position = UDim2.new(1, 0, 0, 0),
		Size = UDim2.new(0, 1, 1, 0),
	}, nil)
	sidebarLine.Parent = sidebar

	local tabsHolder = create("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(10, 12),
		Size = UDim2.new(1, -20, 1, -24),
	}, nil)
	addList(tabsHolder, 7, false)
	tabsHolder.Parent = sidebar
	self.TabsHolder = tabsHolder

	local contentClip = create("Frame", {
		BackgroundColor3 = theme.SurfaceSunken,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(config.SidebarWidth or 180, 0),
		Size = UDim2.new(1, -(config.SidebarWidth or 180), 1, 0),
	}, nil) :: Frame
	contentClip.Parent = body
	self.ContentClip = contentClip

	local contentHolder = create("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
	}, nil) :: Frame
	contentHolder.Parent = contentClip
	self.ContentHolder = contentHolder

	local toastHolder = create("Frame", {
		AnchorPoint = Vector2.new(1, 0),
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -16, 0, 16),
		Size = UDim2.fromOffset(300, 1),
		ZIndex = 20,
	}, nil) :: Frame
	addList(toastHolder, 8, false)
	toastHolder.Parent = gui
	self.ToastHolder = toastHolder

	makeDraggable(self, header, root)

	local toggleKey = config.ToggleKey or Enum.KeyCode.RightShift
	bind(self, UserInputService.InputBegan, function(input: InputObject, gameProcessed: boolean)
		if gameProcessed then
			return
		end
		if input.KeyCode == toggleKey then
			self:SetVisible(not self._visible)
		end
	end)

	gui.Parent = parent
	return self
end

function Window:SetVisible(visible: boolean)
	self._visible = visible
	self.Root.Visible = visible
	self.Shadow.Visible = visible
	self.ToastHolder.Visible = visible
end

function Window:SetMinimized(minimized: boolean)
	self._minimized = minimized
	self.Body.Visible = not minimized

	local goalSize
	if minimized then
		goalSize = UDim2.new(self.Root.Size.X.Scale, self.Root.Size.X.Offset, 0, 58)
	else
		goalSize = self._restoreSize or UDim2.fromOffset(700, 500)
	end

	if not minimized then
		tween(self.Root, TweenInfo.new(0.16, Enum.EasingStyle.Quad), { Size = goalSize })
	else
		self._restoreSize = self.Root.Size
		tween(self.Root, TweenInfo.new(0.16, Enum.EasingStyle.Quad), { Size = goalSize })
	end
end

function Window:Destroy()
	for _, connection in ipairs(self._connections) do
		if connection.Connected then
			connection:Disconnect()
		end
	end
	table.clear(self._connections)

	if self.Gui then
		self.Gui:Destroy()
	end
end

function Window:SelectTab(tabOrName: any)
	local target = nil
	for _, tab in ipairs(self._tabs) do
		if tab == tabOrName or tab.Name == tabOrName then
			target = tab
			break
		end
	end

	if not target then
		return
	end

	self._selectedTab = target
	for _, tab in ipairs(self._tabs) do
		local active = tab == target
		tab.Page.Visible = active
		tab._accent.Visible = active

		local background = if active then self._theme.SurfaceHigh else self._theme.Surface
		local strokeColor = if active then self._theme.AccentMuted else self._theme.BorderSoft
		local iconColor = if active then self._theme.Accent else self._theme.TextMuted
		local textColor = if active then self._theme.Text else self._theme.TextMuted

		tween(tab.Button, TweenInfo.new(0.12), { BackgroundColor3 = background })
		tab._stroke.Color = strokeColor
		tab._iconColor.Value = iconColor
		tab._title.TextColor3 = textColor
		for _, child in ipairs(tab._icon:GetChildren()) do
			if child:IsA("Frame") then
				child.BackgroundColor3 = iconColor
				local stroke = child:FindFirstChildOfClass("UIStroke")
				if stroke then
					stroke.Color = iconColor
				end
			elseif child:IsA("ImageLabel") then
				child.ImageColor3 = iconColor
			end
		end
	end
end

function Window:Tab(config: Dictionary)
	assert(config and config.Name, "Window:Tab requires a Name.")

	local theme = self._theme
	local button = create("TextButton", {
		AutoButtonColor = false,
		BackgroundColor3 = theme.Surface,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 42),
		Text = "",
	}, nil) :: TextButton
	addCorner(button, 5)
	local stroke = addStroke(button, theme.BorderSoft, 0.35, 1)

	local accent = create("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundColor3 = theme.Accent,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.fromOffset(3, 20),
		Visible = false,
	}, nil) :: Frame
	addCorner(accent, 3)
	accent.Parent = button

	local iconColor = Instance.new("Color3Value")
	iconColor.Value = theme.TextMuted
	iconColor.Parent = button

	local icon = createIcon(config.Icon or "circle", 18, theme.TextMuted, self._iconPack)
	icon.Position = UDim2.fromOffset(13, 12)
	icon.Parent = button

	local title = createLabel({
		Font = theme.FontMedium,
		Position = UDim2.fromOffset(42, 0),
		Size = UDim2.new(1, -50, 1, 0),
		Text = config.Name,
		TextColor3 = theme.TextMuted,
		TextSize = 13,
		TextTruncate = Enum.TextTruncate.AtEnd,
	})
	title.Parent = button
	button.Parent = self.TabsHolder

	local page = create("ScrollingFrame", {
		Active = true,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		CanvasSize = UDim2.new(),
		ScrollBarImageColor3 = theme.Border,
		ScrollBarThickness = 4,
		Size = UDim2.fromScale(1, 1),
		Visible = false,
	}, nil) :: ScrollingFrame
	addPadding(page, 16, 16, 16, 16)
	addList(page, 12, false)
	page.Parent = self.ContentHolder

	local tab = setmetatable({
		Window = self,
		Name = config.Name,
		Button = button,
		Page = page,
		Sections = {},
		_defaultSection = nil,
		_accent = accent,
		_stroke = stroke,
		_icon = icon,
		_iconColor = iconColor,
		_title = title,
	}, Tab)

	table.insert(self._tabs, tab)

	bind(self, button.MouseEnter, function()
		if self._selectedTab ~= tab then
			tween(button, TweenInfo.new(0.12), { BackgroundColor3 = theme.SurfaceHigh })
		end
	end)
	bind(self, button.MouseLeave, function()
		if self._selectedTab ~= tab then
			tween(button, TweenInfo.new(0.12), { BackgroundColor3 = theme.Surface })
		end
	end)
	bind(self, button.MouseButton1Click, function()
		self:SelectTab(tab)
	end)

	if #self._tabs == 1 or config.Default == true then
		self:SelectTab(tab)
	end

	return tab
end

function Window:Notify(config: Dictionary)
	config = config or {}
	local theme = self._theme
	local toast = create("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = theme.Surface,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Size = UDim2.new(1, 0, 0, 0),
		ZIndex = 21,
	}, nil) :: Frame
	addCorner(toast, 6)
	addStroke(toast, theme.Border, 0.1, 1)
	addPadding(toast, 12, 11, 12, 11)

	local iconColor = theme.Accent
	if config.Kind == "success" then
		iconColor = theme.Success
	elseif config.Kind == "warning" then
		iconColor = theme.Warning
	elseif config.Kind == "danger" then
		iconColor = theme.Danger
	end

	local icon = createIcon(config.Icon or (config.Kind == "danger" and "alert-triangle" or "info"), 18, iconColor, self._iconPack)
	icon.Position = UDim2.fromOffset(0, 2)
	icon.ZIndex = 22
	icon.Parent = toast

	local title = createLabel({
		Font = theme.FontBold,
		Position = UDim2.fromOffset(28, 0),
		Size = UDim2.new(1, -28, 0, 17),
		Text = config.Title or "Notice",
		TextColor3 = theme.Text,
		TextSize = 13,
		ZIndex = 22,
	})
	title.Parent = toast

	local body = createLabel({
		Font = theme.Font,
		Position = UDim2.fromOffset(28, 20),
		Size = UDim2.new(1, -28, 0, 34),
		Text = config.Body or "",
		TextColor3 = theme.TextMuted,
		TextSize = 12,
		TextWrapped = true,
		TextYAlignment = Enum.TextYAlignment.Top,
		ZIndex = 22,
	})
	body.Parent = toast

	toast.Parent = self.ToastHolder
	toast.Position = UDim2.fromOffset(18, 0)
	toast.BackgroundTransparency = 1
	tween(toast, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {
		BackgroundTransparency = 0,
		Position = UDim2.fromOffset(0, 0),
	})

	task.delay(config.Duration or 3.5, function()
		if not toast.Parent then
			return
		end
		local animation = tween(toast, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(18, 0),
		})
		animation.Completed:Wait()
		if toast.Parent then
			toast:Destroy()
		end
	end)
end

function Window:Dialog(config: Dictionary)
	config = config or {}
	local theme = self._theme
	local overlay = create("Frame", {
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.35,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 30,
	}, nil)
	overlay.Parent = self.Gui

	local panel = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = theme.Surface,
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(380, 180),
		ZIndex = 31,
	}, nil) :: Frame
	addCorner(panel, 7)
	addStroke(panel, theme.Border, 0.05, 1)
	addPadding(panel, 18, 16, 18, 16)
	panel.Parent = overlay

	local icon = createIcon(config.Icon or "alert-triangle", 22, config.IconColor or theme.Warning, self._iconPack)
	icon.Position = UDim2.fromOffset(0, 2)
	icon.ZIndex = 32
	icon.Parent = panel

	local title = createLabel({
		Font = theme.FontBold,
		Position = UDim2.fromOffset(34, 0),
		Size = UDim2.new(1, -34, 0, 22),
		Text = config.Title or "Confirm action",
		TextColor3 = theme.Text,
		TextSize = 15,
		ZIndex = 32,
	})
	title.Parent = panel

	local body = createLabel({
		Font = theme.Font,
		Position = UDim2.fromOffset(0, 42),
		Size = UDim2.new(1, 0, 0, 68),
		Text = config.Body or "This action needs confirmation.",
		TextColor3 = theme.TextMuted,
		TextSize = 13,
		TextWrapped = true,
		TextYAlignment = Enum.TextYAlignment.Top,
		ZIndex = 32,
	})
	body.Parent = panel

	local actions = create("Frame", {
		AnchorPoint = Vector2.new(1, 1),
		BackgroundTransparency = 1,
		Position = UDim2.new(1, 0, 1, 0),
		Size = UDim2.fromOffset(220, 34),
		ZIndex = 32,
	}, nil)
	addList(actions, 8, true)
	actions.Parent = panel

	local function makeDialogButton(text: string, active: boolean, callback: any)
		local button = create("TextButton", {
			AutoButtonColor = false,
			BackgroundColor3 = if active then theme.Accent else theme.SurfaceHigh,
			BorderSizePixel = 0,
			Font = theme.FontBold,
			Size = UDim2.fromOffset(104, 34),
			Text = text,
			TextColor3 = if active then theme.Background else theme.Text,
			TextSize = 12,
			ZIndex = 33,
		}, nil) :: TextButton
		addCorner(button, 5)
		addStroke(button, if active then theme.Accent else theme.BorderSoft, 0.15, 1)
		bind(self, button.MouseButton1Click, function()
			overlay:Destroy()
			safeCall(callback)
		end)
		button.Parent = actions
	end

	makeDialogButton(config.SecondaryText or "Cancel", false, config.OnCancel)
	makeDialogButton(config.PrimaryText or "Confirm", true, config.OnConfirm)

	return overlay
end

function Tab:Section(title: string, config: Dictionary?)
	config = config or {}
	local theme = self.Window._theme

	local container = create("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = theme.Surface,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
	}, nil) :: Frame
	addCorner(container, 6)
	addStroke(container, theme.BorderSoft, 0.05, 1)
	addPadding(container, 12, 12, 12, 12)
	container.Parent = self.Page

	local header = create("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, if config.Description then 40 else 24),
	}, nil)
	header.Parent = container

	local sectionIcon = createIcon(config.Icon or "list-checks", 18, theme.Accent, self.Window._iconPack)
	sectionIcon.Position = UDim2.fromOffset(0, 2)
	sectionIcon.Parent = header

	local titleLabel = createLabel({
		Font = theme.FontBold,
		Position = UDim2.fromOffset(28, 0),
		Size = UDim2.new(1, -28, 0, 20),
		Text = title,
		TextColor3 = theme.Text,
		TextSize = 14,
	})
	titleLabel.Parent = header

	if config.Description then
		local description = createLabel({
			Font = theme.Font,
			Position = UDim2.fromOffset(28, 20),
			Size = UDim2.new(1, -28, 0, 17),
			Text = config.Description,
			TextColor3 = theme.TextMuted,
			TextSize = 12,
			TextTruncate = Enum.TextTruncate.AtEnd,
		})
		description.Parent = header
	end

	local body = create("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
	}, nil)
	addList(body, 8, false)
	body.Parent = container

	local section = setmetatable({
		Window = self.Window,
		Tab = self,
		Container = container,
		Body = body,
	}, Section)
	table.insert(self.Sections, section)
	return section
end

function Tab:_section()
	if not self._defaultSection then
		self._defaultSection = self:Section("Controls", {
			Icon = "sliders-horizontal",
			Description = "Quick controls and runtime options.",
		})
	end
	return self._defaultSection
end

function Tab:Button(config: Dictionary) return self:_section():Button(config) end
function Tab:Toggle(config: Dictionary) return self:_section():Toggle(config) end
function Tab:Slider(config: Dictionary) return self:_section():Slider(config) end
function Tab:Dropdown(config: Dictionary) return self:_section():Dropdown(config) end
function Tab:Input(config: Dictionary) return self:_section():Input(config) end
function Tab:Keybind(config: Dictionary) return self:_section():Keybind(config) end
function Tab:ColorSwatch(config: Dictionary) return self:_section():ColorSwatch(config) end
function Tab:Progress(config: Dictionary) return self:_section():Progress(config) end
function Tab:Paragraph(config: Dictionary) return self:_section():Paragraph(config) end
function Tab:Divider() return self:_section():Divider() end

function Section:_controlRow(config: Dictionary, defaultIcon: string, height: number?, clickable: boolean?)
	local theme = self.Window._theme
	local className = if clickable then "TextButton" else "Frame"
	local rowProperties: Dictionary = {
		BackgroundColor3 = theme.SurfaceHigh,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, height or 58),
	}
	if clickable then
		rowProperties.AutoButtonColor = false
		rowProperties.Text = ""
	end

	local row = create(className, rowProperties, nil) :: GuiObject
	addCorner(row, 5)
	addStroke(row, theme.BorderSoft, 0.25, 1)
	row.Parent = self.Body

	local icon = createIcon(config.Icon or defaultIcon, 18, config.IconColor or theme.TextMuted, self.Window._iconPack)
	icon.Position = UDim2.fromOffset(14, 13)
	icon.Parent = row

	local title = createLabel({
		Font = theme.FontBold,
		Position = UDim2.fromOffset(44, 10),
		Size = UDim2.new(1, -164, 0, 17),
		Text = config.Title or config.Name or "Control",
		TextColor3 = theme.Text,
		TextSize = 13,
		TextTruncate = Enum.TextTruncate.AtEnd,
	})
	title.Parent = row

	local descriptionText = config.Description or config.Caption or ""
	local description = createLabel({
		Font = theme.Font,
		Position = UDim2.fromOffset(44, 29),
		Size = UDim2.new(1, -164, 0, 17),
		Text = descriptionText,
		TextColor3 = theme.TextMuted,
		TextSize = 12,
		TextTruncate = Enum.TextTruncate.AtEnd,
	})
	description.Parent = row

	local right = create("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -12, 0.5, 0),
		Size = UDim2.fromOffset(104, 36),
	}, nil) :: Frame
	right.Parent = row

	if clickable then
		bind(self.Window, (row :: TextButton).MouseEnter, function()
			tween(row, TweenInfo.new(0.12), { BackgroundColor3 = theme.SurfaceRaised })
		end)
		bind(self.Window, (row :: TextButton).MouseLeave, function()
			tween(row, TweenInfo.new(0.12), { BackgroundColor3 = theme.SurfaceHigh })
		end)
	end

	return row, right, title, description
end

function Section:Button(config: Dictionary)
	config = config or {}
	local theme = self.Window._theme
	local row, right = self:_controlRow(config, "mouse-pointer-click", 56, true)

	local action = create("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundColor3 = theme.AccentSoft,
		BorderSizePixel = 0,
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(34, 28),
	}, nil)
	addCorner(action, 5)
	addStroke(action, theme.AccentMuted, 0.25, 1)
	action.Parent = right

	local icon = createIcon(config.ActionIcon or "chevron-right", 16, theme.Accent, self.Window._iconPack)
	icon.AnchorPoint = Vector2.new(0.5, 0.5)
	icon.Position = UDim2.fromScale(0.5, 0.5)
	icon.Parent = action

	bind(self.Window, (row :: TextButton).MouseButton1Click, function()
		safeCall(config.Callback)
	end)

	return {
		Instance = row,
		Fire = function()
			safeCall(config.Callback)
		end,
	}
end

function Section:Toggle(config: Dictionary)
	config = config or {}
	local theme = self.Window._theme
	local value = config.Default == true
	local row, right = self:_controlRow(config, "shield", 56, true)

	local track = create("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundColor3 = if value then theme.Accent else theme.SurfaceSunken,
		BorderSizePixel = 0,
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(48, 24),
	}, nil) :: Frame
	addCorner(track, 12)
	addStroke(track, if value then theme.AccentMuted else theme.Border, 0.15, 1)
	track.Parent = right

	local knob = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = if value then theme.Background else theme.TextMuted,
		BorderSizePixel = 0,
		Position = if value then UDim2.new(1, -12, 0.5, 0) else UDim2.new(0, 12, 0.5, 0),
		Size = UDim2.fromOffset(16, 16),
	}, nil) :: Frame
	addCorner(knob, 999)
	knob.Parent = track

	local api = {}
	local function set(nextValue: boolean, silent: boolean?)
		value = nextValue
		tween(track, TweenInfo.new(0.14), {
			BackgroundColor3 = if value then theme.Accent else theme.SurfaceSunken,
		})
		tween(knob, TweenInfo.new(0.14, Enum.EasingStyle.Quad), {
			BackgroundColor3 = if value then theme.Background else theme.TextMuted,
			Position = if value then UDim2.new(1, -12, 0.5, 0) else UDim2.new(0, 12, 0.5, 0),
		})
		if not silent then
			safeCall(config.Callback, value)
		end
	end

	bind(self.Window, (row :: TextButton).MouseButton1Click, function()
		set(not value, false)
	end)

	api.Instance = row
	api.Set = set
	api.Get = function()
		return value
	end
	return api
end

function Section:Slider(config: Dictionary)
	config = config or {}
	local theme = self.Window._theme
	local min = config.Min or 0
	local max = config.Max or 100
	local decimals = config.Decimals or 0
	local value = math.clamp(config.Default or min, min, max)

	local row, _, title = self:_controlRow(config, "sliders-horizontal", 78, false)
	title.Size = UDim2.new(1, -118, 0, 17)

	local valueLabel = createLabel({
		AnchorPoint = Vector2.new(1, 0),
		Font = theme.FontBold,
		Position = UDim2.new(1, -14, 0, 10),
		Size = UDim2.fromOffset(90, 18),
		Text = "",
		TextColor3 = theme.Accent,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Right,
	})
	valueLabel.Parent = row

	local track = create("Frame", {
		AnchorPoint = Vector2.new(0, 1),
		BackgroundColor3 = theme.SurfaceSunken,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 44, 1, -14),
		Size = UDim2.new(1, -60, 0, 7),
	}, nil) :: Frame
	addCorner(track, 5)
	addStroke(track, theme.BorderSoft, 0.35, 1)
	track.Parent = row

	local fill = create("Frame", {
		BackgroundColor3 = theme.Accent,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 0, 1, 0),
	}, nil) :: Frame
	addCorner(fill, 5)
	fill.Parent = track

	local knob = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = theme.Text,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.fromOffset(15, 15),
	}, nil) :: Frame
	addCorner(knob, 999)
	addStroke(knob, theme.AccentMuted, 0.1, 1)
	knob.Parent = track

	local dragging = false

	local function formatValue(nextValue: number): string
		if decimals > 0 then
			return string.format("%." .. tostring(decimals) .. "f", nextValue)
		end
		return tostring(math.floor(nextValue + 0.5))
	end

	local function set(nextValue: number, silent: boolean?)
		value = math.clamp(nextValue, min, max)
		local alpha = if max == min then 0 else (value - min) / (max - min)
		fill.Size = UDim2.new(alpha, 0, 1, 0)
		knob.Position = UDim2.new(alpha, 0, 0.5, 0)
		valueLabel.Text = formatValue(value)
		if not silent then
			safeCall(config.Callback, value)
		end
	end

	local function setFromX(x: number)
		local alpha = math.clamp((x - track.AbsolutePosition.X) / math.max(1, track.AbsoluteSize.X), 0, 1)
		local nextValue = min + ((max - min) * alpha)
		if decimals <= 0 then
			nextValue = math.floor(nextValue + 0.5)
		else
			local multiplier = 10 ^ decimals
			nextValue = math.floor(nextValue * multiplier + 0.5) / multiplier
		end
		set(nextValue, false)
	end

	bind(self.Window, track.InputBegan, function(input: InputObject)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			setFromX(input.Position.X)
		end
	end)
	bind(self.Window, knob.InputBegan, function(input: InputObject)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
		end
	end)
	bind(self.Window, UserInputService.InputChanged, function(input: InputObject)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			setFromX(input.Position.X)
		end
	end)
	bind(self.Window, UserInputService.InputEnded, function(input: InputObject)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	set(value, true)

	return {
		Instance = row,
		Set = set,
		Get = function()
			return value
		end,
	}
end

function Section:Dropdown(config: Dictionary)
	config = config or {}
	local theme = self.Window._theme
	local options = config.Options or {}
	local value = config.Default or options[1]
	local open = false

	local row, right = self:_controlRow(config, "list-checks", 56, true)

	local selected = createLabel({
		AnchorPoint = Vector2.new(1, 0.5),
		Font = theme.FontBold,
		Position = UDim2.new(1, -28, 0.5, 0),
		Size = UDim2.fromOffset(84, 18),
		Text = tostring(value or "Select"),
		TextColor3 = theme.TextMuted,
		TextSize = 12,
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextXAlignment = Enum.TextXAlignment.Right,
	})
	selected.Parent = right

	local arrow = createIcon("chevron-down", 16, theme.TextMuted, self.Window._iconPack)
	arrow.AnchorPoint = Vector2.new(1, 0.5)
	arrow.Position = UDim2.new(1, 0, 0.5, 0)
	arrow.Parent = right

	local optionsFrame = create("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = theme.SurfaceHigh,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
		Visible = false,
	}, nil) :: Frame
	addCorner(optionsFrame, 5)
	addStroke(optionsFrame, theme.BorderSoft, 0.25, 1)
	addPadding(optionsFrame, 6, 6, 6, 6)
	addList(optionsFrame, 5, false)
	optionsFrame.Parent = self.Body

	local optionButtons = {}
	local api = {}

	local function syncOptions()
		for optionValue, button in pairs(optionButtons) do
			local active = optionValue == value
			button.BackgroundColor3 = if active then theme.AccentSoft else theme.SurfaceHigh
			button.TextColor3 = if active then theme.Text else theme.TextMuted
		end
	end

	local function set(nextValue: any, silent: boolean?)
		value = nextValue
		selected.Text = tostring(value)
		syncOptions()
		if not silent then
			safeCall(config.Callback, value)
		end
	end

	local function toggleOpen()
		open = not open
		optionsFrame.Visible = open
		arrow.Rotation = if open then 180 else 0
	end

	for _, option in ipairs(options) do
		local optionButton = create("TextButton", {
			AutoButtonColor = false,
			BackgroundColor3 = theme.SurfaceHigh,
			BorderSizePixel = 0,
			Font = theme.FontMedium,
			Size = UDim2.new(1, 0, 0, 30),
			Text = tostring(option),
			TextColor3 = theme.TextMuted,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left,
		}, nil) :: TextButton
		addCorner(optionButton, 4)
		addPadding(optionButton, 10, 0, 10, 0)
		optionButton.Parent = optionsFrame
		optionButtons[option] = optionButton

		bind(self.Window, optionButton.MouseButton1Click, function()
			set(option, false)
			toggleOpen()
		end)
	end

	bind(self.Window, (row :: TextButton).MouseButton1Click, toggleOpen)
	set(value, true)

	api.Instance = row
	api.Options = optionsFrame
	api.Set = set
	api.Get = function()
		return value
	end
	return api
end

function Section:Input(config: Dictionary)
	config = config or {}
	local theme = self.Window._theme
	local value = config.Default or ""
	local row, right = self:_controlRow(config, "terminal-square", 58, false)
	right.Size = UDim2.fromOffset(150, 36)

	local box = create("TextBox", {
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundColor3 = theme.SurfaceSunken,
		BorderSizePixel = 0,
		ClearTextOnFocus = false,
		Font = theme.FontMedium,
		PlaceholderColor3 = theme.TextFaint,
		PlaceholderText = config.Placeholder or "Type...",
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(150, 32),
		Text = tostring(value),
		TextColor3 = theme.Text,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, nil) :: TextBox
	addCorner(box, 5)
	addStroke(box, theme.BorderSoft, 0.2, 1)
	addPadding(box, 10, 0, 10, 0)
	box.Parent = right

	bind(self.Window, box.FocusLost, function(enterPressed: boolean)
		value = box.Text
		if config.SubmitOnEnter == false or enterPressed or config.FireOnFocusLost == true then
			safeCall(config.Callback, value)
		end
	end)

	return {
		Instance = row,
		TextBox = box,
		Set = function(nextValue: string, silent: boolean?)
			value = tostring(nextValue)
			box.Text = value
			if not silent then
				safeCall(config.Callback, value)
			end
		end,
		Get = function()
			return value
		end,
	}
end

function Section:Keybind(config: Dictionary)
	config = config or {}
	local theme = self.Window._theme
	local key = config.Default or Enum.KeyCode.RightControl
	local listening = false
	local row, right = self:_controlRow(config, "key", 56, true)

	local keyButton = create("TextButton", {
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
	}, nil) :: TextButton
	addCorner(keyButton, 5)
	addStroke(keyButton, theme.BorderSoft, 0.2, 1)
	keyButton.Parent = right

	local function beginListening()
		listening = true
		keyButton.Text = "Press key"
		keyButton.TextColor3 = theme.Accent
	end

	bind(self.Window, (row :: TextButton).MouseButton1Click, beginListening)
	bind(self.Window, keyButton.MouseButton1Click, beginListening)
	bind(self.Window, UserInputService.InputBegan, function(input: InputObject, gameProcessed: boolean)
		if listening then
			if input.KeyCode ~= Enum.KeyCode.Unknown then
				key = input.KeyCode
				keyButton.Text = key.Name
				keyButton.TextColor3 = theme.Text
				listening = false
				safeCall(config.Changed, key)
			end
			return
		end
		if not gameProcessed and input.KeyCode == key then
			safeCall(config.Callback, key)
		end
	end)

	return {
		Instance = row,
		Set = function(nextKey: Enum.KeyCode)
			key = nextKey
			keyButton.Text = key.Name
		end,
		Get = function()
			return key
		end,
	}
end

function Section:ColorSwatch(config: Dictionary)
	config = config or {}
	local theme = self.Window._theme
	local colors = config.Colors or {
		theme.Accent,
		theme.Success,
		theme.Warning,
		theme.Danger,
		Color3.fromRGB(132, 124, 103),
		Color3.fromRGB(91, 104, 83),
	}
	local value = config.Default or colors[1]
	local row, right = self:_controlRow(config, "palette", 62, false)
	right.Size = UDim2.fromOffset(148, 34)

	local holder = create("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundTransparency = 1,
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(148, 28),
	}, nil)
	addList(holder, 6, true)
	holder.Parent = right

	local swatches = {}
	local api = {}

	local function sync()
		for color, button in pairs(swatches) do
			local stroke = button:FindFirstChildOfClass("UIStroke")
			if stroke then
				stroke.Color = if color == value then theme.Text else theme.BorderSoft
				stroke.Thickness = if color == value then 2 else 1
			end
		end
	end

	local function set(nextColor: Color3, silent: boolean?)
		value = nextColor
		sync()
		if not silent then
			safeCall(config.Callback, value, colorToHex(value))
		end
	end

	for _, color in ipairs(colors) do
		local swatch = create("TextButton", {
			AutoButtonColor = false,
			BackgroundColor3 = color,
			BorderSizePixel = 0,
			Size = UDim2.fromOffset(18, 28),
			Text = "",
		}, nil) :: TextButton
		addCorner(swatch, 4)
		addStroke(swatch, theme.BorderSoft, 0.15, 1)
		swatch.Parent = holder
		swatches[color] = swatch

		bind(self.Window, swatch.MouseButton1Click, function()
			set(color, false)
		end)
	end

	set(value, true)

	api.Instance = row
	api.Set = set
	api.Get = function()
		return value
	end
	return api
end

function Section:Progress(config: Dictionary)
	config = config or {}
	local theme = self.Window._theme
	local value = math.clamp(config.Default or 0, 0, 1)
	local row = self:_controlRow(config, "activity", 70, false)

	local percent = createLabel({
		AnchorPoint = Vector2.new(1, 0),
		Font = theme.FontBold,
		Position = UDim2.new(1, -14, 0, 10),
		Size = UDim2.fromOffset(80, 18),
		Text = "",
		TextColor3 = theme.Accent,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Right,
	})
	percent.Parent = row

	local track = create("Frame", {
		AnchorPoint = Vector2.new(0, 1),
		BackgroundColor3 = theme.SurfaceSunken,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 44, 1, -14),
		Size = UDim2.new(1, -60, 0, 7),
	}, nil) :: Frame
	addCorner(track, 5)
	addStroke(track, theme.BorderSoft, 0.35, 1)
	track.Parent = row

	local fill = create("Frame", {
		BackgroundColor3 = config.Color or theme.Success,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 0, 1, 0),
	}, nil) :: Frame
	addCorner(fill, 5)
	fill.Parent = track

	local function set(nextValue: number)
		value = math.clamp(nextValue, 0, 1)
		fill.Size = UDim2.new(value, 0, 1, 0)
		percent.Text = tostring(math.floor(value * 100 + 0.5)) .. "%"
	end

	set(value)

	return {
		Instance = row,
		Set = set,
		Get = function()
			return value
		end,
	}
end

function Section:Paragraph(config: Dictionary)
	config = config or {}
	local theme = self.Window._theme
	local block = create("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = theme.SurfaceHigh,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
	}, nil) :: Frame
	addCorner(block, 5)
	addStroke(block, theme.BorderSoft, 0.35, 1)
	addPadding(block, 12, 10, 12, 10)
	block.Parent = self.Body

	local title = createLabel({
		Font = theme.FontBold,
		Size = UDim2.new(1, 0, 0, 18),
		Text = config.Title or "Note",
		TextColor3 = theme.Text,
		TextSize = 13,
	})
	title.Parent = block

	local body = createLabel({
		AutomaticSize = Enum.AutomaticSize.Y,
		Font = theme.Font,
		Position = UDim2.fromOffset(0, 24),
		Size = UDim2.new(1, 0, 0, 0),
		Text = config.Body or "",
		TextColor3 = theme.TextMuted,
		TextSize = 12,
		TextWrapped = true,
		TextYAlignment = Enum.TextYAlignment.Top,
	})
	body.Parent = block

	return {
		Instance = block,
		Set = function(nextBody: string)
			body.Text = nextBody
		end,
	}
end

function Section:Divider()
	local theme = self.Window._theme
	local divider = create("Frame", {
		BackgroundColor3 = theme.BorderSoft,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 1),
	}, nil)
	divider.Parent = self.Body
	return divider
end

return Ironvale
