local ReplicatedStorage = game:GetService("ReplicatedStorage")
local QuestModule = require(ReplicatedStorage:WaitForChild("QuestSystem"))

local QuestProgress = {}
local PlayerQuestProgress = {}

function QuestProgress.AddKill(player: Player, enemyName: string)
    if not player then return end
    PlayerQuestProgress[player.UserId] = PlayerQuestProgress[player.UserId] or {}

    local currentQuest = QuestModule:GetCurrentQuest(player)
    if not currentQuest then return end

    local currentQuestData = currentQuest
    if currentQuestData.Target == enemyName then
        PlayerQuestProgress[player.UserId][currentQuestData.Id] = PlayerQuestProgress[player.UserId][currentQuestData.Id] or 0
        PlayerQuestProgress[player.UserId][currentQuestData.Id] += 1

        if PlayerQuestProgress[player.UserId][currentQuestData.Id] >= currentQuestData.Amount then
            QuestModule:Complete(player, currentQuestData.Id)
            print("Quest Completed: " .. currentQuestData.Name) 
        end
    end
end

return QuestProgress
