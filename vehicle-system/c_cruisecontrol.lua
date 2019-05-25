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

local isCCEnabled = false
local rVehicleSpeed = 0 -- The vehicle speed currently requested by cruise control.

function calculateHeading(aTheVehicle)
	local x, y, z = getElementVelocity(aTheVehicle)
	local modulus = math.sqrt(x * x + y * y)
	if not isVehicleOnGround(aTheVehicle) then return 0, modulus end

	local rx, ry, rz = getElementRotation(aTheVehicle)
	local sin, cos = -math.sin(math.rad(rz)), math.cos(math.rad(rz))
	local cx = (sin * x + cos * y) / modulus
	return math.deg(math.acos(cx)) * 0.5, modulus
end

function startCruiseControl()
	local theVehicle = getPedOccupiedVehicle(localPlayer)
	if not isElement(theVehicle) or not getVehicleEngineState(theVehicle) then stopCruiseControl() return false end
	local x, _ = calculateHeading(theVehicle)
	if (x < 5) then
		local vehicleSpeed = getElementSpeed(theVehicle)
		if (vehicleSpeed > rVehicleSpeed) then setPedControlState(localPlayer, "accelerate", false)
			elseif (vehicleSpeed < rVehicleSpeed) then setPedControlState(localPlayer, "accelerate", true)
		end
	end
end

function activateCruiseControl()
	addEventHandler("onClientRender", root, startCruiseControl)
	isCCEnabled = true
	forceBinds()
	local ccSound = playSound("sounds/cc_engaged.mp3")
	setSoundVolume(ccSound, 0.3)
	triggerEvent("vehicle:hud:toggleDashboardIcon", localPlayer, 1, true)
end

function stopCruiseControl()
	removeEventHandler("onClientRender", root, startCruiseControl)
	setPedControlState(localPlayer, "accelerate", false)
	isCCEnabled = false
	triggerEvent("vehicle:hud:toggleDashboardIcon", localPlayer, 1, false)
end

function applyCruiseControl()
	local theVehicle = getPedOccupiedVehicle(localPlayer)
	if not (theVehicle) then return end
	if (getVehicleOccupant(theVehicle) == localPlayer) then
		if getVehicleEngineState(theVehicle) then
			if (isCCEnabled) then -- Stop cruise control if it's already on.
				stopCruiseControl()
			else
				rVehicleSpeed = getElementSpeed(theVehicle)
				if rVehicleSpeed > 10 then
					local vehicleType = getVehicleType(theVehicle)
					if (vehicleType == "Automobile") or (vehicleType == "Boat") or (vehicleType == "Train") or (vehicleType == "Helicopter") or (vehicleType == "Plane") then
						outputChatBox("Cruise control enabled, use + and - to adjust speed.", 75, 230, 10)
						activateCruiseControl()
					end
				end
			end
		end
	end
end
addEventHandler("onClientPlayerVehicleExit", localPlayer, function(_, seat) if (seat == 0) then if (isCCEnabled) then stopCruiseControl() end end end)

function increaseCruiseControl() if (isCCEnabled) then rVehicleSpeed = rVehicleSpeed + 10 end end
function decreaseCruiseControl() if (isCCEnabled) then rVehicleSpeed = rVehicleSpeed - 10 end end
function startCC() if (isCCEnabled) then stopCruiseControl() end end
function stopCC() if (isCCEnabled) then stopCruiseControl() end end
function forceBinds() bindKey("brake_reverse", "down", stopCC); bindKey("accelerate", "down", startCC) end

function ccStart()
	bindKey("c", "down", applyCruiseControl)
	bindKey("=", "down", increaseCruiseControl)
	bindKey("-", "down", decreaseCruiseControl)
	bindKey("num_add", "down", increaseCruiseControl)
	bindKey("num_sub", "down", decreaseCruiseControl)
	
	addCommandHandler("cc", applyCruiseControl)
	addCommandHandler("cruisecontrol", applyCruiseControl)
	forceBinds()
end
addEventHandler("onClientResourceStart", resourceRoot, ccStart)