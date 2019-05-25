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

buttonFont_35 = emGUI:dxCreateNewFont("fonts/buttonFont.ttf", 35)

local spamPrevent = false
local oldState = 1

--------------------------------------------------------------------------------------------
--                                      TOP GUI                                           --
--------------------------------------------------------------------------------------------

function animateF10MenuOpen()
	showCursor(true)
	f10TopGUI = emGUI:dxCreateWindow(0, -0.05, 1, 0.05, "", true, true, _, true, _, _, _, tocolor(45, 165, 10, 220), _, tocolor(45, 165, 10, 220))

	emGUI:dxMoveTo(f10TopGUI, 0, 0, true, false, "Linear", 100)

	settingsButton = emGUI:dxCreateButton(0.037, -0.65, 0.06, 1.5, "SETTINGS", true, f10TopGUI, _, _, _, _, ":account-system/underline.png", ":account-system/underline.png", tocolor(0,0,0,0), tocolor(255,255,255,200), tocolor(255,255,255,225))
	addEventHandler("onClientDgsDxMouseClick", settingsButton, settingsButtonClick)
	requestsButton = emGUI:dxCreateButton(0.15, -0.65, 0.06, 1.5, "REQUESTS", true, f10TopGUI, _, _, _, _, ":account-system/underline.png", ":account-system/underline.png", tocolor(0,0,0,0), tocolor(255,255,255,200), tocolor(255,255,255,225))
	addEventHandler("onClientDgsDxMouseClick", requestsButton, requestsButtonClick)
	donatorPerksButton = emGUI:dxCreateButton(0.26, -0.65, 0.08, 1.5, "DONATOR PERKS", true, f10TopGUI, _, _, _, _, ":account-system/underline.png", ":account-system/underline.png", tocolor(0,0,0,0), tocolor(255,255,255,200), tocolor(255,255,255,225))
	addEventHandler("onClientDgsDxMouseClick", donatorPerksButton, donatorPerksButtonClick)
	changeCharacterButton = emGUI:dxCreateButton(0.39, -0.65, 0.1, 1.5, "CHANGE CHARACTER", true, f10TopGUI, _, _, _, _, ":account-system/underline.png", ":account-system/underline.png", tocolor(0,0,0,0), tocolor(255,255,255,200), tocolor(255,255,255,225))
	addEventHandler("onClientDgsDxMouseClick", changeCharacterButton, changeCharacterButtonClick)
	helpButton = emGUI:dxCreateButton(0.80, -0.65, 0.03, 1.5, "HELP", true, f10TopGUI, _, _, _, _, ":account-system/underline.png", ":account-system/underline.png", tocolor(0,0,0,0), tocolor(255,255,255,200), tocolor(255,255,255,225))
	addEventHandler("onClientDgsDxMouseClick", helpButton, helpButtonClick)
	logoutButton = emGUI:dxCreateButton(0.85, -0.65, 0.05, 1.5, "LOGOUT", true, f10TopGUI, _, _, _, _, ":account-system/underline.png", ":account-system/underline.png", tocolor(0,0,0,0), tocolor(255,255,255,200), tocolor(255,255,255,225))
	addEventHandler("onClientDgsDxMouseClick", logoutButton, logoutButtonClick)
	closeButton = emGUI:dxCreateButton(0.91, -0.65, 0.05, 1.5, "CLOSE", true, f10TopGUI, _, _, _, _, ":account-system/underline.png", ":account-system/underline.png", tocolor(0,0,0,0), tocolor(255,255,255,200), tocolor(255,255,255,225))
	addEventHandler("onClientDgsDxMouseClick", closeButton, closeButtonClick)
end


--------------------------------------------------------------------------------------------
--                                      SIDE SETTINGS GUI                                 --
--------------------------------------------------------------------------------------------

function settingsSubMenu()
	settingsSubMenuGUI = emGUI:dxCreateWindow(0.02, 0.05, 0.09, 0.20, "", true, true, _, true, _, _, _, tocolor(45, 165, 10, 220), _, tocolor(45, 165, 10, 220))

	side_generalButton = emGUI:dxCreateButton(0.06, -0.06, 0.88, 0.20, "General", true, settingsSubMenuGUI, _, _, _, _, _, _, tocolor(0,0,0,100), tocolor(0,0,0,150), tocolor(0,0,0,200))
	addEventHandler("onClientDgsDxMouseClick", side_generalButton, side_generalButtonClick)
	side_accountButton = emGUI:dxCreateButton(0.06, 0.19, 0.88, 0.20, "Account", true, settingsSubMenuGUI, _, _, _, _, _, _, tocolor(0,0,0,100), tocolor(0,0,0,150), tocolor(0,0,0,200))
	addEventHandler("onClientDgsDxMouseClick", side_accountButton, side_accountButtonClick)
	side_notifButton = emGUI:dxCreateButton(0.06, 0.44, 0.88, 0.20, "Notifications", true, settingsSubMenuGUI, _, _, _, _, _, _, tocolor(0,0,0,100), tocolor(0,0,0,150), tocolor(0,0,0,200))
	addEventHandler("onClientDgsDxMouseClick", side_notifButton, side_notifButtonClick)
	side_graphicsButton = emGUI:dxCreateButton(0.06, 0.69, 0.88, 0.20, "Graphics", true, settingsSubMenuGUI, _, _, _, _, _, _, tocolor(0,0,0,100), tocolor(0,0,0,150), tocolor(0,0,0,200))
	addEventHandler("onClientDgsDxMouseClick", side_graphicsButton, side_graphicsButtonClick)

	spamPrevent = false
end

----- The one below is used on character selection screen.

function charSelection_settingsSubMenu()
	char_settingsSubMenuGUI = emGUI:dxCreateWindow(0.775, 0.134, 0.09, 0.20, "", true, true, _, true, _, _, _, tocolor(45, 165, 10, 220), _, tocolor(45, 165, 10, 220))

	side_generalButton = emGUI:dxCreateButton(0.06, -0.06, 0.88, 0.20, "General", true, char_settingsSubMenuGUI, _, _, _, _, _, _, tocolor(0,0,0,100), tocolor(0,0,0,150), tocolor(0,0,0,200))
	addEventHandler("onClientDgsDxMouseClick", side_generalButton, side_generalButtonClick)
	side_accountButton = emGUI:dxCreateButton(0.06, 0.19, 0.88, 0.20, "Account", true, char_settingsSubMenuGUI, _, _, _, _, _, _, tocolor(0,0,0,100), tocolor(0,0,0,150), tocolor(0,0,0,200))
	addEventHandler("onClientDgsDxMouseClick", side_accountButton, side_accountButtonClick)
	side_notifButton = emGUI:dxCreateButton(0.06, 0.44, 0.88, 0.20, "Notifications", true, char_settingsSubMenuGUI, _, _, _, _, _, _, tocolor(0,0,0,100), tocolor(0,0,0,150), tocolor(0,0,0,200))
	addEventHandler("onClientDgsDxMouseClick", side_notifButton, side_notifButtonClick)
	side_graphicsButton = emGUI:dxCreateButton(0.06, 0.69, 0.88, 0.20, "Graphics", true, char_settingsSubMenuGUI, _, _, _, _, _, _, tocolor(0,0,0,100), tocolor(0,0,0,150), tocolor(0,0,0,200))
	addEventHandler("onClientDgsDxMouseClick", side_graphicsButton, side_graphicsButtonClick)

	spamPrevent = false
end
addEvent("account:gui:settingsSubMenuGUI", true)
addEventHandler("account:gui:settingsSubMenuGUI", getRootElement(), charSelection_settingsSubMenu)

function charSelection_closeSettings()
	closeOtherGUIs()
	if (emGUI:dxIsWindowVisible(char_settingsSubMenuGUI)) then emGUI:dxCloseWindow(char_settingsSubMenuGUI) end
	if (emGUI:dxIsWindowVisible(settingsSubMenuGUI)) then emGUI:dxCloseWindow(settingsSubMenuGUI) end
end
addEvent("account:gui:closeCharSelSettings", true)
addEventHandler("account:gui:closeCharSelSettings", getRootElement(), charSelection_closeSettings)

--------------------------------------------------------------------------------------------
--                                      SIDE REQUEST GUI                                  --
--------------------------------------------------------------------------------------------

function requestsSubMenu()
	requestsSubMenuGUI = emGUI:dxCreateWindow(0.133, 0.05, 0.09, 0.15, "", true, true, _, true, _, _, _, tocolor(45, 165, 10, 220), _, tocolor(45, 165, 10, 220))

	rSide_interiorButton = emGUI:dxCreateButton(0.06, -0.085, 0.88, 0.28, "Interior", true, requestsSubMenuGUI, _, _, _, _, _, _, tocolor(0,0,0,100), tocolor(0,0,0,150), tocolor(0,0,0,200))
	addEventHandler("onClientDgsDxMouseClick", rSide_interiorButton, side_interiorButtonClick)
	rSide_mappingButton = emGUI:dxCreateButton(0.06, 0.265, 0.88, 0.28, "Mapping", true, requestsSubMenuGUI, _, _, _, _, _, _, tocolor(0,0,0,100), tocolor(0,0,0,150), tocolor(0,0,0,200))
	addEventHandler("onClientDgsDxMouseClick", rSide_mappingButton, side_mappingButtonClick)
	rSide_gatesButton = emGUI:dxCreateButton(0.06, 0.615, 0.88, 0.28, "Gates", true, requestsSubMenuGUI, _, _, _, _, _, _, tocolor(0,0,0,100), tocolor(0,0,0,150), tocolor(0,0,0,200))
	addEventHandler("onClientDgsDxMouseClick", rSide_gatesButton, side_gatesButtonClick)

	spamPrevent = false
end

--------------------------------------------------------------------------------------------
--                           CONFIRM CHAR SELECT GUI 	                                  --
--------------------------------------------------------------------------------------------

function returnToCharSelectionUI()
	charSelectConfirmGUI = emGUI:dxCreateWindow(0.38, 0.41, 0.23, 0.18, "", true, true, _, true)

	label1 = emGUI:dxCreateLabel(0.22, -0.07, 0.51, 0.26, "CONFIRM", true, charSelectConfirmGUI)
	label2 = emGUI:dxCreateLabel(0.04, 0.35, 0.75, 0.10, "Are you sure you would like to return to character selection?", true, charSelectConfirmGUI)
	emGUI:dxSetFont(label1, buttonFont_35)

	char_noButton = emGUI:dxCreateButton(0.06, 0.57, 0.40, 0.33, "NO", true, charSelectConfirmGUI)
	addEventHandler("onClientDgsDxMouseClick", char_noButton, char_noButtonClick)
	char_sureButton = emGUI:dxCreateButton(0.54, 0.57, 0.40, 0.33, "I'M SURE", true, charSelectConfirmGUI)
	addEventHandler("onClientDgsDxMouseClick", char_sureButton, char_sureButtonClick)
end

--------------------------------------------------------------------------------------------
--                           		CONFIRM LOGOUT GUI 	                                  --
--------------------------------------------------------------------------------------------
function logoutConfirmUI()
	logoutConfirmGUI = emGUI:dxCreateWindow(0.38, 0.41, 0.23, 0.18, "", true, true, _, true)

	label1 = emGUI:dxCreateLabel(0.22, -0.07, 0.51, 0.26, "CONFIRM", true, logoutConfirmGUI)
	label2 = emGUI:dxCreateLabel(0.12, 0.35, 0.75, 0.10, "Are you sure you would like to logout?", true, logoutConfirmGUI)
	emGUI:dxLabelSetHorizontalAlign(label2, "center")
	emGUI:dxSetFont(label1, buttonFont_35)

	logout_noButton = emGUI:dxCreateButton(0.06, 0.57, 0.40, 0.33, "NO", true, logoutConfirmGUI)
	addEventHandler("onClientDgsDxMouseClick", logout_noButton, logout_noButtonClick)
	logout_confirmButton = emGUI:dxCreateButton(0.54, 0.57, 0.40, 0.33, "I'M SURE", true, logoutConfirmGUI)
	addEventHandler("onClientDgsDxMouseClick", logout_confirmButton, logout_confirmButtonClick)
end

--------------------------------------------------------------------------------------------
--                                      FUNCTIONS 	                                      --
--------------------------------------------------------------------------------------------

function animate_subMenuOpen(menu)
	if tostring(menu) then
		local menu = tostring(menu)

		if (menu == "settings") then
			anim_settingsSubMenuGUI = emGUI:dxCreateWindow(0.02, 0.05, 0.09, 0, "", true, true, _, true, _, _, _, tocolor(45, 165, 10, 220), _, tocolor(45, 165, 10, 220))
			emGUI:dxSizeTo(anim_settingsSubMenuGUI, 0.09, 0.20, true, false, "Linear", 100)

			spamPrevent = true
			setTimer(function()
				emGUI:dxCloseWindow(anim_settingsSubMenuGUI)
				settingsSubMenu()
			end, 110, 1)
		elseif (menu == "requests") then
			anim_requestsSubMenuGUI = emGUI:dxCreateWindow(0.133, 0.05, 0.09, 0, "", true, true, _, true, _, _, _, tocolor(45, 165, 10, 220), _, tocolor(45, 165, 10, 220))
			emGUI:dxSizeTo(anim_requestsSubMenuGUI, 0.09, 0.15, true, false, "Linear", 80)

			spamPrevent = true
			setTimer(function()
				emGUI:dxCloseWindow(anim_requestsSubMenuGUI)
				requestsSubMenu()
			end, 90, 1)
		end
	end
end

function closingF10()
	if not (spamPrevent) then
		closeOtherGUIs()
		showCursor(false)
		emGUI:dxCloseWindow(f10TopGUI)
		triggerEvent("hud:updateHudData", localPlayer, "hud:enabledstatus", oldState)
	end
end

--[[				[uiToKeep Types]
1 = Settings Submenu 				8 = Settings > Account GUI
2 = Requests Submenu 				9 = Settings > Notifications GUI
3 = Donator Perks GUI 				10 = Settings > Graphics GUI
4 = Change Char GUI 				11 = Requests > Interior GUI
5 = Help GUI 						12 = Requests > Mapping GUI
6 = Logout GUI 						13 = Requests > Gates GUI
7 = Settings > General GUI 											]]

function closeOtherGUIs(uiToKeep)
	local guiState1 = emGUI:dxIsWindowVisible(settingsSubMenuGUI)
	local guiState2 = emGUI:dxIsWindowVisible(requestsSubMenuGUI)
	--local guiState3 = reserved for donator perks
	local guiState4 = emGUI:dxIsWindowVisible(charSelectConfirmGUI)
	local guiState5 = emGUI:dxIsWindowVisible(infoGUIWindow)
	local guiState6 = emGUI:dxIsWindowVisible(logoutConfirmGUI)
	local guiState7 = emGUI:dxIsWindowVisible(settings_generalGUI)
	local guiState8 = emGUI:dxIsWindowVisible(settings_accountGUI)
	local guiState9 = emGUI:dxIsWindowVisible(settings_notificationGUI)
	local guiState10 = emGUI:dxIsWindowVisible(settings_graphicsGUI)
	--local guiState11 = emGUI:dxIsWindowVisible(CHANGEME)
	--local guiState12 = emGUI:dxIsWindowVisible(CHANGEME)
	--local guiState13 = emGUI:dxIsWindowVisible(CHANGEME)

	if (guiState1) and not (uiToKeep == 1) then emGUI:dxCloseWindow(settingsSubMenuGUI) end
	if (guiState2) and not (uiToKeep == 2) then emGUI:dxCloseWindow(requestsSubMenuGUI) end
	--if (guiState3) and not (uiToKeep == 3) then emGUI:dxCloseWindow(CHANGEME) end
	if (guiState4) and not (uiToKeep == 4) then emGUI:dxCloseWindow(charSelectConfirmGUI) end
	if (guiState5) and not (uiToKeep == 5) then emGUI:dxCloseWindow(infoGUIWindow) end
	if (guiState6) and not (uiToKeep == 6) then emGUI:dxCloseWindow(logoutConfirmGUI) end
	if (guiState7) and not (uiToKeep == 7) then emGUI:dxCloseWindow(settings_generalGUI) end
	if (guiState8) and not (uiToKeep == 8) then emGUI:dxCloseWindow(settings_accountGUI) end
	if (guiState9) and not (uiToKeep == 9) then emGUI:dxCloseWindow(settings_notificationGUI) end
	if (guiState10) and not (uiToKeep == 10) then emGUI:dxCloseWindow(settings_graphicsGUI) end
	--if (guiState11) and not (uiToKeep == 11) then emGUI:dxCloseWindow(CHANGEME) end
	--if (guiState12) and not (uiToKeep == 12) then emGUI:dxCloseWindow(CHANGEME) end
	--if (guiState13) and not (uiToKeep == 13) then emGUI:dxCloseWindow(CHANGEME) end
end
--------------------------------------------------------------------------------------------
--                                      BUTTON CLICKS                                     --
--------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------- 
-- TOP HUD BUTTONS
--------------------------------------------------------------------------------------------
function settingsButtonClick(button, state)
	if (button == "left") and (state == "down") then
		if not (spamPrevent) then
			local guiState = emGUI:dxIsWindowVisible(settingsSubMenuGUI)
			if not (guiState) then
				closeOtherGUIs()
				animate_subMenuOpen("settings")
			else
				emGUI:dxCloseWindow(settingsSubMenuGUI)
			end
		end
	end
end

function requestsButtonClick(button, state)
	if (button == "left") and (state == "down") then
		if not (spamPrevent) then
			local guiState = emGUI:dxIsWindowVisible(requestsSubMenuGUI)
			if not (guiState) then
				closeOtherGUIs()
				animate_subMenuOpen("requests")
			else
				emGUI:dxCloseWindow(requestsSubMenuGUI)
			end
		end
	end
end

function donatorPerksButtonClick(button, state)
	if (button == "left") and (state == "down") then
		outputDebugString("donatorPerksButtonClick", 3)
	end
end

function changeCharacterButtonClick(button, state)
	if (button == "left") and (state == "down") then
		local guiState = emGUI:dxIsWindowVisible(charSelectConfirmGUI)
		if not (guiState) then
			closeOtherGUIs(4)
			returnToCharSelectionUI()
		else
			emGUI:dxCloseWindow(charSelectConfirmGUI)
		end
	end
end

function helpButtonClick(button, state)
	if (button == "left") and (state == "down") then
		closeOtherGUIs(5)
		local guiState = emGUI:dxIsWindowVisible(infoGUIWindow)
		if not (guiState) then
			triggerEvent("account:showInfoGUI", getRootElement())
		else
			emGUI:dxCloseWindow(infoGUIWindow)
		end
	end
end

function logoutButtonClick(button, state)
	if (button == "left") and (state == "down") then
		local guiState = emGUI:dxIsWindowVisible(logoutConfirmGUI)
		if not (guiState) then
			closeOtherGUIs(6)
			logoutConfirmUI()
		else
			emGUI:dxCloseWindow(logoutConfirmGUI)
		end
	end
end

function closeButtonClick(button, state)
	if (button == "left") and (state == "down") then
		closingF10()
	end
end
-------------------------------------------------------------------------------------------- 
-- SETTINGS SUBGUI BUTTONS
--------------------------------------------------------------------------------------------

function side_generalButtonClick(button, state)
	if (button == "left") and (state == "down") then
		local guiState = emGUI:dxIsWindowVisible(settings_generalGUI)
		if not (guiState) then
			closeOtherGUIs(7)
			showGeneralSettingsGUI()
		else
			emGUI:dxCloseWindow(settings_generalGUI)
		end
	end
end

function side_accountButtonClick(button, state)
	if (button == "left") and (state == "down") then
		local guiState = emGUI:dxIsWindowVisible(settings_accountGUI)
		if not (guiState) then
			closeOtherGUIs(8)
			showAccountSettingsGUI()
		else
			emGUI:dxCloseWindow(settings_accountGUI)
		end
	end
end

function side_notifButtonClick(button, state)
	if (button == "left") and (state == "down") then
		local guiState = emGUI:dxIsWindowVisible(settings_notificationGUI)
		if not (guiState) then
			closeOtherGUIs(9)
			showNotificationSettingsGUI()
		else
			emGUI:dxCloseWindow(settings_notificationGUI)
		end
	end
end

function side_graphicsButtonClick(button, state)
	if (button == "left") and (state == "down") then
		local guiState = emGUI:dxIsWindowVisible(settings_graphicsGUI)
		if not (guiState) then
			closeOtherGUIs(10)
			showGraphicSettingsGUI()
		else
			emGUI:dxCloseWindow(settings_graphicsGUI)
		end
	end
end

-------------------------------------------------------------------------------------------- 
-- REQUESTS SUBGUI BUTTONS
--------------------------------------------------------------------------------------------

function side_interiorButtonClick(button, state)
	if (button == "left") and (state == "down") then
		outputDebugString("side_interiorButton", 3)
	end
end

function side_mappingButtonClick(button, state)
	if (button == "left") and (state == "down") then
		outputDebugString("side_mappingButton", 3)
	end
end

function side_gatesButtonClick(button, state)
	if (button == "left") and (state == "down") then
		outputDebugString("side_gatesButton", 3)
	end
end

-------------------------------------------------------------------------------------------- 
-- CHAR SEL BUTTONS
--------------------------------------------------------------------------------------------

function char_noButtonClick(button, state)
	if (button == "left") and (state == "down") then
		emGUI:dxCloseWindow(charSelectConfirmGUI)
	end
end

function char_sureButtonClick(button, state)
	if (button == "left") and (state == "down") then
		closingF10()
		triggerEvent("character:returnToCharSelection", localPlayer)
	end
end

function logout_noButtonClick(button, state)
	if (button == "left") and (state == "down") then
		emGUI:dxCloseWindow(logoutConfirmGUI)
	end
end

function logout_confirmButtonClick(button, state)
	if (button == "left") and (state == "down") then
		emGUI:dxCloseWindow(logoutConfirmGUI)
		closingF10()
		triggerEvent("character:logoutPlayer", localPlayer)
	end
end
--------------------------------------------------------------------------------------------
--                                      F10 bindKey                                       --
--------------------------------------------------------------------------------------------

function displayF10Menu()
	local loggedin = getElementData(localPlayer, "loggedin")
	if (loggedin == 1) then
		local guiState = emGUI:dxIsWindowVisible(f10TopGUI)
		if not (guiState) then
			oldState = getElementData(localPlayer, "hud:enabledstatus")
			triggerEvent("hud:updateHudData", localPlayer, "hud:enabledstatus", 2)
			animateF10MenuOpen()
		else
			--triggerEvent("hud:updateHudData", localPlayer, "hud:enabledstatus", oldState)
			closingF10()
		end
	end
end
addCommandHandler("f10", displayF10Menu)
bindKey("F10", "down", "f10")