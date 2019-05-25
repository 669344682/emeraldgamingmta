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

-- /vtdim - By Skully (05/04/18) [VT/Manager]
function vtDimension(thePlayer)
	if exports.global:isPlayerVehicleTeam(thePlayer) or exports.global:isPlayerManager(thePlayer) then
		local dimState = getElementData(thePlayer, "temp:vtdim")
		local thePlayerVehicle = getPedOccupiedVehicle(thePlayer)
		local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
		if not (dimState) then
			if (thePlayerVehicle) then setElementDimension(thePlayerVehicle, 22220) end
			setElementDimension(thePlayer, 22220)
			setElementData(thePlayer, "temp:vtdim", true, false)
			outputChatBox("You are now in the Vehicle Team dimension.", thePlayer, 75, 230, 10)
			exports.global:sendMessageToManagers("[INFO] " .. thePlayerName .. " has entered the Vehicle Team dimension.")
			exports.logs:addLog(thePlayer, 18, thePlayer, "Entered VT Dimension.")

		else
			if (thePlayerVehicle) then setElementDimension(thePlayerVehicle, 0) end
			setElementDimension(thePlayer, 0)
			removeElementData(thePlayer, "temp:vtdim")
			outputChatBox("You have left the Vehicle Team Dimension.", thePlayer, 75, 230, 10)
			exports.global:sendMessageToManagers("[INFO] " .. thePlayerName .. " is no longer in the Vehicle Team dimension.")
			exports.logs:addLog(thePlayer, 18, thePlayer, "Left VT Dimension.")
		end
	end
end
addCommandHandler("vtdim", vtDimension)

-- /vehicles - By Skully (08/04/18) [Trial Admin]
function showVehiclelist(thePlayer)
	if exports.global:isPlayerTrialAdmin(thePlayer) then
		local vehicleData = exports.mysql:Query("SELECT * FROM `vehicles`;")
		if (vehicleData) then

			local createdBy = {}
			local vehicleNames = {}
			local characterNames = {}

			for i, theVehicle in ipairs(vehicleData) do
				local vehCreator = exports.global:getAccountNameFromID(theVehicle.createdby)
				local _, vehName = exports.global:getVehicleModelInfo(theVehicle.model)
				local ownerName = "Unknown"
				if (theVehicle.faction ~= 0) then
					local theFaction = exports.data:getElement("team", theVehicle.faction)
					if theFaction then
						ownerName = getElementData(theFaction, "faction:abbreviation") .. " (Faction #" .. theVehicle.faction .. ")" or "Unknown"
					end
				elseif (theVehicle.owner ~= 0) then
					ownerName = exports.global:getCharacterNameFromID(theVehicle.owner)
				end
				table.insert(createdBy, vehCreator)
				table.insert(vehicleNames, vehName)
				table.insert(characterNames, ownerName)
			end

			triggerClientEvent(thePlayer, "vehicle:showvehiclelist", thePlayer, vehicleData, createdBy, vehicleNames, characterNames)
		else
			outputChatBox("ERROR: Could not retrieve all vehicles.", thePlayer, 255, 0, 0)
			exports.global:outputDebug("@showVehiclelist: Failed to fetch vehicles from database, is there an active database connection?")
			return false
		end
	end
end
addCommandHandler("vehicles", showVehiclelist)

-- This function creates vehicle, triggered by clientside /createveh GUI.
function createNewVehicle(thePlayer, vehDBID, isFaction, spawnTo, r, g, b)
	local vehicleID = exports.global:doesVehicleExist(vehDBID)
	if not (vehicleID) then
		triggerClientEvent(thePlayer, "vehicle:updatevehcrefeedbacklabel", thePlayer, "That is not a valid vehicle ID.")
		return false
	end

	if not (isFaction) then
		local availableSlots = exports.global:getVehicleSlots(spawnTo)
		if not (availableSlots) then
			local targetPlayerName = getPlayerName(spawnTo):gsub("_", " ")
			triggerClientEvent(thePlayer, "vehicle:updatevehcrefeedbacklabel", thePlayer, targetPlayerName .. " doesn't have any available vehicle slots.")
			return false
		end
	else
		local theFaction = exports.data:getElement("team", spawnTo)
		if not theFaction then
			triggerClientEvent(thePlayer, "vehicle:updatevehcrefeedbacklabel", thePlayer, "A faction with that ID doesn't exist!")
			return false
		end
		local hasSlots = exports.global:getVehicleSlots(spawnTo, true)
		if not hasSlots then
			triggerClientEvent(thePlayer, "vehicle:updatevehcrefeedbacklabel", thePlayer, "Faction #" .. spawnTo .. " doesn't have any available vehicle slots.")
			return false
		end
	end

	_createVehicle(thePlayer, vehDBID, vehicleID, isFaction, spawnTo, r, g, b, true)
end
addEvent("vehicle:createnewvehicle", true)
addEventHandler("vehicle:createnewvehicle", root, createNewVehicle)

-- /qcreateveh [Vehicle ID] - By Skully (06/04/18) [Trial Admin/VT Leader]
function quickCreateNewVehicle(thePlayer, commandName, vehicleID, isFaction, target, r, g, b)
	if exports.global:isPlayerTrialAdmin(thePlayer) or exports.global:isPlayerVehicleTeamLeader(thePlayer) then
		if not tonumber(vehicleID) or not tonumber(isFaction) or not (target) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Vehicle ID] [Faction Vehicle? (0-1)] [Faction or Player/ID] (r) (g) (b)", thePlayer, 75, 230, 10)
			return false
		end

		local vehicle = exports.global:doesVehicleExist(vehicleID)
		if not (vehicle) then
			outputChatBox("ERROR: That is not a valid vehicle ID, see a list of available vehicles with /vehlist.", thePlayer, 255, 0, 0)
			return false
		end

		isFaction = tonumber(isFaction)
		if (isFaction < 0) or (isFaction > 1) then
			outputChatBox("ERROR: Please specify if the vehicle will be a faction vehicle or not. (0 Meaning no, 1 meaning yes.)", thePlayer, 255, 0, 0)
			return false
		end

		if (isFaction == 0) then
			isFaction = false
			local targetPlayer = exports.global:getPlayerFromPartialNameOrID(target, thePlayer)

			if (targetPlayer) then
				target = targetPlayer
				local availableSlots = exports.global:getVehicleSlots(targetPlayer)

				if not (availableSlots) then
					local targetPlayerName = getPlayerName(targetPlayer):gsub("_", " ")
					outputChatBox("ERROR: " .. targetPlayerName .. " doesn't have any available vehicle slots.", thePlayer, 255, 0, 0)
					return false
				end
			else
				return
			end
		elseif (isFaction == 1) then -- If creating to faction.
			isFaction = true
			local theFaction = exports.global:getFactionFromID(target, thePlayer)
			if not theFaction then return false end

			local hasSlots = exports.global:getVehicleSlots(target, true)
			if not hasSlots then
				outputChatBox("ERROR: Faction #" .. target .. " doesn't have any available vehicle slots!", thePlayer, 255, 0, 0)
				return false
			end
			target = theFaction
		end

		_createVehicle(thePlayer, vehicleID, vehicle, isFaction, target, r, g, b)
	end
end
addCommandHandler("qcreateveh", quickCreateNewVehicle)

function _createVehicle(thePlayer, vehDBID, vehicleID, isFaction, target, r, g, b, fromGUI)

	-- Parse colours and make sure each colour values are valid.
	if not tonumber(r) then r = 0 end
	if not tonumber(g) then g = 0 end
	if not tonumber(b) then b = 0 end

	r = tonumber(r); g = tonumber(g); b = tonumber(b)
	if (r) < 0 or (r) > 255 then r = 0 end
	if (g) < 0 or (g) > 255 then g = 0 end
	if (b) < 0 or (b) > 255 then b = 0 end

	local x, y, z = getElementPosition(thePlayer)
	local rx, ry, rz = getElementRotation(thePlayer)
	local dimension = getElementDimension(thePlayer)
	local interior = getElementInterior(thePlayer)
	local randomPlates = exports.global:generateNumberPlate()
	if isPlatelessVehicle(vehicleID) then randomPlates = "No Plates" end

	-- Calculate vehicle spawn location and spawn.
	x = x + ((math.cos(math.rad(rz))) * 3)
	y = y + ((math.sin(math.rad(rz))) * 3)

	-- Create the vehicle.
	local theVehicle = createVehicle(vehicleID, x, y, z, 0, 0, rz, randomPlates)

	if (theVehicle) then
		setVehicleColor(theVehicle, r, g, b, r, g, b)
		setElementDimension(theVehicle, dimension)
		setElementInterior(theVehicle, interior)

		local locationString = x .. "," .. y .. "," .. z .. ",0,0," .. rz
		local col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12 = getVehicleColor(theVehicle, true)
		local colorTable = toJSON({col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12})
		
		local faction, owner
		if (isFaction) then
			faction = getElementData(target, "faction:id")
			owner = 0
		else
			faction = 0
			owner = getElementData(target, "character:id")
		end

		local timeNow = exports.global:getCurrentTime()
		local creator = getElementData(thePlayer, "account:id")

		-- Get the lowest available vehicle ID.
		local nextID = exports.mysql:QueryString("SELECT MIN(e1.id+1) AS dbid FROM `vehicles` AS e1 LEFT JOIN `vehicles` AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL")
		nextID = tonumber(nextID) or 1
		
		local query = exports.mysql:Execute("INSERT INTO `vehicles` (`id`, `model`, `location`, `dimension`, `interior`, `fuel`, `engine`, `locked`, `lights`, `siren`, `hp`, `color`, `plates`, `faction`, `owner`, `windows`, `windows_tinted`, `broken_engine`, `items`, `impounded`, `handbrake`, `upgrades`, `wheelStates`, `panelStates`, `doorStates`, `headlightStates`, `odometer`, `variants`, `description`, `deleted`, `state`, `created_date`, `createdby`, `last_used`, `registered`, `show_plates`, `show_vin`, `damageproof`, `textures`, `job`, `handling`, `faction_perms`) VALUES ((?), (?), (?), (?), (?), '100', '0', '0', '0', '0', '1000', (?), (?), (?), (?), '0', '0', '0', '', '0', '0', '[ [ 255, 255, 255, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 1, 0 ] ]', 0, '0,0', '[ [ ] ]', '0', '0,0', (?), (?), (?), '0', '1', '1', '0', '[ [ ] ]', '0', NULL, '[ [ ] ]');", nextID, vehDBID, locationString, dimension, interior, colorTable, randomPlates, faction, owner, timeNow[3], creator, timeNow[3])
		if (query) then
			-- Allocate the vehicle into data.
			exports.data:allocateElement(theVehicle, nextID)

			-- Begin setting vehicle element data.
			exports.blackhawk:setElementDataEx(theVehicle, "vehicle:id", nextID, true)
			if (isFaction) then
				exports.blackhawk:setElementDataEx(theVehicle, "vehicle:owner", -faction, true)
			else
				exports.blackhawk:setElementDataEx(theVehicle, "vehicle:owner", owner, true)
			end

			exports.blackhawk:setElementDataEx(theVehicle, "vehicle:vehid", vehDBID, true)
			exports.blackhawk:setElementDataEx(theVehicle, "vehicle:engine", true, true)
			exports.blackhawk:setElementDataEx(theVehicle, "vehicle:windows", 0, true)
			exports.blackhawk:setElementDataEx(theVehicle, "vehicle:windowtint", 0, true)
			exports.blackhawk:setElementDataEx(theVehicle, "vehicle:brokenengine", 0, true)
			exports.blackhawk:setElementDataEx(theVehicle, "vehicle:impounded", 0, true)
			exports.blackhawk:setElementDataEx(theVehicle, "vehicle:handbrake", 0, true)
			exports.blackhawk:setElementDataEx(theVehicle, "vehicle:states", "0,0", true)
			exports.blackhawk:setElementDataEx(theVehicle, "vehicle:showplates", 1, true)
			exports.blackhawk:setElementDataEx(theVehicle, "vehicle:job", 0, true)
			exports.blackhawk:setElementDataEx(theVehicle, "vehicle:showvin", 1, true)
			exports.blackhawk:setElementDataEx(theVehicle, "vehicle:dimension", dimension, true)
			exports.blackhawk:setElementDataEx(theVehicle, "vehicle:interior", interior, true)
			exports.blackhawk:setElementDataEx(theVehicle, "vehicle:lights", 0, true)
			exports.blackhawk:setElementDataEx(theVehicle, "vehicle:description", {}, true)
			exports.blackhawk:setElementDataEx(theVehicle, "vehicle:factionperms", "[ [ ] ]", true)
			exports.blackhawk:setElementDataEx(theVehicle, "vehicle:respawnpos", {x, y, z, rx, ry, rz}, true)
			setElementData(theVehicle, "vehicle:mileage", math.random(1000, 3000), true)

			local vehicleTable, vehicleName = exports.global:getVehicleModelInfo(vehDBID)
			exports.blackhawk:setElementDataEx(theVehicle, "vehicle:type", vehicleTable.type)

			-- Output success messages.
			local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
			local targetName = "Unknown"
			if (isFaction) then
				targetName = getTeamName(target)
			else
				targetName = getPlayerName(target):gsub("_", " ")
			end

			outputChatBox("You have created a " .. vehicleName .. " for " .. targetName .. " [ID: " .. nextID .. "].", thePlayer, 255, 0, 0)
			if not (isFaction) then -- If created for a player, notify the player.
				outputChatBox(thePlayerName .. " has created a " .. vehicleName .. " [ID: " .. nextID .. "] for you.", target, 75, 230, 10)
			end
			exports.global:sendMessage("[INFO] " .. thePlayerName .. " has created a " .. vehicleName .. " for " .. targetName .. " [ID: " .. nextID .. "].", 2, true)
			exports.global:sendMessageToManagers("[INFO] " .. thePlayerName .. " has created a " .. vehicleName .. " for " .. targetName .. " [ID: " .. nextID .. "].", true)
			exports.logs:addLog(thePlayer, 1, {thePlayer, target, theVehicle}, "Created vehicle '" .. vehicleName .. "' for " .. targetName .. " [ID: " .. nextID .. "].")
			exports.logs:addVehicleLog(nextID, "[CREATEVEH] VEHICLE CREATED - (".. vehDBID .. ") " .. vehicleName, thePlayer)
			-- Close the GUI for /createveh.
			if (fromGUI) then triggerClientEvent(thePlayer, "vehicle:closecreatevehgui", thePlayer) end

			-- Reload the vehicle to apply final changes.
			triggerEvent("vehicle:reloadvehcall", thePlayer, thePlayer, "gui", nextID)
			return true
		end
	end

	-- If this is reached, then the vehicle failed to create.
	if (fromGUI) then
		triggerClientEvent(thePlayer, "vehicle:updatevehcrefeedbacklabel", thePlayer, "Failed to create vehicle!")
	else
		outputChatBox("ERROR: Failed to create vehicle!", thePlayer, 255, 0, 0)
	end
	exports.global:outputDebug("@_createVehicle: Failed to create vehicle, vehicle element couldn't be created or failed to save to database.")
	return false
end

-- /delveh [Vehicle ID] - By Skully (06/04/18) [Trial Admin]
function deleteVehicle(thePlayer, commandName, vehicleID)
	if exports.global:isPlayerTrialAdmin(thePlayer) then
		if not (vehicleID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Vehicle ID]", thePlayer, 75, 230, 10)
			return false
		end

		local isVehicle = exports.mysql:QueryString("SELECT `deleted` FROM `vehicles` WHERE `id` = (?);", tonumber(vehicleID))
		if not (isVehicle) then
			outputChatBox("ERROR: That vehicle does not exist!", thePlayer, 255, 0, 0)
			return false
		end

		local isDeleting = getElementData(thePlayer, "temp:isdeletingveh")
		vehicleID = tonumber(vehicleID)

		if (tonumber(isVehicle) ~= 0) then -- If the vehicle is not deleted.
			outputChatBox("ERROR: That vehicle is already deleted!", thePlayer, 255, 0, 0)
			return false
		end

		local theVehicle, vehicleID = exports.global:getVehicleFromID(vehicleID, thePlayer)
		if not (theVehicle) then return false end

		local ownerID = getElementData(theVehicle, "vehicle:owner")
		local ownerName = "Unknown"
		if (tonumber(ownerID) < 0) then -- If the owner is a faction.
			local theFaction = exports.data:getElement("team", -ownerID)
			if theFaction then
				ownerName = getTeamName(theFaction) or "Unknown"
			end
		else
			local _, accountName = exports.global:getCharacterAccount(ownerID)
			ownerName = exports.mysql:QueryString("SELECT `name` FROM `characters` WHERE `id` = (?);", ownerID) or "Unknown"
			ownerName = ownerName:gsub("_", " ")
			ownerName = ownerName .. " (" .. accountName .. ")"
		end

		local vehDBID = getElementData(theVehicle, "vehicle:vehid")
		local _, vehName = exports.global:getVehicleModelInfo(vehDBID)

		if not (isDeleting) or (isDeleting ~= vehicleID) then
			if not (commandName == "ui") then
				outputChatBox("[Vehicle ID #" .. vehicleID .. "] " .. vehName .. " - Owner: " .. ownerName, thePlayer, 255, 255, 0)
				outputChatBox("[Vehicle ID #" .. vehicleID .. "] Are you sure you would like to delete this vehicle? Type /delveh " .. vehicleID .. " again to confirm deletion.", thePlayer, 255, 255, 0)
			end
			setElementData(thePlayer, "temp:isdeletingveh", vehicleID)
			return true
		elseif (isDeleting == vehicleID) then
			removeElementData(thePlayer, "temp:isdeletingveh")

			local query = exports.mysql:Execute("UPDATE `vehicles` SET `deleted` = '1' WHERE `id` = (?);", tonumber(vehicleID))
			if (query) then
				outputChatBox("You have deleted vehicle #" .. vehicleID .. ".", thePlayer, 255, 0, 0)
				local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
				exports.global:sendMessage("[INFO] " .. thePlayerName .. " has deleted a " .. vehName .. " [ID: " .. vehicleID .. "] - Owner: " .. ownerName, 2, true)
				exports.global:sendMessageToManagers("[WARN] " .. thePlayerName .. " has deleted a " .. vehName .. " [ID: " .. vehicleID .. "] - Owner: " .. ownerName)
				exports.logs:addLog(thePlayer, 1, {thePlayer, theVehicle}, thePlayerName .. " has deleted a " .. vehName .. " [ID: " .. vehicleID .. "] - Owner: " .. ownerName)
				exports.logs:addVehicleLog(vehicleID, "[DELVEH] VEHICLE DELETED - " .. vehName, thePlayer)
				destroyElement(theVehicle) -- Delete the element after the logs have been submit.
			else
				outputChatBox("ERROR: Failed to delete vehicle!", thePlayer, 255, 0, 0)
				exports.global:outputDebug("@deleteVehicle: Failed to delete vehicle ID " .. vehicleID .. ", is there an active database connection?")
				return false
			end
		end
	end
end
addCommandHandler("delveh", deleteVehicle)
addEvent("vehicle:deletevehiclecall", true) -- Used by /vehicles GUI.
addEventHandler("vehicle:deletevehiclecall", root, deleteVehicle)

-- /removeveh [Vehicle ID] - By Skully (06/04/18) [Manager]
function removeVehicle(thePlayer, commandName, vehicleID)
	if exports.global:isPlayerManager(thePlayer) then
		if not (vehicleID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Vehicle ID]", thePlayer, 75, 230, 10)
			return false
		end

		local isDeleted = exports.mysql:QueryString("SELECT `deleted` FROM `vehicles` WHERE `id` = (?);", tonumber(vehicleID))
		if not (isDeleted) then
			outputChatBox("ERROR: That vehicle does not exist!", thePlayer, 255, 0, 0)
			return false
		end

		if (tonumber(isDeleted) ~= 1) then -- If the vehicle is not deleted.
			outputChatBox("ERROR: That vehicle is not currently deleted, use '/delveh " .. vehicleID .. "' first.", thePlayer, 255, 0, 0)
			return false
		end

		local isRemoving = getElementData(thePlayer, "temp:isremovingveh")
		vehicleID = tonumber(vehicleID)

		-- If the vehicle element still exists somehow, we can remove it.
		local theVehicle = exports.data:getElement("vehicle", vehicleID)
		if (theVehicle) then destroyElement(theVehicle) end

		if not (isRemoving) or (isRemoving ~= vehicleID) then
			outputChatBox("[Vehicle ID #" .. vehicleID .. "] WARNING: You are about to permanently delete this vehicle and it can no longer be restored.", thePlayer, 255, 0, 0)
			outputChatBox("[Vehicle ID #" .. vehicleID .. "] Type /" .. commandName .." " .. vehicleID .. " again to confirm deletion.", thePlayer, 255, 0, 0)
			setElementData(thePlayer, "temp:isremovingveh", vehicleID)
			return true
		elseif (isRemoving == vehicleID) then
			removeElementData(thePlayer, "temp:isremovingveh")

			local query = exports.mysql:Execute("DELETE FROM `vehicles` WHERE `id` = (?);", tonumber(vehicleID))
			if (query) then
				-- Delete all logs associated with the vehicle.
				exports.mysql:Execute("DELETE FROM `vehicle_logs` WHERE `vehid` = (?);", tonumber(vehicleID))

				-- Outputs.
				outputChatBox("You have removed vehicle #" .. vehicleID .. " from the database.", thePlayer, 0, 255, 0)
				local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
				exports.global:sendMessage("[INFO] " .. thePlayerName .. " has removed vehicle #" .. vehicleID .. " from the database.", 2, true)
				exports.logs:addLog(thePlayer, 1, {thePlayer, "VEH" .. vehicleID}, thePlayerName .. " has removed vehicle #" .. vehicleID .. " from the database.")

			else
				outputChatBox("ERROR: Failed to remove the vehicle!", thePlayer, 255, 0, 0)
				exports.global:outputDebug("@removeVehicle: Failed to remove vehicle ID " .. vehicleID .. ", is there an active database connection?")
				return false
			end
		end
	end
end
addCommandHandler("removeveh", removeVehicle)
addEvent("vehicle:removevehiclecall", true) -- Used by /vehicles GUI.
addEventHandler("vehicle:removevehiclecall", root, removeVehicle)

-- /restoreveh [Vehicle ID] - By Skully (06/04/18) [Trial Admin]
function restoreVehicle(thePlayer, commandName, vehicleID)
	if exports.global:isPlayerTrialAdmin(thePlayer) then
		if not (vehicleID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Vehicle ID]", thePlayer, 75, 230, 10)
			return false
		end

		local vehicleData = exports.mysql:QuerySingle("SELECT `model`, `deleted`, `faction`, `owner` FROM `vehicles` WHERE `id` = (?);", tonumber(vehicleID))
		if not (vehicleData) then
			outputChatBox("ERROR: That vehicle does not exist!", thePlayer, 255, 0, 0)
			return false
		end

		if (vehicleData.deleted ~= 1) then -- If the vehicle is not deleted.
			outputChatBox("ERROR: That vehicle is not currently deleted!", thePlayer, 255, 0, 0)
			return false
		end

		local isRestoring = getElementData(thePlayer, "temp:isrestoringveh")
		vehicleID = tonumber(vehicleID)

		local ownerName = "Unknown"
		if (vehicleData.faction > 0) and (vehicleData.owner == 0) then -- If the owner is a faction.
			local theFaction = exports.data:getElement("team", vehicleData.owner)
			if theFaction then
				ownerName = getTeamName(theFaction) or "Unknown"
			else
				outputChatBox("[Vehicle ID #" .. vehicleID .. "] The faction this vehicle belonged to no longer exists, vehicle will be restored to you.", thePlayer, 255, 255, 0)
			end
		elseif (vehicleData.faction == 0) and (vehicleData.owner > 0) then -- If vehicle is player owned.
			local _, accountName = exports.global:getCharacterAccount(vehicleData.owner)
			ownerName = exports.global:getCharacterNameFromID(vehicleData.owner) or "Unknown"
			ownerName = ownerName:gsub("_", " ")
			ownerName = ownerName .. " (" .. accountName .. ")"
		end

		local _, vehName = exports.global:getVehicleModelInfo(vehicleData.model)

		if not (isRestoring) or (isRestoring ~= vehicleID) then
			if not (commandName == "ui") then
				outputChatBox("[Vehicle ID #" .. vehicleID .. "] " .. vehName .. " - Owner: " .. ownerName, thePlayer, 255, 255, 0)
				outputChatBox("[Vehicle ID #" .. vehicleID .. "] Type /" .. commandName .." " .. vehicleID .. " again to confirm you want to restore the vehicle.", thePlayer, 255, 255, 0)
			end
			setElementData(thePlayer, "temp:isrestoringveh", vehicleID)
			return true
		elseif (isRestoring == vehicleID) then
			removeElementData(thePlayer, "temp:isrestoringveh")

			-- Check if the owner of the vehicle has enough slots.
			local hasSlots = exports.global:getVehicleSlots(vehicleData.owner)
			if not (hasSlots) then
				outputChatBox("ERROR: " .. ownerName .. " doesn't have enough vehicle slots to reclaim the vehicle!", thePlayer, 255, 0, 0)
				return false
			end

			-- Attempt to load the vehicle.
			local theVehicle = loadVehicle(vehicleID)
			if not (theVehicle) then -- This may occur if the vehicle was previously deleted with outdated information or an old model.
				outputChatBox("ERROR: Something went wrong whilst restoring the vehicle.", thePlayer, 255, 0, 0)
				return false
			end

			-- Update database.
			local query = exports.mysql:Execute("UPDATE `vehicles` SET `deleted` = '0' WHERE `id` = (?);", tonumber(vehicleID))
			if (query) then
				local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
				
				outputChatBox("You have restored vehicle #" .. vehicleID .. " from the database.", thePlayer, 0, 255, 0)
				exports.global:sendMessage("[INFO] " .. thePlayerName .. " has restored vehicle #" .. vehicleID .. " to " .. ownerName .. ".", 2, true)
				exports.logs:addLog(thePlayer, 1, {thePlayer, "VEH" .. vehicleID}, thePlayerName .. " has restored vehicle #" .. vehicleID .. " to " .. ownerName .. ".")
				exports.logs:addVehicleLog(vehicleID, "[RESTOREVEH] VEHICLE RESTORED TO: " .. ownerName, thePlayer)
			else
				outputChatBox("ERROR: Failed to restore the vehicle!", thePlayer, 255, 0, 0)
				exports.global:outputDebug("@restoreVehicle: Failed to restore vehicle ID " .. vehicleID .. ", is there an active database connection?")
				return false
			end
		end
	end
end
addCommandHandler("restoreveh", restoreVehicle)
addEvent("vehicle:restorevehiclecall", true) -- Used by /vehicles GUI.
addEventHandler("vehicle:restorevehiclecall", root, restoreVehicle)

-- /reloadveh [Vehicle ID] - By Skully (08/04/18) [Trial Admin]
function reloadVehicleCmd(thePlayer, commandName, vehicleID)
	if exports.global:isPlayerTrialAdmin(thePlayer) then
		if not (vehicleID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Vehicle ID]", thePlayer, 75, 230, 10)
			return false
		end

		local loaded, reason = reloadVehicle(vehicleID)
		if not (reason) then reason = "Failed to reload vehicle." end
		if isElement(loaded) then
			if not (commandName == "gui") then
				outputChatBox("You have reloaded vehicle #" .. vehicleID .. ".", thePlayer, 0, 255, 0)
				exports.logs:addLog(thePlayer, 1, {thePlayer, "VEH"..vehicleID}, "Reloaded vehicle.")
				exports.logs:addVehicleLog(vehicleID, "[RELOADVEH] RELOADED VEHICLE", thePlayer)
			end
		else
			outputChatBox("ERROR: " .. reason, thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("reloadveh", reloadVehicleCmd)
addEvent("vehicle:reloadvehcall", true) -- Used by /editveh GUI.
addEventHandler("vehicle:reloadvehcall", root, reloadVehicleCmd)

-- /respawnveh [Vehicle ID] - By Skully (09/04/18) [Helper]
function respawnTheVehicle(thePlayer, commandName, vehicleID)
	if exports.global:isPlayerHelper(thePlayer) then
		if not (vehicleID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Vehicle ID]", thePlayer, 75, 230, 10)
			return false
		end

		-- Check to see if the vehicle exists.
		local theVehicle, vehicleID = exports.global:getVehicleFromID(vehicleID, thePlayer)
		if theVehicle then
			local x, y, z, rx, ry, rz = unpack(getElementData(theVehicle, "vehicle:respawnpos"))
			if not (x) or not (y) or not (z) then
				outputChatBox("ERROR: Failed to respawn vehicle, no /park location found.", thePlayer, 255, 0, 0)
				return false
			end

			if isVehicleBlown(theVehicle) then
				fixVehicle(theVehicle)
				for i = 0, 5 do
					setVehicleDoorState(theVehicle, i, 4) -- Damage the vehicle.
				end
				setElementHealth(theVehicle, 300) -- Damage HP.
				setElementData(theVehicle, "vehicle:brokenengine", 1)
			end

			local vehicleDim = getElementData(theVehicle, "vehicle:dimension") or 0
			local vehicleInt = getElementData(theVehicle, "vehicle:interior") or 0
			local vehOccupants = getVehicleOccupants(theVehicle)

			local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
			if (vehOccupants) then -- Keep vehicle occupants inside the vehicle when it respawns.
				for seat, occupant in pairs (vehOccupants) do
					setElementInterior(occupant, vehicleInt)
					setElementDimension(occupant, vehicleDim)
					outputChatBox(thePlayerName .. " has respawned the vehicle you're in.", occupant, 75, 230, 10)
				end
			end

			setElementInterior(theVehicle, vehicleInt)
			setElementDimension(theVehicle, vehicleDim)
			setElementRotation(theVehicle, rx, ry, rz)
			setElementPosition(theVehicle, x, y, z, true)
			saveVehicle(vehicleID)

			outputChatBox("You have respawned vehicle #" .. vehicleID .. ".", thePlayer, 0, 255, 0)
			exports.global:sendMessageToManagers("[INFO] " .. thePlayerName .. " has respawned vehicle #" .. vehicleID .. ".")
			exports.logs:addLog(thePlayer, 1, {thePlayer, theVehicle}, "Respawned vehicle.")
			exports.logs:addVehicleLog(vehicleID, "[RESPAWNVEH] Vehicle respawned.", thePlayer)
		end
	end
end
addCommandHandler("respawnveh", respawnTheVehicle)
addCommandHandler("respawnvehicle", respawnTheVehicle)
addEvent("vehicle:respawnvehcall", true) -- Used by /checkveh GUI.
addEventHandler("vehicle:respawnvehcall", root, respawnTheVehicle)

-- /gotoveh [Vehicle ID] - By Skully (08/04/18) [Helper/VT]
function gotoVehicle(thePlayer, commandName, vehicleID)
	if exports.global:isPlayerHelper(thePlayer) or exports.global:isPlayerVehicleTeam(thePlayer) then
		if not tonumber(vehicleID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Vehicle ID]", thePlayer, 75, 230, 10)
			return false
		end

		vehicleID = tonumber(vehicleID)
		
		-- Check to see if the vehicle exists.
		local theVehicle, vehicleID = exports.global:getVehicleFromID(vehicleID, thePlayer)
		if not (theVehicle) then return false end

		local x, y, z = getElementPosition(theVehicle)
		local rx, ry, rz = getElementRotation(theVehicle)
		local theVehicleDimension = getElementDimension(theVehicle)
		local theVehicleInterior = getElementInterior(theVehicle)
		x = x + ((math.cos(math.rad(rz))) * 5)
		y = y + ((math.sin(math.rad(rz))) * 5)

		local teleported, affectedElements = exports.global:elementEnterInterior(thePlayer, {x, y, z}, {0, 0, rz}, theVehicleDimension, theVehicleInterior, true, true)

		if teleported then
			outputChatBox("You have teleported to vehicle #" .. vehicleID .. ".", thePlayer, 0, 255, 0)
			local charName = getPlayerName(thePlayer):gsub("_", " ")
			exports.logs:addLog(thePlayer, 1, affectedElements, "(/gotoveh) Teleported to vehicle.")
			exports.logs:addVehicleLog(vehicleID, "[GOTOVEH] " .. charName .. " teleported to vehicle.", thePlayer)
		end
	end
end
addCommandHandler("gotoveh", gotoVehicle)
addCommandHandler("gotovehicle", gotoVehicle)
addCommandHandler("gotocar", gotoVehicle)
addEvent("vehicle:gotovehcall", true) -- Used by /checkveh GUI.
addEventHandler("vehicle:gotovehcall", root, gotoVehicle)

-- /getveh [Vehicle ID] - By Skully (08/04/18) [Helper/VT]
function getVehicle(thePlayer, commandName, vehicleID)
	if exports.global:isPlayerHelper(thePlayer) or exports.global:isPlayerVehicleTeam(thePlayer) then
		if not (vehicleID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Vehicle ID]", thePlayer, 75, 230, 10)
			return false
		end

		vehicleID = tonumber(vehicleID)

		-- Check to see if the vehicle exists.
		local theVehicle, vehicleID = exports.global:getVehicleFromID(vehicleID, thePlayer)
		if not (theVehicle) then return false end

		local x, y, z = getElementPosition(thePlayer)
		local rx, ry, rz = getElementRotation(thePlayer)
		local thePlayerDimension = getElementDimension(thePlayer)
		local thePlayerInterior = getElementInterior(thePlayer)
		x = x + ((math.cos(math.rad(rz))) * 3)
		y = y + ((math.sin(math.rad(rz))) * 3)

		if (getElementHealth(theVehicle) == 0) then
			spawnVehicle(theVehicle, x, y, z, 0, 0, rz)
		end
			
		local teleported, affectedElements = exports.global:elementEnterInterior(theVehicle, {x, y, z}, {0, 0, rz}, thePlayerDimension, thePlayerInterior, true, true)
		if teleported then
			outputChatBox("You have teleported vehicle #" .. vehicleID .. " to you.", thePlayer, 0, 255, 0)
			local charName = getPlayerName(thePlayer):gsub("_", " ")
			exports.logs:addLog(thePlayer, 1, affectedElements, "(/getveh) Teleported vehicle to them.")
			exports.logs:addVehicleLog(vehicleID, "[GETVEH] " .. charName .. " teleported vehicle to them.", thePlayer)
		end
	end
end
addCommandHandler("getveh", getVehicle)
addCommandHandler("getvehicle", getVehicle)
addCommandHandler("getcar", getVehicle)
addEvent("vehicle:getvehcall", true) -- Used by /checkveh GUI.
addEventHandler("vehicle:getvehcall", root, getVehicle)

-- /sendtoveh [Player/ID] [Vehicle ID] - By Skully (08/04/18) [Helper]
function sendToVehicle(thePlayer, commandName, targetPlayer, vehicleID)
	if exports.global:isPlayerHelper(thePlayer) then
		if not (targetPlayer) or not (vehicleID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player/ID] [Vehicle ID]", thePlayer, 75, 230, 10)
			return false
		end

		local targetPlayer, targetPlayerName = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)
		if (targetPlayer) then
			vehicleID = tonumber(vehicleID)

			-- Check to see if the vehicle exists.
			local theVehicle, vehicleID = exports.global:getVehicleFromID(vehicleID, thePlayer)
			if not (theVehicle) then return false end

			local x, y, z = getElementPosition(theVehicle)
			local rx, ry, rz = getElementRotation(theVehicle)
			local theVehicleDimension = getElementDimension(theVehicle)
			local theVehicleInterior = getElementInterior(theVehicle)
			x = x + ((math.cos(math.rad(rz))) * 5)
			y = y + ((math.sin(math.rad(rz))) * 5)

			local targetPlayerVehicle = getPedOccupiedVehicle(targetPlayer)
			if (targetPlayerVehicle) then
				setElementPosition(targetPlayerVehicle, x, y, z, true)
				setElementRotation(targetPlayerVehicle, 0, 0, rz)
				setElementDimension(targetPlayerVehicle, theVehicleDimension)
				setElementInterior(targetPlayerVehicle, theVehicleInterior)
			end

			setElementPosition(targetPlayer, x, y, z, true)
			setElementRotation(targetPlayer, 0, 0, rz)
			setElementDimension(targetPlayer, theVehicleDimension)
			setElementInterior(targetPlayer, theVehicleInterior)

			-- Outputs.
			local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
			outputChatBox("You have teleported " .. targetPlayerName .. " to vehicle #" .. vehicleID .. ".", thePlayer, 0, 255, 0)
			outputChatBox(thePlayerName .. " has teleported you to vehicle #".. vehicleID .. ".", targetPlayer, 75, 230, 10)
			exports.logs:addLog(thePlayer, 1, {targetPlayer, theVehicle}, "Sent " .. targetPlayerName .. " to vehicle.")
			exports.logs:addVehicleLog(vehicleID, "[SENDTOVEH] " .. thePlayerName .. " sent " .. targetPlayerName .. " to  the vehicle.", thePlayer)
		end
	end
end
addCommandHandler("sendtoveh", sendToVehicle)
addCommandHandler("sendtovehicle", sendToVehicle)

-- /sendvehto [Vehicle ID] [Player/ID] - By Skully (08/04/18) [Helper]
function sendVehicleTo(thePlayer, commandName, vehicleID, targetPlayer)
	if exports.global:isPlayerHelper(thePlayer) then
		if not (targetPlayer) or not (vehicleID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Vehicle ID] [Player/ID]", thePlayer, 75, 230, 10)
			return false
		end

		local targetPlayer, targetPlayerName = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)
		if (targetPlayer) then
			vehicleID = tonumber(vehicleID)

			-- Check to see if the vehicle exists.
			local theVehicle, vehicleID = exports.global:getVehicleFromID(vehicleID, thePlayer)
			if not (theVehicle) then return false end

			local x, y, z = getElementPosition(targetPlayer)
			local rx, ry, rz = getElementRotation(targetPlayer)
			local targetPlayerDimension = getElementDimension(targetPlayer)
			local targetPlayerInterior = getElementInterior(targetPlayer)
			x = x + ((math.cos(math.rad(rz))) * 3)
			y = y + ((math.sin(math.rad(rz))) * 3)

			if (getElementHealth(theVehicle) == 0) then
				spawnVehicle(theVehicle, x, y, z, 0, 0, rz)
			else
				setElementPosition(theVehicle, x, y, z, true)
				setElementRotation(theVehicle, 0, 0, rz)
			end

			setElementDimension(theVehicle, targetPlayerDimension)
			setElementInterior(theVehicle, targetPlayerInterior)

			-- Outputs.
			local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
			outputChatBox("You have teleported vehicle #" .. vehicleID .. " to " .. targetPlayerName .. ".", thePlayer, 0, 255, 0)
			outputChatBox(thePlayerName .. " has teleported vehicle #" .. vehicleID .. " to you.", targetPlayer, 75, 230, 10)
			exports.logs:addLog(thePlayer, 1, {targetPlayer, theVehicle}, "Sent vehicle to " .. targetPlayerName .. ".")
			exports.logs:addVehicleLog(vehicleID, "[SENDVEHTO] " .. thePlayerName .. " sent vehicle to " .. targetPlayerName .. ".", thePlayer)
		end
	end
end
addCommandHandler("sendvehto", sendVehicleTo)
addCommandHandler("sendvehicleto", sendVehicleTo)

-- /getvehid [Vehicle ID] - By Skully (08/04/18) [Trial Admin/VT]
function getVehicleModelID(thePlayer, commandName, vehicleID)
	if exports.global:isPlayerTrialAdmin(thePlayer) or exports.global:isPlayerVehicleTeam(thePlayer) then
		local theVehicle = getPedOccupiedVehicle(thePlayer)

		if not (vehicleID) and not (theVehicle) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Vehicle ID]", thePlayer, 75, 230, 10)
			return false
		end

		if not (vehicleID) then
			vehicleID = getElementData(theVehicle, "vehicle:id")
		else
			vehicleExists = exports.data:getElement("vehicle", tonumber(vehicleID))
			if not (vehicleExists) then
				outputChatBox("ERROR: A vehicle with the ID #" .. vehicleID .. " does not exist!", thePlayer, 255, 0, 0)
				return false
			end
		end

		local vehModelID = exports.mysql:QueryString("SELECT `model` FROM `vehicles` WHERE `id` = (?);", tonumber(vehicleID))
		if not (vehModelID) then
			outputChatBox("ERROR: Failed to retrieve the vehicle's model ID.", thePlayer, 255, 0, 0)
			exports.global:outputDebug("@getVehicleModelID: Failed to fetch `model` of existing vehicle, is there an active database connection?")
			return false
		end

		local vehicleInfo, vehicleName = exports.global:getVehicleModelInfo(vehModelID)

		outputChatBox("[Vehicle #" .. vehicleID .. "] " .. vehicleName, thePlayer, 75, 230, 10)
		outputChatBox("[Vehicle #" .. vehicleID .. "] Vehicle library ID: " .. vehModelID, thePlayer, 75, 230, 10)
	end
end
addCommandHandler("getvehid", getVehicleModelID)

function _warpPedIntoVehicle(thePlayer, theVehicle, seatID)
	local oldDimension = getElementDimension(thePlayer)
	local oldInterior = getElementInterior(thePlayer)

	setElementDimension(thePlayer, getElementDimension(theVehicle))
	setElementInterior(thePlayer, getElementInterior(theVehicle))
	if warpPedIntoVehicle(thePlayer, theVehicle, seatID) then
		setCameraTarget(thePlayer, thePlayer)
		exports.blackhawk:setElementDataEx(thePlayer, "character:invehicle", true, true)
		return true
	else
		setElementDimension(thePlayer, oldDimension)
		setElementInterior(thePlayer, oldInterior)
	end
	return false
end

-- /enterveh [Player/ID] [Vehicle ID] (Seat) - By Skully (08/04/18) [Helper]
function enterPlayerVehicle(thePlayer, commandName, targetPlayer, vehicleID, seatID)
	if exports.global:isPlayerHelper(thePlayer) then
		if not (targetPlayer) or not (vehicleID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player/ID] [Vehicle ID] (Seat (0-3))", thePlayer, 75, 230, 10)
			return false
		end

		local targetPlayer, targetPlayerName = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)
		if (targetPlayer) then
			-- Check to see if the vehicle exists.
			local theVehicle, vehicleID = exports.global:getVehicleFromID(vehicleID, thePlayer)
			if not (theVehicle) then return false end

			local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
			if tonumber(seatID) and (tonumber(seatID) >= 0) and (tonumber(seatID) < 4) then
				seatID = tonumber(seatID)
				local seatOccupant = getVehicleOccupant(theVehicle, seatID)
				if (seatOccupant) then
					removePedFromVehicle(seatOccupant)
					outputChatBox(thePlayerName .. " has put themself into your seat add removed you from the vehicle.", thePlayer, 255, 0, 0)
				end

				if _warpPedIntoVehicle(targetPlayer, theVehicle, seatID) then
					exports.logs:addVehicleLog(vehicleID, "[ENTERVEH] Placed " .. targetPlayerName .. " into seat " .. seatID .. ".", thePlayer)
					exports.logs:addLog(thePlayer, 1, {targetPlayer, theVehicle}, "Placed into vehicle seat " .. seatID .. ".")
					if (thePlayer ~= targetPlayer) then
						outputChatBox("You have teleported " .. targetPlayerName .. " into vehicle #" .. vehicleID .. " and into seat " .. seatID .. ".", thePlayer, 0, 255, 0)
						outputChatBox(thePlayerName .. " has teleported you into vehicle #" .. vehicleID .. ".", thePlayer, 75, 230, 10)
					else
						outputChatBox("You have teleported into vehicle #" .. vehicleID .. ".", thePlayer, 0, 255, 0)
					end
				else
					outputChatBox("ERROR: Couldn't teleport " .. targetPlayerName .. " into seat " .. saetID .. " of vehicle #" .. vehicleID .. ".", thePlayer, 255, 0, 0)
				end
			else
				local foundSeat = false
				local maxSeats = getVehicleMaxPassengers(theVehicle) or 2
				for aSeat = 0, maxSeats do
					local cseatOccupant = getVehicleOccupant(theVehicle, aSeat)
					if not (cseatOccupant) then
						foundSeat = true
						if _warpPedIntoVehicle(targetPlayer, theVehicle, aSeat) then
							exports.logs:addVehicleLog(vehicleID, "[ENTERVEH] Placed " .. targetPlayerName .. " into seat " .. aSeat .. ".", thePlayer)
							exports.logs:addLog(thePlayer, 1, {targetPlayer, theVehicle}, "Placed into vehicle seat " .. aSeat .. ".")
							if (thePlayer ~= targetPlayer) then
								outputChatBox("You have teleported " .. targetPlayerName .. " into vehicle #" .. vehicleID .. " and into seat " .. aSeat .. ".", thePlayer, 0, 255, 0)
								outputChatBox(thePlayerName .. " has teleported you into vehicle #" .. vehicleID .. ".", thePlayer, 75, 230, 10)
							else
								outputChatBox("You have teleported into vehicle #" .. vehicleID .. ".", thePlayer, 0, 255, 0)
							end
						else
							outputChatBox("ERROR: Couldn't teleport " .. targetPlayerName .. " into vehicle #" .. vehicleID .. ".", thePlayer, 255, 0, 0)
						end
						break
					end
				end

				if not (foundSeat) then
					outputChatBox("ERROR: That vehicle does not have any free seats.", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("enterveh", enterPlayerVehicle)
addCommandHandler("entervehicle", enterPlayerVehicle)

-- /nearbyvehs [Radius] - By Skully (08/04/18) [Helper]
function nearbyVehicles(thePlayer, commandName, radius)
	if exports.global:isPlayerHelper(thePlayer) then
		if not tonumber(radius) then
			radius = 15
		end

		radius = tonumber(radius)
		if (radius <= 0) or (radius > 25) then
			outputChatBox("ERROR: Radius must be between 0 and 25!", thePlayer, 255, 0, 0)
			return false
		end

		local foundVehicle = false
		local nearbyVehicles = exports.global:getNearbyElements(thePlayer, "vehicle", radius)
		outputChatBox("Nearbv vehicles:", thePlayer, 75, 230, 10)
		for i, theVehicle in ipairs(nearbyVehicles) do
			foundVehicle = true
			local vehID = getElementData(theVehicle, "vehicle:id")
			if not tonumber(vehID) then vehID = 0 end

			local _, vehicleName = exports.global:getVehicleInfo(vehID)
			local vehModel = getElementModel(theVehicle)
			local vehicleModelName = getVehicleNameFromModel(vehModel)
			local owner = getElementData(theVehicle, "vehicle:owner")
			local ownerName
			if (tonumber(owner) < 0) then
				local theFaction = exports.data:getElement("team", -owner)
				if theFaction then
					ownerName = getTeamName(theFaction) or "Unknown"
				end
			else
				ownerName = exports.global:getCharacterNameFromID(tonumber(owner))
			end

			outputChatBox("   [ID: " .. vehID .. "] " .. vehicleName .. " (" .. vehicleModelName .. ") - Owner: " .. ownerName, thePlayer, 75, 230, 10)
		end

		exports.logs:addLog(thePlayer, 1, thePlayer, "Checked nearby vehicles with radius " .. radius .. ".")

		if not (foundVehicle) then
			outputChatBox("   No vehicles.", thePlayer, 75, 230, 10)
		end
	end
end
addCommandHandler("nearbyvehs", nearbyVehicles)
addCommandHandler("nearbyvehicles", nearbyVehicles)


function round(y, z)
	local x = 10^(z or 0)
	return math.floor(y * x + 0.5) / x
end

-- /respawnallvehs (Time (10-60)) - By Skully (08/04/18) [Trial Admin]
function respawnAllVehicles(thePlayer, commandName, time)
	if exports.global:isPlayerTrialAdmin(thePlayer) then
		if (commandName) then -- If command was trigged by player and not the timer.
			if (isTimer(vehicleRespawnTimer)) then
				outputChatBox("ERROR: There is already a vehicle respawn active, use /stopvehrespawn to cancel it.", thePlayer, 255, 0, 0)
				return false
			end

			local respawnTime = tonumber(time) or 30
			if (respawnTime < 10) or (respawnTime > 60) then
				outputChatBox("ERROR: Respawn time must be between 10 and 60 seconds.", thePlayer, 255, 0, 0)
				return false
			end

			-- Outputs.
			local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
			exports.global:sendMessage("[INFO] " .. thePlayerName .. " has initiated a vehicle respawn.", 1, true)
			exports.global:sendMessage("[RESPAWN] All vehicles are being respawned in " .. respawnTime .. " seconds, remain in your vehicle to prevent it from respawning.")
			vehicleRespawnTimer = setTimer(respawnAllVehicles, respawnTime * 1000, 1, thePlayer)
			return
		end

		-- Counters.
		local tick = getTickCount()
		local allVehicles = getElementsByType("vehicle")
		local respawnedCounter = 0
		local tempVehsCounter = 0
		local occupiedVehsCounter = 0
		local unlockedCivCounter = 0
		local notMovedCounter = 0
		local deletedVehCounter = 0 -- Currently unused.
		local affectedElements = {thePlayer}

		for i, theVehicle in ipairs(allVehicles) do
			if isElement(theVehicle) then
				local vehicleID = getElementData(theVehicle, "vehicle:id")
				
				-- Count vehicle occupants.
				local occupants = getVehicleOccupants(theVehicle)
				local vehOccuants = 0
				for seat, occupant in pairs(occupants) do
					vehOccuants = vehOccuants + 1
				end

				if (tonumber(vehicleID) == 0) then -- Unoccupied temporary vehicles.
					if (vehOccuants ~= 0) or getVehicleTowingVehicle(theVehicle) or (#getAttachedElements(theVehicle) == 0) then
						occupiedVehsCounter = occupiedVehsCounter + 1
					else
						destroyElement(theVehicle)
						tempVehsCounter = tempVehsCounter + 1
					end
				else
					if (vehOccuants > 0) or getVehicleTowingVehicle(theVehicle) or (#getAttachedElements(theVehicle) > 0) then -- Skip occupied vehicles.
						occupiedVehsCounter = occupiedVehsCounter + 1
					else
						if isVehicleBlown(theVehicle) then
							fixVehicle(theVehicle)
							for i = 0, 5 do
								setVehicleDoorState(theVehicle, i, 4) -- Damage the vehicle.
							end
							setElementHealth(theVehicle, 300) -- Damage HP.
							setElementData(theVehicle, "vehicle:brokenengine", 1)
						end
						
						-- Respawn impounded vehicles here. @requires pd-system

						-- Respawn job vehicles and unlock.
						local isJobVeh = getElementData(theVehicle, "vehicle:job") or 0
						if (isJobVeh ~= 0) then
							if isElementAttached(theVehicle) then -- If vehicle is attached to anything.
								detachElements(theVehicle)
								setElementCollisionsEnabled(theVehicle, true)
							end
							respawnVehicle(theVehicle) -- Respawn the vehicle.
							setVehicleLocked(theVehicle, false) -- Unlock the doors.

							-- Turn off the headlights.
							setVehicleOverrideLights(theVehicle, 1)
							exports.blackhawk:changeElementDataEx(theVehicle, "vehicle:lights", 0, true)

							-- Handbrake the vehicle.
							setElementFrozen(theVehicle, true)
							exports.blackhawk:changeElementDataEx(theVehicle, "vehicle:handbrake", 1)

							-- Turn off the engine.
							setVehicleEngineState(theVehicle, false)
							exports.blackhawk:changeElementDataEx(theVehicle, "vehicle:engine", 0, true)
						else
							local vehx, vehy, vehz = getElementPosition(theVehicle)
							local x, y, z, rx, ry, rz = unpack(getElementData(theVehicle, "vehicle:respawnpos"))

							if (round(vehx, 6) == x) and (round(vehy, 6) == y) then
								notMovedCounter = notMovedCounter + 1
							else
								if isElementAttached(theVehicle) then
									detachElements(theVehicle)
								end
								setElementCollisionsEnabled(theVehicle, true)

								-- Stop vehicle sounds.
								triggerEvent("radio:stopVehicleSounds", theVehicle)

								setElementPosition(theVehicle, x, y, z, true)
								setElementRotation(theVehicle, rx, ry, rz)
								setElementInterior(theVehicle, getElementData(theVehicle, "vehicle:interior"))
								setElementDimension(theVehicle, getElementData(theVehicle, "vehicle:dimension"))
								respawnedCounter = respawnedCounter + 1
								table.insert(affectedElements, theVehicle)
								exports.logs:addVehicleLog(vehicleID, "[RESPAWN ALL] Vehicle respawned.", thePlayer)
							end
						end

						-- Fix faction vehicles.
						if (getElementData(theVehicle, "vehicle:owner") < 0) then
							fixVehicle(theVehicle)
						end
					end
				end
			end
		end

		local timeTaken = (getTickCount() - tick) / 1000

		-- Outputs and logs.
		exports.global:sendMessage("[RESPAWN] All vehicles have been respawned.")
		outputChatBox("Vehicle respawn complete:", thePlayer, 75, 230, 10)
		outputChatBox("   Total Vehicles Respawned: " .. respawnedCounter .. "/" .. respawnedCounter + notMovedCounter .. ".", thePlayer, 75, 230, 10)
		outputChatBox("   Skipped " .. occupiedVehsCounter .. " occupied vehicles.", thePlayer, 75, 230, 10)
		outputChatBox("   Deleted " .. tempVehsCounter .. " temporary vehicles.", thePlayer, 75, 230, 10)
		outputChatBox("   Respawned and unlocked " .. unlockedCivCounter .. " job vehicles.", thePlayer, 75, 230, 10)
		outputChatBox("   Deleted " .. deletedVehCounter .. " vehicles.", thePlayer, 75, 230, 10)
		outputChatBox("   Time taken: " .. timeTaken .. " seconds.", thePlayer, 75, 230, 10)
		exports.logs:addLog(thePlayer, 1, affectedElements, "(/respawnallvehs) " .. respawnedCounter .. " vehicles respawned, " .. tempVehsCounter + deletedVehCounter .. " vehicles deleted - elapsed " .. timeTaken .. " seconds.")
	end
end
addCommandHandler("respawnallvehs", respawnAllVehicles)
addCommandHandler("respawnvehicles", respawnAllVehicles)

-- /stopvehrespawn - By Skully (08/04/18) [Trial Admin]
function stopVehicleRespawnTimer(thePlayer)
	if exports.global:isPlayerTrialAdmin(thePlayer) or exports.global:isPlayerLeadAdmin(thePlayer, true) then -- Allow lead+ to kill timer off duty.
		if isTimer(vehicleRespawnTimer) then
			killTimer(vehicleRespawnTimer)
			local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
			exports.global:sendMessage("[RESPAWN] " .. thePlayerName .. " has cancelled the vehicle respawn.")
		else
			outputChatBox("ERROR: There is no vehicle respawn active!", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("stopvehrespawn", stopVehicleRespawnTimer)

-- /respawndistrict - by Skully (04/06/18) [Trial Admin]
function respawnDistrictVehicles(thePlayer)
	if exports.global:isPlayerTrialAdmin(thePlayer) then
		local districtName = getElementZoneName(thePlayer)
		local allVehicles = exports.data:getDataElementsByType("vehicle")
		local affectedElements = {}
		for i, theVehicle in ipairs(allVehicles) do
			if isElement(theVehicle) then
				if (getElementZoneName(theVehicle) == districtName) then
					local vehicleID = getElementData(theVehicle, "vehicle:id")
					
					-- Count vehicle occupants.
					local occupants = getVehicleOccupants(theVehicle)
					local vehOccuants = 0
					for seat, occupant in pairs(occupants) do vehOccuants = vehOccuants + 1 end

					if (tonumber(vehicleID) == 0) then -- Unoccupied temporary vehicles.
						if (vehOccuants ~= 0) or getVehicleTowingVehicle(theVehicle) or (#getAttachedElements(theVehicle) == 0) then
						else
							destroyElement(theVehicle)
						end
					else
						if (vehOccuants > 0) or getVehicleTowingVehicle(theVehicle) or (#getAttachedElements(theVehicle) > 0) then -- Skip occupied vehicles.
						else
							if isVehicleBlown(theVehicle) then
								fixVehicle(theVehicle)
								for i = 0, 5 do
									setVehicleDoorState(theVehicle, i, 4) -- Damage the vehicle.
								end
								setElementHealth(theVehicle, 300) -- Damage HP.
								exports.blackhawk:changeElementDataEx(theVehicle, "vehicle:brokenengine", 1)
							end
							
							-- Respawn impounded vehicles here. @requires pd-system

							-- Respawn job vehicles and unlock.
							if (getElementData(theVehicle, "vehicle:job") ~= 0) then
								if isElementAttached(theVehicle) then
									detachElements(theVehicle)
									setElementCollisionsEnabled(theVehicle, true)
								end
								respawnVehicle(theVehicle)
								setVehicleLocked(theVehicle, false)
							else
								local vehx, vehy, vehz = getElementPosition(theVehicle)
								local x, y, z, rx, ry, rz = unpack(getElementData(theVehicle, "vehicle:respawnpos"))

								if (round(vehx, 6) ~= x) and (round(vehy, 6) ~= y) then
									if isElementAttached(theVehicle) then
										detachElements(theVehicle)
									end
									setElementCollisionsEnabled(theVehicle, true)

									-- Turn off vehicle radios.
									triggerEvent("radio:stopVehicleSounds", theVehicle)

									setElementPosition(theVehicle, x, y, z, true)
									setElementRotation(theVehicle, rx, ry, rz)
									setElementInterior(theVehicle, getElementData(theVehicle, "vehicle:interior"))
									setElementDimension(theVehicle, getElementData(theVehicle, "vehicle:dimension"))
									table.insert(affectedElements, theVehicle)
									exports.logs:addVehicleLog(vehicleID, "[RESPAWN DISTRICT] Vehicle respawned.", thePlayer)
								end
							end

							-- Fix faction vehicles.
							if (getElementData(theVehicle, "vehicle:owner") < 0) then fixVehicle(theVehicle) end
						end
					end
				end
			end
		end

		-- Outputs.
		local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
		local count = #affectedElements
		table.insert(affectedElements, thePlayer)
		exports.logs:addLog(thePlayer, 1, affectedElements, "(/respawndistrict) Respawned " .. count .. " vehicles in the " .. districtName .. " district.")
		exports.global:sendMessage("[RESPAWN] " .. thePlayerName .. " has respawned " .. count .. " vehicles in the " .. districtName .. " district.", 1, true)
		outputChatBox("You have respawned " .. count .. " vehicles in the " .. districtName .. " district.", thePlayer, 0, 255, 0)
	end
end
addCommandHandler("respawndistrict", respawnDistrictVehicles)

-- /checkveh [Vehicle ID] - By Skully (10/04/18) [Trial Admin/VT]
function checkVehicle(thePlayer, commandName, vehicleID)
	if exports.global:isPlayerTrialAdmin(thePlayer) or exports.global:isPlayerVehicleTeam(thePlayer) then
		local theVehicle = getPedOccupiedVehicle(thePlayer)
		if not (vehicleID) and not (theVehicle) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Vehicle ID]", thePlayer, 75, 230, 10)
			return false
		end

		local jobVeh
		if not (vehicleID) or (vehicleID == "*") and (theVehicle) then
			vehicleID = getElementData(theVehicle, "vehicle:id")
		else
			theVehicle = exports.data:getElement("vehicle", tonumber(vehicleID))
			if not (theVehicle) then
				theVehicle = exports.mysql:QueryString("SELECT `job` FROM `vehicles` WHERE `id` = (?);", tonumber(vehicleID))
				jobVeh = tonumber(theVehicle)
				if not (theVehicle) then
					outputChatBox("ERROR: A vehicle with the ID #" .. vehicleID .. " does not exist!", thePlayer, 255, 0, 0)
					return false
				end
			end
		end

		-- Prevent temp vehicle check.
		if (tonumber(vehicleID) == 0) then
			outputChatBox("ERROR: You cannot check temporary vehicles.", thePlayer, 255, 0, 0)
			return false
		end

		-- Prevent job vehicle check.
		if not (jobVeh) then
			jobVeh = getElementData(theVehicle, "vehicle:job")
		end

		if (jobVeh ~= 0) then
			outputChatBox("ERROR: You cannot check job vehicles.", thePlayer, 255, 0, 0)
			return false
		end

		local vehicleData = exports.mysql:QuerySingle("SELECT * FROM `vehicles` WHERE `id` = (?);", tonumber(vehicleID))
		if (vehicleData) then
			local vehicleLogs, namesTable = exports.logs:getVehicleLogs(tonumber(vehicleID), true)
			local createdBy = exports.global:getAccountNameFromID(vehicleData.createdby)
			local vehTable, vehName = exports.global:getVehicleInfo(vehicleID)
			local ownerName = "Unknown"
			if (vehicleData.faction ~= 0) then
				local theFaction = exports.data:getElement("team", vehicleData.faction)
				if theFaction then
					ownerName = getElementData(theFaction, "faction:abbreviation") .. " (Faction #" .. vehicleData.faction .. ")" or "Unknown"
				end
			else
				ownerName = exports.global:getCharacterNameFromID(vehicleData.owner)
				local _, accountName = exports.global:getCharacterAccount(vehicleData.owner)
				ownerName = ownerName .. " (" .. accountName .. ")"
			end

			triggerClientEvent(thePlayer, "vehicle:checkvehiclegui", thePlayer, theVehicle or false, {vehTable.vehid, vehName, vehTable.type}, vehicleData, vehicleLogs, namesTable, createdBy, ownerName)

		else
			exports.global:outputDebug("@checkVehicle: Failed to fetch vehicle data of vehicle #" .. vehicleID .. ", is there an active database connection?")
			return false
		end
	end
end
addCommandHandler("cv", checkVehicle)
addCommandHandler("checkveh", checkVehicle)
addCommandHandler("checkvehicle", checkVehicle)
addEvent("vehicle:checkvehcall", true) -- Used by /checkveh GUI itself.
addEventHandler("vehicle:checkvehcall", root, checkVehicle)

function checkVehDeleteNote(thePlayer, vehicleID, noteID)
	local query = exports.mysql:Execute("DELETE FROM `vehicle_logs` WHERE `id` = (?);", tonumber(noteID))
	if not (query) then
		exports.global:outputDebug("@checkVehDeleteNote: Failed to delete vehicle note #" .. noteID .. ", is there an active database connection?")
	end

	local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
	exports.global:sendMessageToManagers("[WARN] " .. thePlayerName .. " has deleted note ID " .. noteID .. " from vehicle #" .. vehicleID .. ".", true)
	exports.logs:addLog(thePlayer, 1, {thePlayer, "VEH" .. vehicleID}, "Deleted note #" .. noteID .. " from vehicle.")
end
addEvent("vehicle:checkvehdelnote", true) -- Used by /checkveh GUI.
addEventHandler("vehicle:checkvehdelnote", root, checkVehDeleteNote)

-- /setjobvehicle [Vehicle ID] - By Skully (02/05/18) [Trial Admin]
function setJobVehicle(thePlayer, commandName, vehicleID, jobID)
	if exports.global:isPlayerManager(thePlayer) or exports.global:isPlayerVehicleTeamLeader(thePlayer) then
		if not (vehicleID) or not tonumber(jobID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Vehicle ID] [Job ID]", thePlayer, 75, 230, 10)
			return false
		end

		vehicleID = tonumber(vehicleID)
		local theVehicle, vehicleID = exports.global:getVehicleFromID(vehicleID, thePlayer)
		if not (theVehicle) then return false end

		-- Create check to see if jobID is valid. @requires job-system

		exports.blackhawk:changeElementDataEx(theVehicle, "vehicle:job", tonumber(jobID))
		local query = exports.mysql:Execute("UPDATE `vehicles` SET `job` = (?) WHERE `id` = (?);", jobID, vehicleID)
		if not (query) then
			exports.global:outputDebug("@setJobVehicle: Failed to update jobID of vehicle #" .. vehicleID .. ", is there an active database connection?")
			return
		end

		outputChatBox("You have set vehicle #" .. vehicleID .. "'s job ID to " .. jobID .. ".", thePlayer, 0, 255, 0)
	end
end
addCommandHandler("setjobvehicle", setJobVehicle)
addCommandHandler("sjv", setJobVehicle)

-- /apark [Vehicle ID] - By Skully (21/05/18) [Helper]
function aParkVehicle(thePlayer, commandName, vehicleID)
	if exports.global:isPlayerHelper(thePlayer) then
		if not (vehicleID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Vehicle ID]", thePlayer, 75, 230, 10)
		else
			local theVehicle, vehicleID = exports.global:getVehicleFromID(vehicleID, thePlayer)
			if (theVehicle) then
				local x, y, z = getElementPosition(theVehicle)
				local rx, ry, rz = getElementRotation(theVehicle)
				local vehicleDimension = getElementDimension(theVehicle)
				local vehicleInterior = getElementInterior(theVehicle)
				local vehicleID = getElementData(theVehicle, "vehicle:id")
				setElementData(theVehicle, "vehicle:respawnpos", {x, y, z, rx, ry, rz})
				setElementData(theVehicle, "vehicle:dimension", vehicleDimension)
				setElementData(theVehicle, "vehicle:interior", vehicleInterior)
				saveVehicle(vehicleID)

				local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)

				if not (commandName == "editor") then
					exports.logs:addVehicleLog(vehicleID, "[ADMIN-PARK] Vehicle parked by " .. thePlayerName .. ".", thePlayer)
					exports.global:sendMessageToManagers("[INFO] " .. thePlayerName .. " has aparked vehicle #" .. vehicleID .. ".")
					outputChatBox("You have parked vehicle #" .. vehicleID .. " at it's current location.", thePlayer, 0, 255, 0)
				end
			end
		end
	end
end
addCommandHandler("apark", aParkVehicle)
addEvent("vehicle:parkvehicle", true)
addEventHandler("vehicle:parkvehicle", root, aParkVehicle)

-- /refuelveh [Vehicle ID] - By Skully (24/05/18) [Helper]
function refuelVehicle(thePlayer, commandName, vehicleID)
	if exports.global:isPlayerHelper(thePlayer) then
		if not (vehicleID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Vehicle ID]", thePlayer, 75, 230, 10)
			return false
		end

		vehicleID = tonumber(vehicleID)
		-- Ensure vehicle ID is above 0.
		if (vehicleID <= 0) then
			outputChatBox("ERROR: That is not a valid vehicle ID!", thePlayer, 255, 0, 0)
			return false
		end

		-- Check if vehicle exists.
		local theVehicle, vehicleID = exports.global:getVehicleFromID(vehicleID, thePlayer)
		if not (theVehicle) then return false end

		-- Set fuel level.
		exports.blackhawk:changeElementDataEx(theVehicle, "vehicle:fuel", 100, true)

		-- Outputs & logs.
		local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
		outputChatBox("You have refueled vehicle #" .. vehicleID .. ".", thePlayer, 0, 255, 0)

		local thePlayerVehicle = getPedOccupiedVehicle(thePlayer)
		if (thePlayerVehicle == theVehicle) then
			exports.global:sendMessageToManagers("[INFO] " .. thePlayerName .. " has refueled their own vehicle. [ID: " .. vehicleID .. "]")
		else
			exports.global:sendMessageToManagers("[INFO] " .. thePlayerName .. " has refueled vehicle #" .. vehicleID .. ".")
		end
		exports.logs:addLog(thePlayer, 1, {thePlayer, theVehicle}, "(/refuelveh) Refueled vehicle #" .. vehicleID .. ".")
		exports.logs:addVehicleLog(vehicleID, "[REFUELVEH] " .. thePlayerName .. " refueled this vehicle.", thePlayer)
	end
end
addCommandHandler("refuelveh", refuelVehicle)

-- /fixveh [Player/ID] - by Skully & Zil (29/05/18) [Helper]
function fixveh(thePlayer, commandName, targetPlayer)
	if exports.global:isPlayerHelper(thePlayer) then
		if not (targetPlayer) then
			local adminVehicle = getPedOccupiedVehicle(thePlayer)
			if not adminVehicle then -- If the player executing the command isn't in a vehicle.
				outputChatBox("SYNTAX: /" .. commandName .. " [Player/ID]", thePlayer, 75, 230, 10)
			else
				if (getElementHealth(adminVehicle) == 1000) then -- Check if the vehicle isn't damaged.
					outputChatBox("ERROR: The vehicle isn't damaged!", thePlayer, 255, 0, 0)
				else
					fixVehicle(adminVehicle)
					local brokenEngine = getElementData(adminVehicle, "vehicle:brokenengine")
					if (brokenEngine == 1) then
						exports.blackhawk:changeElementDataEx(adminVehicle, "vehicle:brokenengine", 0, true)
						setVehicleDamageProof(adminVehicle, false)
					end
					
					outputChatBox("You fixed your vehicle.", thePlayer, 75, 230, 10)
					local vehicleID = getElementData(adminVehicle, "vehicle:id")
					local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
					exports.logs:addLog(thePlayer, 1, {thePlayer, adminVehicle}, "Fixed their own vehicle. [ID #" .. vehicleID .. "]")
					exports.logs:addVehicleLog(adminVehicle, "[FIXVEH] " .. thePlayerName .. " fixed the vehicle.", thePlayer)
					exports.global:sendMessageToManagers("[INFO] " .. thePlayerName .. " has fixed their own vehicle.")
				end
			end
		else
			local targetPlayer, targetPlayerName = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)

			if (targetPlayer) then
				local targetVehicle = getPedOccupiedVehicle(targetPlayer)
				if targetVehicle then
					-- Fix the vehicle.
					fixVehicle(targetVehicle)
					local brokenEngine = getElementData(targetVehicle, "vehicle:brokenengine")
					if (brokenEngine == 1) then
						exports.blackhawk:changeElementDataEx(targetVehicle, "vehicle:brokenengine", 0, true)
						setVehicleDamageProof(targetVehicle, false)
					end

					-- Outputs and logs.
					local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
					outputChatBox("You fixed " .. targetPlayerName .. "'s vehicle." , thePlayer, 75, 230, 10)
					outputChatBox(thePlayerName .. " has fixed your vehicle." , targetPlayer, 75, 230, 10)
					exports.logs:addLog(thePlayer, 1, {thePlayer, targetPlayer, targetVehicle}, "Fixed " .. targetPlayerName .. "'s vehicle.")
					exports.logs:addVehicleLog(targetVehicle, "[FIXVEH] " .. thePlayerName .. " fixed the vehicle.", thePlayer)
					exports.global:sendMessageToManagers("[INFO] " .. thePlayerName .. " has fixed " .. targetPlayerName .. "'s vehicle.")
				else
					outputChatBox("ERROR: " .. targetPlayerName .. " isn't in a vehicle.", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("fixveh", fixveh)
addCommandHandler("fixcar", fixveh)

-- /aject [Player/ID] - by Zil & Skully (20/06/17) [Trial Admin]
function aject(thePlayer, commandName, targetPlayer)
	if exports.global:isPlayerTrialAdmin(thePlayer) then
		if not targetPlayer then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player/ID]", thePlayer, 75, 230, 10)
		else
			local targetPlayer, targetPlayerName = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)
			if (targetPlayer) then					
				if getPedOccupiedVehicle(targetPlayer) then -- Check if the target player is in a vehicle.
					local targetVehicle = getPedOccupiedVehicle(targetPlayer)
					local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)

					removePedFromVehicle(targetPlayer)
					outputChatBox(thePlayerName .. " has removed you from your vehicle.", targetPlayer, 255, 0, 0)
					outputChatBox("You removed " .. targetPlayerName .. " from their vehicle.", thePlayer, 0, 255, 0)
					exports.logs:addLog(thePlayer, 1, {thePlayer, targetPlayer, targetVehicle}, "Removed " .. targetPlayerName .. " from their vehicle.")
				else
					outputChatBox("ERROR: " .. targetPlayerName .. " isn't in a vehicle!", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("aject", aject) 
addCommandHandler("aeject", aject)

-- /blowveh [Player/ID] -- by Zil & Skully (21/06/17) [Admin]
function blowVeh(thePlayer, commandName, targetPlayer)
	if exports.global:isPlayerTrialAdmin(thePlayer) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player/ID]", thePlayer, 75, 230, 10)
		else
			local targetPlayer, targetPlayerName = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)
			if (targetPlayer) then
				local targetPlayerVehicle = getPedOccupiedVehicle(targetPlayer)
				if targetPlayerVehicle then
					blowVehicle(targetPlayerVehicle)
					
					local thePlayerName = exports.global:getStaffTitle(thePlayer)
					outputChatBox("You blew up " .. targetPlayerName .. "'s vehicle.", thePlayer, 0, 255, 0)
					outputChatBox(thePlayerName .. " has blown up your vehicle.", targetPlayer, 255, 0, 0)

					exports.global:sendMessageToManagers("[WARN] " .. thePlayerName .. " has blown up "  .. targetPlayerName .. "'s vehicle.", true)
					exports.logs:addLog(thePlayer, 1, {thePlayer, targetPlayer, targetPlayerVehicle}, "Blew up " .. targetPlayerName .. "'s vehicle.")
				else
					outputChatBox("ERROR: " .. targetPlayerName .. " isn't in a vehicle!", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("blowveh", blowVeh)
addCommandHandler("blowcar", blowVeh)

-- /flip [Player/ID] - by Zil & Skully (21/06/17) [Helper]
function flipVeh(thePlayer, commandName, targetPlayer)
	if exports.global:isPlayerHelper(thePlayer) then
		if not (targetPlayer) then
			local thePlayerVehicle = getPedOccupiedVehicle(thePlayer)
			if not thePlayerVehicle then
				outputChatBox("SYNTAX: /" .. commandName .. " [Player/ID]", thePlayer, 75, 230, 10)
			else
				local x, y, z = getElementPosition(thePlayerVehicle)
				local rotX, rotY, rotZ = getElementRotation(thePlayerVehicle)

				setElementRotation(thePlayerVehicle, rotX, 180, rotZ)
				setElementPosition(thePlayerVehicle, x, y, z + 2) -- Gotta make the vehicle go up 2 because it can get stuck in the ground.
				outputChatBox("You flipped your vehicle.", thePlayer, 75, 230, 10)
				local vehicleID = getElementData(thePlayerVehicle, "vehicle:id")
				local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
				exports.logs:addLog(thePlayer, 1, {thePlayer, thePlayerVehicle}, "(/flipveh) Flipped their own vehicle.")
				exports.logs:addVehicleLog(vehicleID, "[FLIP] " .. thePlayerName .. " flipped the vehicle.", thePlayer)
			end
		else
			local targetPlayer = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)
			if (targetPlayer) and (getElementData(targetPlayer, "loggedin") == 1) then
				local affectedElements = {}
				table.insert(affectedElements, targetPlayer)
				local targetPlayerName = getPlayerName(targetPlayer); targetPlayerName = targetPlayerName:gsub("_", " ")
				if (getPedOccupiedVehicle(targetPlayer)) then -- If the target player is in a vehicle then flip it.
					local targetPlayerVehicle = getPedOccupiedVehicle(targetPlayer)
					table.insert(affectedElements, targetPlayerVehicle)
					local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
					local rotX, rotY, rotZ = getElementRotation(targetPlayerVehicle)
					local x, y, z = getElementPosition(targetPlayerVehicle)

					setElementRotation(targetPlayerVehicle, rotX, 180, rotZ)
					setElementPosition(targetPlayerVehicle, x, y, z + 2) -- Gotta make the vehicle go up 2 because it can get stuck in the ground.
					outputChatBox("You flipped " .. targetPlayerName .. "'s vehicle.", thePlayer, 75, 230, 10)
					outputChatBox(thePlayerName .. " has flipped your vehicle.", targetPlayer, 75, 230, 10)
					exports.logs:addLog(thePlayer, 1, affectedElements, "(/flipveh) Flipped " .. targetPlayerName .. "'s vehicle.") 
					local vehicleID = getElementData(targetPlayerVehicle, "vehicle:id")
					exports.logs:addVehicleLog(vehicleID, "[FLIP] " .. thePlayerName .. " flipped the vehicle.", thePlayer)
				else
					outputChatBox("ERROR: " .. targetPlayerName .. " isn't in a vehicle!", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("flip", flipVeh)
addCommandHandler("flipveh", flipVeh)
addCommandHandler("unflip", flipVeh)
addCommandHandler("unflipveh", flipVeh)

-- /setdamageproof - by Skully (21/06/17) [Lead Admin]
function setVehDamageProof(thePlayer)
	if exports.global:isPlayerLeadAdmin(thePlayer) then
		local thePlayerVehicle = getPedOccupiedVehicle(thePlayer)
		if getPedOccupiedVehicle(thePlayer) then
			local isDamageProof = isVehicleDamageProof(thePlayerVehicle)

			local vehicleID = getElementData(thePlayerVehicle, "vehicle:id")
			if (vehicleID <= 0) then
				outputChatBox("ERROR: Temporary vehicles cannot be set as damage proof.", thePlayer, 255, 0, 0)
				return false
			end

			local state = 0
			local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
			setVehicleDamageProof(thePlayerVehicle, not isDamageProof)
			if (isDamageProof) then
				outputChatBox("This vehicle is no longer damage proof.", thePlayer, 255, 0, 0)
				exports.global:sendMessageToManagers("[WARN] " .. thePlayerName .. " has unset vehicle #" .. vehicleID .. " as damage proof.", true)
				exports.logs:addVehicleLog(vehicleID, "[SETDAMAGEPROOF] Vehicle is no longer damage proof.", thePlayer)
			else
				outputChatBox("You have set this vehicle to be damage proof.", thePlayer, 0, 255, 0)
				exports.global:sendMessageToManagers("[WARN] " .. thePlayerName .. " has set vehicle #" .. vehicleID .. " as damage proof.", true)
				exports.logs:addVehicleLog(vehicleID, "[SETDAMAGEPROOF] Vehicle has been set damage proof.", thePlayer)
				state = 1
			end
			exports.mysql:Execute("UPDATE `vehicles` SET `damageproof` = (?) WHERE `id` = (?);", state, vehicleID)
		else
			outputChatBox("ERROR: You must be inside the vehicle you want to set/unset damage proof.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("setdamageproof", setVehDamageProof)
addCommandHandler("setvehdamageproof", setVehDamageProof)
addCommandHandler("setcardamageproof", setVehDamageProof)
addCommandHandler("sdp", setVehDamageProof)

-- /fixvehvis - by Skully (21/06/17) [Helper]
function fixVehVisuals(thePlayer, commandName, vehicleID)
	if exports.global:isPlayerHelper(thePlayer) then
		if not (vehicleID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Vehicle ID]", thePlayer, 75, 230, 10)
			return
		end

		local theVehicle, vehicleID = exports.global:getVehicleFromID(vehicleID, thePlayer)
		if (theVehicle) then
			local vehPanelParts = {0, 1, 2, 3, 4, 5, 6}
			local vehDoorParts = {0, 1, 2, 3, 4, 5}
			local affectedElements = {thePlayer}
			
			for i, panelPart in ipairs(vehPanelParts) do setVehiclePanelState(theVehicle, panelPart, 0) end
			for i, doorPart in ipairs(vehDoorParts) do setVehicleDoorState(theVehicle, doorPart, 0) end

			-- Outputs and logs.
			local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
			outputChatBox("You fixed all visual parts of vehicle #" .. vehicleID .. ".", thePlayer, 0, 255, 0)
			exports.logs:addLog(thePlayer, 1, {thePlayer, theVehicle}, "(/fixvehvis) Fixed visuals of vehicle #" .. vehicleID .. ".")
			exports.logs:addVehicleLog(vehicleID, "[FIX VISUALS] Fixed vehicle visual parts.", thePlayer)
			exports.global:sendMessageToManagers("[WARN] " .. thePlayerName .. " fixed all visual parts of vehicle #" .. vehicleID .. ".")
		end
	end
end
addCommandHandler("fixvehvis", fixVehVisuals)
addCommandHandler("fixvehvisuals", fixVehVisuals)

-- /setvehhp - by Skully (21/06/17) [Trial Admin]
function setVehHP(thePlayer, commandName, vehicleID, hp)
	if exports.global:isPlayerTrialAdmin(thePlayer) then
		if not (vehicleID) or not tonumber(hp) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Vehicle ID] [HP (0-1000)]", thePlayer, 75, 230, 10)
		else
			local theVehicle, vehicleID = exports.global:getVehicleFromID(vehicleID, thePlayer)
			if (theVehicle) then
				local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
				hp = tonumber(hp)

				setElementHealth(theVehicle, hp)
				outputChatBox("You set vehicle #" .. vehicleID .. "'s health to " .. hp .. ".", thePlayer, 0, 255, 0)
				exports.logs:addLog(thePlayer, 1, {thePlayer, theVehicle}, "(/setvehhp) Set vehicle #" .. vehicleID .. "'s health to " .. hp .. ".")
				exports.logs:addVehicleLog(vehicleID, "[SET HP] Vehicle health set to " .. hp .. ".", thePlayer)
				exports.global:sendMessageToManagers("[WARN] " .. thePlayerName .. " has set vehicle #" .. vehicleID .. "'s health to " .. hp .. ".")
			end
		end
	end
end
addCommandHandler("setvehhp", setVehHP)
addCommandHandler("setvehhealth", setVehHP)

-- /setvehcolor [Color 1] [Color 2] [Color 3] [Color 4] - by Skully (29/05/18) [Helper]
function setVehColor(thePlayer, commandName, vehicleID, r, g, b, colorSet)
	if not (vehicleID) or not tonumber(r) or not tonumber(g) or not tonumber(b) then
		outputChatBox("SYNTAX: /" .. commandName .. " [Vehicle ID] [R] [G] [B] [Color set (1-4)]", thePlayer, 75, 230, 10)
		return false
	end

	local theVehicle, vehicleID = exports.global:getVehicleFromID(vehicleID, thePlayer)
	if (theVehicle) then
		if not tonumber(colorSet) then colorSet = 1 end
		r, g, b, colorSet = tonumber(r), tonumber(g), tonumber(b), tonumber(colorSet)

		if (r < 0) or (g < 0) or (b < 0) or (r > 255) or (g > 255) or (b > 255) then
			outputChatBox("ERROR: R, G, B values must be between 0-255.", thePlayer, 255, 0, 0)
			return false
		elseif (colorSet < 1) or (colorSet > 4) then
			outputChatBox("ERROR: Color set must be between 1 and 4.", thePlayer, 255, 0, 0)
			return false
		end

		local rr1, gg1, bb1, rr2, gg2, bb2, rr3, gg3, bb3 = getVehicleColor(theVehicle, true)

		if (colorSet == 1) then setVehicleColor(theVehicle, r, g, b)
			elseif (colorSet == 2) then setVehicleColor(theVehicle, rr1, gg1, bb1, r, g, b)
			elseif (colorSet == 3) then setVehicleColor(theVehicle, rr1, gg1, bb1, rr2, gg2, bb2, r, g, b)
			elseif (colorSet == 4) then setVehicleColor(theVehicle, rr1, gg1, bb1, rr2, gg2, bb2, rr3, gg3, bb3, r, g, b)
		end

		-- Outputs and logs.
		local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
		outputChatBox("You have set vehicle #" .. vehicleID .. "'s colors to " .. r .. ", " .. g .. ", " .. b .. ".", thePlayer, 0, 255, 0)
		exports.logs:addLog(thePlayer, 1, {thePlayer, theVehicle}, "(/setvehcolor) Set vehicle #" .. vehicleID .. "'s color set " .. colorSet .. " to " .. r .. ", " .. g .. ", " .. b .. " (RGB).")
		exports.logs:addVehicleLog(vehicleID, "[SET COLOR] Colour set " .. colorSet .. " updated to " .. r .. ", " .. g .. ", " .. b .. " (RGB).", thePlayer)
		exports.global:sendMessageToManagers("[WARN] " .. thePlayerName .. " has adjusted vehicle #" .. vehicleID .. "'s colors.")
	end
end
addCommandHandler("setvehcolor", setVehColor)
addCommandHandler("setvehiclecolor", setVehColor)

-- /setvehplates [Vehicle ID] [New Plates] - by Skully (29/05/18) [Trial Admin]
function setVehPlates(thePlayer, commandName, vehicleID, ...)
	if(exports.global:isPlayerTrialAdmin(thePlayer)) then
		if not (vehicleID) or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Vehicle ID] [New Plate]", thePlayer, 75, 230, 10)
		else
			local theVehicle, vehicleID = exports.global:getVehicleFromID(vehicleID, thePlayer)
			if (theVehicle) then
				local newPlate = table.concat({...}, " ")
				if (#newPlate < 1) or (#newPlate > 8) then
					outputChatBox("ERROR: Plate text must be between 1 and 8 characters.", thePlayer, 255, 0, 0)
					return false
				end
				
				local oldPlates = getVehiclePlateText(theVehicle)
				setVehiclePlateText(theVehicle, newPlate)
				exports.mysql:Execute("UPDATE `vehicles` SET `plates` = (?) WHERE `id` = (?);", newPlate, vehicleID)
				
				-- Outputs and logs.
				local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)					
				outputChatBox("You have changed vehicle #" .. vehicleID .. "'s registration plate text to '" .. newPlate .. "'.", thePlayer, 0, 255, 0)

				exports.global:sendMessageToManagers("[INFO] " .. thePlayerName .. " has changed vehicle #" .. vehicleID .. "'s registration plates to '" .. newPlate .. "'.")
				exports.logs:addLog(thePlayer, 1, {thePlayer, theVehicle}, "(/setvehplates) Updated vehicle plates from '" .. oldPlates .. "' to '" .. newPlate .. "'.")
				exports.logs:addVehicleLog(theVehicle, "[SETVEHPLATE] Updated vehicle plates from '" .. oldPlates .. "' to '" .. newPlate .. "'.", thePlayer)
			end
		end
	end
end
addCommandHandler("setvehplates", setVehPlates)
addCommandHandler("setvehicleplates", setVehPlates)

-- /tempsell [Player/ID] - By Skully (03/06/18) [Trial Admin]
function giveTemporarySell(thePlayer, commandName, targetPlayer)
	if exports.global:isPlayerTrialAdmin(thePlayer) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player/ID]", thePlayer, 75, 230, 10)
			return false
		end

		local targetPlayer, targetPlayerName = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)
		if (targetPlayer) then
			local hasTempsell = getElementData(targetPlayer, "var:tempsell")
			if not (hasTempsell) then -- If the target doesn't already have tempsell.
				exports.blackhawk:setElementDataEx(targetPlayer, "var:tempsell", true, false)

				-- Outputs and logs.
				local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
				outputChatBox("You have given " .. targetPlayerName .. " temporary access to /sellveh any vehicle.", thePlayer, 0, 255, 0)
				outputChatBox("Please remain on duty and watch for informational messages regarding the vehicles they sell.", thePlayer, 75, 230, 10)
				outputChatBox(thePlayerName .. " has given you temporary access to /sellveh vehicles.", targetPlayer, 255, 255, 0)
				exports.global:sendMessage("[INFO] " .. thePlayerName .. " has given " .. targetPlayerName .. " temporary access to /sellveh.", 1, true)
				setTimer(function()
					local stillHasTempsell = getElementData(targetPlayer, "var:tempsell")
					if (stillHasTempsell) then
						removeElementData(targetPlayer, "var:tempsell")
						outputChatBox("The temporary /sellveh access given to " .. targetPlayerName .. " has expired.", thePlayer, 255, 255, 0)
						outputChatBox("Your temporary /sellveh access has expired.", targetPlayer, 255, 255, 0)
						exports.logs:addLog(thePlayer, 1, {thePlayer, targetPlayer}, "(/tempsell) " .. targetPlayerName .. "'s temporary access to /sellveh access expired and was automatically removed.")
					end
				end, 10000, 1)--120000
			else -- If target already has tempsell, we remove it.
				removeElementData(targetPlayer, "var:tempsell")
				local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
				outputChatBox("You have removed " .. targetPlayerName .. "'s /tempsell access.", thePlayer, 0, 255, 0)
				outputChatBox("Your /tempsell access has been revoked by " .. thePlayerName .. ".", targetPlayer, 255, 0, 0)
				exports.logs:addLog(thePlayer, 1, {thePlayer, targetPlayer}, "(/tempsell) Access to temporary /sellveh was revoked.")
			end
		end
	end
end
addCommandHandler("tempsell", giveTemporarySell)

-- /setvehowner [Vehicle ID] [Player ID] - By Skully (03/06/18) [Trial Admin]
function setVehicleOwner(thePlayer, commandName, vehicleID, targetPlayer)
	if exports.global:isPlayerTrialAdmin(thePlayer) then
		if not (vehicleID) or not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Vehicle ID] [Player/ID]", thePlayer, 75, 230, 10)
			return false
		end

		local theVehicle, vehicleID = exports.global:getVehicleFromID(vehicleID, thePlayer)
		if (theVehicle) then
			local targetPlayer, targetPlayerName = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)
			if (targetPlayer) then
				local targetCharacterID = getElementData(targetPlayer, "character:id")
				local targetVehicleSlots = exports.global:getVehicleSlots(targetCharacterID)
				if (targetVehicleSlots) then -- If targetPlayer has available vehicle slots.
					local setOwner = exports.blackhawk:changeElementDataEx(theVehicle, "vehicle:owner", targetCharacterID)
					if (setOwner) then
						local oldOwner = getElementData(theVehicle, "vehicle:owner")
						local ownerName = "Unknown"
						if (oldOwner < 0) then
							local theFaction = exports.data:getElement("team", -oldOwner)
							if theFaction then
								ownerName = getTeamName(theFaction) or "Unknown"
							end
						else
							ownerName = exports.global:getCharacterNameFromID(oldOwner)
						end
						local theVehicle = reloadVehicle(vehicleID)
						if theVehicle then
							local thePlayerName = exports.global:getStaffTitle(thePlayer)
							local theVehicleName = getElementData(theVehicle, "vehicle:name")
							outputChatBox("You have set " .. targetPlayerName .. " as the owner of the " .. theVehicleName .. " (#" .. vehicleID .. ").", thePlayer, 0, 255, 0)
							outputChatBox(thePlayerName .. " has transfered a " .. theVehicleName .. " (#" .. vehicleID .. ") to your ownership.", targetPlayer, 75, 230, 10)
							exports.logs:addLog(thePlayer, 1, {thePlayer, targetPlayer, theVehicle}, "(/setvehowner) " .. thePlayerName .. " transfered the vehicle's ownership from " .. oldOwner .. " to " .. targetPlayerName .. ".")
							exports.logs:addVehicleLog(theVehicle, "[SETVEHOWNER] Set " .. targetPlayerName .. " as the vehicle owner.", thePlayer)
							exports.global:sendMessageToManagers("[WARN] " .. thePlayerName .. " has set " .. targetPlayerName .. " as the owner of vehicle #" .. vehicleID .. ".", true)
						else
							outputChatBox("ERROR: Something went wrong whilst saving the vehicle owner.", thePlayer, 255, 0, 0)
						end
					else
						outputChatBox("ERROR: Something went wrong whilst updating the vehicle owner.", thePlayer, 255, 0, 0)
					end
				else
					outputChatBox("ERROR: " .. targetPlayerName .. " doesn't have any available vehicle slots!", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("setvehowner", setVehicleOwner)
addCommandHandler("setvehicleowner", setVehicleOwner)

-- /setvehfuel [Vehicle ID] [Fuel (0-100)] - By Skully (03/06/18) [Helper]
function setVehicleFuel(thePlayer, commandName, vehicleID, fuel)
	if exports.global:isPlayerHelper(thePlayer) or exports.global:isPlayerVehicleTeam(thePlayer) then
		if not (vehicleID) or not tonumber(fuel) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Vehicle ID] [Fuel (0-100%)]", thePlayer, 75, 230, 10)
			return false
		end

		fuel = tonumber(fuel)
		if (fuel < 0) or (fuel > 100) then
			outputChatBox("ERROR: Fuel level must be between 0 and 100!", thePlayer, 255, 0, 0)
			return false
		end

		local theVehicle, vehicleID = exports.global:getVehicleFromID(vehicleID, thePlayer)
		if (theVehicle) then
			local vehType = getElementData(theVehicle, "vehicle:type")
			local tankSize = g_vehicleTypes[vehType]["tank"]
			local fuelToSet = math.ceil((fuel * tankSize) / 100)
			exports.blackhawk:changeElementDataEx(theVehicle, "vehicle:fuel", fuelToSet)
			if (fuelToSet == 0) then setVehicleEngineState(theVehicle, false) end -- If fuel level is 0, turn engine off.

			-- Outputs and logs.
			local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
			outputChatBox("You have set vehicle #" .. vehicleID .. "'s fuel level to " .. fuel .. "%.", thePlayer, 0, 255, 0)
			exports.global:sendMessageToManagers("[INFO] " .. thePlayerName .. " has set vehicle #" .. vehicleID .. "'s fuel level to " .. fuel .. "%.")
			exports.logs:addLog(thePlayer, 1, {thePlayer, theVehicle}, "(/setvehfuel) Vehicle fuel level set to " .. fuel .. "% (Of " .. tankSize .. ").")
			exports.logs:addVehicleLog(vehicleID, "[SETFUEL] Fuel has been set to " .. fuel .. "% (Of " .. tankSize .. ").", thePlayer)
		end
	end
end
addCommandHandler("setvehfuel", setVehicleFuel)

-- /respawnjobvehs - By Skully (04/06/18) [Helper]
function respawnJobVehicles(thePlayer)
	if exports.global:isPlayerHelper(thePlayer) then
		local allVehicles = exports.data:getDataElementsByType("vehicle")
		for i, theVehicle in ipairs(allVehicles) do
			local isJobVehicle = getElementData(theVehicle, "vehicle:job") or 0
			if (isJobVehicle ~= 0) then

				-- Count vehicle occupants.
				local occupants = getVehicleOccupants(theVehicle)
				local vehOccuants = 0
				for seat, occupant in pairs(occupants) do
					vehOccuants = vehOccuants + 1
				end

				-- If the vehicle isn't occupied.
				if (vehOccuants == 0) then
					if isElementAttached(theVehicle) then -- If vehicle is attached to anything.
						detachElements(theVehicle)
						setElementCollisionsEnabled(theVehicle, true)
					end
					respawnVehicle(theVehicle) -- Respawn the vehicle.
					setVehicleLocked(theVehicle, false) -- Unlock the doors.

					-- Turn off the headlights.
					setVehicleOverrideLights(theVehicle, 1)
					exports.blackhawk:changeElementDataEx(theVehicle, "vehicle:lights", 0, true)

					-- Handbrake the vehicle.
					setElementFrozen(theVehicle, true)
					exports.blackhawk:changeElementDataEx(theVehicle, "vehicle:handbrake", 1)

					-- Turn off the engine.
					setVehicleEngineState(theVehicle, false)
					exports.blackhawk:changeElementDataEx(theVehicle, "vehicle:engine", 0, true)
				end
			end
		end

		-- Outputs and logs.
		local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
		outputChatBox("You have respawned all job vehicles.", thePlayer, 0, 255, 0)
		exports.global:sendMessage("[INFO] " .. thePlayerName .. " has respawned all job vehicles.", 1, true)
	end
end
addCommandHandler("respawnjobvehs", respawnJobVehicles)

-- /setvehdim [Vehicle ID] [Dimension ID] - By Skully (29/06/18) [Helper]
function setVehicleDimension(thePlayer, commandName, vehicleID, dimension)
	if exports.global:isPlayerHelper(thePlayer) then
		if not vehicleID or not tonumber(dimension) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Vehicle ID] [Dimension (0-25565)]", thePlayer, 75, 230, 10)
			return
		end

		dimension = tonumber(dimension)
		if (dimension < 0) or (dimension > 25565) then
			outputChatBox("ERROR: Dimension must be between 0 and 25565!", thePlayer, 255, 0, 0)
			return false
		elseif (dimension == 22220) and not exports.global:isPlayerVehicleTeam(thePlayer, true) or not exports.global:isPlayerLeadAdmin(thePlayer, true) or not exports.global:isPlayerDeveloper(thePlayer, true) then
			outputChatBox("ERROR: This dimension is restricted to the Vehicle Team.", thePlayer, 255, 0, 0)
			return false
		end

		local theVehicle = exports.global:getVehicleFromID(vehicleID, thePlayer)
		if theVehicle then
			local updated, affectedElements = exports.global:elementEnterInterior(theVehicle, false, false, dimension, false, true, true)
			if updated then
				outputChatBox("You have set vehicle #" .. vehicleID .. "'s dimension to " .. dimension .. ".", thePlayer, 0, 255, 0)
				exports.logs:addLog(thePlayer, 1, affectedElements, "(/setvehdim) Vehicle dimension set to " .. dimension .. ".")
				exports.logs:addVehicleLog(vehicleID, "[SETVEHDIM] Vehicle dimension set to " .. dimension .. ".", thePlayer)
			end
		end
	end
end
addCommandHandler("setvehdim", setVehicleDimension)

-- /setvehint [Vehicle ID] [Interior (0-255)] - By Skully (29/06/18) [Helper]
function setVehicleInterior(thePlayer, commandName, vehicleID, interior)
	if exports.global:isPlayerHelper(thePlayer) then
		if not vehicleID or not tonumber(interior) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Vehicle ID] [Interior (0-255)]", thePlayer, 75, 230, 10)
			return
		end

		interior = tonumber(interior)
		if (interior < 0) or (interior > 255) then
			outputChatBox("ERROR: Interior must be between 0 and 255!", thePlayer, 255, 0, 0)
			return false
		end

		local theVehicle = exports.global:getVehicleFromID(vehicleID, thePlayer)
		if theVehicle then
			local updated, affectedElements = exports.global:elementEnterInterior(theVehicle, false, false, false, interior, true, true)
			if updated then
				outputChatBox("You have set vehicle #" .. vehicleID .. "'s interior to " .. interior .. ".", thePlayer, 0, 255, 0)
				exports.logs:addLog(thePlayer, 1, affectedElements, "(/setvehint) Vehicle interior set to " .. interior .. ".")
				exports.logs:addVehicleLog(vehicleID, "[SETVEHINT] Vehicle interior set to " .. interior .. ".", thePlayer)
			end
		end
	end
end
addCommandHandler("setvehint", setVehicleInterior)

-- /setvehfaction [Vehicle ID] [Faction ID] - By Skully (07/07/18) [Helper]
function setVehicleFaction(thePlayer, commandName, vehicleID, factionID)
	if exports.global:isPlayerHelper(thePlayer) then
		if not vehicleID or not factionID then
			outputChatBox("SYNTAX: /" .. commandName .. " [Vehicle ID] [Faction ID]", thePlayer, 75, 230, 10)
			return
		end

		local theVehicle, vehicleID = exports.global:getVehicleFromID(vehicleID, thePlayer)
		if theVehicle then
			local theFaction, factionID, theFactionName = exports.global:getFactionFromID(factionID, thePlayer)
			if theFaction then
				exports.blackhawk:changeElementDataEx(theVehicle, "vehicle:owner", -factionID)
				exports.blackhawk:changeElementDataEx(theVehicle, "vehicle:ownername", theFactionName)
				saveVehicle(vehicleID)

				-- Outputs & logs.
				local thePlayerName = exports.global:getStaffTitle(thePlayer)
				outputChatBox("You have set vehicle #" .. vehicleID .. " into the faction #" .. factionID .. ".", thePlayer, 0, 255, 0)
				exports.logs:addVehicleLog(vehicleID, "[SET VEHICLE FACTION] Vehicle faction set to #" .. factionID .. ".", thePlayer)
				exports.global:sendMessageToManagers("[INFO] " .. thePlayerName .. " has set vehicle #" .. vehicleID .. " into faction #" .. factionID .. ".")
			end
		end
	end
end
addCommandHandler("setvehfaction", setVehicleFaction)
addCommandHandler("setvehiclefaction", setVehicleFaction)

-- /delnearbyvehs [Radius] - By Skully (12/08/18) [Admin/VT Leader]
function deleteNearbyVehicles(thePlayer, commandName, radius)
	if exports.global:isPlayerAdmin(thePlayer) or exports.global:isPlayerVehicleTeamLeader(thePlayer) then
		if not tonumber(radius) then
			radius = 15
		end

		radius = tonumber(radius)
		if (radius <= 0) or (radius > 25) then
			outputChatBox("ERROR: Radius must be between 0 and 25!", thePlayer, 255, 0, 0)
			return false
		end

		local delVehCount = 0
		local affectedElements = {thePlayer}
		local nearbyVehicles = exports.global:getNearbyElements(thePlayer, "vehicle", radius)
		outputChatBox("Deleted vehicles:", thePlayer, 255, 0, 0)
		for i, theVehicle in ipairs(nearbyVehicles) do
			local vehID = getElementData(theVehicle, "vehicle:id")
			if not tonumber(vehID) then vehID = 0 end

			local _, vehicleName = exports.global:getVehicleInfo(vehID)
			local vehModel = getElementModel(theVehicle)
			local vehicleModelName = getVehicleNameFromModel(vehModel)
			local owner = getElementData(theVehicle, "vehicle:owner") or "None"
			local ownerName
			if (tonumber(owner) < 0) then
				local theFaction = exports.data:getElement("team", -owner)
				if theFaction then
					ownerName = getElementData(theFaction, "faction:abbreviation") or "Unknown"
				end
			else
				ownerName = exports.global:getCharacterNameFromID(tonumber(owner))
			end
			local query = exports.mysql:Execute("UPDATE `vehicles` SET `deleted` = '1' WHERE `id` = (?);", vehID)
			if (query) then
				outputChatBox("   [ID: " .. vehID .. "] " .. vehicleName .. " (" .. vehicleModelName .. ") - Owner: " .. ownerName, thePlayer, 255, 0, 0)
				local thePlayerName = exports.global:getStaffTitle(thePlayer)
				exports.global:sendMessage("[INFO] " .. thePlayerName .. " has deleted a " .. vehicleName .. " [ID: " .. vehID .. "] (Owner: " .. ownerName .. ")", 2, true)
				exports.logs:addLog(thePlayer, 1, {thePlayer, theVehicle}, thePlayerName .. " has deleted a " .. vehicleName .. " [ID: " .. vehID .. "] - Owner: " .. ownerName)
				exports.logs:addVehicleLog(vehID, "[DELNEARBYVEHS] VEHICLE DELETED - " .. vehicleName, thePlayer)
				destroyElement(theVehicle) -- Delete the element after the logs have been submit.
				table.insert(affectedElements, "VEH" .. vehID)
				delVehCount = delVehCount + 1
			else
				outputChatBox("ERROR: Failed to delete vehicle #" .. vehID .. "!", thePlayer, 255, 0, 0)
				return false
			end
		end

		exports.logs:addLog(thePlayer, 1, affectedElements, "Deleted " .. delVehCount .. " vehicles within a radius of " .. radius .. ".")

		if (delVehCount == 0) then
			outputChatBox("   No vehicles.", thePlayer, 75, 230, 10)
		end
	end
end
addCommandHandler("delnearbyvehs", deleteNearbyVehicles)
addCommandHandler("deletenearbyvehs", deleteNearbyVehicles)
addCommandHandler("deletenearbyvehicles", deleteNearbyVehicles)

-- Function to update vehicle description, command is located clientside.
function updateVehicleDescription(theVehicle, descriptionTable)
	exports.blackhawk:changeElementDataEx(theVehicle, "vehicle:description", descriptionTable, true)

	local thePlayerName = exports.global:getStaffTitle(source)
	local vehicleID = getElementData(theVehicle, "vehicle:id")
	outputChatBox("You have updated the vehicle description.", source, 75, 230, 10)
	exports.global:sendMessageToManagers("[INFO] " .. thePlayerName .. " has updated the description of vehicle #" .. vehicleID .. ".")
	exports.logs:addLog(source, 1, theVehicle, "(/ed) Adjusted the description of vehicle #" .. vehicleID .. ".")
end
addEvent("vehicle:updateVehicleDescription", true)
addEventHandler("vehicle:updateVehicleDescription", root, updateVehicleDescription)

-- /togvin [Vehicle ID] - By Skully (11/02/19) [Lead Admin/VT Leader]
function toggleVehicleVIN(thePlayer, commandName, vehicleID)
	if exports.global:isPlayerLeadAdmin(thePlayer) or exports.global:isPlayerVehicleTeamLeader(thePlayer) then
		if not (vehicleID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Vehicle ID]", thePlayer, 75, 230, 10)
			return
		end

		local theVehicle, vehicleID = exports.global:getVehicleFromID(vehicleID, thePlayer)
		if theVehicle then
			local vinVisible = getElementData(theVehicle, "vehicle:showvin") or 1
			local thePlayerName = exports.global:getStaffTitle(thePlayer)
			if (vinVisible == 1) then
				exports.blackhawk:changeElementDataEx(theVehicle, "vehicle:showvin", 0, true)
				outputChatBox("You have hidden the VIN of vehicle #" .. vehicleID .. ".", thePlayer, 75, 230, 10)
				exports.global:sendMessageToManagers("[INFO] " .. thePlayerName .. " has adjusted vehicle #" .. vehicleID .. "'s VIN to be hidden.", 1)
				exports.logs:addLog(thePlayer, 1, theVehicle, "(/togvin) Adjusted vehicle VIN to be hidden.")
			else
				exports.blackhawk:changeElementDataEx(theVehicle, "vehicle:showvin", 1, true)
				outputChatBox("You have adjusted the VIN of vehicle #" .. vehicleID .. " to be visible.", thePlayer, 75, 230, 10)
				exports.global:sendMessageToManagers("[INFO] " .. thePlayerName .. " has adjusted vehicle #" .. vehicleID .. "'s VIN to be visible.", 1)
				exports.logs:addLog(thePlayer, 1, theVehicle, "(/togvin) Adjusted vehicle VIN to be visible.")
			end
		end
	end
end
addCommandHandler("togvin", toggleVehicleVIN)

-- /togplates [Vehicle ID] - By Skully (11/02/19) [Lead Admin/VT Leader]
function toggleVehiclePlates(thePlayer, commandName, vehicleID)
	if exports.global:isPlayerLeadAdmin(thePlayer) or exports.global:isPlayerVehicleTeamLeader(thePlayer) then
		if not (vehicleID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Vehicle ID]", thePlayer, 75, 230, 10)
			return
		end

		local theVehicle, vehicleID = exports.global:getVehicleFromID(vehicleID, thePlayer)
		if theVehicle then
			local platesVisible = getElementData(theVehicle, "vehicle:showplates") or 1
			local thePlayerName = exports.global:getStaffTitle(thePlayer)
			if (platesVisible == 1) then
				exports.blackhawk:changeElementDataEx(theVehicle, "vehicle:showplates", 0, true)
				outputChatBox("You have hidden the plates of vehicle #" .. vehicleID .. ".", thePlayer, 75, 230, 10)
				exports.global:sendMessageToManagers("[INFO] " .. thePlayerName .. " has adjusted vehicle #" .. vehicleID .. "'s plates to be hidden.", 1)
				exports.logs:addLog(thePlayer, 1, theVehicle, "(/togplates) Adjusted vehicle plates to be hidden.")
			else
				exports.blackhawk:changeElementDataEx(theVehicle, "vehicle:showplates", 1, true)
				outputChatBox("You have adjusted the plates of vehicle #" .. vehicleID .. " to be visible.", thePlayer, 75, 230, 10)
				exports.global:sendMessageToManagers("[INFO] " .. thePlayerName .. " has adjusted vehicle #" .. vehicleID .. "'s plates to be visible.", 1)
				exports.logs:addLog(thePlayer, 1, theVehicle, "(/togplates) Adjusted vehicle plates to be visible.")
			end
		end
	end
end
addCommandHandler("togplates", toggleVehiclePlates)