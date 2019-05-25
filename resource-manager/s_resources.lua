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

--[[

NOTE FOR DEVELOPERS:
	For optimization and error prevention, do not adjust the order of resources in the tables below.
	If you want to add more resources, add them at the bottom of the list unless you know what
	you're doing. - Skully

]]

local dependences = {
	"mysql",
	"data",
	"global",
	"emGUI",
	"vehicle-system",
	"hud-system",
	"login-system",
}

resources = {
	"mysql", 
	"emGUI", 
	"admin-system", 
	"character-system", 
	"chat-system", 
	"dev", 
	"EmeraldGamingLogs", 
	"hud-system",
	"item-system",
	"player-system",
	"interior-system",
	"rp-system", 
	"vehicle-system",
	"npc-system",
	"superman-system", 
	"report-system", 
	"logs",
	"login-system",
	"sound-manager",
	"teleport-manager",
	"radio-system",
	"character-system", 
	"account-system",
}

-- /rss [Resource] - by Skully (21/06/17) [Lead Developer]
function restartRes(thePlayer, commandName, resource, skipTimers)
	if exports.global:isPlayerLeadDeveloper(thePlayer, true) then
		if not (resource) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Resource Name] (Skip Timers)", thePlayer, 75, 230, 10)
		else
			local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
			local theResource = getResourceFromName(resource)
			local skipTimer = false
			if (tonumber(skipTimers) == 1) then skipTimer = true end

			if (theResource) then -- If the resource exists
				if getResourceState(theResource) == "running" then -- If the resource is running
					local theResourceName = getResourceName(theResource)
					if (theResourceName == "data") then
						outputChatBox("ERROR: 'data' cannot be restarted as it is a high server-sided dependency, please restart the server instead.", thePlayer, 255, 0, 0)
						return false
					elseif (theResourceName == "emGUI") then
						outputChatBox("[WARNING] You have restarted the emGUI Framework, any resources that use GUIs must also be manually restarted.", thePlayer, 255, 0, 0)
					elseif (theResourceName == "assets") then
						outputChatBox("[WARNING] You have restarted all assets, any resources that use assets may require a restart.", thePlayer, 255, 0, 0)
					elseif (theResourceName == "blackhawk") then
						outputChatBox("[WARNING] You have restarted blackhawk, previously set protected element data may no longer be accessible.", thePlayer, 255, 0, 0)
					end

					restartResource(theResource)
					exports.global:sendMessageToAdmins("[SERVER] " .. thePlayerName .. " has restarted the resource '" .. theResourceName .. "'.")
					outputChatBox("[SERVER] You have restarted the resource " .. theResourceName .. ".", thePlayer, 75, 230, 10)
				else -- if the resource isn't running.
					outputChatBox("ERROR: That resource is not currently running!", thePlayer, 255, 0, 0)
				end
			else -- if the resource wasn't found.
				outputChatBox("ERROR: That resource does not exist!", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("rss", restartRes)
addCommandHandler("restartres", restartRes)

-- /stopres [Resource] - by Skully (21/06/17) [Lead Developer]
function stopRes(thePlayer, commandName, resource)
	if exports.global:isPlayerLeadDeveloper(thePlayer, true) then
		if not (resource) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Resource Name]", thePlayer, 75, 230, 10)
		else
			local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
			local theResource = getResourceFromName(resource)

			if (theResource) then -- If the resource exists
				if getResourceState(theResource) == "running" then -- If the resource is running
					local theResourceName = getResourceName(theResource)

					stopResource(theResource)
					exports.global:sendMessageToAdmins("[SERVER] " .. thePlayerName .. " has stopped resource '" .. theResourceName .. "'.")
					outputChatBox("[SERVER] You have stopped resource " .. theResourceName .. ".", thePlayer, 75, 230, 10)
				else -- if the resource isn't running
					outputChatBox("ERROR: That resource is not currently running!", thePlayer, 255, 0, 0)
				end
			else -- if the resource wasn't found
				outputChatBox("ERROR: That resource does not exist!", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("stopres", stopRes)

-- /startres [Resource] - by Skully (21/06/17) [Lead Developer]
function startRes(thePlayer, commandName, resource)
	if exports.global:isPlayerLeadDeveloper(thePlayer, true) then
		if not (resource) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Resource Name]", thePlayer, 75, 230, 10)
		else
			local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)
			local theResource = getResourceFromName(resource)

			if (theResource) then -- If the resource exists
				if (getResourceState(theResource) == "stopped") or (getResourceState(theResource) == "loaded") then -- If the resource is stopped/loaded
					local theResourceName = getResourceName(theResource)

					startResource(theResource)
					exports.global:sendMessageToAdmins("[SERVER] " .. thePlayerName .. " has started resource '" .. theResourceName .. "'.")
					outputChatBox("[SERVER] You have started resource " .. theResourceName .. ".", thePlayer, 75, 230, 10)
				else -- if the resource is already running
					outputChatBox("ERROR: That resource is already running!", thePlayer, 255, 0, 0)
				end
			else -- if the resource wasn't found
				outputChatBox("ERROR: That resource does not exist!", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("startres", startRes)

-- /resinfo [Resource] - by Skully (21/06/17) [Lead Developer / Manager]
function resInfo(thePlayer, commandName, resource)
	if exports.global:isPlayerDeveloper(thePlayer, true) or exports.global:isPlayerManager(thePlayer) then
		if not (resource) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Resource Name]", thePlayer, 75, 230, 10)
		else
			local theResource = getResourceFromName(resource)

			if (theResource) then -- If the resource exists
				local theResourceName = getResourceName(theResource)
				local resState = getResourceState(theResource)

				if (getResourceState(theResource) == "stopped") then
					outputChatBox("The resource '" .. theResourceName .. "'' is currently " .. resState .. ".", thePlayer, 255, 0, 0)
				elseif (getResourceState(theResource) == "running") then
					outputChatBox("The resource '" .. theResourceName .. "'' is currently " .. resState .. ".", thePlayer, 0, 255, 0)
				else
					outputChatBox("The resource '" .. theResourceName .. "'' is currently " .. resState .. ".", thePlayer, 0, 255, 0)
				end
			else -- if the resource wasn't found
				outputChatBox("ERROR: That resource does not exist!", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("resinfo", resInfo)
addCommandHandler("getresstate", resInfo)
addCommandHandler("resstatus", resInfo)

-- /rssall - by Zil (21/03/18) [Lead Developer]
function restartAllRes(thePlayer)
	if exports.global:isPlayerLeadDeveloper(thePlayer, true) then
		local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)

		exports.global:sendMessageToPlayers("[SERVER] " .. thePlayerName .. " is restarting ALL resources.")
		exports.global:sendMessageToPlayers("[SERVER] You may experience a period of lag, apologies for the inconvenience!")

		outputDebugString("[RESOURCES] " .. thePlayerName .. " initiated a restart of all resources.")

		local timerLength = 3000
		for i, resName in ipairs(resources) do
			local res = getResourceFromName(resName)

			setTimer(function()
				restartResource(res)
				exports.global:sendMessageToAdmins("[SERVER] Resource '" .. resName .. "' was restarted.")
			end, timerLength, 1)
			timerLength = timerLength + 2000
		end

		setTimer(function()
			exports.global:sendMessageToAdmins("[SERVER] All resources have been successfully restarted.")
			outputDebugString("[RESOURCES] Finished restart of all resources.")
		end, 3000 + (2000 * #resources), 1)
	end
end
addCommandHandler ("rssall", restartAllRes)

function startDependancies()
	for i, res in ipairs(dependences) do
		local theResource = getResourceFromName(res)
		if getResourceState(theResource) ~= "running" then
			exports.global:outputDebug("[SERVER] '" .. res .. "' is not running though is a dependency, starting it now.", 2)
			local started = startResource(theResource)
			if (started) then
				exports.global:sendMessageToDevelopers("[SERVER] '" .. res .. "' was automatically started.")
			else
				exports.global:outputDebug("[SERVER] Failed to start dependency resource '" .. res .."'.", 2)
			end
		end
	end
end
addEventHandler("onResourceStart", resourceRoot, startDependancies)

--------------------------------------------- Individual resource restart functions ---------------------------------------------

function restartVehicleSystem(thePlayer, skipTimer)
	local thePlayerName = exports.global:getStaffTitle(thePlayer, 1)

	if not (skipTimer) then
		exports.global:sendMessage("[SERVER] " .. thePlayerName .. " is restarting the vehicle system in 15 seconds.")
		exports.global:sendMessage("[SERVER] Please exit your vehicle and /park it at your current position!")
		exports["vehicle-system"]:saveAllVehicles()
	else
		exports.global:sendMessage("[SERVER] " .. thePlayerName .. " has restarted the resource 'vehicle-system'.", 2, true)
	end

	-- Timers.
	--[[ @Skully These timers are only temporary, before launch, create a check to get the total amount of vehicles to save, and depending on how many vehicles there are,
	increase the timer to enough time for them all to be saved before the resource restarts. ]]
	local restartTime1 = 15000 -- 15 seconds.
	local restartTime2 = 5000 -- 5 second.
	if (skipTimer) then
		restartTime1 = 50
		restartTime2 = 50
	end

	setTimer(function()
		-- Stop vehicle-system.
		local vehicleSysResource = getResourceFromName("vehicle-system")
		local radioSys = getResourceFromName("radio-system")
		stopResource(vehicleSysResource)
		stopResource(radioSys)
		
		-- Start it again after 5 seconds.
		setTimer(function()
			startResource(vehicleSysResource)
			exports.global:sendMessage("[SERVER] The vehicle system has been restarted, please allow some time for all vehicles to load in.")
			setTimer(function()
				outputChatBox("[WARNING] The radio-system has also been restarted due to high dependences.", thePlayer, 255, 0, 0)
				startResource(radioSys)
			end, 3000, 1)
		end, restartTime2, 1)
	end, restartTime1, 1)
end