GM.Name = "Build Battles"
GM.Author = "Fexa & Charozoid"
GM.Email = ""
GM.Website = ""

DeriveGamemode( "sandbox" )

BBS = {}

--Setting round timers
BBS.PrebuildTimer = 10
BBS.BuildTimer = 10
BBS.VoteTimer = 10

--Setting global round states
PHASE_PREBUILD = 1
PHASE_BUILD = 2
PHASE_VOTE = 3

function GM:GetPhaseTotalTime(phase)
	if phase==1 then
		return BBS.PrebuildTimer
	elseif phase==2 then
		return BBS.BuildTimer
	elseif phase==3 then
		return BBS.VoteTimer
	end
end

function GM:Initialize()
	SetGlobalInt("RoundState", PHASE_PREBUILD)
	SetGlobalString("Theme", "")
	
	if SERVER then
		BBS.StartRoundTimer()
	end
end


