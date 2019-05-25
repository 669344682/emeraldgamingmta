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

function showRadioManagerGUI(stationData, ownerData)
	if not (stationData) or not (ownerData) then outputChatBox("ERROR: Failed to retrieve stations.", 255, 0, 0) return false end
	if emGUI:dxIsWindowVisible(radioStationGUI) then emGUI:dxCloseWindow(radioStationGUI) return end

	radioStationGUI = emGUI:dxCreateWindow(0.31, 0.22, 0.37, 0.44, "Radio Stream Manager", true)

	allStreamsGridlist = emGUI:dxCreateGridList(0.02, 0.03, 0.95, 0.73, true, radioStationGUI)
	emGUI:dxGridListAddColumn(allStreamsGridlist, "ID", 0.04)
	emGUI:dxGridListAddColumn(allStreamsGridlist, "Station Name", 0.25)
	emGUI:dxGridListAddColumn(allStreamsGridlist, "Owner", 0.2)
	emGUI:dxGridListAddColumn(allStreamsGridlist, "Date Added", 0.2)
	emGUI:dxGridListAddColumn(allStreamsGridlist, "Expiry Date", 0.2)
	emGUI:dxGridListAddColumn(allStreamsGridlist, "Enabled", 0.08)
	emGUI:dxGridListAddColumn(allStreamsGridlist, "Stream URL", 0.4)
	
	for i, station in ipairs(stationData) do
		emGUI:dxGridListAddRow(allStreamsGridlist)
		emGUI:dxGridListSetItemText(allStreamsGridlist, i, 1, station.id)
		emGUI:dxGridListSetItemText(allStreamsGridlist, i, 2, station.station_name)
		emGUI:dxGridListSetItemText(allStreamsGridlist, i, 3, ownerData[i])

		local addedDate = exports.global:convertTime(station.date_added, true)
		local expiryDate = "Never"
		if (#station.expiry_date > 1) then
			expiryDate = exports.global:convertTime(station.expiry_date, true) or "Unknown"; expiryDate = expiryDate[2]
		end
		emGUI:dxGridListSetItemText(allStreamsGridlist, i, 4, addedDate[2])
		emGUI:dxGridListSetItemText(allStreamsGridlist, i, 5, expiryDate)

		local enabledState = "Yes"
		if tonumber(station.enabled) == 0 then enabledState = "No" end
		emGUI:dxGridListSetItemText(allStreamsGridlist, i, 6, enabledState)
		emGUI:dxGridListSetItemText(allStreamsGridlist, i, 7, station.url)
	end

	addStreamButton = emGUI:dxCreateButton(0.122, 0.80, 0.22, 0.13, "Add New Stream", true, radioStationGUI)
	addEventHandler("onClientDgsDxMouseClick", addStreamButton, addEditStreamButtonClick)
	editStreamButton = emGUI:dxCreateButton(0.39, 0.80, 0.22, 0.13, "Edit Stream", true, radioStationGUI)
	addEventHandler("onClientDgsDxMouseClick", editStreamButton, addEditStreamButtonClick)
	removeStreamButton = emGUI:dxCreateButton(0.66, 0.80, 0.22, 0.13, "Remove Stream", true, radioStationGUI)
	addEventHandler("onClientDgsDxMouseClick", removeStreamButton, removeStreamButtonClick)
	emGUI:dxSetEnabled(editStreamButton, false)
	emGUI:dxSetEnabled(removeStreamButton, false)

	addEventHandler("ondxGridListSelect", allStreamsGridlist, function(c)
		local enable = c ~= -1
		if emGUI:dxIsWindowVisible(stationEditGUI) then emGUI:dxCloseWindow(stationEditGUI) end
		emGUI:dxSetEnabled(editStreamButton, enable)
		emGUI:dxSetEnabled(removeStreamButton, enable)
	end)

	addEventHandler("onClientDgsDxWindowClose", allStreamsGridlist, function()
		if emGUI:dxIsWindowVisible(stationEditGUI) then emGUI:dxCloseWindow(stationEditGUI) end
	end)
end
addEvent("radio:gui:showRadioManagerGUI", true)
addEventHandler("radio:gui:showRadioManagerGUI", root, showRadioManagerGUI)

function showStreamEditor(isEdit)
	if emGUI:dxIsWindowVisible(stationEditGUI) then emGUI:dxCloseWindow(stationEditGUI) end

	local editStreamLabels = {}
	stationEditGUI = emGUI:dxCreateWindow(0.36, 0.68, 0.27, 0.22, "Add New Station", true, _, _, true)

	editStreamLabels[1] = emGUI:dxCreateLabel(0.03, 0.08, 0.29, 0.07, "Radio Station Name", true, stationEditGUI)
	editStreamLabels[2] = emGUI:dxCreateLabel(0.03, 0.33, 0.29, 0.07, "Stream URL", true, stationEditGUI)
	editStreamLabels[3] = emGUI:dxCreateLabel(0.03, 0.58, 0.29, 0.07, "Owner", true, stationEditGUI)
	editStreamLabels[4] = emGUI:dxCreateLabel(0.56, 0.08, 0.29, 0.07, "Expire Time", true, stationEditGUI)
	
	stationNameInput = emGUI:dxCreateEdit(0.03, 0.18, 0.44, 0.10, "", true, stationEditGUI)
	emGUI:dxEditSetMaxLength(stationNameInput, 23)
	streamURLInput = emGUI:dxCreateEdit(0.03, 0.43, 0.44, 0.10, "", true, stationEditGUI)
	emGUI:dxEditSetMaxLength(streamURLInput, 95)
	streamOwnerInput = emGUI:dxCreateEdit(0.03, 0.68, 0.44, 0.10, "", true, stationEditGUI)
	serverOwnedCheckbox = emGUI:dxCreateCheckBox(0.03, 0.82, 0.21, 0.07, "Server Owned", false, true, stationEditGUI)
	enabledCheckbox = emGUI:dxCreateCheckBox(0.26, 0.82, 0.21, 0.07, "Enabled", false, true, stationEditGUI)
	emGUI:dxCheckBoxSetSelected(enabledCheckbox, true)

	expireTimeInput = emGUI:dxCreateComboBox(0.56, 0.18, 0.37, 0.10, true, stationEditGUI)
	emGUI:dxComboBoxAddItem(expireTimeInput, "1 Month")
	emGUI:dxComboBoxAddItem(expireTimeInput, "2 Months")
	emGUI:dxComboBoxAddItem(expireTimeInput, "3 Months")
	emGUI:dxComboBoxAddItem(expireTimeInput, "6 Months")
	emGUI:dxComboBoxAddItem(expireTimeInput, "Never")
	emGUI:dxComboBoxSetSelectedItem(expireTimeInput, 1)

	submitStationButton = emGUI:dxCreateButton(0.56, 0.41, 0.36, 0.21, "Add Station", true, stationEditGUI)
	addEventHandler("onClientDgsDxMouseClick", submitStationButton, function(b, c)
		if (b == "left") and (c == "down") then handleRadioEdit(isEdit) end
	end)
	cancelButton = emGUI:dxCreateButton(0.56, 0.68, 0.36, 0.21, "Close", true, stationEditGUI)
	addEventHandler("onClientDgsDxMouseClick", cancelButton, cancelButtonClick)

	if (isEdit) then
		emGUI:dxSetText(stationEditGUI, "Station Editor")
		emGUI:dxSetText(submitStationButton, "Edit Station")
		emGUI:dxSetText(editStreamLabels[4], "Update Expiry Time")

		local row = emGUI:dxGridListGetSelectedItem(allStreamsGridlist)
		local stationName = emGUI:dxGridListGetItemText(allStreamsGridlist, row, 2)
		local stationOwner = emGUI:dxGridListGetItemText(allStreamsGridlist, row, 3)
		local stationURL = emGUI:dxGridListGetItemText(allStreamsGridlist, row, 7)
		local isServerOwned = emGUI:dxGridListGetItemText(allStreamsGridlist, row, 3)
		local isEnabled = emGUI:dxGridListGetItemText(allStreamsGridlist, row, 6)
		if (isEnabled == "Yes") then emGUI:dxCheckBoxSetSelected(enabledCheckbox, true) end

		if (isServerOwned == "Server") then
			emGUI:dxCheckBoxSetSelected(serverOwnedCheckbox, true)
			emGUI:dxSetEnabled(streamOwnerInput, false)
			emGUI:dxComboBoxSetSelectedItem(expireTimeInput, 5)
		else
			emGUI:dxSetText(streamOwnerInput, stationOwner)
		end
		emGUI:dxSetText(stationNameInput, stationName)
		emGUI:dxSetText(streamURLInput, stationURL)
	end

	addEventHandler("onDgsCheckBoxChange", serverOwnedCheckbox, function(c)
		if (c) then
			emGUI:dxSetEnabled(streamOwnerInput, false)
			emGUI:dxSetText(streamOwnerInput, "")
		else
			emGUI:dxSetEnabled(streamOwnerInput, true)
		end
	end)
end

function addEditStreamButtonClick(b, c)
	if (b == "left") and (c == "down") then
		local isEdit = source == editStreamButton
		showStreamEditor(isEdit)
	end
end

function showDeleteWarningGUI(stationName)
	if not (stationName) then stationName = "this radio station" end
	delRadioWarningGUI = emGUI:dxCreateWindow(0.38, 0.41, 0.23, 0.18, "", true, true, _, true)

	local label1 = emGUI:dxCreateLabel(0.22, -0.07, 0.51, 0.26, "CONFIRM", true, delRadioWarningGUI)
	local label2 = emGUI:dxCreateLabel(0.12, 0.25, 0.75, 0.10, "Are you sure you would like to delete \n" .. stationName .. "?", true, delRadioWarningGUI)
	local buttonFont_35 = emGUI:dxCreateNewFont("fonts/buttonFont.ttf", 35)
	emGUI:dxSetFont(label1, buttonFont_35)
	emGUI:dxLabelSetHorizontalAlign(label2, "center")

	radioNoButton = emGUI:dxCreateButton(0.06, 0.57, 0.40, 0.33, "NO", true, delRadioWarningGUI)
	addEventHandler("onClientDgsDxMouseClick", radioNoButton, function()
		emGUI:dxCloseWindow(delRadioWarningGUI)
		emGUI:dxSetVisible(radioStationGUI, true)
	end)

	radioYesButton = emGUI:dxCreateButton(0.54, 0.57, 0.40, 0.33, "I'M SURE", true, delRadioWarningGUI)
	addEventHandler("onClientDgsDxMouseClick", radioYesButton, handleRadioDeleted)
end

function removeStreamButtonClick(b, c)
	if (b == "left") and (c == "down") then
		local row = emGUI:dxGridListGetSelectedItem(allStreamsGridlist)
		local stationName = emGUI:dxGridListGetItemText(allStreamsGridlist, row, 2) or false
		emGUI:dxSetVisible(radioStationGUI, false)
		showDeleteWarningGUI(stationName)
	end
end

function cancelButtonClick(b, c)
	if (b == "left") and (c == "down") then
		emGUI:dxCloseWindow(stationEditGUI)
	end
end

function handleRadioEdit(isEdit)
	if isEdit then
		local row = emGUI:dxGridListGetSelectedItem(allStreamsGridlist)
		isEdit = emGUI:dxGridListGetItemText(allStreamsGridlist, row, 1)
	else
		isEdit = false
	end
	local stationName = emGUI:dxGetText(stationNameInput)
	local streamURL = emGUI:dxGetText(streamURLInput)
	local owner = emGUI:dxGetText(streamOwnerInput)
	local isServerOwned = emGUI:dxCheckBoxGetSelected(serverOwnedCheckbox)
	local isEnabled = emGUI:dxCheckBoxGetSelected(enabledCheckbox); if (isEnabled) then isEnabled = 1 else isEnabled = 0 end
	local expireTime = emGUI:dxComboBoxGetSelectedItem(expireTimeInput)

	if not tostring(stationName) or not (string.len(stationName) >= 4) then
		outputChatBox("ERROR: Station name must be between 4 and 24 characters.", 255, 0, 0)
		return false
	end

	if not tostring(streamURL) or not (string.len(streamURL) > 6) or not string.find(string, "http") then
		outputChatBox("ERROR: That doesn't look like a valid Stream URL.", 255, 0, 0)
	return false
	end

	if not tostring(owner) or not (string.len(owner) > 3) and not (isServerOwned) then
		outputChatBox("ERROR: Please provide a station owner.", 255, 0, 0)
		return false
	end

	triggerServerEvent("radio:gui:handleRadioStream", localPlayer, localPlayer, isEdit, stationName, streamURL, owner, isServerOwned, isEnabled, expireTime)
	isEdit = false
	emGUI:dxCloseWindow(radioStationGUI)
	emGUI:dxCloseWindow(stationEditGUI)
	triggerServerEvent("radio:gui:showstreamscall", localPlayer, localPlayer)
end

function handleRadioDeleted(b, c)
	if (b == "left") and (c == "down") then
		local row = emGUI:dxGridListGetSelectedItem(allStreamsGridlist)
		local streamID = emGUI:dxGridListGetItemText(allStreamsGridlist, row, 1)
		triggerServerEvent("radio:gui:handleRadioDeleted", localPlayer, localPlayer, streamID)
		emGUI:dxCloseWindow(delRadioWarningGUI)
		emGUI:dxCloseWindow(radioStationGUI)
		triggerServerEvent("radio:gui:showstreamscall", localPlayer, localPlayer)
	end
end