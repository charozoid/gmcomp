include("shared.lua")

AddCSLuaFile("shared.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_fonts.lua")

local loadout = {"weapon_physgun", "weapon_physcannon", "gmod_tool", "gmod_camera" }

function GM:PlayerLoadout(ply)
	for k,v in pairs(loadout) do
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
	local roundstate = GetGlobalInt("RoundState")
	if timer.Exists("RoundTimer") then
		timer.Destroy("RoundTimer")
	end
	if roundstate == PHASE_PREBUILD then
		timer.Create("RoundTimer", BBS.PrebuildTimer, 1 , function() 
			SetGlobalInt("RoundState", PHASE_BUILD)
			BBS.StartBuild()
			BBS:StartRoundTimer()
		end)
	elseif roundstate == PHASE_BUILD then
		timer.Create("RoundTimer",BBS.BuildTimer, 1 , function() 
			SetGlobalInt("RoundState", PHASE_VOTE)
			BBS:StartRoundTimer()
		end)
	elseif roundstate == PHASE_VOTE then
	timer.Create("RoundTimer", BBS.VoteTimer, 1 , function() 
			SetGlobalInt("RoundState", PHASE_PREBUILD)
			BBS:StartRoundTimer()
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
		self.AllowedProps[i] = self.PropList[randpropid]
	end
	net.Broadcast()
end