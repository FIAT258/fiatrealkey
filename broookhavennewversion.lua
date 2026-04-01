--------------------------------------------------
-- UI
--------------------------------------------------

local Library =
loadstring(game:HttpGet(
"https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"
))()

local Window =
Library:MakeWindow({

Title = "Lorenzo hub---brookhaven",
SubTitle = "by lorenzo and JX1",
ScriptFolder = "LorenzoHub"

})

Library:SetUIScale(1)

local Minimizer =
Window:NewMinimizer({

KeyCode = Enum.KeyCode.LeftControl

})

Minimizer:CreateMobileMinimizer({

Image = "rbxassetid://0",
BackgroundColor3 = Color3.fromRGB(0,0,0)

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
-- TAB MAIN
--------------------------------------------------

local MainTab =
Window:MakeTab({

Title = "Main",
Icon = "Home"

})

--------------------------------------------------
-- PLAYER DROPDOWN
--------------------------------------------------

local selectedPlayer = nil

local function getPlayers()

local t = {}

for _,p in pairs(Players:GetPlayers()) do

if p ~= LocalPlayer then
table.insert(t,p.Name)
end

end

return t

end


local PlayerDropdown =
MainTab:AddDropdown({

Name = "players",
Options = getPlayers(),

Callback = function(v)

selectedPlayer =
Players:FindFirstChild(v)

end

})


Players.PlayerAdded:Connect(function()

PlayerDropdown:Refresh(
getPlayers()
)

end)


Players.PlayerRemoving:Connect(function()

PlayerDropdown:Refresh(
getPlayers()
)

end)

--------------------------------------------------
-- VIEW PLAYER
--------------------------------------------------

local viewing = false

MainTab:AddToggle({

Name = "view player",

Callback = function(v)

viewing = v

if not v then

workspace.CurrentCamera.CameraSubject =
LocalPlayer.Character.Humanoid

end

end

})


RunService.RenderStepped:Connect(function()

if viewing
and selectedPlayer
and selectedPlayer.Character
then

workspace.CurrentCamera.CameraSubject =
selectedPlayer.Character.Humanoid

end

end)

--------------------------------------------------
-- GOTO PLAYER
--------------------------------------------------

MainTab:AddButton({

Name = "goto player",

Callback = function()

if selectedPlayer
and selectedPlayer.Character
then

LocalPlayer.Character.HumanoidRootPart.CFrame =
selectedPlayer.Character.HumanoidRootPart.CFrame
+ Vector3.new(0,3,0)

end

end

})

--------------------------------------------------
-- FLING PLAYER
--------------------------------------------------

MainTab:AddButton({

Name = "fling player",

Callback = function()

if not selectedPlayer then return end

local args = {
"PickingTools",
"Couch"
}

ReplicatedStorage
:WaitForChild("RE")
:WaitForChild("1Too1l")
:InvokeServer(unpack(args))

local TOOL_NAME = "Couch"

local ativo = true
local posicaoOriginal
local codigoExecutado = false

local DESTINO_FINAL =
CFrame.new(
139383728,
521392544,
46955772
)

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

local args = {
"PickingTools",
TOOL_NAME
}

ReplicatedStorage
:WaitForChild("RE")
:WaitForChild("1Too1l")
:InvokeServer(unpack(args))

repeat task.wait() until getTool()

codigoExecutado = true

end

local function equiparSempre()

local char = LocalPlayer.Character

local humanoid =
char and char:FindFirstChildOfClass("Humanoid")

local tool = getTool()

if humanoid and tool then

if tool.Parent ~= char then
humanoid:EquipTool(tool)
end

end

end

local function sentou(plr)

local char = plr and plr.Character

local hum =
char and char:FindFirstChildOfClass("Humanoid")

if hum and hum.Sit then
return true
end

return false

end

local function pararTudo()

ativo = false

local char = LocalPlayer.Character
if not char then return end

local humanoid =
char:FindFirstChildOfClass("Humanoid")

if humanoid then
humanoid:UnequipTools()
end

local root =
char:FindFirstChild("HumanoidRootPart")

if root and posicaoOriginal then
root.CFrame = posicaoOriginal
end

local args = {
"ClearAllTools"
}

ReplicatedStorage
:WaitForChild("RE")
:WaitForChild("1Clea1rTool1s")
:FireServer(unpack(args))

end


RunService.RenderStepped:Connect(function()

if not ativo then return end

local char = LocalPlayer.Character
if not char then return end

local root =
char:FindFirstChild("HumanoidRootPart")

local humanoid =
char:FindFirstChildOfClass("Humanoid")

if not root or not humanoid then return end

if not posicaoOriginal then
posicaoOriginal = root.CFrame
end

garantirTool()
equiparSempre()

local alvo = selectedPlayer

if not alvo then return end

local alvoRoot =
alvo.Character and
alvo.Character:FindFirstChild("HumanoidRootPart")

if not alvoRoot then return end

root.CFrame =
root.CFrame:Lerp(
alvoRoot.CFrame,
0.8
)

root.CFrame =
root.CFrame *
CFrame.Angles(

math.rad(math.random(-900,900)),
math.rad(math.random(-900,900)),
math.rad(math.random(-900,900))

)

if sentou(alvo) then

for i = 1,20 do

root.CFrame =
root.CFrame:Lerp(
DESTINO_FINAL,
1
)

task.wait()

end

pararTudo()

end

end)

end

})

--------------------------------------------------
-- BLACK HOLE PLAYER
--------------------------------------------------

if not getgenv().Network then

getgenv().Network = {

BaseParts = {},

Velocity =
Vector3.new(
14.46262424,
14.46262424,
14.46262424)

}

Network.RetainPart =
function(part)

if part:IsA("BasePart")
and part:IsDescendantOf(Workspace)
then

table.insert(Network.BaseParts,part)

part.CustomPhysicalProperties =
PhysicalProperties.new(0,0,0,0,0)

part.CanCollide = false

end

end


RunService.Heartbeat:Connect(function()

sethiddenproperty(
LocalPlayer,
"SimulationRadius",
math.huge
)

for _, part in pairs(Network.BaseParts) do

if part:IsDescendantOf(Workspace) then

part.Velocity =
Network.Velocity

end

end

end)

end


local Folder =
Instance.new("Folder",Workspace)

local CenterPart =
Instance.new("Part")

CenterPart.Parent = Folder
CenterPart.Anchored = true
CenterPart.CanCollide = false
CenterPart.Transparency = 1

local Attachment1 =
Instance.new("Attachment")

Attachment1.Parent =
CenterPart


local function ForcePart(v)

if
v:IsA("BasePart")
and not v.Anchored
and not v.Parent:FindFirstChildOfClass("Humanoid")
and not v.Parent:FindFirstChild("Head")
and v.Name ~= "Handle"

then

for _, obj in ipairs(v:GetChildren()) do

if
obj:IsA("BodyMover")
or obj:IsA("RocketPropulsion")
or obj:IsA("Torque")
or obj:IsA("AlignPosition")
or obj:IsA("AlignOrientation")

then
obj:Destroy()
end

end

if v:FindFirstChild("Attachment") then
v.Attachment:Destroy()
end

v.CanCollide = false

local Torque =
Instance.new("Torque")

Torque.Torque =
Vector3.new(100000,100000,100000)

Torque.Parent = v

local AlignPosition =
Instance.new("AlignPosition")

AlignPosition.MaxForce =
math.huge

AlignPosition.MaxVelocity =
math.huge

AlignPosition.Responsiveness =
200

local Attachment2 =
Instance.new("Attachment")

Attachment2.Parent = v

Torque.Attachment0 =
Attachment2

AlignPosition.Attachment0 =
Attachment2

AlignPosition.Attachment1 =
Attachment1

AlignPosition.Parent = v

Network.RetainPart(v)

end

end


local blackHoleActive = false
local followConnection
local DescendantAddedConnection


local function startBlackHole(player)

local character =
player.Character
or player.CharacterAdded:Wait()

local hrp =
character:WaitForChild(
"HumanoidRootPart"
)

for _, v in ipairs(
Workspace:GetDescendants()
) do

ForcePart(v)

end

DescendantAddedConnection =
Workspace.DescendantAdded:Connect(function(v)

if blackHoleActive then
ForcePart(v)
end

end)

followConnection =
RunService.RenderStepped:Connect(function()

if blackHoleActive then

Attachment1.WorldCFrame =
hrp.CFrame

end

end)

end


local function stopBlackHole()

if DescendantAddedConnection then
DescendantAddedConnection:Disconnect()
end

if followConnection then
followConnection:Disconnect()
end

end


MainTab:AddToggle({

Name = "black hole player",

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

--------------------------------------------------
-- CONFIG TAB
--------------------------------------------------

local ConfigTab =
Window:MakeTab({

Title = "Config",
Icon = "Settings"

})

local speed = 16
local jump = 50

ConfigTab:AddSlider({

Name = "speed",
Min = 16,
Max = 200,
Default = 16,

Callback = function(v)
speed = v
end

})

ConfigTab:AddSlider({

Name = "jump",
Min = 50,
Max = 200,
Default = 50,

Callback = function(v)
jump = v
end

})

RunService.RenderStepped:Connect(function()

local char =
LocalPlayer.Character

if char then

local hum =
char:FindFirstChildOfClass("Humanoid")

if hum then

hum.WalkSpeed = speed
hum.JumpPower = jump

end

end

end)

ConfigTab:AddToggle({

Name = "no gravity",

Callback = function(v)

if v then
Workspace.Gravity = 0
else
Workspace.Gravity = 196.2
end

end

})

--------------------------------------------------
-- FLY
--------------------------------------------------

local flying = false

ConfigTab:AddToggle({

Name = "fly",

Callback = function(v)

flying = v

local char =
LocalPlayer.Character

if not char then return end

local root =
char:FindFirstChild("HumanoidRootPart")

if not root then return end

if v then

local bv =
Instance.new("BodyVelocity")

bv.Name = "fly"

bv.MaxForce =
Vector3.new(math.huge,math.huge,math.huge)

bv.Parent = root

RunService:BindToRenderStep(

"fly",

Enum.RenderPriority.Character.Value,

function()

local cam =
workspace.CurrentCamera

local move =
char.Humanoid.MoveDirection

bv.Velocity =

(cam.CFrame.LookVector * move.Z
+ cam.CFrame.RightVector * move.X)

* 60

end)

else

RunService:UnbindFromRenderStep("fly")

if root:FindFirstChild("fly") then
root.fly:Destroy()
end

end

end

})

--------------------------------------------------
-- TOOLS TAB
--------------------------------------------------

local ToolsTab =
Window:MakeTab({

Title = "Tools",
Icon = "Axe"

})

ToolsTab:AddButton({

Name = "get Couch",

Callback = function()

local args = {
"PickingTools",
"Couch"
}

ReplicatedStorage
:WaitForChild("RE")
:WaitForChild("1Too1l")
:InvokeServer(unpack(args))

end

})

ToolsTab:AddButton({

Name = "teleport tool",

Callback = function()

local tool =
Instance.new("Tool")

tool.RequiresHandle = false
tool.Name = "tp tool"

tool.Activated:Connect(function()

local mouse =
LocalPlayer:GetMouse()

LocalPlayer.Character
.HumanoidRootPart.CFrame =
CFrame.new(mouse.Hit.Position)

end)

tool.Parent =
LocalPlayer.Backpack

end

})

--------------------------------------------------
-- DISCORD TAB
--------------------------------------------------

local DiscordTab =
Window:MakeTab({

Title = "Discord",
Icon = "MessageCircle"

})

DiscordTab:AddDiscordInvite({

Title = "redz Hub | Community",

Description =
"A community for redz Hub Users",

Banner =
"rbxassetid://17382040552",

Logo =
"rbxassetid://17382040552",

Invite =
"https://discord.gg/redz-hub",

Members = 470000,
Online = 20000

})

--------------------------------------------------
-- NOTIFY
--------------------------------------------------

Window:Notify({

Title = "Lorenzo hub",
Content = "loaded",
Duration = 5

})
