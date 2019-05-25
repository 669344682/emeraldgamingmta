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

function addVehicleLog(vehicleID, logText, sourcePlayer, isNote)
	if not tonumber(vehicleID) then -- If a vehicle element is provided, try determine it's ID.
		vehicleID = getElementData(vehicleID, "vehicle:id")
		if not tonumber(vehicleID) then exports.global:outputDebug("@addVehicleLog: vehicleID not provided or vehicle element doesn't have an ID.") return false end
	end
	if (vehicleID == 0) then return end -- Temporary vehicles.
	if not tostring(logText) then exports.global:outputDebug("@addVehicleLog: logText not provided or is not a string.") return false end
	if not (isNote) then isNote = false end
	local sourcePlayerID = 0
	if (sourcePlayer) then
		sourcePlayerID = getElementData(sourcePlayer, "account:id")
	end

	local timeNow = exports.global:getCurrentTime()
	if (isNote) then isNote = 1 else isNote = 0 end
	local query = exports.mysql:Execute("INSERT INTO `vehicle_logs` (`id`, `vehid`, `log`, `sourceid`, `time`, `last_updated`, `isnote`) VALUES (NULL, (?), (?), (?), (?), (?), (?));", tonumber(vehicleID), tostring(logText), tonumber(sourcePlayerID), timeNow[3], timeNow[3], isNote)
	if (query) then
		outputLogsDebug(1, timeNow, sourcePlayerID, "VEHICLE", "VEH"..vehicleID, logText)
		return true
	else
		exports.global:outputDebug("@addVehicleLog: Failed to add log, is there an active database connection?")
	end
	return false
end
addEvent("log:addVehicleLog", true)
addEventHandler("log:addVehicleLog", root, addVehicleLog)

function updateVehicleLog(logID, vehicleID, logText, sourcePlayer)
	if not tonumber(logID) then exports.global:outputDebug("@updateVehicleLog: logID not provided or is not a number.") return false end
	if not tonumber(vehicleID) then exports.global:outputDebug("@updateVehicleLog: vehicleID not provided or is not a numerical value.") return false end
	if not tostring(logText) then exports.global:outputDebug("@updateVehicleLog: logText not provided or is not a string.") return false end

	local sourcePlayerID = 0
	if (sourcePlayer) then
		sourcePlayerID = getElementData(sourcePlayer, "account:id")
	end

	local timeNow = exports.global:getCurrentTime()
	local logExists = exports.mysql:QueryString("SELECT `sourceid` FROM `vehicle_logs` WHERE `id` = (?) ORDER BY `id`;", tonumber(logID))
	if (logExists) then
		local query = exports.mysql:Execute("UPDATE `vehicle_logs` SET `log` = (?), `last_updated` = (?) WHERE `id` = (?);", tostring(logText), timeNow[3], tonumber(logID))
		if (query) then
			addLog("ACC".. sourcePlayerID, 3, "VEH" .. vehicleID, "UPDATED VEHICLE LOG #" .. logID .. ": " .. logText)
			outputLogsDebug(1, timeNow, sourcePlayerID, "VEHICLE-LOG", "VEH"..vehicleID, logText)
			return true
		else
			exports.global:outputDebug("@updateVehicleLog: Failed to update log #" .. logID .. ", is there an active database connection?")
		end
	else
		exports.global:outputDebug("@updateVehicleLog: Attempted to update log ID #" .. logID .. " though log does not exist in database.")
	end
	return false
end
addEvent("log:updateVehicleLog", true)
addEventHandler("log:updateVehicleLog", root, updateVehicleLog)

function getVehicleLogs(vehicleID, withNameTable)
	if not tonumber(vehicleID) then exports.global:outputDebug("@getVehicleLogs: vehicleID not provided or is not a numerical value.") return false end

	local logs = exports.mysql:Query("SELECT * FROM `vehicle_logs` WHERE `vehid` = (?) ORDER BY `id` DESC;", tonumber(vehicleID))
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
		exports.global:outputDebug("@getVehicleLogs: Failed to fetch vehicle logs, is there an active database connection?")
		return false
	end
end