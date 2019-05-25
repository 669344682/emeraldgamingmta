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

local streams = {
	[0] = { "Radio Off", ""}, -- Radio Station Name, Radio Station URL.
}

-- Optimization.
function getStreams() return streams end

function syncRadio(station)
	local vehicle = getPedOccupiedVehicle(source)
	exports.blackhawk:changeElementDataEx(vehicle, "vehicle:radio", station, true)
	exports.blackhawk:changeElementDataEx(vehicle, "vehicle:radio:old", station, true)
end
addEvent("radio:vehicle:sync", true)
addEventHandler("radio:vehicle:sync", getRootElement(), syncRadio)

function setRadioVolume(thePlayer, commandName, volume)
	local theVehicle = getPedOccupiedVehicle(thePlayer)
	if not (theVehicle) then return end

	local vehType = getVehicleType(theVehicle)
	if (vehType == "BMX") or (vehType == "Bike") or (vehType == "Boat") or (vehType == "Train") then
		outputChatBox("It would be cool if this thing had a radio, huh?", thePlayer, 255, 0, 0)
		return
	end

	if not tonumber(volume) then
		outputChatBox("SYNTAX: /" .. commandName .. " [Volume (0-100)]", thePlayer, 75, 230, 10)
		return
	end

	volume = tonumber(volume)
	if (volume < 0) or (volume > 100) then
		outputChatBox("ERROR: Volume must be between 0 and 100.", thePlayer, 255, 0, 0)
		return
	end

	exports.blackhawk:changeElementDataEx(theVehicle, "vehicle:radio:volume", volume, true)
	triggerEvent("rp:sendAme", thePlayer, "adjusts the radio volume.")
	local vehicleOccupants = getVehicleOccupants(theVehicle)
	for i, player in pairs(vehicleOccupants) do
		triggerClientEvent("radio:gui:updateVolumeLevel", player)
	end
end
addCommandHandler("setvol", setRadioVolume)
addCommandHandler("setvolume", setRadioVolume)

function silenceDistrictRadios(thePlayer)
	if exports.global:isPlayerTrialAdmin(thePlayer) then
		local x, y, z = getElementPosition(thePlayer)

		for i, theVehicle in ipairs(getElementsByType("vehicle")) do
			local vx, vy, vz = getElementPosition(theVehicle)
			local distance = getDistanceBetweenPoints3D (x, y, z, vx, vy, vz)
			
			if distance < 200 then
				exports.blackhawk:changeElementDataEx(theVehicle, "vehicle:radio:volume", 0, true)
			end
		end

		local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
		exports.global:sendMessage("[INFO]" .. thePlayerName .. " has turned off all radios off at " .. getZoneName(x, y, z, false) .. ".", 2, true)
	end
end
addCommandHandler("sdr", silenceDistrictRadios)
addCommandHandler("shutdistrictradios", silenceDistrictRadios)

function fetchStation()
	local allStations = exports.mysql:Query("SELECT * FROM `radio_stations` WHERE `enabled` = '1' ORDER BY `id` ASC")
	local count = 0
	for i, theStation in ipairs(allStations) do
		table.insert(streams, {theStation.station_name, theStation.url})
		count = count + 1
	end

	return count
end

-- Fetch all stations when resource starts and set timer to recheck.
function resourceStart()
	fetchStation()
	setTimer(fetchStation, 900000, 0) -- 15 minutes.
end
addEventHandler("onResourceStart", resourceRoot, resourceStart)

function sendStationsToClient()
	if streams and #streams > 0 then
		triggerClientEvent(source, "radio:getStationsFromServer", source, streams)
	end
end
addEvent("radio:requestRadioStations", true)
addEventHandler("radio:requestRadioStations", root, sendStationsToClient)

function syncRadioToClients()
	local stations = fetchStation()
	local syncedClients, failedClients = 0, 0
	if stations and (stations > 0) then
		for i, player in pairs(getElementsByType("player")) do
			if triggerClientEvent(player, "radio:getStationsFromServer", player, streams) then
				syncedClients = syncedClients + 1
			else
				failedClients = failedClients + 1
			end
		end
		exports.global:outputDebug("Synced " .. stations .. " stations to " .. syncedClients .. " players. (" .. failedClients .. " failed).", 3)
	else
		exports.global:outputDebug("@syncRadioToClients: Failed to sync radio stations to clients.")
	end
end
addEvent("radio:syncRadioToClients", true)
addEventHandler("radio:syncRadioToClients", root, syncRadioToClients)