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

banLength = {21600, 21600, 43200, 43200, 64800, 86400, 129600, 129600, 259200}

mysql = exports.mysql

-- /punish - By Skully (11/03/18) [Trial Admin]
function punishPlayer(thePlayer, commandName)
	if exports.global:isPlayerTrialAdmin(thePlayer) and (getElementData(thePlayer, "loggedin") == 1) then
		triggerClientEvent(thePlayer, "admin:showPunishPlayerGUI", thePlayer)
	end
end
addCommandHandler("punish", punishPlayer)

function issuePunishment(thePlayer, targetPlayer, points, theReason)
	if not (thePlayer) or not (targetPlayer) then
		exports.global:outputDebug("@issuePunishment: thePlayer or targetPlayer not provided.")
		return false
	elseif not tonumber(points) then
		exports.global:outputDebug("@issuePunishment: Points to issue not received.")
		return false
	end

	if (targetPlayer ~= thePlayer) then
		local targetPlayerRank = getElementData(targetPlayer, "staff:rank")
		local thePlayerRank = getElementData(thePlayer, "staff:rank")

		if (targetPlayerRank == 0) or (thePlayerRank > targetPlayerRank) and (thePlayerRank >= 5) then
			local targetPoints = getElementData(targetPlayer, "account:punishments") or 0
			local accountID = getElementData(targetPlayer, "account:id")
			local thePlayerAccountID = getElementData(thePlayer, "account:id")
			local targetAccountName = getElementData(targetPlayer, "account:username")
			local newPoints = targetPoints + points
			local timeNow = exports.global:getCurrentTime()
			local affectedElements = {thePlayer, targetPlayer}

			local banLengthSeconds
			if (newPoints >= 10) then
				banLengthSeconds = 0
			else
				banLengthSeconds = banLength[newPoints] -- Retrieve ban length from the table above in seconds.
			end

			exports.blackhawk:setElementDataEx(targetPlayer, "account:punishments", tonumber(newPoints), true)

			-- Add data to account history, as well as set the new point amount because they might not be saved due to the ban.
			mysql:Execute("UPDATE `accounts` SET `punishments` = (?) WHERE `id` = (?);", tonumber(newPoints), accountID)
			mysql:Execute("INSERT INTO `accounts_history` (`id`, `account`, `date_issued`, `length`, `points`, `reason`, `issuer`) VALUES (NULL, (?), (?), (?), (?), (?), (?))", accountID, timeNow[3], banLengthSeconds, points, theReason, thePlayerAccountID)
			exports.logs:addLog(thePlayer, 16, affectedElements, "Punished " .. targetAccountName .. " for " .. points .. " points with the reason: " .. theReason)

			local banElement = banPlayer(targetPlayer, true, false, true, thePlayer, theReason, banLengthSeconds)
			setBanNick(banElement, targetAccountName)
		else
			outputChatBox("ERROR: You can not punish a staff member!", thePlayer, 255, 0, 0)
		end
	else
		outputChatBox("Why are you trying to punish yourself? Miss me with that kinky shit.", thePlayer, 255, 0, 0)
	end
end

-- This function is triggered from the /punish GUI clientside.
function issuePunishmentCallback(thePlayer, targetPlayer, points, theReason)
	outputDebugString("[issuePunishmentCallback] thePlayer: " .. getPlayerName(thePlayer) .. " / Target: " .. getPlayerName(targetPlayer) .. " / " .. points .. " points / Reason: " .. theReason)
	if not (thePlayer) or not (targetPlayer) then
		outputDebugString("[admin-system] @issuePunishmentCallback: thePlayer or targetPlayer not provided.", 3)
		return false
	elseif not tonumber(points) or not tostring(theReason) then
		outputDebugString("[admin-system] @issuePunishmentCallback: Points to issue or reason not received.", 3)
		return false
	end

	local targetPlayerRank = getElementData(targetPlayer, "staff:rank")
	local thePlayerRank = getElementData(thePlayer, "staff:rank")

	if (targetPlayerRank == 0) or (thePlayerRank > targetPlayerRank) and (thePlayerRank >= 5) then
		local targetAccountName = getElementData(targetPlayer, "account:username")
		local targetPlayerName = getPlayerName(targetPlayer):gsub("_", " ")
		local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
	
		issuePunishment(thePlayer, targetPlayer, points, theReason)
		exports.global:sendMessage("[PUNISHMENT] " .. exports.global:getStaffTitle(thePlayer, 1) .. " has issued " .. points .. " points to " .. targetPlayerName .. " (" .. targetAccountName .. ").", 255, 0, 0, "punish")
		exports.global:sendMessage("[PUNISHMENT] Reason: " .. theReason, 255, 0, 0, "punish")
	else
		outputChatBox("ERROR: You can not punish a staff member!", thePlayer, 255, 0, 0)
	end
end
addEvent("admin:punishPlayer", true)
addEventHandler("admin:punishPlayer", root, issuePunishmentCallback)

-- /qpunish [Target Player] [Points] [Reason] - by Skully and Zil (10/03/18) [Trial Admin]
function qpunishPlayer(thePlayer, commandName, target, points, ...)
	if exports.global:isPlayerTrialAdmin(thePlayer) and (getElementData(thePlayer, "loggedin") == 1) then
		if not (target) or not tostring(target) or not tonumber(points) or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player/ID] [Points (0-10)] [Reason]", thePlayer, 75, 230, 10)
			return false
		end

		local points = tonumber(points)
		local theReason = table.concat({...}, " ")

		if (points >= 1) and (points <= 10) then
			local targetPlayer = exports.global:getPlayerFromPartialNameOrID(target, thePlayer)

			if (targetPlayer) and (getElementData(targetPlayer, "loggedin") == 1) then
				if (targetPlayer ~= thePlayer) then
					local targetPlayerRank = getElementData(targetPlayer, "staff:rank")
					local thePlayerRank = getElementData(thePlayer, "staff:rank")

					if (targetPlayerRank == 0) or (thePlayerRank > targetPlayerRank) and (thePlayerRank >= 5) then
						local targetAccountName = getElementData(targetPlayer, "account:username")
						local targetPlayerName = getPlayerName(targetPlayer):gsub("_", " ")
						local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)

						issuePunishment(thePlayer, targetPlayer, points)
						exports.global:sendMessage("[PUNISHMENT] " .. thePlayerName .. " has issued " .. points .. " points to " .. targetPlayerName .. " (" .. targetPlayerName .. ").", 255, 0, 0, "punish")
						exports.global:sendMessage("[PUNISHMENT] Reason: " .. theReason, 255, 0, 0, "punish")
					else
						outputChatBox("ERROR: You can not punish a staff member!", thePlayer, 255, 0, 0)
					end
				else
					outputChatBox("Why are you trying to punish yourself? Miss me with that kinky shit.", thePlayer, 255, 0, 0)
				end
			end
		else
			outputChatBox("ERROR: Points must be between 1 and 10!", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("qpunish", qpunishPlayer)

-- /unban [Target Player] - by Skully (31/08/17) [Trial Admin]
function unbanPlayer(thePlayer, commandName, targetAccountName)
	if exports.global:isPlayerTrialAdmin(thePlayer) then
		if not (targetAccountName) or not tostring(targetAccountName) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Account Name]", thePlayer, 75, 230, 10)
		else

			local allBans = getBans()
			local removedBan = false

			for i, bannedPlayer in ipairs(allBans) do
				local bannedPlayerNick = getBanNick(bannedPlayer)
				if (bannedPlayerNick) == tostring(targetAccountName) then
					removeBan(bannedPlayer)
					removedBan = true
					break
				end
			end

			if (removedBan) then
				local bannedAccountID = mysql:QueryString("SELECT `id` FROM `accounts` WHERE `username` = (?);", targetAccountName); bannedAccountID = tonumber(bannedAccountID)
				local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
				local thePlayerAccountID = getElementData(thePlayer, "account:id")
				local timeNow = exports.global:getCurrentTime()
				local affectedElements = {thePlayer, "ACC" .. thePlayerAccountID}

				exports.logs:addLog(thePlayer, 16, affectedElements, "Unbanned " .. targetAccountName .. ".")
				-- Add history entry.
				mysql:Execute("INSERT INTO `accounts_history` (`id`, `account`, `date_issued`, `length`, `points`, `reason`, `issuer`) VALUES (NULL, (?), (?), (?), (?), (?), (?))", bannedAccountID, timeNow[3], -1, -1, "ACCOUNT UNBANNED", thePlayerAccountID)
				
				-- Outputs.
				exports.global:sendMessageToAdmins("[UNBAN] " .. thePlayerName .. " has unbanned " .. targetAccountName .. ".")
				outputChatBox("You have unbanned " .. targetAccountName .. ".", thePlayer, 75, 230, 10)
			else
				outputChatBox("ERROR: That player is not banned!", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("unban", unbanPlayer)

-- /warn [Target Player] [Reason] - by Zil (10/03/2018) [Trial Admin]
function issueWarning(thePlayer, commandName, target, ...)
	if exports.global:isPlayerTrialAdmin(thePlayer) then
		if not (target) or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player/ID] [Reason]", thePlayer, 75, 230, 10)
		else
			local targetPlayer = exports.global:getPlayerFromPartialNameOrID(target, thePlayer)

			if (targetPlayer) and (getElementData(targetPlayer, "loggedin") == 1) then
				if (targetPlayer ~= thePlayer) then
					local targetPlayerRank = getElementData(targetPlayer, "staff:rank")
					local thePlayerRank = getElementData(thePlayer, "staff:rank")

					if (targetPlayerRank == 0) or (thePlayerRank > targetPlayerRank) and (thePlayerRank >= 5) then
						local warnAmount = getElementData(targetPlayer, "account:warns")
						local newWarnAmount = warnAmount + 1
						local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
						local targetAccountName = getElementData(targetPlayer, "account:username")
						local targetPlayerName = getPlayerName(targetPlayer):gsub("_", " ")
						local accountID = getElementData(targetPlayer, "account:id")
						local theReason = table.concat({...}, " ")
						local affectedElements = {thePlayer, targetPlayer}

						exports.blackhawk:setElementDataEx(targetPlayer, "account:warns", newWarnAmount, true)
						exports.logs:addLog(thePlayer, 16, affectedElements, "Issued a warning to " .. targetAccountName .. " for the following reason: " .. theReason)

						exports.global:sendMessage("[WARNING] " .. thePlayerName .. " has issued a warning to " .. targetPlayerName .. " (" .. targetPlayerName .. ").", 255, 0, 0, "punish")
						exports.global:sendMessage("[WARNING] Reason: " .. theReason, 255, 0, 0, "punish")

						if (newWarnAmount % 3 == 0) then
							-- Issue a point every 3 warnings.
							mysql:Execute("UPDATE `accounts` SET `warns` = (?) WHERE `id` = (?);", newWarnAmount, accountID)
							issuePunishment(thePlayer, targetPlayer, 1, "Reached 3 consecutive warnings.")
							exports.global:sendMessageToStaff("[AUTO PUNISHMENT] 1 point issued for reaching 3 consecutive warnings.")
						end
					else
						outputChatBox("ERROR: You can not punish a staff member!", thePlayer, 255, 0, 0)
					end
				else
					outputChatBox("Why are you trying to give yourself a warning?", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("warn", issueWarning)

-- /opunish [Target Account Name] [Points] [Reason] - by Zil (10/03/2018) [Trial Admin]
function offlinePunish(thePlayer, commandName, targetAccountName, points, ...)
	if (exports.global:isPlayerTrialAdmin(thePlayer)) then
		if not (targetAccountName) or not (...) or not tonumber(points) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Account Name] [Points] [Reason]", thePlayer, 75, 230, 10)
		else
			local points = tonumber(points)
			if (points >= 1) and (points <= 10) then
				local theReason = table.concat({...}, " ")
				local points = tonumber(points)
				local targetAccountName = tostring(targetAccountName)
				local targetAccountID = exports.global:getAccountFromName(targetAccountName)

				if tonumber(targetAccountID) then
					local targetAccountID = tonumber(targetAccountID)
					local targetAccount = mysql:Query("SELECT `punishments`, `ip`, `serial`, `rank`, `username` FROM `accounts` WHERE `id` = (?);", targetAccountID)
					local targetAccountRank = targetAccount[1].rank
					local pointsAmount = targetAccount[1].punishments
					local timeNow = exports.global:getCurrentTime()
					local thePlayerRank = getElementData(thePlayer, "staff:rank")
					local thePlayerAccountID = getElementData(thePlayer, "account:id")
					local newPoints = pointsAmount + points
					local affectedElements = {thePlayer, "ACC" .. targetAccountID}

					if (targetAccountRank == 0) or (thePlayerRank > targetAccountRank) and (thePlayerRank >= 5) then
						local length = 0

						if (newPoints < 10) then
						length = banLength[newPoints] -- Retrieve ban length from the table above in seconds.
						end

						mysql:Execute("UPDATE `accounts` SET `punishments` = (?) WHERE `id` = (?);", newPoints, targetAccountID)
						mysql:Execute("INSERT INTO `accounts_history` (`id`, `account`, `date_issued`, `length`, `points`, `reason`, `issuer`) VALUES (NULL, (?), (?), (?), (?), (?), (?))", targetAccountID, timeNow[3], length, points, theReason, thePlayerAccountID)
						
						local targetAccountIP = targetAccount[1].ip
						local targetAccountSerial = targetAccount[1].serial
						local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
						local targetAccountUsername = targetAccount[1].username
						addBan(targetAccountIP, targetAccountUsername, targetAccountSerial, thePlayer, theReason, length)

						exports.logs:addLog(thePlayer, 16, affectedElements, "Offline punished " .. targetAccountName .. " for " .. points .. " points with the reason: " .. theReason)
						exports.global:sendMessage("[OFFLINE PUNISHMENT] " .. thePlayerName .. " has issued " .. points .. " points to " .. targetAccountName .. ".", 255, 0, 0, "punish")
						exports.global:sendMessage("[OFFLINE PUNISHMENT] Reason: " .. theReason, 255, 0, 0, "punish")
						return true
					else
						outputChatBox("ERROR: " .. targetAccountName .. " is a staff member, you can not punish them!", thePlayer, 255, 0, 0)
						return false
					end
				end
				outputChatBox("ERROR: No accounts matching that name found.", thePlayer, 255, 0, 0)
			else
				outputChatBox("ERROR: Points must be between 1 and 10!", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("opunish", offlinePunish)

-- /owarn [Target Account Name] [Reason] - by Zil (11/03/2018) [Trial Admin]
function offlineWarn(thePlayer, commandName, targetAccountName, ...)
	if (exports.global:isPlayerTrialAdmin(thePlayer)) then
		if not (targetAccountName) or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Account Name] [Reason]", thePlayer, 75, 230, 10)
		else
			local theReason = table.concat({...}, " ")
			local targetAccountName = tostring(targetAccountName)
			local targetAccountID = exports.global:getAccountFromName(targetAccountName)

			if tonumber(targetAccountID) then
				local targetAccountID = tonumber(targetAccountID)
				local targetAccount = mysql:Query("SELECT `warns`, `punishments`, `ip`, `serial`, `rank`, `username` FROM `accounts` WHERE `id` = (?);", targetAccountID)
				local targetAccountRank = targetAccount[1].rank
				local warnAmount = targetAccount[1].warns
				local targetAccountUsername = targetAccount[1].username
				local timeNow = exports.global:getCurrentTime()
				local thePlayerRank = getElementData(thePlayer, "staff:rank")
				local thePlayerAccountID = getElementData(thePlayer, "account:id")
				local newWarnAmount = warnAmount + 1
				local affectedElements = {thePlayer, "ACC" .. targetAccountID}

				if (targetAccountRank == 0) or (thePlayerRank > targetAccountRank) and (thePlayerRank >= 5) then
					local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)

					mysql:Execute("UPDATE `accounts` SET `warns` = (?) WHERE `id` = (?);", newWarnAmount, targetAccountID)
					mysql:Execute("INSERT INTO `accounts_history` (`id`, `account`, `date_issued`, `length`, `points`, `reason`, `issuer`) VALUES (NULL, (?), (?), (?), (?), (?), (?))", targetAccountID, timeNow[3], -1, -1, theReason, thePlayerAccountID)

					exports.logs:addLog(thePlayer, 16, affectedElements, "Offline warned " .. targetAccountName .. " with the reason: " .. theReason)
					exports.global:sendMessage("[OFFLINE WARNING] " .. thePlayerName .. " has issued a warning to " .. targetAccountName .. ".", 255, 0, 0, "punish")
					exports.global:sendMessage("[OFFLINE WARNING] Reason: " .. theReason, 255, 0, 0, "punish")

					if (newWarnAmount % 3 == 0) then
						local targetPoints = targetAccount[1].punishments
						local targetAccountIP = targetAccount[1].ip
						local targetAccountSerial = targetAccount[1].serial
						local newPoints = targetPoints + 1
						local length = 0

						if (newPoints < 10) then
							length = banLength[newPoints] -- Retrieve ban length from the table above in seconds.
						end

						mysql:Execute("INSERT INTO `accounts_history` (`id`, `account`, `date_issued`, `length`, `points`, `reason`, `issuer`) VALUES (NULL, (?), (?), (?), (?), (?), (?))", targetAccountID, timeNow[3], length, 1, "Reached 3 consecutive warnings.", thePlayerAccountID)
						mysql:Execute("UPDATE `accounts` SET `punishments` = (?) WHERE `id` = (?);", newPoints, targetAccountID)
						exports.global:sendMessageToStaff("[AUTO PUNISHMENT] 1 point issued for reaching 3 consecutive warnings.")

						addBan(targetAccountIP, targetAccountUsername, targetAccountSerial, thePlayer, theReason, length)
						return true
					end
				else
					outputChatBox("ERROR: " .. targetAccountName .. " is a staff member, you can not warn them!", thePlayer, 255, 0, 0)
					return false
				end
			else
				outputChatBox("ERROR: No accounts matching name found.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("owarn", offlineWarn)

-- /history (Account Name) - By Skully (11/03/18) [Player/Trial Admin]
function showAccountHistory(thePlayer, c, accountName)
	local loggedin = getElementData(thePlayer, "loggedin")
	if (loggedin == 1) or (loggedin == 2) then

		local accountID = getElementData(thePlayer, "account:id")
		local theAccountName = getElementData(thePlayer, "account:username")

		if (accountName) then
			if exports.global:isPlayerTrialAdmin(thePlayer) then 
				local targetAccountID = exports.global:getAccountFromName(accountName)

				-- Check to see if the provided account exists.
				if not (targetAccountID) then
					outputChatBox("ERROR: An account with the name '" .. accountName .. "' does not exist!", thePlayer, 255, 0, 0)
					return false
				end

				accountID = targetAccountID
				theAccountName = exports.global:getAccountNameFromID(accountID)
			end
		end
		
		local historyTable = exports.mysql:Query("SELECT * FROM `accounts_history` WHERE `account` = (?);", accountID)
		if (historyTable) then

			local tableToSend = {}

			for i, entry in ipairs(historyTable) do
				local timeIssuedParsed = exports.global:convertTime(historyTable[i].date_issued)
				local issuerName = exports.global:getAccountNameFromID(historyTable[i].issuer)
				
				local lengthParsed = historyTable[i].length
				if (lengthParsed) == 0 then
					lengthParsed = "Permanent"
				elseif (lengthParsed) == -1 then
					lengthParsed = "N/A"
				else
					lengthParsed = historyTable[i].length .. " Hours"
				end

				local pointsParsed = historyTable[i].points
				if (pointsParsed) == -1 then
					historyTable[i].points = "N/A"
				end
				
				tableToSend[i] = {
					[1] = historyTable[i].id,
					[2] = timeIssuedParsed[2] .. " at " .. timeIssuedParsed[1],
					[3] = issuerName,
					[4] = historyTable[i].reason,
					[5] = lengthParsed,
					[6] = historyTable[i].points,
				}
			end

			triggerClientEvent(thePlayer, "admin:showAccountHistory", thePlayer, tableToSend, theAccountName)
		else
			outputDebugString("[admin-system] @showAccountHistory[XXX]: Failed to fetch historyTable for account '" .. accountName .. "'.", 3)
			outputChatBox("ERROR: Something went wrong whilst fetching account history!", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("history", showAccountHistory)
addEvent("admin:s_showAccountHistory", true)
addEventHandler("admin:s_showAccountHistory", root, showAccountHistory)

-- This function is called from the client when an administrator attempts to remove a history entry through the /history GUI.
function removeHistoryEntry(thePlayer, historyID)
	if not (thePlayer) or not tonumber(historyID) then
		outputDebugString("[admin-system] thePlayer or historyID not received.", 3)
		return false
	end

	-- Ensure the history entry exists.
	local historyData = exports.mysql:Query("SELECT `issuer`, `account` FROM `accounts_history` WHERE `id` = (?);", historyID)
	if not (historyData[1].account) then
		outputChatBox("ERROR: The history entry you're attempting to remove doesn't exist!", thePlayer, 255, 0, 0)
		return false
	end

	-- Prevent those who aren't managers from removing other administrator's history entries.
	local staffLevel = getElementData(thePlayer, "staff:rank")
	if (staffLevel < 5) then
		local accountID = getElementData(thePlayer, "account:id")
		if (accountID ~= tonumber(historyData[1].issuer)) then
			outputChatBox("ERROR: Only the issuing administrator can remove this history entry!", thePlayer, 255, 0, 0)
			return false
		end
	end

	local removed = exports.mysql:Execute("DELETE FROM `accounts_history` WHERE `id` = (?);", historyID)
	if (removed) then
		local targetAccountName = exports.global:getAccountNameFromID(historyData[1].account)
		local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
		local affectedElements = {thePlayer, "ACC" .. accountID}

		outputChatBox("You have removed history entry #" .. historyID .. " from the account '" .. targetAccountName .. "'.", thePlayer, 0, 255, 0)
		exports.logs:addLog(thePlayer, 16, affectedElements, "Removed history entry #" .. historyID .. " from the account " .. targetAccountName .. ".")
		exports.global:sendMessage("[HISTORY] " .. thePlayerName .. " has removed history entry #" .. historyID .. " from the account '" .. targetAccountName .. "'.", true, 2)
	else
		outputChatBox("ERROR: Something went wrong whilst attempting to remove that history entry!", thePlayer, 255, 0, 0)
	end
end
addEvent("admin:removeHistoryEntry", true)
addEventHandler("admin:removeHistoryEntry", root, removeHistoryEntry)