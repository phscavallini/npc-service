local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

for _, v in pairs(ServerStorage.Source.Services:GetDescendants()) do
    if not v:IsA("ModuleScript") or not v.Name:match("Service$") then
        continue
    end
    require(v)
end

Knit.Start():andThen(function()
    print("Knit started")
end):catch(warn)