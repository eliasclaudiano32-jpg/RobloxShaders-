-- Speed Script | Brookhaven
-- Pressione Q para ativar/desativar
-- Compatível com Xeno Executor

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local speedAtivado = false
local VELOCIDADE = 9

local function Setup()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end

        if input.KeyCode == Enum.KeyCode.Q then
            speedAtivado = not speedAtivado

            if speedAtivado then
                humanoid.WalkSpeed = VELOCIDADE
                print("[Speed] ✅ Speed ativado! WalkSpeed: " .. VELOCIDADE)
            else
                humanoid.WalkSpeed = 16
                print("[Speed] ❌ Speed desativado!")
            end
        end
    end)

    player.CharacterAdded:Connect(function(newCharacter)
        local newHumanoid = newCharacter:WaitForChild("Humanoid")
        if speedAtivado then
            newHumanoid.WalkSpeed = VELOCIDADE
        end
    end)
end

Setup()
print("[Speed] 🔄 Script carregado! Pressione Q para ativar/desativar.")
