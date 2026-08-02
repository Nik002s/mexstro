-- Rayfield UI Library
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/gen2"))()

local Window = Rayfield:CreateWindow({
    name = "MEXSTRO",
    subtitle = "Knife Duels Script",
    theme = "Amethyst",
    ConfigurationSaving = {
        Enabled = false
    }
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

-- FOV Circle Visual
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.Color = Color3.fromRGB(180, 100, 255)
FOVCircle.Filled = false
FOVCircle.Transparency = 1
FOVCircle.Visible = false

-- FOV Circle Update Loop
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Radius = AimFOV
end)

-- Target Finder
local function GetClosestTarget()
    local Closest = nil
    local MaxDistance = AimFOV

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            -- Team Check (თუ Knife Duels-ში თიმებია)
            if v.Team ~= LocalPlayer.Team or v.Team == nil then
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
    end
    return Closest
end

-- Aimbot Loop
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

-- Chams ESP Manager
local function ApplyChams(v)
    if v ~= LocalPlayer then
        v.CharacterAdded:Connect(function(char)
            task.wait(0.5)
            if ChamsEnabled then
                local Highlight = char:FindFirstChild("MEXSTRO_Chams") or Instance.new("Highlight")
                Highlight.Name = "MEXSTRO_Chams"
                Highlight.Parent = char
                Highlight.FillColor = ChamsColor
                Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                Highlight.FillTransparency = 0.5
                Highlight.OutlineTransparency = 0
            end
        end)
        
        if v.Character then
            if ChamsEnabled then
                local Highlight = v.Character:FindFirstChild("MEXSTRO_Chams") or Instance.new("Highlight")
                Highlight.Name = "MEXSTRO_Chams"
                Highlight.Parent = v.Character
                Highlight.FillColor = ChamsColor
                Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                Highlight.FillTransparency = 0.5
                Highlight.OutlineTransparency = 0
            end
        end
    end
end

for _, v in pairs(Players:GetPlayers()) do
    ApplyChams(v)
end
Players.PlayerAdded:Connect(ApplyChams)

-- UI TABS
local CombatTab = Window:CreateTab("Combat (Aimbot)", 4483362458)
local VisualsTab = Window:CreateTab("Visuals (ESP)", 4483362458)

-- COMBAT TAB ELEMENTS
CombatTab:CreateSection("Aimbot Settings")

CombatTab:CreateToggle({
    Name = "Enable Aimbot",
    CurrentValue = false,
    Flag = "AimbotToggle",
    Callback = function(Value)
        AimbotEnabled = Value
    end,
})

CombatTab:CreateToggle({
    Name = "Show FOV Circle",
    CurrentValue = false,
    Flag = "FOVToggle",
    Callback = function(Value)
        FOVCircle.Visible = Value
    end,
})

CombatTab:CreateSlider({
    Name = "Aimbot FOV",
    Range = {50, 190},
    Increment = 1,
    Suffix = "px",
    CurrentValue = 120,
    Flag = "AOVSlider",
    Callback = function(Value)
        AimFOV = Value
    end,
})

CombatTab:CreateDropdown({
    Name = "Target Bone",
    Options = {"Head", "HumanoidRootPart"},
    CurrentOption = {"Head"},
    MultipleOptions = false,
    Flag = "BoneDropdown",
    Callback = function(Option)
        AimBone = Option[1]
    end,
})

-- VISUALS TAB ELEMENTS
VisualsTab:CreateSection("Chams ESP")

VisualsTab:CreateToggle({
    Name = "Enable Charms ESP",
    CurrentValue = false,
    Flag = "ChamsToggle",
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
    end,
})

VisualsTab:CreateColorPicker({
    Name = "Chams Color",
    Color = Color3.fromRGB(255, 0, 85),
    Flag = "ChamsColorPicker",
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

-- Notification
Rayfield:Notify({
    Title = "MEXSTRO Loaded",
    Content = "Knife Duels Script by MEXSTRO is ready to use!",
    Duration = 5
})
