include("shared.lua")

AddCSLuaFile("shared.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_fonts.lua")

AddCSLuaFile("spawnmenu/cl_spawnmenu.lua")
AddCSLuaFile("spawnmenu/panels.lua")

local defaultloadout = {"weapon_physgun", "weapon_physcannon", "gmod_tool", "gmod_camera" }

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

function GM:PlayerInitialSpawn(ply)
	local pl = ply
	timer.Simple(5, function() 
		if timer.Exists("RoundTimer") then
			BBS:SendTimer(pl)
		end
	end)
end

--[[
	BBS:StartRoundTimer()
	Manages the round timer
]]--
function BBS:StartRoundTimer()
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
	end

	self:GetMinigame().phases[roundstate].startfunc()
	timer.Create("RoundTimer", self:GetMinigame().phases[roundstate].time, 1, function()
		BBS:GetMinigame().phases[roundstate].endfunc()
		SetGlobalInt("RoundState", GetGlobalInt("RoundState") + 1)
		BBS:StartRoundTimer()

	end)
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

util.AddNetworkString("BBSTimer")
--[[
	BBS:StartMinigame()
	Starts the minigame
]]--
function BBS:StartMinigame()
	self:StartRoundTimer()
	net.Start("BBSTimer")
	net.Broadcast()
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
	BBS:SetIdle()
	Called after the voting ends
]]--
function BBS:SetIdle()
	SetGlobalInt("RoundState", 0)
	timer.Simple(3, function() SetGlobalInt("Minigame", 0) end)
end
--[[
	BBS:SetIdle()
	Called after the voting ends
]]--
function BBS:ResetTimer()
	SetGlobalInt("RoundState", 0)
	SetGlobalInt("Minigame", 0)

	if timer.Exists("RoundTimer") then
		timer.Destroy("RoundTimer")
	end
end
--[[
	BBS:SetMinigame(int Minigame ID)
	Sets the current Minigame
]]--
function BBS:SetMinigame(id)
	local gm = self.Minigames[id]
	SetGlobalInt("RoundState", 1)
	SetGlobalInt("Minigame", id)
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
		self.AllowedProps[i] = self.PropList[randpropid]
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
			self.AllowedProps[k] = self.PropList[v]
		end
	net.Broadcast()
end