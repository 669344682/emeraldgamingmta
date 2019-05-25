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

--[[

NOTE FOR DEVELOPERS:
	The table below is a visual display of how the inventoryCache table is structured,
	what indexes are labelled as and what values are stored in which variable.
	The table structure below doesn't allow for items to be deleted by specific itemID.
	(atleast not in an efficient way) - Skully

[Serversided table]
inventoryCache = {
	[thePlayer] = {
		[itemID] = {
			dbid = id,
			value = itemValue,
			protected = true/false,
			amount = 0,
		},
	}	
}

[Clientsided tables]
inventoryContent = {
	[itemID] = {
		[dbid] = {
			id = itemID,
			dbid = dbid,
			value = value,
			protected = true/false,
		}
	}
}

itemsData = {
	[itemID] = {
		image = element,
		label = element,
		amount = 0,
	}	
}

]]

inventoryCache = {}

function cachePlayer(thePlayer)
	if inventoryCache[thePlayer] then inventoryCache[thePlayer] = nil end -- If player already exists in table.
	inventoryCache[thePlayer] = {}
end

function flushPlayer()
	if inventoryCache[source] then inventoryCache[source] = nil end
end
addEventHandler("onPlayerCharacterSelection", root, flushPlayer)
addEventHandler("onPlayerQuit", root, flushPlayer)


function playerHasItem(thePlayer, itemID, itemValue)
	if inventoryCache[thePlayer] then
		if inventoryCache[thePlayer][itemID] and (not itemValue or inventoryCache[thePlayer][itemID].value == itemValue) then
			return true
		end
	else -- Fallback in case player wasn't cached correctly.
		exports.global:outputDebug("@playerHasItem: Player '" .. tostring(getPlayerName(thePlayer)) .. "' inventory not cached, fetching item data from database instead.", 2)
		local characterID = getElementData(thePlayer, "character:id")
		local hasItem = exports.mysql:QueryString("SELECT `id` FROM `items` WHERE `owner` = (?);", characterID)
		local characterID = getElementData(thePlayer, "character:id")
		if hasItem then return true end
	end
	return false
end

--@requires only thePlayer and itemID.
function takeItem(thePlayer, itemID, itemValue)
	if not inventoryCache[thePlayer] then
		exports.global:outputDebug("@takeItem: Attempted to take item '" .. tostring(itemID) .. "' from player '" .. tostring(getPlayerName(thePlayer)) .. "' though player isn't cached.")
		return false
	end

	if not tonumber(itemID) or not (g_itemList[itemID]) then
		exports.global:outputDebug("@takeItem: Attempted to take item '" .. tostring(itemID) .. "' from player '" .. tostring(getPlayerName(thePlayer)) .. "' though itemID is invalid or not a defined item.")
		return false
	end
	itemID = tonumber(itemID)

	if not inventoryCache[thePlayer][itemID] then
		exports.global:outputDebug("@takeItem: Attempted to take item '" .. tostring(itemID) .. "' from player '" .. tostring(getPlayerName(thePlayer)) .. "' though player doesn't have, ensure you check before attempting to take.", 2)
		return false
	end

	-- Remove from database.
	local characterID = getElementData(thePlayer, "character:id")
	local dbid = false
	if not (itemValue) or not tostring(itemValue) or (#itemValue < 1) then
		dbid = exports.mysql:QueryString("SELECT `id` FROM `items` WHERE `owner` = (?) AND `item_id` = (?) LIMIT 1;", characterID, itemID)
	else
		dbid = exports.mysql:QueryString("SELECT `id` FROM `items` WHERE `owner` = (?) AND `item_id` = (?) AND `value` = (?) LIMIT 1;", characterID, itemID, itemValue)
	end
	exports.mysql:Execute("DELETE FROM `items` WHERE `id` = (?);", dbid)

	-- Remove from cache.
	local amount = inventoryCache[thePlayer][itemID].amount
	if (amount > 1) then -- If player has more of that item.
		inventoryCache[thePlayer][itemID].amount = amount - 1
	else -- If this is the last instance of the item.
		inventoryCache[thePlayer][itemID] = nil
	end

	-- Remove from client.
	triggerClientEvent(thePlayer, "inventory:client:removeItem", thePlayer, dbid, itemID)
end
addEvent("item:takeItem", true) -- Clientside for taking items.
addEventHandler("item:takeItem", root, takeItem)

-- @requires only thePlayer and itemID.
function giveItem(thePlayer, itemID, itemValue, amount, isProtected)
	if not inventoryCache[thePlayer] then
		exports.global:outputDebug("@giveItem: Attempted to give item '" .. tostring(itemID) .. "' to player '" .. tostring(getPlayerName(thePlayer)) .. "' though player isn't cached.")
		return false
	end

	if not tonumber(itemID) or not (g_itemList[itemID]) then
		exports.global:outputDebug("@giveItem: Attempted to give item '" .. tostring(itemID) .. "' to player '" .. tostring(getPlayerName(thePlayer)) .. "' though itemID is invalid or not a defined item.")
		return false
	end

	if not tonumber(amount) then
		amount = 0
	elseif (tonumber(amount) < 0) then
		exports.global:outputDebug("@giveItem: Attempted to give item '" .. tostring(itemID) .. "' to player '" .. tostring(getPlayerName(thePlayer)) .. "' though amount '" .. tostring(amount) .. "' is invalid or negative.")
		return false
	end

	if not tostring(itemValue) then itemValue = "" end
	if isProtected then isProtected = 1 else isProtected = 0 end

	-- Update database.
	local characterID = getElementData(thePlayer, "character:id")
	local nextID = exports.mysql:QueryString("SELECT AUTO_INCREMENT FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'emerald' AND TABLE_NAME = 'items';")
	exports.mysql:Execute(
		"INSERT INTO `items` (`id`, `owner`, `item_id`, `value`, `protected`) VALUES ((?), (?), (?), (?), (?));",
		nextID, characterID, itemID, itemValue, isProtected
	)

	-- Update cache.
	isProtected = isProtected == 1
	
	local hasItem = inventoryCache[thePlayer][itemID] or false
	if hasItem then -- If player already has the item, increase  amount.
		inventoryCache[thePlayer][itemID].amount = hasItem.amount + 1
	else -- If this is their first instance of this item, add it to table.
		inventoryCache[thePlayer][itemID] = {
			dbid = nextID,
			value = itemValue,
			protected = isProtected,
			amount = 1,
		}
	end

	-- Update for client.
	triggerClientEvent(thePlayer, "inventory:client:addItem", thePlayer, nextID, itemID, itemValue, isProtected)
	return inventoryCache[thePlayer][itemID]
end

function updateItemValue(thePlayer, dbid, itemValue)
	if not isElement(thePlayer) then
		exports.global:outputDebug("@updateItemValue: thePlayer not provided or is not a valid element.")
		return false
	end

	if not tonumber(dbid) then
		exports.global:outputDebug("@updateItemValue: dbid not received or is not a numerical value.")
		return false
	end

	if not tostring(itemValue) then
		exports.global:outputDebug("@updateItemValue: Attempted to update item value for itemID '" .. tostring(itemID) .. "' and player '" .. tostring(getPlayerName(thePlayer)) .. "' through itemValue is not valid. (got '" .. tostring(itemValue) .. "')")
		return false
	end

	local itemID = exports.mysql:QueryString("SELECT `item_id` FROM `items` WHERE `id` = (?);", tonumber(dbid))
	if itemID then
		inventoryCache[thePlayer][itemID].itemValue = itemValue
		triggerClientEvent(thePlayer, "inventory:client:updateItemValue", thePlayer, tonumber(itemID), tonumber(dbid), tostring(itemValue))
	else
		exports.global:outputDebug("@updateItemValue: Failed to fetch itemID for dbid '" .. tostring(dbid) .. "', maybe item was deleted?")
		return false
	end
end

function setItemProtected(thePlayer, itemID, protectedState)
	-- TODO.
end

------------------------------------------------------------------------------------------------------------------------------

-- This function needs to be optimized in the event of resource restarts since it'll then be called by every client online. @Skully
function requestPlayerInventory()
	if isElement(source) then
		local characterID = getElementData(source, "character:id")
		cachePlayer(source)

		local playerItems = exports.mysql:Query("SELECT * FROM `items` WHERE `owner` = (?);", characterID)
		if (playerItems) then
			-- Create table to store the player's items.

			local inventoryTable = {{}}
			for i, item in pairs(playerItems) do
				if not inventoryTable[item.item_id] then inventoryTable[item.item_id] = {} end

				-- clientside table to send off.
				inventoryTable[item.item_id][item.id] = {
					id = item.item_id, -- ItemID
					dbid = item.id, -- Item Database ID
					value = item.value, -- oItem Value
					protected = item.protected == 1,
				}

				inventoryTable[item.item_id]["vars"] = {
					amount = 0,
					image = false,
					label = false,
				}

				-- Serverside table.

				-- Update amount if player already has the item.
				local hasItem = inventoryCache[source][item.item_id]
				local itemCount = 1
				if hasItem then itemCount = hasItem.amount + 1 end

				inventoryCache[source][item.item_id] = {
					dbid = id,
					value = item.value,
					protected = item.protected == 1,
					amount = itemCount
				}
			end

			triggerClientEvent(source, "inventory:fillInventoryCallback", source, inventoryTable)
			return true
		else
			exports.global:outputDebug("@requestPlayerInventory: Failed to fetch inventory for character '" .. getPlayerName(source) .. "'.")
		end
	end
	exports.global:outputDebug("@requestPlayerInventory: Returning false due to invalid player received.")
	return false
end
addEvent("inventory:requestInventory", true)
addEventHandler("inventory:requestInventory", root, requestPlayerInventory)

------------------------------------------------------------ DEBUGGING ------------------------------------------------------------

function giveItemToPlayer(thePlayer, commandName, itemID, value, amount, protected)
	if not tonumber(itemID) or (value and not tostring(value)) then
		outputChatBox("SYNTAX: /" .. commandName .. " [Item ID] (Value) (Amount) (Protected [0-1])", thePlayer, 75, 230, 10)
		return
	end

	itemID = tonumber(itemID)
	if not value then value = "" end
	if not amount then amount = 1 end
	if (tonumber(protected) == 1) then protected = true else protected = false end


	if not g_itemList[itemID] then
		outputChatBox("ERROR: That is not a valid item ID!", thePlayer, 255, 0, 0)
		return false
	end

	outputChatBox("[itemID: " .. itemID .. " - " .. g_itemList[itemID][2] .. "] Value: '" .. value .. "' / Amount: " .. amount .. " / protected: " .. tostring(protected), thePlayer, 75, 230, 10)
	giveItem(thePlayer, itemID, value, amount, protected)
end
addCommandHandler("giveitem", giveItemToPlayer)

function takeItemFromPlayer(thePlayer, commandName, itemID, value)
	if not tonumber(itemID) or (value and not tostring(value)) then
		outputChatBox("SYNTAX: /" .. commandName .. " [Item ID] (Value) (Amount) (Protected [0-1])", thePlayer, 75, 230, 10)
		return
	end

	itemID = tonumber(itemID)

	if not g_itemList[itemID] then
		outputChatBox("ERROR: That is not a valid item ID!", thePlayer, 255, 0, 0)
		return false
	end


	outputChatBox("[itemID: " .. tostring(itemID) .. " - " .. g_itemList[itemID][2] .. "] Value: '" .. tostring(value) .. "'", thePlayer, 75, 230, 10)
	takeItem(thePlayer, itemID, value)
end
addCommandHandler("takeitem", takeItemFromPlayer)
