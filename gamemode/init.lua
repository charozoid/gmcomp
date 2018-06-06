include("shared.lua")
include("rounds/init.lua")
include("rounds/shared.lua")

include("minigames/init.lua")
include("minigames/shared.lua")

AddCSLuaFile("shared.lua")

AddCSLuaFile("rounds/shared.lua")
AddCSLuaFile("rounds/cl_init.lua")

AddCSLuaFile("minigames/shared.lua")
AddCSLuaFile("minigames/cl_init.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_fonts.lua")

AddCSLuaFile("spawnmenu/cl_spawnmenu.lua")
AddCSLuaFile("spawnmenu/panels.lua")

local defaultloadout = {"weapon_physgun", "weapon_physcannon", "gmod_tool", "gmod_camera" }
--[[
	GM:PlayerLoadout(ply)
	Controls gamemode loadout or uses default loadout
]]--
function GM:PlayerLoadout(ply)
	if BBS:GetMinigame() then
		local gmloadout = BBS:GetMinigame().loadout
		if gmloadout then
			for k,v in pairs(gmloadout) do
				ply:Give(v)
			end
			return true
		end
	end

	for k,v in pairs(defaultloadout) do
		ply:Give(v)
	end

	return true

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
	timer.Simple(5, function() 
		if timer.Exists("RoundTimer") then
			BBS:SendTimer(pl)
		end
	end)
end

--[[
	BBS:RandomTheme
	Returns random theme
]]--
function BBS:GetRandomTheme()
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
--[[
	BBS:AllowProps(table propindex)
	Adds the prop to the allowedprops table and networks to the client
]]--
util.AddNetworkString("BBSPropList")

function BBS:AllowProps(tbl)
	self.AllowedProps = {}
	local len = #tbl

	net.Start("BBSPropList")
		net.WriteInt(len, 16)

		for k,v in ipairs(tbl) do
			net.WriteInt(v, 16)
			self.AllowedProps[self.PropList[v]] = true
		end
	net.Broadcast()
end