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
	local selectedCategory = emGUI:dxComboBoxGetSelectedItem(categoryCombobox) + 1
	local selectedSize = emGUI:dxComboBoxGetSelectedItem(sizeCombobox) + 1

	outputDebugString("[Selected] Category: " .. selectedCategory .. " / Size: " .. selectedSize, 3)
	emGUI:dxGridListClearRow(interiorsGridList)
	
	for i, interior in ipairs(g_interiors) do
		local intCategory = interior[3]
		local intSize = interior[4]
		if (selectedCategory == 0) or (g_interiorTypes[intCategory][2] == selectedCategory) then
			if (selectedSize == 0) or (g_interiorSizes[intSize][2] == selectedSize) then
				local row = emGUI:dxGridListAddRow(interiorsGridList, i)
				emGUI:dxGridListSetItemText(interiorsGridList, row, 1, i)
				emGUI:dxGridListSetItemText(interiorsGridList, row, 2, interior[1])
				emGUI:dxGridListSetItemText(interiorsGridList, row, 3, g_interiorTypes[intCategory][1])
				emGUI:dxGridListSetItemText(interiorsGridList, row, 4, g_interiorSizes[intSize][1])
				emGUI:dxGridListSetItemText(interiorsGridList, row, 5, interior[5])
			end
		end
	end
end