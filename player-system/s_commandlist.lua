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

-- /commands - By Skully (19/01/18) [Player]
function showCommandList(thePlayer, isUI)
	if not thePlayer then thePlayer = source end -- For UI.

	local loggedin = getElementData(thePlayer, "loggedin") or 0
	if (loggedin == 1) then
		local commandList = exports.mysql:Query("SELECT * FROM `command_library`;")

		triggerClientEvent(thePlayer, "player:showCommandListGUI", thePlayer, commandList, isUI)
	end
end
addCommandHandler("commands", showCommandList)
addCommandHandler("cmdlist", showCommandList)

function addNewCommand(cmdName, cmdAliases, cmdHotkey, cmdDescription, selectedCategory, selectionTable)
	local accountName = getElementData(source, "account:username")
	local timeNow = exports.global:getCurrentTime()

	local query = exports.mysql:Execute(
		"INSERT INTO `command_library` (`id`, `command`, `aliases`, `hotkey`, `description`, `permission_groups`, `category`, `last_updated`, `updated_by`) VALUES (NULL, (?), (?), (?), (?), (?), (?), (?), (?));",
		cmdName, cmdAliases, cmdHotkey, cmdDescription, tostring(selectionTable), selectedCategory, timeNow[3], accountName
	)
	if query then
		showCommandList(source, "cmdui")
		outputChatBox("Command was successfully added.", source, 75, 230, 10)
	else
		outputChatBox("ERROR: Something went wrong whilst adding the command, please try again.", source, 255, 0, 0)
		return
	end
end
addEvent("player:addNewCommand", true)
addEventHandler("player:addNewCommand", root, addNewCommand)

function getCommandInfo(cmdID)
	local commandInfo = exports.mysql:QuerySingle("SELECT * FROM `command_library` WHERE `id` = (?);", tonumber(cmdID))
	triggerClientEvent(source, "player:commandlist:animateEditor", source, true, true, commandInfo)
end
addEvent("player:commandlist:getCommandInfo", true)
addEventHandler("player:commandlist:getCommandInfo", root, getCommandInfo)

function deleteCommand(cmdID, cmdName)
	local query = exports.mysql:Execute("DELETE FROM `command_library` WHERE `id` = (?);", cmdID)
	if query then
		local thePlayerName = exports.global:getStaffTitle(source)
		outputChatBox("You have deleted the command '" .. cmdName ..  "' from the command library.", source, 75, 230, 10)
		exports.global:sendMessageToManagers("[INFO] " .. thePlayerName .. " has deleted the command '" .. cmdName .. "' from the command library.", true)
		exports.logs:addLog(source, 1, source, "(/commands) Deleted the command " .. cmdName .. " from the command library.")
		showCommandList(source, "cmdui")
	else
		outputChatBox("ERROR: Something went wrong whilst deleting the command.", source, 255, 0, 0)
		return
	end
end
addEvent("player:commandlist:deletecmd", true)
addEventHandler("player:commandlist:deletecmd", root, deleteCommand)

function editCommand(commandID, cmdName, cmdAliases, cmdHotkey, cmdDescription, selectedCategory, selectionTable)
	local accountName = getElementData(source, "account:username")
	local timeNow = exports.global:getCurrentTime()

	local query = exports.mysql:Execute(
		"UPDATE `command_library` SET `command` = (?), `aliases` = (?), `hotkey`= (?), `description` = (?), `permission_groups` = (?), `category` = (?), `last_updated` = (?), `updated_by` = (?) WHERE `id` = (?);",
		cmdName, cmdAliases, cmdHotkey, cmdDescription, selectionTable, selectedCategory, timeNow[3], accountName, commandID
	)

	if query then
		local thePlayerName = exports.global:getStaffTitle(source)
		outputChatBox("You have updated the command '" .. cmdName ..  "' in the command library.", source, 75, 230, 10)
		exports.global:sendMessageToManagers("[INFO] " .. thePlayerName .. " has updated the command '" .. cmdName .. "' in the command library.", true)
		exports.logs:addLog(source, 1, source, "(/commands) Updated the command " .. cmdName .. " in the command library.")
		showCommandList(source, "cmdui")
	else
		outputChatBox("ERROR: Something went wrong whilst deleting the command.", source, 255, 0, 0)
		return
	end
end
addEvent("player:commandlist:editCommand", true)
addEventHandler("player:commandlist:editCommand", root, editCommand)