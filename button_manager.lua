local CoreGui = game:GetService("CoreGui")

-- Функция для создания кнопки с нужным стилем
local function createButton(text, layoutOrder, parent)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.9, 0, 0, 40)
    Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Button.BackgroundTransparency = 0.3
    Button.BorderSizePixel = 0
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextScaled = true
    Button.Font = Enum.Font.GothamBold
    Button.LayoutOrder = layoutOrder
    Button.Name = "Button_" .. layoutOrder
    Button.Parent = parent
    
    -- Стиль для кнопки
    local ButtonStroke = Instance.new("UIStroke")
    ButtonStroke.Color = Color3.fromRGB(100, 100, 100)
    ButtonStroke.Thickness = 1
    ButtonStroke.Parent = Button
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0.1, 0)
    ButtonCorner.Parent = Button
    
    -- Анимация при наведении
    Button.MouseEnter:Connect(function()
        Button:TweenSize(UDim2.new(0.95, 0, 0, 45), "Out", "Quad", 0.2, true)
        Button.BackgroundTransparency = 0.1
        ButtonStroke.Color = Color3.fromRGB(200, 200, 200)
    end)
    
    Button.MouseLeave:Connect(function()
        Button:TweenSize(UDim2.new(0.9, 0, 0, 40), "Out", "Quad", 0.2, true)
        Button.BackgroundTransparency = 0.3
        ButtonStroke.Color = Color3.fromRGB(100, 100, 100)
    end)
    
    -- Обработка нажатия кнопки
    Button.MouseButton1Click:Connect(function()
        print("Нажата кнопка: " .. text)
        -- Здесь можно добавить свою логику для каждой кнопки
        
        -- Анимация нажатия
        Button:TweenSize(UDim2.new(0.85, 0, 0, 35), "Out", "Quad", 0.1, true)
        wait(0.1)
        Button:TweenSize(UDim2.new(0.9, 0, 0, 40), "Out", "Quad", 0.1, true)
    end)
    
    return Button
end

-- Функция для добавления кнопок в ScrollingFrame
local function addButtons(buttonCount, buttonNames)
    -- Ждем пока GUI будет создан
    local ScreenGui = CoreGui:WaitForChild("TradeValueChecker", 5)
    if not ScreenGui then
        warn("TradeValueChecker GUI не найден!")
        return
    end
    
    local MainFrame = ScreenGui:WaitForChild("Main", 5)
    if not MainFrame then
        warn("MainFrame не найден!")
        return
    end
    
    local ScrollingFrame = MainFrame:WaitForChild("ButtonContainer", 5)
    if not ScrollingFrame then
        warn("ScrollingFrame не найден!")
        return
    end
    
    -- Очищаем старые кнопки (если есть)
    for i, child in pairs(ScrollingFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    -- Создаем новые кнопки
    local buttons = {}
    for i = 1, buttonCount do
        local buttonText = buttonNames and buttonNames[i] or ("Кнопка " .. i)
        local button = createButton(buttonText, i, ScrollingFrame)
        table.insert(buttons, button)
    end
    
    -- Обновляем размер содержимого ScrollingFrame
    local totalHeight = buttonCount * 40 + (buttonCount - 1) * 5 + 20 -- высота кнопок + отступы
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
    
    print("Добавлено " .. buttonCount .. " кнопок в ScrollingFrame")
    return buttons
end

-- Пример использования:
-- Добавить 5 кнопок с стандартными названиями
-- addButtons(5)

-- Добавить кнопки с кастомными названиями
local customNames = {
    "Проверить стоимость",
    "Добавить предмет",
    "Удалить предмет", 
    "Сохранить данные",
    "Загрузить данные",
    "Настройки",
    "Помощь"
}
addButtons(7, customNames)

-- Экспортируем функцию для использования в других скриптах
_G.AddButtonsToTradeChecker = addButtons