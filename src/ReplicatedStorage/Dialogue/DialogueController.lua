-- services
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
--knit
local Knit = require(ReplicatedStorage.Packages.Knit)

local DialogueController = Knit.CreateController {
    Name = "DialogueController",
}

local TWEEN_INFO = TweenInfo.new (
    .1,
    Enum.EasingStyle.Quint,
    Enum.EasingDirection.In
)

-- assets
local IsChatting = false
local Audio: Sound = ReplicatedStorage.Assets:WaitForChild("talk"):Clone()
Audio.Parent = script

function DialogueController:TypeWriteEffect(Text : string, Target : TextLabel, SpeakVelocity : number)
    local newStr = string.split(Text, '')
    for _, char in pairs(newStr) do
        Target.Text = Target.Text..char
        Audio:Play()
        task.wait(SpeakVelocity)
    end
    task.wait(2)
    Target.Text = ""
end

function DialogueController:SetUiVisibility(Ui : BillboardGui, Value : boolean)
    local OpenAnim = TweenService:Create(Ui, TWEEN_INFO, {Size = UDim2.new(0,200,0,100)})
    local CloseAnim = TweenService:Create(Ui, TWEEN_INFO, {Size = UDim2.fromScale(0,0)})
    local myAnimation: Tween
    if Value == true then
        Ui.Size = UDim2.fromScale(0,0)
        Ui.Enabled = true
        myAnimation = OpenAnim
    else
        myAnimation = CloseAnim
    end
    myAnimation:Play()
    myAnimation.Completed:Connect(function(playbackState)
        if playbackState == Enum.PlaybackState.Completed then
            return
        end
    end)
end

function DialogueController:Speak(Ui : BillboardGui, Config : {})
    for _, text in pairs(Config.Text) do
        self:TypeWriteEffect(text, Ui:WaitForChild("DialogueLabel"), Config.SpeakVelocity)
    end
end

function DialogueController:SpeakListener(Ui : BillboardGui, Config : {})
    if IsChatting == false then
        IsChatting = true
        self:SetUiVisibility(Ui, true)
        self:Speak(Ui, Config)
        self:SetUiVisibility(Ui, false)
        IsChatting = false
    end
end

function DialogueController:KnitStart()
    print("DialogueController initialized")
    local DialogueService = Knit.GetService("DialogueService")
    DialogueService.Speak:Connect(function(Ui : BillboardGui, Config : {})
        self:SpeakListener(Ui, Config)
    end)
end

function DialogueController:KnitInit()
    print("DialogueController initialized")
end

return DialogueController