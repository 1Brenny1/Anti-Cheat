--// Services \\--
local HTTP = game:GetService("HttpService")
local TriggerType = require(game.ReplicatedStorage.AntiCheat.TriggerTypes)

--// Constants \\--
local WEBHOOK = "WEBHOOK HERE"

function SendEmbed(Plr:Player, Type:TriggerType)
	
	local Description = ""
	local color = tonumber(0x5555FF)
	if Type.Ban then
		Description = "**Banned for:** ``" .. Type.Reason .. "``"
		color = tonumber(0xFF5555)
	elseif Type.Kick then
		Description = "**Kicked for:** ``" .. Type.Reason .. "``"
		color = tonumber(0xFFFF55)
	else
		Description = "**Caused a:** ``" .. Type.Reason .. "``"
	end
	
	local data = {
		["embeds"] = {{

			["author"] = {
				["name"] = Plr.Name,
				["icon_url"] = "https://www.roblox.com/Thumbs/Avatar.ashx?x=100&y=100&username="..Plr.Name
			},
			["description"] = Description,
			["color"] = color,
			["fields"] = {
				{
					["name"] = "User ID:",
					["value"] = Plr.UserId,
					["inline"] = true
				},
				{
					["name"] = "Account Age:",
					["value"] = math.round((Plr.AccountAge/360 * 100))/100 .. " year(s) old",
					["inline"] = true
				}
			}
		}},

	}
	Send(data)
end

function Send(Data)
	local finalData = HTTP:JSONEncode(Data)
	HTTP:PostAsync(WEBHOOK, finalData)
end

return {SendEmbed = SendEmbed}
