--[[
	BBS:SetMinigame(int Minigame ID)
	Sets the current Minigame
]]--
function BBS:SetMinigame(id)
	local gm = self.Minigames[id]
	SetGlobalInt("RoundState", 1)
	SetGlobalInt("Minigame", id)
end