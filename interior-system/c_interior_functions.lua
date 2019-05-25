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

--[[ interiorMarkers
	[interiorID]
		[1] First Teleporter (Entrance)
			[1] Colsphere
			[2] Pickup

		[1] Second Teleporter (Exit)
			[1] Colsphere
			[2] Pickup
]]

local interiorMarkers = {}
local pickupModels = {
	[1] = 1273, -- Green house. (House for sale)
	[2] = 1272, -- Blue house. (Businesses)
	[3] = 1461, -- Arrow. (Owned properties)
	[4] = 1314, -- Red house (Disabled interior)
	[5] = 1248, -- Yellow House (Garages)
}

function loadInteriorMarkersClient(theInterior)
	if isElement(theInterior) then
		local interiorID = getElementData(theInterior, "interior:id")
		local x, y, z, rz, dim, int = unpack(getElementData(theInterior, "interior:entrance"))
		local x2, y2, z2, rz2, dim2, int2 = unpack(getElementData(theInterior, "interior:exit"))
		local locked = getElementData(theInterior, "interior:locked")
		local owner = getElementData(theInterior, "interior:owner")
		local statuses = getElementData(theInterior, "interior:status")

		-- First marker. (Entrance)
		local entranceMarker = createColSphere(x, y, z, 1)
		setElementDimension(entranceMarker, dim)
		setElementInterior(entranceMarker, int)
		setElementData(entranceMarker, "marker:type", "interior")
		setElementData(entranceMarker, "marker:id", interiorID)
		setElementData(entranceMarker, "marker:isentrance", true)
		setElementData(entranceMarker, "marker:locked", locked or false)
		setElementData(entranceMarker, "marker:status", statuses)
		setElementData(entranceMarker, "marker:owner", owner)

		local icon = pickupModels[1]

		-- If interior is disabled.
		if (statuses[2] == 1) then
			icon = pickupModels[4]
		elseif (owner ~= 0) then -- If interior owned.
			icon = pickupModels[3]
		elseif (statuses[1] == 2) then -- If its a garage.
			icon = pickupModels[5]
		elseif (statuses[1] == 3) or (statuses[1] == 5) or (statuses[1] == 6) then -- If it is a business, government, other.
			icon = pickupModels[2]
		end


		local entrancePickup = createPickup(x, y, z, 3, icon)
		setElementDimension(entrancePickup, dim)
		setElementInterior(entrancePickup, int)

		-- Second marker. (Exit)
		local entranceMarker2 = createColSphere(x2, y2, z2, 1)
		setElementDimension(entranceMarker2, dim2)
		setElementInterior(entranceMarker2, int2)
		setElementData(entranceMarker2, "marker:type", "interior")
		setElementData(entranceMarker2, "marker:id", interiorID)
		setElementData(entranceMarker2, "marker:isentrance", false)
		setElementData(entranceMarker2, "marker:locked", locked or false)
		setElementData(entranceMarker2, "marker:status", statuses)
		setElementData(entranceMarker2, "marker:owner", owner)

		local entrancePickup2 = createPickup(x2, y2, z2, 3, icon)
		setElementDimension(entrancePickup2, dim2)
		setElementInterior(entrancePickup2, int2)

		-- Insert markers into markers table.
		interiorMarkers[interiorID] = {{entranceMarker, entrancePickup}, {entranceMarker2, entrancePickup2}}
	end
end
addEvent("interior:loadInteriorMarkersClient", true)	
addEventHandler("interior:loadInteriorMarkersClient", root, loadInteriorMarkersClient)
addEventHandler("onClientResourceStart", resourceRoot, function()
	for i, int in ipairs(getElementsByType("interior")) do loadInteriorMarkersClient(int) end
end)

function destroyInteriorMarkers(interiorID)
	if interiorMarkers[interiorID] then
		destroyElement(interiorMarkers[interiorID][1][1])
		destroyElement(interiorMarkers[interiorID][1][2])
		destroyElement(interiorMarkers[interiorID][2][1])
		destroyElement(interiorMarkers[interiorID][2][2])
	end
	interiorMarkers[interiorID] = nil
end
addEvent("interior:destroyInteriorMarkers", true)
addEventHandler("interior:destroyInteriorMarkers", root, destroyInteriorMarkers)

function getNearbyMarkerIDs(player, distance)
	local x, y, z = getElementPosition(player)
	local nearbyInteriorMarkers = {}

	for i, markers in pairs(interiorMarkers) do
		for v, pickup in pairs(markers) do
			if isElement(pickup[1]) and getDistanceBetweenPoints3D(x, y, z, getElementPosition(pickup[1])) < (tonumber(distance) or 25) then
				if getElementDimension(player) == getElementDimension(pickup[1]) and getElementInterior(player) == getElementInterior(pickup[1]) then
					local markerID = getElementData(pickup[1], "marker:id")
					local isEntrance = getElementData(pickup[1], "marker:isentrance")
					table.insert(nearbyInteriorMarkers, {markerID, isEntrance})
				end
			end
		end
	end

	return nearbyInteriorMarkers
end

function updateMarkerData(interiorID, entrance, data, value)
	local id = 2; if entrance then id = 1 end
	if isElement(interiorMarkers[interiorID][id][1]) then
		setElementData(interiorMarkers[interiorID][id][1], data, value)
	end
end
addEvent("interior:updateMarkerData", true)
addEventHandler("interior:updateMarkerData", root, updateMarkerData)

-- /nearbyints (Radius [1-25]) - By Skully (20/06/18) [Helper/MT]
function nearbyInteriorsClient(c, radius)
	if exports.global:isPlayerHelper(localPlayer) or exports.global:isPlayerMappingTeam(localPlayer) then
		if not tonumber(radius) or tonumber(radius) < 1 or tonumber(radius) > 25 then radius = 20 end
		local nearbyIntMarkers = getNearbyMarkerIDs(localPlayer, radius)
		outputChatBox("Nearby interiors (Distance of " .. radius .. "):", 75, 230, 10)
		triggerServerEvent("interior:nearbyInteriorCall", localPlayer, nearbyIntMarkers)
		if #nearbyIntMarkers == 0 then outputChatBox("   No interiors.", 75, 230, 10) end
	end
end
addCommandHandler("nearbyints", nearbyInteriorsClient)

-- /lockint - By Skully (21/06/18) [Player]
function lockInteriorClient()
	if (getElementData(localPlayer, "loggedin") == 1) then
		local nearbyIntMarkers = getNearbyMarkerIDs(localPlayer, 4)
		if #nearbyIntMarkers ~= 0 then
			triggerServerEvent("interior:lockInterior", localPlayer, localPlayer, nearbyIntMarkers)
		end
	end
end
bindKey("k", "down", lockInteriorClient)
addCommandHandler("lockint", lockInteriorClient)

function playInteriorSoundEffect(interiorID, effectID)
	local effects = {
		[1] = "door_lock_sound.mp3", -- Door lock/unlocking.
		[2] = "door_islocked.mp3", -- Door open attempt when locked.
		[3] = "door_knocking.mp3", -- Door knocking.
	}

	if (interiorMarkers[interiorID]) then
		for i, marker in ipairs(interiorMarkers[interiorID]) do
			local mx, my, mz = getElementPosition(marker[1])
			local mdim, mint = getElementDimension(marker[1]), getElementInterior(marker[1])
			local sound = playSound3D("assets/sounds/" .. effects[effectID], mx, my, mz)
			if sound then
				setElementDimension(sound, mdim)
				setElementInterior(sound, mint)
			end
		end
	end
end
addEvent("interior:playInteriorSoundEffect", true)
addEventHandler("interior:playInteriorSoundEffect", root, playInteriorSoundEffect)