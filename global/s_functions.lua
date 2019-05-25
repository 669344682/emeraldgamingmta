--[[
 _____                         _     _   _____                 _
|  ___|                       | |   | | |  __ \               (_)
| |__ _ __ ___   ___ _ __ __ _| | __| | | |  \/ __ _ _ __ ___  _ _ __   __ _
|  __| '_ ` _ \ / _ \ '__/ _` | |/ _` | | | __ / _` | '_ ` _ \| | '_ \ / _` |
| |__| | | | | |  __/ | | (_| | | (_| | | |_\ \ (_| | | | | | | | | | | (_| |
\____/_| |_| |_|\___|_|  \__,_|_|\__,_|  \____/\__,_|_| |_| |_|_|_| |_|\__, |
																		__/ |
																	   |___/
______ _____ _      ___________ _       _____   __
| ___ \  _  | |    |  ___| ___ \ |     / _ \ \ / /
| |_/ / | | | |    | |__ | |_/ / |    / /_\ \ V /
|    /| | | | |    |  __||  __/| |    |  _  |\ /
| |\ \\ \_/ / |____| |___| |   | |____| | | || |
\_| \_|\___/\_____/\____/\_|   \_____/\_| |_/\_/

Copyright of the Emerald Gaming Development Team, do not distribute - All rights reserved.

FOR MORE IN-DEPTH EXPLANATION AND INFORMATION REGARDING GLOBAL EXPORTS, CHECK THE WIKI. ]]

-- Used to find the player by just a partial amount of their name.
function getPlayerFromPartialNameOrID(targetPlayer, thePlayer, noOutputs)
	if not targetPlayer and not isElement(thePlayer) and type(thePlayer) == "string" then
		targetPlayer = thePlayer
		thePlayer = nil
	end

	local possibleTargets = {}
	local matchPlayer = nil
	local matchNick = nil
	local matchNickAccuracy = -1
	
	if type(targetPlayer) == "string" then
		targetPlayer = string.lower(targetPlayer)
	elseif isElement(targetPlayer) and getElementType(targetPlayer) == "player" then
		if (getElementData(targetPlayer, "loggedin") == 1) then
			return targetPlayer, getPlayerName(targetPlayer):gsub("_", " ") -- Return targetPlayer and their name gsub'd.
		else
			if not (noOutputs) then
				outputChatBox("ERROR: That player is not logged in!", thePlayer, 255, 0, 0)
			end
			return false
		end
	end

	if thePlayer and targetPlayer == "*" then
		if (getElementData(thePlayer, "loggedin") == 1) then
			return thePlayer, getPlayerName(thePlayer):gsub("_", " ") -- Return the source player.
		else
			if not (noOutputs) then
				outputChatBox("ERROR: That player is not logged in!", thePlayer, 255, 0, 0)
			end
			return false
		end
	elseif type(targetPlayer) == "string" and getPlayerFromName(targetPlayer) then
		local tPlayer = getPlayerFromName(targetPlayer)
		if (getElementData(tPlayer, "loggedin") == 1) then
			return tPlayer, getPlayerName(getPlayerFromName(targetPlayer)):gsub("_", " ")
		else
			if not (noOutputs) then
				outputChatBox("ERROR: That player is not logged in!", thePlayer, 255, 0, 0)
			end
			return false
		end
	elseif tonumber(targetPlayer) then -- Get player by ID.
		matchPlayer = exports.data:getElement('player', tonumber(targetPlayer))
		possibleTargets = { matchPlayer }
	else -- Look for player names.
		local allPlayers = exports.data:getDataElementsByType("player")
		for i, arrayPlayer in ipairs(allPlayers) do
			if isElement(arrayPlayer) then
				local found = false
				local playerName = string.lower(getPlayerName(arrayPlayer))
				local posStart, posEnd = string.find(playerName, tostring(targetPlayer), 1, true)
				
				if not posStart and not posEnd then
					posStart, posEnd = string.find(playerName:gsub(" ", "_"), tostring(targetPlayer), 1, true)
				end

				if posStart and posEnd then
					if posEnd - posStart > matchNickAccuracy then
						matchNickAccuracy = posEnd - posStart
						matchNick = playerName
						matchPlayer = arrayPlayer
						possibleTargets = { arrayPlayer }
					elseif posEnd - posStart == matchNickAccuracy then
						matchNick = nil
						matchPlayer = nil
						table.insert(possibleTargets, arrayPlayer)
					end
				end
			end
		end
	end
	
	-- If we don't have a matched player yet.
	if not matchPlayer or not isElement(matchPlayer) then
		if isElement(thePlayer) then
			if #possibleTargets == 0 then
				if not (noOutputs) then
					outputChatBox("ERROR: That player does not exist!", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Found " .. #possibleTargets .. " players who match:", thePlayer, 75, 230, 10)
				for _, arrayPlayer in ipairs(possibleTargets) do
					outputChatBox("  (" .. tostring(getElementData(arrayPlayer, "player:id")) .. ") " .. getPlayerName(arrayPlayer):gsub("_", " "), thePlayer, 75, 230, 10)
				end
			end
		end
		return false
	else -- We have a player who matched.
		if (getElementData(matchPlayer, "loggedin") == 1) then
			return matchPlayer, getPlayerName(matchPlayer):gsub("_", " ") -- Return them and their name.
		else
			if not (noOutputs) then
				outputChatBox("ERROR: That player is not logged in!", thePlayer, 255, 0, 0)
			end
			return false
		end
	end
end

-- Gets table length.
function getTableLength(tab)
	local count = 0
		for _ in pairs(tab) do 
			count = count + 1
		end
	return count
end

--[[ Generates a random roleplay name.
	  Type: "first", "last" or "full"
	  Gender: "male" or "female"	  ]]
function generateRPName(type, gender)
	local genders = {
		"male", "female"
	}

	local males = {
		"John","Will","Jacob","Henry","Oliver","Adam","Christian","Chris","Christopher","Michael","Mike","Joe","Aaron","Zack","Ethan","Noah","Lucas","Lukas","Gabriel","Owen","Jack","Dorian","James","Colin","Luke","Daniel","Evan","Seth","Jason","David","Thomas","Justin","Jasper","Alex","Alexander","William"
	}

	local females = {
		"Rebecca","Eva","Emma","Olivia","Lilly","Sophie","Lauren","Chloe","Hannah","Emily","Claire","Belle","Natalie","Page","Mia","Leah","Gabriella","Zoe","Kylie","Samantha","Alex","Alexis","Catherine","Cathy","Faith","Victoria","Lillian","Brooke","Julia","Alice","Caroline","Allison","Amy","Dolly","Juliet","Ashley","Amber","Kate","Katie","Mary","Evelyn","Pamela","Jaquelin","Elliot"
	}

	local lastnames = {
		"Clark","Carter","Cooper","Ford","Montana","Hut","Wilson","Smith","Johnson","Jones","Williams","Brown","Davis","Miller","Wilson","Moore","Taylor","Anderson","Jackson","Harris","Thompson","Martinez","Rodriguez","Lewis","Lee","Walker","Hall","Allen","Young","Hernandez","Jimenez","Nilson","Adams","Baker","Turner","Reed","Bell","Crown","Howard","Watson","Brooks","Jenkins","Foster","Butler","Diaz","West","Fisher","Hunter","Stevens","Tucker","Daniels","Porter","Rice","Burns","Black","White","Crawford","Robinson"
	}

	if not type then
		type = "full"
	end
	if (type == "full") then
		if not gender then
			gender = genders[math.random(table.getn(genders))]
		end
		local randFirstname
		if(gender == "male") then
			randFirstname = males[math.random(table.getn(males))]
		elseif(gender == "female") then
			randFirstname = females[math.random(table.getn(females))]
		end
		local randLastname = lastnames[math.random(table.getn(lastnames))]
		local name = tostring(randFirstname .." ".. randLastname)
		return name
	elseif(type == "last") then
		local randLastname = lastnames[math.random(table.getn(lastnames))]
		return randLastname
	elseif(type == "first") then
		if not gender then
			gender = genders[math.random(table.getn(genders))]
		end
		local randFirstname
		if(gender == "male") then
			randFirstname = males[math.random(table.getn(males))]
		elseif(gender == "female") then
			randFirstname = females[math.random(table.getn(females))]
		end
		return randFirstname
	elseif(type == "gender") then
		gender = genders[math.random(table.getn(genders))]
		return gender
	end
end

-- Updates the nametag color of the specified player.
function updateNametagColor(thePlayer)
	if source then thePlayer = source end
	if getElementData(thePlayer, "loggedin") ~= 1 then -- Not logged in
		setPlayerNametagColor(thePlayer, 120, 120, 120)
	elseif isPlayerManager(thePlayer) and getElementData(thePlayer, "duty:staff") == 1 and getElementData(thePlayer, "var:hiddenAdmin") ~= 1 then -- Manager+
		setPlayerNametagColor(thePlayer, 255, 0, 0)
	elseif isPlayerTrialAdmin(thePlayer) and getElementData(thePlayer, "duty:staff") == 1 and getElementData(thePlayer, "var:hiddenAdmin") ~= 1 then -- Trial Admin+
		setPlayerNametagColor(thePlayer, 206, 169, 26) 
	elseif isPlayerHelper(thePlayer) and getElementData(thePlayer, "duty:staff") == 1 and getElementData(thePlayer, "var:hiddenAdmin") ~= 1 then -- Helper
		setPlayerNametagColor(thePlayer, 0, 194, 76)
	elseif isPlayerDeveloper(thePlayer) and (getElementData(thePlayer, "duty:developer") == 1) and getElementData(thePlayer, "var:hiddenAdmin") ~= 1 then -- Developer
		setPlayerNametagColor(thePlayer, 95, 30, 102)
	elseif isPlayerVehicleTeam(thePlayer) and (getElementData(thePlayer, "duty:vt") == 1) and getElementData(thePlayer, "var:hiddenAdmin") ~= 1 then -- Vehicle Team
		setPlayerNametagColor(thePlayer, 95, 30, 102)
	elseif isPlayerMappingTeam(thePlayer) and (getElementData(thePlayer, "duty:mt") == 1) and getElementData(thePlayer, "var:hiddenAdmin") ~= 1 then -- Mapping Team
		setPlayerNametagColor(thePlayer, 95, 30, 102)
	else -- Normal players.
		setPlayerNametagColor(thePlayer, 255, 255, 255)
	end
end
addEvent("updateNametagColor", true)
addEventHandler("updateNametagColor", getRootElement(), updateNametagColor)

-- This just updates nametags for all online players every time resource is restarted/started.
function updateOnResStart()
	for key, thePlayer in ipairs(getElementsByType("player")) do
		updateNametagColor(thePlayer)
	end
end
addEventHandler("onResourceStart", getRootElement(), updateOnResStart)

-- Takes the given account name as a string and returns it's SQL ID, or false if it doesn't exist.
function getAccountFromName(accountName)
	if not tostring(accountName) then
		outputDebugString("[global] @getAccountFromName: accountName not provided or is not a string.", 3)
		return false
	end
	
	local accountNames = exports.mysql:Query("SELECT `username` FROM `accounts`")
	local accFound = false

	for i, v in ipairs(accountNames) do
		local targetAccount = accountNames[i].username
		if tostring(targetAccount):lower() == tostring(accountName):lower() then
			accFound = true
			break
		end
	end

	if (accFound) then
		local accID = exports.mysql:QueryString("SELECT `id` FROM `accounts` WHERE `username` = (?);", accountName)
		return tonumber(accID)
	else
		return false
	end
end

-- Takes the given accountID and returns the respective account name.
function getAccountNameFromID(accountID)
	if not tonumber(accountID) then
		outputDebugString("[global] @getAccountNameFromID: Account ID not provided or is not a numerical value.", 3)
		return false
	end

	local accountName = exports.mysql:QueryString("SELECT `username` FROM `accounts` WHERE `id` = (?);", accountID)

	if tostring(accountName) then
		return accountName
	else
		return false
	end
end