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

-- Takes the given element and updates it's position, rotation, dimension and interior whilst updating all child elements.
function elementEnterInterior(theElement, position, rotation, dimension, interior, keepChildren, isInteriorEntry)
	if not isElement(theElement) then outputDebug("@elementEnterInterior: theElement not provided or is not an element.") return false end
	if not position then position = {}; position[1], position[2], position[3] = getElementPosition(theElement) end
	if not rotation then rotation = {}; rotation[1], rotation[2], rotation[3] = getElementRotation(theElement) end
	if not dimension then dimension = getElementDimension(theElement) end
	if not interior then interior = getElementInterior(theElement) end

	local elementType = getElementType(theElement)
	local affectedElements = {}
	if (elementType == "player") then
		-- Get player's current position data before we teleport them.
		local oldx, oldy, oldz = getElementPosition(theElement)
		local _, _, oldrz = getElementRotation(theElement)
		local oldDimension = getElementData(theElement, "character:dimension") or getElementDimension(theElement)
		local oldInterior = getElementData(theElement, "character:interior") or getElementInterior(theElement)

		-- Set new location.
		local updatePosition = setElementPosition(theElement, position[1], position[2], position[3], true)
		local updatedRotation = setElementRotation(theElement, rotation[1], rotation[3], rotation[3])
		local updateDimension = setElementDimension(theElement, dimension)
		setElementInterior(theElement, interior) -- Always returns false for some reason, ignoring check.

		-- If their position was successfully updated.
		if (updatePosition) and (updatedRotation) and (updateDimension) then
			exports.blackhawk:changeElementDataEx(theElement, "character:dimension", tonumber(dimension))
			exports.blackhawk:changeElementDataEx(theElement, "character:interior", tonumber(interior))
			table.insert(affectedElements, theElement)

			local lightState = true
			if isInteriorEntry then
				local theIntID = tonumber(dimension)

				exports.blackhawk:changeElementDataEx(theElement, "character:realininterior", theIntID)

				-- Interior lighting.
				if theIntID ~= 0 then
					local theInterior = exports.data:getElement("interior", theIntID)
					if theInterior then
						local intLightState = getElementData(theInterior, "interior:lights") or 0
						local lightsOn = intLightState == 1
						triggerClientEvent(theElement, "interior:updateIntLights", theElement, lightsOn)
						lightState = lightsOn
					end
				else
					triggerClientEvent(theElement, "interior:updateIntLights", theElement, true)
				end
			end

			if (keepChildren) then
				local theVehicle = getPedOccupiedVehicle(theElement)
				if (theVehicle) then
					setElementPosition(theVehicle, position[1], position[2], position[3])
					setElementRotation(theVehicle, rotation[1], rotation[2], rotation[3])
					setElementDimension(theVehicle, dimension)
					setElementInterior(theVehicle, interior)
					exports.blackhawk:changeElementDataEx(theVehicle, "vehicle:dimension", dimension)
					exports.blackhawk:changeElementDataEx(theVehicle, "vehicle:interior", interior)
					table.insert(affectedElements, theVehicle)
					local vehOccupants = getVehicleOccupants(theVehicle)
					for i, occupant in pairs(vehOccupants) do
						if isElement(occupant) then
							setElementDimension(occupant, dimension)
							setElementInterior(occupant, interior)
							exports.blackhawk:changeElementDataEx(occupant, "character:dimension", dimension)
							exports.blackhawk:changeElementDataEx(occupant, "character:interior", interior)
							if isInteriorEntry then
								exports.blackhawk:changeElementDataEx(occupant, "character:realininterior", tonumber(dimension))
								triggerClientEvent(theElement, "interior:updateIntLights", theElement, lightState)
							end
							table.insert(affectedElements, occupant)
						end
					end
				end
			end

			return true, affectedElements
		else -- If something failed.
			setElementPosition(theElement, oldx, oldy, oldz)
			setElementRotation(theElement, 0, 0, oldrz)
			setElementDimension(theElement, oldDimension)
			setElementInterior(theElement, oldInterior)
			exports.blackhawk:changeElementDataEx(theElement, "character:dimension", tonumber(oldDimension))
			exports.blackhawk:changeElementDataEx(theElement, "character:interior", tonumber(oldInterior))
			outputChatBox("Uh oh, looks like something went wrong, we've put you back in your old position.", theElement, 255, 0, 0)
			outputDebug("@elementEnterInterior: Failed to set position for " .. getPlayerName(theElement) .. ", restored their previous position.", 2)
			return false, false, "Something went wrong, " .. getPlayerName(theElement):gsub("_", " ") .. "'s position was restored to their old position."
		end
	elseif (elementType == "vehicle") then
		setElementPosition(theElement, position[1], position[2], position[3])
		setElementRotation(theElement, rotation[1], rotation[2], rotation[3])
		setElementDimension(theElement, dimension)
		setElementInterior(theElement, interior)
		exports.blackhawk:changeElementDataEx(theElement, "vehicle:dimension", dimension)
		exports.blackhawk:changeElementDataEx(theElement, "vehicle:interior", interior)
		table.insert(affectedElements, theElement)
		local vehOccupants = getVehicleOccupants(theElement)
		for i, occupant in pairs(vehOccupants) do
			if isElement(occupant) then
				setElementDimension(occupant, dimension)
				setElementInterior(occupant, interior)
				exports.blackhawk:changeElementDataEx(occupant, "character:dimension", dimension)
				exports.blackhawk:changeElementDataEx(occupant, "character:interior", interior)
				if isInteriorEntry then exports.blackhawk:changeElementDataEx(occupant, "character:realininterior", tonumber(dimension)) end
				table.insert(affectedElements, occupant)
			end
		end
		return true, affectedElements
	else
		outputDebug("@elementEnterInterior: elementType is not a valid defined element, expected player/vehicle, got " .. tostring(elementType) .. ".")
		return false, false, "Something went wrong whilst updating position!"
	end
end

function getInteriorFromID(interiorID, thePlayer)
	if not (interiorID) then outputDebug("@getInteriorFromID: interiorID not provided.") return false end
	if not (thePlayer) then outputDebug("@getInteriorFromID: thePlayer not provided.", 2) return false end
	if (tostring(interiorID) == "*") and (thePlayer) then -- If asterix provided, check if we can return the source player's interior.
		interiorID = getElementData(thePlayer, "character:realininterior") or 0
		local theInterior = exports.data:getElement("interior", interiorID)
		local thePlayerRealInt = getElementData(thePlayer, "character:realininterior")
		if theInterior and (interiorID == thePlayerRealInt) then
			local theInteriorName = getElementData(theInterior, "interior:name")
			return theInterior, interiorID, theInteriorName
		else
			outputChatBox("ERROR: You are not inside an interior!", thePlayer, 255, 0, 0)
			return false
		end
	end

	-- Check if interior element exists.
	local theInterior = exports.data:getElement("interior", interiorID)
	if (theInterior) then
		local interiorID = getElementData(theInterior, "interior:id")
		local theInteriorName = getElementData(theInterior, "interior:name")
		return theInterior, interiorID, theInteriorName
	end

	-- Check if interior exists in database.
	local existsInDB = exports.mysql:QuerySingle("SELECT `deleted` FROM `interiors` WHERE `id` = (?);", interiorID)
	if (existsInDB) and (existsInDB.deleted == 1) then
		outputChatBox("ERROR: Interior #" .. interiorID .. " is currently deleted, you can restore it with /restoreint.", thePlayer, 255, 0, 0)
		return false
	end

	-- If we've made it this far, interior doesn't exist.
	outputChatBox("ERROR: An interior with the ID #" .. interiorID .. " does not exist!", thePlayer, 255, 0, 0)
	return false
end

-- Takes the given player and returns how many interiors they own, how many slots they have and if they have an available slot.
function getInteriorSlots(charOrFacID, isFaction)
	if not tonumber(charOrFacID) then outputDebug("@getInteriorSlots: charOrFacID not received or is not a number.") return false end

	if isFaction then
		local theFaction = exports.data:getElement("team", charOrFacID)
		if theFaction then
			local totalFacInts = exports.mysql:QueryString("SELECT COUNT(*) FROM `interiors` WHERE `faction` = (?)", charOrFacID)
			local maxIntSlots = getElementData(theFaction, "faction:maxinteriors")
			local availableSlots = true
			if totalFacInts >= maxIntSlots then
				availableSlots = false
			end
			return availableSlots, totalFacInts, maxIntSlots
		else
			return false
		end
	else
		local slots = exports.mysql:QueryString("SELECT `maxinteriors` FROM `characters` WHERE `id` = (?);", charOrFacID)
		if not (slots) then
			outputDebug("@getInteriorSlots: Attempted to get `maxinteriors` slots of account ID which doesn't exist.")
			return false
		end

		local intCount = exports.mysql:Query("SELECT `id` FROM `interiors` WHERE `owner` = (?);", charOrFacID)
		if (intCount) then
			intCount = #intCount
		end

		local availableSlots = true
		if intCount >= slots then
			availableSlots = false
		end

		if (slots) and (intCount) then
			return availableSlots, intCount, slots
		else
			outputDebug("@getInteriorSlots: Failed to fetch all data to return, is there an active database connection?")
			return false
		end
	end
end

-- Takes the given interior and returns the owner's name, owner type and owner ID.
function getInteriorOwner(theInterior)
	-- If an interior ID is provided rather than an element, grab the element.
	if tonumber(theInterior) then theInterior = exports.data:getElement("interior", theInterior) end
	if not isElement(theInterior) then outputDebug("@getInteriorOwner: theInterior not provided or is not an element.") return false end

	local ownerName = "Unknown"
	local ownerType = false
	local ownerID = getElementData(theInterior, "interior:owner"); ownerID = tonumber(ownerID)
	if (ownerID < 0) then -- If the owner is a faction.
		ownerID = -ownerID
		ownerName = getFactionName(ownerID)
		ownerType = "faction"
	elseif (ownerID == 25560) then -- Server owned.
		ownerName = "Server"
		ownerType = "server"
	elseif (ownerID == 0) then
		ownerName = "No one"
	else
		local _, accountName = exports.global:getCharacterAccount(ownerID)
		ownerName = exports.mysql:QueryString("SELECT `name` FROM `characters` WHERE `id` = (?);", ownerID) or "Unknown"
		ownerName = ownerName:gsub("_", " ")
		ownerName = ownerName .. " (" .. accountName .. ")"
		ownerType = "player"
	end

	return ownerName, ownerType, ownerID
end