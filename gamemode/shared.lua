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

SetGlobalInt("RoundState", 0)
SetGlobalInt("Minigame", 0)
SetGlobalInt("ThemeID", 0)
BBS.Votes = {}

function GM:Initialize()

end


--[[
	BBS:AddTheme(string name, table customtools, table customprops)
	Add a theme with a choice of customtools and customprops
]]--
function BBS:AddTheme(name)
	local count = #self.Themes + 1
	self.Themes[count] = {["name"] = name, ["id"] = count}
end

BBS:AddTheme("Car")

--[[
	BBS:GetTheme()
	Returns the current selected theme
]]--
function BBS:GetTheme()
	if GetGlobalInt("ThemeID") == 0 then return false end
	return self.Themes[GetGlobalInt("ThemeID")]
end
--[[
	BBS:GetThemes()
	Returns the theme table
]]--
function BBS:GetThemes()
	return self.Themes
end
--[[
	BBS:GetMinigameTools()
	Returns tools used in the minigame if there is any
]]--
function BBS:GetMinigameTools()
	if self:GetMinigame().customtools then
		return self:GetMinigame().customtools
	else
		return nil
	end
end

--[[
	string.fromrand(text)
	ex: print(string.fromrand("[Welcome back|Hello|Hi again|You are welcome|Welcome back to BuildBattles]!.")) prints something like Hello!
	dunno how much its needed but.. I like it, it would make the gamemode more friendly and not as a stone hard machine
	be sure you are not calling it from a repedately(not sure if its said that way) hook. call it for once.
]]--
function string.fromrand(rand)
	for data in string.gmatch(rand,"%[(.-)%]") do -- for every >[...]< case
		if not data:find("%|") then continue end -- if not there is any >|< in these brackets
		local pair_table = string.Explode("|",data) -- explode that bracket case by >|< to get choices
		local selected = pair_table[math.random(#pair_table)] -- select one from all choices
		data = "["..data.."]" -- some debugging..
		local data_escaped = data:gsub("(%W)", "%%%1") -- this thing replaces special characters to escape them from string pattern
		rand = rand:gsub(data_escaped,selected,1) -- replace what we did
	end
	return rand
end