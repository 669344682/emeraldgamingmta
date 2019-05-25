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


-- Global customization variables.
local INTERACTION_MENU_OPEN = false -- If the player is currently right-clicking on an element.

-- Function required variables.
local emGUI = exports.emGUI
local sW, sH = guiGetScreenSize()
local INTERACTION_WINDOW_TITLE_COLOR = tocolor(0, 0, 0, 220)
local INTERACTION_WINDOW_COLOR = tocolor(0, 0, 0, 200)
local BUTTON_PRECLICK, BUTTON_HIGHLIGHT, BUTTON_CLICKED = tocolor(0, 0, 0, 0), tocolor(0, 0, 0, 190), tocolor(0, 0, 0, 240)

-- Default interaction options.
local INTERACTION_OPTIONS = {
	["player"] = {"Look"},
	["vehicle"] = {"View Inventory"},
	["ped"] = {"Interact"},
	["object"] = {"Examine", "Pick Up"},
}

-- Primary mouse hover interactions.
function handleCursorHover()
	if (isCursorShowing()) then
		local cursorX, cursorY, absCursorX, absCursorY, absCursorZ = getCursorPosition()
		local cameraX, cameraY, cameraZ = getWorldFromScreenPosition(cursorX, cursorY, 0.1)
		local isHit, x, y, z, theElement = processLineOfSight(cameraX, cameraY, cameraZ, absCursorX, absCursorY, absCursorZ)

		if (isHit and x and y and z) then -- If there is a collision.
			local thePlayerX, thePlayerY, thePlayerZ = getElementPosition(localPlayer)
			local distance = getDistanceBetweenPoints3D(thePlayerX, thePlayerY, thePlayerZ, x, y, z)

			if (theElement) and (distance < MAX_INTERACTION_DISTANCE) then -- If the mouse is hovering over an element.
				--print("[interaction] Type: " .. type(theElement) .. " | Value: " .. tostring(theElement))
			end
		end
	end
end
addEventHandler("onClientRender", root, handleCursorHover)

-- Primary mouse click interaction.
function handleCursorInteractions(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
	if (clickedElement) and (state == "down") then -- Clicking an actual element.
		local x, y, z = getElementPosition(localPlayer)
		local tx, ty, tz = getElementPosition(clickedElement)

		if (getDistanceBetweenPoints3D(x, y, z, tx, ty, tz) < MAX_INTERACTION_DISTANCE) then
			if (button == "left") then -- Left click.
				if INTERACTION_MENU_OPEN then closeInteractionMenu() end
			elseif (button == "right") then -- Right click.
				local elementType = getElementType(clickedElement)
				if (elementType == "object") or (elementType == "vehicle") or (elementType == "ped") or (elementType == "player") then
					if (INTERACTION_MENU_OPEN) then closeInteractionMenu() end
					showInteractionMenu(clickedElement, absoluteX, absoluteY)
				end
			end
		end
	else
		if (button == "left") and not clickedElement then closeInteractionMenu() end
	end
end
addEventHandler("onClientClick", root, handleCursorInteractions)

function closeInteractionMenu()
	if INTERACTION_MENU_OPEN then
		if emGUI:dxIsWindowVisible(interactionMenuWindow) then emGUI:dxCloseWindow(interactionMenuWindow) end
		INTERACTION_MENU_OPEN = false
	end
end

function showInteractionMenu(theElement, absoluteX, absoluteY)
	INTERACTION_MENU_OPEN = true
	absoluteX = absoluteX / sW
	absoluteY = absoluteY / sH

	local theElementType = getElementType(theElement)
	local theElementName = "Unknown"

	local actionTable = {}
	for i, action in ipairs(INTERACTION_OPTIONS[theElementType]) do
		table.insert(actionTable, action)
	end

	-- Staff checks to variables for optimization.
	local isPlayerManager = exports.global:isPlayerManager(localPlayer)
	local isPlayerAdmin = exports.global:isPlayerTrialAdmin(localPlayer)
	local isPlayerHelper = exports.global:isPlayerHelper(localPlayer)
	local isPlayerVehicleTeam = exports.global:isPlayerVehicleTeam(localPlayer)
	local isPlayerVTLeader = exports.global:isPlayerVehicleTeamLeader(localPlayer)

	if (theElement == localPlayer) then -- Self interaction.
		theElementName = getPlayerName(localPlayer):gsub("_", " ")
		table.insert(actionTable, "Set Mood")
	elseif (theElementType == "player") then
		theElementName = getPlayerName(theElement):gsub("_", " ")

		-- Add ability to frisk.
		table.insert(actionTable, "Frisk")

		-- Check if the player is friends with the target element.
		local arePlayerFriends = false -- Check if localPlayer is friends with theElement. @requires social-system
		if not arePlayerFriends then
			table.insert(actionTable, "Add Friend")
		else
			table.insert(actionTable, "Remove Friend")
		end

		-- Check if player is blindfolded.
		local playerHasBlindfold = true -- Check if player has blindfold or rags. @requires item-system
		local isPlayerBlindfolded = getElementData(theElement, "character:blindfolded") == 1

		if isPlayerBlindfolded then
			table.insert(actionTable, "Remove Blindfold")
		elseif playerHasBlindfold then
			table.insert(actionTable, "Blindfold")
		end

		-- Check if player is restrained.
		local playerHasRestraint = true -- Check if player has handcuffs or rope. @requires item-system
		local isPlayerRestrained = getElementData(theElement, "character:cuffed") == 1

		if isPlayerRestrained then
			table.insert(actionTable, "Remove Restraint")
		elseif playerHasRestraint then
			table.insert(actionTable, "Restrain")
		end

		if isPlayerAdmin then
			table.insert(actionTable, "Check Player")
		end

	elseif (theElementType == "vehicle") then
		theElementName = getElementData(theElement, "vehicle:name") or "Unknown"

		-- Check if vehicle is locked/unlocked and player has key.
		local playerHasVehicleKey = false -- Check if player has vehicle key of ID. (getElementData(theElement, "vehicle:id")) @requires item-system
		if playerHasVehicleKey or isPlayerHelper or isPlayerVTLeader then
			local isLockedVehicle = isVehicleLocked(theElement)
			if isLockedVehicle then
				table.insert(actionTable, "Unlock")
			else
				table.insert(actionTable, "Lock")
			end
		end

		if exports["fuel-system"]:isPlayerAtGasStation(localPlayer) then
			table.insert(actionTable, "Refuel Vehicle")
		end

		if isPlayerHelper or isPlayerVehicleTeam then
			table.insert(actionTable, "Check Vehicle")
			table.insert(actionTable, "Respawn Vehicle")
			table.insert(actionTable, "Vehicle Textures")
		end

	elseif (theElementType == "object") then
		local objectID = getElementData(theElement, "object:objectid")
		theElementName = exports["item-system"]:getItemName(objectID)
	elseif (theElementType == "ped") then
		theElementName = getElementData(theElement, "ped:name") -- Adjust element data to get NPC name. @requires npc-system
	end

	local menuOptions = {}
	local textWidth = dxGetTextWidth(theElementName) / sW
	local tableSize = #actionTable
	local buttonWidth = 0.025

	interactionMenuWindow = emGUI:dxCreateWindow(absoluteX, absoluteY, 0.05 + textWidth, buttonWidth + (buttonWidth * tableSize), theElementName, true, true, _, true, _, _, _, INTERACTION_WINDOW_TITLE_COLOR, _, INTERACTION_WINDOW_COLOR)

	for i, option in ipairs(actionTable) do
		menuOptions[i] = emGUI:dxCreateButton(0, (i - 1) / tableSize, 1, (1 / tableSize), option, true, interactionMenuWindow, _, 0.75, 0.75, _, _, _, BUTTON_PRECLICK, BUTTON_HIGHLIGHT, BUTTON_CLICKED)
		setElementData(menuOptions[i], "temp:interaction:option", i, false)

		addEventHandler("onClientDgsDxMouseClick", menuOptions[i], function(b, c)
			if (b == "left") and (c == "down") then
				local clicked = getElementData(source, "temp:interaction:option")
				handleInteractionClick(theElement, theElementType, clicked, actionTable)
			end
		end)
	end
end

function handleInteractionClick(theElement, theElementType, clickedOption, interactionTable)
	local selectedAction = interactionTable[clickedOption]

	if (theElementType == "player") then
		if (selectedAction == "Look") then
			triggerEvent("interaction:showLookCharacterWindow", theElement, theElement)
		elseif (selectedAction == "Set Mood") then
			showMoodUpdateWindow()
		elseif (selectedAction == "Frisk") then
			-- Frisk
		elseif (selectedAction == "Add Friend") then
			-- Add Friend
		elseif (selectedAction == "Remove Friend") then
			-- Remove Friend
		elseif (selectedAction == "Blindfold") then
			-- Blindfold
		elseif (selectedAction == "Remove Blindfold") then
			-- Remove Blindfold
		elseif (selectedAction == "Restrain") then
			-- Restrain
		elseif (selectedAction == "Remove Restraint") then
			-- Remove Restraint
		elseif (selectedAction == "Check Player") then
			triggerServerEvent("admin:s_checkPlayer", localPlayer, localPlayer, "ui", theElement)
		end
	elseif (theElementType == "vehicle") then
		local vehicleID = getElementData(theElement, "vehicle:id")

		if (selectedAction == "View Inventory") then
			-- Check Player
		elseif (selectedAction == "Lock") or (selectedAction == "Unlock") then
			triggerServerEvent("vehicle:toggleVehicleLockOutside", localPlayer, theElement, true)
		elseif (selectedAction == "Refuel Vehicle") then
			triggerServerEvent("fuel:refuelCall", localPlayer, localPlayer)
		elseif (selectedAction == "Check Vehicle") then
			triggerServerEvent("vehicle:checkvehcall", localPlayer, localPlayer, "ui", vehicleID)
		elseif (selectedAction == "Respawn Vehicle") then
			triggerServerEvent("vehicle:respawnvehcall", localPlayer, localPlayer, "ui", vehicleID)
		elseif (selectedAction == "Vehicle Textures") then
			-- Vehicle Textures
		end
	elseif (theElementType == "object") then
		if (selectedAction == "Examine") then
			-- Examine
		elseif (selectedAction == "Pick Up") then
			-- Pick Up
		end
	elseif (theElementType == "ped") then
		if (selectedAction == "Interact") then
			-- Interact
		end
	end
end

-- Mood update interface.
function showMoodUpdateWindow()
	if not (getElementData(localPlayer, "loggedin") == 1) then return end
	if emGUI:dxIsWindowVisible(updateMoodWindow) then return end

	local playerCurrentMood = getElementData(localPlayer, "character:mood") or 1
	local updateMoodWindow = emGUI:dxCreateWindow(0.6, 0.41, 0.14, 0.28, " ", true, true, _, true, _, 5)

	local moodsGridlist = emGUI:dxCreateGridList(0.03, 0.03, 0.93, 0.85, true, updateMoodWindow, true)

	emGUI:dxGridListAddColumn(moodsGridlist, "Update Mood", 1)
	for i, mood in ipairs(g_selectableMoods) do
		local row = emGUI:dxGridListAddRow(moodsGridlist)
		emGUI:dxGridListSetItemText(moodsGridlist, row, 1, mood)
	end

	emGUI:dxGridListSetSelectedItem(moodsGridlist, playerCurrentMood)

	local closeButton = emGUI:dxCreateButton(0, 0.9, 0.5, 0.1, "Close", true, updateMoodWindow)
	addEventHandler("onClientDgsDxMouseClick", closeButton, function(b, c)
		if (b == "left") and (c == "down") then emGUI:dxCloseWindow(updateMoodWindow) end
	end)

	local moodUpdateButton = emGUI:dxCreateButton(0.5, 0.9, 0.5, 0.1, "Update", true, updateMoodWindow)
	addEventHandler("onClientDgsDxMouseClick", moodUpdateButton, function(b, c)
		if (b == "left") and (c == "down") then
			local selectedItem = emGUI:dxGridListGetSelectedItem(moodsGridlist) or -1
			if (selectedItem == -1) then selectedItem = 1 end
			
			triggerServerEvent("interaction:updateCharacterMood", localPlayer, selectedItem)
			emGUI:dxCloseWindow(updateMoodWindow)
		end
	end)
end
addCommandHandler("changemood", showMoodUpdateWindow)
addCommandHandler("updatemood", showMoodUpdateWindow)