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

-- Vehicle class types to show the HUD on, this also includes radio.
local HUD_VEHICLE_TYPES = {
	["Automobile"] = true,
	["Plane"] = true,
	["Helicopter"] = true,
	["Boat"] = true,
	["Train"] = true,
	["Trailer"] = true,
	["Monster Truck"] = true,
	["Quad"] = true,
}

function displayVehicleDashboard()
	if emGUI:dxIsWindowVisible(vehicleDashboardUI) then
		emGUI:dxCloseWindow(vehicleDashboardUI)
		removeEventHandler("onClientRender", root, renderVehicleDashboard)
	end
	if (exports["hud-system"]:isHudEnabled()) then
		local theVehicle = getPedOccupiedVehicle(localPlayer)
		local seat = getPedOccupiedVehicleSeat(localPlayer)
		local dashboardState = getElementData(localPlayer, "hud:vehicle:speedo")
		if (theVehicle) and (seat == 0) and (dashboardState ~= 0) and HUD_VEHICLE_TYPES[getVehicleType(theVehicle)] then
			vehicleDashboardUI = emGUI:dxCreateWindow(0.79, 0.68, 0.21, 0.32, "", true, true, true, true, _, 0, _, _, _, tocolor(0, 0, 0, 0))
			local dashboardImage = emGUI:dxCreateImage(0.03, 0.68, 0.94, 0.31, ":vehicle-system/images/dashboard.png", true, vehicleDashboardUI)
			
			local vehicleType = getElementData(theVehicle, "vehicle:type") or 1
			if (g_vehicleTypes[vehicleType]["tank"]) then
				local fuelGaugeImage = emGUI:dxCreateImage(0.13, 0.50, 0.32, 0.37, ":vehicle-system/images/fuel.png", true, vehicleDashboardUI)    
				emGUI:dxSetEnabled(fuelGaugeImage, false)
			end

			local disc = "disc"
			local speedType = "KM/H"
			if (dashboardState == 2) then
				disc = "discmph"
				speedType = "MPH"
			end
			speedometerImage = emGUI:dxCreateImage(0.26, 0.07, 0.64, 0.74, ":vehicle-system/images/".. disc .. ".png", true, vehicleDashboardUI)
			
			if (getVehicleType(theVehicle) == "Boat" or getVehicleType(theVehicle) == "Plane" or getVehicleType(theVehicle) == "Helicopter") then speedType = "KNOTS" end
			speedoSpeed = emGUI:dxCreateLabel(0.6, 0.6, 0.25, 0.05, "0", true, speedometerImage)
			speedoSpeedType = emGUI:dxCreateLabel(0.6, 0.7, 0.25, 0.05, speedType, true, speedometerImage)
			local tabsFont_14 = emGUI:dxCreateNewFont("fonts/tabsFont.ttf", 14)
			emGUI:dxSetFont(speedoSpeed, tabsFont_14)
			emGUI:dxSetFont(speedoSpeedType, tabsFont_14)

			emGUI:dxSetEnabled(dashboardImage, false)
			emGUI:dxSetEnabled(speedometerImage, false)

			dashboardIcons = {
				[1] = emGUI:dxCreateImage(0, 0, 1, 1, ":vehicle-system/images/dash_cc.png", true, dashboardImage),
				[2] = emGUI:dxCreateImage(0, 0, 1, 1, ":vehicle-system/images/dash_hazards.png", true, dashboardImage),
				[3] = emGUI:dxCreateImage(0, 0, 1, 1, ":vehicle-system/images/dash_lowfuel.png", true, dashboardImage),
				[4] = emGUI:dxCreateImage(0, 0, 1, 1, ":vehicle-system/images/dash_lights.png", true, dashboardImage),
				[5] = emGUI:dxCreateImage(0, 0, 1, 1, ":vehicle-system/images/dash_turnsignal.png", true, dashboardImage),
				[6] = emGUI:dxCreateImage(0, 0, 1, 1, ":vehicle-system/images/dash_seatbelt.png", true, dashboardImage),
				[7] = emGUI:dxCreateImage(0, 0, 1, 1, ":vehicle-system/images/dash_handbrake.png", true, dashboardImage),
			}

			for i, icon in ipairs(dashboardIcons) do emGUI:dxSetVisible(icon, false) end

			handleVehicleIcons()
			removeEventHandler("onClientRender", root, renderVehicleDashboard)
			addEventHandler("onClientRender", root, renderVehicleDashboard)
			addEventHandler("onClientVehicleExit", root, function(p, s)
				if (p == localPlayer) and (s == 0) then
					removeEventHandler("onClientRender", root, renderVehicleDashboard)
					if emGUI:dxIsWindowVisible(vehicleDashboardUI) then emGUI:dxCloseWindow(vehicleDashboardUI) end
				end
			end)

			addEventHandler("onClientPlayerWasted", root, function()
				if (source == localPlayer) then
					local s = getPedOccupiedVehicleSeat(localPlayer)
					if (s == 0) then
						removeEventHandler("onClientRender", root, renderVehicleDashboard)
						if emGUI:dxIsWindowVisible(vehicleDashboardUI) then emGUI:dxCloseWindow(vehicleDashboardUI) end
					end
				end
			end)
		end
	end
end

function onVehicleEnterHandler(player, seat)
	if (player == localPlayer) and (seat == 0) then
		displayVehicleDashboard()
	end
end
addEventHandler("onClientVehicleEnter", root, onVehicleEnterHandler)
addEventHandler("onClientResourceStart", resourceRoot, function()
	local seat = getPedOccupiedVehicleSeat(localPlayer)
	if (seat and seat == 0) then displayVehicleDashboard() end
end)

function renderVehicleDashboard()
	local dashboardState = getElementData(localPlayer, "hud:vehicle:speedo")
	if (dashboardState ~= 0) and not isPlayerMapVisible() and exports["hud-system"]:isHudEnabled() then
		if not (emGUI:dxIsWindowVisible(vehicleDashboardUI)) then
			displayVehicleDashboard()
			return false
		end

		local theVehicle = getPedOccupiedVehicle(localPlayer)
		if theVehicle then
			local vehSpeed = exports.global:getVehicleVelocity(theVehicle, localPlayer)
			local vehSpeedIndicator = vehSpeed
			local sW, sH = guiGetScreenSize()

			if (dashboardState == 2) then
				vehSpeedIndicator = vehSpeedIndicator * 2
				vehSpeed = vehSpeedIndicator
				if (math.ceil(vehSpeed) >= 130) then vehSpeed = 130 end
			else
				if (math.ceil(vehSpeed) >= 263) then vehSpeed = 263 end
			end

			local vx = sW + math.sin(math.rad(-(vehSpeed))) * 90
			local vy = sH + math.cos(math.rad(-(vehSpeed))) * 90
			dxDrawLine(sW - 168, sH - 195, vx - 168, vy - 195, tocolor(255, 0, 0, 255), 2, true)
			emGUI:dxSetText(speedoSpeed, math.floor(vehSpeedIndicator))

			local vehicleType = getElementData(theVehicle, "vehicle:type")
			local tankSize = g_vehicleTypes[vehicleType]["tank"]
			if (tankSize) then
				local vFuel = getElementData(theVehicle, "vehicle:fuel") or 100
				local vehicleFuel = (vFuel * 100) / tankSize
				if (vehicleFuel > 100) then vehicleFuel = 100 end
				if (vehicleFuel < 0) then vehicleFuel = 0 end
				local fx = sW + math.sin(math.rad(-(vehicleFuel) - 50)) * 50
				local fy = sH + math.cos(math.rad(-(vehicleFuel) - 50)) * 50
				dxDrawLine(sW - 301, sH - 125.5, fx - 285, fy - 116.7, tocolor(255, 0, 0, 255), 2, true)
			end

			handleVehicleIcons()
		elseif (emGUI:dxIsWindowVisible(vehicleDashboardUI)) then emGUI:dxCloseWindow(vehicleDashboardUI) end
	else
		if (emGUI:dxIsWindowVisible(vehicleDashboardUI)) then emGUI:dxCloseWindow(vehicleDashboardUI) end
	end
end

------------------------------------------------ FUNCTIONS ------------------------------------------------
function handleVehicleIcons()
	local theVehicle = getPedOccupiedVehicle(localPlayer)
	if (theVehicle) then
		-- Fuel lights.
		local vehicleFuel = getElementData(theVehicle, "vehicle:fuel") or 100
		local vehicleType = getElementData(theVehicle, "vehicle:type") or 1
		local fuelTank = g_vehicleTypes[vehicleType]["tank"]
		if fuelTank then
			local isLowFuel = ((vehicleFuel * 100) / fuelTank) < 30
			toggleDashboardIcon(3, isLowFuel)
		end

		-- Lights icon.
		local lightState = getVehicleOverrideLights(theVehicle)
		local isIndicatorLighting = getElementData(theVehicle, "vehicle:indicating") or 0
		if (lightState == 1) then
			toggleDashboardIcon(4, false)
		elseif (lightState == 2) and (isIndicatorLighting == 0) then
			toggleDashboardIcon(4, true)
		end

		-- Seatbelt icon.
		local seatbeltState = getElementData(localPlayer, "character:seatbelt")
		toggleDashboardIcon(6, not seatbeltState)

		-- Handbrake icon.
		local handbrakeState = getElementData(theVehicle, "vehicle:handbrake")
		if (handbrakeState == 0) then
			toggleDashboardIcon(7, false)
		else
			toggleDashboardIcon(7, true)
		end 
	end
end

function toggleDashboardIcon(iconID, state) emGUI:dxSetVisible(dashboardIcons[iconID], state) end
addEvent("vehicle:hud:toggleDashboardIcon", true)
addEventHandler("vehicle:hud:toggleDashboardIcon", root, toggleDashboardIcon)