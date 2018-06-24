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
		BBS:GetMinigame().phases[state].endfunc()
		BBS.RoundState = BBS.RoundState + 1
		BBS:StartRoundTimer()
	end)
end)
--[[
	BBS:GetPhaseName()
	Returns the current phase name
]]--
function BBS:GetPhaseName()
	if self:GetMinigame() and BBS.RoundState ~= 0 then
		return self:GetMinigame().phases[BBS.RoundState].name
	else
		return nil
	end
end
--[[
	BBS:GetNextPhaseName()
	Returns the next phase name
]]--
function BBS:GetNextPhaseName()
	if self:GetMinigame() and BBS.RoundState ~= 0 then
		local roundstate = BBS.RoundState + 1
		if roundstate > #self:GetMinigame().phases then
			return "End"
		else
			return self:GetMinigame().phases[roundstate].name
		end
	else
		return nil
	end
end
--[[
	BBS.GetPhaseTimeLeft()
	Returns the remaining time to the current phase
]]--
function BBS.GetPhaseTimeLeft()
	if not timer.Exists("RoundTimer") then return end
	return math.ceil(timer.TimeLeft("RoundTimer"))
end
