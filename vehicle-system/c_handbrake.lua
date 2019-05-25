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

function playHandbrakeSound(state, type)
	local soundType = g_vehicleTypes[type].handbrake

	if state == "off" then
		local sound = playSound("sounds/handbrake/release_handbrake.mp3")
		if sound then
			setSoundVolume(sound, 0.5)
		end
	else
		if (soundType) then
			local sound = playSound("sounds/handbrake/" .. soundType)
			if sound then
				setSoundVolume(sound, 0.8)
			end
		end
	end
end
addEvent("vehicles:playhandbrakesound", true)
addEventHandler("vehicles:playhandbrakesound", root, playHandbrakeSound)

local function checkVelocity(veh)
	local x, y, z = getElementVelocity(veh)
	return math.abs(x) < 0.05 and math.abs(y) < 0.05 and math.abs(z) < 0.05
end

-- /handbrake - By Skully (19/05/18) [Player]
function handbrakeVehicle()
	if isPedInVehicle (localPlayer) then
		local playerVehicle = getPedOccupiedVehicle(localPlayer)
		if (getVehicleOccupant(playerVehicle, 0) == localPlayer) then
			-- Prevent vehicles in interiors moving.
			local brakeType = "handbrake"
			local vehicleType = getVehicleType(playerVehicle)
			if (vehicleType == "BMX") or (vehicleType == "Bike") then
				brakeType = "kickstand"
			elseif (vehicleType == "Boat") then
				brakeType = "anchor"
			elseif (vehicleType == "Plane") or (vehicleType == "Helicopter") or (vehicleType == "Train") then
				return
			end

			local forceGrounded = getElementDimension(playerVehicle) > 0 and checkVelocity(playerVehicle)
			triggerServerEvent("vehicle:handbrake", playerVehicle, forceGrounded, brakeType)
		end
	end
end
addCommandHandler("handbrake", handbrakeVehicle)

function handbrakePressed(button, press)
	if button == "g" and (press) then
		handbrakeVehicle()
		cancelEvent()
	end
end

function bindHandbrakeOnStart()
	bindKey("g", "down", handbrakePressed)
end
addEventHandler("onClientResourceStart", resourceRoot, bindHandbrakeOnStart)

addEventHandler("onClientVehicleStartExit", root,
function(player)
	if player == localPlayer and not isVehicleLocked(source) and getPedControlState("handbrake") then
		setPedControlState("handbrake", false)
	end
end)
