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

emGUI = exports.emGUI
local tabsFont_14 = emGUI:dxCreateNewFont("fonts/tabsFont.ttf", 14)
local pointerFont = dxCreateFont(":assets/fonts/textFont.ttf", 12)
local sW, sH = guiGetScreenSize()

----------------------------------- [Inventory definitions] -----------------------------------

local ICON_WIDTH, ICON_HEIGHT = 0.125, 0.201 -- DO NOT ADJUST!
local TILES_COLOR = tocolor(255, 255, 255, 230)
local CATEGORY_TEXT_COLOR = tocolor(255, 255, 255, 255) -- Color of category that is selected.
local CATEGORY_TEXT_COLOR_IDLE = tocolor(200, 200, 200, 200) -- Color of category text when category is unselected.
local CATEGORY_BUTTON_IDLE = tocolor(60, 60, 60, 200)
local CATEGORY_BUTTON_HOVER = tocolor(50, 50, 50, 200)
local CATEGORY_BUTTON_CLICK = tocolor(50, 50, 50, 240)
local ITEM_HOVER_TEXT_COLOR = tocolor(0, 0, 0, 180)
local INVENTORY_COLUMNS = 8 -- Number of slots per row.

local inventoryPositions = {
	[1] = {x = 0.25, y = 0.75}, -- 0-8 items.
	[2] = {x = 0.25, y = 0.65}, -- 9-16 items.
	[3] = {x = 0.25, y = 0.55}, -- 17-24 items.
	[4] = {x = 0.25, y = 0.45}, -- 25-32 items.
	[5] = {x = 0.25, y = 0.35}, -- 33-40 items. (Fall-back in case of inventory overflow)
}

------------------------------------------------------------------------------------------------
----------------------------------- [Inventory Configuration] ----------------------------------

local MAX_WEIGHT = 32 -- (kg) Max weight allowed to be carried at any given time.
local MAX_DROP_DISTANCE = 5 -- The maximum distance a player is able to drop an object.

------------------------------------------------------------------------------------------------
------------------------------------- [Function Variables] -------------------------------------

--[[

NOTE FOR DEVELOPERS:
	The table below is a visual display of how the inventoryContent table is structured,
	what indexes are labelled as and what values are stored in which variable. An important
	thing to note is that the primary index in inventoryContent is the itemID that the player
	has. - Skully

inventoryContent = {
	[itemID] = {
		[dbid] = {
			id = itemID,
			dbid = dbid,
			value = value,
			protected = true/false,
		},

		["vars"] = {
			image = element,
			label = element,
			amount = 0,
		},
	}
}
]]

-- Local inventory table containing all player items.
local inventoryContent = {}

local canOpenInventory = false -- If player can open the inventory.
local isInventoryVisible = false -- Player inventory is open.
local isClicking = false -- False if not clicking, source emGUI element when being clicked.
local firstOpenEvent = true -- Stays true until the inventory is opened atleast once, used for weight calculation.

local currentWeight, maxWeight = 0, 8 -- kgs of weight.
local activeCategory = 1

------------------------------------------------------------------------------------------------

function requestInventory()
	if (getElementData(localPlayer, "loggedin") == 1) then -- If player is logged in and character selected.
		triggerServerEvent("inventory:requestInventory", localPlayer)
	end
end
-- Request the player's inventory whenever resource restarts or when character is selected.
addEventHandler("onClientResourceStart", resourceRoot, requestInventory)
addEventHandler("onCharacterSelected", localPlayer, requestInventory)

-- Callback event for inventory to populate clientsided table.
addEvent("inventory:fillInventoryCallback", true)
addEventHandler("inventory:fillInventoryCallback", root, function(e) inventoryContent = e; canOpenInventory = true end)

-- When player returns to character selection, prevent inventory opening.
addEventHandler("onPlayerCharacterSelection", localPlayer, function() canOpenInventory = false end)

function showInventory()
	if not canOpenInventory then
		outputChatBox("You cannot open your inventory right now.", 255, 0, 0)
		return
	end

	if emGUI:dxIsWindowVisible(inventoryWindow) then
		---- [Inventory closed events] ----
		removeEventHandler("onClientRender", root, handleMouseLabels)
		removeEventHandler("onDgsMouseClick", root, handleMouseClick)
		for i, items in pairs(inventoryContent) do
			if not inventoryContent[i]["vars"] then break end -- Don't proceed if player has no items.
			if isElement(items["vars"].image) then destroyElement(items["vars"].image) end
			if isElement(items["vars"].label) then destroyElement(items["vars"].label) end
		end

		emGUI:dxMoveTo(inventoryWindow, inventoryPositions[1].x, 1, true, false, "InQuad", 100)
		setTimer(function() emGUI:dxCloseWindow(inventoryWindow) end, 105, 1)
		isInventoryVisible = false
		showCursor(false)
		return
	end

	isInventoryVisible = true
	renderInventory()
end
bindKey("i", "down", showInventory)

-- Primary inventory renderer.
function renderInventory(redraw)
	if (redraw) then
		if isInventoryVisible then
			removeEventHandler("onClientRender", root, handleMouseLabels)
			removeEventHandler("onDgsMouseClick", root, handleMouseClick)
			emGUI:dxCloseWindow(inventoryWindow)
		end
	end

	-- Temporary tables to calculate unique item count.
	local noDupeItems = {}
	local dupeItems = {}

	for i, items in pairs(inventoryContent) do
		if not inventoryContent[i]["vars"] then break end -- Don't proceed if player has no items.
		local currentItemCount = 0
		for v, item in pairs(items) do
			if (item.dbid) then
				local itemCategory = g_itemList[item.id][4] or 3
				if firstOpenEvent then -- Weight calculation.
					currentWeight = currentWeight + g_itemList[item.id][5]
					if isItemStorage(item.id) and maxWeight < 32 then
						maxWeight = maxWeight + 8
					end
				end
				
				currentItemCount = currentItemCount + 1

				if not dupeItems[item.id] then
					if (activeCategory == 2) and (itemCategory == 1) -- Wallet
						or (activeCategory == 3) and (itemCategory == 3) -- Keys
						or (activeCategory == 4) and (itemCategory == 2) or (itemCategory == 7) -- Weapons/Ammunition
						or (activeCategory == 1) and (itemCategory > 3) then -- Inventory
						dupeItems[item.id] = true
						table.insert(noDupeItems, item.id)
					end
				end
			end
		end
		inventoryContent[i]["vars"].amount = currentItemCount
	end

	local itemCount = #noDupeItems -- Current items displayed in active category.

	-- Discard temporary tables.
	noDupeItems = nil
	dupeItems = nil

	firstOpenEvent = false -- Set to false, weight is calculated.

	local rows = 1 -- Current rows displayed in active category.
	if (itemCount < 9) then rows = 1
		elseif (itemCount > 8) and (itemCount < 17) then rows = 2
		elseif (itemCount > 16) and (itemCount < 25) then rows = 3
		elseif (itemCount > 24) and (itemCount < 33) then rows = 4
		elseif (itemCount > 32) then rows = 5
	end

	if redraw then
		inventoryWindow = emGUI:dxCreateWindow(inventoryPositions[rows].x, inventoryPositions[rows].y, 0.5, 0.53, "", true, true, _, true, _, 0, _, _, _, tocolor(100, 0, 0, 0))
	else
		inventoryWindow = emGUI:dxCreateWindow(inventoryPositions[rows].x, 1, 0.5, 0.53, "", true, true, _, true, _, 0, _, _, _, tocolor(100, 0, 0, 0))
		emGUI:dxMoveTo(inventoryWindow, inventoryPositions[rows].x, inventoryPositions[rows].y, true, false, "InQuad", 100)
		showCursor(true)
	end

	-- Inventory category buttons.
	categoryButtons = {}
		categoryButtons[1] = emGUI:dxCreateButton(0, 0.151, 0.125, 0.05, "INVENTORY", true, inventoryWindow, CATEGORY_TEXT_COLOR_IDLE, _, _, _, _, _, CATEGORY_BUTTON_IDLE, CATEGORY_BUTTON_HOVER, CATEGORY_BUTTON_CLICK)
		categoryButtons[2] = emGUI:dxCreateButton(0.125, 0.151, 0.125, 0.05, "WALLET", true, inventoryWindow, CATEGORY_TEXT_COLOR_IDLE, _, _, _, _, _, CATEGORY_BUTTON_IDLE, CATEGORY_BUTTON_HOVER, CATEGORY_BUTTON_CLICK)
		categoryButtons[3] = emGUI:dxCreateButton(0.25, 0.151, 0.125, 0.05, "KEYS", true, inventoryWindow, CATEGORY_TEXT_COLOR_IDLE, _, _, _, _, _, CATEGORY_BUTTON_IDLE, CATEGORY_BUTTON_HOVER, CATEGORY_BUTTON_CLICK)
		categoryButtons[4] = emGUI:dxCreateButton(0.375, 0.151, 0.125, 0.05, "WEAPONS", true, inventoryWindow, CATEGORY_TEXT_COLOR_IDLE, _, _, _, _, _, CATEGORY_BUTTON_IDLE, CATEGORY_BUTTON_HOVER, CATEGORY_BUTTON_CLICK)

		for i, button in ipairs(categoryButtons) do
			if (i == activeCategory) then
				emGUI:dxSetEnabled(button, false)
				emGUI:dxButtonSetTextColor(button, CATEGORY_TEXT_COLOR)
			end
			addEventHandler("onClientDgsDxMouseClick", button, switchInventoryCategory)
		end

	weightDisplay = emGUI:dxCreateButton(0.875, 0.151, 0.125, 0.05, currentWeight .. "/" .. maxWeight .. "kg", true, inventoryWindow, CATEGORY_TEXT_COLOR, _, _, _, _, _, CATEGORY_BUTTON_IDLE, CATEGORY_BUTTON_HOVER, CATEGORY_BUTTON_CLICK)
	addEventHandler("onClientDgsDxMouseClick", weightDisplay, function(b, c)
		if (b == "left") and (c == "down") then
			outputChatBox("You are currently carrying a total of " .. currentWeight .. "kg out of a maximum " .. maxWeight .. "kg.", 75, 230, 10)
			outputChatBox("You may carry an additional " .. maxWeight - currentWeight .. "kg of items.", 75, 230, 10)
		end
	end)

	-- Inventory slot creator.
	for COLUMNS = 0, INVENTORY_COLUMNS - 1 do -- -1 as we start counting from position 0.
		for ROWS = 1, rows do
			emGUI:dxCreateImage(0.125 * COLUMNS, 0.2 * ROWS, ICON_WIDTH, ICON_HEIGHT, ":item-system/images/ui/slot.png", true, inventoryWindow, TILES_COLOR)
		end
	end

	renderInventoryContent(redraw) -- Call function to place items into inventory.
end

-- Primary inventory content renderer.
function renderInventoryContent(isRedraw)
	if isRedraw then
		for i, items in pairs(inventoryContent) do
			if not inventoryContent[i]["vars"] then break end -- Don't proceed if player has no items.
			for v, item in pairs(items) do
				if isElement(items["vars"].image) then destroyElement(items["vars"].image) end
				if isElement(items["vars"].label) then destroyElement(items["vars"].label) end
			end
		end
	end

	local row = 1
	local rowItems = 0
	local totalItems = 0

	for i, items in pairs(inventoryContent) do -- Loop through each item set.
		for v, item in pairs(items) do -- Loop through each item within the set.
			if item.id then
				local itemCategory = g_itemList[item.id][4] or 3
				if (activeCategory == 2) and (itemCategory == 1) -- Wallet
					or (activeCategory == 3) and (itemCategory == 3) -- Keys
					or (activeCategory == 4) and (itemCategory == 2) or (itemCategory == 7) -- Weapons/Ammunition
					or (activeCategory == 1) and (itemCategory > 3) then -- Inventory

					if not isElement(inventoryContent[i]["vars"].image) then -- First time item is being displayed.
						local itemImage = emGUI:dxCreateImage(0.125 * rowItems, 0.2 * row, ICON_WIDTH, ICON_HEIGHT, ":item-system/images/items/" .. item.id .. ".png", true, inventoryWindow, TILES_COLOR)
						setElementData(itemImage, "inventory:data", item, false) -- Save item table.

						rowItems = rowItems + 1
						totalItems = totalItems + 1

						inventoryContent[i]["vars"].image = itemImage
						inventoryContent[i]["vars"].label = label
					else
						if (item.id ~= ITEMS.MONEY) then -- Items not to render label for.
							if not isElement(inventoryContent[i]["vars"].label) then
								local x, y = emGUI:dxGetPosition(inventoryContent[i]["vars"].image, true)
								inventoryContent[i]["vars"].label = emGUI:dxCreateLabel(x + ICON_WIDTH - 0.035, y + ICON_HEIGHT - 0.05, 0.2, 0.09, "x" .. inventoryContent[i]["vars"].amount, true, inventoryWindow)
								emGUI:dxSetFont(inventoryContent[i]["vars"].label, tabsFont_14)
							else
								emGUI:dxSetText(inventoryContent[i]["vars"].label, "x" .. inventoryContent[i]["vars"].amount)
							end
						end
					end
					if (totalItems % 8 == 0) then row = row + 1; rowItems = 0 end
				end
			end
		end
	end
	addEventHandler("onDgsMouseClick", root, handleMouseClick)
	addEventHandler("onClientRender", root, handleMouseLabels)
end

local currentDummy = false
function handleMouseClick(button, state)
	if not source then return end -- Prevent drag attempts on tabs and labels.
	if (button == "left") and (state == "down") and getElementData(source, "inventory:data") then
		isClicking = source
		emGUI:dxSetVisible(isClicking, false)
		
		local x, y = emGUI:dxGetPosition(isClicking, true, true)

		local itemData = getElementData(source, "inventory:data")
		currentDummy = emGUI:dxCreateImage(x, y, 0.063, 0.109, ":item-system/images/items/" .. itemData.id .. ".png", true, false, tocolor(255, 255, 255, 165))
		addEventHandler("onClientRender", root, setElementToMouse)
		if isElement(inventoryContent[itemData.id]["vars"].label) then emGUI:dxSetVisible(inventoryContent[itemData.id]["vars"].label, false) end -- Set the label of selected item invisible.
	else
		if not isClicking then return end
		if isElement(currentDummy) then
			removeEventHandler("onClientRender", root, setElementToMouse)

			destroyElement(currentDummy); currentDummy = false
			emGUI:dxSetVisible(isClicking, true)
		end

		local itemData = getElementData(isClicking, "inventory:data")

		-- Set selected item's label visible again and bring to front.
		if isElement(inventoryContent[itemData.id]["vars"].label) then
			emGUI:dxSetVisible(inventoryContent[itemData.id]["vars"].label, true)
			emGUI:dxBringToFront(inventoryContent[itemData.id]["vars"].label)
		end

		local x, y = emGUI:dxGetPosition(inventoryWindow)
		local sx, sy = emGUI:dxGetSize(inventoryWindow)

		if not isMouseInPosition(x, y + 85, sx, sy) and isElement(isClicking) then
			-- Run take item from inventory function, and place in 3D world, use itemID for the itemID.
			print("[inventory-system] Dropped itemID " .. itemData.id .. " with value '" .. tostring(itemData.value) .. "'.")
			
			local thePlayerDimension, thePlayerInterior = getElementDimension(localPlayer), getElementInterior(localPlayer)
			local cursorX, cursorY, absCursorX, absCursorY, absCursorZ = getCursorPosition()
			local cameraX, cameraY, cameraZ = getWorldFromScreenPosition(cursorX, cursorY, 0.1)

			local isHit, x, y, z, theElement = processLineOfSight(cameraX, cameraY, cameraZ, absCursorX, absCursorY, absCursorZ)
			local thePlayerX, thePlayerY, thePlayerZ = getElementPosition(localPlayer)
			local dropDistance = getDistanceBetweenPoints3D(thePlayerX, thePlayerY, thePlayerZ, x, y, z)

			if (dropDistance < MAX_DROP_DISTANCE) then
				triggerServerEvent("itemworld:createItem", localPlayer, itemData.id, itemData.value, x, y, z + g_itemList[itemData.id][9], g_itemList[itemData.id][6], g_itemList[itemData.id][7], g_itemList[itemData.id][8], thePlayerDimension, thePlayerInterior, localPlayer, "null")
				triggerServerEvent("item:takeItem", localPlayer, localPlayer, itemData.id, itemData.value)
			end
		end
		isClicking = false
	end
end

function setElementToMouse()
	local x, y = getCursorPosition()
	emGUI:dxSetPosition(currentDummy, x-0.04, y-0.04, true)
end

-- Function to switch from one inventory category to another.
function switchInventoryCategory(b, c)
	if (b == "left") and (c == "down") then
		local selectedCategory = 1
		for i, button in ipairs(categoryButtons) do
			if (source == button) then
				selectedCategory = i
				emGUI:dxSetEnabled(button, false)
				emGUI:dxButtonSetTextColor(button, CATEGORY_TEXT_COLOR)
			else
				emGUI:dxSetEnabled(button, true)
				emGUI:dxButtonSetTextColor(button, CATEGORY_TEXT_COLOR_IDLE)
			end
		end

		activeCategory = selectedCategory
		renderInventory(true)
	end
end

-- Function MUST receive absolute values for all parameters.
function isMouseInPosition(x, y, width, height)
	if not isCursorShowing() then return false end
	local cx, cy = getCursorPosition()
	local cx, cy = (cx * sW), (cy * sH)

	if (cx >= x and cx <= x + width) and (cy >= y and cy <= y + height) then return true else return false end
end

------------------------------------------ [Mouse Hover Labels] -----------------------------------------

function handleMouseLabels()
	if isCursorShowing() then
		local element = emGUI:dxGetMouseEnterGUI()
		if element then
			local itemData = getElementData(element, "inventory:data")
			if (itemData) then -- element being hovered over is an item.
				local x, y = getCursorPosition()
				local cursorX, cursorY = x * sW, y * sH

				-- First line of item label.
				local itemTitle = g_itemList[itemData.id][2]

				-- If item has a value, add to the end.
				local itemValue = itemData.value
				if #itemValue > 0 then itemTitle = itemTitle .. " (Value: " .. itemValue .. ")" end

				-- If item is protected, add protected pretext.
				if itemData.protected then itemTitle = "#FF0000[PROTECTED] #FFFFFF" .. itemTitle end

				createLabel(cursorX, cursorY, itemTitle, g_itemList[itemData.id][3])
			end
		end
	end
end

function createLabel(x, y, firstLine, secondLine)
	firstLine = tostring(firstLine)

	if secondLine then secondLine = tostring(secondLine) end
	if firstLine == secondLine then secondLine = nil end
	
	local width = dxGetTextWidth(firstLine, 1, pointerFont) + 20
	if secondLine then
		width = math.max(width, dxGetTextWidth(secondLine, 1, pointerFont) + 20)
		firstLine = firstLine .. "\n" .. secondLine
	end

	local height = 10 * (secondLine and 5 or 3)
	x = math.max(10, math.min(x, sW - width)) + 5
	y = math.max(10, math.min(y, sH - height)) + 10

	dxDrawRectangle(x, y, width, height, ITEM_HOVER_TEXT_COLOR, true)
	dxDrawText(firstLine, x, y, x + width, y + height, tocolor(255, 255, 255, 255), 1, pointerFont, "center", "center", false, false, true, true)
	-- NOTICE: The tocolor(255, 255, 255, 255) in dxDrawText above is overwritten from the HEX code up in handleMouseLabels.
end

--------------------------------------------- [Item Weight] ---------------------------------------------

-- Returns bool availableWeight, int currentWeight, int maxWeight
function hasPlayerWeight(weight) return maxWeight - currentWeight >= (tonumber(weight) or 0), currentWeight, maxWeight end

-- Update weight values.
function updateWeight(newCurrent, newMax)
	if newCurrent or newMax then
		currentWeight = newCurrent or currentWeight
		maxWeight = newMax or maxWeight

		-- Fallback in case weights exceed thresholds.
		if currentWeight < 0 then currentWeight = 0 end
		if maxWeight < 8 then maxWeight = 8 end
	end

	if isInventoryVisible then
		emGUI:dxSetText(weightDisplay, currentWeight .. "/" .. maxWeight .. "kg")
		
		if (maxWeight - currentWeight < 4) then
			emGUI:dxButtonSetTextColor(weightDisplay, tocolor(255, 0, 0, 255))
		else
			emGUI:dxButtonSetTextColor(weightDisplay, tocolor(255, 255, 255, 255))
		end
	end
end

function hasPlayerWeightForItem(itemID)
	if not tonumber(itemID) then
		exports.global:outputDebug("@hasPlayerWeightForItem: itemID not received or is not an integer value.")
		return false
	end

	if not g_itemList[tonumber(itemID)] then
		exports.global:outputDebug("@hasPlayerWeightForItem: itemID is not a valid itemID.")
		return false
	end

	local itemWeight = g_itemList[itemID][5] or 1
	return hasPlayerWeight(itemWeight)
end

---------------------------------------------------------------------------------------------------------
--------------------------------------------- [item-system] ---------------------------------------------
---------------------------------------------------------------------------------------------------------

function addItem(dbid, itemID, itemValue, protected)
	local isFirstItem = false -- Whether this is the first instance of the item the player has.

	if not inventoryContent[itemID] or not inventoryContent[itemID]["vars"] then -- This is the first item.
		inventoryContent[itemID] = {}
		isFirstItem = true
	end

	inventoryContent[itemID][dbid] = {
		id = itemID,
		dbid = dbid,
		value = itemValue,
		protected = protected,
	}

	if isFirstItem then
		inventoryContent[itemID]["vars"] = {
			label = false,
			element = false,
			amount = 1,
		}

		-- Re-render inventory instead of attempting to calculate where to put new image, redo this when there is time. (Skully, 29/11/18)
		if isInventoryVisible and isItemCategoryOpen(itemID) then renderInventory(true) end
	else
		-- Update amount data.
		local newAmount = inventoryContent[itemID]["vars"].amount + 1
		inventoryContent[itemID]["vars"].amount = newAmount

		if isInventoryVisible and isElement(inventoryContent[itemID]["vars"].image) then
			if (newAmount == 2) then -- If player now has 2 of the item, need to create label.
				local x, y = emGUI:dxGetPosition(inventoryContent[itemID]["vars"].image, true)
				inventoryContent[itemID]["vars"].label = emGUI:dxCreateLabel(x + ICON_WIDTH - 0.035, y + ICON_HEIGHT - 0.05, 0.2, 0.09, "x" .. newAmount, true, inventoryWindow)
				emGUI:dxSetFont(inventoryContent[itemID]["vars"].label, tabsFont_14)
			else -- If player actively in item category, we need to update label.
				emGUI:dxSetText(inventoryContent[itemID]["vars"].label, "x" .. newAmount)
			end
		end
	end
end
addEvent("inventory:client:addItem", true)
addEventHandler("inventory:client:addItem", root, addItem)

function removeItem(dbid, itemID)
	if inventoryContent[itemID][dbid] then -- Check if item exists in table.
		local itemAmount = inventoryContent[itemID]["vars"].amount -- Get current amount of the item.
		local newItemCount = itemAmount - 1
		if (newItemCount == 0) then -- If this was the last of this item the player had.

			-- Remove item from table and re-render.
			inventoryContent[itemID] = nil
			if isInventoryVisible and isItemCategoryOpen(itemID) then renderInventory(true) end
		else -- If player still has other instances of the item.
			if isElement(inventoryContent[itemID]["vars"].label) then
				if (newItemCount == 1) then
					destroyElement(inventoryContent[itemID]["vars"].label)
				else
					emGUI:dxSetText(inventoryContent[itemID]["vars"].label, "x" .. newItemCount)
				end
				inventoryContent[itemID]["vars"].amount = newItemCount
			end
			inventoryContent[itemID][dbid] = nil
		end

		-- Update weight.
		local itemWeight = g_itemList[itemID][5]
		updateWeight(currentWeight - itemWeight)
	else
		outputDebugString("@removeItem: Attempted to take item '" .. tostring(itemID) .. "' from player '" .. tostring(getPlayerName(localPlayer)) .. "' though player doesn't have, ensure you check before attempting to take.", 3)
	end
end
addEvent("inventory:client:removeItem", true)
addEventHandler("inventory:client:removeItem", root, removeItem)

function updateItemValue(itemID, dbid, itemValue)
	if not inventoryContent[itemID] or not inventoryContent[itemID][dbid] then return end
	inventoryContent[itemID][dbid].value = itemValue
end
addEvent("inventory:client:updateItemValue", true)
addEventHandler("inventory:client:updateItemValue", root, updateItemValue)

function isItemCategoryOpen(itemID) -- Checks if the item's category is currently open.
	local itemCategory = g_itemList[itemID][4] or 3
	if (activeCategory == 2) and (itemCategory == 1) -- Wallet
		or (activeCategory == 3) and (itemCategory == 3) -- Keys
		or (activeCategory == 4) and (itemCategory == 2) or (itemCategory == 7) -- Weapons/Ammunition
		or (activeCategory == 1) and (itemCategory > 3) then -- Inventory
		return true
	end
	return false
end