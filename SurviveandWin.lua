--xxqLgnd

-- Full source but dont leak it please!

if not game:IsLoaded() then game.Loaded:Wait() end

local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character
local ReplicatedStorage = game:GetService("ReplicatedStorage")

repeat

until LocalPlayer:FindFirstChild("Backpack")

local lastValue = LocalPlayer.leaderstats.Points.Value

if lastValue >= 499999 then
    LocalPlayer:Kick("Access Denied. You already have 500k+ points. Spend this points on UGCs..."); return
end

local function GetGroupUGC()
    local UGCs = {}

    local Data = HttpService:JSONDecode(request({
        Method = "GET",
        Url = "https://catalog.roblox.com/v1/search/items?category=All&limit=30&sortType=3&creatorType=Group&creatorTargetId=7015605&salesTypeFilter=2"
    }).Body)

    if Data and Data.data then     
        for _,v in ipairs(Data.data) do
            if v.id then
                local success, info = pcall(function()
                    return MarketplaceService:GetProductInfo(v.id)
                end)
                if success and info and info.IsForSale and v.id ~= 73691321494234 then
                    table.insert(UGCs, v.id)
                end
            end
        end
    end

    return UGCs
end

local function PlayerOwnsAllUGC()
    for _,v in ipairs(GetGroupUGC()) do
        local success, owns = pcall(function()
            return MarketplaceService:PlayerOwnsAsset(LocalPlayer, v)
        end)
        
        if not (success and owns) then
            return false
        end
    end

    return true
end

local function Move()
    for _,v in ipairs(LocalPlayer.Character:GetChildren()) do
        if v:IsA("Tool") then
            v.Parent = LocalPlayer.Backpack
        end
    end
end

local function BackpackTools()
    local Tools = {}

    for _,v in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if v:IsA("Tool") then
            Tools[v.Name] = true
        end
    end

    return Tools
end

local function ReplicatedTools()
    local Tools = {}

    for _,v in ipairs(ReplicatedStorage.Tools:GetChildren()) do
        if v:IsA("Tool") and v.Name ~= "Tommy Gun" then
            table.insert(Tools, v.Name)
        end
    end

    return Tools
end

if PlayerOwnsAllUGC() then
    LocalPlayer:Kick("Access Denied. You already have all UGCs."); return
end

if game.PlaceId ~= 96066725983851 then
    game:GetService('TeleportService'):Teleport(96066725983851, LocalPlayer); return
end

local CoreGui = game:GetService("CoreGui")
local OverlayGui = Instance.new("ScreenGui")
OverlayGui.Name = "Overlay"
OverlayGui.IgnoreGuiInset = true
OverlayGui.ResetOnSpawn = false
OverlayGui.Parent = CoreGui

local StatusFrame = Instance.new("Frame")
StatusFrame.Size = UDim2.new(1, 0, 1, 0)
StatusFrame.Position = UDim2.new(0, 0, 0, 0)
StatusFrame.BackgroundColor3 = Color3.new(0, 0, 0)
StatusFrame.BackgroundTransparency = 0
StatusFrame.ZIndex = 1000
StatusFrame.Parent = OverlayGui

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0.15, 0)
TitleLabel.Position = UDim2.new(0, 0, 0.15, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.new(1, 1, 1)
TitleLabel.TextStrokeTransparency = 0.5
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextScaled = true
TitleLabel.ZIndex = 1002
TitleLabel.Text = "Noctural Points Farm"
TitleLabel.Parent = StatusFrame

local TextLabel = Instance.new("TextLabel")
TextLabel.Size = UDim2.new(1, 0, 1, 0)
TextLabel.Position = UDim2.new(0, 0, 0, 0)
TextLabel.BackgroundTransparency = 1
TextLabel.TextColor3 = Color3.new(1, 1, 1)
TextLabel.TextStrokeTransparency = 0.5
TextLabel.Font = Enum.Font.SourceSansBold
TextLabel.TextScaled = true
TextLabel.ZIndex = 1001
TextLabel.Text = "Loading Settings..."
TextLabel.Parent = StatusFrame


LocalPlayer.leaderstats.Points.Changed:Connect(function(newValue)
    if math.abs(newValue - lastValue) >= 5000 then
        ReplicatedStorage.GiveTool:FireServer("Tommy Gun", -10000)
    end
    lastValue = newValue
end)

if LocalPlayer.PlayerGui:FindFirstChild("Custom Inventory") then
    LocalPlayer.PlayerGui["Custom Inventory"]:Destroy()
end

getgenv().htyhjtyj = true

while task.wait(.1) do
    if getgenv().htyhjtyj and LocalPlayer.PlayerGui:FindFirstChild("MainMenu") then
        firesignal(LocalPlayer.PlayerGui.MainMenu.Buttons.Frame.PlayBTN.MouseButton1Click); getgenv().htyhjtyj = false
    else
        Move()

        local Backpack = 0
        for _,v in ipairs(ReplicatedTools()) do
            if BackpackTools()[v] then
                Backpack = Backpack + 1
            end
        end

        if Backpack == #ReplicatedTools() then
            if LocalPlayer.PlayerGui.DeathScreen and LocalPlayer.PlayerGui.DeathScreen.MainFrame.Visible then
                firesignal(LocalPlayer.PlayerGui.DeathScreen.MainFrame.TextButton.MouseButton1Click);
            else
                for i = 60, 1, -1 do
                    TextLabel.Text = string.format("Waiting for %d seconds to save points%s", i, string.rep(".", (60 - i) % 3 + 1))
                    task.wait(1)
                end
                TextLabel.Text = "Saved Points. Rejoining!"
                game:GetService('TeleportService'):Teleport(138605463938486, LocalPlayer)
                task.wait(10)
            end
        else
            TextLabel.Text = "Setting up the script to gain points..."
            for _,v in ipairs(ReplicatedTools()) do
                if not BackpackTools()[v] then
                    ReplicatedStorage.GiveTool:FireServer(v, -2000); task.wait(.4)
                end
            end
            for i = 1, 2 do
                ReplicatedStorage.GiveTool3:FireServer("Speed Potion",-2000); task.wait(.4)
            end
            ReplicatedStorage.GiveTool2:FireServer("Jump Potion",-2000); task.wait(.4)
            for i = 1, 3 do
                ReplicatedStorage.GiveTool2:FireServer("Medkit",-2000); task.wait(.4)
            end
        end
    end
end
