include("shared.lua")
include("cl_fonts.lua")

local nicephases = {"Prebuild Phase", "Build Phase", "Voting Phase"}

local smoother = 0
function GM:HUDPaint()
	-- time left: math.ceil(timer.TimeLeft("RoundTimer"))
	-- name: nicephases[GetGlobalInt("RoundState")]
	if timer.Exists("RoundTimer") then
		local wid, tall = 200, 30
		smoother = Lerp(10*FrameTime(),smoother,(BBS:GetPhaseTotalTime(GetGlobalInt("RoundState"))-math.ceil(timer.TimeLeft("RoundTimer")))/BBS:GetPhaseTotalTime(GetGlobalInt("RoundState"))*wid)
		surface.SetDrawColor(30,30,30)
		surface.DrawRect(5,5,wid,tall)
		if math.ceil(timer.TimeLeft("RoundTimer"))<BBS:GetPhaseTotalTime(GetGlobalInt("RoundState"))/4 then
			surface.SetDrawColor(167,17,17)
		else
			surface.SetDrawColor(68,164,68)
		end
		surface.DrawRect(5,5,smoother,tall)
		draw.SimpleText(nicephases[GetGlobalInt("RoundState")],"Roboto24-300",wid/2+5,20,color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

		surface.SetDrawColor(35,35,35)
		surface.DrawRect(5,35,wid,tall)
		draw.SimpleText(nicephases[GetGlobalInt("RoundState")==#nicephases and 1 or GetGlobalInt("RoundState")+1],"Roboto24-300",wid/2+5,49,Color(100,100,100),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end
end

net.Receive("BBSTimer", function()
	local time = net.ReadInt(32)
	if timer.Exists("RoundTimer") then
		timer.Destroy("RoundTimer")
	end
	timer.Create("RoundTimer", time, 1, function()
		
	end)
end)

net.Receive("BBSPropList", function(len)
	for i=1, len do
		BBS.AllowedProps[i] = BBS.PropList[net.ReadInt(16)]
	end
end)