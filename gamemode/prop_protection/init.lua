--[[
	I'll use hook.Add cuz this is something like module. I feel like its wrong to override GM:
	Theres a lot to do with prop protection system..
		- Buddies
		- Anti-Crash (?)
		- Client UI
	I dont know if theres any bugs, I did a short test and everything was ok. It comes a bit stupid-
	to me when prop owning is that short. There must be some stupidness and some bugs.
--]]

local META = FindMetaTable("Entity")

--[[
	Entity:SetBBSOwner(ply)
	Sets the owner of entity.
--]]
function META:SetBBSOwner(ply)
	self:SetNWEntity("bbs_owner",ply)
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

for i=1,#hook_names do
	hook.Add("PlayerSpawned"..hook_names[i],"bbsprops_playerspawned",function(ply, ent, _ent)
		if not isentity(ent) then
			ent = _ent
		end
		ent:SetBBSOwner(ply)
	end)
end