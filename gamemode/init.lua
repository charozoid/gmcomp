include("shared.lua")

AddCSLuaFile("shared.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_fonts.lua")

local defaultloadout = {"weapon_physgun", "weapon_physcannon", "gmod_tool", "gmod_camera" }

function GM:PlayerLoadout(ply)
	local gmloadout = BBS:GetGamemode().loadout
	if gmloadout then
		for k,v in pairs(gmloadout) do
			ply:Give(v)
		end
		return true
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
	BBS.StartRoundTimer()
	Manages the round timer
]]--
function BBS.StartRoundTimer()
	if GetGlobalInt("Gamemode") == 0 then
		error("Tried to start the timer with no gamemode selected")
	end
	local roundstate = GetGlobalInt("RoundState")
	if timer.Exists("RoundTimer") then
		timer.Destroy("RoundTimer")
	end
	print(roundstate)
	if roundstate == PHASE_PREBUILD then
		timer.Create("RoundTimer", BBS.PrebuildTimer, 1 , function() 
			SetGlobalInt("RoundState", PHASE_BUILD)
			BBS.StartBuild()
			BBS:StartRoundTimer()
		end)
	elseif roundstate == PHASE_BUILD then
		print(BBS.BuildTimer)
		timer.Create("RoundTimer",BBS.BuildTimer, 1 , function() 
			SetGlobalInt("RoundState", PHASE_VOTE)
			BBS:StartRoundTimer()
		end)
	elseif roundstate == PHASE_VOTE then
	timer.Create("RoundTimer", BBS.VoteTimer, 1 , function() 
			SetGlobalInt("RoundState", PHASE_IDLE)
			BBS:SetIdle()
		end)
	end
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

function BBS.StartBuild()

end
--[[
	BBS:SetIdle()
	Called after the voting ends
]]--
function BBS:SetIdle()
	self:SetGamemode(0)
end

--[[
	BBS:NextPhase()
	Changes the game to the next phase
]]--
function BBS:NextPhase()
	local roundstate = GetGlobalInt("RoundState")
	if roundstate == PHASE_PREBUILD then
		SetGlobalInt("RoundState", PHASE_BUILD)
	elseif roundstate == PHASE_BUILD then
		SetGlobalInt("RoundState", PHASE_VOTE)
	elseif roundstate == PHASE_VOTE then
		SetGlobalInt("RoundState", PHASE_PREBUILD)
	end
	self.StartRoundTimer()
end

--[[
	BBS:SetGamemode(int gamemode ID)
	Sets the current gamemode
]]--
function BBS:SetGamemode(id)
	local gm = self.Gamemodes[id]
	SetGlobalInt("RoundState", PHASE_PREBUILD)
	SetGlobalInt("Gamemode", id)
	BBS.BuildTimer = gm.buildtime
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
	Pick a table of props for use in the mode propidtable = {1, 3, 5, 9, 15}
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