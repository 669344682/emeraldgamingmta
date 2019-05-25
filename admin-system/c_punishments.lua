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

emGUI = exports.emGUI

buttonFont_35 = emGUI:dxCreateNewFont("fonts/buttonFont.ttf", 35)

pointLengths = { 6, 6, 12, 12, 18, 24, 36, 48, 72 }

playerFound = false
pointsToIssue = 1

function showPunishPlayerGUI()
	local uiState = emGUI:dxIsWindowVisible(punishWindow)

	if not (uiState) then
		punishLabels = {}
		punishWindow = emGUI:dxCreateWindow(0.37, 0.29, 0.26, 0.37, "Punish Player", true)

		punishLabels[1] = emGUI:dxCreateLabel(0.05, 0.14, 0.17, 0.05, "Player Name/ID", true, punishWindow)
		punishLabels[2] = emGUI:dxCreateLabel(0.05, 0.34, 0.07, 0.04, "Points", true, punishWindow)
		punishLabels[3] = emGUI:dxCreateLabel(0.05, 0.52, 0.36, 0.05, "Reason For Punishment", true, punishWindow)
		punishLabels[4] = emGUI:dxCreateLabel(0.13, 0.69, 0.74, 0.04, "Please ensure that all details above are correct before proceeding.", true, punishWindow)
		emGUI:dxLabelSetHorizontalAlign(punishLabels[4], "center")
		
		playerFeedbackLabel = emGUI:dxCreateLabel(0.60, 0.19, 0.33, 0.08, "Please input a player name\nor ID.", true, punishWindow)
		emGUI:dxLabelSetHorizontalAlign(playerFeedbackLabel, "center")

		targetPlayerInput = emGUI:dxCreateEdit(0.05, 0.20, 0.50, 0.07, "", true, punishWindow)
		addEventHandler("onClientDgsDxGUITextChange", targetPlayerInput, p_updatePlayerFoundLabel)
		pointsInput = emGUI:dxCreateEdit(0.05, 0.40, 0.10, 0.07, "", true, punishWindow)
		emGUI:dxEditSetMaxLength(pointsInput, 2)

		banReasonInput = emGUI:dxCreateEdit(0.05, 0.58, 0.50, 0.07, "", true, punishWindow)
		emGUI:dxEditSetMaxLength(banReasonInput, 45)

		permBanCheck = emGUI:dxCreateCheckBox(0.18, 0.415, 0.23, 0.04, "Permanent Ban?", false, true, punishWindow)
		addEventHandler("onDgsCheckBoxChange", permBanCheck, permBanCheckUpdate)
		
		cancelButton = emGUI:dxCreateButton(0.08, 0.77, 0.33, 0.18, "CANCEL", true, punishWindow)
		addEventHandler("onClientDgsDxMouseClick", cancelButton, cancelButtonClick)
		submitButton = emGUI:dxCreateButton(0.59, 0.77, 0.33, 0.18, "SUBMIT", true, punishWindow)
		addEventHandler("onClientDgsDxMouseClick", submitButton, submitButtonClick)
	else
		emGUI:dxCloseWindow(punishWindow)
	end
end
addEvent("admin:showPunishPlayerGUI", true)
addEventHandler("admin:showPunishPlayerGUI", root, showPunishPlayerGUI)

----------------------------

function punishConfirminationGUI()
	local punishLabels = {}
	punishConfirmGUI = emGUI:dxCreateWindow(0.35, 0.41, 0.30, 0.18, "", true, true, _, true, _, _, _, tocolor(0, 0, 0, 230), _, tocolor(0, 0, 0, 230))

	punishLabels[5] = emGUI:dxCreateLabel(0.28, -0.07, 0.51, 0.26, "CONFIRM", true, punishConfirmGUI)

	local targetPlayerName = getPlayerName(playerFound); targetPlayerName = targetPlayerName:gsub("_", " ")
	local targetAccountName = getElementData(playerFound, "account:username")
	local pointToLength = "1"
	if (pointsToIssue >= 10) then
		pointToLength = "Permanent"
	else
		pointToLength = pointLengths[pointsToIssue] .. " hour"
	end

	confirmLabel = emGUI:dxCreateLabel(0.12, 0.30, 0.75, 0.20, "Are you sure you would like to punish " .. targetPlayerName .. " (" .. targetAccountName .. ")?\nThis will result in a " .. pointToLength .. " ban.", true, punishConfirmGUI)
	emGUI:dxLabelSetHorizontalAlign(confirmLabel, "center")
	emGUI:dxSetFont(punishLabels[5], buttonFont_35)

	punishNoButton = emGUI:dxCreateButton(0.06, 0.57, 0.40, 0.33, "NO", true, punishConfirmGUI)
	addEventHandler("onClientDgsDxMouseClick", punishNoButton, punishNoButtonClick)
	punishYesButton = emGUI:dxCreateButton(0.54, 0.57, 0.40, 0.33, "I'M SURE", true, punishConfirmGUI, _, _, _, _, _, _, _, tocolor(240, 0, 0))
	addEventHandler("onClientDgsDxMouseClick", punishYesButton, punishYesButtonClick)
end

----------------------------

function p_updatePlayerFoundLabel()
	local targetInputValue = emGUI:dxGetText(targetPlayerInput)
	local targetPlayer, targetPlayerName = exports.global:getPlayerFromPartialNameOrID(targetInputValue, localPlayer)

	if (targetPlayer) and string.len(targetInputValue) >= 1 and (getElementData(targetPlayer, "loggedin") == 1) then
		local targetAccountName = getElementData(targetPlayer, "account:username") or "Unknown"
		emGUI:dxSetText(playerFeedbackLabel, "Player found:\n".. targetPlayerName .. " (" .. targetAccountName .. ")")
		emGUI:dxLabelSetColor(playerFeedbackLabel, 0, 255, 0)
		playerFound = targetPlayer
	else
		emGUI:dxSetText(playerFeedbackLabel, "Player not found.")
		emGUI:dxLabelSetColor(playerFeedbackLabel, 255, 0, 0)
		playerFound = false
	end
end

function permBanCheckUpdate(state)
	if (state) then
		emGUI:dxSetEnabled(pointsInput, false)
		emGUI:dxSetText(pointsInput, 10)
	else
		emGUI:dxSetEnabled(pointsInput, true)
	end
end

function cancelButtonClick(button, state)
	if (button == "left") and (state == "down") then
		emGUI:dxCloseWindow(punishWindow)
	end
end

function submitButtonClick(button, state)
	if (button == "left") and (state == "down") then
		local pointCount = emGUI:dxGetText(pointsInput)
		local banReason = emGUI:dxGetText(banReasonInput)
		
		if (string.len(banReason) < 1) then
			emGUI:dxSetText(punishLabels[4], "Please input a ban reason!")
			emGUI:dxLabelSetColor(punishLabels[4], 255, 0, 0)
			return false
		end

		if tonumber(pointCount) and (tonumber(pointCount) >= 1) and (tonumber(pointCount) <= 10) then
			if (playerFound) then
				pointsToIssue = tonumber(pointCount)
				punishConfirminationGUI()
				emGUI:dxSetEnabled(punishWindow, false)
				emGUI:dxSetText(punishLabels[4], "")
			else
				emGUI:dxSetText(punishLabels[4], "Please input a valid player!")
				emGUI:dxLabelSetColor(punishLabels[4], 255, 0, 0)
			end
		else
			emGUI:dxSetText(punishLabels[4], "Please input a valid amount of points to issue!")
			emGUI:dxLabelSetColor(punishLabels[4], 255, 0, 0)
		end
	end
end

function punishNoButtonClick(button, state)
	if (button == "left") and (state == "down") then
		emGUI:dxSetEnabled(punishWindow, true)
		emGUI:dxCloseWindow(punishConfirmGUI)
	end
end

function punishYesButtonClick(button, state)
	if (button == "left") and (state == "down") then
		local banReason = emGUI:dxGetText(banReasonInput)
		outputDebugString("Received " .. getPlayerName(playerFound) .. ": length: " .. pointsToIssue .. " for reason: " .. emGUI:dxGetText(banReasonInput), 3)
		triggerServerEvent("admin:punishPlayer", localPlayer, localPlayer, playerFound, pointsToIssue, banReason)
		emGUI:dxCloseWindow(punishWindow)
		emGUI:dxCloseWindow(punishConfirmGUI)
	end
end

--------------

function c_showAccountHistory(historyTable, accountName)
	local guiState = emGUI:dxIsWindowVisible(accHistoryGUI)
	if (guiState) then
		emGUI:dxCloseWindow(accHistoryGUI)
	end
	
	if not type(historyTable) == "table" or not (historyTable) then
		outputDebugString("[admin-system] @c_showAccountHistory: historyTable received is empty or not a table.", 3)
		return false
	end

	if not tostring(accountName) then accountName = "Unknown" end

	accHistoryGUI = emGUI:dxCreateWindow(0.25, 0.20, 0.50, 0.53, accountName .." - Account History", true)

	historyGridList = emGUI:dxCreateGridList(0.034, 0.08, 0.93, 0.74, true, accHistoryGUI)
	emGUI:dxGridListAddColumn(historyGridList, "ID", 0) -- Hidden column, not displayed.
	emGUI:dxGridListAddColumn(historyGridList, "Date Issued", 0.18)
	emGUI:dxGridListAddColumn(historyGridList, "Issued By", 0.13)
	emGUI:dxGridListAddColumn(historyGridList, "Reason", 0.46)
	emGUI:dxGridListAddColumn(historyGridList, "Ban Length", 0.13)
	emGUI:dxGridListAddColumn(historyGridList, "Points", 0.09)

	for i, index in ipairs(historyTable) do
		emGUI:dxGridListAddRow(historyGridList)

		emGUI:dxGridListSetItemText(historyGridList, i, 1, historyTable[i][1])
		emGUI:dxGridListSetItemText(historyGridList, i, 2, historyTable[i][2])
		emGUI:dxGridListSetItemText(historyGridList, i, 3, historyTable[i][3])
		emGUI:dxGridListSetItemText(historyGridList, i, 4, historyTable[i][4])
		emGUI:dxGridListSetItemText(historyGridList, i, 5, historyTable[i][5])
		emGUI:dxGridListSetItemText(historyGridList, i, 6, historyTable[i][6])
	end
	addEventHandler("onClientDgsDxMouseClick", historyGridList, gridListItemSelected)
	
	if (getElementData(localPlayer, "staff:rank") > 1) then
		closeHistoryButton = emGUI:dxCreateButton(0.20, 0.84, 0.20, 0.13, "CLOSE", true, accHistoryGUI)
		addEventHandler("onClientDgsDxMouseClick", closeHistoryButton, closeHistoryButtonClick)
		removeHistoryButton = emGUI:dxCreateButton(0.60, 0.84, 0.20, 0.13, "REMOVE HISTORY", true, accHistoryGUI)
		addEventHandler("onClientDgsDxMouseClick", removeHistoryButton, removeHistoryButtonClick)

		emGUI:dxSetEnabled(removeHistoryButton, false)
	else
		closeHistoryButton = emGUI:dxCreateButton(0.38, 0.84, 0.23, 0.13, "CLOSE", true, accHistoryGUI)
		addEventHandler("onClientDgsDxMouseClick", closeHistoryButton, closeHistoryButtonClick)
	end
end
addEvent("admin:showAccountHistory", true)
addEventHandler("admin:showAccountHistory", root, c_showAccountHistory)

function gridListItemSelected()
	if (removeHistoryButton) then
		local selected = emGUI:dxGridListGetSelectedItem(historyGridList)
		if (selected) and (selected ~= -1) then
			emGUI:dxSetEnabled(removeHistoryButton, true)
		end
	end
end

function closeHistoryButtonClick(button, state)
	if (button == "left") and (state == "down") then
		emGUI:dxCloseWindow(accHistoryGUI)
	end
end

function removeHistoryButtonClick(button, state)
	if (button == "left") and (state == "down") then
		local selected = emGUI:dxGridListGetSelectedItem(historyGridList)

		if (selected) and (selected ~= -1) then
			local punishID = emGUI:dxGridListGetItemText(historyGridList, selected, 1)
			triggerServerEvent("admin:removeHistoryEntry", localPlayer, localPlayer, punishID)
			emGUI:dxCloseWindow(accHistoryGUI)
		end
	end
end