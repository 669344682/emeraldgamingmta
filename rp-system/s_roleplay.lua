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

-- Main chat handler for default MTA chat.
function chatMain(message, messageType)
	if (message) then -- If the player has input a message.
		if (messageType == 0) then -- If the player is speaking.
			cancelEvent() -- Cancel the stock MTA /say
			playerSay(source, "say", message) -- Runs the playerSay function below.
		end

		if (messageType == 1) then -- If the player executed /me
			cancelEvent() -- Cancel the stock MTA /me
			meMessage(source, "me", message) -- Runs the meMessage function below.
		end

		if (messageType == 2) then -- If the player executed team say
			cancelEvent() -- Cancel the stock Y message
		end
	end
end
addEventHandler("onPlayerChat", getRootElement(), chatMain)

function meMessage(thePlayer, commandName, ...)
	if (getElementData(thePlayer, "loggedin") == 1) then
		local message = table.concat({...}, " ") -- Places the /me message the player wrote into variable
		local thePlayerName = getPlayerName(thePlayer); thePlayerName = thePlayerName:gsub("_", " ")
		local affectedPlayers = {}

		for key, nearbyPlayer in ipairs(getElementsByType("player")) do
			local distance = exports.global:getElementDistance(thePlayer, nearbyPlayer)
			if distance < 25 then -- If players are less then 20 in distance to each other.
				local thePlayerDimension = getElementDimension(thePlayer)
				local thePlayerInterior = getElementInterior(thePlayer)
				local nearbyPlayerDimension = getElementDimension(nearbyPlayer)
				local nearbyPlayerInterior = getElementInterior(nearbyPlayer)
				-- All variables above save the players int/dim and the nearby players to be checked below.
				if (nearbyPlayerDimension == thePlayerDimension) and (nearbyPlayerInterior == thePlayerInterior) then
					outputChatBox("◆ " .. thePlayerName .. " " .. message, nearbyPlayer, 230, 25, 140)
					table.insert(affectedPlayers, nearbyPlayer)
				end
			end
		end
		exports.logs:addLog(thePlayer, 24, affectedPlayers, message)
	end
end

function sendLocalMe(thePlayer, ...)
	meMessage(thePlayer, "me", ...)
end
addEvent("rp:sendLocalMe", true)
addEventHandler("rp:sendLocalMe", root, sendLocalMe)

-- /do [Message] - by Skully (27/96/17) [Player]
function doMessage(thePlayer, commandName, ...)
	if (getElementData(thePlayer, "loggedin") == 1) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 75, 230, 10)
		else
			local message = table.concat({...}," ") -- Places the /do message the player wrote into a variable.
			local thePlayerName = getPlayerName(thePlayer); thePlayerName = thePlayerName:gsub("_", " ")
			local affectedPlayers = {}

			for key, nearbyPlayer in ipairs(getElementsByType("player")) do
				local distance = exports.global:getElementDistance(thePlayer, nearbyPlayer)

				if distance < 25 then -- If players are less then 20 in distance to each other.
					local thePlayerDimension = getElementDimension(thePlayer)
					local thePlayerInterior = getElementInterior(thePlayer)
					local nearbyPlayerDimension = getElementDimension(nearbyPlayer)
					local nearbyPlayerInterior = getElementInterior(nearbyPlayer)
					-- All variables above save the players int/dim and the nearby players to be checked below.

					if (nearbyPlayerDimension == thePlayerDimension) and (nearbyPlayerInterior == thePlayerInterior) then
						local logged = getElementData(nearbyPlayer, "loggedin")
						if (logged == 1) then
							outputChatBox("◇ " .. message .. " (( " .. thePlayerName .. " ))", nearbyPlayer, 230, 25, 140)
							table.insert(affectedPlayers, nearbyPlayer)
						end
					end
				end
			end
			exports.logs:addLog(thePlayer, 25, affectedPlayers, message)
		end
	end
end
addCommandHandler("do", doMessage, false, false)

function sendLocalDo(thePlayer, ...)
	doMessage(thePlayer, "do", ...)
end
addEvent("rp:sendLocalDo", true)
addEventHandler("rp:sendLocalDo", root, sendLocalDo)

function sendLocalRP(theElement, rpType, message)
	if isElement(theElement) then
		for i, nearbyPlayer in ipairs(getElementsByType("player")) do
			local distance = exports.global:getElementDistance(theElement, nearbyPlayer)

			if (distance < 25) then
				local elementDimension = getElementDimension(theElement)
				local elementInterior = getElementInterior(theElement)
				local nearbyPlayerDimension = getElementDimension(nearbyPlayer)
				local nearbyPlayerInterior = getElementInterior(nearbyPlayer)
				
				if (elementDimension == nearbyPlayerDimension) and (elementInterior == nearbyPlayerInterior) then
					local logged = getElementData(nearbyPlayer, "loggedin")
					if (logged == 1) then
						if (rpType == "me") then outputChatBox("◆ " .. message, nearbyPlayer, 230, 25, 140)
						elseif (rpType == "do") then outputChatBox("◇ " .. message, nearbyPlayer, 230, 25, 140)
						else
							exports.global:outputDebug("@sendLocalRP: Invalid rpType provided, got '" .. tostring(rpType) .. "'.")
						end
					end
				end
			end
		end
	end
end
addEvent("rp:sendLocalRP", true)
addEventHandler("rp:sendLocalRP", root, sendLocalRP)


-- /say [Message] - by Skully (03/06/18) [Player]
function playerSay(thePlayer, commandName, ...)
	if (getElementData(thePlayer, "loggedin") == 1) then
		if isPedDead(thePlayer) then return end
		local affectedElements = {}
		local message = table.concat({...}, " ") -- Places the /me message the player wrote into variable
		message = message:gsub("^%l", string.upper) -- Set the first character of the message a capital.
		local rawMessage = message -- Used by chat bubbles.
		
		local thePlayerName = getPlayerName(thePlayer):gsub("_", " ")
		local thePlayerLanguage = "[English]" -- Get the player's language and add to message. @requires language-system
		message = thePlayerLanguage .. " " .. thePlayerName .. " says: " .. message
		
		-- Firstly, handle showing the message to the source player themselves.
		local thePlayerVehicle = getPedOccupiedVehicle(thePlayer)
		if (thePlayerVehicle) then
			table.insert(affectedElements, thePlayerVehicle)
			local windowState = getElementData(thePlayerVehicle, "vehicle:windows")
			if (windowState == 0) then -- If the windows are up.
				message = "((In Car)) " .. message
				for i, vehPlayer in pairs(getVehicleOccupants(thePlayerVehicle)) do
					if (vehPlayer ~= thePlayer) then
						outputChatBox(message, vehPlayer, 255, 255, 255)
						table.insert(affectedElements, vehPlayer)
					end
				end
			end
		end

		outputChatBox(message, thePlayer, 255, 255, 255)
		triggerClientEvent(thePlayer, "rp:createChatBubble", thePlayer, rawMessage, "say")

		-- Output message to any nearby players who can hear the source player.
		local pDim, pInt = getElementDimension(thePlayer), getElementInterior(thePlayer)
		for i, nearbyPlayer in ipairs(getElementsByType("player")) do
			if (thePlayer ~= nearbyPlayer) then
				local distance = exports.global:getElementDistance(thePlayer, nearbyPlayer)
				if (distance <= 20) and not isPedDead(nearbyPlayer) then
					local nDim, nInt = getElementDimension(nearbyPlayer), getElementInterior(nearbyPlayer)
					if (pDim == nDim) and (pInt == nInt) then
						local rgb = 255
						if (distance > 5) then rgb = 230
							elseif (distance > 9) then rgb = 195
							elseif (distance > 13) then rgb = 170
							elseif (distance > 16) then rgb = 130
						end
						local nearbyPlayerVehicle = getPedOccupiedVehicle(nearbyPlayer)
						if not (nearbyPlayerVehicle) then
							if (thePlayerVehicle) then
								local windowState = getElementData(thePlayerVehicle, "vehicle:windows")
								if (windowState == 1) then
									outputChatBox(message, nearbyPlayer, rgb, rgb, rgb)
									triggerClientEvent(nearbyPlayer, "rp:createChatBubble", thePlayer, rawMessage, "say")
									table.insert(affectedElements, nearbyPlayer)
								end
							else
								outputChatBox(message, nearbyPlayer, rgb, rgb, rgb)
								triggerClientEvent(nearbyPlayer, "rp:createChatBubble", thePlayer, rawMessage, "say")
								table.insert(affectedElements, nearbyPlayer)
							end
						else
							local windowState = getElementData(nearbyPlayerVehicle, "vehicle:windows")
							if (windowState == 1) then
								outputChatBox(message, nearbyPlayer, rgb, rgb, rgb)
								triggerClientEvent(nearbyPlayer, "rp:createChatBubble", thePlayer, rawMessage, "say")
								table.insert(affectedElements, nearbyPlayer)
							end
						end
					end
				end
			end
		end
		table.insert(affectedElements, thePlayer)
		exports.logs:addLog(thePlayer, 22, affectedElements, message)
	end
end

-- /b [Message] - by Zil & Skully (27/06/17) [Player]
function OOCChat(thePlayer, commandName, ...)
	if (getElementData(thePlayer, "loggedin") == 1) then
		local message = table.concat({...}," ") -- Places the /b message the player wrote into variable
		local thePlayerName = getPlayerName(thePlayer); thePlayerName = thePlayerName:gsub("_", " ")
		local thePlayerUsername = getElementData(thePlayer, "account:username")
		local muteStatus = getElementData(thePlayer, "account:muted")

		local displayName = thePlayerName
		local r, g, b = 215, 215, 215

		if (exports.global:isPlayerOnStaffDuty(thePlayer) and (getElementData(thePlayer, "var:hiddenAdmin") ~= 1)) then -- if the player is staff and is on duty, his username and color will be displayed instead of usual chat
			local staffLevel = exports.global:getStaffLevel(thePlayer)
			
			if (staffLevel == 1) then r, g, b = 0, 234, 76
			elseif (staffLevel > 1 and staffLevel < 5) then r, g, b = 255, 200, 0
			elseif (staffLevel == 5 or staffLevel == 6) then r, g, b = 255, 0, 0
			end

			displayName = thePlayerUsername
		end

		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 75, 230, 10)
		else
			if (tonumber(muteStatus) == 0) then
				local affectedPlayers = {}
				for key, nearbyPlayer in ipairs(getElementsByType("player")) do
					local distance = exports.global:getElementDistance(thePlayer, nearbyPlayer)

					if distance < 20 then -- If players are less then 20 in distance to each other.
						local thePlayerDimension = getElementDimension(thePlayer)
						local thePlayerInterior = getElementInterior(thePlayer)
						local nearbyPlayerDimension = getElementDimension(nearbyPlayer)
						local nearbyPlayerInterior = getElementInterior(nearbyPlayer)
						-- All variables above save the players int/dim and the nearby players to be checked below.

						if (nearbyPlayerDimension == thePlayerDimension) and (nearbyPlayerInterior == thePlayerInterior) then
							outputChatBox("(( " .. displayName .. ": " .. message .. " ))", nearbyPlayer, r, g, b)
							table.insert(affectedPlayers, nearbyPlayer)
						end
					end
				end
				exports.logs:addLog(thePlayer, 23, affectedPlayers, message)
			else
				outputChatBox("You are currently muted.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("b", OOCChat, false, false)
addCommandHandler("LocalOOC", OOCChat, false, false)

-- /s [Message] - by Skully & Zil (24/08/17) [Player]
function playerShout(thePlayer, commandName, ...)
	if (getElementData(thePlayer, "loggedin") == 1) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 75, 230, 10)
		else
			local message = table.concat({...}," ") -- Places the /me message the player wrote into variable
			local thePlayerName = getPlayerName(thePlayer); thePlayerName = thePlayerName:gsub("_", " ")
			local thePlayerVehicle = getPedOccupiedVehicle(thePlayer)
			local affectedElements = {}

			for key, nearbyPlayer in ipairs(getElementsByType("player")) do
				local distance = exports.global:getElementDistance(thePlayer, nearbyPlayer)

				if distance < 30 then -- If players are less then 10 in distance to each other.
					local rgb = 255
					if (distance > 10) then rgb = 230
						elseif (distance > 14) then rgb = 195
						elseif (distance > 18) then rgb = 170
						elseif (distance > 23) then rgb = 130
					end

					local thePlayerDimension, thePlayerInterior = getElementDimension(thePlayer), getElementInterior(thePlayer)
					local nearbyPlayerDimension, nearbyPlayerInterior = getElementDimension(nearbyPlayer), getElementInterior(nearbyPlayer)

					-- All variables above save the players int/dim and the nearby players to be checked below.
					local message = message:gsub("^%l", string.upper) -- Set the first character of the message a capital.

					if (nearbyPlayerDimension == thePlayerDimension) and (nearbyPlayerInterior == thePlayerInterior) then
						local logged = tonumber(getElementData(nearbyPlayer, "loggedin"))
						if (logged == 1) then
							if (thePlayerVehicle) then
								thePlayerVehicleWindowsState = getElementData(thePlayerVehicle, "vehicle:windowsopen", false)
								
								if (getPedOccupiedVehicle(nearbyPlayer) == thePlayerVehicle) then -- If the nearby player is in the same vehicle.
									outputChatBox("((In Car)) " .. thePlayerName .. " shouts: " .. message .. "!", nearbyPlayer, rgb, rgb, rgb)
									table.insert(affectedElements, nearbyPlayer)
								else
									if (thePlayerVehicleWindowsState == 1) then -- Vehicle window is open, so we can let the other players outside the vehicle know what thePlayer is saying.
										outputChatBox("((In Car)) " .. thePlayerName .. " shouts: " .. message .. "!", nearbyPlayer, rgb, rgb, rgb)
										table.insert(affectedElements, nearbyPlayer)
									elseif (distance < 10) then -- Windows are closed, but the player is relatively close, so we can let them hear.
										outputChatBox("((In Car)) " .. thePlayerName .. " shouts: " .. message .. "!", nearbyPlayer, rgb, rgb, rgb)
										table.insert(affectedElements, nearbyPlayer)
									end
								end
							else
								outputChatBox(thePlayerName .. " shouts: " .. message .. "!", nearbyPlayer, rgb, rgb, rgb)
								table.insert(affectedElements, nearbyPlayer)
							end
						end
					end
				end
			end

			local nearbyInts = exports.global:getNearbyElements(thePlayer, "interior", 8)
			for i, interior in ipairs(nearbyInts) do
				for v, nearbyPlayer in ipairs(getElementsByType("player")) do
					local px, py, pz = getElementPosition(nearbyPlayer)
					local x, y, z = unpack(getElementData(interior, "interior:exit"))
					if getDistanceBetweenPoints3D(x, y, z, px, py, pz) < 15 then
						outputChatBox(thePlayerName .. " shouts: " .. message .. "!", nearbyPlayer, 130, 130, 130)
					end
				end
			end

			local logMessage
			if (thePlayerVehicle) then -- If thePlayer is in a vehicle we need to add a prefix.
				logMessage = "((In Car)) " .. message
				table.insert(affectedElements, thePlayerVehicle)
			else
				logMessage = message
			end
			exports.logs:addLog(thePlayer, 29, affectedElements, logMessage)
		end
	end
end
addCommandHandler("s", playerShout, false, false)

-- /c [Message] - by Skully & Zil (a bit) (23/08/17) [Player]
function playerC(thePlayer, commandName, ...)
	if (getElementData(thePlayer, "loggedin") == 1) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 75, 230, 10)
		else
			local message = table.concat({...}," ") -- Places the /me message the player wrote into variable
			local thePlayerName = getPlayerName(thePlayer); thePlayerName = thePlayerName:gsub("_", " ")
			local thePlayerVehicle = getPedOccupiedVehicle(thePlayer)
			local affectedElements = {}

			for key, nearbyPlayer in ipairs(getElementsByType("player")) do
				local distance = exports.global:getElementDistance(thePlayer, nearbyPlayer)

				if distance < 8 then -- If players are less than 8 in distance to each other.
					local r, g, b = nil
					if (distance < 2) then
					r, g, b = 255, 255, 255
					elseif (distance < 3) then
						r, g, b = 255, 230, 230
					elseif (distance < 4) then
						r, g, b = 200, 200, 200
					elseif (distance < 5) then
						r, g, b = 180, 180, 180
					elseif (distance < 6) then
						r, g, b = 170, 170, 170
					elseif (distance < 8) then
						r, g, b = 130, 130, 130
					else
						r, g, b = 255, 255, 255
					end

					local thePlayerDimension = getElementDimension(thePlayer)
					local thePlayerInterior = getElementInterior(thePlayer)
					local nearbyPlayerDimension = getElementDimension(nearbyPlayer)
					local nearbyPlayerInterior = getElementInterior(nearbyPlayer)
					-- All variables above save the players int/dim and the nearby players to be checked below.
					local message = message:gsub("^%l", string.upper) -- Set the first character of the message a capital.

					if (nearbyPlayerDimension == thePlayerDimension) and (nearbyPlayerInterior == thePlayerInterior) then
						local logged = tonumber(getElementData(nearbyPlayer, "loggedin"))
						if (logged == 1) then
							if (thePlayerVehicle) then
								thePlayerVehicleWindowsState = getElementData(thePlayerVehicle, "vehicle:windowsopen", false)
								
								if (getPedOccupiedVehicle(nearbyPlayer) == thePlayerVehicle) then -- If the nearby player is in the same vehicle.
									if (thePlayerVehicleWindowsState == 0) then -- If the vehicle window is closed.
										outputChatBox("((In Car)) " .. thePlayerName .. " whispers: " .. message, nearbyPlayer, r, g, b)
										table.insert(affectedElements, nearbyPlayer)
									else
										local thePlayerVehicleOccupants = getVehicleOccupants(thePlayerVehicle)
										for seat, player in pairs(thePlayerVehicleOccupants) do
											if (player and getElementType(player) == "player") then
												outputChatBox("((In Car)) " .. thePlayerName .. " whispers: " .. message, player, r, g, b)
												table.insert(affectedElements, player)
											end
										end
									end
								else
									if (thePlayerVehicleWindowsState == 1) then -- Vehicle window is open, so we can let the other players outside the vehicle know what thePlayer is saying.
										outputChatBox("((In Car)) " .. thePlayerName .. " whispers: " .. message, nearbyPlayer, r, g, b)
										table.insert(affectedElements, nearbyPlayer)
									end
								end

							else
								outputChatBox(thePlayerName .. " whispers: " .. message, nearbyPlayer, r, g, b)
								table.insert(affectedElements, nearbyPlayer)
							end
						end
					end
				end
			end
			local logMessage = ""
			if (thePlayerVehicle) then
				logMessage = "((In Car)) "
				table.insert(affectedElements, thePlayerVehicle)
			end
			logMessage = logMessage .. message
			exports.logs:addLog(thePlayer, 21, affectedElements, logMessage)
		end
	end
end
addCommandHandler("c", playerC, false, false)

function playerWhisper(thePlayer, commandName, targetPlayer, ...)
	if (getElementData(thePlayer, "loggedin") == 1) then
		if not (targetPlayer) or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Target Player] [Message]", thePlayer, 75, 230, 10)
		else
			local theWhisper = table.concat({...}, " "):gsub("^%l", string.upper)
			local targetPlayer = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)
			local sentToTarget = false

			-- If the target player doesn't exist.
			if not (targetPlayer) then
				outputChatBox("ERROR: That player does not exist!", thePlayer, 255, 0, 0)
				return false
			end
			local affectedElements = {}
			local targetPlayerName = getPlayerName(targetPlayer); targetPlayerName = targetPlayerName:gsub("_", " ")
			local thePlayerName = getPlayerName(thePlayer); thePlayerName = thePlayerName:gsub("_", " ")

			for key, nearbyPlayer in ipairs(getElementsByType("player")) do
				local distance = exports.global:getElementDistance(thePlayer, nearbyPlayer)

				if distance < 3 then -- If players are less than 3 in distance to each other.
					local thePlayerDimension = getElementDimension(thePlayer)
					local thePlayerInterior = getElementInterior(thePlayer)
					local nearbyPlayerDimension = getElementDimension(nearbyPlayer)
					local nearbyPlayerInterior = getElementInterior(nearbyPlayer)
					-- All variables above save the players int/dim and the nearby players to be checked below.

					if (nearbyPlayerDimension == thePlayerDimension) and (nearbyPlayerInterior == thePlayerInterior) then
						local logged = tonumber(getElementData(nearbyPlayer, "loggedin"))
						if (logged == 1) then
							-- If the player is whispering to themself.
							if (targetPlayer == thePlayer) then
								outputChatBox(thePlayerName .. " whispers: " .. theWhisper, nearbyPlayer, 255, 255, 255)
								table.insert(affectedElements, nearbyPlayer)
								exports.logs:addLog(thePlayer, 21, affectedElements, theWhisper)
								break
							elseif (nearbyPlayer == targetPlayer) and (targetPlayer ~= thePlayer) then sentToTarget = true end

							if not (nearbyPlayer == thePlayer) then 
								outputChatBox(thePlayerName .. " whispers to " .. targetPlayerName .. ": " .. theWhisper, nearbyPlayer, 255, 255, 255)
							end

							table.insert(affectedElements, nearbyPlayer)
							exports.logs:addLog(thePlayer, 21, affectedElements, theWhisper)
						else
							outputChatBox("ERROR: That player is not logged in!", thetPlayer, 255, 0, 0)
						end
					end
				elseif (nearbyPlayer == targetPlayer) then
					outputChatBox("ERROR: You are too far away from that player to whisper to them!", thePlayer, 255, 0, 0)
					return false
				end
			end

			if (sentToTarget) then
				sendAme(thePlayer, "ame", "whispers to " .. targetPlayerName .. ". ")
				outputChatBox(thePlayerName .. " whispers to " .. targetPlayerName .. ": " .. theWhisper, thePlayer, 255, 255, 255)
			else
				sendAme(thePlayer, "ame", "whispers to themself.")
			end
		end
	end
end
addCommandHandler("w", playerWhisper)
addCommandHandler("whisper", playerWhisper)

function sendAme(thePlayer, commandName, ...)
	if not (...) then
		outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 75, 230, 10)
	else
		local message = table.concat({...}, " ")
		local thePlayerName = getPlayerName(thePlayer):gsub("_", " ")
		triggerClientEvent("rp:createChatBubble", thePlayer, thePlayerName .. " " .. message, "ame")
		outputChatBox("* " .. thePlayerName .. " " .. message .. " *", thePlayer)
		exports.logs:addLog(thePlayer, 26, {thePlayer}, thePlayerName .. " " .. message)
	end
end
addCommandHandler("ame", sendAme)

function sendAmeEvent(...)
	sendAme(source, "ame", ...)
end
addEvent("rp:sendAme", true)
addEventHandler("rp:sendAme", root, sendAmeEvent)

function sendAdo(thePlayer, commandName, ...)
	if not (...) then
		outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 75, 230, 10)
	else
		local message = table.concat({...}, " ")
		local thePlayerName = getPlayerName(thePlayer):gsub("_", " ")
		triggerClientEvent("rp:createChatBubble", thePlayer, message .. " (( " .. thePlayerName .. " ))", "ado")
		outputChatBox("* " .. message .. " (( " .. thePlayerName .. " )) *", thePlayer)
		exports.logs:addLog(thePlayer, 27, {thePlayer}, message .. " (( " .. thePlayerName .. " ))")
	end
end
addCommandHandler("ado", sendAdo)

function sendAdoEvent(...)
	sendAdo(source, "ado", ...)
end
addEvent("rp:sendAdo", true)
addEventHandler("rp:sendAdo", root, sendAdoEvent)

function setStatus(thePlayer, commandName, ...)
	local hasStatus = getElementData(thePlayer, "chat:status")
	if not (...) and not hasStatus then
		outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 75, 230, 10)
	else
		if not (...) then
			removeElementData(thePlayer, "chat:status")
		else
			local statusMessage = table.concat({...}, " ")
			setElementData(thePlayer, "chat:status", statusMessage)
			outputChatBox("[Status] " .. statusMessage, thePlayer)
			exports.logs:addLog(thePlayer, 42, {thePlayer}, statusMessage)
		end
	end
end
addCommandHandler("status", setStatus)
addEvent("rp:setStatus", true)
addEventHandler("rp:setStatus", root, setStatus)