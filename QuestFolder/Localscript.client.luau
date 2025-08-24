local player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local QuestModule = require(ReplicatedStorage:WaitForChild("QuestSystem"))
local QuestProgress = require(ReplicatedStorage:WaitForChild("QuestProgress"))

local KillQuestFrame = script.Parent -- assuming the LocalScript is parented under the QuestFrame
local ConfirmButton = KillQuestFrame:WaitForChild("AcceptButton")
local DeclineButton = KillQuestFrame:WaitForChild("DeclineButton")
local CloseButton = KillQuestFrame:WaitForChild("CloseButton")
local EnemyFolder = workspace:WaitForChild("EnemyType") 

ConfirmButton.MouseButton1Click:Connect(function()
    if QuestModule:GetCurrentQuest(player) then
        print("You have already accepted a quest!")
        return
    end

    KillQuestFrame.Visible = false
    QuestModule:Start(player, "KillQuest1")
    print("Quest Accepted: Kill 5 Goblins")

    for _, enemy in pairs(EnemyFolder:GetChildren()) do
        if enemy:IsA("Model") and enemy:FindFirstChild("Humanoid") then
            local humanoid = enemy.Humanoid
            humanoid.Died:Connect(function()
                QuestProgress.AddKill(player, enemy.Name)
            end)
        end
    end
end)

DeclineButton.MouseButton1Click:Connect(function()
    KillQuestFrame.Visible = false
    print("Quest Declined")
end)

CloseButton.MouseButton1Click:Connect(function()
    KillQuestFrame.Visible = false
end)
