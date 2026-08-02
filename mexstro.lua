-- MEXSTRO Dark Edition (Knife Duels UI)

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
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
local ShowFOV = false
local AimFOV = 120

local ChamsEnabled = false
local ChamsColor = Color3.fromRGB(200, 200, 200)

-- FOV Circle Visual (ეკრანზე წრის გამოჩენა)
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
FOVStroke.Color = Color3.fromRGB(255, 255, 255)
FOVStroke.Thickness = 1.5
FOVStroke.Transparency = 0.3
FOVStroke.Parent = FOVFrame

-- FOV-ის დინამიური განახლება
RunService.RenderStepped:Connect(function()
    FOVFrame.Visible = ShowFOV
    FOVFrame.Size = UDim2.new(0, AimFOV * 2, 0, AimFOV * 2)
    FOVFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
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
                Highlight.FillTransparency = 0.5
                Highlight.OutlineTransparency = 0
            else
                if Highlight then
                    Highlight:Destroy()
                end
            end
        end
    end
end

-- მთავარი ფანჯარა (Clean Dark Theme)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 310, 0, 320)
MainFrame.Position = UDim2.new(0.5, -155, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 14)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(50, 50, 55)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

-- სათაური
local Header = Instance.new("TextLabel")
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
Header.Text = "  MEXSTRO"
Header.TextColor3 = Color3.fromRGB(255, 255, 255)
Header.TextSize = 18
Header.Font = Enum.Font.GothamBold
Header.TextXAlignment = Enum.TextXAlignment.Left
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 14)
HeaderCorner.Parent = Header

-- ჩაკეცვის ღილაკი ეკრანზე (Black Circle Toggle)
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 45, 0, 45)
OpenBtn.Position = UDim2.new(0, 15, 0.5, -22)
OpenBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
OpenBtn.Text = "⚫"
OpenBtn.TextSize = 20
OpenBtn.Active = true
OpenBtn.Draggable = true
OpenBtn.Parent = ScreenGui

local OpenBtnCorner = Instance.new("UICorner")
OpenBtnCorner.CornerRadius = UDim.new(1, 0)
OpenBtnCorner.Parent = OpenBtn

local OpenBtnStroke = Instance.new("UIStroke")
OpenBtnStroke.Color = Color3.fromRGB(80, 80, 90)
OpenBtnStroke.Thickness = 1.5
OpenBtnStroke.Parent = OpenBtn

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- სქროლის ზონა
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -55)
Scroll.Position = UDim2.new(0, 10, 0, 50)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 3
Scroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 110)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 250)
Scroll.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Scroll
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)

local function CreateButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(240, 240, 240)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 15
    btn.Parent = Scroll
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(55, 55, 65)
    stroke.Thickness = 1
    stroke.Parent = btn

    btn.MouseButton1Click:Connect(function()
        callback(btn, stroke)
    end)
    return btn
end

-- 1. FOV Circle Toggle
CreateButton("Show FOV Circle: OFF", function(btn, stroke)
    ShowFOV = not ShowFOV
    if ShowFOV then
        btn.Text = "Show FOV Circle: ON"
        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        stroke.Color = Color3.fromRGB(255, 255, 255)
    else
        btn.Text = "Show FOV Circle: OFF"
        btn.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
        stroke.Color = Color3.fromRGB(55, 55, 65)
    end
end)

-- 2. FOV SLIDER (გადასაწევი სლაიდერი მობილურისთვის)
local SliderContainer = Instance.new("Frame")
SliderContainer.Size = UDim2.new(1, 0, 0, 55)
SliderContainer.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
SliderContainer.Parent = Scroll

local SliderCorner = Instance.new("UICorner")
SliderCorner.CornerRadius = UDim.new(0, 8)
SliderCorner.Parent = SliderContainer

local SliderStroke = Instance.new("UIStroke")
SliderStroke.Color = Color3.fromRGB(55, 55, 65)
SliderStroke.Thickness = 1
SliderStroke.Parent = SliderContainer

local SliderLabel = Instance.new("TextLabel")
SliderLabel.Size = UDim2.new(1, -20, 0, 20)
SliderLabel.Position = UDim2.new(0, 10, 0, 6)
SliderLabel.BackgroundTransparency = 1
SliderLabel.Text = "FOV Size: " .. tostring(AimFOV) .. " px"
SliderLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
SliderLabel.Font = Enum.Font.GothamMedium
SliderLabel.TextSize = 13
SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
SliderLabel.Parent = SliderContainer

local SliderBar = Instance.new("Frame")
SliderBar.Size = UDim2.new(1, -20, 0, 8)
SliderBar.Position = UDim2.new(0, 10, 0, 34)
SliderBar.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
SliderBar.Parent = SliderContainer

local BarCorner = Instance.new("UICorner")
BarCorner.CornerRadius = UDim.new(1, 0)
BarCorner.Parent = SliderBar

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new((AimFOV - 30) / (250 - 30), 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderFill.Parent = SliderBar

local FillCorner = Instance.new("UICorner")
FillCorner.CornerRadius = UDim.new(1, 0)
FillCorner.Parent = SliderFill

local Sliding = false
local MinFOV = 30
local MaxFOV = 250

local function UpdateSlider(input)
    local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
    AimFOV = math.floor(MinFOV + (MaxFOV - MinFOV) * pos)
    SliderFill.Size = UDim2.new(pos, 0, 1, 0)
    SliderLabel.Text = "FOV Size: " .. tostring(AimFOV) .. " px"
end

SliderBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Sliding = true
        UpdateSlider(input)
    end
end)

SliderBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Sliding = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if Sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        UpdateSlider(input)
    end
end)

-- 3. ESP Toggle
CreateButton("Enable Chams ESP: OFF", function(btn, stroke)
    ChamsEnabled = not ChamsEnabled
    if ChamsEnabled me
        btn.Text = "Enable Chams ESP: ON"
        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        stroke.Color = Color3.fromRGB(255, 255, 255)
    else
        btn.Text = "Enable Chams ESP: OFF"
        btn.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
        stroke.Color = Color3.fromRGB(55, 55, 65)
    end
    UpdateChams()
end)
