local Quest = {}
Quest.__index = Quest

function Quest.new(id: string, name: string, description: string, reward: table, target: string, amount: number)
    local self = setmetatable({}, Quest)
    self.Id = id
    self.Name = name
    self.Description = description
    self.Reward = reward or {Gold = 0, XP = 0}
    self.Target = target
    self.Amount = amount or 0
    self.Completed = false
    return self
end

local AllQuests = {
    Quest.new("KillQuest1", "Kill 5 Goblins", "Defeat 5 goblins in the forest", {Gold = 100, XP = 50}, "Goblin", 5),
}

local function GetQuestById(id: string)
    for _, quest in ipairs(AllQuests) do
        if quest.Id == id then
            return quest
        end
    end
    return nil
end

function Quest:GetCurrentQuest(player: Player)
    local CurrentQuestId = player:GetAttribute("CurrentQuest")
    if CurrentQuestId then
        local quest = GetQuestById(CurrentQuestId)
        return quest
    else
        return nil
    end
end

function Quest:Start(player: Player, questId: string)
    local quest = GetQuestById(questId)
    if not quest then return end
    if self:GetCurrentQuest(player) then
        print(player.Name .. " already has a quest!")
        return
    end

    player:SetAttribute("CurrentQuest", questId)
    print("Quest started: " .. quest.Name)
end

function Quest:RewardPlayer(player: Player, questId: string)
    local quest = GetQuestById(questId)
    if not quest then return end

    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then return end

    local Gold = leaderstats:FindFirstChild("Gold")
    local XP = leaderstats:FindFirstChild("XP")

    if Gold then Gold.Value += quest.Reward.Gold end
    if XP then XP.Value += quest.Reward.XP end
end

function Quest:Complete(player: Player, questId: string)
    local quest = GetQuestById(questId)
    if not quest then return end

    quest.Completed = true
    self:RewardPlayer(player, questId)

    local CurrentQuestId = player:GetAttribute("CurrentQuest")
    if CurrentQuestId == questId then
        player:SetAttribute("CurrentQuest", nil)
    end

    print("Quest completed: " .. quest.Name)
end

function Quest:AllQuestsIngame(player: Player)
    if self:GetCurrentQuest(player) then
        return 1
    else
        return 0
    end
end

return Quest
