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

-- Takes the given character ID and returns the associated account ID and username.
function getCharacterAccount(characterID)
	if not tonumber(characterID) then outputDebug("@getCharacterAccount: characterID not provided or is not a numerical value.") return false end

	local accountID = exports.mysql:QueryString("SELECT `account` FROM `characters` WHERE `id` = (?);", characterID)
	if not (accountID) then outputDebug("@getCharacterAccount: Attempted to get accountID of character that does not exist.") return false end -- May also be result of no DB connection.

	local accountInfo = exports.mysql:QuerySingle("SELECT `id`, `username` FROM `accounts` WHERE `id` = (?);", tonumber(accountID))
	if (accountInfo) then
		return accountInfo.id, accountInfo.username or "Unknown"
	else
		outputDebug("@getCharacterAccount: Attempted to get account that does not exist, is there a database connection?")
	end
	return false
end

-- Takes the given character ID and returns it's name.
function getCharacterNameFromID(characterID, noGsub)
	if not tonumber(characterID) then outputDebug("@getCharacterNameFromID: characterID not provided or is not a numerical value.") return false end

	local characterName = exports.mysql:QueryString("SELECT `name` FROM `characters` WHERE `id` = (?);", tonumber(characterID))
	if (characterName) then
		if noGsub then return characterName
			else return characterName:gsub("_", " ")
		end
	else
		outputDebug("@getCharacterNameFromID: Attempted to character name that does not exist, is there a database connection?")
	end
	return false
end

-- Takes the given character name and returns the character ID.
function getCharacterIDFromName(characterName)
	if not tostring(characterName) then outputDebug("@getCharacterIDFromName: characterName not provided or is not a string,") return false end
	characterName = characterName:gsub(" ", "_")

	local characterID = exports.mysql:QueryString("SELECT `id` FROM `characters` WHERE `name` = (?);", tostring(characterName))
	if tonumber(characterID) then
		return characterID
	end
	outputDebug("@getCharacterIDFromName: Attempted to fetch ID of character '" .. tostring(characterName) .. "' though doesn't exist in database.")
	return false
end

-- Takes the given character ID or name and returns the player element with that name if they are online, false otherwise.
function getPlayerFromCharacter(charIDorName)
	if not tostring(charIDorName) then outputDebug("@getPlayerFromCharacter: charIDorName not provided or is not a string.") return false end

	if tonumber(charIDorName) then
		charIDorName = getCharacterNameFromID(charIDorName, true)
	end
	return getPlayerFromName(charIDorName)
end