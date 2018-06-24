
net.Receive("BBSAddVote", function()
	local votes = BBS:GetVotes()
	local id64 = LocalPlayer():SteamID64()

	if votes[id64] then
		votes[id64] = votes[id64] + 1
	else
		votes[id64] = 1
	end
end)