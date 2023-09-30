local Triggers = {
	
	-- Ping Catches
	MissedPing = { -- Occures when a ping is missed
		Reason = "Missed Ping!",
		Alert = true,
		Kick = true,
		Ban = false
	},
	InvalidPing = { -- Occures when the Hash is invalid (Posible Ping Replication)
		Reason = "Invalid Ping!",
		Alert = true,
		Kick = true,
		Ban = true
	},
	
	-- Cheat Detections
	Speed = {
		Reason = "Speed Hacks Detected!",
		Alert = true,
		Kick = true,
		Ban = true
	},
	Jump = {
		Reason = "Jump Hacks Detected!",
		Alert = true,
		Kick = true,
		Ban = true
	},
	Move = {
		Reason = "Teleport Hacks Detected!",
		Alert = true,
		Kick = true,
		Ban = true
	},
	NoClip = {
		Reason = "NoClip Detected!",
		Alert = true,
		Kick = true,
		Ban = true
	},
	Health = { -- Occures when local health and max health does not match server health and max health
		Reason = "Health Hacks Detected!",
		Alert = true,
		Kick = true,
		Ban = true
	},
	Flight = {
		Reason = "Fly Hacks Detected!",
		Alert = true,
		Kick = true,
		Ban = true
	},
	Backpack = {
		Reason = "Invalid Backpack Content Detected!",
		Alert = true,
		Kick = true,
		Ban = true
	},
	BTools = {
		Reason = "BTools Detected!",
		Alert = true,
		Kick = true,
		Ban = true
	},
	CoreGui = {
		Reason = "UI Inject Detected!",
		Alert = true,
		Kick = true,
		Ban = true
	}
}

return Triggers
