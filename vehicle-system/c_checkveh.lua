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
buttonFont_16 = emGUI:dxCreateNewFont(":emGUI/fonts/buttonFont.ttf", 16)

local checkingVehID = false
local c_theVehicle = false
local isManager = false
local isLead = false
local isAdmin = false
local tankSize = false

function openCheckVehicleGUI(theVehicle, vehName, vehicleData, vehicleLogs, namesTable, createdBy, ownerName)
	if (emGUI:dxIsWindowVisible(checkvehGUI)) then
		removeEventHandler("onClientRender", root, updateCheckVehGUI)
		emGUI:dxCloseWindow(checkvehGUI)
		checkingVehID = false
		c_theVehicle = false
	end

	checkingVehID = vehicleData.id
	tankSize = g_vehicleTypes[vehName[3]]["tank"] or 100
	if exports.global:isPlayerManager(localPlayer, true) then isManager = true; isLead = true; isAdmin = true
	elseif exports.global:isPlayerLeadAdmin(localPlayer, true) then isLead = true; isAdmin = true
	elseif exports.global:isPlayerTrialAdmin(localPlayer, true) then isAdmin = true end

	local checkvehGUILabels = {}
	local vehModelName = getVehicleNameFromModel(vehName[1])
	checkvehGUI = emGUI:dxCreateWindow(0.25, 0.20, 0.50, 0.60, "[ID #" .. vehicleData.id .. "] " .. vehName[2] .. " (" .. vehModelName .. ")", true, _, true)

	checkvehGUILabels[1] = emGUI:dxCreateLabel(0.02, 0.02, 0.10, 0.03, "Vehicle ID:", true, checkvehGUI)
	checkvehGUILabels[2] = emGUI:dxCreateLabel(0.02, 0.05, 0.10, 0.03, "Vehicle Model:", true, checkvehGUI)
	checkvehGUILabels[3] = emGUI:dxCreateLabel(0.02, 0.08, 0.10, 0.03, "Location:", true, checkvehGUI)
	checkvehGUILabels[4] = emGUI:dxCreateLabel(0.02, 0.11, 0.10, 0.03, "Dimension:", true, checkvehGUI)
	checkvehGUILabels[5] = emGUI:dxCreateLabel(0.02, 0.14, 0.10, 0.03, "Interior:", true, checkvehGUI)
	checkvehGUILabels[6] = emGUI:dxCreateLabel(0.02, 0.17, 0.10, 0.03, "HP:", true, checkvehGUI)
	checkvehGUILabels[7] = emGUI:dxCreateLabel(0.02, 0.2, 0.10, 0.03, "Occupants:", true, checkvehGUI)

	checkvehGUILabels[8] = emGUI:dxCreateLabel(0.33, 0.02, 0.10, 0.03, "Fuel:", true, checkvehGUI)
	checkvehGUILabels[9] = emGUI:dxCreateLabel(0.33, 0.05, 0.10, 0.03, "Engine:", true, checkvehGUI)
	checkvehGUILabels[10] = emGUI:dxCreateLabel(0.33, 0.08, 0.10, 0.03, "Locked:", true, checkvehGUI)
	checkvehGUILabels[11] = emGUI:dxCreateLabel(0.33, 0.11, 0.10, 0.03, "Odometer:", true, checkvehGUI)
	checkvehGUILabels[12] = emGUI:dxCreateLabel(0.33, 0.14, 0.10, 0.03, "Plates:", true, checkvehGUI)
	checkvehGUILabels[13] = emGUI:dxCreateLabel(0.33, 0.17, 0.10, 0.03, "Owner:", true, checkvehGUI)

	checkvehGUILabels[14] = emGUI:dxCreateLabel(0.68, 0.02, 0.10, 0.03, "Creation Date:", true, checkvehGUI)
	checkvehGUILabels[15] = emGUI:dxCreateLabel(0.68, 0.05, 0.10, 0.03, "Created by:", true, checkvehGUI)
	checkvehGUILabels[16] = emGUI:dxCreateLabel(0.68, 0.08, 0.10, 0.03, "Last Used:", true, checkvehGUI)
	checkvehGUILabels[17] = emGUI:dxCreateLabel(0.68, 0.11, 0.10, 0.03, "Impounded:", true, checkvehGUI)
	checkvehGUILabels[18] = emGUI:dxCreateLabel(0.68, 0.14, 0.10, 0.03, "States:", true, checkvehGUI)
	checkvehGUILabels[19] = emGUI:dxCreateLabel(0.68, 0.17, 0.10, 0.03, "Deleted:", true, checkvehGUI)
	
	for i = 1, #checkvehGUILabels do
		emGUI:dxLabelSetHorizontalAlign(checkvehGUILabels[i], "right")
	end

	local vinVisible = " (VIN Visible)"
	if (vehicleData.show_vin == 0) then vinVisible = " (VIN Hidden)" end
	vehIDLabel = emGUI:dxCreateLabel(0.13, 0.02, 0.18, 0.03, vehicleData.id .. vinVisible, true, checkvehGUI)

	vehModelLabel = emGUI:dxCreateLabel(0.13, 0.05, 0.18, 0.03, vehicleData.model, true, checkvehGUI)

	local vehicleHP, engineState, lockedState, odometerCount, vehiclePlates, x, y, z, locationStringvehicleDimension, vehicleInterior, occupantString
	if (theVehicle) and isElement(theVehicle) then
		c_theVehicle = theVehicle
		vehicleHP = getElementHealth(theVehicle); vehicleHP = string.format("%.0f", vehicleHP)
		engineState = "Turned Off."; if getVehicleEngineState(theVehicle) then engineState = "Turned On." end
		lockedState = "Unlocked"; if (getElementData(theVehicle, "vehicle:locked") == 1) then lockedState = "Locked." end
		odometerCount = getElementData(theVehicle, "vehicle:mileage") or 0
		vehiclePlates = getVehiclePlateText(theVehicle)
		vehicleDimension = getElementDimension(theVehicle)
		vehicleInterior = getElementInterior(theVehicle)
		x, y, z = getElementPosition(theVehicle)
		occupantString = ""
		local vehOccupants = getVehicleOccupants(theVehicle)
		local occCount = 0
		for seat, occupant in pairs(vehOccupants) do
			occCount = occCount + 1
			if (occCount == 1) then
				occupantString = "[Seat " .. seat .. "] " .. getPlayerName(occupant):gsub("_", " ")
				else
				occupantString = occupantString .. " [Seat " .. seat .. "] " .. getPlayerName(occupant):gsub("_", " ")
			end
		end
		if (occCount == 0) then occupantString = "None." end
	else
		vehicleHP = string.format("%.0f", vehicleData.hp)
		engineState = "Turned Off."; if (vehicleData.engine == 1) then engineState = "Turned On." end
		lockedState = "Unlocked."; if (vehicleData.locked == 1) then lockedState = "Locked." end
		odometerCount = vehicleData.odometer or 0
		vehiclePlates = vehicleData.plates or "Unknown"
		vehicleDimension = vehicleData.dimension
		vehicleInterior = vehicleData.interior
		local locString = split(vehicleData.location, ",")
		x, y, z = tonumber(locString[1]), tonumber(locString[2]), tonumber(locString[3])
		occupantString = "None."
	end

	local locationString = getZoneName(x, y, z)
	if (vehicleDimension ~= 0) and (vehicleInterior ~= 0) then
		locationString = "Inside Interior #" .. vehicleDimension
	else
		local city = getZoneName(x, y, z, true)
		if not (locationString == city) then
			locationString = locationString .. ", " .. city .. "."
		else
			locationString = locationString .. "."
		end
	end

	local isImpounded = "No."
	if (vehicleData.impounded == 1) then isImpounded = "Yes." end

	local unk = "Unavailable."
	if not (isAdmin) then
		vehicleHP = unk
		engineState = unk
		lockedState = unk
		vehiclePlates = unk
		vehicleDimension = unk
		vehicleInterior = unk
		occupantString = unk
		locationString = unk
		ownerName = unk
	end

	vehDimLabel = emGUI:dxCreateLabel(0.13, 0.11, 0.18, 0.03, vehicleDimension, true, checkvehGUI)
	vehIntLabel = emGUI:dxCreateLabel(0.13, 0.14, 0.18, 0.03, vehicleInterior, true, checkvehGUI)
	vehLocationLabel = emGUI:dxCreateLabel(0.13, 0.08, 0.18, 0.03, locationString, true, checkvehGUI)
	vehHPLabel = emGUI:dxCreateLabel(0.13, 0.17, 0.18, 0.03, vehicleHP, true, checkvehGUI)
	vehOccupantsLabel = emGUI:dxCreateLabel(0.13, 0.20, 0.18, 0.03, occupantString, true, checkvehGUI)
	
	local vehFuel = vehicleData.fuel
	vehFuelLabel = emGUI:dxCreateLabel(0.44, 0.02, 0.18, 0.03, vehFuel .. "/" .. tankSize, true, checkvehGUI)
	vehEngineLabel = emGUI:dxCreateLabel(0.44, 0.05, 0.18, 0.03, engineState, true, checkvehGUI)
	vehLockedLabel = emGUI:dxCreateLabel(0.44, 0.08, 0.18, 0.03, lockedState, true, checkvehGUI)
	vehOdometerLabel = emGUI:dxCreateLabel(0.44, 0.11, 0.18, 0.03, math.floor(odometerCount / 1000), true, checkvehGUI)

	local platesVisible = " (Visible)"
	if (vehicleData.show_plates == 0) then platesVisible = " (Hidden)" end

	vehPlatesLabel = emGUI:dxCreateLabel(0.44, 0.14, 0.18, 0.03, vehiclePlates .. platesVisible, true, checkvehGUI)
	vehOwnerLabel = emGUI:dxCreateLabel(0.44, 0.17, 0.18, 0.03, ownerName, true, checkvehGUI)
	
	local createdString = exports.global:convertTime(vehicleData.created_date)
	vehCreatedLabel = emGUI:dxCreateLabel(0.79, 0.02, 0.17, 0.03, createdString[2] .. " at " .. createdString[1], true, checkvehGUI)

	vehCreatorLabel = emGUI:dxCreateLabel(0.79, 0.05, 0.17, 0.03, createdBy, true, checkvehGUI)

	local lastUsedTime = exports.global:convertTime(vehicleData.last_used)
	vehLastUsedLabel = emGUI:dxCreateLabel(0.79, 0.08, 0.17, 0.03, lastUsedTime[2] .. " at " .. lastUsedTime[1], true, checkvehGUI)
	vehImpoundedLabel = emGUI:dxCreateLabel(0.79, 0.11, 0.17, 0.03, isImpounded, true, checkvehGUI)

	local statesString = "Not stolen/chopped."
	if (isAdmin) then
		local vehStates = split(vehicleData.state, ",")
		if (vehStates[1] == 1) and (vehStates[2] == 1)then
			statesString = "Stolen and chopped."
		elseif (vehStates[1] == 1) then
			statesString = "Stolen."
		elseif (vehStates[2] == 1) then
			statesString = "Chopped."
		end
	else
		statesString = unk
	end
	vehStatesLabel = emGUI:dxCreateLabel(0.79, 0.14, 0.17, 0.03, statesString, true, checkvehGUI)

	isDeleted = false
	local deletedString = "No."
	if (vehicleData.deleted == 1) then
		isDeleted = true
		deletedString = "Yes."
	end
	vehDeletedLabel = emGUI:dxCreateLabel(0.79, 0.17, 0.17, 0.03, deletedString, true, checkvehGUI)
	
	logsTabPanel = emGUI:dxCreateTabPanel(0.02, 0.25, 0.74, 0.71, true, checkvehGUI)

	local logsTabPanelTab1 = emGUI:dxCreateTab("Staff Notes", logsTabPanel)
		staffNotesGridlist = emGUI:dxCreateGridList(0, 0, 1, 1, true, logsTabPanelTab1, true)
		emGUI:dxGridListAddColumn(staffNotesGridlist, "ID", 0.06)
		emGUI:dxGridListAddColumn(staffNotesGridlist, "Added by", 0.16)
		emGUI:dxGridListAddColumn(staffNotesGridlist, "Time", 0.21)
		emGUI:dxGridListAddColumn(staffNotesGridlist, "Log", 0.57)

	local logsTabPanelTab2 = emGUI:dxCreateTab("Vehicle Logs", logsTabPanel)
		vehLogsGridlist = emGUI:dxCreateGridList(0, 0, 1, 1, true, logsTabPanelTab2, true)
		emGUI:dxGridListAddColumn(vehLogsGridlist, "ID", 0.06)
		emGUI:dxGridListAddColumn(vehLogsGridlist, "Added by", 0.16)
		emGUI:dxGridListAddColumn(vehLogsGridlist, "Time", 0.21)
		emGUI:dxGridListAddColumn(vehLogsGridlist, "Log", 0.57)

	for i, theLog in ipairs(vehicleLogs) do
		local gridToInsert = staffNotesGridlist
		if (theLog.isnote == 0) then gridToInsert = vehLogsGridlist end
		
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

	checkvehGUIMemoLabels = {}
	staffNotesMemo = emGUI:dxCreateMemo(0.02, 0.38, 0.74, 0.5, "", true, checkvehGUI)
	emGUI:dxSetVisible(staffNotesMemo, false)

	vehicleLogsMemo = emGUI:dxCreateMemo(0.02, 0.38, 0.74, 0.5, "", true, checkvehGUI)
	emGUI:dxSetVisible(vehicleLogsMemo, false)
	emGUI:dxMemoSetReadOnly(vehicleLogsMemo, true)


	checkvehGUIMemoLabels[1] = emGUI:dxCreateLabel(0.02, 0.29, 0.10, 0.03, "Log ID:", true, checkvehGUI)
	checkvehGUIMemoLabels[2] = emGUI:dxCreateLabel(0.02, 0.32, 0.10, 0.03, "Added by:", true, checkvehGUI)
	checkvehGUIMemoLabels[3] = emGUI:dxCreateLabel(0.32, 0.29, 0.10, 0.03, "Created:", true, checkvehGUI)
	checkvehGUIMemoLabels[4] = emGUI:dxCreateLabel(0.32, 0.32, 0.10, 0.03, "Last Updated:", true, checkvehGUI)
	for i = 1, #checkvehGUIMemoLabels do
		emGUI:dxLabelSetHorizontalAlign(checkvehGUIMemoLabels[i], "right")
		emGUI:dxSetVisible(checkvehGUIMemoLabels[i], false)
	end


	logIDLabel = emGUI:dxCreateLabel(0.13, 0.29, 0.18, 0.03, "0", true, checkvehGUI)
	logStaffNameLabel = emGUI:dxCreateLabel(0.13, 0.32, 0.18, 0.03, "staffName", true, checkvehGUI)
	logCreatedLabel = emGUI:dxCreateLabel(0.43, 0.29, 0.18, 0.03, "DD/MM/YYYY at HH:MM:SS", true, checkvehGUI)
	loglastUpdatedLabel = emGUI:dxCreateLabel(0.43, 0.32, 0.18, 0.03, "DD/MM/YYYY at HH:MM:SS", true, checkvehGUI)
	emGUI:dxSetVisible(logIDLabel, false)
	emGUI:dxSetVisible(logStaffNameLabel, false)
	emGUI:dxSetVisible(logCreatedLabel, false)
	emGUI:dxSetVisible(loglastUpdatedLabel, false)

	triggerEvent("hud:mouse", localPlayer)

	logsUpdateButton = emGUI:dxCreateButton(0.78, 0.38, 0.20, 0.10, "UPDATE", true, checkvehGUI)
	addEventHandler("onClientDgsDxMouseClick", logsUpdateButton, logsUpdateButtonClick)
	emGUI:dxSetVisible(logsUpdateButton, false)

	logsBackButton = emGUI:dxCreateButton(0.78, 0.5, 0.20, 0.10, "BACK", true, checkvehGUI)
	addEventHandler("onClientDgsDxMouseClick", logsBackButton, logsBackButtonClick)
	emGUI:dxSetVisible(logsBackButton, false)

	noticeLabel1 = emGUI:dxCreateLabel(0.257, 0.31, 0.05, 0.03, "ADD VEHICLE NOTE", true, checkvehGUI)
	noticeLabel2 = emGUI:dxCreateLabel(0.05, 0.91, 0.05, 0.03, "Be sure to leave your name and date when adding notes.", true, checkvehGUI)
	emGUI:dxSetFont(noticeLabel1, buttonFont_16)


	copyNameDate = emGUI:dxCreateButton(0.47, 0.9, 0.20, 0.05, "COPY NAME & DATE", true, checkvehGUI)
	addEventHandler("onClientDgsDxMouseClick", copyNameDate, copyNameDateClick)
	saveNoteButton = emGUI:dxCreateButton(0.78, 0.49, 0.20, 0.10, "Save Note", true, checkvehGUI)
	addEventHandler("onClientDgsDxMouseClick", saveNoteButton, saveNoteButtonClick)
	cancelNoteButton = emGUI:dxCreateButton(0.78, 0.61, 0.20, 0.10, "Cancel", true, checkvehGUI)
	addEventHandler("onClientDgsDxMouseClick", cancelNoteButton, cancelNoteButtonClick)
	emGUI:dxSetVisible(noticeLabel1, false)
	emGUI:dxSetVisible(noticeLabel2, false)
	emGUI:dxSetVisible(copyNameDate, false)
	emGUI:dxSetVisible(saveNoteButton, false)
	emGUI:dxSetVisible(cancelNoteButton, false)

	gotovehButton = emGUI:dxCreateButton(0.78, 0.25, 0.20, 0.10, "GO TO VEHICLE", true, checkvehGUI)
	addEventHandler("onClientDgsDxMouseClick", gotovehButton, gotovehButtonClick)
	getvehButton = emGUI:dxCreateButton(0.78, 0.37, 0.20, 0.10, "GET VEHICLE", true, checkvehGUI)
	addEventHandler("onClientDgsDxMouseClick", getvehButton, getvehButtonClick)
	respawnButton = emGUI:dxCreateButton(0.78, 0.49, 0.20, 0.10, "RESPAWN VEHICLE", true, checkvehGUI)
	addEventHandler("onClientDgsDxMouseClick", respawnButton, respawnButtonClick)
	addnoteButton = emGUI:dxCreateButton(0.78, 0.61, 0.20, 0.10, "ADD NOTE", true, checkvehGUI)
	addEventHandler("onClientDgsDxMouseClick", addnoteButton, addnoteButtonClick)
	
	if (isAdmin) then
		restoreVehButton = emGUI:dxCreateButton(0.78, 0.73, 0.20, 0.10, "RESTORE VEHICLE", true, checkvehGUI)
		addEventHandler("onClientDgsDxMouseClick", restoreVehButton, restoreVehButtonClick)
		emGUI:dxSetVisible(restoreVehButton, false)

		delVehButton = emGUI:dxCreateButton(0.78, 0.73, 0.20, 0.10, "DELETE VEHICLE", true, checkvehGUI)
		addEventHandler("onClientDgsDxMouseClick", delVehButton, delVehButtonClick)
		
		if not (c_theVehicle) then
			emGUI:dxSetVisible(delVehButton, false)
			emGUI:dxSetVisible(restoreVehButton, true)
		end
	end

	if (isManager) then
		showInvButton = emGUI:dxCreateButton(0.78, 0.85, 0.20, 0.10, "SHOW INVENTORY", true, checkvehGUI)
		addEventHandler("onClientDgsDxMouseClick", showInvButton, showInvButtonClick)

		deleteNoteButton = emGUI:dxCreateButton(0.78, 0.62, 0.20, 0.10, "DELETE", true, checkvehGUI)
		addEventHandler("onClientDgsDxMouseClick", deleteNoteButton, deleteNoteButtonClick)
		emGUI:dxSetVisible(deleteNoteButton, false)
	end

	if not (c_theVehicle) then
		emGUI:dxSetEnabled(gotovehButton, false)
		emGUI:dxSetEnabled(getvehButton, false)
		emGUI:dxSetEnabled(respawnButton, false)
	end

	addEventHandler("ondxGridListItemDoubleClick", staffNotesGridlist, function(b, s, id)
		if b == "left" and s == "down" and (id) then
			local logID = emGUI:dxGridListGetItemText(staffNotesGridlist, id, 1); logID = tonumber(logID)
			local selectedLog
			for x, theLog in ipairs(vehicleLogs) do
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

	addEventHandler("ondxGridListItemDoubleClick", vehLogsGridlist, function(b, s, id)
		if b == "left" and s == "down" and (id) then
			local logID = emGUI:dxGridListGetItemText(vehLogsGridlist, id, 1); logID = tonumber(logID)
			local selectedLog
			for x, theLog in ipairs(vehicleLogs) do
				if (theLog.id == logID) then
					selectedLog = theLog
					break
				end
			end
			local logStaff = emGUI:dxGridListGetItemText(vehLogsGridlist, id, 2)
			local logCreated = exports.global:convertTime(selectedLog.time, true) or "Unknown"
			local logUpdated = exports.global:convertTime(selectedLog.last_updated, true) or "Unknown"
			local logText = selectedLog.log
			emGUI:dxSetPosition(logsBackButton, 0.78, 0.38, true)
			viewLogNote(false, logID, logStaff, logCreated, logUpdated, logText)
		end
	end)

	if (c_theVehicle) and (isAdmin) then
		addEventHandler("onClientRender", root, updateCheckVehGUI)
	end

	addEventHandler("onClientDgsDxWindowClose", checkvehGUI, function()
		triggerEvent("hud:hidemouse", localPlayer)
		removeEventHandler("onClientRender", root, updateCheckVehGUI)
		checkingVehID = false
		c_theVehicle = false
		isManager = false
		isLead = false
		isAdmin = false
		tankSize = false
	end)
end
addEvent("vehicle:checkvehiclegui", true)
addEventHandler("vehicle:checkvehiclegui", root, openCheckVehicleGUI)


function updateCheckVehGUI()
	local loggedin = getElementData(localPlayer, "loggedin")
	if (loggedin == 1) then
		if isElement(c_theVehicle) then
			local vehicleHP = getElementHealth(c_theVehicle); vehicleHP = string.format("%.0f", vehicleHP)
			local engineState = "Turned Off."; if getVehicleEngineState(c_theVehicle) then engineState = "Turned On." end
			local lockedState = "Unlocked"; if (getElementData(c_theVehicle, "vehicle:locked") == 1) then lockedState = "Locked." end
			local odometerCount = getElementData(c_theVehicle, "vehicle:mileage") or 0
			local vehicleDimension = getElementDimension(c_theVehicle)
			local vehicleInterior = getElementInterior(c_theVehicle)
			local x, y, z = getElementPosition(c_theVehicle)
			local locationString = getZoneName(x, y, z)
			local vehFuel = getElementData(c_theVehicle, "vehicle:fuel") or 0
			if (vehicleDimension ~= 0) and (vehicleInterior ~= 0) then
			locationString = "Inside Interior #" .. vehicleDimension
			else
				local city = getZoneName(x, y, z, true)
				if not (locationString == city) then
					locationString = locationString .. ", " .. city .. "."
				else
					locationString = locationString .. "."
				end
			end
			local occupantString = ""
			local vehOccupants = getVehicleOccupants(c_theVehicle)
			local occCount = 0
			for seat, occupant in pairs(vehOccupants) do
				occCount = occCount + 1
				if (occCount == 1) then
					occupantString = "[Seat " .. seat .. "] " .. getPlayerName(occupant):gsub("_", " ")
					else
					occupantString = occupantString .. " [Seat " .. seat .. "] " .. getPlayerName(occupant):gsub("_", " ")
				end
			end
			if (occCount == 0) then occupantString = "None." end

			emGUI:dxSetText(vehHPLabel, vehicleHP)
			emGUI:dxSetText(vehDimLabel, vehicleDimension)
			emGUI:dxSetText(vehIntLabel, vehicleInterior)
			emGUI:dxSetText(vehLocationLabel, locationString)
			emGUI:dxSetText(vehOdometerLabel, math.floor(odometerCount/1000))
			emGUI:dxSetText(vehEngineLabel, engineState)
			emGUI:dxSetText(vehLockedLabel, lockedState)
			emGUI:dxSetText(vehOccupantsLabel, occupantString)
			emGUI:dxSetText(vehFuelLabel, vehFuel .. "/" .. tankSize)
		end
	else
		removeEventHandler("onClientRender", root, updateCheckVehGUI)
		emGUI:dxCloseWindow(checkvehGUI)
	end
end
--------------------------- FUNCTIONS ---------------------------
function viewLogNote(UI, id, staff, created, updated, logText)
	if not tostring(logText) then logText = "" end
	if (UI) then
		emGUI:dxMemoSetReadOnly(vehicleLogsMemo, true)
		emGUI:dxSetVisible(staffNotesMemo, true)
		emGUI:dxSetText(staffNotesMemo, logText)
		emGUI:dxSetVisible(noticeLabel2, true)
		emGUI:dxSetVisible(copyNameDate, true)
		emGUI:dxSetVisible(logsUpdateButton, true)
		if (isManager) then emGUI:dxSetVisible(deleteNoteButton, true) end
		emGUI:dxSetVisible(loglastUpdatedLabel, true)
		emGUI:dxSetText(loglastUpdatedLabel, updated[2] .. " at " .. updated[1])
	else
		emGUI:dxSetVisible(vehicleLogsMemo, true)
		emGUI:dxSetText(vehicleLogsMemo, logText)
	end

	emGUI:dxSetVisible(logsTabPanel, false)
	emGUI:dxSetVisible(gotovehButton, false)
	emGUI:dxSetVisible(getvehButton, false)
	emGUI:dxSetVisible(respawnButton, false)
	emGUI:dxSetVisible(addnoteButton, false)
	if (isAdmin) then
		emGUI:dxSetVisible(delVehButton, false)
		emGUI:dxSetVisible(restoreVehButton, false)
	end
	if (isManager) then emGUI:dxSetVisible(showInvButton, false) end

	local lp = #checkvehGUIMemoLabels
	if not (UI) then lp = lp - 1 end
	for i = 1, lp do
		emGUI:dxSetVisible(checkvehGUIMemoLabels[i], true)
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
	emGUI:dxSetVisible(gotovehButton, false)
	emGUI:dxSetVisible(getvehButton, false)
	emGUI:dxSetVisible(respawnButton, false)
	emGUI:dxSetVisible(addnoteButton, false)
	if (isAdmin) then
		emGUI:dxSetVisible(delVehButton, false)
		emGUI:dxSetVisible(restoreVehButton, false)
	end
	if (isManager) then emGUI:dxSetVisible(showInvButton, false) end

	emGUI:dxSetVisible(staffNotesMemo, true)
	emGUI:dxSetVisible(noticeLabel1, true)
	emGUI:dxSetVisible(noticeLabel2, true)
	emGUI:dxSetVisible(copyNameDate, true)
	emGUI:dxSetVisible(saveNoteButton, true)
	emGUI:dxSetVisible(cancelNoteButton, true)
end

function toMainView(fromUI)
	emGUI:dxMemoClearText(staffNotesMemo)
	emGUI:dxMemoClearText(vehicleLogsMemo)
	emGUI:dxSetVisible(staffNotesMemo, false)
	emGUI:dxSetVisible(vehicleLogsMemo, false)

	if (fromUI == 1) then
		for i = 1, #checkvehGUIMemoLabels do
			emGUI:dxSetVisible(checkvehGUIMemoLabels[i], false)
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
	emGUI:dxSetVisible(gotovehButton, true)
	emGUI:dxSetVisible(getvehButton, true)
	emGUI:dxSetVisible(respawnButton, true)
	emGUI:dxSetVisible(addnoteButton, true)
	
	if (isAdmin) then
		if (c_theVehicle) then
			emGUI:dxSetVisible(delVehButton, true)
		else
			emGUI:dxSetVisible(restoreVehButton, true)
		end
	end
	if (isManager) then emGUI:dxSetVisible(showInvButton, true) end
end

--------------------------- BUTTONS ---------------------------

function gotovehButtonClick(button, state)
	if (button == "left") and (state == "down") then
		triggerServerEvent("vehicle:gotovehcall", localPlayer, localPlayer, "gotoveh", checkingVehID)
		emGUI:dxCloseWindow(checkvehGUI)
	end
end

function getvehButtonClick(button, state)
	if (button == "left") and (state == "down") then
		triggerServerEvent("vehicle:getvehcall", localPlayer, localPlayer, "getveh", checkingVehID)
		emGUI:dxCloseWindow(checkvehGUI)
	end
end

function respawnButtonClick(button, state)
	if (button == "left") and (state == "down") then
		triggerServerEvent("vehicle:respawnvehcall", localPlayer, localPlayer, "respawnveh", checkingVehID)
	end
end

function delVehButtonClick(button, state)
	if (button == "left") and (state == "down") then
		local isDeleting = getElementData(localPlayer, "temp:isdeletingveh")
		if not (isDeleting == checkingVehID) then
			triggerServerEvent("vehicle:deletevehiclecall", localPlayer, localPlayer, "ui", checkingVehID)
			emGUI:dxSetText(delVehButton, "CONFIRM DELETION")
		else
			emGUI:dxSetEnabled(delVehButton, false)
			emGUI:dxSetText(delVehButton, "DELETING..")
			triggerServerEvent("vehicle:deletevehiclecall", localPlayer, localPlayer, "ui", checkingVehID)
			setTimer(function()
				triggerServerEvent("vehicle:checkvehcall", localPlayer, localPlayer, "checkveh", checkingVehID)
			end, 1500, 1)
		end
	end
end

function restoreVehButtonClick(button, state)
	if (button == "left") and (state == "down") then
		local isRestoring = getElementData(localPlayer, "temp:isrestoringveh")
		if not (isRestoring == checkingVehID) then
			triggerServerEvent("vehicle:restorevehiclecall", localPlayer, localPlayer, "ui", checkingVehID)
			emGUI:dxSetText(restoreVehButton, "CONFIRM RESTORE")
		else
			emGUI:dxSetEnabled(restoreVehButton, false)
			emGUI:dxSetText(restoreVehButton, "RESTORING..")
			triggerServerEvent("vehicle:restorevehiclecall", localPlayer, localPlayer, "ui", checkingVehID)
			setTimer(function()
				triggerServerEvent("vehicle:checkvehcall", localPlayer, localPlayer, "checkveh", checkingVehID)
			end, 1500, 1)
		end
	end
end

function showInvButtonClick(button, state)
	if (button == "left") and (state == "down") then
		--@requires inventory-system
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
			triggerServerEvent("log:updateVehicleLog", localPlayer, tonumber(logID), checkingVehID, logText, localPlayer)
			triggerServerEvent("vehicle:checkvehcall", localPlayer, localPlayer, "checkveh", checkingVehID)
		end
	end
end

function logsBackButtonClick(button, state)
	if (button == "left") and (state == "down") then
		toMainView(1)
	end
end

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

		triggerServerEvent("log:addVehicleLog", localPlayer, checkingVehID, logText, localPlayer, true)
		triggerServerEvent("vehicle:checkvehcall", localPlayer, localPlayer, "checkveh", checkingVehID)
	end
end

function addnoteButtonClick(button, state)
	if (button == "left") and (state == "down") then
		toAddNote()
	end
end

function cancelNoteButtonClick(button, state)
	if (button == "left") and (state == "down") then
		local logText = emGUI:dxGetText(staffNotesMemo)
		local confirmed = getElementData(localPlayer, "temp:cancelnoteevent")
		if (#logText > 6) and not (confirmed) then
			emGUI:dxSetText(cancelNoteButton, "Cancel\nAre you sure?")
			setElementData(localPlayer, "temp:cancelnoteevent", true)
		else
			setElementData(localPlayer, "temp:cancelnoteevent", false)
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
		local confirmed = getElementData(localPlayer, "temp:deletenoteevent")
		if not (confirmed) then
			emGUI:dxSetText(deleteNoteButton, "DELETE\nAre you sure?")
			setElementData(localPlayer, "temp:deletenoteevent", true)
		else
			setElementData(localPlayer, "temp:deletenoteevent", false)
			outputChatBox("You have deleted note #" .. noteID .. " from vehicle #" .. checkingVehID .. ".", 0, 255, 0)
			triggerServerEvent("vehicle:checkvehdelnote", localPlayer, localPlayer, checkingVehID, tonumber(noteID))
			triggerServerEvent("vehicle:checkvehcall", localPlayer, localPlayer, "checkveh", checkingVehID)
		end
	end
end