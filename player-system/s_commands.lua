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

-- /limitfps [25-100] - by Skully (16/06/17)
function limitfps(thePlayer, commandName, fpslimit)
	if not (fpslimit) then
		outputChatBox("SYNTAX: /" .. commandName .. " [25-60]", thePlayer, 75, 230, 10)
	else
		local fpslimit = tonumber(fpslimit)
		if (fpslimit < 25) or (fpslimit > 60) then -- Checks to see if the input of FPS os between 25 and 60.
			outputChatBox("ERROR: FPS limit must be between 25 to 60.", thePlayer, 255, 0, 0)
		else
			triggerClientEvent(thePlayer, "player:setfpslimit", thePlayer, fpslimit)
			outputChatBox("You have set your FPS limit to " .. fpslimit .. ".", thePlayer, 0, 255, 0)
		end
	end
end
addCommandHandler("limitfps", limitfps)
addCommandHandler("fpslimit", limitfps)
addCommandHandler("setfps", limitfps)

-- /eject [Target] - by Zil (20/06/17) [Player]
function eject(thePlayer, commandName, targetPlayer)
	if (getElementData(thePlayer, "loggedin") == 1) then
		if not targetPlayer then
			outputChatBox("SYNTAX: /" .. commandName .. " [Target Player]", thePlayer, 75, 230, 10)
		else
			if getPedOccupiedVehicle(thePlayer) then -- Check if the player is in a vehicle.
				local targetPlayer = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)
				if (targetPlayer) then
					local thePlayerVehicle = getPedOccupiedVehicle(thePlayer)
					local targetPlayerVehicle = getPedOccupiedVehicle(targetPlayer)

					if not (targetPlayer == thePlayer) then
						if(targetPlayerVehicle == thePlayerVehicle) then -- If the target is in the same vehicle as the player.
							if getPedOccupiedVehicleSeat(thePlayer) == 0 then -- If the player is the driver of the vehicle.
								removePedFromVehicle(targetPlayer)
							else
								outputChatBox("ERROR: You need to be the driver to eject passengers!", thePlayer, 255, 0, 0)
							end
						else
							outputChatBox("ERROR: That player isn't in your vehicle!", thePlayer, 255, 0, 0)
						end
					else 
						outputChatBox("ERROR: You can't eject yourself!", thePlayer, 255, 0, 0)
					end
				end
			else
				outputChatBox("ERROR: You need to be in a vehicle to eject a passenger!", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("eject", eject)

-- /setwalkstyle [ID] - by Skully (17/07/17) [Player]
function setWalkStyle(thePlayer, commandName, walkid)
	if (getElementData(thePlayer, "loggedin") == 1) then
		if not tonumber(walkid) then
			outputChatBox("SYNTAX: /" .. commandName .. " [ID]", thePlayer, 75, 230, 10)
		else
			local validWalks = {57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 118, 119, 120, 121, 122, 123, 124, 125, 126, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138}
			local walkid = tonumber(walkid)

			if exports.global:table_find(walkid, validWalks) then -- If the walkstyle ID the player inputs is a valid walkstyle ID.
				setPedWalkingStyle(thePlayer, walkid)
				exports.blackhawk:setElementDataEx(thePlayer, "character:walkstyle", walkid, true)
				outputChatBox("You have set your walk style to " .. walkid.. ".", thePlayer, 0, 255, 0)
			else
				outputChatBox("ERROR: That is not a valid walk style!", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("sws", setWalkStyle)
addCommandHandler("setwalkstyle", setWalkStyle)

-- /luck [To] - by Zil (01/04/18) [Player]
function luck(thePlayer, commandName, to)
	if (getElementData(thePlayer, "loggedin") == 1) then
		if (to) then
			if not tonumber(to) or (tonumber(to) <= 0) then
				outputChatBox("SYNTAX: /" .. commandName .. " (Number To [0-100])", thePlayer, 75, 230, 10)
			else
				local to = tonumber(to)
				local randomNumber = math.random(0, to)
				triggerEvent("rp:sendLocalMe", thePlayer, thePlayer, "tries their luck from 0 to " .. to .. " and gets a " .. randomNumber .. ".")
			end
		else
			local randomNumber = math.random(0, 100)
			triggerEvent("rp:sendLocalMe", thePlayer, thePlayer, "tries their luck from 0 to 100 and gets a " .. randomNumber .. ".")
		end
	end
end
addCommandHandler("luck", luck)

-- /chance - by Zil (01/04/18) [Player]
function chance(thePlayer, commandName, percentage)
	if (getElementData(thePlayer, "loggedin") == 1) then
		if not (percentage) or not tonumber(percentage) or (tonumber(percentage) > 100) or (tonumber(percentage) < 0) then
			outputChatBox("SYNTAX: /" .. commandName .. " [0-100%]", thePlayer, 75, 230, 10)
		else
			local percentage = tonumber(percentage)
			local chance = math.random(100)
			local result

			if (chance <= percentage) then
				result = "succeeds"
			else
				result = "fails"
			end
			triggerEvent("rp:sendLocalMe", thePlayer, thePlayer, "attempts with a " .. percentage .. "% chance and " .. result .. ".")
		end
	end
end
addCommandHandler("chance", chance)

function coinFlip(thePlayer)
    local chance = math.random(1, 2)

    local side = "tails"
	if (math.random(1, 2) == 1) then side = "heads" end

    triggerEvent("rp:sendLocalDo", thePlayer, thePlayer, "Flipped a coin and got " .. side .. ".")
end
addCommandHandler("coinflip", coinFlip)