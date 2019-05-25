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
| |\ \\ \_/ / |____| |___| |   | |____| | | || |         Zil & Skully          
\_| \_|\___/\_____/\____/\_|   \_____/\_| |_/\_/                             
																			 

Copyright of the Emerald Gaming Development Team, do not distribute - All rights reserved. ]]																																																													local sh = "c7a10bb54db766249fae26205b19c102"

function createHash()
	local h = ""
	for l = 1, math.random(5, 18) do h = h .. string.char(math.random(65, 122)) end
	return h
end
sh = createHash()

addEventHandler("onElementDataChange", root, function(index, oldValue)
	if not client then return end
	local theElement = source
	local isProtected = getElementData(theElement, sh .. "p:" .. index) -- Check if the elementData changed was protected.

	if (isProtected) then -- If the protected elementData was changed.
		local sourceClient = client -- Get the real source.
		if (sourceClient) then
			if (getElementType(sourceClient) == "player") then
				local newData = getElementData(source, index) -- If client tries to change a protected elementData.
				local thePlayerName = getPlayerName(source) or "Unknown"
				local playerID = getElementData(source, "player:id") or 0
				local playerUsername = getElementData(source, "account:username") or "Unknown"

				-- Notify staff.
				exports.global:sendMessageToAdmins("[ANTICHEAT] (" .. playerID .. ") " .. thePlayerName .. " (" .. playerUsername .. ") sent illegal data from their client!")
				exports.global:sendMessageToAdmins("(Player: ".. playerUsername .." | Data: ".. index .." | Old Value: ".. tostring(oldValue) .. " | New Value: ".. tostring(newData) ..")")
				exports.logs:addLog(source, 43, source, "[ANTICHEAT] (" .. playerID .. ") " .. thePlayerName .. " (" .. playerUsername .. ") sent modified element data. | Data: ".. index .." | Old Value: ".. tostring(oldValue) .. " | New Value: ".. tostring(newData) ..")")

				-- Revert the data back to what it was.
				changeElementDataEx(source, index, oldValue, true)
			end
		end
	end
end)

addEventHandler ("onPlayerJoin", root, function()
	protectElementData(source, "account:id") -- Protect the player's ID and username when they join.
	protectElementData(source, "account:username")
end)

-- Handler function for allowing changes to elementData.
function allowElementData(theElement, index)
	setElementData(theElement, sh .."p:".. index, false, false)
end

-- Handler function for protecting elementData and preventing any changes being made to them.
function protectElementData(theElement, index)
	setElementData(theElement, sh .."p:".. index, true, false)
end

function changeElementData(theElement, index, newvalue)
	allowElementData(theElement, index) -- Allows changes to the elementDAta specified.
	setElementData(theElement, index, newvalue) -- Changes the ElementData.
	protectElementData(theElement, index) -- Protects the elementData again so it can't be changed.
end

-- Used as the basic setElementData.
function changeElementDataEx(theElement, index, newvalue, sync, nosyncatall)
	if (theElement) and (index) then
		if not newvalue then
			newvalue = nil
		end
		if not nosyncatall then
			nosyncatall = false
		end
	
		allowElementData(theElement, index) -- Allow changes to the elementData.
		setElementData(theElement, index, newvalue, sync) -- Make the change.

		if not sync then -- If no sync was declared.
			if not nosyncatall then
				if getElementType(theElement) == "player" then
					triggerClientEvent(theElement, "blackhawk:updateElementData", root, theElement, index, newvalue)
				end
			end
		end
		protectElementData(theElement, index) -- Protect the elementData again.
		return true
	end
	return false
end

function changeEld(theElement, index, newvalue)
	if source then theElement = source end
	return changeElementData(theElement, index, newvalue)
end
addEvent("blackhawk:changeEld", true)
addEventHandler("blackhawk:changeEld", root, changeEld)

function setEld(theElement, index, newvalue, sync)
	if source then theElement = source end
	local sync2 = false
	local nosyncatall = true
	if sync == "one" then
		sync2 = false
		nosyncatall = false
	elseif sync == "all" then
		sync2 = true
		nosyncatall = false
	else
		sync2 = false
		nosyncatall = true
	end
	return changeElementDataEx(theElement, index, newvalue, sync2, nosyncatall)
end
addEvent("blackhawk:setEld", true)
addEventHandler("blackhawk:setEld", root, setEld)

-- Primary function for usage of changing elementData safely.
function setElementDataEx(theElement, theParameter, theValue, syncToClient, noSyncAtall)
	if syncToClient == nil then
		syncToClient = false
	end
	
	if noSyncAtall == nil then
		noSyncAtall = false
	end
	
	if tonumber(theValue) then
		theValue = tonumber(theValue)
	end
	
	changeElementDataEx(theElement, theParameter, theValue, syncToClient, noSyncAtall)
	return true
end

addEventHandler("onResourceStart", resourceRoot, function() print("[BLACKHAWK] Service is now active.") end)