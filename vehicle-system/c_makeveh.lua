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

local editor = false

function makeVehicle(editorData)
	if (emGUI:dxIsWindowVisible(makeVehGUI)) then emGUI:dxCloseWindow(makeVehGUI) return end
	if exports.global:isPlayerManager(localPlayer) or exports.global:isPlayerVehicleTeamLeader(localPlayer) then
		local playerDim = getElementDimension(localPlayer)
		local playerInt = getElementInterior(localPlayer)

		if (playerDim ~= 22220) and not exports.global:isPlayerManager(localPlayer) then
			outputChatBox("ERROR: You must be in /vtdim before to do this!", 255, 0, 0)
			return false
		elseif (playerInt ~= 0) and not exports.global:isPlayerManager(localPlayer) then
			outputChatBox("ERROR: You must be in interior 0 before to do this!", 255, 0, 0)
			return false
		end

		local makeVehGUILabels = {}
		local title = "Make New Vehicle"
		if editorData then title = "Vehicle Property Editor" end
		makeVehGUI = emGUI:dxCreateWindow(0.36, 0.27, 0.29, 0.39, title, true)

		makeVehGUILabels[1] = emGUI:dxCreateLabel(0.25, 0.05, 0.12, 0.04, "Brand", true, makeVehGUI)
		makeVehGUILabels[2] = emGUI:dxCreateLabel(0.63, 0.05, 0.12, 0.04, "Model", true, makeVehGUI)
		makeVehGUILabels[3] = emGUI:dxCreateLabel(0.05, 0.05, 0.12, 0.04, "Year", true, makeVehGUI)
		makeVehGUILabels[4] = emGUI:dxCreateLabel(0.045, 0.285, 0.02, 0.04, "$", true, makeVehGUI)
		makeVehGUILabels[5] = emGUI:dxCreateLabel(0.045, 0.22, 0.12, 0.04, "Price", true, makeVehGUI)
		makeVehGUILabels[6] = emGUI:dxCreateLabel(0.045, 0.37, 0.17, 0.04, "GTA Vehicle ID", true, makeVehGUI)
		makeVehGUILabels[7] = emGUI:dxCreateLabel(0.4, 0.585, 0.17, 0.04, "Vehicle Type", true, makeVehGUI)
		makeVehGUILabels[8] = emGUI:dxCreateLabel(0.40, 0.22, 0.17, 0.04, "Dealerships", true, makeVehGUI)
		makeVehGUILabels[9] = emGUI:dxCreateLabel(0.045, 0.52, 0.17, 0.04, "Vehicle Tax ($/H)", true, makeVehGUI)
		feedbackLabel = emGUI:dxCreateLabel(0.415, 0.70, 0.17, 0.04, "", true, makeVehGUI)
		emGUI:dxLabelSetColor(feedbackLabel, 255, 0, 0)
		emGUI:dxLabelSetHorizontalAlign(feedbackLabel, "center")

		vehTypeComboBox = emGUI:dxCreateComboBox(0.57, 0.58, 0.32, 0.06, true, makeVehGUI)

		for i, vehType in ipairs(g_vehicleTypes) do
			emGUI:dxComboBoxAddItem(vehTypeComboBox, vehType.type)
		end
	
		emGUI:dxComboBoxSetSelectedItem(vehTypeComboBox, 1)
		
		yearInput = emGUI:dxCreateEdit(0.054, 0.105, 0.15, 0.06, "", true, makeVehGUI)
		brandInput = emGUI:dxCreateEdit(0.25, 0.105, 0.32, 0.06, "", true, makeVehGUI)
		modelInput = emGUI:dxCreateEdit(0.63, 0.105, 0.32, 0.06, "", true, makeVehGUI)
		priceInput = emGUI:dxCreateEdit(0.07, 0.28, 0.26, 0.06, "", true, makeVehGUI)
		vehidInput = emGUI:dxCreateEdit(0.045, 0.43, 0.285, 0.06, "", true, makeVehGUI)
		taxInput = emGUI:dxCreateEdit(0.045, 0.58, 0.285, 0.06, "", true, makeVehGUI)
		
		dealershipGridlist = emGUI:dxCreateGridList(0.40, 0.28, 0.56, 0.27, true, makeVehGUI, true)
		emGUI:dxGridListAddColumn(dealershipGridlist, "ID", 0.2)
		emGUI:dxGridListAddColumn(dealershipGridlist, "Dealership", 0.8)

		for i, dealerName in ipairs(g_dealerships) do
			emGUI:dxGridListAddRow(dealershipGridlist)
			emGUI:dxGridListSetItemText(dealershipGridlist, i, 1, i)
			emGUI:dxGridListSetItemText(dealershipGridlist, i, 2, dealerName)
		end

		if (editorData) and (editor) then
			emGUI:dxSetText(yearInput, editorData.year)
			emGUI:dxSetText(brandInput, editorData.brand)
			emGUI:dxSetText(modelInput, editorData.model)
			emGUI:dxSetText(priceInput, editorData.price)
			emGUI:dxSetText(vehidInput, editorData.vehid)
			emGUI:dxSetText(taxInput, editorData.tax)
			emGUI:dxComboBoxSetSelectedItem(vehTypeComboBox, editorData.type)
			emGUI:dxGridListSetSelectedItem(dealershipGridlist, editorData.dealership, 1)
		end
		
		local cancelButton = emGUI:dxCreateButton(0.10, 0.79, 0.30, 0.16, "CANCEL", true, makeVehGUI)
		addEventHandler("onClientDgsDxMouseClick", cancelButton, cancelButtonClick)
		local saveButton = emGUI:dxCreateButton(0.60, 0.79, 0.30, 0.16, "SAVE", true, makeVehGUI)
		addEventHandler("onClientDgsDxMouseClick", saveButton, saveButtonClick)
		addEventHandler("onClientDgsDxWindowClose", makeVehGUI, function()
			editorData = nil
			if emGUI:dxIsWindowVisible(vehicleEditorGUI) then emGUI:dxCloseWindow(vehicleEditorGUI) end
		end)
	end
end
addEvent("vehicle:makevehGUI", true)
addEventHandler("vehicle:makevehGUI", root, makeVehicle)
addCommandHandler("makeveh", makeVehicle)

function cancelButtonClick(button, state)
	if (button == "left") and (state == "down") then
		emGUI:dxCloseWindow(makeVehGUI)
	end
end

function saveButtonClick(button, state)
	if (button == "left") and (state == "down") then
		local yearValue = emGUI:dxGetText(yearInput)
		if not tonumber(yearValue) then
			emGUI:dxSetText(feedbackLabel, "Please enter a valid year.")
			return false
		end

		local brandValue = emGUI:dxGetText(brandInput)
		if not tostring(brandValue) or not (string.len(brandValue) > 2) or not (string.len(brandValue) < 20) then
			emGUI:dxSetText(feedbackLabel, "Brand must be between 2 and 20 characters!")
			return false
		end

		local modelValue = emGUI:dxGetText(modelInput)
		if not tostring(modelValue) or not (string.len(modelValue) > 2) or not (string.len(modelValue) < 50) then
			emGUI:dxSetText(feedbackLabel, "Model must be between 2 and 50 characters!")
			return false
		end

		local priceValue = emGUI:dxGetText(priceInput)
		if not tonumber(priceValue) or (tonumber(priceValue) > 999999999999) or (tonumber(priceValue) <= 0) then
			emGUI:dxSetText(feedbackLabel, "Please enter a valid price.")
			return false
		end

		local vehID = emGUI:dxGetText(vehidInput)
		if not tonumber(vehID) or not exports.global:table_find(tonumber(vehID), g_validVehicles) then
			emGUI:dxSetText(feedbackLabel, "That is not a valid vehicle ID or this vehicle cannot be created!")
			return false
		end

		local vehTax = emGUI:dxGetText(taxInput)
		if not tonumber(vehTax) or (tonumber(vehTax) < 0) or (tonumber(vehTax) > 5000) then
			emGUI:dxSetText(feedbackLabel, "Tax must be between 0 and 5,000.")
			return false
		end

		local selectedCol = emGUI:dxGridListGetSelectedItem(dealershipGridlist)
		local dealershipID
		if (selectedCol) and (selectedCol ~= -1) then
			dealershipID = emGUI:dxGridListGetItemText(dealershipGridlist, selectedCol, 1)
		else
			emGUI:dxSetText(feedbackLabel, "Please select a dealership for the vehicle to spawn in.")
			return false
		end

		local vehType = emGUI:dxComboBoxGetSelectedItem(vehTypeComboBox)
		emGUI:dxCloseWindow(makeVehGUI)

		if (editor) then
			local tempVehicle = getPedOccupiedVehicle(localPlayer)
			setElementData(tempVehicle, "tempveh:year", yearValue)
			setElementData(tempVehicle, "tempveh:brand", brandValue)
			setElementData(tempVehicle, "tempveh:model", modelValue)
			setElementData(tempVehicle, "tempveh:price", priceValue)
			setElementData(tempVehicle, "tempveh:vehid", vehID)
			setElementData(tempVehicle, "tempveh:dealership", dealershipID)
			setElementData(tempVehicle, "vehicle:type", vehType)
			setElementData(tempVehicle, "tempveh:tax", vehTax)

			if (getElementModel(tempVehicle) ~= vehID) then
				setElementModel(tempVehicle, vehID)
			end
		else
			triggerServerEvent("vehicle:s_makeEditorVehicle", localPlayer, localPlayer, yearValue, brandValue, modelValue, priceValue, vehID, dealershipID, vehType, vehTax, true)
		end
	end
end

------------------------------------------------------------------------------------------------------------------------------------------------------

function drawSideEditorGUI(isNewVehicle, editorData)
	if (emGUI:dxIsWindowVisible(edittingWindow)) then emGUI:dxCloseWindow(edittingWindow) return end
	
	edittingWindow = emGUI:dxCreateWindow(0, 0.27, 0.08, 0.40, "", true, true, true, true)

	cancelCreButton = emGUI:dxCreateButton(0.10, 0.04, 0.78, 0.16, "CANCEL", true, edittingWindow)
	addEventHandler("onClientDgsDxMouseClick", cancelCreButton, cancelCreButtonClick)

	editVehicleButton = emGUI:dxCreateButton(0.10, 0.22, 0.78, 0.16, "VEHICLE\nEDITOR", true, edittingWindow)
	addEventHandler("onClientDgsDxMouseClick", editVehicleButton, editVehicleButtonClick)

	editPropertiesButton = emGUI:dxCreateButton(0.10, 0.40, 0.78, 0.16, "PROPERTIES", true, edittingWindow)
	
	unsetCustomButton = emGUI:dxCreateButton(0.10, 0.58, 0.78, 0.16, "UNSET\nCUSTOM", true, edittingWindow)
	addEventHandler("onClientDgsDxMouseClick", unsetCustomButton, unsetCustomButtonClick)

	saveVehButton = emGUI:dxCreateButton(0.10, 0.76, 0.78, 0.16, "SAVE", true, edittingWindow)
	addEventHandler("onClientDgsDxMouseClick", saveVehButton, saveVehButtonClick)

	if (isNewVehicle) then
		emGUI:dxSetEnabled(unsetCustomButton, false)
		emGUI:dxSetEnabled(editPropertiesButton, false)
	else
		editor = editorData
		emGUI:dxSetEnabled(unsetCustomButton, false)
		addEventHandler("onClientDgsDxMouseClick", editPropertiesButton, editPropertiesButtonClick)
	end
end
addEvent("vehicle:modding:drawsidebar", true)
addEventHandler("vehicle:modding:drawsidebar", root, drawSideEditorGUI)

------------------------------------------------------ FUNCTIONS ------------------------------------------------------

function cancelCreButtonClick(b, c)
	if (b == "left") and (c == "down") then
		emGUI:dxCloseWindow(edittingWindow)
		if emGUI:dxIsWindowVisible(vehicleEditorGUI) then emGUI:dxCloseWindow(vehicleEditorGUI) end
		triggerServerEvent("vehicle:cancelvehcre", localPlayer, localPlayer)
	end
end

function saveVehButtonClick(b, c)
	if (b == "left") and (c == "down") then
		if (editor) then
			confirmVehicleUpdate()
		else
			emGUI:dxCloseWindow(edittingWindow)
			triggerServerEvent("vehicle:savevehcre", localPlayer, localPlayer)
		end
	end
end

function editVehicleButtonClick(b, c)
	if (b == "left") and (c == "down") then
		triggerServerEvent("vehicle:modding:editVehicle", localPlayer, localPlayer, "gui")
	end
end

function editPropertiesButtonClick(b, c)
	if (b == "left") and (c == "down") then
		makeVehicle(editor)
	end
end

function unsetCustomButtonClick(b, c)
	if (b == "left") and (c == "down") then
		--
	end
end

function confirmVehicleUpdate(unsetCustomCall)
	if emGUI:dxIsWindowVisible(confirmVehUpdateGUI) then emGUI:dxCloseWindow(confirmVehUpdateGUI) return end
	local buttonFont_35 = emGUI:dxCreateNewFont("fonts/buttonFont.ttf", 35)
	confirmVehUpdateGUI = emGUI:dxCreateWindow(0.29, 0.33, 0.34, 0.23, "", true, true, _, true)

	local label1 = emGUI:dxCreateLabel(0.1, 0.05, 0.83, 0.23, "CONFIRM UPDATE", true, confirmVehUpdateGUI)
	local label2 = emGUI:dxCreateLabel(0.09, 0.32, 0.82, 0.24, "Are you sure you would like to update this vehicle with your changes?\nThis will effect ALL vehicles in the world with the current model to update and reload.", true, confirmVehUpdateGUI)
	emGUI:dxSetFont(label1, buttonFont_35)
	emGUI:dxLabelSetHorizontalAlign(label1, "center")
	emGUI:dxLabelSetHorizontalAlign(label2, "center")

	confirmNoButton = emGUI:dxCreateButton(0.06, 0.57, 0.40, 0.33, "NO, TAKE ME BACK", true, confirmVehUpdateGUI)
	addEventHandler("onClientDgsDxMouseClick", confirmNoButton, function() emGUI:dxCloseWindow(confirmVehUpdateGUI) end)
	confirmYesButton = emGUI:dxCreateButton(0.54, 0.57, 0.40, 0.33, "I'M SURE", true, confirmVehUpdateGUI)

	if tonumber(unsetCustomCall) then
		emGUI:dxSetText(label2, "Are you sure you would like to unset this vehicle's custom properties?\nThis will revert it back to it's library model's values.")
		addEventHandler("onClientDgsDxMouseClick", confirmYesButton, function()
			triggerServerEvent("vehicle:modding:unsetCustomVehicle", localPlayer, localPlayer, unsetCustomCall)
			emGUI:dxCloseWindow(confirmVehUpdateGUI)
			emGUI:dxCloseWindow(makeVehGUI)
			if emGUI:dxIsWindowVisible(edittingWindow) then emGUI:dxCloseWindow(edittingWindow) end
			editor = false
		end)
	else
		addEventHandler("onClientDgsDxMouseClick", confirmYesButton, confirmYesButtonClick)
	end
end
addEvent("vehicle:modding:confirmVehicleUpdate", true)
addEventHandler("vehicle:modding:confirmVehicleUpdate", root, confirmVehicleUpdate)

function confirmYesButtonClick(b, c)
	if (b == "left") and (c == "down") then
		emGUI:dxCloseWindow(edittingWindow)
		emGUI:dxCloseWindow(confirmVehUpdateGUI)
		editor = false
		triggerServerEvent("vehicle:vehlist:updateLibraryVehicle", localPlayer, localPlayer)
	end
end