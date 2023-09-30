--// Librarys \\--
local HashLib = require(game.ReplicatedStorage.AntiCheat.HashLib)
local TriggerType = require(game.ReplicatedStorage.AntiCheat.TriggerTypes)
local Discord = require(script.Parent.Discord)
local Http = game:GetService("HttpService")

--// Variables \\--
local PlayerData = {}


--// Player Connections \\--
game.Players.PlayerAdded:Connect(function(Plr)
	PlayerData[Plr.UserId] = {
		Salt = "",
		LastPing = time(),
		Index = -1,
		InitPing = false,
		LastPosition = Vector3.new(0,0,0)
	}
end)

game.Players.PlayerRemoving:Connect(function(Plr)
	PlayerData[Plr.UserId] = nil
end)

--// Tokens \\--
local function createToken(Plr:Player):string
	local Data = PlayerData[Plr.UserId]
	local Val = math.noise(
		-Data.Index * tonumber("1.".. Plr.UserId),
		Data.Index * tonumber("1." .. Plr.UserId),
		-Data.Index * tonumber("1." .. Plr.UserId)
	)
	Data.Index += 1
	local Hash = HashLib.sha256(tostring(Val) .. Data.Salt)
	return Hash
end

local function Punish(Plr:Player, Type:TriggerType)
	print(Type)
	--if game:GetService("RunService"):IsStudio() then return end
	if Type.Alert then
		Discord.SendEmbed(Plr, Type)
	end
end

coroutine.resume(coroutine.create(function()
	while wait(1) do
		for i, v in ipairs(game.Players:GetChildren()) do
			if PlayerData[v.UserId].LastPing <= time() - 2.5 then
				Punish(v, TriggerType.MissedPing)
			end
		end
	end
end))

return {
	createToken=createToken,
	PlayerData=PlayerData,
	Punish=Punish
}
