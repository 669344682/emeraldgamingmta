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

function showFactionSelectorCall()
	local thePlayerFactions = getElementData(source, "character:factions") or {}
	local factionDataTable = {}
	for i, factionID in ipairs(thePlayerFactions) do
		local factionData = exports.mysql:QuerySingle("SELECT `logo`, `abbreviation` FROM `factions` WHERE `id` = (?);", factionID)
		if factionData then
			factionDataTable[i] = {factionID, factionData.abbreviation, tostring(factionData.logo)}
		end
	end

	triggerClientEvent(source, "faction:showFactionSelector", source, factionDataTable)
	exports.global:setPlayerToCivilianTeam(source)
end
addEvent("faction:showFactionSelectorCall", true)
addEventHandler("faction:showFactionSelectorCall", root, showFactionSelectorCall)

--------------------------------------------------------------------------------------------------------------------------------------------
--													START OF FACTION MENU DATA FUNCTIONS
--------------------------------------------------------------------------------------------------------------------------------------------

function showFactionMenuCall(thePlayer, factionID, animateIn)
	if not tonumber(factionID) or (tonumber(factionID) == 0) then return end
	factionID = tonumber(factionID)

	local theFaction = exports.data:getElement("team", factionID)
	if theFaction then
		local isFactionLeader = exports.global:isPlayerFactionLeader(thePlayer, factionID)
		local menuData = {}
		local memberNames = {}
		local memberRanks = {}
		local memberLastSeen = {}
		local memberLeaderships = {}

		menuData[1] = isFactionLeader
		menuData[2] = getElementData(theFaction, "faction:logo") or false
		menuData[3] = getElementData(theFaction, "faction:motd") or ""
		menuData[4] = getElementData(theFaction, "faction:name") or getTeamName(theFaction)

		local allMembers = exports.global:getFactionMembers(factionID)
		for i, member in ipairs(allMembers) do
			local memberName = exports.global:getCharacterNameFromID(member.characterid)
			memberNames[i] = memberName
			memberRanks[i] = member.rank
			local date = exports.mysql:QueryString("SELECT `last_used` FROM `characters` WHERE `id` = (?);", member.characterid); date = split(date, ",")
			local timeParsed = date[6] .. "-" .. date[5] .. "-" .. date[4]
			memberLastSeen[i] = exports.mysql:QueryString("SELECT DATEDIFF(NOW(), (?));", timeParsed)
			memberLeaderships[i] = exports.global:isPlayerFactionLeader(member.characterid, factionID)
		end

		if animateIn then
			setPlayerTeam(source, theFaction)
			blackhawk:changeElementDataEx(source, "character:activefaction", factionID)
		end
		triggerClientEvent(thePlayer, "faction:showFactionMenu", thePlayer, animateIn, theFaction, menuData, memberNames, memberRanks, memberLastSeen, memberLeaderships)
	end
end
addEvent("faction:showFactionMenuCall", true)
addEventHandler("faction:showFactionMenuCall", root, showFactionMenuCall)

function fetchVehicleData(factionID)
	local vehicleIDs = {}
	local vehicleNames = {}
	local vehiclePlates = {}

	local factionVehicles = exports.mysql:Query("SELECT `id`, `model`, `plates` FROM `vehicles` WHERE `faction` = (?);", factionID)
	for i, vehicle in ipairs(factionVehicles) do
		vehicleIDs[i] = vehicle.id
		local vehData, vehicleName = exports.global:getVehicleModelInfo(vehicle.model)
		vehicleNames[i] = vehicleName
		vehiclePlates[i] = vehicle.plates
	end

	triggerClientEvent(source, "faction:fetchVehicleDataCallback", source, vehicleIDs, vehicleNames, vehiclePlates)
end
addEvent("faction:fetchVehicleData", true)
addEventHandler("faction:fetchVehicleData", root, fetchVehicleData)

function fetchInteriorData(factionID)
	local interiorIDs = {}
	local interiorNames = {}
	local interiorTypes = {}
	local interiorLocations = {}

	local factionInteriors = exports.mysql:Query("SELECT `id`, `name`, `type`, `location`, `price` FROM `interiors` WHERE `faction` = (?);", factionID)
	for i, interior in ipairs(factionInteriors) do
		interiorIDs[i] = interior.id
		interiorNames[i] = interior.name
		interiorTypes[i] = interior.type
		interiorLocations[i] = split(interior.location, ",")
	end

	triggerClientEvent(source, "faction:fetchInteriorDataCallback", source, interiorIDs, interiorNames, interiorTypes, interiorLocations)
end
addEvent("faction:fetchInteriorData", true)
addEventHandler("faction:fetchInteriorData", root, fetchInteriorData)

function fetchLeadershipData(factionID)
	local leaderLogTexts = {}
	local leaderLogNames = {}
	local leaderLogTimes = {}

	local factionLogs, namesTable = exports.logs:getFactionLogs(factionID, true)
	for i, log in ipairs(factionLogs) do
		leaderLogTexts[i] = log.log
		leaderLogNames[i] = namesTable[i]
		leaderLogTimes[i] = log.time
	end

	local theFaction = exports.data:getElement("team", factionID)
	local factionMotd = getElementData(theFaction, "faction:motd") or ""
	local factionRanks = getElementData(theFaction, "faction:ranks")
	triggerClientEvent(source, "faction:fetchLeadershipDataCallback", source, factionMotd, factionRanks, leaderLogTexts, leaderLogNames, leaderLogTimes)
end
addEvent("faction:fetchLeadershipData", true)
addEventHandler("faction:fetchLeadershipData", root, fetchLeadershipData)

function fetchFinanceData(factionID)
	local financeData = {}
	local financeLogIDs = {}
	local financeTypes = {}
	local financeReasons = {}
	local finanacePrices = {}

	financeData[1] = exports.mysql:QueryString("SELECT `money` FROM `factions` WHERE `id` = (?);", factionID) or 0
	financeData[2] = 0 -- Sum of vehicle prices.
	local factionVehicles = exports.mysql:Query("SELECT `model` FROM `vehicles` WHERE `faction` = (?);", factionID)
	for i, vehicle in ipairs(factionVehicles) do
		local vehPrice = exports.mysql:QueryString("SELECT `price` FROM `vehicle_database` WHERE `id` = (?);", vehicle.model) or 0
		financeData[2] = financeData[2] + vehPrice
	end

	-- Sum of interior prices.
	financeData[3] = exports.mysql:QueryString("SELECT sum(`price`) FROM `interiors` WHERE `faction` = (?);", factionID) or 0
	
	-- Sum of full faction net worth.
	financeData[4] = financeData[1] + financeData[2] + financeData[3]

	-- Fetch faction financial transaction data. @requires bank-system
	local facFinanceLogs = {1} -- Get faction financial transactions. (Be sure to sort DESC in SQL when fetching for sorting.)
	for i = 1, 1 do
		financeLogIDs[i] = 1 -- Log ID.
		financeTypes[i] = "Income" -- Type.
		financeReasons[i] = "Sample reason." -- Reason.
		finanacePrices[i] = 100000 -- Amount.
	end

	triggerClientEvent(source, "faction:fetchFinanceDataCallback", source, financeData, financeLogIDs, financeTypes, financeReasons, finanacePrices)
end
addEvent("faction:fetchFinanceData", true)
addEventHandler("faction:fetchFinanceData", root, fetchFinanceData)

--------------------------------------------------------------------------------------------------------------------------------------------
--													END OF FACTION MENU DATA FUNCTIONS
--												  START OF FACTION MENU ACTION FUNCTIONS
--------------------------------------------------------------------------------------------------------------------------------------------

function leaveFactionEvent(factionID)
	local characterID = getElementData(source, "character:id")
	local query = exports.mysql:Execute("DELETE FROM `faction_members` WHERE `characterid` = (?) AND `factionid` = (?);", characterID, factionID)
	if query then
		local newFactionTable = exports.global:getPlayerFactions(characterID)

		blackhawk:changeElementDataEx(source, "character:factions", newFactionTable)
		exports.global:setPlayerToCivilianTeam(source)

		-- Outputs & Logs.
		local thePlayerName = getPlayerName(source):gsub("_", " ")
		local theFaction = exports.data:getElement("team", factionID)
		local factionName = getTeamName(theFaction)
		outputChatBox("You have left the faction '" .. factionName .. "'.", source, 0, 255, 0)
		exports.logs:addLog(source, 5, {theFaction}, "[LEAVE FACTION] " .. thePlayerName .. " left the faction.")
		exports.logs:addFactionLog(factionID, source, "[LEAVE FACTION] " .. thePlayerName .. " left the faction.")
		-- Remove player duty equipment. @requires item-system (Set data on duty items that declare them as faction duty, and then remove all duty items.)
	else
		outputChatBox("Uh oh, something went wrong whilst attempting to leave the faction.", source, 255, 0, 0)
	end
end
addEvent("faction:leaveFactionEvent", true)
addEventHandler("faction:leaveFactionEvent", root, leaveFactionEvent)

function addFactionMember(targetPlayer, theFaction, rankID)
	local isInFaction = exports.global:isPlayerInFaction(targetPlayer, theFaction)
	if isInFaction then
		outputChatBox("ERROR: That player is already in the faction!", source, 255, 0, 0)
	else
		local theFactionName = getElementData(theFaction, "faction:name") or "Unknown"
		local targetPlayerName = getPlayerName(targetPlayer):gsub("_", " ")
		outputChatBox("You have invited " .. targetPlayerName .. " to the faction, waiting for them to accept..", source, 255, 255, 0)
		outputChatBox(getPlayerName(source):gsub("_", " ") .. " has invited you to the faction '" .. theFactionName .. "', type /acceptfaction to accept the invite.", targetPlayer, 255, 255, 0)
		blackhawk:setElementDataEx(targetPlayer, "temp:faction:facinvite", {source, theFaction, rankID}, false)
		exports.logs:addFactionLog(theFaction, source, "[MEMBER INVITED] Invited " .. targetPlayerName .. " to the faction.")
		setTimer(function()
			if getElementData(targetPlayer, "temp:faction:facinvite") then
				removeElementData(targetPlayer, "temp:faction:facinvite")
				outputChatBox("Your invite to the faction '" .. theFactionName .. "' has expired.", targetPlayer, 255, 255, 0)
				outputChatBox("Your faction invite to " .. targetPlayerName .. " has expired as they didn't respond.", source, 255, 255, 0)
			end
		end, 30000, 1)
	end
end
addEvent("faction:inviteMemberToFaction", true)
addEventHandler("faction:inviteMemberToFaction", root, addFactionMember)

---------------------------------------------------------------------------------------------------

function menuEditMemberCall(factionID, memberName, factionRanks)
	local characterID = exports.global:getCharacterIDFromName(memberName)
	local memberData = exports.mysql:QuerySingle("SELECT `rank`, `isleader` FROM `faction_members` WHERE `characterid` = (?) AND `factionid` = (?);", characterID, factionID)
	local factionDutyPerks = exports.mysql:QueryString("SELECT `duty_groups` FROM `faction_members` WHERE `factionid` = (?);", factionID)
	local factionDutyGroups = exports.mysql:QueryString("SELECT `group_data` FROM `faction_duty_groups` WHERE `factionID` = (?);", factionID)
	if memberData then
		triggerClientEvent(source, "faction:menu:showMemberEditorGUI", source, factionID, memberName, characterID, memberData.rank, memberData.isleader, factionRanks, factionDutyPerks, factionDutyGroups)
	end
end
addEvent("faction:menuEditMemberCall", true)
addEventHandler("faction:menuEditMemberCall", root, menuEditMemberCall)

function kickFactionMember(characterID)
	local factionID = getElementData(source, "character:activefaction")
	local memberName = exports.global:getCharacterNameFromID(characterID)
	local query = exports.mysql:Execute("DELETE FROM `faction_members` WHERE `characterid` = (?) AND `factionid` = (?);", characterID, factionID)
	if query then
		exports.logs:addFactionLog(factionID, source, "[MEMBER REMOVED] Removed " .. memberName .. " from faction.")
		outputChatBox("You have removed " .. memberName .. " from the faction.", source, 0, 255, 0)

		-- If the player who has been kicked is currently online.
		local kickedPlayer = exports.global:getPlayerFromCharacter(characterID)
		if kickedPlayer then
			local newFactionTable = exports.global:getPlayerFactions(characterID)
			blackhawk:changeElementDataEx(kickedPlayer, "character:factions", newFactionTable)
			exports.global:setPlayerToCivilianTeam(kickedPlayer)

			-- Outputs & Logs.
			local thePlayerName = getPlayerName(kickedPlayer):gsub("_", " ")
			local theFaction = exports.data:getElement("team", factionID)
			local factionName = getTeamName(theFaction)
			outputChatBox("You have been removed from the faction '" .. factionName .. "' by " .. getPlayerName(source):gsub("_", " ") .. ".", kickedPlayer, 255, 0, 0)
		end
	else
		outputChatBox("ERROR: Failed to remove " .. tostring(memberName) .. " from faction.", source, 255, 0, 0)
		exports.global:outputDebug("@kickFactionMember: Attempted to remove characterID " .. tostring(characterID) .. " from faction #" .. tostring(factionID) .. " though database entry doesn't exist.")
	end
end
addEvent("faction:menu:kickFactionMember", true)
addEventHandler("faction:menu:kickFactionMember", root, kickFactionMember)

function menuEditUpdatePlayer(factionID, characterID, playerName, selectedRank, selectedRankName, leaderStatus, playerDutyGroups)
	local oldData = exports.mysql:QuerySingle("SELECT `rank`, `isleader` FROM `faction_members` WHERE `characterid` = (?) AND `factionid` = (?);", characterID, factionID)
	local query = exports.mysql:Execute(
		"UPDATE `faction_members` SET `rank` = (?), `isleader` = (?), `duty_groups` = (?) WHERE `characterid` = (?) AND `factionid` = (?);",
		selectedRank, leaderStatus, playerDutyGroups, characterID, factionID
	)
	if query then
		exports.logs:addFactionLog(factionID, source, "[MEMBER ADJUSTED] " .. getPlayerName(source):gsub("_", " ") .. " updated " .. playerName .. ".")
		if oldData.rank ~= selectedRank then
			local state = "promoted"; if oldData.rank > selectedRank then state = "demoted" end
			exports.logs:addFactionLog(factionID, source, "[RANK ADJUSTED] " .. getPlayerName(source):gsub("_", " ") .. " " .. state .. " " .. playerName .. " and set their rank to " .. selectedRankName .. ".")
		end

		if oldData.isleader ~= leaderStatus then
			if (leaderStatus == 1) then
				exports.logs:addFactionLog(factionID, source, "[LEADER ADDED] Added " .. playerName .. " as a faction leader.")
			else
				exports.logs:addFactionLog(factionID, source, "[LEADER REMOVED] Removed " .. playerName .. "'s faction leader status.")
			end
		end
		outputChatBox("You have updated " .. playerName .. ".", source, 0, 255, 0)
	else
		outputChatBox("ERROR: Something went wrong whilst updating the " .. playerName .. "'s information.", source, 255, 0, 0)
	end
end
addEvent("faction:menu:updateMemberCall", true)
addEventHandler("faction:menu:updateMemberCall", root, menuEditUpdatePlayer)

---------------------------------------------------------------------------------------------------

function saveFactionNotes(factionID, facNotes, leaderNotes)
	local theFaction = exports.data:getElement("team", factionID)
	if theFaction then
		blackhawk:changeElementDataEx(theFaction, "faction:note", facNotes)
		blackhawk:changeElementDataEx(theFaction, "faction:leadernote", leaderNotes)

		outputChatBox("You have updated the faction notes.", source, 75, 230, 10)
		exports.logs:addFactionLog(factionID, source, "[NOTES UPDATED] Updated faction notes.")
	end
end
addEvent("faction:menu:saveFactionNotes", true)
addEventHandler("faction:menu:saveFactionNotes", root, saveFactionNotes)

---------------------------------------------------------------------------------------------------

function respawnFactionVehicle(vehicleID)
	local respawned, reason = respawnFactionVehicle(source, vehicleID)
	if respawned then
		local factionID = getElementData(source, "character:activefaction")
		exports.logs:addFactionLog(factionID, source, "[VEHICLE RESPAWN] Respawned faction vehicle #" .. vehicleID .. ".")
		outputChatBox("You have respawned faction vehicle #" .. vehicleID .. ".", source, 0, 255, 0)
	else
		outputChatBox(reason, source, 255, 0, 0)
	end
end
addEvent("faction:menu:respawnFactionVehicle", true)
addEventHandler("faction:menu:respawnFactionVehicle", root, respawnFactionVehicle)

function respawnAllFactionVehicles(thePlayer)
	local factionID = getElementData(thePlayer, "character:activefaction")
	exports.global:sendMessageToFaction(factionID, "[WARN] All faction vehicles will be respawned in 15 seconds.", true)
	local factionVehicles = exports.mysql:Query("SELECT `id` FROM `vehicles` WHERE `faction` = (?) AND `deleted` <> 1;", factionID)
	setTimer(function()
		for i, veh in ipairs(factionVehicles) do
			local respawned, reason = respawnFactionVehicle(thePlayer, veh.id)
			if not respawned then outputChatBox(reason, thePlayer, 255, 0, 0) end
		end
		exports.logs:addFactionLog(factionID, thePlayer, "[VEHICLE RESPAWN] Respawned all faction vehicles.")
		outputChatBox("You have respawned all faction vehicles.", thePlayer, 0, 255, 0)
		exports.global:sendMessageToFaction(factionID, "[WARN] All faction vehicles have been respawned.")
	end, 15000, 1)
end
addEvent("faction:menu:respawnAllFactionVehicles", true)
addEventHandler("faction:menu:respawnAllFactionVehicles", root, respawnAllFactionVehicles)

function respawnFactionVehicle(thePlayer, vehicleID)
	local theVehicle = exports.data:getElement("vehicle", vehicleID)
	local respawned, reason = false, "ERROR: Something went wrong whilst attempting to respawn vehicle #" .. vehicleID .. "."
	if theVehicle then
		local x, y, z, rx, ry, rz = unpack(getElementData(theVehicle, "vehicle:respawnpos"))
		if isVehicleBlown(theVehicle) then fixVehicle(theVehicle) end
		setElementData(theVehicle, "vehicle:brokenengine", 0)

		local vehicleDim = getElementData(theVehicle, "vehicle:dimension") or 0
		local vehicleInt = getElementData(theVehicle, "vehicle:interior") or 0
		local occupantCount = 0
		for seat, occupant in pairs (getVehicleOccupants(theVehicle)) do occupantCount = occupantCount + 1 end
		if occupantCount == 0 then
			respawned, _, reason = exports.global:elementEnterInterior(theVehicle, {x, y, z}, {rx, ry, rz}, vehicleDim, vehicleInt, false, true)
			if respawned then
				local thePlayerName = getPlayerName(thePlayer):gsub("_", " ")
				exports.logs:addVehicleLog(vehicleID, "[FACTION RESPAWNED] " .. thePlayerName .. " respawned the faction vehicle.", thePlayer)
			end
		else
			reason = "Vehicle #" .. vehicleID .. " couldn't be respawned as it's currently occupied."
		end
	else
		reason = "Failed to respawn vehicle #" .. vehicleID .. ", it may currently be deleted."
	end
	return respawned, reason
end

function updateFactionMotd(motdText)
	local factionID = getElementData(source, "character:activefaction")
	local theFaction = exports.data:getElement("team", factionID)
	if theFaction then
		blackhawk:changeElementDataEx(theFaction, "faction:motd", motdText)

		outputChatBox("You have updated the faction MOTD.", source, 75, 230, 10)
		exports.logs:addFactionLog(factionID, source, "[MOTD UPDATED] Updated the faction MOTD.")
	end
end
addEvent("faction:menu:updateFactionMotd", true)
addEventHandler("faction:menu:updateFactionMotd", root, updateFactionMotd)

---------------------------------------------------------------------------------------------------

function updateFactionRanksWages(ranksTable)
	local factionID = getElementData(source, "character:activefaction")
	local theFaction = exports.data:getElement("team", factionID)
	if theFaction then
		blackhawk:changeElementDataEx(theFaction, "faction:ranks", ranksTable)

		outputChatBox("You have updated the faction ranks and wages.", source, 75, 230, 10)
		exports.logs:addFactionLog(factionID, source, "[RANKS/WAGES ADJUSTED] Updated the faction ranks and wages.")
		showFactionMenuCall(source, factionID, true)
	end
end
addEvent("faction:menu:updateFactionRanksWages", true)
addEventHandler("faction:menu:updateFactionRanksWages", root, updateFactionRanksWages)

--------------------------------------------------------------------------------------------------------------------------------------------
--												   END OF FACTION MENU ACTION FUNCTIONS
--												   START OF FACTION DUTY POINT FUNCTIONS
--------------------------------------------------------------------------------------------------------------------------------------------

function fetchFactionDutyLocations()
	local factionID = getElementData(source, "character:activefaction")
	local dutyLocationData = exports.mysql:Query("SELECT * FROM `faction_duty_locations` WHERE `factionid` = (?);", factionID)

	triggerClientEvent(source, "faction:menu:showDutyLocationEditorGUI", source, dutyLocationData, true)
end
addEvent("faction:menu:fetchFactionDutyLocations", true)
addEventHandler("faction:menu:fetchFactionDutyLocations", root, fetchFactionDutyLocations)

function addFactionDutyPoint(dutyName, loc, isVehicle)
	local factionID = getElementData(source, "character:activefaction")

	-- Validate if the vehicle/interior is owned by the faction.
	local isVehicleEntry = 0
	if not isVehicle then
		if (loc[4] == 0) then outputChatBox("ERROR: You must be inside a faction owned interior to add a duty point!", source, 255, 0, 0) return end
		local _, _, ownerID = exports.global:getInteriorOwner(loc[4])
		if ownerID ~= factionID then
			outputChatBox("ERROR: Duty points can only be set inside interiors owned by your faction!", source, 255, 0, 0)
			return false
		end
	else
		isVehicleEntry = 1
		local vehOwner = getElementData(isVehicle, "vehicle:owner") or 0
		if -vehOwner ~= factionID then
			outputChatBox("ERROR: Duty points cannot be set in vehicles that aren't owned by your faction!", source, 255, 0, 0)
			return
		end
	end

	local dutyExists = exports.mysql:QueryString(
		"SELECT `location` FROM `faction_duty_locations` WHERE `name` = (?) AND `factionid` = (?);",
		dutyName, factionID
	)
	if dutyExists then
		outputChatBox("ERROR: A duty point with that name already exists!", source, 255, 0, 0)
		return false
	end

	local locationString
	if not isVehicle then
		locationString = loc[1]..","..loc[2]..","..loc[3]..","..loc[4]..","..loc[5]
	else
		locationString = loc[1]
	end

	local query = exports.mysql:Execute(
		"INSERT INTO `faction_duty_locations` (`id`, `factionid`, `name`, `isvehicle`, `location`) VALUES (NULL, (?), (?), (?), (?));",
		factionID, dutyName, isVehicleEntry, locationString
	)
	if query then
		local dutyLocationData = exports.mysql:Query("SELECT * FROM `faction_duty_locations` WHERE `factionid` = (?);", factionID)
		triggerClientEvent(source, "faction:menu:showDutyLocationEditorGUI", source, dutyLocationData, false)
		exports.logs:addFactionLog(factionID, source, "[DUTY POINT CREATED] Added new duty point '" .. dutyName .. "'.")
	else
		outputChatBox("ERROR: Failed to save duty location to database.", source, 255, 0, 0)
	end
end
addEvent("faction:menu:addFactionDutyPoint", true)
addEventHandler("faction:menu:addFactionDutyPoint", root, addFactionDutyPoint)

function removeFactionDutyPoint(dutyName)
	local factionID = getElementData(source, "character:activefaction")

	local query = exports.mysql:Execute("DELETE FROM `faction_duty_locations` WHERE `factionid` = (?) AND `name` = (?);", factionID, dutyName)
	if query then
		outputChatBox("You have deleted duty location point '" .. dutyName .. "'.", source, 0, 255, 0)
		local dutyLocationData = exports.mysql:Query("SELECT * FROM `faction_duty_locations` WHERE `factionid` = (?);", factionID)
		triggerClientEvent(source, "faction:menu:showDutyLocationEditorGUI", source, dutyLocationData, false)
		exports.logs:addFactionLog(factionID, source, "[DUTY POINT DELETED] Removed duty location '" .. dutyName .. "'.")
	else
		outputChatBox("ERROR: Failed to save changes to database.", source, 255, 0, 0)
	end
end
addEvent("faction:menu:removeFactionDutyPoint", true)
addEventHandler("faction:menu:removeFactionDutyPoint", root, removeFactionDutyPoint)

--------------------------------------------------------------------------------------------------------------------------------------------
--												  END OF FACTION DUTY POINT FUNCTIONS
--											 START OF FACTION MENU DUTY MANAGER FUNCTIONS
--------------------------------------------------------------------------------------------------------------------------------------------

function fetchFactionDutyManagerInfo()
	local factionID = getElementData(source, "character:activefaction")

	local groupData = exports.mysql:QueryString("SELECT `group_data` FROM `faction_duty_groups` WHERE `factionid` = (?);", factionID)
	local itemData = exports.mysql:QuerySingle("SELECT `item_table`, `skin_table` FROM `faction_items` WHERE `factionid` = (?);", factionID)
	if not groupData then groupData = '[ [ ] ]' end

	triggerClientEvent(source, "faction:menu:showFactionGroupManager", source, groupData, itemData, true)
end
addEvent("faction:menu:fetchFactionDutyManagerInfo", true)
addEventHandler("faction:menu:fetchFactionDutyManagerInfo", root, fetchFactionDutyManagerInfo)

function factionDutyCreateGroup(groupName, groupWages)
	local factionID = getElementData(source, "character:activefaction")

	local groupData = exports.mysql:QueryString("SELECT `group_data` FROM `faction_duty_groups` WHERE `factionid` = (?);", factionID)
	groupData = fromJSON(groupData)

	local lowestID = 0
	for i, group in ipairs(groupData) do lowestID = i end

	groupData[groupName] = {
		name = groupName,
		wages = groupWages,
		items = {},
		skins = {},
		locations = {},
	}

	groupData = toJSON(groupData)
	local query = exports.mysql:Execute("UPDATE `faction_duty_groups` SET `group_data` = (?) WHERE `factionid` = (?);", groupData, factionID)
	if query then
		local itemData = exports.mysql:QuerySingle("SELECT `item_table`, `skin_table` FROM `faction_items` WHERE `factionid` = (?);", factionID)
		triggerClientEvent(source, "faction:menu:showFactionGroupManager", source, groupData, itemData, false)
		exports.logs:addFactionLog(factionID, source, "[GROUP CREATED] Duty group '" .. groupName .. "' created.")
	else
		outputChatBox("ERROR: Failed to save group to database.", source, 255, 0, 0)
	end
end
addEvent("faction:menu:factionDutyCreateGroup", true)
addEventHandler("faction:menu:factionDutyCreateGroup", root, factionDutyCreateGroup)

function factionDutyDeleteGroup(groupName)
	local factionID = getElementData(source, "character:activefaction")

	local groupData = exports.mysql:QueryString("SELECT `group_data` FROM `faction_duty_groups` WHERE `factionid` = (?);", factionID)

	groupData = fromJSON(groupData)
	groupData[groupName] = nil
	groupData = toJSON(groupData)

	local query = exports.mysql:Execute("UPDATE `faction_duty_groups` SET `group_data` = (?) WHERE `factionid` = (?);", groupData, factionID)
	if query then
		local itemData = exports.mysql:QuerySingle("SELECT `item_table`, `skin_table` FROM `faction_items` WHERE `factionid` = (?);", factionID)
		triggerClientEvent(source, "faction:menu:showFactionGroupManager", source, groupData, itemData, false)
		exports.logs:addFactionLog(factionID, source, "[GROUP DELETED] Duty group '" .. groupName .. "' deleted.")
	else
		outputChatBox("ERROR: Failed to save group to database.", source, 255, 0, 0)
	end
end
addEvent("faction:menu:factionDutyDeleteGroup", true)
addEventHandler("faction:menu:factionDutyDeleteGroup", root, factionDutyDeleteGroup)

function fetchDutyGroupLocationData(groupName)
	local factionID = getElementData(source, "character:activefaction")

	local groupData = exports.mysql:QueryString("SELECT `group_data` FROM `faction_duty_groups` WHERE `factionid` = (?);", factionID)
	local dutyLocations = exports.mysql:Query("SELECT * FROM `faction_duty_locations` WHERE `factionid` = (?);", factionID)
	if groupData and dutyLocations then
		triggerClientEvent(source, "faction:menu:showFactionDutyLocationEditor", source, groupName, groupData, dutyLocations, true)
	else
		outputChatBox("ERROR: Something went wrong whilst fetching faction duty locations.", source, 255, 0, 0)
	end
end
addEvent("faction:menu:fetchDutyGroupLocationData", true)
addEventHandler("faction:menu:fetchDutyGroupLocationData", root, fetchDutyGroupLocationData)

function dutyLocationsUpdateTable(groupData, groupName)
	local factionID = getElementData(source, "character:activefaction")

	local query = exports.mysql:Execute("UPDATE `faction_duty_groups` SET `group_data` = (?) WHERE `factionid` = (?);", groupData, factionID)
	if query then
		exports.logs:addFactionLog(factionID, source, "[DUTY LOCATIONS] Updated duty locations for duty group '" .. groupName .. "'.")
	else
		outputChatBox("ERROR: Something went wrong whilst saving your changes to duty locations.", source, 255, 0, 0)
	end
end
addEvent("faction:menu:dutyLocationsUpdateTable", true)
addEventHandler("faction:menu:dutyLocationsUpdateTable", root, dutyLocationsUpdateTable)

function saveDutyGroupChanges(groupName, groupWages, groupItems, groupSkins)
	local factionID = getElementData(source, "character:activefaction")

	local groupData = exports.mysql:QueryString("SELECT `group_data` FROM `faction_duty_groups` WHERE `factionid` = (?);", factionID)
	groupData = fromJSON(groupData)
	groupData[groupName].wages = groupWages
	groupData[groupName].items = groupItems
	groupData[groupName].skins = groupSkins
	groupData = toJSON(groupData)

	local query = exports.mysql:Execute("UPDATE `faction_duty_groups` SET `group_data` = (?) WHERE `factionid` = (?);", groupData, factionID)
	if query then
		triggerClientEvent(source, "faction:menu:dutyManagerUpdateFeedback", source, "Group Changes\nSaved!")
		exports.logs:addFactionLog(factionID, source, "[DUTY GROUP UPDATED] Adjusted the duty group '" .. groupName .. "'.")
	else
		outputChatBox("ERROR: Something went wrong whilst attempting to save duty group changes.", source, 255, 0, 0)
		triggerClientEvent(source, "faction:menu:dutyManagerUpdateFeedback", source, "Failed To\nSave Changes!")
	end
end
addEvent("faction:menu:saveDutyGroupChanges", true)
addEventHandler("faction:menu:saveDutyGroupChanges", root, saveDutyGroupChanges)

function showVehiclePermEditorMenu(animate)
	local factionID = getElementData(source, "character:activefaction")

	local groupData = exports.mysql:QueryString("SELECT `group_data` FROM `faction_duty_groups` WHERE `factionid` = (?);", factionID)
	local vehicleData = {}

	local factionVehicles = exports.mysql:Query("SELECT `id`, `model`, `faction_perms` FROM `vehicles` WHERE `faction` = (?);", factionID)
	for i, vehicle in ipairs(factionVehicles) do
		local _, vehicleName = exports.global:getVehicleModelInfo(vehicle.model)
		local permTable = fromJSON(vehicle.faction_perms)
		vehicleData[vehicle.id] = {name = vehicleName, groups = permTable}
	end

	triggerClientEvent(source, "faction:menu:showVehiclePermissionEditor", source, groupData, vehicleData, animate)
end
addEvent("faction:menu:showVehiclePermEditorMenu", true)
addEventHandler("faction:menu:showVehiclePermEditorMenu", root, showVehiclePermEditorMenu)

function saveVehicleGroupPermissions(vehicleID, groupPerms)
	local factionID = getElementData(source, "character:activefaction")

	local query = exports.mysql:Execute("UPDATE `vehicles` SET `faction_perms` = (?) WHERE `id` = (?);", groupPerms, vehicleID)
	if query then
		local theVehicle = exports.data:getElement("vehicle", vehicleID)
		if theVehicle then
			exports.blackhawk:changeElementDataEx(theVehicle, "vehicle:factionperms", groupPerms)
		end
		showVehiclePermEditorMenu(false)
		exports.logs:addFactionLog(factionID, source, "[VEHICLE PERM UPDATED] Adjusted usage permissions for vehicle #" .. vehicleID .. ".")
	else
		outputChatBox("ERROR: Something went wrong whilst updating the faction vehicle permissions.", source, 255, 0, 0)
	end
end
addEvent("faction:menu:saveVehicleGroupPermissions", true)
addEventHandler("faction:menu:saveVehicleGroupPermissions", root, saveVehicleGroupPermissions)