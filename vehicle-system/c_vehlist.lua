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

function c_showVehicleList(dataTable, createdBy, updatedBy)
	if (emGUI:dxIsWindowVisible(vehicleListGUI)) then emGUI:dxCloseWindow(vehicleListGUI) return end
	if exports.global:isPlayerTrialAdmin(localPlayer, true) or exports.global:isPlayerVehicleTeam(localPlayer, true) then

		if not (dataTable) then
			outputChatBox("Something went wrong whilst opening the vehicle library.", 255, 0, 0)
			exports.global:outputDebug("@c_showVehicleList: dataTable not received or is empty. (Opened by " .. getPlayerName(localPlayer) .. ")")
			return false
		end

		local vehlibGridlistLabels = {}
		vehicleListGUI = emGUI:dxCreateWindow(0.20, 0.17, 0.60, 0.60, "Vehicle Library", true)

		vehlibGridlist = emGUI:dxCreateGridList(0.02, 0.02, 0.95, 0.77, true, vehicleListGUI)
		emGUI:dxGridListAddColumn(vehlibGridlist, "dummyname", 0)
		emGUI:dxGridListAddColumn(vehlibGridlist, "ID", 0.04)
		emGUI:dxGridListAddColumn(vehlibGridlist, "OOC Model", 0.1)
		emGUI:dxGridListAddColumn(vehlibGridlist, "Year", 0.04)
		emGUI:dxGridListAddColumn(vehlibGridlist, "Brand", 0.11)
		emGUI:dxGridListAddColumn(vehlibGridlist, "Model", 0.2)
		emGUI:dxGridListAddColumn(vehlibGridlist, "Type", 0.08)
		emGUI:dxGridListAddColumn(vehlibGridlist, "Price", 0.08)
		emGUI:dxGridListAddColumn(vehlibGridlist, "Tax", 0.06)
		emGUI:dxGridListAddColumn(vehlibGridlist, "Created", 0.13)
		emGUI:dxGridListAddColumn(vehlibGridlist, "Created By", 0.09)
		emGUI:dxGridListAddColumn(vehlibGridlist, "Last Updated", 0.13)
		emGUI:dxGridListAddColumn(vehlibGridlist, "Updated By", 0.09)
		emGUI:dxGridListAddColumn(vehlibGridlist, "Dealership", 0.08)

		vehlibGridlistLabels[1] = emGUI:dxCreateLabel(0.02, 0.81, 0.07, 0.03, "Vehicle Search", true, vehicleListGUI)
		vehlibGridlistLabels[2] = emGUI:dxCreateLabel(0.23, 0.81, 0.07, 0.03, "Category Filter", true, vehicleListGUI)
		
		vehfeedbackLabel = emGUI:dxCreateLabel(0.06, 0.91, 0.30, 0.02, "", true, vehicleListGUI)
		emGUI:dxLabelSetHorizontalAlign(vehfeedbackLabel, "center", false)
		
		vehicleSearchInput = emGUI:dxCreateEdit(0.02, 0.845, 0.20, 0.04, "", true, vehicleListGUI)
		
		categoryFilterComboBox = emGUI:dxCreateComboBox(0.23, 0.845, 0.17, 0.04, true, vehicleListGUI)
		emGUI:dxComboBoxAddItem(categoryFilterComboBox, "All")
		for i, category in ipairs(g_vehicleTypes) do
			emGUI:dxComboBoxAddItem(categoryFilterComboBox, g_vehicleTypes[i].type)
		end
		emGUI:dxComboBoxSetSelectedItem(categoryFilterComboBox, 1)
		
		if (exports.global:isPlayerVehicleTeamLeader(localPlayer, true) or exports.global:isPlayerManager(localPlayer, true)) then
			editVehButton = emGUI:dxCreateButton(0.42, 0.84, 0.16, 0.10, "Edit Vehicle", true, vehicleListGUI)
			addEventHandler("onClientDgsDxMouseClick", editVehButton, editVehButtonClick)
			makeVehButton = emGUI:dxCreateButton(0.613, 0.84, 0.16, 0.10, "Make New Vehicle", true, vehicleListGUI)
			addEventHandler("onClientDgsDxMouseClick", makeVehButton, makeVehButtonClick)
			delVehicleButton = emGUI:dxCreateButton(0.81, 0.84, 0.16, 0.10, "DELETE VEHICLE", true, vehicleListGUI)
			addEventHandler("onClientDgsDxMouseClick", delVehicleButton, delVehicleButtonClick)
		else
			closeVehListButton = emGUI:dxCreateButton(0.81, 0.84, 0.16, 0.10, "Close", true, vehicleListGUI)
			addEventHandler("onClientDgsDxMouseClick", closeVehListButton, function() emGUI:dxCloseWindow(vehicleListGUI) end)
		end

		for i, result in ipairs(dataTable) do
			local vehName = getVehicleNameFromModel(result.vehid)
			local vehType = vehicleTypeToName(result.type)
			local vehPrice = exports.global:formatNumber(result.price)
			local vehTax = exports.global:formatNumber(result.tax)
			local createdDate = exports.global:convertTime(result.created_date, true)
			local lastUpdated = exports.global:convertTime(result.last_updated, true)
			local dealerName = getDealershipName(result.dealership)
			local dummyName = result.year .. " " .. result.brand .. " " .. result.model

			emGUI:dxGridListAddRow(vehlibGridlist)
			emGUI:dxGridListSetItemText(vehlibGridlist, i, 1, dummyName)
			emGUI:dxGridListSetItemText(vehlibGridlist, i, 2, result.id)
			emGUI:dxGridListSetItemText(vehlibGridlist, i, 3, "(" .. result.vehid .. ") " .. vehName)
			emGUI:dxGridListSetItemText(vehlibGridlist, i, 4, result.year)
			emGUI:dxGridListSetItemText(vehlibGridlist, i, 5, result.brand)
			emGUI:dxGridListSetItemText(vehlibGridlist, i, 6, result.model)
			emGUI:dxGridListSetItemText(vehlibGridlist, i, 7, vehType)
			emGUI:dxGridListSetItemText(vehlibGridlist, i, 8, "$" .. vehPrice)
			emGUI:dxGridListSetItemText(vehlibGridlist, i, 9, "$" .. vehTax .. "/H")
			emGUI:dxGridListSetItemText(vehlibGridlist, i, 10, createdDate[2])
			emGUI:dxGridListSetItemText(vehlibGridlist, i, 11, createdBy[i])
			emGUI:dxGridListSetItemText(vehlibGridlist, i, 12, lastUpdated[2])
			emGUI:dxGridListSetItemText(vehlibGridlist, i, 13, updatedBy[i])
			emGUI:dxGridListSetItemText(vehlibGridlist, i, 14, dealerName)
		end

		addEventHandler("onDgsComboBoxSelect", categoryFilterComboBox, function(category)
			emGUI:dxGridListClearRow(vehlibGridlist)
			for v, vehicleData in pairs(dataTable) do
				if vehicleData.type == (emGUI:dxComboBoxGetSelectedItem(categoryFilterComboBox) -1) or (emGUI:dxComboBoxGetSelectedItem(categoryFilterComboBox) - 1) == 0 then
					
					local row = emGUI:dxGridListAddRow(vehlibGridlist)
					local vehName = getVehicleNameFromModel(vehicleData.vehid)
					local vehType = vehicleTypeToName(vehicleData.type)
					local vehPrice = exports.global:formatNumber(vehicleData.price)
					local vehTax = exports.global:formatNumber(vehicleData.tax)
					local createdDate = exports.global:convertTime(vehicleData.created_date, true)
					local lastUpdated = exports.global:convertTime(vehicleData.last_updated, true)
					local dealerName = getDealershipName(vehicleData.dealership)
					local dummyName = vehicleData.year .. " " .. vehicleData.brand .. " " .. vehicleData.model
					emGUI:dxGridListSetItemText(vehlibGridlist, row, 1, dummyName)
					emGUI:dxGridListSetItemText(vehlibGridlist, row, 2, vehicleData.id)
					emGUI:dxGridListSetItemText(vehlibGridlist, row, 3, "(" .. vehicleData.vehid .. ") " .. vehName)
					emGUI:dxGridListSetItemText(vehlibGridlist, row, 4, vehicleData.year)
					emGUI:dxGridListSetItemText(vehlibGridlist, row, 5, vehicleData.brand)
					emGUI:dxGridListSetItemText(vehlibGridlist, row, 6, vehicleData.model)
					emGUI:dxGridListSetItemText(vehlibGridlist, row, 7, vehType)
					emGUI:dxGridListSetItemText(vehlibGridlist, row, 8, "$" .. vehPrice)
					emGUI:dxGridListSetItemText(vehlibGridlist, row, 9, "$" .. vehTax .. "/H")
					emGUI:dxGridListSetItemText(vehlibGridlist, row, 10, createdDate[2])
					emGUI:dxGridListSetItemText(vehlibGridlist, row, 11, createdBy[v])
					emGUI:dxGridListSetItemText(vehlibGridlist, row, 12, lastUpdated[2])
					emGUI:dxGridListSetItemText(vehlibGridlist, row, 13, updatedBy[v])
					emGUI:dxGridListSetItemText(vehlibGridlist, row, 14, dealerName)
				end
			end
		end)

		addEventHandler("onDgsTextChange", vehicleSearchInput, function(newText)
			emGUI:dxGridListClearRow(vehlibGridlist)
			for v, vehicleData in pairs(dataTable) do
				local tempString = vehicleData.year .. " " .. vehicleData.brand .. " " .. vehicleData.model
				if vehicleData.type == (emGUI:dxComboBoxGetSelectedItem(categoryFilterComboBox) -1) or (emGUI:dxComboBoxGetSelectedItem(categoryFilterComboBox) - 1) == 0 then
					if tempString:lower():find(newText:lower()) or tostring(vehicleData.id):find(newText) then
						local row = emGUI:dxGridListAddRow(vehlibGridlist)
						local vehName = getVehicleNameFromModel(vehicleData.vehid)
						local vehType = vehicleTypeToName(vehicleData.type)
						local vehPrice = exports.global:formatNumber(vehicleData.price)
						local vehTax = exports.global:formatNumber(vehicleData.tax)
						local createdDate = exports.global:convertTime(vehicleData.created_date, true)
						local lastUpdated = exports.global:convertTime(vehicleData.last_updated, true)
						local dealerName = getDealershipName(vehicleData.dealership)
						local dummyName = vehicleData.year .. " " .. vehicleData.brand .. " " .. vehicleData.model

						emGUI:dxGridListSetItemText(vehlibGridlist, row, 1, dummyName)
						emGUI:dxGridListSetItemText(vehlibGridlist, row, 2, vehicleData.id)
						emGUI:dxGridListSetItemText(vehlibGridlist, row, 3, "(" .. vehicleData.vehid .. ") " .. vehName)
						emGUI:dxGridListSetItemText(vehlibGridlist, row, 4, vehicleData.year)
						emGUI:dxGridListSetItemText(vehlibGridlist, row, 5, vehicleData.brand)
						emGUI:dxGridListSetItemText(vehlibGridlist, row, 6, vehicleData.model)
						emGUI:dxGridListSetItemText(vehlibGridlist, row, 7, vehType)
						emGUI:dxGridListSetItemText(vehlibGridlist, row, 8, "$" .. vehPrice)
						emGUI:dxGridListSetItemText(vehlibGridlist, row, 9, "$" .. vehTax .. "/H")
						emGUI:dxGridListSetItemText(vehlibGridlist, row, 10, createdDate[2])
						emGUI:dxGridListSetItemText(vehlibGridlist, row, 11, createdBy[v])
						emGUI:dxGridListSetItemText(vehlibGridlist, row, 12, lastUpdated[2])
						emGUI:dxGridListSetItemText(vehlibGridlist, row, 13, updatedBy[v])
						emGUI:dxGridListSetItemText(vehlibGridlist, row, 14, dealerName)
					end
				end
			end
		end)
	end
end
addEvent("vehicle:c_showvehlist", true)
addEventHandler("vehicle:c_showvehlist", root, c_showVehicleList)

function editVehButtonClick(button, state)
	if (button == "left") and (state == "down") then
		local selection = emGUI:dxGridListGetSelectedItem(vehlibGridlist)
		if not (selection) or (selection == -1) then
			emGUI:dxLabelSetColor(vehfeedbackLabel, 255, 0, 0)
			emGUI:dxSetText(vehfeedbackLabel, "Please select a vehicle to edit first!")
			return false
		end

		local vehID = emGUI:dxGridListGetItemText(vehlibGridlist, selection, 2)
		triggerServerEvent("vehicle:vehlist:editvehicle", localPlayer, localPlayer, vehID)
		emGUI:dxCloseWindow(vehicleListGUI)
	end
end

function makeVehButtonClick(button, state)
	if (button == "left") and (state == "down") then
		emGUI:dxCloseWindow(vehicleListGUI)
		triggerEvent("vehicle:makevehGUI", localPlayer)
	end
end

function delVehicleButtonClick(b, c)
	if (b == "left") and (c == "down") then
		local selection = emGUI:dxGridListGetSelectedItem(vehlibGridlist)
		if not (selection) or (selection == -1) then
			emGUI:dxLabelSetColor(vehfeedbackLabel, 255, 0, 0)
			emGUI:dxSetText(vehfeedbackLabel, "Please select a vehicle to delete first!")
			return false
		end

		vehlibToDelete = emGUI:dxGridListGetItemText(vehlibGridlist, selection, 2)
		emGUI:dxSetVisible(vehicleListGUI, false)
		confirmVehlibDelete()
	end
end

function confirmVehlibDelete()
	if emGUI:dxIsWindowVisible(confirmVehlibDeleteGUI) then emGUI:dxCloseWindow(confirmVehlibDeleteGUI) return end
	confirmVehlibDeleteGUI = emGUI:dxCreateWindow(0.33, 0.33, 0.34, 0.23, "", true, true, _, true)

	local label1 = emGUI:dxCreateLabel(0.1, 0.05, 0.83, 0.23, "CONFIRM DELETION", true, confirmVehlibDeleteGUI)
	local label2 = emGUI:dxCreateLabel(0.09, 0.32, 0.82, 0.24, "Are you sure you would like to delete this library vehicle?\nThis will delete ALL vehicles in the world with this library ID.", true, confirmVehlibDeleteGUI)
	local buttonFont_35 = emGUI:dxCreateNewFont("fonts/buttonFont.ttf", 35)
	emGUI:dxSetFont(label1, buttonFont_35)
	emGUI:dxLabelSetHorizontalAlign(label1, "center")
	emGUI:dxLabelSetHorizontalAlign(label2, "center")

	confirmNoButton = emGUI:dxCreateButton(0.06, 0.57, 0.40, 0.33, "NO, TAKE ME BACK", true, confirmVehlibDeleteGUI)
	addEventHandler("onClientDgsDxMouseClick", confirmNoButton, function()
		emGUI:dxCloseWindow(confirmVehlibDeleteGUI)
		emGUI:dxSetVisible(vehicleListGUI, true)
	end)
	confirmYesButton = emGUI:dxCreateButton(0.54, 0.57, 0.40, 0.33, "I'M SURE", true, confirmVehlibDeleteGUI)
	addEventHandler("onClientDgsDxMouseClick", confirmYesButton, function()
		emGUI:dxCloseWindow(confirmVehlibDeleteGUI)
		emGUI:dxCloseWindow(vehicleListGUI)
		triggerServerEvent("vehicle:vehlist:deletevehicle", localPlayer, localPlayer, vehlibToDelete)
		vehlibToDelete = nil
	end)
end