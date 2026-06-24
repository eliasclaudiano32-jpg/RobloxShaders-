-- Speed Script | Anti-Shift Travado no 9
-- Pressione Q para ativar/desativar
-- Compatível com Xeno Executor

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local speedAtivado = false
local VELOCIDADE = 9
local loop

-- Bloqueia o Shift Lock e Sprint do Brookhaven
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
        if speedAtivado then
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = VELOCIDADE
                end
            end
        end
    end

    if input.KeyCode == Enum.KeyCode.Q then
        speedAtivado = not speedAtivado

        if speedAtivado then
            print("[Speed] ✅ Ativado e travado no " .. VELOCIDADE)
            loop = RunService.Heartbeat:Connect(function()
                local character = player.Character
                if character then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.WalkSpeed = VELOCIDADE
                        humanoid:SetAttribute("SprintSpeed", nil)
                        humanoid:SetAttribute("Sprint", false)
                    end
                end
            end)
        else
            print("[Speed] ❌ Desativado!")
            if loop then
                loop:Disconnect()
                loop = nil
            end
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = 16
                end
            end
        end
    end
end)

print("[Speed] 🔄 Carregado! Pressione Q para ativar/desativar.")
