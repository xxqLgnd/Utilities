local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

-- Функция для создания кнопки
local function createButton(parent, text, layoutOrder)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 40)
    Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Button.BackgroundTransparency = 0.2
    Button.BorderSizePixel = 0
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextScaled = true
    Button.Font = Enum.Font.SourceSansBold
    Button.LayoutOrder = layoutOrder
    Button.Parent = parent
    
    -- Стиль кнопки
    local ButtonStroke = Instance.new("UIStroke")
    ButtonStroke.Color = Color3.fromRGB(100, 100, 100)
    ButtonStroke.Thickness = 1
    ButtonStroke.Parent = Button
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0.1, 0)
    ButtonCorner.Parent = Button
    
    -- Анимация при наведении
    local hoverTween = TweenService:Create(Button, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    })
    
    local normalTween = TweenService:Create(Button, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    })
    
    Button.MouseEnter:Connect(function()
        hoverTween:Play()
    end)
    
    Button.MouseLeave:Connect(function()
        normalTween:Play()
    end)
    
    -- Функция нажатия на кнопку
    Button.MouseButton1Click:Connect(function()
        print("Кнопка '" .. text .. "' была нажата!")
        -- Здесь можно добавить свою логику для каждой кнопки
        
        -- Анимация нажатия
        local clickTween = TweenService:Create(Button, TweenInfo.new(0.1), {
            Size = UDim2.new(0.95, 0, 0, 38)
        })
        local returnTween = TweenService:Create(Button, TweenInfo.new(0.1), {
            Size = UDim2.new(1, 0, 0, 40)
        })
        
        clickTween:Play()
        clickTween.Completed:Connect(function()
            returnTween:Play()
        end)
    end)
    
    return Button
end

-- Функция для добавления кнопок в ScrollingFrame
local function addButtons(buttonCount)
    local screenGui = CoreGui:FindFirstChild("TradeValueChecker")
    if not screenGui then
        warn("TradeValueChecker GUI не найден!")
        return
    end
    
    local scrollingFrame = screenGui.Main:FindFirstChild("ButtonContainer")
    if not scrollingFrame then
        warn("ButtonContainer не найден!")
        return
    end
    
    -- Очищаем существующие кнопки
    for _, child in pairs(scrollingFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    -- Добавляем новые кнопки
    for i = 1, buttonCount do
        createButton(scrollingFrame, "Кнопка " .. i, i)
    end
    
    -- Обновляем размер канваса ScrollingFrame
    local totalHeight = buttonCount * 40 + (buttonCount - 1) * 5 + 20 -- высота кнопок + отступы
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
end

-- Пример использования: добавить 10 кнопок
-- Можно изменить число на нужное количество
addButtons(10)

-- Функция для добавления кнопок извне (можно вызывать из других скриптов)
_G.AddButtonsToTradeChecker = addButtons

print("Скрипт управления кнопками загружен! Используйте _G.AddButtonsToTradeChecker(количество) для добавления кнопок.")