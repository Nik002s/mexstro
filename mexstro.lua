-- MEXSTRO GUI (Knife Duels)

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ძველი GUI-ს წაშლა
if CoreGui:FindFirstChild("MEXSTRO_GUI") then
    CoreGui.MEXSTRO_GUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MEXSTRO_GUI"
ScreenGui.ResetOnSpawn = false

if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
elseif gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = CoreGui
end

-- ცვლადები
local AimbotEnabled = false
local ShowFOV = false
local AimFOV = 120
local Smoothness = 0.25

local ChamsEnabled = false
local ChamsColor = Color3.fromRGB(255, 30, 30)

-- FOV Circle Visual (GUI Based - 100% მუშაობს მობილურზე)
local FOVFrame = Instance.new("Frame")
FOVFrame.Name = "FOVFrame"
FOVFrame.AnchorPoint = Vector2.new(0.5, 0.5)
FOVFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
FOVFrame.Size = UDim2.new(0, AimFOV * 2, 0, AimFOV * 2)
FOVFrame.BackgroundTransparency = 1
FOVFrame.Visible = false
FOVFrame.Parent = ScreenGui

local FOVCorner = Instance.new("UICorner")
FOVCorner.CornerRadius = UDim.new(1, 0)
FOVCorner.Parent = FOVFrame

local FOVStroke = Instance.new("UIStroke")
FOVStroke.Color = Color3.fromRGB(255, 50, 50)
FOVStroke.Thickness = 1.5
FOVStroke.Transparency = 0.2
FOVStroke.Parent = FOVFrame

local function UpdateFOVVisual()
    FOVFrame.Size = UDim2.new(0, AimFOV * 2, 0, AimFOV * 2)
    FOVFrame.Visible = ShowFOV
end

-- Target Finder (HumanoidRootPart / ტანი)
local function GetClosestTarget()
    local Closest = nil
    local MaxDistance = AimFOV

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local TargetPart = v.Character:FindFirstChild("HumanoidRootPart") or v.Character:FindFirstChild("Torso")
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

-- ESP (Chams)
local function UpdateChams()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character then
            local Highlight = v.Character:FindFirstChild("MEXSTRO_Chams")
            if ChamsEnabled then
                if not Highlight then
                    Highlight = Instance.new("Highlight")
                    Highlight.Name = "MEXSTRO_Chams"
                    Highlight.Parent = v.Character
                end
                Highlight.FillColor = ChamsColor
                Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                Highlight.FillTransparency = 0.4
                Highlight.OutlineTransparency = 0
            else
                if Highlight then
                    Highlight:Destroy()
                end
            end
        end
    end
end

-- მთავარი ფანჯარა
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 310, 0, 360)
MainFrame.Position = UDim2.new(0.5, -155, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 14)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(220, 38, 38)
UIStroke.Thickness = 2.5
UIStroke.Parent = MainFrame

-- სათაური (მხოლოდ MEXSTRO)
local Header = Instance.new("TextLabel")
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Color3.fromRGB(35, 18, 22)
Header.Text = "  MEXSTRO"
Header.TextColor3 = Color3.fromRGB(255, 255, 255)
Header.TextSize = 18
Header.Font = Enum.Font.GothamBold
Header.TextXAlignment = Enum.TextXAlignment.Left
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 14)
HeaderCorner.Parent = Header

-- ჩაკეცვის ღილაკი ეკრანზე
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 45, 0, 45)
OpenBtn.Position = UDim2.new(0, 15, 0.5, -22)
OpenBtn.BackgroundColor3 = Color3.fromRGB(220, 38, 38)
OpenBtn.Text = "🔴"
OpenBtn.TextSize = 20
OpenBtn.Active = true
OpenBtn.Draggable = true
OpenBtn.Parent = ScreenGui

local OpenBtnCorner = Instance.new("UICorner")
OpenBtnCorner.CornerRadius = UDim.new(1, 0)
OpenBtnCorner.Parent = OpenBtn

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- სქროლის ზონა
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -55)
Scroll.Position = UDim2.new(0, 10, 0, 50)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 3
Scroll.ScrollBarImageColor3 = Color3.fromRGB(220, 38, 38)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 330)
Scroll.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Scroll
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

local function CreateButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(40, 25, 30)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(240, 240, 240)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 15
    btn.Parent = Scroll
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(80, 40, 45)
    stroke.Thickness = 1
    stroke.Parent = btn

    btn.MouseButton1Click:Connect(function()
        callback(btn, stroke)
    end)
    return btn
end

-- 1. Aimbot Toggle
CreateButton("Aimbot: OFF", function(btn, stroke)
    AimbotEnabled = not AimbotEnabled
    if AimbotEnabled then
        btn.Text = "Aimbot: ON"
        btn.BackgroundColor3 = Color3.fromRGB(180, 25, 25)
        stroke.Color = Color3.fromRGB(255, 60, 60)
    else
        btn.Text = "Aimbot: OFF"
        btn.BackgroundColor3 = Color3.fromRGB(40, 25, 30)
        stroke.Color = Color3.fromRGB(80, 40, 45)
    end
end)

-- 2. FOV Circle Toggle
CreateButton("Show FOV Circle: OFF", function(btn, stroke)
    ShowFOV = not ShowFOV
    if ShowFOV then
        btn.Text = "Show FOV Circle: ON"
        btn.BackgroundColor3 = Color3.fromRGB(180, 25, 25)
        stroke.Color = Color3.fromRGB(255, 60, 60)
    else
        btn.Text = "Show FOV Circle: OFF"
        btn.BackgroundColor3 = Color3.fromRGB(40, 25, 30)
        stroke.Color = Color3.fromRGB(80, 40, 45)
    end
    UpdateFOVVisual()
end)

-- 3. FOV Label & Controls
local FOVLabel = Instance.new("TextLabel")
FOVLabel.Size = UDim2.new(1, 0, 0, 25)
FOVLabel.BackgroundTransparency = 1
FOVLabel.Text = "Aimbot FOV Radius: " .. tostring(AimFOV) .. " px"
FOVLabel.TextColor3 = Color3.fromRGB(220, 180, 185)
FOVLabel.Font = Enum.Font.Gotham
FOVLabel.TextSize = 14
FOVLabel.Parent = Scroll

CreateButton("Increase FOV (+15)", function()
    if AimFOV < 250 then
        AimFOV = AimFOV + 15
        FOVLabel.Text = "Aimbot FOV Radius: " .. tostring(AimFOV) .. " px"
        UpdateFOVVisual()
    end
end)

CreateButton("Decrease FOV (-15)", function()
    if AimFOV > 40 then
        AimFOV = AimFOV - 15
        FOVLabel.Text = "Aimbot FOV Radius: " .. tostring(AimFOV) .. " px"
        UpdateFOVVisual()
    end
end)

-- 4. ESP Toggle
CreateButton("Enable Chams ESP: OFF", function(btn, stroke)
    ChamsEnabled = not ChamsEnabled
    if ChamsEnabled then
        btn.Text = "Enable Chams ESP: ON"
        btn.BackgroundColor3 = Color3.fromRGB(180, 25, 25)
        stroke.Color = Color3.fromRGB(255, 60, 60)
    else
        btn.Text = "Enable Chams ESP: OFF"
        btn.BackgroundColor3 = Color3.fromRGB(40, 25, 30)
        stroke.Color = Color3.fromRGB(80, 40, 45)
    end
    UpdateChams()
end)
