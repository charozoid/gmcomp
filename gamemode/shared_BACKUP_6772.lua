GM.Name = "Build Battles"
GM.Author = "Fexa & Charozoid"
GM.Email = ""
GM.Website = ""

DeriveGamemode( "sandbox" )

BBS = {}
BBS.Gamemodes = {}
BBS.Themes = {}

--Setting round timers
BBS.PrebuildTimer = 10
BBS.BuildTimer = 10
BBS.VoteTimer = 10

--Setting global round states
PHASE_PREBUILD = 1
PHASE_BUILD = 2
PHASE_VOTE = 3

<<<<<<< HEAD
function BBS:GetPhaseTotalTime(phase)
	if phase==PHASE_PREBUILD then
		return self.PrebuildTimer
	elseif phase==PHASE_BUILD then
		return self:GetGamemode().buildtime
	elseif phase==PHASE_VOTE then
		return self.VoteTimer
=======
--[[
	BBS:GetPhaseTotalTime(int phase)
	Returns given phase's total phase time.
--]]
function BBS:GetPhaseTotalTime(phase)
	if phase==1 then
		return BBS.PrebuildTimer
	elseif phase==2 then
		return BBS.BuildTimer
	elseif phase==3 then
		return BBS.VoteTimer
>>>>>>> d67f52e51d736fd4289f28c667633734a63d3b41
	end
end

function GM:Initialize()
	BBS:Initialize()
end

function BBS:Initialize()
	SetGlobalInt("RoundState", PHASE_PREBUILD)
	SetGlobalInt("ThemeID", 0)
	
	if SERVER then
		self:SetGamemode(1)
		self.StartRoundTimer()	
	end

end
--[[
	BBS:AddGamemode(string name, int buildtime)
	Add a custom gamemode to the game
]]--

function BBS:AddGamemode(name, buildtime)
	local count = #self.Gamemodes + 1
	self.Gamemodes[count] = {["name"] = name, ["buildtime"] = buildtime}
	PrintTable(self.Gamemodes)
end

BBS:AddGamemode("Random Props", 60)

--[[
	BBS:AddTheme(string name, table customtools, table customprops)
	Add a theme with a choice of customtools and customprops
]]--
function BBS:AddTheme(name, customtools, customprops)
	local count = #self.Themes
	self.Themes[count] = {["name"] = name, ["customtools"] = customtools, ["customprops"] = customprops}
end

BBS:AddTheme("Car", {"wheel"}, nil)

--[[
	BBS:SetGamemode(int gamemode ID)
	Sets the current gamemode
]]--
function BBS:SetGamemode(id)
	SetGlobalInt("Gamemode", id)
	local gamem = self.Gamemodes[id]
	self.BuildTimer = gamem.buildtime
	print(self.BuildTimer)
end
--[[
	BBS:SetGamemode(int gamemode ID)
	Returns the current gamemode table
]]--
function BBS:GetGamemode()
	return self.Gamemodes[GetGlobalInt("Gamemode")]
end
