-- general
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Knit = require(ReplicatedStorage.Packages.Knit)

-- service
local NPCService = Knit.CreateService {
    Name = "NPCService",
    Client = {},
    NPCs = {},
}

-- assets
local NPCsFOLDER = Workspace:WaitForChild("NPCs")
local DialogueService = require(script.Parent.Parent.Dialogue.DialogueService)

-- check if a model is a NPC
function NPCService:IsNPC(NPC : Model): boolean
    if (NPC and NPC:FindFirstChildOfClass("Humanoid")) then
        return true
    end
    return false
end

-- add a NPC to the self.NPCs table
function NPCService:Setup(NPC : Model): table
    if (self:IsNPC(NPC)) then
        self.NPCs[NPC.Name] = NPC
    end
    return self.NPCs
end

function NPCService:AnimateNPCs()
    for _, NPC in pairs(self.NPCs) do
        if not NPC:WaitForChild("Animations") then -- if it cant find the animations folder then
            return false
        end
        local AnimFolder: Folder = NPC:WaitForChild("Animations")
        local Humanoid: Humanoid = NPC:FindFirstChildOfClass("Humanoid")
        local Anim = Humanoid:LoadAnimation(AnimFolder:WaitForChild("Animation1"))
        return Anim:Play()
    end
end

function NPCService:KnitStart()
    print("NPCService started")
    for _, NPC in pairs(NPCsFOLDER:GetChildren()) do
        self:Setup(NPC)
        DialogueService:CreatePrompt(NPC)
    end
    self:AnimateNPCs()
    print(self.NPCs)
end

function NPCService:KnitInit()
    print("NPCService initialized")
end

return NPCService