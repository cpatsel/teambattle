function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

function string.splitspace(String)
	local line = {}
			for k,v in string.gmatch(String, "%S+") do
				table.insert(line,k)
			end
	return line
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
		if isAuthenticated(args.player) then
			print(args.player:GetPosition())
			return false
		else
			args.player:SendChatMessage("Can't do that",colorRed)
		end
	end
	if args.text == "/sg" then
		if (isAuthenticated(args.player)) then
			args.player:SetNetworkValue("isingame",not args.player:GetValue("isingame"))
			args.player:SendChatMessage("Toggled game status",colorRadio)
		end
	end
	if args.text == "/die" then
		args.player:SetHealth(0)
		return false
	end
	if args.text == "/id" then
		print(args.player:GetSteamId().string)
		args.player:SendChatMessage("Your steam ID is "..args.player:GetSteamId().string,colorRadio)
	end
	if args.text == "/clear" or args.text == "/cls" then
			for i=0, 13 do
				args.player:SendChatMessage("",colorBlue);
			end
		return false
	end
	--if args.text == "/ready" then
	--	args.player:SetNetworkValue("isready", not args.player:GetValue("isready"))
	--	if (args.player:GetValue("isready")) then args.player:SendChatMessage("You are now ready.",colorGreen)
	--	else args.player:SendChatMessage("You are no longer ready.",colorRed)
	--	end
	--	return false
	--end
	if args.text == "/force" then
		if (isAuthenticated(args.player)) then
			VoteForMap()
		end
		return false
	end
	if args.text == "/dosh" then
		if (isAuthenticated(args.player)) then
			args.player:SetMoney(100000)
		end
		return false
	end
	if args.text == "/jp" then
		args.player:SetPosition(snowtownBlueSpawns[1])
		return false;
	end
	if args.text == SECRET_PHRASE then
		if NEEDS_AUTH_SECRET == true then
			if (isAuthenticated(args.player)) then
				args.player:SetModelId(SECRET_MODELID)
			end
		else
			args.player:SetModelId(SECRET_MODELID)
		end
		return false
	end
	
	if string.starts(args.text,"/") then
		return false
	end
	return true
end