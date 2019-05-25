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

-- /setplayerfaction [Player/ID] [Faction ID] - By Skully (01/07/18) [Admin/Faction Leader]
function setPlayerFaction(thePlayer, commandName, targetPlayer, factionID, rankID)
	if exports.global:isPlayerAdmin(thePlayer) or exports.global:isPlayerFactionTeamLeader(thePlayer) then
		if not targetPlayer or not (factionID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player/ID] [Faction ID] (Rank [1-20])", thePlayer, 75, 230, 10)
			return
		end

		rankID = tonumber(rankID) or NUMBER_OF_RANKS
		if (rankID < 1) or (rankID > NUMBER_OF_RANKS) then
			outputChatBox("ERROR: Rank ID must be between 1 and " .. NUMBER_OF_RANKS .. ".", thePlayer, 255, 0, 0)
			return false
		end

		local targetPlayer, targetPlayerName = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)
		if targetPlayer then
			-- Check if player has a vacant faction slot.
			local playerFactions = getElementData(targetPlayer, "character:factions")
			if (playerFactions[3] ~= 0) then
				outputChatBox("ERROR: " .. targetPlayerName .. " is already a part of the maximum limit of 3 factions!", thePlayer, 255, 0, 0)
				return false
			end

			local theFaction, factionID, factionName = exports.global:getFactionFromID(factionID, thePlayer)
			
			if theFaction then
				-- Ensure player isn't already in the faction.
				if exports.global:isPlayerInFaction(targetPlayer, factionID) then
					outputChatBox("ERROR: " .. targetPlayerName .. " is already in faction #" .. factionID .. ".", thePlayer, 255, 0, 0)
					return false
				end

				local characterID = getElementData(targetPlayer, "character:id")
				local query = exports.mysql:Execute(
					"INSERT INTO `faction_members` (`characterid`, `factionid`, `rank`, `duty_groups`, `isleader`) VALUES ((?), (?), (?), '[ [ ] ]', '0');",
					characterID, factionID, rankID
				)
				if query then
					local newFactionTable = exports.global:getPlayerFactions(characterID)
					blackhawk:changeElementDataEx(targetPlayer, "character:factions", newFactionTable)

					-- Outputs & logs.
					local thePlayerName = exports.global:getStaffTitle(thePlayer)
					local facRankName  = exports.global:getFactionRank(rankID, factionID)
					outputChatBox("You have added " .. targetPlayerName .. " into the faction " .. factionName .. " with the rank " .. facRankName .. ".", thePlayer, 0, 255, 0)
					outputChatBox(thePlayerName .. " has added you to the faction '" .. factionName .. "' with the rank " .. facRankName .. ".", targetPlayer, 0, 255, 0)
					exports.logs:addLog(thePlayer, 1, {targetPlayer, theFaction}, "(/setplayerfaction) " .. thePlayerName .. " set " .. targetPlayerName .. " into faction with rank '" .. facRankName .. "'.")
					exports.logs:addFactionLog(factionID, thePlayer, "[MEMBER ADDED] Added " .. targetPlayerName .. " into the faction with the rank " .. facRankName .. ".")
				end
			end
		end
	end
end
addCommandHandler("setfaction", setPlayerFaction)
addCommandHandler("setplayerfaction", setPlayerFaction)

-- /setfactionleader [Player/ID] [Faction ID] - By Skully (02/07/18) [Lead Admin/FT Leader]
function setFactionLeader(thePlayer, commandName, targetPlayer, factionID)
	if exports.global:isPlayerLeadAdmin(thePlayer) or exports.global:isPlayerFactionTeamLeader(thePlayer) or exports.global:isPlayerDeveloper(thePlayer) then
		if not targetPlayer or not factionID then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player/ID] [Faction ID]", thePlayer, 75, 230, 10)
			return
		end

		local targetPlayer, targetPlayerName = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)
		if targetPlayer then
			local theFaction, factionID, theFactionName = exports.global:getFactionFromID(factionID, thePlayer)
			if theFaction then
				-- If the player isn't already in the faction, add them into it.
				local isInFaction = exports.global:isPlayerInFaction(targetPlayer, factionID)
				local characterID = getElementData(targetPlayer, "character:id")
				local thePlayerName = exports.global:getStaffTitle(thePlayer)
				if not isInFaction then
					local facRankName = exports.global:getFactionRank(NUMBER_OF_RANKS, factionID)
					exports.mysql:Execute("INSERT INTO `faction_members` (`characterid`, `factionid`, `rank`, `duty_groups`, `isleader`) VALUES ((?), (?), '20', '[ [ ] ]', '1');", characterID, factionID)
					exports.logs:addFactionLog(factionID, thePlayer, "[MEMBER ADDED] Added " .. targetPlayerName .. " into the faction with the rank " .. facRankName .. ".")
				else
					exports.mysql:Execute("UPDATE `faction_members` SET `isleader` = '1' WHERE `characterid` = (?) AND `factionid` = (?);", characterID, factionID)
				end

				local newFactionTable = exports.global:getPlayerFactions(characterID)
				blackhawk:changeElementDataEx(targetPlayer, "character:factions", newFactionTable)

				-- Outputs & logs.
				outputChatBox("You have set " .. targetPlayerName .. " as a faction leader of the faction '" .. theFactionName .. "'.", thePlayer, 0, 255, 0)
				outputChatBox(thePlayerName .. " has set you as a leader of the faction  '" .. theFactionName .. "'.", targetPlayer, 0, 255, 0)
				exports.logs:addLog(thePlayer, 1, {targetPlayer, theFaction}, "(/setfactionleader) " .. thePlayerName .. " set " .. targetPlayerName .. " as a faction leader.")
				exports.logs:addFactionLog(factionID, thePlayer, "[LEADER ADDED] Added " .. targetPlayerName .. " as a faction leader.")
			end
		end
	end
end
addCommandHandler("setfactionleader", setFactionLeader)

-- /factions - By Skully (10/07/18) [Helper]
function showFactionList(thePlayer)
	if exports.global:isPlayerHelper(thePlayer) then
		local factionData = exports.mysql:Query("SELECT `id`, `name`, `abbreviation`, `type`, `max_vehicles`, `max_interiors` FROM `factions` ORDER BY `id` ASC;;")
		local vehicleCountData = {}
		local factionMemberData = {}
		local interiorCountData = {}

		for i, faction in ipairs(factionData) do
			-- Count total members in faction.
			local memberCount = exports.mysql:QueryString("SELECT COUNT(*) FROM `faction_members` WHERE `factionid` = (?);", faction.id)
			factionMemberData[faction.id] = memberCount

			-- Count total vehicles.
			local vehicleCount = exports.mysql:QueryString("SELECT COUNT(*) FROM `vehicles` WHERE `faction` = (?);", faction.id)
			vehicleCountData[faction.id] = vehicleCount

			-- Count total interiors.
			local interiorCount = exports.mysql:QueryString("SELECT COUNT(*) FROM `interiors` WHERE `faction` = (?);", faction.id)
			interiorCountData[faction.id] = interiorCount
		end

		triggerClientEvent(thePlayer, "faction:showFactionListGUI", thePlayer, factionData, vehicleCountData, interiorCountData, factionMemberData)
	end
end
addCommandHandler("factions", showFactionList)
addCommandHandler("factionlist", showFactionList)
addCommandHandler("showfactions", showFactionList)

function editFactionCall(factionID)
	if not tonumber(factionID) then return false end

	local factionData = exports.mysql:QuerySingle("SELECT `id`, `name`, `abbreviation`, `type`, `max_vehicles`, `max_interiors`, `phone` FROM `factions` WHERE `id` = (?);", factionID)
	if factionData then
		triggerClientEvent(source, "faction:showFactionEditor", source, factionData)
	end
end
addEvent("faction:gui:editFactionCall", true) -- Used by /factions GUI.
addEventHandler("faction:gui:editFactionCall", root, editFactionCall)

function updateFactionInfoCall(factionID, factionType, factionName, factionAbbr, vehicleSlots, interiorSlots, factionPhone)
	if not tonumber(factionPhone) then factionPhone = 0 end
	local query = exports.mysql:Execute(
		"UPDATE `factions` SET `name` = (?), `abbreviation` = (?), `type` = (?), `max_vehicles` = (?), `max_interiors` = (?), `phone` = (?) WHERE `id` = (?);",
		factionName, factionAbbr, factionType, vehicleSlots, interiorSlots, factionPhone, factionID
	)
	if query then
		local theFaction = exports.data:getElement("team", factionID)
		blackhawk:changeElementDataEx(theFaction, "faction:name", tostring(factionName))
		blackhawk:changeElementDataEx(theFaction, "faction:abbreviation", tostring(factionAbbr))
		blackhawk:changeElementDataEx(theFaction, "faction:type", tonumber(factionType))
		blackhawk:changeElementDataEx(theFaction, "faction:maxvehicles", tonumber(vehicleSlots))
		blackhawk:changeElementDataEx(theFaction, "faction:maxinteriors", tonumber(interiorSlots))

		-- Outputs & Logs.
		local thePlayerName = exports.global:getStaffTitle(source)
		exports.global:sendMessageToManagers("[INFO] " .. thePlayerName .. " has adjusted faction (#" .. factionID .. ") " .. factionName .. ".", true)
		exports.logs:addLog(source, 1, {theFaction}, "[EDIT FACTION] Faction has been adjusted.")
		exports.logs:addFactionLog(factionID, source, "[FACTION EDITTED] Faction has been adjusted by " .. thePlayerName .. ".")
	else
		outputChatBox("ERROR: Something went wrong whilst saving your adjusted faction changes.", source, 255, 0, 0)
	end
end
addEvent("faction:gui:updateFactionInfoCall", true) -- Used by /factions GUI.
addEventHandler("faction:gui:updateFactionInfoCall", root, updateFactionInfoCall)

-- /deletefaction [Faction ID] - By Skully (06/04/18) [Manager/FT Leader]
function deleteFactionCmd(thePlayer, commandName, factionID)
	if exports.global:isPlayerManager(thePlayer) or exports.global:isPlayerFactionTeamLeader(thePlayer) then
		if not (factionID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Faction ID]", thePlayer, 75, 230, 10)
			return false
		end

		factionID = tonumber(factionID)
		local isDeleted = exports.data:getElement("team", factionID)
		if not (isDeleted) then
			outputChatBox("ERROR: That faction does not exist!", thePlayer, 255, 0, 0)
			return false
		end

		local isRemoving = getElementData(thePlayer, "temp:isremovingfaction")

		if not (isRemoving) or (isRemoving ~= factionID) then
			outputChatBox("[Faction ID #" .. factionID .. "] WARNING: You are about to permanently delete this faction and it can no longer be restored.", thePlayer, 255, 0, 0)
			outputChatBox("[Faction ID #" .. factionID .. "] Type /deletefaction " .. factionID .. " again to confirm deletion.", thePlayer, 255, 0, 0)
			outputChatBox("THIS WILL ALSO PERMANENTLY DELETE THE FACTIONS VEHICLES AND FORCESELL ITS INTERIORS.", thePlayer, 255, 0, 0)
			setElementData(thePlayer, "temp:isremovingfaction", factionID)
			local thePlayerName = exports.global:getStaffTitle(thePlayer)
			exports.global:sendMessageToManagers("[WARN] " .. thePlayerName .. " is attempting to delete faction #" .. factionID .. ".", true, 255, 0, 0)
			return true
		elseif (isRemoving == factionID) then
			removeElementData(thePlayer, "temp:isremovingfaction")

			local deleted, reason = deleteFaction(factionID)
			if (deleted) then
				-- Outputs.
				outputChatBox("You have permanently deleted faction #" .. factionID .. ".", thePlayer, 0, 255, 0)
				local thePlayerName = exports.global:getStaffTitle(thePlayer)
				exports.global:sendMessage("[INFO] " .. thePlayerName .. " has deleted faction #" .. factionID .. ".", 2, true)
				exports.logs:addLog(thePlayer, 1, {thePlayer, "FAC" .. factionID}, "(/deletefaction) " .. thePlayerName .. " has removed faction #" .. factionID .. " from the database.")

			else
				outputChatBox("ERROR: " .. reason, thePlayer, 255, 0, 0)
				return false
			end
		end
	end
end
addCommandHandler("deletefaction", deleteFactionCmd)
addEvent("faction:deletefactioncall", true) -- Used by /factions GUI.
addEventHandler("faction:deletefactioncall", root, deleteFactionCmd)

function showFactionAssetManagerCall(factionID)
	local assetData = exports.mysql:QuerySingle("SELECT `item_table`, `skin_table` FROM `faction_items` WHERE `factionid` = (?);", factionID)
	if assetData then
		triggerClientEvent(source, "faction:gui:showFactionAssetManager", source, factionID, assetData)
	else
		outputChatBox("ERROR: Something went wrong whilst fetching asset data for the faction.", source, 255, 0, 0)
	end
end
addEvent("faction:gui:showFactionAssetManagerCall", true)
addEventHandler("faction:gui:showFactionAssetManagerCall", root, showFactionAssetManagerCall)

function saveFactionAssets(factionID, itemData, skinData)
	local query = exports.mysql:Execute("UPDATE `faction_items` SET `item_table` = (?), `skin_table` = (?) WHERE `factionid` = (?);",
		itemData, skinData, factionID
	)
	if query then
		local thePlayerName = exports.global:getStaffTitle(source)
		exports.logs:addFactionLog(factionID, source, "[FACTION ASSETS] Faction assets have been adjusted by " .. thePlayerName .. ".")
		exports.logs:addLog(source, 5, "FAC"..factionID, "[FACTION ASSETS] Adjusted available assets of faction #" .. factionID .. ".")
	else
		outputChatBox("ERROR: Something went wrong whilst saving faction assets.", source, 255, 0, 0)
	end
end
addEvent("faction:gui:saveFactionAssets", true)
addEventHandler("faction:gui:saveFactionAssets", root, saveFactionAssets)