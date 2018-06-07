net.Receive("BBSStartTimer", function()
	BBS.RoundState = 1
	BBS:StartRoundTimer()
end)

net.Receive("BBSResetTimer", function()
	if timer.Exists("RoundTimer") then
		timer.Destroy("RoundTimer")
	end
	BBS.RoundState = 0
end)
--[[
	"BBSConnectTimer"
	Received round state and timer timeleft
]]--
net.Receive("BBSConnectTimer", function()
	local time = net.ReadFloat()
	local state = net.ReadInt(16)
	BBS.RoundState = state
	timer.Create("RoundTimer", time, 1, function() 
		BBS:GetMinigame().phases[GetGlobalInt("RoundState")].endfunc()
		BBS.RoundState = BBS.RoundState + 1
		BBS:StartRoundTimer()
	end)
end)