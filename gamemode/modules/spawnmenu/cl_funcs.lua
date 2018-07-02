--[[
	spawnmenu.FindTool(ToolName tname)
	Finds the tool table from spawnmenu and returns it.
]]--
function spawnmenu.FindTool(tname)
	local tab = nil
	if not tname then return nil end
	for _, cat in pairs(spawnmenu.GetToolMenu("Main")) do
		for __, tool in pairs(cat) do
			if not isstring(tool) and ((tool.ItemName)==tname) then
				tab = tool
				tab.Category = cat.ItemName
				goto found
			end
		end
	end
	::found::
	return tab
end