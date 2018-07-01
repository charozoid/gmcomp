function BBS:GetHighestVoted()
	local votetbl = self:GetVotes()
	local keytbl = {}
	for k,v in pairs(votetbl) do
		table.insert(keytbl, {["id"] = k, ["votes"] = v})
	end
	table.sort(keytbl, function(a, b) return a.votes > b.votes end)

	local winnertbl = {}

	for k,v in pairs(votetbl) do
		if v == keytbl[1].votes then
			winnertbl[k] = v
		end
	end

	if #winnertbl > 1 then
		local winners = {}
		for k,v in pairs(winnertbl) do
			table.insert(winners, player.GetBySteamID64(k))
		end
		
	else
		--win
	end
	PrintTable(winnertbl)
end

local meta = FindMetaTable("Player")
util.AddNetworkString("BBSAddVote")

function meta:AddVote()
	local votes = BBS:GetVotes()
	local id64 = self:SteamID64()

	if votes[id64] then
		votes[id64] = votes[id64] + 1
	else
		votes[id64] = 1
	end
	net.Start("BBSAddVote")
	net.Send(self)
end

function meta:GetVotes()
	return BBS:GetVotes()[self:SteamID64()]
end
