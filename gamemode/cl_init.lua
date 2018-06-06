include("shared.lua")
include("cl_fonts.lua")

include("rounds/cl_init.lua")
include("rounds/shared.lua")

include("minigames/cl_init.lua")
include("minigames/shared.lua")

include("spawnmenu/cl_spawnmenu.lua")

local nicephases = {"Prebuild Phase", "Build Phase", "Voting Phase"}

local smoother = 0
function GM:HUDPaint()
	-- time left: math.ceil(timer.TimeLeft("RoundTimer"))
	-- name: nicephases[GetGlobalInt("RoundState")]
	if timer.Exists("RoundTimer") then
		local wid, tall = 200, 30
		local phasetime = BBS:GetPhaseTotalTime()
		local remtime = BBS.GetPhaseTimeLeft()
		if not phasetime or not remtime then return end
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
		draw.SimpleText(BBS:GetPhaseName(),"Roboto24-300",wid/2+5,20,color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

		surface.SetDrawColor(35,35,35)
		surface.DrawRect(5,35,wid,tall)
		--draw.SimpleText(nicephases[GetGlobalInt("RoundState")==#nicephases and 1 or GetGlobalInt("RoundState")+1],"Roboto24-300",wid/2+5,49,Color(100,100,100),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		draw.SimpleText(BBS:GetNextPhaseName(),"Roboto24-300",wid/2+5,49,Color(100,100,100),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end
end

net.Receive("BBSPropList", function()
	BBS.AllowedProps = {}
	local len = net.ReadInt(16)
	
	for i=1, len do
		local id = net.ReadInt(16)
		BBS.AllowedProps[i] = BBS.PropList[id]
	end
end)