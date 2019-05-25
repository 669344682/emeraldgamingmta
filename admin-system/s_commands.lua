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

Copyright of the Emerald Gaming Development Team, do not distribute - All rights reserved. ]]

blackhawk = exports.blackhawk
global = exports.global

-- /sethp [Player/ID] [Health (1-100)] - by Skully (18/06/17) [Helper]
function setPlayerHealth(thePlayer, commandName, targetPlayer, health)
	if exports.global:isPlayerHelper(thePlayer) then
		if not tonumber(health) or not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player/ID] [Health]", thePlayer, 75, 230, 10)
		else
			local targetPlayer, targetPlayerName = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)

			if (tonumber(health) <= 100) then
				if (targetPlayer) then
					local thePlayerAdminLevel = exports.global:getStaffLevel(thePlayer)
					local targetPlayerAdminLevel = exports.global:getStaffLevel(targetPlayer)
					local thePlayerTitle = exports.global:getStaffTitle(thePlayer, 1)
					local affectedElements = {thePlayer, targetPlayer}

					if (thePlayerAdminLevel >= targetPlayerAdminLevel) then
						setElementHealth(targetPlayer, health)
						outputChatBox("You have set " .. targetPlayerName .. "'s health to " .. health .. ".", thePlayer, 75, 230, 10)
						outputChatBox(thePlayerTitle .. " has set your health to " .. health .. ".", targetPlayer, 75, 230, 10)
						exports.logs:addLog(thePlayer, 1, affectedElements, "Set " .. targetPlayerName .. "'s health to " .. health .. ".")
					else
						outputChatBox("ERROR: You cannot set the health of an administrator with a greater rank!", thePlayer, 255, 0, 0)
					end
				end
			else
				outputChatBox("ERROR: Health value must not be greater than 100!", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("sethp", setPlayerHealth)

-- /setarmour [Player/ID] [Armour (1-100)] - by Skully (19/06/17) [Helper]
function setPlayerArmour(thePlayer, commandName, targetPlayer, armour)
	if exports.global:isPlayerHelper(thePlayer) then
		if not (targetPlayer) or not tonumber(armour) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player/ID] [0-100]", thePlayer, 75, 230, 10)
		else
			local targetPlayer, targetPlayerName = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)

			armour = tonumber(armour)
			if (armour < 0) or (armour > 100) then
				outputChatBox("ERROR: Armour value must be between 0 and 100!", thePlayer, 255, 0, 0)
			else
				if targetPlayer then
					local thePlayerName = exports.global:getStaffTitle(thePlayer)
					setPedArmor(targetPlayer, armour)
					outputChatBox("You have set " .. targetPlayerName .. "'s armour to " .. armour .. ".", thePlayer, 75, 230, 10)
					outputChatBox(thePlayerName .. " has set your armour to " .. armour .. ".", targetPlayer, 75, 230, 10)
					exports.logs:addLog(thePlayer, 1, {targetPlayer}, "Set " .. targetPlayerName .. "'s armor to " .. armour .. ".")
					exports.global:sendMessageToManagers("[INFO] " .. thePlayerName .. " has set " .. targetPlayerName .. "'s armour to " .. armour .. ".", true)
				end
			end
		end
	end
end
addCommandHandler("setarmour", setPlayerArmour)
addCommandHandler("setarmor", setPlayerArmour)

-- /rot [0-360] - by Skully (18/06/17) [Helper]
function setRot(thePlayer, commandName, rotation)
	if exports.global:isPlayerHelper(thePlayer) then
		if not tonumber(rotation) then -- if the input for rotation is not a number.
			outputChatBox("SYNTAX: /" .. commandName .. " [Rotation (0-360)]", thePlayer, 75, 230, 10)
		else
			local rotation = rotation -- yes zil we are keeping this because its a meme
			local theVehicle = getPedOccupiedVehicle(thePlayer)
			local affectedElements = {thePlayer}
			if (theVehicle) then -- Checks to see if the player is in a vehicle, so we can rotate the vehicle too.
				local rx, ry, rz = getElementRotation(theVehicle)
				setElementRotation(theVehicle, rx, ry, rotation)
				table.insert(affectedElements, theVehicle)
			else
				local rx, ry, rz = getElementRotation(thePlayer)
				setElementRotation(thePlayer, rx, ry, rotation)
			end
			exports.logs:addLog(thePlayer, 1, affectedElements, "Set rotation to " .. rotation)
		end
	end
end
addCommandHandler("rot", setRot)

-- /setdimension [Player/ID] [Dimension ID (0-65535)] - by Skully (18/06/17) [Trial Admin/Developer]
function setDimension(thePlayer, commandName, targetPlayer, dimension)
	if exports.global:isPlayerTrialAdmin(thePlayer) or exports.global:isPlayerDeveloper(thePlayer) then
		if not (targetPlayer) or not (dimension) or not tonumber(dimension) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player/ID] [Dimension ID (0-65535)]", thePlayer, 75, 230, 10)
		else
			dimension = tonumber(dimension)
			local targetPlayer, targetPlayerName = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)
			local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)

			if (dimension < 0) or (dimension >= 65535) then -- Prevents the player from setting dimension out of MTA's limits.
				outputChatBox("ERROR: Dimension ID must be between 0-65535.", thePlayer, 255, 0, 0)
			elseif (dimension == 22220) and not exports.global:isPlayerVehicleTeam(thePlayer, true) or not exports.global:isPlayerLeadAdmin(thePlayer, true) or not exports.global:isPlayerDeveloper(thePlayer, true) then
				outputChatBox("ERROR: This dimension is restricted to the Vehicle Team.", thePlayer, 255, 0, 0)
			else
				if (targetPlayer) then
					local state, affectedElements, reason = exports.global:elementEnterInterior(targetPlayer, false, false, dimension, false, true)

					if (state) then
						outputChatBox("You set " .. targetPlayerName .. "'s dimension to " .. dimension .. ".", thePlayer, 0, 255, 0)
						outputChatBox(thePlayerName .. " has set your dimension to " .. dimension .. ".", targetPlayer, 75, 230, 10)
						exports.logs:addLog(thePlayer, 1, affectedElements, "Set dimension of " .. targetPlayerName .. " to " .. dimension .. ".")
					else
						outputChatBox("ERROR: " .. reason, thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("setdimension", setDimension)
addCommandHandler("setdim", setDimension)

-- /setinterior [Player/ID] [Interior ID (0-255)] - by Skully (18/06/17) [Trial Admin/Developer]
function setInterior(thePlayer, commandName, targetPlayer, interior)
	if exports.global:isPlayerTrialAdmin(thePlayer) or exports.global:isPlayerDeveloper(thePlayer) then
		if not (targetPlayer) or not (interior) or not tonumber(interior) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player/ID] [Interior ID (0-255)]", thePlayer, 75, 230, 10)
		else
			interior = tonumber(interior)
			local targetPlayer, targetPlayerName = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)
			local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)

			if (interior < 0) or (interior > 255) then -- Prevents the player from setting interior out of MTA's limits.
				outputChatBox("ERROR: Interior ID must be between 0 and 255.", thePlayer, 255, 0, 0)
			else
				if (targetPlayer) then
					local state, affectedElements, reason = exports.global:elementEnterInterior(targetPlayer, false, false, false, interior, true)

					if (state) then
						outputChatBox("You set " .. targetPlayerName .. "'s interior to " .. interior .. ".", thePlayer, 0, 255, 0)
						outputChatBox(thePlayerName .. " has set your interior to " .. interior .. ".", targetPlayer, 75, 230, 10)
						exports.logs:addLog(thePlayer, 1, affectedElements, "Set interior of " .. targetPlayerName .. " to " .. interior .. ".")
					else
						outputChatBox("ERROR: " .. reason, thePlayer, 255, 0, 0)
					end
					
				end
			end
		end
	end
end
addCommandHandler("setinterior", setInterior)
addCommandHandler("setint", setInterior)

-- /setfightstyle [Player/ID] [Style] - by Skully (14/02/18) [Helper]
function setFightStyle(thePlayer, commandName, targetPlayer, style)
	if exports.global:isPlayerHelper(thePlayer) then
		if not (targetPlayer) or not tonumber(style) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player/ID] [Style ID]", thePlayer, 75, 230, 10)
			outputChatBox("1 = Standard Fighting, 2 = Boxing, 3 = Kung Fu, 4 = Kneehead, 5 = Grab Kick, 6 = Elbow Fighting.", thePlayer, 75, 230, 10)
		else
			local style = tonumber(style) -- converts the variable to a readable number.
			local targetPlayer, targetPlayerName = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)
			local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
			local affectedElements = {thePlayer, targetPlayer}

			local fightStyles = {
				[1] = {"Standard Fighting", 4},
				[2] = {"Boxing", 5},
				[3] = {"Kung Fu", 6},
				[4] = {"Kneehead", 7},
				[5] = {"Grab Kick", 15},
				[6] = {"Elbow Fighting", 16},
			}

			if (targetPlayer) and (getElementData(targetPlayer, "loggedin") == 1) then
				if (style < 1 or style > #fightStyles) then   -- added < 0 in case someone runs the command with a negative number, if that's even possible :)
					outputChatBox("ERROR: That is not a valid fightstyle ID!", thePlayer, 255, 0, 0, false)
				else
					setPedFightingStyle(targetPlayer, fightStyles[style][2])
					blackhawk:setElementDataEx(targetPlayer, "character:fightstyle", fightStyles[style][2], true)
					outputChatBox("You set ".. targetPlayerName .."'s fight style to ".. fightStyles[style][1] .. ".", thePlayer, 75, 230, 10)
					outputChatBox(thePlayerName .. " has changed your fight style to ".. fightStyles[style][1] .. ".", targetPlayer, 75, 230, 10)
					exports.logs:addLog(thePlayer, 1, affectedElements, "Changed " .. targetPlayerName .. "'s fighting style to " .. style .. ".")
				end
			end
		end
	end
end
addCommandHandler("setfightstyle", setFightStyle)
addCommandHandler("sfs", setFightStyle)

-- /kill [Player/ID] - by Zil (18/06/17) [Trial Admin]
-- [NOTE] This function is called killPlayerr on purpose with two 'r's because killPlayer is a MTA function.
function killPlayerr(thePlayer, commandName, targetPlayer)
	if exports.global:isPlayerTrialAdmin(thePlayer) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player/ID]", thePlayer, 75, 230, 10)
		else
			local targetPlayer = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)

			if (targetPlayer) and (getElementData(targetPlayer, "loggedin") == 1) then
				local thePlayerAdminLevel = exports.global:getStaffLevel(thePlayer)
				local targetPlayerAdminLevel = exports.global:getStaffLevel(targetPlayer)
				local thePlayerName = exports.global:getStaffTitle(thePlayer)
				local targetPlayerName = getPlayerName(targetPlayer); targetPlayerName = targetPlayerName:gsub("_", " ")
				
				if (thePlayerAdminLevel >= targetPlayerAdminLevel) then
					-- Kill the target.
					killPed(targetPlayer)

					-- Outputs.
					outputChatBox("You have killed " .. targetPlayerName .. ".", thePlayer, 75, 230, 10)
					exports.logs:addLog(thePlayer, 1, {thePlayer, targetPlayer}, thePlayerName .. " killed " .. targetPlayerName .. ".")
				else
					outputChatBox("One does not simply kill their superior.", thePlayer, 255, 0, 0)
					exports.global:sendMessageToManagers("[INFO] " .. thePlayerName .. " attempted to /kill " .. targetPlayerName .. ".")
				end
			end
		end
	end
end
addCommandHandler("kill", killPlayerr)

-- /aheal [Player/ID] - by Zil (18/06/17) [Helper]
function aheal(thePlayer, commandName, targetPlayer)
	if exports.global:isPlayerHelper(thePlayer) then
		if not (targetPlayer) then
			setElementHealth(thePlayer, 100)
			outputChatBox("You have been healed.", thePlayer, 75, 230, 10)
		else
			local targetPlayer = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)
			local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)

			if (targetPlayer) and (getElementData(targetPlayer, "loggedin") == 1) then
				local targetPlayerName = getPlayerName(targetPlayer); targetPlayerName = targetPlayerName:gsub("_", " ")
				local affectedElements = {thePlayer, targetPlayer}

				setElementHealth(targetPlayer, 100)
				outputChatBox(targetPlayerName .. " has been healed.", thePlayer, 75, 230, 10)
				outputChatBox("You have been healed by " .. thePlayerName ..".", targetPlayer, 75, 230, 10)
				exports.logs:addLog(thePlayer, 1, affectedElements, "Healed " .. targetPlayerName .. ".")
			end
		end
	end
end
addCommandHandler("aheal", aheal)

-- /disarm [Player/ID] - by Zil (19/06/17) [Trial Admin]
function disarm(thePlayer, commandName, targetPlayer)
	if exports.global:isPlayerTrialAdmin(thePlayer) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player/ID]", thePlayer, 75, 230, 10)
		else
			local targetPlayer = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)
			local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)

			if (targetPlayer) and (getElementData(targetPlayer, "loggedin") == 1) then
				local targetPlayerName = getPlayerName(targetPlayer); targetPlayerName = targetPlayerName:gsub("_", " ")
				local hasWeapon = getPedWeapon(targetPlayer) -- Check if the player has a weapon, returns the type of weapon the player has, otherwise 0.
				local thePlayerAdminLevel = exports.global:getStaffLevel(thePlayer)
				local targetPlayerAdminLevel = exports.global:getStaffLevel(targetPlayer)
				local affectedElements = {thePlayer, targetPlayer}

				if (thePlayerAdminLevel >= targetPlayerAdminLevel) then
					if (hasWeapon > 0) then -- If the player has a weapon in at least the 1st inventory slot.
						takeAllWeapons(targetPlayer) -- Take all weapons from the player.
						outputChatBox(thePlayerName .. " has taken away all of your weapons.", targetPlayer, 75, 230, 10)
						outputChatBox("You have disarmed " .. targetPlayerName .. ".", thePlayer, 75, 230, 10)

						exports.global:sendMessageToManagers("[INFO] " .. thePlayerName.. " has disarmed " .. targetPlayerName .. ".", true) -- Notifies all online staff of the change.
						exports.logs:addLog(thePlayer, 1, affectedElements, "Disarmed " .. targetPlayerName .. ".")
					else
						outputChatBox("ERROR: " .. targetPlayerName .. " has no weapons.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("disarm", disarm)

-- /freeze [Player/ID] - by Skully (13/03/18) [Trial Admin]
function freezePlayer(thePlayer, commandName, targetPlayer)
	if exports.global:isPlayerTrialAdmin(thePlayer) and (getElementData(thePlayer, "loggedin") == 1) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player/ID]", thePlayer, 75, 230, 10)
		else
			local targetPlayer = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)
			if (targetPlayer) then
				local frozenState = isElementFrozen(targetPlayer)
				local controlState = isControlEnabled(targetPlayer, "walk")
				local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
				local targetPlayerName = getPlayerName(targetPlayer); targetPlayerName = targetPlayerName:gsub("_", " ")
				local affectedElements = {thePlayer, targetPlayer}

				if (frozenState) and not (controlState) then -- Unfreeze.
					setElementFrozen(targetPlayer, not frozenState) -- Set frozen state inverse of what it currently is.
					toggleAllControls(targetPlayer, true) -- Enable all controls.
					outputChatBox(targetPlayerName .. " has been unfrozen.", thePlayer, 75, 230, 10)
					if (targetPlayer ~= thePlayer) then
						outputChatBox("You have been unfrozen by " .. thePlayerName .. ".", targetPlayer, 255, 0, 0)
						exports.global:sendMessageToAdmins("[INFO] " .. thePlayerName .. " has unfrozen " .. targetPlayerName .. ".")
						exports.logs:addLog(thePlayer, 1, affectedElements, "Unfroze " .. targetPlayerName .. ".")
					end
				else
					setElementFrozen(targetPlayer, not frozenState)
					toggleAllControls(targetPlayer, false, true, false) -- Toggle all controls except for MTA's controls (e.g. chatbox)
					outputChatBox(targetPlayerName .. " has been frozen.", thePlayer, 75, 230, 10)
					if (targetPlayer ~= thePlayer) then
						outputChatBox("You have been frozen by " .. thePlayerName .. ".", targetPlayer, 255, 0, 0)
						exports.global:sendMessageToAdmins("[INFO] " .. thePlayerName .. " has frozen " .. targetPlayerName .. ".")
						exports.logs:addLog(thePlayer, 1, affectedElements, "Froze " .. targetPlayerName .. ".")
					end
				end
			end
		end
	end
end
addCommandHandler("freeze", freezePlayer)
addCommandHandler("unfreeze", freezePlayer)
addEvent("admin:freezePlayer", true) -- eventHandler used by /check freeze.
addEventHandler("admin:freezePlayer", root, freezePlayer)

-- /goto [Player/ID] - by Skully & Zil (19/06/17) [Helper]
function goto(thePlayer, commandName, targetPlayer)
	if exports.global:isPlayerHelper(thePlayer) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player/ID]", thePlayer, 75, 230, 10)
		else
			local targetPlayer, targetPlayerName = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)

			if (targetPlayer) then
				local targetPlayerDimension = getElementDimension(targetPlayer)
				local targetPlayerInterior = getElementInterior(targetPlayer)
				local affectedElements = {thePlayer, targetPlayer}

				local adminVehicle = getPedOccupiedVehicle(thePlayer)

				if (getPedOccupiedVehicle(targetPlayer)) then -- If the target player is in a car, if yes return what vehicle.
					local targetVehicle = getPedOccupiedVehicle(targetPlayer) -- Get the player's vehicle
					local x, y, z = getElementPosition(targetVehicle) -- Get the target player's vehicle position.
					local rz, ry, rz = getElementRotation(targetVehicle)
					table.insert(affectedElements, targetVehicle)

					if (getPedOccupiedVehicle(thePlayer)) then -- Check if the admin is in a car.
						local adminVehicleSeat = getPedOccupiedVehicleSeat(thePlayer)
						local adminVehicleEngineState = getVehicleEngineState(adminVehicle)
						
						x = x + ((math.cos(math.rad(rz))) * 3)
						y = y + ((math.sin(math.rad(rz))) * 3)

						setElementPosition(adminVehicle, x, y, z, true) -- Teleport the admin's vehicle to the target player's position.
						setElementRotation(adminVehicle, 0, 0, rz)
						table.insert(affectedElements, adminVehicle)

						if (adminVehicleEngineState == true) then -- If the admin's vehicle's engine is on.
							warpPedIntoVehicle(thePlayer, adminVehicle, adminVehicleSeat)
							setVehicleEngineState(adminVehicle, true) -- When warping into the vehicle, the engine gets turned off, so we need to turn it back on.
						else
							warpPedIntoVehicle(thePlayer, adminVehicle, adminVehicleSeat)
						end
					else
						setElementPosition(thePlayer, x, y, z, true)
						setElementRotation(thePlayer, 0, 0, rz)
					end
				else
					if (getPedOccupiedVehicle(thePlayer)) then
						local x, y, z = getElementPosition(targetPlayer) -- Get the target player's position.
						local rx, ry, rz = getElementRotation(targetPlayer)
						local adminVehicle = getPedOccupiedVehicle(thePlayer)
						local adminVehicleEngineState = getVehicleEngineState(adminVehicle)

						x = x + ((math.cos(math.rad(rz))) * 3)
						y = y + ((math.sin(math.rad(rz))) * 3)

						setElementPosition(adminVehicle, x, y, z, true)
						setElementRotation(adminVehicle, 0, 0, rz)

						if (adminVehicleEngineState == true) then -- If the admin's vehicle engine is on.
							warpPedIntoVehicle(thePlayer, adminVehicle, adminVehicleSeat)
							setVehicleEngineState(adminVehicle, true) -- When warping into the vehicle, the engine gets turned off, so we need to turn it back on.
						else
							warpPedIntoVehicle(thePlayer, adminVehicle, adminVehicleSeat)
						end
					else
						local x, y, z = getElementPosition(targetPlayer) -- Get the target player's position.
						local rx, ry, rz = getElementRotation(targetPlayer)

						x = x + ((math.cos(math.rad(rz))) * 3)
						y = y + ((math.sin(math.rad(rz))) * 3)

						setElementPosition(thePlayer, x, y, z, true)
						setElementRotation(thePlayer, 0, 0, rz)
					end
				end
				setElementInterior(thePlayer, targetPlayerInterior)
				setElementDimension(thePlayer, targetPlayerDimension)

				local logMessage = "Teleported themself "
				if (adminVehicle) then
					logMessage = logMessage .. "and their vehicle "
				end

				local thePlayerName = exports.global:getStaffTitle(thePlayer)
				if (targetPlayer ~= thePlayer) then
					outputChatBox("You have teleported to " .. targetPlayerName .. ".", thePlayer, 75, 230, 10)
					outputChatBox(thePlayerName .. " has teleported to you.", targetPlayer, 75, 230, 10)
					logMessage = logMessage .. "to " .. targetPlayerName .. "."
				else
					outputChatBox("You have teleported to yourself.", thePlayer, 75, 230, 10)
					logMessage = logMessage .. "to themself."
				end
				exports.logs:addLog(thePlayer, 1, affectedElements, logMessage)
			end
		end
	end
end
addCommandHandler("goto", goto)
addCommandHandler("tp", goto)
addEvent("admin:gotoPlayer", true) -- eventHandler used by /check GUI.
addEventHandler("admin:gotoPlayer", root, goto)

-- /gethere [Player/ID] - by Zil (19/06/17) [Helper]
function gethere(thePlayer, commandName, targetPlayer)
	if exports.global:isPlayerHelper(thePlayer) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player/ID]", thePlayer, 75, 230, 10)
		else
			local targetPlayer = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)
			local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)

			if (targetPlayer) and (getElementData(targetPlayer, "loggedin") == 1) then
				if (targetPlayer == thePlayer) then -- Check if the target player is the admin.
					outputChatBox("Why are you trying to teleport yourself?", thePlayer, 255, 0, 0)
				else
					local thePlayerAdminLevel = exports.global:getStaffLevel(thePlayer)
					local targetPlayerAdminLevel = exports.global:getStaffLevel(targetPlayer)
					local affectedElements = {thePlayer, targetPlayer}
					local logMessage = ""

					if (thePlayerAdminLevel >= targetPlayerAdminLevel) then
						local x, y, z = getElementPosition(thePlayer) -- Get the admin's position.
						local thePlayerDimension = getElementDimension(thePlayer)
						local thePlayerInterior = getElementInterior(thePlayer)
						local thePlayerRotation = getPedRotation(thePlayer)

						-- Math calculations to stop the target being stuck in the player
						 x = x + ((math.cos(math.rad(thePlayerRotation))) * 2)
						 y = y + ((math.sin(math.rad(thePlayerRotation))) * 2)

						if (getPedOccupiedVehicle(targetPlayer)) then -- If the player is in a car, if yes return what vehicle.
							local targetVehicle = getPedOccupiedVehicle(targetPlayer) -- Get the target player's vehicle
							table.insert(affectedElements, targetVehicle)
							local targetPlayerName = getPlayerName(targetPlayer); targetPlayerName = targetPlayerName:gsub("_", " ")
							local rotX, rotY, rotZ = getElementRotation(targetVehicle)

							setElementAngularVelocity(targetVehicle, 0, 0, 0)
							setElementPosition(targetVehicle, x + 2.5,y,z + 1, true)
							setElementRotation(targetVehicle, rotX, 180, rotZ) -- Make sure the target player's vehicle isn't flipped.
							setTimer(setElementAngularVelocity, 50, 20, targetVehicle, 0, 0, 0)
							setElementInterior(targetPlayer, thePlayerInterior)
							setElementDimension(targetPlayer, thePlayerDimension)
							outputChatBox("You have been teleported to " .. thePlayerName .. ".", targetPlayer, 75, 230, 10)
							outputChatBox("You have teleported " .. targetPlayerName .. " to you.", thePlayer, 75, 230, 10)
							logMessage = "Teleported " .. targetPlayerName .. " and their vehicle to themself."
						else
							local targetPlayerName = getPlayerName(targetPlayer):gsub("_", " ")

							setElementPosition(targetPlayer, x,y + 1, z, true) -- Teleport the player to the admin.
							setElementInterior(targetPlayer, thePlayerInterior)
							setElementDimension(targetPlayer, thePlayerDimension)
							outputChatBox("You have been teleported to " .. thePlayerName .. ".", targetPlayer, 75, 230, 10)
							outputChatBox("You have teleported " .. targetPlayerName .. " to you.", thePlayer, 75, 230, 10)
							logMessage = "Teleported " .. targetPlayerName .. " to themself."
						end
						exports.logs:addLog(thePlayer, 1, affectedElements, logMessage)
					end
				end
			end
		end
	end
end
addCommandHandler("gethere", gethere)
addCommandHandler("get", gethere)
addCommandHandler("tphere", gethere)
addEvent("admin:getherePlayer", true) -- eventHandler used by /check GUI.
addEventHandler("admin:getherePlayer", root, gethere)

-- /settime [Hour] [Minute] - by Skully (20/06/17) [Lead Manager]
function setTimeOfDay(thePlayer, commandName, hour, minute)
	if exports.global:isPlayerLeadManager(thePlayer) then
		if not tonumber(hour) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Hour] [Minutes]", thePlayer, 75, 230, 10)
		else
			local hour = tonumber(hour)
			if not tonumber(minute) then -- if no minute is put in.
				if (hour <= -1) or (hour >= 25) then -- if the hour input is not between 0-24.
					outputChatBox("ERROR: That time is incorrect!", thePlayer, 255, 0, 0)
				else -- if the hour input is fine, and no minute was put in, we just use minute 0 by default.
					setTime(hour, 00)
					outputChatBox("You set the time to " .. hour.. ":00.", thePlayer, 75, 230, 10)
				end
			else -- if the player has input an hour and the minutes they want to set.
				local minute = tonumber(minute)
				if (minute <= -1) or (minute >= 61) or (hour <= -1) or (hour >= 25) then
					outputChatBox("ERROR: That time is incorrect!", thePlayer, 255, 0, 0)
				else
					setTime(hour, minute)

					if (minute < 10) then
						minute = "0" .. tostring(minute)
					end

					if (hour < 10) then
						hour =  "0" .. tostring(hour)
					end

					outputChatBox("You set the time to " .. hour.. ":" .. minute .. ".", thePlayer, 75, 230, 10)
					exports.logs:addLog(thePlayer, 1, thePlayer, "Set the time to " .. hour .. ":" .. minute .. ".")

					local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
					exports.global:sendMessage("[INFO] " .. thePlayerName .. " has set the time to " .. hour .. ":" .. minute .. ".", 2, true) -- Notifies managers.
				end
			end
		end
	end
end
addCommandHandler("settime", setTimeOfDay)

-- /changename [Player/ID] [Name] - by Zil (19/06/17) [Trial Admin]
function changeName(thePlayer, commandName, targetPlayer, ...)
	if exports.global:isPlayerTrialAdmin(thePlayer) then
		if not (targetPlayer) or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player/ID] [Name]", thePlayer, 75, 230, 10)
		else
			local targetPlayer = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)
			local targetPlayerName = getPlayerName(targetPlayer); targetPlayerName = targetPlayerName:gsub("_", " ")
			if (targetPlayer) and (getElementData(targetPlayer, "loggedin") == 1) then
				local newName = table.concat({...}, " ")
				newName = newName:gsub(" ", "_")
				if string.len(newName) > 3 and string.len(newName) <= 25 then -- Check if the new name isn't empty or doesn't exceed max characters.
					if targetPlayerName == newName then -- Check if the target player's name is already set to the new name.
						outputChatBox("ERROR: " .. targetPlayerName .. " already has that name!", thePlayer, 255, 0, 0)
					else
						local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
						local accountID = getElementData(targetPlayer, "account:id")
						local affectedElements = {thePlayer, targetPlayer}
						
						-- Update and save the name.
						exports.mysql:Execute("UPDATE `characters` SET `name` = (?) WHERE `id` = (?);", newName, accountID)
						exports.blackhawk:setElementDataEx(targetPlayer, "character:name", newName, true)
						setPlayerName(targetPlayer, newName) -- Set the player's name to the new name.
						
						newName = newName:gsub("_", " ")
						outputChatBox("You have updated " .. targetPlayerName .. " name to " .. newName .. ".", thePlayer, 75, 230, 10)
						outputChatBox(thePlayerName .. " has set your name to " .. newName .. ".", targetPlayer, 75, 230, 10)

						exports.logs:addLog(thePlayer, 1, affectedElements, "Set " .. targetPlayerName .. " to " .. newName .. ".")
						exports.global:sendMessageToAdmins("[INFO] " .. thePlayerName .. " has set " .. targetPlayerName .. "'s name to " .. newName .. ".") -- Notifies all online staff.
					end
				else
					outputChatBox("ERROR: Name length must be between 4 and 25 characters!", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("changename", changeName)

-- /z [Z Value] - by Zil (20/06/17) [Trial Admin]
function setZ(thePlayer, commandName, addZ)
	if exports.global:isPlayerTrialAdmin(thePlayer) then
		if not tonumber(addZ) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Z Value]", thePlayer, 75, 230, 10)
		else
			local affectedElements = {thePlayer}
			local logMessage
			if getPedOccupiedVehicle(thePlayer) then -- If the player is in a vehicle, we'll teleport the player's vehicle.
				local theVehicle = getPedOccupiedVehicle(thePlayer)
				local x,y,z = getElementPosition(theVehicle)
				logMessage = "Added " .. addZ .. " to their vehicle's and their own's Z position."
				table.insert(affectedElements, theVehicle)
				setElementPosition(theVehicle, x,y,z + addZ)
			else
				local x,y,z = getElementPosition(thePlayer)
				setElementPosition(thePlayer, x,y,z + addZ)
				logMessage = "Added " .. addZ .. " to their Z position."
			end
			exports.logs:addLog(thePlayer, 1, affectedElements, logMessage)
		end
	end
end
addCommandHandler("z", setZ)

-- /y [Y Value] - by Zil (20/06/17) [Trial Admin]
function setY(thePlayer, commandName, addY)
	if exports.global:isPlayerTrialAdmin(thePlayer) then
		if not tonumber(addY) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Y Value]", thePlayer, 75, 230, 10)
		else
			local affectedElements = {thePlayer}
			local logMessage
			if getPedOccupiedVehicle(thePlayer) then
				local theVehicle = getPedOccupiedVehicle(thePlayer)
				local x,y,z = getElementPosition(theVehicle)
				logMessage = "Added " .. addY .. " to their vehicle's and their own Y position."
				table.insert(affectedElements, theVehicle)
				setElementPosition(theVehicle, x,y + addY,z)
			else
				local x,y,z = getElementPosition(thePlayer)
				setElementPosition(thePlayer, x,y + addY,z)
				logMessage = "Added " .. addY .. " to their Y position."
			end
			exports.logs:addLog(thePlayer, 1, affectedElements, logMessage)
		end
	end
end
addCommandHandler("y", setY)

-- /x [X Value] - by Zil (20/06/17) [Trial Admin]
function setX(thePlayer, commandName, addX)
	if exports.global:isPlayerTrialAdmin(thePlayer) then
		if not tonumber(addX) then
			outputChatBox("SYNTAX: /" .. commandName .. " [X Value]", thePlayer, 75, 230, 10)
		else
			local affectedElements = {thePlayer}
			local logMessage
			if getPedOccupiedVehicle(thePlayer) then
				local theVehicle = getPedOccupiedVehicle(thePlayer)
				local x,y,z = getElementPosition(theVehicle)
				logMessage = "Added " .. addX .. " to their vehicle's and their own Y position."
				table.insert(affectedElements, theVehicle)
				setElementPosition(theVehicle, x + addX,y,z)
			else
				local x,y,z = getElementPosition(thePlayer)
				setElementPosition(thePlayer, x + addX,y,z)
				logMessage = "Added " .. addX .. " to their X position."
			end
			exports.logs:addLog(thePlayer, 1, affectedElements, logMessage)
		end
	end
end
addCommandHandler("x", setX)

-- /setxyz [X] [Y] [Z] - by Zil (20/06/17) [Trial Admin]
function setXYZ(thePlayer, commandName, x, y, z)
	if exports.global:isPlayerTrialAdmin(thePlayer) then
		if not (x) or not (y) or not (z) then
			outputChatBox("SYNTAX: /" .. commandName .. " [X] [Y] [Z]", thePlayer, 75, 230, 10)
			return
		end

		x = x:gsub(",", " "); y = y:gsub(",", " "); z = z:gsub(",", " ")
		if not tonumber(x) or not tonumber(y) or not tonumber(z) then
			outputChatBox("SYNTAX: /" .. commandName .. " [X] [Y] [Z]", thePlayer, 75, 230, 10)
		else
			if (tonumber(x) <= -10000) or (tonumber(y) <= -10000) or (tonumber(z) <= -10000) then -- If one of the provided coordinates is less then 0.
				outputChatBox("ERROR: Invalid coordinates given!", thePlayer, 255, 0, 0)
			else
				local affectedElements = {thePlayer}
				local logMessage
				if getPedOccupiedVehicle(thePlayer) then -- If the player is in a vehicle, we'll teleport the player's vehicle.
					local theVehicle = getPedOccupiedVehicle(thePlayer)
					table.insert(affectedElements, theVehicle)
					setElementPosition(theVehicle, tonumber(x), tonumber(y), tonumber(z))
					logMessage = "Set their and their vehicle's position to " .. x .. ", " .. y .. ", " .. z .. "." 
				else
					setElementPosition(thePlayer, tonumber(x), tonumber(y), tonumber(z))
					logMessage = "Set their position to " .. x .. ", " .. y .. ", " .. z .. "." 
				end
				exports.logs:addLog(thePlayer, 1, affectedElements, logMessage)
			end
		end
	end
end
addCommandHandler("setxyz", setXYZ)
addCommandHandler("xyz", setXYZ)

-- /nudge [Player/ID] - by Zil (20/06/17) [Helper]
function nudge (thePlayer, commandName, targetPlayer)
	if exports.global:isPlayerHelper(thePlayer) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player/ID]", thePlayer, 75, 230, 10)
		else
			local targetPlayer = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)
			if (targetPlayer) then
				local affectedElements = {thePlayer, targetPlayer}
				local targetPlayerName = getPlayerName(targetPlayer); targetPlayerName = targetPlayerName:gsub("_", " ")
				local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)

				outputChatBox(thePlayerName .. " has nudged you.", targetPlayer, 75, 230, 10)
				outputChatBox("You nudged " .. targetPlayerName .. ".", thePlayer, 75, 230, 10)
				triggerClientEvent(targetPlayer, "nudgeSoundFX", targetPlayer)
				exports.logs:addLog(thePlayer, 1, affectedElements, "Nudged " .. targetPlayerName .. ".")
			end
		end
	end
end
addCommandHandler("nudge", nudge)

-- /freconnect [Player/ID] - by Zil (20/06/17) [Trial Admin]
function freconnect(thePlayer, commandName, targetPlayer)
	if exports.global:isPlayerTrialAdmin(thePlayer) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player/ID]", thePlayer, 75, 230, 10)
		else
			targetPlayer = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)
			if (targetPlayer) then
				local thePlayerAdminLevel = exports.global:getStaffLevel(thePlayer)
				local targetPlayerAdminLevel = exports.global:getStaffLevel(targetPlayer)

				if (thePlayerAdminLevel >= targetPlayerAdminLevel) then
					local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
					local targetPlayerName = getPlayerName(targetPlayer); targetPlayerName = targetPlayerName:gsub("_", " ")
					local affectedElements = {thePlayer, targetPlayer}
					redirectPlayer(targetPlayer, "", 22003) -- Redirect player to the server again.

					exports.global:sendMessageToAdmins("[INFO] " .. thePlayerName .. " has force reconnected "  .. targetPlayerName .. ".") -- Notifies all online admins.
					exports.logs:addLog(thePlayer, 1, affectedElements, "Forcefully reconnected " .. targetPlayerName .. ".")
				else
					outputChatBox("Why are you trying to freconnect a higher level staff member? It's treason, then.", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("freconnect", freconnect)

-- /slap [Player/ID] [Force] - by Zil (20/06/17) [Trial Admin]
function slapPlayer(thePlayer, commandName, targetPlayer, force)
	if exports.global:isPlayerTrialAdmin(thePlayer) then
		if not targetPlayer then
			outputChatBox("SYNTAX: /" .. commandName .. " [Target Player] [Force]", thePlayer, 75, 230, 10)
		else
			local targetPlayer, targetPlayerName = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)
			if (targetPlayer) and (getElementData(targetPlayer, "loggedin") == 1) then				
				local thePlayerAdminLevel = exports.global:getStaffLevel(thePlayer)
				local targetPlayerAdminLevel = exports.global:getStaffLevel(targetPlayer)

				if (thePlayerAdminLevel >= targetPlayerAdminLevel) then
					local affectedElements = {thePlayer, targetPlayer}
					local force = force
					if not (force) then
						force = 3
					end
					if tonumber(force) > 0 then
						local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
						local x, y, z = getElementPosition(targetPlayer)
						force = tonumber(force)
						if getPedOccupiedVehicle(targetPlayer) then removePedFromVehicle(targetPlayer) end

						setElementPosition(targetPlayer, x, y, z + force)
						outputChatBox(thePlayerName .. " has slapped you.", targetPlayer, 75, 230, 10) 
						outputChatBox("You slapped " .. targetPlayerName .. " with a force level of " .. force .. ".", thePlayer, 75, 230, 10)

						exports.global:sendMessageToManagers("[INFO] " .. thePlayerName .. " has slapped " .. targetPlayerName .. ".", true) -- Notifies all online staff.
						exports.logs:addLog(thePlayer, 1, affectedElements, "Slapped " .. targetPlayerName .. " with " .. force .. " force.")
					else
						outputChatBox("ERROR: Force must be a minimum of 1!", thePlayer, 255, 0, 0) 
					end
				end
			end
		end
	end
end
addCommandHandler("slap", slapPlayer)

-- /setweather [ID] - by Zil (20/06/17) [Trial Admin]
function setWeatherID(thePlayer, commandName, weatherID)
	if exports.global:isPlayerTrialAdmin(thePlayer) then
		if not tonumber(weatherID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Weather ID]", thePlayer, 75, 230, 10)
		else
			if tonumber(weatherID) >= 0 and tonumber(weatherID) <= 19 then -- Check if the weather isn't less then 0 or more then 255.
				local weatherID = tonumber(weatherID)
				local currentWeather = getWeather()
				if currentWeather ~= (weatherID) then
					local weatherID = tonumber(weatherID)
					setWeather(weatherID)
					outputChatBox("You set the weather to ID " .. weatherID .. ".", thePlayer, 75, 230, 10) 
					exports.logs:addLog(thePlayer, 1, thePlayer, "Set the weather to ID " .. weatherID .. ".")
				else
					outputChatBox("ERROR: The weather is already ID " .. weatherID .. ".", thePlayer, 255, 0, 0)
				end
			elseif tonumber(weatherID) < 0 then
				outputChatBox("ERROR: Weather ID can not be less than 0!", thePlayer, 255, 0, 0)
			else
				outputChatBox("ERROR: Weather ID can not be more than 19!", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("setweather", setWeatherID)
addCommandHandler("sw", setWeatherID)

-- /setskin [Player/ID] [Skin ID] - by Zil (20/06/17) [Trial Admin]
function setSkin(thePlayer, commandName, targetPlayer, skinID)
	if exports.global:isPlayerTrialAdmin(thePlayer) then
		if not (targetPlayer) or not tonumber(skinID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player/ID] [Skin ID]", thePlayer, 75, 230, 10)
		else
			local targetPlayer, targetPlayerName = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)
			if targetPlayer then
				if exports.global:isValidSkin(skinID) then -- checks to see if the skin id is in the valid skins table.
					skinID = tonumber(skinID)
					local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
					setElementModel(targetPlayer, skinID)
					outputChatBox("You set " .. targetPlayerName .. " skin to ID " .. skinID .. ".", thePlayer, 75, 230, 10)
					outputChatBox(thePlayerName .. " has set your skin to ID " .. skinID .. ".", targetPlayer, 75, 230, 10)
					exports.logs:addLog(thePlayer, 1, targetPlayer, "(/setskin) Set " .. targetPlayerName .. "'s skin to ID " .. skinID .. ".")  
				else
					outputChatBox("ERROR: That is not a valid skin ID!", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("setskin", setSkin)
addCommandHandler("setplayerskin", setSkin)

-- /disappear - By Zil (21/06/17) [Trial Admin]
function setInvisible(thePlayer, commandName)
	if exports.global:isPlayerTrialAdmin(thePlayer) then
		if (getElementAlpha(thePlayer) == 0) then -- If the admin is already fully invisible (transparent)
			triggerClientEvent(thePlayer, "admin:disablewallview", thePlayer)
			setElementAlpha(thePlayer, 255) -- Set the admin back to visible.
			exports.logs:addLog(thePlayer, 1, thePlayer, "Set themself back to being visible.")
		else
			local staffRank = getElementData(thePlayer, "staff:rank")
			local distance = 25
			if staffRank >= 5 then distance = 75
				elseif staffRank >= 3 then distance = 50
			end
			triggerClientEvent(thePlayer, "admin:enablewallview", thePlayer, distance, true)
			setElementAlpha(thePlayer, 0)
			exports.logs:addLog(thePlayer, 1, thePlayer, "Set themself invisible.")
		end
	end
end
addCommandHandler("disappear",  setInvisible)
addCommandHandler("invisible",  setInvisible)

-- /getpos - by Zil (21/06/17) [Helper]
function getPos(thePlayer, commandName)
	if exports.global:isPlayerHelper(thePlayer) or exports.global:isPlayerTrialDeveloper(thePlayer) then
		local x, y, z = getElementPosition(thePlayer)
		local rotX, rotY, rotZ = getElementRotation(thePlayer)
		local interior, dimension = getElementInterior(thePlayer), getElementDimension(thePlayer)

		outputChatBox(" ", thePlayer, 0, 0, 0)
		outputChatBox("Your position: " .. string.format("%.5f", x) .. ", " .. string.format("%.5f", y) .. ", " .. string.format("%.5f", z), thePlayer, 75, 230, 10)
		outputChatBox("Rotation: " .. string.format("%.5f", rotZ), thePlayer, 75, 230, 10)
		outputChatBox("Interior: " .. interior, thePlayer, 75, 230, 10)
		outputChatBox("Dimension: " .. dimension, thePlayer, 75, 230, 10)
		outputChatBox("X: " .. string.format("%.5f", x), thePlayer, 75, 230, 10)
		outputChatBox("Y: " .. string.format("%.5f", y), thePlayer, 75, 230, 10)
		outputChatBox("Z: " .. string.format("%.5f", z), thePlayer, 75, 230, 10)
	end
end
addCommandHandler("getpos", getPos)

--/mute by Zil & Skully (24/06/17) [Trial Admin]
function mutePlayer(thePlayer, commandName, targetPlayer)
	if exports.global:isPlayerTrialAdmin(thePlayer) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player/ID]", thePlayer, 75, 230, 10)
		else
			local targetPlayer, targetPlayerName = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)
			if (targetPlayer) then				
				local thePlayerAdminLevel = getElementData(thePlayer, "staff:rank")
				local targetPlayerAdminLevel = getElementData(targetPlayer, "staff:rank")

				if (targetPlayerAdminLevel == 0) then
					local muteStatus = getElementData(targetPlayer, "account:muted")

					if (muteStatus == 1) then -- Check if the player is already muted.
						outputChatBox("ERROR: " .. targetPlayerName .. " is already muted!" , thePlayer, 255, 0, 0)
					else
						local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
						local affectedElements = {thePlayer, targetPlayer}
						exports.blackhawk:setElementDataEx(targetPlayer, "account:muted", 1, true)

						outputChatBox("You muted " .. targetPlayerName .. ".", thePlayer, 75, 230, 10)
						outputChatBox(thePlayerName .. " has muted you.", targetPlayer, 75, 230, 10)
						exports.global:sendMessageToAdmins("[INFO] " .. thePlayerName .. " has muted " .. targetPlayerName .. ".")
						exports.logs:addLog(thePlayer, 1, affectedElements, "Muted " .. targetPlayerName .. ".")
					end
				else
					outputChatBox("ERROR: You can't mute a staff member!", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("mute", mutePlayer)

-- /unmute by Zil & Skully (24/06/17) [Trial Admin]
function unmutePlayer(thePlayer, commandName, targetPlayer)
	if exports.global:isPlayerTrialAdmin(thePlayer) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player/ID]", thePlayer, 75, 230, 10)
		else
			local targetPlayer, targetPlayerName = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)
			if (targetPlayer) then				
				local muteStatus = getElementData(targetPlayer, "account:muted")

				if (muteStatus == 0) then -- Check if the player is already unmuted.
					outputChatBox("ERROR: " .. targetPlayerName .. " isn't muted!" , thePlayer, 255, 0, 0)
				else
					local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
					local affectedElements = {thePlayer, targetPlayer}
					exports.blackhawk:setElementDataEx(targetPlayer, "account:muted", 0, true)

					outputChatBox("You unmuted " .. targetPlayerName .. ".", thePlayer, 75, 230, 10)
					outputChatBox(thePlayerName .. " has unmuted you.", targetPlayer, 75, 230, 10)
					exports.global:sendMessageToAdmins("[INFO] " .. thePlayerName .. " has unmuted " .. targetPlayerName .. ".")
					exports.logs:addLog(thePlayer, 1, affectedElements, "Unmuted " .. targetPlayerName .. ".")
				end
			end
		end
	end
end
addCommandHandler("unmute", unmutePlayer)

-- /togglemgtwarns - by Skully (25/06/17) [Manager]
function toggleManagementWarns(thePlayer)
	if (exports.global:isPlayerManager(thePlayer)) then

		if (getElementData(thePlayer, "var:togmgtwarn") == 0) or (getElementData(thePlayer, "var:togmgtwarn") == false) then -- 0 means not ignoring.
			exports.blackhawk:setElementDataEx(thePlayer, "var:togmgtwarn", 1, true)
			outputChatBox("You have disabled management warning messages.", thePlayer, 75, 230, 10)
		else
			exports.blackhawk:setElementDataEx(thePlayer, "var:togmgtwarn", 0, true)
			outputChatBox("You have enabled management warning messages.", thePlayer, 75, 230, 10)
		end
	end
end
addCommandHandler("togglemgtwarns", toggleManagementWarns)
addCommandHandler("togglemanagerwarns", toggleManagementWarns)

-- /hduty - by Zil (27/06/17) [Helper]
function helperDuty(thePlayer)
	if (exports.global:getStaffLevel(thePlayer) == 1) then -- If the player is a helper.
		if (exports.global:isPlayerOnStaffDuty(thePlayer, true)) then -- If the player is already on helper duty make them off duty.
			blackhawk:setElementDataEx(thePlayer, "duty:staff", 0, true)
			outputChatBox("You are now off Helper Duty.", thePlayer, 75, 230, 10)
		else -- Turn on helper duty.
			blackhawk:setElementDataEx(thePlayer, "duty:staff", 1, true)
			outputChatBox("You are now on Helper Duty.", thePlayer, 75, 230, 10)
		end
	end
end
addCommandHandler("hduty", helperDuty)

-- /aduty - by Zil (27/06/17) [Trial Admin]
function adminDuty(thePlayer)
	if exports.global:isPlayerTrialAdmin(thePlayer, true) then -- If the player is a helper.
		if (exports.global:isPlayerOnStaffDuty(thePlayer)) then -- If the player is already on admin duty then set them off duty.
			blackhawk:setElementDataEx(thePlayer, "duty:staff", 0, true)
			outputChatBox("You are now off Admin Duty.", thePlayer, 75, 230, 10)
			if (getElementData(thePlayer, "var:toggledpms") == 1) then -- If the admin had their PMs toggled off.
				blackhawk:setElementDataEx(thePlayer, "var:toggledpms", 0, true) -- Turn their PMs back on.
			end
		else -- Turn on admin duty.
			blackhawk:setElementDataEx(thePlayer, "duty:staff", 1, true)
			outputChatBox("You are now on Admin Duty.", thePlayer, 75, 230, 10)
		end
	end
end
addCommandHandler("aduty", adminDuty)

-- /devduty - by Zil (27/06/17) [Trial Developer]
function developerDuty(thePlayer)
	if(exports.global:isPlayerTrialDeveloper(thePlayer, true)) then -- If the player is a trial developer.
		if (exports.global:isPlayerOnDeveloperDuty(thePlayer)) then -- If the player is already on developer duty make them off duty.
			blackhawk:setElementDataEx(thePlayer, "duty:developer", 0, true)
			outputChatBox("You are now off Developer Duty.", thePlayer, 75, 230, 10)
		else -- Turn on developer duty.
			blackhawk:setElementDataEx(thePlayer, "duty:developer", 1, true)
			outputChatBox("You are now on Developer Duty.", thePlayer, 75, 230, 10)
		end
	end
end
addCommandHandler("devduty", developerDuty)
addCommandHandler("dd", developerDuty)

-- /vtduty - by Zil (27/06/17) [Trial VT Member]
function vehicleDuty(thePlayer)
	if(exports.global:isPlayerVehicleTeam(thePlayer, true)) then -- If the player is a vehicle team member.
		if (exports.global:isPlayerOnVTDuty(thePlayer)) then -- If the player is already on vehicle team duty make them off duty.
			blackhawk:setElementDataEx(thePlayer, "duty:vt", 0, true)
			outputChatBox("You are now off VT Duty.", thePlayer, 75, 230, 10)
		else -- Turn on vehicle team duty.
			blackhawk:setElementDataEx(thePlayer, "duty:vt", 1, true)
			outputChatBox("You are now on VT Duty.", thePlayer, 75, 230, 10)
		end
	end
end
addCommandHandler("vtduty", vehicleDuty)

-- /mtduty - by Zil (27/06/17) [Trial MT Member]
function mappingDuty(thePlayer)
	if(exports.global:isPlayerMappingTeam(thePlayer, true)) then -- If the player is a maping team member.
		if (exports.global:isPlayerOnMTDuty(thePlayer)) then -- If the player is already on mapping team duty make them off duty.
			blackhawk:setElementDataEx(thePlayer, "duty:mt", 0, true)
			outputChatBox("You are now off MT Duty.", thePlayer, 75, 230, 10)

		else -- Turn on mapping team duty.
			blackhawk:setElementDataEx(thePlayer, "duty:mt", 1, true)
			outputChatBox("You are now on MT Duty.", thePlayer, 75, 230, 10)
		end
	end
end
addCommandHandler("mtduty", mappingDuty)

-- /toggooc - by Zil (28/06/17) [Lead Admin]
function toggleGlobalOOC(thePlayer, commandName)
	if(exports.global:isPlayerLeadAdmin(thePlayer)) then
		local goocStatus = exports.global:getDummyData("goocstate")
		local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
		if (goocStatus == 1) then -- if global OOC is already on.
			exports.mysql:Execute("UPDATE `variables` SET `goocstate` = '0'")
			exports.global:setDummyData("goocstate", 0)
			exports.global:sendMessageToPlayers("[SERVER] " .. thePlayerName .. " has turned off Global OOC chat." )
			exports.logs:addLog(thePlayer, 1, thePlayer, "Turned off Global OOC chat.")
		else -- turn on global ooc chat.
			exports.mysql:Execute("UPDATE `variables` SET `goocstate` = '1'")
			exports.global:setDummyData("goocstate", 1)
			exports.global:sendMessageToPlayers("[SERVER] " .. thePlayerName .. " has turned on Global OOC chat." )
			exports.logs:addLog(thePlayer, 1, thePlayer, "Turned on Global OOC chat.")
		end
	end
end
addCommandHandler("toggooc", toggleGlobalOOC)

-- /bigears [Player/ID] - by Zil (19/07/17) [Trial Admin]
function bigEars(thePlayer, commandName, targetPlayer)
	if (exports.global:isPlayerTrialAdmin(thePlayer)) then
		local affectedElements = {thePlayer}
		if not (targetPlayer) then
			if (getElementData(thePlayer, "bigears")) then -- If the player is already listening to someone, turn bigears off.
				local targetPlayer = getElementData(thePlayer, "bigears")
				local targetPlayerElement = getPlayerFromName(targetPlayer:gsub(" ", "_"))
				table.insert(affectedElements, targetPlayerElement)
				
				removeElementData(thePlayer, "bigears") -- Remove the element data.

				outputChatBox("You have stopped listening to " .. targetPlayer .. "." , thePlayer, 75, 230, 10)

				local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
				exports.global:sendMessageToManagers("[INFO] " .. thePlayerName .. " has stopped listening to " .. targetPlayer ..  ".")
				exports.logs:addLog(thePlayer, 1, affectedElements, "Stopped listening to " .. targetPlayer .. ".")
			else
				outputChatBox("SYNTAX: /" .. commandName .. " [Player/ID]", thePlayer, 75, 230, 10)
			end
		else
			local targetPlayer = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)
			if (targetPlayer) then
				if (targetPlayer == thePlayer) then -- Don't want admins to be able to bigears theirselves.
					outputChatBox("What kind of a special idiot tries to bigears themselves?", thePlayer, 255, 0, 0)
				else
					table.insert(affectedElements, targetPlayer)
					local targetPlayerName = getPlayerName(targetPlayer); targetPlayerName = targetPlayerName:gsub("_", " ")
				
					blackhawk:setElementDataEx(thePlayer, "bigears", targetPlayerName)
					outputChatBox("You have started listening to " .. targetPlayerName .. ". /bigears to stop listening." , thePlayer, 75, 230, 10)

					local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
					exports.global:sendMessageToManagers("[INFO] " .. thePlayerName .. " has started listening to " .. targetPlayerName ..  ".")
					exports.logs:addLog(thePlayer, 1, affectedElements, "Started listening to " .. targetPlayerName .. ".")
				end
			end
		end
	end
end
addCommandHandler("bigears", bigEars)

-- /hideadmin - by Zil (24/08/17) [Manager]
function hideAdmin(thePlayer)
	if (exports.global:isPlayerManager(thePlayer)) then
		if(getElementData(thePlayer, "var:hiddenAdmin") == 1) then -- Checks if the Manager is already a hidden administrator. 0 means no, 1 means that the manager is hidden.
			exports.blackhawk:setElementDataEx(thePlayer, "var:hiddenAdmin", 0, true) -- Disable hidden admin.
			outputChatBox("You have disabled your hidden status.", thePlayer, 75, 230, 10)
			exports.logs:addLog(thePlayer, 1, thePlayer, "Disabled hidden admin status.")
		else -- Enable it.
			exports.blackhawk:setElementDataEx(thePlayer, "var:hiddenAdmin", 1, true)
			outputChatBox("You have enabled your hidden status.", thePlayer, 75, 230, 10)
			exports.logs:addLog(thePlayer, 1, thePlayer, "Enabled hidden admin status.")
		end
	end
end
addCommandHandler("hideadmin", hideAdmin)
addCommandHandler("hideduty", hideAdmin)
addCommandHandler("hidemanager", hideAdmin)

-- /togpms - by Zil (25/08/17) [Trial Admin]
function togglePms(thePlayer)
	if (exports.global:isPlayerTrialAdmin(thePlayer)) then
		if (getElementData(thePlayer, "var:toggledpms") == 1) then -- If the staff member has toggled their PMs off.
			exports.blackhawk:setElementDataEx(thePlayer, "var:toggledpms", 0, true) -- Toggles the player's PMs back on.
			outputChatBox("You have enabled incoming private messages.", thePlayer, 75, 230, 10)
			exports.logs:addLog(thePlayer, 1, thePlayer, "Enabled incoming private messages using staff command.")
		else -- Disable the PMs.
			exports.blackhawk:setElementDataEx(thePlayer, "var:toggledpms", 1, true)
			outputChatBox("You have disabled incoming private messages.", thePlayer, 75, 230, 10)
			exports.logs:addLog(thePlayer, 1, thePlayer, "Disabled incoming private messages using staff command.")
		end
	else
		outputChatBox("ERROR: You can only toggle your private messages while on duty!", thePlayer, 255, 0, 0)
	end
end
addCommandHandler("togpms", togglePms)
addCommandHandler("togglepms", togglePms)

-- /lockserver - by Skully (31/08/17) [Lead Manager]
function lockServer(thePlayer, commandName, password)
	if exports.global:isPlayerLeadManager(thePlayer) then
		if not (password) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Password]", thePlayer, 75, 230, 10)
		else
			if #password < 3 then
				outputChatBox("ERROR: The password must be greater than 3 characters!", thePlayer, 255, 0, 0)
				return false
			end

			local wasSuccessful = setServerPassword(password)

			if (wasSuccessful) then
				local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
				outputChatBox("You have locked the server with the password: " .. password, thePlayer, 75, 230, 10)
				exports.global:sendMessageToManagers("[INFO] " .. thePlayerName .. " has locked the server with the password: " .. password, true)
				exports.logs:addLog(thePlayer, 1, thePlayer, "Locked the server with the password: " .. password .. ".")
			else
				outputChatBox("ERROR: Something went wrong whilst locking the server, please notify a developer!", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("lockserver", lockServer)

-- /unlockserver - by Skully (31/08/17) [Lead Manager]
function unlockServer(thePlayer)
	if exports.global:isPlayerLeadManager(thePlayer) then
		local wasSuccessful = setServerPassword(nil)

		if (wasSuccessful) then
			local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
			outputChatBox("You have unlocked the server.", thePlayer, 75, 230, 10)
			exports.global:sendMessageToManagers("[INFO] " .. thePlayerName .. " has unlocked the server.", true)
			exports.logs:addLog(thePlayer, 1, thePlayer, "Unlocked the server.")
		else
			outputChatBox("ERROR: Something went wrong whilst unlocking the server, please notify a developer!", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("unlockserver", unlockServer)

-- /fa [Target Player] [Reason] - by Skully (31/07/17) [Helper]
function forceAppPlayer(thePlayer, commandName, targetPlayer, ...)
	if exports.global:isPlayerHelper(thePlayer) then
		if not (targetPlayer) or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player/ID] [Reason]", thePlayer, 75, 230, 10)
		else
			local targetPlayer = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)

			-- If no target player.
			if not (targetPlayer) then
				return false
			end
			local affectedElements = {thePlayer, targetPlayer}

			-- Retard proof so they don't f'app themselves.
			if (targetPlayer == thePlayer) then
				outputChatBox("Are you retarded?", thePlayer, 255, 0, 0)
				return false
			end

			local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
			local targetPlayerName = getPlayerName(targetPlayer); targetPlayerName = targetPlayerName:gsub("_", " ")
			local theReason = table.concat({...}, "")
			local accountID = getElementData(targetPlayer, "account:id")

			if (exports.global:isPlayerStaff(targetPlayer)) then
				outputChatBox(targetPlayerName .. " is a " .. exports.global:getStaffTitle(targetPlayer) .. ". You can not send them back to the application stage.", thePlayer, 255, 0, 0)
				return false
			end

			-- Initiate the app-state setting.
			exports.mysql:Execute("UPDATE `accounts` SET `appstate` = '0' WHERE `id` = (?);", accountID)
			kickPlayer(targetPlayer, thePlayer, "You have been sent to the application stage! Submit another application at emeraldgaming.net")

			-- Notify everyone what happened.
			outputChatBox("You have sent " .. targetPlayerName .. " back to the application stage.", thePlayer, 75, 230, 10)
			exports.global:sendMessageToPlayers(thePlayerName .. " has sent " .. targetPlayerName .. " back to the application stage.")
			exports.global:sendMessageToPlayers("Reason: " .. theReason)
			exports.logs:addLog(thePlayer, 1, affectedElements, "Sent " .. targetPlayerName .. " back to the application stage with the reason: " .. theReason)
		end
	end
end
addCommandHandler("fa", forceAppPlayer)
addCommandHandler("forceapp", forceAppPlayer)

-- /unfap [Target Player] - by Skully (31/07/17) [Helper]
function unForceAppPlayer(thePlayer, commandName, accountName)
	if exports.global:isPlayerHelper(thePlayer) then
		if not tostring(accountName) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Account Name]", thePlayer, 75, 230, 10)
		else
			local isFapping = exports.mysql:QueryString("SELECT `appstate` FROM `accounts` WHERE `username` = (?);", accountName)
			if (tonumber(isFapping) ~= 0) then
				outputChatBox("ERROR: That player is not on the application stage!", thePlayer, 255, 0, 0)
				return false
			end
			local accountID = getAccountFromName(accountName)
			local affectedElements = {thePlayer, "ACC" .. accountID}
			local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)

			-- Set MySQL state of un-forceapped.
			exports.mysql:Execute("UPDATE `accounts` SET `appstate` = '1' WHERE `username` = (?);", accountName)

			-- Notify everyone what happened.
			outputChatBox("You have set " .. accountName .. "'s application stage status to passed.", thePlayer, 75, 230, 10)
			exports.global:sendMessageToStaff(thePlayerName .. " has removed " .. accountName .. "'s force-application status.")
			exports.logs:addLog(thePlayer, 1, affectedElements, "Removed " .. accountName .. "'s force-application status.")
		end
	end
end
addCommandHandler("unfa", unForceAppPlayer)
addCommandHandler("unfap", unForceAppPlayer)
addCommandHandler("unforceapp", unForceAppPlayer)

-- /kick [Target Player] [Reason] - by Zil (02/09/17) [Trial Admin]
function kickThePlayer(thePlayer, commandName, targetPlayer, ...)
	if (exports.global:isPlayerTrialAdmin(thePlayer)) then
		if not (targetPlayer) or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player/ID] [Reason]", thePlayer, 75, 230, 10)
		else
			local targetPlayer = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)
			if (targetPlayer == thePlayer) then
				outputChatBox("Why would you want to kick yourself? Just do /quit.", thePlayer, 255, 0, 0)
				return false
			end

			local theReason = table.concat({...}, "")
			local thePlayerName = exports.global:getStaffTitle(thePlayer)
			local targetPlayerName = getPlayerName(targetPlayer); targetPlayerName = targetPlayerName:gsub("_", " ")
			local affectedElements = {thePlayer, targetPlayer}

			if (exports.global:isPlayerStaff(targetPlayer)) then
				local targetPlayerTitle = exports.global:getStaffTitle(targetPlayer, 3)
				outputChatBox(targetPlayerName .. " is a " .. targetPlayerTitle .. " you can't kick them.", thePlayer, 255, 0, 0)
				return false
			end

			if (string.len(theReason) > 64) then
				outputChatBox("ERROR: The reason couldn't be more then 64 characters!", thePlayer, 255, 0, 0)
				return false
			end

			kickPlayer(targetPlayer, thePlayer, theReason)
			exports.global:sendMessageToStaff("[KICK] " .. thePlayerName .. " has kicked " .. targetPlayerName .. ".")
			exports.global:sendMessageToStaff("[KICK] Reason: " .. theReason)
			exports.logs:addLog(thePlayer, 1, affectedElements, "Kicked " .. targetPlayerName .. " with the reason: " .. theReason)
		end
	end
end
addCommandHandler("kick", kickThePlayer)

-- /setemeralds [Player] [Amount] - by Lancelot (17/02/2018) [Manager]
function setPlayerEmeralds(thePlayer, commandName, targetPlayer, amount)
	if exports.global:isPlayerManager(thePlayer) then
		if not (targetPlayer) or not tonumber(amount) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player/ID] [Amount]", thePlayer, 75, 230, 10)
		else
			local targetPlayer = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer) -- check if the player exists
			if (targetPlayer) and (getElementData(thePlayer, "loggedin") == 1) and (getElementData(targetPlayer, "loggedin") == 2) or (getElementData(targetPlayer, "loggedin") == 1) then
				if tonumber(amount) < 0 then
					outputChatBox("ERROR: Emeralds amount cannot be negative!", thePlayer, 75, 230, 10)
					return
				end
				local affectedElements = {thePlayer, targetPlayer}

				amount = tonumber(amount)
				exports.blackhawk:setElementDataEx(targetPlayer, "account:emeralds", amount)

				local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
				local theTargetUsername = getElementData(targetPlayer, "account:username")

				outputChatBox(thePlayerName .. " has set your Emeralds to " .. amount .. " .", targetPlayer, 75, 230, 10)
				outputChatBox("You have successfully updated " .. theTargetUsername .. "'s Emeralds to " .. amount .. ".", thePlayer, 75, 230, 10)
				exports.global:sendMessageToManagers("[INFO] " .. thePlayerName .. " has set " .. theTargetUsername .. "'s Emeralds amount to " .. amount .. ".", true)
				exports.logs:addLog(thePlayer, 1, affectedElements, "Set " .. theTargetUsername .. " emerald amount to " .. amount .. ".")
			end
		end
	end
end
addCommandHandler("setemeralds", setPlayerEmeralds)

-- /giveemeralds [Player] [Amount] - by Lancelot (17/02/2018) [Manager]
function givePlayerEmeralds(thePlayer, commandName, targetPlayer, amount)
	if exports.global:isPlayerManager(thePlayer) then
		if not (targetPlayer) or not tonumber(amount) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player/ID] [Amount]", thePlayer, 75, 230, 10)
		else
			if tonumber(amount) < 1 then
				outputChatBox("ERROR: Emeralds amount cannot be negative, to remove Emeralds, use /setemeralds.", thePlayer, 75, 230, 10)
				return
			end

			local targetPlayer = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer) -- check if the player exists
			if (targetPlayer) and (getElementData(thePlayer, "loggedin") == 1) and (getElementData(targetPlayer, "loggedin") == 2) or (getElementData(targetPlayer, "loggedin") == 1) then
				local previousAmount = getElementData(targetPlayer, "account:emeralds")
				exports.blackhawk:setElementDataEx(targetPlayer, "account:emeralds", previousAmount + amount)
				local affectedElements = {thePlayer, targetPlayer}

				local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
				local theTargetUsername = getElementData(targetPlayer, "account:username")

				outputChatBox(thePlayerName .. " has added " .. amount .. " Emeralds to your account.", targetPlayer, 75, 230, 10)
				outputChatBox("You have added " .. amount .. " Emeralds to " .. theTargetUsername .. "'s account.", thePlayer, 75, 230, 10)
				exports.global:sendMessageToManagers("[INFO] " .. thePlayerName .. " has given " .. theTargetUsername .. " " .. amount .. " Emeralds.", true)
				exports.logs:addLog(thePlayer, 1, affectedElements, "Gave " .. amount .. " emeralds to " .. theTargetUsername .. ".")
			end
		end
	end
end
addCommandHandler("giveemeralds", givePlayerEmeralds)

announcementState = false
-- /ann - by Skully & Zil (25/02/2018) [Helper, Aux. Team Leaders]
function createAnnouncement(thePlayer, commandName, ...)
	if (exports.global:isPlayerHelper(thePlayer)) or (exports.global:isPlayerMappingTeamLeader(thePlayer)) or (exports.global:isPlayerVehicleTeamLeader(thePlayer)) or (exports.global:isPlayerFactionTeamLeader(thePlayer)) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 75, 230, 10)
			return
		end

		if not (announcementState) then
			local message = table.concat({...}, " ")
			local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
			local allPlayers = getElementsByType("player") -- Get a table of all the players in the server.

			local affectedElements = {thePlayer}
			for i, player in ipairs(allPlayers) do table.insert(affectedElements, player) end

			local r, g, b = 174, 94, 183 -- Default auxiliary team colour.
			if exports.global:isPlayerManager(thePlayer) then
				r, g, b = 255, 0, 0 -- If they are a manager, make it red.
			elseif exports.global:isPlayerTrialAdmin(thePlayer) then
				r, g, b = 206, 169, 26 -- If they are an administrator.
			elseif exports.global:isPlayerHelper(thePlayer) then
				r, g, b = 0, 194, 76 -- If they are a helper.
			end

			triggerClientEvent(allPlayers, "admin:createAnnouncement", thePlayer, message, r, g, b)
			announcementState = true
			exports.logs:addLog(thePlayer, 1, affectedElements, "Broadcasted an announcement with the message: " .. message)

			setTimer(function()
				announcementState = false
			end, 24000, 1)
		else
			outputChatBox("ERROR: Someone else is already broadcasting an announcement!", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("ann", createAnnouncement)

-- /setdob [Player/ID] [Day] [Month] [Year] - By SjoerdPSV (18/02/18) [Trial Admin]
function setDOB(thePlayer, commandName, targetPlayer, dd, mm, yyyy)
	if exports.global:isPlayerTrialAdmin(thePlayer) then
		if not tonumber(dd) or not tonumber(mm) or not tonumber(yyyy) then
			outputChatBox( "SYNTAX: /" .. commandName .. " [Player/ID] [Day] [Month] [Year]", thePlayer,  75, 230, 10)
			return
		end

		local targetPlayer, targetPlayerName = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)
		if not (targetPlayer) or (getElementData(targetPlayer, "loggedin") == 0) then 
			return 
		end
		local affectedElements = {thePlayer, targetPlayer}

		local dob = dd..","..mm..","..yyyy
		local age = exports.global:dobToAge(dob)
		if age >= 16 and age <= 112 then
			exports.blackhawk:setElementDataEx(targetPlayer, "character:dob", dob, true)
			exports.blackhawk:setElementDataEx(targetPlayer, "character:age", age, true)

			local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
			outputChatBox("You have set " .. targetPlayerName .. "'s age to " .. age .. ".", thePlayer, 75, 230, 10)
			outputChatBox(thePlayerName .. " has set your age to " .. age .. ".", targetPlayer, 75, 230, 10)
			exports.logs:addLog(thePlayer, 1, affectedElements, "Set " .. targetPlayerName .. "'s age to " .. age .. ".")
		else
			outputChatBox("ERROR: Age must be between 16 and 112 years!", thePlayer, 255, 0, 0)	
		end
	end	
end
addCommandHandler("setdob", setDOB)

-- /setheight [Player/ID] [Height (140-205)] - By SjoerdPSV (18/02/18) [Helper]
function setHeight(thePlayer, commandName, targetPlayer, height)
	if exports.global:isPlayerHelper(thePlayer) then
		if not tonumber(height) then
			outputChatBox( "SYNTAX: /" .. commandName .. " [Player/ID] [Height (140-205)]", thePlayer,  75, 230, 10)
			return
		end

		local targetPlayer, targetPlayerName = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)
		if not (targetPlayer) or (getElementData(targetPlayer, "loggedin") == 0) then 
			return 
		end
		local affectedElements = {thePlayer, targetPlayer}

		local height = tonumber(height)
		if (height >= 140) and (height <= 205) then
			exports.blackhawk:setElementDataEx(targetPlayer, "character:height", height, true)
			
			local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
			outputChatBox("You have set " .. targetPlayerName .. "'s height to " .. height .. "cm.", thePlayer, 75, 230, 10)
			outputChatBox(thePlayerName .. " has set your height to " .. height .. "cm.", targetPlayer, 75, 230, 10)
			exports.logs:addLog(thePlayer, 1, affectedElements, "Set " .. targetPlayerName .. "'s height to " .. height .. "cm.")
		else
			outputChatBox("ERROR: Height must be between 140cm and 205cm!", thePlayer, 255, 0, 0)	
		end
	end	
end
addCommandHandler("setheight", setHeight)	 

-- /setweight [Player/ID] [Weight (40-205)] - By SjoerdPSV (18/02/18) [Helper]
function setWeight(thePlayer, commandName, targetPlayer, weight)
	if exports.global:isPlayerHelper(thePlayer) then
		if not tonumber(weight) then
			outputChatBox( "SYNTAX: /" .. commandName .. " [Player/ID] [Weight (40-205)]", thePlayer,  75, 230, 10)
			return
		end

		local targetPlayer, targetPlayerName = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)
		if not (targetPlayer) or (getElementData(targetPlayer, "loggedin") == 0) then 
			return 
		end
		local affectedElements = {thePlayer, targetPlayer}

		local weight = tonumber(weight)
		if (weight >= 40) and (weight <= 205) then
			exports.blackhawk:setElementDataEx(targetPlayer, "character:weight", weight, true)

			local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
			outputChatBox("You have set " .. targetPlayerName .. "'s weight to " .. weight .. "kg.", thePlayer, 75, 230, 10)
			outputChatBox(thePlayerName .. " has set your weight to " .. weight .. "kg.", targetPlayer, 75, 230, 10)
			exports.logs:addLog(thePlayer, 1, affectedElements, "Set " .. targetPlayerName .. "'s weight to " .. weight .. "kg.")
		else
			outputChatBox("ERROR: Weight must be between 40kg and 205kg!", thePlayer, 255, 0, 0)	
		end
	end	
end
addCommandHandler("setweight", setWeight)	 

-- /setgender [Player/ID] [Gender (1-2)] - By SjoerdPSV (18/02/18) [Helper]
function setGender(thePlayer, commandName, targetPlayer, gender)
	if exports.global:isPlayerHelper(thePlayer) then
		if not tonumber(gender) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player/ID] [Gender (1-2)]", thePlayer, 75, 230, 10)
			outputChatBox("Gender Types: 1 = Male, 2 = Female", thePlayer, 75, 230, 10)
			return
		end

		local targetPlayer, targetPlayerName = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)
		if not (targetPlayer) or (getElementData(targetPlayer, "loggedin") == 0) then 
			return 
		end
		local affectedElements = {thePlayer, targetPlayer}

		local gender = tonumber(gender)
		if (gender == 1) or (gender == 2) then
			exports.blackhawk:setElementDataEx(targetPlayer, "character:gender", gender, true)

			if (gender == 1) then gender = "Male" else gender = "Female" end -- Update the gender variable to be the gender name.

			local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
			outputChatBox("You have changed " .. targetPlayerName .. "'s gender to " .. gender .. ".", thePlayer, 75, 230, 10)
			outputChatBox(thePlayerName .. " has changed your gender to " .. gender .. ".", targetPlayer, 75, 230, 10)
			exports.logs:addLog(thePlayer, 1, affectedElements, "Set " .. targetPlayerName .. "'s gender to " .. gender .. ".")
		else
			outputChatBox("ERROR: That is not a valid gender ID!", thePlayer, 255, 0, 0)	
		end
	end	
end
addCommandHandler("setgender", setGender)

-- /recon [Target Player] - by Zil (14/03/18) [Trial Admin]
function reconPlayer(thePlayer, commandName, targetPlayer)
	if (exports.global:isPlayerTrialAdmin(thePlayer)) then
		-- If the staff member is already reconning someone.
		if (getElementData(thePlayer, "var:recon") == 1) then
			stopReconning(thePlayer)
			return
		end

		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " (Player/ID)", thePlayer,  75, 230, 10)
			return
		end

		local targetPlayer, targetPlayerName = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)

		if (targetPlayer) then 
			local targetPlayerName = getPlayerName(targetPlayer):gsub("_", " ")
			local affectedElements = {thePlayer, targetPlayer}

			if (targetPlayer == thePlayer) then
				outputChatBox("Why do you want to recon yourself?", thePlayer, 255, 0, 0)
				return
			end

			if (getElementData(targetPlayer, "var:recon") == 1) then
				local targetPlayerTitle = exports.global:getStaffTitle(targetPlayer, 1)
				outputChatBox("ERROR: " .. targetPlayerTitle .. " is currently reconning someone.", thePlayer, 255, 0, 0)
				return
			end

			if (getPedOccupiedVehicle(thePlayer)) then
				removePedFromVehicle(thePlayer)
			end

			if (getElementData(thePlayer, "freecam:state")) then
				-- Disables freecam.
				enableFreecam(thePlayer)
			end

			local x, y, z = getElementPosition(thePlayer)
			local rotX, rotY, rotZ = getElementRotation(thePlayer)
			local thePlayerDim = getElementDimension(thePlayer)
			local thePlayerInt = getElementInterior(thePlayer)
			local thePlayerPreRecon = {targetPlayer, targetPlayerName, x, y, z, rotX, rotY, rotZ, thePlayerDim, thePlayerInt}

			local targetPlayerDim = getElementDimension(targetPlayer)
			local targetPlayerInt = getElementInterior(targetPlayer)
			local x, y, z = getElementPosition(targetPlayer, 0)

			setElementDimension(thePlayer, targetPlayerDim)
			setElementInterior(thePlayer, targetPlayerInt)
			setCameraInterior(thePlayer, targetPlayerInt)
			setElementPosition(thePlayer, x - 8, y - 8, z - 5)
			setElementAlpha(thePlayer, 0)

			local attachStatus = attachElements(thePlayer, targetPlayer, -10, -10, -5)
			if not (attachStatus) then
				attachStatus = attachElements(thePlayer, targetPlayer, -5, -5, -5)
				if not (attachStatus) then
					attachStatus = attachElements(thePlayer, targetPlayer, 5, 5, -5)
				end
			end

			if not (attachStatus) then
				outputChatBox("ERROR: Something went wrong whilst attaching to target player, please notify a developer!", thePlayer, 255, 0, 0)
			else
				local thePlayerTitle = exports.global:getStaffTitle(thePlayer, 1)
				local targetPlayerID = getElementData(targetPlayer, "player:id")

				setCameraTarget(thePlayer, targetPlayer)
				setPedWeaponSlot(thePlayer, 0)

				-- Begin displaying the recon GUI.
				triggerClientEvent(thePlayer, "admin:showReconGUI", thePlayer, targetPlayer)
				
				outputChatBox("You are now reconning " .. targetPlayerName .. ".", thePlayer, 75, 230, 10)
				exports.global:sendMessage("[RECON] " .. thePlayerTitle .. " has started reconning " .. "(" .. targetPlayerID .. ") " .. targetPlayerName .. ".", 2, true)
				exports.logs:addLog(thePlayer, 1, affectedElements, "Started reconning " .. targetPlayerName .. ".")
				blackhawk:setElementDataEx(thePlayer, "var:recon", 1)
				blackhawk:setElementDataEx(targetPlayer, "var:beingreconned", thePlayer)
				blackhawk:setElementDataEx(thePlayer, "var:reconinfo", thePlayerPreRecon)
			end
		end
	end
end
addCommandHandler("recon", reconPlayer)
addEvent("admin:reconPlayer", true)
addEventHandler("admin:reconPlayer", root, reconPlayer)

function stopReconning(thePlayer, quitState)
	local thePlayerPreRecon = getElementData(thePlayer, "var:reconinfo")
	if (thePlayerPreRecon) then
		local thePlayerTitle = exports.global:getStaffTitle(thePlayer, 1)
		local targetPlayer = thePlayerPreRecon[1]
		local targetPlayerName = thePlayerPreRecon[2]
		local targetPlayerID = getElementData(targetPlayer, "player:id")
		local affectedElements = {thePlayer}

		detachElements(thePlayer)
		setElementPosition(thePlayer, thePlayerPreRecon[3], thePlayerPreRecon[4], thePlayerPreRecon[5])
		setElementRotation(thePlayer, thePlayerPreRecon[6], thePlayerPreRecon[7], thePlayerPreRecon[8])
		setElementDimension(thePlayer, thePlayerPreRecon[9])
		setElementInterior(thePlayer, thePlayerPreRecon[10])
		setElementAlpha(thePlayer, 255)
		setCameraTarget(thePlayer)

		if (targetPlayer) then removeElementData(targetPlayer, "var:beingreconned") end

		-- Stop drawing the GUI.
		triggerClientEvent(thePlayer, "admin:stopReconningGUI", thePlayer)

		local logMessage = "Stopped reconning " .. targetPlayerName
		if (quitState) then 
			targetPlayerName = targetPlayerName .. " [Player Quit]"
			table.insert(affectedElements, "ACC" .. targetPlayerID)
			logMessage = logMessage .. " due to the player leaving."
		else
			table.insert(affectedElements, targetPlayer)
			logMessage = logMessage .. "."
		end

		blackhawk:setElementDataEx(thePlayer, "var:recon", 0)
		exports.global:sendMessage("[RECON] " .. thePlayerTitle .. " has stopped reconning " .. "(" .. targetPlayerID .. ") " .. targetPlayerName .. ".", 2, true)
		exports.logs:addLog(thePlayer, 1, affectedElements, logMessage)
	end
end
addEvent("admin:stopReconning", true)
addEventHandler("admin:stopReconning", root, stopReconning, thePlayer)

-- /findserial [Player/ID/Serial] - By Skully (14/03/18) [Trial Admin]
function findSerial(thePlayer, commandName, targetOrSerial)
	if global:isPlayerTrialAdmin(thePlayer) and (getElementData(thePlayer, "loggedin") == 1) then
		if not (targetOrSerial) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player/ID/Serial]", thePlayer, 75, 230, 10)
			return false
		end

		local targetPlayer, targetPlayerName = global:getPlayerFromPartialNameOrID(targetOrSerial, thePlayer, true)
		local foundMatch = false
		local affectedElements = {thePlayer}

		if not (targetPlayer) then
			if (string.len(targetOrSerial) ~= 32) then
				outputChatBox("ERROR: That is not a valid serial or target player!", thePlayer, 255, 0, 0)
				return false
			end

			outputChatBox("Results for serial: " .. targetOrSerial, thePlayer, 75, 230, 10)
			local allSerials = exports.mysql:Query("SELECT `serial` FROM `accounts`")
			local matchedAccounts = {}
			--run for i, a in ipairs(x) do outputDebugString(x[i].serial) end
			for i, serialTable in ipairs(allSerials) do
				local parsedTable = split(allSerials[i].serial, ",")
				for k, theSerial in ipairs(parsedTable) do
					if theSerial == targetOrSerial then
						local parseMatchedAcc = exports.mysql:QueryString("SELECT `id` FROM `accounts` WHERE `serial` = (?);", serialTable.serial)
						table.insert(matchedAccounts, parseMatchedAcc)
					end
				end
			end

			if #matchedAccounts >= 1 then
				foundMatch = true

				for i, accountID in ipairs(matchedAccounts) do
					local accountName = exports.mysql:QueryString("SELECT `username` FROM `accounts` WHERE `id` = (?);", accountID)
					outputChatBox("   [" .. i .. "] " .. accountName, thePlayer, 75, 230, 10)
					table.insert(affectedElements, "ACC" .. accountID)
				end
				exports.logs:addLog(thePlayer, 1, affectedElements, "Looked for accounts with serial " .. targetOrSerial .. " and found " .. #matchedAccounts .. " accounts.")
			end
		else
			foundMatch = true
			local targetAccountName = getElementData(targetPlayer, "account:username")
			outputChatBox("Results for player: " .. targetPlayerName .. " (" .. targetAccountName .. ")", thePlayer, 75, 230, 10)

			local accountID = getElementData(targetPlayer, "account:id")
			table.insert(affectedElements, targetPlayer)
			local serialTable = exports.mysql:QueryString("SELECT `serial` FROM `accounts` WHERE `id` = (?);", accountID)
			local parsedTable = split(serialTable, ",")

			for i, serial in ipairs(parsedTable) do
				outputChatBox("   [" .. i .. "] " .. serial, thePlayer, 75, 230, 10)
			end
			local targetPlayerName = getPlayerName(targetPlayer):gsub("_", " ")
			exports.logs:addLog(thePlayer, 1, affectedElements, "Looked up " .. targetPlayerName .. "'s serial and found " .. #parsedTable .. " accounts.")
		end

		if not (foundMatch) then
			outputChatBox("   No matches!", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("findserial", findSerial)

-- /findaccserial [Account Name] - By Skully (14/03/18) [Trial Admin]
function findAccountSerial(thePlayer, commandName, accountName)
	if exports.global:isPlayerTrialAdmin(thePlayer) and (getElementData(thePlayer, "loggedin") == 1) then
		if not (accountName) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Account Name]", thePlayer, 75, 230, 10)
			return false
		end

		local serialTable = exports.mysql:QueryString("SELECT `serial` FROM `accounts` WHERE `username` = (?);", accountName)
		if not (serialTable) then
			outputChatBox("ERROR: The account '" .. accountName .. "' does not exist!", thePlayer, 255, 0, 0)
			return false
		end
		local accountID = exports.global:getAccountFromName(accountName)
		local affectedElements = {thePlayer, "ACC" .. accountID}

		outputChatBox("Serials for account '" .. accountName .. "':", thePlayer, 75, 230, 10)
		local parsedTable = split(serialTable, ",")
		for i, serial in ipairs(parsedTable) do
			outputChatBox("   [" .. i .. "] " .. serial, thePlayer, 75, 230, 10)
		end
		exports.logs:addLog(thePlayer, 1, affectedElements, "Looked up account's " .. accountName .. " serials and found " .. #parsedTable .. ".")
	end
end
addCommandHandler("findaccserial", findAccountSerial)
addCommandHandler("findaccountserial", findAccountSerial)

-- /findip [Player/ID/IP] - By Skully (14/03/18) [Trial Admin]
function findIP(thePlayer, commandName, targetOrIP)
	if global:isPlayerTrialAdmin(thePlayer) and (getElementData(thePlayer, "loggedin") == 1) then
		if not (targetOrIP) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player/ID/IP]", thePlayer, 75, 230, 10)
			return false
		end

		local targetPlayer, targetPlayerName = global:getPlayerFromPartialNameOrID(targetOrIP, thePlayer, true)
		local foundMatch = false
		local affectedElements = {thePlayer}

		if not (targetPlayer) then
			local _, count = string.gsub(targetOrIP, "%.", "")

			if (count ~= 3) then
				outputChatBox("ERROR: That is not a valid IP or target player!", thePlayer, 255, 0, 0)
				return false
			end

			outputChatBox("Results for serial: " .. targetOrIP, thePlayer, 75, 230, 10)
			local allIPs = exports.mysql:Query("SELECT `ip` FROM `accounts`")
			local matchedAccounts = {}
			
			for i, ipsTable in ipairs(allIPs) do
				local parsedTable = split(allIPs[i].ip, ",")
				for k, theIP in ipairs(parsedTable) do
					if theIP == targetOrIP then
						local parseMatchedAcc = exports.mysql:QueryString("SELECT `id` FROM `accounts` WHERE `ip` = (?);", ipsTable.ip)
						table.insert(matchedAccounts, parseMatchedAcc)
					end
				end
			end

			if #matchedAccounts >= 1 then
				foundMatch = true

				for i, accountID in ipairs(matchedAccounts) do
					local accountName = exports.mysql:QueryString("SELECT `username` FROM `accounts` WHERE `id` = (?);", accountID)
					outputChatBox("   [" .. i .. "] " .. accountName, thePlayer, 75, 230, 10)
					table.insert(affectedElements, "ACC" .. accountID)
				end
			end
			exports.logs:addLog(thePlayer, 1, affectedElements, "Looked up account's registered under IP " .. targetOrIP .. " and found " .. #matchedAccounts .. " accounts.")
		else
			foundMatch = true
			local targetAccountName = getElementData(targetPlayer, "account:username")
			table.insert(affectedElements, targetPlayer)
			outputChatBox("Results for player: " .. targetPlayerName .. " (" .. targetAccountName .. ")", thePlayer, 75, 230, 10)

			local accountID = getElementData(targetPlayer, "account:id")
			local ipsTable = exports.mysql:QueryString("SELECT `ip` FROM `accounts` WHERE `id` = (?);", accountID)
			local parsedTable = split(ipsTable, ",")

			for i, theIP in ipairs(parsedTable) do
				outputChatBox("   [" .. i .. "] " .. theIP, thePlayer, 75, 230, 10)
			end
			exports.logs:addLog(thePlayer, 1, affectedElements, "Looked up accounts registered under " .. targetAccountName .. "'s IP and found " .. #parsedTable .. ".")
		end

		if not (foundMatch) then
			outputChatBox("   No matches!", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("findip", findIP)

-- /findaccip [Account Name] - By Skully (14/03/18) [Trial Admin]
function findAccountIP(thePlayer, commandName, accountName)
	if exports.global:isPlayerTrialAdmin(thePlayer) and (getElementData(thePlayer, "loggedin") == 1) then
		if not (accountName) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Account Name]", thePlayer, 75, 230, 10)
			return false
		end

		local IPTable = exports.mysql:QueryString("SELECT `ip` FROM `accounts` WHERE `username` = (?);", accountName)
		if not (IPTable) then
			outputChatBox("ERROR: The account '" .. accountName .. "' does not exist!", thePlayer, 255, 0, 0)
			return false
		end
		local accountID = exports.global:getAccountFromName(accountName)
		local affectedElements = {thePlayer, "ACC" .. accountID}

		outputChatBox("IPs for account '" .. accountName .. "':", thePlayer, 75, 230, 10)
		local parsedTable = split(IPTable, ",")
		for i, theIP in ipairs(parsedTable) do
			outputChatBox("   [" .. i .. "] " .. theIP, thePlayer, 75, 230, 10)
		end
		exports.logs:addLog(thePlayer, 1, affectedElements, "Looked up account's " .. accountName .. " IPs and found " .. #parsedTable .. ".")
	end
end
addCommandHandler("findaccountip", findAccountIP)
addCommandHandler("findaccip", findAccountIP)

-- /findalts [Player/ID] - By Skully (15/03/18) [Trial Admin]
function findAlts(thePlayer, commandName, targetPlayer)
	if exports.global:isPlayerTrialAdmin(thePlayer) then
		if not (targetPlayer) or not tostring(targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player/ID/Account Name]", thePlayer, 75, 230, 10)
			return false
		end

		local targetPlayerAlt, targetPlayerName = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer, true)
		local accountID, accountName
		local foundAcc = false -- If we have found an account.

		if (targetPlayerAlt) then
			accountID = getElementData(targetPlayerAlt, "account:id")
			accountName = getElementData(targetPlayerAlt, "account:username")
			foundAcc = true
		else
			local foundAccount = exports.mysql:QuerySingle("SELECT `id`, username FROM `accounts` WHERE `username` = (?);", targetPlayer)
			if (foundAccount) then
				accountID = foundAccount.id
				accountName = foundAccount.username
				foundAcc = true
			end
		end

		if (foundAcc) then
			local characterTable = exports.mysql:Query("SELECT `name`, `status`, `last_used`, `hours`, `created` FROM `characters` WHERE `account` = (?);", accountID)
			local charName, charStatus, lastUsed, charHours, charCreated
			local affectedElements = {thePlayer, "ACC" .. accountID}

			outputChatBox("Characters of " .. accountName .. ":", thePlayer, 75, 230, 10)
			for i, theCharacter in ipairs(characterTable) do
				charName = tostring(theCharacter.name)
				local r, g, b = 75, 230, 10
				if getPlayerFromName(charName) then r, g, b = 255, 255, 0 end
				charName = charName:gsub("_", " ")
				if (tonumber(theCharacter.status) == 0) then charStatus = "Alive"
					elseif (tonumber(theCharacter.status) == 1) then charStatus = "Deceased"
					elseif (tonumber(theCharacter.status) == 2) then charStatus = "Incarcerated"
					else charStatus = "Unknown"
				end
				lastUsed = exports.global:convertTime(theCharacter.last_used)
				charHours = tonumber(theCharacter.hours)
				charCreated = exports.global:convertTime(theCharacter.created)

				outputChatBox("  [" .. i .. "] " .. charName .. " | ".. charHours .. " Hours | " .. charStatus .. " | Last Used: " .. lastUsed[2] .. " at " .. lastUsed[1] .. " | Created: " .. charCreated[2] .. " at " .. charCreated[1], thePlayer, r, g, b)
			end
			exports.logs:addLog(thePlayer, 1, affectedElements, "Looked up " .. accountName .. "'s characters and found " .. #characterTable .. ".")
		else
			outputChatBox("ERROR: That player does not exist or is not a valid account username!", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("findalts", findAlts)
addEvent("admin:findAlts", true)
addEventHandler("admin:findAlts", root, findAlts)


-- /findaccalts [Player/ID] - By Skully (15/03/18) [Trial Admin]
function findAccAlts(thePlayer, commandName, accountName)
	if (exports.global:isPlayerTrialAdmin(thePlayer)) then
		if not (accountName) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Account Name]", thePlayer, 75, 230, 10)
			return false
		end

		local accountID = exports.global:getAccountFromName(accountName)
		if not (accountID) then
			outputChatBox("ERROR: An account with the name '" .. accountName .. "' does not exist!", thePlayer, 255, 0, 0)
			return false
		end

		local characterTable = exports.mysql:Query("SELECT `name`, `status`, `last_used`, `hours`, `created` FROM `characters` WHERE `account` = (?);", accountID)
		local charName, charStatus, lastUsed, charHours, charCreated
		local affectedElements = {thePlayer, "ACC" .. accountID}

		outputChatBox("Characters of " .. accountName .. ":", thePlayer, 75, 230, 10)
		for i, theCharacter in ipairs(characterTable) do
			charName = tostring(theCharacter.name)
			local r, g, b = 75, 230, 10
			if getPlayerFromName(charName) then r, g, b = 255, 255, 0 end
			charName = charName:gsub("_", " ")
			if (tonumber(theCharacter.status) == 0) then charStatus = "Alive"
				elseif (tonumber(theCharacter.status) == 1) then charStatus = "Deceased"
				elseif (tonumber(theCharacter.status) == 2) then charStatus = "Incarcerated"
				else charStatus = "Unknown"
			end
			lastUsed = exports.global:convertTime(theCharacter.last_used)
			charHours = tonumber(theCharacter.hours)
			charCreated = exports.global:convertTime(theCharacter.created)

			outputChatBox("  [" .. i .. "] " .. charName .. " | ".. charHours .. " Hours | " .. charStatus .. " | Last Used: " .. lastUsed[2] .. " at " .. lastUsed[1] .. " | Created: " .. charCreated[2] .. " at " .. charCreated[1], thePlayer, r, g, b)
		end
		exports.logs:addLog(thePlayer, 1, affectedElements, "Looked up " .. accountName .. "'s characters and found " .. #charactersTable .. ".")
	end
end
addCommandHandler("findaccalts", findAccAlts)
addCommandHandler("findaccountalts", findAccAlts)

-- /givelicense [Player/ID] [License Type] - by Zil (17/03/18) [Helper]
function giveLicense(thePlayer, commandName, targetPlayer, licenseType)
	if exports.global:isPlayerHelper(thePlayer) and (getElementData(thePlayer, "loggedin") == 1) then
		if not (targetPlayer) or not tonumber(licenseType) or (tonumber(licenseType) <= 0) or (tonumber(licenseType) >= 4) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player/ID] [License Type]", thePlayer, 75, 230, 10)
			outputChatBox(" ", thePlayer)

			outputChatBox("License Types:", thePlayer, 75, 230, 10)
			outputChatBox("1 - Motor Vehicle License", thePlayer, 75, 230, 10)
			outputChatBox("2 - Bike License", thePlayer, 75, 230, 10)
			outputChatBox("3 - Boat License", thePlayer, 75, 230, 10)
			return false
		end
		local targetPlayer, targetPlayerName = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)

		if (targetPlayer) then
			local affectedElements = {thePlayer, targetPlayer}
			local licenseType = tonumber(licenseType)
			local licenses = getElementData(targetPlayer, "character:licenses")
			local licensesTable = split(licenses, ",") -- Convert from formatted string to table.

			local licenseName
			if (licenseType == 1) then licenseName = "Motor Vehicle" 
			elseif (licenseType == 2) then licenseName = "Bike"
			else licenseName = "Boat" end

			if (licensesTable[licenseType] == 1) then
				outputChatBox("ERROR: " .. targetPlayerName .. " already has a " .. licenseName .. " license!", thePlayer, 255, 0, 0)
			else
				local thePlayerTitle = exports.global:getStaffTitle(thePlayer, 1)
				licensesTable[licenseType] = 1
				-- Convert back to string format.
				local licenseString = ""
				for i, license in ipairs(licensesTable) do
					licenseString = licenseString .. license .. ","
				end

				setElementData(targetPlayer, "character:licenses", licenseString:sub(1, -2)) -- Remove the last character of the string, in our case it'd be a comma.
				outputChatBox("You have given " .. targetPlayerName .. " a " .. licenseName .. " license.", thePlayer, 75, 230, 10)
				outputChatBox(thePlayerTitle .. " has given you a " .. licenseName .. " license.", targetPlayer, 75, 230, 10)
				exports.global:sendMessageToManagers("[INFO] " .. thePlayerTitle .. " has given " .. targetPlayerName .. " a " .. licenseName .. " license.", false)
				exports.logs:addLog(thePlayer, 1, affectedElements, "Gave " .. targetPlayerName .. " a " .. licenseName .. " license.")
			end
		end
	end
end
addCommandHandler("givelicense", giveLicense)

-- /takelicense [Player/ID] [License Type] - by Zil (17/03/18) [Helper]
function takeLicense(thePlayer, commandName, targetPlayer, licenseType)
	if exports.global:isPlayerHelper(thePlayer) and (getElementData(thePlayer, "loggedin") == 1) then
		if not (targetPlayer) or not tonumber(licenseType) or (tonumber(licenseType) <= 0) or (tonumber(licenseType) >= 4) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player/ID] [License Type]", thePlayer, 75, 230, 10)
			outputChatBox(" ", thePlayer)

			outputChatBox("License Types:", thePlayer, 75, 230, 10)
			outputChatBox("1 - Motor Vehicle License", thePlayer, 75, 230, 10)
			outputChatBox("2 - Bike License", thePlayer, 75, 230, 10)
			outputChatBox("3 - Boat License", thePlayer, 75, 230, 10)
			return false
		end
		local targetPlayer, targetPlayerName = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)

		if (targetPlayer) then
			local affectedElements = {thePlayer, targetPlayer}
			local licenseType = tonumber(licenseType)
			local licenses = getElementData(targetPlayer, "character:licenses")
			local licensesTable = split(licenses, ",") -- Convert from formatted string to table.

			local licenseName
			if (licenseType == 1) then licenseName = "Motor Vehicle" 
			elseif (licenseType == 2) then licenseName = "Bike"
			else licenseName = "Boat" end

			if (licensesTable[licenseType] == 0) then
				outputChatBox("ERROR: " .. targetPlayerName .. " doesn't have a " .. licenseName .. " license!", thePlayer, 255, 0, 0)
			else
				local thePlayerTitle = exports.global:getStaffTitle(thePlayer, 1)
				licensesTable[licenseType] = 0
				-- Convert back to string format.
				local licenseString = ""
				for i, license in ipairs(licensesTable) do
					licenseString = licenseString .. license .. ","
				end

				setElementData(targetPlayer, "character:licenses", licenseString:sub(1, -2)) -- Remove the last character of the string, in our case it'd be a comma.
				outputChatBox("You have taken away " .. targetPlayerName .. "'s " .. licenseName .. " license.", thePlayer, 75, 230, 10)
				outputChatBox(thePlayerTitle .. " has taken away your " .. licenseName .. " license.", targetPlayer, 75, 230, 10)
				exports.global:sendMessageToManagers("[INFO] " .. thePlayerTitle .. " has taken away " .. targetPlayerName .. "'s " .. licenseName .. " license.", false)
				exports.logs:addLog(thePlayer, 1, affectedElements, "Took away " .. targetPlayerName .. "'s " .. licenseName .. " license.")
			end
		end
	end
end
addCommandHandler("takelicense", takeLicense)

-- /setskill [Player/ID] [Skill] [Level 0-10] - by Zil (17/03/18) [Helper]
function setSkill(thePlayer, commandName, targetPlayer, skill, skillLevel)
	if exports.global:isPlayerHelper(thePlayer) and (getElementData(thePlayer, "loggedin") == 1) then
		if not (targetPlayer) or not tonumber(skill) or not tonumber(skillLevel) or (tonumber(skill) < 0) or (tonumber(skill) > 5) or (tonumber(skillLevel) < 0) or (tonumber(skillLevel) > 10) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player/ID] [Skill] [Level 0-10]", thePlayer, 75, 230, 10)
			outputChatBox(" ", thePlayer)

			outputChatBox("Skills:", thePlayer, 75, 230, 10)
			outputChatBox("1 - Strength", thePlayer, 75, 230, 10)
			outputChatBox("2 - Marksmanship", thePlayer, 75, 230, 10)
			outputChatBox("3 - Mechanics", thePlayer, 75, 230, 10)
			outputChatBox("4 - Knowledge", thePlayer, 75, 230, 10)
			outputChatBox("5 - Stamina", thePlayer, 75, 230, 10)
			return false
		end
		local targetPlayer, targetPlayerName = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)

		if (targetPlayer)  then
			local affectedElements = {thePlayer, targetPlayer}
			local skill = tonumber(skill)
			local skillLevel = tonumber(skillLevel)
			local skills = getElementData(targetPlayer, "character:skills")
			local skillsTable = split(skills, ",") -- Convert from formatted string to table.

			local skillName
			if (skill == 1) then skillName = "Strength" 
			elseif (skill == 2) then skillName = "Marksmanship"
			elseif (skill == 3) then skillName = "Mechanics"
			elseif (skill == 4) then skillName = "Knowledge"
			else skillName = "Stamina" end

			if (skillsTable[skill] == skillLevel) then
				outputChatBox("ERROR: " .. targetPlayerName .. "'s " .. skillName:lower() .. " level is already at " .. skillLevel .. "!", thePlayer, 255, 0, 0)
			else
				local thePlayerTitle = exports.global:getStaffTitle(thePlayer, 1)
				skillsTable[skill] = skillLevel
				-- Convert back to string format.
				local skillString = ""
				for i, skillValue in ipairs(skillsTable) do
					skillString = skillString .. skillValue .. ","
				end

				setElementData(targetPlayer, "character:skills", skillString:sub(1, -2)) -- Remove the last character of the string, in our case it'd be a comma.
				outputChatBox("You have set " .. targetPlayerName .. "'s " .. skillName:lower() .. " level to " .. skillLevel .. ".", thePlayer, 75, 230, 10)
				outputChatBox(thePlayerTitle .. " has set your " .. skillName:lower() .. " level to " .. skillLevel .. ".", targetPlayer, 75, 230, 10)
				exports.global:sendMessageToManagers("[INFO] " .. thePlayerTitle .. " has set " .. targetPlayerName .. "'s " .. skillName:lower() .. " level to " .. skillLevel .. ".", false)
				exports.logs:addLog(thePlayer, 1, affectedElements, "Set " .. targetPlayerName .. "'s " .. skillName .. " level to " .. skillLevel .. ".")
			end
		end
	end
end
addCommandHandler("setskill", setSkill)


-- /marry [Player/ID] [Player/ID] - By Skully (07/05/18) [Helper]
function marryPlayers(thePlayer, commandName, targetPlayer, targetPlayer2)
	if exports.global:isPlayerHelper(thePlayer) then
		if not (targetPlayer) or not (targetPlayer2) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player/ID] [Player/ID]", thePlayer, 75, 230, 10)
			return
		end

		-- Check if target's exist.
		local targetPlayer, targetPlayerName = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)
		local targetPlayer2, targerPlayer2Name = exports.global:getPlayerFromPartialNameOrID(targetPlayer2, thePlayer)

		if targetPlayer and targetPlayer2 then

			-- Check to see if they are already married.
			local isTargetMarried = getElementData(targetPlayer, "character:marriedto")
			local isTarget2Married = getElementData(targetPlayer2, "character:marriedto")
			local targetPlayerID = getElementData(targetPlayer, "character:id")
			local targetPlayer2ID = getElementData(targetPlayer2, "character:id")

			if (isTargetMarried) == (targetPlayer2ID) then
				outputChatBox("ERROR: " .. targetPlayerName .. " is already married to " .. targerPlayer2Name .. "!", thePlayer, 255, 0, 0)
				return false
			end

			-- Check to see if attempting to marry same targets.
			if (targetPlayer == targetPlayer2) then
				outputChatBox("It would be great to get married to yourself, huh?", thePlayer, 255, 0, 0)
				return false
			end

			-- Set the data.
			setElementData(targetPlayer, "character:marriedto", targetPlayer2ID)
			setElementData(targetPlayer2, "character:marriedto", targetPlayerID)

			-- Outputs.
			local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
			outputChatBox(thePlayerName .. " has married you to " .. targetPlayer2Name .. ", congratulations!", targetPlayer, 0, 255, 0)
			outputChatBox(thePlayerName .. " has married you to " .. targetPlayerName .. ", congratulations!", targetPlayer2, 0, 255, 0)
			outputChatBox("You have married " .. targetPlayerName .. " to " .. targetPlayer2Name .. ".", thePlayer, 0, 255, 0)
			exports.global:sendMessage("[INFO] " .. thePlayerName .. " has married " .. targetPlayerName .. " to " .. targetPlayer2Name .. ".", 1, true)
			exports.logs:addLog(thePlayer, 1, {thePlayer, targetPlayer, targetPlayer2}, "Players have been married.")
		end
	end
end
addCommandHandler("marry", marryPlayers)

-- /divorce [Player/ID] [Player/ID] - By Zil & Skully (12/02/18) [Helper]
function divorcePlayers(thePlayer, commandName, targetPlayer, targetPlayer2)
	if exports.global:isPlayerHelper(thePlayer) then
		if not (targetPlayer) or not (targetPlayer2) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player/ID] [Player/ID]", thePlayer, 75, 230, 10)
			return
		end

		-- Check if target's exist.
		local targetPlayer, targetPlayerName = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)
		local targetPlayer2, targerPlayer2Name = exports.global:getPlayerFromPartialNameOrID(targetPlayer2, thePlayer)

		if targetPlayer and targetPlayer2 then

			-- Check to see if they are married.
			local isTargetMarried = getElementData(targetPlayer, "character:marriedto")
			local isTarget2Married = getElementData(targetPlayer2, "character:marriedto")
			local targetPlayerID = getElementData(targetPlayer, "character:id")
			local targetPlayer2ID = getElementData(targetPlayer2, "character:id")

			if (isTargetMarried) ~= (targetPlayer2ID) then
				outputChatBox("ERROR: " .. targetPlayerName .. " is not married to " .. targerPlayer2Name .. "!", thePlayer, 255, 0, 0)
				return false
			end

			-- Set the data.
			setElementData(targetPlayer, "character:marriedto", 0)
			setElementData(targetPlayer2, "character:marriedto", 0)

			-- Outputs.
			local thePlayerName = epxorts.global:getStaffTitle(thePlayer, 1)
			outputChatBox(thePlayerName .. " has divorced you from " .. targetPlayer2Name .. ".", targetPlayer, 0, 255, 0)
			outputChatBox(thePlayerName .. " has divorced you from " .. targetPlayerName .. ".", targetPlayer2, 0, 255, 0)
			outputChatBox("You have divorced " .. targetPlayerName .. " from " .. targetPlayer2Name .. ".", thePlayer, 0, 255, 0)
			exports.global:sendMessage("[INFO] " .. thePlayerName .. " has divorced " .. targetPlayerName .. " from " .. targetPlayer2Name .. ".", 1, true)
			exports.logs:addLog(thePlayer, 1, {thePlayer, targetPlayer, targetPlayer2}, "Players have been divorced.")
		end
	end
end
addCommandHandler("divorce", divorcePlayers)

-- /setmoney [Player/ID] [Amount] - by Light & Skully (07/05/2018) [Manager]
function setPlayerMoney(thePlayer, commandName, targetPlayer, amount)
	if (exports.global:isPlayerManager(thePlayer)) then
		-- Checks the syntax used is correct.
		if not (targetPlayer) or not (tonumber(amount)) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player/ID] [Amount]", thePlayer, 75, 230, 10) 
			return
		end

		local amount = tonumber(amount)
		
		-- Checks to see if the amount stated is above 1 and less than 1,000,000. (Excluding lead managers.)
		if (amount > 1000000) or (amount < 0) and not exports.global:isPlayerLeadManager(thePlayer) then
			outputChatBox("ERROR: Amount must be between 1 and 1,000,000.", thePlayer, 255, 0, 0)
			return false
		end

		-- Fetch the target player, and their name
		local targetPlayer, targetPlayerName = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer) 
		if (targetPlayer) then
			exports.blackhawk:setElementDataEx(targetPlayer, "character:bankmoney", amount)

			-- Outputs
			local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
			outputChatBox("You have set " .. targetPlayerName .. "'s bank balance to $" .. exports.global:formatNumber(amount) .. ".", thePlayer, 0, 255, 0)
			outputChatBox(thePlayerName .. " has set your bank balance to $" .. exports.global:formatNumber(amount) .. ".", targetPlayer, 0, 255, 0)
			exports.global:sendMessage("[INFO] " .. thePlayerName .. " has set " .. targetPlayerName .. "'s bank balance to $" .. exports.global:formatNumber(amount) .. ".", 1, true)
			exports.global:sendMessageToManagers("[WARN] " .. thePlayerName .. " has set " .. targetPlayerName .. "'s bank balance to $" .. exports.global:formatNumber(amount) .. ".", true)
			exports.logs:addLog(thePlayer, 1, {thePlayer, targetPlayer}, thePlayerName .. " has set " .. targetPlayerName .. "'s bank balance to " .. amount .. ".")
		end	
	end
end
addCommandHandler("setmoney", setPlayerMoney)

-- /givemoney [Player/ID] [Amount] - by Light & Skully (07/05/2018) [Trial Developer, Lead Developer]
function giveMoneyToPlayer(thePlayer, commandName, targetPlayer, amount)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (targetPlayer) or not (tonumber(amount)) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player/ID] [Amount]", thePlayer, 75, 230, 10) 
			return
		end

		local amount = tonumber(amount)
		-- Check to see if amount is within 0 and 500,000. (Excluding Lead Managers.)
		if (amount > 500000) or (amount < 0) and not exports.global:isPlayerLeadManager(thePlayer) then
			outputChatBox("ERROR: Amount must be between 1 and 500,000.", thePlayer, 255, 0, 0)
			return false
		end

		local targetPlayer, targetPlayerName = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)
		if (targetPlayer) then
			-- Get the character's previous amount and add to new amount.
			local targetMoney = getElementData(targetPlayer, "character:money")
			exports.blackhawk:setElementDataEx(targetPlayer, "character:money", tonumber(targetMoney) + amount)
			givePlayerMoney(targetPlayer, amount)
			
			-- Outputs.
			local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
			local money = exports.global:formatNumber(amount)
			outputChatBox("You have given " .. targetPlayerName .. " $" .. money .. ".", targetPlayer, 0, 255, 0)
			outputChatBox(thePlayerName .. " has given you $" .. money .. ".", targetPlayer, 0, 255, 0)
			exports.global:sendMessage("[INFO] " .. thePlayerName .. " has given " .. targetPlayerName .. " $" .. money .. ".", 1, true)
			exports.global:sendMessageToManagers("[WARN] " .. thePlayerName .. " has given " .. targetPlayerName .. " $" .. money .. ".", true)
			exports.logs:addLog(thePlayer, 1, {thePlayer, targetPlayer}, thePlayerName .. " gave " .. targetPlayerName .. " $" .. money .. ".")
		end
	end
end
addCommandHandler("givemoney", giveMoneyToPlayer)

function getGotoLocations(thePlayer)
	local gotoLocations = exports.mysql:Query("SELECT * FROM `goto_locations`;")
	triggerClientEvent(thePlayer, "admin:populateGotoList", resourceRoot, gotoLocations)
end
addEvent("admin:getGotoLocations", true)
addEventHandler("admin:getGotoLocations", root, getGotoLocations)

-- /addgoto [Command] [Name] - by Zil (07/07/18) [Lead Admin]
function addGoto(thePlayer, commandName, command, ...)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		if not (...) or not (command) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Command] [Name]", thePlayer, 75, 230, 10)
			outputChatBox("[Command] is used with /gotoplace, and [Name] is used as a short description of the location.", thePlayer, 75, 230, 10)
			outputChatBox(" ", thePlayer)
			return
		end
		command = command:lower()

		local commands = exports.mysql:Query("SELECT `command` FROM `goto_locations`;")
		for i, goto in ipairs(commands) do
			if (goto["command"] == command) then
				outputChatBox("ERROR: Command already exists! Double-check there's no such goto location already, if not use a different command.", thePlayer, 255, 0, 0)
				return
			end
		end

		local name = table.concat({...}, " ")
		local x, y, z = getElementPosition(thePlayer)
		local rx, ry, rz = getElementRotation(thePlayer)
		local int = getElementInterior(thePlayer)
		local dim = getElementDimension(thePlayer)

		x = x + ((math.cos(math.rad(rz))) * 3)
		y = y + ((math.sin(math.rad(rz))) * 3)
		local location = tostring(x) .. "," .. tostring(y) .. "," .. tostring(z) .. "," .. tostring(rz) .. "," .. tostring(int) .. "," .. tostring(dim)

		exports.mysql:Execute("INSERT INTO `goto_locations` (`id`, `location_name`, `location`, `command`) VALUES (NULL, (?), (?), (?))", name, location, command)
		exports.logs:addLog(thePlayer, 1, thePlayer, "Added goto location with the name " .. name .. " and location " .. location .. ".")

		local thePlayerTitle = exports.global:getStaffTitle(thePlayer)
		outputChatBox("You have added a goto location with name " .. name .. " and command " .. command .. ".", thePlayer, 0, 255, 0)
		exports.global:sendMessageToManagers("[WARN] " .. thePlayerTitle .. " has created a goto location with name " .. name .. " and command " .. command .. ".", false)
	end
end
addCommandHandler("addgoto", addGoto)

function deleteGoto(id)
	local thePlayerTitle = exports.global:getStaffTitle(source)
	exports.mysql:Execute("DELETE FROM `goto_locations` WHERE `id` = (?)", id)

	outputChatBox("You have deleted goto location ID " .. id .. ".", thePlayer, 0, 255, 0)
	exports.global:sendMessageToManagers("[WARN] " .. thePlayerTitle .. " has deleted goto location ID " .. id .. ".", true)
end
addEvent("admin:deleteGoto", true)
addEventHandler("admin:deleteGoto", root, deleteGoto)

-- /gotoplace [Name] - by Zil (07/07/18) [Helper]
function gotoPlace(thePlayer, commandName, name, targetPlayer)
	if (exports.global:isPlayerHelper(thePlayer)) then
		if not (name) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Name] (Target Player)", thePlayer, 75, 230, 10) 
			return
		end
		local gotoTable = exports.mysql:Query("SELECT `location_name`, `location` FROM `goto_locations` WHERE `command` = (?);", name:lower())

		if not (gotoTable) or (#gotoTable == 0) then
			outputChatBox("ERROR: Couldn't find '" .. name:lower() ..  "'. Check possible locations with /gotolist.", thePlayer, 255, 0, 0)
			return
		end

		local locationTable = split(gotoTable[1]["location"], ',')
		local locationName = gotoTable[1]["location_name"]

		local affectedElements = {thePlayer}
		local logMessage = "Teleported themselves to gotoplace named " .. locationName .. "."

		if (targetPlayer) then
			local targetPlayer, targetPlayerName = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)
			local thePlayerTitle = exports.global:getStaffTitle(thePlayer, 1)

			if (targetPlayer) then
				if (getPedOccupiedVehicle(targetPlayer)) then
					local targetPlayerVehicle = getPedOccupiedVehicle(targetPlayer)
					table.insert(affectedElements, targetPlayerVehicle)
				end

				if (targetPlayer ~= thePlayer) then 
					table.insert(affectedElements, targetPlayer)
					logMessage = "Teleported " .. targetPlayerName .. " to gotoplace named " .. locationName .. "."
				end

				exports.global:elementEnterInterior(targetPlayer, {locationTable[1], locationTable[2], locationTable[3]}, {0, 0, locationTable[4]}, locationTable[5], locationTable[6], true)
				outputChatBox("You have teleported " .. targetPlayerName .. " to " .. locationName .. ".", thePlayer, 0, 255, 0)
				outputChatBox(thePlayerTitle .. " has teleported you to " .. locationName .. "." , targetPlayer, 0, 255, 0)
			end
		else
			exports.global:elementEnterInterior(thePlayer, {locationTable[1], locationTable[2], locationTable[3]}, {0, 0, locationTable[4]}, locationTable[5], locationTable[6], true)
			outputChatBox("You have teleported to " .. locationName .. ".", thePlayer, 0, 255, 0)
		end
		exports.logs:addLog(thePlayer, 1, affectedElements, logMessage)
	end
end
addCommandHandler("gotoplace", gotoPlace)
addEvent("admin:gotoPlace", true)
addEventHandler("admin:gotoPlace", root, gotoPlace)