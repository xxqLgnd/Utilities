-- Modern Roblox GUI Script
-- Создано для красивого и функционального интерфейса

if not game:IsLoaded() then game.Loaded:Wait() end

-- Сервисы
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Переменные
local GUI = {}
local isGUIVisible = true
local dragToggle = nil
local dragSpeed = 0.25
local dragStart = nil
local startPos = nil

-- Создание основного GUI
local function createMainGUI()
    -- Основной ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ModernGUI"
    screenGui.Parent = PlayerGui
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.ResetOnSpawn = false
    
    -- Главный фрейм
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Parent = screenGui
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    mainFrame.BorderSizePixel = 0
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    mainFrame.Size = UDim2.new(0, 400, 0, 300)
    mainFrame.Active = true
    mainFrame.Draggable = true
    
    -- Закругленные углы для главного фрейма
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = mainFrame
    
    -- Градиентная рамка
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0.0, Color3.fromRGB(45, 45, 65)),
        ColorSequenceKeypoint.new(1.0, Color3.fromRGB(25, 25, 35))
    }
    gradient.Rotation = 45
    gradient.Parent = mainFrame
    
    -- Заголовок
    local titleFrame = Instance.new("Frame")
    titleFrame.Name = "TitleFrame"
    titleFrame.Parent = mainFrame
    titleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    titleFrame.BorderSizePixel = 0
    titleFrame.Size = UDim2.new(1, 0, 0, 40)
    titleFrame.Position = UDim2.new(0, 0, 0, 0)
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Parent = titleFrame
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.Size = UDim2.new(1, -60, 1, 0)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = "Modern GUI v1.0"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Кнопка закрытия
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Parent = titleFrame
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
    closeButton.BorderSizePixel = 0
    closeButton.Position = UDim2.new(1, -35, 0, 8)
    closeButton.Size = UDim2.new(0, 24, 0, 24)
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Text = "×"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 16
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 12)
    closeCorner.Parent = closeButton
    
    -- Контентный фрейм
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Parent = mainFrame
    contentFrame.BackgroundTransparency = 1
    contentFrame.Position = UDim2.new(0, 15, 0, 55)
    contentFrame.Size = UDim2.new(1, -30, 1, -70)
    
    -- Кнопка 1: Телепорт к игрокам
    local teleportButton = Instance.new("TextButton")
    teleportButton.Name = "TeleportButton"
    teleportButton.Parent = contentFrame
    teleportButton.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
    teleportButton.BorderSizePixel = 0
    teleportButton.Position = UDim2.new(0, 0, 0, 0)
    teleportButton.Size = UDim2.new(0.48, 0, 0, 35)
    teleportButton.Font = Enum.Font.Gotham
    teleportButton.Text = "🚀 Телепорт"
    teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    teleportButton.TextSize = 14
    
    local teleportCorner = Instance.new("UICorner")
    teleportCorner.CornerRadius = UDim.new(0, 8)
    teleportCorner.Parent = teleportButton
    
    -- Кнопка 2: Скорость
    local speedButton = Instance.new("TextButton")
    speedButton.Name = "SpeedButton"
    speedButton.Parent = contentFrame
    speedButton.BackgroundColor3 = Color3.fromRGB(255, 170, 85)
    speedButton.BorderSizePixel = 0
    speedButton.Position = UDim2.new(0.52, 0, 0, 0)
    speedButton.Size = UDim2.new(0.48, 0, 0, 35)
    speedButton.Font = Enum.Font.Gotham
    speedButton.Text = "⚡ Скорость"
    speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedButton.TextSize = 14
    
    local speedCorner = Instance.new("UICorner")
    speedCorner.CornerRadius = UDim.new(0, 8)
    speedCorner.Parent = speedButton
    
    -- Кнопка 3: Полет
    local flyButton = Instance.new("TextButton")
    flyButton.Name = "FlyButton"
    flyButton.Parent = contentFrame
    flyButton.BackgroundColor3 = Color3.fromRGB(170, 85, 255)
    flyButton.BorderSizePixel = 0
    flyButton.Position = UDim2.new(0, 0, 0, 45)
    flyButton.Size = UDim2.new(0.48, 0, 0, 35)
    flyButton.Font = Enum.Font.Gotham
    flyButton.Text = "🦅 Полет"
    flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    flyButton.TextSize = 14
    
    local flyCorner = Instance.new("UICorner")
    flyCorner.CornerRadius = UDim.new(0, 8)
    flyCorner.Parent = flyButton
    
    -- Кнопка 4: Невидимость
    local invisButton = Instance.new("TextButton")
    invisButton.Name = "InvisButton"
    invisButton.Parent = contentFrame
    invisButton.BackgroundColor3 = Color3.fromRGB(85, 255, 170)
    invisButton.BorderSizePixel = 0
    invisButton.Position = UDim2.new(0.52, 0, 0, 45)
    invisButton.Size = UDim2.new(0.48, 0, 0, 35)
    invisButton.Font = Enum.Font.Gotham
    invisButton.Text = "👻 Невидимость"
    invisButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    invisButton.TextSize = 14
    
    local invisCorner = Instance.new("UICorner")
    invisCorner.CornerRadius = UDim.new(0, 8)
    invisCorner.Parent = invisButton
    
    -- Текстбокс для скорости
    local speedInput = Instance.new("TextBox")
    speedInput.Name = "SpeedInput"
    speedInput.Parent = contentFrame
    speedInput.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    speedInput.BorderSizePixel = 0
    speedInput.Position = UDim2.new(0, 0, 0, 90)
    speedInput.Size = UDim2.new(1, 0, 0, 30)
    speedInput.Font = Enum.Font.Gotham
    speedInput.PlaceholderText = "Введите скорость (по умолчанию 50)"
    speedInput.Text = "50"
    speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedInput.TextSize = 12
    speedInput.ClearTextOnFocus = false
    
    local speedInputCorner = Instance.new("UICorner")
    speedInputCorner.CornerRadius = UDim.new(0, 8)
    speedInputCorner.Parent = speedInput
    
    -- Информационная панель
    local infoFrame = Instance.new("Frame")
    infoFrame.Name = "InfoFrame"
    infoFrame.Parent = contentFrame
    infoFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    infoFrame.BorderSizePixel = 0
    infoFrame.Position = UDim2.new(0, 0, 0, 130)
    infoFrame.Size = UDim2.new(1, 0, 0, 80)
    
    local infoCorner = Instance.new("UICorner")
    infoCorner.CornerRadius = UDim.new(0, 8)
    infoCorner.Parent = infoFrame
    
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Name = "InfoLabel"
    infoLabel.Parent = infoFrame
    infoLabel.BackgroundTransparency = 1
    infoLabel.Position = UDim2.new(0, 10, 0, 5)
    infoLabel.Size = UDim2.new(1, -20, 1, -10)
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.Text = "🎮 Статус: Готов к использованию\n💡 Нажмите кнопки для активации функций\n⚙️ Настройте скорость в поле выше"
    infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    infoLabel.TextSize = 11
    infoLabel.TextWrapped = true
    infoLabel.TextYAlignment = Enum.TextYAlignment.Top
    infoLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    return screenGui, mainFrame, closeButton, teleportButton, speedButton, flyButton, invisButton, speedInput, infoLabel
end

-- Анимации
local function createTweenInfo(time, style, direction)
    return TweenInfo.new(time, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out)
end

local function animateButton(button, scale)
    local tween = TweenService:Create(button, createTweenInfo(0.1), {Size = button.Size * scale})
    tween:Play()
    tween.Completed:Connect(function()
        local returnTween = TweenService:Create(button, createTweenInfo(0.1), {Size = button.Size / scale})
        returnTween:Play()
    end)
end

-- Основная инициализация
local screenGui, mainFrame, closeButton, teleportButton, speedButton, flyButton, invisButton, speedInput, infoLabel = createMainGUI()

-- Переменные для функций
local flyEnabled = false
local speedEnabled = false
local invisEnabled = false
local originalWalkSpeed = 16

-- Функция обновления информации
local function updateInfo(text)
    infoLabel.Text = "🎮 " .. text
end

-- Сохранение GUI в глобальную переменную
GUI.ScreenGui = screenGui
GUI.MainFrame = mainFrame
GUI.IsVisible = true

print("🚀 Modern GUI загружен успешно!")
updateInfo("GUI загружен и готов к работе!")

-- Функции для основных возможностей

-- Функция телепорта к случайному игроку
local function teleportToRandomPlayer()
    local players = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(players, player)
        end
    end
    
    if #players > 0 then
        local randomPlayer = players[math.random(1, #players)]
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = randomPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(5, 0, 0)
            updateInfo("Телепортирован к игроку: " .. randomPlayer.Name)
        else
            updateInfo("Ошибка: персонаж не найден!")
        end
    else
        updateInfo("Нет доступных игроков для телепорта!")
    end
end

-- Функция изменения скорости
local function toggleSpeed()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local humanoid = LocalPlayer.Character.Humanoid
        local speedValue = tonumber(speedInput.Text) or 50
        
        if not speedEnabled then
            originalWalkSpeed = humanoid.WalkSpeed
            humanoid.WalkSpeed = speedValue
            speedEnabled = true
            speedButton.Text = "⚡ Отключить"
            speedButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
            updateInfo("Скорость установлена: " .. speedValue)
        else
            humanoid.WalkSpeed = originalWalkSpeed
            speedEnabled = false
            speedButton.Text = "⚡ Скорость"
            speedButton.BackgroundColor3 = Color3.fromRGB(255, 170, 85)
            updateInfo("Скорость сброшена до: " .. originalWalkSpeed)
        end
    else
        updateInfo("Ошибка: персонаж не найден!")
    end
end

-- Функция полета
local flyConnection = nil
local flySpeed = 50

local function toggleFly()
    if not flyEnabled then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.Parent = LocalPlayer.Character.HumanoidRootPart
            
            flyConnection = RunService.Heartbeat:Connect(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local camera = game.Workspace.CurrentCamera
                    local moveVector = LocalPlayer.Character.Humanoid.MoveDirection
                    local lookVector = camera.CFrame.LookVector
                    local rightVector = camera.CFrame.RightVector
                    
                    local velocity = Vector3.new(0, 0, 0)
                    
                    -- Управление клавишами
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        velocity = velocity + lookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        velocity = velocity - lookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        velocity = velocity - rightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        velocity = velocity + rightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        velocity = velocity + Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        velocity = velocity - Vector3.new(0, 1, 0)
                    end
                    
                    bodyVelocity.Velocity = velocity * flySpeed
                else
                    if flyConnection then
                        flyConnection:Disconnect()
                        flyConnection = nil
                    end
                end
            end)
            
            flyEnabled = true
            flyButton.Text = "🦅 Отключить"
            flyButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
            updateInfo("Полет активирован! WASD + Space/Shift")
        else
            updateInfo("Ошибка: персонаж не найден!")
        end
    else
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local bodyVelocity = LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyVelocity")
            if bodyVelocity then
                bodyVelocity:Destroy()
            end
        end
        
        flyEnabled = false
        flyButton.Text = "🦅 Полет"
        flyButton.BackgroundColor3 = Color3.fromRGB(170, 85, 255)
        updateInfo("Полет отключен")
    end
end

-- Функция невидимости
local function toggleInvisibility()
    if LocalPlayer.Character then
        if not invisEnabled then
            -- Делаем невидимым
            for _, part in pairs(LocalPlayer.Character:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Transparency = 1
                elseif part:IsA("Accessory") and part:FindFirstChild("Handle") then
                    part.Handle.Transparency = 1
                end
            end
            
            -- Скрываем лицо
            if LocalPlayer.Character:FindFirstChild("Head") and LocalPlayer.Character.Head:FindFirstChild("face") then
                LocalPlayer.Character.Head.face.Transparency = 1
            end
            
            invisEnabled = true
            invisButton.Text = "👻 Видимый"
            invisButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
            updateInfo("Невидимость активирована!")
        else
            -- Делаем видимым
            for _, part in pairs(LocalPlayer.Character:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Transparency = 0
                elseif part:IsA("Accessory") and part:FindFirstChild("Handle") then
                    part.Handle.Transparency = 0
                end
            end
            
            -- Показываем лицо
            if LocalPlayer.Character:FindFirstChild("Head") and LocalPlayer.Character.Head:FindFirstChild("face") then
                LocalPlayer.Character.Head.face.Transparency = 0
            end
            
            invisEnabled = false
            invisButton.Text = "👻 Невидимость"
            invisButton.BackgroundColor3 = Color3.fromRGB(85, 255, 170)
            updateInfo("Невидимость отключена")
        end
    else
        updateInfo("Ошибка: персонаж не найден!")
    end
end

-- Функция переключения GUI
local function toggleGUI()
    if isGUIVisible then
        local hideTween = TweenService:Create(mainFrame, createTweenInfo(0.3, Enum.EasingStyle.Back), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        })
        hideTween:Play()
        hideTween.Completed:Connect(function()
            screenGui.Enabled = false
        end)
        isGUIVisible = false
    else
        screenGui.Enabled = true
        mainFrame.Size = UDim2.new(0, 0, 0, 0)
        mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        
        local showTween = TweenService:Create(mainFrame, createTweenInfo(0.3, Enum.EasingStyle.Back), {
            Size = UDim2.new(0, 400, 0, 300),
            Position = UDim2.new(0.5, -200, 0.5, -150)
        })
        showTween:Play()
        isGUIVisible = true
    end
end

-- Обработчики событий кнопок
closeButton.MouseButton1Click:Connect(function()
    animateButton(closeButton, 0.9)
    screenGui:Destroy()
    updateInfo("GUI закрыт")
end)

teleportButton.MouseButton1Click:Connect(function()
    animateButton(teleportButton, 0.95)
    teleportToRandomPlayer()
end)

speedButton.MouseButton1Click:Connect(function()
    animateButton(speedButton, 0.95)
    toggleSpeed()
end)

flyButton.MouseButton1Click:Connect(function()
    animateButton(flyButton, 0.95)
    toggleFly()
end)

invisButton.MouseButton1Click:Connect(function()
    animateButton(invisButton, 0.95)
    toggleInvisibility()
end)

-- Обработчик изменения текста в поле скорости
speedInput.FocusLost:Connect(function()
    local newSpeed = tonumber(speedInput.Text)
    if newSpeed and newSpeed > 0 and newSpeed <= 500 then
        if speedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = newSpeed
            updateInfo("Скорость обновлена: " .. newSpeed)
        end
    else
        speedInput.Text = "50"
        updateInfo("Неверное значение скорости! Установлено 50")
    end
end)

-- Горячие клавиши
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.RightControl then
        toggleGUI()
    elseif input.KeyCode == Enum.KeyCode.T and isGUIVisible then
        teleportToRandomPlayer()
    elseif input.KeyCode == Enum.KeyCode.G and isGUIVisible then
        toggleSpeed()
    elseif input.KeyCode == Enum.KeyCode.F and isGUIVisible then
        toggleFly()
    elseif input.KeyCode == Enum.KeyCode.V and isGUIVisible then
        toggleInvisibility()
    end
end)

-- Автоматическое обновление при респавне персонажа
LocalPlayer.CharacterAdded:Connect(function(character)
    wait(1) -- Ждем полной загрузки персонажа
    
    -- Сбрасываем все состояния
    flyEnabled = false
    speedEnabled = false
    invisEnabled = false
    
    -- Обновляем кнопки
    speedButton.Text = "⚡ Скорость"
    speedButton.BackgroundColor3 = Color3.fromRGB(255, 170, 85)
    
    flyButton.Text = "🦅 Полет"
    flyButton.BackgroundColor3 = Color3.fromRGB(170, 85, 255)
    
    invisButton.Text = "👻 Невидимость"
    invisButton.BackgroundColor3 = Color3.fromRGB(85, 255, 170)
    
    -- Отключаем полет если был активен
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    
    updateInfo("Персонаж возрожден! Функции сброшены")
end)

-- Финальное сообщение
updateInfo("Готов! Горячие клавиши: RCtrl - показать/скрыть, T - телепорт, G - скорость, F - полет, V - невидимость")
print("🎮 Все функции GUI загружены!")
print("📋 Горячие клавиши:")
print("   RightControl - Показать/скрыть GUI")
print("   T - Телепорт к случайному игроку")
print("   G - Переключить скорость")
print("   F - Переключить полет")
print("   V - Переключить невидимость")