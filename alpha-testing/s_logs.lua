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

--[[
	[1] Log Text
	[2] Character Name
	[3] Account Name
	[4] Vehicle ID
	[5] Interior ID
	[6] Faction ID
	[7] Item ID
]]

function logViewerCallback(selections, searchType, isTextSearch, searchInput)
	-- selections is table with all selected log ids
	-- searchType is what type from table above
	-- isTextSearch is text for respective searchType

	local types = ""
	local searchquery = ""
	for i, selection in ipairs(selections) do
		if i ~= #selections then
			types = types .. selection .. " OR `type` = "
		else
			types = types .. selection
		end
	end

	local idPrefix = ""
	if (isTextSearch) then
		if (searchType == 1) then -- Log Text Search.
			idPrefix = "`log` = '" .. searchInput
		elseif (searchType == 2) then -- Character Name search.
			idPrefix = "`source_element` = 'CHAR"
			local charID = exports.global:getCharacterIDFromName(searchInput)
			if not charID or not tonumber(charID) then charID = 0 end
			idPrefix = idPrefix .. charID
		elseif (searchType == 3) then -- Account Name search.
			idPrefix = "`source_element` = 'ACC"
			local accID = exports.mysql:QueryString("SELECT `id` FROM `accounts` WHERE `username` = (?);", searchInput)
			if not accID or not tonumber(accID) then accID = 0 end
			idPrefix = idPrefix .. accID
		elseif (searchType == 4) then -- Vehicle ID search.
			idPrefix = "`source_element` = 'VEH"
			idPrefix = idPrefix .. searchInput
		elseif (searchType == 5) then -- Interior ID search.
			idPrefix = "`source_element` = 'INT"
			idPrefix = idPrefix .. searchInput
		elseif (searchType == 6) then -- Faction ID search.
			idPrefix = "`source_element` = 'FAC"
			idPrefix = idPrefix .. searchInput
		elseif (searchType == 7) then -- Item ID search.
			idPrefix = "`source_element` = 'OBJ"
			idPrefix = idPrefix .. searchInput
		end
		searchquery = "SELECT * FROM `logs` WHERE " .. idPrefix .. "' AND (`type` = " .. types .. ");"
	else
		searchquery = "SELECT * FROM `logs` WHERE `type` = " .. types .. ";"
	end

	local resultTable = exports.mysql:Query(searchquery)

	triggerClientEvent(source, "admin:logs:populateLogs", source, resultTable, searchquery)
end
addEvent("admin:logsearch", true)
addEventHandler("admin:logsearch", root, logViewerCallback)