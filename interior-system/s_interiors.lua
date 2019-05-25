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

function toggleInteriorLock(thePlayer, nearbyMarkers)
	local isUnlocking = getElementData(thePlayer, "temp:int:unlocking")
	if not isUnlocking then -- Spam prevention.
		local x, y, z = getElementPosition(thePlayer)
		local minDistance = 10
		local foundInterior, staffOverride, isEntrance = false, false, false

		for i, intID in ipairs(nearbyMarkers) do
			local theInterior = exports.data:getElement("interior", intID[1])
			if theInterior then
				local x1, y1, z1 = unpack(getElementData(theInterior, "interior:entrance"))
				local x2, y2, z2 = unpack(getElementData(theInterior, "interior:exit"))
				local distanceToIntEntrance = getDistanceBetweenPoints3D(x, y, z, x1, y1, z1)
				local distanceToIntExit = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
				local canOpenInterior = true -- Requires check to see if player has key to interior. (Interior ID is var 'intID'). @requires item-system
				if not (canOpenInterior) then
					if exports.global:isPlayerHelper(thePlayer) or exports.global:isPlayerMappingTeamLeader(thePlayer) then
						staffOverride = true
						canOpenInterior = true
					end
				end
				if canOpenInterior then
					if minDistance > distanceToIntEntrance then
						minDistance = distanceToIntEntrance
						foundInterior = theInterior
						isEntrance = true
					elseif minDistance > distanceToIntExit then
						minDistance = distanceToIntExit
						foundInterior = theInterior
					end
				end
			end
		end
		if (foundInterior) then
			setElementData(thePlayer, "temp:int:unlocking", true, false)
			local interiorID = getElementData(foundInterior, "interior:id")
			local isInteriorLocked = getElementData(foundInterior, "interior:locked")
			local position = "inside"; if isEntrance then position = "outside" end
			if isInteriorLocked then
				if (getElementAlpha(thePlayer) == 0) and staffOverride then
					local intName = getElementData(foundInterior, "interior:name")
					triggerEvent("rp:sendLocalRP", thePlayer, thePlayer, "do", "The doors would now be open. (( " .. intName .. " ))")
				else
					triggerEvent("rp:sendAme", thePlayer, "unlocks the door.")
				end

				if staffOverride then
					local thePlayerName = exports.global:getStaffTitle(thePlayer)
					exports.logs:addInteriorLog(interiorID, "[STAFF-UNLOCK] " .. thePlayerName .. " unlocked from ".. position .. ".", thePlayer)
				else
					exports.logs:addInteriorLog(interiorID, "[UNLOCK] " .. getPlayerName(thePlayer):gsub("_", " ") .. " unlocked from ".. position .. ".", thePlayer)
				end
			else
				if (getElementAlpha(thePlayer) == 0) and staffOverride then
					local intName = getElementData(foundInterior, "interior:name")
					triggerEvent("rp:sendLocalRP", thePlayer, thePlayer, "do", "The doors would now be locked. (( " .. intName .. " ))")
				else
					triggerEvent("rp:sendAme", thePlayer, "locks the door.")
				end

				if staffOverride then
					local thePlayerName = exports.global:getStaffTitle(thePlayer)
					exports.logs:addInteriorLog(interiorID, "[STAFF-LOCK] " .. thePlayerName .. " locked from ".. position .. ".", thePlayer)
				else
					exports.logs:addInteriorLog(interiorID, "[LOCK] " .. getPlayerName(thePlayer):gsub("_", " ") .. " locked from ".. position .. ".", thePlayer)
				end
			end
			exports.blackhawk:changeElementDataEx(foundInterior, "interior:locked", not isInteriorLocked)

			-- Update element data of both interior markers clientsided.
			-- This is very inefficient man use a function or some shit clientsided to check if int is locked rather than updating the
			-- state of interior markers every time an int is locked. @Skully
			for i, player in ipairs(getElementsByType("player")) do
				triggerClientEvent(player, "interior:updateMarkerData", thePlayer, interiorID, true, "marker:locked", not isInteriorLocked)
				triggerClientEvent(player, "interior:updateMarkerData", thePlayer, interiorID, false, "marker:locked", not isInteriorLocked)
				triggerClientEvent(player, "interior:playInteriorSoundEffect", player, interiorID, 1)
			end

			setTimer(function() removeElementData(thePlayer, "temp:int:unlocking") end, 2000, 1)
		end
	end
end
addEvent("interior:lockInterior", true)
addEventHandler("interior:lockInterior", root, toggleInteriorLock)

-- /toglights - By Skully (28/06/18) [Player]
function toggleInteriorLight(thePlayer)
	if getElementData(thePlayer, "loggedin") == 1 then
		local interiorID = getElementData(thePlayer, "character:realininterior") or 0
		if (interiorID ~= 0) then
			local theInterior = exports.data:getElement("interior", interiorID)
			if theInterior then
				local hasKeys = true -- Check if player has keys to interior. @requires item-system
				if hasKeys or exports.global:isPlayerHelper(thePlayer) then
					local lightState = getElementData(theInterior, "interior:lights") or 0
					if (lightState == 1) then lightState = true else lightState = false end
					local newState = 0; if not lightState then newState = 1 end
					exports.blackhawk:changeElementDataEx(theInterior, "interior:lights", newState)
					setInteriorLightState(interiorID, not lightState)
					triggerEvent("rp:sendAme", thePlayer, "flicks the light switch.")
					return
				end
			end
		end
		outputChatBox("There is no light switch nearby.", thePlayer, 255, 0, 0)
	end
end
addCommandHandler("toglights", toggleInteriorLight)

function setInteriorLightState(interiorID, status)
	for i, player in ipairs(getElementsByType("player")) do
		local intID = getElementData(player, "character:realininterior") or 0
		if (tonumber(intID) == tonumber(interiorID)) then
			triggerClientEvent(player, "interior:updateIntLights", player, status)
		end
	end
end
addEvent("interior:setInteriorLightState", true)
addEventHandler("interior:setInteriorLightState", root, setInteriorLightState)

function sellPropertyCall(thePlayer, interiorID, sellTarget, price)
	local theInterior = exports.global:getInteriorFromID(interiorID, thePlayer)
	if isElement(theInterior) then
		local interiorName = getElementData(theInterior, "interior:name")
		local ownerName = exports.global:getInteriorOwner(theInterior)
		local target = sellTarget -- Don't question this, it's correct. (Slightly inefficient, but correct.)
		if not sellTarget then
			price = getElementData(theInterior, "interior:price")
			sellTarget = thePlayer
		end
		local intType = getElementData(theInterior, "interior:status")
		local isCustomInt = exports.mysql:QueryString("SELECT `custom_int` FROM `interiors` WHERE `id` = (?);", tonumber(interiorID))
		local linkedInteriorID = getElementData(theInterior, "interior:linked") or 0
		local isLinked = false
		if (linkedInteriorID ~= 0) then
			local linkedInterior = exports.data:getElement("interior", linkedInteriorID)
			local linkedIntPrice = 0
			if not linkedInterior then
				linkedIntPrice = exports.mysql:QueryString("SELECT `price` FROM `interiors` WHERE `id` = (?);", linkedInteriorID)
			else
				linkedIntPrice = getElementData(linkedInterior, "interior:price") or 0
			end
			isLinked = linkedIntPrice -- isLinked now becomes the price.
		end
		if isCustomInt then isCustomInt = "Yes" else isCustomInt = "No" end

		triggerClientEvent(sellTarget, "interior:showPurchasePropertyGUI", sellTarget, {interiorID, interiorName, ownerName, intType[1], isCustomInt}, thePlayer, target, price, isLinked)
		return true
	else
		outputChatBox("ERROR: Something went wrong.", thePlayer, 255, 0, 0)
	end
	return false
end
addEvent("interior:sellPropertyCall", true)
addEventHandler("interior:sellPropertyCall", root, sellPropertyCall)

function handleIntSaleCallback(interiorID, state, fromPlayer, price, fromCard)
	-- States: 0 - Start int preview, 1 - Canceled, 2 - Finish int Preview, 3 - Purchased
	if (state == 0) then
		local theInterior = exports.data:getElement("interior", interiorID)
		local x, y, z, rz, dim, int = unpack(getElementData(theInterior, "interior:exit"))
		exports.global:elementEnterInterior(source, {x, y, z}, {0, 0, rz}, dim, int, false, true)
		exports.logs:addLog(source, 3, {theInterior}, "Started previewing interior.")
	elseif (state == 3) then
		local theInterior, interiorID, interiorName = exports.global:getInteriorFromID(interiorID, source)
		local charID = getElementData(source, "character:id")
		exports.blackhawk:changeElementDataEx(theInterior, "interior:owner", charID)
		local theInterior = reloadInterior(interiorID)
		if theInterior then
			local formattedPrice = "$" .. exports.global:formatNumber(price)
			local intLink = getElementData(theInterior, "interior:linked") or 0
			if (intLink ~= 0) then
				local linkedInterior, linkedIntID, linkedIntName = exports.global:getInteriorFromID(intLink, source)
				if linkedInterior then
					exports.blackhawk:changeElementDataEx(linkedInterior, "interior:owner", charID)
					reloadInterior(intLink)
					outputChatBox("You have obtained the property '(" .. intLink .. ") " .. linkedIntName .. "' as it was linked to interior #" .. interiorID .. ".", thePlayer, 255, 255, 0)
					exports.logs:addInteriorLog(intLink, "[PURCHASE] Interior #" .. interiorID .. " purchased by " .. getPlayerName(source):gsub("_", " ")  .. ", automatically gained this linked property.", source)
				end
			end
			local thePlayerName = getPlayerName(source):gsub("_", " ")
			outputChatBox("You have purchased '(" .. interiorID .. ") " .. interiorName .. "' for " .. formattedPrice .. ".", source, 255, 255, 0)
			-- Take money from player. (var 'price'), if fromCard then take money from bank instead. @requires item-system
			if fromPlayer then
				if (fromPlayer ~= source) then
					outputChatBox(thePlayerName .. " has purchased '(" .. interiorID .. ") " .. interiorName .. "' for " .. formattedPrice .. ".", fromPlayer, 255, 255, 0)
				end
				exports.logs:addLog(source, 44, {fromPlayer}, "(/sellint) " .. getPlayerName(fromPlayer):gsub("_", " ") .. " sold '(" .. interiorID .. ") " .. interiorName .. "' to " .. thePlayerName .. " for " .. formattedPrice .. ".")
				exports.logs:addInteriorLog(interiorID, "[PURCHASE] Interior purchased from " .. getPlayerName(fromPlayer):gsub("_", " ") .. " for " .. formattedPrice .. ".", source)
			else
				exports.logs:addLog(source, 44, source, thePlayerName .. " purchased property from server for " .. formattedPrice .. ".")
				exports.logs:addInteriorLog(interiorID, "[PURCHASE] Interior purchased for " .. formattedPrice .. ".", source)
			end
		else
			outputChatBox("ERROR: Something went wrong whilst updating the interior owner!", thePlayer, 255, 0, 0)
			return false
		end
	elseif (state == 2) then
		if not interiorID then
			interiorID = getElementData(source, "character:realininterior")
		else
			outputChatBox("You are no longer previewing the property.", source, 75, 230, 10)
		end
		local theInterior = exports.data:getElement("interior", interiorID)
		removeElementData(source, "var:int:previewint")
		local x, y, z, rz, dim, int = unpack(getElementData(theInterior, "interior:entrance"))
		exports.global:elementEnterInterior(source, {x, y, z}, {0, 0, rz}, dim, int, false, true)
	else
		if fromPlayer ~= source then
			local thePlayerName = getPlayerName(source):gsub("_", " ")
			outputChatBox("You have declined the offer to purchase the property.", source, 255, 255, 0)
			outputChatBox(thePlayerName .. " has declined your offer to purchase the property.", fromPlayer, 255, 0, 0)
		end
	end
end
addEvent("interior:handleIntSaleCallback", true)
addEventHandler("interior:handleIntSaleCallback", root, handleIntSaleCallback)