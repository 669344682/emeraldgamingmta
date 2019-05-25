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

Copyright of the Emerald Gaming Development Team, do not distribute - All rights reserved.

FOR MORE IN-DEPTH EXPLANATION AND INFORMATION REGARDING GLOBAL EXPORTS, CHECK THE WIKI. ]]

-- Gets all online players and outputs a message to them.
function sendMessageToPlayers(message, r, g, b, messageType)
	if (message) then
		local players = getElementsByType("player") -- Get a table of all the players in the server.

		for theKey, thePlayer in ipairs(players) do -- Use a for loop to step through each player.
			if (messageType == "punish") then -- Optional parameter currently only used in s_punishments.lua in order to implement 'Mute punishment message' account setting.
				local punishNotificationSetting = getElementData(thePlayer, "settings:notification:setting3")
				if (punishNotificationSetting == 0) and not (exports.global:isPlayerTrialAdmin(thePlayer)) then break end -- If disabled don't send the message, but only if the player isn't in admin team.
			end

			if (r) and (g) and (b) then -- If a specific color was specified.
				outputChatBox(message, thePlayer, r, g, b)
			else
				outputChatBox(message, thePlayer, 255, 0, 0)
			end
		end
	else
		outputDebugString("[GLOBAL] Incorrect syntax provided for function sendMessageToPlayers, no message to send.", 3)
	end
end


-- Gets all online staff members and outputs a message to them.
function sendMessageToStaff(message, r, g, b)
	if (message) then
		local players = getElementsByType("player") -- Get a table of all the players in the server.

		for k, thePlayer in ipairs(players) do -- Use a for loop to step through each player.
			if exports.global:isPlayerHelper(thePlayer, true) or exports.global:isPlayerVehicleTeam(thePlayer, true) or exports.global:isPlayerMappingTeam(thePlayer, true) or exports.global:isPlayerFactionTeam(thePlayer, true) or exports.global:isPlayerTrialDeveloper(thePlayer, true) then
				if (r) and (g) and (b) then -- If a specific color was specified.
					outputChatBox(message, thePlayer, r, g, b)
				else
					outputChatBox(message, thePlayer, 255, 0, 0) -- Sends the message in red.
				end
			end
		end
	else
		outputDebugString("[GLOBAL] Incorrect syntax provided for function sendMessageToStaff, no message to send.", 3)
	end
end

-- Gets all online administrators and outputs a message to them.
function sendMessageToAdmins(message, r, g, b)
	if (message) then
		local players = getElementsByType("player") -- Get a table of all the players in the server.

		for k, thePlayer in ipairs(players) do -- Use a for loop to step through each player.
			if exports.global:isPlayerTrialAdmin(thePlayer, true) then -- Checks if the player is an admin.
				if (r) and (g) and (b) then -- If a specific color was specified.
					outputChatBox(message, thePlayer, r,g,b)
				else
					outputChatBox(message, thePlayer, 255, 0, 0) -- Sends the message in red.
				end
			end
		end
	else
		outputDebugString("[global] sendMessageToAdmins: Incorrect syntax provided, no message to send.", 3)
	end
end

-- Gets all online helpers and outputs a message to them.
function sendMessageToHelpers(message, r, g, b)
	if (message) then
		local players = getElementsByType("player") -- Get a table of all the players in the server.

		for k, thePlayer in ipairs(players) do -- Use a for loop to step through each player.
			if (exports.global:getStaffLevel(thePlayer) == 1) then -- Checks if the player is only a helper.
				if (r) and (g) and (b) then -- If a specific color was specified.
					outputChatBox(message, thePlayer, r,g,b)
				else
					outputChatBox(message, thePlayer, 255, 0, 0) -- Sends the message in red.
				end
			end
		end
	else
		outputDebugString("[global] sendMessageToHelpers: Incorrect syntax provided, no message to send.", 3)
	end
end


-- Gets all online staff members and outputs a message to them.
function sendMessageToManagers(message, notIgnorable, r, g, b)
	if tostring(message) then
		if not (r) then r = 0 end
		if not (g) then g = 255 end
		if not (b) then b = 255 end

		local allPlayers = getElementsByType("player") -- Get a table of all the players in the server.

		for i, thePlayer in ipairs(allPlayers) do -- Use a for loop to step through each player.
			if exports.global:isPlayerManager(thePlayer, true) then -- Checks if the player is a manager.
				local isIgnoring = getElementData(thePlayer, "var:togmgtwarn")
				if (isIgnoring == 0) or (notIgnorable) then
					outputChatBox(message, thePlayer, r, g, b)
				end
			end
		end
	else
		outputDebugString("[global] @sendMessageToManagers: No message provided to send or message is not a string.", 3)
	end
end

-- Gets all online developers and outputs a message to them.
function sendMessageToDevelopers(message, r, g, b)
	if not tostring(message) then outputDebug("@sendMessageToDevelopers: message not provided or is not a string.") return false end

	local players = getElementsByType("player")
	if not (r) or not (g) or not (b) then r, g, b = 204, 102, 255 end

	for k, thePlayer in ipairs(players) do
		if isPlayerDeveloper(thePlayer, true) then
			outputChatBox(message, thePlayer, r, g, b)
		end
	end
end

-- Gets all online vehicle team members and outputs a message to them.
function sendMessageToVehicleTeam(message, r, g, b)
	if (message) then
		local players = getElementsByType("player") -- Get a table of all the players in the server.

		for k, thePlayer in ipairs(players) do -- Use a for loop to step through each player.
			if exports.global:isPlayerVehicleTeam(thePlayer, true) then
				if (r) and (g) and (b) then -- If a specific color was specified.
					outputChatBox(message, thePlayer, r, g, b)
				else
					outputChatBox(message, thePlayer, 255, 0, 0) -- Send the message in red.
				end
			end
		end
	else
		outputDebugString("[GLOBAL] Incorrect syntax provided for function sendMessageToVehicleTeam, no message to send.", 3)
	end
end

-- Gets all online mapping team members and outputs a message to them.
function sendMessageToMappingTeam(message, r, g, b)
	if (message) then
		local players = getElementsByType("player") -- Get a table of all the players in the server.

		for k, thePlayer in ipairs(players) do -- Use a for loop to step through each player.
			if exports.global:isPlayerMappingTeam(thePlayer, true) then
				if (r) and (g) and (b) then -- If a specific color was specified.
					outputChatBox(message, thePlayer, r, g, b)
				else
					outputChatBox(message, thePlayer, 255, 0, 0) -- Send the message in red.
				end
			end
		end
	else
		outputDebugString("[GLOBAL] Incorrect syntax provided for function sendMessageToMappingTeam, no message to send.", 3)
	end
end

-- Gets all online faction team members and outputs a message to them.
function sendMessageToFactionTeam(message, r, g, b)
	if (message) then
		local players = getElementsByType("player") -- Get a table of all the players in the server.

		for k, thePlayer in ipairs(players) do -- Use a for loop to step through each player.
			if exports.global:isPlayerFactionTeam(thePlayer, true) then
				if (r) and (g) and (b) then -- If a specific color was specified.
					outputChatBox(message, thePlayer, r, g, b)
				else
					outputChatBox(message, thePlayer, 255, 0, 0) -- Send the message in red.
				end
			end
		end
	else
		outputDebugString("[GLOBAL] Incorrect syntax provided for function sendMessageToFactionTeam, no message to send.", 3)
	end
end

-- Function sends a message to all players that have the onDuty value specified, and the staff level specified in the parameters.
function sendMessage(message, level, onDuty, r, g, b)
	if not tonumber(r) or not tonumber(g) or not tonumber(b) then r, g, b = 255, 0, 0 end
	local allPlayers = getElementsByType("player")

	for k, thePlayer in ipairs(allPlayers) do
		if not tonumber(level) or (getStaffLevel(thePlayer) >= level) then
			if (onDuty) then
				if (isPlayerOnStaffDuty(thePlayer)) then
					outputChatBox(message, thePlayer, r, g, b)
				end
			else
				outputChatBox(message, thePlayer, r, g, b)
			end
		end
	end
end