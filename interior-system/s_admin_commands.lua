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

function createIntCallback(thePlayer, intid, type, owner, name, price)
	local theInterior, reason = createInterior(thePlayer, intid, type, owner, name, price)
	if (theInterior) then
		local intID = getElementData(theInterior, "interior:id")
		outputChatBox("You have created the interior '" .. name .. "'. [ID: " .. intID .. "]", thePlayer, 0, 255, 0)

		local intOwner = "No one"
		if (owner == 25560) then
			intOwner = "Server"
		elseif (owner ~= 0) then
			intOwner = getPlayerName(owner):gsub("_", " ")
		end
		
		local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
		exports.global:sendMessage("[INFO] " .. thePlayerName .. " has created the interior '" .. name .. "'. [ID: " .. intID .. "]", 2, true)
		exports.global:sendMessageToManagers("[WARN] " .. thePlayerName .. " has created interior #" .. intID .. ". [Owner: " .. intOwner .. "]", true)
		exports.logs:addLog(thePlayer, 1, theInterior, "(/createint) Interior '" .. name .. "' created. [ID: " .. intID .. ", Owner: " .. intOwner .. "]")
		exports.logs:addInteriorLog(intID, "[CREATEINT] Interior created by " .. thePlayerName .. ".\nGTA interior ID: " .. intid .. "\nOwner: " .. intOwner .. "\nPrice: $" .. exports.global:formatNumber(price), thePlayer)
	else
		outputChatBox("ERROR: " .. reason, thePlayer, 255, 0, 0)
	end
end
addEvent("interior:createIntCall", true) -- Used by /createint GUI.
addEventHandler("interior:createIntCall", root, createIntCallback)

function previewInteriorCall(thePlayer, interiorID)
	if not tonumber(interiorID) then
		outputChatBox("ERROR: Please select an interior to preview first!", thePlayer, 255, 0, 0)
		return false
	end

	-- Get interior data.
	local int = g_interiors[interiorID][1]
	local x, y, z, rz = unpack(g_interiors[interiorID][2])
	local intName = g_interiors[interiorID][5]
	local randomDim = math.random(50000, 60000)
	local intCategory = g_interiors[interiorID][3]; intCategory = g_interiorTypes[intCategory][1]
	local intSize = g_interiors[interiorID][4]; intSize = g_interiorSizes[intSize][1]

	setElementInterior(thePlayer, int)
	setElementPosition(thePlayer, x, y, z)
	setElementRotation(thePlayer, 0, 0, rz)
	setElementDimension(thePlayer, randomDim)

	outputChatBox(" ", thePlayer)
	outputChatBox("You are now previewing interior #" .. interiorID .. ".", thePlayer, 75, 230, 10)
	outputChatBox("Interior Name: " .. intName, thePlayer, 75, 230, 10)
	outputChatBox("Category: " .. intCategory, thePlayer, 75, 230, 10)
	outputChatBox("Size: " .. intSize, thePlayer, 75, 230, 10)
end
addEvent("interior:previewInteriorCall", true) -- Used by /intlist GUI.
addEventHandler("interior:previewInteriorCall", root, previewInteriorCall)

-- /reloadint [Interior ID] - By Skully (09/06/18) [Helper/Developer]
function reloadInteriorCmd(thePlayer, commandName, interiorID)
	if exports.global:isPlayerHelper(thePlayer) or exports.global:isPlayerDeveloper(thePlayer) then
		if not (interiorID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Interior ID]", thePlayer, 75, 230, 10)
			return false
		end

		local theInterior, interiorID = exports.global:getInteriorFromID(interiorID, thePlayer)
		if (theInterior) then
			local state, reason = reloadInterior(interiorID)
			if (state) then
				local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
				outputChatBox("You have reloaded interior #" .. interiorID .. ".", thePlayer, 0, 255, 0)
				
				local theInteriorRenewed = exports.data:getElement("interior", interiorID)
				exports.logs:addLog(thePlayer, 1, theInteriorRenewed, "(/reloadint) Interior reloaded.")
				exports.logs:addInteriorLog(interiorID, "[RELOADINT] Interior saved and reloaded.", thePlayer)
				exports.global:sendMessageToManagers("[INFO] " .. thePlayerName .. " has reloaded interior #" .. interiorID .. ".")
			else
				outputChatBox("ERROR: " .. reason, thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("reloadint", reloadInteriorCmd)

-- /delint [Interior ID] - By Skully (09/06/18) [Trial Admin]
function deleteInterior(thePlayer, commandName, interiorID)
	if exports.global:isPlayerTrialAdmin(thePlayer) then
		if not tonumber(interiorID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Interior ID]", thePlayer, 75, 230, 10)
			return false
		end

		-- Check to see if the interior exists.
		interiorID = tonumber(interiorID)
		local theInterior = exports.mysql:QueryString("SELECT `deleted` FROM `interiors` WHERE `id` = (?);", interiorID)
		if not (theInterior) then
			outputChatBox("ERROR: That interior doesn't exist!", thePlayer, 255, 0, 0)
			return false
		end

		-- Check if the interior is already deleted.
		if (tonumber(theInterior) ~= 0) then
			outputChatBox("ERROR: That interior is already deleted!", thePlayer, 255, 0, 0)
			return false
		end

		local theInterior, interiorID, theInteriorName = exports.global:getInteriorFromID(interiorID, thePlayer)
		if not (theInterior) then return false end

		-- Get the name of the interior's owner.
		local ownerID = getElementData(theInterior, "interior:owner")
		local ownerName = "Unknown"
		if (tonumber(ownerID) < 0) then -- If the owner is a faction.
			ownerName = "Generic Faction" -- Get the faction name here. @requires faction-system
		elseif tonumber(ownerID) == 25560 then -- Server owned.
			ownerName = "Server"
		elseif tonumber(ownerID) == 0 then
			ownerName = "No one"
		else
			local _, accountName = exports.global:getCharacterAccount(ownerID)
			ownerName = exports.mysql:QueryString("SELECT `name` FROM `characters` WHERE `id` = (?);", ownerID) or "Unknown"
			ownerName = ownerName:gsub("_", " ")
			ownerName = ownerName .. " (" .. accountName .. ")"
		end

		-- Check if the player is deleting the interior already, if not, prompt them.
		local isDeleting = getElementData(thePlayer, "temp:isdeletingint")
		if not (isDeleting) or (isDeleting ~= interiorID) then
			outputChatBox("[Interior ID #" .. interiorID .. "] " .. theInteriorName .. " - Owner: " .. ownerName, thePlayer, 255, 255, 0)
			outputChatBox("[Interior ID #" .. interiorID .. "] Are you sure you would like to delete this interior? Type /delint " .. interiorID .. " again to confirm deletion.", thePlayer, 255, 255, 0)
			setElementData(thePlayer, "temp:isdeletingint", interiorID)
			return true
		elseif (isDeleting == interiorID) then -- If player has confirmed deletion.
			removeElementData(thePlayer, "temp:isdeletingint")

			local query = exports.mysql:Execute("UPDATE `interiors` SET `deleted` = 1 WHERE `id` = (?);", interiorID)
			if (query) then
				outputChatBox("You have deleted interior #" .. interiorID .. ".", thePlayer, 255, 0, 0)
				local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
				exports.global:sendMessage("[INFO] " .. thePlayerName .. " has deleted interior #" .. interiorID .. ". [Name: " .. theInteriorName .. "] - Owner: " .. ownerName, 2, true)
				exports.global:sendMessageToManagers("[WARN] " .. thePlayerName .. " has deleted interior #" .. interiorID .. " [Name: " .. theInteriorName .. "] - Owner: " .. ownerName, true)
				exports.logs:addLog(thePlayer, 1, theInterior, "Deleted interior #" .. interiorID .. " [Name: " .. theInteriorName .. " - Owner: " .. ownerName .. "]")
				exports.logs:addVehicleLog(interiorID, "[DELINT] INTERIOR DELETED - " .. theInteriorName, thePlayer)
				-- Destroy all existing teleporter markers.
				for i, thePlayer in ipairs(getElementsByType("player")) do
					triggerClientEvent(thePlayer, "interior:destroyInteriorMarkers", thePlayer, interiorID)
				end
				destroyElement(theInterior) -- Delete the element after the logs have been submit.
			else
				outputChatBox("ERROR: Failed to delete interior!", thePlayer, 255, 0, 0)
				exports.global:outputDebug("@deleteInterior: Failed to delete interior ID " .. interiorID .. ", is there an active database connection?")
				return false
			end
		end
	end
end
addCommandHandler("delint", deleteInterior)

-- /removeint [Interior ID] - By Skully (09/06/18) [Manager]
function removeInterior(thePlayer, commandName, interiorID)
	if exports.global:isPlayerManager(thePlayer) then
		if not (interiorID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Interior ID]", thePlayer, 75, 230, 10)
			return false
		end
		interiorID = tonumber(interiorID)

		local isDeleted = exports.mysql:QueryString("SELECT `deleted` FROM `interiors` WHERE `id` = (?);", interiorID)
		if not (isDeleted) then
			outputChatBox("ERROR: That interior does not exist!", thePlayer, 255, 0, 0)
			return false
		end

		if (tonumber(isDeleted) ~= 1) then -- If the interior is not deleted.
			outputChatBox("ERROR: That interior is not currently deleted, use '/" .. commandName .. " " .. interiorID .. "' first.", thePlayer, 255, 0, 0)
			return false
		end

		local isRemoving = getElementData(thePlayer, "temp:isremovingint")

		-- If the interior element still exists somehow, we can remove it.
		local theInterior = exports.data:getElement("interior", interiorID)
		if (theInterior) then destroyElement(theInterior) end

		if not (isRemoving) or (isRemoving ~= interiorID) then
			outputChatBox("[Interior ID #" .. interiorID .. "] WARNING: You are about to permanently delete this interior and it can no longer be restored.", thePlayer, 255, 0, 0)
			outputChatBox("[Interior ID #" .. interiorID .. "] Type /" .. commandName .." " .. interiorID .. " again to confirm deletion.", thePlayer, 255, 0, 0)
			setElementData(thePlayer, "temp:isremovingint", interiorID)
			return true
		elseif (isRemoving == interiorID) then
			removeElementData(thePlayer, "temp:isremovingint")

			local query = exports.mysql:Execute("DELETE FROM `interiors` WHERE `id` = (?);", interiorID)
			if (query) then
				-- Delete all logs associated with the interior.
				exports.mysql:Execute("DELETE FROM `interior_logs` WHERE `intid` = (?);", interiorID)

				-- Outputs.
				outputChatBox("You have removed interior #" .. interiorID .. " from the database.", thePlayer, 0, 255, 0)
				local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
				exports.global:sendMessage("[INFO] " .. thePlayerName .. " has removed interior #" .. interiorID .. " from the database.", 2, true)
				exports.logs:addLog(thePlayer, 1, "INT" .. interiorID, thePlayerName .. " has removed interior #" .. interiorID .. " from the database.")

			else
				outputChatBox("ERROR: Failed to remove the interior!", thePlayer, 255, 0, 0)
				exports.global:outputDebug("@removeInterior: Failed to remove interior ID " .. interiorID .. ", is there an active database connection?")
				return false
			end
		end
	end
end
addCommandHandler("removeint", removeInterior)

-- /setintentrance - By Skully (09/06/18) [Helper]
function setInteriorEntrance(thePlayer, commandName, interiorID)
	if exports.global:isPlayerHelper(thePlayer) or exports.global:isPlayerMappingTeam(thePlayer) then
		if not interiorID then
			outputChatBox("SYNTAX: /" .. commandName .. " [Interior ID]", thePlayer, 75, 230, 10)
			return false
		end

		local theInterior, interiorID = exports.global:getInteriorFromID(interiorID, thePlayer)
		if (theInterior) then
			-- Update the element data.
			local x, y, z = getElementPosition(thePlayer)
			local _, _, rz = getElementRotation(thePlayer)
			local thePlayerInt = getElementInterior(thePlayer)
			local thePlayerDimension = getElementDimension(thePlayer)
			local intEntrance = {x, y, z, rz, thePlayerDimension, thePlayerInt}
			local locationString = x..","..y..","..z..","..rz
			-- Update in database.
			local query = exports.mysql:Execute("UPDATE `interiors` SET `location` = (?), `dimension` = (?), `interior` = (?) WHERE `id` = (?);", locationString, thePlayerDimension, thePlayerInt, interiorID)
			if query then
				exports.blackhawk:changeElementDataEx(theInterior, "interior:entrance", intEntrance)
				-- Reload the interior markers.
				local theInterior, reason = reloadInterior(interiorID)
				if not (theInterior) then
					outputChatBox("ERROR: " .. reason, thePlayer, 255, 0, 0)
					return false
				end

				-- Outputs and logs.
				local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
				outputChatBox("You have moved this interiors entrance position.", thePlayer, 0, 255, 0)
				exports.global:sendMessageToManagers("[INFO] " .. thePlayerName .. " has adjusted interior #" .. interiorID .. "'s entrance position.")
				exports.logs:addInteriorLog(interiorID, "[SETINTENTRANCE] Entrance position has been moved.", thePlayer)
				exports.logs:addLog(thePlayer, 1, theInterior, "(/setintentrance) Entrance position of interior moved to '" .. x .. ", " .. y .. ", " .. z .. ", " .. rz .. "'. (Dimension: " .. thePlayerDimension .. ", Interior: " .. thePlayerInt .. ")")
			else
				outputChatBox("ERROR: Failed to save changes to database.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("setintentrance", setInteriorEntrance)
addCommandHandler("setinteriorentrance", setInteriorEntrance)


-- /setintexit - By Skully (09/06/18) [Helper]
function setInteriorExit(thePlayer)
	if exports.global:isPlayerHelper(thePlayer) or exports.global:isPlayerMappingTeam(thePlayer) then

		-- Ensure the player is inside of an interior.
		local interiorID = getElementData(thePlayer, "character:realininterior")
		local thePlayerDimension = getElementDimension(thePlayer)
		if (interiorID == 0) or (interiorID ~= thePlayerDimension) then
			outputChatBox("ERROR: You aren't inside of an interior!", thePlayer, 255, 0, 0)
			return false
		end

		local theInterior, interiorID = exports.global:getInteriorFromID(interiorID, thePlayer)
		if (theInterior) then
			-- Update the element data.
			local x, y, z = getElementPosition(thePlayer)
			local _, _, rz = getElementRotation(thePlayer); rz = (rz + 180) % 360 -- Flip angle opposite since player will be facing the exit (A wall/door.)
			local thePlayerInt = getElementInterior(thePlayer)
			local intExit = {x, y, z, rz, thePlayerDimension, thePlayerInt}
			local locationString = x..","..y..","..z..","..rz
			-- Update in database.
			local query = exports.mysql:Execute("UPDATE `interiors` SET `inside_location` = (?), `inside_dimension` = (?), `inside_interior` = (?) WHERE `id` = (?);", locationString, thePlayerDimension, thePlayerInt, interiorID)
			if query then
				exports.blackhawk:changeElementDataEx(theInterior, "interior:exit", intExit)
				-- Reload the interior markers.
				local theInterior, reason = reloadInterior(interiorID)
				if not (theInterior) then
					outputChatBox("ERROR: " .. reason, thePlayer, 255, 0, 0)
					return false
				end

				-- Outputs and logs.
				local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
				outputChatBox("You have moved this interiors exit position.", thePlayer, 0, 255, 0)
				exports.global:sendMessageToManagers("[INFO] " .. thePlayerName .. " has adjusted interior #" .. interiorID .. "'s exit position.")
				exports.logs:addInteriorLog(interiorID, "[SETINTEXIT] Exit position has been moved.", thePlayer)
				exports.logs:addLog(thePlayer, 1, theInterior, "(/setintexit) Exit position of interior moved to '" .. x .. ", " .. y .. ", " .. z .. ", " .. rz .. "'. (Dimension: " .. thePlayerDimension .. ", Interior: " .. thePlayerInt .. ")")
			else
				outputChatBox("ERROR: Failed to save changes to database.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("setintexit", setInteriorExit)
addCommandHandler("setinteriorexit", setInteriorExit)

-- /setintid [Int ID] - By Skully (10/06/18) [Trial Admin/MT]
function setInteriorID(thePlayer, commandName, intID)
	if exports.global:isPlayerTrialAdmin(thePlayer) or exports.global:isPlayerMappingTeam(thePlayer) then
		if not tonumber(intID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Interior ID]", thePlayer, 75, 230, 10)
			return false
		end

		intID = tonumber(intID)

		-- Check if interior ID exists.
		if not g_interiors[intID] then
			outputChatBox("ERROR: That is not a valid interior ID, please check /intlist for a list of valid IDs.", thePlayer, 255, 0, 0)
			return false
		end

		-- Check if player is inside an interior.
		local realininterior = getElementData(thePlayer, "character:realininterior") or 0
		if (realininterior == 0) then
			outputChatBox("ERROR: You must be inside an interior.", thePlayer, 255, 0, 0)
			return false
		end

		-- Check if interior element exists.
		local theInterior = exports.data:getElement("interior", realininterior)
		if not (theInterior) then
			outputChatBox("ERROR: You must be inside and interior.", thePlayer, 255, 0, 0)
			return false
		end

		local x, y, z, rz = unpack(g_interiors[intID][2])
		setElementInterior(thePlayer, g_interiors[intID][1], x, y, z)
		setElementRotation(thePlayer, 0, 0, rz)

		exports.blackhawk:changeElementDataEx(theInterior, "interior:exit", {x, y, z, rz, realininterior, g_interiors[intID][1]})
		local theInterior, state = reloadInterior(realininterior)
		if (theInterior) then
			local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
			outputChatBox("You have updated this interior's ID to #" .. intID .. ". (" .. g_interiors[intID][5] .. ")", thePlayer, 0, 255, 0)
			exports.global:sendMessageToManagers("[INFO] " .. thePlayerName .. " has adjusted interior #" .. realininterior .. "'s interior to '" .. g_interiors[intID][5] .. "'.")
			exports.logs:addLog(thePlayer, 1, {thePlayer, theInterior}, "(/setintid) Updated interior's ID to #" .. intID .. ". (" .. g_interiors[intID][5] .. ")")
			exports.logs:addInteriorLog(realininterior, "[SETINTID] Updated interior's ID to #" .. intID .. ". (" .. g_interiors[intID][5] .. ")", thePlayer)
		else
			outputChatBox("ERROR: " .. reason, thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("setintid", setInteriorID)

-- /togint [Interior ID] - By Skully (20/06/18) [Trial Admin/MT]
function toggleInterior(thePlayer, commandName, interiorID)
	if exports.global:isPlayerTrialAdmin(thePlayer) or exports.global:isPlayerMappingTeam(thePlayer) then
		if not (interiorID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Interior ID]", thePlayer, 75, 230, 10)
			return false
		end

		local theInterior, interiorID, intName = exports.global:getInteriorFromID(interiorID, thePlayer)
		if (theInterior) then
			local oldStatus = getElementData(theInterior, "interior:status")
			local toggled = 1; if oldStatus[2] == 1 then toggled = 0 end
			exports.blackhawk:changeElementDataEx(theInterior, "interior:status", {oldStatus[1], toggled})
			local theInterior, reason = reloadInterior(interiorID)
			if (theInterior) then
				if toggled == 1 then toggled = "disabled" else toggled = "enabled" end
				local thePlayerName = exports.global:getStaffTitle(thePlayer)
				outputChatBox("You have " .. toggled .. " interior #" .. interiorID .. ".", thePlayer, 0, 255, 0)
				exports.global:sendMessage("[INFO] " .. thePlayerName .. " has " .. toggled .. " interior #" .. interiorID .. ".", 2, true)
				exports.logs:addLog(thePlayer, 1, {thePlayer, theInterior}, "(/togint) Interior " .. toggled .. ".")
				exports.logs:addInteriorLog(interiorID, "[TOGINT] Interior has been " .. toggled .. ".", thePlayer)
			else
				outputChatBox("ERROR: " .. reason, thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("togint", toggleInterior)

-- /gotoint [Interior ID] (Player/ID) - By Skully (20/06/18) [Helper/MT]
function gotoInterior(thePlayer, commandName, interiorID, targetPlayer)
	if exports.global:isPlayerHelper(thePlayer) or exports.global:isPlayerMappingTeam(thePlayer) then
		if not (interiorID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Interior ID] (Player/ID)", thePlayer, 75, 230, 10)
			return
		end

		local playerToSend, targetPlayerName = thePlayer
		if targetPlayer then
			targetPlayer, targetPlayerName = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)
			if targetPlayer then playerToSend = targetPlayer end
		end

		local theInterior, interiorID = exports.global:getInteriorFromID(interiorID, thePlayer)
		if (theInterior) then
			if (commandName == "gotoint") then
				local x, y, z, rz, dim, int = unpack(getElementData(theInterior, "interior:entrance"))
				setElementPosition(playerToSend, x, y, z, true); setElementDimension(playerToSend, dim); setElementInterior(playerToSend, int); setElementRotation(playerToSend, 0, 0, rz)
			else
				x, y, z, rz, dim, int = unpack(getElementData(theInterior, "interior:exit"))
				exports.global:elementEnterInterior(playerToSend, {x, y, z}, {0, 0, rz}, dim, int, false, true)
			end
			local placement = "outside"; if commandName == "gotointi" then placement = "inside" end
			local thePlayerName = exports.global:getStaffTitle(thePlayer)
			
			if (targetPlayer) then
				outputChatBox("You have teleported " .. targetPlayerName .. " " .. placement .. " interior #" .. interiorID .. ".", thePlayer, 75, 230, 10)
				outputChatBox(thePlayerName .. " has teleported you " .. placement .. " interior #" .. interiorID .. ".", targetPlayer, 0, 255, 0)
				exports.global:sendMessageToManagers("[INFO] " .. thePlayerName .. " has teleported " .. targetPlayerName .. " " .. placement .. " interior #" .. interiorID .. ".")
				exports.logs:addLog(thePlayer, 1, {thePlayer, targetPlayer, interiorID}, "("..commandName..") Teleported " .. targetPlayerName .. " " .. placement .. " interior.")
				exports.logs:addInteriorLog(interiorID, "[" .. commandName:upper() .. "] Teleported " .. targetPlayerName .. " " .. placement .. " interior.", thePlayer)
			else
				outputChatBox("You have teleported ".. placement .. " interior #" .. interiorID .. ".", thePlayer, 0, 255, 0)
				exports.global:sendMessageToManagers("[INFO] " .. thePlayerName .. " has teleported ".. placement .. " interior #" .. interiorID .. ".")
				exports.logs:addLog(thePlayer, 1, {thePlayer, interiorID}, "(" .. commandName .. ") Teleported ".. placement .. " interior.")
				exports.logs:addInteriorLog(interiorID, "[" .. commandName:upper() .. "] " .. thePlayerName .. " teleported ".. placement .. " interior.", thePlayer)
			end

		end
	end
end
addCommandHandler("gotoint", gotoInterior)
addCommandHandler("gotointi", gotoInterior)

function nearbyInteriorsCall(interiorIDs)
	for i, intid in ipairs(interiorIDs) do
		local theInterior, interiorID, intName = exports.global:getInteriorFromID(intid, source)
		if theInterior then
			local owner = getElementData(theInterior, "interior:owner")
			local ownerName = "Unknown"
			if (owner == 0) then ownerName = "No one"
			elseif (owner < 0) then
				ownerName = "Generic Faction" -- Get faction name from ID. @requires faction-system
			elseif (owner == 25560) then
				ownerName = "Server"
			else
				ownerName = exports.global:getCharacterNameFromID(owner)
			end
			local lockState = getElementData(theInterior, "interior:locked"); if lockState == 1 then lockState = "Yes" else lockState = "No" end
			local intType = getElementData(theInterior, "interior:status"); intType = intType[1]
			outputChatBox("    [#" .. interiorID .. "] " .. intName .. " | Owner: " .. ownerName .. " | Locked: " .. lockState .. " | Type: " .. g_interiorTypes[intType][1], source, 75, 230, 10)
		end
	end
end
addEvent("interior:nearbyInteriorCall", true) -- Used by /nearbyints.
addEventHandler("interior:nearbyInteriorCall", root, nearbyInteriorsCall)