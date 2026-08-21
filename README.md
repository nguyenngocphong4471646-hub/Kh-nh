-- ScreenGui
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "NBKCheatMenu"

-- Main Frame
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 200, 0, 400)
MainFrame.Position = UDim2.new(0.5, -100, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

-- Title
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Title.Text = "NBK MENU"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 14

local UIList = Instance.new("UIListLayout", MainFrame)
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 5)

-- Helper Toggle
local function CreateToggle(name, callback)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0.9, 0, 0, 28)
    btn.Position = UDim2.new(0.05, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 12
    btn.Text = name .. ": [OFF]"
    
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 6)

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            btn.BackgroundColor3 = Color3.fromRGB(40, 140, 60)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Text = name .. ": [ON]"
        else
            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            btn.Text = name .. ": [OFF]"
        end
        callback(state)
    end)
end

-- 1. SPEED
CreateToggle("Speed 100", function(enabled)
    _G.SpeedHack = enabled
    task.spawn(function()
        while _G.SpeedHack do
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = 100
            end
            task.wait(0.1)
        end
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = 16
        end
    end)
end)

-- 2. GOD MODE
CreateToggle("God Mode", function(enabled)
    _G.GodMode = enabled
    task.spawn(function()
        while _G.GodMode do
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.MaxHealth = math.huge
                char.Humanoid.Health = math.huge
            end
            task.wait(0.2)
        end
    end)
end)

-- 3. INVISIBLE
CreateToggle("Invisible", function(enabled)
    local char = game.Players.LocalPlayer.Character
    if char then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then
                if v.Name ~= "HumanoidRootPart" then
                    v.Transparency = enabled and 1 or 0
                end
            end
        end
    end
end)

-- 4. ESP HIGHLIGHT
CreateToggle("Player ESP", function(enabled)
    _G.ESP = enabled
    if enabled then
        task.spawn(function()
            while _G.ESP do
                for _, p in pairs(game.Players:GetPlayers()) do
                    if p ~= game.Players.LocalPlayer and p.Character then
                        if not p.Character:FindFirstChild("MiniESP") then
                            local hl = Instance.new("Highlight", p.Character)
                            hl.Name = "MiniESP"
                            hl.FillColor = Color3.fromRGB(255, 0, 0)
                            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                        end
                    end
                end
                task.wait(1)
            end
        end)
    else
        for _, p in pairs(game.Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("MiniESP") then
                p.Character.MiniESP:Destroy()
            end
        end
    end
end)

-- 5. ESP NAME
CreateToggle("ESP Name", function(enabled)
    _G.ESPName = enabled
    if enabled then
        task.spawn(function()
            while _G.ESPName do
                for _, p in pairs(game.Players:GetPlayers()) do
                    if p ~= game.Players.LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                        if not p.Character.Head:FindFirstChild("NameTag") then
                            local bg = Instance.new("BillboardGui", p.Character.Head)
                            bg.Name = "NameTag"
                            bg.Size = UDim2.new(0, 100, 0, 30)
                            bg.StudsOffset = Vector3.new(0, 2, 0)
                            bg.AlwaysOnTop = true

                            local txt = Instance.new("TextLabel", bg)
                            txt.Size = UDim2.new(1, 0, 1, 0)
                            txt.BackgroundTransparency = 1
                            txt.Text = p.Name
                            txt.TextColor3 = Color3.fromRGB(0, 255, 255)
                            txt.Font = Enum.Font.SourceSansBold
                            txt.TextSize = 14
                        end
                    end
                end
                task.wait(1)
            end
        end)
    else
        for _, p in pairs(game.Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("Head") and p.Character.Head:FindFirstChild("NameTag") then
                p.Character.Head.NameTag:Destroy()
            end
        end
    end
end)

-- 6. GHIM TÂM (AIMBOT / CAMERA LOCK)
CreateToggle("Aimbot (Ghim Tam)", function(enabled)
    _G.Aimbot = enabled
    
    local Camera = workspace.CurrentCamera
    local LocalPlayer = game.Players.LocalPlayer
    
    local function GetClosestPlayer()
        local closestPlayer = nil
        local shortestDistance = math.huge
        
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                local pos, onScreen = Camera:WorldToViewportPoint(player.Character.Head.Position)
                if onScreen then
                    local mousePos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                    local distance = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
        return closestPlayer
    end

    task.spawn(function()
        while _G.Aimbot do
            local target = GetClosestPlayer()
            if target and target.Character and target.Character:FindFirstChild("Head") then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
            end
            task.wait()
        end
    end)
end)

-- 7. TELEPORT THEO TÊN
local TextBox = Instance.new("TextBox", MainFrame)
TextBox.Size = UDim2.new(0.9, 0, 0, 26)
TextBox.Position = UDim2.new(0.05, 0, 0, 0)
TextBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.PlaceholderText = "Nhap ten nguoi choi..."
TextBox.Font = Enum.Font.SourceSans
TextBox.TextSize = 12

local BoxCorner = Instance.new("UICorner", TextBox)
BoxCorner.CornerRadius = UDim.new(0, 4)

local TeleBtn = Instance.new("TextButton", MainFrame)
TeleBtn.Size = UDim2.new(0.9, 0, 0, 26)
TeleBtn.Position = UDim2.new(0.05, 0, 0, 0)
TeleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 150)
TeleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleBtn.Font = Enum.Font.SourceSansBold
TeleBtn.Text = "Teleport"
TeleBtn.TextSize = 12

local BtnCorner2 = Instance.new("UICorner", TeleBtn)
BtnCorner2.CornerRadius = UDim.new(0, 4)

TeleBtn.MouseButton1Click:Connect(function()
    local nameInput = string.lower(TextBox.Text)
    if nameInput == "" then return end
    
    for _, target in pairs(game.Players:GetPlayers()) do
        if target ~= game.Players.LocalPlayer then
            if string.find(string.lower(target.Name), nameInput) or string.find(string.lower(target.DisplayName), nameInput) then
                if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    local myChar = game.Players.LocalPlayer.Character
                    if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                        myChar.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                    end
                end
                break
            end
        end
    end
end)

-- NÚT TOGGLE NBK
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Name = "ToggleButton"
ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleBtn.Position = UDim2.new(0.02, 0, 0.4, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ToggleBtn.Text = "NBK"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 11
ToggleBtn.Active = true
ToggleBtn.Draggable = true

local BtnCorner = Instance.new("UICorner", ToggleBtn)
BtnCorner.CornerRadius = UDim.new(0, 22)

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
