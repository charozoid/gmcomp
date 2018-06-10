-- our name is BBSProps

BBSProps = BBSProps or {}

local ENTITY = FindMetaTable("Entity")

--[[
	Entity:GetBBSOwner(ply)
	Gets the owner of entity.
--]]
function ENTITY:GetBBSOwner()
	return self:GetNWEntity("bbs_owner",NULL)
end

local PLAYER = FindMetaTable("Player")

--[[
	Player:CanTouch(Entity ent)
	Returns if player is allowed to touch/interact with that entity.
]]--
function PLAYER:CanTouch(ent)
	return ent:GetBBSOwner()==self
end

hook.Add("PhysgunPickup","bbsprops_physgunpickup",function(ply, ent)
	--[[
		Could made like return ply:CanTouch(ent) but it is risky. It can override other hooks.
	]]--
	if not ply:CanTouch(ent) then
		return false
	end 
end)

hook.Add("CanTool","bbsprops_cantool",function(ply, tr, tool)
	local ent = tr.Entity
	if not ply:CanTouch(ent) then
		return false
	end 
end)

hook.Add("CanProperty","bbsprops_canproperty",function(ply, property, ent)
	if not ply:CanTouch(ent) then
		return false
	end 
end)