include("shared.lua")

AddCSLuaFile("shared.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_fonts.lua")

local defaultloadout = {"weapon_physgun", "weapon_physcannon", "gmod_tool", "gmod_camera" }

function GM:PlayerLoadout(ply)
	if BBS:GetGamemode() then
		local gmloadout = BBS:GetGamemode().loadout
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

util.AddNetworkString("BBSTimer")

local function sendtime(ply) --Send the timer time to the client
	local roundtimer = math.floor(timer.TimeLeft("RoundTimer"))

	net.Start("BBSTimer")
		net.WriteInt(roundtimer, 32)
	net.Send(ply)
end

hook.Add("PlayerInitialSpawn", "sendroundtimer", sendtime)

local function broadcasttime() --Broadcast the timer time to everyone
	local roundtimer = math.floor(timer.TimeLeft("RoundTimer"))

	net.Start("BBSTimer")
		net.WriteInt(roundtimer, 32)
	net.Broadcast()
end
--[[
	BBS:StartRoundTimer()
	Manages the round timer
]]--
function BBS:StartRoundTimer()
	if GetGlobalInt("Gamemode") == 0 then
		error("Tried to start the timer with no gamemode selected")
	end
	local roundstate = GetGlobalInt("RoundState")
	local gmphaseslen = #self:GetGamemode().phases

	if timer.Exists("RoundTimer") then
		timer.Destroy("RoundTimer")
	end

	if roundstate > gmphaseslen then
		BBS:SetIdle()
		return
	end

	if roundstate == 1 then
		self:GetGamemode().propfunc()
	end

	self:GetGamemode().phases[roundstate].func()
	timer.Create("RoundTimer", self:GetGamemode().phases[roundstate].time, 1, function()
		SetGlobalInt("RoundState", GetGlobalInt("RoundState") + 1)
		BBS:StartRoundTimer()
	end)

	broadcasttime()
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
	SetGlobalInt("Gamemode", 0)
end

--[[
	BBS:SetGamemode(int gamemode ID)
	Sets the current gamemode
]]--
function BBS:SetGamemode(id)
	local gm = self.Gamemodes[id]
	SetGlobalInt("RoundState", 1)
	SetGlobalInt("Gamemode", id)
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