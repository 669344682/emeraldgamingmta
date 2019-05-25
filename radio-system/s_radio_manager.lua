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

-- /showstreams - By Skully (23/05/18) [Manager/Developer]
function showRadioManager(thePlayer)
	if exports.global:isPlayerManager(thePlayer, true) or exports.global:isPlayerDeveloper(thePlayer) then
		local stationData = exports.mysql:Query("SELECT * FROM radio_stations ORDER BY `id`")
		if (stationData) then
			local ownerData = {}
			for i, station in ipairs(stationData) do
				if (station.owner == 0) then
					table.insert(ownerData, "Server")
				else
					local accountName = exports.global:getAccountNameFromID(station.owner) or "Unknown"
					table.insert(ownerData, accountName)
				end
			end
			triggerClientEvent(thePlayer, "radio:gui:showRadioManagerGUI", thePlayer, stationData, ownerData)
		end
	end
end
addCommandHandler("showstreams", showRadioManager)
addEvent("radio:gui:showstreamscall", true) -- Used by Stream Manager GUI to reopen.
addEventHandler("radio:gui:showstreamscall", root, showRadioManager)

-- Event triggered by client when new stream added or edited.
function handleRadioStream(thePlayer, isEdit, stationName, streamURL, owner, isServerOwned, isEnabled, expireTime)
	if tonumber(isEdit) then
		local accountID = exports.global:getAccountFromName(owner)
		if not (accountID) and not (isServerOwned) then
			outputChatBox("ERROR: An account with the name '" .. owner .. "' does not exist!", thePlayer, 255, 0, 0)
			return false
		end

		if (isServerOwned) then accountID = 0 end
		local expireTime = 0 -- Handle expiry for donator radios. @requires donator-system (Not really just cba rn xd)

		local editState = exports.mysql:Execute("UPDATE `radio_stations` SET `station_name` = (?), `url` = (?), `owner` = (?), `expiry_date` = (?), `enabled` = (?) WHERE `id` = (?);", stationName, streamURL, accountID, expireTime, isEnabled, tonumber(isEdit))
		if (editState) then
			local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
			outputChatBox("You have updated station #" .. isEdit .. " - " .. stationName, thePlayer, 0, 255, 0)
			exports.global:sendMessageToManagers("[INFO] " .. thePlayerName .. " has adjusted radio station #" .. isEdit .. " - " .. stationName .. ".", true)
			exports.logs:addLog(thePlayer, 1, thePlayer, "(/showstreams) Edited radio station #" .. isEdit .. " - " .. stationName .. ".")
		else
			outputChatBox("ERROR: Failed to save changes to database.", thePlayer, 255, 0, 0)
		end
	else
		local accountID = exports.global:getAccountFromName(owner)
		if not (accountID) and not (isServerOwned) then
			outputChatBox("ERROR: An account with the name '" .. owner .. "' does not exist!", thePlayer, 255, 0, 0)
			return false
		end

		if (isServerOwned) then accountID = 0 end
		local expireTime = 0 -- Handle expiry for donator radios. @requires donator-system
		local timeNow = exports.global:getCurrentTime()
		local stationAdded = exports.mysql:Execute("INSERT INTO `radio_stations` (`id`, `station_name`, `url`, `owner`, `date_added`, `expiry_date`, `enabled`) VALUES (NULL, (?), (?), (?), (?), (?), (?));", stationName, streamURL, accountID, timeNow[3], expireTime, isEnabled)
		if (stationAdded) then
			local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
			outputChatBox("You have added the station '" .. stationName .. "'.", thePlayer, 0, 255, 0)
			outputChatBox("Please allow some time for the station to sync and appear to all players.", thePlayer, 75, 230, 10)
			exports.global:sendMessageToManagers("[INFO] " .. thePlayerName .. " has added a new radio stream. (" .. stationName .. ")", true)
			exports.logs:addLog(thePlayer, 1, thePlayer, "(/showstreams) Added radio station '" .. stationName .. "'.")
		else
			outputChatBox("ERROR: Failed to save stream to database.", thePlayer, 255, 0, 0)
		end
	end
	-- send client radio syncc
end
addEvent("radio:gui:handleRadioStream", true)
addEventHandler("radio:gui:handleRadioStream", root, handleRadioStream)

-- Event triggered by client when stream deleted.
function handleRadioDeleted(thePlayer, streamID)
	local stationExists = exports.mysql:QuerySingle("SELECT `station_name` FROM `radio_stations` WHERE `id` = (?);", tonumber(streamID))
	if (stationExists) then
		local isDeleted = exports.mysql:Execute("DELETE FROM `radio_stations` WHERE `id` = (?);", streamID)
		if (isDeleted) then
			local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
			outputChatBox("You have deleted the station '" .. stationExists.station_name .. "'.", thePlayer, 75, 230, 10)
			exports.global:sendMessageToManagers("[INFO] " .. thePlayerName .. " has deleted radio station #" .. streamID .. " - " .. stationExists.station_name .. ".", true)
			exports.logs:addLog(thePlayer, 1, thePlayer, "(/showstreams) Deleted radio station #" .. streamID .. " - " .. stationExists.station_name .. ".")
		else
			outputChatBox("ERROR: Failed to delete from database.", thePlayer, 255, 0, 0)
			return
		end
	else
		outputChatBox("ERROR: A station with the ID " .. streamID .. " doesn't exist!", thePlayer, 255, 0, 0)
	end
	-- send client radio syncc
end
addEvent("radio:gui:handleRadioDeleted", true)
addEventHandler("radio:gui:handleRadioDeleted", root, handleRadioDeleted)