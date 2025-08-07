local CoreGui = game:GetService("CoreGui")
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TradeValueChecker"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.4, 0, 0.4, 0)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0.5
MainFrame.Name = "Main"
MainFrame.Parent = ScreenGui

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 0, 0)
UIStroke.Thickness = 4
UIStroke.Parent = MainFrame

local cornerOverlay = Instance.new("UICorner")
cornerOverlay.CornerRadius = UDim.new(0.2, 0)
cornerOverlay.Parent = MainFrame

-- ScrollingFrame в центре MainFrame
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(0.9, 0, 0.8, 0)
ScrollingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
ScrollingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ScrollingFrame.BackgroundTransparency = 0.3
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.ScrollBarThickness = 8
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0) -- Будет изменяться при добавлении кнопок
ScrollingFrame.Name = "ButtonContainer"
ScrollingFrame.Parent = MainFrame

-- Стиль для ScrollingFrame
local ScrollStroke = Instance.new("UIStroke")
ScrollStroke.Color = Color3.fromRGB(0, 0, 0)
ScrollStroke.Thickness = 2
ScrollStroke.Parent = ScrollingFrame

local ScrollCorner = Instance.new("UICorner")
ScrollCorner.CornerRadius = UDim.new(0.1, 0)
ScrollCorner.Parent = ScrollingFrame

-- UIListLayout для автоматического размещения кнопок
local ListLayout = Instance.new("UIListLayout")
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 5)
ListLayout.Parent = ScrollingFrame

-- UIPadding для отступов внутри ScrollingFrame
local Padding = Instance.new("UIPadding")
Padding.PaddingTop = UDim.new(0, 10)
Padding.PaddingBottom = UDim.new(0, 10)
Padding.PaddingLeft = UDim.new(0, 10)
Padding.PaddingRight = UDim.new(0, 10)
Padding.Parent = ScrollingFrame