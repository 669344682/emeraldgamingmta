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
buttonFont_16 = emGUI:dxCreateNewFont("fonts/buttonFont.ttf", 16)

local checkingIntID = false
local interiorExists = false
local isManager = false
local isLead = false
local isAdmin = false

function openCheckInteriorGUI(theInterior, interiorData, interiorLogs, namesTable, ownerName)
	if (emGUI:dxIsWindowVisible(checkIntGUI)) then emGUI:dxCloseWindow(checkIntGUI) end

	checkingIntID = interiorData.id
	interiorExists = interiorData.deleted == 0

	if exports.global:isPlayerManager(localPlayer, true) then isManager = true; isLead = true; isAdmin = true
		elseif exports.global:isPlayerLeadAdmin(localPlayer, true) then isLead = true; isAdmin = true
		elseif exports.global:isPlayerTrialAdmin(localPlayer, true) then isAdmin = true
	end

	local checkIntGUILabels = {}

	checkIntGUI = emGUI:dxCreateWindow(0.25, 0.20, 0.50, 0.60, "[ID #" .. checkingIntID .. "] " .. interiorData.name, true, _, true)

	checkIntGUILabels[1] = emGUI:dxCreateLabel(0.02, 0.02, 0.10, 0.03, "Interior ID:", true, checkIntGUI)
	checkIntGUILabels[2] = emGUI:dxCreateLabel(0.02, 0.05, 0.10, 0.03, "Price:", true, checkIntGUI)
	checkIntGUILabels[3] = emGUI:dxCreateLabel(0.02, 0.08, 0.10, 0.03, "Owner:", true, checkIntGUI)
	checkIntGUILabels[4] = emGUI:dxCreateLabel(0.02, 0.11, 0.10, 0.03, "Dimension:", true, checkIntGUI)
	checkIntGUILabels[5] = emGUI:dxCreateLabel(0.02, 0.14, 0.10, 0.03, "Interior:", true, checkIntGUI)

	checkIntGUILabels[6] = emGUI:dxCreateLabel(0.33, 0.02, 0.10, 0.03, "Deleted:", true, checkIntGUI)
	checkIntGUILabels[7] = emGUI:dxCreateLabel(0.33, 0.05, 0.10, 0.03, "Disabled:", true, checkIntGUI)
	checkIntGUILabels[8] = emGUI:dxCreateLabel(0.33, 0.08, 0.10, 0.03, "Locked:", true, checkIntGUI)
	checkIntGUILabels[9] = emGUI:dxCreateLabel(0.33, 0.11, 0.10, 0.03, "Players Inside:", true, checkIntGUI)
	checkIntGUILabels[10] = emGUI:dxCreateLabel(0.33, 0.14, 0.10, 0.03, "Location:", true, checkIntGUI)

	checkIntGUILabels[11] = emGUI:dxCreateLabel(0.68, 0.02, 0.10, 0.03, "Creation Date:", true, checkIntGUI)
	checkIntGUILabels[12] = emGUI:dxCreateLabel(0.68, 0.05, 0.10, 0.03, "Created by:", true, checkIntGUI)
	checkIntGUILabels[13] = emGUI:dxCreateLabel(0.68, 0.08, 0.10, 0.03, "Last Used:", true, checkIntGUI)
	checkIntGUILabels[14] = emGUI:dxCreateLabel(0.68, 0.11, 0.10, 0.03, "Custom Interior:", true, checkIntGUI)
	checkIntGUILabels[15] = emGUI:dxCreateLabel(0.68, 0.14, 0.10, 0.03, "Interior Type:", true, checkIntGUI)
	
	for i = 1, #checkIntGUILabels do emGUI:dxLabelSetHorizontalAlign(checkIntGUILabels[i], "right") end

	intIDLabel = emGUI:dxCreateLabel(0.13, 0.02, 0.18, 0.03, checkingIntID, true, checkIntGUI)
	intModelID = emGUI:dxCreateLabel(0.13, 0.05, 0.18, 0.03, "$" .. exports.global:formatNumber(interiorData.price), true, checkIntGUI)

	intDimLabel = emGUI:dxCreateLabel(0.13, 0.11, 0.18, 0.03, interiorData.dimension, true, checkIntGUI)
	intIntLabel = emGUI:dxCreateLabel(0.13, 0.14, 0.18, 0.03, interiorData.interior, true, checkIntGUI)
	intOwnerLabel = emGUI:dxCreateLabel(0.13, 0.08, 0.18, 0.03, ownerName, true, checkIntGUI)

	local deletedState = "No"; if interiorData.deleted == 1 then deletedState = "Yes" end
	intDeletedLabel = emGUI:dxCreateLabel(0.44, 0.02, 0.18, 0.03, deletedState, true, checkIntGUI)
	
	local disabledState = "No"; if interiorData.disabled == 1 then disabledState = "Yes" end
	intDisabledLabel = emGUI:dxCreateLabel(0.44, 0.05, 0.18, 0.03, disabledState, true, checkIntGUI)
	
	local lockedState = "No"
	if isElement(theInterior) then
		local locked = getElementData(theInterior, "interior:locked")
		if locked then lockedState = "Yes" end
	else
		if interiorData.locked == 1 then lockedState = "Yes" end
	end

	intLockedLabel = emGUI:dxCreateLabel(0.44, 0.08, 0.18, 0.03, lockedState, true, checkIntGUI)
	local playersInside = 0
	for i, player in ipairs(getElementsByType("player")) do if getElementData(player, "character:realininterior") == checkingIntID then playersInside = playersInside + 1 end end
	playersInsideLabel = emGUI:dxCreateLabel(0.44, 0.11, 0.18, 0.03, playersInside, true, checkIntGUI)
	
	local pos = split(interiorData.location, ",")
	local locationName = getZoneName(pos[1], pos[2], pos[3])
	local locationCity = getZoneName(pos[1], pos[2], pos[3], true)
	if (interiorData.dimension ~= 0) then locationName = "Inside Interior #" .. interiorData.dimension else if locationName ~= locationCity then locationName = locationName .. ", " .. locationCity end end
	intLocationLabel = emGUI:dxCreateLabel(0.44, 0.14, 0.18, 0.03, locationName, true, checkIntGUI)
	
	local createdString = exports.global:convertTime(interiorData.created_date)
	intCreatedLabel = emGUI:dxCreateLabel(0.79, 0.02, 0.17, 0.03, createdString[2] .. " at " .. createdString[1], true, checkIntGUI)
	intCreatorLabel = emGUI:dxCreateLabel(0.79, 0.05, 0.17, 0.03, interiorData.created_by, true, checkIntGUI)

	local lastUsedTime = exports.global:convertTime(interiorData.last_used)
	intLastUsedLabel = emGUI:dxCreateLabel(0.79, 0.08, 0.17, 0.03, lastUsedTime[2] .. " at " .. lastUsedTime[1], true, checkIntGUI)
	
	local customIntState = "No"; if interiorData.custom_int then customIntState = "Yes" end
	intCustomLabel = emGUI:dxCreateLabel(0.79, 0.11, 0.17, 0.03, customIntState, true, checkIntGUI)
	intTypeLabel = emGUI:dxCreateLabel(0.79, 0.14, 0.17, 0.03, g_interiorTypes[interiorData.type][1], true, checkIntGUI)

	logsTabPanel = emGUI:dxCreateTabPanel(0.02, 0.25, 0.74, 0.71, true, checkIntGUI)
	local logsTabPanelTab1 = emGUI:dxCreateTab("Staff Notes", logsTabPanel)
		staffNotesGridlist = emGUI:dxCreateGridList(0, 0, 1, 1, true, logsTabPanelTab1, true)
		emGUI:dxGridListAddColumn(staffNotesGridlist, "ID", 0.06)
		emGUI:dxGridListAddColumn(staffNotesGridlist, "Added by", 0.16)
		emGUI:dxGridListAddColumn(staffNotesGridlist, "Time", 0.21)
		emGUI:dxGridListAddColumn(staffNotesGridlist, "Log", 0.57)

	local logsTabPanelTab2 = emGUI:dxCreateTab("Interior Logs", logsTabPanel)
		intLogsGridlist = emGUI:dxCreateGridList(0, 0, 1, 1, true, logsTabPanelTab2, true)
		emGUI:dxGridListAddColumn(intLogsGridlist, "ID", 0.06)
		emGUI:dxGridListAddColumn(intLogsGridlist, "Added by", 0.16)
		emGUI:dxGridListAddColumn(intLogsGridlist, "Time", 0.21)
		emGUI:dxGridListAddColumn(intLogsGridlist, "Log", 0.57)

	for i, theLog in ipairs(interiorLogs) do
		local gridToInsert = staffNotesGridlist
		if (theLog.isnote == 0) then gridToInsert = intLogsGridlist end
		
		local row = emGUI:dxGridListAddRow(gridToInsert)
		emGUI:dxGridListSetItemText(gridToInsert, row, 1, theLog.id)
		emGUI:dxGridListSetItemText(gridToInsert, row, 2, namesTable[i])
		local timeString = exports.global:convertTime(theLog.time)
		emGUI:dxGridListSetItemText(gridToInsert, row, 3, timeString[2] .. " at " .. timeString[1])

		if (theLog.isnote == 1) and (#theLog.log > 60) or string.find(theLog.log, "\n") then
			emGUI:dxGridListSetItemText(gridToInsert, row, 4, "[Double click to view this log.]")
		else
			emGUI:dxGridListSetItemText(gridToInsert, row, 4, theLog.log)
		end
	end

	checkIntGUIMemoLabels = {}
	staffNotesMemo = emGUI:dxCreateMemo(0.02, 0.38, 0.74, 0.5, "", true, checkIntGUI)
	emGUI:dxSetVisible(staffNotesMemo, false)

	interiorLogsMemo = emGUI:dxCreateMemo(0.02, 0.38, 0.74, 0.5, "", true, checkIntGUI)
	emGUI:dxSetVisible(interiorLogsMemo, false)
	emGUI:dxMemoSetReadOnly(interiorLogsMemo, true)


	checkIntGUIMemoLabels[1] = emGUI:dxCreateLabel(0.02, 0.29, 0.10, 0.03, "Log ID:", true, checkIntGUI)
	checkIntGUIMemoLabels[2] = emGUI:dxCreateLabel(0.02, 0.32, 0.10, 0.03, "Added by:", true, checkIntGUI)
	checkIntGUIMemoLabels[3] = emGUI:dxCreateLabel(0.32, 0.29, 0.10, 0.03, "Created:", true, checkIntGUI)
	checkIntGUIMemoLabels[4] = emGUI:dxCreateLabel(0.32, 0.32, 0.10, 0.03, "Last Updated:", true, checkIntGUI)
	for i = 1, #checkIntGUIMemoLabels do
		emGUI:dxLabelSetHorizontalAlign(checkIntGUIMemoLabels[i], "right")
		emGUI:dxSetVisible(checkIntGUIMemoLabels[i], false)
	end

	logIDLabel = emGUI:dxCreateLabel(0.13, 0.29, 0.18, 0.03, "0", true, checkIntGUI)
	logStaffNameLabel = emGUI:dxCreateLabel(0.13, 0.32, 0.18, 0.03, "staffName", true, checkIntGUI)
	logCreatedLabel = emGUI:dxCreateLabel(0.43, 0.29, 0.18, 0.03, "DD/MM/YYYY at HH:MM:SS", true, checkIntGUI)
	loglastUpdatedLabel = emGUI:dxCreateLabel(0.43, 0.32, 0.18, 0.03, "DD/MM/YYYY at HH:MM:SS", true, checkIntGUI)
	emGUI:dxSetVisible(logIDLabel, false)
	emGUI:dxSetVisible(logStaffNameLabel, false)
	emGUI:dxSetVisible(logCreatedLabel, false)
	emGUI:dxSetVisible(loglastUpdatedLabel, false)

	triggerEvent("hud:mouse", localPlayer)

	logsUpdateButton = emGUI:dxCreateButton(0.78, 0.38, 0.20, 0.10, "UPDATE", true, checkIntGUI)
	addEventHandler("onClientDgsDxMouseClick", logsUpdateButton, logsUpdateButtonClick)
	emGUI:dxSetVisible(logsUpdateButton, false)

	logsBackButton = emGUI:dxCreateButton(0.78, 0.5, 0.20, 0.10, "BACK", true, checkIntGUI)
	addEventHandler("onClientDgsDxMouseClick", logsBackButton, logsBackButtonClick)
	emGUI:dxSetVisible(logsBackButton, false)

	noticeLabel1 = emGUI:dxCreateLabel(0.257, 0.31, 0.05, 0.03, "ADD INTERIOR NOTE", true, checkIntGUI)
	noticeLabel2 = emGUI:dxCreateLabel(0.05, 0.91, 0.05, 0.03, "Be sure to leave your name and date when adding notes.", true, checkIntGUI)
	emGUI:dxSetFont(noticeLabel1, buttonFont_16)


	copyNameDate = emGUI:dxCreateButton(0.47, 0.9, 0.20, 0.05, "COPY NAME & DATE", true, checkIntGUI)
	addEventHandler("onClientDgsDxMouseClick", copyNameDate, copyNameDateClick)
	saveNoteButton = emGUI:dxCreateButton(0.78, 0.49, 0.20, 0.10, "Save Note", true, checkIntGUI)
	addEventHandler("onClientDgsDxMouseClick", saveNoteButton, saveNoteButtonClick)
	cancelNoteButton = emGUI:dxCreateButton(0.78, 0.61, 0.20, 0.10, "Cancel", true, checkIntGUI)
	addEventHandler("onClientDgsDxMouseClick", cancelNoteButton, cancelNoteButtonClick)
	emGUI:dxSetVisible(noticeLabel1, false)
	emGUI:dxSetVisible(noticeLabel2, false)
	emGUI:dxSetVisible(copyNameDate, false)
	emGUI:dxSetVisible(saveNoteButton, false)
	emGUI:dxSetVisible(cancelNoteButton, false)

	gotointButton = emGUI:dxCreateButton(0.78, 0.25, 0.20, 0.10, "GO TO INTERIOR", true, checkIntGUI)
	addEventHandler("onClientDgsDxMouseClick", gotointButton, gotointButtonClick)
	gotointinsideButton = emGUI:dxCreateButton(0.78, 0.37, 0.20, 0.10, "GO INSIDE\nINTERIOR", true, checkIntGUI)
	addEventHandler("onClientDgsDxMouseClick", gotointinsideButton, gotointinsideButtonClick)
	reloadIntButton = emGUI:dxCreateButton(0.78, 0.49, 0.20, 0.10, "RELOAD INTERIOR", true, checkIntGUI)
	addEventHandler("onClientDgsDxMouseClick", reloadIntButton, reloadIntButtonClick)
	addnoteButton = emGUI:dxCreateButton(0.78, 0.61, 0.20, 0.10, "ADD NOTE", true, checkIntGUI)
	addEventHandler("onClientDgsDxMouseClick", addnoteButton, addnoteButtonClick)
	
	if (isAdmin) then
		restoreIntButton = emGUI:dxCreateButton(0.78, 0.73, 0.20, 0.10, "RESTORE INTERIOR", true, checkIntGUI)
		addEventHandler("onClientDgsDxMouseClick", restoreIntButton, restoreIntButtonClick)
		emGUI:dxSetVisible(restoreIntButton, false)

		delIntButton = emGUI:dxCreateButton(0.78, 0.73, 0.20, 0.10, "DELETE INTERIOR", true, checkIntGUI)
		addEventHandler("onClientDgsDxMouseClick", delIntButton, delIntButtonClick)
		
		if not (interiorExists) then
			emGUI:dxSetVisible(delIntButton, false)
			emGUI:dxSetVisible(restoreIntButton, true)
		end
	end

	if (isManager) then
		showSaveInvButton = emGUI:dxCreateButton(0.78, 0.85, 0.20, 0.10, "SHOW SAFE\nINVENTORY", true, checkIntGUI)
		addEventHandler("onClientDgsDxMouseClick", showSaveInvButton, showSaveInvButtonClick)

		deleteNoteButton = emGUI:dxCreateButton(0.78, 0.62, 0.20, 0.10, "DELETE", true, checkIntGUI)
		addEventHandler("onClientDgsDxMouseClick", deleteNoteButton, deleteNoteButtonClick)
		emGUI:dxSetVisible(deleteNoteButton, false)
	end

	if not (interiorExists) then
		emGUI:dxSetEnabled(gotointButton, false)
		emGUI:dxSetEnabled(gotointinsideButton, false)
		emGUI:dxSetEnabled(reloadIntButton, false)
	end

	addEventHandler("ondxGridListItemDoubleClick", staffNotesGridlist, function(b, s, id)
		if b == "left" and s == "down" and (id) then
			local logID = emGUI:dxGridListGetItemText(staffNotesGridlist, id, 1); logID = tonumber(logID)
			local selectedLog
			for x, theLog in ipairs(interiorLogs) do
				if (theLog.id == logID) then
					selectedLog = theLog
					break
				end
			end
			local logStaff = emGUI:dxGridListGetItemText(staffNotesGridlist, id, 2)
			local logCreated = exports.global:convertTime(selectedLog.time, true) or "Unknown"
			local logUpdated = exports.global:convertTime(selectedLog.last_updated, true) or "Unknown"
			local logText = selectedLog.log
			viewLogNote(true, logID, logStaff, logCreated, logUpdated, logText)
		end
	end)

	addEventHandler("ondxGridListItemDoubleClick", intLogsGridlist, function(b, s, id)
		if b == "left" and s == "down" and (id) then
			local logID = emGUI:dxGridListGetItemText(intLogsGridlist, id, 1); logID = tonumber(logID)
			local selectedLog
			for x, theLog in ipairs(interiorLogs) do
				if (theLog.id == logID) then
					selectedLog = theLog
					break
				end
			end
			local logStaff = emGUI:dxGridListGetItemText(intLogsGridlist, id, 2)
			local logCreated = exports.global:convertTime(selectedLog.time, true) or "Unknown"
			local logUpdated = exports.global:convertTime(selectedLog.last_updated, true) or "Unknown"
			local logText = selectedLog.log
			emGUI:dxSetPosition(logsBackButton, 0.78, 0.38, true)
			viewLogNote(false, logID, logStaff, logCreated, logUpdated, logText)
		end
	end)

	addEventHandler("onClientDgsDxWindowClose", checkIntGUI, function()
		triggerEvent("hud:hidemouse", localPlayer)
		checkingIntID = false
		interiorExists = false
		isManager = false
		isLead = false
		isAdmin = false
	end)
end
addEvent("interior:checkinteriorgui", true)
addEventHandler("interior:checkinteriorgui", root, openCheckInteriorGUI)

--------------------------- FUNCTIONS ---------------------------
function viewLogNote(UI, id, staff, created, updated, logText)
	if not tostring(logText) then logText = "" end
	if (UI) then
		emGUI:dxMemoSetReadOnly(interiorLogsMemo, true)
		emGUI:dxSetVisible(staffNotesMemo, true)
		emGUI:dxSetText(staffNotesMemo, logText)
		emGUI:dxSetVisible(noticeLabel2, true)
		emGUI:dxSetVisible(copyNameDate, true)
		emGUI:dxSetVisible(logsUpdateButton, true)
		if (isManager) then emGUI:dxSetVisible(deleteNoteButton, true) end
		emGUI:dxSetVisible(loglastUpdatedLabel, true)
		emGUI:dxSetText(loglastUpdatedLabel, updated[2] .. " at " .. updated[1])
	else
		emGUI:dxSetVisible(interiorLogsMemo, true)
		emGUI:dxSetText(interiorLogsMemo, logText)
	end

	emGUI:dxSetVisible(logsTabPanel, false)
	emGUI:dxSetVisible(gotointButton, false)
	emGUI:dxSetVisible(gotointinsideButton, false)
	emGUI:dxSetVisible(reloadIntButton, false)
	emGUI:dxSetVisible(addnoteButton, false)
	if (isAdmin) then
		emGUI:dxSetVisible(delIntButton, false)
		emGUI:dxSetVisible(restoreIntButton, false)
	end
	if (isManager) then emGUI:dxSetVisible(showSaveInvButton, false) end

	local lp = #checkIntGUIMemoLabels
	if not (UI) then lp = lp - 1 end
	for i = 1, lp do
		emGUI:dxSetVisible(checkIntGUIMemoLabels[i], true)
	end
	emGUI:dxSetVisible(logIDLabel, true)
	emGUI:dxSetVisible(logStaffNameLabel, true)
	emGUI:dxSetVisible(logCreatedLabel, true)
	emGUI:dxSetVisible(logsBackButton, true)

	emGUI:dxSetText(logIDLabel, id)
	emGUI:dxSetText(logStaffNameLabel, staff)
	emGUI:dxSetText(logCreatedLabel, created[2] .. " at " .. created[1])
end

function toAddNote()
	emGUI:dxSetVisible(logsTabPanel, false)
	emGUI:dxSetVisible(gotointButton, false)
	emGUI:dxSetVisible(gotointinsideButton, false)
	emGUI:dxSetVisible(reloadIntButton, false)
	emGUI:dxSetVisible(addnoteButton, false)
	if (isAdmin) then
		emGUI:dxSetVisible(delIntButton, false)
		emGUI:dxSetVisible(restoreIntButton, false)
	end
	if (isManager) then emGUI:dxSetVisible(showSaveInvButton, false) end

	emGUI:dxSetVisible(staffNotesMemo, true)
	emGUI:dxSetVisible(noticeLabel1, true)
	emGUI:dxSetVisible(noticeLabel2, true)
	emGUI:dxSetVisible(copyNameDate, true)
	emGUI:dxSetVisible(saveNoteButton, true)
	emGUI:dxSetVisible(cancelNoteButton, true)
end

function toMainView(fromUI)
	emGUI:dxMemoClearText(staffNotesMemo)
	emGUI:dxMemoClearText(interiorLogsMemo)
	emGUI:dxSetVisible(staffNotesMemo, false)
	emGUI:dxSetVisible(interiorLogsMemo, false)

	if (fromUI == 1) then
		for i = 1, #checkIntGUIMemoLabels do
			emGUI:dxSetVisible(checkIntGUIMemoLabels[i], false)
		end
		emGUI:dxSetVisible(logIDLabel, false)
		emGUI:dxSetVisible(logStaffNameLabel, false)
		emGUI:dxSetVisible(logCreatedLabel, false)
		emGUI:dxSetVisible(loglastUpdatedLabel, false)

		emGUI:dxSetVisible(logsUpdateButton, false)
		if (isManager) then emGUI:dxSetVisible(deleteNoteButton, false) end
		emGUI:dxSetVisible(logsBackButton, false)
	elseif (fromUI == 2) then
		emGUI:dxSetVisible(noticeLabel1, false)

		emGUI:dxSetVisible(saveNoteButton, false)
		emGUI:dxSetVisible(cancelNoteButton, false)
	else return false end

	emGUI:dxSetPosition(logsBackButton, 0.78, 0.5, true)
	emGUI:dxSetVisible(noticeLabel2, false)
	emGUI:dxSetVisible(copyNameDate, false)

	emGUI:dxSetVisible(logsTabPanel, true)
	emGUI:dxSetVisible(gotointButton, true)
	emGUI:dxSetVisible(gotointinsideButton, true)
	emGUI:dxSetVisible(reloadIntButton, true)
	emGUI:dxSetVisible(addnoteButton, true)
	
	if (isAdmin) then
		if (interiorExists) then
			emGUI:dxSetVisible(delIntButton, true)
		else
			emGUI:dxSetVisible(restoreIntButton, true)
		end
	end
	if (isManager) then emGUI:dxSetVisible(showSaveInvButton, true) end
end

--------------------------- BUTTONS ---------------------------
function gotointButtonClick(button, state)
	if (button == "left") and (state == "down") then
		triggerServerEvent("interior:gotoint", localPlayer, localPlayer, "gotoint", checkingIntID)
		emGUI:dxCloseWindow(checkIntGUI)
	end
end

function gotointinsideButtonClick(button, state)
	if (button == "left") and (state == "down") then
		triggerServerEvent("interior:gotoint", localPlayer, localPlayer, "gotointi", checkingIntID)
		emGUI:dxCloseWindow(checkIntGUI)
	end
end

function reloadIntButtonClick(button, state)
	if (button == "left") and (state == "down") then
		triggerServerEvent("interior:reloadintcall", localPlayer, localPlayer, "ui", checkingIntID)
	end
end

function delIntButtonClick(button, state)
	if (button == "left") and (state == "down") then
		local isDeleting = getElementData(localPlayer, "temp:isdeletingint")
		if not (isDeleting == checkingIntID) then
			triggerServerEvent("interior:deleteintcall", localPlayer, localPlayer, "ui", checkingIntID)
			emGUI:dxSetText(delIntButton, "CONFIRM DELETION")
		else
			emGUI:dxSetEnabled(delIntButton, false)
			emGUI:dxSetText(delIntButton, "DELETING..")
			triggerServerEvent("interior:deleteintcall", localPlayer, localPlayer, "ui", checkingIntID)
			setTimer(function()
				triggerServerEvent("interior:checkintcall", localPlayer, localPlayer, "checkint", checkingIntID)
			end, 1500, 1)
		end
	end
end

function restoreIntButtonClick(button, state)
	if (button == "left") and (state == "down") then
		local isRestoring = getElementData(localPlayer, "temp:isrestoringint")
		if not (isRestoring == checkingIntID) then
			triggerServerEvent("interior:restoreintcall", localPlayer, localPlayer, "ui", checkingIntID)
			emGUI:dxSetText(restoreIntButton, "CONFIRM RESTORE")
		else
			emGUI:dxSetEnabled(restoreIntButton, false)
			emGUI:dxSetText(restoreIntButton, "RESTORING..")
			triggerServerEvent("interior:restoreintcall", localPlayer, localPlayer, "ui", checkingIntID)
			setTimer(function()
				triggerServerEvent("interior:checkintcall", localPlayer, localPlayer, "checkint", checkingIntID)
			end, 1500, 1)
		end
	end
end

function showSaveInvButtonClick(button, state)
	if (button == "left") and (state == "down") then
		--@requires inventory-system safes.
	end
end

function logsUpdateButtonClick(button, state)
	if (button == "left") and (state == "down") then
		local logID = emGUI:dxGetText(logIDLabel)
		local logText = emGUI:dxGetText(staffNotesMemo)
		if not tostring(logText) or (#logText < 5) or (#logText > 400) then
			emGUI:dxSetText(noticeLabel2, "Note must contain between 5 and 400 characters!")
			emGUI:dxLabelSetColor(noticeLabel2, 255, 0, 0)
			setTimer(function()
				emGUI:dxSetText(noticeLabel2, "Be sure to leave your name and date when adding notes.")
				emGUI:dxLabelSetColor(noticeLabel2, 255, 255, 255)
			end, 4000, 1)
			return
		else
			outputChatBox("You have updated log #" .. logID .. ".", 0, 255, 0)
			triggerServerEvent("log:updateInteriorLog", localPlayer, tonumber(logID), checkingIntID, logText, localPlayer)
			triggerServerEvent("interior:checkintcall", localPlayer, localPlayer, "checkint", checkingIntID)
		end
	end
end

function logsBackButtonClick(button, state) if (button == "left") and (state == "down") then toMainView(1) end end

function copyNameDateClick(button, state)
	if (button == "left") and (state == "down") then
		local thePlayerName = exports.global:getStaffTitle(localPlayer, 1)
		local timeNow = exports.global:getCurrentTime()
		setClipboard(" (" .. thePlayerName .. ", " .. timeNow[2] .. ")")
		emGUI:dxSetText(copyNameDate, "Copied!")
		setTimer(function()
			emGUI:dxSetText(copyNameDate, "Copy Name & Date")
		end, 3000, 1)
	end
end

function saveNoteButtonClick(button, state)
	if (button == "left") and (state == "down") then
		local logText = emGUI:dxGetText(staffNotesMemo)
		if not (#logText) or (#logText < 5) or (#logText > 400) then
			emGUI:dxSetText(noticeLabel2, "Note must contain between 5 and 400 characters!")
			emGUI:dxLabelSetColor(noticeLabel2, 255, 0, 0)
			setTimer(function()
				emGUI:dxSetText(noticeLabel2, "Be sure to leave your name and date when adding notes.")
				emGUI:dxLabelSetColor(noticeLabel2, 255, 255, 255)
			end, 4000, 1)
			return
		end

		triggerServerEvent("log:addInteriorLog", localPlayer, checkingIntID, logText, localPlayer, true)
		triggerServerEvent("interior:checkintcall", localPlayer, localPlayer, "checkint", checkingIntID)
	end
end

function addnoteButtonClick(button, state) if (button == "left") and (state == "down") then toAddNote() end end

function cancelNoteButtonClick(button, state)
	if (button == "left") and (state == "down") then
		local logText = emGUI:dxGetText(staffNotesMemo)
		local confirmed = getElementData(localPlayer, "temp:int:cancelnoteevent")
		if (#logText > 6) and not (confirmed) then
			emGUI:dxSetText(cancelNoteButton, "Cancel\nAre you sure?")
			setElementData(localPlayer, "temp:int:cancelnoteevent", true)
		else
			setElementData(localPlayer, "temp:int:cancelnoteevent", false)
			emGUI:dxSetText(cancelNoteButton, "Cancel")
			removeEventHandler("onClientDgsDxMouseClick", addnoteButton, addnoteButtonClick)
			toMainView(2)
			setTimer(function()
				addEventHandler("onClientDgsDxMouseClick", addnoteButton, addnoteButtonClick)
			end, 500, 1)
		end
	end
end

function deleteNoteButtonClick(button, state)
	if (button == "left") and (state == "down") then
		local noteID = emGUI:dxGetText(logIDLabel)
		local confirmed = getElementData(localPlayer, "temp:int:deletenoteevent")
		if not (confirmed) then
			emGUI:dxSetText(deleteNoteButton, "DELETE\nAre you sure?")
			setElementData(localPlayer, "temp:int:deletenoteevent", true)
		else
			setElementData(localPlayer, "temp:int:deletenoteevent", false)
			outputChatBox("You have deleted note #" .. noteID .. " from interior #" .. checkingIntID .. ".", 0, 255, 0)
			triggerServerEvent("interior:checkintdelnote", localPlayer, localPlayer, checkingIntID, tonumber(noteID))
			triggerServerEvent("interior:checkintcall", localPlayer, localPlayer, "checkint", checkingIntID)
		end
	end
end