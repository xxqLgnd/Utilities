local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-- Удаляем старые версии GUI
for i, v in pairs(CoreGui:GetChildren()) do
    if v.Name == "TradeValueChecker" then
        v:Destroy()
    end
end

-- Создаем основной ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TradeValueChecker"
ScreenGui.Parent = CoreGui

-- Создаем главный фрейм
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.4, 0, 0.4, 0)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0.5
MainFrame.Name = "Main"
MainFrame.Parent = ScreenGui

-- Стиль для главного фрейма
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 0, 0)
UIStroke.Thickness = 4
UIStroke.Parent = MainFrame

local cornerOverlay = Instance.new("UICorner")
cornerOverlay.CornerRadius = UDim.new(0.2, 0)
cornerOverlay.Parent = MainFrame

-- Создаем ScrollingFrame посередине MainFrame
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(0.9, 0, 0.8, 0)
ScrollingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
ScrollingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ScrollingFrame.BackgroundTransparency = 0.7
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.ScrollBarThickness = 8
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollingFrame.Name = "ButtonContainer"
ScrollingFrame.Parent = MainFrame

-- Стиль для ScrollingFrame
local ScrollUIStroke = Instance.new("UIStroke")
ScrollUIStroke.Color = Color3.fromRGB(0, 0, 0)
ScrollUIStroke.Thickness = 2
ScrollUIStroke.Parent = ScrollingFrame

local ScrollCorner = Instance.new("UICorner")
ScrollCorner.CornerRadius = UDim.new(0.1, 0)
ScrollCorner.Parent = ScrollingFrame

-- Добавляем UIListLayout для автоматического расположения кнопок
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.Parent = ScrollingFrame

-- Добавляем UIPadding для отступов внутри ScrollingFrame
local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 10)
UIPadding.PaddingBottom = UDim.new(0, 10)
UIPadding.PaddingLeft = UDim.new(0, 10)
UIPadding.PaddingRight = UDim.new(0, 10)
UIPadding.Parent = ScrollingFrame

print("TradeValueChecker GUI создан успешно!")