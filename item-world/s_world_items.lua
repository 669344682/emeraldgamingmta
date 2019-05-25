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
| |\ \\ \_/ / |____| |___| |   | |____| | | || |         	Skully
\_| \_|\___/\_____/\____/\_|   \_____/\_| |_/\_/

Created for Emerald Gaming Roleplay, do not distribute - All rights reserved. ]]

-- Function to create items, spawn them in the world and allocateElement.
function createItem(itemID, itemValue, x, y, z, rx, ry, rz, dimension, interior, droppedBy, permissionString)
	if not tonumber(itemID) then exports.global:outputDebug("@createItem: itemID provided is not a numerical value.") return false, "Invalid itemID provided." end
	if not tostring(itemValue) then exports.global:outputDebug("@createItem: itemValue provided is not a string.") return false, "Invalid itemValue provided." end
	if not tonumber(x) or not tonumber(y) or not tonumber(z) then exports.global:outputDebug("@createItem: Coordinates 'x', 'y' or 'z' not provided.") return false, "Invalid location received." end
	if not tonumber(rx) then rx = 0 end
	if not tonumber(ry) then ry = 0 end
	if not tonumber(rz) then rz = 0 end

	-- Prepare our location string for the database.
	local locationString = x..","..y..","..z..","..rx..","..ry..","..rz

	if not tonumber(dimension) or not tonumber(interior) then exports.global:outputDebug("@createItem: Dimension/Interior provided is not a number.") return false, "Invalid dimension/interior." end
	if (tonumber(dimension) == -1) then exports.global:outputDebug("@createItem: Attempt to drop an item in dimension -1 was prevented.", 3) return false, "Cannot drop items in dimension -1!" end
	if (droppedBy) then
		if type(droppedBy) == "userdata" then -- If it was dropped by an element (player).
			droppedBy = getElementData(droppedBy, "account:id"); droppedBy = tonumber(droppedBy)
			if not tonumber(droppedBy) then exports.global:outputDebug("@createItem: droppedBy player received though could not determine account:id.") return false, "Cannot determine item dropper." end
		elseif tonumber(droppedBy) then
			droppedBy = tonumber(droppedBy)
		end
	else
		exports.global:outputDebug("@createItem: Failed to fetch ID of droppedBy player, defaulting to 0.", 2)
		droppedBy = 0
	end
	if not tostring(permissionString) then exports.global:outputDebug("@createItem: permissionString provided is not a string.") return false, "Invalid permission node." end

	itemID = tonumber(itemID)
	itemValue = tostring(itemValue)
	locationString = tostring(locationString)
	dimension = tonumber(dimension)
	interior = tonumber(interior)
	droppedBy = tonumber(droppedBy)
	permissionString = tostring(permissionString)
	local timeNow = exports.global:getCurrentTime(); timeNow = tostring(timeNow[3])

	-- Get the lowest possible primary key from the table.
	local nextID = exports.mysql:QueryString("SELECT MIN(e1.id+1) AS dbid FROM `items_world` AS e1 LEFT JOIN `items_world` AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL")
	nextID = tonumber(nextID) or 1

	local query = exports.mysql:Execute("INSERT INTO `items_world` (`id`, `item_id`, `item_value`, `location`, `dimension`, `interior`, `dropped_by`, `created`, `permissions`, `last_updated`) VALUES ((?), (?), (?), (?), (?), (?), (?), (?), (?), (?));", nextID, itemID, itemValue, locationString, dimension, interior, droppedBy, timeNow, permissionString, timeNow)
	if (query) then
		local objectID = exports["item-system"]:getItemObjectID(itemID)
		local object = createObject(objectID, x, y, z, rx, ry, rz)

		-- If object creation failed due to invalid ID or location.
		if not (object) then
			exports.mysql:Execute("DELETE FROM `items_world` WHERE `id` = (?);", id)
			exports.global:outputDebug("@createItem: Deleted bugged item #" .. tostring(id) .. " from database, failed to createObject.")
			return false, "Failed to create object element."
		end

		exports.data:allocateElement(object, nextID)
		setItemData(object, {"id", "objectid", "value", "location", "dimension", "interior", "droppedby", "permissions"}, {id, itemID, itemValue, locationString, dimension, interior, droppedBy, permissionString}, true)
		setElementDimension(object, dimension)
		setElementInterior(object, interior)
		return object
	else
		exports.global:outputDebug("@CreateItem: Failed to insert item into database, is there an active database connection?")
		return false, "Failed to save item into database!"
	end
end
addEvent("itemworld:createItem", true)
addEventHandler("itemworld:createItem", root, createItem)

-- Function to delete the given item.
function deleteItem(itemID)
	if not tonumber(itemID) then exports.global:outputDebug("@deleteItem: itemID provided is not a numerical value.") return false, "Invalid itemID provided." end

	local object = exports.data:getElement("object", itemID)
	if not isElement(object) then -- If object isn't an element, check if it exists in database.
		object = exports.mysql:QueryString("SELECT 1 FROM `items_world` WHERE `id` = (?);", itemID)
		if not object then -- Object isn't in database and is not an element.
			return true, "Item not in database and not an element." -- Object doesn't exist in-game or in database, job done - return true (:
		end
	else destroyElement(object) end -- Object exists, destroy the element.

	-- Remove it from the database.
	local deleted = exports.mysql:Execute("DELETE FROM `items_world` WHERE `id` = (?);", itemID)
	if deleted then return true end

	exports.global:outputDebug("@deleteItem: Failed to delete itemID '" .. tostring(itemID) .. "', is there an active database connection?")
end

-- Function to load one item from database, used by loadAllWorldItems()
function loadWorldItem(dbid)
	local itemData = exports.mysql:QuerySingle("SELECT * FROM `items_world` WHERE `id` = (?);", dbid)

	if (itemData) then
		local id = tonumber(itemData.id)
		local itemID = tonumber(itemData.item_id)
		local itemValue = tostring(itemData.item_value)
		local locationString = tostring(itemData.location); local pos = split(locationString, ",")
		local dimension = tonumber(itemData.dimension)
		local interior = tonumber(itemData.interior)
		local droppedBy = tonumber(itemData.dropped_by)
		local createdString = itemData.created
		local permissionString = tostring(itemData.permissions)

		local objectID = exports["item-system"]:getItemObjectID(itemID)
		local object = createObject(objectID, pos[1], pos[2], pos[3], pos[4], pos[5], pos[6])

		if isElement(object) then
			exports.data:allocateElement(object, id)
			setItemData(object, {"id", "objectid", "value", "location", "dimension", "interior", "droppedby", "permissions"}, {id, itemID, itemValue, locationString, dimension, interior, droppedBy, permissionString}, true)
			setElementDimension(object, dimension)
			setElementInterior(object, interior)
		else
			exports.global:outputDebug("@loadWorldItem: Failed to load item #" .. tostring(itemID) .. ", deleting from database to prevent future issues.", 2)
			local deleted, reason = deleteItem(id)
			if not deleted then
				exports.global:outputDebug("@loadWorldItem: Failed to delete bugged item #" .. tostring(itemID) .. ": " .. tostring(reason))
			end
		end
	else
		exports.global:outputDebug("@loadWorldItem: Attempted to load itemData of an item that does not exist in database.")
		return false
	end
end

-- Loads all world items from database onResourceStart.
function loadAllWorldItems()
	local allItems = exports.mysql:Query("SELECT `id` FROM `items_world`;")
	if not (allItems) then return end

	local delay = 50
	for index, item in ipairs(allItems) do
		setTimer(loadWorldItem, delay, 1, tonumber(item.id))
		delay = delay + 50
	end

	exports.global:outputDebug("Loading " .. #allItems .. " items, estimated time to load: " .. (delay/1000) .. " seconds.", 3)
end
addEventHandler("onResourceStart", resourceRoot, loadAllWorldItems)

--[[ setItemData(element, key, value, [noDBSync])
Sets item elementData as well as updating database information accordingly to keep information in sync.
Note that this function's key and value and also be a table containing all the data to set.
noDBSync is passed by createItem to declare not to update database information again. 			]]
function setItemData(element, key, value, noDBSync)
	if not isElement(element) then exports.global:outputDebug("@setItemData: item not provided or is not an element.") return false end
	if not (key) or not (value) then exports.global:outputDebug("@setItemData: key or value not provided, or are invalid types.") return false end

	local keyTable = {}
	local valueTable = {}
	if type(key) == "table" and type(value) == "table" then
		keyTable = key
		valueTable = value
	else
		keyTable = {key}
		valueTable = {value}
	end

	if (noDBSync) then
		for i, keyValue in ipairs(keyTable) do
			setElementData(element, "object:" .. keyValue, valueTable[i])
		end
		return true
	end

	local itemID = getElementData(element, "object:id")
	if not tonumber(itemID) then return false end

	for i, keyValue in ipairs(keyTable) do
		setElementData(element, "object:" .. keyValue, valueTable[i])
		if (keyValue == "id") then
			exports.mysql:Execute("UPDATE `items_world` SET `id` = (?) WHERE `id` = (?);", valueTable[i], itemID)
		elseif (keyValue == "objectid") then
			exports.mysql:Execute("UPDATE `items_world` SET `item_id` = (?) WHERE `id` = (?);", valueTable[i], itemID)
		elseif (keyValue == "value") then
			exports.mysql:Execute("UPDATE `items_world` SET `item_value` = (?) WHERE `id` = (?);", valueTable[i], itemID)
		elseif (keyValue == "location") then
			exports.mysql:Execute("UPDATE `items_world` SET `location` = (?) WHERE `id` = (?);", valueTable[i], itemID)
		elseif (keyValue == "dimension") then
			if (getElementDimension(element) ~= tonumber(valueTable[i])) then -- Maintain sync.
				exports.global:outputDebug("@setItemData: objectID " .. itemID .. "'s dimension was not in synced to its new value, adjusting it now.", 2)
				setElementDimension(element, tonumber(valueTable[i]))
			end
			exports.mysql:Execute("UPDATE `items_world` SET `dimension` = (?) WHERE `id` = (?);", valueTable[i], itemID)
		elseif (keyValue == "interior") then
			if (getElementInterior(element) ~= tonumber(valueTable[i])) then -- Maintain sync.
				exports.global:outputDebug("@setItemData: objectID " .. itemID .. "'s interior was not in synced to its new value, adjusting it now.", 2)
				setElementInterior(element, tonumber(valueTable[i]))
			end
			exports.mysql:Execute("UPDATE `items_world` SET `interior` = (?) WHERE `id` = (?);", valueTable[i], itemID)
		elseif (keyValue == "droppedby") then
			exports.mysql:Execute("UPDATE `items_world` SET `dropped_by` = (?) WHERE `id` = (?);", valueTable[i], itemID)
		elseif (keyValue == "permissions") then
			exports.mysql:Execute("UPDATE `items_world` SET `permissions` = (?) WHERE `id` = (?);", valueTable[i], itemID)
		end
	end

	local timeNow = exports.global:getCurrentTime()
	exports.mysql:Execute("UPDATE `items_world` SET `last_updated` = (?) WHERE `id` = (?);", timeNow[3], itemID)
	return true
end
	

------------------------------------------------- [DEBUG CONTENT BELOW] -------------------------------------------------
function debugCreateItem(thePlayer, commandName, itemID, itemValue)
	if exports.global:isPlayerLeadManager(thePlayer) then
		if not tonumber(itemID) or not tostring(itemValue) then
			outputChatBox("SYNTAX: /" .. commandName .. " [itemID] [itemValue]", thePlayer, 75, 230, 10)
			return false
		end

		local x, y, z = getElementPosition(thePlayer)
		local rx, ry, rz = getElementRotation(thePlayer)
		local dimension = getElementDimension(thePlayer)
		local interior = getElementInterior(thePlayer)
		local droppedBy = getElementData(thePlayer, "account:id")

		x = x - math.sin(math.rad(rz)) * 2
		y = y + math.cos(math.rad(rz)) * 2
		rz = rz + math.cos(math.rad(rz))
		itemID = tonumber(itemID)

		local itemTable = exports["item-system"]:getItem(itemID)
		if not (itemTable) then
			outputChatBox("ERROR: An item with that ID does not exist!", thePlayer, 255, 0, 0)
			return false
		end
		local object, reason = createItem(itemTable[1], itemValue, x, y, z, rx, ry, rz, dimension, interior, droppedBy, "testPermString")
		if (object) then
			outputChatBox("Object with ID #" .. itemID .. " successfully created.", thePlayer, 75, 230, 10)
		else
			outputChatBox("ERROR: Failed to create object: " .. reason, thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("createitem", debugCreateItem)

function deleteItemCmd(thePlayer, commandName, itemID)
	if exports.global:isPlayerLeadManager(p) then
		if not tonumber(thePlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Item ID]", thePlayer, 75, 230, 10)
			return
		end

		local deleted, reason = deleteItem(tonumber(itemID))
		if deleted then
			outputChatBox("Successfully deleted item #" .. itemID .. ".", thePlayer, 75, 230, 10)
		else
			outputChatBox("ERROR: Failed to delete item: " .. reason, thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("delitem", deleteItemCmd)