----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function deadremains.item.spawn(player, unique)
	local trace = player:eyeTrace(192)

	local item = deadremains.item.get(unique)

	if (item) then
		local entity = ents.Create("deadremains_item")
		entity:SetPos(trace.HitPos)
		entity:SetModel(item.model)
		entity:Spawn()
	end
end