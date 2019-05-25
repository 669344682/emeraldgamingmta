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

Copyright of the Emerald Gaming Development Team, do not distribute - All rights reserved. ]]

function addInteriorLog(interiorID, logText, sourcePlayer, isNote)
	if not tonumber(interiorID) then -- If an interior element is provided, try determine it's ID.
		interiorID = getElementData(interiorID, "interior:id")
		if not tonumber(interiorID) then exports.global:outputDebug("@addInteriorLog: interiorID not provided or interior element doesn't have an ID.") return false end
	end
	if not tostring(logText) then exports.global:outputDebug("@addInteriorLog: logText not provided or is not a string.") return false end
	if not (isNote) then isNote = false end
	local sourcePlayerID = 0
	if (sourcePlayer) then
		sourcePlayerID = getElementData(sourcePlayer, "account:id")
	end

	local timeNow = exports.global:getCurrentTime()
	if (isNote) then isNote = 1 else isNote = 0 end
	local query = exports.mysql:Execute("INSERT INTO `interior_logs` (`id`, `intid`, `log`, `sourceid`, `time`, `last_updated`, `isnote`) VALUES (NULL, (?), (?), (?), (?), (?), (?));", tonumber(interiorID), tostring(logText), tonumber(sourcePlayerID), timeNow[3], timeNow[3], isNote)
	if (query) then
		outputLogsDebug(1, timeNow, sourcePlayerID, "INTERIOR", "INT"..interiorID, logText)
		return true
	else
		exports.global:outputDebug("@addInteriorLog: Failed to add log, is there an active database connection?")
	end
	return false
end
addEvent("log:addInteriorLog", true)
addEventHandler("log:addInteriorLog", root, addInteriorLog)

function updateInteriorLog(logID, interiorID, logText, sourcePlayer)
	if not tonumber(logID) then exports.global:outputDebug("@updateInteriorLog: logID not provided or is not a number.") return false end
	if not tonumber(interiorID) then exports.global:outputDebug("@updateInteriorLog: interiorID not provided or is not a numerical value.") return false end
	if not tostring(logText) then exports.global:outputDebug("@updateInteriorLog: logText not provided or is not a string.") return false end

	local sourcePlayerID = 0
	if (sourcePlayer) then sourcePlayerID = getElementData(sourcePlayer, "account:id") end

	local timeNow = exports.global:getCurrentTime()
	local logExists = exports.mysql:QueryString("SELECT `sourceid` FROM `interior_logs` WHERE `id` = (?) ORDER BY `id`;", tonumber(logID))
	if (logExists) then
		local query = exports.mysql:Execute("UPDATE `interior_logs` SET `log` = (?), `last_updated` = (?) WHERE `id` = (?);", tostring(logText), timeNow[3], tonumber(logID))
		if (query) then
			addLog("ACC".. sourcePlayerID, 3, "INT" .. interiorID, "UPDATED INTERIOR LOG #" .. logID .. ": " .. logText)
			outputLogsDebug(1, timeNow, sourcePlayerID, "INTERIOR-LOG", "INT"..interiorID, logText)
			return true
		else
			exports.global:outputDebug("@updateInteriorLog: Failed to update log #" .. logID .. ", is there an active database connection?")
		end
	else
		exports.global:outputDebug("@updateInteriorLog: Attempted to update log ID #" .. logID .. " though log does not exist in database.")
	end
	return false
end
addEvent("log:updateInteriorLog", true)
addEventHandler("log:updateInteriorLog", root, updateInteriorLog)

function getInteriorLogs(interiorID, withNameTable)
	if not tonumber(interiorID) then exports.global:outputDebug("@getInteriorLogs: interiorID not provided or is not a numerical value.") return false end

	local logs = exports.mysql:Query("SELECT * FROM `interior_logs` WHERE `intid` = (?) ORDER BY `id` DESC;", tonumber(interiorID))
	if (logs) then
		if (withNameTable) then
			local namesTable = {}
			for i, theLog in ipairs(logs) do
				local staffName
				if (theLog.sourceid ~= 0) then
					staffName = exports.global:getAccountNameFromID(theLog.sourceid)
				else
					staffName = "SERVER"
				end
				table.insert(namesTable, staffName)
			end
			return logs, namesTable
		end
		return logs
	else
		exports.global:outputDebug("@getInteriorLogs: Failed to fetch interior logs, is there an active database connection?")
		return false
	end
end