--// Librarys \\--

local TriggerType = require(game.ReplicatedStorage.AntiCheat.TriggerTypes)
local Utils = require(script.Parent.CoreUtils)

--// Constants \\--
local Rep = game.ReplicatedStorage.AntiCheat


Rep.Ping.OnServerEvent:Connect(function(Plr, Token, Data)
	if not Utils.PlayerData[Plr.UserId].InitPing then
		Utils.PlayerData[Plr.UserId].InitPing = true
		Utils.PlayerData[Plr.UserId].Salt = Data.Salt
		Utils.PlayerData[Plr.UserId].Index = Data.Index
		return
	end
	
	local PlrData = Utils.PlayerData[Plr.UserId]
	PlrData.LastPing = time()
	
	if Token == Utils.createToken(Plr) then
		local Char = Plr.Character or Plr.CharacterAdded:Wait()
		
		if Data.Caught ~= nil then
			Utils.Punish(Plr, Data.Caught)
		end
		if Data.Health ~= Char.Humanoid.Health or Data.MaxHealth ~= Char.Humanoid.MaxHealth then
			Utils.Punish(Plr, TriggerType.Health)
		end	
		if Data.Speed ~= Char.Humanoid.WalkSpeed then
			Utils.Punish(Plr, TriggerType.Speed)
		end
		if Data.Jump ~= Char.Humanoid.JumpHeight then
			Utils.Punish(Plr, TriggerType.Jump)
		end
		
		local Tools = {}
		for i, v in ipairs(Plr.Backpack:GetChildren()) do
			table.insert(Tools,v.Name)
		end
		for i, v in ipairs(Data.Backpack) do
			if not table.find(Tools, v) then
				Utils.Punish(Plr, TriggerType.Backpack)
			end
		end
		
	else
		Utils.Punish(Plr, TriggerType.InvalidPing)
	end
end)

local Params = RaycastParams.new()
Params.FilterType = Enum.RaycastFilterType.Exclude
Params.IgnoreWater = true

game.Players.PlayerAdded:Connect(function(Plr)
	Plr.CharacterAdded:Connect(function(Char)
		Utils.PlayerData[Plr.UserId].LastPosition = Char.HumanoidRootPart.Position
	end)
end)

game:GetService("RunService").Heartbeat:Connect(function()
	for i, v in ipairs(game.Players:GetChildren()) do
		local Char = v.Character or v.CharacterAdded:Wait()
		if not Char:WaitForChild("HumanoidRootPart") then continue end
		Params.FilterDescendantsInstances = {Char}
		local Cast = game.Workspace:Raycast(Char.HumanoidRootPart.Position,Char.HumanoidRootPart.Position-Utils.PlayerData[v.UserId].LastPosition, Params)
		if Cast then
			if Cast.Instance.CanCollide then
				Utils.Punish(v, TriggerType.NoClip)
			end
		end
		Utils.PlayerData[v.UserId].LastPosition = Char.HumanoidRootPart.Position
	end
end)
