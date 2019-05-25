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

local handbrakeTimer = {}
local vehExceptions = {
	[573] = true, -- Dune
	[556] = true, -- Monster Truck
	[444] = true, -- Monster Truck
}

function toggleHandbrake(thePlayer, theVehicle, forceGrounded, brakeType)
	local handbrake = getElementData(theVehicle, "vehicle:handbrake") or 0

	if (handbrake == 0) then -- If the handbrake isn't on.
		if (brakeType == "kickstand") then -- Bikes/BMX.
			if not isVehicleOnGround(theVehicle) and not forceGrounded then
				outputChatBox("You need to be on the ground and stationary to do that.", thePlayer, 255, 0, 0)
			elseif (math.floor(exports.global:getVehicleVelocity(theVehicle, thePlayer)) > 2) then
				outputChatBox("You can't do that whilst moving!", thePlayer, 255, 0, 0)
			else
				setElementData(theVehicle, "vehicle:handbrake", 1, true)
				setElementFrozen(theVehicle, true)
			end
		elseif (brakeType == "anchor") then
			if (math.floor(exports.global:getVehicleVelocity(theVehicle, thePlayer)) > 4) then
				outputChatBox("You can't do that whilst moving!", thePlayer, 255, 0, 0)
			else
				setElementData(theVehicle, "vehicle:handbrake", 1, true)
				setElementFrozen(theVehicle, true)
			end
		elseif (isVehicleOnGround(theVehicle) or forceGrounded) then
			setControlState(thePlayer, "handbrake", true)
			playHandbrakeSound(theVehicle, "on")
			setElementData(theVehicle, "vehicle:handbrake", 1, true)
			handbrakeTimer[theVehicle] = setTimer(function()
				setElementFrozen(theVehicle, true)
				setControlState(thePlayer, "handbrake", false)
			end, 3000, 1)
		end
	else
		if isTimer(handbrakeTimer[theVehicle]) then
			killTimer(handbrakeTimer[theVehicle])
			setControlState(thePlayer, "handbrake", false)
		end
		setElementData(theVehicle, "vehicle:handbrake", 0, true)
		setElementFrozen(theVehicle, false) 
		triggerEvent("vehicle:handbrake:lifted", theVehicle, thePlayer)
		if (brakeType == "handbrake") then playHandbrakeSound(theVehicle, "off") end
	end	
end
addEvent("vehicle:handbrake:lifted", true)
addEvent("vehicle:handbrake", true)
addEventHandler("vehicle:handbrake", root, function(forceGrounded, commandName) toggleHandbrake(client, source, forceGrounded, commandName) end)


function playHandbrakeSound(theVehicle, state)
	for i = 0, getVehicleMaxPassengers(theVehicle) do
		local thePlayer = getVehicleOccupant(theVehicle, i)
		if thePlayer then
			local theVehicleType = getElementData(theVehicle, "vehicle:type") or 1
			triggerClientEvent(thePlayer, "vehicles:playhandbrakesound", thePlayer, state, theVehicleType)
		end
	end
end
