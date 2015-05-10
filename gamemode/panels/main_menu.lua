local panel = {}

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:Init()
	self.dragging = {0, 0}

	self.panels = {}
	self.categories = {}

	self:DockPadding(0, 82, 0, 0)

	self.list = self:Add("Panel")
	self.list:Dock(LEFT)
	self.list:DockMargin(0, 0, 1, 0)
	self.list:SetWide(100)
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:getPanel(name)
	return self.panels[name]
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:addPanel(base, name, panel)
	if (IsValid(base)) then
		local panel = base:Add(panel)
		
		self.panels[name] = panel
		
		return panel
	else
		self.panels[name] = panel
	end
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:openCategory(name)
	local data = self.categories[string.lower(name)]
	
	if (data) then
		self:switchParent(data.parent, data.callback)
	end
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:switchParent(parent, callback)
	if (IsValid(parent)) then
		local current = self.last_parent
		
		if (IsValid(current)) then
			current:SetVisible(false)
		end
		
		parent:SetVisible(true)
		
		if (callback) then
			callback(parent)
		end
		
		self.last_parent = parent
	else
		if (callback) then
			callback(parent)
		end
	end
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:parent()
	local panel = self:Add("EditablePanel")
	panel:Dock(FILL)
	panel:SetVisible(false)
	
	return panel
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:addCategory(name, icon, callback, no_parent)
	local parent
	
	if (!no_parent) then
		parent = self:parent()
	end
	
	local panel = self.list:Add("Panel")
	panel:SetTall(100)
	panel:Dock(TOP)
	panel:DockMargin(0, 0, 0, 2)
	panel:SetCursor("hand")
	
	function panel.OnMousePressed()
		self:switchParent(parent, callback)
	end
	
	function panel:Paint(w, h)
		draw.RoundedBox(2, 0, 0, w, h, panel_color_background)

		if (icon) then
			draw.Material(w *0.5 -16, h *0.5 -16, 32, 32, color_white, icon)
		end
	end
	
	self.list:InvalidateLayout(true)
	self.list:SizeToChildren(false, true)
	
	self.categories[string.lower(name)] = {callback = callback, parent = parent}
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:OnMousePressed()
	if (gui.MouseY() < self.y +20) then
		self.dragging[1] = gui.MouseX() -self.x
		self.dragging[2] = gui.MouseY() -self.y
		
		self:MouseCapture(true)
	end
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:OnMouseReleased()
	self.dragging = {0, 0}

	self:MouseCapture(false)
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:Think()
	if (self.dragging[1] != 0) then
		local x = gui.MouseX() -self.dragging[1]
		local y = gui.MouseY() -self.dragging[2]
		
		x = math.Clamp(x, 0, ScrW() -self:GetWide())
		y = math.Clamp(y, 0, ScrH() -self:GetTall())
		
		self:SetPos(x, y)
	end
	
	if (self.Hovered and gui.MouseY() < self.y +20) then
		self:SetCursor("sizeall")
		
		return
	end
	
	self:SetCursor("arrow")
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:PerformLayout()
	--local w, h = self:GetSize()
	
	--self.list:SetWide(100)
	--self.list:SetPos(0, 35)
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:Paint(w, h)
	draw.RoundedBox(2, 0, 0, w, 80, panel_color_background)

	draw.SimpleText("EQUIPMENT", "deadremains.button", w *0.5, 80 *0.5, panel_color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

vgui.Register("deadremains.main_menu", panel, "EditablePanel")






local panel = {}

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:Init()
	local test = deadremains.item.get("base")

	self.inventory_head = self:Add("deadremains.inventory")
	self.inventory_head:createInventory(2, 2)
	self.inventory_head:addItem(test)

	self.inventory_chest = self:Add("deadremains.inventory")
	self.inventory_chest:createInventory(2, 2)

	self.inventory_feet = self:Add("deadremains.inventory")
	self.inventory_feet:createInventory(2, 2)

	self.inventory_primary = self:Add("deadremains.inventory")
	self.inventory_primary:createInventory(5, 2)
	
	self.inventory_primary:addItem(test)
	self.inventory_primary:addItem(test)
	
	self.inventory_secondary = self:Add("deadremains.inventory")
	self.inventory_secondary:createInventory(3, 2)

	self.inventory_back = self:Add("deadremains.inventory")
	self.inventory_back:createInventory(5, 5)

	self.inventory_legs = self:Add("deadremains.inventory")
	self.inventory_legs:createInventory(2, 2)
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:PerformLayout()
	local w, h = self:GetSize()

	self.inventory_head:SetPos(25, 25)
	self.inventory_chest:SetPos(25, 25 *2 +60 *2)
	self.inventory_feet:SetPos(25, 25 +60 *4 +25 *2)
	self.inventory_primary:SetPos(25, h -60 *2 -25)
	self.inventory_secondary:SetPos(w -60 *3 -25, h -60 *2 -25)

	self.inventory_legs:SetPos(w -60 *2 -25, 25 +60 *5 +25)
	self.inventory_back:SetPos(w -60 *2 -195, 25)
end
----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:Paint(w, h)
	draw.RoundedBox(2, 0, 0, w, h, panel_color_background)
end

vgui.Register("deadremains.equipment", panel, "EditablePanel")


















if (IsValid(main_menu)) then main_menu:Remove() end

--STORE_SCALE = math.Clamp(ScrW() /2560, 0.87, 1)

main_menu = vgui.Create("deadremains.main_menu")
main_menu:SetSize(660, 730)
main_menu:Center()
main_menu.x=200
main_menu:MakePopup()
main_menu:InvalidateLayout(true)

local character_icon = Material("icon16/user.png")

main_menu:addCategory("a", character_icon, function(base)
	local character_panel = main_menu:getPanel("character_panel")
	
	if (!IsValid(character_panel)) then
		character_panel = main_menu:addPanel(base, "character_panel", "deadremains.equipment")
		character_panel:Dock(FILL)
		--character_panel:DockPadding(4, 4, 4, 4)
	end
	
	--next_frame(function()
	--	storePanel:rebuild()
		
	--end)
	
end)

--main_menu:openCategory("a")