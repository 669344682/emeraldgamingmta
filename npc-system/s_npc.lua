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

local maleSkins = {7,14,15,17,20,21,24,25,26,29,35,36,37,44,46,57,58,59,60,68,72,98,147,185,186,187,223,227,228,234,235,240,258,259}
local femaleSkins = {9,11,12,40,41,55,56,69,76,88,89,91,93,129,130,141,148,150,151,190,191,192,193,194,196,211,215,216,219,224,225,226,233,263}

-- /createnpc [Skin ID] [Type] [Name] - by Skully (29/09/18) [Trial Admin]
function createNPCCmd(thePlayer, commandName, skin, npcType, ...)
	if exports.global:isPlayerTrialAdmin(thePlayer) then
		if not tonumber(skin) or not tonumber(npcType) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Skin ID] [Type] [Name]", thePlayer, 75, 230, 10)
			return
		end

		-- Check if the skin ID is valid.
		local skinID = tonumber(skin)
		if not exports.global:isValidSkin(skinID) then
			outputChatBox("ERROR: That is not a valid skin ID!", thePlayer, 255, 0, 0)
			return false
		end

		-- Check if the NPC type is valid.
		npcType = tonumber(npcType)
		if (npcType < 0) or (npcType > 2) then
			outputChatBox("ERROR: That is not a valid NPC type!", thePlayer, 255, 0, 0)
			-- Show NPC type list @Skully
			return false
		end

		-- Restrict NPC name length to 25.
		local name = table.concat({...}, " ")
		if string.len(name) > 25 then
			outputChatBox("ERROR: The NPC name cannot be longer than 25 characters.", thePlayer, 255, 0, 0)
			return false
		end

		-- If the player didn't specify a NPC name, generate a random one.
		if not name or name == "" then
			if exports.global:table_find(skinID, maleSkins) then -- If the skin is a male skin, get a male name.
				name = exports.global:generateRPName("full", "male")
			else -- otherwise must be a female skin, so get a female name.
				name = exports.global:generateRPName("full", "female")
			end
		end

		local theNPC, reason = createNPC(thePlayer, skinID, npcType, name)
		if (theNPC) then
			local thePlayerName = exports.global:getStaffTitle(thePlayer)
			local npcID = getElementData(theNPC, "npc:id")
			outputChatBox("You have created NPC #" .. npcID .. " with the name '" .. name .. "'.", thePlayer, 0, 255, 0)
			exports.global:sendMessageToManagers("[INFO] " .. thePlayerName .. " has created NPC #" .. npcID .. " (Type " .. npcType .. ") with the name '" .. name .. "'.")
		else
			outputChatBox("ERROR: " .. reason, thePlayer, 255, 0, 0)
			return false
		end
	end
end
addCommandHandler("makenpc", createNPCCmd)
addCommandHandler("createnpc", createNPCCmd)
addCommandHandler("makeped", createNPCCmd)

-- /delnpc [NPC ID] - by Skully (25/08/17) [Trial Admin]
function removeNPC(thePlayer, commandName, npcid)
	if exports.global:isPlayerTrialAdmin(thePlayer) then
		if not (npcid) then
			outputChatBox("SYNTAX: /" .. commandName .. " [NPC ID]", thePlayer, 75, 230, 10)
		else

			local npc = tonumber(npcid)
			local thePed = exports.data:getElement("ped", npc)
			local thePlayerName = getPlayerName(thePlayer)
			local thePlayerTitle = exports.global:getStaffTitle(thePlayer)
			if not (thePed) then
				outputChatBox("ERROR: An NPC with that ID does not exist!", thePlayer, 255, 0, 0)
				return false
			end
			destroyElement(thePed)
			exports.mysql:Execute("DELETE FROM `npcs` WHERE `npcs`.`id` = (?);", npc)

			-- Output messages.
			outputChatBox("You have deleted the NPC with ID " .. npc .. ".", thePlayer, 75, 230, 10)
			exports.global:sendMessageToManagers("[INFO] " .. thePlayerTitle .. " " .. thePlayerName .. " has deleted an NPC. [NPC ID " .. npc .. "]")
		end
	end
end
addCommandHandler("delnpc", removeNPC)
addCommandHandler("deletenpc", removeNPC)