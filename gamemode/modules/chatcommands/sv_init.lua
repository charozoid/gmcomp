function GM:PlayerSay(sender, string)
	if string.sub(string, 1, 1) == "!" then
		local argstart, argend = string.find(string, " ")
		if argstart then
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
								break
							end
							if string.find(nick, var) then
								table.insert(foundtbl, p)
							end
							if o==#plytbl and #foundtbl == 0 then
								local fstart, fend, string = string.find()
								print("No player found")
							end
						end
						if #foundtbl > 1 then
							print("Many players with this name")
						else
							v.func(foundtbl[1])
						end	
					else
						local num = tonumber(var)
						v.func(num)
					end	
				end
			end
		else
			local command = string.sub(string, 2)
			for k,v in pairs(BBS.Commands) do
				if v.command == command then
					v.func(sender)
				end
			end
		end
	end
	return string
end