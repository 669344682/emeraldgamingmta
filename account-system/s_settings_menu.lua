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

function updateSettingsData(thePlayer, group, dataTable)
	if not (thePlayer) then
		outputDebugString("[account-system] @updateSettingsData: Attempted to save account settings of player that doesn't exist.", 3)
		return false
	end

	-- For the following elementData and their meanings, see Wiki page regarding this specific data.
	-- https://github.com/ItsZil/emeraldgaming/wiki/Saved-Element-Data#account-settings

	local groupName = false
	if (group == 1) then groupName = "general"
		elseif (group == 2) then groupName = "account"
		elseif (group == 3) then groupName = "notification"
		elseif (group == 4) then groupName = "graphics"
	end

	if (groupName) then
		for i, v in ipairs(dataTable) do
			setElementData(thePlayer, "settings:" .. groupName .. ":setting" .. i, dataTable[i], true)
		end
	else
		outputDebugString("[account-system] @updateSettingsData: Invalid group ID received.", 3)
		return false
	end
	triggerClientEvent(thePlayer, "account:c_implementSettings", thePlayer)
end
addEvent("account:updateSettingsData", true)
addEventHandler("account:updateSettingsData", getRootElement(), updateSettingsData)


function loadAccountSettings(thePlayer)
	triggerClientEvent(thePlayer, "account:c_loadAccountSettings", thePlayer)
end


function loadAccountSettingsCallback(thePlayer, settingsTable)
	if not (thePlayer) then
		outputDebugString("[account-system] @updateSettingsData: Attempted to save account settings of player that doesn't exist.", 3)
		return false
	end

	for i, v in ipairs(settingsTable[1]) do
		setElementData(thePlayer, "settings:general:setting" .. i, tonumber(settingsTable[1][i]), true)
	end

	for i, v in ipairs(settingsTable[2]) do
		setElementData(thePlayer, "settings:account:setting" .. i, tonumber(settingsTable[2][i]), true)
	end

	for i, v in ipairs(settingsTable[3]) do
		setElementData(thePlayer, "settings:notification:setting" .. i, tonumber(settingsTable[3][i]), true)
	end

	for i, v in ipairs(settingsTable[4]) do
		setElementData(thePlayer, "settings:graphics:setting" .. i, tonumber(settingsTable[4][i]), true)
	end
end
addEvent("account:loadAccountSettings", true)
addEventHandler("account:loadAccountSettings", getRootElement(), loadAccountSettingsCallback)