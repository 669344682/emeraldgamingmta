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

bindKey("F1", "down", "report") -- Report GUI

emGUI = exports.emGUI

labelFont_14 = emGUI:dxCreateNewFont("fonts/buttonFont.ttf", 14)
buttonFont_6 = dxCreateFont(":assets/fonts/buttonFont.ttf", 6)

reportGUIOpened = false
infoGUIOpened = false
makegunGUIOpened = false
playerFound = false

addEvent("report:showReportGui", true)
addEventHandler("report:showReportGui", resourceRoot,
function()
	helpWindowGUI = emGUI:dxCreateWindow(0.3703125, 0.26018518518519, 0.25989583333333, 0.4712962962963, "Create Report", true)

	report_type = emGUI:dxCreateLabel(30, 35, 72, 19, "Report Type", false, helpWindowGUI)
	player_name = emGUI:dxCreateLabel(250, 35, 230, 15, "Player Name", false, helpWindowGUI)
	player_name2 = emGUI:dxCreateLabel(250, 85, 230, 15, "(Leave blank if unrequired)", false, helpWindowGUI)
	description_label = emGUI:dxCreateLabel(30, 195, 90, 20, "Description", false, helpWindowGUI)
	max_chars = emGUI:dxCreateLabel(320, 195, 118, 16, "(Max 140 Characters)", false, helpWindowGUI)

	-- Gridlist
	gridListMenu = emGUI:dxCreateGridList(0.06, 0.12, 0.39, 0.243, true, helpWindowGUI)
	emGUI:dxGridListAddColumn(gridListMenu, "Report Type", 1)
	for i = 1, 5 do
		emGUI:dxGridListAddRow(gridListMenu)
	end
	emGUI:dxGridListSetItemText(gridListMenu, 1, 1, "Player Report", false, false)
	emGUI:dxGridListSetItemText(gridListMenu, 2, 1, "General Question", false, false)
	emGUI:dxGridListSetItemText(gridListMenu, 3, 1, "Vehicle Team Report", false, false)
	emGUI:dxGridListSetItemText(gridListMenu, 4, 1, "Mapping Team Report", false, false)
	emGUI:dxGridListSetItemText(gridListMenu, 5, 1, "Faction Team Report", false, false) 

	-- Input boxes
	playername_input = emGUI:dxCreateEdit(0.50, 0.12, 0.43, 0.05, "", true, helpWindowGUI)
	addEventHandler("onClientDgsDxGUITextChange", playername_input, updatePlayerFoundLabel)

	description_input = emGUI:dxCreateMemo(0.058, 0.46, 0.889, 0.3, "", true, helpWindowGUI)

	-- Buttons
	cancelButton = emGUI:dxCreateButton(30, 400, 185, 62, "CANCEL", false, helpWindowGUI)
	submitButton = emGUI:dxCreateButton(284, 400, 185, 62, "SUBMIT", false, helpWindowGUI)

	addEventHandler ("onClientDgsDxMouseClick", cancelButton, closeReportMenu)
	addEventHandler ("onClientDgsDxMouseClick", submitButton, submitReport)
end)

function updatePlayerFoundLabel()
	local playerNameValue = emGUI:dxGetText(playername_input)
	local targetPlayer = exports.global:getPlayerFromPartialNameOrID(playerNameValue)

	if (targetPlayer) and string.len(playerNameValue) >= 1 then
		local targetPlayerName = getPlayerName(targetPlayer); targetPlayerName = targetPlayerName:gsub("_", " ")
		emGUI:dxSetText(player_name2, "Player " .. targetPlayerName .. " found!")
		emGUI:dxLabelSetColor(player_name2, 0, 255, 0)
		playerFound = targetPlayer
	else
		emGUI:dxSetText(player_name2, "Player not found.")
		emGUI:dxLabelSetColor(player_name2, 255, 0, 0)
		playerFound = false
	end
end

function closeReportMenu(button)
	if (button == "left") then
		emGUI:dxCloseWindow(helpWindowGUI)
	end
end

function submitReport(button)
	if (button == "left") then
		if (playerFound) then -- Checking to see if the reportee is reporting another player that exists.
			reportedPlayer = playerFound
		else
			reportedPlayer = nil -- The server function will make this N/A in the report information.
		end

		local description = emGUI:dxGetText(description_input)

		if (string.len(description) > 140) then -- If the description field is within 140 character limit.
			emGUI:dxLabelSetColor(max_chars, 255, 0, 0)
			return false
		end

		if (string.len(description) == 0) then -- If the description field is empty.
			emGUI:dxLabelSetColor(description_label, 255, 0, 0)
			return false
		end

		local reportType = emGUI:dxGridListGetSelectedItem(gridListMenu) -- Report type is defined in s_reports.lua

		if not (reportType) or (reportType == -1) then -- If the player didn't select a report type.
			emGUI:dxSetText(report_type, "Please select a report type!")
			emGUI:dxLabelSetColor(report_type, 255, 0, 0)
			return false
		end
		triggerServerEvent("report:saveReport", getLocalPlayer(), localPlayer, reportedPlayer, reportType, description)
		emGUI:dxCloseWindow(helpWindowGUI)
	end
end

-- Actually creates report menu.
function showReport()
	if (getElementData(localPlayer, "loggedin") == 1) then
		local guiState = emGUI:dxIsWindowVisible(helpWindowGUI)
		if not (guiState) then
			triggerEvent("report:showReportGui", getRootElement())
		else
			emGUI:dxCloseWindow(helpWindowGUI)
		end
	end
end
addCommandHandler("report", showReport)

------------------------------------------------------------------ [STAFF REPORT PANEL] ------------------------------------------------------------------

reportsClient = {
	-- [reportID] = {reporter, reportedPlayer, reportType, reportDescription, reportHandler}
}

reportPanelLabels = {
	[1] = {},
	[2] = {}
}

function addReportClient(reporter, reportedPlayer, reportType, reportDescription, reportHandlerName)
-- This function is triggered by the shared script in g_reports.lua whenever a report has been created, closed or when it's type has been changed.
-- Used only when adding a report.
	table.insert(reportsClient, {reporter:gsub("_", " "), reportedPlayer, reportType, reportDescription, reportHandlerName})
	populateReports()
end
addEvent("report:addReportClient", true)
addEventHandler("report:addReportClient", getRootElement(), addReportClient)

function removeReportClient(reportID)
-- Same as the function above, just removing it.
	table.remove(reportsClient, reportID)
	populateReports()
end
addEvent("report:removeReportClient", true)
addEventHandler("report:removeReportClient", getRootElement(), removeReportClient)

function changeReportTypeClient(reportID, type)
-- Changes the report's type. Triggered with the /rar command.
	reportsClient[reportID][3] = type
	populateReports()
end
addEvent("report:changeTypeClient", true)
addEventHandler("report:changeTypeClient", getRootElement(), changeReportTypeClient)

function setHandledState(reportID, reportHandlerName)
-- Sets the reports being handled state (true or false). The report label is green if nobody is handling it (false) and red otherwise.
	reportsClient[reportID][5] = reportHandlerName
	populateReports()
end
addEvent("report:setHandledStateClient", true)
addEventHandler("report:setHandledStateClient", getRootElement(), setHandledState)

function report_showReportPanel()
	reportPanelWindow = emGUI:dxCreateWindow(0.675, 0.04, 0.30, 0.30, " ", true, false, true, true, _, 5)
	populateReports()
end

function populateReports()
	local guiState = emGUI:dxIsWindowVisible(reportPanelWindow)
	if (guiState) then
		for i in ipairs(reportPanelLabels[1]) do
			 if (isElement(reportPanelLabels[1][i])) and (getElementType(reportPanelLabels[1][i]) == "dgs-dxlabel") then
				destroyElement(reportPanelLabels[1][i])
			end
			if (isElement(reportPanelLabels[2][i])) and (getElementType(reportPanelLabels[2][i]) == "dgs-dxlabel") then
				destroyElement(reportPanelLabels[2][i])
			end
		end
		--[[ Window sizing
		local windowHeight = 0.04
		windowHeight = windowHeight + (0.025 * #reportsClient)
		outputDebugString(windowHeight)
		emGUI:dxSizeTo(reportPanelWindow, 0.30, windowHeight, true, false, "Linear", 0) ]]
			

		local firstLabelPosY = 0.025
		if (#reportsClient == 0) and not (reportsPlaceholder) then 
			reportsPlaceholder = emGUI:dxCreateLabel(0.025, firstLabelPosY, 0.35, 0.06, "There are currently no reports open.", true, reportPanelWindow)
			return
		elseif (reportsPlaceholder) and (isElement(reportsPlaceholder)) and (getElementType(reportsPlaceholder) == "dgs-dxlabel") then
			destroyElement(reportsPlaceholder)
			reportsPlaceholder = nil
		end

		if (#reportsClient > 8) and not (reportIfMore) then 
			local reportText = "report"
			if (#reportsClient > 9) then reportText = reportText .. "s" end

			reportIfMore = emGUI:dxCreateLabel(0.75, 0.93, 0.35, 0.06, "and " .. #reportsClient - 8 .. " other " .. reportText .. ".", true, reportPanelWindow)
		elseif (reportIfMore) and (#reportsClient <= 8) then
			destroyElement(reportIfMore)
			reportIfMore = nil
		elseif (reportIfMore) and (#reportsClient >= 9) then
			emGUI:dxSetText(reportIfMore, "and " .. #reportsClient - 8 .. " other reports.")
		end


		for i, theReport in ipairs(reportsClient) do
			if (i <= 8) then
				local reportType = reportsClient[i][3]
				if (reportType == "Faction Team Report") then
					reportType = "[Faction Team] "
				elseif (reportType == "Mapping Team Report") then
					reportType = "[Mapping Team] "
				elseif (reportType == "Vehicle Team Report") then
					reportType = "[Vehicle Team] "
				else
					reportType = "[" .. reportType .. "] "
				end
				local reportCreator = reportsClient[i][1]
				local reportDescription = reportsClient[i][4]

				local reportedPlayer = reportsClient[i][2]
				if not (reportedPlayer) or (getPlayerFromName(reportedPlayer:gsub(" ", "_")) == getPlayerFromName(reportCreator:gsub(" ", "_"))) then reportedPlayer = "None" end

				local reportHandlerName = reportsClient[i][5]
				if not (reportHandlerName) then reportHandlerName = "None" end

				if (string.len(reportDescription) > 50) then
					reportDescription = reportDescription:sub(0, 50)
					reportDescription = reportDescription .. "..."
				end

				reportPanelLabels[1][i] = emGUI:dxCreateLabel(0.025, firstLabelPosY, 0.35, 0.06, "(#".. i .. ") " .. reportType .."- " .. reportCreator .. " - " .. "Reported Player: " .. reportedPlayer:gsub("_", " "), true, reportPanelWindow)
				reportPanelLabels[2][i] = emGUI:dxCreateLabel(0.025, firstLabelPosY + 0.05, 0.35, 0.06, "Description: " .. reportDescription .. " - Handler: " .. reportHandlerName, true, reportPanelWindow)
				firstLabelPosY = firstLabelPosY + 0.115

				addEventHandler("onClientDgsDxMouseEnter", reportPanelLabels[1][i], function()
						local i = emGUI:dxGetText(source); i = tonumber(i:sub(3, 3))

						emGUI:dxLabelSetColor(reportPanelLabels[1][i], 255, 255, 0)
						emGUI:dxLabelSetColor(reportPanelLabels[2][i], 255, 255, 0)
				end)

				addEventHandler("onClientDgsDxMouseLeave", reportPanelLabels[1][i], function()
					local i = emGUI:dxGetText(source); i = tonumber(i:sub(3, 3))

					if (reportHandlerName ~= "None") then 
						emGUI:dxLabelSetColor(reportPanelLabels[1][i], 255, 0, 0)
						emGUI:dxLabelSetColor(reportPanelLabels[2][i], 255, 0, 0)
					else 
						emGUI:dxLabelSetColor(reportPanelLabels[1][i], 0, 255, 0) 
						emGUI:dxLabelSetColor(reportPanelLabels[2][i], 0, 255, 0)
					end
				end)

				addEventHandler("onClientDgsDxMouseClick", reportPanelLabels[1][i], function(button, state)
					if (button == "left") and (state == "down") then
						local id = emGUI:dxGetText(source); id = id:sub(3, 3)

						if (reportHandlerName == "None") then
							triggerServerEvent("reports:acceptReport", localPlayer, localPlayer, "ar", tonumber(id))
						elseif (reportHandlerName == getElementData(localPlayer, "account:username")) then
							triggerServerEvent("reports:closeReport", localPlayer, localPlayer, "cr", tonumber(id))
						end
					end
				end)


				if (reportHandlerName ~= "None") then
					emGUI:dxLabelSetColor(reportPanelLabels[1][i], 255, 0, 0)
					emGUI:dxLabelSetColor(reportPanelLabels[2][i], 255, 0, 0)
				else
					emGUI:dxLabelSetColor(reportPanelLabels[1][i], 0, 255, 0)
					emGUI:dxLabelSetColor(reportPanelLabels[2][i], 0, 255, 0)
				end
			else
				break
			end
		end
	end
end
addEvent("report:populateReportPanel", true)
addEventHandler("report:populateReportPanel", localPlayer, populateReports)


function toggleReportMenu()
	if getElementData(localPlayer, "hud:reportpanel") == 0 then
		report_showReportPanel()
		triggerEvent("hud:updateHudData", localPlayer, "hud:reportpanel", 1)
	else -- If panel was open.
		emGUI:dxCloseWindow(reportPanelWindow)
		reportsPlaceholder = nil
		reportIfMore = nil
		triggerEvent("hud:updateHudData", localPlayer, "hud:reportpanel", 0)
	end
end
addEvent("report:toggleReportMenuState", true)
addEventHandler("report:toggleReportMenuState", getRootElement(), toggleReportMenu)
-- This eventHandler is triggered in c_hud.lua by the HUD icon to enable the report panel.

function initReportsPanel()
	local reportPanelStatus = getElementData(localPlayer, "hud:reportpanel")
	if (reportPanelStatus == 1) then
		triggerEvent("hud:updateHudData", localPlayer, "hud:reportpanel", 0)
	end
end
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), initReportsPanel)

function restoreReports(reportsTable)
	for i, report in ipairs(reportsTable) do
		table.insert(reports[i][1], reportsTable[i][1])
		table.insert(reports[i][2], reportsTable[i][2])
		table.insert(reports[i][3], reportsTable[i][3])

		if (reportsTable[i][4] ~= false) then
			table.insert(reports[i][4], true)
		end
	end
end
addEvent("report:c_restoreReports", true)
addEventHandler("report:c_restoreReports", getResourceRootElement(), restoreReports)

--------------------------------------------- [REPORT PANEL ICON] -----------------------------------

local screenW, screenH = guiGetScreenSize()

function renderReportIcon()
	if (getElementData(localPlayer, "hud:enabledstatus") == 0) then
		if (getElementData(localPlayer, "staff:rank") >= 1) or (getElementData(localPlayer, "staff:developer") >= 1) or (getElementData(localPlayer, "staff:vt") >= 1) or (getElementData(localPlayer, "staff:ft") >= 1) or (getElementData(localPlayer, "staff:mt") >= 1) then
			local hudStyle = getElementData(localPlayer, "settings:graphics:setting7") or 1

			if (tonumber(hudStyle) == 1) then
				hudStyle = "black_on_white"
			elseif (tonumber(hudStyle) == 2) then
				hudStyle = "white_on_black"
			else
				hudStyle = "black_on_white"
			end

			local reportIconImage = "/reportpanel_offgreen.png"
			if (#reportsClient >= 4) and not (#reports >= 8) then
				reportIconImage = "/reportpanel_offyellow.png"
			elseif (#reportsClient >= 8) then
				reportIconImage = "/reportpanel_offred.png"
			end

			local posLeft = screenW * 0.9650
			if (#reportsClient >= 10) then
				posLeft = screenW * 0.9645
			end

			if (getElementData(localPlayer, "hud:reportpanel") == 1) then
				dxDrawImage(screenW - 72, 5, 32, 32, "images/" .. hudStyle .. reportIconImage)
			else
				dxDrawImage(screenW - 72, 5, 32, 32, "images/" .. hudStyle ..  reportIconImage, 0, 0, 0, tocolor(165, 165, 165))
			end
			local reportCountLabel = dxDrawText(#reportsClient, posLeft, screenH * 0.0241, screenW * 0.9682, screenH * 0.0324, tocolor(255, 255, 255), 1.00, buttonFont_6)
		end
	end
end
addEventHandler("onClientRender", getRootElement(), renderReportIcon)
addEventHandler("onClientResourceStart", getRootElement(), renderReportIcon)