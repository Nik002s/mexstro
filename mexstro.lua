-- Orion UI Library (იდეალურია მობილურებისთვის)
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({
    Name = "MEXSTRO | Knife Duels",
    HidePremium = true,
    SaveConfig = false,
    ConfigFolder = "MexstroConfig"
})

-- Variables & Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

local AimbotEnabled = false
local AimFOV = 120
local AimBone = "Head"
local Smoothness = 0.2

local ChamsEnabled = false
local ChamsColor = Color3.fromRGB(255, 0, 85)

-- FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.Color = Color3.fromRGB(180, 100, 255)
FOVCircle.Filled = false
FOVCircle.Transparency = 1
FOVCircle.Visible = false

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Radius = AimFOV
end)

local function GetClosestTarget()
    local Closest = nil
    local MaxDistance = AimFOV

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local TargetPart = v.Character:FindFirstChild(AimBone)
            if TargetPart then
                local ScreenPos, OnScreen = Camera:WorldToViewportPoint(TargetPart.Position)
                if OnScreen then
                    local MousePos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                    local Distance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - MousePos).Magnitude
                    
                    if Distance < MaxDistance then
                        MaxDistance = Distance
                        Closest = TargetPart
                    end
                end
            end
        end
    end
    return Closest
end

RunService.RenderStepped:Connect(function()
    if AimbotEnabled then
        local Target = GetClosestTarget()
        if Target then
            local CurrentCF = Camera.CFrame
            local TargetCF = CFrame.new(Camera.CFrame.Position, Target.Position)
            Camera.CFrame = CurrentCF:Lerp(TargetCF, Smoothness)
        end
    end
end)

-- TABS
local CombatTab = Window:MakeTab({
    Name = "Combat (Aimbot)",
    Icon = "rbxassetid://4483362458",
    PremiumOnly = false
})

local VisualsTab = Window:MakeTab({
    Name = "Visuals (ESP)",
    Icon = "rbxassetid://4483362458",
    PremiumOnly = false
})

-- COMBAT TAB
CombatTab:AddSection({ Name = "Aimbot Settings" })

CombatTab:AddToggle({
    Name = "Enable Aimbot",
    Default = false,
    Callback = function(Value)
        AimbotEnabled = Value
    end    
})

CombatTab:AddToggle({
    Name = "Show FOV Circle",
    Default = false,
    Callback = function(Value)
        FOVCircle.Visible = Value
    end    
})

CombatTab:AddSlider({
    Name = "Aimbot FOV",
    Min = 50,
    Max = 190,
    Default = 120,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "px",
    Callback = function(Value)
        AimFOV = Value
    end    
})

CombatTab:AddDropdown({
    Name = "Target Bone",
    Default = "Head",
    Options = {"Head", "HumanoidRootPart"},
    Callback = function(Value)
        AimBone = Value
    end
})

-- VISUALS TAB
VisualsTab:AddSection({ Name = "Chams ESP" })

VisualsTab:AddToggle({
    Name = "Enable Chams ESP",
    Default = false,
    Callback = function(Value)
        ChamsEnabled = Value
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character then
                if Value then
                    local Highlight = v.Character:FindFirstChild("MEXSTRO_Chams") or Instance.new("Highlight")
                    Highlight.Name = "MEXSTRO_Chams"
                    Highlight.Parent = v.Character
                    Highlight.FillColor = ChamsColor
                    Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    Highlight.FillTransparency = 0.5
                    Highlight.OutlineTransparency = 0
                else
                    if v.Character:FindFirstChild("MEXSTRO_Chams") then
                        v.Character.MEXSTRO_Chams:Destroy()
                    end
                end
            end
        end
    end    
})

VisualsTab:AddColorpicker({
    Name = "Chams Color",
    Default = Color3.fromRGB(255, 0, 85),
    Callback = function(Value)
        ChamsColor = Value
        if ChamsEnabled then
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("MEXSTRO_Chams") then
                    v.Character.MEXSTRO_Chams.FillColor = Value
                end
            end
        end
    end
})

OrionLib:Init()
