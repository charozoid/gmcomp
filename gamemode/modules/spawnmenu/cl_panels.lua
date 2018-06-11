local PANEL = {}

function PANEL:Init()
	self:SetTextColor(color_white)
	self:SetFont("Roboto16-300")
	self.isclicked = false
end

function PANEL:Paint(w,h)
	if not self:GetDisabled() then
		if self:IsHovered() then
			surface.SetDrawColor(40,40,40)
		else
			surface.SetDrawColor(35,35,35)
		end

		if self.isclicked and self.istoggle then
			surface.SetDrawColor(50,50,50)
		end		
	else
		surface.SetDrawColor(30,30,30)
	end
	surface.DrawRect(0,0,w,h)
end

function PANEL:SetClicked(bool)
	self.isclicked = bool
end

function PANEL:SetToggle(bool)
	self.istoggle = bool
end

function PANEL:PerformLayout(w,h)
	if self:GetDisabled() then
		self:SetMouseInputEnabled(false)
	end
	//self:SizeToContentsX(25)
end

vgui.Register("BBS-Button", PANEL, "DButton")

local PANEL = {}

function PANEL:Init()
	self.buttons = {}
	self.button_clicked = nil
end

function PANEL:AddButton(name, func, dock_type, clickable, toggle)
	local button = vgui.Create("BBS-Button",self)
	func = func or function() end
	if isbool(clickable) then
		button:SetEnabled(clickable)
	end
	button:Dock(dock_type or LEFT)
	button:SetText(name)
	button:SetToggle(toggle)
	button.DoClick = function(...)
		if self.button_clicked then
			self.button_clicked:SetClicked(false)
		end
		self.button_clicked = button
		button:SetClicked(true)

		return func(...)
	end
	table.insert(self.buttons,button)
end

function PANEL:Paint(w,h)
	surface.SetDrawColor(30,30,30)
	surface.DrawRect(0,0,w,h)
	/*surface.SetDrawColor(30,30,30)
	surface.DrawRect(0,0,w,28)	*/
end

vgui.Register("BBS-NavBar", PANEL, "DPanel")

local PANEL = {}

local r_w, r_h = 250, 0 -- tool panel's width and height
function PANEL:Init()
	self:SetTitle("")
	self:SetDraggable(false)
	self:ShowCloseButton(false)
	self:DockPadding(0,0,0,0)
	self.kids = {}

	self.shifter = vgui.Create("DFrame")
	self.shifter.h = 16
	self.shifter:SetSize(62,self.shifter.h)
	self.shifter:ShowCloseButton(false)
	self.shifter:SetDraggable(false)
	self.shifter:SetTitle("")
	self.shifter:DockPadding(0,0,0,0)
	table.insert(self.kids,self.shifter)

	self.shifter.navbar = vgui.Create("BBS-NavBar",self.shifter)
	self.shifter.navbar:Dock(FILL)
	self.shifter.navbar:AddButton("default", function() 
		BBS.SpawnMenuDisabled = true 
		self:Close()  
		bbs_spawn:OpenDef()
	end)
	self.shifter.Paint = function(s,w,h)
		surface.SetDrawColor(40,40,40)
		surface.DrawRect(0,0,w,h)
	end

	self.panel = vgui.Create("DPanel",self)
	self.panel:Dock(FILL)
	self.panel.Paint = function(s,w,h)
		if s.nothingfound then
			draw.SimpleText("Nothing found! :(","Roboto28-300",w/2,h/2-15,color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		end
	end
	self.panel:DockPadding(5,5,5,5)

	self.navbar = vgui.Create("BBS-NavBar",self)
	self.navbar:Dock(TOP)
	self.navbar:SetTall(32)
	self.navbar:AddButton("Props",function()
		self.panel:Clear()
		self.panel.nothingfound = false
		local iclay = vgui.Create("DIconLayout",self.panel)
		iclay:Dock(FILL)
		iclay:SetSpaceX(5)
		iclay:SetSpaceY(5)

		for i, model in pairs(BBS.AllowedProps) do
			local prop = iclay:Add("SpawnIcon")
			prop:SetModel(model)
			prop:SetTooltip(model)
--[[		TESTING ZONE
			prop.PaintOver = function(s,w,h)
				surface.SetDrawColor(30,30,30)
				surface.DrawRect(0,0,w,h)

				draw.DrawText("You cant\nspawn this\nany more!","Roboto16-300",w/2,3,color_white,TEXT_ALIGN_CENTER)
				surface.DrawTexturedRect(w/2-8,h/2,16,16)
				surface.SetDrawColor(255,255,255)
				//surface.SetMaterial(string materialName,boolean forceMaterial=false)
			end]]
			prop.DoClick = function()
				RunConsoleCommand("gm_spawn", model)
			end			
		end
		if #BBS.AllowedProps==0 then
			self.panel.nothingfound = true
		end
	end, LEFT, true, true)
	self.navbar.last_bbs = BBS.AllowedProps

	self.toolpanel = vgui.Create("DFrame")
	self.toolpanel:SetTitle("")
	self.toolpanel:SetDraggable(false)
	self.toolpanel:ShowCloseButton(false)
	self.toolpanel:DockPadding(0,0,0,0)
	table.insert(self.kids,self.toolpanel)

	self.toolpanel.navbar = vgui.Create("BBS-NavBar",self.toolpanel)
	self.toolpanel.navbar:Dock(TOP)
	self.toolpanel.navbar:SetTall(32)
	self.toolpanel.navbar:AddButton("Tools",nil,FILL,false)

	self.toolpanel.Paint = function(s,w,h)
		surface.SetDrawColor(40,40,40)
		surface.DrawRect(0,0,w,h)
		/*surface.SetDrawColor(30,30,30)
		surface.DrawRect(0,0,w,28)*/
	end

	self.toolpanel.panel = vgui.Create("DPanel",self.toolpanel)
	self.toolpanel.panel:Dock(FILL)
	self.toolpanel.panel.Paint = function() end
	self.toolpanel.panel.lasttools = BBS:GetMinigameTools()
end

function PANEL:AdjustTP() -- adjust tp to cursize/curpos
	local sw, sh = self:GetSize()
	r_h = sh -- set tool panels height to our height
	self:SetSize(sw-r_w-10,sh) -- 10 is the gap
	self.toolpanel:SetSize(r_w,r_h)
	self.toolpanel:SetPos(select(1,self:GetPos())+select(1,self:GetSize())+10,select(2,self:GetPos()))
	self.shifter:SetPos(select(1,self:GetPos()),select(2,self:GetPos())-self.shifter.h)
end

function PANEL:Paint(w,h)
	surface.SetDrawColor(40,40,40)
	surface.DrawRect(0,0,w,h)
	/*surface.SetDrawColor(30,30,30)
	surface.DrawRect(0,0,w,28)	*/
end

function PANEL:Open()
	RestoreCursorPosition()

	if (self:IsVisible()) then return end

	CloseDermaMenus()

	self:MakePopup()
	self:SetVisible(true)
	self:SetKeyboardInputEnabled(false)
	self:SetMouseInputEnabled(true)
	self:SetAlpha(255)

	for _, panel in pairs(self.kids) do
		panel:MakePopup()
		panel:SetVisible(true)
		panel:SetKeyboardInputEnabled(false)
		panel:SetMouseInputEnabled(true)
		panel:SetAlpha(255)
	end

	if LocalPlayer():GetUserGroup()=="user" then
		self.shifter:SetKeyboardInputEnabled(false)
		self.shifter:SetMouseInputEnabled(false)
		self.shifter:SetVisible(false)
	end

	if #self.navbar.buttons>0 and (self.navbar.button_clicked==nil or self.navbar.last_bbs!=BBS.AllowedProps) then
		self.navbar.buttons[1]:DoClick()
	end

	if self.toolpanel.lasttools!=BBS:GetMinigameTools() then
		self.toolpanel.panel:Clear()
		for _, tool in pairs(BBS:GetMinigameTools()) do
			local toolbut = vgui.Create("BBS-Button",self.toolpanel.panel)
			toolbut:SetText(tool)
			toolbut.DoClick = function()

			end
		end
	end
end

function PANEL:Close()
	RememberCursorPosition()

	CloseDermaMenus()

	self:SetKeyboardInputEnabled(false)
	self:SetMouseInputEnabled(false)
	self:SetVisible(false)

	for _, panel in pairs(self.kids) do
		panel:SetKeyboardInputEnabled(false)
		panel:SetMouseInputEnabled(false)
		panel:SetVisible(false)
	end

	self.navbar.last_bbs = BBS.AllowedProps
end

vgui.Register("BBS-SpawnMenu", PANEL, "DFrame")