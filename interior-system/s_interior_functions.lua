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

function createInterior(thePlayer, intid, type, owner, name, price)
	if not isElement(thePlayer) then exports.global:outputDebug("@createInterior: thePlayer not provided or is not an element.") return false end

	local x, y, z = getElementPosition(thePlayer) -- Location where interior entrance will be.
	local _, _, rz = getElementRotation(thePlayer)
	local dimension, interior = getElementDimension(thePlayer), getElementInterior(thePlayer)
	local intx, inty, intz, intrz = unpack(g_interiors[intid][2]) -- Location inside interior. (Interior exit)
	local locationStringOutside = x..","..y..","..z..","..rz
	local locationStringInside = intx..","..inty..","..intz..","..intrz
	if owner ~= 25560 and owner ~= 0 then owner = getElementData(owner, "character:id") end
	local timeNow = exports.global:getCurrentTime()
	local createdBy = getElementData(thePlayer, "account:username")

	-- Get the lowest available vehicle ID.
	local nextID = exports.mysql:QueryString("SELECT MIN(e1.id+1) AS dbid FROM `interiors` AS e1 LEFT JOIN `interiors` AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL")
	nextID = tonumber(nextID) or 1

	local query = exports.mysql:Execute(
		"INSERT INTO `interiors` (`id`, `location`, `dimension`, `interior`, `inside_location`, `inside_dimension`, `inside_interior`, `type`, `intid`, `owner`, `faction`, `locked`, `name`, `price`, `disabled`, `deleted`, `created_date`, `created_by`, `last_used`, `lights`, `custom_int`, `linked_int`) VALUES ((?), (?), (?), (?), (?), (?), (?), (?), (?), (?), '0', '0', (?), (?), '0', '0', (?), (?), (?), '1', NULL, '0');",
		nextID, locationStringOutside, dimension, interior, locationStringInside, nextID, g_interiors[intid][1], type, intid, owner, name, price, timeNow[3], createdBy, timeNow[3]
	)
	if (query) then
		local loadedInt, reason = loadInterior(nextID)
		return loadedInt, reason
	else
		outputChatBox("ERROR: Failed to save interior to database.", thePlayer, 255, 0, 0)
		exports.global:outputDebug("@createInterior: Failed to create interior, is there an active database connection?")
	end
	return false, "Something went wrong whilst creating the interior."
end

function loadInterior(interiorID)
	if not tonumber(interiorID) then exports.global:outputDebug("@loadInterior: interiorID not provided or is not a numerical value.") return false end

	local interiorData = exports.mysql:QuerySingle("SELECT * FROM `interiors` WHERE `id` = (?);", interiorID)
	if not (interiorData) then
		exports.global:outputDebug("@loadInterior: Attempted to load interior #" .. interiorID .. " though interior does not exist.")
		return false, "Interior ID provided does not exist!"
	end

	-- Create the interior element and allocate it.
	local theInterior = createElement("interior", interiorID)
	if (theInterior) then
		exports.data:allocateElement(theInterior, interiorID)

		-- Start setting element data.
		blackhawk:setElementDataEx(theInterior, "interior:id", tonumber(interiorID), true)


		-- Set interior location data.
		local intEntrance = split(interiorData.location, ",")
		table.insert(intEntrance, tonumber(interiorData.dimension))
		table.insert(intEntrance, tonumber(interiorData.interior))
		local intExit = split(interiorData.inside_location, ",")
		table.insert(intExit, tonumber(interiorData.inside_dimension))
		table.insert(intExit, tonumber(interiorData.inside_interior))

		-- set interior position to entrance.
		setElementPosition(theInterior, intEntrance[1], intEntrance[2], intEntrance[3])
		setElementDimension(theInterior, intEntrance[5])
		setElementInterior(theInterior, intEntrance[6])

		-- General data.
		blackhawk:setElementDataEx(theInterior, "interior:entrance", intEntrance, true)
		blackhawk:setElementDataEx(theInterior, "interior:exit", intExit, true)
		blackhawk:setElementDataEx(theInterior, "interior:status", {tonumber(interiorData.type), tonumber(interiorData.disabled)}, true)
		local locked = false; if (tonumber(interiorData.locked) == 1) then locked = true end
		blackhawk:setElementDataEx(theInterior, "interior:locked", locked, true)
		blackhawk:setElementDataEx(theInterior, "interior:name", interiorData.name, true)
		blackhawk:setElementDataEx(theInterior, "interior:price", interiorData.price, true)
		blackhawk:setElementDataEx(theInterior, "interior:lights", interiorData.lights, true)
		blackhawk:setElementDataEx(theInterior, "interior:linked", interiorData.linked_int, true)

		--- Set interior owner.
		local owner, faction = interiorData.owner, interiorData.faction
		if (interiorData.faction ~= 0) then owner = -faction end
		blackhawk:setElementDataEx(theInterior, "interior:owner", owner, true)

		-- Set interior owner name.
		local ownerName = "Server"
		if (owner ~= 25560) and (owner ~= 0) then
			if (interiorData.faction ~= 0) then
				ownerName = exports.global:getFactionName(faction)
			else
				ownerName = exports.global:getCharacterNameFromID(owner)
			end
		end
		blackhawk:setElementDataEx(theInterior, "interior:ownername", ownerName, true)

		-- Load interior markers for clients.
		for i, thePlayer in ipairs(getElementsByType("player")) do
			triggerClientEvent(thePlayer, "interior:loadInteriorMarkersClient", theInterior, theInterior)
		end
		return theInterior
	else
		return false, "Something went wrong whilst loading the interior."
	end
end

function saveInterior(interiorID)
	if not tonumber(interiorID) then exports.global:outputDebug("@saveInterior: interiorID not provided or is not a numerical value.") return false end

	-- Check if the interior element exists.
	local theInterior = exports.data:getElement("interior", interiorID)
	if not (theInterior) then
		exports.global:outputDebug("@saveInterior: Attempted to save interior #" .. interiorID .. " though interior element does not exist.")
		return false
	end

	-- If the interior being saved doesn't exist in the database.
	local interiorData = exports.mysql:QueryString("SELECT `name` FROM `interiors` WHERE `id` = (?);", interiorID)
	if not (interiorData) then
		exports.global:outputDebug("@saveInterior: Attempted to save interior #" .. interiorID .. " though interior does not exist in database.")
		return false
	end

	-- Get location data.
	local x, y, z, rz, dimension, interior = unpack(getElementData(theInterior, "interior:entrance"))
	local ix, iy, iz, irz, inside_dim, inside_int = unpack(getElementData(theInterior, "interior:exit"))
	local locationStringOutside = x..","..y..","..z..","..rz
	local locationStringInside = ix..","..iy..","..iz..","..irz

	-- Get interior statuses.
	local intType, isDisabled = unpack(getElementData(theInterior, "interior:status"))

	-- Other general data.
	local isLocked = getElementData(theInterior, "interior:locked")
	if (isLocked) then isLocked = 1 else isLocked = 0 end
	local intName = getElementData(theInterior, "interior:name")
	local intPrice = getElementData(theInterior, "interior:price")
	local intLights = getElementData(theInterior, "interior:lights") or 1
	local linkedInt = getElementData(theInterior, "interior:linked")
	
	-- Get interior owner.
	local intOwner = getElementData(theInterior, "interior:owner")
	local intFaction = 0
	if (intOwner < 0) then intFaction = -intOwner; intOwner = 0 end

	local query = exports.mysql:Execute(
		"UPDATE `interiors` SET `location` = (?), `dimension` = (?), `interior` = (?), `inside_location` = (?), `inside_dimension` = (?), `inside_interior` = (?), `type` = (?), `owner` = (?), `faction` = (?), `locked` = (?), `name` = (?), `price`= (?), `disabled` = (?), `lights` = (?), `linked_int` = (?) WHERE `id` = (?);",
		locationStringOutside, dimension, interior, locationStringInside, inside_dim, inside_int, intType, intOwner, intFaction, isLocked, intName,
		intPrice, isDisabled, intLights, linkedInt, interiorID
	)

	if (query) then return true end
	return false
end

function reloadInterior(interiorID)
	if not tonumber(interiorID) then exports.global:outputDebug("@reloadInterior: interiorID not provided or is not a numerical value.") return false end
	interiorID = tonumber(interiorID)
	-- Check to see if the interior element exists.
	local theInterior = exports.data:getElement("interior", interiorID)
	local skipSave = false

	-- If the interior element doesn't exist, we don't need to save it before loading it again.
	if not (theInterior) then
		local intExists = exports.mysql:QueryString("SELECT `deleted` FROM `interiors` WHERE `id` = (?);", interiorID)
		if (intExists) then
			if tonumber(intExists == 1) then
				return false, "You can't reload an interior that is deleted!"
			end

			skipSave = true
		else
			return false, "An interior with that ID does not exist!"
		end
	end

	if not (skipSave) then
		saveInterior(interiorID)
		-- Destroy all existing teleporter markers.
		for i, thePlayer in ipairs(getElementsByType("player")) do
			triggerClientEvent(thePlayer, "interior:destroyInteriorMarkers", thePlayer, interiorID)
		end
		destroyElement(theInterior)
	end

	local loaded = loadInterior(interiorID)
	return loaded, "Failed to load interior."
end

function saveAllInteriors()
	local allInteriors = exports.data:getDataElementsByType("interior")
	local leftToSave = #allInteriors

	local delay = 50
	for i, interior in ipairs(allInteriors) do
		local intID = getElementData(interior, "interior:id")
		if (intID) then
			setTimer(saveInterior, delay, 1, intID)
		end
		delay = delay + 50

		leftToSave = leftToSave - 1
		if (leftToSave == 0) then return true end
	end
end

-- Loads all interiors from database onResourceStart.
function loadAllInteriors()
	local allInteriors = exports.mysql:Query("SELECT `id` FROM `interiors` WHERE `deleted` = 0 ORDER BY `id` ASC;")
	if not (allInteriors) or not (allInteriors[1]) then return end

	local delay = 50
	for index, interior in ipairs(allInteriors) do
		setTimer(loadInterior, delay, 1, tonumber(interior.id))
		delay = delay + 50
	end

	exports.global:outputDebug("Loading " .. #allInteriors .. " interiors, estimated time to load: " .. (delay/1000) .. " seconds.", 3)
end
addEventHandler("onResourceStart", resourceRoot, loadAllInteriors)

-- Primary function for interior marker usage.
function useInteriorMarker(interiorID, isEntrance)
	local theInterior = exports.data:getElement("interior", interiorID)
	if theInterior then
		local x, y, z, rz, dim, int
		if isEntrance then -- If the marker being used is the entrance marker.
			x, y, z, rz, dim, int = unpack(getElementData(theInterior, "interior:exit"))
		else
			x, y, z, rz, dim, int = unpack(getElementData(theInterior, "interior:entrance"))
		end
		local state, affectedElements = exports.global:elementEnterInterior(source, {x, y, z}, {0, 0, rz}, dim, int, true, true)
		if (state) then
			if isEntrance then
				exports.logs:addInteriorLog(dim, "[ENTER] " .. getPlayerName(source) .. " entered interior.", source)
				exports.logs:addLog(source, 3, affectedElements, "[Interior Enter] " .. getPlayerName(source) .. " entered interior.", source)
			else
				exports.logs:addInteriorLog(dim, "[EXIT] " .. getPlayerName(source) .. " exited interior.", source)
				exports.logs:addLog(source, 3, affectedElements, "[Interior Exit] " .. getPlayerName(source) .. " exited interior.", source)
			end
		end
	end
end
addEvent("interior:useMarker", true)
addEventHandler("interior:useMarker", root, useInteriorMarker)