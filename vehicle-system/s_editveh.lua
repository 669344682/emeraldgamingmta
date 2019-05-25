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

local propertyTable = {
	"numberOfGears",
	"maxVelocity",
	"engineAcceleration",
	"engineInertia",
	"driveType",
	"engineType",
	"steeringLock",
	"collisionDamageMultiplier",
	"mass",
	"turnMass",
	"dragCoeff",
	"centerOfMass",
	"percentSubmerged",
	"animGroup",
	"seatOffsetDistance",
	"tractionMultiplier",
	"tractionLoss",
	"tractionBias",
	"brakeDeceleration",
	"brakeBias",
	"suspensionForceLevel",
	"suspensionDamping",
	"suspensionHighSpeedDamping",
	"suspensionUpperLimit",
	"suspensionLowerLimit",
	"suspensionAntiDiveMultiplier",
	"suspensionFrontRearBias",
}

function saveVehicleSettings(thePlayer, theVehicle, handlingTable, modelFlagsTable, handlingFlagsTable, fromCreation)
	-- Apply all changes to vehicle.
	for i, property in ipairs(propertyTable) do
		setVehicleHandling(theVehicle, property, handlingTable[i])
	end

	exports.blackhawk:changeElementDataEx(theVehicle, "fuel:consumption", tonumber(handlingTable[28]))
	local parsedTable = toJSON(handlingTable)
	if (fromCreation) then -- If editing a vehicle from /createveh.
		setElementData(theVehicle, "tempveh:handling", parsedTable)
		return true
	end

	local theVehicleID = getElementData(theVehicle, "vehicle:id")

	local saved = exports.mysql:Execute("UPDATE `vehicles` SET `handling` = (?) WHERE `id` = (?);", parsedTable, theVehicleID)
	if (saved) then
		local _, vehicleName = exports.global:getVehicleInfo(theVehicleID)
		local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
		exports.logs:addVehicleLog(theVehicleID, "[MODIFICATION] Vehicle modified by " .. thePlayerName .. ".", thePlayer)
		outputChatBox("You have saved changes to the vehicle '" .. vehicleName .. "' [VIN #" .. theVehicleID .. "].", thePlayer, 0, 255, 0)
		outputChatBox("Remember to /checkveh " .. theVehicleID .. " and document your adjustments.", thePlayer, 0, 255, 0)
		exports.global:sendMessageToManagers("[WARN] " .. thePlayerName .. " has edited vehicle #" .. theVehicleID .. " (" .. vehicleName ..").", true)
	else
		outputChatBox("ERROR: Failed to save modifications, contact a developer to obtain lost vehicle changes.", thePlayer, 255, 0, 0)
		exports.global:outputDebug("@saveVehicleSettings: " .. thePlayerName .. " failed to save vehicle settings, is there an active database connection?")
		exports.global:outputDebug("@saveVehicleSettings: Passed handling table: " .. parsedTable)
	end
end
addEvent("vehicle:modding:saveVehicleSettings", true)
addEventHandler("vehicle:modding:saveVehicleSettings", root, saveVehicleSettings)

function applyVehicleSettings(theVehicle, handlingTable, modelFlagsTable, handlingFlagsTable)
	-- Apply changes to vehicle.
	for i, property in ipairs(propertyTable) do
		setVehicleHandling(theVehicle, property, handlingTable[i])
	end

	-- Set vehicle fuel consumption.
	exports.blackhawk:changeElementDataEx(theVehicle, "fuel:consumption", tonumber(handlingTable[28]))
end
addEvent("vehicle:modding:applyVehicleSettings", true)
addEventHandler("vehicle:modding:applyVehicleSettings", root, applyVehicleSettings)

function discardVehicleChanges(thePlayer, theVehicle)
	local theVehicleID = getElementData(theVehicle, "vehicle:id")
	triggerEvent("vehicle:reloadvehcall", thePlayer, thePlayer, "reloadveh", theVehicleID)

	setTimer(function()
		local vehRenewed = exports.data:getElement("vehicle", theVehicleID)
		local x, y, z = getElementPosition(thePlayer)
		local thePlayerInterior = getElementInterior(thePlayer)
		local thePlayerDimension = getElementDimension(thePlayer)

		setElementPosition(vehRenewed, x, y, z)
		setElementInterior(vehRenewed, thePlayerInterior)
		setElementDimension(vehRenewed, thePlayerDimension)
		warpPedIntoVehicle(thePlayer, vehRenewed)
	end, 300, 1)
end
addEvent("vehicle:modding:discardVehicleChanges", true)
addEventHandler("vehicle:modding:discardVehicleChanges", root, discardVehicleChanges)

function editVehicle(thePlayer, c)
	if exports.global:isPlayerManager(thePlayer) or exports.global:isPlayerVehicleTeamLeader(thePlayer) or (c == "gui") then
		local theVehicle = getPedOccupiedVehicle(thePlayer)
		local realInVehicle = getElementData(thePlayer, "character:invehicle")
		if (theVehicle) and (realInVehicle) then
			local vehicleID = getElementData(theVehicle, "vehicle:id")
			if (tonumber(vehicleID) == 0) and not (c) then -- If editing a temporary vehicle and it's not a /makeveh vehicle.
				outputChatBox("ERROR: You cannot edit temporary vehicles.", thePlayer, 2550, 0, 0)
				return false
			end
			
			local thePlayerDim = getElementDimension(thePlayer)
			if (thePlayerDim ~= 22220) and not exports.global:isPlayerLeadManager(thePlayer, true) then
				outputChatBox("ERROR: You must be in /vtdim before editing vehicle!", thePlayer, 255, 0, 0)
				return false
			end

			local handlingData = getVehicleHandling(theVehicle)
			local isVehicleCustom = exports.mysql:QueryString("SELECT `handling` FROM `vehicles` WHERE `id` = (?);", vehicleID)
			local fromCreation = false; if (c == "gui") then fromCreation = true end -- If this is being triggered from /makeveh.

			local fuelConsumption = 1
			if (isVehicleCustom) then
				fuelConsumption = fromJSON(isVehicleCustom)[28]
			else
				local vehicleModelID = getElementData(theVehicle, "vehicle:vehid")
				if (vehicleModelID) and (vehicleModelID ~= 0) then
					local modelConsumption = exports.mysql:QueryString("SELECT `handling` FROM `vehicle_database` WHERE `id` = (?);", vehicleModelID)
					fuelConsumption = fromJSON(modelConsumption)[28]
				end
			end

			triggerClientEvent(thePlayer, "vehicle:modding:showVehicleEditor", thePlayer, {handlingData, isVehicleCustom, fuelConsumption}, fromCreation)
		else
			outputChatBox("ERROR: You must be inside a vehicle to edit it!", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("editveh", editVehicle)
addCommandHandler("editvehicle", editVehicle)
addEvent("vehicle:modding:editVehicle", true)
addEventHandler("vehicle:modding:editVehicle", root, editVehicle) -- Used by vehicle editor sidebar GUI.

function unsetCustomVehicle()
	local thePlayer = client
	local theVehicle = getPedOccupiedVehicle(thePlayer)
	if (theVehicle) then -- If the vehicle exists.
		local vehicleID = getElementData(theVehicle, "vehicle:id")
		if (vehicleID) and (vehicleID ~= 0) then -- If the vehicle isn't a temporary one.
			local unset = exports.mysql:Execute("UPDATE `vehicles` SET `handling` = NULL WHERE `id` = (?);", vehicleID)
			if (unset) then
				outputChatBox("You have successfully unset all if vehicle #" .. vehicleID .. "'s custom properties.", thePlayer, 75, 230, 10)
				local loaded, reason = exports["vehicle-system"]:reloadVehicle(vehicleID)
				if not (loaded) then
					outputChatBox("An error occurred whilst loading the vehicle back in: " .. reason, thePlayer, 255, 0, 0)
				end
			end

			-- Set a timer to teleport the player back into the vehicle after reloading it.
			setTimer(function()
				local vehRenewed = exports.data:getElement("vehicle", vehicleID)
				local x, y, z = getElementPosition(thePlayer)
				local thePlayerInterior = getElementInterior(thePlayer)
				local thePlayerDimension = getElementDimension(thePlayer)

				setElementPosition(vehRenewed, x, y, z)
				setElementInterior(vehRenewed, thePlayerInterior)
				setElementDimension(vehRenewed, thePlayerDimension)
				warpPedIntoVehicle(thePlayer, vehRenewed)
			end, 300, 1)

			-- Outputs and logs.
			local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
			exports.logs:addVehicleLog(vehicleID, "[VEHICLE MODIFICATION] Vehicle has been unset as custom and now inherits\nhandling properties from vehicle model.", thePlayer)
			exports.global:sendMessageToManagers("[INFO] " .. thePlayerName .. " has unset vehicle #" .. vehicleID .. " as custom.", true)
			return true
		end
	end
	outputChatBox("ERROR: This vehicle doesn't have hold it's own custom properties.", thePlayer, 255, 0, 0)
end
addEvent("vehicle:modding:unsetcustom", true)
addEventHandler("vehicle:modding:unsetcustom", root, unsetCustomVehicle)