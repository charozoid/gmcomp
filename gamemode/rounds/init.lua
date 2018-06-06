--[[
	BBS:StartMinigame()
	Starts the minigame
]]--
util.AddNetworkString("BBSStartTimer")
function BBS:StartMinigame()
	self:StartRoundTimer()
	net.Start("BBSStartTimer")
	net.Broadcast()
	for k, v in pairs(player.GetAll()) do
		v:Spawn()
	end
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