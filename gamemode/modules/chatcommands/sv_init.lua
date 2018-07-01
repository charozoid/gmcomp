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
						for o,p in pairs(plytbl) do
							if string.lower(p:Nick()) == var then
								v.func(p)
								break
							end
							if o==#plytbl then
								print("No player found")
							end
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