ENT.Type = "anim"
ENT.Base = "base_anim"

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "ContainerIndex")
end

--[[
function ENT:SetItemID(network)
	self.dt.item_id = network
	
	if (SERVER) then
		self.itemData = ecrp.item.GetByNetwork(network)
	end
end

function ENT:GetItemID()
	return self.dt.item_id
end]]