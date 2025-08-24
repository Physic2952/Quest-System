local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local QuestModule = require(ReplicatedStorage:WaitForChild("QuestSystem"))

local AllQuests = {
    QuestModule.new("KillQuest1", "Kill 5 Goblins", "Defeat 5 goblins in the forest", {Gold = 100, XP = 50}, "Goblin", 5),
}

Players.PlayerAdded:Connect(function(player)
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player

    local Gold = Instance.new("IntValue")
    Gold.Name = "Gold"
    Gold.Value = 0
    Gold.Parent = leaderstats

    local XP = Instance.new("IntValue")
    XP.Name = "XP"
    XP.Value = 0
    XP.Parent = leaderstats

    if not player:GetAttribute("CurrentQuest") then
        player:SetAttribute("CurrentQuest", nil)
    end
end)

local function CreateQuestGui(player)
    local playerGui = player:WaitForChild("PlayerGui")
    local QuestFrame = playerGui:WaitForChild("QuestFrame")

    local RandomQuest = AllQuests[math.random(1, #AllQuests)]
    local RandomQuestId = RandomQuest.Id

    local RandomQuestFrame = QuestFrame:FindFirstChild(RandomQuestId)
    if RandomQuestFrame then
        RandomQuestFrame.Visible = true
    end
end

task.spawn(function()
    while true do
        task.wait(60)
        for _, player in pairs(Players:GetPlayers()) do
            if QuestModule:AllQuestsIngame(player) <= 6 then
                CreateQuestGui(player)
            end
        end
    end
end)
