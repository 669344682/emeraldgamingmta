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

mysql = exports.mysql
blackhawk = exports.blackhawk

-- Function that loads the account data for the specified player.
function loadAccountData(thePlayer, accountID)
	if not (thePlayer) then
		outputDebugString("[account-system] @account_loadAccountData: thePlayer not specified.", 3)
		return false
	end
	if not tonumber(accountID) then -- If no account ID is given, attempt to get thePlayer's account ID ourselves.
		local accountID = getElementData(thePlayer, "account:id")
		if not (accountID) then -- If they don't have any account ID attached to them.
			outputDebugString("[account-system] @account_loadAccountData: accountID not specified for " .. getPlayerName(thePlayer)..".", 3)
			return false
		end
	end

	-- Grab all content for elementData.
	local accountData = mysql:Query("SELECT * FROM `accounts` WHERE `id` = (?);", accountID)

	-- Username and accountID is set by login-system on player login.
	local rank = tonumber(accountData[1].rank)
	local developer = tonumber(accountData[1].developer)
	local vehicleteam = tonumber(accountData[1].vehicleteam)
	local factionteam = tonumber(accountData[1].factionteam)
	local mappingteam = tonumber(accountData[1].mappingteam)
	local muted = tonumber(accountData[1].muted)
	local reports = tonumber(accountData[1].reports)
	local warns = tonumber(accountData[1].warns)
	local emeralds = tonumber(accountData[1].emeralds)
	local punishments = tonumber(accountData[1].punishments)
	local accHours = mysql:Query("SELECT `hours` FROM `characters` WHERE `account` = (?);", accountID)
	local totalHours = 0
	for i, key in ipairs(accHours) do
		totalHours = totalHours + tonumber(accHours[i].hours)
	end

	blackhawk:setElementDataEx(thePlayer, "staff:rank", rank, true)
	blackhawk:setElementDataEx(thePlayer, "staff:developer", developer, true)
	blackhawk:setElementDataEx(thePlayer, "staff:vt", vehicleteam, true)
	blackhawk:setElementDataEx(thePlayer, "staff:ft", factionteam, true)
	blackhawk:setElementDataEx(thePlayer, "staff:mt", mappingteam, true)
	blackhawk:setElementDataEx(thePlayer, "account:muted", muted, true)
	blackhawk:setElementDataEx(thePlayer, "account:reports", reports, true)
	blackhawk:setElementDataEx(thePlayer, "account:warns", warns, true)
	blackhawk:setElementDataEx(thePlayer, "account:emeralds", emeralds, true)
	blackhawk:setElementDataEx(thePlayer, "account:punishments", punishments, true)
	blackhawk:setElementDataEx(thePlayer, "account:hours", totalHours, true)
	blackhawk:setElementDataEx(thePlayer, "account:timeinserver", 0, false, true)

	-- Temporary set data so it can be used by character selection.
	local tempLoginTime = tostring(accountData[1].lastlogin)
	local emailAddress = tostring(accountData[1].email)
	local registrationDate = tostring(accountData[1].registered)
	blackhawk:setElementDataEx(thePlayer, "temp:account:lastlogin", tempLoginTime, true)
	blackhawk:setElementDataEx(thePlayer, "temp:account:email", emailAddress, true)
	blackhawk:setElementDataEx(thePlayer, "temp:account:registerdate", registrationDate, true)

	loadAccountSettings(thePlayer) -- Loads account settings.

	-- Send all reports from server to clientside for proper report panel function.
	if (rank > 0) or (developer > 0) or (vehicleteam > 0) or (factionteam > 0) or (mappingteam > 0) then
		triggerEvent("report:sendReportsToClient", getRootElement(), thePlayer) -- Triggers an event in s_reports.lua that goes through all reports and adds them to clientside.
	end
end
addEvent("account:loadAccountData", true)
addEventHandler("account:loadAccountData", getRootElement(), loadAccountData)