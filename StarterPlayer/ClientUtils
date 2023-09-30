--// Librarys \\--
local HashLib = require(game.ReplicatedStorage.AntiCheat.HashLib)

--// Variables \\--

local function createSalt():string
	local Chars = string.split("AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890!@#$%^&*()-=_+", "")
	local Salt = ""
	for i=1, 50 do
		Salt = Salt .. Chars[math.random(1, #Chars)]
	end
	return Salt
end

local Salt = createSalt()
local Index = math.random(100000,999999)

--// Tokens \\--
local function createToken(Plr:Player):string
	local Val = math.noise(
		-Index * tonumber("1.".. Plr.UserId),
		Index * tonumber("1." .. Plr.UserId),
		-Index * tonumber("1." .. Plr.UserId)
	)
	Index += 1
	local Hash = HashLib.sha256(tostring(Val) .. Salt)
	return Hash
end

return {
	createToken = createToken,
	Salt = Salt,
	Index = Index
}
