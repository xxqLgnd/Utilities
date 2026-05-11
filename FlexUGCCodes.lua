getgenv().Settings = {
    Launcher = false,
    Avoid = false,
    Delay = 0.5,
    Skip = 0,
    Speed = false,
    SpeedBasic = 16,
    CustomSpeed = 16,
    Version = "1.0.5"
}

local File = "connecthub_settings.json"
local HttpService = game:GetService("HttpService")

local function SaveSettings(table)
    writefile(File, HttpService:JSONEncode(table))
end

local function LoadSettings()
    if isfile(File) then
        local data = readfile(File)
        local success, table = pcall(function() return HttpService:JSONDecode(data) end)
        if success and type(table) == "table" then
            return table
        end
    end
    return nil
end

local function CheckActiveCrate()
    for i,v in pairs(LocalPlayer.PlayerGui.ScreenGui.ScrollingFrame.Frame.CasesF:GetChildren()) do
        if v:IsA("Folder") then
            for i,z in pairs(v:GetChildren()) do
                if z:IsA("ScrollingFrame") and z.Name == "ScrollingFrame" and z.Visible then
                    return false
                end
            end
        end
    end

    return true
end

local LoadedSettings = LoadSettings()

if LoadedSettings then
    for i, v in pairs(LoadedSettings) do
        Settings[i] = v
    end
end

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HumanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
local Humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")

local function FireTouchTransmitter(part)
    if firetouchinterest then
        local Character = LocalPlayer.Character:FindFirstChildOfClass("Part")
  
        if Character then
            firetouchinterest(part, Character, 0)
            firetouchinterest(part, Character, 1)
        end
    else
        LocalPlayer.Character:PivotTo(part:GetPivot())
    end
end

local ui = loadstring(game:HttpGet("https://raw.githubusercontent.com/xxqLgnd/Library/main/uiV3.lua", true))()

local UISettings = {
    ['Game'] = string.format(game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name .. " %s", Settings.Version),
	['Auto'] = 110162136250435,
    ['Update'] = 86844430363710
}

local Window = ui:Window({
	Title = "Connect Hub",
	Desc = UISettings.Game
})

local General = Window:Add({
	Title = "Launcher Sniper",
	Desc = UISettings.Game,
	Banner = UISettings.Auto
})

local SectionL = General:Section({
	Title = "Main",
	Side = 'l'
})

local Prompt = BrickColor.new("Pastel light blue")
local Kick = BrickColor.new("Persimmon")
local Fling = BrickColor.new("Gold")
local Ball = 1

Workspace.ChildAdded:Connect(function(v)
    if not Settings.Launcher then return end
    if v:IsA("MeshPart") and v.BrickColor == Prompt then
        Ball = Ball + 1
    end
end)

SectionL:Toggle({Title = "Auto Collect Launcher Items", Desc = "Automatic collect launcher items on the map", Value = Settings.Launcher, Callback = function(state)
    task.spawn(function()
        Settings.Launcher = state; Ball = 0; SaveSettings(Settings)
        while true do
            if not Settings.Launcher then Ball = 0 return end
            for i,v in pairs(Workspace:GetChildren()) do
                if v:IsA("MeshPart") and v.BrickColor == Prompt then
                    if Ball >= Settings.Skip then
                        FireTouchTransmitter(v); Ball = 0;
                    end
                end
            end
            task.wait(Settings.Delay)
        end
    end)
end})

SectionL:Slider({Title = "Collect Delay", Min = .01, Max = 10, Value = Settings.Delay, Rounding = 4, CallBack = function(v)
	Settings.Delay = v; SaveSettings(Settings)
end})

SectionL:Slider({Title = "Skip Balls", Min = 0, Max = 10, Value = Settings.Skip, Rounding = 0, CallBack = function(v)
	Settings.Skip = v; SaveSettings(Settings)
end})

SectionL:Paragarp({
    Title = "Skip Balls Description:", 
    Desc = "0 = collect all | 2 = skip 1, collect 2rd | 3 = skip 2, collect 3th and etc."
})


local SectionR = General:Section({
	Title = "Misc",
	Side = 'r'
})

SectionR:Toggle({Title = "Enable Player Speed", Desc = "", Value = Settings.Speed, Callback = function(state)
	task.spawn(function()
        Settings.Speed = state; SaveSettings(Settings)
        while true do
            if not Settings.Speed then Humanoid.WalkSpeed = Settings.SpeedBasic return end
            Humanoid.WalkSpeed = Settings.CustomSpeed
            task.wait(.1)
        end
    end)
end})

SectionR:Slider({Title = "Player Speed", Min = 16, Max = 100, Value = Settings.CustomSpeed, Rounding = 0, CallBack = function(v)
	Settings.CustomSpeed = v; SaveSettings(Settings)
end})

SectionR:Button({Title = "Teleport Tool", Callback = function()
	loadstring(game:HttpGet("https://pastefy.app/spn8O2kz/raw",true))()
end})

local Update = Window:Add({
	Title = "Connect Hub",
	Desc = UISettings.Game,
	Banner = UISettings.Update
})

local UpdateL = Update:Section({
	Title = "Update",
	Side = 'l'
})

UpdateL:Discord(".gg/trSwdwm6Hp")
UpdateL:Telegram("t.me/LimitedUGCnotifier")
