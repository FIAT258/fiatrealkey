debugX = true

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
	Name = "Key System",
	LoadingTitle = "Key System by fiat",
	LoadingSubtitle = "FIAT HUB",
	Theme = "Default",
	KeySystem = false
})

local Tab = Window:CreateTab("Key", "key")

local inputKey = ""

Tab:CreateInput({
	Name = "Digite sua Key",
	PlaceholderText = "pege em baixo",
	RemoveTextAfterFocusLost = false,
	Callback = function(text)
		inputKey = text
	end
})

Tab:CreateButton({
	Name = "Check Key",
	Callback = function()
		if not string.find(inputKey, "130") then
			return
		end

		if game.PlaceId ~= 18687417158 then
			player:Kick("Você está no jogo errado.")
			return
		end

		task.wait(2)
		loadstring(game:HttpGet(
			"https://raw.githubusercontent.com/FIAT258/fiathub2/main/code.lua",
			true
		))()

		Rayfield:Destroy()
	end
})

Tab:CreateButton({
	Name = "Pegar Key (Link)",
	Callback = function()
		if setclipboard then
			setclipboard("https://linkvertise.com/1460648/dNaQrIYkPzT9?o=sharing")
		end
	end
})

Rayfield:LoadConfiguration()
