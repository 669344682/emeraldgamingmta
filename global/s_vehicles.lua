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

function getVehicleFromID(vehicleID, thePlayer)
	if not (vehicleID) then outputDebug("@getVehicleFromID: vehicleID not provided.") return false end
	if not (thePlayer) then outputDebug("@getVehicleFromID: thePlayer not provided.", 2) return false end
	if (tostring(vehicleID) == "*") and (thePlayer) then -- IF asterix provided, check if we can return the source player's vehicle.
		local thePlayerVehicle = getPedOccupiedVehicle(thePlayer)
		if thePlayerVehicle then
			local vehicleID = getElementData(thePlayerVehicle, "vehicle:id")
			return thePlayerVehicle, vehicleID
		else
			outputChatBox("ERROR: You are not inside a vehicle!", thePlayer, 255, 0, 0)
			return false
		end
	end

	-- Check if vehicle element exists.
	local theVehicle = exports.data:getElement("vehicle", vehicleID)
	if (theVehicle) then
		local vehicleID = getElementData(theVehicle, "vehicle:id")
		return theVehicle, vehicleID
	end

	-- Check if vehicle exists in database.
	local existsInDB = exports.mysql:QuerySingle("SELECT `deleted` FROM `vehicles` WHERE `id` = (?);", vehicleID)
	if (existsInDB) and (existsInDB.deleted == 1) then
		outputChatBox("ERROR: Vehicle #" .. vehicleID .. " is currently deleted, you can restore it with /restoreveh.", thePlayer, 255, 0, 0)
		return false
	end

	-- If we've made it this far, vehicle doesn't exist.
	outputChatBox("ERROR: A vehicle with the ID #" .. vehicleID .. " does not exist!", thePlayer, 255, 0, 0)
	return false
end

-- Function which handles placing player's into vehicles and handling extra actions along the way, should be used over MTA's warpPedIntoVehicle().
function vehicle_warpPedIntoVehicle(thePlayer, theVehicle, seat)
	if not (thePlayer) or not (theVehicle) then return false end
	if not (seat) then seat = 0 end

	-- Save the player's current interior and dim.
	local thePlayerDimension = getElementDimension(thePlayer)
	local thePlayerInterior = getElementInterior(thePlayer)

	-- Place them into the vehicle.
	setElementDimension(thePlayer, getElementDimension(theVehicle))
	setElementInterior(thePlayer, getElementInterior(theVehicle))
	if warpPedIntoVehicle(thePlayer, theVehicle, seat) then
		if (seat > 0) then
			setCameraTarget(thePlayer, thePlayer)
		end
		return true
	else -- If we couldn't set them into vehicle, set their interior/dim back to what it was.
		setElementDimension(thePlayer, thePlayerDimension)
		setElementInterior(thePlayer, thePlayerInterior)
	end
	return false
end

-- Takes the given vehicle ID and checks to see if it exists in the vehicle database and returns the MTA model ID if it exists, else false.
function doesVehicleExist(vehicleID)
	if not tonumber(vehicleID) then outputDebug("@doesVehicleExist: Provided vehicleID not received or is not a numerical value.") return false end

	local exists = exports.mysql:QueryString("SELECT `vehid` FROM `vehicle_database` WHERE `id` = (?);", tonumber(vehicleID))
	if (exists) then
		return tonumber(exists)
	else
		return false
	end
end

-- Takes the given player and returns how many vehicles they own, how many slots they have and if they have an available slot.
function getVehicleSlots(charOrFacID, isFaction)
	if not (charOrFacID) then outputDebug("@getVehicleSlots: charOrFacID not received or is not an element/number.") return false end

	if isFaction then
		local theFaction = exports.data:getElement("team", charOrFacID)
		if theFaction then
			local totalFacVehs = exports.mysql:QueryString("SELECT COUNT(*) FROM `vehicles` WHERE `faction` = (?)", charOrFacID)
			local maxVehSlots = getElementData(theFaction, "faction:maxinteriors")
			local availableSlots = true
			if totalFacVehs >= maxVehSlots then
				availableSlots = false
			end
			return availableSlots, totalFacVehs, maxVehSlots
		else
			return false
		end
	else
		if type(charOrFacID) == "userdata" then -- If a player was provided.
			charOrFacID = getElementData(charOrFacID, "character:id")
		end

		local slots = exports.mysql:QueryString("SELECT `maxvehicles` FROM `characters` WHERE `id` = (?);", charOrFacID)
		if not (slots) then
			outputDebug("@getVehicleSlots: Attempted to get `maxvehicles` slots of account ID which doesn't exist.")
			return false
		end

		local vehCount = exports.mysql:Query("SELECT `id` FROM `vehicles` WHERE `owner` = (?);", charOrFacID)
		if (vehCount) then
			vehCount = #vehCount
		end

		local availableSlots = true
		if vehCount >= slots then
			availableSlots = false
		end

		if (slots) and (vehCount) then
			return availableSlots, vehCount, slots
		else
			outputDebug("@getVehicleSlots: Failed to fetch all data to return, is there an active database connection?")
			return false
		end
	end
end

-- Takes the given vehicle DBID and returns it's associated information in a table, and it's name.
function getVehicleModelInfo(vehDBID)
	if not tonumber(vehDBID) then outputDebug("@getVehicleModelInfo: vehDBID not received or is not a numerical value.") return false end

	if not (doesVehicleExist(vehDBID)) then
		outputDebug("@getVehicleModelInfo: Attempted to get information of vehicle that doesn't exist.")
		return false
	end

	local dataTable = exports.mysql:QuerySingle("SELECT * FROM `vehicle_database` WHERE `id` = (?);", tonumber(vehDBID))
	if (dataTable) then
		local vehicleName = dataTable.year .. " " .. dataTable.brand .. " " .. dataTable.model
		return dataTable, vehicleName
	else
		outputDebug("@getVehicleModelInfo: Failed to fetch information of vehicle DBID #" .. tonumber(vehDBID) .. ", does the vehicle still exist?") -- May also be the result of no SQL connection.
		return false
	end
end

-- Takes the given vehicleID and returns it's model information as a table, and name.
function getVehicleInfo(vehicleID)
	if not tonumber(vehicleID) then -- If no vehicle ID is provided, check to see if it is a vehicle element and determine it's ID.
		vehicleID = getElementData(vehicleID, "vehicle:id")
		if not (vehicleID) then outputDebug("@getVehicleInfo: vehicleID not received or is not a numerical value.") return false end
	end
	if (vehicleID == 0) then return false, "Temporary Vehicle" end -- If the ID provided is a temp vehicle.

	local vehicleModel = exports.mysql:QueryString("SELECT `model` FROM `vehicles` WHERE `id` = (?);", tonumber(vehicleID))
	if (vehicleModel) then
		local vehicleData, vehicleName = getVehicleModelInfo(vehicleModel)
		return vehicleData, vehicleName
	else
		outputDebug("@getVehicleInfo: Failed to fetch information of vehicle DBID #" .. tonumber(vehicleID) .. ", does the vehicle exist?") -- May also be the result of no SQL connection.
		return false
	end
end