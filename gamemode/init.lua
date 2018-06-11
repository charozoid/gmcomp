include("shared.lua")
AddCSLuaFile("shared.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_fonts.lua")

local p = "gamemodes/buildbattles/gamemode/modules/*"
local _, modules = file.Find(""..p, "GAME")

for k, v in pairs(modules) do
	local svinc = file.Find("gamemodes/buildbattles/gamemode/modules/"..v.."/*.lua", "GAME")

	for i, j in pairs(svinc) do
		local sub = string.sub(j, 1, 3)
		if sub == "sv_" then
			include("modules/"..v.."/"..j)
		elseif sub == "cl_" then
			AddCSLuaFile("modules/"..v.."/"..j)
		elseif j == "shared.lua" then
			include("modules/"..v.."/"..j)
			AddCSLuaFile("modules/"..v.."/"..j)
		end
	end
	print("Added module "..v)
end


/*AddCSLuaFile("spawnmenu/cl_spawnmenu.lua")
AddCSLuaFile("spawnmenu/panels.lua")*/

local defaultloadout = {"weapon_physgun", "weapon_physcannon", "gmod_tool", "gmod_camera" }
--[[
	GM:PlayerLoadout(ply)
	Controls gamemode loadout or uses default loadout
]]--
function GM:PlayerLoadout(ply)
	local pl = ply
	pl:StripWeapons()
	timer.Simple(1.25, function()
		if BBS:GetMinigame() then
			local gmloadout = BBS:GetMinigame().loadout
			if gmloadout then
				for k,v in pairs(gmloadout) do
					pl:Give(v)
				end
				return true
			end
		end

		for k,v in pairs(defaultloadout) do
			pl:Give(v)
		end

	return true
end)
end
--[[
	GM:PlayerSpawnProp(ply, model)
	Only make the player be able to spawn the allowed props
]]--
function GM:PlayerSpawnProp(ply, model)
	if not BBS.AllowedProps[model] then
		return false
	else
		return true
	end
end
--[[
	GM:PlayerInitialSpawn(ply)
	Delays timer creation 
]]--
function GM:PlayerInitialSpawn(ply)
	local pl = ply
	pl.SpawnedProps = {}
	timer.Simple(5, function() 
		if timer.Exists("RoundTimer") then
			BBS:SendTimer(pl)
		end
	end)
end

--[[
	BBS:SetRandomTheme
	Selects a random theme
]]--
function BBS:SetRandomTheme()
	local int = math.random(#self.Themes)
	SetGlobalInt("ThemeID", int)
end

--[[
	BBS:SetTheme(int themeid)
	Sets the current theme
]]--
function BBS:SetTheme(id)
	SetGlobalInt("ThemeID", id)
end
--[[
	BBS:PickRandomProps(number rand)
	Pick a random table of props from the global prop list
]]--
function BBS:PickRandomProps(number)
	self.AllowedProps = {}
	local idtbl = {}
	if number>#self.PropList then 
		error("Tried to get "..number.." random props while there is only "..#self.PropList.." props available!")
		return
	end
	local randpropids = {}

	for i=1,number do
		::again::
		local randpropid = math.random(#self.PropList)
		if  randpropids[randpropid] then
			goto again
		end
		randpropids[randpropid] = true
		idtbl[i] = randpropid
	end
	self:AllowProps(idtbl)
end
--[[
	BBS:PickProps(table propidtable)
	Pick a table of props from global prop list. Using table index
	Ex : propidtable = {1, 3, 5, 9, 15}
]]--
function BBS:PickProps(propidtable)
	local idtbl = {}
	for k, v in ipairs(propidtable) do
		idtbl[k] = v
	end
	self:AllowProps(idtbl)
end

function GM:CanTool(ply, tr, tool)
	if BBS:GetMinigame() then
		if BBS:GetMinigameTools() then
			for k,v in pairs(BBS:GetMinigameTools()) do
				if tool == v then 
					return true
				else
					return false
				end
			end
		else
			return false
		end
	else
		return true
	end
end