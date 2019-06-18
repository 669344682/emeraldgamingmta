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

Copyright of the Emerald Gaming Development Team, do not distribute - All rights reserved. 

This file is to be used for developmental commands or functions which will exist permanently for the usage of the Development Team. ]]

-- [TEMPORARY] Timer to automatically set the time to 12:00 every 3 minutes.
setTimer(function()
	setTime(12, 0)
end, 20000, 0) -- 180,000 milliseconds is 3 minutes.

-- /debugdata - By Skully (??/??/17) [Player]
function debugData(thePlayer)
	-- Ranks
	local rankLevel = getElementData(thePlayer, "staff:rank")
	local developerLevel = getElementData(thePlayer, "staff:developer")
	local vehicleTeamLevel = getElementData(thePlayer, "staff:vt")
	local factionTeamLevel = getElementData(thePlayer, "staff:ft")
	local mappingTeamLevel = getElementData(thePlayer, "staff:mt")

	-- Duties
	local staffDuty = getElementData(thePlayer, "duty:staff")
	local devDuty = getElementData(thePlayer, "duty:developer")
	local vehicleDuty = getElementData(thePlayer, "duty:vt")
	local mappingDuty = getElementData(thePlayer, "duty:mt")

	-- Titles
	local adminTitle = getElementData(thePlayer, "title:admin")
	local developerTitle = getElementData(thePlayer, "title:developer")
	local vtTitle = getElementData(thePlayer, "title:vt")
	local ftTitle = getElementData(thePlayer, "title:ft")
	local mtTitle = getElementData(thePlayer, "title:mt")

	-- Other Data
	local muted = getElementData(thePlayer, "account:muted")
	local togmgtwarn = getElementData(thePlayer, "var:togmgtwarn")
	local loggedin = getElementData(thePlayer, "loggedin")

	outputChatBox(" ", thePlayer, 0, 0, 0)
	outputChatBox("[CURRENT SAVED ELEMENT DATA]", thePlayer, 75, 230, 10)
	outputChatBox(" ", thePlayer, 0, 0, 0)
	outputChatBox("[RANKS]", thePlayer, 200, 200, 240)
	outputChatBox("Your Staff rank level: " .. rankLevel, thePlayer, 0, 255, 0)
	outputChatBox("Your developer level: " .. developerLevel, thePlayer, 0, 255, 0)
	outputChatBox("Your Vehicle Team level: " .. vehicleTeamLevel, thePlayer, 0, 255, 0)
	outputChatBox("Your Faction Team level: " .. factionTeamLevel, thePlayer, 0, 255, 0)
	outputChatBox("Your Mapping Team level: " .. mappingTeamLevel, thePlayer, 0, 255, 0)

	outputChatBox(" ", thePlayer, 0, 0, 0)
	outputChatBox("[DUTY STATUSES]", thePlayer, 200, 200, 240)
	outputChatBox("Your Staff Duty status: " .. staffDuty, thePlayer, 0, 255, 0)
	outputChatBox("Your Developer Duty status: " .. devDuty, thePlayer, 0, 255, 0)
	outputChatBox("Your Vehicle Team Duty status: " .. vehicleDuty, thePlayer, 0, 255, 0)
	outputChatBox("Your Mapping Team Duty status: " .. mappingDuty, thePlayer, 0, 255, 0)

	outputChatBox(" ", thePlayer, 0, 0, 0)
	outputChatBox("[STAFF TITLES]", thePlayer, 200, 200, 240)
	outputChatBox("Admin Title: " .. adminTitle, thePlayer, 0, 255, 0)
	outputChatBox("Developer Title: " .. developerTitle, thePlayer, 0, 255, 0)
	outputChatBox("VT Title: " .. vtTitle, thePlayer, 0, 255, 0)
	outputChatBox("FT Title: " .. ftTitle, thePlayer, 0, 255, 0)
	outputChatBox("MT Title: " .. mtTitle, thePlayer, 0, 255, 0)

	outputChatBox(" ", thePlayer, 0, 0, 0)
	outputChatBox("[OTHER DATA]", thePlayer, 200, 200, 240)
	outputChatBox("Your muted status: " .. muted, thePlayer, 0, 255, 0)
	outputChatBox("Your Manager Warns status: " .. togmgtwarn, thePlayer, 0, 255, 0)
	outputChatBox("Your logged in status: " .. loggedin, thePlayer, 0, 255, 0)
	outputChatBox(" ", thePlayer, 0, 0, 0)
end
addCommandHandler("debugdata", debugData)

-- /sqlstatus - by Skully (04/08/17) [Manager, Lead Developer]
function checkMySQL(thePlayer)
	if (exports.global:isPlayerLeadDeveloper(thePlayer) or exports.global:isPlayerManager(thePlayer)) then
		local SQLStatus = exports.mysql:getConnection()

		if (SQLStatus) then
			outputChatBox("[MYSQL] The server is currently connected to the MySQL database.", thePlayer, 75, 230, 10)
		else
			outputChatBox("[MYSQL] There is no MySQL connection currently active!", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("sqlstatus", checkMySQL)

-- /debuglogs - by Skully (17/03/18) [Lead Manager, Lead Developer]
function debugLogs(thePlayer)
	if (exports.global:isPlayerLeadDeveloper(thePlayer) or exports.global:isPlayerLeadManager(thePlayer)) then
		local state =  getElementData(thePlayer, "var:debuglogs")

		if not (state) or (tonumber(state) == 0) then
			exports.blackhawk:setElementDataEx(thePlayer, "var:debuglogs", 1)
			outputChatBox("You have enabled debug view for logs.", thePlayer, 75, 230, 10)
		else
			exports.blackhawk:setElementDataEx(thePlayer, "var:debuglogs", 0)
			outputChatBox("You have disabled debug view for logs.", thePlayer, 75, 230, 10)
		end
	end
end
addCommandHandler("debuglogs", debugLogs)

--[[

NOTE FOR DEVELOPERS:
	This is a temporary backdoor command used to set your rank back to any specific value, used for
	testing permissions and whatnot. - Skully

]]
-- /setxdrank - by Skully (23/06/17) [Player]
function setAdminRank(thePlayer, commandName, targetPlayer, rank)
	if not (targetPlayer) or not tonumber(rank) then
		local thePlayerName = getPlayerName(thePlayer)
		exports.global:sendMessageToManagers("[WARNING] " .. thePlayerName:gsub("_", " ") .. " attempted to use the back-door command.", 1)
		return
	else
		local targetPlayer = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)

		if (targetPlayer) then
			local targetPlayerName = getPlayerName(targetPlayer)
			local thePlayerName = getPlayerName(thePlayer)
			local thePlayerRank = exports.global:getStaffTitle(thePlayer)
			local accountID = getElementData(targetPlayer, "account:id")

			if (tonumber(rank) >= 0) and (tonumber(rank) <= 6) then
				local rankName = exports.global:numberToRankName(tonumber(rank)) -- convert the number the player inputs to name
				
				-- Set the data.
				exports.mysql:Execute("UPDATE `accounts` SET `rank` = (?) WHERE `accounts`.`id` = (?);", rank, accountID)
				exports.blackhawk:setElementDataEx(targetPlayer, "staff:rank", rank, true)
				exports.global:setPlayerTitles(targetPlayer)

				-- Send the respective messages to notify the players and administrators.
				outputChatBox("You have set " .. targetPlayerName .. "'s rank to " .. rankName .. ".", thePlayer, 0, 255, 0)
				outputChatBox("Your rank has been set to " .. rankName .. " by " .. thePlayerName .. ".", targetPlayer, 75, 230, 10)
				exports.global:sendMessageToManagers("[WARNING] " .. thePlayerName:gsub("_", " ") .. " has set " .. targetPlayerName:gsub("_", " ") .. "'s rank using the back-door command.", 1)
			else
				outputChatBox("ERROR: That is not a valid rank ID!", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("ERROR: That player does not exist!", thePlayer, 255, 0, 0)
		end
	end
end
--addCommandHandler("setxdrank", setAdminRank)

-- /setelementdata [Data] [Value] (Player/ID) (Use Anticheat [1-0]) - By Skully (24/05/18) [Lead Developer]
function pSetElementData(thePlayer, commandName, data, value, targetPlayer, anticheat)
	if exports.global:isPlayerLeadDeveloper(thePlayer) then
		if not (data) or not (value) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Data] [Value] (Player/ID) (Use Anticheat [1-0])", thePlayer, 75, 230, 10)
			return false
		end

		if not (targetPlayer) then targetPlayer = thePlayer end
		local targetPlayer, targetPlayerName = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)
		if (targetPlayer) then
			local hasSet = false

			-- Convert string entries to booleans.
			if (value == "true") then value = true end
			if (value == "false") then value = false end
			if (anticheat) then
				hasSet = exports.blackhawk:setElementDataEx(targetPlayer, data, value, true)
			else
				hasSet = setElementData(targetPlayer, data, value, true)
			end

			-- Outputs.
			if (hasSet) then
				outputChatBox("You have set element data on " .. targetPlayerName .. ". [Data: '" .. data .. "', Value: '" .. value .. "']", thePlayer, 75, 230, 10)
				local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
				exports.global:sendMessageToManagers("[WARN] " .. thePlayerName .. " has set element data on " .. targetPlayerName .. ".", true)
			else
				outputChatBox("ERROR Failed to set element data on " .. targetPlayerName .. ".", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("setelementdata", pSetElementData)

-- /removeelementdata [Data] (Player/ID) - By Skully (24/05/18) [Lead Developer]
function pRemoveElementData(thePlayer, commandName, data, targetPlayer)
	if exports.global:isPlayerLeadDeveloper(thePlayer) then
		if not (data) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Data] (Player/ID)", thePlayer, 75, 230, 10)
			return false
		end

		if not (targetPlayer) then targetPlayer = thePlayer end
		local targetPlayer, targetPlayerName = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)
		if (targetPlayer) then
			local hasRemoved = removeElementData(targetPlayer, data)
			if (hasRemoved) then
				outputChatBox("You have remove element data '" .. data .. "' from " .. targetPlayerName .. ".", thePlayer, 0, 255, 0)
				local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
				exports.global:sendMessageToManagers("[WARN] " .. thePlayerName .. " has removed element data from " .. targetPlayerName .. ".", true)
			else
				outputChatBox("ERROR: No element data '" .. data .. "' exists on " .. targetPlayerName .. ".", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("removeelementdata", pRemoveElementData)
