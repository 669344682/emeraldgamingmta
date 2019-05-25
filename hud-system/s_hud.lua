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

function toggleHUD(thePlayer)
	if (getElementData(thePlayer, "loggedin") == 1) then
		local hudStatus = getElementData(thePlayer, "hud:enabledstatus")

		if (hudStatus == 0) then
			setElementData(thePlayer, "hud:enabledstatus", 1, true)
			outputChatBox("Your HUD has been disabled.", thePlayer, 0, 255, 0)
		else
			setElementData(thePlayer, "hud:enabledstatus", 0, true)
			outputChatBox("Your HUD has been enabled.", thePlayer, 0, 255, 0)
		end
	end
end
addCommandHandler("toghud", toggleHUD)

function toggleReportPanel(thePlayer)
	if (exports.global:isPlayerStaff(thePlayer)) then
		local panelStatus = getElementData(thePlayer, "hud:reportpanel")

		triggerClientEvent("report:toggleReportMenuState", thePlayer)
		if (panelStatus == 0) then
			setElementData(thePlayer, "hud:reportpanel", 1, true)
		else
			setElementData(thePlayer, "hud:reportpanel", 0, true)
		end
	end
end
addCommandHandler("togreportpanel", toggleReportPanel)