--[[
	BBS:AddMinigame(string name, int buildtime, table loadout, table phases)
	Add a custom Minigame to the game
	phases = {{["name"] = "", ["time"] = 0}}
]]--

function BBS:AddMinigame(tbl)
	local count = #self.Minigames + 1
	self.Minigames[count] = {["id"] = count, ["name"] = tbl.name, ["loadout"] = tbl.loadout, ["tools"] = tbl.tools, ["phases"] = tbl.phases, ["propfunc"] = tbl.propfunc}
end

if SERVER then
	AddCSLuaFile("minigames.lua")
	include("minigames.lua")
end
if CLIENT then
	include("minigames.lua")
end

--[[
	BBS:GetMinigame()
	Returns the current Minigame table
]]--
function BBS:GetMinigame()
	if GetGlobalInt("Minigame") == 0 then return false end
	return self.Minigames[GetGlobalInt("Minigame")]
end

--[[
	BBS:GetMinigameTools()
	Returns tools used in the minigame if there is any
]]--
function BBS:GetMinigameTools()
	if not self:GetMinigame() or not self:GetMinigame().tools then
		return nil
	end
	return self:GetMinigame().tools
end