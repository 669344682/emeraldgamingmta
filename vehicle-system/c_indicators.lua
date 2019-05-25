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

function indicatorLeft() triggerServerEvent("vehicle:indicate:left", localPlayer, "left") end
function indicatorRight() triggerServerEvent("vehicle:indicate:right", localPlayer, "right") end
function indicatorHazards() triggerServerEvent("vehicle:indicate:hazards", localPlayer, "hazards") end

local function bindIndicators()
	if (getElementData(localPlayer, "settings:general:setting3") ~= 1) then
		bindKey("[", "down", indicatorLeft)
		bindKey("]", "down", indicatorRight)
		bindKey("=", "down", indicatorHazards)
	else
		addCommandHandler("indicator_left", indicatorLeft)
		addCommandHandler("indicator_right", indicatorRight)
		addCommandHandler("indicator_hazards", indicatorHazards)
	end
end

addEventHandler("onClientPlayerVehicleEnter", localPlayer, function(_, s) if (s == 0) then bindIndicators() end end)
addEventHandler("onClientResourceStart", resourceRoot, function()
	local veh = getPedOccupiedVehicle(localPlayer)
	if (veh) and (getVehicleOccupant(veh, 0) == localPlayer) then bindIndicators() end
end)

addEventHandler("onClientPlayerVehicleExit", localPlayer, function()
	unbindKey("[", "down", indicatorLeft)
	unbindKey("]", "down", indicatorRight)
	unbindKey("=", "down", indicatorHazards)
	removeCommandHandler("indicator_left")
	removeCommandHandler("indicator_right")
	removeCommandHandler("indicator_hazards")
end)