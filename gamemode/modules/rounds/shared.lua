--[[
	BBS:StartRoundTimer()
	Manages the round timer on the clientside
]]--
function BBS:StartRoundTimer()
	if CLIENT then
	local roundstate = self.RoundState
	local gmphaseslen = #self:GetMinigame().phases

	if timer.Exists("RoundTimer") then
		timer.Destroy("RoundTimer")
	end

	if roundstate > gmphaseslen then
			roundstate = 0
			BBS.AllowedProps = {}
		return
	end
	if self:GetMinigame().phases[roundstate].startfunc then
		self:GetMinigame().phases[roundstate].startfunc()
	end
	timer.Create("RoundTimer", self:GetMinigame().phases[roundstate].time, 1, function()
		if BBS:GetMinigame().phases[roundstate].endfunc then
			BBS:GetMinigame().phases[roundstate].endfunc()
		end
		BBS.RoundState = roundstate + 1
		BBS:StartRoundTimer()
	end)
	end
	if SERVER then
	if GetGlobalInt("Minigame") == 0 then
		error("Tried to start the timer with no Minigame selected")
	end
	local roundstate = GetGlobalInt("RoundState")
	local gmphaseslen = #self:GetMinigame().phases

	if timer.Exists("RoundTimer") then
		timer.Destroy("RoundTimer")
	end

	if roundstate > gmphaseslen then
		BBS:SetIdle()
		return
	end

	if roundstate == 1 then
		self:GetMinigame().propfunc()
		self:StartCLTimer()
	end

	if self:GetMinigame().phases[roundstate].startfunc then
		self:GetMinigame().phases[roundstate].startfunc()
	end
	timer.Create("RoundTimer", self:GetMinigame().phases[roundstate].time, 1, function()
		if BBS:GetMinigame().phases[roundstate].endfunc then
			BBS:GetMinigame().phases[roundstate].endfunc()
		end
		SetGlobalInt("RoundState", GetGlobalInt("RoundState") + 1)
		BBS:StartRoundTimer()
	end)
	end
end


--[[
	BBS:GetPhaseTotalTime()
	Returns the current phase total time
]]--
function BBS:GetPhaseTotalTime()
	local roundstate = GetGlobalInt("RoundState")
	if self:GetMinigame() then
		return self:GetMinigame().phases[roundstate].time
	end
end
--[[
	BBS:GetPhaseName()
	Returns the current phase name
]]--
function BBS:GetPhaseName()
	local roundstate = GetGlobalInt("RoundState")
	return self:GetMinigame().phases[roundstate].name
end
--[[
	BBS:GetNextPhaseName()
	Returns the current phase name
]]--
function BBS:GetNextPhaseName()
	local roundstate = GetGlobalInt("RoundState") + 1
	if roundstate > #self:GetMinigame().phases then
		return "End"
	else
		return self:GetMinigame().phases[roundstate].name
	end
end
--[[
	BBS.GetPhaseTimeLeft()
	Returns the remaining time to the current phase
]]--
function BBS.GetPhaseTimeLeft()
	return math.ceil(timer.TimeLeft("RoundTimer"))
end
