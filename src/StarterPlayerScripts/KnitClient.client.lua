local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

for _, v in pairs(ReplicatedStorage.Source.Dialogue:GetDescendants()) do
    if not v:IsA("ModuleScript") or not v.Name:match("Controller$") then
        continue
    end
   require(v)
end

Knit.Start():andThen(function()
    print("Knit started")
end):catch(warn)