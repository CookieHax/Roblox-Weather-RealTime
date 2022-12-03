local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Remote_Events = ReplicatedStorage.Common.Remote_Events

local RainMod = require(script.ScreenRain)
local player = Players.LocalPlayer
local character = player.Character

RainMod:Disable() --Disable rain on start.

Remote_Events.RainAction.OnClientEvent:Connect(function(enabled, settings)
    if enabled == true then
        RainMod:Enable(settings)
    else
        game.Workspace.RainBrick.ParticleEmitter.Enabled = false
        RainMod:Disable()
    end
end)
