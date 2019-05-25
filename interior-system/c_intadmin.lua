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

-- /intlist - By Skully (09/06/18) [Helper/MT/Developers]
function showInteriorIdsList()
	if exports.global:isPlayerHelper(localPlayer) or exports.global:isPlayerMappingTeam(localPlayer) or exports.global:isPlayerDeveloper(localPlayer) then
		if emGUI:dxIsWindowVisible(interiorsListGUI) then emGUI:dxCloseWindow(interiorsListGUI) return end

		local interiorsListGUILabels = {}

		interiorsListGUI = emGUI:dxCreateWindow(0.25, 0.20, 0.50, 0.53, "Interiors List", true)

		interiorsGridList = emGUI:dxCreateGridList(0.02, 0.02, 0.97, 0.76, true, interiorsListGUI, true)
		emGUI:dxGridListAddColumn(interiorsGridList, "ID", 0.03)
		emGUI:dxGridListAddColumn(interiorsGridList, "Interior ID", 0.08)
		emGUI:dxGridListAddColumn(interiorsGridList, "Category", 0.2)
		emGUI:dxGridListAddColumn(interiorsGridList, "Size", 0.1)
		emGUI:dxGridListAddColumn(interiorsGridList, "Description", 0.59)

		for i, int in ipairs(g_interiors) do
			local row = emGUI:dxGridListAddRow(interiorsGridList, i)
			emGUI:dxGridListSetItemText(interiorsGridList, row, 1, i)
			emGUI:dxGridListSetItemText(interiorsGridList, row, 2, int[1])
			local intCategory = int[3]
			emGUI:dxGridListSetItemText(interiorsGridList, row, 3, g_interiorTypes[intCategory][1])
			local intSize = int[4]
			emGUI:dxGridListSetItemText(interiorsGridList, row, 4, g_interiorSizes[intSize][1])
			emGUI:dxGridListSetItemText(interiorsGridList, row, 5, int[5])
		end

		interiorsListGUILabels[1] = emGUI:dxCreateLabel(0.03, 0.8, 0.06, 0.03, "Category", true, interiorsListGUI)
		interiorsListGUILabels[2] = emGUI:dxCreateLabel(0.30, 0.8, 0.06, 0.03, "Size", true, interiorsListGUI)

		categoryCombobox = emGUI:dxCreateComboBox(0.03, 0.84, 0.22, 0.04, true, interiorsListGUI)
		emGUI:dxComboBoxAddItem(categoryCombobox, "All")
		for i, category in ipairs(g_interiorTypes) do
			emGUI:dxComboBoxAddItem(categoryCombobox, category[1])
		end
		emGUI:dxComboBoxSetSelectedItem(categoryCombobox, 1)
		addEventHandler("onDgsComboBoxSelect", categoryCombobox, handleGridSorting)

		sizeCombobox = emGUI:dxCreateComboBox(0.30, 0.84, 0.22, 0.04, true, interiorsListGUI)
		emGUI:dxComboBoxAddItem(sizeCombobox, "All")
		for i, size in ipairs(g_interiorSizes) do
			emGUI:dxComboBoxAddItem(sizeCombobox, size[1])
		end
		emGUI:dxComboBoxSetSelectedItem(sizeCombobox, 1)
		addEventHandler("onDgsComboBoxSelect", sizeCombobox, handleGridSorting)
		
		local closeButton = emGUI:dxCreateButton(0.76, 0.84, 0.19, 0.11, "Close", true, interiorsListGUI)
		addEventHandler("onClientDgsDxMouseClick", closeButton, function(b, c) if (b == "left") and (c == "down") then emGUI:dxCloseWindow(interiorsListGUI) end end)
		local previewIntButton = emGUI:dxCreateButton(0.56, 0.84, 0.19, 0.11, "Preview Interior", true, interiorsListGUI)
		addEventHandler("onClientDgsDxMouseClick", previewIntButton, function(b, c)
			if (b == "left") and (c == "down") then
				local selected = emGUI:dxGridListGetSelectedItem(interiorsGridList)
				local intID = emGUI:dxGridListGetItemText(interiorsGridList, selected, 1)
				triggerServerEvent("interior:previewInteriorCall", localPlayer, localPlayer, tonumber(intID))
				emGUI:dxCloseWindow(interiorsListGUI)
			end
		end)
		emGUI:dxSetEnabled(previewIntButton, false)

		addEventHandler("ondxGridListSelect", interiorsGridList, function(c)
			local enable = c ~= -1
			emGUI:dxSetEnabled(previewIntButton, enable)
		end)
	end
end
addCommandHandler("intlist", showInteriorIdsList)
addEvent("interior:showInteriorIdsList", true) -- Used by /createint GUI.
addEventHandler("interior:showInteriorIdsList", root, showInteriorIdsList)

function handleGridSorting()
	emGUI:dxGridListClearRow(interiorsGridList)
	local selectedCategory = emGUI:dxComboBoxGetSelectedItem(categoryCombobox) - 1
	local selectedSize = emGUI:dxComboBoxGetSelectedItem(sizeCombobox) - 1

	for i, interior in ipairs(g_interiors) do
		local intCategory = interior[3]
		local intSize = interior[4]
		if (selectedCategory == 0) or (g_interiorTypes[intCategory][2] == selectedCategory) then
			if (selectedSize == 0) or (g_interiorSizes[intSize][2] == selectedSize) then
				local row = emGUI:dxGridListAddRow(interiorsGridList)
				emGUI:dxGridListSetItemText(interiorsGridList, row, 1, i)
				emGUI:dxGridListSetItemText(interiorsGridList, row, 2, interior[1])
				emGUI:dxGridListSetItemText(interiorsGridList, row, 3, g_interiorTypes[intCategory][1])
				emGUI:dxGridListSetItemText(interiorsGridList, row, 4, g_interiorSizes[intSize][1])
				emGUI:dxGridListSetItemText(interiorsGridList, row, 5, interior[5])
			end
		end
	end
end

------------------------------------------------------------------------------------------------------------------------------

local isMTLeader = false
function c_showInteriorList(dataTable, ownerData)
	if (emGUI:dxIsWindowVisible(interiorListGUI)) then emGUI:dxCloseWindow(interiorListGUI) return end
	if exports.global:isPlayerTrialAdmin(localPlayer, true) or exports.global:isPlayerMappingTeam(localPlayer, true) then
		if not (dataTable) or not (ownerData) then
			outputChatBox("Something went wrong whilst opening the interior list.", 255, 0, 0)
			exports.global:outputDebug("@c_showInteriorList: dataTable or ownerData not received or is empty. (Opened by " .. getPlayerName(localPlayer) .. ")")
			return false
		end

		if exports.global:isPlayerMappingTeamLeader(localPlayer) or exports.global:isPlayerManager(localPlayer) then isMTLeader = true end

		local interiorListLabels = {}
		interiorListGUI = emGUI:dxCreateWindow(0.19, 0.19, 0.62, 0.62, "Interior Database", true)

		interiorListLabels[1] = emGUI:dxCreateLabel(0.045, 0.043, 0.13, 0.02, "Search (Interior Name/ID):", true, interiorListGUI)
		interiorListLabels[2] = emGUI:dxCreateLabel(0.103, 0.093, 0.08, 0.02, "Search (Owner):", true, interiorListGUI)
		searchIntNameInput = emGUI:dxCreateEdit(0.2, 0.04, 0.20, 0.04, "", true, interiorListGUI)
		searchOwnerInput = emGUI:dxCreateEdit(0.2, 0.09, 0.20, 0.04, "", true, interiorListGUI)

		if isMTLeader then
			delInteriorButton = emGUI:dxCreateButton(0.43, 0.04, 0.16, 0.09, "Delete Interior", true, interiorListGUI)
			addEventHandler("onClientDgsDxMouseClick", delInteriorButton, delInteriorButtonClick)
		end
		
		restoreIntButton = emGUI:dxCreateButton(0.63, 0.04, 0.16, 0.09, "Restore Interior", true, interiorListGUI)
		addEventHandler("onClientDgsDxMouseClick", restoreIntButton, restoreIntButtonClick)

		gotoRemoveIntButton = emGUI:dxCreateButton(0.83, 0.04, 0.16, 0.09, "Go to Interior", true, interiorListGUI)
		addEventHandler("onClientDgsDxMouseClick", gotoRemoveIntButton, gotoRemoveIntButtonClick)

		if exports.global:isPlayerManager(localPlayer, true) then emGUI:dxSetText(gotoRemoveIntButton, "Remove Interior") end

		intlistGridList = emGUI:dxCreateGridList(0.01, 0.16, 0.98, 0.82, true, interiorListGUI)
		emGUI:dxGridListAddColumn(intlistGridList, "ID", 0.04)
		emGUI:dxGridListAddColumn(intlistGridList, "Name", 0.23)
		emGUI:dxGridListAddColumn(intlistGridList, "Type", 0.11)
		emGUI:dxGridListAddColumn(intlistGridList, "Price", 0.08)
		emGUI:dxGridListAddColumn(intlistGridList, "Owner", 0.13)
		emGUI:dxGridListAddColumn(intlistGridList, "Disabled", 0.05)
		emGUI:dxGridListAddColumn(intlistGridList, "Deleted", 0.05)
		emGUI:dxGridListAddColumn(intlistGridList, "Locked", 0.05)
		emGUI:dxGridListAddColumn(intlistGridList, "Last Used", 0.14)
		emGUI:dxGridListAddColumn(intlistGridList, "Created", 0.14)
		emGUI:dxGridListAddColumn(intlistGridList, "Created By", 0.09)

		for i, result in ipairs(dataTable) do
			emGUI:dxGridListAddRow(intlistGridList)
			emGUI:dxGridListSetItemText(intlistGridList, i, 1, result.id)
			emGUI:dxGridListSetItemText(intlistGridList, i, 2, result.name)
			emGUI:dxGridListSetItemText(intlistGridList, i, 3, g_interiorTypes[result.type][1])
			emGUI:dxGridListSetItemText(intlistGridList, i, 4, "$" .. exports.global:formatNumber(result.price))
			emGUI:dxGridListSetItemText(intlistGridList, i, 5, ownerData[i] or "Unknown")

			local disabledState = "No"; if result.disabled == 1 then disabledState = "Yes" end
			emGUI:dxGridListSetItemText(intlistGridList, i, 6, disabledState)

			local deletedState = "No"; if result.deleted == 1 then deletedState = "Yes" end
			emGUI:dxGridListSetItemText(intlistGridList, i, 7, deletedState)

			local lockedState = "No"; if result.locked == 1 then lockedState = "Yes" end
			emGUI:dxGridListSetItemText(intlistGridList, i, 8, lockedState)

			local lastUsedTime = exports.global:convertTime(result.last_used)
			emGUI:dxGridListSetItemText(intlistGridList, i, 9, lastUsedTime[2] .. " at " .. lastUsedTime[1])

			local createdTime = exports.global:convertTime(result.created_date)
			emGUI:dxGridListSetItemText(intlistGridList, i, 10, createdTime[2] .. " at " .. createdTime[1])

			emGUI:dxGridListSetItemText(intlistGridList, i, 11, result.created_by)
		end

		addEventHandler("ondxGridListItemDoubleClick", intlistGridList, function(b, s, id)
			if b == "left" and s == "down" and (id) then
				triggerServerEvent("interior:checkintcall", localPlayer, localPlayer, "checkint", id)
			end
		end)

		-- Interior ID/Name search.
		addEventHandler("onDgsTextChange", searchIntNameInput, function(newText)
			if (#newText ~= 0) then emGUI:dxSetEnabled(searchOwnerInput, false) else emGUI:dxSetEnabled(searchOwnerInput, true) end
			emGUI:dxGridListClearRow(intlistGridList)
			for v, result in pairs(dataTable) do
				if result.name:lower():find(newText:lower()) or tostring(result.id):find(newText) then
					local row = emGUI:dxGridListAddRow(intlistGridList)
					emGUI:dxGridListSetItemText(intlistGridList, row, 1, result.id)
					emGUI:dxGridListSetItemText(intlistGridList, row, 2, result.name)
					emGUI:dxGridListSetItemText(intlistGridList, row, 3, g_interiorTypes[result.type][1])
					emGUI:dxGridListSetItemText(intlistGridList, row, 4, "$" .. exports.global:formatNumber(result.price))
					emGUI:dxGridListSetItemText(intlistGridList, row, 5, ownerData[i] or "Unknown")
					
					local disabledState = "No"; if result.disabled == 1 then disabledState = "Yes" end
					emGUI:dxGridListSetItemText(intlistGridList, row, 6, disabledState)

					local deletedState = "No"; if result.deleted == 1 then deletedState = "Yes" end
					emGUI:dxGridListSetItemText(intlistGridList, row, 7, deletedState)

					local lockedState = "No"; if result.locked == 1 then lockedState = "Yes" end
					emGUI:dxGridListSetItemText(intlistGridList, row, 8, lockedState)

					local lastUsedTime = exports.global:convertTime(result.last_used)
					emGUI:dxGridListSetItemText(intlistGridList, row, 9, lastUsedTime[2] .. " at " .. lastUsedTime[1])

					local createdTime = exports.global:convertTime(result.created_date)
					emGUI:dxGridListSetItemText(intlistGridList, row, 10, createdTime[2] .. " at " .. createdTime[1])
					emGUI:dxGridListSetItemText(intlistGridList, row, 11, result.created_by)
				end
			end
		end)

		-- Owner search.
		addEventHandler("onDgsTextChange", searchOwnerInput, function(newText)
			if (#newText ~= 0) then emGUI:dxSetEnabled(searchIntNameInput, false) else emGUI:dxSetEnabled(searchIntNameInput, true) end
			emGUI:dxGridListClearRow(intlistGridList)
			for v, result in pairs(dataTable) do
				if ownerData[v]:lower():find(newText:lower()) then
					local row = emGUI:dxGridListAddRow(intlistGridList)
					emGUI:dxGridListSetItemText(intlistGridList, row, 1, result.id)
					emGUI:dxGridListSetItemText(intlistGridList, row, 2, result.name)
					emGUI:dxGridListSetItemText(intlistGridList, row, 3, g_interiorTypes[result.type][1])
					emGUI:dxGridListSetItemText(intlistGridList, row, 4, "$" .. exports.global:formatNumber(result.price))
					emGUI:dxGridListSetItemText(intlistGridList, row, 5, ownerData[v] or "Unknown")
					
					local disabledState = "No"; if result.disabled == 1 then disabledState = "Yes" end
					emGUI:dxGridListSetItemText(intlistGridList, row, 6, disabledState)

					local deletedState = "No"; if result.deleted == 1 then deletedState = "Yes" end
					emGUI:dxGridListSetItemText(intlistGridList, row, 7, deletedState)

					local lockedState = "No"; if result.locked == 1 then lockedState = "Yes" end
					emGUI:dxGridListSetItemText(intlistGridList, row, 8, lockedState)

					local lastUsedTime = exports.global:convertTime(result.last_used)
					emGUI:dxGridListSetItemText(intlistGridList, row, 9, lastUsedTime[2] .. " at " .. lastUsedTime[1])

					local createdTime = exports.global:convertTime(result.created_date)
					emGUI:dxGridListSetItemText(intlistGridList, row, 10, createdTime[2] .. " at " .. createdTime[1])

					emGUI:dxGridListSetItemText(intlistGridList, row, 11, result.created_by)
				end
			end
		end)

		addEventHandler("onDgsWindowClose", interiorListGUI, function() isMTLeader = false end)
	end
end
addEvent("interior:c_showInteriorList", true)
addEventHandler("interior:c_showInteriorList", root, c_showInteriorList)

function gotoRemoveIntButtonClick(b, c)
	if (b == "left") and (c == "down") then
		local selection = emGUI:dxGridListGetSelectedItem(intlistGridList)
		if not (selection) or (selection == -1) then
			outputChatBox("ERROR: Select an interior first!", 255, 0, 0)
			return false
		end

		local intID = emGUI:dxGridListGetItemText(intlistGridList, selection, 1)
		if exports.global:isPlayerManager(localPlayer, true) then
			triggerServerEvent("interior:removeintcall", localPlayer, localPlayer, "removeint", intID)
		else
			triggerServerEvent("interior:gotoint", localPlayer, localPlayer, "gotoint", intID)
		end
		emGUI:dxCloseWindow(interiorListGUI)
	end
end

function restoreIntButtonClick(b, c)
	if (b == "left") and (c == "down") then
		local selection = emGUI:dxGridListGetSelectedItem(intlistGridList)
		if not (selection) or (selection == -1) then
			outputChatBox("ERROR: Select an interior to restore first!", 255, 0, 0)
			return false
		end

		local intID = emGUI:dxGridListGetItemText(intlistGridList, selection, 1)
		triggerServerEvent("interior:restoreintcall", localPlayer, localPlayer, "restoreint", intID)
		emGUI:dxCloseWindow(interiorListGUI)
	end
end

function delInteriorButtonClick(b, c)
	if (b == "left") and (c == "down") then
		local selection = emGUI:dxGridListGetSelectedItem(intlistGridList)
		if not (selection) or (selection == -1) then
			outputChatBox("ERROR: Select an interior to delete first!", 255, 0, 0)
			return false
		end

		local intID = emGUI:dxGridListGetItemText(intlistGridList, selection, 1)
		emGUI:dxCloseWindow(interiorListGUI)
		triggerServerEvent("interior:deleteintcall", localPlayer, localPlayer, "deleteint", intID)
	end
end
