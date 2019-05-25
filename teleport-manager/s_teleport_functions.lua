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

blackhawk = exports.blackhawk

function createTeleporter(thePlayer, location, location2, isOneway)
	if not isElement(thePlayer) then exports.global:outputDebug("@createTeleporter: thePlayer not provided or is not an element.") return false end
	if not (type(location) == "table") or not (type(location2) == "table") then
		exports.global:outputDebug("@createTeleporter: location or location2 table not provided.")
		return false
	end
	if isOneway then isOneway = 1 else isOneway = 0 end

	local locationString = location[1]..","..location[2]..","..location[3]..","..location[4]..","..location[5]..","..location[6]
	local locationString2 = location2[1]..","..location2[2]..","..location2[3]..","..location2[4]..","..location2[5]..","..location2[6]

	-- Get lowest available teleporter ID.
	local nextID = exports.mysql:QueryString("SELECT MIN(e1.id+1) AS dbid FROM `teleporters` AS e1 LEFT JOIN `teleporters` AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL")
	nextID = tonumber(nextID) or 1

	local query = exports.mysql:Execute(
		"INSERT INTO `teleporters` (`id`, `location`, `location2`, `locked`, `oneway`, `mode`) VALUES ((?), (?), (?), '0', (?), '1');",
		nextID, locationString, locationString2, isOneway
	)

	if (query) then
		local loadedTeleporter, reason = loadTeleporter(nextID)
		return loadedTeleporter, reason
	else
		outputChatBox("ERROR: Failed to save teleporter to database.", thePlayer, 255, 0, 0)
		exports.global:outputDebug("@createTeleporter: Failed to create teleporter, is there an active database connection?")
	end
	return false, "Something went wrong whilst creating the teleporter."
end

function loadTeleporter(teleporterID)
	if not tonumber(teleporterID) then exports.global:outputDebug("@loadTeleporter: teleporterID not provided or is not a numerical value.") return false end
	teleporterID = tonumber(teleporterID)

	local teleporterData = exports.mysql:QuerySingle("SELECT * FROM `teleporters` WHERE `id` = (?);", teleporterID)
	if (teleporterData) then
		local theTeleporter = createElement("teleporter", teleporterID)
		if theTeleporter then
			-- Set element data.
			local locationString = split(teleporterData.location, ",")
			local locationString2 = split(teleporterData.location2, ",")
			
			blackhawk:setElementDataEx(theTeleporter, "teleporter:id", teleporterID, true)
			blackhawk:setElementDataEx(theTeleporter, "teleporter:location", {locationString[1], locationString[2], locationString[3], locationString[4], locationString[5], locationString[6]}, true)
			blackhawk:setElementDataEx(theTeleporter, "teleporter:location2", {locationString2[1], locationString2[2], locationString2[3], locationString2[4], locationString2[5], locationString2[6]}, true)
			blackhawk:setElementDataEx(theTeleporter, "teleporter:locked", teleporterData.locked, true)
			blackhawk:setElementDataEx(theTeleporter, "teleporter:oneway", teleporterData.oneway, true)
			blackhawk:setElementDataEx(theTeleporter, "teleporter:mode", teleporterData.mode, true)

			-- Allocate element.
			exports.data:allocateElement(theTeleporter, teleporterID)

			-- Load teleporter for all clients.
			for i, thePlayer in ipairs(getElementsByType("player")) do
				triggerClientEvent(thePlayer, "teleporter:loadTeleporterClient", theTeleporter, theTeleporter)
			end

			return theTeleporter
		else
			return false, "Failed to create teleporter element!"
		end
	else
		return false, "A teleporter with that ID doesn't exist."
	end
end

function reloadTeleporter(teleporterID)
	if not tonumber(teleporterID) then exports.global:outputDebug("@reloadTeleporter: teleporterID not provided or is not a numerical value.") return false end
	teleporterID = tonumber(teleporterID)

	local theTeleporter = exports.data:getElement("teleporter", teleporterID)
	local skipSave = false

	-- If the teleporter element doesn't exist, we don't need to save it before loading it again.
	if not (theTeleporter) then
		local teleporterExists = exports.mysql:QueryString("SELECT `locked` FROM `teleporters` WHERE `id` = (?);", teleporterID)
		if not (teleporterExists) then
			return false, "A teleporter with that ID doesn't exist!"
		else
			skipSave = true
		end
	end

	if not (skipSave) then
		saveTeleporter(teleporterID)

		-- Destroy all existing teleporter markers.
		for i, thePlayer in ipairs(getElementsByType("player")) do
			triggerClientEvent(thePlayer, "teleporter:destroyTeleporter", thePlayer, teleporterID)
		end
		destroyElement(theTeleporter)
	end

	local loadedTeleporter, reason = loadTeleporter(teleporterID)
	return loadTeleporter, reason
end
addEvent("teleport:reloadTeleporter", true) -- Used by /fixtps
addEventHandler("teleport:reloadTeleporter", root, reloadTeleporter)

function saveTeleporter(teleporterID)
	if not tonumber(teleporterID) then exports.global:outputDebug("@saveTeleporter: teleporterID not provided or is not a numerical value.") return false end
	teleporterID = tonumber(teleporterID)

	-- Check if teleporter exists in database.
	local teleporterData = exports.mysql:QueryString("SELECT `locked` FROM `teleporters` WHERE `id` = (?);", teleporterID)
	if not teleporterData then
		exports.global:outputDebug("@saveTeleporter: Attempted to save teleporter #" .. teleporterID .. " though teleporter doesn't exist in database.")
		return false	
	end

	-- Check if teleporter element exists.
	local theTeleporter = exports.data:getElement("teleporter", teleporterID)
	if not (theTeleporter) then
		exports.global:outputDebug("@saveTeleporter: Attempted to save teleporter #" .. teleporterID .. " though teleporter element doesn't exist.")
		return false
	end

	-- Get all data.
	local x, y, z, rz, dim, int = unpack(getElementData(theTeleporter, "teleporter:location"))
	local x2, y2, z2, rz2, dim2, int2 = unpack(getElementData(theTeleporter, "teleporter:location2"))
	local lockedState = getElementData(theTeleporter, "teleporter:locked") or 0
	local oneway = getElementData(theTeleporter, "teleporter:oneway") or 0
	local mode = getElementData(theTeleporter, "teleporter:mode") or 0
	local locationString = x..","..y..","..z..","..rz..","..dim..","..int
	local locationString2 = x2..","..y2..","..z2..","..rz2..","..dim2..","..int2

	local query = exports.mysql:Execute(
		"UPDATE `teleporters` SET `location` = (?), `location2` = (?), `locked` = (?), `oneway` = (?), `mode` = (?) WHERE `id` = (?);",
		locationString, locationString2, lockedState, oneway, mode, teleporterID
	)
	
	if (query) then return true end
	return false
end

function deleteTeleporter(teleporterID)
	if not tonumber(teleporterID) then exports.global:outputDebug("@deleteTeleporter: teleporterID not provided or is not a numerical value.") return false end
	teleporterID = tonumber(teleporterID)

	-- Check if teleporter element exists.
	local theTeleporter = exports.data:getElement("teleporter", teleporterID)
	if not (theTeleporter) then
		exports.global:outputDebug("@deleteTeleporter: Attempted to delete teleporter #" .. teleporterID .. " though teleporter element doesn't exist.")
		return false, "That teleporter does not exist!"
	end

	local query = exports.mysql:Execute("DELETE FROM `teleporters` WHERE `id` = (?);", teleporterID)
	if (query) then
		-- Destroy all existing teleporter markers.
		for i, thePlayer in ipairs(getElementsByType("player")) do
			triggerClientEvent(thePlayer, "teleporter:destroyTeleporter", thePlayer, teleporterID)
		end
		local destroyed = destroyElement(theTeleporter)
		return destroyed, "Something went wrong whilst deleting the teleporter element."
	else
		return false, "Something went wrong whilst removing the teleporter from the database."
	end
end

function saveAllTeleporters()
	local allTeleporters = exports.data:getDataElementsByType("teleporter")
	local leftToSave = #allTeleporters

	local delay = 50
	for i, teleporter in ipairs(allTeleporters) do
		local teleporterID = getElementData(teleporter, "teleporter:id")
		if teleporterID then
			setTimer(saveTeleporter, delay, 1, teleporterID)
		end
		delay = delay + 50

		leftToSave = leftToSave - 1
		if (leftToSave == 0) then return true end
	end
end

function loadAllTeleporters()
	local allTeleporters = exports.mysql:Query("SELECT `id` FROM `teleporters` ORDER BY `id` ASC;")
	if not allTeleporters or not (allTeleporters[1]) then return end

	local delay = 50
	for i, teleporter in ipairs(allTeleporters) do
		setTimer(loadTeleporter, delay, 1, tonumber(teleporter.id))
		delay = delay + 50
	end

	exports.global:outputDebug("Loading " .. #allTeleporters .. " teleporters, estimated time to load: " .. (delay/1000) .. " seconds.", 3)
end
addEventHandler("onResourceStart", resourceRoot, loadAllTeleporters)

function useTeleporter(teleporterID, isEntrance)
	local theTeleporter = exports.data:getElement("teleporter", teleporterID)
	if theTeleporter then
		local x, y, z, rz, dim, int
		if (isEntrance) then -- If the teleporter being used is the primary/entrance marker.
			x, y, z, rz, dim, int = unpack(getElementData(theTeleporter, "teleporter:location2"))
		else
			x, y, z, rz, dim, int = unpack(getElementData(theTeleporter, "teleporter:location"))
		end
		
		local state, affectedElements = exports.global:elementEnterInterior(source, {x, y, z}, {0, 0, rz}, dim, int, true, false)
		if (false) then -- get int id the marker attached to
			if isEntrance then
				exports.logs:addInteriorLog(dim, "[ENTER] " .. getPlayerName(source) .. " entered interior through teleporter #" .. teleporterID .. ".", source)
				exports.logs:addLog(source, 3, affectedElements, "[Interior Enter] " .. getPlayerName(source) .. " entered interior through teleporter #" .. teleporterID .. ".", source)
			else
				exports.logs:addInteriorLog(dim, "[EXIT] " .. getPlayerName(source) .. " exited interior through teleporter #" .. teleporterID .. ".", source)
				exports.logs:addLog(source, 3, affectedElements, "[Interior Exit] " .. getPlayerName(source) .. " exited interior through teleporter #" .. teleporterID .. ".", source)
			end
		end
	end
end
addEvent("teleporter:useTeleporter", true)
addEventHandler("teleporter:useTeleporter", root, useTeleporter)