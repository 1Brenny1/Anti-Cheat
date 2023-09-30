--// Librarys \\--

local TriggerType = require(game.ReplicatedStorage.AntiCheat.TriggerTypes)
local Utils = require(script.Parent.ClientUtils)

--// Constants \\--
local REP = game.ReplicatedStorage.AntiCheat
local PLR = game.Players.LocalPlayer
local CHAR = PLR.Character or PLR.CharacterAdded:Wait()

--// Variables \\--
local Caught:TriggerType = nil

--// Initial Ping \\--

local function InitPing()
	local PingData = {
		Salt=Utils.Salt,
		Index=Utils.Index
	}
	REP.Ping:FireServer("", PingData)
end
InitPing()

--// Local Hacks \\--

CHAR:WaitForChild("HumanoidRootPart").ChildAdded:Connect(function(Obj)
	if 
		Obj.ClassName == "BodyGyro" or 
		Obj.ClassName == "BodyPosition" or 
		Obj.ClassName == "BodyVelocity" or 
		Obj.ClassName == "BodyForce"
	then
		Caught = TriggerType.Flight
	end
end)

PLR.Backpack.ChildAdded:Connect(function(Obj)
	if Obj:IsA("HopperBin") then
		Caught = TriggerType.BTools
	end
end)

coroutine.resume(coroutine.create(function()
	local LastPos = CHAR:WaitForChild("HumanoidRootPart").Position
	local Timer = time()
	PLR.CharacterAdded:Connect(function(Char)
		LastPos = Char:WaitForChild("HumanoidRootPart").Position
	end)
	PLR.CharacterRemoving:Connect(function(Char)
		Timer = time()
	end)
	
	game:GetService("RunService").Heartbeat:Connect(function()
		if not CHAR:WaitForChild("HumanoidRootPart") then return end
		if Timer >= time()-5 then
			LastPos = CHAR.HumanoidRootPart.Position
		end
		
		if (CHAR.HumanoidRootPart.Position - LastPos).Magnitude >= (CHAR.Humanoid.WalkSpeed / 16) * 4 then
			Caught = TriggerType.Move
		end
		LastPos = CHAR.HumanoidRootPart.Position
	end)
end))


--// Update Ping \\--

coroutine.resume(coroutine.create(function()
	while wait(1) do
		CHAR = PLR.Character or PLR.CharacterAdded:Wait()
		local Tools = {}
		for i, v in ipairs(PLR.Backpack:GetChildren()) do
			table.insert(Tools, v.Name)
		end
		local PingData = {
			Caught=Caught,
			Backpack=Tools,
			Speed=CHAR.Humanoid.WalkSpeed,
			Jump=CHAR.Humanoid.JumpHeight,
			Health=CHAR.Humanoid.Health,
			MaxHealth=CHAR.Humanoid.MaxHealth
		}
		REP.Ping:FireServer(Utils.createToken(PLR), PingData)
		if game:GetService("RunService"):IsStudio() then
			Caught = nil
		end
	end
end))
--[[
local Service = game:GetService("TextService")
Service.Name = "CoreGui"
Service.ChildAdded:Connect(function()
	Caught = TriggerType.CoreGui
end)
]]
