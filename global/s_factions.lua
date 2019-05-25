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
|    /| | | | |    |  __||  __/| |    |  _  |\ /          Created by
| |\ \\ \_/ / |____| |___| |   | |____| | | || |            Skully
\_| \_|\___/\_____/\____/\_|   \_____/\_| |_/\_/

Copyright of the Emerald Gaming Development Team, do not distribute - All rights reserved.

FOR MORE IN-DEPTH EXPLANATION AND INFORMATION REGARDING GLOBAL EXPORTS, CHECK THE WIKI. ]]

-- Takes the given factionID and returns the faction element.
function getFactionFromID(factionID, thePlayer)
	if not (factionID) then outputDebug("@getFactionFromID: factionID not provided.") return false end
	if not (thePlayer) then outputDebug("@getFactionFromID: thePlayer not provided.", 2) return false end
	if (tostring(factionID) == "*") and (thePlayer) then -- If asterix provided, check if we can return the source player's active faction.
		factionID = getElementData(thePlayer, "character:activefaction") or 0; factionID = tonumber(factionID)
		if (factionID ~= 0) then
			local theFaction = exports.data:getElement("team", factionID)
			local theFactionName = getElementData(theFaction, "faction:name") or "Unknown"
			return theFaction, factionID, theFactionName
		else
			outputChatBox("ERROR: A faction with that ID doesn't exist!", thePlayer, 255, 0, 0)
			return false
		end
	end

	-- If we received a string, check if it is an abbreviation.
	if not tonumber(factionID) then
		if tostring(factionID) and (#factionID < 6) then
			factionID = exports.mysql:QueryString("SELECT `id` FROM `factions` WHERE `abbreviation` = (?);", tostring(factionID))
			if not tonumber(factionID) then
				outputChatBox("ERROR: A faction with that ID doesn't exist!", thePlayer, 255, 0, 0)
				return false
			end
		else
			outputChatBox("ERROR: A faction with that ID doesn't exist!", thePlayer, 255, 0, 0)
			return false
		end
	end

	factionID = tonumber(factionID)

	-- Check if faction element exists.
	local theFaction = exports.data:getElement("team", factionID)
	if (theFaction) then
		factionID = getElementData(theFaction, "faction:id")
		local theFactionName = getElementData(theFaction, "faction:name")
		return theFaction, factionID, theFactionName
	end

	-- If we've made it this far, faction doesn't exist.
	outputChatBox("ERROR: A faction with the ID #" .. factionID .. " does not exist!", thePlayer, 255, 0, 0)
	return false
end

-- Takes the given characterID or player and returns the respective character's factions in a table.
function getPlayerFactions(characterID)
	local factionTable = {0, 0, 0}
	if not tonumber(characterID) then
		characterID = getElementData(characterID, "character:id")
		if not tonumber(characterID) then
			exports.global:outputDebug("@getPlayerFactions: characterID not provided or is not a number value or an element.")
			return factionTable
		end
	end

	local charFactions = exports.mysql:Query("SELECT `factionid` FROM `faction_members` WHERE `characterid` = (?) ORDER BY `factionid`;", tonumber(characterID))
	if charFactions and charFactions[1] then
		for i, data in ipairs(charFactions) do
			factionTable[i] = tonumber(data.factionid)
		end
	end
	return factionTable
end

-- Takes the given characterID or player and checks to see if they are a faction leader of the factionID specified.
function isPlayerFactionLeader(characterID, factionID)
	if not tonumber(characterID) then
		characterID = getElementData(characterID, "character:id")
		if not tonumber(characterID) then
			exports.global:outputDebug("@isPlayerFactionLeader: characterID not provided or is not a number value or an element.")
			return false
		end
	end
	if not tonumber(factionID) then exports.global:outputDebug("@isPlayerFactionLeader: factionID not provided or is not a number value.") return false end

	local factionLeader = exports.mysql:QueryString("SELECT `isleader` FROM `faction_members` WHERE `characterid` = (?) AND `factionid` = (?);", tonumber(characterID), tonumber(factionID))
	if (tonumber(factionLeader) == 1) then
		return true
	end
	return false
end

-- Takes the given rankID and returns the given rank name and wage from the provided factionID.
function getFactionRank(rankID, factionID)
	if not tonumber(rankID) then outputDebug("@getFactionRankName: rankID not provided or is not a number value.") return false end
	if not tonumber(factionID) then outputDebug("@getFactionRankName: factionID not provided or is not a number value.") return false end

	local theFaction = exports.data:getElement("team", factionID)
	if theFaction then
		local rankTable = getElementData(theFaction, "faction:ranks")
		return rankTable[rankID][1], rankTable[rankID][2]
	else
		outputDebug("@getFactionRankName: Attempted to get rank from faction #" .. factionID .. " though faction element doesn't exist.")
		return false
	end
end

-- Checks to see if the given player or character ID is in the provided factionID.
function isPlayerInFaction(thePlayer, factionID)
	if not isElement(thePlayer) then outputDebug("@isPlayerInFaction: thePlayer not provided or is not an element.") return false end
	if not tonumber(factionID) then
		factionID = getElementData(factionID, "faction:id")
		if not tonumber(factionID) then
			outputDebug("@isPlayerInFaction: factionID not provided or is not a number value or faction element.")
			return false
		end
	end

	local playerFactions = getElementData(thePlayer, "character:factions") or {}
	for i, faction in ipairs(playerFactions) do
		if tonumber(faction) == tonumber(factionID) then return true end
	end
	return false
end

-- Takes the given factionID and returns the faction members characterIDs.
function getFactionMembers(factionID)
	if not tonumber(factionID) then outputDebug("@getFactionMembers: factionID not provided or is not a number value.") return false end

	local factionMembers = exports.mysql:Query("SELECT * FROM `faction_members` WHERE `factionid` = (?) ORDER BY `rank` ASC;", tonumber(factionID))
	if factionMembers and factionMembers[1] then
		return factionMembers
	end
	return {}
end

-- Takes the given player element and sets them to the civilian team.
function setPlayerToCivilianTeam(thePlayer)
	if not isElement(thePlayer) then outputDebug("@setPlayerToCivilianTeam: thePlayer not provided or is not an element.") return false end

	local civilianTeam = getTeamFromName("Civilian")
	setPlayerTeam(thePlayer, civilianTeam)
	exports.blackhawk:changeElementDataEx(thePlayer, "character:activefaction", 0)
	return true
end

-- Takes the given factionID and outputs a message to all online faction members.
function sendMessageToFaction(factionID, message, onDuty, r, g, b)
	if not tonumber(factionID) then
		factionID = getElementData(factionID, "faction:id")
		if not tonumber(factionID) then
			outputDebug("@sendMessageToFaction: factionID not provided or is not a number value or faction element.")
			return false
		end
	end
	if not tostring(message) then outputDebug("@sendMessageToFaction: message not provided or is not a string.") return false end
	r = tonumber(r) or 220
	g = tonumber(g) or 0
	b = tonumber(b) or 0

	local theFaction = exports.data:getElement("team", factionID)
	if theFaction then
		local factionMembers = getPlayersInTeam(theFaction)
		local factionAbbreviation = getElementData(theFaction, "faction:abbreviation")
		for i, player in ipairs(factionMembers) do
			if not onDuty or (onDuty and (getElementData(player, "character:factionduty") == factionID)) then
				outputChatBox("(" .. factionAbbreviation .. ") " .. message, player, r, g, b)
			end
		end
		return true
	else
		outputDebug("@sendMessageToFaction: Failed to fetch faction element.")
	end
	return false
end

function hasPlayerFactionVehiclePermission(thePlayer, theVehicle)
	if not isElement(thePlayer) then outputDebug("@hasPlayerFactionVehiclePermission: thePlayer not provided or is not an element.") return false end
	if not isElement(theVehicle) then
		theVehicle = exports.data:getElement("vehicle", theVehicle)
		if not isElement(theVehicle) then
			outputDebug("@hasPlayerFactionVehiclePermission: Expected vehicle element at argument 2, got " .. type(theVehicle) .. ".")
			return false
		end
	end

	local characterID = getElementData(thePlayer, "character:id")
	local vehfactionID = getElementData(theVehicle, "vehicle:owner")
	local playerDutyGroups = exports.mysql:QueryString("SELECT `duty_groups` FROM `faction_members` WHERE `characterid` = (?) AND `factionid` = (?);", characterID, -vehfactionID)
	if playerDutyGroups then
		playerDutyGroups = fromJSON(playerDutyGroups)
		local vehiclePermissions = getElementData(theVehicle, "vehicle:factionperms"); vehiclePermissions = fromJSON(vehiclePermissions)
		local hasPermission = false
		for i, group in pairs(vehiclePermissions) do
			for j, playergroup in pairs(playerDutyGroups) do
				if playergroup == group then
					hasPermission = true
					break
				end
			end
			if hasPermission then break end
		end
		return hasPermission
	else
		outputDebug("hasPlayerFactionVehiclePermission: Failed to fetch duty group data for characterID " .. tostring(characterID) .. " and factionID " .. tostring(vehfactionID) .. ".")
		return false
	end
end