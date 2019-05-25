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

-- Function to reduce fuel in vehicles that are currently occupied.
function vehicleFuelUsage()
	local allPlayers = getElementsByType("player")
	for i, thePlayer in ipairs(allPlayers) do
		if isPedInVehicle(thePlayer) then -- If player is in vehicle.
			local theVehicle = getPedOccupiedVehicle(thePlayer)
			local realInVehicle = getElementData(thePlayer, "character:invehicle") or 0
			if (theVehicle) and (realInVehicle) then -- If player is in vehicle.
				local theVehicleID = getElementData(theVehicle, "vehicle:id") or 0
				if (theVehicleID ~= 0) then -- If the vehicle is not a temporary one.
					local seat = getPedOccupiedVehicleSeat(thePlayer)
					if (seat == 0) then -- Player in driver seat of vehicle.
						local vehicleType = getElementData(theVehicle, "vehicle:type") or 20 -- Other.
						local tankSize = exports["vehicle-system"]:getTankSize(vehicleType)
						if (tankSize) then -- Vehicle has a fuel tank.
							local engineState = getElementData(theVehicle, "vehicle:engine") or 0
							if (engineState == 1) then -- Engine is on.
								local fuel = getElementData(theVehicle, "vehicle:fuel") or 100
								if (fuel > 0) then -- If vehicle has fuel.
									
									local x, y, z = getElementPosition(theVehicle)
									local ox, oy, oz = unpack(getElementData(theVehicle, "fuel:oldpos") or {x, y, z})
									
									local hasNotMoved = math.abs(oz - z) > 50 or math.abs(oy - y) > 1000 or math.abs(ox - x) > 1000
									
									if not hasNotMoved then
										-- Fuel drains whilst vehicle is on though not moving.
										local distanceTravelled = getDistanceBetweenPoints2D(x, y, ox, oy)
										if (distanceTravelled < 10) then
											distanceTravelled = 10
										end

										local vehicleMass = getVehicleHandling(theVehicle)["mass"]
										local fuelConsumption = getElementData(theVehicle, "fuel:consumption") or 1
										local newFuel = fuel

										newFuel = (distanceTravelled / 400) + (vehicleMass / 20000)
										local deduc = (((newFuel / 100) * tankSize) * fuelConsumption) -- TEMP
										newFuel = fuel - (((newFuel / 100) * tankSize) * fuelConsumption)

										blackhawk:setElementDataEx(theVehicle, "vehicle:fuel", newFuel)
										-- Trigger function to update client fuel. (send newFuel)
										--outputDebugString("[#" .. theVehicleID .. "] fuel consumption: " .. fuelConsumption .. " / distance: " .. distanceTravelled, 3)
										--outputDebugString("[#" .. theVehicleID .. "] oldFuel: " .. fuel .. " / newFuel: " .. newFuel .. " / deduction: " .. deduc, 3)

										-- If the vehicle has run out of fuel.
										if (newFuel <= 0) then
											setVehicleEngineState(theVehicle, false)
											blackhawk:setElementDataEx(theVehicle, "vehicle:engine", 0)
											blackhawk:setElementDataEx(theVehicle, "vehicle:fuel", 0) -- Set fuel to a rounded off flat 0.
											toggleControl(thePlayer, "brake_reverse", false)
										end
									end
									blackhawk:changeElementDataEx(theVehicle, "fuel:oldpos", {x, y, z}, false)
								end
							end
						end
					end
				end
			end
		end
	end
end
setTimer(vehicleFuelUsage, 20000, 0) -- Every 20 seconds. (20000)

-- Function to reduce fuel in vehicles that have engines on and are unoccupied.
function emptyVehiclesFuelUsage()
	local allVehicles = exports.data:getDataElementsByType("vehicle")
	for i, theVehicle in ipairs(allVehicles) do
		local engineState = getElementData(theVehicle, "vehicle:engine") or 0
		local tempVehicle = getElementData(theVehicle, "vehicle:id") or 0
		if (engineState == 1) and (tempVehicle ~= 0) then -- If the vehicle engine is on.
			if not getVehicleOccupant(theVehicle) then -- If the vehicle isn't occupied.
				local vehicleFuel = getElementData(theVehicle, "vehicle:fuel") or 100
				local vehicleType = getElementData(theVehicle, "vehicle:type") or 20 -- Other.
				local tankSize = exports["vehicle-system"]:getTankSize(vehicleType)
				if (vehicleFuel > 0) and (tankSize) then -- If the vehicle still has fuel and has a fuel tank.
					local fuelConsumption = getElementData(theVehicle, "fuel:consumption") or 1
					--outputDebugString("[" .. tempVehicle .. "] " .. ((0.009 * tankSize) * fuelConsumption) .. " deducted @ fuelConsumption: " .. fuelConsumption)
					local newFuel = vehicleFuel - ((0.009 * tankSize) * fuelConsumption)
					blackhawk:changeElementDataEx(theVehicle, "vehicle:fuel", newFuel, false)

					if (newFuel <= 0) then -- If the vehicle has run out of fuel.
						-- Turn the engine off.
						setVehicleEngineState(theVehicle, false)
						blackhawk:changeElementDataEx(theVehicle, "vehicle:engine", 0, false)
						blackhawk:setElementDataEx(theVehicle, "vehicle:fuel", 0) -- Set fuel to a rounded off flat 0.
						newFuel = 0
					end
				end
			end
		end
	end
end
setTimer(emptyVehiclesFuelUsage, 240000, 0) -- Every 4 minutes. (240000)