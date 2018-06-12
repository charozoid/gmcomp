include("shared.lua")
include("cl_fonts.lua")

local p = "buildbattles/gamemode/modules/*"
local _, modules = file.Find(""..p, "LUA")
PrintTable(modules)
for k, v in pairs(modules) do
	local svinc = file.Find("buildbattles/gamemode/modules/"..v.."/*.lua", "LUA")

	for i, j in pairs(svinc) do
		local sub = string.sub(j, 1, 3)
		if sub == "cl_" then
			include("modules/"..v.."/"..j)
		elseif j == "shared.lua" then
			include("modules/"..v.."/"..j)
		end
	end
	print("Added module "..v)
end

local smoother = 0
function GM:HUDPaint()
	-- time left: math.ceil(timer.TimeLeft("RoundTimer"))
	-- name: nicephases[GetGlobalInt("RoundState")]
	if timer.Exists("RoundTimer") then
		local wid, tall = 200, 30
		if not BBS:GetPhaseTotalTime() or not BBS.GetPhaseTimeLeft() then return end

		local phasetime = BBS:GetPhaseTotalTime()
		local remtime = BBS.GetPhaseTimeLeft()

		local to = (phasetime-remtime)/phasetime*wid

		smoother = Lerp(10*FrameTime(),smoother, to)

		surface.SetDrawColor(30,30,30)
		surface.DrawRect(5,5,wid,tall)

		if remtime<phasetime/4 then
			surface.SetDrawColor(167,17,17)
		else
			surface.SetDrawColor(68,164,68)
		end
		surface.DrawRect(5,5,smoother,tall)
		surface.SetDrawColor(0,0,0,100)
		surface.DrawRect(5,tall+5-4,smoother,4)
		draw.SimpleText(BBS:GetPhaseName(),"Roboto24-300",wid/2+5,20,color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

		surface.SetDrawColor(35,35,35)
		surface.DrawRect(5,35,wid,tall)
		--draw.SimpleText(nicephases[GetGlobalInt("RoundState")==#nicephases and 1 or GetGlobalInt("RoundState")+1],"Roboto24-300",wid/2+5,49,Color(100,100,100),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		draw.SimpleText(BBS:GetNextPhaseName(),"Roboto24-300",wid/2+5,49,Color(100,100,100),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end
	if BBS:GetTheme() then
		local name = BBS:GetTheme().name
		local wid = surface.GetTextSize(BBS:GetTheme().name) + 75
		local tall = 30
		
		surface.SetDrawColor(30,30,30)
		surface.DrawRect(5, 70, wid, tall)

		surface.SetTextColor(color_white)
		surface.SetFont("Roboto24-300")
		surface.SetTextPos(10, 75)
		surface.DrawText("Theme:"..BBS:GetTheme().name)
	end
end
