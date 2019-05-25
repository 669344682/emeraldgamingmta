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

--[[ loadedTeleporters
	[teleporterID]
		[1] First Teleporter (Entrance)
			[1] Colsphere
			[2] Pickup

		[1] Second Teleporter (Exit)
			[1] Colsphere
			[2] Pickup
]]

local loadedTeleporters = {}

function loadTeleporterClient(theTeleporter)
	if isElement(theTeleporter) then
		local teleporterID = getElementData(theTeleporter, "teleporter:id")
		local x, y, z, rz, dim, int = unpack(getElementData(theTeleporter, "teleporter:location"))
		local x2, y2, z2, rz2, dim2, int2 = unpack(getElementData(theTeleporter, "teleporter:location2"))
		local locked = getElementData(theTeleporter, "teleporter:locked") or 0
		local oneway = getElementData(theTeleporter, "teleporter:oneway") or 0
		local mode = getElementData(theTeleporter, "teleporter:mode") or 1
		
		-- First teleporter.
		local teleporterElement = createColSphere(x, y, z, 1)
		setElementDimension(teleporterElement, dim)
		setElementInterior(teleporterElement, int)
		setElementData(teleporterElement, "marker:type", "teleporter")
		setElementData(teleporterElement, "marker:id", teleporterID)
		setElementData(teleporterElement, "marker:isentrance", true)
		setElementData(teleporterElement, "marker:locked", locked)
		setElementData(teleporterElement, "marker:oneway", oneway)
		setElementData(teleporterElement, "marker:mode", mode)

		local teleporterPickup = createPickup(x, y, z, 3, g_teleporterModel)
		setElementDimension(teleporterPickup, dim)
		setElementInterior(teleporterPickup, int)

		-- Second teleporter.
		local teleporterElement2 = createColSphere(x2, y2, z2, 1)
		setElementDimension(teleporterElement2, dim2)
		setElementInterior(teleporterElement2, int2)
		setElementData(teleporterElement2, "marker:type", "teleporter")
		setElementData(teleporterElement2, "marker:id", teleporterID)
		setElementData(teleporterElement2, "marker:isentrance", false)
		setElementData(teleporterElement2, "marker:locked", locked)
		setElementData(teleporterElement2, "marker:oneway", oneway)
		setElementData(teleporterElement2, "marker:mode", mode)

		local teleporterPickup2 = createPickup(x2, y2, z2, 3, g_teleporterModel)
		setElementDimension(teleporterPickup2, dim2)
		setElementInterior(teleporterPickup2, int2)

		-- Insert teleporters into loading table.
		loadedTeleporters[teleporterID] = {{teleporterElement, teleporterPickup}, {teleporterElement2, teleporterPickup2}}
	end
end
addEvent("teleporter:loadTeleporterClient", true)	
addEventHandler("teleporter:loadTeleporterClient", root, loadTeleporterClient)
addEventHandler("onClientResourceStart", resourceRoot, function()
	for i, teleporter in ipairs(getElementsByType("teleporter")) do loadTeleporterClient(teleporter) end
end)

function bindKeys()
	setElementData(localPlayer, "marker:current", source)
	toggleControl("enter_exit", false)
end
addEventHandler("onClientColShapeHit", root, bindKeys)

function unbindKeys()
	setElementData(localPlayer, "marker:current", false)
	toggleControl("enter_exit", true)
end
addEventHandler("onClientColShapeLeave", root, unbindKeys)

local isEntering = false
addEventHandler("onClientKey", root, function(k, p) 
	if (k == "f") and p then
		local currentMarker = getElementData(localPlayer, "marker:current")
		if not (isEntering) and currentMarker then
			isEntering = true
			setTimer(function() isEntering = false end, 500, 1)
			local markerType = getElementData(currentMarker, "marker:type")
			local thePlayerDim, thePlayerInt = getElementDimension(localPlayer), getElementInterior(localPlayer)
			local markerDim, markerInt = getElementDimension(currentMarker), getElementInterior(currentMarker)
			if (thePlayerDim == markerDim) and (thePlayerInt == markerInt) then -- Match player dimension.
				local theVehicle = getPedOccupiedVehicle(localPlayer)
				if theVehicle and (getVehicleOccupant(theVehicle, 0) ~= localPlayer) then return end -- If player is in vehicle and not driver.
				if (markerType == "teleporter") then
					-- If player is in vehicle, check distance.
					if theVehicle and isElementWithinColShape(theVehicle, currentMarker) or isElementWithinColShape(localPlayer, currentMarker) then
						local mode = getElementData(currentMarker, "marker:mode")
						if (mode ~= 1) then -- If not players & vehicles.
							-- Players only.
							if (theVehicle) and (mode == 2) then
								outputChatBox("Vehicles cannot use through here.", 255, 0, 0)
								return
							end

							-- Vehicles only.
							if not (theVehicle) and (mode == 3) then
								outputChatBox("Only vehicles can go through here.", 255, 0, 0)
								return
							end

							-- Controller holders only.
							if (mode == 4) then
								local hasController = true -- Check to see if player has controller for this teleporter. [ID of teleporter can be accessed with data "marker:id"] @requires item-system
								if not hasController then
									outputChatBox("You need to have the controller in order to go through here.", 255, 0, 0)
									return
								end
							end
						end

						-- One way.
						local oneway = getElementData(currentMarker, "marker:oneway")
						local isEntrance = getElementData(currentMarker, "marker:isentrance")
						if (oneway == 1) and not isEntrance then
							outputChatBox("It appears this doesn't lead back anywhere.", 255, 0, 0)
							return
						end

						local teleporterID = getElementData(currentMarker, "marker:id")
						triggerServerEvent("teleporter:useTeleporter", localPlayer, teleporterID, isEntrance)
					end
				elseif (markerType == "interior") then
					local interiorID = getElementData(currentMarker, "marker:id")
					
					-- Un-owned interior.
					local owner = getElementData(currentMarker, "marker:owner")
					if (owner == 0) then
						if getElementData(currentMarker, "marker:isentrance") then
							triggerServerEvent("interior:sellPropertyCall", localPlayer, localPlayer, interiorID)
						else
							triggerEvent("interior:stopIntPreview", localPlayer)
						end
						return
					end

					-- Locked interior.
					local locked = getElementData(currentMarker, "marker:locked")
					if locked then
						outputChatBox("You attempt to twist the door handle but it's locked.", 255, 0, 0)
						triggerEvent("interior:playInteriorSoundEffect", localPlayer, interiorID, 2)
						return
					end

					-- Disabled interior.
					local status = getElementData(currentMarker, "marker:status")
					if (status[2] == 1) then
						outputChatBox("This interior is currently disabled.", 255, 0, 0)
						return
					end

					-- Prevent vehicle usage on markers apart from garage entrances.
					if theVehicle and (status[1] ~= 2) then outputDebugString("type is 2 get out") return end

					local isEntrance = getElementData(currentMarker, "marker:isentrance")
					triggerServerEvent("interior:useMarker", localPlayer, interiorID, isEntrance)
				end
			end
		end
	end
end)

function destroyTeleporter(teleporterID)
	if loadedTeleporters[teleporterID] then
		destroyElement(loadedTeleporters[teleporterID][1][1])
		destroyElement(loadedTeleporters[teleporterID][1][2])
		destroyElement(loadedTeleporters[teleporterID][2][1])
		destroyElement(loadedTeleporters[teleporterID][2][2])
	end
	loadedTeleporters[teleporterID] = nil
end
addEvent("teleporter:destroyTeleporter", true)
addEventHandler("teleporter:destroyTeleporter", root, destroyTeleporter)

function getNearbyTeleporters(player, distance)
	local x, y, z = getElementPosition(player)
	local nearbyTeleports = {}

	for i, teleporter in pairs(loadedTeleporters) do
		for v, pickup in pairs(teleporter) do
			if isElement(pickup[1]) and getDistanceBetweenPoints3D(x, y, z, getElementPosition(pickup[1])) < (distance or 25) then
				if getElementDimension(player) == getElementDimension(pickup[1]) and getElementInterior(player) == getElementInterior(pickup[1]) then
					table.insert(nearbyTeleports, pickup[1])
				end
			end
		end
	end

	return nearbyTeleports
end