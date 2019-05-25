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

function resourceStart(resource)
	setGameType("Roleplay")
	setMapName("San Andreas")
	setRuleValue("Script Version", "0.5.0")
	setRuleValue("Author", "Emerald Gaming Development Team")
	setRuleValue("Website", "https://emeraldgaming.net")
end
addEventHandler("onResourceStart", resourceRoot, resourceStart)

-- Things that should happen when a player quits/times out/leaves from the server - this function should only be used to remove data or update other functions, NOT save content.
function onLeave()
	setElementData(source, "loggedin", 0, true)

	local lastPmPlayerName = getElementData(source, "var:lastpmtarget")

	if (lastPmPlayerName) then
		local lastPmPlayer = getPlayerFromName(lastPmPlayerName)
		removeElementData(lastPmPlayer, "var:lastpmtarget")
	end

	triggerEvent("report:removeReportQuit", root, source) -- Triggers an event in g_reports.lua that removes the player's report if they quit or unassigns the handler.

	local beingReconned = getElementData(source, "var:beingreconned") -- Returns the admin who is reconning them.
	if (beingReconned) then triggerEvent("admin:stopReconning", root, beingReconned, true) end -- s_commands stopReconning function
end
addEventHandler("onPlayerQuit", root, onLeave)

-- Disables traffic lights.
addEventHandler("onClientPreRender", root,
function()
	setTrafficLightState(9)
	setTrafficLightsLocked(true)
end)

-- Cancels specified default MTA commands.
function disableDefaultCommands(commandName)
	if (commandName == "nick") then
		cancelEvent()
	end
end
addEventHandler("onPlayerCommand", root, disableDefaultCommands)

-- Respawn player after they die.
addEventHandler("onPlayerWasted", root,
function(ammo, killer, weapon, bodypart, stealth)
	local oldSkin = getElementModel(source)
	setTimer(spawnPlayer, 4000, 1, source, 1607.35059, 1820.37500, 10.82800, 0, oldSkin, 0, 0)
end)

-- Encrypts the string given and returns the hash and salt.
function encryptString(...)
	if not (string) then
		outputDebugString("[GLOBAL] Incorrect parameter provided for function encryptString, string to encrypt not given.")
		return false
	end

	local text = table.concat({...}, " ")																																											local key = "omlettebastard"
	local encrypted = hash("sha256", text)
	local algorithmTwo = hash("sha256", hash("sha256", key .. text .. encrypted))
	local salt = hash("sha256", algorithmTwo)
	local finalResult = hash("sha256", algorithmTwo .. salt)

	if (finalResult) then
		return finalResult, salt
	end
end