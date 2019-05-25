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

-- /oldcar - By Skully (08/04/18) [Player]
function getOldcarID(thePlayer)
	local loggedin = getElementData(thePlayer, "loggedin")
	if (loggedin == 1) then
		local oldcarID = getElementData(thePlayer, "character:oldcar")
		if (oldcarID) then
			outputChatBox("The ID of the last vehicle you entered is: #" .. oldcarID .. ".", thePlayer, 75, 230, 10)
		else
			outputChatBox("You haven't entered a vehicle yet!", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("oldcar", getOldcarID)
addCommandHandler("oldveh", getOldcarID)

-- /park - By Skully (09/04/18) [Player]
function parkVehicle(thePlayer)
	local loggedin = getElementData(thePlayer, "loggedin")
	if (loggedin == 1) then
		local theVehicle = getPedOccupiedVehicle(thePlayer)
		if not (theVehicle) then
			outputChatBox("ERROR: You must be in the driver seat of the vehicle you want to park!", thePlayer, 255, 0, 0)
			return false
		end

		local vehicleDriver = getVehicleOccupant(theVehicle, 0)

		if vehicleDriver ~= thePlayer then
			outputChatBox("ERROR: You must be in the driver seat to park this vehicle!", thePlayer, 255, 0, 0)
			return false
		end

		if not isVehicleOnGround(theVehicle) then
			outputChatBox("ERROR: The vehicle must be on the ground before you can park it.", thePlayer, 255, 0, 0)
			return false
		end

		local hasVehicleKey = true -- Check to see if player has the vehicle's key. @requires item-system
		
		if (hasVehicleKey) then
			local x, y, z = getElementPosition(theVehicle)
			local rx, ry, rz = getElementRotation(theVehicle)
			local vehicleDimension = getElementDimension(theVehicle)
			local vehicleInterior = getElementInterior(theVehicle)
			local vehicleID = getElementData(theVehicle, "vehicle:id")
			setElementData(theVehicle, "vehicle:respawnpos", {x, y, z, rx, ry, rz})
			setElementData(theVehicle, "vehicle:dimension", vehicleDimension)
			setElementData(theVehicle, "vehicle:interior", vehicleInterior)
			saveVehicle(vehicleID)
			exports.logs:addVehicleLog(vehicleID, "[PARK] Vehicle parked by " .. getPlayerName(thePlayer):gsub("_", " ") .. ".", thePlayer)

			outputChatBox("You have parked the vehicle at your current location.", thePlayer, 0, 255, 0)
		end
	end
end
addCommandHandler("park", parkVehicle)

-- /sellveh [Vehicle ID] [Player/ID] [Price] - By Skully (31/05/18) [Player]
function sellVehicle(thePlayer, commandName, vehicleID, targetPlayer, price)
	local loggedin = getElementData(thePlayer, "loggedin") == 1
	if not loggedin then return end

	if not tonumber(vehicleID) or not (targetPlayer) then
		outputChatBox("SYNTAX: /" .. commandName .. " [Vehicle ID] [Player/ID] [Price]", thePlayer, 75, 230, 10)
		return false
	end

	local sellOverride = exports.global:isPlayerTrialAdmin(thePlayer) or getElementData(thePlayer, "var:tempsell")
	if not (sellOverride) and not tonumber(price) then
		outputChatBox("SYNTAX: /" .. commandName .. " [Vehicle ID] [Player/ID] [Price]", thePlayer, 75, 230, 10)
		return false
	elseif (sellOverride) then
		price = 0
	end

	if not tonumber(price) or (tonumber(price) < 0) then
		outputChatBox("ERROR: Price must be greater than zero!", thePlayer, 255, 0, 0)
		return false
	end

	local targetPlayer, targetPlayerName = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)
	if (targetPlayer) then
		if (targetPlayer == thePlayer) and not sellOverride then -- If target is the player.
			outputChatBox("Why are you trying to sell a car to yourself?", thePlayer, 255, 0, 0)
			return false
		end

		-- Ensure the player doesn't already have a request sent.
		local pHasOpenReq = getElementData(thePlayer, "temp:sellveh")
		if (pHasOpenReq) and not (sellOverride) then
			outputChatBox("ERROR: You can't send a sale request with another one pending!", thePlayer, 255, 0, 0)
			return
		end

		-- Ensure the target doesn't already have a pending request.
		local tHasOpenReq = getElementData(targetPlayer, "temp:sellveh")
		if (tHasOpenReq) and not (sellOverride) then
			outputChatBox("ERROR: That player already has a sale request pending.", thePlayer, 255, 0, 0)
			return
		end

		local theVehicle = exports.data:getElement("vehicle", vehicleID) -- We don't use getVehicleFromID here because we want a custom message if no vehicle.
		if (theVehicle) then
			local canPlayerSell = false
			local vehOwner = getElementData(theVehicle, "vehicle:owner")
			local jobVeh = getElementData(theVehicle, "vehicle:job")

			-- If the vehicle is a job vehicle.
			if (jobVeh) and (jobVeh ~= 0) and (sellOverride) then
				outputChatBox("ERROR: You cannot sell job vehicles.", thePlayer, 255, 0, 0)
				return false
			end

			if (vehOwner) then
				if sellOverride then
					canPlayerSell = true
				elseif (vehOwner > 0) then -- If vehicle is player owned.
					if getElementData(thePlayer, "account:id") == vehOwner then
						if true then -- Check to see if player has vehicle keys. @requires item-system
							canPlayerSell = true
						else
							outputChatBox("You need to have a pair of keys for the vehicle in order to sell it!", thePlayer, 255, 0, 0)
							return false
						end
					end
				elseif (vehOwner < 0) then -- If vehicle is faction owned.
					if exports.global:isPlayerFactionLeader(thePlayer, -vehOwner) then
						canPlayerSell = true
					end
				end
			end

			-- Check to see if the player can sell it.
			if not (canPlayerSell) then
				outputChatBox("You don't own a vehicle with that ID!", thePlayer, 255, 0, 0)
				return false
			end

			if sellOverride or exports.global:areElementsWithinDistance(thePlayer, targetPlayer, 6) then
				if sellOverride or exports.global:areElementsWithinDistance(thePlayer, theVehicle, 6) then
					local thePlayerName = getPlayerName(thePlayer):gsub("_", " ")
					local targetPlayerName = getPlayerName(targetPlayer):gsub("_", " ")
					local theVehicleName = getElementData(theVehicle, "vehicle:name")
					local targetCharacterID = getElementData(targetPlayer, "character:id")

					if sellOverride then -- If this is being sold with temporary sell access or by an admin.
						local hasSold = exports.mysql:Execute("UPDATE `vehicles` SET `owner` = (?) WHERE `id` = (?);", targetCharacterID, tonumber(vehicleID))
						if (hasSold) then
							local oldOwner = getElementData(theVehicle, "vehicle:owner")
							local ownerName = "Unknown"
							if (oldOwner < 0) then
								local theFaction = exports.data:getElement("team", -oldOwner)
								if theFaction then
									ownerName = getElementData(theFaction, "faction:name") or "Unknown"
								end
							else
								ownerName = exports.global:getCharacterNameFromID(oldOwner)
							end
							exports.blackhawk:changeElementDataEx(theVehicle, "vehicle:owner", targetCharacterID, true)
							exports.blackhawk:changeElementDataEx(theVehicle, "vehicle:ownername", targetPlayerName, true)
							local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
							outputChatBox("You have successfully sold the " .. theVehicleName .. " to " .. targetPlayerName .. ".", thePlayer, 0, 255, 0)
							outputChatBox(thePlayerName .. " has transferred a '" .. theVehicleName .. "' to your ownership.", targetPlayer, 75, 230, 10)
							exports.logs:addLog(thePlayer, 44, {thePlayer, targetPlayer, theVehicle}, "(/sellveh) " .. thePlayerName .. " transfered the vehicle's ownership from " .. oldOwner .. " to " .. targetPlayerName .. ".")
							exports.logs:addVehicleLog(theVehicle, "[SELLVEH] " .. thePlayerName .. " transferred the vehicle's ownership.\nPrevious owner: " .. ownerName .. "\nNew owner: " .. targetPlayerName, thePlayer)
							exports.global:sendMessage("[INFO] " .. thePlayerName .. " transferred ownership of vehicle #" .. vehicleID .. " to " .. targetPlayerName .. ".", 1, true)
							return true
						else
							outputChatBox("ERROR: Something went wrong whilst updating the vehicle owner.", thePlayer, 255, 0, 0)
							return false
						end
					else
						local thePlayerName = getPlayerName(thePlayer):gsub("_", " ")
						exports.blackhawk:setElementDataEx(thePlayer, "temp:sellveh", true, false)
						exports.blackhawk:setElementDataEx(targetPlayer, "temp:sellveh", thePlayerName:gsub(" ", "_") .. "," .. theVehicleName .. "," .. price .. "," .. vehicleID, false)
						outputChatBox("You have offered to sell your " .. theVehicleName .. " to " .. targetPlayerName .. ", waiting for them to accept..", thePlayer, 75, 230, 10)
						outputChatBox(thePlayerName .. " has offered to sell you their " .. theVehicleName .. ", type /reviewsell to review the sale.", targetPlayer, 255, 255, 0)
						setTimer(function()
							local haveTraded = getElementData(thePlayer, "temp:sellveh")
							if (haveTraded) then
								removeElementData(thePlayer, "temp:sellveh")
								removeElementData(targetPlayer, "temp:sellveh")
								outputChatBox("Your vehicle sale request to " .. targetPlayerName .. " has expired.", thePlayer, 255, 0, 0)
								outputChatBox("The sale request from " .. thePlayerName .. " has expired as you didn't respond to it.", targetPlayer, 255, 0, 0)
							end
						end, 15000, 1)
					end
				else
					outputChatBox("ERROR: You are not close enough to your vehicle!", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("ERROR: You are not close enough to that player!", thePlayer, 255, 0, 0)
			end

		else -- If vehicle doesn't exist, output this stock message to prevent player from using on random vehicle IDs to check if they exist.
			if sellOverride then
				outputChatBox("ERROR: A vehicle with the ID #" .. vehicleID .. " does not exist!", thePlayer, 255, 0, 0)
			else
				outputChatBox("You don't own a vehicle that ID!", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("sellveh", sellVehicle)

--/reviewsell - By Skully (30/05/18) [Player]
function reviewSell(thePlayer)
	local loggedin = getElementData(thePlayer, "loggedin") == 1
	if not loggedin then return end

	local hasOffer = getElementData(thePlayer, "temp:sellveh")
	if (hasOffer) then
		local tradeData = split(hasOffer, ",")
		local sellingPlayer = getPlayerFromName(tradeData[1])

		if (sellingPlayer) then
			-- Remove element data off both players.
			removeElementData(sellingPlayer, "temp:sellveh")
			removeElementData(thePlayer, "temp:sellveh")

			-- Open the GUI for the player who received the offer.
			triggerClientEvent(thePlayer, "vehicle:sale:reviewsaleGUI", thePlayer, sellingPlayer, tradeData)
		else
			outputChatBox("ERROR: The player who sent the trade request has logged out.", thePlayer, 255, 0, 0)
		end
	else
		outputChatBox("ERROR: You don't have any pending sale requests!", thePlayer, 255, 0, 0)
	end
end
addCommandHandler("reviewsell", reviewSell)

function handleSaleCancel(sellingPlayer, sellerName)
	if isElement(sellingPlayer) then -- If selling player is still online.
		local thePlayerName = getPlayerName(source):gsub("_", " ")
		outputChatBox(thePlayerName .. " has declined your sale offer.", sellingPlayer, 255, 0, 0)
	end

	outputChatBox("You have declined the sale offer from " .. sellerName[1]:gsub("_", " ") .. ".", source, 75, 230, 10)
end
addEvent("vehicle:sale:handleSaleCancel", true) -- Used by /sellveh GUI.
addEventHandler("vehicle:sale:handleSaleCancel", root, handleSaleCancel)

function handleSaleConfirmed(sellingPlayer, sellingData)
	if isElement(sellingPlayer) then
		local vehicleID = tonumber(sellingData[4])
		local theVehicle = exports.data:getElement("vehicle", vehicleID) -- Get the vehicle element.
		if not (theVehicle) then -- If the vehicle no longer exists.
			outputChatBox("ERROR: The vehicle no longer appears to exist, sale cancelled.", source, 255, 0, 0)
			return false
		end

		local accountID = getElementData(source, "account:id")
		local hasSold = exports.mysql:Execute("UPDATE `vehicles` SET `owner` = (?) WHERE `id` = (?);", accountID, vehicleID)
		if (hasSold) then
			local oldOwner = getElementData(theVehicle, "vehicle:owner")
			local ownerName = "Unknown"
			if (oldOwner < 0) then
				local theFaction = exports.data:getElement("team", -oldOwner)
				if theFaction then
					ownerName = getElementData(theFaction, "faction:name") or "Unknown"
				end
			else
				ownerName = exports.global:getCharacterNameFromID(oldOwner)
			end
			exports.blackhawk:changeElementDataEx(theVehicle, "vehicle:owner", accountID, true)

			-- Outputs and logs.
			local thePlayerName = getPlayerName(source):gsub("_", " ")
			local targetPlayerName = getPlayerName(sellingPlayer):gsub("_", " ")
			outputChatBox("You have purchased a " .. sellingData[2] .. " from " .. targetPlayerName .. " for $" .. sellingData[3] ..".", source, 0, 255, 0)
			outputChatBox("You have successfully sold the " .. sellingData[2] .. " to " .. thePlayerName .. " for $" .. sellingData[3] .. ".", sellingPlayer, 0, 255, 0)
			exports.logs:addLog(source, 44, {source, sellingPlayer, theVehicle}, "(/sellveh) " .. thePlayerName .. " sold the vehicle to " .. targetPlayerName .. " for $" .. sellingData[3] .. ".")
			exports.logs:addVehicleLog(theVehicle, "[SELLVEH] " .. thePlayerName .. " has sold the vehicle to " .. targetPlayerName .. " for $" .. sellingData[3] .. ".", source)
			return true
		else
			outputChatBox("ERROR: Something went wrong whilst updating the vehicle owner.", source, 255, 0, 0)
			return false
		end
	else
		outputChatBox("ERROR: " .. sellingData[1] .. " is no longer online, the sale has been cancelled.", source, 255, 0, 0)
	end
end
addEvent("vehicle:sale:handleSaleConfirmed", true) -- Used by /sellveh GUI.
addEventHandler("vehicle:sale:handleSaleConfirmed", root, handleSaleConfirmed)