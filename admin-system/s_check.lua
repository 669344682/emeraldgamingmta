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

-- /check [Player/ID] - By Skully (11/03/18) [Trial Admin]
-- NOTE: This function's command handler is located in c_check.lua within the function c_checkPlayer since "check" is a default MTA server-sided command.
function s_checkPlayer(thePlayer, commandName, targetPlayer)
	if exports.global:isPlayerTrialAdmin(thePlayer, true) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player/ID]", thePlayer, 75, 230, 10)
			return false
		end

		local targetPlayer = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)

		if (targetPlayer) then
			local targetAccountID = getElementData(targetPlayer, "account:id")
			local targetCharacterID = getElementData(targetPlayer, "character:id")

			local adminNote = exports.mysql:QueryString("SELECT `anote` FROM `accounts` WHERE `id` = (?);", targetAccountID)
			local playerIP = getPlayerIP(targetPlayer)

			local accountData = {adminNote, playerIP}
			local characterData = exports.mysql:Query("SELECT * FROM `accounts` WHERE `id` = (?);", targetCharacterID)

			triggerClientEvent(thePlayer, "admin:showCheckGUI", thePlayer, targetPlayer, accountData, characterData)
		end
	end
end
addEvent("admin:s_checkPlayer", true)
addEventHandler("admin:s_checkPlayer", root, s_checkPlayer)

-- This function is triggered from the client when the player attempts to update an account's admin note.
function updateAdminNote(thePlayer, targetPlayer, note)
	if not (thePlayer) or not (targetPlayer) then
		outputDebugString("[admin-system] @updateAdminNote: thePlayer or targetPlayer not received.", 3)
		outputChatBox("ERROR: Something went wrong whilst saving the note!", thePlayer, 255, 0, 0)
		return false
	end

	if not tostring(note) then
		outputChatBox("ERROR: The note contains invalid characters or is longer than 500 characters!", thePlayer, 255, 0, 0)
		return false
	end

	if (string.len(note) > 500) then
		outputChatBox("Looks like the note contains more than 500 characters, please shorten it down and try update it again.", thePlayer, 255, 0, 0)
		return false
	end

	local targetAccountID = getElementData(targetPlayer, "account:id")
	if not tonumber(targetAccountID) then
		outputChatBox("ERROR: The player has logged out, note could not be saved!", thePlayer, 255, 0, 0)
		return false
	end

	local affectedElements = {thePlayer, targetPlayer}
	local result = exports.mysql:Execute("UPDATE `accounts` SET `anote` = (?) WHERE `id` = (?);", note, targetAccountID)
	if (result) then
		local targetAccountName = getElementData(targetPlayer, "account:username") or "Unknown"
		outputChatBox("You have successfully updated the note for account '" .. targetAccountName .. "'.", thePlayer, 75, 230, 10)

		local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
		exports.global:sendMessageToManagers("[INFO] " .. thePlayerName .. " has updated " .. targetAccountName .. "'s admin note.")
		exports.logs:addLog(thePlayer, 1, affectedElements, "Updated " .. targetAccountName .. "'s admin note to: " .. note)
	else
		outputChatBox("ERROR: Something went wrong whilst attempting to save the note!", thePlayer, 255, 0, 0)
	end
end
addEvent("admin:updateCheckNote", true)
addEventHandler("admin:updateCheckNote", root, updateAdminNote)