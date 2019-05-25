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

function addFactionLog(factionID, sourcePlayer, logText)
	if not tonumber(factionID) then -- If a faction element is provided, try determine it's ID.
		factionID = getElementData(factionID, "faction:id")
		if not tonumber(factionID) then exports.global:outputDebug("@addFactionLog: factionID not provided or faction element doesn't have an ID.") return false end
	end
	local sourcePlayerID = 0
	if (sourcePlayer) then
		sourcePlayerID = getElementData(sourcePlayer, "account:id") or 0
	end
	if not tostring(logText) then exports.global:outputDebug("@addFactionLog: logText not provided or is not a string.") return false end

	local timeNow = exports.global:getCurrentTime()
	if (isNote) then isNote = 1 else isNote = 0 end
	local query = exports.mysql:Execute("INSERT INTO `faction_logs` (`id`, `factionid`, `log`, `sourceid`, `time`) VALUES (NULL, (?), (?), (?), (?));", tonumber(factionID), tostring(logText), tonumber(sourcePlayerID), timeNow[3])
	if (query) then
		outputLogsDebug(1, timeNow, sourcePlayerID, "FACTION", "FAC"..factionID, logText)
		return true
	else
		exports.global:outputDebug("@addFactionLog: Failed to add log, is there an active database connection?")
	end
	return false
end

function getFactionLogs(factionID, withNameTable)
	if not tonumber(factionID) then exports.global:outputDebug("@getFactionLogs: factionID not provided or is not a numerical value.") return false end

	local logs = exports.mysql:Query("SELECT * FROM `faction_logs` WHERE `factionid` = (?) ORDER BY `id` DESC;", tonumber(factionID))
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
		exports.global:outputDebug("@getFactionLogs: Failed to fetch faction logs, is there an active database connection?")
		return false
	end
end