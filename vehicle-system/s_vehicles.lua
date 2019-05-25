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

-- Force bind keys.
function bindKeys()
	local allPlayers = exports.data:getDataElementsByType("player")
	for i, thePlayer in ipairs(allPlayers) do
		if not(isKeyBound(thePlayer, "j", "down", toggleVehicleEngine)) then
			bindKey(thePlayer, "j", "down", toggleVehicleEngine)
		end
		if not(isKeyBound(thePlayer, "z", "down", toggleSeatbelt)) then
			bindKey(thePlayer, "z", "down", toggleSeatbelt)
		end
		if not(isKeyBound(thePlayer, "x", "down", toggleVehicleWindows)) then
			bindKey(thePlayer, "x", "down", toggleVehicleWindows)
		end
		if not(isKeyBound(thePlayer, "l", "down", toggleVehicleLights)) then
			bindKey(thePlayer, "l", "down", toggleVehicleLights)
		end
		if not(isKeyBound(thePlayer, "k", "down", toggleVehicleLock)) then
			bindKey(thePlayer, "k", "down", toggleVehicleLock)
		end
	end
end
addEventHandler("onResourceStart", resourceRoot, bindKeys)

function bindKeysOnJoin()
	bindKey(source, "j", "down", toggleVehicleEngine)
	bindKey(source, "z", "down", toggleSeatbelt)
	bindKey(source, "x", "down", toggleVehicleWindows)
	bindKey(source, "l", "down", toggleVehicleLights)
	bindKey(source, "k", "down", toggleVehicleLock)

end
addEventHandler("onPlayerJoin", root, bindKeysOnJoin)

-- Things to do when a player exists a vehicle.
function vehicleExitEvents(thePlayer)
	local vehID = getElementData(source, "vehicle:id")
	if (vehID) then
		-- Save the vehicle.
		saveVehicle(vehID)
	end
	toggleControl(thePlayer, "brake_reverse", true)
end
addEventHandler("onVehicleExit", root, vehicleExitEvents)

-- Things to do when a player enters a vehicle.
function vehicleEnterEvents(thePlayer)
	local vehID = getElementData(source, "vehicle:id")
	if (vehID) then
		-- Set player's oldcar ID.
		setElementData(thePlayer, "character:oldcar", tonumber(vehID))
	end
end
addEventHandler("onVehicleEnter", root, vehicleEnterEvents)

-------------------------------------------------------------------------------------------------------------------
--											VEHICLE ENGINE EVENTS
-------------------------------------------------------------------------------------------------------------------

-- /engine - By Skully (20/05/18) [Player]
function toggleVehicleEngine(thePlayer)
	local theVehicle = getPedOccupiedVehicle(thePlayer)
	local realInVehicle = getElementData(thePlayer, "character:invehicle")
	if (theVehicle) and (realInVehicle) then
		-- Check if the player is in the driver seat.
		local theVehicleSeat = getPedOccupiedVehicleSeat(thePlayer)
		if (theVehicleSeat) == 0 then

			-- Ensure the vehicle has an engine.
			local theVehicleModel = getElementModel(theVehicle)
			if not (g_enginelessVehicle[theVehicleModel]) then

				-- Check if the player can start the engine.
				local canStartVehicle = false
				local isFactionVehicle = getElementData(theVehicle, "vehicle:owner") or 0
				if (isFactionVehicle < 0) then
					isFactionVehicle = -isFactionVehicle
					if (exports.global:hasPlayerFactionVehiclePermission(thePlayer, theVehicle)) then
						canStartVehicle = true
					end
				else
					local hasVehicleKey = false -- Check to see if player has vehicle key or if key is in the vehicle inventory. @requires item-system
					if (hasVehicleKey) then
						canStartVehicle = true
					end
				end

				if (canStartVehicle) or exports.global:isPlayerHelper(thePlayer) then
					local engineState = getElementData(theVehicle, "vehicle:engine") or 0
					if (engineState == 0) then -- If engine is off, attempt to start.
						local brokenEngine = getElementData(theVehicle, "vehicle:brokenengine") or 0
						local vehicleFuel = getElementData(theVehicle, "vehicle:fuel") or 0
						local theVehicleID = getElementData(theVehicle, "vehicle:id") or 0
						local startingEngine = getElementData(theVehicle, "temp:vehicle:enginestart")
						local isTail = false
						if (brokenEngine == 1) or (vehicleFuel <= 0) and (theVehicleID ~= 0) then
							isTail = true
							if (startingEngine) then return false end -- If vehicle engine is already starting up.
							setElementData(theVehicle, "temp:vehicle:enginestart", true, false)
							triggerEvent("rp:sendAme", thePlayer, "attempts to start the vehicle engine.")
							local _, vehicleName = exports.global:getVehicleInfo(theVehicle)
							setTimer(function()
								removeElementData(theVehicle, "temp:vehicle:enginestart")
								triggerEvent("rp:sendLocalRP", theVehicle, theVehicle, "do", "The vehicle engine fails to start. (( " .. vehicleName .. " ))")
							end, 2500, 1)
						end
						
						local nearbyPlayers = exports.global:getNearbyElements(theVehicle, "player", 20)
						for i, player in ipairs(nearbyPlayers) do
							triggerClientEvent(player, "vehicle:startEngineSound", player, theVehicle, isTail)
						end
					else -- If engine is on, turn it off.
						toggleControl(thePlayer, "brake_reverse", false)
						setVehicleEngineState(theVehicle, false)
						setElementData(theVehicle, "vehicle:engine", 0)
					end
				else
					outputChatBox("You don't have the keys to start this vehicle.", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addEvent("vehicle:toggleVehicleEngine", true)
addEventHandler("vehicle:toggleVehicleEngine", root, toggleVehicleEngine)
addCommandHandler("engine", toggleVehicleEngine)

function startEngineCall(thePlayer, theVehicle)
	toggleControl(thePlayer, "brake_reverse", true)
	setVehicleEngineState(theVehicle, true)
	exports.blackhawk:setElementDataEx(theVehicle, "vehicle:engine", 1)
	exports.logs:addVehicleLog(theVehicle, "[ENGINE START] " .. getPlayerName(thePlayer):gsub("_", " ") .. " started vehicle engine.", thePlayer)
end
addEvent("vehicle:startEngineCall", true)
addEventHandler("vehicle:startEngineCall", root, startEngineCall)

-- RealInVehicle functions - updates element data of player when they are actually inside a vehicle.
function setPlayerRealInVehicle(thePlayer)
	if isVehicleLocked(source) then
		exports.blackhawk:changeElementDataEx(thePlayer, "character:invehicle", false)
		removePedFromVehicle(thePlayer)
	else
		local engineState = getElementData(source, "vehicle:engine")
		if (engineState == 1) then
			setVehicleEngineState(source, true)
		end
		exports.blackhawk:changeElementDataEx(thePlayer, "character:invehicle", true)
	end
end
addEventHandler("onVehicleEnter", root, setPlayerRealInVehicle)

function setRealNotInVehicle(thePlayer)
	local locked = isVehicleLocked(source)

	if not (locked) then
		if (thePlayer) then
			exports.blackhawk:changeElementDataEx(thePlayer, "character:invehicle", false)
		end
	end
end
addEventHandler("onVehicleStartExit", root, setRealNotInVehicle)

function vehicleBreakdown()
	local health = getElementHealth(source)
	local brokenEngine = getElementData(source, "vehicle:brokenengine")

	if (health <= 350) and (brokenEngine == 0) then
		setElementHealth(source, 300)
		setVehicleDamageProof(source, true)
		setVehicleEngineState(source, false)
		exports.blackhawk:changeElementDataEx(source, "vehicle:brokenengine", 1, false)
		exports.blackhawk:changeElementDataEx(source, "vehicle:engine", 0, false)

		local driver = getVehicleOccupant(source, 0)
		local vehicleID = getElementData(source, "vehicle:id")
		if driver then
			toggleControl(driver, "brake_reverse", false)
			exports.logs:addVehicleLog(vehicleID, "[VEHICLE BREAK] Vehicle broken by " .. getPlayerName(driver):gsub("_", " ") .. ".", driver)
		else
			exports.logs:addVehicleLog(vehicleID, "[VEHICLE BREAK] Vehicle has broken.")
		end
	end
end
addEventHandler("onVehicleDamage", root, vehicleBreakdown)

-------------------------------------------------------------------------------------------------------------------
--												VEHICLE SEATBELT
-------------------------------------------------------------------------------------------------------------------

noBeltVehicles = {[431] = true, [437] = true}

-- /seatbelt - By Skully (20/05/18) [Player]
function toggleSeatbelt(thePlayer)
	local theVehicle = getPedOccupiedVehicle(thePlayer)
	local realInVehicle = getElementData(thePlayer, "character:invehicle")
	if (theVehicle) and (realInVehicle) then
		if (getVehicleType(theVehicle) == "BMX") or (getVehicleType(theVehicle) == "Bike") or (noBeltVehicles[getElementModel(theVehicle)]) then
			outputChatBox("There's no seatbelts in this vehicle.", thePlayer, 2550, 0, 0)
		else
			if (getElementData(thePlayer, "character:seatbelt") == true) then
				exports.blackhawk:changeElementDataEx(thePlayer, "character:seatbelt", false, true)
				triggerEvent("rp:sendAme", thePlayer, "unbuckles their seatbelt.")
			else
				exports.blackhawk:changeElementDataEx(thePlayer, "character:seatbelt", true, true)
				triggerEvent("rp:sendAme", thePlayer, "buckles their seatbelt.")
			end
		end
	end
end
addCommandHandler("belt", toggleSeatbelt)
addCommandHandler("seatbelt", toggleSeatbelt)

function removeSeatBelt(thePlayer)
	local seatbelt = getElementData(thePlayer, "character:seatbelt")
	if (seatbelt) then
		exports.blackhawk:changeElementDataEx(thePlayer, "character:seatbelt", false, true)
		triggerEvent("rp:sendAme", thePlayer, "unbuckles their seatbelt.")
	end
end
addEventHandler("onVehicleStartExit", root, removeSeatBelt)

-------------------------------------------------------------------------------------------------------------------
--												VEHICLE WINDOWS
-------------------------------------------------------------------------------------------------------------------

-- /windows - By Skully (20/05/18) [Helper]
function toggleVehicleWindows(thePlayer)
	if not (thePlayer) then thePlayer = source end

	local theVehicle = getPedOccupiedVehicle(thePlayer)
	local realInVehicle = getElementData(thePlayer, "character:invehicle")
	if (theVehicle) and (realInVehicle) then
		if (vehicleHasWindows(theVehicle)) then
			if (getVehicleOccupant(theVehicle) == thePlayer) or (getVehicleOccupant(theVehicle, 1) == thePlayer) then
				local windowState = getElementData(theVehicle, "vehicle:windows") or 0
				if (windowState == 1) then -- Windows are open.
					exports.blackhawk:changeElementDataEx(theVehicle, "vehicle:windows", 0, true)
					triggerClientEvent(thePlayer, "vehicle:toggleWindowsClient", thePlayer, theVehicle, false)
					triggerEvent("rp:sendAme", thePlayer, "rolls up the windows.")
				else -- Windows are closed.
					exports.blackhawk:changeElementDataEx(theVehicle, "vehicle:windows", 1, true)
					triggerClientEvent(thePlayer, "vehicle:toggleWindowsClient", thePlayer, theVehicle, true)
					triggerEvent("rp:sendAme", thePlayer, "rolls the windows down.")
				end
			end
		end
	end
end
addCommandHandler("windows", toggleVehicleWindows)
addCommandHandler("togwindows", toggleVehicleWindows)
addEvent("vehicle:toggleWindow", true)
addEventHandler("vehicle:toggleWindow", root, toggleVehicleWindows)

-------------------------------------------------------------------------------------------------------------------
--												VEHICLE LIGHTS
-------------------------------------------------------------------------------------------------------------------

-- /lights - By Skully (20/05/18) [Player]
function toggleVehicleLights(thePlayer)
	local theVehicle = getPedOccupiedVehicle(thePlayer)
	local realInVehicle = getElementData(thePlayer, "character:invehicle")

	if (theVehicle) and (realInVehicle) then
		if not g_lightlessVehicle[getElementModel(theVehicle)] then
			local lights = getVehicleOverrideLights(theVehicle)
			local seat = getPedOccupiedVehicleSeat(thePlayer)

			if (seat == 0) then
				if (lights ~= 2) then
					setVehicleOverrideLights(theVehicle, 2)
					exports.blackhawk:changeElementDataEx(theVehicle, "vehicle:lights", 1, true)
					local trailer = getVehicleTowedByVehicle(theVehicle)
					if (trailer) then
						setVehicleOverrideLights(trailer, 2)
					end
				elseif (lights ~= 1) then
					setVehicleOverrideLights(theVehicle, 1)
					exports.blackhawk:changeElementDataEx(theVehicle, "vehicle:lights", 0, true)
					local trailer = getVehicleTowedByVehicle(theVehicle)
					if (trailer) then
						setVehicleOverrideLights(trailer, 1)
					end
				end
			end
		end
	end
end
addCommandHandler("lights", toggleVehicleLights)

-------------------------------------------------------------------------------------------------------------------
--											VEHICLE LOCK
-------------------------------------------------------------------------------------------------------------------

function checkBikeLock(thePlayer)
	if (isVehicleLocked(source)) and (getVehicleType(source) == "Bike" or getVehicleType(source) == "Boat" or getVehicleType(source) == "BMX" or getVehicleType(source) == "Quad" or getElementModel(source) == 568 or getElementModel(source) == 571 or getElementModel(source) == 572 or getElementModel(source) == 424 or getElementModel(source) == 431 or getElementModel(source) == 437) then
		outputChatBox("That vehicle is locked.", thePlayer, 255, 0, 0)
		cancelEvent()
	end
end
addEventHandler("onVehicleStartEnter", root, checkBikeLock)


-- Prevent exitting vehicle from inside if door is locked.
function checkVehicleLocked(thePlayer, seat, jacked)
	local locked = isVehicleLocked(source)

	if (locked) and not (jacked) then
		cancelEvent()
		outputChatBox("The door is locked.", thePlayer, 255, 0, 0)
	end
end
addEventHandler("onVehicleStartExit", root, checkVehicleLocked)

-- /lock - By Skully (20/05/18) [Player]
function toggleVehicleLock(thePlayer)
	local theVehicle = getPedOccupiedVehicle(thePlayer)
	local inVehicle = getElementData(thePlayer, "character:invehicle")

	if (theVehicle) and (inVehicle) then
		triggerEvent("vehicle:toggleVehicleLockInside", thePlayer, theVehicle)
	elseif not (theVehicle) then
		local x, y, z = getElementPosition(thePlayer)
		local nearbyVehicles = exports.global:getNearbyElements(thePlayer, "vehicle", 30)
		local found = false
		local shortest = 31

		for i, veh in ipairs(nearbyVehicles) do
			local distanceToVehicle = getDistanceBetweenPoints3D(x, y, z, getElementPosition(veh))
			local canOpenVehicle = false
			local hasVehicleKeys = true
			if hasVehicleKeys then
				canOpenVehicle = true -- Check to see if player has vehicle key. @requires item-system
			end
			if not canOpenVehicle then -- If player doesn't have key.
				if (getElementData(veh, "vehicle:owner") < 0) then -- If vehicle is faction owned.
					if exports.global:hasPlayerFactionVehiclePermission(thePlayer, veh) then
						canOpenVehicle = true
					end
				end
			end

			local staffOverride = false
			if not (canOpenVehicle) then
				if exports.global:isPlayerHelper(thePlayer) then
					staffOverride = true
					canOpenVehicle = true
				end
			end
			if shortest > distanceToVehicle and canOpenVehicle then
				shortest = distanceToVehicle
				found = veh
			end
		end
		if (found) then
			triggerEvent("vehicle:toggleVehicleLockOutside", thePlayer, found, staffOverride)
		end
	end
end
addCommandHandler("lockveh", toggleVehicleLock)

function toggleVehicleLockInside(theVehicle, staffOverride)
	if not g_locklessVehicle[getElementModel(theVehicle)] then
		local locked = isVehicleLocked(theVehicle)
		local seat = getPedOccupiedVehicleSeat(source)
		if (seat == 0) then
			if (locked) then
				setVehicleLocked(theVehicle, false)
				triggerEvent("rp:sendAme", source, "unlocks the vehicle doors.")
				if (staffOverride) then
					local thePlayerName = exports.global:getStaffTitle(source, 1)
					exports.logs:addVehicleLog(theVehicle, "[STAFF-UNLOCK] " .. thePlayerName .. " unlocked from inside.", source)
				else
					exports.logs:addVehicleLog(theVehicle, "[UNLOCK] " .. getPlayerName(source):gsub("_", " ") .. " unlocked from inside.", source)
				end
				playCarLockToggleFx(theVehicle, false, true)
			else
				setVehicleLocked(theVehicle, true)
				setVehicleDoorState(theVehicle, 0, 0)
				setVehicleDoorState(theVehicle, 1, 0)
				setVehicleDoorState(theVehicle, 2, 0)
				setVehicleDoorState(theVehicle, 3, 0)
				setVehicleDoorState(theVehicle, 4, 0)
				setVehicleDoorState(theVehicle, 5, 0)
				triggerEvent("rp:sendAme", source, "locks the vehicle doors.")
				if (staffOverride) then
					local thePlayerName = exports.global:getStaffTitle(source, 1)
					exports.logs:addVehicleLog(theVehicle, "[STAFF-LOCK] " .. thePlayerName .. " locked from inside.", source)
				else
					exports.logs:addVehicleLog(theVehicle, "[LOCK] " .. getPlayerName(source):gsub("_", " ") .. " locked from inside.", source)
				end
				playCarLockToggleFx(theVehicle, true, true)
			end
		end
	end
end
addEvent("vehicle:toggleVehicleLockInside", true)
addEventHandler("vehicle:toggleVehicleLockInside", root, toggleVehicleLockInside)

function toggleVehicleLockOutside(theVehicle, staffOverride)
	local theVehicleName = getElementData(theVehicle, "vehicle:name")
	if isVehicleLocked(theVehicle) then
		setVehicleLocked(theVehicle, false)
		triggerEvent("rp:sendAme", source, "unlocks the vehicle. (( " .. theVehicleName .. " ))")
		if (staffOverride) then
			local thePlayerName = exports.global:getStaffTitle(source)
			exports.logs:addVehicleLog(theVehicle, "[STAFF-UNLOCK] " .. thePlayerName .. " unlocked from outside.", source)
		else
			exports.logs:addVehicleLog(theVehicle, "[UNLOCK] " .. getPlayerName(source):gsub("_", " ") .. " unlocked from outside.", source)
		end
		playCarLockToggleFx(theVehicle, false, false)
	else
		-- This repairs the vehicle doors when unlocked, needs to be adjusted. #481
		setVehicleLocked(theVehicle, true)
		setVehicleDoorState(theVehicle, 0, 0)
		setVehicleDoorState(theVehicle, 1, 0)
		setVehicleDoorState(theVehicle, 2, 0)
		setVehicleDoorState(theVehicle, 3, 0)
		setVehicleDoorState(theVehicle, 4, 0)
		setVehicleDoorState(theVehicle, 5, 0)
		triggerEvent("rp:sendAme", source, "locks the vehicle. (( " .. theVehicleName .. " ))")
		if (staffOverride) then
			local thePlayerName = exports.global:getStaffTitle(source, 1)
			exports.logs:addVehicleLog(theVehicle, "[STAFF-LOCK] " .. thePlayerName .. " locked from inside.", source)
		else
			exports.logs:addVehicleLog(theVehicle, "[LOCK] " .. getPlayerName(source):gsub("_", " ") .. " locked from inside.", source)
		end
		playCarLockToggleFx(theVehicle, true, false)
	end
end
addEvent("vehicle:toggleVehicleLockOutside", true)
addEventHandler("vehicle:toggleVehicleLockOutside", root, toggleVehicleLockOutside)

function playCarLockToggleFx(theVehicle, lockState, insideVehicle)
	if getVehicleType(theVehicle) == "Automobile" then
		if insideVehicle then
			for i = 0, getVehicleMaxPassengers(theVehicle) do
				local player = getVehicleOccupant(theVehicle, i)
				if (player) then
					triggerClientEvent(player, "vehicle:playerCarLockToggleFx", player, lockState)
				end
			end
		else
			flashSpeed = 500
			setVehicleOverrideLights(theVehicle, 1)
			setTimer(setVehicleOverrideLights, flashSpeed, 1, theVehicle, 2)
			setTimer(setVehicleOverrideLights, flashSpeed * 2, 1, theVehicle, 1)
			local x, y, z = getElementPosition(theVehicle)
			local theVehicleInterior = getElementInterior(theVehicle)
			local theVehicleDimension = getElementDimension(theVehicle)
			triggerClientEvent("vehicle:playerCarLockToggleFxOutside", resourceRoot, {x, y, z, theVehicleInterior, theVehicleDimension})
		end
	end
end