-- our name is BBSProps

BBSProps = BBSProps or {}

local META = FindMetaTable("Entity")

--[[
	Entity:GetBBSOwner(ply)
	Gets the owner of entity.
--]]
function META:GetBBSOwner()
	return self:GetNWEntity("bbs_owner",NULL)
end

hook.Add("PhysgunPickup","bbsprops_physgunpickup",function(ply, ent)
	if ent:GetBBSOwner()!=ply then
		return false
	end
end)

hook.Add("CanTool","bbsprops_cantool",function(ply, tr, tool)
	local ent = tr.Entity
	if IsValid(ent) and ent:GetBBSOwner()!=ply then
		return false
	end
end)

hook.Add("CanProperty","bbsprops_canproperty",function(ply, property, ent)
	if ent:GetBBSOwner()!=ply then
		return false
	end
end)