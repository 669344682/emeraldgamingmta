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

global = exports.global

function makeEditorVehicle(thePlayer, yearOrData, brandValue, modelValue, priceValue, vehID, dealershipID, vehType, vehTax, isNewVehicle)
	local thePlayerName = global:getStaffTitle(thePlayer, 1)
	local broadcastText = "has started vehicle creation of a"
	local vehData = yearOrData
	local libID = 0
	
	if not (isNewVehicle) then -- If vehicle already exists, we need to get its data.
		broadcastText = "has started editing"
		libID = brandValue
		yearOrData, brandValue, modelValue = yearOrData.year, yearOrData.brand, yearOrData.model
	end

	global:sendMessageToManagers("[INFO] " .. thePlayerName .. " " .. broadcastText .. " '(" .. vehID .. ") " .. yearOrData .. " " .. brandValue .. " " .. modelValue .. "'.", true)

	local x, y, z = getElementPosition(thePlayer)
	local rx, ry, rz = getElementRotation(thePlayer)
	local dimension = getElementDimension(thePlayer)
	local int = getElementInterior(thePlayer)

	local tempVehicle = createVehicle(vehID, x, y, z, 0, 0, rz, "TEMPVEH")
	setElementDimension(tempVehicle, dimension)
	setElementInterior(tempVehicle, int)
	warpPedIntoVehicle(thePlayer, tempVehicle)

	setElementData(tempVehicle, "vehicle:id", 0) -- Give it temp vehicle ID.
	setElementData(tempVehicle, "vehicle:vehid", libID) -- Vehicle library ID. (If it already exists)
	setElementData(tempVehicle, "tempveh:vehid", vehID) -- GTA vehicle model ID.
	setElementData(tempVehicle, "vehicle:type", vehType)
	setElementData(tempVehicle, "tempveh:year", yearOrData)
	setElementData(tempVehicle, "tempveh:brand", brandValue)
	setElementData(tempVehicle, "tempveh:model", modelValue)
	setElementData(tempVehicle, "tempveh:price", priceValue)
	setElementData(tempVehicle, "tempveh:dealership", dealershipID)
	setElementData(tempVehicle, "tempveh:tax", vehTax)

	if not (isNewVehicle) then
		local propertyTable = { "numberOfGears", "maxVelocity", "engineAcceleration", "engineInertia", "driveType", "engineType", "steeringLock", "collisionDamageMultiplier", "mass", "turnMass", "dragCoeff", "centerOfMass", "percentSubmerged", "animGroup", "seatOffsetDistance", "tractionMultiplier", "tractionLoss", "tractionBias", "brakeDeceleration", "brakeBias", "suspensionForceLevel", "suspensionDamping", "suspensionHighSpeedDamping", "suspensionUpperLimit", "suspensionLowerLimit", "suspensionAntiDiveMultiplier", "suspensionFrontRearBias"}
		local handlingTable = fromJSON(vehData.handling)
		for i, property in ipairs(propertyTable) do
			setVehicleHandling(tempVehicle, property, handlingTable[i])
		end
	else
		triggerClientEvent(thePlayer, "vehicle:modding:drawsidebar", thePlayer, isNewVehicle)
	end
end
addEvent("vehicle:s_makeEditorVehicle", true)
addEventHandler("vehicle:s_makeEditorVehicle", root, makeEditorVehicle)

function cancelVehCreation(thePlayer, vehicle)
	local tempVeh = getPedOccupiedVehicle(thePlayer) or vehicle
	if (tempVeh) then destroyElement(tempVeh) end

	outputChatBox("You have cancelled the vehicle editor.", thePlayer, 255, 0, 0)
end
addEvent("vehicle:cancelvehcre", true)
addEventHandler("vehicle:cancelvehcre", root, cancelVehCreation)

function saveVehCreation(thePlayer)
	local tempVeh = getPedOccupiedVehicle(thePlayer)

	if not (tempVeh) then
		outputChatBox("ERROR: Unable to save vehicle handling data. Are you in the vehicle?", thePlayer, 255, 0, 0)
		return false
	end

	local vehID = getElementData(tempVeh, "tempveh:vehid")
	local year = getElementData(tempVeh, "tempveh:year")
	local model = getElementData(tempVeh, "tempveh:model")
	local brand = getElementData(tempVeh, "tempveh:brand")
	local price = getElementData(tempVeh, "tempveh:price")
	local dealership = getElementData(tempVeh, "tempveh:dealership")
	local vehType = getElementData(tempVeh, "vehicle:type")
	local handlingData = getElementData(tempVeh, "tempveh:handling")
	if not (handlingData) then -- If handling wasn't adjusted during vehicle creation.
		handlingData = getVehicleHandling(tempVeh); handlingData = toJSON(handlingData)
	end
	local tax = getElementData(tempVeh, "tempveh:tax")

	-- Destroy the vehicle and all attached data.
	destroyElement(tempVeh)

	local accountID = getElementData(thePlayer, "account:id")
	local timeNow = global:getCurrentTime()

	-- Creation and logging.
	local query = exports.mysql:Execute("INSERT INTO `vehicle_database` (`id`, `vehid`, `brand`, `model`, `year`, `price`, `tax`, `created_date`, `createdby`, `last_updated`, `updatedby`, `handling`, `dealership`, `type`) VALUES (NULL, (?), (?), (?), (?), (?), (?), (?), (?), (?), (?), (?), (?), (?));", vehID, brand, model, year, price, tax, timeNow[3], accountID, timeNow[3], accountID, handlingData, dealership, vehType)
	outputChatBox("You have saved the vehicle '(" .. vehID .. ") " .. year .. " " .. brand .. " " .. model .. "'.", thePlayer, 75, 230, 10)

	local thePlayerName = global:getStaffTitle(thePlayer, 1)
	local priceFormatted = global:formatNumber(price)
	global:sendMessageToManagers("[INFO] " .. thePlayerName .. " has saved a new vehicle into the vehicle library.", true)
	global:sendMessageToManagers("[INFO] Vehicle info: (" .. vehID .. ") " .. year .. " " .. brand .. " " .. model .. " | Price: $" .. priceFormatted .. " | Dealership: " .. dealership, true)

	exports.logs:addLog(thePlayer, 2, thePlayer, "Created vehicle: '" .. year .. " " .. brand .. " " .. model .. "' | Price: $" .. priceFormatted .. " | Dealership: " .. dealership)
end
addEvent("vehicle:savevehcre", true)
addEventHandler("vehicle:savevehcre", root, saveVehCreation)