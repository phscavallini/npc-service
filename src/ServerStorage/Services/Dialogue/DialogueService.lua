-- general
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Knit = require(ReplicatedStorage.Packages.Knit)

-- tween info

local LookInfo = TweenInfo.new (
    .3,
    Enum.EasingStyle.Quint,
    Enum.EasingDirection.Out
)

local DialogueConfig = require(script.Parent.DialogueConfig)

local DialogueService = Knit.CreateService {
    Name = "DialogueService",
    Client = {
        Speak = Knit.CreateSignal();
    },
}

-- assets
local ChatAsset: BillboardGui = ReplicatedStorage.Assets:WaitForChild("DialogueGui")
local IsChatting = false

function DialogueService:CreatePrompt(NPC): ProximityPrompt
    -- NPCs' body parts
    local HRP = NPC:WaitForChild("HumanoidRootPart")
    local Head = NPC:WaitForChild("Head")
    -- system usage
    local Prompt = Instance.new("ProximityPrompt", NPC)
    local LocalUi = ChatAsset:Clone()
    LocalUi.Parent = Head
    LocalUi.Adornee = Head
    -- prompt manipulation
    Prompt.ObjectText = NPC.Name
    Prompt.ActionText = "Talk"
    Prompt.Triggered:Connect(function(PLR : Player)
        self.Client.Speak:Fire(PLR, LocalUi, DialogueConfig)
    end)
end

-- function by server
function DialogueService:LookAtPlayer(NPC : Model, PLR : Player) -- this function will make the npc look at the player who triggered the prompt
    local LookAnim = TweenService:Create (
        NPC.HumanoidRootPart,
        LookInfo,
        {CFrame = CFrame.lookAt(NPC.HumanoidRootPart.Position, PLR.Character.HumanoidRootPart.Position)}
    )
    return LookAnim:Play() -- returns the animation
end

-- this functions does the animation of the TextLabel inside the dialogue ui 
function DialogueService:KnitStart()
    print("DialogueService started")
end

function DialogueService:KnitInit()
    print("DialogueService initialized")
end


return DialogueService