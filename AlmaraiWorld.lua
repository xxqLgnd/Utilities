--xxqLgnd
local ReplicatedStorage = game:GetService("ReplicatedStorage")

for _,v in ipairs({"Milk", "Strawberry", "Apple", "Raspberry"}) do
    ReplicatedStorage.BridgeNet2.dataRemoteEvent:FireServer({{ReplicatedStorage.Truck_Fruit_Strawberry_Nivel03, 50, 10000, "Milk"}, utf8.char(5)})
end
