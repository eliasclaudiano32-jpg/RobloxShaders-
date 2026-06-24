-- Speed Script | Travado no 9
-- Pressione Q para ativar/desativar
-- Compatível com Xeno Executor

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local speedAtivado = false
local VELOCIDADE = 9

local loop

local function Setup()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end

        if input.KeyCode == Enum.KeyCode.Q then
            speedAtivado = not speedAtivado

            if speedAtivado then
                print("[Speed] ✅ Speed ativado! WalkSpeed: " .. VELOCIDADE)
                -- Loop que força o speed travado
                loop = RunService.Heartbeat:Connect(function()
                    if humanoid and humanoid.Parent then
                        humanoid.WalkSpeed = VELOCIDADE
                    end
                end)
            else
                print("[Speed] ❌ Speed desativado!")
                if loop then
                    loop:Disconnect()
                    loop = nil
                end
                humanoid.WalkSpeed = 16
            end
        end
    end)

    player.CharacterAdded:Connect(function(newCharacter)
        local newHumanoid = newCharacter:WaitForChild("Humanoid")
        if loop then loop:Disconnect() loop = nil end
        if speedAtivado then
            loop = RunService.Heartbeat:Connect(function()
                if newHumanoid and newHumanoid.Parent then
                    newHumanoid.WalkSpeed = VELOCIDADE
                end
            end)
        end
    end)
end

Setup()
print("[Speed] 🔄 Script carregado! Pressione Q para ativar/desativar.")
