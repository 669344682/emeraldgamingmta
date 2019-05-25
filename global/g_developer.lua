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

--[[

[RANK TABLE]
Player: 0
Trial Developer: 1
Developer: 2
Lead Developer: 3

]]

defaultRank = "Player"
level1 = "Trial Developer"
level2 = "Developer"
level3 = "Lead Developer"

-- Gets the given player and returns their rank developer team rank.
function getDeveloperTitle(player, mode)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end

	local playerName = ""
	if (mode == 1) then
		playerName = " " .. getElementData(player, "account:username")
	elseif (mode == 2) then
		local name = getPlayerName(player)
		playerName = " " .. name:gsub("_", " ") .. " (" .. getElementData(player, "account:username") .. ")"
	elseif (mode == 3) then
		playerName = ""
	end

	if getElementData(player, "staff:developer") == 1 then
		return level1 .. PlayerName
	elseif getElementData(player, "staff:developer") == 2 then
		return level2 .. playerName
	elseif getElementData(player, "staff:developer") == 3 then
		return level3 .. playerName
	else
		return defaultRank
	end
end

--[[ Outputs a debug message to the chatbox of all online developers and a debugString message.
[LEVELS] 1 = ERROR, 2 = WARNING, 3 = INFO 												]]
function outputDebug(message, level)
	if not tonumber(level) then level = 1 end
	level = tonumber(level)
	local resName = "global"

	if (sourceResource) and type(sourceResource) == "userdata" then -- sourceResource in this case is the resource that called this function.
		resName = getResourceName(sourceResource) or "global"
	end

	local errorType = "ERROR"
	local r, g, b = 255, 20, 20

	if (level == 2) then
		errorType = "WARNING"
		r, g, b = 255, 255, 0
	elseif (level == 3) then
		errorType = "INFO"
		r, g, b = 204, 102, 255
	end

	local debugMessage = "[" .. errorType .. ": " .. resName .. "] " .. message
	for i, player in ipairs(getElementsByType("player")) do
		if (level == 1) or isPlayerOnDeveloperDuty(player) then
			outputChatBox(debugMessage, player, r, g, b)
		end
	end

	outputDebugString(debugMessage, 3)

	local timeNow = getCurrentTime()
	local query = exports.mysql:Execute("INSERT INTO `logs` (`id`, `time`, `source_element`, `type`, `affected_elements`, `log`) VALUES (NULL, (?), (?), (?), (?), (?));", timeNow[3], "SERVER", 17, resName, debugMessage)
	if not (query) then
		outputDebugString("[global] @outputDebug: Attempted to store error log though query failed, is there an active database connection?", 3)
	end
end