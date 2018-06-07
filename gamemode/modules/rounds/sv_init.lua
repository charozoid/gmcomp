--[[
	BBS:StartCLTimer()
	Broadcast signal to players to start their round timer
]]--
util.AddNetworkString("BBSStartTimer")
function BBS:StartCLTimer()
	net.Start("BBSStartTimer")
	net.Broadcast()
end


util.AddNetworkString("BBSConnectTimer")
--[[
	BBS:SendTimer(ply)
	Sends the current timer and roundstate to the player
]]--
function BBS:SendTimer(ply)
	net.Start("BBSConnectTimer")
		net.WriteFloat(timer.TimeLeft("RoundTimer"))
		net.WriteInt(GetGlobalInt("RoundState"), 16)
	net.Send(ply)
end

--[[
	BBS:SetIdle()
	Called after the voting ends
]]--
function BBS:SetIdle()
	SetGlobalInt("RoundState", 0)
	timer.Simple(1, function() SetGlobalInt("Minigame", 0) end) --Delay it a bit to let the client catch up
end
--[[
	BBS:SetIdle()
	Called after the voting ends
]]--
util.AddNetworkString("BBSResetTimer")
function BBS:ResetTimer()
	SetGlobalInt("RoundState", 0)
	SetGlobalInt("Minigame", 0)

	if timer.Exists("RoundTimer") then
		timer.Destroy("RoundTimer")
	end
	net.Start("BBSResetTimer")
	net.Broadcast()
end