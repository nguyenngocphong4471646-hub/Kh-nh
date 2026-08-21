-- ScreenGui
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "NBKCheatMenu"

-- Services
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Main Frame (Thiết kế dạng thanh ngang)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 750, 0, 170)
MainFrame.Position = UDim2.new(0.5, 0, 0.8, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 10)

-- Title (Thanh tiêu đề ngang phía trên)
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 28)
Title.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Title.Text = "NBK CHEAT MENU"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 14

-- Container chứa các nút (Sắp xếp theo Lưới / Cột ngang)
local ButtonContainer = Instance.new("Frame", MainFrame)
ButtonContainer.Name = "ButtonContainer"
ButtonContainer.Size = UDim2.new(1, -20, 1, -38)
ButtonContainer.Position = UDim2.new(0, 10, 0, 33)
ButtonContainer.BackgroundTransparency = 1

local UIGrid = Instance.new("UIGridLayout", ButtonContainer)
UIGrid.CellSize = UDim2.new(0, 138, 0, 28) -- Kích thước mỗi nút
UIGrid.CellPadding = UDim2.new(0, 8, 0, 8)  -- Khoảng cách giữa các nút
UIGrid.SortOrder = Enum.SortOrder.LayoutOrder

-- Helper Toggle
local function CreateToggle(name, callback)
    local btn = Instance.new("TextButton", ButtonContainer)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 11
    btn.Text = name .. ": [OFF]"
    
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 5)

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

-- 6. ITEM ESP
CreateToggle("Item ESP", function(enabled)
    _G.ItemESP = enabled
    if enabled then
        task.spawn(function()
            while _G.ItemESP do
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Tool") or v:FindFirstChildOfClass("ClickDetector") or v:FindFirstChildOfClass("ProximityPrompt") then
                        if not v:FindFirstChild("ItemESP_HL") then
                            local hl = Instance.new("Highlight")
                            hl.Name = "ItemESP_HL"
                            hl.FillColor = Color3.fromRGB(255, 255, 0)
                            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                            hl.Adornee = v
                            hl.Parent = v

                            local targetPart = v:IsA("BasePart") and v or v:FindFirstChildWhichIsA("BasePart")
                            if targetPart and not targetPart:FindFirstChild("ItemESP_Tag") then
                                local bg = Instance.new("BillboardGui", targetPart)
                                bg.Name = "ItemESP_Tag"
                                bg.Size = UDim2.new(0, 100, 0, 30)
                                bg.StudsOffset = Vector3.new(0, 1.5, 0)
                                bg.AlwaysOnTop = true

                                local txt = Instance.new("TextLabel", bg)
                                txt.Size = UDim2.new(1, 0, 1, 0)
                                txt.BackgroundTransparency = 1
                                txt.Text = "[ " .. v.Name .. " ]"
                                txt.TextColor3 = Color3.fromRGB(255, 255, 0)
                                txt.Font = Enum.Font.SourceSansBold
                                txt.TextSize = 12
                            end
                        end
                    end
                end
                task.wait(2)
            end
        end)
    else
        for _, v in pairs(workspace:GetDescendants()) do
            if v:FindFirstChild("ItemESP_HL") then
                v.ItemESP_HL:Destroy()
            end
            if v:IsA("BasePart") and v:FindFirstChild("ItemESP_Tag") then
                v.ItemESP_Tag:Destroy()
            end
        end
    end
end)

-- 7. AIMBOT
CreateToggle("Aimbot", function(enabled)
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

-- 8. GÔM NGƯỜI CHƠI
CreateToggle("Gom Nguoi", function(enabled)
    _G.BringAll = enabled
    task.spawn(function()
        while _G.BringAll do
            local myChar = game.Players.LocalPlayer.Character
            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                local myPos = myChar.HumanoidRootPart.CFrame * CFrame.new(0, 0, -4)
                for _, p in pairs(game.Players:GetPlayers()) do
                    if p ~= game.Players.LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        p.Character.HumanoidRootPart.CFrame = myPos
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end)

-- 9. DROP KICK
CreateToggle("Drop Kick", function(enabled)
    _G.DropKick = enabled
    task.spawn(function()
        local LocalPlayer = game.Players.LocalPlayer
        while _G.DropKick do
            local myChar = LocalPlayer.Character
            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                for _, p in pairs(game.Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local targetHRP = p.Character.HumanoidRootPart
                        myChar.HumanoidRootPart.CFrame = targetHRP.CFrame * CFrame.new(0, -1, 0.5)
                        myChar.HumanoidRootPart.Velocity = Vector3.new(9999, 9999, 9999)
                        task.wait(0.02)
                    end
                end
            end
            task.wait(0.05)
        end
    end)
end)

-- 10. NOCLIP
CreateToggle("Noclip", function(enabled)
    _G.Noclip = enabled
    if enabled then
        task.spawn(function()
            while _G.Noclip do
                local char = game.Players.LocalPlayer.Character
                if char then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
                RunService.Stepped:Wait()
            end
            
            local char = game.Players.LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
            end
        end)
    end
end)

-- 11. TELEPORT BOX & BUTTON (Nằm chung vào ô lưới)
local TextBox = Instance.new("TextBox", ButtonContainer)
TextBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.PlaceholderText = "Nhap ten..."
TextBox.Font = Enum.Font.SourceSans
TextBox.TextSize = 11

local BoxCorner = Instance.new("UICorner", TextBox)
BoxCorner.CornerRadius = UDim.new(0, 5)

local TeleBtn = Instance.new("TextButton", ButtonContainer)
TeleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 150)
TeleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleBtn.Font = Enum.Font.SourceSansBold
TeleBtn.Text = "Teleport"
TeleBtn.TextSize = 11

local BtnCorner2 = Instance.new("UICorner", TeleBtn)
BtnCorner2.CornerRadius = UDim.new(0, 5)

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

-- NÚT TOGGLE VÀ ANIMATION MỞ NGANG
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Name = "ToggleButton"
ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleBtn.Position = UDim2.new(0.02, 0, 0.5, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ToggleBtn.Text = "NBK"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 12
ToggleBtn.Active = true
ToggleBtn.Draggable = true

local BtnCorner = Instance.new("UICorner", ToggleBtn)
BtnCorner.CornerRadius = UDim.new(0, 22)

-- Animation ngang
local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local fullSize = UDim2.new(0, 750, 0, 170)
local zeroSize = UDim2.new(0, 0, 0, 170)

local isOpen = true

ToggleBtn.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    if isOpen then
        MainFrame.Visible = true
        local tween = TweenService:Create(MainFrame, tweenInfo, {Size = fullSize, BackgroundTransparency = 0})
        tween:Play()
    else
        local tween = TweenService:Create(MainFrame, tweenInfo, {Size = zeroSize, BackgroundTransparency = 1})
        tween:Play()
        tween.Completed:Connect(function()
            if not isOpen then
                MainFrame.Visible = false
            end
        end)
    end
end)
