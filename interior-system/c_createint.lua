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

-- /createint - By Skully (05/06/18) [Admin/MT]
function createNewInteriorGUI()
	if exports.global:isPlayerAdmin(localPlayer) or exports.global:isPlayerMappingTeam(localPlayer) then
		if emGUI:dxIsWindowVisible(createNewIntGUI) then emGUI:dxCloseWindow(createNewIntGUI) return end
		local createNewIntGUILabels = {}
		createNewIntGUI = emGUI:dxCreateWindow(0.38, 0.31, 0.23, 0.39, "Create New Interior", true)

		createNewIntGUILabels[1] = emGUI:dxCreateLabel(0.06, 0.10, 0.15, 0.04, "Interior Name", true, createNewIntGUI)
		createNewIntGUILabels[2] = emGUI:dxCreateLabel(0.57, 0.10, 0.15, 0.04, "Interior ID", true, createNewIntGUI)
		createNewIntGUILabels[3] = emGUI:dxCreateLabel(0.06, 0.27, 0.15, 0.04, "Interior Type", true, createNewIntGUI)
		createNewIntGUILabels[4] = emGUI:dxCreateLabel(0.06, 0.48, 0.15, 0.04, "Interior Owner", true, createNewIntGUI)
		createNewIntGUILabels[5] = emGUI:dxCreateLabel(0.57, 0.48, 0.15, 0.04, "Interior Price", true, createNewIntGUI)
		
		intNameInput = emGUI:dxCreateEdit(0.06, 0.152, 0.45, 0.06, "", true, createNewIntGUI)
		intIDInput = emGUI:dxCreateEdit(0.57, 0.152, 0.34, 0.06, "", true, createNewIntGUI)
		viewIntsButton = emGUI:dxCreateButton(0.58, 0.26, 0.32, 0.14, "View\nInteriors", true, createNewIntGUI)
		addEventHandler("onClientDgsDxMouseClick", viewIntsButton, function(b, c)
			if (b == "left") and (c == "down") then triggerEvent("interior:showInteriorIdsList", localPlayer) end
		end)

		intTypeCombobox = emGUI:dxCreateComboBox(0.06, 0.322, 0.45, 0.065, true, createNewIntGUI)
		for i, intType in ipairs(g_interiorTypes) do
			emGUI:dxComboBoxAddItem(intTypeCombobox, intType[1])
		end
		emGUI:dxComboBoxSetSelectedItem(intTypeCombobox, 1)
		
		intOwnerInput = emGUI:dxCreateEdit(0.06, 0.535, 0.45, 0.06, "", true, createNewIntGUI)
		addEventHandler("onClientDgsDxGUITextChange", intOwnerInput, updatePlayerFoundLabel)

		intPriceInput = emGUI:dxCreateEdit(0.57, 0.535, 0.34, 0.06, "", true, createNewIntGUI)
		serverOwnedCheckbox = emGUI:dxCreateCheckBox(0.125, 0.61, 0.50, 0.06, "Server Owned Interior", false, true, createNewIntGUI)
		addEventHandler("onDgsCheckBoxChange", serverOwnedCheckbox, function(state)
			if (state) then
				emGUI:dxSetText(intOwnerInput, "Server")
			end
			emGUI:dxSetEnabled(intOwnerInput, not state)
		end)

		intsFeedbackLabel = emGUI:dxCreateLabel(0.135, 0.7, 0.72, 0.04, "", true, createNewIntGUI)
		emGUI:dxLabelSetHorizontalAlign(intsFeedbackLabel, "center")
		
		createIntButton = emGUI:dxCreateButton(0.25, 0.77, 0.49, 0.18, "Create Interior", true, createNewIntGUI)
		addEventHandler("onClientDgsDxMouseClick", createIntButton, createIntButtonClick)
	end
end
addCommandHandler("createint", createNewInteriorGUI)
addEvent("interior:createintcall", true) -- Used by /interiors GUI.
addEventHandler("interior:createintcall", root, createNewInteriorGUI)

local function updateFeedbackLabel(text, r, g, b)
	if not (r) then r, g, b = 255, 0, 0 end
	emGUI:dxSetText(intsFeedbackLabel, text)
	emGUI:dxLabelSetColor(intsFeedbackLabel, r, g, b)
end

local playerFound = false
function updatePlayerFoundLabel()
	local intOwner = emGUI:dxGetText(intOwnerInput)
	local targetPlayer, targetPlayerName = exports.global:getPlayerFromPartialNameOrID(intOwner, localPlayer)

	if (intOwner:lower() == "server") then
		updateFeedbackLabel("Interior will be owned by server.", 0, 255, 0)
		playerFound = 25560 -- Server
	elseif (targetPlayer) then
		updateFeedbackLabel("Player " .. targetPlayerName .. " found!", 0, 255, 0)
		playerFound = targetPlayer
	else
		updateFeedbackLabel("Player not found, interior will be owned by no one.")
		playerFound = 0
	end
end

function createIntButtonClick(b, c)
	if (b == "left") and (c == "down") then
		local intName = emGUI:dxGetText(intNameInput)
		local intID = emGUI:dxGetText(intIDInput)
		local intType = emGUI:dxComboBoxGetSelectedItem(intTypeCombobox)
		local intPrice = emGUI:dxGetText(intPriceInput)

		if not tostring(intName) or (string.len(intName) < 3) or (string.len(intName) > 35) then
			updateFeedbackLabel("Interior name must be between 3 and 35 characters!")
			return false
		end

		if not tonumber(intID) or not g_interiors[tonumber(intID)] then
			updateFeedbackLabel("That is not a valid interior ID!")
			return false
		end

		if not (playerFound) then playerFound = 0 end

		if not tonumber(intPrice) or (tonumber(intPrice) < 0)  or (tonumber(intPrice) > 100000000) then
			updateFeedbackLabel("That is not a valid price amount!")
			return false
		end

		triggerServerEvent("interior:createIntCall", localPlayer, localPlayer, tonumber(intID), intType, playerFound, intName, tonumber(intPrice))
		emGUI:dxCloseWindow(createNewIntGUI)
	end
end