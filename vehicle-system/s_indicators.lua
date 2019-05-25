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

local indicatingVehs = {} -- Table which holds vehicle timers for those that are indicating.
local indicatorSpeed = 500 -- Speed in milliseconds the indicators flash.

function stopIndicator(theVehicle)
	exports.blackhawk:setElementDataEx(theVehicle, "vehicle:indicating", 0, true)
	killTimer(indicatingVehs[theVehicle])
	indicatingVehs[theVehicle] = nil
end

function startIndicator(theVehicle)
	local indicator = getElementData(theVehicle, "vehicle:indicating")
	local driver = getVehicleOccupant(theVehicle, 0)
	if (indicator == 0) then
		stopIndicator(theVehicle)
	else
		if (indicator == 1) then -- Left indicator.
			local headlightState = getVehicleOverrideLights(theVehicle)
			if (headlightState == 2) then -- If headlights are already on.
				-- Break left-sided lights and turn headlights on.
				setVehicleLightState(theVehicle, 0, 1)
				setVehicleLightState(theVehicle, 3, 1)
				triggerClientEvent(driver, "vehicle:hud:toggleDashboardIcon", driver, 5, true)

				setTimer(function()
					-- fix left-sided lights.
					setVehicleLightState(theVehicle, 0, 0)
					setVehicleLightState(theVehicle, 3, 0)
					setVehicleOverrideLights(theVehicle, 2)
					triggerClientEvent(driver, "vehicle:hud:toggleDashboardIcon", driver, 5, false)
				end, indicatorSpeed, 1)
			else
				-- Break left-sided lights and turn headlights on.
				setVehicleLightState(theVehicle, 1, 1)
				setVehicleLightState(theVehicle, 2, 1)
				setVehicleOverrideLights(theVehicle, 2)
				triggerClientEvent(driver, "vehicle:hud:toggleDashboardIcon", driver, 5, true)

				setTimer(function()
					-- fix left-sided lights.
					setVehicleLightState(theVehicle, 1, 0)
					setVehicleLightState(theVehicle, 2, 0)
					setVehicleOverrideLights(theVehicle, 1)
					triggerClientEvent(driver, "vehicle:hud:toggleDashboardIcon", driver, 5, false)
				end, indicatorSpeed, 1)
			end
		elseif (indicator == 2) then -- Right indicator.
			local headlightState = getVehicleOverrideLights(theVehicle)
			if (headlightState == 2) then -- If headlights are already on.
				-- Break right-sided lights and turn headlights on.
				setVehicleLightState(theVehicle, 1, 1)
				setVehicleLightState(theVehicle, 2, 1)
				triggerClientEvent(driver, "vehicle:hud:toggleDashboardIcon", driver, 5, true)

				setTimer(function()
					-- fix right-sided lights.
					setVehicleLightState(theVehicle, 1, 0)
					setVehicleLightState(theVehicle, 2, 0)
					setVehicleOverrideLights(theVehicle, 2)
					triggerClientEvent(driver, "vehicle:hud:toggleDashboardIcon", driver, 5, false)
				end, indicatorSpeed, 1)
			else
				-- Break right-sided lights and turn headlights on.
				setVehicleLightState(theVehicle, 0, 1)
				setVehicleLightState(theVehicle, 3, 1)
				setVehicleOverrideLights(theVehicle, 2)
				triggerClientEvent(driver, "vehicle:hud:toggleDashboardIcon", driver, 5, true)

				setTimer(function()
					-- fix right-sided lights.
					setVehicleLightState(theVehicle, 0, 0)
					setVehicleLightState(theVehicle, 3, 0)
					setVehicleOverrideLights(theVehicle, 1)
					triggerClientEvent(driver, "vehicle:hud:toggleDashboardIcon", driver, 5, false)
				end, indicatorSpeed, 1)
			end
		elseif (indicator == 3) then -- Hazards.
			local headlightState = getVehicleOverrideLights(theVehicle)
			if (headlightState == 2) then -- If headlights are already on.
				-- Turn headlights off.
				setVehicleOverrideLights(theVehicle, 1)
				triggerClientEvent(driver, "vehicle:hud:toggleDashboardIcon", driver, 2, true)
				setTimer(function()
					-- Turn lights back on.
					triggerClientEvent(driver, "vehicle:hud:toggleDashboardIcon", driver, 2, false)
					setVehicleOverrideLights(theVehicle, 2)
				end, indicatorSpeed, 1)
			else
				-- Turn headlights on.
				setVehicleOverrideLights(theVehicle, 2)
				triggerClientEvent(driver, "vehicle:hud:toggleDashboardIcon", driver, 2, true)
				setTimer(function()
					-- Turn lights off again.
					triggerClientEvent(driver, "vehicle:hud:toggleDashboardIcon", driver, 2, false)
					setVehicleOverrideLights(theVehicle, 1)
				end, indicatorSpeed, 1)
			end
		end
	end
end

function handleIndicateLeft()
	local theVehicle = getPedOccupiedVehicle(source)
	local engineState = getElementData(theVehicle, "vehicle:engine") or 0
	if theVehicle and (engineState == 1) then
		local indicatorState = getElementData(theVehicle, "vehicle:indicating") or 0
		if (indicatorState ~= 1) and not isTimer(indicatingVehs[theVehicle]) then
			exports.blackhawk:setElementDataEx(theVehicle, "vehicle:indicating", 1, true)
			indicatingVehs[theVehicle] = setTimer(startIndicator, indicatorSpeed * 2, 0, theVehicle)
		else
			stopIndicator(theVehicle)
		end
	end
end
addEvent("vehicle:indicate:left", true)
addEventHandler("vehicle:indicate:left", root, handleIndicateLeft)

function handleIndicateRight()
	local theVehicle = getPedOccupiedVehicle(source)
	local engineState = getElementData(theVehicle, "vehicle:engine") or 0
	if theVehicle and (engineState == 1) then
		local indicatorState = getElementData(theVehicle, "vehicle:indicating") or 0
		if (indicatorState ~= 2) and not isTimer(indicatingVehs[theVehicle]) then
			exports.blackhawk:setElementDataEx(theVehicle, "vehicle:indicating", 2, true)
			indicatingVehs[theVehicle] = setTimer(startIndicator, indicatorSpeed * 2, 0, theVehicle)
		else
			stopIndicator(theVehicle)
		end
	end
end
addEvent("vehicle:indicate:right", true)
addEventHandler("vehicle:indicate:right", root, handleIndicateRight)

function handleIndicateHazards()
	local theVehicle = getPedOccupiedVehicle(source)
	local engineState = getElementData(theVehicle, "vehicle:engine") or 0
	if theVehicle and (engineState == 1) then
		local indicatorState = getElementData(theVehicle, "vehicle:indicating") or 0
		if (indicatorState ~= 3) and not isTimer(indicatingVehs[theVehicle]) then
			exports.blackhawk:setElementDataEx(theVehicle, "vehicle:indicating", 3, true)
			indicatingVehs[theVehicle] = setTimer(startIndicator, indicatorSpeed * 2, 0, theVehicle)
		else
			stopIndicator(theVehicle)
		end
	end
end
addEvent("vehicle:indicate:hazards", true)
addEventHandler("vehicle:indicate:hazards", root, handleIndicateHazards)

-- Exported function.
function stopIndicatorsCall(theVehicle) if indicatingVehs[theVehicle] then stopIndicator(theVehicle) end end