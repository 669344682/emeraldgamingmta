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

 -- Table which contains all reports.
reports = {
	-- [reportID] = {reporter, reportedPlayer, reportType, reportDescription, reportHandler}
}

--[[ 
		[Report Types]
		1 - Player Report
		2 - General Question
		3 - Vehicle Team Report
		4 - Mapping Team Report
		5 - Faction Team Report
--]]


function saveReport(thePlayer, reportedPlayer, reportType, reportDesc)
	if not (thePlayer) then -- If there is no player.
		outputDebugString("[REPORT] Error with function 'saveReport', expected thePlayer at parameter 1, got nil", 3)
		return false
	end

	for index, id in ipairs(reports) do -- Check if the player doesn't have any other reports open.
		if (reports[index][1] == getPlayerName(thePlayer)) then
			cantOpenReport = true
		break end
	end

	if not (cantOpenReport == 41) then -- ==== TODO: REMOVE THE == 41 THING LOL ====
		-- Convert the reportType number to a string.
		if (reportType == 1) then
			reportType = "Player Report"
		elseif (reportType == 2) then
			reportType = "General Question"
		elseif (reportType == 3) then
			reportType = "Vehicle Team Report"
		elseif (reportType == 4) then
			reportType = "Mapping Team Report"
		elseif (reportType == 5) then
			reportType = "Faction Team Report"
		else -- In the event the report type is anything else somehow.
			reportType = "Other"
		end

		if not (reportedPlayer) then -- If the player didn't report anyone, make it so they report themselves.
			reportedPlayer = thePlayer
		end

		reportDesc = reportDesc:gsub("\n", " ")

		thePlayerName = getPlayerName(thePlayer)
		reportedPlayerName = getPlayerName(reportedPlayer)

		-- Calculate what the report's ID will be depending on how many reports we already have saved in the table.
		local reportID = #reports + 1

		-- Save all of the report data into the table.
		table.insert(reports, {thePlayerName, reportedPlayerName, reportType, reportDesc, false})
		exports.logs:addLog(thePlayer, 15, thePlayer, "Created report #" .. reportID .. " with type " .. reportType .. " and description: " .. reportDesc)
		-- The report handler state is set to the staff member's name on report acceptance.

		local players = getElementsByType("player") -- Get a table of all the players in the server.
		-- Update every staff member's clientside report table.
		for k, player in ipairs(players) do
			if (exports.global:isPlayerStaff(player, true)) then
				triggerClientEvent(player, "report:addReportClient", player, thePlayerName, reportedPlayerName, reportType, reportDesc, false) -- Trigger an event in c_reports.lua that adds the report to a table.
			end
		end

		outputChatBox("You have opened report #" .. reportID .. " please standby for a staff member to accept the report.", thePlayer, 240, 220, 50)

		-- Notify all staff members of the new report. Administrators are notified of every report, helpers only those that aren't player reports. 
		-- Auxiliary team members (that aren't helpers or admins) are notified of only their team's report type.
		if (thePlayerName ~= reportedPlayerName) then
			exports.global:sendMessageToAdmins("[Report #" .. reportID .. " - " .. reportType .. "] " .. thePlayerName:gsub("_", " ") .. " is reporting " .. reportedPlayerName:gsub("_", " ") .. ".", 240, 220, 50)
			exports.global:sendMessageToAdmins("Description: " .. reportDesc, 240, 220, 50)
		else
			exports.global:sendMessageToAdmins("[Report #" .. reportID .. " - " .. reportType .. "] " .. thePlayerName:gsub("_", " ") .. " is requesting assistance.", 240, 220, 50)
			exports.global:sendMessageToAdmins("Description: " .. reportDesc, 240, 220, 50)
		end

		if (reportType ~= "Player Report") then -- Don't notify helpers about player reports.
			notifyHelpers(reportID, reportType, thePlayerName:gsub("_", " "), reportedPlayer, reportDesc)
		end

		if (reportType == "Vehicle Team Report") then
			notifyVehicleTeam(reportID, reportType, thePlayerName:gsub("_", " "), reportedPlayer, reportDesc)
		end

		if (reportType == "Mapping Team Report") then
			notifyMappingTeam(reportID, reportType, thePlayerName:gsub("_", " "), reportedPlayer, reportDesc)
		end

		if (reportType == "Faction Team Report") then
			notifyFactionTeam(reportID, reportType, thePlayerName:gsub("_", " "), reportedPlayer, reportDesc)
		end
	else
		outputChatBox("You can only have one report open at a time. Close your report with /er to open a new one.", thePlayer, 255, 0, 0)
	end
end
addEvent("report:saveReport", true)
addEventHandler("report:saveReport", getRootElement(), saveReport)


function removeOpenReportBlock()
	cantOpenReport = nil
end
addEvent("reports:removereportblock", true)
addEventHandler("reports:removereportblock", getRootElement(), removeOpenReportBlock)

function notifyVehicleTeam(reportID, reportType, thePlayerName, reportedPlayer, reportDesc)
	local players = getElementsByType("player") -- Get a table of all the players in the server.

	for k, thePlayer in ipairs(players) do -- Use a for loop to step through each player.
		if (exports.global:isPlayerVehicleTeam(thePlayer, true)) then
			if not (exports.global:isPlayerHelper(thePlayer, true)) and not (exports.global:isPlayerTrialAdmin(thePlayer, true)) then
				local reportedPlayerName = getPlayerName(reportedPlayer):gsub("_", " ")

				if (reportedPlayerName ~= thePlayerName) then
					outputChatBox("[Report #" .. reportID .. " - " .. reportType .. "] " .. thePlayerName .. " is reporting " .. reportedPlayerName .. ".", thePlayer, 240, 220, 50)
					outputChatBox("Description: " .. reportDesc, thePlayer, 240, 220, 50)
				else
					outputChatBox("[Report #" .. reportID .. " - " .. reportType .. "] " .. thePlayerName .. " is requesting assistance.", thePlayer, 240, 220, 50)
					outputChatBox("Description: " .. reportDesc, thePlayer, 240, 220, 50)
				end
			end
		end
	end
end

function notifyMappingTeam(reportID, reportType, thePlayerName, reportedPlayer, reportDesc)
	local players = getElementsByType("player") -- Get a table of all the players in the server.

	for k, thePlayer in ipairs(players) do -- Use a for loop to step through each player.
		if (exports.global:isPlayerMappingTeam(thePlayer, true)) then
			if not (exports.global:isPlayerHelper(thePlayer, true)) and not (exports.global:isPlayerTrialAdmin(thePlayer, true)) then
				local reportedPlayerName = getPlayerName(reportedPlayer)

				if (reportedPlayerName ~= thePlayerName) then
					outputChatBox("[Report #" .. reportID .. " - " .. reportType .. "] " .. thePlayerName .. " is reporting " .. reportedPlayerName .. ".", thePlayer, 240, 220, 50)
					outputChatBox("Description: " .. reportDesc, thePlayer, 240, 220, 50)
				else
					outputChatBox("[Report #" .. reportID .. " - " .. reportType .. "] " .. thePlayerName .. " is requesting assistance.", thePlayer, 240, 220, 50)
					outputChatBox("Description: " .. reportDesc, thePlayer, 240, 220, 50)
				end
			end
		end
	end
end

function notifyFactionTeam(reportID, reportType, thePlayerName, reportedPlayer, reportDesc)
	local players = getElementsByType("player") -- Get a table of all the players in the server.

	for k, thePlayer in ipairs(players) do -- Use a for loop to step through each player.
		if (exports.global:isPlayerFactionTeam(thePlayer, true)) then
			if not (exports.global:isPlayerHelper(thePlayer, true)) and not (exports.global:isPlayerTrialAdmin(thePlayer, true)) then
				local reportedPlayerName = getPlayerName(reportedPlayer)

				if (reportedPlayerName ~= thePlayerName) then
					outputChatBox("[Report #" .. reportID .. " - " .. reportType .. "] " .. thePlayerName .. " is reporting " .. reportedPlayerName .. ".", thePlayer, 240, 220, 50)
					outputChatBox("Description: " .. reportDesc, thePlayer, 240, 220, 50)
				else
					outputChatBox("[Report #" .. reportID .. " - " .. reportType .. "] " .. thePlayerName .. " is requesting assistance.", thePlayer, 240, 220, 50)
					outputChatBox("Description: " .. reportDesc, thePlayer, 240, 220, 50)
				end
			end
		end
	end
end

function notifyHelpers(reportID, reportType, thePlayerName, reportedPlayer, reportDesc)
	local players = getElementsByType("player") -- Get a table of all the players in the server.

	for k, thePlayer in ipairs(players) do -- Use a for loop to step through each player.
		if (exports.global:getStaffLevel(thePlayer) == 1) then -- Make sure the staff member is only a helper.
			local reportedPlayerName = getPlayerName(reportedPlayer)

			if (reportedPlayerName ~= thePlayerName) then
				local reportedPlayerName = getPlayerName(reportedPlayer)
				outputChatBox("[Report #" .. reportID .. " - " .. reportType .. "] " .. thePlayerName .. " is reporting " .. reportedPlayerName .. ".", thePlayer, 240, 220, 50)
				outputChatBox("Description: " .. reportDesc, thePlayer, 240, 220, 50)
			else
				outputChatBox("[Report #" .. reportID .. " - " .. reportType .. "] " .. thePlayerName .. " is requesting assistance.", thePlayer, 240, 220, 50)
				outputChatBox("Description: " .. reportDesc, thePlayer, 240, 220, 50)
			end
		end
	end
end

function resourceStart(resource)
	reports = exports.data:loadReports(reports) or {}

	-- Use timer due to the fact that clientside takes longer to load.
	setTimer(function() 
		local players = getElementsByType("player")
		for i, thePlayer in ipairs(players) do 
			if (exports.global:isPlayerStaff(thePlayer, true)) then
				triggerEvent("report:sendReportsToClient", resourceRoot, thePlayer)
			end
		end
	end, 800, 1)
end
addEventHandler("onResourceStart", getResourceRootElement(), resourceStart)

function resourceStop(resource)
	exports.data:saveReports(reports)
end
addEventHandler("onResourceStop", getResourceRootElement(), resourceStop)