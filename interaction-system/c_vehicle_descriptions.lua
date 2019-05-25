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
| |\ \\ \_/ / |____| |___| |   | |____| | | || |         	Skully
\_| \_|\___/\_____/\____/\_|   \_____/\_| |_/\_/

Created for Emerald Gaming Roleplay, do not distribute - All rights reserved. ]]

-- Function required variables.
local emGUI = exports.emGUI
local vehicleTable = {}
local RESET_TIMER
local SHOWING_DESCRIPTION = false

-- Customization variables.
local MAX_VIEW_DESC_DISTANCE = 20 -- The max distance at which vehicle descriptions can be seen.

function toggleVehicleDescriptions(b, c)
	if (c == "down") and not SHOWING_DESCRIPTION then
		addEventHandler("onClientRender", root, renderVehicleDescription)
		RESET_TIMER = setTimer(refreshNearbyVehicles, 1000, 0)
		SHOWING_DESCRIPTION = true
	else
		removeEventHandler("onClientRender", root, renderVehicleDescription)
		killTimer(RESET_TIMER)
		SHOWING_DESCRIPTION = false
	end
end
bindKey("lalt", "down", toggleVehicleDescriptions)
bindKey("lalt", "up", toggleVehicleDescriptions)

-- Right Alt sticky binding for descriptions.
function toggleVehicleDescriptionsSticky()
	if SHOWING_DESCRIPTION then
		removeEventHandler("onClientRender", root, renderVehicleDescription)
		killTimer(RESET_TIMER)
		SHOWING_DESCRIPTION = false
	else
		addEventHandler("onClientRender", root, renderVehicleDescription)
		RESET_TIMER = setTimer(refreshNearbyVehicles, 1000, 0)
		SHOWING_DESCRIPTION = true
	end
end
--bindKey("ralt", "down", toggleVehicleDescriptionsSticky)

function renderVehicleDescription()
	for i, theVehicle in ipairs(vehicleTable) do
		if isElement(theVehicle) then
			local staffOverride = exports.global:isPlayerHelper(localPlayer) or exports.global:isPlayerVehicleTeam(localPlayer)
			local toShowTable = {} -- Table containing strings of the full vehicle description to show.
			local drawHeight = 1.2
			local vehicleID = getElementData(theVehicle, "vehicle:id") or 0
			if not vehicleID or (tonumber(vehicleID) == 0) then vehicleID = "-1" end

			-- Line 1 (Vehicle name)
			local vehicleName = getElementData(theVehicle, "vehicle:name") or "Unknown Vehicle"
			table.insert(toShowTable, vehicleName)

			-- Line 2 (Vehicle owner)
			local ownerID = getElementData(theVehicle, "vehicle:owner")
			if (ownerID) == (getElementData(localPlayer, "character:id")) or staffOverride then
				local vehOwner = getElementData(theVehicle, "vehicle:ownername") or "Unknown"
				table.insert(toShowTable, "Owner: " .. vehOwner)
			end

			-- Line 3 (VIN)
			local showVIN = getElementData(theVehicle, "vehicle:showvin") or 0
			if (showVIN == 0) then
				if staffOverride then
					table.insert(toShowTable, "(( VIN: " .. vehicleID .. " ))")
				end
			else table.insert(toShowTable, "VIN: " .. vehicleID) end

			-- Line 4 (Plates)
			local showPlates = getElementData(theVehicle, "vehicle:showplates") or 0
			local vehiclePlates = getVehiclePlateText(theVehicle)
			if (showPlates == 0) then
				if staffOverride then
					table.insert(toShowTable, "(( Plates: " .. vehiclePlates .. " ))")
				end
			else table.insert(toShowTable, "Plates: " .. vehiclePlates) end

			-- Vehicle description.
			local vehicleDescription = getElementData(theVehicle, "vehicle:description")
			local hasDescription = false
			for i, desc in ipairs(vehicleDescription) do
				if desc ~= "" then
					--if not hasDescription then hasDescription = true; table.insert(toShowTable, "\n") end
					if i == 1 then table.insert(toShowTable, "\n" .. desc) else table.insert(toShowTable, desc) end
				end
			end

			-- Render toShowTable which contains all of the text we need to show on the vehicle.
			local textToShow = ""
			for i, text in ipairs(toShowTable) do textToShow = textToShow .. "\n" .. text end
			--dxDrawRectangleBorder(theVehicle, 300, 100, 5, tocolor(0, 0, 0, 100)) @requires function to draw rectangle.
			dxDrawTextOnElement(theVehicle, textToShow, drawHeight, MAX_VIEW_DESC_DISTANCE, 255, 255, 255, 255, 1.5, false, true, false, false, false, false, true)
			
		elseif SHOWING_DESCRIPTION then
			removeEventHandler("onClientRender", root, renderVehicleDescription)
			killTimer(RESET_TIMER)
			SHOWING_DESCRIPTION = false
		end
	end
end

-- Function below is deprecated since it doesn't pick up on element distance to object, needs rework.
function dxDrawRectangleBorder(theElement, width, height, borderWidth, color, postGUI)
	local vx, vy, vz = getElementPosition(theElement)
	local x, y, z = getScreenFromWorldPosition(vx, vy, vz + 1.1, 0.05)
	x = x - 125
	y = y - 75
	--[[Filler]]dxDrawRectangle(x, y, width, height, color, postGUI)
	--[[Left]]	dxDrawRectangle(x - borderWidth, y, borderWidth, height, color, postGUI)
	--[[Right]]	dxDrawRectangle(x + width, y, borderWidth, height, color, postGUI)
	--[[Top]]	dxDrawRectangle(x - borderWidth, y - borderWidth, width + (borderWidth * 2), borderWidth, color, postGUI)
	--[[Botm]]	dxDrawRectangle(x - borderWidth, y + height, width + (borderWidth * 2), borderWidth, color, postGUI)
end

function dxDrawTextOnElement(theElement, text, height, distance, r, g, b, alpha, size, font, checkBuildings, checkVehicles, checkPeds, checkDummies, seeThroughStuff, ignoreSomeObjectsForCamera, ignoredElement)
	local x, y, z = getElementPosition(theElement)
	local x2, y2, z2 = getElementPosition(localPlayer)
	local distance = distance or 20
	local height = height or 1
	local checkBuildings = checkBuildings or false --switched to false for performance, as we don't use SA map anyway
	local checkVehicles = false
	local checkPeds = checkPeds or false
	local checkObjects = checkObjects or true
	local checkDummies = checkDummies or true
	local seeThroughStuff = seeThroughStuff or false
	local ignoreSomeObjectsForCamera = ignoreSomeObjectsForCamera or false
	local ignoredElement = ignoredElement or nil

	if isLineOfSightClear(x, y, z, x2, y2, z2, checkBuildings, checkVehicles, checkPeds, checkObjects, checkDummies, seeThroughStuff, ignoreSomeObjectsForCamera, ignoredElement) then
		local sx, sy = getScreenFromWorldPosition(x, y, z + height)
		if (sx) and (sy) then
			local distanceBetweenPoints = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
			if(distanceBetweenPoints < distance and distanceBetweenPoints < 12) then
				dxDrawText(text, sx + 4, sy + 2, sx, sy, tocolor(0, 0, 0, 180), (size or 1) - (distanceBetweenPoints / distance), font or "arial", "center", "center")
				dxDrawText(text, sx + 2, sy + 2, sx, sy, tocolor(r or 255, g or 255, b or 255, alpha or 255), (size or 1) - (distanceBetweenPoints / distance), font or "arial", "center", "center")
			end
		end
	end
end

function refreshNearbyVehicles()
	local nearbyVehicles = exports.global:getNearbyElements(localPlayer, "vehicle", MAX_VIEW_DESC_DISTANCE)
	vehicleTable = {}
	for i, veh in pairs(nearbyVehicles) do
		if isElement(veh) then
			table.insert(vehicleTable, veh)
		end
	end
end