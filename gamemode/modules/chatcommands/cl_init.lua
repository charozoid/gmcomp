--[[
	net.Receive("BBSChatText")
	Receives and displays serverside chat.AddText
]]--
net.Receive("BBSChatText", function()
	local len = net.ReadUInt(16)
	local args = {}

	for i=1,len/2 do
		local col = Color(net.ReadUInt(8), net.ReadUInt(8), net.ReadUInt(8), 255)
		local text = net.ReadString()

		table.insert(args, col)
		table.insert(args, text)
	end

	chat.AddText(unpack(args))
	chat.PlaySound()
end)