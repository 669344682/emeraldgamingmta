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
|    /| | | | |    |  __||  __/| |    |  _  |\ /
| |\ \\ \_/ / |____| |___| |   | |____| | | || |
\_| \_|\___/\_____/\____/\_|   \_____/\_| |_/\_/

Copyright of the Emerald Gaming Development Team, do not distribute - All rights reserved. ]]

function showStaffManagerGUI()
	local staffLabels = {}
	staffManagerMenu = emGUI:dxCreateWindow(0.38, 0.34, 0.24, 0.40, "Staff Manager", true, true)

	staffLabels[1] = emGUI:dxCreateLabel(0.08, 0.117, 0.26, 0.05, "Account Name", true, staffManagerMenu)
	staffLabels[2] = emGUI:dxCreateLabel(0.21, 0.30, 0.13, 0.06, "Staff Rank:", true, staffManagerMenu)
	staffLabels[3] = emGUI:dxCreateLabel(0.09, 0.39, 0.23, 0.06, "Vehicle Team Rank:", true, staffManagerMenu)
	staffLabels[4] = emGUI:dxCreateLabel(0.08, 0.47, 0.24, 0.06, "Mapping Team Rank:", true, staffManagerMenu)
	staffLabels[5] = emGUI:dxCreateLabel(0.09, 0.55, 0.23, 0.06, "Faction Team Rank:", true, staffManagerMenu)
	staffLabels[6] = emGUI:dxCreateLabel(0.14, 0.63, 0.23, 0.06, "Developer Rank:", true, staffManagerMenu)

	feedbackLabelText = emGUI:dxCreateLabel(0.22, 0.72, 0.56, 0.05, "", true, staffManagerMenu)
	emGUI:dxLabelSetHorizontalAlign(feedbackLabelText, "center")
	
	staffNameInput = emGUI:dxCreateEdit(0.08, 0.17, 0.45, 0.06, "", true, staffManagerMenu)
	addEventHandler("onClientDgsDxGUITextChange", staffNameInput, updateStaffFeedbackLabel)

	staffRankLabel = emGUI:dxCreateLabel(0.39, 0.30, 0.30, 0.06, "N/A", true, staffManagerMenu)
	vehicleTeamLabel = emGUI:dxCreateLabel(0.39, 0.39, 0.30, 0.06, "N/A", true, staffManagerMenu)
	mappingTeamLabel = emGUI:dxCreateLabel(0.39, 0.47, 0.30, 0.06, "N/A", true, staffManagerMenu)
	factionTeamLabel = emGUI:dxCreateLabel(0.39, 0.55, 0.30, 0.06, "N/A", true, staffManagerMenu)
	devTeamLabel = emGUI:dxCreateLabel(0.39, 0.63, 0.30, 0.06, "N/A", true, staffManagerMenu)

	staffRankButton = emGUI:dxCreateButton(0.72, 0.30, 0.22, 0.07, "Adjust", true, staffManagerMenu)
	addEventHandler("onClientDgsDxMouseClick", staffRankButton, staffRankButtonEvent)

	vehicleTeamButton = emGUI:dxCreateButton(0.72, 0.38, 0.22, 0.07, "Adjust", true, staffManagerMenu)
	addEventHandler("onClientDgsDxMouseClick", vehicleTeamButton, vehicleTeamButtonEvent)

	mappingTeamButton = emGUI:dxCreateButton(0.72, 0.46, 0.22, 0.07, "Adjust", true, staffManagerMenu)
	addEventHandler("onClientDgsDxMouseClick", mappingTeamButton, mappingTeamButtonEvent)

	factionTeamButton = emGUI:dxCreateButton(0.72, 0.54, 0.22, 0.07, "Adjust", true, staffManagerMenu)
	addEventHandler("onClientDgsDxMouseClick", factionTeamButton, factionTeamButtonEvent)

	devTeamButton = emGUI:dxCreateButton(0.72, 0.62, 0.22, 0.07, "Adjust", true, staffManagerMenu)
	addEventHandler("onClientDgsDxMouseClick", devTeamButton, devTeamButtonEvent)

	closeButton = emGUI:dxCreateButton(0.30, 0.79, 0.40, 0.18, "Close", true, staffManagerMenu)
	addEventHandler("onClientDgsDxMouseClick", closeButton, closeButtonEvent)
end

function showStaffManager()
	if exports.global:isPlayerManager(localPlayer, true) or exports.global:isPlayerLeadDeveloper(localPlayer, true) or exports.global:isPlayerVehicleTeamLeader(localPlayer, true) or exports.global:isPlayerMappingTeamLeader(localPlayer, true) or exports.global:isPlayerFactionTeamLeader(localPlayer, true) then
		local guiState = emGUI:dxIsWindowVisible(staffManagerMenu)
		if not (guiState) then
			showStaffManagerGUI()
		else
			emGUI:dxCloseWindow(staffManagerMenu)
		end
	end
end
addCommandHandler("staffs", showStaffManager)

-- Button Handlers
playerFound = false

function closeButtonEvent(button, state)
	if (button == "left") and (state == "down") then
		local guiState = emGUI:dxIsWindowVisible(adjustRankGUI)
		
		playerFound = false
		emGUI:dxCloseWindow(staffManagerMenu)
		if (guiState) then
			emGUI:dxCloseWindow(adjustRankGUI)
		end
	end
end

function updateStaffFeedbackLabel()
	local staffInputValue = emGUI:dxGetText(staffNameInput)

	if string.len(staffInputValue) >= 3 then
		triggerServerEvent("staffs:staffsFindPlayerByName", localPlayer, localPlayer, staffInputValue)
	else
		emGUI:dxSetText(feedbackLabelText, "Player not found.")
		emGUI:dxLabelSetColor(feedbackLabelText, 255, 0, 0)
		emGUI:dxSetText(staffRankLabel, "N/A")
		emGUI:dxSetText(devTeamLabel, "N/A")
		emGUI:dxSetText(vehicleTeamLabel, "N/A")
		emGUI:dxSetText(factionTeamLabel, "N/A")
		emGUI:dxSetText(mappingTeamLabel, "N/A")
		playerFound = false
	end
end

function staffs_returnAccountID(targetPlayer)
	playerFound = targetPlayer
end
addEvent("staffs:returnAccountID", true)
addEventHandler("staffs:returnAccountID", root, staffs_returnAccountID)

function c_updateStaffLabels(ranksTable)
	local defaultRank = "Player"
	local staffTitle, devTitle, vtTitle, ftTitle, mtTitle

	if ranksTable[1] == 6 then staffTitle = "Lead Manager"
		elseif ranksTable[1] == 5 then staffTitle = "Manager"
		elseif ranksTable[1] == 4 then staffTitle = "Lead Administrator"
		elseif ranksTable[1] == 3 then staffTitle = "Administrator"
		elseif ranksTable[1] == 2 then staffTitle = "Trial Administrator"
		elseif ranksTable[1] == 1 then staffTitle = "Helper"
		else staffTitle = defaultRank
	end

	if ranksTable[2] == 3 then devTitle = "Lead Developer"
		elseif ranksTable[2] == 2 then devTitle = "Developer"
		elseif ranksTable[2] == 1 then devTitle = "Trial Developer"
		else devTitle = defaultRank
	end

	if ranksTable[3] == 2 then vtTitle = "VT Leader"
		elseif ranksTable[3] == 1 then vtTitle = "VT Member"
		else vtTitle = defaultRank
	end

	if ranksTable[4] == 2 then ftTitle = "FT Leader"
		elseif ranksTable[4] == 1 then ftTitle = "FT Member"
		else ftTitle = defaultRank
	end

	if ranksTable[5] == 2 then mtTitle = "MT Leader"
		elseif ranksTable[5] == 1 then mtTitle = "MT Member"
		else mtTitle = defaultRank
	end

	emGUI:dxSetText(staffRankLabel, staffTitle)
	emGUI:dxSetText(devTeamLabel, devTitle)
	emGUI:dxSetText(vehicleTeamLabel, vtTitle)
	emGUI:dxSetText(factionTeamLabel, ftTitle)
	emGUI:dxSetText(mappingTeamLabel, mtTitle)
end
addEvent("staffs:updateStaffLabelsCall", true)
addEventHandler("staffs:updateStaffLabelsCall", root, c_updateStaffLabels)

function setStaffFeedbackLabel(message, r, g, b)
	emGUI:dxSetText(feedbackLabelText, message)
	emGUI:dxLabelSetColor(feedbackLabelText, r, g, b)
end
addEvent("staffSetFeedbackLabel", true)
addEventHandler("staffSetFeedbackLabel", getRootElement(), setStaffFeedbackLabel)

function staffRankButtonEvent(button, state)
	if (button == "left") and (state == "down") then

		if not playerFound then
			emGUI:dxSetText(feedbackLabelText, "Please input an account first!")
			emGUI:dxLabelSetColor(feedbackLabelText, 255, 0, 0)
			return false
		end

		local guiState = emGUI:dxIsWindowVisible(adjustRankGUI)
		if not (guiState) then
			triggerEvent("showStaffAdjustGUI", getRootElement(), 1, staffMember)
			emGUI:dxSetEnabled(staffNameInput, false)
			emGUI:dxSetAlpha(staffNameInput, 0.7)
		else
			emGUI:dxCloseWindow(adjustRankGUI)
			emGUI:dxSetEnabled(staffNameInput, true)
			emGUI:dxSetAlpha(staffNameInput, 1)
		end
	end
end

function vehicleTeamButtonEvent(button, state)
	if (button == "left") and (state == "down") then

		if not playerFound then
			emGUI:dxSetText(feedbackLabelText, "Please input an account first!")
			emGUI:dxLabelSetColor(feedbackLabelText, 255, 0, 0)
			return false
		end

		local guiState = emGUI:dxIsWindowVisible(adjustRankGUI)
		if not (guiState) then
			triggerEvent("showStaffAdjustGUI", getRootElement(), 2, staffMember)
			emGUI:dxSetEnabled(staffNameInput, false)
			emGUI:dxSetAlpha(staffNameInput, 0.7)
		else
			emGUI:dxCloseWindow(adjustRankGUI)
			emGUI:dxSetEnabled(staffNameInput, true)
			emGUI:dxSetAlpha(staffNameInput, 1)
		end
	end
end

function mappingTeamButtonEvent(button, state)
	if (button == "left") and (state == "down") then

		if not playerFound then
			emGUI:dxSetText(feedbackLabelText, "Please input an account first!")
			emGUI:dxLabelSetColor(feedbackLabelText, 255, 0, 0)
			return false
		end

		local guiState = emGUI:dxIsWindowVisible(adjustRankGUI)
		if not (guiState) then
			triggerEvent("showStaffAdjustGUI", getRootElement(), 3, staffMember)
			emGUI:dxSetEnabled(staffNameInput, false)
			emGUI:dxSetAlpha(staffNameInput, 0.7)
		else
			emGUI:dxCloseWindow(adjustRankGUI)
			emGUI:dxSetEnabled(staffNameInput, true)
			emGUI:dxSetAlpha(staffNameInput, 1)
		end
	end
end

function factionTeamButtonEvent(button, state)
	if (button == "left") and (state == "down") then

		if not playerFound then
			emGUI:dxSetText(feedbackLabelText, "Please input an account first!")
			emGUI:dxLabelSetColor(feedbackLabelText, 255, 0, 0)
			return false
		end

		local guiState = emGUI:dxIsWindowVisible(adjustRankGUI)
		if not (guiState) then
			triggerEvent("showStaffAdjustGUI", getRootElement(), 4, staffMember)
			emGUI:dxSetEnabled(staffNameInput, false)
			emGUI:dxSetAlpha(staffNameInput, 0.7)
		else
			emGUI:dxCloseWindow(adjustRankGUI)
			emGUI:dxSetEnabled(staffNameInput, true)
			emGUI:dxSetAlpha(staffNameInput, 1)
		end
	end
end

function devTeamButtonEvent(button, state)
	if (button == "left") and (state == "down") then

		if not playerFound then
			emGUI:dxSetText(feedbackLabelText, "Please input an account first!")
			emGUI:dxLabelSetColor(feedbackLabelText, 255, 0, 0)
			return false
		end

		local guiState = emGUI:dxIsWindowVisible(adjustRankGUI)
		if not (guiState) then
			triggerEvent("showStaffAdjustGUI", getRootElement(), 5, staffMember)
			emGUI:dxSetEnabled(staffNameInput, false)
			emGUI:dxSetAlpha(staffNameInput, 0.7)
		else
			emGUI:dxCloseWindow(adjustRankGUI)
			emGUI:dxSetEnabled(staffNameInput, true)
			emGUI:dxSetAlpha(staffNameInput, 1)
		end
	end
end

----------------------------------------------------------------------------------------------------------------------------------------------

--[[ Adjusters:
1 = Staff Rank
2 = Vehicle Team
3 = Mapping Team
4 = Faction Team
5 = Developer  ]]

identifier = nil

function showAdjustmentMenu(adjuster)
	adjustRankGUI = emGUI:dxCreateWindow(0.6195, 0.42, 0.18, 0.22, "", true, true, _, true)

	rankDisplayGrid = emGUI:dxCreateGridList(0.05, 0.02, 0.91, 0.62, true, adjustRankGUI, true)
	emGUI:dxGridListAddColumn(rankDisplayGrid, "Available Ranks", 0.97)

	if (adjuster == 1) then -- Staff Rank
		identifier = 1
		for i = 1, 7 do
			emGUI:dxGridListAddRow(rankDisplayGrid)
		end
		emGUI:dxGridListSetItemText(rankDisplayGrid, 1, 1, "Lead Manager", false, false)
		emGUI:dxGridListSetItemText(rankDisplayGrid, 2, 1, "Manager", false, false)
		emGUI:dxGridListSetItemText(rankDisplayGrid, 3, 1, "Lead Administrator", false, false)
		emGUI:dxGridListSetItemText(rankDisplayGrid, 4, 1, " Administrator", false, false)
		emGUI:dxGridListSetItemText(rankDisplayGrid, 5, 1, "Trial Administrator", false, false)
		emGUI:dxGridListSetItemText(rankDisplayGrid, 6, 1, "Helper", false, false)
		emGUI:dxGridListSetItemText(rankDisplayGrid, 7, 1, "No Rank", false, false)
	elseif (adjuster == 2) then -- Vehicle Team
		identifier = 2
		for i = 1, 3 do
			emGUI:dxGridListAddRow(rankDisplayGrid)
		end
		emGUI:dxGridListSetItemText(rankDisplayGrid, 1, 1, "VT Leader", false, false)
		emGUI:dxGridListSetItemText(rankDisplayGrid, 2, 1, "VT Member", false, false)
		emGUI:dxGridListSetItemText(rankDisplayGrid, 3, 1, "No Rank", false, false)
	elseif (adjuster == 3) then -- Mapping Team
		identifier = 3
		for i = 1, 3 do
			emGUI:dxGridListAddRow(rankDisplayGrid)
		end
		emGUI:dxGridListSetItemText(rankDisplayGrid, 1, 1, "MT Leader", false, false)
		emGUI:dxGridListSetItemText(rankDisplayGrid, 2, 1, "MT Member", false, false)
		emGUI:dxGridListSetItemText(rankDisplayGrid, 3, 1, "No Rank", false, false)
	elseif (adjuster == 4) then -- Faction Team
		identifier = 4
		for i = 1, 3 do
			emGUI:dxGridListAddRow(rankDisplayGrid)
		end
		emGUI:dxGridListSetItemText(rankDisplayGrid, 1, 1, "FT Leader", false, false)
		emGUI:dxGridListSetItemText(rankDisplayGrid, 2, 1, "FT Member", false, false)
		emGUI:dxGridListSetItemText(rankDisplayGrid, 3, 1, "No Rank", false, false)
	else -- Developer
		identifier = 5
		for i = 1, 4 do
			emGUI:dxGridListAddRow(rankDisplayGrid)
		end
		emGUI:dxGridListSetItemText(rankDisplayGrid, 1, 1, "Lead Developer", false, false)
		emGUI:dxGridListSetItemText(rankDisplayGrid, 2, 1, "Developer", false, false)
		emGUI:dxGridListSetItemText(rankDisplayGrid, 3, 1, "Trial Developer", false, false)
		emGUI:dxGridListSetItemText(rankDisplayGrid, 4, 1, "No Rank", false, false)
	end

	cancelAdjustButton = emGUI:dxCreateButton(0.05, 0.76, 0.40, 0.17, "Cancel", true, adjustRankGUI)
	addEventHandler("onClientDgsDxMouseClick", cancelAdjustButton, closeAdjustButtonEvent)

	
	applyAdjustButton = emGUI:dxCreateButton(0.56, 0.76, 0.40, 0.17, "Apply", true, adjustRankGUI)
	addEventHandler("onClientDgsDxMouseClick", applyAdjustButton, applyAdjustButtonEvent)
end
addEvent("showStaffAdjustGUI", true)
addEventHandler("showStaffAdjustGUI", getRootElement(), showAdjustmentMenu, adjuster)

function closeAdjustButtonEvent(button, state)
	if (button == "left") and (state == "down") then
		emGUI:dxCloseWindow(adjustRankGUI)
		emGUI:dxSetEnabled(staffNameInput, true)
		emGUI:dxSetAlpha(staffNameInput, 1)
	end
end

function applyAdjustButtonEvent(button, state)
	if (button == "left") and (state == "down") then
		local rank = emGUI:dxGridListGetSelectedItem(rankDisplayGrid)
		local staffInputValue = emGUI:dxGetText(staffNameInput)

		if (rank) == -1 then
			emGUI:dxSetText(feedbackLabelText, "Please make a rank selection!")
			emGUI:dxLabelSetColor(feedbackLabelText, 255, 0, 0)
			return false
		end

		triggerServerEvent("staff:applyRankAdjustment", localPlayer, localPlayer, identifier, rank, playerFound)
		emGUI:dxSetEnabled(staffNameInput, true)
		emGUI:dxSetAlpha(staffNameInput, 1)
		emGUI:dxCloseWindow(adjustRankGUI)

		identifier = nil
	end
end