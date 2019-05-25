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

local pickups = {}

-- /addtp - By Skully (20/06/18) [Helper]
function createNewTeleporter()
	if exports.global:isPlayerHelper(localPlayer) then
		if emGUI:dxIsWindowVisible(createTeleporterGUI) then emGUI:dxCloseWindow(createTeleporterGUI) return end
		createTeleporterGUI = emGUI:dxCreateWindow(0.19, 0.35, 0.15, 0.30, "Create Teleporter", true, _, true)

		setPos1Button = emGUI:dxCreateButton(0.08, 0.09, 0.85, 0.23, "Set Entrance Point", true, createTeleporterGUI)
		addEventHandler("onClientDgsDxMouseClick", setPos1Button, function(b, c)
			if (b == "left") and (c == "down") then
				handlePickupCreation(1)
			end
		end)
		setPos2Button = emGUI:dxCreateButton(0.08, 0.35, 0.85, 0.23, "Set Exit Point", true, createTeleporterGUI)
		addEventHandler("onClientDgsDxMouseClick", setPos2Button, function(b, c)
			if (b == "left") and (c == "down") then
				handlePickupCreation(2)
			end
		end)
		createTeleportButton = emGUI:dxCreateButton(0.14, 0.73, 0.72, 0.21, "Create", true, createTeleporterGUI)
		addEventHandler("onClientDgsDxMouseClick", createTeleportButton, createTeleportButtonClick)
		emGUI:dxSetEnabled(createTeleportButton, false)

		oneWayCheckbox = emGUI:dxCreateCheckBox(0.27, 0.63, 0.59, 0.05, "One Way Teleporter", false, true, createTeleporterGUI)

		addEventHandler("onDgsWindowClose", createTeleporterGUI, function()
			if pickups[1] then destroyElement(pickups[1][1]); pickups[1] = nil end
			if pickups[2] then destroyElement(pickups[2][1]); pickups[2] = nil end
		end)
	end
end
addCommandHandler("addtp", createNewTeleporter)
addCommandHandler("createtp", createNewTeleporter)

function handlePickupCreation(point)
	local x, y, z = getElementPosition(localPlayer)
	local _, _, rz = getElementRotation(localPlayer)
	local dim, int = getElementDimension(localPlayer), getElementInterior(localPlayer)
	if (point == 1) then
		if pickups[1] then destroyElement(pickups[1][1]) end
		pickups[1] = {createPickup(x, y, z, 3, g_teleporterModel), x, y, z, rz, dim, int}
		setElementDimension(pickups[1][1], dim)
		setElementInterior(pickups[1][1], int)
		outputChatBox("First position of teleporter set.", 75, 230, 10)
	else
		if pickups[2] then destroyElement(pickups[2][1]) end
		pickups[2] = {createPickup(x, y, z, 3, g_teleporterModel), x, y, z, rz, dim, int}
		setElementDimension(pickups[2][1], dim)
		setElementInterior(pickups[2][1], int)
		outputChatBox("Second position of teleporter set.", 75, 230, 10)
	end

	if pickups[1] and pickups[2] then
		emGUI:dxSetEnabled(createTeleportButton, true)
	else
		emGUI:dxSetEnabled(createTeleportButton, false)
	end
end

function createTeleportButtonClick(b, c)
	if (b == "left") and (c == "down") then
		outputChatBox("Pickup created with 2 points, resetting.", 75, 230, 10)
		local oneWay = emGUI:dxCheckBoxGetSelected(oneWayCheckbox)
		triggerServerEvent("teleporter:handleTeleportCreation", localPlayer, {pickups[1][2], pickups[1][3], pickups[1][4], pickups[1][5], pickups[1][6], pickups[1][7]}, {pickups[2][2], pickups[2][3], pickups[2][4], pickups[2][5], pickups[2][6], pickups[2][7]}, oneWay)
		emGUI:dxCloseWindow(createTeleporterGUI)
	end
end

function fixTeleporters()
	if (getElementData(localPlayer, "loggedin") == 1) then
		local nearbyTeleporters = getNearbyTeleporters(localPlayer)
		if #nearbyTeleporters >= 1 then
			for i, teleporter in ipairs(nearbyTeleporters) do
				local tpid = getElementData(teleporter, "marker:id")
				triggerServerEvent("teleport:reloadTeleporter", localPlayer, tpid)
			end
			outputChatBox(#nearbyTeleporters .. " nearby teleporters have been reloaded.", 75, 230, 10)
		else
			outputChatBox("There are no nearby teleporters.", 255, 0, 0)
		end
	end
end
addCommandHandler("fixtps", fixTeleporters)
addCommandHandler("fixteleporters", fixTeleporters)

-- /nearbytps [Radius] - By Skully (20/06/18) [Helper]
function nearbyTeleporters(c, radius)
	if exports.global:isPlayerHelper(localPlayer) then
		if not tonumber(radius) or (tonumber(radius) < 1) or (tonumber(radius) > 50) then radius = 15 end
		local nearbyTeleporters = getNearbyTeleporters(localPlayer, tonumber(radius))

		outputChatBox("Nearby teleporters (Distance of " .. radius .. "):", 75, 230, 10)
		for i, teleporter in ipairs(nearbyTeleporters) do
			local teleporterID = getElementData(teleporter, "marker:id") or "?"
			local isEntrance = getElementData(teleporter, "marker:isentrance")
			local locked = getElementData(teleporter, "marker:locked") or 0
			local mode = getElementData(teleporter, "marker:mode") or 1
			local oneway = getElementData(teleporter, "marker:oneway") or 0
			
			if locked == 1 then locked = "Yes" else locked = "No" end
			if oneway == 1 then oneway = "Yes" else oneway = "No" end
			if isEntrance then isEntrance = "Entrance" else isEntrance = "Exit" end

			outputChatBox("    [#" .. teleporterID .. " " .. isEntrance .. "] Locked: " .. locked .. " | One Way: " .. oneway .. " | Mode: " .. g_teleporterModes[mode], 75, 230, 10)
		end
		if #nearbyTeleporters == 0 then outputChatBox("   No teleporters.", 75, 230, 10) end
	end
end
addCommandHandler("nearbytp", nearbyTeleporters)
addCommandHandler("nearbytps", nearbyTeleporters)