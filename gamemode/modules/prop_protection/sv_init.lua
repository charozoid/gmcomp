--[[
	I'll use hook.Add cuz this is something like module. I feel like its wrong to override GM:
	Theres a lot to do with prop protection system..
		- Buddies
		- Anti-Crash (?)
		- Client UI
	I dont know if theres any bugs, I did a short test and everything was ok. It comes a bit stupid-
	to me when prop owning is that short. There must be some stupidness and some bugs.
]]--

local ENTITY = FindMetaTable("Entity")

--[[
	Entity:SetBBSOwner(Player ply)
	Sets the owner of entity.
]]--
function ENTITY:SetBBSOwner(ply)
	if ply==nil or ply==NULL then -- if the owner is not valid
		local owner = self:GetBBSOwner()
		if owner and owner:IsPlayer() and owner.BBSEnts then
			table.RemoveByValue(owner.BBSEnts,self)
		end
		self:SetNWEntity("bbs_owner",NULL)
	else -- if its valid
		if not ply:IsPlayer() then return end -- if he is a player (?)

		table.insert(ply.BBSEnts,self)
		self:SetNWEntity("bbs_owner",ply)
	end
end

local PLAYER = FindMetaTable("Player")

--[[
	Player:GetBBSEntities()
	Returns player's entities.
]]--
function PLAYER:GetBBSEntities()
	return self.BBSEnts
end

local hook_names = {
	"Effect",
	"NPC",
	"Prop",
	"Ragdoll",
	"SENT",
	"SWEP",
	"Vehicle"
}


--[[
	Spawn hooks.
	bbsprops_playerspawned+[Effect|NPC|Prop|Ragdoll|SENT|Vehicle] : Sets the owner of entity when its spawned.
]]--
for i=1,#hook_names do
	hook.Add("PlayerSpawned"..hook_names[i],"bbsprops_playerspawned",function(ply, ent, _ent)
		if not isentity(ent) then
			ent = _ent
		end
		ent:SetBBSOwner(ply)
	end)
end

--[[
	Deletion hooks.
	bbsprops_entityremoved : Removes the entity from owners ent table.
]]--
hook.Add("EntityRemoved","bbsprops_entityremoved",function(ent)
	ent:SetBBSOwner(NULL) -- remove that entity from its owners BBSEnts table
end)

--[[
	EXPERIMENTAL Hooks (Can be removed/edited later.)
	bbsprops_playerinitialspawn : Prepares a entities table for recording player's entities.
	bbsprops_playerdisconnected : Removes entity when its owner disconnects.
	bbsprops_gravgunpickupallowed : Disallow gravgun pickup for other peoples ents.
]]--

hook.Add("PlayerInitialSpawn","bbsprops_playerinitialspawn",function(ply)
	ply.BBSEnts = {} -- created his table
end)

hook.Add("PlayerDisconnected","bbsprops_playerdisconnected",function(ply)
	for _, ent in pairs(ply:GetBBSEntities()) do
		ent:Remove()
	end
end)

hook.Add("GravGunPickupAllowed","bbsprops_gravgunpickupallowed",function(ply, ent)
	if not ply:CanTouch(ent) then
		return false
	end
end)

--[[
	BBS:AllowProps(table propindex)
	Adds the prop to the allowedprops table and networks to the client
]]--
util.AddNetworkString("BBSPropList")

function BBS:AllowProps(tbl)
	self.AllowedProps = {}
	local len = #tbl

	net.Start("BBSPropList")
		net.WriteInt(len, 16)

		for k,v in ipairs(tbl) do
			net.WriteInt(v, 16)
			self.AllowedProps[self.PropList[v]] = true
		end
	net.Broadcast()
end