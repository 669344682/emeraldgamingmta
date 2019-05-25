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

-- Script watermark.
local version = "EG:RP v0.5.0 | "
local vSize = dxGetTextWidth(version)
local iSize = dxGetTextWidth("MTA:SA 1.5.5 ")
local sx, sy = guiGetScreenSize()
 
addEventHandler("onClientRender", root, function()
	dxDrawText(version, sx - iSize - vSize, sy - 14, sx, sy, tocolor(255, 255, 255, 100), 1, "default")
end)

-- Things that should happen when a player joins the server.
function onJoin()
	setAmbientSoundEnabled("gunfire", false)
	triggerServerEvent("updateNametagColor", localPlayer)
end

addEventHandler("onClientResourceStart", getResourceRootElement(), onJoin)

-- Disable ability to one-hit kill with knife.
function abortAllStealthKills(targetPlayer)
    cancelEvent()
end
addEventHandler("onClientPlayerStealthKill", getLocalPlayer(), abortAllStealthKills)