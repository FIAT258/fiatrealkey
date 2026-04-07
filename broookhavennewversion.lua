--------------------------------------------------
-- SERVICES
--------------------------------------------------

local WindUI = loadstring(game:HttpGet(
"https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"
))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

--------------------------------------------------
-- BLACK HOLE LOGIC (ORIGINAL)
--------------------------------------------------

if not getgenv().Network then

getgenv().Network = {
BaseParts = {},
Velocity = Vector3.new(14.4626,14.4626,14.4626)
}

Network.RetainPart = function(part)

if part:IsA("BasePart")
and part:IsDescendantOf(workspace) then

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

if part:IsDescendantOf(workspace) then
part.Velocity = Network.Velocity
end

end

end)

end


local Folder = Instance.new("Folder",workspace)

local CenterPart = Instance.new("Part")
CenterPart.Parent = Folder
CenterPart.Anchored = true
CenterPart.CanCollide = false
CenterPart.Transparency = 1

local Attachment1 = Instance.new("Attachment",CenterPart)


local function ForcePart(v)

if v:IsA("BasePart")
and not v.Anchored
and not v.Parent:FindFirstChildOfClass("Humanoid")
and not v.Parent:FindFirstChild("Head")
and v.Name ~= "Handle" then

for _, obj in ipairs(v:GetChildren()) do

if obj:IsA("BodyMover")
or obj:IsA("RocketPropulsion")
or obj:IsA("Torque")
or obj:IsA("AlignPosition")
or obj:IsA("AlignOrientation") then

obj:Destroy()

end

end

if v:FindFirstChild("Attachment") then
v.Attachment:Destroy()
end

v.CanCollide = false

local Torque = Instance.new("Torque")
Torque.Torque = Vector3.new(100000,100000,100000)
Torque.Parent = v

local AlignPosition = Instance.new("AlignPosition")

AlignPosition.MaxForce = math.huge
AlignPosition.MaxVelocity = math.huge
AlignPosition.Responsiveness = 200

local Attachment2 = Instance.new("Attachment",v)

Torque.Attachment0 = Attachment2

AlignPosition.Attachment0 = Attachment2
AlignPosition.Attachment1 = Attachment1

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
character:WaitForChild("HumanoidRootPart")

for _, v in ipairs(workspace:GetDescendants()) do
ForcePart(v)
end

DescendantAddedConnection =
workspace.DescendantAdded:Connect(function(v)

if blackHoleActive then
ForcePart(v)
end

end)


followConnection =
RunService.RenderStepped:Connect(function()

if blackHoleActive then
Attachment1.WorldCFrame = hrp.CFrame
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

--------------------------------------------------
-- FLING LOGIC
--------------------------------------------------

local function flingTarget(target)

local character = LocalPlayer.Character
if not character then return end

local hrp = character:FindFirstChild("HumanoidRootPart")
if not hrp then return end

local targetChar = target.Character
if not targetChar then return end

local targetHRP =
targetChar:FindFirstChild("HumanoidRootPart")

if not targetHRP then return end

local bp = Instance.new("BodyAngularVelocity")
bp.AngularVelocity =
Vector3.new(999999,999999,999999)

bp.MaxTorque = Vector3.new(
math.huge,
math.huge,
math.huge
)

bp.Parent = hrp

for i=1,50 do

hrp.CFrame =
targetHRP.CFrame
* CFrame.new(0,0,1)

RunService.RenderStepped:Wait()

end

bp:Destroy()

end

--------------------------------------------------
-- WINDOW
--------------------------------------------------

local Window = WindUI:CreateWindow({

Title="Lorenzo hub --- brookhaven",
Author="lorenzo",
Folder="lorenzohub",

Icon="zap",

Theme="Dark",

ToggleKey=Enum.KeyCode.RightShift,

Size=UDim2.fromOffset(680,460)

})

--------------------------------------------------
-- TABS
--------------------------------------------------

local MainTab =
Window:Tab({Title="Main",Icon="home"})

local SoundTab =
Window:Tab({Title="Sound",Icon="volume-2"})

local ConfigTab =
Window:Tab({Title="Config",Icon="settings"})

local ToolsTab =
Window:Tab({Title="Tools",Icon="tool"})

local DiscordTab =
Window:Tab({Title="Discord",Icon="message-circle"})

local UIConfigTab =
Window:Tab({Title="UI Config",Icon="book"})

--------------------------------------------------
-- PLAYER DROPDOWN
--------------------------------------------------

local selectedPlayer=nil

local function getPlayers()

local t={}

for _,p in pairs(
Players:GetPlayers()
) do

if p~=LocalPlayer then
table.insert(t,p.Name)
end

end

return t

end


local PlayerDropdown =
MainTab:Dropdown({

Title="Player",

Values=getPlayers(),

Callback=function(v)

selectedPlayer =
Players:FindFirstChild(v)

end

})


Players.PlayerAdded:Connect(function()
PlayerDropdown:Refresh(getPlayers())
end)

Players.PlayerRemoving:Connect(function()
PlayerDropdown:Refresh(getPlayers())
end)

--------------------------------------------------
-- VIEW PLAYER
--------------------------------------------------

local viewing=false

MainTab:Toggle({

Title="view player",

Callback=function(v)

viewing=v

if not v then

workspace.CurrentCamera.CameraSubject=
LocalPlayer.Character.Humanoid

end

end

})


RunService.RenderStepped:Connect(function()

if viewing
and selectedPlayer
and selectedPlayer.Character then

workspace.CurrentCamera.CameraSubject=
selectedPlayer.Character.Humanoid

end

end)

--------------------------------------------------
-- GOTO
--------------------------------------------------

MainTab:Button({

Title="goto player",

Callback=function()

if selectedPlayer
and selectedPlayer.Character then

LocalPlayer.Character
.HumanoidRootPart.CFrame =
selectedPlayer.Character
.HumanoidRootPart.CFrame
+Vector3.new(0,3,0)

end

end

})

--------------------------------------------------
-- FLING
--------------------------------------------------

MainTab:Button({

Title="fling player",

Callback=function()

if selectedPlayer then
flingTarget(selectedPlayer)
end

end

})

--------------------------------------------------
-- BLACK HOLE
--------------------------------------------------

MainTab:Toggle({

Title="black hole player",

Callback=function(v)

blackHoleActive=v

if v
and selectedPlayer then

startBlackHole(selectedPlayer)

else

stopBlackHole()

end

end

})

--------------------------------------------------
-- SOUND TAB
--------------------------------------------------

local audioID=""
local audioVolume=0.5
local audioLoop=false


SoundTab:Input({

Title="audio id",

Callback=function(text)

audioID=text

end

})


SoundTab:Slider({

Title="volume",

Min=0.1,
Max=1,

Value=0.5,

Callback=function(v)

audioVolume=v

end

})


SoundTab:Button({

Title="play audio",

Callback=function()

if audioID~="" then

local sound=
Instance.new("Sound")

sound.SoundId=
"rbxassetid://"..audioID

sound.Volume=audioVolume

sound.Parent=
LocalPlayer.Character
.HumanoidRootPart

sound:Play()

end

end

})


SoundTab:Toggle({

Title="loop audio",

Callback=function(v)

audioLoop=v

spawn(function()

while audioLoop do

if audioID~="" then

local sound=
Instance.new("Sound")

sound.SoundId=
"rbxassetid://"..audioID

sound.Volume=audioVolume

sound.Parent=
LocalPlayer.Character
.HumanoidRootPart

sound:Play()

end

task.wait(1)

end

end)

end

})

--------------------------------------------------
-- CONFIG TAB
--------------------------------------------------

local speed=16
local jump=50


ConfigTab:Slider({

Title="speed",

Min=16,
Max=200,

Value=16,

Callback=function(v)

speed=v

end

})


ConfigTab:Slider({

Title="jump",

Min=50,
Max=200,

Value=50,

Callback=function(v)

jump=v

end

})


RunService.RenderStepped:Connect(function()

local char =
LocalPlayer.Character

if char then

local hum =
char:FindFirstChildOfClass(
"Humanoid"
)

if hum then

hum.WalkSpeed=speed
hum.JumpPower=jump

end

end

end)


ConfigTab:Toggle({

Title="no gravity",

Callback=function(v)

Workspace.Gravity=
v and 0 or 196.2

end

})

--------------------------------------------------
-- TOOLS TAB
--------------------------------------------------

ToolsTab:Button({

Title="get Couch",

Callback=function()

ReplicatedStorage
.RE
["1Too1l"]
:InvokeServer(
"PickingTools",
"Couch"
)

end

})


ToolsTab:Button({

Title="tp tool",

Callback=function()

local tool=
Instance.new("Tool")

tool.RequiresHandle=false

tool.Name="tp tool"

tool.Activated:Connect(function()

local mouse=
LocalPlayer:GetMouse()

LocalPlayer.Character
.HumanoidRootPart.CFrame =
CFrame.new(
mouse.Hit.Position
)

end)

tool.Parent=
LocalPlayer.Backpack

end

})

--------------------------------------------------
-- UI CONFIG TAB
--------------------------------------------------

UIConfigTab:Dropdown({

Title="theme",

Values=(function()

local t={}

for name in pairs(
WindUI:GetThemes()
) do

table.insert(t,name)

end

return t

end)(),

Callback=function(v)

WindUI:SetTheme(v)

end

})


UIConfigTab:Keybind({

Title="toggle key",

Value=Enum.KeyCode.RightShift,

Callback=function(v)

Window:SetToggleKey(v)

end

})

--------------------------------------------------
-- DISCORD TAB
--------------------------------------------------

DiscordTab:Button({

Title="copy discord",

Callback=function()

setclipboard(
"https://discord.gg/redz-hub"
)

WindUI:Notify({

Title="discord",

Content="copiado"

})

end

})

--------------------------------------------------
-- NOTIFY
--------------------------------------------------

WindUI:Notify({

Title="Lorenzo hub",

Content="loaded"

})
