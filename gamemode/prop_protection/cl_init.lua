hook.Add("HUDPaint","bbsprops_drawowner",function()
	-- drawing the owner of entity.
	local ent = LocalPlayer():GetEyeTrace().Entity
	if IsValid(ent) then
		surface.SetDrawColor(30,30,30)
		local w,h = 0, 20
		local x,y = 5, ScrH()/2
		surface.SetFont("Roboto19-300")
		local owner = ent:GetBBSOwner()==NULL and "world" or ent:GetBBSOwner():Nick()
		w = surface.GetTextSize(owner)
		surface.DrawRect(x,y,w+7,h)
		draw.SimpleText(owner,"Roboto19-300",x+2.5,y,color_white)
	end
end)
--[[
TESTING ZONE :p
hook.Add("PostDrawViewModel","bbsprops_physgundraw",function(viewModel, ply, weapon)
	if ply==LocalPlayer() and IsValid(weapon) and ply:Alive() and weapon:GetClass()=="weapon_physgun" then
		if IsValid(viewModel) then
			--PrintTable(weapon:GetAttachments())
			local attID = viewModel:LookupAttachment("fork1m")
			local attPos = viewModel:GetAttachment(attID).Pos
			--local wepTr = util.QuickTrace(attPos, viewModel:GetAngles():Forward()* 999, self)
			local ang = EyeAngles()
			local pos = attPos+ang:Up()*9+ang:Right()*-17+ang:Forward()*-27
			ang:RotateAroundAxis(ang:Right(),80)
			ang:RotateAroundAxis(ang:Up(),-90)
			--print(WorldToLocal(attPos,EyeAngles(),weapon:GetPos(),EyeAngles()))
			local w,h = 350, 250
			cam.Start3D2D(pos, ang, 0.026)
				draw.RoundedBox(0,0,0,w,h,Color(30,30,30))
				local ent = LocalPlayer():GetEyeTrace().Entity
				draw.SimpleText(ent,"Roboto24-300",w/2,0,color_white,TEXT_ALIGN_CENTER)
				draw.SimpleText("Class: "..ent:GetClass(),"Roboto19-300",5,30,color_white,TEXT_ALIGN_LEFT)
				draw.SimpleText("Speed: "..math.floor(ent:GetVelocity():Length()),"Roboto19-300",5,45,color_white,TEXT_ALIGN_LEFT)
				local owner = ent:GetBBSOwner()==NULL and "world" or ent:GetBBSOwner():Nick()
				draw.SimpleText("Owner: "..owner,"Roboto19-300",5,60,color_white,TEXT_ALIGN_LEFT)
				draw.SimpleText("Model: "..ent:GetModel(),"Roboto19-300",5,75,color_white,TEXT_ALIGN_LEFT)
				draw.SimpleText("Color: "..("R: "..ent:GetColor().r.." G: "..ent:GetColor().g.." B: "..ent:GetColor().b),"Roboto19-300",5,90,color_white,TEXT_ALIGN_LEFT)
			cam.End3D2D()			
		end
	end
end)]]--