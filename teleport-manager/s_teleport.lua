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

function handleTeleportCreation(location, location2, isOneWay)
	local created, reason = createTeleporter(source, location, location2, isOneWay)
	if (created) then
		local thePlayerName = exports.global:getStaffTitle(source, 1)
		local teleporterID = getElementData(created, "teleporter:id")

		outputChatBox("Teleporter successfully created.", source, 0, 255, 0)
		exports.global:sendMessageToManagers("[INFO] " .. thePlayerName .. " has created a new teleporter [ID #" .. teleporterID .."].")
		exports.logs:addLog(source, 1, source, "(/addtp) Created new teleporter. [ID #" .. teleporterID .. "]")
		-- Give player a controller for teleporter. @requires item-system
	else
		outputChatBox("ERROR: " .. reason, source, 255, 0, 0)
	end
end
addEvent("teleporter:handleTeleportCreation", true)
addEventHandler("teleporter:handleTeleportCreation", root, handleTeleportCreation)

-- /deltp [Teleporter ID] - By Skully (20/06/18) [Trial Admin]
function deleteTeleporterCmd(thePlayer, commandName, teleporterID)
	if exports.global:isPlayerHelper(thePlayer) then
		if not tonumber(teleporterID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Teleporter ID]", thePlayer, 75, 230, 10)
			return
		end

		-- Ensure teleporter with ID provided exists.
		local theTeleporter = exports.data:getElement("teleporter", tonumber(teleporterID))
		if not (theTeleporter) then
			outputChatBox("ERROR: A teleporter with the ID #" .. teleporterID .. " doesn't exist!", thePlayer, 255, 0, 0)
			return false
		end

		local destroyTeleporter, reason = deleteTeleporter(teleporterID)
		if (destroyTeleporter) then
			local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
			outputChatBox("You have deleted teleporter with the ID #".. teleporterID .. ".", thePlayer, 0, 255, 0)
			exports.global:sendMessageToManagers("[INFO] " .. thePlayerName .. " has deleted teleporter ID #" .. teleporterID .. ".")
			exports.logs:addLog(thePlayer, 1, thePlayer, "(/deltp) Deleted teleporter with ID #".. teleporterID .. ".")
		else
			outputChatBox("ERROR: " .. reason, thePlayer, 255, 0, 0)
			return false
		end
	end
end
addCommandHandler("deltp", deleteTeleporterCmd)

-- /reloadtp [Teleporter ID] - By Skully (20/06/18) [Helper]
function reloadTeleporterCmd(thePlayer, commandName, teleporterID)
	if exports.global:isPlayerHelper(thePlayer) then
		if not tonumber(teleporterID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Teleporter ID]", thePlayer, 75, 230, 10)
			return false
		end

		-- Ensure the teleporter exists.
		local theTeleporter = exports.data:getElement("teleporter", teleporterID)
		if not (theTeleporter) then
			outputChatBox("ERROR: A teleporter with the ID #" .. teleporterID .. " doesn't exist!", thePlayer, 255, 0, 0)
			return false
		end

		local loaded, reason = reloadTeleporter(teleporterID)
		if loaded then
			outputChatBox("You have reloaded teleporter #" .. teleporterID .. ".", thePlayer, 0, 255, 0)
		else
			outputChatBox("ERROR: " .. reason, thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("reloadtp", reloadTeleporterCmd)

-- /settpmode [Teleporter ID] [Mode] - By Skully (20/06/18) [Helper]
function setTeleporterMode(thePlayer, commandName, teleporterID, mode)
	if exports.global:isPlayerHelper(thePlayer) then
		if not tonumber(teleporterID) or not tonumber(mode) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Teleporter ID] [Mode]", thePlayer, 75, 230, 10)
			for i, mode in ipairs(g_teleporterModes) do
				outputChatBox(i .. ": " .. mode, thePlayer, 75, 230, 10)
			end
			return
		end

		mode = tonumber(mode)
		if (mode < 1) or (mode > #g_teleporterModes) then
			outputChatBox("ERROR: That is not a valid mode!", thePlayer, 255, 0, 0)
			return false
		end

		-- Ensure the teleporter exists.
		local theTeleporter = exports.data:getElement("teleporter", teleporterID)
		if not (theTeleporter) then
			outputChatBox("ERROR: A teleporter with the ID #" .. teleporterID .. " doesn't exist!", thePlayer, 255, 0, 0)
			return false
		end

		exports.blackhawk:changeElementDataEx(theTeleporter, "teleporter:mode", mode)
		local saved = reloadTeleporter(teleporterID)
		if (saved) then
			outputChatBox("You have set the mode for teleporter #" .. teleporterID .. " to " .. g_teleporterModes[mode] .. ".", thePlayer, 0, 255, 0)
		else
			outputChatBox("ERROR: Something went wrong whilst applying the change, please reload the teleporter.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("settpmode", setTeleporterMode)