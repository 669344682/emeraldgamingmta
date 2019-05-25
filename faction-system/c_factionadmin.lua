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

-- /createfaction - By Skully (30/06/18) [Manager/FT Leader]
function showFactionCreator()
	if exports.global:isPlayerManager(localPlayer) or exports.global:isPlayerFactionTeamLeader(localPlayer) then
		if emGUI:dxIsWindowVisible(createFactionGUI) then emGUI:dxCloseWindow(createFactionGUI) return end
		createFactionGUI = emGUI:dxCreateWindow(0.36, 0.28, 0.27, 0.40, "Create New Faction", true)

		emGUI:dxCreateLabel(0.04, 0.09, 0.16, 0.04, "Faction Name", true, createFactionGUI)
		emGUI:dxCreateLabel(0.69, 0.09, 0.22, 0.04, "Abbreviation", true, createFactionGUI)
		emGUI:dxCreateLabel(0.69, 0.255, 0.22, 0.04, "Vehicle Slots", true, createFactionGUI)
		emGUI:dxCreateLabel(0.69, 0.4, 0.22, 0.04, "Interior Slots", true, createFactionGUI)
		emGUI:dxCreateLabel(0.69, 0.55, 0.22, 0.04, "Faction Phone #", true, createFactionGUI)
		
		feedbackLabel = emGUI:dxCreateLabel(0.14, 0.72, 0.69, 0.04, "", true, createFactionGUI)
		emGUI:dxLabelSetColor(feedbackLabel, 255, 0, 0)
		emGUI:dxLabelSetHorizontalAlign(feedbackLabel, "center")
		
		factionNameInput = emGUI:dxCreateEdit(0.04, 0.15, 0.62, 0.06, "", true, createFactionGUI)
		factionAbbrInput = emGUI:dxCreateEdit(0.69, 0.15, 0.22, 0.06, "", true, createFactionGUI)
		facMaxVehiclesInput = emGUI:dxCreateEdit(0.69, 0.31, 0.22, 0.06, "", true, createFactionGUI)
		facMaxIntInput = emGUI:dxCreateEdit(0.69, 0.46, 0.22, 0.06, "", true, createFactionGUI)
		facPhoneInput = emGUI:dxCreateEdit(0.69, 0.605, 0.22, 0.06, "", true, createFactionGUI)
		emGUI:dxSetEnabled(facPhoneInput, false)

		emGUI:dxEditSetMaxLength(factionNameInput, 50)
		emGUI:dxEditSetMaxLength(factionAbbrInput, 5)
		emGUI:dxEditSetMaxLength(facMaxVehiclesInput, 4)
		emGUI:dxEditSetMaxLength(facMaxIntInput, 4)
		emGUI:dxEditSetMaxLength(facPhoneInput, 6)
		
		facPhoneCheckbox = emGUI:dxCreateCheckBox(0.92, 0.62, 0.03, 0.03, "", false, true, createFactionGUI)
		addEventHandler("onDgsCheckBoxChange", facPhoneCheckbox, function(c) emGUI:dxSetEnabled(facPhoneInput, c) end)
		
		factionTypesGridlist = emGUI:dxCreateGridList(0.04, 0.26, 0.62, 0.41, true, createFactionGUI, true)
		emGUI:dxGridListAddColumn(factionTypesGridlist, "ID", 0.14)
		emGUI:dxGridListAddColumn(factionTypesGridlist, "Type", 0.6)
		
		for i, facType in ipairs(g_factionTypes) do
			local row = emGUI:dxGridListAddRow(factionTypesGridlist)
			emGUI:dxGridListSetItemText(factionTypesGridlist, row, 1, i)
			emGUI:dxGridListSetItemText(factionTypesGridlist, row, 2, facType[1])
		end

		facCancelButton = emGUI:dxCreateButton(0.09, 0.79, 0.34, 0.16, "Cancel", true, createFactionGUI)
		addEventHandler("onClientDgsDxMouseClick", facCancelButton, function() emGUI:dxCloseWindow(createFactionGUI) end)
		
		createFacButton = emGUI:dxCreateButton(0.57, 0.79, 0.34, 0.16, "Create Faction", true, createFactionGUI)
		addEventHandler("onClientDgsDxMouseClick", createFacButton, function(b, c)
			if (b == "left") and (c == "down") then
				local factionType = emGUI:dxGridListGetSelectedItem(factionTypesGridlist)
				local factionName = emGUI:dxGetText(factionNameInput)
				local factionAbbr = emGUI:dxGetText(factionAbbrInput)
				local vehicleSlots = emGUI:dxGetText(facMaxVehiclesInput)
				local interiorSlots = emGUI:dxGetText(facMaxIntInput)
				local facPhoneEnabled = emGUI:dxCheckBoxGetSelected(facPhoneCheckbox)
				local factionPhone = emGUI:dxGetText(facMaxIntInput)
				if not facPhoneEnabled then factionPhone = false end

				local validated, reason = handleInputValidation(factionType, factionName, factionAbbr, vehicleSlots, interiorSlots, facPhoneEnabled, factionPhone)
				if not validated then
					emGUI:dxSetText(feedbackLabel, reason)
				else
					triggerServerEvent("faction:createFaction", localPlayer, localPlayer, factionName, factionAbbr, factionType, vehicleSlots, interiorSlots, factionPhone)
					emGUI:dxCloseWindow(createFactionGUI)
				end
			end
		end)
	end
end
addEvent("faction:showFactionCreator", true)
addEventHandler("faction:showFactionCreator", root, showFactionCreator)
addCommandHandler("createfaction", showFactionCreator)

function handleInputValidation(factionType, factionName, factionAbbr, vehicleSlots, interiorSlots, facPhoneEnabled, factionPhone)
	if not factionType or factionType == -1 then
		return false, "Please select a faction type!"
	end

	if (#factionName <= 3) then
		return false, "Faction name must be greater than 3 characters!"
	end

	if (#factionAbbr < 2) then
		return false, "Faction abbreviation must be between 2 and 5 characters!"
	end

	if not tonumber(vehicleSlots) then
		return false, "That is not a valid vehicle slot amount!"
	end

	if not tonumber(interiorSlots) then
		return false, "That is not a valid interior slot amount!"
	end

	if facPhoneEnabled then
		if not tonumber(factionPhone) then
			return false, "That is not a valid phone number!"
		elseif (#factionPhone ~= 0) and #factionPhone < 3 then
			return false, "Faction phone number must be between 3 and 6 digits!"
		end
	end
	
	return true
end

---------------------------------------------------------------------------------------------------------------------

function showFactionListGUI(factionData, vehicleCountData, interiorCountData, factionMemberData)
	if emGUI:dxIsWindowVisible(factionMenuWindow) then emGUI:dxCloseWindow(factionMenuWindow) return end
	if not factionData or not vehicleCountData or not interiorCountData or not factionMemberData then outputChatBox("ERROR: Failed to fetch faction data.", 255, 0, 0) return false end

	local canEdit = exports.global:isPlayerManager(localPlayer) or exports.global:isPlayerFactionTeamLeader(localPlayer)
	if canEdit then
		factionMenuWindow = emGUI:dxCreateWindow(0.21, 0.21, 0.58, 0.57, "Server Factions", true)
		allFactionsGridlist = emGUI:dxCreateGridList(0.01, 0.02, 0.98, 0.8, true, factionMenuWindow, true)
	else
		factionMenuWindow = emGUI:dxCreateWindow(0.21, 0.21, 0.58, 0.48, "Server Factions", true, _, _, _, _, _, _, _, _, tocolor(0,0,0,150))
		allFactionsGridlist = emGUI:dxCreateGridList(0, 0, 1, 1, true, factionMenuWindow, true)
	end
	emGUI:dxGridListAddColumn(allFactionsGridlist, "ID", 0.04)
	emGUI:dxGridListAddColumn(allFactionsGridlist, "Name", 0.35)
	emGUI:dxGridListAddColumn(allFactionsGridlist, "Abbreviation", 0.1)
	emGUI:dxGridListAddColumn(allFactionsGridlist, "Type", 0.13)
	emGUI:dxGridListAddColumn(allFactionsGridlist, "Vehicle Slots", 0.09)
	emGUI:dxGridListAddColumn(allFactionsGridlist, "Interior Slots", 0.09)
	emGUI:dxGridListAddColumn(allFactionsGridlist, "Members", 0.2)

	for i, faction in ipairs(factionData) do
		local row = emGUI:dxGridListAddRow(allFactionsGridlist)
		emGUI:dxGridListSetItemText(allFactionsGridlist, row, 1, faction.id)
		emGUI:dxGridListSetItemText(allFactionsGridlist, row, 2, faction.name)
		emGUI:dxGridListSetItemText(allFactionsGridlist, row, 3, faction.abbreviation)
		local factionType = g_factionTypes[faction.type][1]
		emGUI:dxGridListSetItemText(allFactionsGridlist, row, 4, factionType)
		emGUI:dxGridListSetItemText(allFactionsGridlist, row, 5, vehicleCountData[faction.id] .. "/" .. faction.max_vehicles)
		emGUI:dxGridListSetItemText(allFactionsGridlist, row, 6, interiorCountData[faction.id] .. "/" .. faction.max_interiors)
		local activeMembers = 0
		local onDutyCount = 0
		local theFaction = getTeamFromName(faction.name)
		if theFaction then
			local factionMembers = getPlayersInTeam(theFaction)
			activeMembers = #factionMembers

			for i, player in ipairs(factionMembers) do
				local onDuty = getElementData(player, "character:factionduty") == faction.id
				if onDuty then onDutyCount = onDutyCount + 1 end
			end
		end
		local memberCountParsed = factionMemberData[faction.id]; if memberCountParsed == 1 then memberCountParsed = memberCountParsed .. " Member" else memberCountParsed = memberCountParsed .. " Members" end
		emGUI:dxGridListSetItemText(allFactionsGridlist, row, 7, memberCountParsed .. " (" .. activeMembers .. " Active, " .. onDutyCount .. " On Duty)")
	end

	if canEdit then
		editFactionButton = emGUI:dxCreateButton(0.2, 0.84, 0.18, 0.13, "Edit Faction", true, factionMenuWindow)
		emGUI:dxSetEnabled(editFactionButton, false)
		addEventHandler("onClientDgsDxMouseClick", editFactionButton, function(b, c)
			if (b == "left") and (c == "down") then
				local s = emGUI:dxGridListGetSelectedItem(allFactionsGridlist)
				local factionID = emGUI:dxGridListGetItemText(allFactionsGridlist, s, 1)
				emGUI:dxCloseWindow(factionMenuWindow)
				triggerServerEvent("faction:gui:editFactionCall", localPlayer, factionID)
			end
		end)

		local factionItemManagerButton = emGUI:dxCreateButton(0.41, 0.84, 0.18, 0.13, "Faction Assets", true, factionMenuWindow)
		emGUI:dxSetEnabled(factionItemManagerButton, false)
		addEventHandler("onClientDgsDxMouseClick", factionItemManagerButton, function(b, c)
			if (b == "left") and (c == "down") then
				emGUI:dxMoveTo(factionMenuWindow, 0.21, 1, true, false, "OutQuad", 250)
				setTimer(function()
					local s = emGUI:dxGridListGetSelectedItem(allFactionsGridlist)
					local factionID = emGUI:dxGridListGetItemText(allFactionsGridlist, s, 1)
					triggerServerEvent("faction:gui:showFactionAssetManagerCall", localPlayer, factionID)
				end, 300, 1)
			end
		end)

		local delFactionButton = emGUI:dxCreateButton(0.62, 0.84, 0.18, 0.13, "Delete Faction", true, factionMenuWindow)
		emGUI:dxSetEnabled(delFactionButton, false)
		addEventHandler("onClientDgsDxMouseClick", delFactionButton, function(b, c)
			if (b == "left") and (c == "down") then
				local s = emGUI:dxGridListGetSelectedItem(allFactionsGridlist)
				local factionID = emGUI:dxGridListGetItemText(allFactionsGridlist, s, 1)
				emGUI:dxCloseWindow(factionMenuWindow)
				triggerServerEvent("faction:deletefactioncall", localPlayer, localPlayer, "deletefaction", factionID)
			end
		end)
		addEventHandler("ondxGridListSelect", allFactionsGridlist, function(c)
			emGUI:dxSetEnabled(editFactionButton, c ~= -1)
			emGUI:dxSetEnabled(factionItemManagerButton, c ~= -1)
			emGUI:dxSetEnabled(delFactionButton, c ~= -1)
		end)
	end
end
addEvent("faction:showFactionListGUI", true)
addEventHandler("faction:showFactionListGUI", root, showFactionListGUI)

---------------------------------------------------------------------------------------------------------------------

function showFactionEditor(factionData)
	if exports.global:isPlayerManager(localPlayer) or exports.global:isPlayerFactionTeamLeader(localPlayer) then
		if not factionData then outputChatBox("ERROR: Failed to fetch faction data.", 255, 0, 0) return end
		if emGUI:dxIsWindowVisible(editFactionGUI) then emGUI:dxCloseWindow(editFactionGUI) return end
		if emGUI:dxIsWindowVisible(editFactionGUI) then emGUI:dxCloseWindow(editFactionGUI) end

		editFactionGUI = emGUI:dxCreateWindow(0.36, 0.28, 0.27, 0.40, "Editing Faction: " .. factionData.name, true)

		emGUI:dxCreateLabel(0.04, 0.09, 0.16, 0.04, "Faction Name", true, editFactionGUI)
		emGUI:dxCreateLabel(0.69, 0.09, 0.22, 0.04, "Abbreviation", true, editFactionGUI)
		emGUI:dxCreateLabel(0.69, 0.255, 0.22, 0.04, "Vehicle Slots", true, editFactionGUI)
		emGUI:dxCreateLabel(0.69, 0.4, 0.22, 0.04, "Interior Slots", true, editFactionGUI)
		emGUI:dxCreateLabel(0.69, 0.55, 0.22, 0.04, "Faction Phone #", true, editFactionGUI)
		
		local feedbackLabel = emGUI:dxCreateLabel(0.14, 0.72, 0.69, 0.04, "", true, editFactionGUI)
		emGUI:dxLabelSetColor(feedbackLabel, 255, 0, 0)
		emGUI:dxLabelSetHorizontalAlign(feedbackLabel, "center")
		
		local factionNameInput = emGUI:dxCreateEdit(0.04, 0.15, 0.62, 0.06, factionData.name, true, editFactionGUI)
		local factionAbbrInput = emGUI:dxCreateEdit(0.69, 0.15, 0.22, 0.06, factionData.abbreviation, true, editFactionGUI)
		local facMaxVehiclesInput = emGUI:dxCreateEdit(0.69, 0.31, 0.22, 0.06, factionData.max_vehicles, true, editFactionGUI)
		local facMaxIntInput = emGUI:dxCreateEdit(0.69, 0.46, 0.22, 0.06, factionData.max_interiors, true, editFactionGUI)
		local hasPhone = factionData.phone ~= 0
		local facPhoneInput = emGUI:dxCreateEdit(0.69, 0.605, 0.22, 0.06, "", true, editFactionGUI)
		if hasPhone then emGUI:dxSetText(facPhoneInput, factionData.phone) end
		emGUI:dxSetEnabled(facPhoneInput, hasPhone)

		emGUI:dxEditSetMaxLength(factionNameInput, 50)
		emGUI:dxEditSetMaxLength(factionAbbrInput, 5)
		emGUI:dxEditSetMaxLength(facMaxVehiclesInput, 4)
		emGUI:dxEditSetMaxLength(facMaxIntInput, 4)
		emGUI:dxEditSetMaxLength(facPhoneInput, 6)
		
		local facPhoneCheckbox = emGUI:dxCreateCheckBox(0.92, 0.62, 0.03, 0.03, "", hasPhone, true, editFactionGUI)
		addEventHandler("onDgsCheckBoxChange", facPhoneCheckbox, function(c) emGUI:dxSetEnabled(facPhoneInput, c) end)
		
		local factionTypesGridlist = emGUI:dxCreateGridList(0.04, 0.26, 0.62, 0.41, true, editFactionGUI, true)
		emGUI:dxGridListAddColumn(factionTypesGridlist, "ID", 0.14)
		emGUI:dxGridListAddColumn(factionTypesGridlist, "Type", 0.6)
		
		for i, facType in ipairs(g_factionTypes) do
			local row = emGUI:dxGridListAddRow(factionTypesGridlist)
			emGUI:dxGridListSetItemText(factionTypesGridlist, row, 1, i)
			emGUI:dxGridListSetItemText(factionTypesGridlist, row, 2, facType[1])
		end
		emGUI:dxGridListSetSelectedItem(factionTypesGridlist, factionData.type)

		local discardChangesButton = emGUI:dxCreateButton(0.03, 0.79, 0.34, 0.16, "Discard Changes", true, editFactionGUI)
		addEventHandler("onClientDgsDxMouseClick", discardChangesButton, function(b, c) if (b == "left") and (c == "down") then emGUI:dxCloseWindow(editFactionGUI) end end)
		
		local saveChangesButton = emGUI:dxCreateButton(0.63, 0.79, 0.34, 0.16, "Save Changes", true, editFactionGUI)
		addEventHandler("onClientDgsDxMouseClick", saveChangesButton, function(b, c)
			if (b == "left") and (c == "down") then
				local factionType = emGUI:dxGridListGetSelectedItem(factionTypesGridlist)
				local factionName = emGUI:dxGetText(factionNameInput)
				local factionAbbr = emGUI:dxGetText(factionAbbrInput)
				local vehicleSlots = emGUI:dxGetText(facMaxVehiclesInput)
				local interiorSlots = emGUI:dxGetText(facMaxIntInput)
				local facPhoneEnabled = emGUI:dxCheckBoxGetSelected(facPhoneCheckbox)
				local factionPhone = emGUI:dxGetText(facPhoneInput)
				if not facPhoneEnabled then factionPhone = false end

				local validated, reason = handleInputValidation(factionType, factionName, factionAbbr, vehicleSlots, interiorSlots, facPhoneEnabled, factionPhone)
				if not validated then
					emGUI:dxSetText(feedbackLabel, reason)
				else
					triggerServerEvent("faction:gui:updateFactionInfoCall", localPlayer, factionData.id, factionType, factionName, factionAbbr, vehicleSlots, interiorSlots, factionPhone)
					emGUI:dxCloseWindow(editFactionGUI)
				end
			end
		end)
	end
end
addEvent("faction:showFactionEditor", true)
addEventHandler("faction:showFactionEditor", root, showFactionEditor)

function showFactionAssetManager(factionID, assetData)
	local itemData = assetData.item_table; itemData = fromJSON(itemData) or {}
	local skinData = assetData.skin_table; skinData = fromJSON(skinData) or {}

	existingItems = {}
	existingSkins = {}

	factionAssetEditorWindow = emGUI:dxCreateWindow(0.18, 1, 0.64, 0.39, "Faction Asset Manager", true, true, _, true)
	emGUI:dxMoveTo(factionAssetEditorWindow, 0.18, 0.31, true, false, "OutQuad", 250)

	allItemsGridlist = emGUI:dxCreateGridList(0.01, 0.02, 0.25, 0.96, true, factionAssetEditorWindow, true)
	emGUI:dxGridListAddColumn(allItemsGridlist, "ID", 0.09)
	emGUI:dxGridListAddColumn(allItemsGridlist, "Available Items", 0.9)

	factionItemsGridlist = emGUI:dxCreateGridList(0.34, 0.02, 0.25, 0.96, true, factionAssetEditorWindow, true)
	emGUI:dxGridListAddColumn(factionItemsGridlist, "ID", 0.09)
	emGUI:dxGridListAddColumn(factionItemsGridlist, "Faction Items", 0.9)

	addFacItemButton = emGUI:dxCreateButton(0.275, 0.37, 0.05, 0.10, "⏩", true, factionAssetEditorWindow)
	addEventHandler("onClientDgsDxMouseClick", addFacItemButton, handleFacItemsAssets)
	removeFacItemButton = emGUI:dxCreateButton(0.275, 0.52, 0.05, 0.10, "⏪", true, factionAssetEditorWindow)
	addEventHandler("onClientDgsDxMouseClick", removeFacItemButton, handleFacItemsAssets)
	emGUI:dxSetEnabled(addFacItemButton, false)
	emGUI:dxSetEnabled(removeFacItemButton, false)

	local skinIDLabel = emGUI:dxCreateLabel(0.6, 0.035, 0.06, 0.02, "Add Skin ID:", true, factionAssetEditorWindow)
	local skinIDInput = emGUI:dxCreateEdit(0.67, 0.03, 0.06, 0.06, "", true, factionAssetEditorWindow)

	factionSkinsGridlist = emGUI:dxCreateGridList(0.60, 0.11, 0.22, 0.87, true, factionAssetEditorWindow, true)
	emGUI:dxGridListAddColumn(factionSkinsGridlist, "Available Skins", 1)

	local insertSkinButton = emGUI:dxCreateButton(0.74, 0.03, 0.06, 0.06, "Insert", true, factionAssetEditorWindow)
	addEventHandler("onClientDgsDxMouseClick", insertSkinButton, function(b, c)
		if (b == "left") and (c == "down") then
			local skinID = emGUI:dxGetText(skinIDInput) or -1; skinID = tonumber(skinID)
			if not tonumber(skinID) then emGUI:dxLabelSetColor(skinIDLabel, 255, 0, 0) return end
			if not exports.global:isValidSkin(skinID) then
				emGUI:dxLabelSetColor(skinIDLabel, 255, 0, 0)
				emGUI:dxSetText(skinIDLabel, "Invalid ID!")
				setTimer(function()
					if emGUI:dxIsWindowVisible(factionAssetEditorWindow) then
						emGUI:dxLabelSetColor(skinIDLabel, 255, 255, 255)
						emGUI:dxSetText(skinIDLabel, "Add Skin ID:")
					end
				end, 3000, 1)
				return
			end

			if existingSkins[skinID] then return end
			local row = emGUI:dxGridListAddRow(factionSkinsGridlist)
			emGUI:dxGridListSetItemText(factionSkinsGridlist, row, 1, skinID)
			existingSkins[skinID] = skinID
		end
	end)

	local removeSkinButton = emGUI:dxCreateButton(0.835, 0.11, 0.15, 0.18, "Remove Skin", true, factionAssetEditorWindow)
	emGUI:dxSetEnabled(removeSkinButton, false)
	addEventHandler("onClientDgsDxMouseClick", removeSkinButton, function(b, c)
		if (b == "left") and (c == "down") then
			local s = emGUI:dxGridListGetSelectedItem(factionSkinsGridlist)
			local skinID = emGUI:dxGridListGetItemText(factionSkinsGridlist, s, 1)
			emGUI:dxGridListRemoveRow(factionSkinsGridlist, s)
			existingSkins[tonumber(skinID)] = nil
		end
	end)

	local discardFacChangesButton = emGUI:dxCreateButton(0.835, 0.58, 0.15, 0.18, "Discard Changes", true, factionAssetEditorWindow)
	addEventHandler("onClientDgsDxMouseClick", discardFacChangesButton, function(b, c)
		if (b == "left") and (c == "down") then
			emGUI:dxMoveTo(factionAssetEditorWindow, 0.18, 1, true, false, "OutQuad", 250)
			setTimer(function()
				emGUI:dxCloseWindow(factionAssetEditorWindow)
				emGUI:dxMoveTo(factionMenuWindow, 0.21, 0.21, true, false, "OutQuad", 250)
			end, 300, 1)
		end
	end)

	local saveItemChangesButton = emGUI:dxCreateButton(0.835, 0.79, 0.15, 0.18, "Save Changes", true, factionAssetEditorWindow)
	addEventHandler("onClientDgsDxMouseClick", saveItemChangesButton, function(b, c)
		if (b == "left") and (c == "down") then
			local parsedItems = {}
			local parsedSkins = {}
			for i, item in pairs(existingItems) do table.insert(parsedItems, item) end
			for i, skin in pairs(existingSkins) do table.insert(parsedSkins, skin) end
			parsedItems = toJSON(parsedItems)
			parsedSkins = toJSON(parsedSkins)

			triggerServerEvent("faction:gui:saveFactionAssets", localPlayer, factionID, parsedItems, parsedSkins)
			emGUI:dxMoveTo(factionAssetEditorWindow, 0.18, 1, true, false, "OutQuad", 250)
			setTimer(function()
				emGUI:dxCloseWindow(factionAssetEditorWindow)
				emGUI:dxMoveTo(factionMenuWindow, 0.21, 0.21, true, false, "OutQuad", 250)
			end, 300, 1)
		end
	end)

	local itemTable = exports["item-system"]:getItemTable()
	for i, item in pairs(itemTable) do
		local row = emGUI:dxGridListAddRow(allItemsGridlist)
		emGUI:dxGridListSetItemText(allItemsGridlist, row, 1, i)
		emGUI:dxGridListSetItemText(allItemsGridlist, row, 2, item[2])
	end

	for i, itemID in pairs(itemData) do
		local row = emGUI:dxGridListAddRow(factionItemsGridlist)
		emGUI:dxGridListSetItemText(factionItemsGridlist, row, 1, itemID)
		emGUI:dxGridListSetItemText(factionItemsGridlist, row, 2, itemTable[itemID][2])
		existingItems[tonumber(itemID)] = tonumber(itemID)
	end

	for i, skinID in pairs(skinData) do
		local row = emGUI:dxGridListAddRow(factionSkinsGridlist)
		emGUI:dxGridListSetItemText(factionSkinsGridlist, row, 1, skinID)
		existingSkins[tonumber(skinID)] = tonumber(skinID)
	end

	addEventHandler("ondxGridListSelect", allItemsGridlist, function(c) emGUI:dxSetEnabled(addFacItemButton, c ~= -1) end)
	addEventHandler("ondxGridListSelect", factionItemsGridlist, function(c) emGUI:dxSetEnabled(removeFacItemButton, c ~= -1) end)
	addEventHandler("ondxGridListSelect", factionSkinsGridlist, function(c) emGUI:dxSetEnabled(removeSkinButton, c ~= -1) end)
end
addEvent("faction:gui:showFactionAssetManager", true)
addEventHandler("faction:gui:showFactionAssetManager", root, showFactionAssetManager)

function handleFacItemsAssets(b, c)
	if (b == "left") and (c == "down") then
		if (source == addFacItemButton) then
			local s = emGUI:dxGridListGetSelectedItem(allItemsGridlist)
			local itemID = emGUI:dxGridListGetItemText(allItemsGridlist, s, 1); itemID = tonumber(itemID)
			if not existingItems[itemID] then
				local itemName = emGUI:dxGridListGetItemText(allItemsGridlist, s, 2)

				local row = emGUI:dxGridListAddRow(factionItemsGridlist)
				emGUI:dxGridListSetItemText(factionItemsGridlist, row, 1, itemID)
				emGUI:dxGridListSetItemText(factionItemsGridlist, row, 2, itemName)
				existingItems[itemID] = itemID
			end
		elseif (source == removeFacItemButton) then
			local s = emGUI:dxGridListGetSelectedItem(factionItemsGridlist)
			local itemID = emGUI:dxGridListGetItemText(factionItemsGridlist, s, 1)

			emGUI:dxGridListRemoveRow(factionItemsGridlist, s)
			existingItems[tonumber(itemID)] = nil
		end
	end
end