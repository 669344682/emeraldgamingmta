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

Copyright of the Emerald Gaming Development Team, do not distribute - All rights reserved. ]]

addEvent("onCharacterSelected", true)
addEvent("onPlayerCharacterSelection", true)

mysql = exports.mysql
blackhawk = exports.blackhawk

-- Function that logs out the specified player.
function character_logoutPlayerServer(thePlayer, passMode)
	if (passMode) then
		removeElementData(thePlayer, "character:id", true)
	end

	setElementData(thePlayer, "loggedin", 0, true)
	setTimer(function()
		redirectPlayer(thePlayer, "", 22003) -- Redirect player to the server again.
	end, 5000, 1)
end
addEvent("character:logoutPlayerServer", true)
addEventHandler("character:logoutPlayerServer", root, character_logoutPlayerServer)

-- Function which shows the specified player the character selection menu.
function character_showCharacterSelection(thePlayer, skipCam)
	if not skipCam then skipCam = false end

	local accountID = getElementData(thePlayer, "account:id")

	setPlayerNametagColor(thePlayer, 120, 120, 120)
	local characterTable = mysql:Query("SELECT * FROM `characters` WHERE `account` = (?);", accountID)
	if (characterTable) then
		triggerClientEvent(thePlayer, "character:clientShowCharacterSelection", thePlayer, characterTable, skipCam)
		
		-- Call events for when player enters character selection.
		triggerEvent("onPlayerCharacterSelection", thePlayer, accountID)
		triggerClientEvent(thePlayer, "onPlayerCharacterSelection", thePlayer, accountID)
	else
		exports.global:outputDebug("@character_showCharacterSelection: Error fetching characterTable for Account " .. accountID .. ".")
	end
end
addEvent("character:showCharacterSelection", true)
addEventHandler("character:showCharacterSelection", root, character_showCharacterSelection)

-- Function that spawns the character to their specified character ID.
function character_spawnCharacter(thePlayer, characterID)
	if not (thePlayer) or not (characterID) then return false end

	-- Grab all content for elementData.
	local characterData = mysql:QuerySingle("SELECT * FROM `characters` WHERE `id` = (?);", characterID)
	
	local accountID = getElementData(thePlayer, "account:id")

	local thePlayerName = tostring(characterData.name)
	local age = exports.global:dobToAge(string.gsub(characterData.dob, "/", ","))
	local language = tonumber(characterData.language)
	local language2 = tonumber(characterData.language2)
	local language3 = tonumber(characterData.language3)
	local skin = tonumber(characterData.skin)
	local walkstyle = tonumber(characterData.walkstyle)
	local duty = tonumber(characterData.duty)
	local cuffed = tonumber(characterData.cuffed)
	local blindfolded = tonumber(characterData.blindfolded)
	local fightstyle = tonumber(characterData.fightstyle)
	--local arrested = tonumber(characterData.arrested) -- Enable when there is something to do with this. @requires pd-system
	local description = fromJSON(characterData.description)
	local mood = tonumber(characterData.mood)
	local licenses = tostring(characterData.licenses)
	local marriedto = tonumber(characterData.marriedto)
	local job = tonumber(characterData.job)
	local maxvehicles = tonumber(characterData.maxvehicles)
	local maxinteriors = tonumber(characterData.maxinteriors)


	-- Gather location data.
	local parsedLocation = tostring(characterData.location)
	local locationTable = split(parsedLocation, ",")
	local x, y, z, rx, ry, rz = locationTable[1], locationTable[2], locationTable[3], locationTable[4], locationTable[5], locationTable[6]
	local dimension = characterData.dimension
	local interior = characterData.interior

	--------------- PRIMARY CHARACTER DATA SET ----------------
	blackhawk:setElementDataEx(thePlayer, "character:id", characterID, true)
	blackhawk:setElementDataEx(thePlayer, "character:account", accountID, true)
	blackhawk:setElementDataEx(thePlayer, "character:name", thePlayerName, true)
	blackhawk:setElementDataEx(thePlayer, "character:dob", tostring(characterData.dob), true)
	blackhawk:setElementDataEx(thePlayer, "character:age", age, true)
	blackhawk:setElementDataEx(thePlayer, "character:height", tonumber(characterData.height), true)
	blackhawk:setElementDataEx(thePlayer, "character:weight", tonumber(characterData.weight), true)
	blackhawk:setElementDataEx(thePlayer, "character:gender", tonumber(characterData.gender), true)
	blackhawk:setElementDataEx(thePlayer, "character:language", language, true)
	blackhawk:setElementDataEx(thePlayer, "character:language2", language2, true)
	blackhawk:setElementDataEx(thePlayer, "character:language3", language3, true)
	blackhawk:setElementDataEx(thePlayer, "character:ethnicity", tonumber(characterData.ethnicity), true)
	blackhawk:setElementDataEx(thePlayer, "character:skin", skin, true)
	blackhawk:setElementDataEx(thePlayer, "character:skills", tostring(characterData.skills), true)
	blackhawk:setElementDataEx(thePlayer, "character:hours", tonumber(characterData.hours), true)
	blackhawk:setElementDataEx(thePlayer, "character:walkstyle", walkstyle, true)
	blackhawk:setElementDataEx(thePlayer, "character:money", tonumber(characterData.money), true)
	blackhawk:setElementDataEx(thePlayer, "character:bankmoney", tonumber(characterData.bankmoney), true)
	blackhawk:setElementDataEx(thePlayer, "character:duty", duty, true)
	blackhawk:setElementDataEx(thePlayer, "character:cuffed", cuffed, true)
	blackhawk:setElementDataEx(thePlayer, "character:blindfolded", blindfolded, true)
	blackhawk:setElementDataEx(thePlayer, "character:fightstyle", fightstyle, true)
	blackhawk:setElementDataEx(thePlayer, "character:licenses", licenses, true)
	blackhawk:setElementDataEx(thePlayer, "character:description", description, true)
	blackhawk:setElementDataEx(thePlayer, "character:mood", mood, true)
	blackhawk:setElementDataEx(thePlayer, "character:marriedto", marriedto, true)
	blackhawk:setElementDataEx(thePlayer, "character:job", job, true)
	blackhawk:setElementDataEx(thePlayer, "character:dimension", dimension, false)
	blackhawk:setElementDataEx(thePlayer, "character:interior", interior, false)
	blackhawk:setElementDataEx(thePlayer, "character:realininterior", dimension, true)
	blackhawk:setElementDataEx(thePlayer, "character:invehicle", false, true)
	blackhawk:setElementDataEx(thePlayer, "character:seatbelt", false, true)

	local autoStaffDuty = getElementData(thePlayer, "settings:account:setting4")
	blackhawk:setElementDataEx(thePlayer, "duty:staff", autoStaffDuty, true)
	
	setElementData(thePlayer, "loggedin", 1, true) -- Set player as logged in.
	triggerEvent("updateNametagColor", thePlayer)

	setPlayerName(thePlayer, thePlayerName)
	spawnPlayer(thePlayer, x, y, z, rz, skin, interior, dimension)

	setElementFrozen(thePlayer, true)
	triggerClientEvent("character:cancelLoginDamage", thePlayer, true) -- Prevent the player from taking damage.

	setCameraTarget(thePlayer, thePlayer)
	setElementPosition(thePlayer, x, y, z)
	setElementRotation(thePlayer, rx, ry, rz)
	setElementInterior(thePlayer, interior)
	setElementDimension(thePlayer, dimension)
	setElementModel(thePlayer, skin)
	setPedWalkingStyle(thePlayer, walkstyle)
	setElementHealth(thePlayer, tonumber(characterData.health))
	setPedArmor(thePlayer, tonumber(characterData.armor))
	setPedFightingStyle(thePlayer, fightstyle)

	-- Faction data.
	local civilianFaction = getTeamFromName("Civilian")
	setPlayerTeam(thePlayer, civilianFaction)
	local playerFactions = exports.global:getPlayerFactions(characterID)
	blackhawk:setElementDataEx(thePlayer, "character:factions", playerFactions, true)
	blackhawk:setElementDataEx(thePlayer, "character:activefaction", 0, true)
	blackhawk:setElementDataEx(thePlayer, "character:factionduty", false, true)

	setElementAlpha(thePlayer, 50) -- Set the player's alpha slightly until they are fully loaded.

	-- Trigger events for scripts to execute onCharacterSelected.
	triggerEvent("onCharacterSelected", thePlayer, characterID, thePlayerName, accountID)
	triggerClientEvent(thePlayer, "onCharacterSelected", thePlayer, characterID, thePlayerName, accountID)

	setElementData(thePlayer, "hud:enabledstatus", 0, true) -- Enable the HUD.
	exports.global:setPlayerTitles(thePlayer) -- Sets all of the players staff titles.
	local lines = 40
	for i = 1, lines do -- Loop and send nothing in their chatbox 40 times to clear it up.
		outputChatBox(" ", thePlayer)
	end
	outputChatBox("Welcome to Emerald Gaming Roleplay, " .. thePlayerName:gsub("_", " ") .. "!", thePlayer, 75, 230, 10)

	-- Timer to just allow everything to go through.
	setTimer(function()
		fadeCamera(thePlayer, true)
		showChat(thePlayer, true)
		setElementAlpha(thePlayer, 150)
	end, 1800, 1)

	setTimer(function()
		setElementFrozen(thePlayer, false)
		setElementAlpha(thePlayer, 200)
	end, 2500, 1)

	setTimer(function()
		triggerClientEvent("character:cancelLoginDamage", thePlayer, false)
		setElementAlpha(thePlayer, 255)
	end, 4000, 1)

	-- Log the character selection.
	local thePlayerUsername = getElementData(thePlayer, "account:username")
	exports.logs:addLog(thePlayer, 9, thePlayer, "[CHARACTER SELECTED] " .. thePlayerUsername .. " selected character '" .. thePlayerName .. "'.")
end
addEvent("character:spawnCharacter", true)
addEventHandler("character:spawnCharacter", root, character_spawnCharacter)