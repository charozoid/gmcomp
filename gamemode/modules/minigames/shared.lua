--[[
	BBS:AddMinigame(string name, int buildtime, table loadout, table phases)
	Add a custom Minigame to the game
	phases = {{["name"] = "", ["time"] = 0}}
]]--

function BBS:AddMinigame(tbl)
	local count = #self.Minigames + 1
	self.Minigames[count] = {["id"] = count, ["name"] = tbl.name, ["loadout"] = tbl.loadout, ["tools"] = tbl.tools, ["phases"] = tbl.phases, ["propfunc"] = tbl.propfunc}
end

local minigame = {}

minigame.name = "Random Props"
minigame.loadout = nil
minigame.phases = {
	{	["name"] = "Build", 
		["time"] = 60,
		["startfunc"] = function() 
			if SERVER then
				BBS:SetRandomTheme()
				BBS:PickRandomProps(50)
				BBS.AllowedTools = {}
				for k,v in pairs(BBS:GetMinigameTools()) do
					BBS.AllowedTools[v] = true
				end
			end
		end,
		["endfunc"] = function() 

		end
	},
	{	["name"] = "Vote", 
		["time"] = 10,
		["startfunc"] = function() 

		end,
		["endfunc"] = function() 

		end
	}
}

minigame.tools = {"weld", "axis", "wheel"}
minigame.propfunc = function()
		if SERVER then
			BBS:PickRandomProps(10)
		end
	end

BBS:AddMinigame(minigame)

local minigame = {}

if SERVER then
	util.AddNetworkString("bbsminigame_gtowers")
end

if CLIENT then
	bbsminigame_gtowers = bbsminigame_gtowers or {}
	bbsminigame_gtowers.stopat = bbsminigame_gtowers.stopat or 0
	net.Receive("bbsminigame_gtowers",function()
		bbsminigame_gtowers.ply = net.ReadString()
		bbsminigame_gtowers.prop = net.ReadEntity()
		bbsminigame_gtowers.pos = net.ReadVector()
		bbsminigame_gtowers.stopat = CurTime()+BBS:GetMinigame().phases[#BBS:GetMinigame().phases].time -- get the showcase phase's time
	
		chat.AddText(Color(17,161,17),"[Gravity Towers] ",color_white,bbsminigame_gtowers.ply.." builded the highest tower!")
	end)

	hook.Add("PostDrawTranslucentRenderables","bbsminigame_gtowers",function()
		if bbsminigame_gtowers.stopat>=CurTime() then
			if not bbsminigame_gtowers.prop then return end
			if not bbsminigame_gtowers.pos then return end

			render.SetColorMaterial()
			render.DrawSphere(bbsminigame_gtowers.pos,1,12,12,Color(17,161,17))
			render.DrawLine(bbsminigame_gtowers.pos,bbsminigame_gtowers.pos+Vector(0,0,10),Color(17,161,17))
			halo.Add({bbsminigame_gtowers.prop},Color(17,161,17))

			local w,h = 100, 15
			local ang = Angle(0,EyeAngles().y-90,90)
			--ang:RotateAroundAxis(bbsminigame_gtowers.prop:GetUp(),90)
			cam.Start3D2D(bbsminigame_gtowers.pos+Vector(0,0,13),ang,0.1)
				draw.WordBox(2,0,0,"Highest Point","Roboto28-300",Color(30,30,30),color_white)
				draw.WordBox(2,0,33,bbsminigame_gtowers.ply,"Roboto24-300",Color(30,30,30),color_white)
			cam.End3D2D()
		end
	end)
end

minigame.name = "Gravity Towers"
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
				hook.Add("GravGunPunt", "BBSGravTowerPunt", function(ply, ent)
					return false
				end)
			end
		end,
		["endfunc"] = function()
			if SERVER then
				for _, ply in pairs(player.GetAll()) do
					ply:StripWeapons()
				end
			end
		end
		},
		{["name"] = "Finalizing",
		["time"] = 4,
		["startfunc"] = function()
			if CLIENT then
				chat.AddText(Color(17,161,17),"[Gravity Towers] ", color_white, "Waiting for props to settle down...")
			end
		end,
		["endfunc"] = function() 
			if SERVER then
				for _, ply in pairs(player.GetAll()) do
					ply.highestz = -999999 -- to get lowest point before detecting higher one. 0 doesnt work cuz some maps are located at below 0
					ply.highestprop = NULL
					ply.highestpos = NULL
					for __, ent in pairs(ply:GetBBSEntities()) do
						if ent:GetClass()=="prop_physics" then
							if not IsValid(ent:GetPhysicsObject()) then continue end
							ent:GetPhysicsObject():EnableMotion(false)
							for _, data in pairs(ent:GetPhysicsObject():GetMeshConvexes()) do
								for __, vertex in pairs(data) do
									local pos = vertex.pos
									pos:Rotate(ent:GetAngles())
									pos = pos+ent:GetPos()
									if pos.z>ply.highestz then
										ply.highestz = pos.z
										ply.highestprop = ent
										ply.highestpos = pos
									end
								end
							end
						end
					end
				end
			end
		end},
		{["name"] = "Showcase", 
		["time"] = 15,
		["startfunc"] = function() 
			if SERVER then
				local svhighestz = -999999 -- to get lowest point before detecting higher one. 0 doesnt work cuz some maps are located at below 0
				local svhighestprop = NULL
				local svhighestplayer = NULL
				local svhighestpos = NULL

				for _, ply in pairs(player.GetAll()) do
					if ply.highestz>svhighestz then
						svhighestz = ply.highestz
						svhighestprop = ply.highestprop
						svhighestplayer = ply
						svhighestpos = ply.highestpos
					end
				end
				net.Start("bbsminigame_gtowers")
					net.WriteString(svhighestplayer:Nick())
					net.WriteEntity(svhighestprop)
					net.WriteVector(svhighestpos)
				net.Broadcast()
				--BroadcastLua([[chat.AddText(Color(17,161,17),"[Gravity Towers] ",color_white,"]]..svhighestplayer:Nick()..[[".." builded the highest tower!")]])
			end
		end,
		["endfunc"] = function() 
			if SERVER then
				for _, ply in pairs(player.GetAll()) do
					ply:Spawn()
					ply.highestprop = nil
				end
				hook.Remove("PlayerSpawnProp", "BBSGravTowerSpawn")
				hook.Remove("GravGunPunt", "BBSGravTowerPunt")
			end
		end}
	}


minigame.tools = nil
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
	if GetGlobalInt("Minigame") == 0 then return false end
	return self.Minigames[GetGlobalInt("Minigame")]
end

--[[
	BBS:GetMinigameTools()
	Returns tools used in the minigame if there is any
]]--
function BBS:GetMinigameTools()
	if not self:GetMinigame() or not self:GetMinigame().tools then
		return nil
	end
	return self:GetMinigame().tools
end