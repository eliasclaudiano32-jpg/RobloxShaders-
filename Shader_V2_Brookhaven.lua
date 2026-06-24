-- Advanced Shader Script | Brookhaven Optimized
-- Compatível com Xeno Executor
-- Versão 2.0 - Terrain + Lighting Focus

local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Terrain = workspace.Terrain

-- =============================================
-- CONFIGURAÇÕES
-- =============================================
local Config = {
    -- Dia
    DayBrightness = 3.8,
    DayAmbient = Color3.fromRGB(140, 135, 145),
    DayOutdoor = Color3.fromRGB(160, 155, 150),
    DayTint = Color3.fromRGB(255, 245, 225),
    DaySaturation = 0.35,
    DayContrast = 0.15,

    -- Noite
    NightBrightness = 0.4,
    NightAmbient = Color3.fromRGB(55, 60, 90),
    NightOutdoor = Color3.fromRGB(40, 45, 80),
    NightTint = Color3.fromRGB(170, 180, 220),
    NightSaturation = 0.08,
    NightContrast = 0.10,

    -- Terrain
    WaterColor = Color3.fromRGB(50, 155, 215),
    GrassColor = Color3.fromRGB(85, 125, 60),
    DirtColor = Color3.fromRGB(108, 80, 52),
    SandColor = Color3.fromRGB(195, 175, 130),
    RockColor = Color3.fromRGB(110, 105, 100),
    AsphaltColor = Color3.fromRGB(48, 44, 42),

    -- Postes/Luzes
    LampBrightness = 6,
    LampRange = 22,
    LampColor = Color3.fromRGB(255, 195, 95),
    HouseLightColor = Color3.fromRGB(255, 220, 150),
    HouseLightBrightness = 4,
    HouseLightRange = 14,
}

-- =============================================
-- LIMPAR EFEITOS ANTERIORES
-- =============================================
local function CleanLighting()
    for _, v in ipairs(Lighting:GetChildren()) do
        if v:IsA("PostEffect") or v:IsA("Atmosphere") or v:IsA("Sky") then
            v:Destroy()
        end
    end
end

-- =============================================
-- CONFIGURAR EFEITOS DE LIGHTING
-- =============================================
local bloom, cc, sunRays, atmosphere, dof

local function SetupEffects()
    CleanLighting()

    atmosphere = Instance.new("Atmosphere")
    atmosphere.Density = 0.32
    atmosphere.Offset = 0.08
    atmosphere.Color = Color3.fromRGB(175, 200, 255)
    atmosphere.Decay = Color3.fromRGB(95, 115, 165)
    atmosphere.Glare = 0.45
    atmosphere.Haze = 1.8
    atmosphere.Parent = Lighting

    bloom = Instance.new("BloomEffect")
    bloom.Intensity = 0.65
    bloom.Size = 26
    bloom.Threshold = 0.92
    bloom.Parent = Lighting

    cc = Instance.new("ColorCorrectionEffect")
    cc.Brightness = 0.05
    cc.Contrast = 0.15
    cc.Saturation = 0.35
    cc.TintColor = Config.DayTint
    cc.Parent = Lighting

    sunRays = Instance.new("SunRaysEffect")
    sunRays.Intensity = 0.14
    sunRays.Spread = 0.65
    sunRays.Parent = Lighting

    dof = Instance.new("DepthOfFieldEffect")
    dof.FarIntensity = 0.08
    dof.NearIntensity = 0.04
    dof.FocusDistance = 70
    dof.InFocusRadius = 50
    dof.Parent = Lighting

    Lighting.GlobalShadows = true
    Lighting.ShadowSoftness = 0.3
    Lighting.FogEnd = 900
    Lighting.FogStart = 300
    Lighting.FogColor = Color3.fromRGB(175, 190, 215)
end

-- =============================================
-- TERRAIN DO BROOKHAVEN
-- =============================================
local function SetupTerrain()
    Terrain:SetMaterialColor(Enum.TerrainMaterial.Water, Config.WaterColor)
    Terrain:SetMaterialColor(Enum.TerrainMaterial.Grass, Config.GrassColor)
    Terrain:SetMaterialColor(Enum.TerrainMaterial.LeafyGrass, Color3.fromRGB(75, 118, 52))
    Terrain:SetMaterialColor(Enum.TerrainMaterial.SmoothPlastic, Color3.fromRGB(70, 115, 50))
    Terrain:SetMaterialColor(Enum.TerrainMaterial.Ground, Config.DirtColor)
    Terrain:SetMaterialColor(Enum.TerrainMaterial.Mud, Color3.fromRGB(90, 65, 42))
    Terrain:SetMaterialColor(Enum.TerrainMaterial.Sandstone, Color3.fromRGB(160, 125, 80))
    Terrain:SetMaterialColor(Enum.TerrainMaterial.Sand, Config.SandColor)
    Terrain:SetMaterialColor(Enum.TerrainMaterial.Rock, Config.RockColor)
    Terrain:SetMaterialColor(Enum.TerrainMaterial.Limestone, Color3.fromRGB(190, 180, 160))
    Terrain:SetMaterialColor(Enum.TerrainMaterial.Basalt, Color3.fromRGB(60, 58, 55))
    Terrain:SetMaterialColor(Enum.TerrainMaterial.Cobblestone, Config.AsphaltColor)
    Terrain:SetMaterialColor(Enum.TerrainMaterial.Snow, Color3.fromRGB(235, 242, 255))

    print("[Shader] ✅ Terrain do Brookhaven configurado!")
end

-- =============================================
-- PEÇAS DO MAPA (BaseParts)
-- =============================================
local function ApplyToPart(obj)
    if not (obj:IsA("BasePart") or obj:IsA("MeshPart") or obj:IsA("UnionOperation")) then return end

    local name = obj.Name:lower()
    local mat = obj.Material

    if mat == Enum.Material.Asphalt
        or mat == Enum.Material.Cobblestone
        or name:find("road") or name:find("street")
        or name:find("asphalt") or name:find("pavement")
        or name:find("sidewalk") or name:find("calcada") then
        obj.Color = Config.AsphaltColor
        obj.Reflectance = 0.04

    elseif mat == Enum.Material.Water
        or name:find("water") or name:find("agua")
        or name:find("lake") or name:find("river") or name:find("sea") then
        obj.Color = Config.WaterColor
        obj.Transparency = 0.28
        obj.Reflectance = 0.45
        obj.CastShadow = false

    elseif mat == Enum.Material.Ground or mat == Enum.Material.Mud
        or name:find("dirt") or name:find("terra") or name:find("ground") then
        obj.Color = Config.DirtColor
        obj.Reflectance = 0.0

    elseif mat == Enum.Material.Grass or mat == Enum.Material.LeafyGrass
        or name:find("leaf") or name:find("tree") or name:find("bush")
        or name:find("arvore") or name:find("folha") or name:find("planta") then
        obj.Color = Config.GrassColor
        obj.Reflectance = 0.0

    elseif name:find("lamp") or name:find("poste") or name:find("streetlight")
        or name:find("lantern") or name:find("lightpost") then
        local pl = obj:FindFirstChildOfClass("PointLight")
            or Instance.new("PointLight", obj)
        pl.Brightness = Config.LampBrightness
        pl.Range = Config.LampRange
        pl.Color = Config.LampColor
        pl.Shadows = true

    elseif name:find("houselight") or name:find("roomlight")
        or name:find("ceiling") or name:find("indoor") or name:find("bulb") then
        local pl = obj:FindFirstChildOfClass("PointLight")
            or Instance.new("PointLight", obj)
        pl.Brightness = Config.HouseLightBrightness
        pl.Range = Config.HouseLightRange
        pl.Color = Config.HouseLightColor
        pl.Shadows = true
    end
end

local function ApplyAllParts()
    for _, obj in ipairs(workspace:GetDescendants()) do
        ApplyToPart(obj)
    end
    print("[Shader] ✅ Peças do mapa configuradas!")
end

-- =============================================
-- DIA / NOITE DINÂMICO
-- =============================================
local function UpdateDayNight()
    if not cc then return end

    local hour = Lighting.ClockTime

    if (hour >= 5 and hour < 7) or (hour >= 17 and hour < 19) then
        Lighting.Brightness = 2.0
        Lighting.Ambient = Color3.fromRGB(120, 90, 70)
        Lighting.OutdoorAmbient = Color3.fromRGB(200, 130, 80)
        Lighting.ColorShift_Top = Color3.fromRGB(255, 160, 80)
        Lighting.ColorShift_Bottom = Color3.fromRGB(150, 80, 50)
        cc.Saturation = 0.45
        cc.Brightness = 0.06
        cc.TintColor = Color3.fromRGB(255, 210, 160)
        if atmosphere then
            atmosphere.Glare = 0.8
            atmosphere.Haze = 2.5
        end

    elseif hour >= 7 and hour < 17 then
        Lighting.Brightness = Config.DayBrightness
        Lighting.Ambient = Config.DayAmbient
        Lighting.OutdoorAmbient = Config.DayOutdoor
        Lighting.ColorShift_Top = Color3.fromRGB(255, 240, 190)
        Lighting.ColorShift_Bottom = Color3.fromRGB(120, 115, 100)
        cc.Saturation = Config.DaySaturation
        cc.Contrast = Config.DayContrast
        cc.Brightness = 0.05
        cc.TintColor = Config.DayTint
        if atmosphere then
            atmosphere.Glare = 0.45
            atmosphere.Haze = 1.8
        end

    else
        Lighting.Brightness = Config.NightBrightness
        Lighting.Ambient = Config.NightAmbient
        Lighting.OutdoorAmbient = Config.NightOutdoor
        Lighting.ColorShift_Top = Color3.fromRGB(18, 22, 58)
        Lighting.ColorShift_Bottom = Color3.fromRGB(10, 12, 38)
        cc.Saturation = Config.NightSaturation
        cc.Contrast = Config.NightContrast
        cc.Brightness = -0.04
        cc.TintColor = Config.NightTint
        if atmosphere then
            atmosphere.Glare = 0.1
            atmosphere.Haze = 0.8
        end
    end
end

-- =============================================
-- ANIMAÇÃO DE ÁGUA
-- =============================================
local waterParts = {}
local function CollectWaterParts()
    waterParts = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local name = obj.Name:lower()
            if name:find("water") or name:find("agua") or name:find("lake")
                or name:find("river") or name:find("sea") or name:find("pool") then
                table.insert(waterParts, obj)
            end
        end
    end
end

local waterTick = 0
local function AnimateWater(dt)
    waterTick += dt
    for _, part in ipairs(waterParts) do
        if part and part.Parent then
            part.Transparency = 0.26 + math.sin(waterTick * 1.1) * 0.07
        end
    end
end

-- =============================================
-- INICIALIZAÇÃO
-- =============================================
print("[Shader] 🔄 Carregando shaders para Brookhaven...")

SetupEffects()
task.wait(1.5)
SetupTerrain()
task.wait(0.5)
ApplyAllParts()
CollectWaterParts()

RunService.Heartbeat:Connect(function(dt)
    UpdateDayNight()
    AnimateWater(dt)
end)

workspace.DescendantAdded:Connect(function(obj)
    task.wait(0.3)
    ApplyToPart(obj)
    if obj:IsA("BasePart") then
        local name = obj.Name:lower()
        if name:find("water") or name:find("agua") or name:find("lake") then
            table.insert(waterParts, obj)
        end
    end
end)

print("[Shader] ✅ Brookhaven Shaders V2 ativado com sucesso!")
