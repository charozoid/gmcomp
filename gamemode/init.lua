include("shared.lua")

AddCSLuaFile("shared.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_fonts.lua")
AddCSLuaFile("cl_spawnmenu.lua")

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
	BBS:ChooseRandomProps(int number)
	Choose a number of props randomly from the main props table
]]--

util.AddNetworkString("BBSPropList")

function BBS:ChooseRandomProps(number)
	self.AllowedProps = {}
	net.Start("BBSPropList")
	for i=1,number do
		local randpropid = math.random(#self.PropList)
		net.WriteInt(randpropid, 16)
		self.AllowedProps[""..self.PropList[randpropid]] = true
	end
	net.Broadcast()
end
--[[
	BBS:PickProps(table propidtable)
	Pick a table of props from global prop list. Using table index
	Ex : propidtable = {1, 3, 5, 9, 15}
]]--
function BBS:PickProps(propidtable)
	self.AllowedProps = {}
	net.Start("BBSPropList")
	for k, v in ipairs(propidtable) do
		local propid = v
		self.AllowedProps[""..self.PropList[propid]] = true
		net.WriteInt(propid, 16)
	end
	net.Broadcast()
end