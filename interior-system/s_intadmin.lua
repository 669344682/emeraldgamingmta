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

-- /reloadint [Interior ID] - By Skully (09/06/18) [Helper/MT/Developer]
function reloadInteriorCmd(thePlayer, commandName, interiorID)
	if exports.global:isPlayerHelper(thePlayer) or exports.global:isPlayerMappingTeam(thePlayer) or exports.global:isPlayerDeveloper(thePlayer) then
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
addEvent("interior:reloadintcall", true) -- Used by /checkint GUI.
addEventHandler("interior:reloadintcall", root, reloadInteriorCmd)

-- /delint [Interior ID] - By Skully (09/06/18) [Trial Admin]
function deleteInterior(thePlayer, commandName, interiorID)
	if exports.global:isPlayerTrialAdmin(thePlayer) or exports.global:isPlayerMappingTeamLeader(thePlayer) then
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
			local theFaction = exports.data:getElement("team", -ownerID)
			ownerName = getElementData(theFaction, "faction:name") or "Unknown"
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
			if not (commandName == "ui") then
				outputChatBox("[Interior ID #" .. interiorID .. "] " .. theInteriorName .. " - Owner: " .. ownerName, thePlayer, 255, 255, 0)
				outputChatBox("[Interior ID #" .. interiorID .. "] Are you sure you would like to delete this interior? Type /delint " .. interiorID .. " again to confirm deletion.", thePlayer, 255, 255, 0)
			end
			setElementData(thePlayer, "temp:isdeletingint", interiorID)
			return true
		elseif (isDeleting == interiorID) then -- If player has confirmed deletion.
			removeElementData(thePlayer, "temp:isdeletingint")

			local query = exports.mysql:Execute("UPDATE `interiors` SET `deleted` = '1', `linked_int` = '0' WHERE `id` = (?);", interiorID)
			if (query) then
				-- If the interior is linked to another interior, unlink them.
				local linkedInt = getElementData(theInterior, "interior:linked") or 0
				if linkedInt then
					local linkedInterior = exports.data:getElement("interior", linkedInt)
					if linkedInterior then
						exports.blackhawk:changeElementDataEx(linkedInterior, "interior:linked", 0)
						reloadInterior(linkedInt)
					else
						exports.mysql:Execute("UPDATE `interiors` SET `linked_int` = '0' WHERE `id` = (?);", tonumber(linkedInt))
					end
					exports.logs:addInteriorLog(linkedInt, "[UNLINK] Interior unlinked from interior #" .. interiorID .. " as it was deleted.", thePlayer)
					outputChatBox("Interior #" .. linkedInt .. " has been unlinked from interior #" .. interiorID .. ".", thePlayer, 255, 255, 0)
				end

				outputChatBox("You have deleted interior #" .. interiorID .. ".", thePlayer, 255, 0, 0)
				local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
				exports.global:sendMessage("[INFO] " .. thePlayerName .. " has deleted interior #" .. interiorID .. ". [Name: " .. theInteriorName .. "] - Owner: " .. ownerName, 2, true)
				exports.global:sendMessageToManagers("[WARN] " .. thePlayerName .. " has deleted interior #" .. interiorID .. " [Name: " .. theInteriorName .. "] - Owner: " .. ownerName, true)
				exports.logs:addLog(thePlayer, 1, theInterior, "Deleted interior #" .. interiorID .. " [Name: " .. theInteriorName .. " - Owner: " .. ownerName .. "]")
				exports.logs:addInteriorLog(interiorID, "[DELINT] INTERIOR DELETED - " .. theInteriorName, thePlayer)
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
addEvent("interior:deleteintcall", true) -- Used by /interiors and /checkint GUIs.
addEventHandler("interior:deleteintcall", root, deleteInterior)

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
			outputChatBox("ERROR: That interior is not currently deleted, use '/delint " .. interiorID .. "' first.", thePlayer, 255, 0, 0)
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
addEvent("interior:removeintcall", true)
addEventHandler("interior:removeintcall", root, removeInterior)

-- /restoreint [Interior ID] - By Skully (21/06/18) [Admin/MT]
function restoreInterior(thePlayer, commandName, interiorID)
	if exports.global:isPlayerTrialAdmin(thePlayer) or exports.global:isPlayerMappingTeam(thePlayer) then
		if not tonumber(interiorID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Interior ID]", thePlayer, 75, 230, 10)
			return
		end

		interiorID = tonumber(interiorID)
		local intData = exports.mysql:QuerySingle("SELECT `deleted`, `name`, `owner`, `faction` FROM `interiors` WHERE `id` = (?);", interiorID)
		if (intData) then
			if (intData.deleted ~= 1) then
				outputChatBox("ERROR: That interior is not deleted!", thePlayer, 255, 0, 0)
				return false
			end

			local isRestoring = getElementData(thePlayer, "temp:isrestoringint")
			if not (isRestoring) or (isRestoring ~= interiorID) then
				local ownerName = "Unknown"
				if (intData.faction ~= 0) then
					local theFaction = exports.data:getElement("team", intData.faction)
					if theFaction then
						ownerName = getElementData(theFaction, "faction:name") or "Unknown"
					end
					elseif (intData.owner == 0) then ownerName = "No one"
					elseif (intData.owner == 25560) then ownerName = "Server"
					else ownerName = exports.global:getCharacterNameFromID(intData.owner)
				end
				if not (commandName == "ui") then
					outputChatBox("[Interior ID #" .. interiorID .. "] " .. intData.name .. " - Owner: " .. ownerName, thePlayer, 255, 255, 0)
					outputChatBox("[Interior ID #" .. interiorID .. "] Type /" .. commandName .." " .. interiorID .. " again to confirm you want to restore the interior.", thePlayer, 255, 255, 0)
				end
				setElementData(thePlayer, "temp:isrestoringint", interiorID)
				return true
			else
				removeElementData(thePlayer, "temp:isrestoringint")

				local ownerName = "Unknown"
				if (intData.faction ~= 0) then
					local theFaction = exports.data:getElement("team", intData.faction)
					if theFaction then
						ownerName = getElementData(theFaction, "faction:name") or "Unknown"
					end
					elseif (intData.owner == 0) then ownerName = "No one"
					elseif (intData.owner == 25560) then ownerName = "Server"
					else ownerName = exports.global:getCharacterNameFromID(intData.owner)
				end
				
				-- Check if the owner of the interior has enough slots if the interior is owned.
				local checkSlots = true
				if (intData.faction == 0) and (intData.owner == 0) or (intData.owner == 25560) then checkSlots = false end
				
				if checkSlots then
					local isFaction = intData.faction ~= 0
					local hasSlots = exports.global:getInteriorSlots(intData.owner, isFaction)
					if not (hasSlots) then
						outputChatBox("ERROR: " .. ownerName .. " doesn't have enough interior slots to reclaim the interior!", thePlayer, 255, 0, 0)
						return false
					end
				end

				-- Attempt to load the interior.
				local theInterior, reason = loadInterior(interiorID)
				if not (theInterior) then
					outputChatBox("ERROR: " .. reason, thePlayer, 255, 0, 0)
					return false
				end

				-- Update database.
				local query = exports.mysql:Execute("UPDATE `interiors` SET `deleted` = '0' WHERE `id` = (?);", interiorID)
				if (query) then
					local thePlayerName = exports.global:getStaffTitle(thePlayer)
					
					outputChatBox("You have restored interior #" .. interiorID .. " from the database.", thePlayer, 0, 255, 0)
					exports.global:sendMessage("[INFO] " .. thePlayerName .. " has restored interior #" .. interiorID .. " to " .. ownerName .. ".", 2, true)
					exports.logs:addLog(thePlayer, 1, {thePlayer, "INT" .. interiorID}, thePlayerName .. " has restored interior #" .. interiorID .. " to " .. ownerName .. ".")
					exports.logs:addInteriorLog(interiorID, "[RESTOREINT] INTERIOR RESTORED TO: " .. ownerName, thePlayer)
				else
					outputChatBox("ERROR: Failed to restore the interior!", thePlayer, 255, 0, 0)
					exports.global:outputDebug("@restoreInterior: Failed to restore interior ID " .. interiorID .. ", is there an active database connection?")
					return false
				end
			end
		else
			outputChatBox("ERROR: An interior with the ID #" .. interiorID .. " doesn't exist!", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("restoreint", restoreInterior)
addEvent("interior:restoreintcall", true)
addEventHandler("interior:restoreintcall", root, restoreInterior)

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
			local _, _, rz = getElementRotation(thePlayer); rz = (rz + 180) % 360 -- Flip angle opposite since player will be facing the exit (A wall/door.)
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
				exports.logs:addLog(thePlayer, 19, theInterior, "(/setintentrance) Entrance position of interior moved to '" .. x .. ", " .. y .. ", " .. z .. ", " .. rz .. "'. (Dimension: " .. thePlayerDimension .. ", Interior: " .. thePlayerInt .. ")")
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
				exports.logs:addLog(thePlayer, 19, theInterior, "(/setintexit) Exit position of interior moved to '" .. x .. ", " .. y .. ", " .. z .. ", " .. rz .. "'. (Dimension: " .. thePlayerDimension .. ", Interior: " .. thePlayerInt .. ")")
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
			exports.logs:addLog(thePlayer, 19, {thePlayer, theInterior}, "(/setintid) Updated interior's ID to #" .. intID .. ". (" .. g_interiors[intID][5] .. ")")
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
				exports.logs:addLog(thePlayer, 19, {thePlayer, theInterior}, "(/togint) Interior " .. toggled .. ".")
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
				exports.global:elementEnterInterior(playerToSend, {x, y, z}, {0, 0, rz}, dim, int, true, true)
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
addEvent("interior:gotoint", true) -- Used by /checkint GUI.
addEventHandler("interior:gotoint", root, gotoInterior)

function nearbyInteriorsCall(interiorIDs)
	for i, intid in ipairs(interiorIDs) do
		local theInterior, interiorID, intName = exports.global:getInteriorFromID(intid[1], source)
		if theInterior then
			local owner = getElementData(theInterior, "interior:owner")
			local ownerName = "Unknown"
			if (owner == 0) then ownerName = "No one"
			elseif (owner < 0) then
				local theFaction = exports.data:getElement("team", -owner)
				if theFaction then
					ownerName = getElementData(theFaction, "faction:name")
				end
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

-- /interiors - By Skully (21/06/18) [Trial Admin/MT]
function showInteriorList(thePlayer)
	if exports.global:isPlayerTrialAdmin(thePlayer, true) or exports.global:isPlayerMappingTeam(thePlayer) then
		local interiorData = exports.mysql:Query("SELECT * FROM `interiors`;")
		if interiorData then
			local ownerData = {}
			for i, interior in ipairs(interiorData) do
				local intOwner = "Unknown"
				if (interior.faction) ~= 0 then
					local theFaction = exports.data:getElement("team", interior.faction)
					if theFaction then
						ownerName = getElementData(theFaction, "faction:name")
					end
				elseif (interior.owner == 0) then
					intOwner = "No one"
				elseif (interior.owner == 25560) then
					intOwner = "Server"
				else
					intOwner = exports.global:getCharacterNameFromID(interior.owner)
				end
				table.insert(ownerData, intOwner)
			end
			triggerClientEvent(thePlayer, "interior:c_showInteriorList", thePlayer, interiorData, ownerData)
			exports.logs:addLog(thePlayer, 19, thePlayer, "(/interiors) Viewed interior database list.")
		else
			outputChatBox("ERROR: Something went wrong whilst fetching interior information.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("interiors", showInteriorList)

-- /checkint [Interior ID] - By Skully (22/06/18) [Trial Admin/MT]
function checkInterior(thePlayer, commandName, interiorID)
	if exports.global:isPlayerTrialAdmin(thePlayer) or exports.global:isPlayerMappingTeam(thePlayer) then
		local theInterior = getElementData(thePlayer, "character:realininterior") or 0
		if not (interiorID) and (theInterior == 0) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Interior ID]", thePlayer, 75, 230, 10)
			return
		end

		if not (interiorID) or (interiorID == "*") and (theInterior) then
			interiorID = theInterior
		else
			theInterior = exports.data:getElement("interior", interiorID)
			if not (theInterior) then
				theInterior = exports.mysql:QueryString("SELECT `deleted` FROM `interiors` WHERE `id` = (?);", tonumber(interiorID))
				if not (theInterior) then
					outputChatBox("ERROR: An interior with the ID #" .. interiorID .. " does not exist!", thePlayer, 255, 0, 0)
					return false
				end
			end
		end

		interiorID = tonumber(interiorID)

		local interiorData = exports.mysql:QuerySingle("SELECT * FROM `interiors` WHERE `id` = (?);", interiorID)
		if interiorData then
			local interiorLogs, namesTable = exports.logs:getInteriorLogs(interiorID, true)
			local ownerName = "Unknown"
			if (interiorData.faction) ~= 0 then
				local theFaction = exports.data:getElement("team", interiorData.faction)
				if theFaction then
					ownerName = getElementData(theFaction, "faction:abbreviation") .. " (Faction #" .. interiorData.faction .. ")"
				end
				elseif (interiorData.owner == 0) then ownerName = "No one"
				elseif (interiorData.owner == 25560) then ownerName = "Server"
				else
					ownerName = exports.global:getCharacterNameFromID(interiorData.owner) or "Unknown"
					local _, ownerAccount = exports.global:getCharacterAccount(interiorData.owner)
					ownerName = ownerName .. " (" .. ownerAccount .. ")"
			end

			triggerClientEvent(thePlayer, "interior:checkinteriorgui", thePlayer, theInterior or false, interiorData, interiorLogs, namesTable, ownerName)
		else
			outputChatBox("ERROR: Failed to fetch interior data.", thePlayer, 255, 0, 0)
			return false
		end
	end
end
addCommandHandler("checkint", checkInterior)
addCommandHandler("checkinterior", checkInterior)
addEvent("interior:checkintcall", true) -- Used by /checkint GUI itself.
addEventHandler("interior:checkintcall", root, checkInterior)

function checkIntDeleteNote(thePlayer, interiorID, noteID)
	local query = exports.mysql:Execute("DELETE FROM `interior_logs` WHERE `id` = (?);", tonumber(noteID))
	if (query) then
		local thePlayerName = exports.global:getStaffTitle(thePlayer)
		exports.global:sendMessageToManagers("[WARN] " .. thePlayerName .. " has deleted note ID " .. noteID .. " from interior #" .. interiorID .. ".", true)
		exports.logs:addLog(thePlayer, 1, {thePlayer, "INT" .. interiorID}, "Deleted note #" .. noteID .. " from interior.")
		exports.logs:addInteriorLog(interiorID, "[NOTE DELETED] Note #" .. noteID .. " was deleted.", thePlayer)
	end
end
addEvent("interior:checkintdelnote", true) -- Used by /checkint GUI.
addEventHandler("interior:checkintdelnote", root, checkIntDeleteNote)

-- /sellint [Player/ID] [Price] - By Skully (26/06/18) [Player]
function sellInterior(thePlayer, commandName, targetPlayer, price)
	if getElementData(thePlayer, "loggedin") == 1 then
		if not targetPlayer then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player/ID] [Price]", thePlayer, 75, 230, 10)
			return
		end

		local targetPlayer, targetPlayerName = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)
		if targetPlayer then
			local staffOverride = exports.global:isPlayerHelper(thePlayer) or exports.global:isPlayerMappingTeamLeader(thePlayer)
			if staffOverride then price = price or 0 end

			-- Prevent helpers/MT selling interiors to themselves.
			if targetPlayer == thePlayer and not exports.global:isPlayerTrialAdmin(thePlayer) then
				outputChatBox("ERROR: You don't have permission to sell interiors to yourself, ask an administrator for assistance.", thePlayer, 255, 0, 0)
				return false
			end

			-- Check price.
			if not tonumber(price) or (tonumber(price) < 0) or (tonumber(price) > 50000000) then
				outputChatBox("SYNTAX: /" .. commandName .. " [Player/ID] [Price]", thePlayer, 75, 230, 10)
				return
			end

			-- Check if interior exists.
			local interiorID = getElementData(thePlayer, "character:realininterior") or 0
			local theInterior = exports.data:getElement("interior", tonumber(interiorID))
			if not theInterior then
				outputChatBox("ERROR: You must be inside the property you want to sell!", thePlayer, 255, 0, 0)
				return false
			end

			-- Check if player can sell the interior.
			local ownerID = getElementData(theInterior, "interior:owner")
			local canSell = staffOverride
			local ownerName, ownerType = exports.global:getInteriorOwner(theInterior)
			if not canSell then
				if (ownerType == "player") then
					if getElementData(thePlayer, "character:id") == ownerID then canSell = true end
				elseif (ownerType == "faction") then
					if exports.global:isPlayerFactionLeader(thePlayer, -ownerID) then canSell = true end
				end
			end

			-- Check if player has keys.
			local hasIntKeys = true -- Check if player has keys of interior. @requires item-system
			if not hasIntKeys and not staffOverride then
				outputChatBox("ERROR: You must have the property keys to sell it!", thePlayer, 255, 0, 0)
				return false
			end

			if not canSell then
				outputChatBox("ERROR: You don't have permission to sell this property!", thePlayer, 255, 0, 0)
				return false
			end

			if staffOverride or exports.global:areElementsWithinDistance(thePlayer, targetPlayer, 6) then
				if staffOverride then
					local charID = getElementData(targetPlayer, "character:id")
					exports.blackhawk:changeElementDataEx(theInterior, "interior:owner", charID)
					local renewedInt = reloadInterior(interiorID)
					if renewedInt then
						local interiorName = getElementData(renewedInt, "interior:name")
						-- Take money from targetPlayer. (var 'price').
						local formattedPrice = "$" .. exports.global:formatNumber(price)
						local thePlayerName = exports.global:getStaffTitle(thePlayer)
						outputChatBox(thePlayerName .. " has given you ownership of the property '(" .. interiorID .. ") " .. interiorName .. "' for " .. formattedPrice .. ".", targetPlayer, 0, 255, 0)
						outputChatBox("You have transfered ownership of '(" .. interiorID .. ") " .. interiorName .. "' to " .. targetPlayerName .. " for " .. formattedPrice .. ".", thePlayer, 0, 255, 0)
						exports.logs:addLog(thePlayer, 1, {targetPlayer}, "(/sellint) " .. thePlayerName .. " transfered ownership of interior to " .. targetPlayerName .. ".")
						exports.logs:addInteriorLog(interiorID, "[SELLINT] " .. thePlayerName .. " transfered ownership of the property to " .. targetPlayerName .. " for " .. formattedPrice .. ".", thePlayer)
						exports.global:sendMessageToManagers("[INFO] " .. thePlayerName .. " has transfered ownership of interior #" .. interiorID .. " to " .. targetPlayerName .. ".")
					else
						outputChatBox("ERROR: Something went wrong whilst updating the interior owner!", thePlayer, 255, 0, 0)
						return false
					end
				else
					local sentRequest = sellPropertyCall(thePlayer, interiorID, targetPlayer, price)
					if sentRequest then
						outputChatBox("You have offered to sell this interior to " .. targetPlayerName .. ", waiting for their response..", thePlayer, 255, 255, 0)
					end
				end
			else
				outputChatBox("ERROR: You aren't close enough to " .. targetPlayerName .. "!", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("sellint", sellInterior)
addCommandHandler("sellproperty", sellInterior)

-- /setintowner [Interior ID] [Player/ID] - By Skully (26/06/18) [Trial Admin]
function setInteriorOwner(thePlayer, commandName, interiorID, targetPlayer)
	if exports.global:isPlayerTrialAdmin(thePlayer) then
		if not interiorID or not targetPlayer then
			outputChatBox("SYNTAX: /" .. commandName .. " [Interior ID] [Player/ID]", thePlayer, 75, 230, 10)
			return
		end

		local theInterior, interiorID = exports.global:getInteriorFromID(interiorID, thePlayer)
		if theInterior then
			local targetPlayer, targetPlayerName = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)
			if targetPlayer then
				local charID = getElementData(targetPlayer, "character:id")
				local intOwner = exports.global:getInteriorOwner(interiorID)
				exports.blackhawk:changeElementDataEx(theInterior, "interior:owner", charID)
				local renewedInt = reloadInterior(interiorID)
				if renewedInt then
					local thePlayerName = exports.global:getStaffTitle(thePlayer)
					exports.logs:addInteriorLog(interiorID, "[SETINTOWNER] Interior ownership transferred from " .. intOwner .. " to " .. targetPlayerName .. ".", thePlayer)
					exports.logs:addLog(thePlayer, 1, {targetPlayer, renewedInt}, "(/setintowner) Set " .. targetPlayerName .. " as interior owner. (Old owner: " .. intOwner .. ")")
					exports.global:sendMessageToManagers("[INFO] " .. thePlayerName .. " has set " .. targetPlayerName .. " the owner of interior #" .. interiorID .. ".")
					outputChatBox("You have set " .. targetPlayerName .. " as the owner of interior #" .. interiorID .. ".", thePlayer, 0, 255, 0)
					outputChatBox(thePlayerName .. " has transferred ownership of interior #" .. interiorID .. " to you.", targetPlayer, 255, 255, 0)
				end
			end
		end
	end
end
addCommandHandler("setintowner", setInteriorOwner)
addCommandHandler("setinteriorowner", setInteriorOwner)

-- /fsellint [Interior ID] - By Skully (26/06/18) [Trial Admin]
function forceSellInterior(thePlayer, commandName, interiorID)
	if exports.global:isPlayerTrialAdmin(thePlayer) then
		if not interiorID then
			outputChatBox("SYNTAX: /" .. commandName .. " [Interior ID]", thePlayer, 75, 230, 10)
			return
		end

		local theInterior, interiorID, interiorName = exports.global:getInteriorFromID(interiorID, thePlayer)
		if theInterior then
			local oldIntOwner, ownerType = exports.global:getInteriorOwner(interiorID)
			if not ownerType then
				outputChatBox("ERROR: That interior already doesn't have an owner!", thePlayer, 255, 0, 0)
				return false
			end

			local isFselling = getElementData(thePlayer, "temp:fsellint")
			if not isFselling or isFselling ~= tonumber(interiorID) then
				setElementData(thePlayer, "temp:fsellint", interiorID)
				outputChatBox("[Interior #" .. interiorID .. "] Are you sure you would like to force-sell " .. interiorName .. "?", thePlayer, 255, 255, 0)
				outputChatBox("[Interior #" .. interiorID .. "] Type /" .. commandName .. " " .. interiorID .. " again to confirm.", thePlayer, 255, 255, 0)
			else
				removeElementData(thePlayer, "temp:fsellint")
				exports.blackhawk:changeElementDataEx(theInterior, "interior:owner", 0)
				local renewedInt = reloadInterior(interiorID)
				if renewedInt then
					local linkedIntID = getElementData(renewedInt, "interior:linked") or 0
					if (linkedIntID ~= 0) then
						local linkedInterior = exports.data:getElement("interior", linkedIntID)
						if linkedInterior then
							exports.blackhawk:changeElementDataEx(linkedInterior, "interior:owner", 0)
							linkedInterior = reloadInterior(linkedIntID)
						else
							exports.mysql:Execute("UPDATE `interiors` SET `owner` = '0', `faction` = '0' WHERE `id` = (?);", tonumber(linkedIntID))
						end
						outputChatBox("[INFO] Interior #" .. linkedIntID .. " has also been force sold as it was linked to #" .. interiorID .. ".", thePlayer, 255, 255, 0)
						exports.logs:addLog(thePlayer, 1, {linkedInterior}, "(/fsellint) Force-sold linked interior. (Old owner: " .. oldIntOwner .. ", Linked Interior: #" .. interiorID .. ")")
						exports.logs:addInteriorLog(linkedIntID, "[FORCE SELL] Interior force sold as linked interior was sold from previous owner: '" .. oldIntOwner .. "'.", thePlayer)
					end
					local thePlayerName = exports.global:getStaffTitle(thePlayer)
					outputChatBox("You have force sold interior #" .. interiorID .. ".", thePlayer, 0, 255, 0)
					exports.global:sendMessage("[INFO] " .. thePlayerName .. " has force sold interior #" .. interiorID .. ".", 2, true)
					exports.logs:addLog(thePlayer, 1, {renewedInt}, "(/fsellint) Force-sold interior. (Old owner: " .. oldIntOwner .. ")")
					exports.logs:addInteriorLog(interiorID, "[FORCE SELL] Interior force sold from previous owner: '" .. oldIntOwner .. "'.", thePlayer)
				end
			end
		end
	end
end
addCommandHandler("fsellint", forceSellInterior)

-- /linkints [Interior ID] [Second Interior ID] - By Skully (29/06/18) [Trial Admin]
function linkInteriors(thePlayer, commandName, interiorID, secondInteriorID)
	if exports.global:isPlayerTrialAdmin(thePlayer) or exports.global:isPlayerMappingTeam(thePlayer) then
		if not interiorID or not secondInteriorID then
			outputChatBox("SYNTAX: /" .. commandName .. " [Interior ID] [Second Interior ID]", thePlayer, 75, 230, 10)
			return
		end

		if interiorID == secondInteriorID then
			outputChatBox("ERROR: You can't link the same interior to itself.", thePlayer, 255, 0, 0)
			return false
		end

		local theInterior, interiorID = exports.global:getInteriorFromID(interiorID, thePlayer)
		if theInterior then
			local secondInterior, secondInteriorID = exports.global:getInteriorFromID(secondInteriorID, thePlayer)
			if secondInterior then
				-- Check if first interior is linked to an interior, if it is then update the linked interior to be unlinked.
				local isLinked = getElementData(theInterior, "interior:linked") or 0
				if (tonumber(isLinked) ~= 0) then
					if (isLinked == secondInteriorID) then
						outputChatBox("ERROR: Interior #" .. interiorID .. " is already linked to #" .. secondInteriorID .. ".", thePlayer, 255, 0, 0)
						return
					end

					local linkedInt = exports.data:getElement("interior", isLinked)
					if linkedInt then
						exports.blackhawk:changeElementDataEx(linkedInt, "interior:linked", 0)
						reloadInterior(isLinked)
					else
						exports.mysql:Execute("UPDATE `interiors` SET `linked_int` = '0' WHERE `id` = (?);", tonumber(sIsLinked))
					end
					exports.logs:addInteriorLog(interiorID, "[UNLINKED] Interior unlinked from interior #" .. isLinked .. ".", thePlayer)
					exports.logs:addInteriorLog(isLinked, "[UNLINKED] Interior unlinked from interior #" .. interiorID .. ".", thePlayer)
					outputChatBox("Interior #" .. isLinked .. " has been unlinked from interior #" .. interiorID .. ".", thePlayer, 255, 255, 0)
				end

				-- Check if second interior is linked to an interior, if it is then update the linked interior to be unlinked.
				local sIsLinked = getElementData(secondInterior, "interior:linked") or 0
				if (tonumber(sIsLinked) ~= 0) then
					if (sIsLinked == interiorID) then
						outputChatBox("ERROR: Interior #" .. interiorID .. " is already linked to #" .. secondInteriorID .. ".", thePlayer, 255, 0, 0)
						return
					end

					local sLinkedInt = exports.data:getElement("interior", sIsLinked)
					if sLinkedInt then
						exports.blackhawk:changeElementDataEx(sLinkedInt, "interior:linked", 0)
						reloadInterior(sIsLinked)
					else
						exports.mysql:Execute("UPDATE `interiors` SET `linked_int` = '0' WHERE `id` = (?);", tonumber(sIsLinked))
					end
					exports.logs:addInteriorLog(secondInteriorID, "[UNLINK] Interior unlinked from interior #" .. sIsLinked .. ".", thePlayer)
					exports.logs:addInteriorLog(sIsLinked, "[UNLINK] Interior unlinked from interior #" .. secondInteriorID .. ".", thePlayer)
					outputChatBox("Interior #" .. sIsLinked .. " has been unlinked from interior #" .. secondInteriorID .. ".", thePlayer, 255, 255, 0)
				end

				-- Link two interiors together.
				exports.blackhawk:changeElementDataEx(theInterior, "interior:linked", tonumber(secondInteriorID))
				exports.blackhawk:changeElementDataEx(secondInterior, "interior:linked", tonumber(interiorID))
				local loadedInt = reloadInterior(interiorID)
				local loadedSecondInt = reloadInterior(secondInteriorID)
				if loadedInt and loadedSecondInt then

					-- Outputs & logs.
					local thePlayerName = exports.global:getStaffTitle(thePlayer)
					outputChatBox("You have linked interior #" .. interiorID .. " to interior #" .. secondInteriorID .. ".", thePlayer, 0, 255, 0)
					exports.logs:addLog(thePlayer, 1, {loadedInt, loadedSecondInt}, "(/linkints) Linked interiors together.")
					exports.logs:addInteriorLog(interiorID, "[LINKED] Interior has been linked to interior #" .. secondInteriorID .. ".", thePlayer)
					exports.logs:addInteriorLog(secondInteriorID, "[LINKED] Interior has been linked to interior #" .. interiorID .. ".", thePlayer)
					exports.global:sendMessageToManagers("[INFO] " .. thePlayerName .. " has linked interior #" .. interiorID .. " to #" .. secondInteriorID .. ".")
				else
					outputChatBox("ERROR: Something went wrong whilst linking the interiors.", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("linkints", linkInteriors)

-- /unlinkint [Interior ID] - By Skully (29/06/18) [Trial Admin/MT]
function unlinkInteriors(thePlayer, commandName, interiorID)
	if exports.global:isPlayerTrialAdmin(thePlayer) or exports.global:isPlayerMappingTeam(thePlayer) then
		if not interiorID then
			outputChatBox("SYNTAX: /" .. commandName .. " [Interior ID]", thePlayer, 75, 230, 10)
			return
		end

		local theInterior, interiorID = exports.global:getInteriorFromID(interiorID, thePlayer)
		if theInterior then
			local isLinked = getElementData(theInterior, "interior:linked") or 0
			if tonumber(isLinked) and (tonumber(isLinked) ~= 0) then
				local linkedInterior = exports.data:getElement("interior", isLinked)
				local renewedLinkedInt
				if linkedInterior then
					exports.blackhawk:changeElementDataEx(linkedInterior, "interior:linked", 0)
					renewedLinkedInt = reloadInterior(isLinked)
				else
					exports.mysql:Execute("UPDATE `interiors` SET `linked_int` = '0' WHERE `id` = (?);", tonumber(isLinked))
					renewedLinkedInt = true
				end

				exports.blackhawk:changeElementDataEx(theInterior, "interior:linked", 0)
				local renewedInt = reloadInterior(interiorID)

				if renewedInt and renewedLinkedInt then
					-- Outputs & logs.
					local thePlayerName = exports.global:getStaffTitle(thePlayer)
					outputChatBox("You have unlinked interior #" .. isLinked .. " from #" .. interiorID .. ".", thePlayer, 0, 255, 0)
					exports.logs:addLog(thePlayer, 1, {renewedInt, renewedLinkedInt}, "(/unlinkint) Unlinked interiors.")
					exports.logs:addInteriorLog(interiorID, "[UNLINK] Interior unlinked from interior #" .. isLinked .. ".", thePlayer)
					exports.logs:addInteriorLog(isLinked, "[UNLINK] Interior unlinked from interior #" .. interiorID .. ".", thePlayer)
					exports.global:sendMessageToManagers("[INFO] " .. thePlayerName .. " has unlinked interior #" .. isLinked .. " from #" .. interiorID .. ".")
				else
					outputChatBox("ERROR: Something went wrong whilst unlinking the interiors.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("ERROR: Interior #" .. interiorID .. " isn't currently linked to any other interior.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("unlinkint", unlinkInteriors)

-- /setintname [Interior ID] [Name] - By Skully (29/06/18) [Trial Admin/MT]
function setInteriorName(thePlayer, commandName, interiorID, ...)
	if exports.global:isPlayerTrialAdmin(thePlayer) or exports.global:isPlayerMappingTeam(thePlayer) then
		if not interiorID or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Interior ID] [Name]", thePlayer, 75, 230, 10)
			return
		end

		local name = table.concat({...}, " ")
		if #name < 3 or #name > 35 then
			outputChatBox("ERROR: Interior name must be between 3 and 35 characters!", thePlayer, 255, 0, 0)
			return false
		end

		local theInterior, interiorID, interiorName = exports.global:getInteriorFromID(interiorID, thePlayer)
		if theInterior then
			exports.blackhawk:changeElementDataEx(theInterior, "interior:name", name)
			local renewedInterior = reloadInterior(interiorID)
			if renewedInterior then
				local thePlayerName = exports.global:getStaffTitle(thePlayer)
				outputChatBox("You have set the name of interior #" .. interiorID .. " to '" .. name .. "'.", thePlayer, 0, 255, 0)
				exports.global:sendMessage("[INFO] " .. thePlayerName .. " has adjusted the name of interior #" .. interiorID .. " to '" .. name .. "'.", 2, true)
				exports.logs:addInteriorLog(interiorID, "[SETINTNAME] Interior name changed from '" .. interiorName .. "' to '" .. name .. "'.", thePlayer)
				exports.logs:addLog(thePlayer, 1, {renewedInterior}, "(/setintname) Interior name changed from '" .. interiorName .. "' to '" .. name .. "'.")
			else
				outputChatBox("ERROR: Failed to save interior name.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("setintname", setInteriorName)

-- /setintprice [Interior ID] [Price (0-50,000,000)] - By Skully (29/06/18) [Admin/MT]
function setInteriorPrice(thePlayer, commandName, interiorID, price)
	if exports.global:isPlayerAdmin(thePlayer) or exports.global:isPlayerMappingTeam(thePlayer) then
		if not interiorID or not tonumber(price) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Interior ID] [Price]", thePlayer, 75, 230, 10)
			return
		end

		price = tonumber(price)
		if (price < 0) or (price > 50000000) then
			outputChatBox("ERROR: Please enter a valid price amount!", thePlayer, 255, 0, 0)
			return false
		end

		local theInterior, interiorID = exports.global:getInteriorFromID(interiorID, thePlayer)
		if theInterior then
			exports.blackhawk:changeElementDataEx(theInterior, "interior:price", price)
			local renewedInterior = reloadInterior(interiorID)
			if renewedInterior then
				local thePlayerName = exports.global:getStaffTitle(thePlayer)
				local formattedPrice = "$" .. exports.global:formatNumber(price)
				outputChatBox("You have set the price of interior #" .. interiorID .. " to " .. formattedPrice ..".", thePlayer, 0, 255, 0)
				exports.global:sendMessage("[INFO] " .. thePlayerName .. " has adjusted the price of interior #" .. interiorID .. " to " .. formattedPrice ..".", 2, true)
				exports.logs:addInteriorLog(interiorID, "[SETINTPRICE] Interior price changed to " .. formattedPrice ..".", thePlayer)
				exports.logs:addLog(thePlayer, 1, {renewedInterior}, "(/setintprice) Interior price changed to " .. formattedPrice ..".")
			else
				outputChatBox("ERROR: Failed to save interior price.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("setintprice", setInteriorPrice)

-- /setinttype [Interior ID] [Name] - By Skully (29/06/18) [Trial Admin/MT]
function setInteriorType(thePlayer, commandName, interiorID, intType)
	if exports.global:isPlayerTrialAdmin(thePlayer) or exports.global:isPlayerMappingTeam(thePlayer) then
		if not interiorID or not tonumber(intType) or not g_interiorTypes[tonumber(intType)] then
			outputChatBox("SYNTAX: /" .. commandName .. " [Interior ID] [Type]", thePlayer, 75, 230, 10)
			for i, inttype in ipairs(g_interiorTypes) do
				outputChatBox("  " .. i .. ": " .. inttype[1], thePlayer, 75, 230, 10)
			end
			return
		end

		intType = tonumber(intType)

		local theInterior, interiorID = exports.global:getInteriorFromID(interiorID, thePlayer)
		if theInterior then
			local oldStates = getElementData(theInterior, "interior:status")
			exports.blackhawk:changeElementDataEx(theInterior, "interior:status", {intType, oldStates[2]})
			local renewedInterior = reloadInterior(interiorID)
			if renewedInterior then
				local thePlayerName = exports.global:getStaffTitle(thePlayer)
				local intTypeName = g_interiorTypes[intType][1]
				outputChatBox("You have set interior #" .. interiorID .. "'s type to " .. intTypeName ..".", thePlayer, 0, 255, 0)
				exports.global:sendMessage("[INFO] " .. thePlayerName .. " has adjusted interior #" .. interiorID .. "'s type to " .. intTypeName ..".", 2, true)
				exports.logs:addInteriorLog(interiorID, "[SETINTTYPE] Interior type changed to " .. intTypeName ..".", thePlayer)
				exports.logs:addLog(thePlayer, 1, {renewedInterior}, "(/setinttype) Interior type changed to " .. intTypeName ..".")
			else
				outputChatBox("ERROR: Failed to save interior type.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("setinttype", setInteriorType)

-- /setintfaction [Interior ID] [Faction ID] - By Skully (07/07/18) [Helper]
function setInteriorFaction(thePlayer, commandName, interiorID, factionID)
	if exports.global:isPlayerHelper(thePlayer) then
		if not interiorID or not factionID then
			outputChatBox("SYNTAX: /" .. commandName .. " [Interior ID] [Faction ID]", thePlayer, 75, 230, 10)
			return
		end

		local theInterior, interiorID = exports.global:getInteriorFromID(interiorID, thePlayer)
		if theInterior then
			local theFaction, factionID, theFactionName = exports.global:getFactionFromID(factionID, thePlayer)
			if theFaction then
				blackhawk:changeElementDataEx(theInterior, "interior:owner", -factionID)
				blackhawk:changeElementDataEx(theInterior, "interior:ownername", theFactionName)
				saveInterior(interiorID)

				-- Outputs & logs.
				local thePlayerName = exports.global:getStaffTitle(thePlayer)
				outputChatBox("You have set interior #" .. interiorID .. " into the faction #" .. factionID .. ".", thePlayer, 0, 255, 0)
				exports.logs:addInteriorLog(interiorID, "[SET INTERIOR FACTION] Interior faction set to #" .. factionID .. ".", thePlayer)
				exports.global:sendMessageToManagers("[INFO] " .. thePlayerName .. " has set interior #" .. interiorID .. " into faction #" .. factionID .. ".")
			end
		end
	end
end
addCommandHandler("setintfaction", setInteriorFaction)
addCommandHandler("setinteriorfaction", setInteriorFaction)