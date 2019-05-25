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

local blackhawk = exports.blackhawk

function loadVehicle(vehicleID)
	if not tonumber(vehicleID) then exports.global:outputDebug("@loadVehicle: vehicleID not provided or is not a numerical value.") return false end
	
	local vehicleData = exports.mysql:QuerySingle("SELECT * FROM `vehicles` WHERE `id` = (?);", tonumber(vehicleID))
	
	-- Check to see if the vehicle exists.
	if not (vehicleData) then
		exports.global:outputDebug("@loadVehicle: Attempted to load vehicleID #" .. vehicleID .. " though vehicle does not exist.")
		return false
	end

	-- Get location and vehicle data to create vehicle.
	local locationTable = split(vehicleData.location, ",")
	local variantTable = split(vehicleData.variants, ",")
	local vehicleInfo, vehicleName = exports.global:getVehicleModelInfo(vehicleData.model)
	local x, y, z, rx, ry, rz = tonumber(locationTable[1]), tonumber(locationTable[2]), tonumber(locationTable[3]), tonumber(locationTable[4]), tonumber(locationTable[5]), tonumber(locationTable[6])
	-- Create the vehicle.
	local theVehicle = createVehicle(vehicleInfo.vehid, x, y, z, rx, ry, rz, vehicleData.plates, tonumber(variantTable[1]), tonumber(variantTable[2]))
	
	if (theVehicle) then
		exports.data:allocateElement(theVehicle, vehicleData.id) -- Allocate the vehicle element into data.
		
		-- Set basic vehicle crap.
		local colorTable = fromJSON(vehicleData.color)
		setElementDimension(theVehicle, vehicleData.dimension)
		setElementInterior(theVehicle, vehicleData.interior)
		setVehicleColor(theVehicle, colorTable[1], colorTable[2], colorTable[3], colorTable[4], colorTable[5], colorTable[6], colorTable[7], colorTable[8], colorTable[9], colorTable[10], colorTable[11], colorTable[12])
		setElementHealth(theVehicle, vehicleData.hp)

		-- If the vehicle is locked, lock it.
		if (vehicleData.locked == 1) then
			setVehicleLocked(theVehicle, true)
		end

		-- Set vehicle light state.
		local lightState = 2
		if (vehicleData.lights ~= 2) then lightState = 1 end
		setVehicleOverrideLights(theVehicle, lightState) -- Lights on.

		-- Set lights fixed/broken.
		local lightStates = fromJSON(vehicleData.headlightStates)
		setVehicleLightState(theVehicle, 0, lightStates[1]) -- Front left.
		setVehicleLightState(theVehicle, 1, lightStates[2]) -- Front right.
		setVehicleLightState(theVehicle, 2, lightStates[3]) -- Rear right.
		setVehicleLightState(theVehicle, 3, lightStates[4]) -- Rear left.

		-- Set engine state.
		if (vehicleData.engine == 1) then
			setVehicleEngineState(theVehicle, true)
		else
			setVehicleEngineState(theVehicle, false)
		end

		local stateTable = split(vehicleData.state, ",")
		if (tonumber(stateTable[1]) == 1) then
			-- If vehicle is stolen. - Do something here @Skully
		end
		if (tonumber(stateTable[2]) == 1) then
			-- If vehicle is chopped. - Do something here @Skully
		end

		-- Set wheel states.
		local wheelStates = fromJSON(vehicleData.wheelStates)
		setVehicleWheelStates(theVehicle, wheelStates[1], wheelStates[2], wheelStates[3], wheelStates[4])

		-- Set vehicle door states.
		local doorStates = fromJSON(vehicleData.doorStates)
		setVehicleDoorState(theVehicle, 0, doorStates[1])
		setVehicleDoorState(theVehicle, 1, doorStates[2])
		setVehicleDoorState(theVehicle, 2, doorStates[3])
		setVehicleDoorState(theVehicle, 3, doorStates[4])
		setVehicleDoorState(theVehicle, 4, doorStates[5])
		setVehicleDoorState(theVehicle, 5, doorStates[6])

		-- Set vehicle panel states.
		local panelStates = fromJSON(vehicleData.panelStates)
		setVehiclePanelState(theVehicle, 0, panelStates[1])
		setVehiclePanelState(theVehicle, 1, panelStates[2])
		setVehiclePanelState(theVehicle, 2, panelStates[3])
		setVehiclePanelState(theVehicle, 3, panelStates[4])
		setVehiclePanelState(theVehicle, 4, panelStates[5])
		setVehiclePanelState(theVehicle, 5, panelStates[6])
		setVehiclePanelState(theVehicle, 6, panelStates[7])

		-- Add vehicle upgrades.
		local upgradesTable = fromJSON(vehicleData.upgrades)
		setVehicleHeadLightColor(theVehicle, upgradesTable[1], upgradesTable[2], upgradesTable[3])
		setVehiclePaintjob(theVehicle, upgradesTable[4])
		for i = 5, 20 do
			if (upgradesTable[i] ~= 0) then -- If its a vehicle upgrade.
				addVehicleUpgrade(theVehicle, upgradesTable[i])
			end
		end

		-- Load vehicle custom handling if it exists.
		local propertyTable = { "numberOfGears", "maxVelocity", "engineAcceleration", "engineInertia", "driveType", "engineType", "steeringLock", "collisionDamageMultiplier", "mass", "turnMass", "dragCoeff", "centerOfMass", "percentSubmerged", "animGroup", "seatOffsetDistance", "tractionMultiplier", "tractionLoss", "tractionBias", "brakeDeceleration", "brakeBias", "suspensionForceLevel", "suspensionDamping", "suspensionHighSpeedDamping", "suspensionUpperLimit", "suspensionLowerLimit", "suspensionAntiDiveMultiplier", "suspensionFrontRearBias"}
		local fallbackHandling = getOriginalHandling(vehicleInfo.vehid)
		local handlingData = false
		if (vehicleData.handling) then -- If vehicle has custom handling.
			handlingData = fromJSON(vehicleData.handling)
		else -- Otherwise load handling from vehicle model.
			handlingData = fromJSON(vehicleInfo.handling)
		end

		-- If handling from database isn't valid, use default GTA.
		if not (handlingData) then
			handlingData = fallbackHandling
			exports.global:outputDebug("@loadVehicle: Handling data for vehicle #" .. vehicleData.id .. " is invalid, using default GTA values.", 2)
		end

		for i, property in ipairs(propertyTable) do
			setVehicleHandling(theVehicle, property, handlingData[i])
		end

		-- Set vehicle fuel consumption.
		blackhawk:setElementDataEx(theVehicle, "fuel:consumption", tonumber(handlingData[28]), true)

		-- Add vehicle siren. @requires item-system @requires pd-system
		-- Set windows tinted. @requires vehicle-system
		-- Insert vehicle items. @requires item-system
		
		-- Set vehicle description.
		local platesParsed = fromJSON(vehicleData.description)
		blackhawk:setElementDataEx(theVehicle, "vehicle:description", platesParsed, true)

		-- Set vehicle textures. @requires texture-system
		
		-- If vehicle has a broken engine.
		if (vehicleData.broken_engine == 1) then
			setElementHealth(theVehicle, 300) -- Damage HP.
			blackhawk:setElementDataEx(theVehicle, "vehicle:brokenengine", 1, true)
		end

		-- If vehicle is damage proof.
		if (vehicleData.damageproof == 1) then
			setVehicleDamageProof(theVehicle, true)
		end

		-- Begin setting elementData.
		blackhawk:setElementDataEx(theVehicle, "vehicle:id", tonumber(vehicleData.id), true)
		if (vehicleData.faction ~= 0) then
			blackhawk:setElementDataEx(theVehicle, "vehicle:owner", tonumber(-vehicleData.faction), true)

			local factionName = exports.global:getFactionName(vehicleData.faction)
			blackhawk:setElementDataEx(theVehicle, "vehicle:ownername", factionName, true)
		else
			blackhawk:setElementDataEx(theVehicle, "vehicle:owner", tonumber(vehicleData.owner), true)

			local characterName = exports.global:getCharacterNameFromID(vehicleData.owner)
			blackhawk:setElementDataEx(theVehicle, "vehicle:ownername", characterName, true)
		end
		blackhawk:setElementDataEx(theVehicle, "vehicle:vehid", tonumber(vehicleData.model), true)
		blackhawk:setElementDataEx(theVehicle, "vehicle:engine", tonumber(vehicleData.engine), true)
		blackhawk:setElementDataEx(theVehicle, "vehicle:windows", tonumber(vehicleData.windows), true)
		blackhawk:setElementDataEx(theVehicle, "vehicle:windowtint", tonumber(vehicleData.windowtint), true)
		blackhawk:setElementDataEx(theVehicle, "vehicle:brokenengine", tonumber(vehicleData.broken_engine), true)
		blackhawk:setElementDataEx(theVehicle, "vehicle:impounded", tonumber(vehicleData.impounded), true)
		blackhawk:setElementDataEx(theVehicle, "vehicle:handbrake", tonumber(vehicleData.handbrake), true)
		blackhawk:setElementDataEx(theVehicle, "vehicle:states", vehicleData.state, true)
		blackhawk:setElementDataEx(theVehicle, "vehicle:showplates", tonumber(vehicleData.show_plates), true)
		blackhawk:setElementDataEx(theVehicle, "vehicle:showvin", tonumber(vehicleData.show_vin), true)
		blackhawk:setElementDataEx(theVehicle, "vehicle:job", tonumber(vehicleData.job), true)
		blackhawk:setElementDataEx(theVehicle, "vehicle:respawnpos", {x, y, z, rx, ry, rz}, true)
		blackhawk:setElementDataEx(theVehicle, "vehicle:fuel", tonumber(vehicleData.fuel), true)
		blackhawk:setElementDataEx(theVehicle, "vehicle:dimension", tonumber(vehicleData.dimension), false)
		blackhawk:setElementDataEx(theVehicle, "vehicle:interior", tonumber(vehicleData.interior), false)
		blackhawk:setElementDataEx(theVehicle, "vehicle:type", tonumber(vehicleInfo.type), true)
		blackhawk:setElementDataEx(theVehicle, "vehicle:lights", tonumber(vehicleInfo.lights), true)
		blackhawk:setElementDataEx(theVehicle, "vehicle:name", vehicleName, true)
		blackhawk:setElementDataEx(theVehicle, "vehicle:factionperms", vehicleData.faction_perms, true)
		setElementData(theVehicle, "vehicle:mileage", tonumber(vehicleData.odometer), true)

		
		-- Freeze vehicle if handbraked.
		setElementFrozen(theVehicle, getElementData(theVehicle, "vehicle:handbrake") == 1)

		-- If it's a job vehicle.
		if (tonumber(vehicleData.job) ~= 0) then
			toggleVehicleRespawn(theVehicle, true)
			setVehicleRespawnDelay(theVehicle, 60000) -- Respawn vehicle after 60 seconds if it blows up.
			setVehicleIdleRespawnDelay(theVehicle, 900000) -- Respawn the vehicle after 15 minutes if it's unused.
		end

		setVehicleRespawnPosition(theVehicle, tonumber(locationTable[1]), tonumber(locationTable[2]), tonumber(locationTable[3]), tonumber(locationTable[4]), tonumber(locationTable[5]), tonumber(locationTable[6]))
		return theVehicle
	else
		exports.global:outputDebug("@loadVehicle: Failed to create vehicle element for vehicle ID " .. vehicleData.id .. ".")
		return false
	end
end

function saveVehicle(vehicleID)
	if not tonumber(vehicleID) then exports.global:outputDebug("@saveVehicle: vehicleID not provided or is not a numerical value.") return false end
	vehicleID = tonumber(vehicleID)
	if (vehicleID) == 0 then return end -- Avoid attempting to save temporary vehicles.
	
	local vehicleData = exports.mysql:QuerySingle("SELECT * FROM `vehicles` WHERE `id` = (?);", tonumber(vehicleID))
	
	-- Check to see if the vehicle exists.
	if not (vehicleData) then
		exports.global:outputDebug("@saveVehicle: Attempted to save vehicleID #" .. vehicleID .. " though vehicle does not exist in database.")
		return false
	end

	-- Check if the vehicle element exists.
	local theVehicle = exports.data:getElement("vehicle", vehicleID)
	if not (theVehicle) then
		exports.global:outputDebug("@saveVehicle: Attempted to save vehicleID #" .. vehicleID .. " though vehicle element does not exist.")
		return false
	end

	local vehModel = getElementData(theVehicle, "vehicle:vehid")
	
	-- Save vehicle's /park location.
	local x, y, z, rx, ry, rz = unpack(getElementData(theVehicle, "vehicle:respawnpos"))
	local locationString
	if not (x) or not (y) or not (z) then
		locationString = vehicleData.location
	else
		locationString = x..","..y..","..z..","..rx..","..ry..","..rz
	end

	local dimension = getElementData(theVehicle, "vehicle:dimension") or 0
	local interior = getElementData(theVehicle, "vehicle:interior") or 0

	-- Save vehicle fuel. @requires fuel-system

	-- Save vehicle engine state.
	local engineState = getElementData(theVehicle, "vehicle:engine") or 0

	-- Save vehicle locked state.
	local lockState = isVehicleLocked(theVehicle)
	if (lockState) then lockState = 1 else lockState = 0 end

	-- Save vehicle light states.
	local lightState = getVehicleOverrideLights(theVehicle)

	-- Save vehicle siren. @requires item-system @requires pd-system
	
	local vehHP = getElementHealth(theVehicle)

	-- Save vehicle colours.
	local col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12 = getVehicleColor(theVehicle, true)
	local colorTable = toJSON({col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12})

	local vehPlates = getVehiclePlateText(theVehicle)

	-- Save vehicle owner.
	local vehOwner = getElementData(theVehicle, "vehicle:owner")
	local vehFaction = 0
	if (tonumber(vehOwner) < 0) then -- If it is faction owned.
		vehFaction = -vehOwner
		vehOwner = 0
	end

	local windowState = getElementData(theVehicle, "vehicle:windows")
	local brokenEngineState = getElementData(theVehicle, "vehicle:brokenengine")
	-- Save vehicle window tint. @requires vehicle-system
	-- Save vehicle items. @requires item-system
	-- Save vehicle impounded state. @requires pd-system
	local vehicleHandbrake = getElementData(theVehicle, "vehicle:handbrake")

	-- Save vehicle upgrades. // Find a more efficient way to do this with getVehicleUpgrades, this is fucking cancer @Skully
	local lightr, lightg, lightb = getVehicleHeadLightColor(theVehicle)
	local vehPaintJob = getVehiclePaintjob(theVehicle)
	local upgradesTable = {lightr, lightg, lightb, vehPaintJob}
	
	for i = 0, 16 do
		table.insert(upgradesTable, getVehicleUpgradeOnSlot(theVehicle, i))
	end
	local parsedUpgradesTable = toJSON(upgradesTable)

	-- Save vehicle wheel states.
	local wheel1, wheel2, wheel3, wheel4 = getVehicleWheelStates(theVehicle)
	local wheelStateTable = toJSON({wheel1, wheel2, wheel3, wheel4})

	-- Save vehicle panel states.
	local panelTable = {}

	for i = 0, 6 do
		table.insert(panelTable, getVehiclePanelState(theVehicle, i))
	end
	local parsedPanelTable = toJSON(panelTable)

	-- Save vehicle door states.
	local doorsTable = {}
	for i = 0, 5 do
		table.insert(doorsTable, getVehicleDoorState(theVehicle, i))
	end
	local parsedDoorsTable = toJSON(doorsTable)

	-- Save vehicle headlight states.
	local headlightTable = {}
	for i = 0, 3 do
		table.insert(headlightTable, getVehicleLightState(theVehicle, i))
	end
	local parsedHeadlightTable = toJSON(headlightTable)

	-- Save odometer.
	local vehOdometer = getElementData(theVehicle, "vehicle:mileage")

	-- Save variants.
	local var1, var2 = getVehicleVariant(theVehicle)
	local variantString = var1 .. "," .. var2

	local vehicleDescription = getElementData(theVehicle, "vehicle:description")
	vehicleDescription = toJSON(vehicleDescription)

	-- Save vehicle states.
	local vehicleStates = getElementData(theVehicle, "vehicle:states")

	-- Save vehicle plates/VIN state.
	local showPlates = getElementData(theVehicle, "vehicle:showplates") or 1
	local showVIN = getElementData(theVehicle, "vehicle:showvin") or 1

	-- Save vehicle damageproof state.
	local damageproof = isVehicleDamageProof(theVehicle)
	if (damageproof) then damageproof = 1 else damageproof = 0 end

	local vehTextures = "[ [ ] ]" -- Save vehicle textures. @requires texture-system
	local factionPerms = getElementData(theVehicle, "vehicle:factionperms") or "[ [ ] ]"

	local saved = exports.mysql:Execute(
		"UPDATE `vehicles` SET `model` = (?), `location` = (?), `dimension` = (?), `interior` = (?), `fuel` = '100', `engine` = (?),  `locked` = (?), `lights` = (?), `siren` = '0', `hp` = (?),  `color` = (?), `plates` = (?), `faction` = (?), `owner` = (?), `windows` = (?), `windows_tinted` = '0', `broken_engine` = (?), `items` = '', `impounded` = '0', `handbrake` = (?), `upgrades` = (?), `wheelStates` = (?), `panelStates` = (?), `doorStates` = (?), `headlightStates` = (?), `odometer` = (?), `variants` = (?), `description` =  (?), `state` = (?), `show_plates` = (?), `show_vin` = (?), `damageproof` = (?), `textures` = (?), `faction_perms` = (?) WHERE `id` = (?);",
		vehModel, locationString, dimension, interior, engineState, lockState, lightState, vehHP, colorTable, vehPlates, vehFaction, vehOwner, windowState, brokenEngineState, vehicleHandbrake, parsedUpgradesTable, wheelStateTable, parsedPanelTable, parsedDoorsTable, parsedHeadlightTable, vehOdometer, variantString, vehicleDescription, vehicleStates, showPlates, showVIN, damageproof, vehTextures, factionPerms, vehicleID)
	if not (saved) then
		exports.global:outputDebug("@saveVehicle: Failed to save vehicle ID #" .. vehicleID .. ", is there an active database connection?")
		return false
	end
	return true
end

-- Reloads the specified vehicle.
function reloadVehicle(vehicleID)
	if not tonumber(vehicleID) then exports.global:outputDebug("@saveVehicle: vehicleID not provided or is not a numerical value.") return false end
	vehicleID = tonumber(vehicleID)

	-- Check to see if the vehicle exists.
	local theVehicle = exports.data:getElement("vehicle", vehicleID)
	local skipSave = false

	-- If the vehicle element doesn't exist, we don't want to save it before loading it again,
	if not (theVehicle) then
		local vehExists = exports.mysql:QueryString("SELECT `deleted` FROM `vehicles` WHERE `id` = (?);", vehicleID)
		if (vehExists) then
			if (tonumber(vehExists) == 1) then
				return false, "You cannot reload a vehicle that is deleted!"
			end

			skipSave = true
		else
			return false, "A vehicle with that ID does not exist!"
		end
	end

	-- Stop radio if playing.
	triggerClientEvent("radio:stopVehicleSounds", theVehicle, theVehicle)
	if not (skipSave) then
		saveVehicle(vehicleID)
		destroyElement(theVehicle)
	end

	local loaded = loadVehicle(vehicleID)
	return loaded, "Failed to load vehicle."
end

function saveAllVehicles()
	local allVehicles = exports.data:getDataElementsByType("vehicle")
	local leftToSave = #allVehicles

	local delay = 50
	for i, vehicle in ipairs(allVehicles) do
		local vehID = getElementData(vehicle, "vehicle:id")
		if (vehID) then
			setTimer(saveVehicle, delay, 1, vehID)
		end
		delay = delay + 50

		leftToSave = leftToSave - 1
		if (leftToSave == 0) then return true end
	end
end

-- Loads all vehicles from database onResourceStart.
function loadAllVehicles()
	local allVehicles = exports.mysql:Query("SELECT id FROM `vehicles` WHERE `deleted` = 0 ORDER BY `id` ASC;")
	if not (allVehicles) or not (allVehicles[1]) then return end

	local delay = 50
	for index, vehicle in ipairs(allVehicles) do
		setTimer(loadVehicle, delay, 1, tonumber(vehicle.id))
		delay = delay + 50
	end

	exports.global:outputDebug("Loading " .. #allVehicles .. " vehicles, estimated time to load: " .. (delay/1000) .. " seconds.", 3)
end
addEventHandler("onResourceStart", resourceRoot, loadAllVehicles)