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

emGUI = exports.emGUI

function showAnnouncement(message, r, g, b)
	local guiState = emGUI:dxIsWindowVisible(annWindow)
	if not (guiState) then
		if getElementData(localPlayer, "loggedin") == 1 then
			message = "ANNOUNCEMENT: " .. message
			outputConsole(message)

			annWindow = emGUI:dxCreateWindow(0, -0.5, 1, 0.03, "", true, true, true, true, _, 1.5, _, tocolor(r, g, b, 255), _, tocolor(0, 0, 0, 200))
			labelMessage = emGUI:dxCreateLabel(1, 0.20, 0.88, 0.42, message, true, annWindow)
			emGUI:dxLabelSetHorizontalAlign(labelMessage, "center")
			emGUI:dxLabelSetColor(labelMessage, r, g, b)
			emGUI:dxMoveTo(annWindow, 0, 0, true, false, "OutQuad", 500)
			
			playSound("sounds/announcementSound.mp3", false)
			setTimer(function()
				emGUI:dxMoveTo(labelMessage, -0.9, 0.20, true, false, "OutInQuad", 20000)
			end, 810, 1)

			setTimer(function()
				emGUI:dxMoveTo(annWindow, 0, -0.5, true, false, "InQuad", 800)
			end, 23050, 1)
			setTimer(function()
				emGUI:dxCloseWindow(annWindow)
			end, 23150, 1)
		end
	end
end
addEvent("admin:createAnnouncement", true)
addEventHandler("admin:createAnnouncement", getRootElement(), showAnnouncement)