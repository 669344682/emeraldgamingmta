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

--[[ 											[Identifiers & Rank]

1 = Staff Rank 						2 = Vehicle Team 				3 = Mapping Team 				4 = Faction Team
	1 - Lead Manager					1 - VT Leader					1 - MT Leader					1 - FT Leader
	2 - Manager							2 - VT Member					2 - MT Member					2 - FT Member
	3 - Lead Administrator				3 - No Rank  					3 - No Rank						3 - No Rank
	4 - Administrator
	5 - Trial Administrator
	6 - Helper
	7 - No Rank

5 = Developer Rank
	1 - Lead Developer
	2 - Developer
	3 - Trial Developer
	4 - No Rank

]]

function applyRankAdjustment(thePlayer, identifier, rank, accountID)
	local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
	local targetPlayer = exports.global:getPlayerFromAccountID(accountID)
	local rankGroup, rankName

	if (identifier == 1) then -- Staff Team
		rankGroup = "Staff Rank"
		if (rank == 1) then
			rankName = "Lead Manager"
			if (currentStaffRank ~= 6) then
				if exports.global:isPlayerLeadManager(thePlayer, true) or exports.global:isPlayerLeadDeveloper(thePlayer, true) then
					exports.mysql:Execute("UPDATE `accounts` SET `rank` = (?) WHERE `accounts`.`id` = (?);", 6, accountID)
					if (targetPlayer) then
						exports.blackhawk:setElementDataEx(targetPlayer, "staff:rank", 6, true)
						exports.global:setPlayerTitles(targetPlayer)
					end
				else
					triggerClientEvent(thePlayer, "staffSetFeedbackLabel", thePlayer, "You lack the permissions to do that!", 255, 0, 0)
					return false
				end
			else
				triggerClientEvent(thePlayer, "staffSetFeedbackLabel", thePlayer, "That player is already a " .. rankName .. "!", 255, 0, 0)
				return false
			end
		elseif(rank == 2) then
			rankName = "Manager"
			if (currentStaffRank ~= 5) then
				if exports.global:isPlayerLeadManager(thePlayer, true) or exports.global:isPlayerLeadDeveloper(thePlayer, true) then
					exports.mysql:Execute("UPDATE `accounts` SET `rank` = (?) WHERE `accounts`.`id` = (?);", 5, accountID)
					if (targetPlayer) then
						exports.blackhawk:setElementDataEx(targetPlayer, "staff:rank", 5, true)
						exports.global:setPlayerTitles(targetPlayer)
					end
				else
					triggerClientEvent(thePlayer, "staffSetFeedbackLabel", thePlayer, "You lack the permissions to do that!", 255, 0, 0)
					return false
				end
			else
				triggerClientEvent(thePlayer, "staffSetFeedbackLabel", thePlayer, "That player is already a " .. rankName .. "!", 255, 0, 0)
				return false
			end
		elseif(rank == 3) then
			rankName = "Lead Administrator"
			if (currentStaffRank ~= 4) then
				if exports.global:isPlayerManager(thePlayer, true) or exports.global:isPlayerLeadDeveloper(thePlayer, true) then
					exports.mysql:Execute("UPDATE `accounts` SET `rank` = (?) WHERE `accounts`.`id` = (?);", 4, accountID)
					if (targetPlayer) then
						exports.blackhawk:setElementDataEx(targetPlayer, "staff:rank", 4, true)
						exports.global:setPlayerTitles(targetPlayer)
					end
				else
					triggerClientEvent(thePlayer, "staffSetFeedbackLabel", thePlayer, "You lack the permissions to do that!", 255, 0, 0)
					return false
				end
			else
				triggerClientEvent(thePlayer, "staffSetFeedbackLabel", thePlayer, "That player is already a " .. rankName .. "!", 255, 0, 0)
				return
			end
		elseif(rank == 4) then
			rankName = "Administrator"
			if (currentStaffRank ~= 3) then
				if exports.global:isPlayerManager(thePlayer, true) or exports.global:isPlayerLeadDeveloper(thePlayer, true) then
					exports.mysql:Execute("UPDATE `accounts` SET `rank` = (?) WHERE `accounts`.`id` = (?);", 3, accountID)
					if (targetPlayer) then
						exports.blackhawk:setElementDataEx(targetPlayer, "staff:rank", 3, true)
						exports.global:setPlayerTitles(targetPlayer)
					end
				else
					triggerClientEvent(thePlayer, "staffSetFeedbackLabel", thePlayer, "You lack the permissions to do that!", 255, 0, 0)
					return false
				end
			else
				triggerClientEvent(thePlayer, "staffSetFeedbackLabel", thePlayer, "That player is already a " .. rankName .. "!", 255, 0, 0)
				return false
			end
		elseif(rank == 5) then
			rankName = "Trial Administrator"
			if (currentStaffRank ~= 2) then
				if exports.global:isPlayerManager(thePlayer, true) or exports.global:isPlayerLeadDeveloper(thePlayer, true) then
					exports.mysql:Execute("UPDATE `accounts` SET `rank` = (?) WHERE `accounts`.`id` = (?);", 2, accountID)
					if (targetPlayer) then
						exports.blackhawk:setElementDataEx(targetPlayer, "staff:rank", 2, true)
						exports.global:setPlayerTitles(targetPlayer)
					end
				else
					triggerClientEvent(thePlayer, "staffSetFeedbackLabel", thePlayer, "You lack the permissions to do that!", 255, 0, 0)
					return false
				end
			else
				triggerClientEvent(thePlayer, "staffSetFeedbackLabel", thePlayer, "That player is already a " .. rankName .. "!", 255, 0, 0)
				return false
			end
		elseif(rank == 6) then
			rankName = "Helper"
			if (currentStaffRank ~= 1) then
				if exports.global:isPlayerManager(thePlayer, true) or exports.global:isPlayerLeadDeveloper(thePlayer, true) then
					exports.mysql:Execute("UPDATE `accounts` SET `rank` = (?) WHERE `accounts`.`id` = (?);", 1, accountID)
					if (targetPlayer) then
						exports.blackhawk:setElementDataEx(targetPlayer, "staff:rank", 1, true)
						exports.global:setPlayerTitles(targetPlayer)
					end
				else
					triggerClientEvent(thePlayer, "staffSetFeedbackLabel", thePlayer, "You lack the permissions to do that!", 255, 0, 0)
					return false
				end
			else
				triggerClientEvent(thePlayer, "staffSetFeedbackLabel", thePlayer, "That player is already a " .. rankName .. "!", 255, 0, 0)
				return false
			end
		else
			rankName = nil
			if (currentStaffRank ~= 0) then
				if exports.global:isPlayerManager(thePlayer, true) or exports.global:isPlayerLeadDeveloper(thePlayer, true) then
					exports.mysql:Execute("UPDATE `accounts` SET `rank` = (?) WHERE `accounts`.`id` = (?);", 0, accountID)
					if (targetPlayer) then
						exports.blackhawk:setElementDataEx(targetPlayer, "staff:rank", 0, true)
						exports.global:setPlayerTitles(targetPlayer)
					end
				else
					triggerClientEvent(thePlayer, "staffSetFeedbackLabel", thePlayer, "You lack the permissions to do that!", 255, 0, 0)
					return false
				end
			else
				triggerClientEvent(thePlayer, "staffSetFeedbackLabel", thePlayer, "That player is already not a part of that team!", 255, 0, 0)
				return false
			end
		end
	elseif (identifier == 2) then -- Vehicle Team
		rankGroup = "Vehicle Team rank"
		if(rank == 1) then
			rankName = "Vehicle Team Leader"
			if (currentVTRank ~= 2) then
				if exports.global:isPlayerManager(thePlayer, true) or exports.global:isPlayerLeadDeveloper(thePlayer, true) then
					exports.mysql:Execute("UPDATE `accounts` SET `vehicleteam` = (?) WHERE `accounts`.`id` = (?);", 2, accountID)
					if (targetPlayer) then
						exports.blackhawk:setElementDataEx(targetPlayer, "staff:vt", 2, true)
						exports.global:setPlayerTitles(targetPlayer)
					end
				else
					triggerClientEvent(thePlayer, "staffSetFeedbackLabel", thePlayer, "You lack the permission to do that!", 255, 0, 0)
					return false
				end
			else
				triggerClientEvent(thePlayer, "staffSetFeedbackLabel", thePlayer, "That player is already a " .. rankName .. "!", 255, 0, 0)
				return false
			end
		elseif(rank == 2) then
			rankName = "Vehicle Team Member"
			if (currentVTRank ~= 1) then
				if exports.global:isPlayerManager(thePlayer, true) or exports.global:isPlayerLeadDeveloper(thePlayer, true) or exports.global:isPlayerVehicleTeamLeader(thePlayer, true) then
					exports.mysql:Execute("UPDATE `accounts` SET `vehicleteam` = (?) WHERE `accounts`.`id` = (?);", 1, accountID)
					if (targetPlayer) then
						exports.blackhawk:setElementDataEx(targetPlayer, "staff:vt", 1, true)
						exports.global:setPlayerTitles(targetPlayer)
					end
				else
					triggerClientEvent(thePlayer, "staffSetFeedbackLabel", thePlayer, "You lack the permission to do that!", 255, 0, 0)
					return false
				end
			else
				triggerClientEvent(thePlayer, "staffSetFeedbackLabel", thePlayer, "That player is already a " .. rankName .. "!", 255, 0, 0)
				return false
			end
		else
			rankName = nil
			if (currentVTRank ~= 0) then
				if exports.global:isPlayerManager(thePlayer, true) or exports.global:isPlayerLeadDeveloper(thePlayer, true) or exports.global:isPlayerVehicleTeamLeader(thePlayer, true) then
					exports.mysql:Execute("UPDATE `accounts` SET `vehicleteam` = (?) WHERE `accounts`.`id` = (?);", 0, accountID)
					if (targetPlayer) then
						exports.blackhawk:setElementDataEx(targetPlayer, "staff:vt", 0, true)
						exports.global:setPlayerTitles(targetPlayer)
					end
				else
					triggerClientEvent(thePlayer, "staffSetFeedbackLabel", thePlayer, "You lack the permission to do that!", 255, 0, 0)
					return false
				end
			else
				triggerClientEvent(thePlayer, "staffSetFeedbackLabel", thePlayer, "That player is already not a part of that team!", 255, 0, 0)
				return false
			end
		end
	elseif (identifier == 3) then -- Mapping Team
		rankGroup = "Mapping Team rank"
		if(rank == 1) then
			rankName = "Mapping Team Leader"
			if (currentMTRank ~= 2) then
				if exports.global:isPlayerManager(thePlayer, true) or exports.global:isPlayerLeadDeveloper(thePlayer, true) then	
					exports.mysql:Execute("UPDATE `accounts` SET `mappingteam` = (?) WHERE `accounts`.`id` = (?);", 2, accountID)
					if (targetPlayer) then
						exports.blackhawk:setElementDataEx(targetPlayer, "staff:mt", 2, true)
						exports.global:setPlayerTitles(targetPlayer)
					end
				else
					triggerClientEvent(thePlayer, "staffSetFeedbackLabel", thePlayer, "You lack the permission to do that!", 255, 0, 0)
					return false
				end
			else
				triggerClientEvent(thePlayer, "staffSetFeedbackLabel", thePlayer, "That player is already a " .. rankName .. "!", 255, 0, 0)
				return false
			end
		elseif(rank == 2) then
			rankName = "Mapping Team Member"
			if (currentMTRank ~= 1) then
				if exports.global:isPlayerManager(thePlayer, true) or exports.global:isPlayerLeadDeveloper(thePlayer, true) or exports.global:isPlayerMappingTeamLeader(thePlayer, true) then
					exports.mysql:Execute("UPDATE `accounts` SET `mappingteam` = (?) WHERE `accounts`.`id` = (?);", 1, accountID)
					if (targetPlayer) then
						exports.blackhawk:setElementDataEx(targetPlayer, "staff:mt", 1, true)
						exports.global:setPlayerTitles(targetPlayer)
					end
				else
					triggerClientEvent(thePlayer, "staffSetFeedbackLabel", thePlayer, "You lack the permission to do that!", 255, 0, 0)
					return false
				end
			else
				triggerClientEvent(thePlayer, "staffSetFeedbackLabel", thePlayer, "That player is already a " .. rankName .. "!", 255, 0, 0)
				return false
			end
		else
			rankName = nil
			if (currentMTRank ~= 0) then
				if exports.global:isPlayerManager(thePlayer, true) or exports.global:isPlayerLeadDeveloper(thePlayer, true) or exports.global:isPlayerMappingTeamLeader(thePlayer, true) then
					exports.mysql:Execute("UPDATE `accounts` SET `mappingteam` = (?) WHERE `accounts`.`id` = (?);", 0, accountID)
					if (targetPlayer) then
						exports.blackhawk:setElementDataEx(targetPlayer, "staff:mt", 0, true)
						exports.global:setPlayerTitles(targetPlayer)
					end
				else
					triggerClientEvent(thePlayer, "staffSetFeedbackLabel", thePlayer, "You lack the permission to do that!", 255, 0, 0)
					return false
				end
			else
				triggerClientEvent(thePlayer, "staffSetFeedbackLabel", thePlayer, "That player is already not a part of that team!", 255, 0, 0)
				return false
			end
		end
	elseif (identifier == 4) then -- Faction Team
		rankGroup = "Faction Team rank"
		if (rank == 1) then
			rankName = "Faction Team Leader"
			if (currentFTRank ~= 2) then
				if exports.global:isPlayerManager(thePlayer, true) or exports.global:isPlayerLeadDeveloper(thePlayer, true) then
					exports.mysql:Execute("UPDATE `accounts` SET `factionteam` = (?) WHERE `accounts`.`id` = (?);", 2, accountID)
					if (targetPlayer) then
						exports.blackhawk:setElementDataEx(targetPlayer, "staff:ft", 2, true)
						exports.global:setPlayerTitles(targetPlayer)
					end
				else
					triggerClientEvent(thePlayer, "staffSetFeedbackLabel", thePlayer, "You lack the permission to do that!", 255, 0, 0)
					return false
				end
			else
				triggerClientEvent(thePlayer, "staffSetFeedbackLabel", thePlayer, "That player is already a " .. rankName .. "!", 255, 0, 0)
				return false
			end
		elseif (rank == 2) then
			rankName = "Faction Team Member"
			if (currentFTRank ~= 1) then
				if exports.global:isPlayerManager(thePlayer, true) or exports.global:isPlayerLeadDeveloper(thePlayer, true) or exports.global:isPlayerFactionTeamLeader(thePlayer, true) then
					exports.mysql:Execute("UPDATE `accounts` SET `factionteam` = (?) WHERE `accounts`.`id` = (?);", 1, accountID)
					if (targetPlayer) then
						exports.blackhawk:setElementDataEx(targetPlayer, "staff:ft", 1, true)
						exports.global:setPlayerTitles(targetPlayer)
					end
				else
					triggerClientEvent(thePlayer, "staffSetFeedbackLabel", thePlayer, "You lack the permission to do that!", 255, 0, 0)
					return false
				end
			else
				triggerClientEvent(thePlayer, "staffSetFeedbackLabel", thePlayer, "That player is already a " .. rankName .. "!", 255, 0, 0)
				return false
			end
		else
			rankName = nil
			if (currentFTRank ~= 0) then
				if exports.global:isPlayerManager(thePlayer, true) or exports.global:isPlayerLeadDeveloper(thePlayer, true) or exports.global:isPlayerFactionTeamLeader(thePlayer, true) then
					exports.mysql:Execute("UPDATE `accounts` SET `factionteam` = (?) WHERE `accounts`.`id` = (?);", 0, accountID)
					if (targetPlayer) then
						exports.blackhawk:setElementDataEx(targetPlayer, "staff:ft", 0, true)
						exports.global:setPlayerTitles(targetPlayer)
					end
				else
					triggerClientEvent(thePlayer, "staffSetFeedbackLabel", thePlayer, "You lack the permission to do that!", 255, 0, 0)
					return false
				end
			else
				triggerClientEvent(thePlayer, "staffSetFeedbackLabel", thePlayer, "That player is already not a part of that team!", 255, 0, 0)
				return false
			end
		end
	elseif (identifier == 5) then -- Developer Rank
		rankGroup = "Developer Rank"
		if(rank == 1) then
			rankName = "Lead Developer"
			if (currentDevRank ~= 3) then
				if exports.global:isPlayerLeadManager(thePlayer, true) or exports.global:isPlayerLeadDeveloper(thePlayer, true) then
					exports.mysql:Execute("UPDATE `accounts` SET `developer` = (?) WHERE `accounts`.`id` = (?);", 3, accountID)
					if (targetPlayer) then
						exports.blackhawk:setElementDataEx(targetPlayer, "staff:developer", 3, true)
						exports.global:setPlayerTitles(targetPlayer)
					end
				else
					triggerClientEvent(thePlayer, "staffSetFeedbackLabel", thePlayer, "You lack the permission to do that!", 255, 0, 0)
					return false
				end
			else
				triggerClientEvent(thePlayer, "staffSetFeedbackLabel", thePlayer, "That player is already a " .. rankName .. "!", 255, 0, 0)
				return false
			end
		elseif(rank == 2) then
			rankName = "Developer"
			if (currentDevRank ~= 2) then
				if exports.global:isPlayerLeadManager(thePlayer, true) or exports.global:isPlayerLeadDeveloper(thePlayer, true) then
					exports.mysql:Execute("UPDATE `accounts` SET `developer` = (?) WHERE `accounts`.`id` = (?);", 2, accountID)
					if (targetPlayer) then
						exports.blackhawk:setElementDataEx(targetPlayer, "staff:developer", 2, true)
						exports.global:setPlayerTitles(targetPlayer)
					end
				else
					triggerClientEvent(thePlayer, "staffSetFeedbackLabel", thePlayer, "You lack the permission to do that!", 255, 0, 0)
					return false
				end
			else
				triggerClientEvent(thePlayer, "staffSetFeedbackLabel", thePlayer, "That player is already a " .. rankName .. "!", 255, 0, 0)
				return false
			end
		elseif(rank == 3) then
			rankName = "Trial Developer"
			if (currentDevRank ~= 1) then
				if exports.global:isPlayerLeadManager(thePlayer, true) or exports.global:isPlayerLeadDeveloper(thePlayer, true) then
					exports.mysql:Execute("UPDATE `accounts` SET `developer` = (?) WHERE `accounts`.`id` = (?);", 1, accountID)
					if (targetPlayer) then
						exports.blackhawk:setElementDataEx(targetPlayer, "staff:developer", 1, true)
						exports.global:setPlayerTitles(targetPlayer)
					end
				else
					triggerClientEvent(thePlayer, "staffSetFeedbackLabel", thePlayer, "You lack the permission to do that!", 255, 0, 0)
					return false
				end
			else
				triggerClientEvent(thePlayer, "staffSetFeedbackLabel", thePlayer, "That player is already a " .. rankName .. "!", 255, 0, 0)
				return false
			end
		else
			rankName = nil
			if (currentDevRank ~= 0) then
				if exports.global:isPlayerLeadManager(thePlayer, true) or exports.global:isPlayerLeadDeveloper(thePlayer, true) then
					exports.mysql:Execute("UPDATE `accounts` SET `developer` = (?) WHERE `accounts`.`id` = (?);", 0, accountID)
					if (targetPlayer) then
						exports.blackhawk:setElementDataEx(targetPlayer, "staff:developer", 0, true)
						exports.global:setPlayerTitles(targetPlayer)
					end
				else
					triggerClientEvent(thePlayer, "staffSetFeedbackLabel", thePlayer, "You lack the permission to do that!", 255, 0, 0)
					return false
				end
			else
				triggerClientEvent(thePlayer, "staffSetFeedbackLabel", thePlayer, "That player is already not a part of that team!", 255, 0, 0)
				return false
			end
		end
	end

	updateRanksLabels(thePlayer, accountID)
	triggerClientEvent(thePlayer, "staffSetFeedbackLabel", thePlayer, "Rank successfully updated.", 0, 255, 0)
	
	-- Notify all staff members.
	local targetAccountName = exports.mysql:QueryString("SELECT `username` FROM `accounts` WHERE `id` = (?);", accountID)
	local affectedElements = {thePlayer, targetPlayer}
	local logMessage
	if (rankName) then
		outputChatBox("You have set " .. thePlayerName .. "'s " .. rankGroup .. " to " .. rankName .. ".", thePlayer, 75, 230, 10)
		exports.global:sendMessageToStaff("[STAFF] ".. thePlayerName .. " has set " .. targetAccountName .. "'s " .. rankGroup .. " to " .. rankName .. ".")
		logMessage = "Set " .. targetAccountName .. "'s " .. rankGroup .. " to " .. rankName .. "."
		if (targetPlayer) then
			outputChatBox("Your " .. rankGroup .. " has been set to " .. rankName .. " by " .. thePlayerName .. ".", targetPlayer, 75, 230, 10)
		end
	else
		outputChatBox("You have removed " .. thePlayerName .. "'s " .. rankGroup .. ".", thePlayer, 75, 230, 10)
		exports.global:sendMessageToStaff("[STAFF] " .. thePlayerName .. " has removed " .. targetAccountName .. "'s " .. rankGroup .. ".")
		logMessage = "Removed " .. targetAccountName .. "'s " .. rankGroup .. "."
		if (targetPlayer) then
			outputChatBox("Your " .. rankGroup .. " has been removed by " .. thePlayerName .. ".", targetPlayer, 75, 230, 10)
		end
	end
	exports.logs:addLog(thePlayer, 1, affectedElements, logMessage)
end
addEvent("staff:applyRankAdjustment", true)
addEventHandler("staff:applyRankAdjustment", getRootElement(), applyRankAdjustment)

-- Function triggered whenever a player types an account name into the /staffs GUI.
function staffsFindPlayerByName(thePlayer, accountName)
	if tostring(accountName) then
		triggerClientEvent(thePlayer, "staffSetFeedbackLabel", thePlayer, "Searching..", 255, 255, 255)
		local targetAccount = exports.global:getAccountFromName(accountName)

		if (targetAccount) then
			updateRanksLabels(thePlayer, targetAccount)
			triggerClientEvent(thePlayer, "staffSetFeedbackLabel", thePlayer, "Account '" .. accountName:gsub("^%l", string.upper) .. "' found!", 0, 255, 0)
			triggerClientEvent(thePlayer, "staffs:returnAccountID", thePlayer, targetAccount)
		else
			triggerClientEvent(thePlayer, "staffSetFeedbackLabel", thePlayer, "Account not found.", 255, 0, 0)
		end
	end
end
addEvent("staffs:staffsFindPlayerByName", true)
addEventHandler("staffs:staffsFindPlayerByName", root, staffsFindPlayerByName)

-- Function to update labels clientside.
function updateRanksLabels(thePlayer, targetAccountID)
	if not tonumber(targetAccountID) then return false end
	local accountData = exports.mysql:Query("SELECT `rank`, `developer`, `vehicleteam`, `factionteam`, `mappingteam` FROM `accounts` WHERE `id` = (?);", targetAccountID)
	local rankTable = {accountData[1].rank, accountData[1].developer, accountData[1].vehicleteam, accountData[1].factionteam, accountData[1].mappingteam}
	triggerClientEvent(thePlayer, "staffs:updateStaffLabelsCall", thePlayer, rankTable)
end