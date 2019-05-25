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

blackhawk = exports.blackhawk
local PROTECTED_FACTIONS = {
	1, -- PD.
	2, -- FD.
	3, -- GOV.
	4, -- Courts.
}

function createFaction(thePlayer, factionName, abbreviation, factionType, vehSlots, intSlots, phone)
	if not tostring(factionName) or not tostring(abbreviation) or not tonumber(factionType) then return false end
	if #factionName < 3 or #factionName > 50 then return false end
	if #abbreviation < 2 or #abbreviation > 5 then return false end

	-- Prevent faction being made with same name.
	local nameExists = exports.mysql:QueryString("SELECT `id` FROM `factions` WHERE `name` = (?);", tostring(factionName))
	if nameExists then
		outputChatBox("ERROR: Faction #" .. nameExists .. " already exists with the name '" .. factionName .. "'.", thePlayer, 255, 0, 0)
		return false
	end

	-- Prevent faction being made with same abbreviation.
	local abbrExists = exports.mysql:QueryString("SELECT `name` FROM `factions` WHERE `abbreviation` = (?);", tostring(abbreviation))
	if abbrExists then
		outputChatBox("ERROR: The faction '" .. abbrExists .. "' is already using this abbreviation!", thePlayer, 255, 0, 0)
		return false
	end

	local nextID = exports.mysql:QueryString("SELECT AUTO_INCREMENT FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'emerald' AND TABLE_NAME = 'factions';"); nextID = tonumber(nextID)
	
	-- Parse default rank table.
	local defaultRankTable = {}
	for i = 1, NUMBER_OF_RANKS do defaultRankTable[i] = {"Default Rank " .. i, 0} end
	local defaultRanksParsed = toJSON(defaultRankTable)
	if not tonumber(phone) then phone = 0 end

	local query = exports.mysql:Execute(
		"INSERT INTO `factions` (`id`, `name`, `abbreviation`, `logo`, `type`, `ranks`, `note`, `leader_note`, `motd`, `max_vehicles`, `max_interiors`, `money`, `phone`) VALUES ((?), (?), (?), NULL, (?), (?), NULL, NULL, 'Welcome to the faction!', (?), (?), '0', (?));",
		nextID, factionName, abbreviation, tonumber(factionType), defaultRanksParsed, tonumber(vehSlots), tonumber(intSlots), tonumber(phone)
	)
	if query then
		local theFaction = createTeam(factionName)
		if theFaction then
			exports.data:allocateElement(theFaction, nextID)
			blackhawk:setElementDataEx(theFaction, "faction:id", tonumber(nextID), true)
			blackhawk:setElementDataEx(theFaction, "faction:name", tostring(factionName), true)
			blackhawk:setElementDataEx(theFaction, "faction:abbreviation", tostring(abbreviation), true)
			blackhawk:setElementDataEx(theFaction, "faction:logo",false, true)
			blackhawk:setElementDataEx(theFaction, "faction:type", tonumber(factionType), true)
			blackhawk:setElementDataEx(theFaction, "faction:ranks", defaultRankTable, true)
			blackhawk:setElementDataEx(theFaction, "faction:note", "", true)
			blackhawk:setElementDataEx(theFaction, "faction:leadernote", "", true)
			blackhawk:setElementDataEx(theFaction, "faction:motd", "Welcome to the faction!", true)
			blackhawk:setElementDataEx(theFaction, "faction:maxvehicles", tonumber(vehSlots), true)
			blackhawk:setElementDataEx(theFaction, "faction:maxinteriors", tonumber(intSlots), true)

			-- Create duty groups table for faction.
			exports.mysql:Execute("INSERT INTO `faction_duty_groups` (`factionid`, `group_data`) VALUES ((?), '[ [ ] ]');", nextID)

			-- Create duty items table for faction.
			exports.mysql:Execute("INSERT INTO `faction_items` (`factionid`, `item_table`, `skin_table`) VALUES ((?), '[ [ ] ]', '[ [ ] ]');", nextID)

			-- Outputs & logs.
			local thePlayerName = exports.global:getStaffTitle(thePlayer)
			outputChatBox("You have creation the faction '" .. factionName .. "' with ID #" .. nextID .. ".", thePlayer, 0, 255, 0)
			exports.logs:addLog(thePlayer, 1, theFaction, "[FACTION CREATED] Created faction '" .. factionName .. "' (Abbr: " .. abbreviation .. ", Type: " .. factionType .. ", Vehicle Slots: " .. vehSlots .. ", Interior Slots: " .. intSlots .. ")")
			exports.logs:addFactionLog(nextID, thePlayer, "[FACTION CREATED] Faction created by " .. thePlayerName .. ".")
			exports.global:sendMessage("[INFO] " .. thePlayerName .. " has created the faction '" .. factionName .. "'.", 4, false)
			return theFaction
		else
			outputChatBox("ERROR: Something went wrong whilst creating the faction.", thePlayer, 255, 0, 0)
			exports.global:outputDebug("@createFaction: Failed to create faction '" .. tostring(factionName) .. "', requested by " .. tostring(getPlayerName(thePlayer)) .. ".")
			return false
		end
	else
		outputChatBox("ERROR: Failed to save faction to database.", thePlayer, 255, 0, 0)
		exports.global:outputDebug("@createFaction: Failed to create faction, is there an active database connection?")
		return false
	end
	outputChatBox("ERROR: Something went wrong whilst creating the faction!", thePlayer, 255, 0, 0)
	return false
end
addEvent("faction:createFaction", true)
addEventHandler("faction:createFaction", root, createFaction)

function saveFaction(factionID)
	if not tonumber(factionID) then exports.global:outputDebug("@saveFaction: factionID not provided or is not a number value.") return false end
	factionID = tonumber(factionID)
	if (factionID <= 0) then return end 

	-- Check to see if faction element exists.
	local theFaction = exports.data:getElement("team", factionID)
	if not theFaction then
		exports.global:outputDebug("@saveFaction: Attempted to save faction #" .. factionID .. " though faction element doesn't exist.")
		return false
	end

	-- Check if faction exists in database.
	local factionData = exports.mysql:QueryString("SELECT `name` FROM `factions` WHERE `id` = (?);", factionID)
	if not factionData then
		exports.global:outputDebug("@saveFaction: Attempted to save faction #" .. factionID .. " though faction does not exist in database.")
		return false
	end

	-- Get faction data.
	local factionName = getElementData(theFaction, "faction:name")
	local factionAbbreviation = getElementData(theFaction, "faction:abbreviation")
	local factionLogo = getElementData(theFaction, "faction:logo")
	local factionRanks = toJSON(getElementData(theFaction, "faction:ranks"))
	local factionNote = getElementData(theFaction, "faction:note")
	local factionLeaderNote = getElementData(theFaction, "faction:leadernote")
	local factionMotd = getElementData(theFaction, "faction:motd")
	local factionMoney = getElementData(theFaction, "faction:money")

	local query = exports.mysql:Execute(
		"UPDATE `factions` SET `name` = (?), `abbreviation` = (?), `logo` = (?), `ranks` = (?), `note` = (?), `leader_note` = (?), `motd` = (?), `money` = (?) WHERE `id` = (?);",
		factionName, factionAbbreviation, factionLogo, factionRanks, factionNote, factionLeaderNote, factionMotd, factionMoney, factionID
	)

	return query, theFaction
end

function deleteFaction(factionID)
	if not tonumber(factionID) then exports.global:outputDebug("@deleteFaction: factionID not provided or is not a number value.") return false end
	factionID = tonumber(factionID)

	if exports.global:table_find(factionID, PROTECTED_FACTIONS) then
		return false, "This faction is protected and cannot be deleted, contact a Lead Manager."
	end

	-- Check if faction exists in database.
	local factionData = exports.mysql:QueryString("SELECT `name` FROM `factions` WHERE `id` = (?);", factionID)
	if not factionData then
		exports.global:outputDebug("@saveFaction: Attempted to delete faction #" .. factionID .. " though faction does not exist in database.")
		return false, "The faction you attempted to delete no longer exists."
	end

	local theFaction = exports.data:getElement("team", factionID)
	if theFaction then
		-- If there are players online with the faction currently set as their active one, remove them and set them to civilian.
		local factionMembers = getPlayersInTeam(theFaction)
		for i, player in ipairs(factionMembers) do
			local characterID = getElementData(player, "character:id")
			exports.mysql:Execute("DELETE FROM `faction_members` WHERE `characterid` = (?) AND `factionid` = (?);", characterID, factionID)
			local newFactionTable = exports.global:getPlayerFactions(characterID)
			blackhawk:changeElementDataEx(player, "character:factions", newFactionTable)
			exports.global:setPlayerToCivilianTeam(player)
		end

		destroyElement(theFaction)
	end

	exports.mysql:Execute("DELETE FROM `faction_logs` WHERE `factionid` = (?);", factionID) -- Delete faction logs.
	exports.mysql:Execute("DELETE FROM `faction_members` WHERE `factionid` = (?);", factionID) -- Delete faction members.
	exports.mysql:Execute("DELETE FROM `faction_duty_locations` WHERE `factionid` = (?);", factionID) -- Delete faction duty locations.
	exports.mysql:Execute("DELETE FROM `faction_duty_groups` WHERE `factionid` = (?);", factionID) -- Delete faction duty groups.
	exports.mysql:Execute("DELETE FROM `faction_items` WHERE `factionid` = (?);", factionID) -- Delete faction items.


	-- Set all faction interiors as un-owned.
	local factionInteriors = exports.mysql:Query("SELECT `id` FROM `interiors` WHERE `faction` = (?);", factionID)
	for i, interior in ipairs(factionInteriors) do
		local theInterior = exports.data:getElement("interior", interior.id)
		exports.blackhawk:changeElementDataEx(theInterior, "interior:owner", 0)
		exports["interior-system"]:reloadInterior(interior.id)
		exports.logs:addInteriorLog(interior.id, "[FORCE SOLD] Interior forcesold as owner faction #" .. factionID .. " was deleted.")
	end

	-- Delete all faction vehicles.
	local factionVehicles = exports.mysql:Query("SELECT `id` FROM `vehicles` WHERE `faction` = (?);", factionID)
	for i, vehicle in ipairs(factionVehicles) do
		local theVehicle = exports.data:getElement("vehicle", vehicle.id)
		if theVehicle then destroyElement(theVehicle) end
		exports.mysql:Execute("DELETE FROM `vehicle_logs` WHERE `vehid` = (?);", vehicle.id)
		exports.mysql:Execute("DELETE FROM `vehicles` WHERE `id` = (?);", vehicle.id)
	end

	local query = exports.mysql:Execute("DELETE FROM `factions` WHERE `id` = (?);", factionID) -- Delete faction.
	return query
end

function loadFaction(factionID)
	local factionData = exports.mysql:QuerySingle("SELECT * FROM `factions` WHERE `id` = (?);", factionID)
	if not factionData then
		exports.global:outputDebug("@loadFaction: Attempted to load faction #" .. factionID .. " though faction doesn't exist in database.")
		return false
	end

	local theFaction = createTeam(factionData.name)
	if theFaction then
		exports.data:allocateElement(theFaction, factionData.id)
		blackhawk:setElementDataEx(theFaction, "faction:id", tonumber(factionData.id), true)
		blackhawk:setElementDataEx(theFaction, "faction:name", tostring(factionData.name), true)
		blackhawk:setElementDataEx(theFaction, "faction:abbreviation", tostring(factionData.abbreviation), true)
		blackhawk:setElementDataEx(theFaction, "faction:logo",factionData.logo or false, true)
		blackhawk:setElementDataEx(theFaction, "faction:type", tonumber(factionData.type), true)
		local rankTable = fromJSON(tostring(factionData.ranks))
		blackhawk:setElementDataEx(theFaction, "faction:ranks", rankTable, true)
		blackhawk:setElementDataEx(theFaction, "faction:note", factionData.note or "", true)
		blackhawk:setElementDataEx(theFaction, "faction:motd", factionData.motd or "", true)
		blackhawk:setElementDataEx(theFaction, "faction:leadernote", factionData.leader_note or "", true)
		blackhawk:setElementDataEx(theFaction, "faction:maxvehicles", tonumber(factionData.max_vehicles), true)
		blackhawk:setElementDataEx(theFaction, "faction:maxinteriors", tonumber(factionData.max_interiors), true)

		-- Create duty points here for faction. @requires faction-system /duty
		return true
	else
		exports.global:outputDebug("@loadAllFactions: Failed to load faction #" .. tostring(factionData.id) .. ", faction may already exist.")
		return false
	end
end

function loadAllFactions()
	local allFactions = exports.mysql:Query("SELECT `id` FROM `factions` ORDER BY `id` ASC;")
	if not (allFactions) or not (allFactions[1]) then return end

	local delay = 50
	for index, faction in ipairs(allFactions) do
		setTimer(loadFaction, delay, 1, tonumber(faction.id))
		delay = delay + 50
	end

	exports.global:outputDebug("Loading " .. #allFactions .. " factions, estimated time to load: " .. (delay/1000) .. " seconds.", 3)

	-- Create civilian team.
	local civilianTeam = createTeam("Civilian", 255, 255, 255)
	exports.blackhawk:setElementDataEx(civilianTeam, "faction:id", 0, true)
	exports.blackhawk:setElementDataEx(civilianTeam, "faction:name", "Civilian", true)
	exports.data:allocateElement(civilianTeam, -1)

	-- Set all players into civilian faction.
	local allPlayers = exports.data:getDataElementsByType("player")
	for i, player in ipairs(allPlayers) do
		setPlayerTeam(player, civilianTeam)
		blackhawk:setElementDataEx(player, "character:activefaction", 0)
	end
end
addEventHandler("onResourceStart", resourceRoot, loadAllFactions)

function saveAllFactions()
	local allFactions = exports.data:getDataElementsByType("team")
	local leftToSave = #allFactions

	local delay = 50
	for i, faction in ipairs(allFactions) do
		local factionID = getElementData(faction, "faction:id")
		if (factionID) then
			setTimer(saveFaction, delay, 1, factionID)
		end
		delay = delay + 50

		leftToSave = leftToSave - 1
		if (leftToSave == 0) then return true end
	end
end