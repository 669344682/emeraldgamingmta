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
local selectAll = true

local typesTable = {
	[1] = "Admin Command",
	[2] = "Vehicle Related",
	[3] = "Interior Related",
	[4] = "Ped Related",
	[5] = "Faction Related",
	[6] = "Item Movement",
	[7] = "Cash Transfers",
	[8] = "Emeralds",
	[9] = "Connections",
	[10] = "Phone Logs",
	[11] = "SMS Logs",
	[12] = "Vehicle/Int Actions",
	[13] = "Stat Transfers",
	[14] = "Kill/Death Logs & Lost Items",
	[15] = "Reports",
	[16] = "Punishments/Warns",
	[17] = "Errors",
	[18] = "VT Related",
	[19] = "MT Related",
	[20] = "FT Related",
	[21] = "/c & /w",
	[22] = "/say",
	[23] = "/b",
	[24] = "/me",
	[25] = "/do",
	[26] = "/ame",
	[27] = "/ado",
	[28] = "/pm",
	[29] = "/s",
	[30] = "/h",
	[31] = "/st",
	[32] = "/mt",
	[33] = "/vt",
	[34] = "/ft",
	[35] = "/d",
	[36] = "/a",
	[37] = "/l",
	[38] = "/r",
	[39] = "/f",
	[40] = "/m",
	[41] = "/district",
	[42] = "/status",
	[43] = "Anticheat",
	[44] = "Asset Transfers",
	[45] = "Teleporter Usage",
	[46] = "/fl",
	[47] = "Undefined",
	[48] = "Undefined",
	[49] = "Undefined",
	[50] = "Undefined",
}

function showLogsGUI()
	if exports.global:isPlayerLeadManager(localPlayer) then
		if emGUI:dxIsWindowVisible(logViewerWindow) then emGUI:dxCLoseWindow(logViewerWindow) return end
		selectAll = true
		checkboxes = {}
		logViewerWindow = emGUI:dxCreateWindow(0.16, 0.20, 0.68, 0.69, "Log Viewer", true)

		logsGridList = emGUI:dxCreateGridList(0.01, 0.33, 0.98, 0.66, true, logViewerWindow)
		emGUI:dxGridListAddColumn(logsGridList, "ID", 0.04)
		emGUI:dxGridListAddColumn(logsGridList, "Time", 0.12)
		emGUI:dxGridListAddColumn(logsGridList, "Source", 0.1)
		emGUI:dxGridListAddColumn(logsGridList, "Type", 0.1)
		emGUI:dxGridListAddColumn(logsGridList, "Effected", 0.1)
		emGUI:dxGridListAddColumn(logsGridList, "Log", 0.54)
		
		emGUI:dxGridListAddRow(logsGridList)
		emGUI:dxGridListSetItemText(logsGridList, 1, 1, "-")
		emGUI:dxGridListSetItemText(logsGridList, 1, 2, "-")
		emGUI:dxGridListSetItemText(logsGridList, 1, 3, "-")
		emGUI:dxGridListSetItemText(logsGridList, 1, 4, "-")
		emGUI:dxGridListSetItemText(logsGridList, 1, 5, "-")
		emGUI:dxGridListSetItemText(logsGridList, 1, 6, "-")

		checkboxes[1] = emGUI:dxCreateCheckBox(0.02, 0.02, 0.10, 0.02, "Admin Command", false, true, logViewerWindow)
		checkboxes[2] = emGUI:dxCreateCheckBox(0.02, 0.05, 0.10, 0.02, "Vehicle Related", false, true, logViewerWindow)
		checkboxes[3] = emGUI:dxCreateCheckBox(0.02, 0.08, 0.10, 0.02, "Interior Related", false, true, logViewerWindow)
		checkboxes[4] = emGUI:dxCreateCheckBox(0.02, 0.11, 0.10, 0.02, "Ped Related", false, true, logViewerWindow)
		checkboxes[5] = emGUI:dxCreateCheckBox(0.02, 0.14, 0.10, 0.02, "Faction Related", false, true, logViewerWindow)
		checkboxes[6] = emGUI:dxCreateCheckBox(0.02, 0.17, 0.10, 0.02, "Item Movement", false, true, logViewerWindow)
		checkboxes[7] = emGUI:dxCreateCheckBox(0.02, 0.20, 0.10, 0.02, "Cash Transfers", false, true, logViewerWindow)
		checkboxes[8] = emGUI:dxCreateCheckBox(0.02, 0.23, 0.10, 0.02, "Emeralds", false, true, logViewerWindow)
		checkboxes[9] = emGUI:dxCreateCheckBox(0.02, 0.26, 0.10, 0.02, "Connections", false, true, logViewerWindow)
		checkboxes[10] = emGUI:dxCreateCheckBox(0.02, 0.29, 0.10, 0.02, "Phone Logs", false, true, logViewerWindow)
		
		checkboxes[11] = emGUI:dxCreateCheckBox(0.15, 0.02, 0.10, 0.02, "SMS Logs", false, true, logViewerWindow)
		checkboxes[12] = emGUI:dxCreateCheckBox(0.15, 0.05, 0.10, 0.02, "Vehicle/Int Actions", false, true, logViewerWindow)
		checkboxes[13] = emGUI:dxCreateCheckBox(0.15, 0.08, 0.10, 0.02, "Stat Transfers", false, true, logViewerWindow)
		checkboxes[14] = emGUI:dxCreateCheckBox(0.15, 0.11, 0.10, 0.02, "Kill/Death Log & Item Loss", false, true, logViewerWindow)
		checkboxes[15] = emGUI:dxCreateCheckBox(0.15, 0.14, 0.10, 0.02, "Reports", false, true, logViewerWindow)
		checkboxes[16] = emGUI:dxCreateCheckBox(0.15, 0.17, 0.10, 0.02, "Punishments/Warns", false, true, logViewerWindow)
		checkboxes[17] = emGUI:dxCreateCheckBox(0.15, 0.20, 0.10, 0.02, "Errors", false, true, logViewerWindow)
		checkboxes[18] = emGUI:dxCreateCheckBox(0.15, 0.23, 0.10, 0.02, "VT Related", false, true, logViewerWindow)
		checkboxes[19] = emGUI:dxCreateCheckBox(0.15, 0.26, 0.10, 0.02, "MT Related", false, true, logViewerWindow)
		checkboxes[20] = emGUI:dxCreateCheckBox(0.15, 0.29, 0.10, 0.02, "FT Related", false, true, logViewerWindow)

		checkboxes[21] = emGUI:dxCreateCheckBox(0.28, 0.02, 0.10, 0.02, "/c & /w", false, true, logViewerWindow)
		checkboxes[22] = emGUI:dxCreateCheckBox(0.28, 0.05, 0.10, 0.02, "/say", false, true, logViewerWindow)
		checkboxes[23] = emGUI:dxCreateCheckBox(0.28, 0.08, 0.10, 0.02, "/b", false, true, logViewerWindow)
		checkboxes[24] = emGUI:dxCreateCheckBox(0.28, 0.11, 0.10, 0.02, "/me", false, true, logViewerWindow)
		checkboxes[25] = emGUI:dxCreateCheckBox(0.28, 0.14, 0.10, 0.02, "/do", false, true, logViewerWindow)
		checkboxes[26] = emGUI:dxCreateCheckBox(0.28, 0.17, 0.10, 0.02, "/ame", false, true, logViewerWindow)
		checkboxes[27] = emGUI:dxCreateCheckBox(0.28, 0.20, 0.10, 0.02, "/ado", false, true, logViewerWindow)
		checkboxes[28] = emGUI:dxCreateCheckBox(0.28, 0.23, 0.10, 0.02, "/pm", false, true, logViewerWindow)
		checkboxes[29] = emGUI:dxCreateCheckBox(0.28, 0.26, 0.10, 0.02, "/s", false, true, logViewerWindow)
		checkboxes[30] = emGUI:dxCreateCheckBox(0.28, 0.29, 0.10, 0.02, "/h", false, true, logViewerWindow)

		checkboxes[31] = emGUI:dxCreateCheckBox(0.41, 0.02, 0.10, 0.02, "/st", false, true, logViewerWindow)
		checkboxes[32] = emGUI:dxCreateCheckBox(0.41, 0.05, 0.10, 0.02, "/mt", false, true, logViewerWindow)
		checkboxes[33] = emGUI:dxCreateCheckBox(0.41, 0.08, 0.10, 0.02, "/vt", false, true, logViewerWindow)
		checkboxes[34] = emGUI:dxCreateCheckBox(0.41, 0.11, 0.10, 0.02, "/ft", false, true, logViewerWindow)
		checkboxes[35] = emGUI:dxCreateCheckBox(0.41, 0.14, 0.10, 0.02, "/d", false, true, logViewerWindow)
		checkboxes[36] = emGUI:dxCreateCheckBox(0.41, 0.17, 0.10, 0.02, "/a", false, true, logViewerWindow)
		checkboxes[37] = emGUI:dxCreateCheckBox(0.41, 0.20, 0.10, 0.02, "/l", false, true, logViewerWindow)
		checkboxes[38] = emGUI:dxCreateCheckBox(0.41, 0.23, 0.10, 0.02, "/r", false, true, logViewerWindow)
		checkboxes[39] = emGUI:dxCreateCheckBox(0.41, 0.26, 0.10, 0.02, "/f", false, true, logViewerWindow)
		checkboxes[40] = emGUI:dxCreateCheckBox(0.41, 0.29, 0.10, 0.02, "/m", false, true, logViewerWindow)

		checkboxes[41] = emGUI:dxCreateCheckBox(0.54, 0.02, 0.10, 0.02, "/district", false, true, logViewerWindow)
		checkboxes[42] = emGUI:dxCreateCheckBox(0.54, 0.05, 0.10, 0.02, "/status", false, true, logViewerWindow)
		checkboxes[43] = emGUI:dxCreateCheckBox(0.54, 0.08, 0.10, 0.02, "Anticheat", false, true, logViewerWindow)
		checkboxes[44] = emGUI:dxCreateCheckBox(0.54, 0.11, 0.10, 0.02, "Asset Transfers", false, true, logViewerWindow)
		checkboxes[45] = emGUI:dxCreateCheckBox(0.54, 0.14, 0.10, 0.02, "Teleporter Usage", false, true, logViewerWindow)
		checkboxes[46] = emGUI:dxCreateCheckBox(0.54, 0.17, 0.10, 0.02, "/fl", false, true, logViewerWindow)
		--checkboxes[47] = emGUI:dxCreateCheckBox(0.54, 0.20, 0.10, 0.02, "None", false, true, logViewerWindow)
		--checkboxes[48] = emGUI:dxCreateCheckBox(0.54, 0.23, 0.10, 0.02, "None", false, true, logViewerWindow)
		--checkboxes[49] = emGUI:dxCreateCheckBox(0.54, 0.26, 0.10, 0.02, "None", false, true, logViewerWindow)
		--checkboxes[50] = emGUI:dxCreateCheckBox(0.54, 0.29, 0.10, 0.02, "None", false, true, logViewerWindow)

		emGUI:dxCreateLabel(0.66, 0.06, 0.12, 0.02, "Log Search Type", true, logViewerWindow)

		searchTypeCombobox = emGUI:dxCreateComboBox(0.66, 0.1, 0.18, 0.035, true, logViewerWindow)
		emGUI:dxComboBoxAddItem(searchTypeCombobox, "Log Text")
		emGUI:dxComboBoxAddItem(searchTypeCombobox, "Character Name")
		emGUI:dxComboBoxAddItem(searchTypeCombobox, "Account Name")
		emGUI:dxComboBoxAddItem(searchTypeCombobox, "Vehicle ID")
		emGUI:dxComboBoxAddItem(searchTypeCombobox, "Interior ID")
		emGUI:dxComboBoxAddItem(searchTypeCombobox, "Faction ID")
		emGUI:dxComboBoxAddItem(searchTypeCombobox, "Item ID")
		
		searchTypeInput = emGUI:dxCreateEdit(0.66, 0.15, 0.31, 0.035, "", true, logViewerWindow)

		local uncheckallButton = emGUI:dxCreateButton(0.66, 0.215, 0.15, 0.09, "Check/Uncheck All", true, logViewerWindow)
		addEventHandler("onClientDgsDxMouseClick", uncheckallButton, function(b, c)
			if (b == "left") and (c == "down") then
				for i, checkbox in ipairs(checkboxes) do
					emGUI:dxCheckBoxSetSelected(checkbox, selectAll)
				end
				selectAll = not selectAll
			end
		end)

		searchButton = emGUI:dxCreateButton(0.82, 0.215, 0.15, 0.09, "Search", true, logViewerWindow)
		addEventHandler("onClientDgsDxMouseClick", searchButton, searchButtonClick)
	end
end
addCommandHandler("viewlogs", showLogsGUI)

function searchButtonClick(b, c)
	if (b == "left") and (c == "down") then
		local searchType = emGUI:dxComboBoxGetSelectedItem(searchTypeCombobox) or -1
		local searchInput = emGUI:dxGetText(searchTypeInput)
		local isTextSearch = false
		if tonumber(searchType) and (searchType ~= -1) and tostring(searchInput) and (string.len(searchInput) > 0) then
			isTextSearch = true
		end

		-- Insert all selected log IDs into selections table.
		local selections = {}
		for i, checkbox in ipairs(checkboxes) do
			if emGUI:dxCheckBoxGetSelected(checkbox) then
				table.insert(selections, i)
			end
		end

		if (#selections == 0) then
			emGUI:dxSetText(logViewerWindow, "Select some log types to search for!")
			emGUI:dxWindowSetTitleTextColor(logViewerWindow, tocolor(255, 0, 0, 255))
			return false
		end
		triggerServerEvent("admin:logsearch", localPlayer, selections, tonumber(searchType), isTextSearch, searchInput)

		emGUI:dxSetText(searchButton, "Loading..")
		emGUI:dxSetEnabled(searchButton, false)
	end
end

local queryCount = 0
function populateLogs(logTable, q)
	setClipboard(q)
	if logTable and (type(logTable) == "table") then
		if emGUI:dxIsWindowVisible(logViewerWindow) then
			emGUI:dxGridListClearRow(logsGridList)
			queryCount = 0
			for i, log in pairs(logTable) do
				queryCount = queryCount + 1
				local row = emGUI:dxGridListAddRow(logsGridList)
				emGUI:dxGridListSetItemText(logsGridList, row, 1, log.id)

				local parsedTime = exports.global:convertTime(log.time)
				emGUI:dxGridListSetItemText(logsGridList, row, 2, parsedTime[2] .. " at " .. parsedTime[1])
				emGUI:dxGridListSetItemText(logsGridList, row, 3, tostring(log.source_element))
				emGUI:dxGridListSetItemText(logsGridList, row, 4, typesTable[log.type])
				emGUI:dxGridListSetItemText(logsGridList, row, 5, tostring(log.affected_elements))
				emGUI:dxGridListSetItemText(logsGridList, row, 6, tostring(log.log))
			end
		end
	else
		emGUI:dxSetText(logViewerWindow, "Log Viewer (No matching results)")
	end

	emGUI:dxSetText(searchButton, "Search")
	emGUI:dxSetEnabled(searchButton, true)
end
addEvent("admin:logs:populateLogs", true)
addEventHandler("admin:logs:populateLogs", root, populateLogs)