-- general
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Knit = require(ReplicatedStorage.Packages.Knit)

-- tween info
local Info = TweenInfo.new (
    .1,
    Enum.EasingStyle.Quint,
    Enum.EasingDirection.In
)

local LookInfo = TweenInfo.new (
    .3,
    Enum.EasingStyle.Quint,
    Enum.EasingDirection.Out
)

local DialogueConfig = require(script.Parent.DialogueConfig)

local DialogueService = Knit.CreateService {
    Name = "DialogueService",
    Client = {
        --MySignal = Knit.CreateSignal(); will use in the future
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
    -- audio
    local TalkAudio: Sound = Head:WaitForChild("talk")
    -- prompt manipulation
    Prompt.ObjectText = NPC.Name
    Prompt.ActionText = "Talk"
    Prompt.Triggered:Connect(function(PLR : Player)
        if (IsChatting == false) then
            IsChatting = true
            self:PopUp(LocalUi, true)
            self:LookAtPlayer(NPC, PLR)
            for index, text in pairs(DialogueConfig.Text) do
                if typeof(text) ~= 'string' then
                    continue
                end
                if index == 1 then
                    self:TypeWriteEffect(text.." "..PLR.Name, LocalUi:FindFirstChildOfClass("TextLabel"), TalkAudio)
                else
                    self:TypeWriteEffect(text, LocalUi:FindFirstChildOfClass("TextLabel"), TalkAudio)
                end
            end
            IsChatting = false
            self:PopUp(LocalUi, false)
        end
    end)
end

function DialogueService:LookAtPlayer(NPC : Model, PLR : Player) -- this function will make the npc look at the player who triggered the prompt
    local LookAnim = TweenService:Create (
        NPC.HumanoidRootPart,
        LookInfo,
        {CFrame = CFrame.lookAt(NPC.HumanoidRootPart.Position, PLR.Character.HumanoidRootPart.Position)}
    )
    return LookAnim:Play() -- returns the animation
end

-- this function determines if the text ui will pop up or be hidden, it is passed by the param "Value"
function DialogueService:PopUp(LocalUi : BillboardGui, Value : boolean)
   local ShowAnim = TweenService:Create(LocalUi, Info, {Size = UDim2.new(0,200,0,100)})
   local HideAnim = TweenService:Create(LocalUi, Info, {Size = UDim2.fromScale(0,0)})
   if Value then -- if value is true then (shows ui)
      LocalUi.Enabled = true
      LocalUi.Size = UDim2.fromScale(.5,.5)
      ShowAnim:Play()
      ShowAnim.Completed:Wait()
   else -- if it's false (hide ui)
      HideAnim:Play()
      HideAnim.Completed:Wait()
      LocalUi.Enabled = false
   end
   return "completed"
end

-- this functions does the animation of the TextLabel inside the dialogue ui 
function DialogueService:TypeWriteEffect(Text : string, Target : TextLabel, Audio : Sound)
    local newStr = string.split(Text, '')
    for _, char in pairs(newStr) do
        Target.Text = Target.Text..char
        Audio:Play()
        task.wait(DialogueConfig.SpeakVelocity)
    end
    task.wait(2)
    Target.Text = ""
end

function DialogueService:KnitStart()
    print("DialogueService started")
end

function DialogueService:KnitInit()
    print("DialogueService initialized")
end


return DialogueService