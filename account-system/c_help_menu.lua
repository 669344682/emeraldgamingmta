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

function showInfoGUI()
	local infoGUI = {
		tab = {},
		label = {}
	}

	infoGUIWindow = emGUI:dxCreateWindow(0.31, 0.16, 0.37, 0.67, "Emerald Gaming Roleplay Information", true)
	infoTabPanel = emGUI:dxCreateTabPanel(0.04, 0.02, 0.92, 0.96, true, infoGUIWindow)
	infoGUI.tab[1] = emGUI:dxCreateTab("Introduction", infoTabPanel)
	infoGUI.label[1] = emGUI:dxCreateLabel(0.01, 0.01, 0.98, 0.97, "Welcome to Emerald Gaming Roleplay! Thanks for partaking in the Closed Alpha Testing.\nYou can use /editrank to adjust your rank for testing purposes.\n\nAll discovered bugs can be reported at https://bugs.emeraldgaming.net\nIf you have any questions, get in touch on Discord in the #alpha-tesing channel.", true, infoGUI.tab[1])
	infoGUI.tab[2] = emGUI:dxCreateTab("Community", infoTabPanel)
	infoGUI.label[3] = emGUI:dxCreateLabel(0.01, 0.01, 0.98, 0.97, "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt\nut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation\nullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in\nreprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.\nExcepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt\nmollit anim id est laborum.", true, infoGUI.tab[2])
	infoGUI.tab[3] = emGUI:dxCreateTab("Roleplay", infoTabPanel)
	infoGUI.label[4] = emGUI:dxCreateLabel(0.01, 0.01, 0.98, 0.97, "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt\nut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation\nullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in\nreprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.\nExcepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt\nmollit anim id est laborum.", true, infoGUI.tab[3])   
end
addEvent("account:showInfoGUI", true)
addEventHandler("account:showInfoGUI", getRootElement(), showInfoGUI)

function showInfo()
	local guiState = emGUI:dxIsWindowVisible(infoGUIWindow)
	if not (guiState) then
		showInfoGUI()
	else
		emGUI:dxCloseWindow(infoGUIWindow)
	end
end
addCommandHandler("helpme", showInfo)