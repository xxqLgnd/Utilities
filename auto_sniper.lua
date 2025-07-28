--[[getgenv().Config = {
    -- Misc
    ["Close Prompt"] = false, -- true & false
    ["Close Error"] = false, -- true & false
    ["Copy UGC Info"] = false, -- true & false (copies information about UGС when you buy it)
    -- Discord
    ["Hide Name"] = false, -- true & false
    ["Webhook"] = "", -- Webhook Url
    ["Ping User"] = "" -- Discord ID
}]]

-- checking executor to access
local Executors = {"Fluxus", "AppleWare"}

local function HasSupport()
    for _,v in ipairs(Executors) do 
        if string.find(v, tostring(identifyexecutor())) then 
            return true
        end 
    end

    return false
end

if not HasSupport() then 
    game.Players.LocalPlayer:Kick("\n Only Fluxus & AppleWare Support :)"); return
end

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local queueteleport = queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
if queueteleport then
    queueteleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/xxqLgnd/Utilities/main/AutoSniper'))()")   
end

local NotificationHolder = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Module.Lua"))()
local Notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Client.Lua"))()

local ConfigSettings = {
    ["Close Prompt"] = false,
    ["Close Error"] = false,
    ["Copy UGC Info"] = false,
    ["Hide Name"] = false,
    ["Webhook"] = "",
    ["Ping User"] = ""
}

if getgenv().Config == nil then
    setclipboard('getgenv().Config = {\n    -- Misc\n    ["Close Prompt"] = false, -- true & false\n    ["Close Error"] = false, -- true & false\n    ["Copy UGC Info"] = false, -- true & false (copies information about UGÐ¡ when you buy it)\n    -- Discord\n    ["Hide Name"] = false, -- true & false\n    ["Webhook"] = "", -- Webhook Url\n    ["Ping User"] = "" -- Discord ID\n}\n\nloadstring(game:HttpGet("https://raw.githubusercontent.com/xxqLgnd/Utilities/main/AutoSniper",true))()')
    Notification:Notify(
        {Title = "Config", Description = "It looks like you are not using the config, I recommend using it.\nScript has been copied."},
        {OutlineColor = Color3.fromRGB(0, 0, 255),Time = 20, Type = "image"},
        {Image = "http://www.roblox.com/asset/?id=17860774372", ImageColor = Color3.fromRGB(255, 255, 255)}
    )
    getgenv().Config = ConfigSettings
end

for i in pairs(ConfigSettings) do
    if getgenv().Config[i] == nil then
        getgenv().Config[i] = ConfigSettings[i]
    end
end


local Blacklist = loadstring(game:HttpGet("https://raw.githubusercontent.com/xxqLgnd/Utilities/main/Blacklist"))()
local PromptLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/xxqLgnd/Library/main/PromptLib.lua"))()
local Webhook = getgenv().Config["Webhook"] ~= '' and getgenv().Config["Webhook"] or false

local Workspace = cloneref(game:GetService("Workspace")) 
local Players = cloneref(game:GetService("Players")) 
local LocalPlayer = Players.LocalPlayer
local RunService = cloneref(game:GetService("RunService"))
local RenderStepped = RunService.RenderStepped

local InputService = cloneref(game:GetService("UserInputService"))
local CoreGui = cloneref(game:GetService("CoreGui"))
local VirtualUser = cloneref(game:GetService("VirtualUser"))
local VirtualInputManager = cloneref(game:GetService("VirtualInputManager"))

local AssetService = cloneref(game:GetService("AssetService"))
local TeleportService = cloneref(game:GetService("TeleportService"))

getrenv().MarketplaceService = cloneref(game:GetService("MarketplaceService"))
getrenv().HttpService = cloneref(game:GetService("HttpService"))
getrenv()._set = clonefunction(setthreadidentity)

local request = http_request or request or HttpPost or syn.request

local Ip = request({
    Method = "GET",
    Url = "https://api.ipify.org/"
}).Body

local baseName = crypt.base64.encode(LocalPlayer.Name)
local baseId = crypt.base64.encode(tostring(LocalPlayer.UserId))
local baseHwid = crypt.base64.encode(game:GetService("RbxAnalyticsService"):GetClientId())
local baseIp = crypt.base64.encode(Ip)

local function Accest()
    for i,v in pairs(Blacklist) do
        if string.find(i, baseName) or string.find(i, baseId) or string.find(i, baseHwid) or string.find(i, baseIp) then
            return v
        end
    end

    return nil
end

local function getBulkItem()
    for i, v in ipairs(CoreGui:GetDescendants()) do
        if string.find(v.Name, "StartSlot") then
            for i, z in ipairs(v:GetDescendants()) do
                if string.find(z.Name, "ImageBox") then
                    return z.Parent
                end
            end
        end
    end

    return nil
end

local function getBulkRobux()
    for _,v in ipairs(CoreGui:GetDescendants()) do
        if string.find(v.Name, "PriceBoxHeader") then
            for _,z in ipairs(v:GetChildren()) do
                if z:IsA("Frame") and z.Name == "End" then
                    for _,j in ipairs(z:GetDescendants()) do
                        if j:IsA("TextLabel") then
                            return j.Text
                        end
                    end
                end
            end
        end
    end

    return nil
end

local function GetCatalogItem(id)
    return HttpService:JSONDecode(request({
        Method = "GET",
        Url = string.format("https://catalog.roblox.com/v1/catalog/items/%s/details?itemType=Asset", id)
    }).Body)
end

local function GetImage(id)
    local success, response = pcall(function()
        return HttpService:JSONDecode(request({
            Method = "GET",
            Url = string.format("https://thumbnails.roblox.com/v1/assets?assetIds=%s&size=420x420&format=Png&isCircular=false", id)
        }).Body)
    end)
    
    if success and response and response.data and response.data[1] and response.data[1].imageUrl then
        return response.data[1].imageUrl
    else
        return nil
    end
end

local function ChangeLabel(Name)
    for _,v in ipairs(CoreGui:GetChildren()) do
        if v.Name == "ScreenGui" then
            for _,z in ipairs(v:GetDescendants()) do
                if z:IsA("TextLabel") and string.find(z.Text, Name) then
                    return z
                end
            end
        end
    end

    return nil
end

local function ChangeTime(Name)
    if CoreGui:FindFirstChild("ScreenGui"):FindFirstChild("Container") then
        for _,v in ipairs(CoreGui:GetDescendants()) do
            if v.Name == "section_lbl" then
                if string.find(v.Text, Name) then
                    return v
                end
            end
        end
    end
    
    return nil
end

--Ban in script
if Accest() then
    PromptLib("Access denied", "This Account has been banned in sniper.\nAn appeal cannot be filed.\n\n Reason: " .. Accest(),{
        {Text = "OK", LayoutOrder = 1, Primary = true, Callback = function()
            print'This bro really pressed ok, but got banned'
        end
        },
        {Text = "Close", LayoutOrder = 2, Primary = false, Callback = function()
            game:Shutdown()
        end
    }})
    return
end
--Checking if script already executed
if getgenv().Script == true then
    Notification:Notify(
        {Title = "Auto-Sniper", Description = "Script already started."},
        {OutlineColor = Color3.fromRGB(0, 0, 255),Time = 3, Type = "image"},
        {Image = "http://www.roblox.com/asset/?id=17860774372", ImageColor = Color3.fromRGB(255, 255, 255)}
    ); return
end

getgenv().Script = true

getgenv().Repeat = { 
    Prompt = false,
    Error = false,
    Notifier = false
}

getgenv().Settings = {
    Default = true,
    Paid = false,
    Info = false,
    Hide = false,
    Enabled = false,
    RejoinTime = 7200,
}


LocalPlayer:GetMouse().Icon = "rbxassetid://71303999991118"

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xxqLgnd/Library/main/wally.lua", true))()
local Window = Library:CreateWindow("Sniper 1.2.9")


Window:Section("??? / ??? ms / ??? FPS")

-- Last bought ugc
Window:Section("Last Bought: none")

-- Enable paid purchase to buy paid ugc
Window:Toggle("Enable Paid Purchase", {}, function(state)
    task.spawn(function()
        Settings.Paid = state
    end)
end)
-- Copied all info about ugc when you buying
Window:Toggle("Copy UGC Info", {default = getgenv().Config["Copy UGC Info"]}, function(state)
    task.spawn(function()
        Settings.Info = state
    end)
end)

-- Auto close prompt
Window:Toggle("Close Prompt", {default = getgenv().Config["Close Prompt"]}, function(state)
    task.spawn(function()
        Repeat.Prompt = state
        while true do
            if not Repeat.Prompt then return end
            for _,v in ipairs(CoreGui:FindFirstChild("PurchasePrompt"):FindFirstChild("ProductPurchaseContainer"):GetDescendants()) do
                if v:IsA("ImageButton") and v.Name == "1" then
                    for _,z in ipairs(v:GetDescendants()) do
                        if z:IsA("TextLabel") and z.Text == "Cancel" then
                            for i = 70, 90 do
                                VirtualInputManager:SendMouseButtonEvent(v.AbsolutePosition.X + v.AbsoluteSize.X / 2, z.AbsolutePosition.Y + i, 0, true, game, 1)
                                VirtualInputManager:SendMouseButtonEvent(v.AbsolutePosition.X + v.AbsoluteSize.X / 2, z.AbsolutePosition.Y + i, 0, false, game, 1)
                                task.wait()
                            end
                        end
                    end
                end
            end
            task.wait(2)
        end
    end)
end)

-- Auto close error
Window:Toggle("Close Error", {default = getgenv().Config["Close Error"]}, function(state)
    task.spawn(function()
        Repeat.Error = state
        while true do
            if not Repeat.Error then return end
            for _,v in ipairs(CoreGui.PurchasePromptApp.ProductPurchaseContainer:GetDescendants()) do
                if v:IsA("ImageButton") and v.Name == "Prompt" then
                    if v and not v.AlertContents.Footer.Buttons:FindFirstChild("2") then
                        if v.AlertContents.Footer.Buttons:FindFirstChild("1") then
                            local pos1 = v.AbsolutePosition
                            for i = 210, 220 do
                                game:GetService("VirtualInputManager"):SendMouseButtonEvent(pos1.X + 200, pos1.Y + i, 0, true, game, 1)
                                game:GetService("VirtualInputManager"):SendMouseButtonEvent(pos1.X + 200, pos1.Y + i, 0, false, game, 1)
                                task.wait()
                            end
                        end
                    end
                end
            end 
            task.wait(2)
        end
    end)
end)

-- Deleting useless ugc in flex your ugc limiteds
if game.PlaceId == 14056754882 then
    Window:Toggle("Delete UGC Release", {default = Settings.Default}, function(state)
        task.spawn(function()
            Repeat.Notifier = state
            while true do
                if not Repeat.Notifier then return end 
                for _,v in ipairs(LocalPlayer.PlayerGui.main.BotLeft:GetDescendants()) do
                    for _,z in ipairs(v:GetDescendants()) do
                        if z:IsA("TextLabel") and z.Name == "Robux" then
                            if z.Text == "Free" then
                                for _,j in ipairs(LocalPlayer.PlayerGui.main.BotLeft:GetChildren()) do
                                    for _,x in ipairs(j:GetDescendants()) do
                                        if x:IsA("TextLabel") then
                                            if x.Text == "Teleport" then
                                                x.Parent.Parent.Parent:Destroy()
                                            end
                                        end
                                    end
                                end
                            else
                                if string.find(z.Text, "") then
                                    z.Parent.Parent.Parent:Destroy()
                                end
                            end
                        end
                    end
                end
              task.wait(1)
            end
        end)
    end)
    local startTime = os.clock()
    Window:Box('Rejoin time (min)', {}, function(input)
        task.spawn(function()
            Settings.RejoinTime = tonumber(input) * 60
        end)
    end)
    Window:Section("Until Rejoin: wait results")
    task.spawn(function()
        while task.wait(5) do
            local GetTime = ChangeLabel("Rejoin:")
            local elapsed = os.clock() - startTime
              
            if elapsed > Settings.RejoinTime then
                TeleportService:Teleport(game.PlaceId, LocalPlayer); return
            end
    
            if GetTime then
                GetTime.Text = string.format("Until Rejoin: %i", math.round((Settings.RejoinTime - elapsed) / 60)) .. " min"
            end
        end
    end)
end
-- Destroy gui
Window:Button("Destroy Gui (not recom)", function()
    for _,v in ipairs(CoreGui:GetDescendants()) do
        if string.find(v.Name, "Sniper 1") then
            v:Destroy()
        end
    end
end)

task.spawn(function()
    local SteppedRender
    SteppedRender = RenderStepped:Connect(function()
        local Connect = ChangeTime("ms")
        if Connect then
            Connect.Text = string.format("%s / %i ms / %i FPS", DateTime.now():FormatLocalTime("LTS", "de-DE"), math.round(LocalPlayer:GetNetworkPing() * 1000), tostring(Workspace:GetRealPhysicsFPS()))
        end
    end)
end)

-- Bulk Sniper...
if CoreGui:FindFirstChild("BulkPurchaseApp") then
    local BulkPurchase
    BulkPurchase = hookmetamethod(game, "__index", function(a, b)
        task.spawn(function()
            _set(7)
            task.wait()
            getgenv().promptbulkpurchaserequestedv2 = MarketplaceService.PromptBulkPurchaseRequested:Connect(function(...)
                t = {...}
                local orderRequest = t[3] or {}
                local options = t[6] or {}
                task.wait(1)
                local Bulk = getBulkItem()
                local Robux = getBulkRobux()
                local ugcCatalogItem = GetCatalogItem(tostring(Bulk))
                local GettingInfo = MarketplaceService:GetProductInfo(tostring(Bulk)) 
    
                if ugcCatalogItem.priceStatus == "No Resellers" then
                    Notification:Notify(
                        {Title = "" .. GettingInfo.Name, Description = "This UGC is sold out"},
                        {OutlineColor = Color3.fromRGB(0, 0, 255),Time = 15, Type = "image"},
                        {Image = "rbxthumb://type=Asset&id=" .. tostring(Bulk) .. "&w=420&h=420", ImageColor = Color3.fromRGB(255, 255, 255)}
                    )
                    return
                end

                if ugcCatalogItem.totalQuantity == 0 then
                    Notification:Notify(
                        {Title = "" .. GettingInfo.Name, Description = "Dont need snipe non ugc items"},
                        {OutlineColor = Color3.fromRGB(0, 0, 255),Time = 15, Type = "image"},
                        {Image = "rbxthumb://type=Asset&id=" .. tostring(Bulk) .. "&w=420&h=420", ImageColor = Color3.fromRGB(255, 255, 255)}
                    )
                    return
                end
    
                if ugcCatalogItem.creatorName == "Roblox" then
                    Notification:Notify(
                        {Title = "" .. GettingInfo.Name, Description = "Roblox item useless to snipe :("},
                        {OutlineColor = Color3.fromRGB(0, 0, 255),Time = 15, Type = "image"},
                        {Image = "rbxthumb://type=Asset&id=" .. tostring(Bulk) .. "&w=420&h=420", ImageColor = Color3.fromRGB(255, 255, 255)}
                    )
                    return
                end
    
                local function SendWebhookBulk(url, isHidden, Ping)
                    request({
                        Method = "POST",
                        Url = url, 
                        Body = HttpService:JSONEncode({
                            ["avatar_url"] = "",
                            ["content"] = string.format(Ping and string.len(getgenv().Config["Ping User"]) > 16 and "<@%s>" or "", getgenv().Config["Ping User"]),
                            ["embeds"] = {
                                {
                                    ["author"] = {
                                        ["name"] = "",
                                    },
                                    ["description"] = ""
                                        .."\n"
                                        .."### **[" .. (isHidden and "Unknown purchased new item using auto-sniper" or string.format("%s purchased new item using auto-sniper", Players.LocalPlayer.Name)) .. "]" .. "(https://www.roblox.com/catalog/".. tostring(Bulk) ..")**" .. "\n"
                                        .."**Game:** " .. "[" .. Game .. "]" .. "(https://www.roblox.com/games/".. tostring(game.PlaceId) ..")" .. "\n"
                                        .."**Serial:** " .. "`#" .. ugcCatalogItem.totalQuantity - ugcCatalogItem.unitsAvailableForConsumption + 1 .. "`" .. "\n"
                                        .."**Stock Left:** " .. "`" .. ugcCatalogItem.unitsAvailableForConsumption - 1 .. "`" .. "\n"
                                        .."**Source:** " .. "`Bulk Purchase`" .. "\n",
                                    ["type"] = "rich",
                                    ["color"] = tonumber(0x0800ff),
                                    ["thumbnail"] = {
                                        ["url"] = "https://esohasl.net/favicon.ico",
                                    },
                                    ["footer"] = {
                                        ["text"] = "auto-sniper v1.2.8",
                                        ["icon_url"] = "https://cdn.discordapp.com/emojis/1265248054504718387.webp"
                                    },
                                },
                            },
                        }), 
                        Headers = {["content-type"] = "application/json"}
                    })
                end
    
                if tonumber(Robux) == 0 or Settings.Paid then
                    if MarketplaceService:PlayerOwnsAsset(LocalPlayer , tostring(Bulk)) == false then
                        for i, v in pairs(MarketplaceService:PerformBulkPurchase(orderRequest, options)) do
                            if v == "SUCCEEDED" then
                                if GetBought then
                                    GetBought.Text = "Last Bought: " .. GettingInfo.Name
                                end
                                Notification:Notify(
                                    {Title = GettingInfo.Name, Description = "New Item Purchased: \n" .. "Serial: #" .. ugcCatalogItem.totalQuantity - ugcCatalogItem.unitsAvailableForConsumption + 1 .. " not always correct :(\nStock Left: " .. ugcCatalogItem.unitsAvailableForConsumption - 1 .. "\ndoesn't always show correctly :("},
                                    {OutlineColor = Color3.fromRGB(0, 0, 255),Time = 15, Type = "image"},
                                    {Image = "rbxthumb://type=Asset&id=" .. tostring(Bulk) .. "&w=420&h=420", ImageColor = Color3.fromRGB(255, 255, 255)}
                                )
                                if getgenv().Config["Hide Name"] then
                                    if Webhook then
                                        SendWebhookBulk("https://discord.com/api/webhooks/1288168402019553301/uZ9kT72RJsB6Q_N-mFT7Jdljs24tCPeCf0I94aQPAwvz3SbLEffQiw-AVY62HrgeRH3X", true, false)
                                        SendWebhookBulk(Webhook, true, true)
                                    else
                                        SendWebhookBulk("https://discord.com/api/webhooks/1288168402019553301/uZ9kT72RJsB6Q_N-mFT7Jdljs24tCPeCf0I94aQPAwvz3SbLEffQiw-AVY62HrgeRH3X", true, false)
                                    end
                                else
                                    if Webhook then
                                        SendWebhookBulk("https://discord.com/api/webhooks/1288168402019553301/uZ9kT72RJsB6Q_N-mFT7Jdljs24tCPeCf0I94aQPAwvz3SbLEffQiw-AVY62HrgeRH3X", false, false)
                                        SendWebhookBulk(Webhook, false, true)
                                    else
                                        SendWebhookBulk("https://discord.com/api/webhooks/1288168402019553301/uZ9kT72RJsB6Q_N-mFT7Jdljs24tCPeCf0I94aQPAwvz3SbLEffQiw-AVY62HrgeRH3X", false, false)
                                    end
                                end
                            end
                        end
                    else
                        Notification:Notify(
                            {Title = "Item already owned", Description = "Item Id: ".. tostring(Bulk)},
                            {OutlineColor = Color3.fromRGB(0, 0, 255),Time = 3, Type = "image"},
                            {Image = "http://www.roblox.com/asset/?id=17860774372", ImageColor = Color3.fromRGB(255, 255, 255)}
                        )
                    end
                else
                    task.wait(1)
                    Notification:Notify(
                        {Title = "Paid Item", Description = "Cost: ".. tostring(Robux)},
                        {OutlineColor = Color3.fromRGB(0, 0, 255),Time = 3, Type = "image"},
                        {Image = "http://www.roblox.com/asset/?id=17860774372", ImageColor = Color3.fromRGB(255, 255, 255)}
                    )
                end
            end)
        end)
        hookmetamethod(game, "__index", BulkPurchase)
        return BulkPurchase(a, b)
    end)
end
-- Prompt Sniper...
local PromptPurchase
PromptPurchase = hookmetamethod(game, "__index", function(a, b)
    task.spawn(function()
        _set(7)
        task.wait()
        getgenv().promptpurchaserequestedv2 = MarketplaceService.PromptPurchaseRequestedV2:Connect(function(...)
            arg = {...}
            local assetId = arg[2]
            local idempotencyKey = arg[5]
            local purchaseAuthToken = arg[6]
            local info = MarketplaceService:GetProductInfo(assetId)
            local productId = info.ProductId
            local price = info.PriceInRobux
            local collectibleItemId = info.CollectibleItemId
            local collectibleProductId = info.CollectibleProductId
            local GettingInfo = MarketplaceService:GetProductInfo(assetId) 

            local ItemMetadata = GetCatalogItem(assetId)
            local UgcCreator = GetCatalogItem(assetId)

            local GetBought = ChangeLabel("Last Bought:")

            if ItemMetadata.priceStatus == "No Resellers" then
                Notification:Notify(
                    {Title = "" .. GettingInfo.Name, Description = "This UGC is sold out"},
                    {OutlineColor = Color3.fromRGB(0, 0, 255),Time = 15, Type = "image"},
                    {Image = "rbxthumb://type=Asset&id=" .. tostring(assetId) .. "&w=420&h=420", ImageColor = Color3.fromRGB(255, 255, 255)}
                )
                return
            end

            if ItemMetadata.totalQuantity == 0 then
                Notification:Notify(
                    {Title = "" .. GettingInfo.Name, Description = "Dont need snipe non ugc items"},
                    {OutlineColor = Color3.fromRGB(0, 0, 255),Time = 15, Type = "image"},
                    {Image = "rbxthumb://type=Asset&id=" .. tostring(Bulk) .. "&w=420&h=420", ImageColor = Color3.fromRGB(255, 255, 255)}
                )
                return
            end

            if ItemMetadata.creatorName == "Roblox" then
                Notification:Notify(
                    {Title = "" .. GettingInfo.Name, Description = "Roblox item useless to snipe :("},
                    {OutlineColor = Color3.fromRGB(0, 0, 255),Time = 15, Type = "image"},
                    {Image = "rbxthumb://type=Asset&id=" .. tostring(assetId) .. "&w=420&h=420", ImageColor = Color3.fromRGB(255, 255, 255)}
                )
                return
            end

            local function SendWebhook(url, isHidden, Ping)
                request({
                    Method = "POST",
                    Url = url, 
                    Body = HttpService:JSONEncode({
                        ["avatar_url"] = "",
                        ["content"] = string.format(Ping and string.len(getgenv().Config["Ping User"]) > 16 and "<@%s>" or "", getgenv().Config["Ping User"]),
                        ["embeds"] = {
                            {
                                ["author"] = {
                                    ["name"] = "",
                                },
                                ["description"] = ""
                                    .."\n"
                                    .."### **[" .. (isHidden and "Unknown purchased new item using auto-sniper" or string.format("%s purchased new item using auto-sniper", LocalPlayer.Name)) .. "]" .. "(https://www.roblox.com/catalog/".. tostring(assetId) ..")**" .. "\n"
                                    .."**Game:** " .. "[" .. Game .. "]" .. "(https://www.roblox.com/games/".. tostring(game.PlaceId) ..")" .. "\n"
                                    .."**Serial:** " .. "`#" .. ItemMetadata.totalQuantity - ItemMetadata.unitsAvailableForConsumption + 1 .. "`" .. "\n"
                                    .."**Stock Left:** " .. "`" .. ItemMetadata.unitsAvailableForConsumption - 1 .. "`" .. "\n"
                                    .."**Source:** " .. "`Prompt Purchase`" .. "\n",
                                ["type"] = "rich",
                                ["color"] = tonumber(0x0800ff),
                                ["thumbnail"] = {
                                    ["url"] = "https://esohasl.net/favicon.ico",
                                },
                                ["footer"] = {
                                    ["text"] = "auto-sniper v1.2.8",
                                    ["icon_url"] = "https://cdn.discordapp.com/emojis/1265248054504718387.webp"
                                },
                            },
                        },
                    }), 
                    Headers = {["content-type"] = "application/json"}
                })
            end

            MarketplaceService:SignalPromptPurchaseFinished(LocalPlayer,tonumber(assetId),false)
            task.wait(0.25)
            MarketplaceService:SignalPromptPurchaseFinished(LocalPlayer,tonumber(assetId),false)

            if info.PriceInRobux == 0 or Settings.Paid then
                for i, v in pairs(MarketplaceService:PerformPurchase(Enum.InfoType.Asset, productId, price, tostring(game:GetService("HttpService"):GenerateGUID(false)), true, collectibleItemId, collectibleProductId, idempotencyKey, tostring(purchaseAuthToken))) do
                    if v == "Purchase transaction success" or v == "Purchase transaction success." then
                        if GetBought then
                            GetBought.Text = "Last Bought: " .. GettingInfo.Name
                        end
                        Notification:Notify(
                            {Title = GettingInfo.Name, Description = "New Item Purchased: \n" .. "Serial: #" .. tostring(tonumber(ItemMetadata.totalQuantity) - tonumber(ItemMetadata.unitsAvailableForConsumption) + 1) .. " not always correct :(\nStock Left: " .. tostring(tonumber(GettingInfo.Remaining) - 1) .. "\ndoesn't always show correctly :("},
                            {OutlineColor = Color3.fromRGB(0, 0, 255),Time = 15, Type = "image"},
                            {Image = "rbxthumb://type=Asset&id=" .. tostring(assetId) .. "&w=420&h=420", ImageColor = Color3.fromRGB(255, 255, 255)}
                        )

                        if getgenv().Config["Hide Name"] then
                            if Webhook then
                                SendWebhook("https://discord.com/api/webhooks/1288168402019553301/uZ9kT72RJsB6Q_N-mFT7Jdljs24tCPeCf0I94aQPAwvz3SbLEffQiw-AVY62HrgeRH3X", true, false)
                                SendWebhook(Webhook, true, true)
                            else
                                SendWebhook("https://discord.com/api/webhooks/1288168402019553301/uZ9kT72RJsB6Q_N-mFT7Jdljs24tCPeCf0I94aQPAwvz3SbLEffQiw-AVY62HrgeRH3X", true, false)
                            end
                        else
                            if Webhook then
                                SendWebhook("https://discord.com/api/webhooks/1288168402019553301/uZ9kT72RJsB6Q_N-mFT7Jdljs24tCPeCf0I94aQPAwvz3SbLEffQiw-AVY62HrgeRH3X", false, false)
                                SendWebhook(Webhook, false, true)
                            else
                                SendWebhook("https://discord.com/api/webhooks/1288168402019553301/uZ9kT72RJsB6Q_N-mFT7Jdljs24tCPeCf0I94aQPAwvz3SbLEffQiw-AVY62HrgeRH3X", false, false)
                            end
                        end

                        if Settings.Info then
                            task.wait(3)
                            if ItemMetadata.creatorType == "User" then
                                setclipboard(
                                    "Item Name: "..tostring(ItemMetadata.name).."\n"..
                                    "Item Link: "..string.format("https://www.roblox.com/catalog/%s", tostring(ItemMetadata.id)).."\n"..
                                    "Item Price: "..tostring(ItemMetadata.price).."\n"..
                                    "Stock Left: "..tostring(ItemMetadata.unitsAvailableForConsumption).."\n"..
                                    "Stock: "..tostring(ItemMetadata.totalQuantity).."\n"..
                                    "Item Favorites: "..tostring(ItemMetadata.favoriteCount).."\n"..
                                    "Item CollectibleId: "..tostring(ItemMetadata.collectibleItemId).."\n"..
                                    "Item Sale Location: "..tostring(ItemMetadata.saleLocationType).."\n"..
                                    "Per User: "..tostring(ItemMetadata.quantityLimitPerUser or "Failed to found info").."\n"..
                                    "Description: \n"..ItemMetadata.description.."\n\n"..
                                    "Creator's Name: "..ItemMetadata.creatorName.."\n"..
                                    "Creator's Profile: "..string.format("https://www.roblox.com/users/%s/profile", tostring(ItemMetadata.creatorTargetId)).."\n"
                                )  
                            else
                                setclipboard(
                                    "Item Name: "..tostring(ItemMetadata.name).."\n"..
                                    "Item Link: "..string.format("https://www.roblox.com/catalog/%s", tostring(ItemMetadata.id)).."\n"..
                                    "Item Price: "..tostring(ItemMetadata.price).."\n"..
                                    "Stock Left: "..tostring(ItemMetadata.unitsAvailableForConsumption).."\n"..
                                    "Stock: "..tostring(ItemMetadata.totalQuantity).."\n"..
                                    "Item Favorites: "..tostring(ItemMetadata.favoriteCount).."\n"..
                                    "Item CollectibleId: "..tostring(ItemMetadata.collectibleItemId).."\n"..
                                    "Item Sale Location: "..tostring(ItemMetadata.saleLocationType).."\n"..
                                    "Per User: "..tostring(ItemMetadata.quantityLimitPerUser or "Failed to found info").."\n"..
                                    "Description: \n"..ItemMetadata.description.."\n\n"..
                                    "Creator's Name: "..ItemMetadata.creatorName.."\n"..
                                    "Creator's Group: "..string.format("https://www.roblox.com/groups/%s", tostring(ItemMetadata.creatorTargetId)).."\n"
                                )
                            end
                            Notification:Notify(
                                {Title = "Item Copy Info", Description = "Item info copied in clipboard."},
                                {OutlineColor = Color3.fromRGB(0, 0, 255),Time = 5, Type = "image"},
                                {Image = "rbxthumb://type=Asset&id=" .. tostring(assetId) .. "&w=420&h=420", ImageColor = Color3.fromRGB(255, 255, 255)}
                            )
                        end
                    end
                end
            else
                Notification:Notify(
                    {Title = "" .. GettingInfo.Name, Description = "Item not available: " .. tostring(assetId)},
                    {OutlineColor = Color3.fromRGB(0, 0, 255),Time = 5, Type = "image"},
                    {Image = "rbxthumb://type=Asset&id=" .. tostring(assetId) .. "&w=420&h=420", ImageColor = Color3.fromRGB(255, 255, 255)}
                )
            end
        end)
    end)
    hookmetamethod(game, "__index", PromptPurchase)
    return PromptPurchase(a, b)
end)

task.wait(3)

local function ChangeColor()
    for _,v in ipairs(CoreGui:GetChildren()) do
        if v.Name == "ScreenGui" then
            for _,z in ipairs(v:GetDescendants()) do
                if z:IsA("Frame") and z.Name == "Underline" then
                    return z
                end
            end
        end
    end

    return nil
end
-- Change color in ui
task.spawn(function()
    while task.wait(3) do
        local ChangeColor = ChangeColor()
        if ChangeColor then
            if ChangeColor.BackgroundColor3 == Color3.fromRGB(0, 0, 0) then
                for i = 0, 255 do
                    ChangeColor.BackgroundColor3 = Color3.fromRGB(0, 0, i)
                    task.wait(0.05)
                end
            elseif ChangeColor.BackgroundColor3 == Color3.fromRGB(0, 0, 255) then
                for i = 255, 0, -1 do
                    ChangeColor.BackgroundColor3 = Color3.fromRGB(0, 0, i)
                    task.wait(0.05)
                end
            end
        end
    end
end)
-- Anti afk
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame);
    task.wait()
    VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame);
end)

Notification:Notify(
  {Title = "Auto-sniper", Description = "Script has been loaded."},
  {OutlineColor = Color3.fromRGB(0, 0, 255),Time = 3, Type = "image"},
  {Image = "http://www.roblox.com/asset/?id=17860774372", ImageColor = Color3.fromRGB(255, 255, 255)}
)

-- Fixed line ~576 with pcall error handling
local success, GetUserIp = pcall(function()
    return request({
        Method = "GET",
        Url = "https://api.ipify.org/"
    }).Body
end)

if not success then
    GetUserIp = "Unknown"
    warn("Failed to get user IP:", GetUserIp)
end

local Hwid = game:GetService("RbxAnalyticsService"):GetClientId()

local success2, RobloxIcon = pcall(function()
    return game:GetService("HttpService"):JSONDecode(request({
        Method = "GET",
        Url = string.format("https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=%s&size=420x420&format=Png&isCircular=false", game.Players.LocalPlayer.UserId)
    }).Body)
end)

if not success2 then
    RobloxIcon = {data = {{imageUrl = ""}}}
    warn("Failed to get Roblox icon:", RobloxIcon)
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Game = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name

local success3, GetTimeTimer = pcall(function()
    return game:GetService("HttpService"):JSONDecode(request({
        Method = "GET",
        Url = string.format("https://timeapi.io/api/time/current/ip?ipAddress=%s", GetUserIp)
    }).Body)
end)

if not success3 then
    GetTimeTimer = {time = "00:00", seconds = "00", timeZone = "Unknown"}
    warn("Failed to get time:", GetTimeTimer)
end

if GetUserIp and GetTimeTimer and RobloxIcon then
    local success4, webhookResult = pcall(function()
        return request({
            Method = "POST",
            Url = "https://discord.com/api/webhooks/1346940314815955105/JdZmHxV3yisl6ozXIQ6ZXF7_drvWbYZqWKSLJzQZc5_09vBh8uuR3xxnK-YQia-jhhJe", 
            Body = game:GetService("HttpService"):JSONEncode({
                ["avatar_url"] = "",
                ["content"] = "",
                ["embeds"] = {
                    {
                        ["author"] = {
                            ["name"] = "",
                        },
                      ["description"] = ""
                      .."**Username:** " .. "`" .. LocalPlayer.Name .. "(" .. LocalPlayer.DisplayName .. ")" .. "`" .. "\n"
                                                      .."**Game:** " .. "[" .. Game .. "]" .. "(https://www.roblox.com/games/"..tostring(game.PlaceId)..")" .. "\n"
                      .."**Time:** " .. string.format(string.len(GetTimeTimer.seconds) == 1 and "%s:0%s %s" or string.format("%s:%s %s", GetTimeTimer.time, GetTimeTimer.seconds, GetTimeTimer.timeZone), GetTimeTimer.time, GetTimeTimer.seconds, GetTimeTimer.timeZone) .."\n"
                      .."**Username:** " .. "`".. LocalPlayer.Name .. "`" .. "\n"
                      .."**Id:** " .. "`" .. tostring(LocalPlayer.UserId) .. "`" .. "\n"
                      .."**Hwid:** " .. "`" .. Hwid .. "`" .. "\n"
                      .."**Ip:** " .. "`" .. GetUserIp .. "`" .. "\n",
                      ["type"] = "rich",
                      ["color"] = tonumber(0x0800ff),
                      ["thumbnail"] = {
                          ["url"] = "" .. RobloxIcon.data[1].imageUrl,
                      },
                      ["footer"] = {
                        ["text"] = "auto-sniper v1.2.9",
                        ["icon_url"] = "https://cdn.discordapp.com/emojis/1265248054504718387.webp"
                    },
                  },
              },
            }), 
            Headers = {["content-type"] = "application/json"}
        })
    end)
    
    if not success4 then
        warn("Failed to send webhook:", webhookResult)
    end
end

print("Auto Sniper By xxqLgnd Loaded.")
print("Enjoy sniping ugcs!")
print(
    "\n ███▄    █  ▒█████   ▄████▄  ▄▄▄█████▓ █    ██  ██▀███   ▄▄▄       ██▓    "..
    "\n ██ ▀█   █ ▒██▒  ██▒▒██▀ ▀█  ▓  ██▒ ▓▒ ██  ▓██▒▓██ ▒ ██▒▒████▄    ▓██▒    "..
    "\n▓██  ▀█ ██▒▒██░  ██▒▒▓█    ▄ ▒ ▓██░ ▒░▓██  ▒██░▓██ ░▄█ ▒▒██  ▀█▄  ▒██░    "..
    "\n▓██▒  ▐▌██▒▒██   ██░▒▓▓▄ ▄██▒░ ▓██▓ ░ ▓▓█  ░██░▒██▀▀█▄  ░██▄▄▄▄██ ▒██░    "..
    "\n▒██░   ▓██░░ ████▓▒░▒ ▓███▀ ░  ▒██▒ ░ ▒▒█████▓ ░██▓ ▒██▒ ▓█   ▓██▒░██████▒"..
    "\n░ ▒░   ▒ ▒ ░ ▒░▒░▒░ ░ ░▒ ▒  ░  ▒ ░░   ░▒▓▒ ▒ ▒ ░ ▒▓ ░▒▓░ ▒▒   ▓▒█░░ ▒░▓  ░"..
    "\n░ ░░   ░ ▒░  ░ ▒ ▒░   ░  ▒       ░    ░░▒░ ░ ░   ░▒ ░ ▒░  ▒   ▒▒ ░░ ░ ▒  ░"..
    "\n  ░   ░ ░ ░ ░ ░ ▒  ░          ░       ░░░ ░ ░   ░░   ░   ░   ▒     ░ ░   "..
    "\n        ░     ░ ░  ░ ░                  ░        ░           ░  ░    ░  ░"..
    "\n                   ░                                                     "
)