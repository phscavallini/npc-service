local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local DialogueController = Knit.CreateController {
    Name = "DialogueController"
}

function DialogueController:KnitStart()
    print("DialogueController initialized")
end

function DialogueController:KnitInit()
    print("DialogueController initialized")
end

return DialogueController