bbs_spawn = bbs_spawn or {}

BBS.SpawnMenuDisabled = BBS.SpawnMenuDisabled or false -- a config value for admins to use whether new ui or default ui (not editable)

local f

function bbs_spawn:Fill()
	local w,h = 1250, 700

	f = vgui.Create("BBS-SpawnMenu")
	f:SetSize(w,h)
	f:SetVisible(false)
	f:SetPos(ScrW()/2-1250/2,ScrH()/2-700/2)
	f:AdjustTP()
end

function bbs_spawn:Open()
	if not f or not IsValid(f) then
		bbs_spawn:Fill()
	end
	f:Open()
end

function bbs_spawn:Close()
	if not f or not IsValid(f) then return end
	f:Close()
end

function bbs_spawn:OpenDef()
	if (IsValid(g_SpawnMenu)) then
		g_SpawnMenu:Open()
		menubar.ParentTo(g_SpawnMenu)

		if g_SpawnMenu.shifter then return end
		g_SpawnMenu.shifter = vgui.Create("DFrame")
		g_SpawnMenu.shifter:SetParent(g_SpawnMenu)
		g_SpawnMenu.shifter:SetSize(64,16)
		g_SpawnMenu.shifter:SetPos(40,33)
		g_SpawnMenu.shifter:ShowCloseButton(false)
		g_SpawnMenu.shifter:SetDraggable(false)
		g_SpawnMenu.shifter:SetTitle("")
		g_SpawnMenu.shifter:DockPadding(0,0,0,0)

		g_SpawnMenu.shifter.navbar = vgui.Create("BBS-NavBar",g_SpawnMenu.shifter)
		g_SpawnMenu.shifter.navbar:Dock(FILL)
		g_SpawnMenu.shifter.navbar:AddButton("bbs_spawn", function() 
			BBS.SpawnMenuDisabled = false 
			bbs_spawn:CloseDef()
			bbs_spawn:Open()
		end)
		g_SpawnMenu.shifter.Paint = function(s,w,h)
			surface.SetDrawColor(40,40,40)
			surface.DrawRect(0,0,w,h)
		end
	end
end

function bbs_spawn:CloseDef()
	if(IsValid(g_SpawnMenu)) then 
		g_SpawnMenu:Close() 
	end
end

function GM:OnSpawnMenuOpen()
	if LocalPlayer():GetUserGroup()=="user" then 
		bbs_spawn:Open()
		return false 
	else
		if BBS.SpawnMenuDisabled then
			bbs_spawn:OpenDef()
		elseif not BBS.SpawnMenuDisabled then
			bbs_spawn:Open()
			return false
		end
	end
end

function GM:OnSpawnMenuClose()
	bbs_spawn:Close()
	bbs_spawn:CloseDef()
end