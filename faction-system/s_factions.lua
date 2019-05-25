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

-- /acceptfaction - By Skully (03/07/18) [Player]
function acceptFactionInvite(thePlayer)
	if (getElementData(thePlayer, "loggedin") == 1) then
		local hasInvite = getElementData(thePlayer, "temp:faction:facinvite")
		if hasInvite then
			local fromPlayer, theFaction, rankID = unpack(hasInvite)
			removeElementData(thePlayer, "temp:faction:facinvite")
			local playerFactions = getElementData(thePlayer, "character:factions")
			if (playerFactions[3] ~= 0) then
				outputChatBox("ERROR: You are already in the maximum limit of 3 factions and cannot join another.", thePlayer, 255, 0, 0)
				return false
			end

			local factionID = getElementData(theFaction, "faction:id")
			local characterID = getElementData(thePlayer, "character:id")
			local query = exports.mysql:Execute(
				"INSERT INTO `faction_members` (`characterid`, `factionid`, `rank`, `duty_groups`, `isleader`) VALUES ((?), (?), (?), '[ [ ] ]', '0');",
				characterID, factionID, rankID
			)
			if query then
				local newFactionTable = exports.global:getPlayerFactions(characterID)
				blackhawk:changeElementDataEx(thePlayer, "character:factions", newFactionTable)

				-- Outputs & Logs.
				local factionName = getElementData(theFaction, "faction:name")
				local rankName = exports.global:getFactionRank(rankID, factionID)
				local fromPlayerName = getPlayerName(fromPlayer):gsub("_", " ")
				local thePlayerName = getPlayerName(thePlayer):gsub("_", " ")
				outputChatBox(fromPlayerName .. " has accepted your faction invite.", thePlayer, 255, 255, 0)
				outputChatBox("You have joined the faction '" .. factionName .. "' with the rank '" .. rankName .. "'.", thePlayer, 255, 255, 0)
				exports.logs:addLog(thePlayer, 5, {fromPlayer, theFaction}, "(/acceptfaction) " .. thePlayerName .. " accepted faction invite from " .. fromPlayerName .. " to join faction '" .. factionName .. "' with the rank of '" .. rankName .. "'.")
				exports.logs:addFactionLog(factionID, thePlayer, "[MEMBER JOINED] " .. thePlayerName .. " joined the rank with the rank " .. rankName .. ".")
			else
				outputChatBox("ERROR: Something went wrong whilst attempting to join the faction.", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("You don't have any pending faction invites.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("acceptfaction", acceptFactionInvite)

-- /f [Message] - By Skully (18/07/18) [Player]
function factionChat(thePlayer, commandName, ...)
	if (getElementData(thePlayer, "loggedin") == 1) then
		local factionID = getElementData(thePlayer, "character:activefaction") or 0
		local theFaction = exports.data:getElement("team", factionID)

		if theFaction then
			if not (...) then
				outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 75, 230, 10)
			else
				local factionMembers = getPlayersInTeam(theFaction)
				local factionAbbr = getElementData(theFaction, "faction:abbreviation")
				local affectedElements = {theFaction}
				local message = table.concat({...}, " ")
				local thePlayerName = getPlayerName(thePlayer):gsub("_", " ")
				for i, member in pairs(factionMembers) do
					outputChatBox("[" .. factionAbbr .. "] " .. thePlayerName .. ": " .. message, member, 0, 200, 255)
					table.insert(affectedElements, member)
				end

				exports.logs:addLog(thePlayer, 39, affectedElements, "[" .. factionAbbr .. "] " .. thePlayerName .. ": " .. message)
			end
		else
			outputChatBox("You don't have any faction selected to speak in.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("f", factionChat)

-- /fl [Message] - By Skully (18/07/18) [Player]
function factionLeaderChat(thePlayer, commandName, ...)
	if (getElementData(thePlayer, "loggedin") == 1) then
		local factionID = getElementData(thePlayer, "character:activefaction") or 0
		local theFaction = exports.data:getElement("team", factionID)
		if theFaction then
			if exports.global:isPlayerFactionLeader(thePlayer, factionID) then
				if not (...) then
					outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 75, 230, 10)
				else
					local factionMembers = getPlayersInTeam(theFaction)
					local factionAbbr = getElementData(theFaction, "faction:abbreviation")
					local affectedElements = {theFaction}
					local message = table.concat({...}, " ")
					local thePlayerName = getPlayerName(thePlayer):gsub("_", " ")
					for i, member in pairs(factionMembers) do
						if exports.global:isPlayerFactionLeader(member, factionID) then
							outputChatBox("[" .. factionAbbr .. " Leader] " .. thePlayerName .. ": " .. message, member, 100, 192, 255)
							table.insert(affectedElements, member)
						end
					end

					exports.logs:addLog(thePlayer, 46, affectedElements, "[" .. factionAbbr .. " Leader] " .. thePlayerName .. ": " .. message)
				end
			end
		end
	end
end
addCommandHandler("fl", factionLeaderChat)

-- /fannounce [Message] - By Skully (21/07/18) [Player]
function factionAnnounce(thePlayer, commandName, ...)
	if (getElementData(thePlayer, "loggedin") == 1) then
		local factionID = getElementData(thePlayer, "character:activefaction") or 0
		local theFaction = exports.data:getElement("team", factionID)
		if theFaction then
			if exports.global:isPlayerFactionLeader(thePlayer, factionID) then
				if not (...) then
					outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 75, 230, 10)
				else
					local factionMembers = {}
					local membersQuery = exports.mysql:Query("SELECT `characterid` FROM `faction_members` WHERE `factionid` = (?);", factionID)
					for i, char in ipairs(membersQuery) do
						local facPlayer = exports.global:getPlayerFromCharacter(char.characterid)
						if facPlayer then table.insert(factionMembers, facPlayer) end
					end

					local factionAbbr = getElementData(theFaction, "faction:abbreviation")
					local affectedElements = {theFaction}
					local message = table.concat({...}, " ")
					local thePlayerName = getPlayerName(thePlayer):gsub("_", " ")
					for i, member in pairs(factionMembers) do
						playSoundFrontEnd(member, 43)
						outputChatBox(" ", member)
						outputChatBox("[" .. factionAbbr .. " Announcement from " .. thePlayerName .. "]", member, 100, 250, 250)
						outputChatBox(message, member, 100, 250, 250)
						-- Send announcement notification to member. @requires notification-system
						table.insert(affectedElements, member)
					end

					exports.logs:addLog(thePlayer, 46, affectedElements, "[" .. factionAbbr .. " Announcement] " .. thePlayerName .. ": " .. message)
				end
			end
		end
	end
end
addCommandHandler("fannounce", factionAnnounce)