local PANEL = {}

PANEL.Buttons = {}
function PANEL:Init()

end

function PANEL:AddButton(name, func, dock_type, clickable)
	local button = vgui.Create("DButton",self)
	if isbool(clickable) then
		button:SetEnabled(clickable)
	end
	button:Dock(dock_type or LEFT)
	button:SetText(name)
	button.DoClick = func or function() end
	button.Paint = function(s,w,h)
		surface.SetDrawColor(35,35,35)
		surface.DrawRect(0,0,w,h)
	end
	button:SetTextColor(color_white)
	button:SetFont("Roboto16-300")
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

	self.panel = vgui.Create("DPanel",self)
	self.panel:Dock(FILL)
	self.panel.Paint = function(s,w,h) end
	self.panel:DockPadding(5,5,5,5)

	self.navbar = vgui.Create("BBS-NavBar",self)
	self.navbar:Dock(TOP)
	self.navbar:SetTall(32)
	self.navbar:AddButton("Props",function()
		self.panel:Clear()
		local iclay = vgui.Create("DIconLayout",self.panel)
		iclay:Dock(FILL)
		iclay:SetSpaceX(5)
		iclay:SetSpaceY(5)

		for i, model in pairs(BBS.AllowedProps) do
			local prop = iclay:Add("SpawnIcon")
			prop:SetModel(model)
			prop:SetTooltip(model)
			prop.DoClick = function()
				RunConsoleCommand("gm_spawn", model)
			end			
		end
	end)
	
	self.toolpanel = vgui.Create("DFrame")
	self.toolpanel:SetTitle("")
	self.toolpanel:SetDraggable(false)
	self.toolpanel:ShowCloseButton(false)
	self.toolpanel:DockPadding(0,0,0,0)

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
end

function PANEL:AdjustTP() -- adjust tp to cursize/curpos
	local sw, sh = self:GetSize()
	r_h = sh -- set tool panels height to our height
	self:SetSize(sw-r_w-10,sh) -- 10 is the gap
	self.toolpanel:SetSize(r_w,r_h)
	self.toolpanel:SetPos(select(1,self:GetPos())+select(1,self:GetSize())+10,select(2,self:GetPos()))
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

	self.toolpanel:MakePopup()
	self.toolpanel:SetVisible(true)
	self.toolpanel:SetKeyboardInputEnabled(false)
	self.toolpanel:SetMouseInputEnabled(true)
	self.toolpanel:SetAlpha(255)
end

function PANEL:Close()
	RememberCursorPosition()

	CloseDermaMenus()

	self:SetKeyboardInputEnabled(false)
	self:SetMouseInputEnabled(false)
	self:SetVisible(false)

	self.toolpanel:SetKeyboardInputEnabled(false)
	self.toolpanel:SetMouseInputEnabled(false)
	self.toolpanel:SetVisible(false)
end

vgui.Register("BBS-SpawnMenu", PANEL, "DFrame")