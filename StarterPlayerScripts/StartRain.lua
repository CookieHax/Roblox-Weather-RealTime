local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Remote_Events = ReplicatedStorage.Common.Remote_Events

local RainModule = require(script.ScreenRain)
local player = Players.LocalPlayer
local character = player.Character

RainModule:Disable() --Disable rain on start.

Remote_Events.RainAction.OnClientEvent:Connect(function(enabled, settings)
    if enabled == true then
        RainModule:Enable(settings)
    else
        game.Workspace.RainBrick.ParticleEmitter.Enabled = false
        RainModule:Disable()
    end
end)