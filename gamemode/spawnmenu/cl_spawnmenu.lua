include("panels.lua")

local bbs_spawn = {}

local f

function bbs_spawn:Fill()
	local w,h = 1250, 700

	f = vgui.Create("BBS-SpawnMenu")
	f:SetSize(w,h)
	f:SetVisible(false)
	f:SetPos(ScrW()/2-1250/2,ScrH()/2-700/2)
	f:AdjustTP()


/*	local w,h = 990,700
	f = vgui.Create("DFrame")
	f:SetSize(w,h)
	f:SetTitle("")
	f:SetDraggable(false)
	f:ShowCloseButton(false)
	f:SetPos(ScrW()/2-1250/2,ScrH()/2-700/2)

	f.toolpanel = vgui.Create("DFrame")
	f.toolpanel:SetSize(250,select(2,f:GetSize()))
	f.toolpanel:SetPos(select(1,f:GetPos())+select(1,f:GetSize())+10,select(2,f:GetPos()))
	f.toolpanel:SetTitle("")
	f.toolpanel:SetDraggable(false)
	f.toolpanel:ShowCloseButton(false)

	f.toolpanel.Paint = function(s,w,h)
		surface.SetDrawColor(40,40,40)
		surface.DrawRect(0,0,w,h)
		surface.SetDrawColor(30,30,30)
		surface.DrawRect(0,0,w,28)
	end

	function f:Open()
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
	function f:Close()
		RememberCursorPosition()

		CloseDermaMenus()

		self:SetKeyboardInputEnabled(false)
		self:SetMouseInputEnabled(false)
		self:SetVisible(false)

		self.toolpanel:SetKeyboardInputEnabled(false)
		self.toolpanel:SetMouseInputEnabled(false)
		self.toolpanel:SetVisible(false)
	end
	f.Paint = function(s,w,h)
		surface.SetDrawColor(40,40,40)
		surface.DrawRect(0,0,w,h)
		surface.SetDrawColor(30,30,30)
		surface.DrawRect(0,0,w,28)		
	end

	f:MakePopup()
	f:SetVisible(true)
	f:SetKeyboardInputEnabled(false)
	f:SetMouseInputEnabled(true)
	f:SetAlpha(255)

	f.toolpanel:MakePopup()
	f.toolpanel:SetVisible(true)
	f.toolpanel:SetKeyboardInputEnabled(false)
	f.toolpanel:SetMouseInputEnabled(true)
	f.toolpanel:SetAlpha(255)*/
end

function bbs_spawn:Open()
	if not f or not IsValid(f) then
		bbs_spawn:Fill()
	end
	f:Open()
end

function bbs_spawn:Close()
	f:Close()
end

function GM:OnSpawnMenuOpen()
	if LocalPlayer():GetUserGroup()=="user" then 
		bbs_spawn:Open()
		return false 
	end
end

function GM:OnSpawnMenuClose()
	if LocalPlayer():GetUserGroup()=="user" then 
		bbs_spawn:Close()
	end	
end