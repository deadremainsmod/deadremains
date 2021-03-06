--! @module serverside player class, loads all dependencies.

-- be careful with order here...
include("player/sv_team.lua")
include("player/sv_needs.lua")
include("player/sv_chars.lua")
include("player/sv_skills.lua")
include("player/sv_inventory.lua")
include("player/sv_init.lua")

--! @brief global network function to send all the required data to the client at runtime.
deadremains.netrequest.create("deadremains.syncdata", function (ply, data)
	
	ply:networkChars()

	ply:networkSkills()

	deadremains.character.networkFlags(ply)

	-- pingback
	if (data) then
		return data
	end
end)