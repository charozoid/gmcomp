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

minigame.name = "Highest Tower"
minigame.loadout = {"weapon_physcannon"}
minigame.phases = 
	{
		{["name"] = "Build", 
		["time"] = 60,
		["startfunc"] = function() 
		if SERVER then
			hook.Add("PlayerSpawnProp", "BBSGravTowerSpawn", function(ply, mdl)
				if ply.SpawnedProps[mdl] then
					return false
				else
					return true
				end
			end)
			hook.Add("PlayerSpawnedProp", "BBSGravTowerSpawned", function(ply, mdl)
				ply.SpawnedProps[mdl] = true
			end)
		end
		end,
		["endfunc"] = function() 
		if SERVER then
			for k, v in pairs(player.GetAll()) do
				v:StripWeapons()
			end
		end
		end}, 
		{["name"] = "Vote", 
		["time"] = 10,
		["startfunc"] = function() 
			print("This shit works3")
		end,
		["endfunc"] = function() 
			if SERVER then
				for k, v in pairs(player.GetAll()) do
					v.SpawnedProp = {}
					v:Spawn()
				end
				hook.Remove("BBSGravTowerSpawn")
				hook.Remove("BBSGravTowerSpawned")
			end
		end}
	}


minigame.customtools = nil
minigame.propfunc = function()
		if SERVER then
			BBS:PickRandomProps(10)
		end
	end

BBS:AddMinigame(minigame)

minigame = nil
--[[
	BBS:GetMinigame()
	Returns the current Minigame table
]]--
function BBS:GetMinigame()
	return self.Minigames[GetGlobalInt("Minigame")]
end
--[[
	BBS:GetMinigameTools()
	Returns the Minigame tools
]]--
function BBS:GetMinigameTools()
	return self:GetMinigame().tools
end