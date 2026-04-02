-- Carregar Fluent
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- Criar janela principal
local Window = Fluent:CreateWindow({
    Title = "Lorenzo hub --- brookhaven",
    SubTitle = "by lorenzo and JX1",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Tabs
local MainTab = Window:AddTab({ Title = "Main", Icon = "home" })
local SoundTab = Window:AddTab({ Title = "Sound", Icon = "volume-2" })
local ConfigTab = Window:AddTab({ Title = "Config", Icon = "settings" })
local ToolsTab = Window:AddTab({ Title = "Tools", Icon = "axe" })

-- Notificação de carregamento
Fluent:Notify({
    Title = "Lorenzo hub",
    Content = "Carregado com sucesso!",
    Duration = 5
})

--------------------------------------------------
-- SERVICES
--------------------------------------------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

--------------------------------------------------
-- MAIN TAB
--------------------------------------------------

local selectedPlayer = nil

-- Função para obter lista de jogadores (excluindo o local)
local function getPlayerNames()
    local names = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(names, player.Name)
        end
    end
    return names
end

-- Dropdown de jogadores
local PlayerDropdown = MainTab:AddDropdown("PlayerDropdown", {
    Title = "Jogadores",
    Values = getPlayerNames(),
    Multi = false,
    Default = 1,
    Callback = function(value)
        selectedPlayer = Players:FindFirstChild(value)
    end
})

-- Atualizar dropdown quando jogadores entram/saem
local function updatePlayerDropdown()
    PlayerDropdown:SetValues(getPlayerNames())
end

Players.PlayerAdded:Connect(updatePlayerDropdown)
Players.PlayerRemoving:Connect(updatePlayerDropdown)

-- View Player (Toggle)
local viewing = false
MainTab:AddToggle("ViewPlayerToggle", {
    Title = "Ver jogador",
    Default = false,
    Callback = function(value)
        viewing = value
        if not value then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                workspace.CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid
            end
        end
    end
})

RunService.RenderStepped:Connect(function()
    if viewing and selectedPlayer and selectedPlayer.Character then
        workspace.CurrentCamera.CameraSubject = selectedPlayer.Character.Humanoid
    end
end)

-- Goto Player (Botão)
MainTab:AddButton({
    Title = "Ir até jogador",
    Callback = function()
        if selectedPlayer and selectedPlayer.Character then
            local root = selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root and LocalPlayer.Character then
                LocalPlayer.Character.HumanoidRootPart.CFrame = root.CFrame + Vector3.new(0, 3, 0)
            end
        end
    end
})

-- Fling Player (Botão)
MainTab:AddButton({
    Title = "Flingar jogador",
    Callback = function()
        if not selectedPlayer then return end

        local args = { "PickingTools", "Couch" }
        ReplicatedStorage:WaitForChild("RE"):WaitForChild("1Too1l"):InvokeServer(unpack(args))

        local TOOL_NAME = "Couch"
        local ativo = true
        local posicaoOriginal
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
        end

        local function garantirTool()
            if codigoExecutado then return end
            local tool = getTool()
            if tool then
                codigoExecutado = true
                return
            end
            local args = { "PickingTools", TOOL_NAME }
            ReplicatedStorage:WaitForChild("RE"):WaitForChild("1Too1l"):InvokeServer(unpack(args))
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
            return hum and hum.Sit or false
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
            local args = { "ClearAllTools" }
            ReplicatedStorage:WaitForChild("RE"):WaitForChild("1Clea1rTool1s"):FireServer(unpack(args))
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
            if not alvo or not alvo.Character then return end
            local alvoRoot = alvo.Character:FindFirstChild("HumanoidRootPart")
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

-- Black Hole Player (Toggle)
if not getgenv().Network then
    getgenv().Network = {
        BaseParts = {},
        Velocity = Vector3.new(14.46262424, 14.46262424, 14.46262424)
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
        if v:FindFirstChild("Attachment") then v.Attachment:Destroy() end
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
local followConnection, descendantAddedConnection

local function startBlackHole(player)
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")
    for _, v in ipairs(Workspace:GetDescendants()) do ForcePart(v) end
    descendantAddedConnection = Workspace.DescendantAdded:Connect(function(v)
        if blackHoleActive then ForcePart(v) end
    end)
    followConnection = RunService.RenderStepped:Connect(function()
        if blackHoleActive then
            Attachment1.WorldCFrame = hrp.CFrame
        end
    end)
end

local function stopBlackHole()
    if descendantAddedConnection then descendantAddedConnection:Disconnect() end
    if followConnection then followConnection:Disconnect() end
end

MainTab:AddToggle("BlackHoleToggle", {
    Title = "Buraco negro no jogador",
    Default = false,
    Callback = function(value)
        if not selectedPlayer then
            Fluent:Notify({ Title = "Erro", Content = "Nenhum jogador selecionado.", Duration = 3 })
            return
        end
        blackHoleActive = value
        if value then
            startBlackHole(selectedPlayer)
        else
            stopBlackHole()
        end
    end
})

--------------------------------------------------
-- SOUND TAB
--------------------------------------------------
local audioID = ""
local audioVolume = 0.5
local audioLoop = false
local loopConnection = nil

SoundTab:AddInput("AudioIDInput", {
    Title = "ID do áudio",
    Placeholder = "ID aqui",
    Default = "",
    Callback = function(text)
        audioID = text
    end
})

SoundTab:AddSlider("VolumeSlider", {
    Title = "Volume",
    Min = 0.1,
    Max = 0.8,
    Default = 0.5,
    Rounding = 2,
    Callback = function(value)
        audioVolume = value
    end
})

SoundTab:AddButton({
    Title = "Tocar áudio",
    Callback = function()
        if audioID == "" then return end
        pcall(function()
            local remote = ReplicatedStorage:FindFirstChild("RE") and ReplicatedStorage.RE:FindFirstChild("1Gu1nSound1s")
            if remote then
                remote:FireServer(workspace, audioID, 1)
            end
        end)
        pcall(function()
            local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local sound = Instance.new("Sound")
                sound.SoundId = "rbxassetid://" .. audioID
                sound.Volume = audioVolume
                sound.Parent = hrp
                sound:Play()
                game:GetService("Debris"):AddItem(sound, 10)
            end
        end)
    end
})

local loopActive = false
SoundTab:AddToggle("LoopAudioToggle", {
    Title = "Spawnar áudio (loop)",
    Default = false,
    Callback = function(value)
        loopActive = value
        if value then
            task.spawn(function()
                while loopActive do
                    if audioID ~= "" then
                        pcall(function()
                            local remote = ReplicatedStorage:FindFirstChild("RE") and ReplicatedStorage.RE:FindFirstChild("1Gu1nSound1s")
                            if remote then
                                remote:FireServer(workspace, audioID, 1)
                            end
                        end)
                        pcall(function()
                            local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                            local hrp = character:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                local sound = Instance.new("Sound")
                                sound.SoundId = "rbxassetid://" .. audioID
                                sound.Volume = audioVolume
                                sound.Parent = hrp
                                sound:Play()
                                game:GetService("Debris"):AddItem(sound, 10)
                            end
                        end)
                    end
                    task.wait(0.6)
                end
            end)
        end
    end
})

--------------------------------------------------
-- CONFIG TAB
--------------------------------------------------
local speed = 16
local jump = 50

ConfigTab:AddSlider("SpeedSlider", {
    Title = "Velocidade",
    Min = 16,
    Max = 200,
    Default = 16,
    Rounding = 0,
    Callback = function(value)
        speed = value
    end
})

ConfigTab:AddSlider("JumpSlider", {
    Title = "Pulo",
    Min = 50,
    Max = 200,
    Default = 50,
    Rounding = 0,
    Callback = function(value)
        jump = value
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

ConfigTab:AddToggle("NoGravityToggle", {
    Title = "Sem gravidade",
    Default = false,
    Callback = function(value)
        Workspace.Gravity = value and 0 or 196.2
    end
})

--------------------------------------------------
-- TOOLS TAB
--------------------------------------------------
ToolsTab:AddButton({
    Title = "Pegar Couch",
    Callback = function()
        ReplicatedStorage:WaitForChild("RE"):WaitForChild("1Too1l"):InvokeServer("PickingTools", "Couch")
    end
})

ToolsTab:AddButton({
    Title = "Criar ferramenta de teleporte",
    Callback = function()
        local tool = Instance.new("Tool")
        tool.RequiresHandle = false
        tool.Name = "tp tool"
        tool.Activated:Connect(function()
            local mouse = LocalPlayer:GetMouse()
            if mouse and mouse.Hit then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position)
            end
        end)
        tool.Parent = LocalPlayer.Backpack
    end
})

--------------------------------------------------
-- NOTIFICAÇÃO EXTRA (OPCIONAL)
--------------------------------------------------
Fluent:Notify({
    Title = "Lorenzo hub",
    Content = "Todas as funções carregadas. Divirta-se!",
    Duration = 4
})
