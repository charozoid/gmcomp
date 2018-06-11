--[[
	BBS:StartRoundTimer()
	Manages the round timer on the clientside
]]--
function BBS:StartRoundTimer()
	if CLIENT then
	local roundstate = self.RoundState
	local gmphaseslen = #self:GetMinigame().phases or 0

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
	if SERVER then
		local roundstate = GetGlobalInt("RoundState")
		if self:GetMinigame() then
			return self:GetMinigame().phases[roundstate].time
		end
	elseif CLIENT then
		if self:GetMinigame() and BBS.RoundState ~= 0 then
			return self:GetMinigame().phases[BBS.RoundState].time
		else
			return nil
		end
	end
end
