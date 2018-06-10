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
					local ret = true
					for _, ent in pairs(ply:GetBBSEntities()) do
						if ent:GetModel()==mdl then
							ret = false
						end
					end
					return ret
				end)
			end
		end,
		["endfunc"] = function() 
			if SERVER then
				for _, ply in pairs(player.GetAll()) do
					ply:StripWeapons()
					ply.highestprop = 0
					ply.highestprop_prop = NULL

					for __, ent in pairs(ply:GetBBSEntities()) do
						if ent:GetClass()=="prop_physics" then
							local maxs = ent:OBBMaxs()
							maxs = maxs:Rotate(ent:GetAngles())

							if maxs.z>=ply.highestprop then
								ply.highestprop = maxs.z
								ply.highestprop_prop = ent
							end
						end
					end
				end
			end
		end}, 
		{["name"] = "Vote", 
		["time"] = 10,
		["startfunc"] = function() 
			if SERVER then
				local svhighest = 0
				local svhighest_player = NULL
				for _, ply in pairs(player.GetAll()) do
					if ply.highestprop>svhighest then
						svhighest = ply.highestprop
						svhighest_player = ply
					end 
				end

				PrintMessage(HUD_PRINTTALK,svhighest_player:Nick().." builded the highest tower!")
			end
		end,
		["endfunc"] = function() 
			if SERVER then
				for _, ply in pairs(player.GetAll()) do
					ply:Spawn()
					ply.highestprop = nil
				end
				hook.Remove("BBSGravTowerSpawn")
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