local ELEMENT = {}
function ELEMENT:Init()

	self.titleBar = vgui.Create("deadremains.sec_panel_title_bar", self)
	self.titleBar:SetSize(540, 100)
	self.titleBar:SetPos(0, 0)

	self.inventories = {}
	self.inventory_panels = {}

end

function ELEMENT:rebuild()
	local activeID = 0
	if self.activeInventory then

		activeID = self.activeInventory:getID()

	end

	for _, v in pairs(self.inventory_panels) do

		v.panel:Remove()

	end

	local h = 0
	if activeID == 0 then

		local v = self.inventories[1]

		local inv = vgui.Create("deadremains.inventory_entry", self)
		inv:SetPos(0, 102)
		inv:setGridSize(v.slotX, v.slotY)
		inv:setID(v.id)
		inv:setName(v.name)
		inv:setCapacity(v.capacity)
		inv:setSlotSize(v.slotX * v.slotY)
		inv:setSelected(true)

		h = v.slotY * 60 + 78

		self.inventory_panels[v.id] = {pos = 1, panel = inv}

		self.activeInventory = inv

	else

		for _, v in pairs(self.inventories) do

			if activeID == v.id then

				local inv = vgui.Create("deadremains.inventory_entry", self)
				inv:SetPos(0, 102)
				inv:setGridSize(v.slotX, v.slotY)
				inv:setID(v.id)
				inv:setName(v.name)
				inv:setCapacity(v.capacity)
				inv:setSlotSize(v.slotX * v.slotY)
				inv:setSelected(true)

				h = v.slotY * 60 + 78

				self.inventory_panels[v.id] = {pos = 1, panel = inv}

				self.activeInventory = inv

			end

		end

	end

	local pos = 2
	activeID = self.activeInventory:getID()
	for k, v in pairs(self.inventories) do

		if activeID != v.id or (activeID == 0 and k != 1) then

			local inv = vgui.Create("deadremains.inventory_entry", self)
			inv:SetPos(0, 102 + h)
			inv:setGridSize(v.slotX, v.slotY)
			inv:setID(v.id)
			inv:setName(v.name)
			inv:setCapacity(v.capacity)
			inv:setSlotSize(v.slotX * v.slotY)
			inv:setSelected(false)

			self.inventory_panels[v.id] = {pos = pos, panel = inv}

			inv:minimize()

			pos = pos + 1

			h = h + 115

		end

	end

end

function ELEMENT:addInventory(id, name, slotX, slotY, maxWeight)
	table.insert(self.inventories, {id = id, name = name, slotX = slotX, slotY = slotY, capacity = maxWeight})

	self:rebuild()

end

function ELEMENT:removeInventory(id)
	for k, v in pairs(self.inventories) do

		if v.id == id then

			table.remove(self.inventories, k)

			if self.activeInventory and self.activeInventory:getID() == id then

				self.activeInventory = nil

			end

		end

	end

end

function ELEMENT:addItem(inv, name, slot)

	local slotsX = deadremains.item.get(name).slots_horizontal
	local slotsY = deadremains.item.get(name).slots_vertical
	local weight = deadremains.item.get(name).weight

	if (self.inventory_panels[inv] ~= nil) then
		self.inventory_panels[inv].panel:addItem(name, slot.x, slot.y, slotsX, slotsY, weight)
	end
end

function ELEMENT:removeItem(inv, slot)

	self.inventory_panels[inv].panel:removeItem(slot.x, slot.y)

end

function ELEMENT:clearAllItems(inv)
	--print("inv panels", self.inventory_panels, #self.inventory_panels)

	if self.inventory_panels[inv] ~= nil then 
		self.inventory_panels[inv].panel:clearAllItems()
		return true
	else
		return false
	end
end

function ELEMENT:OnMouseWheeled(dt)

	local h = -100
	local children = self:GetChildren()
	for _, v in pairs(children) do

			h = h + v:GetTall()

	end

	for _, v in pairs(self.inventory_panels) do

		local x, y = v.panel:GetPos()
		v.panel:SetPos(x, math.Clamp(y + dt * 10, 100, h))
		--print(dt * 10, -h, math.Clamp(y + dt * 10, 100, h))

	end

end

function ELEMENT:minimize(id)

	local pos = self.inventory_panels[id].pos
	local panel = self.inventory_panels[id].panel

	local y = panel.sizeY

	local toRem = y * 60 + 78 + 83 - 115

	for _, v in pairs(self.inventory_panels) do

		if v.pos > pos then

			local _, yPos = v.panel:GetPos()

			v.panel:SetPos(0, yPos - toRem)

		end

	end

end

function ELEMENT:maximize(id)

	local pos = self.inventory_panels[id].pos
	local panel = self.inventory_panels[id].panel

	local y = panel.sizeY

	local toAdd = y * 60 + 78 + 83 - 115

	for _, v in pairs(self.inventory_panels) do

		if v.pos > pos then

			local _, yPos = v.panel:GetPos()

			v.panel:SetPos(0, yPos + toAdd)

		end

	end

end

function ELEMENT:Paint(w, h)

	surface.SetDrawColor(deadremains.ui.colors.clr1)
	surface.DrawRect(0, 102, w, h)

end
vgui.Register("deadremains.secondary_inventory_panel", ELEMENT, "Panel")