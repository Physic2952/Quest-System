
local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local Balance = DataStoreService:GetDataStore("BalanceDataStore")

local function SavePlayerData(player: Player)
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then return end

    local GoldValue = leaderstats:FindFirstChild("Gold")
    local XPValue = leaderstats:FindFirstChild("XP")
    local data = {
        Gold = GoldValue and GoldValue.Value or 0,
        XP = XPValue and XPValue.Value or 0
    }

    local success, err = pcall(function()
        Balance:SetAsync(player.UserId, data)
    end)

    if not success then
        warn("Failed to save data for " .. player.Name .. ": " .. tostring(err))
    end
end

local function GetPlayerData(player: Player)
    local success, data = pcall(function()
        return Balance:GetAsync(player.UserId)
    end)

    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then return end

    local GoldValue = leaderstats:FindFirstChild("Gold")
    local XPValue = leaderstats:FindFirstChild("XP")

    if success and data then
        if GoldValue then GoldValue.Value = data.Gold or 0 end
        if XPValue then XPValue.Value = data.XP or 0 end
    else
        if GoldValue then GoldValue.Value = 0 end
        if XPValue then XPValue.Value = 0 end
        print("No data found for " .. player.Name .. ", initializing with default values.")
    end
end

Players.PlayerAdded:Connect(GetPlayerData)
Players.PlayerRemoving:Connect(SavePlayerData)

game:BindToClose(function()
    for _, player in pairs(Players:GetPlayers()) do
        pcall(SavePlayerData, player)
    end
end)

