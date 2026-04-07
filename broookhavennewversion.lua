local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "XFIREX HUB--- brookhaven",
    Author = "by lorenzo and JX1",
    Folder = "LorenzoHub",
    Icon = "door-open",
    Theme = "Dark",
    ToggleKey = Enum.KeyCode.RightShift,
    Size = UDim2.fromOffset(680, 460)
})

-- ========== ABAS COM ÍCONES CORRETOS ==========
local MainTab     = Window:Tab({ Title = "Main",     Icon = "home" })
local SoundTab    = Window:Tab({ Title = "Sound",    Icon = "music" })
local ConfigTab   = Window:Tab({ Title = "Config",   Icon = "sliders" })
local ToolsTab    = Window:Tab({ Title = "Tools",    Icon = "tool" })
local DiscordTab  = Window:Tab({ Title = "Discord",  Icon = "discord" })
local UIConfigTab = Window:Tab({ Title = "UI Config", Icon = "settings" })

-- ========== SERVIÇOS ==========
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local RE = ReplicatedStorage:WaitForChild("RE")

-- ========== MAIN TAB ==========
local selectedPlayer = nil

local function getPlayers()
    local t = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(t, p.Name)
        end
    end
    return t
end

local PlayerDropdown = MainTab:Dropdown({
    Title = "players",
    Values = getPlayers(),
    Callback = function(v)
        selectedPlayer = Players:FindFirstChild(v)
    end
})

Players.PlayerAdded:Connect(function()
    PlayerDropdown:Refresh(getPlayers())
end)
Players.PlayerRemoving:Connect(function()
    PlayerDropdown:Refresh(getPlayers())
end)

-- View Player
local viewing = false
MainTab:Toggle({
    Title = "view player",
    Callback = function(v)
        viewing = v
        if not v and LocalPlayer.Character then
            workspace.CurrentCamera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        end
    end
})

RunService.RenderStepped:Connect(function()
    if viewing and selectedPlayer and selectedPlayer.Character then
        workspace.CurrentCamera.CameraSubject = selectedPlayer.Character:FindFirstChildOfClass("Humanoid")
    end
end)

-- Goto Player
MainTab:Button({
    Title = "goto player",
    Callback = function()
        if selectedPlayer and selectedPlayer.Character and LocalPlayer.Character then
            LocalPlayer.Character.HumanoidRootPart.CFrame = selectedPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        end
    end
})

-- Fling Player
MainTab:Button({
    Title = "fling player",
    Callback = function()
        if not selectedPlayer then return end

        RE["1Too1l"]:InvokeServer("PickingTools", "Couch")
        local TOOL_NAME = "Couch"
        local ativo = true
        local posicaoOriginal = nil
        local codigoExecutado = false
        local DESTINO_FINAL = CFrame.new(139383728, 521392544, 46955772)

        local function getTool()
            local char = LocalPlayer.Character
            local backpack = LocalPlayer:FindFirstChild("Backpack")
            if char and char:FindFirstChild(TOOL_NAME) then
                return char[TOOL_NAME]
            end
            if backpack and backpack:FindFirstChild(TOOL_NAME) then
                return backpack[TOOL_NAME]
            end
            return nil
        end

        local function garantirTool()
            if codigoExecutado then return end
            local tool = getTool()
            if tool then
                codigoExecutado = true
                return
            end
            RE["1Too1l"]:InvokeServer("PickingTools", TOOL_NAME)
            repeat task.wait() until getTool()
            codigoExecutado = true
        end

        local function equiparSempre()
            local char = LocalPlayer.Character
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            local tool = getTool()
            if humanoid and tool and tool.Parent ~= char then
                humanoid:EquipTool(tool)
            end
        end

        local function sentou(plr)
            local char = plr and plr.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            return hum and hum.Sit
        end

        local function pararTudo()
            ativo = false
            local char = LocalPlayer.Character
            if not char then return end
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:UnequipTools()
            end
            local root = char:FindFirstChild("HumanoidRootPart")
            if root and posicaoOriginal then
                root.CFrame = posicaoOriginal
            end
            RE["1Clea1rTool1s"]:FireServer("ClearAllTools")
        end

        RunService.RenderStepped:Connect(function()
            if not ativo then return end
            local char = LocalPlayer.Character
            if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if not root or not humanoid then return end

            if not posicaoOriginal then
                posicaoOriginal = root.CFrame
            end

            garantirTool()
            equiparSempre()

            local alvo = selectedPlayer
            if not alvo then return end
            local alvoRoot = alvo.Character and alvo.Character:FindFirstChild("HumanoidRootPart")
            if not alvoRoot then return end

            root.CFrame = root.CFrame:Lerp(alvoRoot.CFrame, 0.8)
            root.CFrame = root.CFrame * CFrame.Angles(
                math.rad(math.random(-900, 900)),
                math.rad(math.random(-900, 900)),
                math.rad(math.random(-900, 900))
            )

            if sentou(alvo) then
                for i = 1, 20 do
                    root.CFrame = root.CFrame:Lerp(DESTINO_FINAL, 1)
                    task.wait()
                end
                pararTudo()
            end
        end)
    end
})

-- Black Hole (requer Network)
if not getgenv().Network then
    getgenv().Network = {
        BaseParts = {},
        Velocity = Vector3.new(14.4626, 14.4626, 14.4626)
    }

    Network.RetainPart = function(part)
        if part:IsA("BasePart") and part:IsDescendantOf(Workspace) then
            table.insert(Network.BaseParts, part)
            part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
            part.CanCollide = false
        end
    end

    RunService.Heartbeat:Connect(function()
        sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
        for _, part in pairs(Network.BaseParts) do
            if part:IsDescendantOf(Workspace) then
                part.Velocity = Network.Velocity
            end
        end
    end)
end

local Folder = Instance.new("Folder", Workspace)
local CenterPart = Instance.new("Part")
CenterPart.Parent = Folder
CenterPart.Anchored = true
CenterPart.CanCollide = false
CenterPart.Transparency = 1
local Attachment1 = Instance.new("Attachment", CenterPart)

local function ForcePart(v)
    if v:IsA("BasePart") and not v.Anchored and not v.Parent:FindFirstChildOfClass("Humanoid") and not v.Parent:FindFirstChild("Head") and v.Name ~= "Handle" then
        for _, obj in ipairs(v:GetChildren()) do
            if obj:IsA("BodyMover") or obj:IsA("RocketPropulsion") or obj:IsA("Torque") or obj:IsA("AlignPosition") or obj:IsA("AlignOrientation") then
                obj:Destroy()
            end
        end
        if v:FindFirstChild("Attachment") then
            v.Attachment:Destroy()
        end
        v.CanCollide = false
        local Torque = Instance.new("Torque")
        Torque.Torque = Vector3.new(100000, 100000, 100000)
        Torque.Parent = v
        local AlignPosition = Instance.new("AlignPosition")
        AlignPosition.MaxForce = math.huge
        AlignPosition.MaxVelocity = math.huge
        AlignPosition.Responsiveness = 200
        local Attachment2 = Instance.new("Attachment", v)
        Torque.Attachment0 = Attachment2
        AlignPosition.Attachment0 = Attachment2
        AlignPosition.Attachment1 = Attachment1
        AlignPosition.Parent = v
        Network.RetainPart(v)
    end
end

local blackHoleActive = false
local followConnection = nil
local DescendantAddedConnection = nil

local function startBlackHole(player)
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")
    for _, v in ipairs(Workspace:GetDescendants()) do
        ForcePart(v)
    end
    DescendantAddedConnection = Workspace.DescendantAdded:Connect(function(v)
        if blackHoleActive then
            ForcePart(v)
        end
    end)
    followConnection = RunService.RenderStepped:Connect(function()
        if blackHoleActive then
            Attachment1.WorldCFrame = hrp.CFrame
        end
    end)
end

local function stopBlackHole()
    if DescendantAddedConnection then DescendantAddedConnection:Disconnect() end
    if followConnection then followConnection:Disconnect() end
end

MainTab:Toggle({
    Title = "black hole player",
    Callback = function(v)
        if not selectedPlayer then return end
        blackHoleActive = v
        if v then
            startBlackHole(selectedPlayer)
        else
            stopBlackHole()
        end
    end
})

-- ========== SOUND TAB ==========
local audioID = ""
local audioVolume = 0.5
local audioLoop = false

SoundTab:Input({
    Title = "Audio ID",
    Callback = function(text)
        audioID = text
    end
})

SoundTab:Slider({
    Title = "Volume",
    Min = 0.1,
    Max = 0.8,
    Value = 0.5,
    Callback = function(v)
        audioVolume = v
    end
})

SoundTab:Button({
    Title = "Play audio",
    Callback = function()
        if audioID == "" then return end
        RE["1Gu1nSound1s"]:FireServer(workspace, audioID, 1)
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://" .. audioID
            sound.Volume = audioVolume
            sound.Parent = hrp
            sound:Play()
            game:GetService("Debris"):AddItem(sound, 10)
        end
    end
})

SoundTab:Toggle({
    Title = "Spawnar audio",
    Callback = function(v)
        audioLoop = v
        if v then
            task.spawn(function()
                while audioLoop do
                    RE["1Gu1nSound1s"]:FireServer(workspace, audioID, 1)
                    task.wait(0.6)
                end
            end)
        end
    end
})

-- ========== CONFIG TAB ==========
local speed = 16
local jump = 50

ConfigTab:Slider({
    Title = "speed",
    Min = 16,
    Max = 200,
    Value = 16,
    Callback = function(v)
        speed = v
    end
})

ConfigTab:Slider({
    Title = "jump",
    Min = 50,
    Max = 200,
    Value = 50,
    Callback = function(v)
        jump = v
    end
})

RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = speed
            hum.JumpPower = jump
        end
    end
end)

ConfigTab:Toggle({
    Title = "no gravity",
    Callback = function(v)
        Workspace.Gravity = v and 0 or 196.2
    end
})

-- ========== TOOLS TAB ==========
ToolsTab:Button({
    Title = "get Couch",
    Callback = function()
        RE["1Too1l"]:InvokeServer("PickingTools", "Couch")
    end
})

ToolsTab:Button({
    Title = "teleport tool",
    Callback = function()
        local tool = Instance.new("Tool")
        tool.RequiresHandle = false
        tool.Name = "tp tool"
        tool.Activated:Connect(function()
            local mouse = LocalPlayer:GetMouse()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position)
            end
        end)
        tool.Parent = LocalPlayer.Backpack
    end
})

-- ========== UI CONFIG TAB ==========
UIConfigTab:Dropdown({
    Title = "Theme",
    Values = (function()
        local names = {}
        for name in pairs(WindUI:GetThemes()) do
            table.insert(names, name)
        end
        table.sort(names)
        return names
    end)(),
    Value = WindUI:GetCurrentTheme(),
    Callback = function(selected)
        WindUI:SetTheme(selected)
    end
})

UIConfigTab:Toggle({
    Title = "Acrylic",
    Callback = function()
        WindUI:ToggleAcrylic(not WindUI.Window.Acrylic)
    end
})

UIConfigTab:Toggle({
    Title = "Transparent",
    Value = WindUI:GetTransparency(),
    Callback = function(state)
        Window:ToggleTransparency(state)
    end
})

local currentKey = Enum.KeyCode.RightShift
UIConfigTab:Keybind({
    Title = "Toggle UI Key",
    Value = "RightShift",
    Callback = function(v)
        currentKey = typeof(v) == "EnumItem" and v or Enum.KeyCode[v]
        Window:SetToggleKey(currentKey)
    end
})

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == currentKey then
        Window:Toggle()
    end
end)

-- ========== DISCORD TAB ==========
DiscordTab:Button({
    Title = "copy discord",
    Callback = function()
        setclipboard("https://discord.gg/redz-hub")
        WindUI:Notify({
            Title = "discord",
            Content = "copiado"
        })
    end
})

-- ========== NOTIFICAÇÃO INICIAL ==========
WindUI:Notify({
    Title = "Lorenzo hub",
    Content = "loaded"
})
