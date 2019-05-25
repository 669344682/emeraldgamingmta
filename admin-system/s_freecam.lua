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

function setPlayerFreecamEnabled(player, x, y, z, dontChangeFixedMode)
	return triggerClientEvent(player,"doSetFreecamEnabled", getRootElement(), x, y, z, dontChangeFixedMode)
end

function setPlayerFreecamDisabled(player, dontChangeFixedMode)
	return triggerClientEvent(player,"doSetFreecamDisabled", getRootElement(), dontChangeFixedMode)
end

function setPlayerFreecamOption(player, theOption, value)
	return triggerClientEvent(player,"doSetFreecamOption", getRootElement(), theOption, value)
end

function isPlayerFreecamEnabled(player)
	return getElementData(player,"freecam:state")
end

-- Skully, 05/09/17
function enableFreecam(player)
	if exports.global:isPlayerTrialAdmin(player) or exports.global:isPlayerDeveloper(player) then
		local logMessage
		if not isPlayerFreecamEnabled(player) then
			local x, y, z = getElementPosition(player)
			setPlayerFreecamEnabled(player, x, y, z)
			setElementAlpha(player, 0)
			setElementFrozen(player, true)
			logMessage = "Enabled freecam."
		else 
			local newx, newy, newz = getCameraMatrix(player)
			setPlayerFreecamDisabled(player)
			setElementPosition(player, newx, newy, newz)
			setElementAlpha(player, 255)
			setElementFrozen(player, false)
			logMessage = "Disabled freecam."
		end
		exports.logs:addLog(player, 1, player, logMessage)
	end
end 
addCommandHandler("freecam", enableFreecam) 