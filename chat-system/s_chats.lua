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

-- /pm and /quickreply (Bind) -- by Skully (24/06/17) [Player]
function privateMessage(thePlayer, commandName, targetPlayer, ...)
	if (getElementData(thePlayer, "loggedin") == 1) then
		local message = nil
		if tostring(commandName):lower() == "quickreply" and targetPlayer then -- If the command used was quickreply.
			local target = getElementData(thePlayer, "var:lastpmtarget")

			-- If there is no target or their target is not an element.
			if (target) then
				target = target:gsub(" ", "_")
				local ourTarget = exports.global:getPlayerFromPartialNameOrID(target, thePlayer)
				if not ourTarget then
					outputChatBox("You don't have anyone to reply to.", thePlayer, 255, 0, 0)
					return false
				end
			end

			message = targetPlayer.." "..table.concat({...}, " ")
			targetPlayer = target
		else -- If they used /pm and not quickreply.
			if not (targetPlayer) or not (...) then
				outputChatBox("SYNTAX: /" .. commandName .. " [Player] [Message]", thePlayer, 75, 230, 10)
				outputChatBox("Press U to reply to the last person who PM'd you.", thePlayer, 75, 230, 10)
				return false
			end
			message = table.concat({...}, " ")
		end

		-- If we have our targetPlayer and we have the message they want to send.
		if (targetPlayer) and (message) then
			local targetPlayer = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)

			if (targetPlayer) then
				if getElementData(targetPlayer, "loggedin") ~= 1 then
					outputChatBox("ERROR: That player is not logged in!", thePlayer, 255, 0, 0)
					return false
				end

				if (targetPlayer == thePlayer) then
					outputChatBox("Why would you want to message yourself?", thePlayer, 255, 0, 0)
					return false
				end

				local thePlayerID = getElementData(thePlayer, "player:id")
				local thePlayerName = getPlayerName(thePlayer); thePlayerName = thePlayerName:gsub("_", " ")
				local thePlayerUsername = getElementData(thePlayer, "account:username")

				local targetPlayerName = getPlayerName(targetPlayer); targetPlayerName = targetPlayerName:gsub("_", " ")
				local targetPlayerUsername = getElementData(targetPlayer, "account:username")
				local targetPlayerID = getElementData(targetPlayer, "player:id")

				local affectedPlayers = {}
				local bigEarsAdmins = {}
				local logMessage = ""

				if (getElementData(targetPlayer, "var:toggledpms") ~= 1) or (exports.global:isPlayerHelper(thePlayer)) or (getElementData(targetPlayer, "pmblockignore") == thePlayerName) then -- Make sure that the target player doesn't have their PMs toggled off.
					exports.blackhawk:setElementDataEx(targetPlayer, "var:lastpmtarget", thePlayerName, true)
					table.insert(affectedPlayers, thePlayer)
					table.insert(affectedPlayers, targetPlayer)

					for _, aPlayer in ipairs(getElementsByType("player")) do -- Go through all the players and find an admin that has bigears for thePlayer or targetPlayer, add them to bigEarsAdmins table.
						if(exports.global:isPlayerTrialAdmin(aPlayer)) then
							local bigEarsTarget = getElementData(aPlayer, "bigears")
							if (bigEarsTarget == targetPlayerName) or (bigEarsTarget == thePlayerName) then -- If the player is listening to either of the PM recipients.
								if (targetPlayerName ~= getPlayerName(aPlayer)) and (thePlayerName ~= getPlayerName(aPlayer)) then -- Make sure that the PM recipient isn't the admin. 
									table.insert(bigEarsAdmins, aPlayer)
								end
							end
						end 
					end
			
					local thePlayerUsernameSetting = getElementData(thePlayer, "settings:account:setting1")
					local targetPlayerUsernameSetting = getElementData(targetPlayer, "setting:account:setting1")

					if (thePlayerUsernameSetting == 1) and (targetPlayerUsernameSetting == 1) or (exports.global:isPlayerOnStaffDuty(thePlayer)) then
						targetPlayerUsername = " (" .. targetPlayerUsername .. "): "
					else
						targetPlayerUsername = ": "
					end
					outputChatBox("[PM] You > (" .. targetPlayerID .. ") " .. targetPlayerName .. targetPlayerUsername .. message, thePlayer, 255, 255, 0) -- SENT PM BY thePlayer.

					if (targetPlayerUsernameSetting == 1) and (thePlayerUsernameSetting == 1) or (exports.global:isPlayerOnStaffDuty(thePlayer)) then
						thePlayerUsername = " (" .. thePlayerUsername .. "): "
					else
						thePlayerUsername = ": "
					end
					outputChatBox("[PM] (" .. thePlayerID .. ") " .. thePlayerName .. thePlayerUsername .. message, targetPlayer, 255, 255, 0) -- RECEIVED PM BY TARGET.
					-- Set back to default values.
					thePlayerUsername = getElementData(thePlayer, "account:username")
					targetPlayerUsername = getElementData(targetPlayer, "account:username")


					for i, admin in ipairs(bigEarsAdmins) do
						outputChatBox("[BIGEARS] (" .. thePlayerID .. ") " .. thePlayerName .. " (" .. thePlayerUsername .. ") > (" .. targetPlayerID .. ") " .. targetPlayerName .. " (" .. targetPlayerUsername .. "): " .. message, admin, 255, 255, 0)
						triggerClientEvent(admin, "pmSoundFX", admin)
					end
					
					-- Edit log message to include who bigear'ed the message.
					if (#bigEarsAdmins >= 1) then
						logMessage = "[BIGEARS: " 
						for i, admin in ipairs(bigEarsAdmins) do
							table.insert(affectedPlayers, admin)
							logMessage = logMessage .. getPlayerName(admin):gsub("_", " ")
							if (#bigEarsAdmins > i) then
								logMessage = logMessage .. ", "
							end
						end
						logMessage = logMessage .. "] "
					end
					logMessage = logMessage .. "[PM] " .. thePlayerName .. " > " .. targetPlayerName .. ": " .. message
					exports.logs:addLog(thePlayer, 28, affectedPlayers, logMessage)

					local containsAd = false
					if (string.find(message, "owl")) or (string.find(message, "server")) or (string.find(message, "roleplay")) then
						containsAd = true
					else
						local words = {}
						for word in message:gmatch("%w+") do
							table.insert(words, word)
							if (word == "server") or (word == "ip") or (word == "website") or (word == "http") or (word == "https") or (word == "www") or (word == "com") or (word == "net") or (word == "samp") or (word == "lsrp") or (word == "mta") then     
								containsAd = true
								break
							end
						end
					end

					if (containsAd) then
						exports.global:sendMessageToAdmins("[INFO] (" .. thePlayerID .. ") " .. thePlayerName .. " sent a possible advertisement to (" .. targetPlayerID .. ") " .. targetPlayerName .. "!") -- Notifies all online admins that a possible advertisement has been sent.
						exports.global:sendMessageToAdmins("[INFO] Message content: " .. message)
					end
					triggerClientEvent(targetPlayer, "pmSoundFX", targetPlayer)
				else
					outputChatBox(targetPlayerName .. " is currently blocking their private messages.", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("pm", privateMessage)
addCommandHandler("quickreply", privateMessage)

-- /snote [Message] - by Skully (20/06/17) [Player]
function chatNote(thePlayer, commandName, ...)
	if (getElementData(thePlayer, "loggedin") == 1) then
		local note = table.concat({...}, " ")
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Note]", thePlayer, 75, 230, 10)
		else
			outputChatBox("[SELF NOTE] " .. note .. "", thePlayer, 255, 255, 0)
		end
	end
end
addCommandHandler("snote", chatNote)

-- /a [Message] - by Zil (25/06/17) [Trial Admin]
function adminChat(thePlayer, commandName, ...)
	if (getElementData(thePlayer, "loggedin") == 1) then
		if exports.global:isPlayerTrialAdmin(thePlayer) then
			if not (...) then
				outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 75, 230, 10)
			else
				local message = table.concat({...}, " ")
				local players = getElementsByType("player") -- Get a table of all the players in the server.
				local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
				local thePlayerID = getElementData(thePlayer, "player:id")
				local affectedPlayers = {}

				for k, player in ipairs(players) do -- Use a for loop to step through each player.
					if (exports.global:isPlayerTrialAdmin(player)) then -- Checks if the player is a trial admin.
						outputChatBox("[ADMIN] ("..thePlayerID..") " .. thePlayerName .. ": " .. message, player, 255, 102, 0) -- Send the message to all currently online staff members.
						table.insert(affectedPlayers, player)

						if (player ~= thePlayer) and (getElementData(player, "settings:notification:setting5")) then
							local mentionedPlayerName = getElementData(player, "account:username")
							local lowerMessage = string.lower(message)
							local lowerMentionedPlayerName = string.lower(mentionedPlayerName)

							if (string.find(lowerMessage, lowerMentionedPlayerName)) then -- If the message contains the staff member's name, play a sound.
								triggerClientEvent(player, "pmSoundFX", player) --[[ Temporary sound.]]
							end
						end
					end
				end
				exports.logs:addLog(thePlayer, 29, affectedPlayers, message)
			end
		end
	end
end
addCommandHandler("a", adminChat)
addCommandHandler("achat", adminChat)
addCommandHandler("adminchat", adminChat)

-- /l [Message] - by Zil (25/06/17) [Manager]
function ManagerChat(thePlayer, commandName, ...)
	if (getElementData(thePlayer, "loggedin") == 1) then
		if exports.global:isPlayerManager(thePlayer) then
			if not (...) then
				outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 75, 230, 10)
			else
				local message = table.concat({...}, " ")
				local players = getElementsByType("player") -- Get a table of all the players in the server.
				local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
				local thePlayerID = getElementData(thePlayer, "player:id")
				local affectedPlayers = {}
				for k, player in ipairs(players) do -- Use a for loop to step through each player.
					if exports.global:isPlayerManager(player) then -- Checks if the player is an admin.
						outputChatBox("[MANAGMENT] ("..thePlayerID..") " .. thePlayerName .. ": " .. message, player, 255, 0, 102) -- Send the message to all currently online staff members.
						table.insert(affectedPlayers, player)

						if (player ~= thePlayer) and (getElementData(player, "settings:notification:setting5")) then
							local mentionedPlayerName = getElementData(player, "account:username")
							local lowerMessage = string.lower(message)
							local lowerMentionedPlayerName = string.lower(mentionedPlayerName)

							if (string.find(lowerMessage, lowerMentionedPlayerName)) then -- If the message contains the staff member's name, play a sound.
								triggerClientEvent(player, "pmSoundFX", player) --[[ Temporary sound.]]
							end
						end
					end
				end
				exports.logs:addLog(thePlayer, 37, affectedPlayers, message)
			end
		end
	end
end
addCommandHandler("l", ManagerChat)
addCommandHandler("lchat", ManagerChat)
addCommandHandler("leadchat", ManagerChat)

-- /d [Message] - by Zil (25/06/17) [Trial Developer / Manager]
function developerChat(thePlayer, commandName, ...)
	if (getElementData(thePlayer, "loggedin") == 1) then
		if (exports.global:isPlayerTrialDeveloper(thePlayer)) or (exports.global:isPlayerManager(thePlayer)) then
			if not (...) then
				outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 75, 230, 10)
			else
				local message = table.concat({...}, " ")
				local players = getElementsByType("player") -- Get a table of all the players in the server.
				local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
				local thePlayerID = getElementData(thePlayer, "player:id")
				local affectedPlayers = {}

				for k, player in ipairs(players) do -- Use a for loop to step through each player.
					if (exports.global:isPlayerTrialDeveloper(player)) or (exports.global:isPlayerManager(player)) then -- Checks if the player is a trial developer or manager.
						outputChatBox("[DEV] ("..thePlayerID..") " .. thePlayerName .. ": " .. message, player, 204, 102, 255) -- Send the message to all currently online developer team members.
						table.insert(affectedPlayers, player)

						if (player ~= thePlayer) and (getElementData(player, "settings:notification:setting5")) then
							local mentionedPlayerName = getElementData(player, "account:username")
							local lowerMessage = string.lower(message)
							local lowerMentionedPlayerName = string.lower(mentionedPlayerName)

							if (string.find(lowerMessage, lowerMentionedPlayerName)) then -- If the message contains the staff member's name, play a sound.
								triggerClientEvent(player, "pmSoundFX", player) --[[ Temporary sound.]]
							end
						end
					end
				end
				exports.logs:addLog(thePlayer, 35, affectedPlayers, message)
			end
		end
	end
end
addCommandHandler("d", developerChat)
addCommandHandler("devchat", developerChat)
addCommandHandler("developerchat", developerChat)

-- /st [Message] - by Zil (25/06/17) [Staff]
function staffChat(thePlayer, commandName, ...)
	if (getElementData(thePlayer, "loggedin") == 1) then
		if exports.global:isPlayerStaff(thePlayer) then
			if not (...) then
				outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 75, 230, 10)
			else
				local message = table.concat({...}, " ")
				local players = getElementsByType("player") -- Get a table of all the players in the server.
				local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
				local thePlayerID = getElementData(thePlayer, "player:id")
				local affectedPlayers = {}
				
				for k, player in ipairs(players) do -- Use a for loop to step through each player.
					if exports.global:isPlayerStaff(player) then -- Checks if the player is an admin.
						outputChatBox("[STAFF] ("..thePlayerID..") " .. thePlayerName .. ": " .. message, player, 204, 102, 255) -- Send the message to all currently online staff members.
						table.insert(affectedPlayers, player)

						if (player ~= thePlayer) and (getElementData(player, "settings:notification:setting5")) then
							local mentionedPlayerName = getElementData(player, "account:username")
							local lowerMessage = string.lower(message)
							local lowerMentionedPlayerName = string.lower(mentionedPlayerName)

							if (string.find(lowerMessage, lowerMentionedPlayerName)) then -- If the message contains the staff member's name, play a sound.
								triggerClientEvent(player, "pmSoundFX", player) --[[ Temporary sound.]]
							end
						end
					end
				end
				exports.logs:addLog(thePlayer, 31, affectedPlayers, message)
			end
		end
	end
end
addCommandHandler("sc", staffChat)
addCommandHandler("staffchat", staffChat)
addCommandHandler("st", staffChat)

-- /h [Message] - by Zil (25/06/17) [Helper]
function helperChat(thePlayer, commandName, ...)
	if (getElementData(thePlayer, "loggedin") == 1) then
		if (exports.global:isPlayerHelper(thePlayer)) then
			if not (...) then
				outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 75, 230, 10)
			else
				local message = table.concat({...}, " ")
				local players = getElementsByType("player") -- Get a table of all the players in the server.
				local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
				local thePlayerID = getElementData(thePlayer, "player:id")
				local affectedPlayers = {}

				for k, player in ipairs(players) do -- Use a for loop to step through each player.
					if exports.global:isPlayerHelper(player) then -- Checks if the player is a helper.
						outputChatBox("[HELPER] ("..thePlayerID..") " .. thePlayerName .. ": " .. message, player, 155, 255, 10) -- Send the message to all currently online staff members.
						table.insert(affectedPlayers, player)

						if (player ~= thePlayer) and (getElementData(player, "settings:notification:setting5")) then
							local mentionedPlayerName = getElementData(player, "account:username")
							local lowerMessage = string.lower(message)
							local lowerMentionedPlayerName = string.lower(mentionedPlayerName)

							if (string.find(lowerMessage, lowerMentionedPlayerName)) then -- If the message contains the staff member's name, play a sound.
								triggerClientEvent(player, "pmSoundFX", player) --[[ Temporary sound.]]
							end
						end
					end
				end
				exports.logs:addLog(thePlayer, 30, affectedPlayers, message)
			end
		end
	end
end
addCommandHandler("h", helperChat)
addCommandHandler("ht", helperChat)
addCommandHandler("helperchat", helperChat)

-- /vt [Message] - by Zil (25/06/17) [Vehicle Team Member]
function vehicleTeamChat(thePlayer, commandName, ...)
	if (getElementData(thePlayer, "loggedin") == 1) then
		if (exports.global:isPlayerVehicleTeam(thePlayer)) or (exports.global:isPlayerManager(thePlayer)) then
			if not (...) then
				outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 75, 230, 10)
			else
				local message = table.concat({...}, " ")
				local players = getElementsByType("player") -- Get a table of all the players in the server.
				local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
				local thePlayerID = getElementData(thePlayer, "player:id")
				local affectedPlayers = {}

				for k, player in ipairs(players) do -- Use a for loop to step through each player.
					if (exports.global:isPlayerVehicleTeam(player)) or (exports.global:isPlayerManager(player)) then -- Checks if the player is a vehicle team member or manager.
						outputChatBox("[VT] ("..thePlayerID..") " .. thePlayerName .. ": " .. message, player, 20, 190, 180) -- Send the message to all currently online vehicle team members.
						table.insert(affectedPlayers, player)

						if (player ~= thePlayer) and (getElementData(player, "settings:notification:setting5")) then
							local mentionedPlayerName = getElementData(player, "account:username")
							local lowerMessage = string.lower(message)
							local lowerMentionedPlayerName = string.lower(mentionedPlayerName)

							if (string.find(lowerMessage, lowerMentionedPlayerName)) then -- If the message contains the staff member's name, play a sound.
								triggerClientEvent(player, "pmSoundFX", player) --[[ Temporary sound.]]
							end
						end
					end
				end
				exports.logs:addLog(thePlayer, 33, affectedPlayers, message)
			end
		end
	end
end
addCommandHandler("vt", vehicleTeamChat)
addCommandHandler("vehicleteamchat", vehicleTeamChat)

-- /ft [Message] - by Zil (25/06/17) [Faction Team Member]
function factionTeamChat(thePlayer, commandName, ...)
	if (getElementData(thePlayer, "loggedin") == 1) then
		if (exports.global:isPlayerFactionTeam(thePlayer)) or (exports.global:isPlayerManager(thePlayer)) then
			if not (...) then
				outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 75, 230, 10)
			else
				local message = table.concat({...}, " ")
				local players = getElementsByType("player") -- Get a table of all the players in the server.
				local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
				local thePlayerID = getElementData(thePlayer, "player:id")
				local affectedPlayers = {}

				for k, player in ipairs(players) do -- Use a for loop to step through each player.
					if (exports.global:isPlayerFactionTeam(player)) or (exports.global:isPlayerManager(player)) then -- Checks if the player is a faction team member or manager.
						outputChatBox("[FT] ("..thePlayerID..") " .. thePlayerName .. ": " .. message, player, 200, 50, 50) -- Send the message to all currently online faction team members.
						table.insert(affectedPlayers, player)

						if (player ~= thePlayer) and (getElementData(player, "settings:notification:setting5")) then
							local mentionedPlayerName = getElementData(player, "account:username")
							local lowerMessage = string.lower(message)
							local lowerMentionedPlayerName = string.lower(mentionedPlayerName)

							if (string.find(lowerMessage, lowerMentionedPlayerName)) then -- If the message contains the staff member's name, play a sound.
								triggerClientEvent(player, "pmSoundFX", player) --[[ Temporary sound.]]
							end
						end
					end
				end
				exports.logs:addLog(thePlayer, 34, affectedPlayers, message)
			end
		end
	end
end
addCommandHandler("ft", factionTeamChat)
addCommandHandler("factionteamchat", factionTeamChat)

-- /mt [Message] - by Zil (25/06/17) [Mapping Team Member]
function mappingTeamChat(thePlayer, commandName, ...)
	if (getElementData(thePlayer, "loggedin") == 1) then
		if (exports.global:isPlayerMappingTeam(thePlayer)) or (exports.global:isPlayerManager(thePlayer)) then
			if not (...) then
				outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 75, 230, 10)
			else
				local message = table.concat({...}, " ")
				local players = getElementsByType("player") -- Get a table of all the players in the server.
				local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
				local thePlayerID = getElementData(thePlayer, "player:id")
				local affectedPlayers = {}

				for k, player in ipairs(players) do -- Use a for loop to step through each player.
					if (exports.global:isPlayerMappingTeam(player)) or (exports.global:isPlayerManager(player)) then -- Checks if the player is a mapping team member or manager.
						outputChatBox("[MT] ("..thePlayerID..") " .. thePlayerName .. ": " .. message, player, 200, 190, 10) -- Send the message to all currently online mapping team members.
						table.insert(affectedPlayers, player)

						if (player ~= thePlayer) and (getElementData(player, "settings:notification:setting5")) then
							local mentionedPlayerName = getElementData(player, "account:username")
							local lowerMessage = string.lower(message)
							local lowerMentionedPlayerName = string.lower(mentionedPlayerName)

							if (string.find(lowerMessage, lowerMentionedPlayerName)) then -- If the message contains the staff member's name, play a sound.
								triggerClientEvent(player, "pmSoundFX", player) --[[ Temporary sound.]]
							end
						end
					end
				end
				exports.logs:addLog(thePlayer, 32, affectedPlayers, message)
			end
		end
	end
end
addCommandHandler("mt", mappingTeamChat)
addCommandHandler("mappingteamchat", mappingTeamChat)

-- /gooc [Message] - by Skully (11/03/18) [Player]
function globalOOC(thePlayer, commandName, ...)
	if (getElementData(thePlayer, "loggedin") == 1) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 75, 230, 10)
		else
			-- Check to see if the player is muted.
			local muteStatus = getElementData(thePlayer, "account:muted")
			if (muteStatus == 1) then
				outputChatBox("You cannot speak in Global OOC while muted.", thePlayer, 255, 0, 0)
				return false
			end
			
			-- Check to see if GOOC is enabled.
			local goocStatus = exports.global:getDummyData("goocstate")
			if (tonumber(goocStatus) == 0) then
				outputChatBox("Global OOC is currently disabled.", thePlayer, 255, 0, 0)
				return false
			end

			local message = table.concat({...}, " ")
			local thePlayerName = getPlayerName(thePlayer); thePlayerName = thePlayerName:gsub("_", " ")
			local thePlayerID = getElementData(thePlayer, "player:id")
			exports.global:sendMessageToPlayers("(( [GLOBAL] (".. thePlayerID .. ") " .. thePlayerName .. ": " .. message .. " ))", 215, 215, 215)
		end
	end
end
addCommandHandler("gooc", globalOOC)

-- /district [Message] - by Zil (20/04/18) [Player]
function districtMessage(thePlayer, commandName, ...)
	if (getElementData(thePlayer, "loggedin") == 1) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 75, 230, 10)
		else
			local message = table.concat({...}, " ")
			if (#message <= 3) then 
				outputChatBox("District message must be longer than 3 characters!", thePlayer, 255, 0, 0)
				return false
			end
			
			local affectedPlayers = {}
			local thePlayerDistrict = getElementZoneName(thePlayer)
			local thePlayerInterior, thePlayerDimension = getElementInterior(thePlayer), getElementDimension(thePlayer)
			local thePlayerName = getPlayerName(thePlayer):gsub("_", " ")
			local x, y = getElementPosition(thePlayer)

			for i, player in ipairs(getElementsByType("player")) do
				if (getElementData(player, "loggedin") == 1) then
					local playerDistrict = getElementZoneName(player)
					local playerInterior, playerDimension = getElementInterior(player), getElementDimension(player)
					local playerX, playerY = getElementPosition(player)

					if (thePlayerDistrict == playerDistrict) and (thePlayerInterior == playerInterior) and (thePlayerDimension == playerDimension) and (getDistanceBetweenPoints2D(x, y, playerX, playerY) < 200) then
						if (exports.global:isPlayerTrialAdmin(player)) then
							outputChatBox("District IC: " .. message .. " ((" .. thePlayerName .. "))", player, 255, 255, 255)
						else
							outputChatBox("District IC: " .. message, player, 255, 255, 255)
						end
						table.insert(affectedPlayers, player)
					end
				end
			end 
			exports.logs:addLog(thePlayer, 41, affectedPlayers, message)
		end
	end
end
addCommandHandler("district", districtMessage)