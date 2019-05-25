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

local blackhawk = exports.blackhawk

-- Takes the given player and checks if they are at a gas station with the provided vehicle.
function isAtGasStation(thePlayer, theVehicle)
	local reason = "You aren't next to a vehicle to refuel."
	local isAtStation = false
	if (thePlayer) and (theVehicle) then
		local px, py, pz = getElementPosition(thePlayer)
		for i, station in ipairs(g_fuelStations) do
			local x, y, z, radius = unpack(g_fuelStations[i]["pos"])

			if getDistanceBetweenPoints3D(x, y, z, px, py, pz) < radius then
				isAtStation = i
				break
			end
		end

		if (isAtStation) then
			local vx, vy, vz = getElementPosition(theVehicle)
			if (getDistanceBetweenPoints3D(vx, vy, vz, px, py, pz) < 5) then
				if not getPedOccupiedVehicle(thePlayer) then
					local engineState = getElementData(theVehicle, "vehicle:engine")
					if (engineState == 0) then
						return isAtStation
					else reason = "You need to turn the vehicle engine off first." end
				else reason = "You need to get out of the vehicle to refuel it!" end
			end
		else reason = "You aren't at a gas station." end
	end
	return false, reason
end

-- /refuel - By Skully (24/05/18) [Player]
function refuelVehicle(thePlayer)
	local loggedin = getElementData(thePlayer, "loggedin")
	if (loggedin == 1) then

		local theVehicle = exports.global:getNearestElement(thePlayer, "vehicle", 4)

		-- If there isn't any vehicle nearby.
		if not (theVehicle) then
			outputChatBox("There is no vehicle nearby to refuel!", thePlayer, 255, 0, 0)
			return false
		end

		-- Check if player is within a gas station.
		local fuelStation, reason = isAtGasStation(thePlayer, theVehicle)
		if not (fuelStation) then
			outputChatBox(reason, thePlayer, 255, 0, 0)
			return false
		end

		local isVehRefueling = getElementData(theVehicle, "temp:fuel:isfueling")
		if isVehRefueling then
			outputChatBox("This vehicle is already being refuelled by " .. getPlayerName(isVehRefueling):gsub("_", " ") .. "!", thePlayer, 255, 0, 0)
			return false
		end

		-- Check to see if player has keys. @requires item-system
		local canRefuelVehicle = true -- set this to false when item-system check is done.
		local vehicleOwner = getElementData(theVehicle, "vehicle:owner")
		if (vehicleOwner < 0) then -- If the vehicle is faction owned.
			if exports.global:isPlayerInFaction(thePlayer, -vehicleOwner) then
				canRefuelVehicle = true
			end
		end

		if not (canRefuelVehicle) then
			outputChatBox("You don't have the keys to this vehicle.", thePlayer, 255, 0, 0)
			return false
		end

		-- Check if vehicle is a temporary one.
		local theVehicleID = getElementData(theVehicle, "vehicle:id")
		if not (theVehicleID) or (theVehicleID == 0) then
			outputChatBox("ERROR: You cannot refuel temporary vehicles.", thePlayer, 255, 0, 0)
			return false
		end

		-- Check to see if the vehicle is electric.
		local vehicleEngineType = getVehicleHandling(theVehicle)["engineType"]
		if (vehicleEngineType == "electric") then
			outputChatBox("How do you plan on fuelling an electric vehicle?", thePlayer, 255, 0, 0)
			return false
		end


		local vehicleType = getElementData(theVehicle, "vehicle:type") or 20
		local tankSize = exports["vehicle-system"]:getTankSize(vehicleType)

		-- If vehicle is already full on fuel.
		local vehicleFuel = getElementData(theVehicle, "vehicle:fuel") or 0
		if (vehicleFuel >= tankSize) then
			outputChatBox("This vehicle still has plenty of fuel in it!", thePlayer, 255, 0, 0)
			return false
		end

		setElementData(thePlayer, "temp:refueling", theVehicleID)
		setElementData(theVehicle, "temp:fuel:isfueling", thePlayer, false)
		triggerClientEvent(thePlayer, "fuel:showRefuelGUI", thePlayer, vehicleFuel, fuelStation, tankSize)
	end
end
addEvent("fuel:refuelCall", true)
addEventHandler("fuel:refuelCall", root, refuelVehicle)

function isDoneRefueling(thePlayer, totalPrice, newFuel, fuelType)
	outputChatBox("You have refueled your vehicle for $" .. math.ceil(totalPrice) .. ".", thePlayer, 75, 230, 10)
	local theVehicleID = getElementData(thePlayer, "temp:refueling")

	local theVehicle = exports.data:getElement("vehicle", theVehicleID)
	removeElementData(thePlayer, "temp:refueling")
	removeElementData(theVehicle, "temp:fuel:isfueling")

	-- If vehicle fuel type doesn't match, set a timer to fuck the engine shortly.
	if (fuelType == 1) then fuelType = "petrol" else fuelType = "diesel" end
	local vehicleFuelType = getVehicleHandling(theVehicle)["engineType"]
	if (fuelType ~= vehicleFuelType) and (newFuel > 15) then -- If vehicle fuel types don't match and 20L+ is added.
		local randomTime = math.random(30000, 120000) -- Random time between 30 and 120 seconds.
		setTimer(function()
			blackhawk:changeElementDataEx(theVehicle, "vehicle:engine", 0, true) -- Turn engine state off.
			blackhawk:changeElementDataEx(theVehicle, "vehicle:brokenengine", 1, true) -- Break vehicle engine.
			blackhawk:changeElementDataEx(theVehicle, "vehicle:fuel", 0, true) -- Empty fuel tank.
			setElementHealth(theVehicle, 300) -- Make the vehicle smoke.
			local theVehicleName = getElementData(theVehicle, "vehicle:name")
			triggerEvent("rp:sendLocalRP", theVehicle, theVehicle, "do", "The vehicle engine sputters and comes to a halt, the sound of moving liquid comes from beneath the vehicle. (( " .. theVehicleName .. " ))")
			setVehicleEngineState(theVehicle, false)
		end, 15000, 1)
		local thePlayerName = getPlayerName(thePlayer):gsub("_", " ")
		exports.logs:addVehicleLog(theVehicleID, "[ENGINE BREAK] " .. thePlayerName .. " has broken the vehicle engine since\n" .. fuelType .. " was fueled into this " .. vehicleFuelType .. " vehicle.", thePlayer)
		return
	end

	local oldFuel = getElementData(theVehicle, "vehicle:fuel")
	local newFuelValue = math.ceil(oldFuel + newFuel)
	blackhawk:changeElementDataEx(theVehicle, "vehicle:fuel", newFuelValue, true)

	-- Deduct cost from player, math.ceil(totalPrice) @requires item-system
end
addEvent("fuel:doneRefueling", true)
addEventHandler("fuel:doneRefueling", root, isDoneRefueling)

-- Function used by client to remove elementData when player exits GUI and hasn't refueled.
addEvent("refuel:removedata", true)
addEventHandler("refuel:removedata", root, function()
	local vehID = getElementData(source, "temp:refueling")
	if vehID then
		removeElementData(source, "temp:refueling")
		local veh = exports.data:getElement("vehicle", vehID)
		if veh then removeElementData(veh, "temp:fuel:isfueling") end
	end
end)