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

-- /vehlist - By Skully (05/04/18) [Trial Admin/VT]
function showVehicleList(thePlayer)
	if exports.global:isPlayerTrialAdmin(thePlayer, true) or exports.global:isPlayerVehicleTeam(thePlayer, true) then
		local vehicleData = exports.mysql:Query("SELECT * FROM `vehicle_database`")

		if (vehicleData) then
			local createdBy = {}
			local updatedBy = {}

			for i, vehInfo in ipairs(vehicleData) do
				local createdby = exports.global:getAccountNameFromID(vehInfo.createdby)
				local updatedby = exports.global:getAccountNameFromID(vehInfo.updatedby)
				table.insert(createdBy, createdby)
				table.insert(updatedBy, updatedby)
			end

			triggerClientEvent(thePlayer, "vehicle:c_showvehlist", thePlayer, vehicleData, createdBy, updatedBy)
		else
			outputChatBox("An error occurred whilst fetching the vehicle library.", thePlayer, 255, 0, 0)
			exports.global:outputDebug("@showVehicleList: Failed to fetch vehicle data from vehicle database, is there an active connection?")
		end
	end
end
addEvent("vehicle:s_showvehlist", true)
addEventHandler("vehicle:s_showvehlist", root, showVehicleList) -- eventHandler's used by /createveh GUI.
addCommandHandler("vehlist", showVehicleList)
addCommandHandler("vehlib", showVehicleList)
addCommandHandler("vehiclelist", showVehicleList)

function deleteLibraryVehicle(thePlayer, vehlibID)
	local allVehicles = exports.mysql:Query("SELECT `id` FROM `vehicles` WHERE `model` = (?);", vehlibID)
	local deletedVehicles = 0
	if (allVehicles) then
		for i, vehicle in ipairs(allVehicles) do
			local vehicleElement = exports.data:getElement("vehicle", vehicle.id)
			if (vehicleElement) then destroyElement(vehicleElement) end -- Destroy the vehicle if it exists.
			local deleted = exports.mysql:Execute("DELETE FROM `vehicles` WHERE `id` = (?);", vehicle.id) -- Delete vehicle from database.
			if (deleted) then -- Delet all vehicle logs.
				exports.mysql:Execute("DELETE FROM `vehicle_logs` WHERE `vehid` = (?);", vehicle.id)
			end
			deletedVehicles = deletedVehicles + 1
			exports.logs:addLog(thePlayer, 18, "VEH" .. vehicle.id, "[LIBRARY DELETE] Deleted library model #"  .. vehlibID .. ", vehicle deleted.")
		end
	end
	-- Delete vehicle data from library.
	exports.mysql:Execute("DELETE FROM `vehicle_database` WHERE `id` = (?);", vehlibID)
	exports.logs:addLog(thePlayer, 18, thePlayer, "Deleted library model #" .. vehlibID .. ", " .. deletedVehicles .. " have been permanently deleted.")

	-- Outputs.
	local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
	outputChatBox("You have deleted library vehicle #" .. vehlibID .. ", a total of " .. deletedVehicles .. " vehicles have also been permanently deleted.", thePlayer, 75, 230, 10)
	exports.global:sendMessage("[WARN] " .. thePlayerName .. " has deleted vehicle #" .. vehlibID .. " from the library, " .. deletedVehicles .. " vehicles have been deleted from the world.", 2)

	-- Reopen the /vehlist for the player.
	showVehicleList(thePlayer)
end
addEvent("vehicle:vehlist:deletevehicle", true)
addEventHandler("vehicle:vehlist:deletevehicle", root, deleteLibraryVehicle)

function libraryVehicleEditor(thePlayer, vehDBID)
	if getPedOccupiedVehicle(thePlayer) then
		outputChatBox("ERROR: Please exit your current vehicle before edtting!", thePlayer, 255, 0, 0)
		return
	end

	local vehicleInfo, vehName = exports.global:getVehicleModelInfo(vehDBID)	
	triggerEvent("vehicle:s_makeEditorVehicle", thePlayer, thePlayer, vehicleInfo, vehDBID, nil, vehicleInfo.price, vehicleInfo.vehid, vehicleInfo.dealership, vehicleInfo.type, vehicleInfo.tax, false)

	triggerClientEvent(thePlayer, "vehicle:modding:drawsidebar", thePlayer, false, vehicleInfo)
end
addEvent("vehicle:vehlist:editvehicle", true) -- Triggered from /vehlib GUI.
addEventHandler("vehicle:vehlist:editvehicle", root, libraryVehicleEditor)

function updateLibraryVehicle(thePlayer)
	local tempVeh = getPedOccupiedVehicle(thePlayer)
	if not (tempVeh) then
		outputChatBox("ERROR: Something went wrong whilst saving your changes!", thePlayer, 255, 0, 0)
		return false
	end

	-- Get vehicle data.
	local vehID = getElementData(tempVeh, "tempveh:vehid")
	local year = getElementData(tempVeh, "tempveh:year")
	local model = getElementData(tempVeh, "tempveh:model")
	local brand = getElementData(tempVeh, "tempveh:brand")
	local price = getElementData(tempVeh, "tempveh:price")
	local dealership = getElementData(tempVeh, "tempveh:dealership")
	local vehType = getElementData(tempVeh, "vehicle:type")
	local handlingData = getElementData(tempVeh, "tempveh:handling")
	if not (handlingData) then -- If handling wasn't adjusted during vehicle creation.
		handlingData = getVehicleHandling(tempVeh); handlingData = toJSON(handlingData)
	end
	local tax = getElementData(tempVeh, "tempveh:tax")
	local libraryID = getElementData(tempVeh, "vehicle:vehid")

	-- Destroy the vehicle and all attached data.
	destroyElement(tempVeh)

	local accountID = getElementData(thePlayer, "account:id")
	local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
	local timeNow = exports.global:getCurrentTime()

	-- Update and logging.
	local updated = exports.mysql:Execute("UPDATE `vehicle_database` SET `vehid` = (?), `brand` = (?), `model` = (?), `year` = (?), `price` = (?), `tax` = (?), `last_updated` = (?), `updatedby` = (?), `handling` = (?), `dealership` = (?), `type` = (?) WHERE `id` = (?);", vehID, brand, model, year, price, tax, timeNow[3], accountID, handlingData, dealership, vehType, libraryID)
	if (updated) then
		-- Reload all vehicles in the world using this vehicle library information.
		local toReload = 0
		local vehiclesToReload = exports.mysql:Query("SELECT `id` FROM `vehicles` WHERE `model` = (?) AND `deleted` <> 1 AND `handling` IS NULL;", libraryID)
		if (vehiclesToReload) then
			for i, veh in ipairs(vehiclesToReload) do
				local vehElement = exports.data:getElement("vehicle", veh.id)
				if (vehElement) then
					exports["vehicle-system"]:reloadVehicle(veh.id)
					exports.logs:addVehicleLog(veh.id, "[LIBRARY UPDATED] " .. thePlayerName .. " has updated this vehicle model.\nNew Model: (" .. libraryID .. ") " .. year .. " " .. brand .. " " .. model .. ".", thePlayer)
					toReload = toReload + 1
				end
			end
		end

		-- Outputs.
		outputChatBox("You have updated the vehicle (" .. libraryID .. ") " .. year .. " " .. brand .. " " .. model .. ", " .. toReload .. " vehicles have been effected.", thePlayer, 75, 230, 10)
		exports.global:sendMessage("[WARN] " .. thePlayerName .. " has updated vehicle #" .. libraryID .. " from the library, " .. toReload .. " vehicles have been reloaded.", 1, true)
		exports.logs:addLog(thePlayer, 18, thePlayer, "Updated vehicle #" .. libraryID .. " from the library, " .. toReload .. " vehicles effected.")
	else
		outputChatBox("ERROR: Failed to save to database.", thePlayer, 255, 0, 0)
	end
end
addEvent("vehicle:vehlist:updateLibraryVehicle", true)
addEventHandler("vehicle:vehlist:updateLibraryVehicle", root, updateLibraryVehicle)