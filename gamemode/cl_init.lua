include("shared.lua")
include("cl_fonts.lua")

local nicephases = {"Prebuild Phase", "Build Phase", "Judging Phase"}

function GM:HUDPaint()
	if timer.Exists("RoundTimer") then
		surface.SetTextColor(255, 0, 0, 255)
		surface.SetFont("Arial24")
		surface.SetTextPos(100, 100)
		surface.DrawText(""..math.ceil(timer.TimeLeft("RoundTimer")) )
		surface.SetTextPos(100, 50)
		surface.DrawText(""..nicephases[GetGlobalInt("RoundState")])
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
