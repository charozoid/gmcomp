--[[
	BBSChatCommands Playersay Hook
	Controls chat commands
]]--
hook.Add("PlayerSay", "BBSChatCommands", function(sender, string) 
	if string.sub(string, 1, 1) == "!" then
		local argstart, argend = string.find(string, " ") --Find a space in the string for args
		if argstart then --If there is a space
			local command = string.sub(string, 2, argstart - 1)
			for k,v in pairs(BBS.Commands) do
				if v.command == command then
					local var = string.sub(string, argstart + 1)
					if not tonumber(var) then
						local plytbl = player.GetAll()
						local foundtbl = {}
						for o,p in pairs(plytbl) do
							local nick = string.lower(p:Nick())
							if string.lower(nick) == var then
								v.func(p)
								return ""
							end
							if string.find(nick, var) then
								table.insert(foundtbl, p)
							end
							if o==#plytbl and #foundtbl == 0 then
								--local fstart, fend, string = string.find()
								BBS.AddChatText(sender, Color(150, 0, 0), "No players found with this name.")
								return ""
							end
						end
						if #foundtbl > 1 then
							BBS.AddChatText(sender, Color(150, 0, 0), "Many players found with this name.")
						else
							v.func(foundtbl[1])
							return ""
						end	
					else
						local num = tonumber(var)
						v.func(num)
						return ""
					end	
				end
			end
		else
			local command = string.sub(string, 2)
			for k,v in pairs(BBS.Commands) do
				if v.command == command then
					v.func(sender)
					return ""
				end
			end
		end
	end
	return string
end)
util.AddNetworkString("BBSChatText")
function BBS.AddChatText(...)
	local vars = {...}
	net.Start("BBSChatText")
	net.WriteUInt(#vars, 16)
	if type(vars[1]) == "Player" then
		for k,v in pairs(vars) do
			if type(v) == "string" then
				net.WriteString(v)
			elseif type(v) == "table" then
				net.WriteUInt(v.r, 8)
				net.WriteUInt(v.g, 8)
				net.WriteUInt(v.b, 8)
			end
		end
		net.Send(vars[1])
	else
		for k,v in pairs(vars) do
				if type(v) == "string" then
				net.WriteString(v)
			elseif type(v) == "table" then
				net.WriteUInt(v.r, 8)
				net.WriteUInt(v.g, 8)
				net.WriteUInt(v.b, 8)
			end		
		end
		net.Broadcast()
	end
end