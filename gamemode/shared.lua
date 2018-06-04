GM.Name = "Build Battles"
GM.Author = "Fexa & Charozoid"
GM.Email = ""
GM.Website = ""

DeriveGamemode( "sandbox" )

BBS = {}

BBS.PrebuildTimer = 10
BBS.BuildTimer = 10
BBS.VoteTimer = 10

--Setting global round states
PHASE_PREBUILD = 1
PHASE_BUILD = 2
PHASE_VOTE = 3

function GM:Initialize()
	SetGlobalInt("RoundState", PHASE_PREBUILD)

	if SERVER then
		BBS.StartRoundTimer()
	end
end


