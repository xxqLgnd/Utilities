-- Скрипт для добавления кнопок в ScrollingFrame
local CoreGui = game:GetService("CoreGui")

-- Функция для создания кнопки
local function createButton(parent, text, layoutOrder)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -20, 0, 40)
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Button.BackgroundTransparency = 0.2
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 16
    Button.Font = Enum.Font.SourceSansBold
    Button.LayoutOrder = layoutOrder
    Button.Parent = parent
    
    -- Стиль для кнопки
    local ButtonStroke = Instance.new("UIStroke")
    ButtonStroke.Color = Color3.fromRGB(100, 100, 100)
    ButtonStroke.Thickness = 1
    ButtonStroke.Parent = Button
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = Button
    
    -- Анимация при наведении
    Button.MouseEnter:Connect(function()
        Button:TweenSize(UDim2.new(1, -15, 0, 45), "Out", "Quad", 0.1, true)
        Button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end)
    
    Button.MouseLeave:Connect(function()
        Button:TweenSize(UDim2.new(1, -20, 0, 40), "Out", "Quad", 0.1, true)
        Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end)
    
    -- Функция нажатия (можно настроить под свои нужды)
    Button.MouseButton1Click:Connect(function()
        print("Нажата кнопка: " .. text)
        -- Здесь можно добавить свою логику
    end)
    
    return Button
end

-- Функция для обновления размера Canvas
local function updateCanvasSize(scrollingFrame)
    local listLayout = scrollingFrame:FindFirstChild("UIListLayout")
    if listLayout then
        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
    end
end

-- Функция для добавления кнопок
local function addButtons(count)
    -- Ищем ScrollingFrame
    local screenGui = CoreGui:FindFirstChild("TradeValueChecker")
    if not screenGui then
        warn("TradeValueChecker не найден!")
        return
    end
    
    local mainFrame = screenGui:FindFirstChild("Main")
    if not mainFrame then
        warn("MainFrame не найден!")
        return
    end
    
    local scrollingFrame = mainFrame:FindFirstChild("ScrollingFrame")
    if not scrollingFrame then
        warn("ScrollingFrame не найден!")
        return
    end
    
    -- Очищаем старые кнопки (опционально)
    for i, v in pairs(scrollingFrame:GetChildren()) do
        if v:IsA("TextButton") then
            v:Destroy()
        end
    end
    
    -- Добавляем новые кнопки
    for i = 1, count do
        createButton(scrollingFrame, "Кнопка " .. i, i)
    end
    
    -- Обновляем размер Canvas после добавления кнопок
    wait(0.1) -- Небольшая задержка для обновления layout
    updateCanvasSize(scrollingFrame)
    
    -- Подключаем автоматическое обновление размера при изменении содержимого
    local listLayout = scrollingFrame:FindFirstChild("UIListLayout")
    if listLayout then
        listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            updateCanvasSize(scrollingFrame)
        end)
    end
end

-- Примеры использования:

-- Добавить 10 кнопок
addButtons(10)

-- Можно вызвать эту функцию с любым количеством кнопок:
-- addButtons(5)   -- Добавит 5 кнопок
-- addButtons(20)  -- Добавит 20 кнопок

-- Экспортируем функцию для использования в других скриптах
return {
    addButtons = addButtons,
    createButton = createButton
}