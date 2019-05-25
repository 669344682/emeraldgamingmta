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
|    /| | | | |    |  __||  __/| |    |  _  |\ /
| |\ \\ \_/ / |____| |___| |   | |____| | | || |
\_| \_|\___/\_____/\____/\_|   \_____/\_| |_/\_/

Copyright of the Emerald Gaming Development Team, do not distribute - All rights reserved.

DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH
DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH

									MAKING ANY CHANGES TO THIS FILE CAN RESULT IN UNEXPECTED RESULTS.

DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH
DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH						]]

dataTable = {
	["player"] = {},
	["vehicle"] = {},
	["interior"] = {},
	["ped"] = {},
	["object"] = {},
	["teleporter"] = {},
	["team"] = {},
}

local indexedData = {
	player = {},
	vehicle = {},
	interior = {},
	ped = {},
	object = {},
	teleporter = {},
	team = {},
}

local idelementdata = {
	player = "player:id", -- Player ID on scoreboard, not character id in database.
	vehicle = "vehicle:id",
	interior = "interior:id",
	ped = "ped:id",
	object = "object:id",
	teleporter = "teleporter:id",
	team = "faction:id",
}

function isValidType(elementType) return dataTable[elementType] ~= nil end

function showsize(thePlayer)
	if exports.global:isPlayerDeveloper(thePlayer, true) then
		local players = #dataTable["player"]
		local vehicles = #dataTable["vehicle"]
		local interiors = #dataTable["interior"]
		local peds = #dataTable["ped"]
		local objects = #dataTable["object"]
		local teleporters = #dataTable["teleporter"]
		local factions = #dataTable["team"]
		
		local tplayers = #getElementsByType("player")
		local tvehicles = #getElementsByType("vehicle")
		local tinteriors = #getElementsByType("interior")
		local tpeds = #getElementsByType("ped")
		local tobjects = #getElementsByType("object")
		local tteleporters = #getElementsByType("teleporter")
		local tfactions = #getElementsByType("team")
		
		outputChatBox(" ", thePlayer)
		outputChatBox("STORED DATA ELEMENTS:", thePlayer, 75, 230, 10)
		outputChatBox("  • Players: " .. tostring(players) .. "/" .. tostring(tplayers), thePlayer, 75, 230, 10)
		outputChatBox("  • Vehicles: " .. tostring(vehicles) .. "/" .. tostring(tvehicles), thePlayer, 75, 230, 10)
		outputChatBox("  • Interiors: " .. tostring(interiors) .. "/" .. tostring(tinteriors), thePlayer, 75, 230, 10)
		outputChatBox("  • Peds: " .. tostring(peds) .. "/" .. tostring(tpeds), thePlayer, 75, 230, 10)
		outputChatBox("  • Objects: " .. tostring(objects) .. "/" .. tostring(tobjects), thePlayer, 75, 230, 10)
		outputChatBox("  • Teleporters: " .. tostring(teleporters) .. "/" .. tostring(tteleporters), thePlayer, 75, 230, 10)
		outputChatBox("  • Factions: " .. tostring(factions) .. "/" .. tostring(tfactions), thePlayer, 75, 230, 10)
	end
end
addCommandHandler("datasize", showsize)

function deallocateElement(element)
	local elementType = getElementType(element)
	if (isValidType(elementType)) then
		local elementPool = dataTable[elementType]
		local i = 0
		for k = #elementPool, 1, -1 do
			if elementPool[k] == element then
				table.remove(elementPool, k)
			end
		end
		
		if indexedData[elementType] then
			local id = tonumber(getElementData(element, idelementdata[elementType]))
			if id and indexedData[elementType][id] then
				indexedData[elementType][id] = nil
			else
				for k, v in pairs(indexedData[elementType]) do
					if v == element then
						indexedData[elementType][k] = nil
					end
				end
			end
		end
	end
end

function allocateElement(element, id, skipChildren)
	if not isElement(element) then exports.global:outputDebug("@allocateElement: element provided is not an element.") return false end

	local elementType = getElementType(element)
	if not isValidType(elementType) then exports.global:outputDebug("@allocateElement: element provided is not a defined allocatable data type. (Got " .. tostring(getElementType(element)) .. ".)") return false end
	
	deallocateElement(element)
	table.insert(dataTable[elementType], element)
	if indexedData[elementType] then
		if not id then
			id = getElementData(element, idelementdata[elementType])
			if not tonumber(id) then
				deallocateElement(element)
				return false
			end
		else
			indexedData[elementType][tonumber(id)] = element
		end
	end

	if not skipChildren and getElementChildren(element) then
		for k, e in ipairs(getElementChildren(element)) do
			allocateElement(e)
		end
	end
end

function getDataElementsByType(elementType)
	if (elementType == "pickup") then return getElementsByType("pickup") end
	if not isValidType(elementType) then exports.global:outputDebug("@getDataElementsByType: elementType is not a defined allocated element type.") return false end
	if dataTable[elementType] then return dataTable[elementType] else return false end
end

addEventHandler("onResourceStop", resourceRoot, function()
	saveData(dataTable, "dataTable")
	saveData(indexedData, "indexedData")
end)

addEventHandler("onResourceStart", resourceRoot, function()
	local loaded = loadData("dataTable")
	if loaded then dataTable = loaded end
	
	loaded = loadData("indexedData")
	
	if loaded then indexedData = loaded end

	if not indexedData["ped"] then
		indexedData["ped"] = {}
		exports.global:outputDebug("[DATA] Added missing indexed data for peds.", 2)
	end
end)

addEventHandler("onElementDestroy", root, function() deallocateElement(source) end)
function getElement(elementType, id) return indexedData[elementType] and indexedData[elementType][tonumber(id)] end

------------------------------------------------- [Player IDs & Allocation] -------------------------------------------------
--[[ DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH ]]

addEventHandler("onPlayerJoin", root, function() allocateElement(source) end)
addEventHandler("onPlayerQuit", root, function() deallocateElement(source) end)

local ids = {}

-- Allocates the player and assigns them an ID.
function playerJoin()
	local slot = nil
	
	for i = 1, 5000 do
		if (ids[i] == nil) then
			slot = i
			break
		end
	end
	
	ids[slot] = source
	exports.blackhawk:setElementDataEx(source, "player:id", slot, true)
	allocateElement(source, slot)
end
addEventHandler("onPlayerJoin", root, playerJoin)

-- Removes the player from the table and makes their ID available.
function playerQuit()
	local slot = getElementData(source, "player:id")
	if (slot) then ids[slot] = nil end
end
addEventHandler("onPlayerQuit", root, playerQuit)

-- Assigns players an ID and allocates them when the resource starts.
function allocatePlayers()
	local players = getDataElementsByType("player")
	
	for key, value in ipairs(players) do
		ids[key] = value
		exports.blackhawk:setElementDataEx(value, "player:id", key, true)
		allocateElement(value, key)
	end
end
addEventHandler("onResourceStart", resourceRoot, allocatePlayers)