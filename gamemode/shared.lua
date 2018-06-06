GM.Name = "Build Battles"
GM.Author = "Fexa & Charozoid"
GM.Email = ""
GM.Website = ""

DeriveGamemode( "sandbox" )

BBS = {}
BBS.Minigames = {}
BBS.Themes = {}

--Setting global round states
PHASE_IDLE = 0

BBS.AllowedProps = {}
BBS.PropList = {
"models/props_borealis/mooring_cleat01.mdl",
"models/props_borealis/door_wheel001a.mdl",
"models/props_borealis/borealis_door001a.mdl",
"models/props_borealis/bluebarrel001.mdl",
"models/props_building_details/storefront_template001a_bars.mdl",
"models/props_c17/canister01a.mdl",
"models/props_c17/canister_propane01a.mdl",
"models/props_c17/bench01a.mdl",
"models/props_c17/chair02a.mdl",
"models/props_c17/concrete_barrier001a.mdl",
"models/props_c17/display_cooler01a.mdl",
"models/props_c17/door01_left.mdl",
"models/props_c17/fence01a.mdl",
"models/props_c17/furniturebathtub001a.mdl",
"models/props_c17/furniturebed001a.mdl",
"models/props_c17/furniturecouch001a.mdl",
"models/props_c17/furnituredrawer001a.mdl",
"models/props_c17/furniturechair001a.mdl",
"models/props_c17/furniturefridge001a.mdl",
"models/props_c17/furniturefireplace001a.mdl",
"models/props_junk/plasticcrate01a.mdl",
"models/props_junk/plasticcrate01a.mdl",
"models/props_junk/plasticcrate01a.mdl",
"models/props_c17/oildrum001.mdl",
"models/props_c17/gravestone_cross001b.mdl",
"models/props_c17/gravestone001a.mdl",
"models/props_c17/furnituresink001a.mdl",
"models/props_c17/furniturestove001a.mdl",
"models/props_c17/shelfunit01a.mdl",
"models/props_combine/breendesk.mdl",
"models/props_combine/breenchair.mdl",
"models/props_combine/breenglobe.mdl",
"models/props_interiors/furniture_couch01a.mdl",
"models/props_interiors/vendingmachinesoda01a.mdl",
"models/props_interiors/radiator01a.mdl",
"models/props_interiors/pot01a.mdl",
"models/props_interiors/pot02a.mdl",
"models/props_junk/popcan01a.mdl",
"models/props_junk/pushcart01a.mdl",
"models/props_junk/trashdumpster01a.mdl",
"models/props_junk/wood_crate001a.mdl",
"models/props_junk/trafficcone001a.mdl",
"models/props_junk/trashbin01a.mdl",
"models/props_trainstation/trashcan_indoor001a.mdl",
"models/props_trainstation/tracksign02.mdl",
"models/props_wasteland/barricade002a.mdl",
"models/props_wasteland/barricade001a.mdl",
"models/props_vehicles/tire001a_tractor.mdl",
"models/props_wasteland/gaspump001a.mdl",
"models/props_wasteland/kitchen_counter001a.mdl",
"models/props_wasteland/kitchen_stove001a.mdl",
"models/props_wasteland/kitchen_stove002a.mdl",
"models/props_wasteland/kitchen_fridge001a.mdl",
"models/props_wasteland/kitchen_shelf001a.mdl",
"models/props_wasteland/laundry_dryer002.mdl",
"models/props_junk/sawblade001a.mdl",
"models/props_junk/ravenholmsign.mdl",
"models/props_c17/streetsign001c.mdl",
"models/props_c17/streetsign003b.mdl",
"models/props_junk/garbage_takeoutcarton001a.mdl",
"models/props_junk/garbage_plasticbottle001a.mdl",
"models/props_lab/monitor01a.mdl",
"models/props_lab/harddrive02.mdl"
}


function GM:Initialize()
	BBS:Initialize()
end

function BBS:Initialize()
	SetGlobalInt("RoundState", 0)
	SetGlobalInt("Minigame", 0)
	SetGlobalInt("ThemeID", 0)
end
--[[
	BBS:AddMinigame(string name, int buildtime, table loadout, table phases)
	Add a custom Minigame to the game
	phases = {{["name"] = "", ["time"] = 0}}
]]--

function BBS:AddMinigame(tbl)
	local count = #self.Minigames + 1
	self.Minigames[count] = {["id"] = count, ["name"] = tbl.name, ["loadout"] = tbl.loadout, ["tools"] = tbl.customtools, ["phases"] = tbl.phases, ["propfunc"] = tbl.propfunc}
end

local minigame = {}

minigame.name = "Random Props"
minigame.loadout = nil
minigame.phases = {
	{	["name"] = "Prebuild", 
		["time"] = 10,
		["startfunc"] = function() 
			print("Prebuild start")
		end,
		["endfunc"] = function() 
			print("Prebuild end")
		end
	},
	{	["name"] = "Build", 
		["time"] = 10,
		["startfunc"] = function() 
			print("Build start")
		end,
		["endfunc"] = function() 
			print("Build end")
		end
	},
	{	["name"] = "Vote", 
		["time"] = 10,
		["startfunc"] = function() 
			print("Vote start")
		end,
		["endfunc"] = function() 
			print("Vote end")
		end
	}
}

minigame.customtools = {"weld", "axis", "wheel"}
minigame.propfunc = function()
		if SERVER then
			BBS:PickRandomProps(10)
		end
	end

BBS:AddMinigame(minigame)

local minigame = {}

minigame.name = "Random Props"
minigame.loadout = {"weapon_physcannon"}
minigame.phases = 
	{
		{["name"] = "Build", 
		["time"] = 10,
		["startfunc"] = function() 
			print("This shit works")
		end,
		["endfunc"] = function() 
			print("This shit works2")
		end}, 
		{["name"] = "Vote", 
		["time"] = 10,
		["startfunc"] = function() 
			print("This shit works3")
		end,
		["endfunc"] = function() 
			print("This shit works4")
		end}
	}


minigame.customtools = {"weld", "axis", "wheel"}
minigame.propfunc = function()
		if SERVER then
			BBS:PickRandomProps(10)
		end
	end

BBS:AddMinigame(minigame)

minigame = nil
--[[
	BBS:AddTheme(string name, table customtools, table customprops)
	Add a theme with a choice of customtools and customprops
]]--
function BBS:AddTheme(name)
	local count = #self.Themes
	self.Themes[count] = {["name"] = name}
end

BBS:AddTheme("Car")



--[[
	BBS:GetPhaseTotalTime()
	Returns the current phase total time
]]--
function BBS:GetPhaseTotalTime()
	local roundstate = GetGlobalInt("RoundState")
	if self:GetMinigame() then
		return self:GetMinigame().phases[roundstate].time
	end
end
--[[
	BBS:GetPhaseName()
	Returns the current phase name
]]--
function BBS:GetPhaseName()
	local roundstate = GetGlobalInt("RoundState")
	return self:GetMinigame().phases[roundstate].name
end
--[[
	BBS:GetNextPhaseName()
	Returns the current phase name
]]--
function BBS:GetNextPhaseName()
	local roundstate = GetGlobalInt("RoundState") + 1
	if roundstate > #self:GetMinigame().phases then
		return "End"
	else
		return self:GetMinigame().phases[roundstate].name
	end
end
--[[
	BBS:GetMinigame()
	Returns the current Minigame table
]]--
function BBS:GetMinigame()
	return self.Minigames[GetGlobalInt("Minigame")]
end
function BBS.GetPhaseTimeLeft()
	return math.ceil(timer.TimeLeft("RoundTimer"))
end
--[[
	BBS:GetTheme()
	Returns the current selected theme
]]--
function BBS:GetTheme()
	return self.Themes[GetGlobalInt("ThemeID")]
end

--[[
	BBS:GetMinigameTools()
	Returns the Minigame tools
]]--
function BBS:GetMinigameTools()
	return self:GetMinigame().tools
end
