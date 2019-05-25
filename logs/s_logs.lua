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

================================================================================================================
| ID | Type (Events)                 | ID |        Type (Commands)        | ID |        Type (Commands)        |
| -- |:-----------------------------:| -- |:-----------------------------:| -- |:-----------------------------:|
| 1  | Admin Command                 | 21 | /c & /w                       | 41 | /district                     |
| 2  | Vehicle Related               | 22 | /say                          | 42 | /status                       |
| 3  | Interior Related              | 23 | /b                            | 43 | Anticheat                     |
| 4  | Ped Related                   | 24 | /me                           | 44 | Asset Transfers               |
| 5  | Faction Related               | 25 | /do                           | 45 | Teleporter Usage              |
| 6  | Item Movement                 | 26 | /ame                          | 46 | /fl                           |
| 7  | Cash Transfers                | 27 | /ado                          | 47 | Empty                         |
| 8  | Emeralds                      | 28 | /pm                           | 48 | Empty                         |
| 9  | Connections                   | 29 | /s                            | 49 | Empty                         |
| 10 | Phone Logs                    | 30 | /h                            | 50 | Empty                         |
| 11 | SMS Logs                      | 31 | /st                           | 51 | Empty                         |
| 12 | Vehicle/Int Actions           | 32 | /mt                           | 52 | Empty                         |
| 13 | Stat Transfers                | 33 | /vt                           | 53 | Empty                         |
| 14 | Kill/Death Logs & Lost Items  | 34 | /ft                           | 54 | Empty                         |
| 15 | Reports                       | 35 | /d                            | 55 | Empty                         |
| 16 | Punishments/Warns             | 36 | /a                            | 56 | Empty                         |
| 17 | Errors                        | 37 | /l                            | 57 | Empty                         |
| 18 | VT Related                    | 38 | /r                            | 58 | Empty                         |
| 19 | MT Related                    | 39 | /f                            | 59 | Empty                         |
| 20 | FT Related                    | 40 | /m                            | 60 | Empty                         |
================================================================================================================]]

-- Primary exported function to insert logs into database.
function addLog(sourceElement, logType, affectedElements, log)
	if not (sourceElement) then
		exports.global:outputDebug("@addLog: sourceElement does not exist or is invalid.")
		return false
	end

	local theSource = logGetSourceType(sourceElement) or logGetElementType(sourceElement) -- String containing the source type and ID.

	-- Check to see if a sourceElement was determined.
	if not (theSource) then
		exports.global:outputDebug("@addLog: Could not determine sourceElement.")
		return false
	end
	-- Check to see if logType was provided and is a numerical value.
	if (logType == nil) then
		exports.global:outputDebug("@addLog: logType not provided.")
		return false
	end
	if not tonumber(logType) then
		exports.global:outputDebug("@addLog: logType specified is not a numerical value.")
		return false
	end

	-- Check to see if affectedElements are valid.
	local affectedString = logGetElementType(affectedElements)
	if not (affectedString) then
		exports.global:outputDebug("@addLog: affectedElements not provided.")
		return false
	end

	-- Check to see if log content was provided.
	if not (log) then
		exports.global:outputDebug("@addLog: log not provided.")
		return false
	end

	-- Get the time now in SQL format.
	local timeNow = exports.global:getCurrentTime()
	if not (timeNow) then
		exports.global:outputDebug("@addLog: Failed to get currentTime from global, is the resource running?")
		return false
	end

	-- Send it all off in our query and see if we get a result.
	local query = exports.mysql:Execute("INSERT INTO `logs` (`id`, `time`, `source_element`, `type`, `affected_elements`, `log`) VALUES (NULL, (?), (?), (?), (?), (?));", timeNow[3], theSource, logType, affectedString, log)
	if (query) then -- If the query executed successfully.
		outputLogsDebug(1, timeNow, theSource, logType, affectedString, log)
	else
		exports.global:outputDebug("@addLog: Query to insert log failed, check the query parameters given.")
		return false
	end
end

-- Takes the given element(s) and gets their respective sourceType, returns all values in a concatenated string with ',' as the separator.
function logGetElementType(theElement)
	local elementType = type(theElement)
	if elementType == "string" then
		return theElement
	elseif elementType == "userdata" then -- If it is an element.
		local sourceType = logGetSourceType(theElement)
		if (sourceType) then
			return sourceType
		else
			exports.global:outputDebug("@logGetElementType: theElement received is userdata (element) though an undefined type.")
			return false
		end
	elseif elementType == "table" then
		local returnString = ""
		for i, element in ipairs(theElement) do
			local sourceTypeResult = logGetSourceType(element)
			if (sourceTypeResult) then
				if (sourceTypeResult ~= "") then
					returnString = returnString .. sourceTypeResult .. ","
				else
					returnString = element
				end
			end
		end

		if (returnString ~= "") then
			returnString = returnString:sub(1, -2) -- Remove the extra ',' at the end of the string.
			return returnString
		else
			exports.global:outputDebug("@logGetElementType: returnString is empty, element sourceType could not be determined.")
		end
	end
	return false
end

-- Takes the given sourceElement and returns the parsed db source string with the element's ID and type in the format of 'TYPEID', Example: VEH561 is Vehicle ID 561.
function logGetSourceType(sourceElement)
	if not isElement(sourceElement) then
		return false
	end

	local elementType = getElementType(sourceElement)

	if (elementType == "player") then -- If source element is a player.
		local characterID = getElementData(sourceElement, "character:id")
		if (characterID) then
			return "CHAR" .. tostring(characterID)
		else
			local accountID = getElementData(sourceElement, "account:id")
			if (accountID) then
				return "ACC" .. tostring(accountID)
			else
				exports.global:outputDebug("logGetSourceType: Player sourceElement does not have a character:id or account:id.")
				return false
			end
		end
	elseif (elementType == "vehicle") then -- If the source element is a vehicle.
		local vehicleID = getElementData(sourceElement, "vehicle:id")
		if (vehicleID) then
			return "VEH" .. tostring(vehicleID)
		else
			exports.global:outputDebug("@logGetSourceType: Vehicle sourceElement does not have a vehicle:id.")
			return false
		end
	elseif (elementType == "interior") then -- If the source element is an interior.
		local interiorID = getElementData(sourceElement, "interior:id")
		if (interiorID) then
			return "INT" .. tostring(interiorID)
		else
			exports.global:outputDebug("@logGetSourceType: Interior sourceElement does not have an interior:id.")
			return false
		end
	elseif (elementType == "ped") then -- If the source element is a ped.
		local npcID = getElementData(sourceElement, "ped:id")
		if (npcID) then
			return "PED" .. tostring(npcID)
		else
			exports.global:outputDebug("@logGetSourceType: Ped sourceElement does not have an ped:id.")
			return false
		end
	elseif (elementType == "object") then -- If the source element is an object.
		local objectID = getElementData(sourceElement, "object:id")
		if (objectID) then
			return "OBJ" .. tostring(objectID)
		else
			exports.global:outputDebug("@logGetSourceType: Object sourceElement does not have an object:id.")
			return false
		end
	elseif (elementType == "team") then -- If the source element is a faction.
		local factionID = getElementData(sourceElement, "faction:id")
		if (factionID) then
			return "FAC" .. tostring(factionID)
		else
			exports.global:outputDebug("@logGetSourceType: Faction sourceElement does not have a faction:id.")
			return false
		end
	else
		exports.global:outputDebug("@logGetSourceType: Log element type not defined, received element: " .. getElementType(elementType))
	end
	return false
end

-- Exported function to get all logs of the given element.
function getLogs(theElement)
	if not isElement(theElement) then
		exports.global:outputDebug("@getLogs: theElement received is not an element.")
		return false
	end

	local elementType = logGetSourceType(theElement)

	if (elementType) then
		elementType = tostring(elementType)
		
		local allLogs = exports.mysql:Query("SELECT * FROM `logs` WHERE `source_element` = (?);", elementType)
		
		if (allLogs) then
			outputLogsDebug(2, allLogs, elementType)
			return allLogs
		else
			exports.global:outputDebug("@getLogs: Query failed to fetch allLogs for element '" .. elementType .. "'.")
			return false
		end
	end
end

-- Function to output log debug for developers with log debug view enabled.
function outputLogsDebug(addOrGet, time, source, logType, affected, log)
	local allPlayers = getElementsByType("player")
	for i, player in ipairs(allPlayers) do
		local debugState = getElementData(player, "var:debuglogs")
		if (tonumber(debugState) == 1) then
			if (addOrGet == 1) then -- addOrGet type 1 means it was a log added.
				outputChatBox("[LOGS] (addLog:1) Time: " .. time[3] .. " | Source: " .. source .. " | logType: " .. logType .. " | affectedElements: " .. affected, player, 204, 102, 255)
				outputChatBox("[LOGS] (addLog:2) Log: " .. log, player, 204, 102, 255)
			else -- Must have been a logs retrieved.
				for i, theLog in ipairs(time) do -- Time in this case is a table of all the logs retrieved.
					outputChatBox("[LOGS] (getLogs:" .. i .. ") Source: " .. source .. " | Time: " .. theLog.time .. " | Type: " .. theLog.type .. " | affectedElements: " .. theLog.affected_elements, player, 204, 102, 255)
					outputChatBox("[LOGS] (getLogs:" .. i .. ") Log: " .. theLog.log, thePlayer, 204, 102, 255)
				end
			end
		end
	end
end