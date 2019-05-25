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

local RANK_GROUPS = {
	"Player/All",
	"Helper",
	"Trial Administrator",
	"Administrator",
	"Lead Administrator",
	"Manager",
	"Lead Manager",
	"VT Member",
	"VT Leader",
	"MT Member",
	"MT Leader",
	"FT Member",
	"FT Leader",
	"Trial Developer",
	"Developer",
	"Lead Developer",
}

local COMMAND_CATEGORIES = {
	"All",
	"General",
	"Chat",
	"Roleplay",
	"Vehicle",
	"Interior",
	"Faction",
	"Teleporters",
	"Animation",
}

emGUI = exports.emGUI

--[[

NOTE FOR DEVELOPERS:
	This interface is incomplete, the capability to sort by dropdown menu and command searching still needs
	to be implemented. - Skully

]]
function showCommandListGUI(commandListData, isUI)
	if emGUI:dxIsWindowVisible(commandListWindow) then
		emGUI:dxCloseWindow(commandListWindow)
		if isUI ~= "cmdui" then return end
	end

	commandListWindow = emGUI:dxCreateWindow(0.19, 0.19, 0.62, 0.62, "Command List", true, _, _, true)

	emGUI:dxCreateLabel(0.063, 0.04, 0.10, 0.03, "Rank Group:", true, commandListWindow)
	emGUI:dxCreateLabel(0.015, 0.09, 0.10, 0.03, "Command Category:", true, commandListWindow)
	emGUI:dxCreateLabel(0.31, 0.055, 0.10, 0.03, "Search Command", true, commandListWindow)

	-- Rank group dropdown.
	rankGroupCombobox = emGUI:dxCreateComboBox(0.14, 0.035, 0.15, 0.04, true, commandListWindow)
	for i, rankName in ipairs(RANK_GROUPS) do emGUI:dxComboBoxAddItem(rankGroupCombobox, rankName) end
	emGUI:dxComboBoxSetSelectedItem(rankGroupCombobox, 1)

	-- Command group dropdown.
	cmdCategoryCombobox = emGUI:dxCreateComboBox(0.14, 0.09, 0.15, 0.04,true, commandListWindow)
	for i, categoryName in ipairs(COMMAND_CATEGORIES) do emGUI:dxComboBoxAddItem(cmdCategoryCombobox, categoryName) end
	emGUI:dxComboBoxSetSelectedItem(cmdCategoryCombobox, 1)

	commandGridList = emGUI:dxCreateGridList(0.01, 0.16, 0.98, 0.83, true, commandListWindow)
	emGUI:dxGridListAddColumn(commandGridList, "ID", 0)
	emGUI:dxGridListAddColumn(commandGridList, "Command Name", 0.1)
	emGUI:dxGridListAddColumn(commandGridList, "Aliases", 0.15)
	emGUI:dxGridListAddColumn(commandGridList, "Hotkey", 0.06)
	emGUI:dxGridListAddColumn(commandGridList, "Description", 0.69)
	addEventHandler("onClientDgsDxMouseClick", commandGridList, commandGridListSelected)

	for i, commandData in ipairs(commandListData) do
		local row = emGUI:dxGridListAddRow(commandGridList)
		emGUI:dxGridListSetItemText(commandGridList, row, 1, commandData.id)
		emGUI:dxGridListSetItemText(commandGridList, row, 2, commandData.command)
		emGUI:dxGridListSetItemText(commandGridList, row, 3, commandData.aliases)
		emGUI:dxGridListSetItemText(commandGridList, row, 4, commandData.hotkey)
		emGUI:dxGridListSetItemText(commandGridList, row, 5, commandData.description)
	end

	cmdSearchInput = emGUI:dxCreateEdit(0.31, 0.09, 0.18, 0.04, "", true, commandListWindow)
	
	if exports.global:isPlayerManager(localPlayer) or exports.global:isPlayerDeveloper(localPlayer) then
		addCmdButton = emGUI:dxCreateButton(0.69, 0.04, 0.14, 0.10, "Add Command", true, commandListWindow)
		addEventHandler("onClientDgsDxMouseClick", addCmdButton, function(b, c) if (b == "left") and (c == "down") then animateEditor(true, false) end end)

		editCmdButton = emGUI:dxCreateButton(0.53, 0.04, 0.14, 0.10, "Edit Command", true, commandListWindow)
		addEventHandler("onClientDgsDxMouseClick", editCmdButton, function(b, c)
			if (b == "left") and (c == "down") then
				local selected = emGUI:dxGridListGetSelectedItem(commandGridList)
				local cmdID = emGUI:dxGridListGetItemText(commandGridList, selected, 1)
				triggerServerEvent("player:commandlist:getCommandInfo", localPlayer, cmdID)
			end
		end)
		emGUI:dxSetEnabled(editCmdButton, false)
	end

	closeGUIButton = emGUI:dxCreateButton(0.85, 0.04, 0.14, 0.10, "Close", true, commandListWindow)
	addEventHandler("onClientDgsDxMouseClick", closeGUIButton, function(b, c) if (b == "left") and (c == "down") then emGUI:dxCloseWindow(commandListWindow) end end)
end
addEvent("player:showCommandListGUI", true)
addEventHandler("player:showCommandListGUI", root, showCommandListGUI)

function animateEditor(isAnimateIn, isEdit, editCmdData)
	if isAnimateIn then
		emGUI:dxMoveTo(commandListWindow, 0.19, 1, true, false, "OutQuad", 300)
		showAddEditCommandGUI(isEdit, editCmdData)
	else
		emGUI:dxMoveTo(addEditCmdWindow, 0.33, 1, true, false, "OutQuad", 300)
		setTimer(function()
			emGUI:dxCloseWindow(addEditCmdWindow)
			emGUI:dxMoveTo(commandListWindow, 0.19, 0.19, true, false, "OutQuad", 300)
		end, 305, 1)
	end
end
addEvent("player:commandlist:animateEditor", true)
addEventHandler("player:commandlist:animateEditor", root, animateEditor)

function commandGridListSelected()
	if (editCmdButton) and exports.global:isPlayerManager(localPlayer) or exports.global:isPlayerDeveloper(localPlayer) then
		local selected = emGUI:dxGridListGetSelectedItem(commandGridList)
		if (selected) and (selected ~= -1) then
			emGUI:dxSetEnabled(editCmdButton, true)
		else
			emGUI:dxSetEnabled(editCmdButton, false)
		end
	end
end

function showAddEditCommandGUI(isEdit, editCmdData)
	if isEdit and not (type(editCmdData) == "table") then
		outputChatBox("ERROR: Something went wrong whilst trying to edit that command!", 255, 0, 0)
		outputDebugString("@showAddEditCommandGUI: isEdit passed though no command data table received.", 3)
		return
	end

	labels = {}
	checkboxes = {}

	if emGUI:dxIsWindowVisible(addEditCmdWindow) then emGUI:dxCloseWindow(addEditCmdWindow) end
	addEditCmdWindow = emGUI:dxCreateWindow(0.33, 1, 0.35, 0.44, "Add Command", true, _, _, true)

	setTimer(function()
		emGUI:dxMoveTo(addEditCmdWindow, 0.33, 0.3, true, false, "OutQuad", 300)
	end, 305, 1)

	local closeEditAddGUI = emGUI:dxCreateButton(0, -0.057, 0.05, 0.058, "↩️", true, addEditCmdWindow, _, _, _, _, _, _, tocolor(50, 200, 0, 0))
	addEventHandler("onClientDgsDxMouseClick", closeEditAddGUI, function(b, c) if (b == "left") and (c == "down") then animateEditor(false) end end)

	labels[1] = emGUI:dxCreateLabel(0.063, 0.08, 0.09, 0.05, "Command:", true, addEditCmdWindow)
	labels[2] = emGUI:dxCreateLabel(0.063, 0.175, 0.09, 0.05, "Aliases:", true, addEditCmdWindow)
	labels[3] = emGUI:dxCreateLabel(0.063, 0.275, 0.09, 0.05, "Hotkey:", true, addEditCmdWindow)
	labels[4] = emGUI:dxCreateLabel(0.063, 0.365, 0.09, 0.05, "Description:", true, addEditCmdWindow)
	for i, label in ipairs(labels) do emGUI:dxLabelSetHorizontalAlign(label, "right") end
	
	commandNameInput = 		emGUI:dxCreateEdit(0.17, 0.07, 0.43, 0.057, "", true, addEditCmdWindow)
	commandAliasesInput = 	emGUI:dxCreateEdit(0.17, 0.17, 0.43, 0.057, "", true, addEditCmdWindow)
	commandHotkeyInput = 	emGUI:dxCreateEdit(0.17, 0.27, 0.15, 0.057, "", true, addEditCmdWindow)
	commandDescInput = 		emGUI:dxCreateEdit(0.17, 0.363, 0.43, 0.057, "", true, addEditCmdWindow)

	commandCategoryGridlist = emGUI:dxCreateGridList(0.65, 0.07, 0.32, 0.35, true, addEditCmdWindow, true)
	emGUI:dxGridListAddColumn(commandCategoryGridlist, "Category", 1)

	for i, categoryName in ipairs(COMMAND_CATEGORIES) do
		if (i ~= 1) then -- Prevent "all" category appearing.
			local row = emGUI:dxGridListAddRow(commandCategoryGridlist)
			emGUI:dxGridListSetItemText(commandCategoryGridlist, row, 1, categoryName)
		end
	end
	
	checkboxes[1] =  emGUI:dxCreateCheckBox(0.1, 0.47, 0.2, 0.03, RANK_GROUPS[1], false, true, addEditCmdWindow)
	checkboxes[2] =  emGUI:dxCreateCheckBox(0.1, 0.53, 0.2, 0.03, RANK_GROUPS[2], false, true, addEditCmdWindow)
	checkboxes[3] =  emGUI:dxCreateCheckBox(0.1, 0.59, 0.2, 0.03, RANK_GROUPS[3], false, true, addEditCmdWindow)
	checkboxes[4] =  emGUI:dxCreateCheckBox(0.1, 0.65, 0.2, 0.03, RANK_GROUPS[4], false, true, addEditCmdWindow)

	checkboxes[5] =  emGUI:dxCreateCheckBox(0.3, 0.47, 0.2, 0.03, RANK_GROUPS[5], false, true, addEditCmdWindow)
	checkboxes[6] =  emGUI:dxCreateCheckBox(0.3, 0.53, 0.2, 0.03, RANK_GROUPS[6], false, true, addEditCmdWindow)
	checkboxes[7] =  emGUI:dxCreateCheckBox(0.3, 0.59, 0.2, 0.03, RANK_GROUPS[7], false, true, addEditCmdWindow)
	checkboxes[8] =  emGUI:dxCreateCheckBox(0.3, 0.65, 0.2, 0.03, RANK_GROUPS[8], false, true, addEditCmdWindow)

	checkboxes[9] =  emGUI:dxCreateCheckBox(0.5, 0.47, 0.2, 0.03, RANK_GROUPS[9], false, true, addEditCmdWindow)
	checkboxes[10] = emGUI:dxCreateCheckBox(0.5, 0.53, 0.2, 0.03, RANK_GROUPS[10], false, true, addEditCmdWindow)
	checkboxes[11] = emGUI:dxCreateCheckBox(0.5, 0.59, 0.2, 0.03, RANK_GROUPS[11], false, true, addEditCmdWindow)
	checkboxes[12] = emGUI:dxCreateCheckBox(0.5, 0.65, 0.2, 0.03, RANK_GROUPS[12], false, true, addEditCmdWindow)

	checkboxes[13] = emGUI:dxCreateCheckBox(0.69, 0.47, 0.2, 0.03, RANK_GROUPS[13], false, true, addEditCmdWindow)
	checkboxes[14] = emGUI:dxCreateCheckBox(0.69, 0.53, 0.2, 0.03, RANK_GROUPS[14], false, true, addEditCmdWindow)
	checkboxes[15] = emGUI:dxCreateCheckBox(0.69, 0.59, 0.2, 0.03, RANK_GROUPS[15], false, true, addEditCmdWindow)
	checkboxes[16] = emGUI:dxCreateCheckBox(0.69, 0.65, 0.2, 0.03, RANK_GROUPS[16], false, true, addEditCmdWindow)

	allRanksCheckbox = emGUI:dxCreateCheckBox(0.45, 0.72, 0.2, 0.03, "All Ranks", false, true, addEditCmdWindow)
	addEventHandler("onDgsCheckBoxChange", allRanksCheckbox, function(state)
		for i, checkbox in ipairs(checkboxes) do
			emGUI:dxCheckBoxSetSelected(checkbox, state)
			emGUI:dxSetEnabled(checkbox, not state)
		end
	end)

	lastUpdatedLabel = emGUI:dxCreateLabel(0.09, 0.77, 0.81, 0.04, "", true, addEditCmdWindow)
	emGUI:dxLabelSetHorizontalAlign(lastUpdatedLabel, "center")

	if isEdit then
		emGUI:dxSetText(addEditCmdWindow, "Edit Command")
		deleteCmdButton = emGUI:dxCreateButton(0.12, 0.83, 0.31, 0.14, "Delete Command", true, addEditCmdWindow)
		local wantsDeletion = false
		addEventHandler("onClientDgsDxMouseClick", deleteCmdButton, function(b, c)
			if (b == "left") and (c == "down") then
				if (wantsDeletion) then
					triggerServerEvent("player:commandlist:deletecmd", localPlayer, tonumber(editCmdData.id), editCmdData.command)
					emGUI:dxCloseWindow(addEditCmdWindow)
					return
				end
				emGUI:dxSetText(deleteCmdButton, "ARE YOU SURE?")
				emGUI:dxButtonSetColor(deleteCmdButton, tocolor(255, 0, 0), tocolor(230, 0, 0), tocolor(200, 0, 0))
				wantsDeletion = true
				setTimer(function()
					if not emGUI:dxIsWindowVisible(addEditCmdWindow) then return end
					emGUI:dxSetText(deleteCmdButton, "DELETE COMMAND")
					emGUI:dxButtonSetColor(deleteCmdButton)
					wantsDeletion = false
				end, 5000, 1)
			end
		end)

		updateCmdButton = emGUI:dxCreateButton(0.57, 0.83, 0.31, 0.14, "Apply Changes", true, addEditCmdWindow)
		addEventHandler("onClientDgsDxMouseClick", updateCmdButton, function(b, c)
			if (b == "left") and (c == "down") then
				local isValid, cmdName, cmdAliases, cmdHotkey, cmdDescription, selectedCategory, selectionTable = validateCommandData()
				if isValid then
					triggerServerEvent("player:commandlist:editCommand", localPlayer, tonumber(editCmdData.id), cmdName, cmdAliases, cmdHotkey, cmdDescription, selectedCategory, selectionTable)
					emGUI:dxCloseWindow(addEditCmdWindow)
				end
			end
		end)

		-- Set input fields text.
		emGUI:dxSetText(commandNameInput, editCmdData.command)
		emGUI:dxSetText(commandAliasesInput, editCmdData.aliases)
		emGUI:dxSetText(commandHotkeyInput, editCmdData.hotkey)
		emGUI:dxSetText(commandDescInput, editCmdData.description)

		-- Set category selection.
		emGUI:dxGridListSetSelectedItem(commandCategoryGridlist, editCmdData.category)

		-- Set checkbox selections.
		if tonumber(editCmdData.permission_groups) and (tonumber(editCmdData.permission_groups) == 0) then
			for i, checkbox in ipairs(checkboxes) do
				emGUI:dxCheckBoxSetSelected(checkbox, true)
				emGUI:dxSetEnabled(checkbox, false)
			end
			emGUI:dxCheckBoxSetSelected(allRanksCheckbox, true)
		else
			local selectionTable = split(editCmdData.permission_groups, ",")
			for i, selectedCategory in pairs(selectionTable) do
				emGUI:dxCheckBoxSetSelected(checkboxes[tonumber(selectedCategory)], true)
			end
		end

		local parsedTime = exports.global:convertTime(editCmdData.last_updated)

		emGUI:dxSetText(lastUpdatedLabel, "Last updated on " .. parsedTime[2] .. " at " .. parsedTime[1] .. " by " .. tostring(editCmdData.updated_by) .. ".")
	else
		addNewCmdButton = emGUI:dxCreateButton(0.35, 0.83, 0.31, 0.14, "Add Command", true, addEditCmdWindow)
		addEventHandler("onClientDgsDxMouseClick", addNewCmdButton, addNewCmdButtonClick)
	end
end
addEvent("player:showAddEditCommandGUI", true)
addEventHandler("player:showAddEditCommandGUI", root, showAddEditCommandGUI)

function setFeedbackLabel(text, r, g, b)
	if not (r) or not (g) or not (b) then r, g, b = 255, 0, 0 end
	emGUI:dxLabelSetColor(lastUpdatedLabel, r, g, b)
	emGUI:dxSetText(lastUpdatedLabel, text)
end

function validateCommandData()
	local cmdName = emGUI:dxGetText(commandNameInput)
	local cmdAliases = emGUI:dxGetText(commandAliasesInput)
	local cmdHotkey = emGUI:dxGetText(commandHotkeyInput)
	local cmdDescription = emGUI:dxGetText(commandDescInput)

	-- Validate command name.
	if (string.len(cmdName) <= 0) then
		setFeedbackLabel("Input a valid command!")
		emGUI:dxLabelSetColor(labels[1], 255, 0, 0)
		return false
	end

	-- Validate alias.
	if (string.len(cmdAliases) > 30) then
		setFeedbackLabel("Alias is too long!")
		emGUI:dxLabelSetColor(labels[2], 255, 0, 0)
		return false
	elseif (string.len(cmdAliases) <= 0) then
		cmdAliases = "None"
	end

	-- Validate hotkey.
	if (string.len(cmdHotkey) > 10) then
		setFeedbackLabel("Hotkey is too long!")
		emGUI:dxLabelSetColor(labels[3], 255, 0, 0)
		return false
	elseif (string.len(cmdHotkey) <= 0) then
		cmdHotkey = "N/A"
	end

	-- Validate description.
	if (string.len(cmdDescription) > 200) then
		setFeedbackLabel("Description is too long!")
		emGUI:dxLabelSetColor(labels[4], 255, 0, 0)
		return false
	end

	-- Validate category selection.
	local selectedCategory = emGUI:dxGridListGetSelectedItem(commandCategoryGridlist)
	if not (selectedCategory) or (selectedCategory == -1) then
		setFeedbackLabel("Select a category!")
		return false
	end

	-- Validate rank group selections.
	local selectionTable = ""
	if emGUI:dxCheckBoxGetSelected(allRanksCheckbox) then
		selectionTable = "0"
	else
		for i, checkbox in ipairs(checkboxes) do
			if emGUI:dxCheckBoxGetSelected(checkbox) then
				selectionTable = selectionTable .. i .. ","
			end
		end
	end

	if (string.len(selectionTable) <= 0) then
		setFeedbackLabel("Select permitted rank groups!")
		return false
	end

	return true, cmdName, cmdAliases, cmdHotkey, cmdDescription, selectedCategory, selectionTable
end

function addNewCmdButtonClick(b, c)
	if (b == "left") and (c == "down") then	
		local isValid, cmdName, cmdAliases, cmdHotkey, cmdDescription, selectedCategory, selectionTable = validateCommandData()
		if isValid then
			triggerServerEvent("player:addNewCommand", localPlayer, cmdName, cmdAliases, cmdHotkey, cmdDescription, selectedCategory, selectionTable)
			emGUI:dxCloseWindow(addEditCmdWindow)
		end
	end
end