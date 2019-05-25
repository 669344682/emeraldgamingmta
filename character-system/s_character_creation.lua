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

mysql = exports.mysql
blackhawk = exports.blackhawk

spawnLocations = {
--  ID         x            y         z      rot
	[1] = {2857.33789, 1288.48633, 11.39062, 83}, -- LV Train Station
	[2] = {2854.16699, 2222.20703, 10.82031, 90}, -- Bus Stop in LV
	[3] = {1683.41504, 1447.81543, 10.77143, 270}, -- LV Airport
	[4] = {2294.51953, 619.31055, 10.82031, 12}, -- LV Docks
}

function character_creationSpawnPlayer(thePlayer, skinID)
	local dimID = 50000 + getElementData(thePlayer, "player:id")
	spawnPlayer(thePlayer, 1720.80078, -2236.12695, 39.78027, 90, skinID, 20, dimID)
end
addEvent("character:creationSpawnPlayer", true)
addEventHandler("character:creationSpawnPlayer", getRootElement(), character_creationSpawnPlayer)

function character_isNameAvailable(theName)
	if not (theName) or not tostring(theName) then return false end

	local exists = mysql:QueryString("SELECT `id` FROM `characters` WHERE `name` = (?);", theName)
	if (exists) or (exists ~= nil) then
		triggerClientEvent("character:character_clientUpdateNameValidation", getRootElement(), false)
	else
		triggerClientEvent("character:character_clientUpdateNameValidation", getRootElement(), true)
	end
end
addEvent("character:isNameAvailableCheck", true)
addEventHandler("character:isNameAvailableCheck", getRootElement(), character_isNameAvailable)

function character_createPlayerCharacter(thePlayer, characterData)
	------------------ Grab all data from client ------------------
	local charName = tostring(characterData["fullName"])
	local dob = tostring(characterData["parsedDOB"])
	local height = tonumber(characterData["height"])
	local weight = tonumber(characterData["weight"])
	local gender = tostring(characterData["gender"]) or 1
	local language = tostring(characterData["language"]) or 1
	local ethnicity = tostring(characterData["ethnicity"]) or 1
	local skin = tonumber(characterData["selectedSkin"]) or 240
	local skills = tostring(characterData["skills"])
	local origin = tostring(characterData["origin"])
	local spawnArea = tonumber(characterData["spawnArea"]); if (tonumber(spawnArea) == -1) then spawnArea = 1 end
	---------------------------------------------------------------

	-- Turn gender to numerical value.
	if (gender == "Male") then
		gender = 1
	elseif (gender == "Female") then
		gender = 2
	else
		gender = 1
		outputDebugString("[character-system] @character_createPlayerCharacter: Defaulting gender to 1 as received gender doesn't exist or is nil.")
	end
	
	-- Turn ethnicity to numerical value.
	if (ethnicity == "Caucasian") then
		ethnicity = 1
	elseif (ethnicity == "Black") then
		ethnicity = 2
	elseif (ethnicity == "Hispanic") then
		ethnicity = 3
	elseif (ethnicity == "Asian") then
		ethnicity = 4
	else
		ethnicity = 1
		outputDebugString("[character-system] @character_createPlayerCharacter: Defaulting ethnicity to 1 as received ethnicity doesn't exist or is nil.")
	end

	-- Turn language to numerical value.
	if (language == "English") then
		language = 1
	elseif (language == "Irish") then
		language = 2
	elseif (language == "Spanish") then
		language = 3
	elseif (language == "German") then
		language = 4
	elseif (language == "French") then
		language = 5
	else
		language = 1
		outputDebugString("[character-system] @character_createPlayerCharacter: Defaulting language to 1 as received language doesn't exist or is nil.")
	end

	-- Parse location and spawn point.
	local x, y, z = spawnLocations[spawnArea][1], spawnLocations[spawnArea][2], spawnLocations[spawnArea][3]
	local rotation = spawnLocations[spawnArea][4]
	local sqlLocation = x .. "," .. y .. "," .. z .. ",0,0," .. rotation -- x, y, z, rx, ry, rz
	local defaultDescription = '[ { "physicalbuild": "", "facialfeatures": "", "accessories": "", "clothing": "", "walkstyle": "", "haircolstyle": "", "makeup": "" } ]'
	local defaultMood = 1 -- Neutral.
	local accountID = getElementData(thePlayer, "account:id")
	local walkstyle = getPedWalkingStyle(thePlayer) or 128
	local timeNow = exports.global:getCurrentTime()
	local currentTime = tostring(timeNow[3])
	
	-- Big query to save it all.
	mysql:Execute(
		"INSERT INTO `characters` (`id`, `account`, `name`, `dob`, `location`, `dimension`, `interior`, `height`, `weight`, `gender`, `language`, `language2`, `language3`, `ethnicity`, `skin`, `skills`, `origin`, `hours`, `last_used`, `location_area`, `status`, `walkstyle`, `created`, `health`, `armor`, `money`, `bankmoney`, `duty`, `cuffed`, `blindfolded`, `fightstyle`, `arrested`, `arrestedtime`, `description`, `mood`, `licenses`, `marriedto`, `deathinfo`, `active`, `job`, `maxvehicles`, `maxinteriors`) VALUES (NULL,(?),(?),(?),(?),(?),(?),(?),(?),(?),(?),(?),(?),(?),(?),(?),(?),(?),(?),(?),(?),(?),(?),(?),(?),(?),(?),(?),(?),(?),(?),(?),(?),(?),(?),(?),(?),(?),(?),(?),(?),(?));",
		accountID, charName, dob, sqlLocation, 0, 0, height, weight, gender, language, 0, 0, ethnicity, skin, skills, origin, 0, currentTime, "San Andreas International Airport", 0, walkstyle, currentTime, 100, 0, 0, 0, 0, 0, 0, 4, 0, 0, defaultDescription, defaultMood, 0, 0, "N/A", 1, 0, 8, 8
	)

	local characterID = mysql:QueryString("SELECT `id` FROM `characters` WHERE `name` = (?);", charName)
	character_spawnCharacter(thePlayer, characterID)
end
addEvent( "character:creationAttempt", true)
addEventHandler("character:creationAttempt", getRootElement(), character_createPlayerCharacter)