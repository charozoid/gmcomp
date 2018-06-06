GM.Name = "Build Battles"
GM.Author = "Fexa & Charozoid"
GM.Email = ""
GM.Website = ""

DeriveGamemode( "sandbox" )

BBS = {}
BBS.Gamemodes = {}
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
	SetGlobalInt("Gamemode", 0)
	SetGlobalInt("ThemeID", 0)
end
--[[
	BBS:AddGamemode(string name, int buildtime, table loadout, table phases)
	Add a custom gamemode to the game
	phases = {{["name"] = "", ["time"] = 0}}
]]--

function BBS:AddGamemode(name, loadout, phases, customtools, propfunc)
	local count = #self.Gamemodes + 1
	self.Gamemodes[count] = {["name"] = name, ["loadout"] = loadout, ["tools"] = customtools, ["phases"] = phases, ["propfunc"] = propfunc}
end

BBS:AddGamemode("Random Props", 
	nil, 
	{
		{["name"] = "Prebuild", 
		["time"] = 10,
		["func"] = function() 
			print("This shit works")
		end}, 
		{["name"] = "Build", 
		["time"] = 10,
		["func"] = function() 
			print("This shit works2")
		end}, 
		{["name"] = "Vote", 
		["time"] = 10,
		["func"] = function() 
			print("This shit works3")
		end}
	},
	nil,
	function()
		if SERVER then
			BBS:PickRandomProps(10)
		end
	end)

BBS:AddGamemode("Gravity tower", 
	{"weapon_physcannon"}, 
	{
		{["name"] = "Build", 
		["time"] = 10,
		["func"] = function() 
			print("This shit works")
		end}, 
		{["name"] = "Vote", 
		["time"] = 10,
		["func"] = function() 
			print("This shit works2")
		end}
	},
	{"wheel", "weld", "axis"})

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
	return self:GetGamemode().phases[roundstate].time
end
--[[
	BBS:GetPhaseName()
	Returns the current phase name
]]--
function BBS:GetPhaseName()
	local roundstate = GetGlobalInt("RoundState")
	return self:GetGamemode().phases[roundstate].name
end
--[[
	BBS:GetNextPhaseName()
	Returns the current phase name
]]--
function BBS:GetNextPhaseName()
	local roundstate = GetGlobalInt("RoundState") + 1
	if roundstate > #self:GetGamemode().phases then
		return "End"
	else
		return self:GetGamemode().phases[roundstate].name
	end
end
--[[
	BBS:GetGamemode()
	Returns the current gamemode table
]]--
function BBS:GetGamemode()
	return self.Gamemodes[GetGlobalInt("Gamemode")]
end

--[[
	BBS:GetTheme()
	Returns the current selected theme
]]--
function BBS:GetTheme()
	return self.Themes[GetGlobalInt("ThemeID")]
end

--[[
	BBS:GetGamemodeTools()
	Returns the gamemode tools
]]--
function BBS:GetGamemodeTools()
	return self:GetGamemode().tools
end
