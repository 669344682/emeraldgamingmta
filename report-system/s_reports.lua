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

function completedReport(theAdmin, reportID) -- Adds one report to the admin's report count.
	local reportCount = getElementData(theAdmin, "account:reports")
	exports.blackhawk:setElementDataEx(theAdmin, "account:reports", reportCount + 1, false)

	local players = getElementsByType("player") -- Get a table of all the players in the server.
	-- Update every staff member's clientside report table.
	for k, player in ipairs(players) do
		if (exports.global:isPlayerStaff(player, true)) then
			triggerClientEvent(player, "report:removeReportClient", getRootElement(), reportID) -- Trigger an event in c_reports.lua that removes the report from the client table.
		end
	end

	 -- Notify the reporter's that were bumped down that their report ID has changed.
	for index, id in ipairs(reports) do
		if (index >= reportID) then -- Check if the report was bumped down.
			local reporterName = reports[index][1]
			local reporter = getPlayerFromName(reporterName)
			outputChatBox("Your report has been moved down to #" .. index .. " due to reports in front being solved.", reporter, 240, 220, 50)
		end
	end
end

-- /ri - by Zil (29/08/17) [Staff]
function reportInformation(thePlayer, commandName, reportID)
	if exports.global:isPlayerStaff(thePlayer) then
		if not tonumber(reportID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Report ID]", thePlayer, 75, 230, 10)
		else
			local reportID = tonumber(reportID)

			if (reportID > #reports) or (reportID < 1) then
				outputChatBox("The specified report does not exist.", thePlayer, 255, 0, 0)
			else
				local reporter = reports[reportID][1]
				local reportedPlayer = reports[reportID][2]
				local reportType = reports[reportID][3]
				local reportDesc = reports[reportID][4]
				local reportHandlerName = reports[reportID][5]

				if (reporter) then -- If there's no reporter then there's no report.
					if not (reporter) then
						local reporterName = getPlayerFromName(reporter)
						outputChatBox("[Report #" .. reportID .. " - " .. reportType .. "] " .. reporter:gsub("_", " ") .. " is reporting " .. reportedPlayer:gsub("_", " ") .. ".", thePlayer, 240, 220, 50)
						outputChatBox("Description: " .. reportDesc, thePlayer, 240, 220, 50)
					else
						outputChatBox("[Report #" .. reportID .. " - " .. reportType .. "] " .. reporter:gsub("_", " ") .. " is requesting assistance.", thePlayer, 240, 220, 50)
						outputChatBox("Description: " .. reportDesc, thePlayer, 240, 220, 50)
					end

					if (reportHandlerName) then -- If someone is handling the report.
						local reportHandler = getPlayerFromName(reportHandlerName)
						local reportHandlerTitle = exports.global:getStaffTitle(reportHandler, 1)
						outputChatBox("This report is being handled by " .. reportHandler .. ".", thePlayer, 240, 220, 50)
					end
				else
					outputChatBox("ERROR: A report with that ID does not exist.", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("ri", reportInformation)

-- /ar - by Zil (29/08/17) [Staff]
function acceptReport(thePlayer, commandName, reportID)
	if(exports.global:isPlayerStaff(thePlayer)) then
		if not tonumber(reportID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Report ID]", thePlayer, 75, 230, 10)
		else
			local reportID = tonumber(reportID)

			if (reportID > #reports) or (reportID < 1) then
				outputChatBox("The specified report does not exist.", thePlayer, 255, 0, 0)
			else
				local reporter = reports[reportID][1]
				local reportedPlayer = reports[reportID][2]
				local reportType = reports[reportID][3]
				local reportDesc = reports[reportID][4]
				local reportHandlerName = reports[reportID][5]

				if (reporter) then
					if not (reportHandlerName) then -- If someone isn't already handling the report.
						if (reporter == getPlayerName(thePlayer)) then -- Make sure that the staff member isn't accepting their own report.
							local thePlayerName = getPlayerName(thePlayer)
							local thePlayerTitle = exports.global:getStaffTitle(thePlayer, 1)
							local theReporter = getPlayerFromName(reporter)
							local affectedElements = {thePlayer, theReporter}

							reports[reportID][5] = thePlayerName -- Set the report as being handled by thePlayer in the table.
							exports.blackhawk:setElementDataEx(thePlayer, "var:lastpmtarget", reporter:gsub(" ", "_"), true) -- Set the last pm target for the admin to the reporter to enable quickreply.
							exports.blackhawk:setElementDataEx(theReporter, "var:lastpmtarget", thePlayerName, true)
							exports.logs:addLog(thePlayer, 15, affectedElements, "Accepted report #" .. reportID .. " created by " .. reporter:gsub("_", " "))

							outputChatBox("You have accepted report #" .. reportID .. " opened by " .. reporter:gsub("_", " ") .. ".", thePlayer, 240, 220, 50)
							outputChatBox(thePlayerTitle .. " has accepted your report #" .. reportID .. ".", theReporter, 240, 220, 50)

							if (getElementData(thePlayer, "var:toggledpms") == 1) then -- If the staff member has their PMs toggled off.
								exports.blackhawk:setElementDataEx(thePlayer, "pmblockignore", reporter, true) -- Sets element data to allow the reporter to PM the staff member even if their PMs are blocked. 
								-- This element data is later removed when the report is closed by either party.
							end

							local players = getElementsByType("player") -- Get a table of all the players in the server.
							-- Update every staff member's clientside report table.
							for k, player in ipairs(players) do
								if (exports.global:isPlayerStaff(player, true)) then
									local theHandlerName = getElementData(thePlayer, "account:username")
									triggerClientEvent(player, "report:setHandledStateClient", player, reportID, theHandlerName)
								end
							end
						else
							outputChatBox("ERROR: You can't accept your own report!", thePlayer, 255, 0, 0)
						end
					else
						local reportHandler = getPlayerFromName(reportHandlerName)
						local reportHandlerTitle = exports.global:getStaffTitle(reportHandler, 1)
						outputChatBox("Report #" .. reportID .. " is already being handled by " .. reportHandlerTitle .. ".", thePlayer, 255, 0, 0)
					end
				else
					outputChatBox("ERROR: A report with that ID does not exist.", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("ar", acceptReport)
addCommandHandler("acceptreport", acceptReport)
addEvent("reports:acceptReport", true)
addEventHandler("reports:acceptReport", root, acceptReport)

-- /cr - by Zil (29/08/17) [Staff]
function closeReport(thePlayer, commandName, reportID)
	if (exports.global:isPlayerStaff(thePlayer)) then
		local closedReport = false
		local reportID = reportID
		local affectedElements = {thePlayer, theReporter}

		if (tonumber(reportID)) then
			if (reportID > #reports) or (reportID < 1) then
				outputChatBox("The specified report does not exist.", thePlayer, 255, 0, 0)
			else
				if (reports[reportID][5]) then
					local reportHandlerName = reports[reportID][5]
					local reportHandler = getPlayerFromName(reportHandlerName)
					local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)

					if (reportHandler == thePlayer) then -- Make sure that the report is being handled by the player that is attempting to close it.
						local theReporterName = reports[reportID][1]
						local theReporter = getPlayerFromName(theReporterName)

						table.insert(affectedElements, theReporter)
						table.remove(reports, reportID)
						closedReport = true

						if (getElementData(reportHandler, "pmblockignore") == theReporterName) then
							removeElementData(reportHandler, "pmblockignore") -- Remove the PM block bypass for the player that submitted the report, making it no longer possible for them to PM the staff member.
						end

						outputChatBox(thePlayerName .. " has closed your report #" .. reportID .. ".", theReporter, 240, 220, 50)
						outputChatBox("You have closed report #" .. reportID .. ".", thePlayer, 240, 220, 50)
						exports.logs:addLog(thePlayer, 15, affectedElements, "Closed report #" .. reportID .. " created by " .. theReporterName .. ".")

						completedReport(thePlayer, reportID)
						triggerEvent("reports:removereportblock", theReporter)
					else
						outputChatBox("You can only close reports that you are handling.", thePlayer, 255, 0, 0)
					end
				else
					outputChatBox("You can only close reports that you are handling.", thePlayer, 255, 0, 0)
				end
			end
		else
			for index, id in ipairs(reports) do
				local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)

				if (reports[index][5] == getPlayerName(thePlayer)) then -- If the report is being handled by the staff member that is trying to close it.
					local theReporterName = reports[index][1]
					local theReporter = getPlayerFromName(theReporterName)
					reportID = index

					if (getElementData(thePlayer, "pmblockignore") == theReporterName) then
						removeElementData(thePlayer, "pmblockignore") -- Remove the PM block bypass for the player that submitted the report, making it no longer possible for them to PM the staff member.
					end

					table.insert(affectedElements, theReporter)
					table.remove(reports, index)
					closedReport = true

					outputChatBox(thePlayerName .. " has closed your report #" .. index .. ".", theReporter, 240, 220, 50)
					outputChatBox("You have closed report #" .. index .. ".", thePlayer, 240, 220, 50)
					exports.logs:addLog(thePlayer, 15, affectedElements, "Closed report #" .. index .. " created by " .. theReporterName .. ".")

					completedReport(thePlayer, reportID)
					triggerEvent("reports:removereportblock", theReporter)
					return true -- Only close one.
				end
			end
		end
	end
end
addCommandHandler("cr", closeReport)
addCommandHandler("closereport", closeReport)
addEvent("reports:closeReport", true)
addEventHandler("reports:closeReport", root, closeReport)

-- /er - by Zil (31/08/17) [Player]
function endReport(thePlayer, commandName, reportID)
	if (getElementData(thePlayer, "loggedin") == 1) then
		local affectedElements = {thePlayer}
		local closedReport = false
		local reportID = tonumber(reportID)
		local reportHandler = false
		local thePlayerName = getPlayerName(thePlayer); thePlayerName = thePlayerName:gsub("_", " ")

		if (reportID) then
			if (reportID > #reports) or (reportID < 1) then outputChatBox("ERROR: A report with that ID does not exist.", thePlayer, 255, 0, 0) return false end

			if (reports[reportID][1] == getPlayerName(thePlayer)) then
				table.remove(reports, reportID)
				outputChatBox("You have closed your report #" .. reportID .. ".", thePlayer, 240, 220, 50)
				closedReport = true
			else
				outputChatBox("You can only close reports that you created.", thePlayer, 255, 0, 0)
			end
		else 
			for index, id in ipairs(reports) do
				if (reports[index][1] == getPlayerName(thePlayer)) then
					reportID = index
					reportHandler = reports[reportID][5]

					table.remove(reports, reportID)
					outputChatBox("You have closed your report #" .. reportID .. ".", thePlayer, 240, 220, 50)
					closedReport = true
				break end
			end
		end
		if (closedReport) then
			if (reportHandler) then -- If someone is handling that report.
				local theReportHandler = getPlayerFromName(reportHandler)

				-- Remove the PM block bypass for the player that submitted the report, making it no longer possible for them to PM the staff member.
				if (getElementData(thePlayer, "pmblockignore") == reportHandler) then removeElementData(thePlayer, "pmblockignore") end

				outputChatBox(thePlayerName .. " has closed his report #" .. reportID .. ". You have been credited for the report.", theReportHandler, 240, 220, 50)
				table.insert(affectedElements, theReportHandler)
				completedReport(theReportHandler, reportID)
			end
			exports.logs:addLog(thePlayer, 15, affectedElements, "Ended report #" .. reportID .. ".")

			local players = getElementsByType("player")
			-- Update every staff member's clientside report table.
			for k, player in ipairs(players) do
				if (exports.global:isPlayerStaff(player, true)) then
					triggerClientEvent(player, "report:removeReportClient", player, reportID) -- Trigger an event in c_reports.lua that removes the report from the panel & table.
				end
			end

			 -- Notify the reporter's that were bumped down that their report ID has changed.
			for index, id in ipairs(reports) do
				if (index >= reportID) then -- Check if the report was bumped down.
					local reporterName = reports[index][1]
					local reporter = getPlayerFromName(reporterName)
					outputChatBox("Your report has been moved down to #" .. index .. " due to reports in front being solved.", reporter, 240, 220, 50)
				end
			end
			triggerEvent("reports:removereportblock", thePlayer)
		end
	end
end
addCommandHandler("er", endReport)
addCommandHandler("endreport", endReport)

-- /dr - by Zil (02/09/17) [Staff]
function dropReport(thePlayer, commandName, reportID)
	if (exports.global:isPlayerStaff(thePlayer)) then
		if not tonumber(reportID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Report ID]", thePlayer, 75, 230, 10)
		else
			local reportID = tonumber(reportID)

			if (reportID > #reports) or (reportID < 1) then
				outputChatBox("The specified report does not exist.", thePlayer, 255, 0, 0)
			else
				if (reports[reportID][5]:gsub(" ", "_") == getPlayerName(thePlayer)) then
					local reporterName = reports[reportID][1]:gsub(" ", "_")
					local theReporter = getPlayerFromName(reporterName)
					local affectedElements = {thePlayer, theReporter}

					reports[reportID][5] = false -- False is the default value that is set when the report is first created with no handler.

					local players = getElementsByType("player")
					-- Update every staff member's clientside report table.
					for k, player in ipairs(players) do
						if (exports.global:isPlayerStaff(player, true)) then
							triggerClientEvent(player, "report:setHandledStateClient", player, reportID, false) -- Trigger an event in c_reports.lua that removes the report from the panel & table.
						end
					end
					exports.logs:addLog(thePlayer, 15, affectedElements, "Dropped report #" .. reportID .. " created by " .. reporterName .. ".")

					local thePlayerTitle = exports.global:getStaffTitle(thePlayer, 1)
					outputChatBox("You have dropped report #" .. reportID .. ".", thePlayer, 240, 220, 50)
					outputChatBox(thePlayerTitle .. " has dropped your report #" .. reportID .. ".", theReporter, 240, 220, 50)
				else
					outputChatBox("You can only drop reports that you are handling.", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("dr", dropReport)
addCommandHandler("dropreport", dropReport)

function reassignReport(thePlayer, commandName, reportID, newReportType)
	if (exports.global:isPlayerStaff(thePlayer)) then
		if not (tonumber(reportID)) or not (newReportType) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Report ID] [Report Type]", thePlayer, 75, 230, 10)
			outputChatBox(" ", thePlayer, 75, 230, 10)
			outputChatBox("Report Types:", thePlayer, 75, 230, 10)
			outputChatBox("1 | pr - Player Report", thePlayer, 75, 230, 10)
			outputChatBox("2 | gq - General Question", thePlayer, 75, 230, 10)
			outputChatBox("3 | vt - Vehicle Team Report", thePlayer, 75, 230, 10)
			outputChatBox("4 | mt - Mapping Team Report", thePlayer, 75, 230, 10)
			outputChatBox("5 | ft - Faction Team Report", thePlayer, 75, 230, 10)
		else
			local reportID = tonumber(reportID)

			if (reportID > #reports) or (reportID < 1) then
				outputChatBox("The specified report does not exist.", thePlayer, 255, 0, 0)
			else
				local reportType = reports[reportID][3]

				if (reportType) then -- Check if the report exists.
					local newType
					if (newReportType == "pr") or (tonumber(newReportType) == 1) then newType = "Player Report"
					elseif (newReportType == "gq") or (tonumber(newReportType) == 2) then newType = "General Question"
					elseif (newReportType == "vt") or (tonumber(newReportType) == 3) then newType = "Vehicle Team Report"
					elseif (newReportType == "mt") or (tonumber(newReportType) == 4) then newType = "Mapping Team Report"
					elseif (newReportType == "ft") or (tonumber(newReportType) == 5) then newType = "Faction Team Report"
					else
						outputChatBox("ERROR: Could not recognize provided report type!", thePlayer, 255, 0, 0)
						return false
					end

					if (reportType == newType) then
						outputChatBox("The specified report is already a " .. reportType .. ".", thePlayer, 255, 0, 0)
						return false
					end

					local reporterName = reports[reportID][1]
					local theReporter = getPlayerFromName(reporterName)
					local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
					local affectedElements = {thePlayer, theReporter}

					exports.global:sendMessageToAdmins(thePlayerName .. " has set report #" .. reportID .. "'s type from " .. reportType .. " to a " .. newType .. ".", 240, 220, 50)
					exports.logs:addLog(thePlayer, 15, affectedElements, "Set report # " .. reportID .. "'s type from " .. reportType .. " to a " .. newType .. ".")
					outputChatBox(thePlayerName .. " has set your report #" .. reportID .. " type from " .. reportType .. "'s to a " .. newType .. ".", theReporter, 240, 220, 50)

					-- Set the new report type.
					reports[reportID][3] = newType

					local players = getElementsByType("player") -- Get a table of all the players in the server.
					for k, player in ipairs(players) do
						if (exports.global:isPlayerStaff(player, true)) then
							triggerClientEvent(player, "report:changeTypeClient", player, reportID, reports[reportID][3]) -- Trigger an event in c_reports.lua that changes the report's type.
						end
					end
				end
			end
		end
	end
end
addCommandHandler("rar", reassignReport)
addCommandHandler("reassignreport", reassignReport)
addCommandHandler("setreportype", reassignReport)

function showReports(thePlayer)
	if (exports.global:isPlayerStaff(thePlayer, true)) then
		if (#reports == 0) then
			outputChatBox("There are currently no reports open.", thePlayer, 240, 220, 50)
		else
			for index, id in ipairs(reports) do
				local reportID = index
				local reporterName = reports[index][1]
				local reportedPlayer = reports[index][2]
				local reportType = reports[index][3]
				local reportDesc = reports[index][4]
				local reportHandlerName = reports[index][5]

				outputChatBox(" ", thePlayer, 240, 220, 50)
				outputChatBox("[" .. reportType .. " - #" .. reportID .. "] " .. reporterName:gsub("_", " ") .. ": " .. reportDesc, thePlayer, 240, 220, 50)

				if (reportHandlerName) then -- If someone is handling the report.
					local theHandler = getPlayerFromName(reportHandlerName)
					local reportHandlerTitle = exports.global:getStaffTitle(theHandler, 1)
					outputChatBox("[" .. reportType .. " - #" .. reportID .. "] Being handled by " .. reportHandlerTitle .. ".", thePlayer, 240, 220, 50)
				end
			end
		end
	end
end
addCommandHandler("reports", showReports)

function falseReport(thePlayer, commandName, reportID)
	if (exports.global:isPlayerStaff(thePlayer)) then
		if tonumber(reportID) then
			local reportID = tonumber(reportID)
			if not (reportID > #reports) or (reportID < 1) then
				local reportHandler = reports[reportID][5]

				if not (reportHandler) or (reportHandler:gsub(" ", "_") == getPlayerName(thePlayer)) then -- Don't close the report if someone is handling it, unless thePlayer is theHandler.
					local reporterName = reports[reportID][1]:gsub("_", " ")
					local thePlayerTitle = exports.global:getStaffTitle(thePlayer, 1)
					local theReporter = getPlayerFromName(reporterName:gsub(" ", "_"))
					local affectedElements = {thePlayer, theReporter}

					table.remove(reports, reportID)
					exports.logs:addLog(thePlayer, 15, affectedElements, "Marked report #" .. reportID .. " to false.")

					local players = getElementsByType("player") -- Get a table of all the players in the server.
					for k, player in ipairs(players) do
						if (exports.global:isPlayerStaff(player, true)) then
							triggerClientEvent(player, "report:removeReportClient", player, reportID) -- Trigger an event in c_reports.lua that removes the report clientside.
						end
					end

					outputChatBox("You marked report #" .. reportID .. " false.", thePlayer, 240, 220, 50)
					outputChatBox(thePlayerTitle .. " has marked your report #" .. reportID .. " false.", theReporter, 240, 220, 50)

					 -- Notify the reporter's that were bumped down that their report ID has changed.
					for index, id in ipairs(reports) do
						if (index >= reportID) then -- Check if the report was bumped down.
							local reporterName = reports[index][1]
							local reporter = getPlayerFromName(reporterName)
							outputChatBox("Your report has been moved down to #" .. index .. " due to reports in front being solved.", reporter, 240, 220, 50)
						end
					end
				else
					outputChatBox("The report is currently being handled by another staff member.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Specified report could not be found.", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("SYNTAX: /" .. commandName .. " [Report ID]", thePlayer, 75, 230, 10)
		end
	end
end
addCommandHandler("fr", falseReport)

function removeReportQuit(thePlayer)
	-- Event is triggered in the global resource s_main.lua script whenever a player quits the server or goes to character selection.
	for i, report in ipairs(reports) do
		local thePlayerName = getPlayerName(thePlayer)

		if (reports[i][1] == thePlayerName) then
			 -- If the report is being handled by someone, still reward.
			if (reports[i][5] ~= false) then
				local reportHandler = getPlayerFromName(reports[i][5]:gsub(" ", "_"))
				completedReport(getPlayerFromName(reports[i][5]:gsub(" ", "_")), i)
				outputChatBox("Report #" .. i .. " was closed because the player left.", reportHandler, 240, 220, 50)
			end

			-- Remove the report from the table.
			table.remove(reports, i)
			triggerEvent("reports:removereportblock", getPlayerFromName(thePlayerName:gsub(" ", "_")))

			local players = getElementsByType("player") -- Get a table of all the players in the server.
			for k, player in ipairs(players) do
				if (exports.global:isPlayerStaff(player, true)) then
					triggerClientEvent(player, "report:removeReportClient", player, i)
				end
			end

			 -- Notify the reporter's that were bumped down that their report ID has changed.
			for index, id in ipairs(reports) do
				if (index >= reportID) then -- Check if the report was bumped down.
					local reporterName = reports[index][1]
					local reporter = getPlayerFromName(reporterName)
					outputChatBox("Your report has been moved down to #" .. index .. " due to reports in front being solved.", reporter, 240, 220, 50)
				end
			end
		elseif (reports[i][5] == thePlayerName) then
			-- If the report handler left or when they go to character selection.
			reports[i][5] = false
			local reporter = getPlayerFromName(reports[i][1]:gsub(" ", "_"))

			outputChatBox("Your report #" .. i .. " is open again due to the handler leaving.", reporter, 240, 220, 50)
		end
	end
end
addEvent("report:removeReportQuit", true)
addEventHandler("report:removeReportQuit", getRootElement(), removeReportQuit)

function sendReportsToClient(thePlayer)
	-- Event is triggered in the character-system s_characters.lua script whenever a staff member goes on a character. As well as onResourceStart (g_reports.lua)
	for i, report in ipairs(reports) do
		local reportHandlerName = false
		if (reports[i][5] ~= false) then -- If someone is handling that report.
			local reportHandler = getPlayerFromName(reports[i][5])
			reportHandlerName = getElementData(reportHandler, "account:username")
		end

		 -- Trigger an event in c_reports.lua that adds the report to a table
		triggerClientEvent(thePlayer, "report:addReportClient", thePlayer, reports[i][1], reports[i][2], reports[i][3], reports[i][4], reportHandlerName)
	end
end
addEvent("report:sendReportsToClient", true)
addEventHandler("report:sendReportsToClient", getRootElement(), sendReportsToClient)