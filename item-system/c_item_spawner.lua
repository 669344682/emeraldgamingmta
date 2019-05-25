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

function showItemSpawnerGUI(rank)
	if not tonumber(rank) then rank = 2 end

	local guiState = emGUI:dxIsWindowVisible(itemSpawner)
	if (guiState) then emGUI:dxCloseWindow(itemSpawner) return end

	local itemSpawnerLabels = {}
	itemSpawner = emGUI:dxCreateWindow(0.27, 0.11, 0.47, 0.76, "Item Spawner", true)

	itemsGridList = emGUI:dxCreateGridList(0.05, 0.05, 0.90, 0.73, true, itemSpawner, true)
	emGUI:dxGridListAddColumn(itemsGridList, "ID", 0.05)
	emGUI:dxGridListAddColumn(itemsGridList, "Item Name", 0.25)
	emGUI:dxGridListAddColumn(itemsGridList, "Item Description", 0.48)
	emGUI:dxGridListAddColumn(itemsGridList, "Size", 0.045)
	emGUI:dxGridListAddColumn(itemsGridList, "Category", 0.1)

	local itemImage = emGUI:dxCreateImage(0.08, 0.815, 0.13, 0.125, ":assets/images/logoIcon.png", true, itemSpawner)
	itemSpawnerLabels[1] = emGUI:dxCreateLabel(0.24, 0.81, 0.09, 0.02, "Item Search:", true, itemSpawner)
	itemSpawnerLabels[2] = emGUI:dxCreateLabel(0.24, 0.88, 0.09, 0.02, "Item Value:", true, itemSpawner)
	itemSpawnerLabels[3] = emGUI:dxCreateLabel(0.52, 0.81, 0.09, 0.02, "Amount:", true, itemSpawner)
	itemSpawnerLabels[4] = emGUI:dxCreateLabel(0.52, 0.88, 0.11, 0.02, "Spawn to Player:", true, itemSpawner)
	itemSpawnerLabels[5] = emGUI:dxCreateLabel(0.72, 0.81, 0.09, 0.02, "Category Filter", true, itemSpawner)    

	itemFeedbackLabel = emGUI:dxCreateLabel(0.30, 0.96, 0.41, 0.03, "Item will be spawned in your inventory.", true, itemSpawner)
	emGUI:dxLabelSetHorizontalAlign(itemFeedbackLabel, "center")
	
	itemSearchInput = emGUI:dxCreateEdit(0.24, 0.84, 0.25, 0.03, "", true, itemSpawner)
	itemValueInput = emGUI:dxCreateEdit(0.24, 0.91, 0.25, 0.03, "", true, itemSpawner)
	itemAmountInput = emGUI:dxCreateEdit(0.52, 0.84, 0.11, 0.03, "1", true, itemSpawner)
	spawnToInput = emGUI:dxCreateEdit(0.52, 0.91, 0.21, 0.03, "", true, itemSpawner)

	for v, item in pairs(g_itemList) do
		local row = emGUI:dxGridListAddRow(itemsGridList)
		emGUI:dxGridListSetItemText(itemsGridList, row, 1, v)
		emGUI:dxGridListSetItemText(itemsGridList, row, 2, item[2])
		emGUI:dxGridListSetItemText(itemsGridList, row, 3, item[3])
		emGUI:dxGridListSetItemText(itemsGridList, row, 4, "?")
		emGUI:dxGridListSetItemText(itemsGridList, row, 5, categoryTable[item[4]])
	end

	categoryComboBox = emGUI:dxCreateComboBox(0.72, 0.84, 0.23, 0.03, true, itemSpawner)
	for i, category in ipairs(categoryTable) do
		emGUI:dxComboBoxAddItem(categoryComboBox, category)
	end
	
	emGUI:dxComboBoxSetSelectedItem(categoryComboBox, 1)

	addEventHandler("onDgsComboBoxSelect", categoryComboBox, function(category)
		emGUI:dxGridListClearRow(itemsGridList)
		for v, item in pairs(g_itemList) do
			if item[4] == (emGUI:dxComboBoxGetSelectedItem(categoryComboBox) - 1) or (emGUI:dxComboBoxGetSelectedItem(categoryComboBox) - 1) == 0 then
				local row = emGUI:dxGridListAddRow(itemsGridList)
				emGUI:dxGridListSetItemText(itemsGridList, row, 1, v)
				emGUI:dxGridListSetItemText(itemsGridList, row, 2, item[2])
				emGUI:dxGridListSetItemText(itemsGridList, row, 3, item[3])
				emGUI:dxGridListSetItemText(itemsGridList, row, 4, "?")
				emGUI:dxGridListSetItemText(itemsGridList, row, 5, categoryTable[item[4]])
			end
		end
	end)

	local thePlayerName = getPlayerName(localPlayer)
	emGUI:dxSetText(spawnToInput, thePlayerName)
	addEventHandler("onDgsTextChange", spawnToInput, updatePlayerFoundLabel)

	addEventHandler("onDgsTextChange", itemSearchInput, function(newText)
		emGUI:dxGridListClearRow(itemsGridList)
		for v, item in pairs(g_itemList) do
			if (item[4] == (emGUI:dxComboBoxGetSelectedItem(categoryComboBox) - 1)) or ((emGUI:dxComboBoxGetSelectedItem(categoryComboBox) - 1) == 0) then
				if tostring(item[2]):lower():find(newText:lower()) or tostring(v):find(newText) then
					local row = emGUI:dxGridListAddRow(itemsGridList)
					emGUI:dxGridListSetItemText(itemsGridList, row, 1, v)
					emGUI:dxGridListSetItemText(itemsGridList, row, 2, item[2])
					emGUI:dxGridListSetItemText(itemsGridList, row, 3, item[3])
					emGUI:dxGridListSetItemText(itemsGridList, row, 4, "?")
					emGUI:dxGridListSetItemText(itemsGridList, row, 5, categoryTable[item[4]])
				end
			end
		end
	end)

	spawnItemButton = emGUI:dxCreateButton(0.75, 0.89, 0.2, 0.07, "SPAWN", true, itemSpawner)
	addEventHandler("onClientDgsDxMouseClick", spawnItemButton, spawnItemButtonClick)

	addEventHandler("ondxGridListSelect", itemsGridList, function(new, old)
		if (new) and (new ~= -1) then
			local selection = emGUI:dxGridListGetSelectedItem(itemsGridList)
			local itemID = emGUI:dxGridListGetItemText(itemsGridList, selection, 1)
			emGUI:dxImageSetImage(itemImage, ":item-system/images/items/" .. itemID .. ".png")
		end
	end)
end
addEvent("item:showItemList", true)
addEventHandler("item:showItemList", root, showItemSpawnerGUI)

-------------------------------------------------------------------------------------------------------------------------
--													FUNCTIONS
-------------------------------------------------------------------------------------------------------------------------

playerFound = localPlayer
function updatePlayerFoundLabel()
	local targetInputValue = emGUI:dxGetText(spawnToInput)
	local targetPlayer, targetPlayerName = exports.global:getPlayerFromPartialNameOrID(targetInputValue, localPlayer)

	if (targetPlayer) then
		local targAccountName = getElementData(targetPlayer, "account:username")
		emGUI:dxSetText(itemFeedbackLabel, "Player " .. targetPlayerName .. " (" .. targAccountName .. ") found!")
		emGUI:dxLabelSetColor(itemFeedbackLabel, 0, 255, 0)
		playerFound = targetPlayer
	else
		emGUI:dxSetText(itemFeedbackLabel, "Player not found, spawning item in your inventory.")
		emGUI:dxLabelSetColor(itemFeedbackLabel, 255, 0, 0)
		playerFound = localPlayer
	end
end

-------------------------------------------------------------------------------------------------------------------------
--													BUTTON CLICK
-------------------------------------------------------------------------------------------------------------------------

function spawnItemButtonClick(button, state)
	if (button == "left") and (state == "down") then
		local selection = emGUI:dxGridListGetSelectedItem(itemsGridList)
		if not (selection) or (selection == -1) then
			emGUI:dxSetText(itemFeedbackLabel, "You didn't select an item!")
			emGUI:dxLabelSetColor(itemFeedbackLabel, 255, 0, 0)
			return false
		end

		local itemID = emGUI:dxGridListGetItemText(itemsGridList, selection, 1)
		local itemValue = emGUI:dxGetText(itemValueInput)
		if string.len(itemValue) < 1 then itemValue = "" end
		triggerServerEvent("item:adminGivePlayerItem", localPlayer, localPlayer, playerFound, tonumber(itemID), itemValue)
		playerFound = localPlayer
		emGUI:dxCloseWindow(itemSpawner)
	end
end
