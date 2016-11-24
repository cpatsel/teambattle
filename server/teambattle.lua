playersReady = 0;
MIN_PLAYERS = 2;
VOTE_TIME = 5; --Time for votes in seconds.
ROUND_TIME = 30 --Time for rounds in minutes
CHECKPLAYER_TIME = 30 -- Time to wait in-between voting rounds.
isGameRunning = false
gameMode = "wait"
forceGameStart = false
textColor = Color(115, 170, 220)
colorRed = Color(255,0, 0)
colorGreen = Color(0, 255, 0)
colorBlue = Color(0, 0, 255)
colorRadio = Color(255,0,255)
totalPlayers = {}
redTeam = {}
blueTeam = {}

team1Name = "RED"
team2Name = "BLUE"
team1Model = 52 -- Govt. Soldier 2
team2Model = 59 --Roaches Soldier 2
defaultModel = 34 -- Tom Sheldon


function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

function PlayerChat(args)
	if (string.starts(args.text, "/vote")) then
		if gameMode != "vote" then
			args.player:SendChatMessage("Can't vote yet!",colorRed)
			return false
		else
			local line = {}
			for k,v in string.gmatch(args.text, "%S+") do
				table.insert(line,k)
			end
			local vote = tonumber(line[2])
			if vote != nil and vote <= #gameMaps then
				args.player:SetNetworkValue("mapvote", gameMaps[vote])
				args.player:SendChatMessage("Vote cast for "..gameMaps[vote],colorGreen)
			else
				args.player:SendChatMessage("Invalid vote.",colorRed)
			end
		end
	end
	if args.text == "/pos" then
		print(args.player:GetPosition())
		return false
	end
	if args.text == "/sg" then
		args.player:SetNetworkValue("isingame",not args.player:GetValue("isingame"))
		args.player:SendChatMessage("Toggled game status",colorRadio)
	end
	if args.text == "/die" then
		args.player:SetHealth(0.001)
		return false
	end
	if args.text == "/clear" or args.text == "/cls" then
			for i=0, 13 do
				args.player:SendChatMessage("",colorBlue);
			end
		return false
	end
	if args.text == "/ready" then
		args.player:SetNetworkValue("isready", not args.player:GetValue("isready"))
		if (args.player:GetValue("isready")) then args.player:SendChatMessage("You are now ready.",colorGreen)
		else args.player:SendChatMessage("You are no longer ready.",colorRed)
		end
		return false
	end
	if args.text == "/force" then
		--forceGameStart = true
		VoteForMap()
		--StartGame() --Just start the game, for testing purposes.
	end
	if args.text == "/start" then
		if CheckForPlayers() == true then
			StartGame()
		else
			args.player:SendChatMessage("Not enough players are ready!",textColor)
		end
		return false
	end
	if args.text == "/dosh" then
		args.player:SetMoney(100000)
		return false
	end
	if args.text == "/ff" then
		args.player:SetModelId(22)
		return false
	end
	
	if string.starts(args.text,"/") then
		return false
	end
	return true
end



pregameSpawns = Vector3(-14086.923828,647.565002,-14133.714844)
Scispawns = {
	Vector3(11229.243164,295.011841,13629.721680)
	
}

oilrigBlueSpawns = {
	Vector3(13487.761719, 246.000092, 8374.313477),
	Vector3(13459.677734, 258.000000, 8372.576172)
}
oilrigRedSpawns = {
	Vector3(13117.674805, 245.999710,4877.251953),
	Vector3(13100.363281, 258.003815,4881.176758)
}

twofortsRedSpawns = {
	Vector3(7338.379395, 242.591782, -12402.055664),
	Vector3(7324.265625, 240.091370, -12389.548828),
	Vector3(7174.604004, 204.31584, -12096.792969)
}
twofortsBlueSpawns = {
	Vector3(7278.772949, 243.903580, -10833.377930),
	Vector3(7254.101563, 241.366989, -10816.667969),
	Vector3(7244.250000, 208.205338, -11270.101563)
}

snowtownRedSpawns = {
	Vector3(-3230.736816, 680.172119, -9639.092773),
	Vector3(-3228.648438, 656.165344, -9618.196289)
}
snowtownBlueSpawns = {
	Vector3(-3411.420654, 640.118652, -8959.943359),
	Vector3(-3380.758545, 625.964294, -9065.541016)
}
metroRedSpawns = {
	Vector3(-12984.646484, 203.097412, -996.036865),
	Vector3(-12996.444336, 203.064743, -992.394653),
	Vector3(-12980.592773, 216.766769, -929.102051)
}
metroBlueSpawns = {
	Vector3(-11945.137695, 203.141068, -1017.165039),
	Vector3(-11900.509766, 203.097397, -1084.895630),
	Vector3(-11913.561523, 203.097397, -1084.895630)
}

dunesRedSpawns = {
Vector3(-6414.409180, 359.236328, 4041.758301),
Vector3(-6442.712891, 359.321747, 4069.619629)
}
dunesBlueSpawns = {
Vector3(-5853.285156, 236.827118,2504.569336),
Vector3(-5873.191406, 236.801682,2486.928955)
}

bayouRedSpawns = {
Vector3(-1867.852539, 212.698425, 9927.549805),
Vector3(-1866.837280, 212.698395, 9970.952148)
}
bayouBlueSpawns ={
Vector3(-5913.595703, 203.541809, 9753.535156),
Vector3(-5988.159668, 210.843735, 9670.381836)
}
mapTime = 13 --The time to set the clock to for the chosen map. Default 13:00
gameMaps = {"oilrigs", "twoforts", "snowtown", "metro","dunes","bayou"}
selectedMap = "oilrigs"
genericRedSpawns = {}
genericBlueSpawns = {}
function PickRandomMap()
local selection = math.random(1,#gameMaps)
selectedMap = gameMaps[selection]
PickMap()
end


function PickMap()	
	if selectedMap == "oilrigs" then
		genericRedSpawns = oilrigRedSpawns
		genericBlueSpawns = oilrigBlueSpawns
		mapTime = 13
	end
	if selectedMap == "twoforts" then
		genericRedSpawns = twofortsRedSpawns
		genericBlueSpawns = twofortsBlueSpawns
		mapTime = 15
	end
	if selectedMap == "snowtown" then
		genericRedSpawns = snowtownRedSpawns
		genericBlueSpawns = snowtownBlueSpawns
		mapTime = 23
	end
	if selectedMap == "metro" then
		genericRedSpawns = metroRedSpawns
		genericBlueSpawns = metroBlueSpawns
		--Metro can be either night or day
		mapTime = (math.random(1,10))%2
		if (mapTime == 0) then mapTime = 3
		else mapTime = 10
		end
	end
	if selectedMap == "dunes" then
		genericRedSpawns = dunesRedSpawns
		genericBlueSpawns = dunesBlueSpawns
		mapTime = 12
	end
	if selectedMap == "bayou" then
		genericRedSpawns = bayouRedSpawns
		genericBlueSpawns = bayouBlueSpawns
		mapTime = 17
	end
end

function FirstLoad()
	local message = "Waiting for enough players to join..."
	Chat:Broadcast("[CB]"..message, textColor)
	for player in Server:GetPlayers() do
		local spawnPosition = pregameSpawns
		player:SetPosition(spawnPosition)
		player:ClearInventory()
		player:SetHealth(1)
		
	end
	if CheckForPlayers() == true then
		StartGame()
	end
end
function CheckForPlayers()
	if #totalPlayers >= MIN_PLAYERS then 
		return true		
	elseif forceGameStart == true then
		return true			
	else
		return false
	end

end
function OnPlayerJoin(args)
	table.insert(totalPlayers,args.player)
	args.player:SetNetworkValue("isingame", false)
	args.player:SetNetworkValue("mapvote", "oilrigs")
	args.player:SetNetworkValue("wp",pregameSpawns)
	args.player:SetNetworkValue("setwp",false)
	Chat:Broadcast(args.player:GetName().." has joined", textColor)
	
end

function OnPlayerQuit(args)
	table.remove(totalPlayers,args.player)
end
timer = Timer()
function TDMPostTick(args)

	if gameMode == "wait" then
		if (timer:GetSeconds() >= CHECKPLAYER_TIME) then
			if (CheckForPlayers() == true) then
				VoteForMap()
			else
				Chat:Broadcast("[TDM] Waiting for players ["..#totalPlayers.."/"..MIN_PLAYERS.."]",textColor)
				timer:Restart()
			end
			
		end
	elseif gameMode == "vote" then
		if (timer:GetSeconds() >= VOTE_TIME) then
			TallyVotes()
		elseif timer:GetSeconds() == (VOTE_TIME)/2 then
			Chat:Broadcast("[TDM] Only "..VOTE_TIME-timer:GetSeconds().." seconds left to vote!", textColor)
		end
	elseif gameMode == "fight" then
		if (timer:GetMinutes() >= ROUND_TIME) then
			Chat:Broadcast("[TDM] Time Up! Draw game!", colorRadio)
			KickAllPlayersBack(true)
		end
	end
end


function TallyVotes()
	local votes = {}
	--Initialize the table
	for i=1,#gameMaps do
		votes[gameMaps[i]] = 0
	end
	for player in Server:GetPlayers() do
		local val = player:GetValue("mapvote")
		votes[val] = votes[val] + 1
	end
	local mostVotes = 0
	local chosenMap = selectedMap
	for k,v in pairs(votes) do
		if v > mostVotes then
			mostVotes = v
			chosenMap = k
			print(k.." "..v)
		end
	end
	--TODO: handle ties
	Chat:Broadcast("Winning map is "..chosenMap, textColor)
	gameMode = "wait"
	selectedMap = chosenMap
	StartGame()
end

function VoteForMap()
	gameMode = "vote";
	local message = "Vote for a map with /vote [number]! You have "..VOTE_TIME.." seconds to vote."
	Chat:Broadcast(message, textColor)
	message = ""
	for i=1, #gameMaps do
		message = message .." "..i..". "..gameMaps[i] .. ", "
	end
	Chat:Broadcast(message, textColor)
	timer:Restart()
	
end
	
function setTheme()
	local decider = math.random(0,100)
	if decider < 10 then
		team2Name = "NINJAS"
		team1Name = "GANGSTERS"
		team1Model = 78 -- Thug boss
		team2Model = 44 -- Ninja
	elseif decider > 90 then
		team1Name = "MALE"
		team2Name = "FEMALE"
		team1Model = 15 -- Male Stripper
		team2Model = 86 -- Female Stripper
	elseif decider >= 80 and decider <= 90 then
		team1Name = "BIZNESS" --Intentionally Spelled wrong
		team2Name = "CASUAL"
		team1Model = 7
		team2Model = 73
	else
		team1Name = "RED"
		team2Name = "BLUE"
		team1Model = 52 -- Default
		team2Model = 59 -- Default
	end
end

function RemovePlayerFromAnyTeam(argplayer)
	for index, player in ipairs(redTeam) do
		if player == argplayer then
			table.remove(redTeam, index)
			break
		end
	end
	for index, player in ipairs(blueTeam) do
		if player == argplayer then
			table.remove(blueTeam, index)
			break
		end
	end
end

function KickAllPlayersBack(drawGame)
	for player in Server:GetPlayers() do
		RemovePlayerFromAnyTeam(player)
		player:ClearInventory()
		player:SetPosition(pregameSpawns)
		player:SetNetworkValue("isingame",false)
		if drawGame == true then
			player:SetModelId(57) -- Oil Worker for draws.
		else
			player:SetModelId(95) -- Exclusive Guest for winners.
			player:SetMoney(player:GetMoney()+10) --Prize money for winning and surviving.
		end
		gameMode = "wait"
		timer:Restart()
	end
end



function StartGame()

	PickMap()
	local message = "Starting game on "..selectedMap.." with "..Server:GetPlayerCount().." players"
	Chat:Broadcast("[TDM] "..message, textColor)
	setTheme()
	gameMode = "fight"
	local counter = math.random(0,1)
	local spawnPosition = nil
	for player in Server:GetPlayers() do
		player:SetNetworkValue("isingame", true)
		if counter%2 == 0 then
			table.insert(redTeam,player)
			local randomIndex = math.random(1, #genericRedSpawns)
			spawnPosition = genericRedSpawns[randomIndex]
			player:SendChatMessage("[TDM] You are on the " ..team1Name.." team.", colorRed)
			player:SetModelId(team1Model)
			player:SetNetworkValue("wp",genericBlueSpawns[randomIndex])
		else
			table.insert(blueTeam,player)
			local randomIndex = math.random(1, #genericBlueSpawns)
			spawnPosition = genericBlueSpawns[randomIndex]
			player:SendChatMessage("[TDM] You are on the " ..team2Name.." team.", colorBlue)
			player:SetModelId(team2Model)
			player:SetNetworkValue("wp",genericRedSpawns[randomIndex])
		end
		counter = counter + 1
		player:SetPosition(spawnPosition)
		-- Give them a machine gun in the primary slot (2).
		player:ClearInventory()
		local weapon = Weapon(28)
		player:GiveWeapon(2, weapon)
		-- Reset their health to 100%, just in case.
		player:SetHealth(1)
	end
	DefaultWorld:SetTime(mapTime)
	timer:Restart()
end
 
function PlayerSpawn(args)
	args.player:SetModelId(defaultModel)
	-- Remove all of their weapons.
	args.player:ClearInventory()
	-- Teleport them to the top of the dome.
	args.player:SetPosition(pregameSpawns)
	-- Send them a chat message.
	local message = ""
	if gameMode == "wait" then
		message = "[TDM] A game will be starting soon. "
	elseif gameMode == "fight" then
		message = "[TDM] Please relax until the next game :) "
	elseif gameMode == "vote" then
		message = "[TDM] Voting underway. "..math.floor(VOTE_TIME-timer:GetSeconds()).." seconds remain."
	end
	args.player:SendChatMessage(message, textColor)
	-- Return false to override the default spawn position set in config.lua.
	
	return false
end

function isInTeam(myplayer)
	local found = false
	for index, player in ipairs(redTeam) do
		if player == myplayer then
			found = true
			break
		end
	end
	if found == false then
		for index, player in ipairs(blueTeam) do
			if player == myplayer then
				found = true
				break
			end
		end
	end
	return found
end

function PlayerDeathOrQuit(args)
	local found = false
	local isover = false
	
	-- If they're in the players table, remove them.
	for index, player in ipairs(redTeam) do
		if player == args.player then
			found = true
			table.remove(redTeam, index)
			break
		end
	end
	if found == false then
		for index, player in ipairs(blueTeam) do
			if player == args.player then
				found = true
				table.remove(blueTeam, index)
				break
			end
		end
	end
	if found == false then
		--The player who died is not currently in the game, so ignore it.
		return
	end
	
	
	if (args.player:GetValue("isingame") == true) then
		--Update killer's score
		print(args.killer)
		if args.killer then
			Chat:Broadcast("[Radio] "..args.killer:GetName().." has killed "..args.player:GetName().." [["..team1Name..": "..#redTeam.."/"..
			team2Name..": "..#blueTeam.."]]", colorRadio)
			args.killer:SetMoney(args.killer:GetMoney()+(10+math.sqrt(math.pow((100-Server:GetPlayerCount()),2)))) --Scale money given inversely with available players
		else
			Chat:Broadcast("[Radio] "..args.player:GetName().." has been eliminated. [["..team1Name..": "..#redTeam.."/"..team2Name..": "..#blueTeam.."]]", colorRadio)
		end
	
	
		-- If there is only one player left, declare them the winner.
		if #redTeam == 0 then
			local message = "[TDM] "..team2Name.." Team wins!"
			Chat:Broadcast(message , colorBlue)
			isover = true
		elseif #blueTeam == 0 then
			local message = "[TDM] "..team1Name.." Team wins!"
			Chat:Broadcast(message , colorRed)
			isover = true
		end
		
		if isover == true then
			--redTeam = {}
			--blueTeam = {}
			isover = true
			KickAllPlayersBack(false)
		end
	end
end
Events:Subscribe("PlayerChat", PlayerChat)
Events:Subscribe("ModuleLoad", FirstLoad)
Events:Subscribe("PlayerSpawn", PlayerSpawn)
Events:Subscribe("PlayerDeath", PlayerDeathOrQuit)
Events:Subscribe("PlayerQuit", PlayerDeathOrQuit)
Events:Subscribe("PostTick",TDMPostTick)
Events:Subscribe("PlayerJoin",OnPlayerJoin)
