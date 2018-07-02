function BBS:AddChatCommand(command, func)
	local count = #self.Commands + 1
	self.Commands[count] = {["command"] = command, ["func"] = func}
end

BBS:AddChatCommand("suicide", function(ply)
	if SERVER then
		ply:Kill()
		BBS.AddChatText(ply, Color(255, 0, 0), "You have killed yourself!")
	end
end)

BBS:AddChatCommand("kill", function(target)
	if SERVER then
		target:Kill()
	end
end)

BBS:AddChatCommand("minigame", function(num)
	if SERVER then
		BBS:SetMinigame(num)
	end
end)

BBS:AddChatCommand("start", function(num)
	if SERVER then
		BBS:StartMinigame()
	end
end)

BBS:AddChatCommand("reset", function()
	if SERVER then
		BBS:ResetTimer()
	end
end)
