--local invs = deadremains.settings.get("default_inventories")
LocalPlayer().Inventories = {}

net.Receive("deadremains.networkinventory", function(bits)
	local itemCount = net.ReadUInt(16)

	if (itemCount > 0) then
		LocalPlayer().Inventories = {}

		for i=1, itemCount do
			local invName = net.ReadString()
			local itemName = net.ReadString()
			local itemSlotPos = net.ReadVector()

			table.insert(LocalPlayer().Inventories, {
					InventoryName = invName,
					ItemUnique = itemName,
					SlotPosition = itemSlotPos
				})
		end

		PrintTable(LocalPlayer().Inventories)
	end
	
end)

function player_meta:InventoryItemAction(action_name, inventory_name, item_unique, item_slot_position)
	net.Start("deadremains.itemaction")
		net.WriteString(action_name)
		net.WriteString(inventory_name)
		net.WriteString(item_unique)
		net.WriteVector(item_slot_position)
	net.SendToServer()
end
concommand.Add("dropbeans", function()
	LocalPlayer():InventoryItemAction("consume", "hunting_backpack", "tin_beans", Vector(0,0,0))
end)