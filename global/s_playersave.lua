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

local playersToSave = {}

function hourlyGlobalSave()
	for i, value in ipairs(getElementsByType("player")) do
		table.insert(playersToSave, value)
	end

	local saveDelay = 0 -- Delay so we don't save everyone at once and overload SQL.
	for i, thePlayer in ipairs(playersToSave) do
		if isElement(thePlayer) then
			local logged = getElementData(thePlayer, "loggedin")
			if (logged == 1) then
				saveDelay = saveDelay + 1000
				setTimer(savePlayerData, saveDelay, 1, thePlayer, 2)
			elseif (logged == 2) then
				saveDelay = saveDelay + 1000
				setTimer(savePlayerData, saveDelay, 1, thePlayer, 6)
			end
		else
			outputDebug("@hourlyGlobalSave: Attempted to save data on player who isn't an element. Element is " .. tostring(getElementType(thePlayer)))
		end
	end

	-- Save all vehicles.
	exports["vehicle-system"]:saveAllVehicles()
end

function updateTIS()
	for i, thePlayer in ipairs(getElementsByType("player")) do
		local timeInServer = getElementData(thePlayer, "account:timeinserver")
		if (timeInServer) and (getPlayerIdleTime(thePlayer) < 600000) then
			if (timeInServer >= 60) then
				local charHours = getElementData(thePlayer, "character:hours")
				local accHours = getElementData(thePlayer, "account:hours")

				blackhawk:changeElementData(thePlayer, "character:hours", charHours + 1)
				blackhawk:changeElementData(thePlayer, "account:hours", accHours + 1)
				blackhawk:changeElementData(thePlayer, "account:timeinserver", 0)
				return true
			end
			blackhawk:changeElementData(thePlayer, "account:timeinserver", tonumber(timeInServer) + 10)
		end
	end
end
setTimer(updateTIS, 600000, 0)

--[[ 							[Save Types]
	1 = General save, saving one player. (Saves character and account data.)
	2 = Global hourly save. (Saves character and account data.)
	3 = Account save.															
	4 = Character save.
	5 = Leaving server save. (Saves account and character data, and triggers onPlayerLogout events.)
	6 = Global hourly save for players on character selection. (Saves account data.)	]]
function savePlayerData(thePlayer, saveType)
	if source ~= nil then
		thePlayer = source
	end

	if not tonumber(saveType) then saveType = 5 end -- If no saveType is given, assume player leaving server save.

	-- Account save.
	if (saveType == 1) or (saveType == 2) or (saveType == 3) or (saveType == 5) or (saveType == 6) then
		local accountID = getElementData(thePlayer, "account:id")
		if not (accountID) or not (tonumber(accountID)) then
			return false
		end

		local lastLogin, muted, reports, warns, emeralds

		lastLogin = exports.global:getCurrentTime(); lastLogin = tostring(lastLogin[3])
		muted = getElementData(thePlayer, "account:muted") or 0
		reports = getElementData(thePlayer, "account:reports")
		warns = getElementData(thePlayer, "account:warns")
		emeralds = getElementData(thePlayer, "account:emeralds")

		local username = getElementData(thePlayer, "account:username")-- Debug
		exports.mysql:Execute("UPDATE `accounts` SET `lastlogin` = (?), `muted` = (?), `reports` = (?), `warns` = (?), `emeralds` = (?) WHERE `id` = (?);", lastLogin, muted, reports, warns, emeralds, accountID)
	end

	-- Character save.
	if (saveType == 1) or (saveType == 2) or (saveType == 4) or (saveType == 5) then
		local logged = getElementData(thePlayer, "loggedin") or 0
		if (logged == 1) or (saveType == 5) and not (logged == 2) then -- Either they are currently logged in or they have just left the server.
			local characterDBID = getElementData(thePlayer, "character:id")
			if tonumber(characterDBID) then
				local name, dob, sqlLocation, dimension, interior, height, weight, gender, language, language2, language3, ethnicity, skin, skills, charHours, last_used, location_area, walkstyle, health, armor, money, bankmoney, duty, cuffed, blindfolded, fightstyle, arrested, arrestedtime, description, mood, licenses, marriedto, job

				name = getElementData(thePlayer, "character:name") or getElementData(thePlayer, "account:username") or "Unknown"
				dob = getElementData(thePlayer, "character:dob")
				local x, y, z = getElementPosition(thePlayer)
				local rx, ry, rz = getElementRotation(thePlayer)
				sqlLocation = x .. "," .. y .. "," .. z .. "," .. rx .. "," .. ry .. "," .. rz
				dimension = getElementDimension(thePlayer) or 0
				interior = getElementInterior(thePlayer) or 0
				height = getElementData(thePlayer, "character:height")
				weight = getElementData(thePlayer, "character:weight")
				gender = getElementData(thePlayer, "character:gender")
				language = getElementData(thePlayer, "character:language")
				language2 = getElementData(thePlayer, "character:language2")
				language3 = getElementData(thePlayer, "character:language3")
				ethnicity = getElementData(thePlayer, "character:ethnicity")
				skin = getElementData(thePlayer, "character:skin")
				skills = getElementData(thePlayer, "character:skills")
				charHours = getElementData(thePlayer, "character:hours")
				local timeNow = exports.global:getCurrentTime()
				timeNow = tostring(timeNow[3])
				location_area = getElementZoneName(thePlayer) or "Unknown"
				walkstyle = getPedWalkingStyle(thePlayer) or 128
				health = getElementHealth(thePlayer) or 100
				armor = getPedArmor(thePlayer) or 0
				money = getElementData(thePlayer, "character:money")
				bankmoney = getElementData(thePlayer, "character:bankmoney")
				duty = getElementData(thePlayer, "character:duty") or 0
				cuffed = getElementData(thePlayer, "character:cuffed") or 0
				blindfolded = getElementData(thePlayer, "character:blindfolded") or 0
				fightstyle = getPedFightingStyle(thePlayer) or 4
				arrested = getElementData(thePlayer, "character:arrested") or 0
				arrestedtime = 0 -- Do something here.
				description = getElementData(thePlayer, "character:description"); description = toJSON(description)
				mood = getElementData(thePlayer, "character:mood") or 1
				licenses = getElementData(thePlayer, "character:licenses")
				marriedto = getElementData(thePlayer, "character:marriedto")
				job = getElementData(thePlayer, "character:job")

				-- Send everything off and save it in our massive query.
				exports.mysql:Execute(
					"UPDATE `characters` SET `name` = (?), `dob` = (?), `location` = (?), `dimension` = (?), `interior` = (?), `height` = (?), `weight` = (?), `gender` = (?), `language` = (?), `language2` = (?), `language3` = (?), `ethnicity` = (?), `skin` = (?),  `skills` = (?), `hours` = (?), `last_used` = (?), `location_area` = (?), `walkstyle` = (?), `health` = (?), `armor` = (?), `money` = (?), `bankmoney` = (?), `duty` = (?), `cuffed` = (?), `blindfolded` = (?), `fightstyle` = (?), `arrested` = (?), `arrestedtime` = (?), `description` = (?), `mood` = (?), `licenses` = (?), `marriedto` = (?), `job` = (?) WHERE `id` = (?);",
					name, dob, sqlLocation, dimension, interior, height, weight, gender, language, language2, language3, ethnicity, skin, skills, charHours, timeNow, location_area, walkstyle, health, armor, money, bankmoney, duty, cuffed, blindfolded, fightstyle, arrested, arrestedtime, description, mood, licenses, marriedto, job, characterDBID
				)
			end
		end
	end

	-- Global hourly saves.
	if (saveType == 2) or (saveType == 6) then
		for i, player in ipairs(playersToSave) do
			if (player == thePlayer) then
				table.remove(playersToSave, i)
			end
		end
	end

	-- Player leaving server save.
	if (saveType == 5) then
		-- Check to see if they are in a vehicle to trigger onVehicleExit content.
		local theVehicle = getPedOccupiedVehicle(thePlayer)
		if (theVehicle) then
			local seat = getPedOccupiedVehicleSeat(thePlayer)
			triggerEvent("onVehicleExit", theVehicle, thePlayer, seat)
		end
	end
end
addEvent("global:savePlayer", true)
addEventHandler("global:savePlayer", getRootElement(), savePlayerData)
addEventHandler("onPlayerQuit", getRootElement(), savePlayerData)
setTimer(hourlyGlobalSave, 3600000, 0)

addCommandHandler("saveall", function(p)
	if getElementType(p) == "console" or isPlayerLeadManager(p) or isPlayerLeadDeveloper(p) then
		local thePlayerName = "Unknown"
		if getElementType(p) == "console" then
			thePlayerName = "the console"
		else
			thePlayerName = getStaffTitle(p, 1)
		end

		sendMessageToManagers("[SAVE] A manual server save was initiated by " .. thePlayerName .. ".", true)
		hourlyGlobalSave()
	end
end)

addCommandHandler("stopserver", function(p, reason)
	if (getElementType(p) == "console") then
		print("[STOP SERVER] Server shutdown initiated, saving and stopping..")

		local timeNow = getCurrentTime()
		for i = 1, 20 do sendMessage(" ") end
		sendMessage("_______________________________________________________")
		sendMessage(" ")
		sendMessage("[" .. timeNow[2] .. " at " .. timeNow[1] .. "]")
		sendMessage("A SERVER SHUTDOWN HAS BEEN INITIATED, ALL DATA IS BEING SAVED.")
		sendMessage(" ")
		sendMessage("_______________________________________________________")

		hourlyGlobalSave()
		setTimer(function()
			shutdown(reason or "Server shutdown, check our Forums/Discord for updates.")
		end, 5000, 1)
	end
end)