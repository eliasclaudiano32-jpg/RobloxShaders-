-- Advanced Shader Script | Roblox Luau
-- Compatível com Xeno Executor

local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- =============================================
-- CONFIGURAÇÕES
-- =============================================
local Config = {
    DayColor = Color3.fromRGB(255, 240, 200),
    NightColor = Color3.fromRGB(30, 40, 80),
    NightAmbient = Color3.fromRGB(60, 65, 90),
    DayAmbient = Color3.fromRGB(130, 130, 140),
    WaterColor = Color3.fromRGB(60, 160, 220),
    WaterTransparency = 0.3,
    AsphaltColor = Color3.fromRGB(45, 42, 40),
    DirtColor = Color3.fromRGB(100, 75, 50),
    TreeColor = Color3.fromRGB(55, 100, 50),
}

-- =============================================
-- LIGHTING BASE
-- =============================================
local function SetupLighting()
    Lighting.Brightness = 3.5
    Lighting.ClockTime = Lighting.ClockTime
    Lighting.FogEnd = 800
    Lighting.FogStart = 200
    Lighting.FogColor = Color3.fromRGB(180, 190, 210)
    Lighting.GlobalShadows = true
    Lighting.ShadowSoftness = 0.35

    for _, effect in ipairs(Lighting:GetChildren()) do
        if effect:IsA("PostEffect") or effect:IsA("Sky") then
            effect:Destroy()
        end
    end

    local atmosphere = Instance.new("Atmosphere")
    atmosphere.Density = 0.35
    atmosphere.Offset = 0.1
    atmosphere.Color = Color3.fromRGB(180, 200, 255)
    atmosphere.Decay = Color3.fromRGB(100, 120, 170)
    atmosphere.Glare = 0.4
    atmosphere.Haze = 1.5
    atmosphere.Parent = Lighting

    local bloom = Instance.new("BloomEffect")
    bloom.Intensity = 0.6
    bloom.Size = 24
    bloom.Threshold = 0.95
    bloom.Parent = Lighting

    local cc = Instance.new("ColorCorrectionEffect")
    cc.Brightness = 0.04
    cc.Contrast = 0.12
    cc.Saturation = 0.25
    cc.TintColor = Color3.fromRGB(255, 248, 235)
    cc.Parent = Lighting

    local dof = Instance.new("DepthOfFieldEffect")
    dof.FarIntensity = 0.1
    dof.NearIntensity = 0.05
    dof.FocusDistance = 60
    dof.InFocusRadius = 40
    dof.Parent = Lighting

    local sunRays = Instance.new("SunRaysEffect")
    sunRays.Intensity = 0.12
    sunRays.Spread = 0.6
    sunRays.Parent = Lighting
end

-- =============================================
-- DIA / NOITE DINÂMICO
-- =============================================
local colorCorrection = nil
local function GetColorCorrection()
    for _, v in ipairs(Lighting:GetChildren()) do
        if v:IsA("ColorCorrectionEffect") then
            colorCorrection = v
            return v
        end
    end
end

local function UpdateTimeOfDay()
    local cc = GetColorCorrection()
    if not cc then return end

    local hour = Lighting.ClockTime

    if hour >= 6 and hour < 18 then
        Lighting.OutdoorAmbient = Config.DayAmbient
        Lighting.Ambient = Config.DayAmbient
        Lighting.ColorShift_Top = Color3.fromRGB(255, 240, 180)
        Lighting.ColorShift_Bottom = Color3.fromRGB(120, 110, 90)
        Lighting.Brightness = 3.5
        cc.Saturation = 0.3
        cc.Brightness = 0.05
        cc.TintColor = Color3.fromRGB(255, 248, 230)
    else
        Lighting.OutdoorAmbient = Config.NightAmbient
        Lighting.Ambient = Config.NightAmbient
        Lighting.ColorShift_Top = Color3.fromRGB(20, 25, 60)
        Lighting.ColorShift_Bottom = Color3.fromRGB(10, 15, 40)
        Lighting.Brightness = 0.5
        cc.Saturation = 0.1
        cc.Brightness = -0.05
        cc.TintColor = Color3.fromRGB(180, 185, 220)
    end
end

-- =============================================
-- MELHORAR MATERIAIS DO MAPA
-- =============================================
local function ApplyMaterials()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("MeshPart") or obj:IsA("UnionOperation") then
            local name = obj.Name:lower()
            local mat = obj.Material

            if mat == Enum.Material.Water or name:find("water") or name:find("agua") then
                obj.Color = Config.WaterColor
                obj.Material = Enum.Material.Glass
                obj.Transparency = Config.WaterTransparency
                obj.Reflectance = 0.4
                obj.CastShadow = false

            elseif mat == Enum.Material.Asphalt or name:find("road") or name:find("asphalt") or name:find("rua") or name:find("estrada") then
                obj.Color = Config.AsphaltColor
                obj.Material = Enum.Material.Cobblestone
                obj.Reflectance = 0.05

            elseif mat == Enum.Material.Ground or mat == Enum.Material.Mud or mat == Enum.Material.Dirt or name:find("dirt") or name:find("terra") or name:find("chao") then
                obj.Color = Config.DirtColor
                obj.Material = Enum.Material.Ground
                obj.Reflectance = 0.0

            elseif mat == Enum.Material.Grass or mat == Enum.Material.LeafyGrass or name:find("tree") or name:find("leaf") or name:find("arvore") or name:find("folha") then
                obj.Color = Config.TreeColor
                obj.Material = Enum.Material.LeafyGrass
                obj.Reflectance = 0.0

            elseif name:find("lamp") or name:find("poste") or name:find("light") or name:find("street") then
                if obj:IsA("BasePart") then
                    local pointLight = obj:FindFirstChildOfClass("PointLight")
                    if not pointLight then
                        pointLight = Instance.new("PointLight")
                        pointLight.Parent = obj
                    end
                    pointLight.Brightness = 5
                    pointLight.Range = 18
                    pointLight.Color = Color3.fromRGB(255, 200, 100)
                    pointLight.Shadows = true
                end
            end
        end
    end
end

-- =============================================
-- ANIMAÇÃO DE ÁGUA
-- =============================================
local waterParts = {}
local function CollectWater()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Material == Enum.Material.Water or obj.Material == Enum.Material.Glass) then
            local name = obj.Name:lower()
            if name:find("water") or name:find("agua") or name:find("rio") or name:find("lake") or name:find("mar") or name:find("sea") then
                table.insert(waterParts, obj)
            end
        end
    end
end

local waterTick = 0
local function AnimateWater(dt)
    waterTick = waterTick + dt
    for _, part in ipairs(waterParts) do
        if part and part.Parent then
            local wave = math.sin(waterTick * 1.2) * 0.08
            part.Transparency = 0.28 + wave
        end
    end
end

-- =============================================
-- INICIALIZAÇÃO
-- =============================================
SetupLighting()
task.wait(1)
ApplyMaterials()
CollectWater()

RunService.Heartbeat:Connect(function(dt)
    UpdateTimeOfDay()
    AnimateWater(dt)
end)

workspace.DescendantAdded:Connect(function(obj)
    task.wait(0.2)
    if obj:IsA("BasePart") then
        ApplyMaterials()
        CollectWater()
    end
end)

print("[Shader] ✅ Script de shaders V1 carregado com sucesso!")
