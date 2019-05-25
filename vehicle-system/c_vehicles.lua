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

emGUI = exports.emGUI

-- Disable vehicle engines when player enters.
addEventHandler("onClientPlayerVehicleEnter", root, function(theVehicle, seat)
	if (seat == 0) then
		setVehicleEngineState(theVehicle, false)
	end
end)

-- Window toggling.
function toggleWindowsClient(theVehicle, state)
	setVehicleWindowOpen(theVehicle, 2, state)
	setVehicleWindowOpen(theVehicle, 3, state)
	setVehicleWindowOpen(theVehicle, 4, state)
	setVehicleWindowOpen(theVehicle, 5, state)
end
addEvent("vehicle:toggleWindowsClient", true)
addEventHandler("vehicle:toggleWindowsClient", root, toggleWindowsClient)


function playerCarLockToggleFx(state)
	local sound = playSound(state and "sounds/lock/car_inside_lock.mp3" or "sounds/lock/car_inside_unlock.mp3")
end
addEvent("vehicle:playerCarLockToggleFx", true)
addEventHandler("vehicle:playerCarLockToggleFx", root, playerCarLockToggleFx)

function playerCarLockToggleFxOutside(p)
	local sound = playSound3D("sounds/lock/car_lock.mp3", p[1], p[2], p[3])
	if (sound) then
		setSoundMaxDistance(sound, 50)
		setSoundVolume(sound, 0.7)
		setElementInterior(sound, p[4])
		setElementDimension(sound, p[5])
	end
end
addEvent("vehicle:playerCarLockToggleFxOutside", true)
addEventHandler("vehicle:playerCarLockToggleFxOutside", root, playerCarLockToggleFxOutside)

function startEngineSound(theVehicle, isTail)
	local vehType = getElementData(theVehicle, "vehicle:type")
	local ignitionType = false
	if (vehType) then ignitionType = g_vehicleTypes[vehType]["ignition"] end
	if not (ignitionType) then triggerServerEvent("vehicle:startEngineCall", localPlayer, localPlayer, theVehicle) return end

	local ignitionSound = exports["sound-manager"]:playSoundEffect(localPlayer, ":vehicle-system/sounds/engine/" .. ignitionType .. ".wav", 0.5)
	local soungLength = math.max(getSoundLength(ignitionSound) * 800, 100)
	setTimer(function()
		if not (isTail) then triggerServerEvent("vehicle:startEngineCall", localPlayer, localPlayer, theVehicle) end
	end, soungLength, 1)

	if (isTail) then
		local playerVehicle = getPedOccupiedVehicle(localPlayer)
		if (playerVehicle == theVehicle) then
			setTimer(function()
				local sound = playSound("sounds/engine/" .. ignitionType .. "_tail.wav")
			end, soungLength, 1)
		else
			local x, y, z = getElementPosition(theVehicle)
			local dim, int = getElementDimension(theVehicle), getElementInterior(theVehicle)
			local sound = playSound3D("sounds/engine/exterior_stall.wav", x, y, z)
			if (sound) then
				setSoundVolume(sound, 3)
				setElementDimension(sound, dim)
				setElementInterior(sound, int)
			end
		end
	end
end
addEvent("vehicle:startEngineSound", true)
addEventHandler("vehicle:startEngineSound", root, startEngineSound)

function getElementSpeed(theElement)
	if not isElement(theElement) then return false end
	local x, y, z = getElementVelocity(theElement)
	return (x ^ 2 + y ^ 2 + z ^ 2) ^ 0.5 * 1.61 * 100
end

-- Vehicle mileage.
setTimer(function()
	local theVehicle = getPedOccupiedVehicle(localPlayer)
	if (theVehicle) and (getVehicleType(theVehicle) ~= "Bike") then
		local vs = getElementSpeed(theVehicle)
		local om = getElementData(theVehicle, "vehicle:mileage") or 0
		setElementData(theVehicle, "vehicle:mileage", om + vs)
	end
end, 2000, 0)