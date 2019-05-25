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

function createNPC(thePlayer, skinID, npcType, npcName)
	if not isElement(thePlayer) then exports.global:outputDebug("@createNPC: thePlayer not provided or is not an element.") return false end

	local x, y, z = getElementPosition(thePlayer) -- Location where the NPC will be.
	local _, _, rz = getElementRotation(thePlayer) -- Rotation of the NPC.
	local dimension, interior = getElementDimension(thePlayer), getElementInterior(thePlayer)

	local locationString = x..","..y..","..z..","..rz
	local createdby = getElementData(thePlayer, "account:username")

	-- Get the lowest available NPC ID.
	local nextID = exports.mysql:QueryString("SELECT MIN(e1.id+1) AS dbid FROM `npcs` AS e1 LEFT JOIN `npcs` AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL")
	nextID = tonumber(nextID) or 1

	local query = exports.mysql:Execute(
		"INSERT INTO `npcs` (`id`, `name`, `skin`, `type`, `location`, `dimension`, `interior`, `createdby`) VALUES ((?), (?), (?), (?), (?), (?), (?), (?));",
		nextID, npcName, skinID, npcType, locationString, dimension, interior, createdby
	)
	if query then
		local loadedNPC, reason = loadNPC(nextID)
		return loadedNPC, reason
	else
		outputChatBox("ERROR: Failed to save NPC to database.", thePlayer, 255, 0, 0)
		exports.global:outputDebug("@createNPC: Failed to create NPC, is there an active database connection?")
	end
	return false, "Something went wrong whilst creating the NPC."
end

function loadNPC(npcID)
	if not tonumber(npcID) then exports.global:outputDebug("@loadNPC: npcID not provided or is not a numerical value.") return false end

	local npcData = exports.mysql:QuerySingle("SELECT * FROM `npcs` WHERE `id` = (?);", npcID)
	if not npcData then
		exports.global:outputDebug("@loadNPC: Attempted to load NPC #" .. npcID .. " though NPC does not exist.")
		return false, "NPC ID provided does not exist!"
	end

	-- Create the NPC element and allocate it.
	local location = split(npcData.location, ",")
	local theNPC = createPed(npcData.skin, location[1], location[2], location[3], location[4])
	if (theNPC) then
		exports.data:allocateElement(theNPC, npcID)

		-- Start setting element data.
		blackhawk:setElementDataEx(theNPC, "npc:id", tonumber(npcID), true)
		blackhawk:setElementDataEx(theNPC, "npc_id", tonumber(npcID), true)
		blackhawk:setElementDataEx(theNPC, "npc:name", tostring(npcData.name), true)
		blackhawk:setElementDataEx(theNPC, "name", tostring(npcData.name), true)
		blackhawk:setElementDataEx(theNPC, "npc:skin", npcData.skin, true)
		blackhawk:setElementDataEx(theNPC, "npc:type", npcData.type, true)

		-- Set NPC dimension and interior.
		setElementDimension(theNPC, npcData.dimension)
		setElementInterior(theNPC, npcData.interior)

		return theNPC
	else
		return false, "Something went wrong whilst loading the NPC."
	end
end

function saveNPC(npcID)
	if not tonumber(interiorID) then exports.global:outputDebug("@saveNPC: npcID not provided or is not a numerical value.") return false end

	-- Check if the NPC element exists.
	local theNPC = exports.data:getElement("npc", npcID)
	if not (theNPC) then
		exports.global:outputDebug("@saveNPC: Attempted to save NPC #" .. npcID .. " though NPC element does not exist.")
		return false
	end

	-- If the NPC being saved doesn't exist in the database.
	local npcData = exports.mysql:QueryString("SELECT `name` FROM `npcs` WHERE `id` = (?);", interiorID)
	if not (npcData) then
		exports.global:outputDebug("@saveNPC: Attempted to save NPC #" .. npcID .. " though NPC does not exist in database.")
		return false
	end

	-- Get location data.
	local x, y, z = getElementPosition(theNPC)
	local _, _, rz = getElementRotation(theNPC)
	local dimension, interior = getElementDimension(theNPC), getElementInterior(theNPC)

	-- Get general data.
	local npcName = getElementData(theNPC, "npc:name")
	local npcSkin = getElementModel(theNPC)
	local npcType = getElementData(theNPC, "npc:type")

	local query = exports.mysql:Execute(
		"UPDATE `npcs` SET `name` = (?), `skin` = (?), `type` = (?), `location` = (?), `dimension` = (?), `interior` = (?) WHERE `id` = (?);",
		npcName, npcSkin, npcType, locationString, dimension, interior, npcID
	)
	if query then return true end
	return false
end

function reloadNPC(npcID)
	if not tonumber(interiorID) then exports.global:outputDebug("@reloadNPC: npcID not provided or is not a numerical value.") return false end
	npcID = tonumber(npcID)

	-- Check to see if the NPC element exists.
	local theNPC = exports.data:getElement("npc", npcID)

	if (theNPC) then
		saveNPC(npcID)
		destroyElement(theNPC)
	end

	local loaded = loadNPC(npcID)
	return loaded, "Failed to load NPC."
end