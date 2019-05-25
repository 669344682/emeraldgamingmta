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

---------------------------------------------------------------------------------------------------------------------------------------
--														GENERAL SETTINGS GUI 														 --
---------------------------------------------------------------------------------------------------------------------------------------

function showGeneralSettingsGUI()
	local settingValues = loadSettings(1)
	if not (settingValues) then
		outputChatBox("ERROR: Something went wrong whilst loading your settings, try reconnecting to resolve this.", 255, 0, 0)
		return false
	end

	local settingsLabels = {}

	settings_generalGUI = emGUI:dxCreateWindow(0.31, 0.24, 0.39, 0.53, "General Settings", true, true, _, true)

	settingsLabels[1] = emGUI:dxCreateLabel(0.08, 0.07, 0.16, 0.03, "Enable Typing Icons", true, settings_generalGUI)
	settingsLabels[2] = emGUI:dxCreateLabel(0.08, 0.19, 0.16, 0.03, "Enable Radio Streams", true, settings_generalGUI)
	settingsLabels[3] = emGUI:dxCreateLabel(0.08, 0.31, 0.16, 0.03, "Show Own Nametag", true, settings_generalGUI)
	
	generalSettings = {
		[1] = {
			[1] = emGUI:dxCreateButton(0.08, 0.11, 0.07, 0.05, "OFF", true, settings_generalGUI, _, _, _, _, _, _, _, tocolor(50, 200, 0, 180), tocolor(50, 200, 0, 180)),
			[2] = emGUI:dxCreateButton(0.15, 0.11, 0.07, 0.05, "ON", true, settings_generalGUI, _, _, _, _, _, _, _, tocolor(50, 200, 0, 180), tocolor(50, 200, 0, 180)),
		},
		[2] = {
			[1] = emGUI:dxCreateButton(0.08, 0.23, 0.07, 0.05, "OFF", true, settings_generalGUI, _, _, _, _, _, _, _, tocolor(50, 200, 0, 180), tocolor(50, 200, 0, 180)),
			[2] = emGUI:dxCreateButton(0.15, 0.23, 0.07, 0.05, "ON", true, settings_generalGUI, _, _, _, _, _, _, _, tocolor(50, 200, 0, 180), tocolor(50, 200, 0, 180)),
		},
		[3] = {
			[1] = emGUI:dxCreateButton(0.08, 0.35, 0.07, 0.05, "OFF", true, settings_generalGUI, _, _, _, _, _, _, _, tocolor(50, 200, 0, 180), tocolor(50, 200, 0, 180)),
			[2] = emGUI:dxCreateButton(0.15, 0.35, 0.07, 0.05, "ON", true, settings_generalGUI, _, _, _, _, _, _, _, tocolor(50, 200, 0, 180), tocolor(50, 200, 0, 180)),
		},
	}

	-- Load settings.
	if (settingValues[1] == 1) then emGUI:dxSetAlpha(generalSettings[1][1], 0.3) else emGUI:dxSetAlpha(generalSettings[1][2], 0.3) end
	if (settingValues[2] == 1) then emGUI:dxSetAlpha(generalSettings[2][1], 0.3) else emGUI:dxSetAlpha(generalSettings[2][2], 0.3) end
	if (settingValues[3] == 1) then emGUI:dxSetAlpha(generalSettings[3][1], 0.3) else emGUI:dxSetAlpha(generalSettings[3][2], 0.3) end
	--

	for k, i in ipairs(generalSettings) do
		addEventHandler("onClientDgsDxMouseClick", generalSettings[k][1], general_settingToggle)
		addEventHandler("onClientDgsDxMouseClick", generalSettings[k][2], general_settingToggle)
	end

	general_cancelButton = emGUI:dxCreateButton(0.27, 0.84, 0.22, 0.13, "CANCEL", true, settings_generalGUI)
	addEventHandler("onClientDgsDxMouseClick", general_cancelButton, settings_cancelChangeClick)

	general_applyButton = emGUI:dxCreateButton(0.51, 0.84, 0.22, 0.13, "APPLY", true, settings_generalGUI)
	addEventHandler("onClientDgsDxMouseClick", general_applyButton, settings_applyChangeClick)
end

function general_settingToggle(button, state)
	if (button == "left") and (state == "down") then
		local optionID, stateID

		for j, setting in ipairs(generalSettings) do
			for k, state in ipairs(setting) do
				if source == state then
					optionID = j;
					stateID = k;
				end
			end
		end

		if not tonumber(optionID) or not tonumber(stateID) then
			outputDebugString("[account-system] settingToggle: Failed to fetch button source to update toggle.", 3)
			return false
		end
		
		local offState = emGUI:dxGetEnabled(generalSettings[optionID][stateID])

		if (offState) then
			if (stateID == 1) then
				emGUI:dxSetAlpha(generalSettings[optionID][1], 1)
				emGUI:dxSetAlpha(generalSettings[optionID][2], 0.3)
			else
				emGUI:dxSetAlpha(generalSettings[optionID][1], 0.3)
				emGUI:dxSetAlpha(generalSettings[optionID][2], 1)
			end
		end
	end
end

---------------------------------------------------------------------------------------------------------------------------------------
--														ACCOUNT SETTINGS GUI 														 --
---------------------------------------------------------------------------------------------------------------------------------------

function showAccountSettingsGUI()
	local settingValues = loadSettings(2)
	if not (settingValues) then
		outputChatBox("ERROR: Something went wrong whilst loading your settings, try reconnecting to resolve this.", 255, 0, 0)
		return false
	end

	local accountLabels = {}

	settings_accountGUI = emGUI:dxCreateWindow(0.31, 0.24, 0.39, 0.53, "Account Settings", true, true, _, true)

	accountLabels[1] = emGUI:dxCreateLabel(0.08, 0.07, 0.16, 0.03, "Enable account username in PMs", true, settings_accountGUI)
	accountLabels[2] = emGUI:dxCreateLabel(0.08, 0.19, 0.16, 0.03, "Allow others to send you friend requests", true, settings_accountGUI)
	accountLabels[3] = emGUI:dxCreateLabel(0.08, 0.31, 0.16, 0.03, "Allow friends to bypass PM Block", true, settings_accountGUI)
	accountLabels[4] = emGUI:dxCreateLabel(0.08, 0.43, 0.16, 0.03, "Automatically go on staff duty when logged in", true, settings_accountGUI)


	accountSettings = {
		[1] = {
			[1] = emGUI:dxCreateButton(0.08, 0.11, 0.07, 0.05, "OFF", true, settings_accountGUI, _, _, _, _, _, _, _, tocolor(50, 200, 0, 180), tocolor(50, 200, 0, 180)),
			[2] = emGUI:dxCreateButton(0.15, 0.11, 0.07, 0.05, "ON", true, settings_accountGUI, _, _, _, _, _, _, _, tocolor(50, 200, 0, 180), tocolor(50, 200, 0, 180)),
		},
		[2] = {
			[1] = emGUI:dxCreateButton(0.08, 0.23, 0.07, 0.05, "OFF", true, settings_accountGUI, _, _, _, _, _, _, _, tocolor(50, 200, 0, 180), tocolor(50, 200, 0, 180)),
			[2] = emGUI:dxCreateButton(0.15, 0.23, 0.07, 0.05, "ON", true, settings_accountGUI, _, _, _, _, _, _, _, tocolor(50, 200, 0, 180), tocolor(50, 200, 0, 180)),
		},
		[3] = {
			[1] = emGUI:dxCreateButton(0.08, 0.35, 0.07, 0.05, "OFF", true, settings_accountGUI, _, _, _, _, _, _, _, tocolor(50, 200, 0, 180), tocolor(50, 200, 0, 180)),
			[2] = emGUI:dxCreateButton(0.15, 0.35, 0.07, 0.05, "ON", true, settings_accountGUI, _, _, _, _, _, _, _, tocolor(50, 200, 0, 180), tocolor(50, 200, 0, 180)),
		},
		[4] = {
			[1] = emGUI:dxCreateButton(0.08, 0.47, 0.07, 0.05, "OFF", true, settings_accountGUI, _, _, _, _, _, _, _, tocolor(50, 200, 0, 180), tocolor(50, 200, 0, 180)),
			[2] = emGUI:dxCreateButton(0.15, 0.47, 0.07, 0.05, "ON", true, settings_accountGUI, _, _, _, _, _, _, _, tocolor(50, 200, 0, 180), tocolor(50, 200, 0, 180)),
		},
	}

	-- Load settings.
	if (settingValues[1] == 1) then emGUI:dxSetAlpha(accountSettings[1][1], 0.3) else emGUI:dxSetAlpha(accountSettings[1][2], 0.3) end
	if (settingValues[2] == 1) then emGUI:dxSetAlpha(accountSettings[2][1], 0.3) else emGUI:dxSetAlpha(accountSettings[2][2], 0.3) end
	if (settingValues[3] == 1) then emGUI:dxSetAlpha(accountSettings[3][1], 0.3) else emGUI:dxSetAlpha(accountSettings[3][2], 0.3) end
	if (settingValues[4] == 1) then emGUI:dxSetAlpha(accountSettings[4][1], 0.3) else emGUI:dxSetAlpha(accountSettings[4][2], 0.3) end
	--

	for k, i in ipairs(accountSettings) do
		addEventHandler("onClientDgsDxMouseClick", accountSettings[k][1], account_settingToggle)
		addEventHandler("onClientDgsDxMouseClick", accountSettings[k][2], account_settingToggle)
	end

	account_cancelButton = emGUI:dxCreateButton(0.27, 0.84, 0.22, 0.13, "CANCEL", true, settings_accountGUI)
	addEventHandler("onClientDgsDxMouseClick", account_cancelButton, settings_cancelChangeClick)

	account_applyButton = emGUI:dxCreateButton(0.51, 0.84, 0.22, 0.13, "APPLY", true, settings_accountGUI)
	addEventHandler("onClientDgsDxMouseClick", account_applyButton, settings_applyChangeClick)
end

function account_settingToggle(button, state)
	if (button == "left") and (state == "down") then
		local optionID, stateID

		for j, setting in ipairs(accountSettings) do
			for k, state in ipairs(setting) do
				if source == state then
					optionID = j;
					stateID = k;
				end
			end
		end

		if not tonumber(optionID) or not tonumber(stateID) then
			outputDebugString("[account-system] account_settingToggle: Failed to fetch button source to update toggle.", 3)
			return false
		end
		
		local offState = emGUI:dxGetEnabled(accountSettings[optionID][stateID])

		if (offState) then
			if (stateID == 1) then
				emGUI:dxSetAlpha(accountSettings[optionID][1], 1)
				emGUI:dxSetAlpha(accountSettings[optionID][2], 0.3)
			else
				emGUI:dxSetAlpha(accountSettings[optionID][1], 0.3)
				emGUI:dxSetAlpha(accountSettings[optionID][2], 1)
			end
		end
	end
end

---------------------------------------------------------------------------------------------------------------------------------------
--														NOTIFICATION SETTINGS GUI 														 --
---------------------------------------------------------------------------------------------------------------------------------------

function showNotificationSettingsGUI()
	local settingValues = loadSettings(3)
	if not (settingValues) then
		outputChatBox("ERROR: Something went wrong whilst loading your settings, try reconnecting to resolve this.", 255, 0, 0)
		return false
	end

	local notificationLabels = {}

	settings_notificationGUI = emGUI:dxCreateWindow(0.31, 0.24, 0.39, 0.53, "Notification Settings", true, true, _, true)

	notificationLabels[1] = emGUI:dxCreateLabel(0.08, 0.07, 0.16, 0.03, "Enable inactivity scanner notifications", true, settings_notificationGUI)
	notificationLabels[2] = emGUI:dxCreateLabel(0.08, 0.19, 0.16, 0.03, "Enable faction notifications", true, settings_notificationGUI)
	notificationLabels[3] = emGUI:dxCreateLabel(0.08, 0.31, 0.16, 0.03, "Show staff punishment messages", true, settings_notificationGUI)
	notificationLabels[4] = emGUI:dxCreateLabel(0.08, 0.43, 0.16, 0.03, "Enable mention notification in staff chats", true, settings_notificationGUI)

	socialNotifTypeGrid = emGUI:dxCreateGridList(0.55, 0.07, 0.34, 0.16, true, settings_notificationGUI)
	emGUI:dxGridListAddColumn(socialNotifTypeGrid, "Social Notifications Type", 1)
	for i = 1, 3 do
		emGUI:dxGridListAddRow(socialNotifTypeGrid)
	end
	emGUI:dxGridListSetItemText(socialNotifTypeGrid, 1, 1, "Show only logout/login notifications.")
	emGUI:dxGridListSetItemText(socialNotifTypeGrid, 2, 1, "Show only character changes")
	emGUI:dxGridListSetItemText(socialNotifTypeGrid, 3, 1, "Show all updates.")
	
	
	notificationSettings = {
		[1] = {
			[1] = emGUI:dxCreateButton(0.08, 0.11, 0.07, 0.05, "OFF", true, settings_notificationGUI, _, _, _, _, _, _, _, tocolor(50, 200, 0, 180), tocolor(50, 200, 0, 180)),
			[2] = emGUI:dxCreateButton(0.15, 0.11, 0.07, 0.05, "ON", true, settings_notificationGUI, _, _, _, _, _, _, _, tocolor(50, 200, 0, 180), tocolor(50, 200, 0, 180)),
		},
		[2] = {
			[1] = emGUI:dxCreateButton(0.08, 0.23, 0.07, 0.05, "OFF", true, settings_notificationGUI, _, _, _, _, _, _, _, tocolor(50, 200, 0, 180), tocolor(50, 200, 0, 180)),
			[2] = emGUI:dxCreateButton(0.15, 0.23, 0.07, 0.05, "ON", true, settings_notificationGUI, _, _, _, _, _, _, _, tocolor(50, 200, 0, 180), tocolor(50, 200, 0, 180)),
		},
		[3] = {
			[1] = emGUI:dxCreateButton(0.08, 0.35, 0.07, 0.05, "OFF", true, settings_notificationGUI, _, _, _, _, _, _, _, tocolor(50, 200, 0, 180), tocolor(50, 200, 0, 180)),
			[2] = emGUI:dxCreateButton(0.15, 0.35, 0.07, 0.05, "ON", true, settings_notificationGUI, _, _, _, _, _, _, _, tocolor(50, 200, 0, 180), tocolor(50, 200, 0, 180)),
		},
		[4] = {
			[1] = emGUI:dxCreateButton(0.08, 0.47, 0.07, 0.05, "OFF", true, settings_notificationGUI, _, _, _, _, _, _, _, tocolor(50, 200, 0, 180), tocolor(50, 200, 0, 180)),
			[2] = emGUI:dxCreateButton(0.15, 0.47, 0.07, 0.05, "ON", true, settings_notificationGUI, _, _, _, _, _, _, _, tocolor(50, 200, 0, 180), tocolor(50, 200, 0, 180)),
		},
	}

	-- Load settings.
	if (settingValues[1] == 1) then emGUI:dxSetAlpha(notificationSettings[1][1], 0.3) else emGUI:dxSetAlpha(notificationSettings[1][2], 0.3) end
	if (settingValues[2] == 1) then emGUI:dxSetAlpha(notificationSettings[2][1], 0.3) else emGUI:dxSetAlpha(notificationSettings[2][2], 0.3) end
	if (settingValues[3] == 1) then emGUI:dxSetAlpha(notificationSettings[3][1], 0.3) else emGUI:dxSetAlpha(notificationSettings[3][2], 0.3) end
	if (settingValues[4]) then emGUI:dxGridListSetSelectedItem(socialNotifTypeGrid, tonumber(settingValues[4]), 1) end
	if (settingValues[5] == 1) then emGUI:dxSetAlpha(notificationSettings[4][1], 0.3) else emGUI:dxSetAlpha(notificationSettings[4][2], 0.3) end
	--

	for k, i in ipairs(notificationSettings) do
		addEventHandler("onClientDgsDxMouseClick", notificationSettings[k][1], notification_settingToggle)
		addEventHandler("onClientDgsDxMouseClick", notificationSettings[k][2], notification_settingToggle)
	end

	notification_cancelButton = emGUI:dxCreateButton(0.27, 0.84, 0.22, 0.13, "CANCEL", true, settings_notificationGUI)
	addEventHandler("onClientDgsDxMouseClick", notification_cancelButton, settings_cancelChangeClick)

	notification_applyButton = emGUI:dxCreateButton(0.51, 0.84, 0.22, 0.13, "APPLY", true, settings_notificationGUI)
	addEventHandler("onClientDgsDxMouseClick", notification_applyButton, settings_applyChangeClick)
end

function notification_settingToggle(button, state)
	if (button == "left") and (state == "down") then
		local optionID, stateID

		for j, setting in ipairs(notificationSettings) do
			for k, state in ipairs(setting) do
				if source == state then
					optionID = j;
					stateID = k;
				end
			end
		end

		if not tonumber(optionID) or not tonumber(stateID) then
			outputDebugString("[account-system] notification_settingToggle: Failed to fetch button source to update toggle.", 3)
			return false
		end
		
		local offState = emGUI:dxGetEnabled(notificationSettings[optionID][stateID])

		if (offState) then
			if (stateID == 1) then
				emGUI:dxSetAlpha(notificationSettings[optionID][1], 1)
				emGUI:dxSetAlpha(notificationSettings[optionID][2], 0.3)
			else
				emGUI:dxSetAlpha(notificationSettings[optionID][1], 0.3)
				emGUI:dxSetAlpha(notificationSettings[optionID][2], 1)
			end
		end
	end
end

---------------------------------------------------------------------------------------------------------------------------------------
--														GRAPHIC SETTINGS GUI 														 --
---------------------------------------------------------------------------------------------------------------------------------------

function showGraphicSettingsGUI()
	local settingValues = loadSettings(4)
	if not (settingValues) then
		outputChatBox("ERROR: Something went wrong whilst loading your settings, try reconnecting to resolve this.", 255, 0, 0)
		return false
	end

	local graphicLabels = {}

	settings_graphicsGUI = emGUI:dxCreateWindow(0.31, 0.24, 0.39, 0.53, "Graphic Settings", true, true, _, true)

	graphicLabels[1] = emGUI:dxCreateLabel(0.08, 0.07, 0.16, 0.03, "Enable motion blur", true, settings_graphicsGUI)
	graphicLabels[2] = emGUI:dxCreateLabel(0.08, 0.19, 0.16, 0.03, "Enable road shader", true, settings_graphicsGUI)
	graphicLabels[3] = emGUI:dxCreateLabel(0.08, 0.31, 0.16, 0.03, "Enable HDR shader", true, settings_graphicsGUI)
	graphicLabels[4] = emGUI:dxCreateLabel(0.08, 0.43, 0.16, 0.03, "Enable car shader", true, settings_graphicsGUI)
	graphicLabels[5] = emGUI:dxCreateLabel(0.08, 0.55, 0.16, 0.03, "Enable sky shader", true, settings_graphicsGUI)
	graphicLabels[6] = emGUI:dxCreateLabel(0.08, 0.67, 0.16, 0.03, "Enable water shader", true, settings_graphicsGUI)
	
	graphicLabels[7] = emGUI:dxCreateLabel(0.71, 0.07, 0.16, 0.03, "PREVIEW", true, settings_graphicsGUI)
	hudStylePreview = emGUI:dxCreateImage(0.71, 0.11, 0.073, 0.10, ":hud-system/images/hud/black_on_white/hudicon.png", true, settings_graphicsGUI)

	hudStyleGrid = emGUI:dxCreateGridList(0.48, 0.07, 0.20, 0.16, true, settings_graphicsGUI)
	emGUI:dxGridListAddColumn(hudStyleGrid, "HUD Style Type", 1)
	for i = 1, 2 do
		emGUI:dxGridListAddRow(hudStyleGrid)
	end
	emGUI:dxGridListSetItemText(hudStyleGrid, 1, 1, "Black on White")
	emGUI:dxGridListSetItemText(hudStyleGrid, 2, 1, "White on Black")
	
	graphicSettings = {
		[1] = {
			[1] = emGUI:dxCreateButton(0.08, 0.11, 0.07, 0.05, "OFF", true, settings_graphicsGUI, _, _, _, _, _, _, _, tocolor(50, 200, 0, 180), tocolor(50, 200, 0, 180)),
			[2] = emGUI:dxCreateButton(0.15, 0.11, 0.07, 0.05, "ON", true, settings_graphicsGUI, _, _, _, _, _, _, _, tocolor(50, 200, 0, 180), tocolor(50, 200, 0, 180)),
		},
		[2] = {
			[1] = emGUI:dxCreateButton(0.08, 0.23, 0.07, 0.05, "OFF", true, settings_graphicsGUI, _, _, _, _, _, _, _, tocolor(50, 200, 0, 180), tocolor(50, 200, 0, 180)),
			[2] = emGUI:dxCreateButton(0.15, 0.23, 0.07, 0.05, "ON", true, settings_graphicsGUI, _, _, _, _, _, _, _, tocolor(50, 200, 0, 180), tocolor(50, 200, 0, 180)),
		},
		[3] = {
			[1] = emGUI:dxCreateButton(0.08, 0.35, 0.07, 0.05, "OFF", true, settings_graphicsGUI, _, _, _, _, _, _, _, tocolor(50, 200, 0, 180), tocolor(50, 200, 0, 180)),
			[2] = emGUI:dxCreateButton(0.15, 0.35, 0.07, 0.05, "ON", true, settings_graphicsGUI, _, _, _, _, _, _, _, tocolor(50, 200, 0, 180), tocolor(50, 200, 0, 180)),
		},
		[4] = {
			[1] = emGUI:dxCreateButton(0.08, 0.47, 0.07, 0.05, "OFF", true, settings_graphicsGUI, _, _, _, _, _, _, _, tocolor(50, 200, 0, 180), tocolor(50, 200, 0, 180)),
			[2] = emGUI:dxCreateButton(0.15, 0.47, 0.07, 0.05, "ON", true, settings_graphicsGUI, _, _, _, _, _, _, _, tocolor(50, 200, 0, 180), tocolor(50, 200, 0, 180)),
		},
		[5] = {
			[1] = emGUI:dxCreateButton(0.08, 0.59, 0.07, 0.05, "OFF", true, settings_graphicsGUI, _, _, _, _, _, _, _, tocolor(50, 200, 0, 180), tocolor(50, 200, 0, 180)),
			[2] = emGUI:dxCreateButton(0.15, 0.59, 0.07, 0.05, "ON", true, settings_graphicsGUI, _, _, _, _, _, _, _, tocolor(50, 200, 0, 180), tocolor(50, 200, 0, 180)),
		},
		[6] = {
			[1] = emGUI:dxCreateButton(0.08, 0.71, 0.07, 0.05, "OFF", true, settings_graphicsGUI, _, _, _, _, _, _, _, tocolor(50, 200, 0, 180), tocolor(50, 200, 0, 180)),
			[2] = emGUI:dxCreateButton(0.15, 0.71, 0.07, 0.05, "ON", true, settings_graphicsGUI, _, _, _, _, _, _, _, tocolor(50, 200, 0, 180), tocolor(50, 200, 0, 180)),
		},
	}

	-- Load settings.
	if (settingValues[1] == 1) then emGUI:dxSetAlpha(graphicSettings[1][1], 0.3) else emGUI:dxSetAlpha(graphicSettings[1][2], 0.3) end
	if (settingValues[2] == 1) then emGUI:dxSetAlpha(graphicSettings[2][1], 0.3) else emGUI:dxSetAlpha(graphicSettings[2][2], 0.3) end
	if (settingValues[3] == 1) then emGUI:dxSetAlpha(graphicSettings[3][1], 0.3) else emGUI:dxSetAlpha(graphicSettings[3][2], 0.3) end
	if (settingValues[4] == 1) then emGUI:dxSetAlpha(graphicSettings[4][1], 0.3) else emGUI:dxSetAlpha(graphicSettings[4][2], 0.3) end
	if (settingValues[5] == 1) then emGUI:dxSetAlpha(graphicSettings[5][1], 0.3) else emGUI:dxSetAlpha(graphicSettings[5][2], 0.3) end
	if (settingValues[6] == 1) then emGUI:dxSetAlpha(graphicSettings[6][1], 0.3) else emGUI:dxSetAlpha(graphicSettings[6][2], 0.3) end
	if settingValues[7] then emGUI:dxGridListSetSelectedItem(hudStyleGrid, tonumber(settingValues[7]), 1) end
	--

	for k, i in ipairs(graphicSettings) do
		addEventHandler("onClientDgsDxMouseClick", graphicSettings[k][1], graphic_settingToggle)
		addEventHandler("onClientDgsDxMouseClick", graphicSettings[k][2], graphic_settingToggle)
	end

	------- Setting 7 (HUD Style) -------
	addEventHandler("ondxGridListSelect", hudStyleGrid, function(new, old)
		if (new == 1) then
			emGUI:dxImageSetImage(hudStylePreview, ":hud-system/images/hud/black_on_white/hudicon.png")
		elseif (new == 2) then
			emGUI:dxImageSetImage(hudStylePreview, ":hud-system/images/hud/white_on_black/hudicon.png")
		end
	end)

	triggerEvent("ondxGridListSelect", hudStyleGrid, tonumber(settingValues[7]), 1) -- Update the image as soon as GUI opens to the one player has selected.
	-------------------------------------

	graphic_cancelButton = emGUI:dxCreateButton(0.27, 0.84, 0.22, 0.13, "CANCEL", true, settings_graphicsGUI)
	addEventHandler("onClientDgsDxMouseClick", graphic_cancelButton, settings_cancelChangeClick)

	graphic_applyButton = emGUI:dxCreateButton(0.51, 0.84, 0.22, 0.13, "APPLY", true, settings_graphicsGUI)
	addEventHandler("onClientDgsDxMouseClick", graphic_applyButton, settings_applyChangeClick)
end

function graphic_settingToggle(button, state)
	if (button == "left") and (state == "down") then
		local optionID, stateID

		for j, setting in ipairs(graphicSettings) do
			for k, state in ipairs(setting) do
				if source == state then
					optionID = j;
					stateID = k;
				end
			end
		end

		if not tonumber(optionID) or not tonumber(stateID) then
			outputDebugString("[account-system] graphic_settingToggle: Failed to fetch button source to update toggle.", 3)
			return false
		end
		
		local offState = emGUI:dxGetEnabled(graphicSettings[optionID][stateID])

		if (offState) then
			if (stateID == 1) then
				emGUI:dxSetAlpha(graphicSettings[optionID][1], 1)
				emGUI:dxSetAlpha(graphicSettings[optionID][2], 0.3)
			else
				emGUI:dxSetAlpha(graphicSettings[optionID][1], 0.3)
				emGUI:dxSetAlpha(graphicSettings[optionID][2], 1)
			end
		end
	end
end

---------------------------------------------------------------------------------------------------------------------------------------
--															BUTTON CLICK FUNCTIONS	 												 --
---------------------------------------------------------------------------------------------------------------------------------------

function settings_cancelChangeClick(button, state)
	if (button == "left") and (state == "down") then
		local parentUI = emGUI:dxGetParent(source)
		emGUI:dxCloseWindow(parentUI)
	end
end


function settings_applyChangeClick(button, state)
	if (button == "left") and (state == "down") then
		local parentUI = emGUI:dxGetParent(source)
		
		local dataTable = {}
		if (parentUI) == settings_generalGUI then
			-- Get our data from GUI states.
			local setting1 = emGUI:dxGetAlpha(generalSettings[1][2]) or 1
			local setting2 = emGUI:dxGetAlpha(generalSettings[2][2]) or 1
			local setting3 = emGUI:dxGetAlpha(generalSettings[3][2]) or 1

			-- Save our data.
			if (setting1 == 1) then table.insert(dataTable, 1) else table.insert(dataTable, 0) end
			if (setting2 == 1) then table.insert(dataTable, 1) else table.insert(dataTable, 0) end
			if (setting3 == 1) then table.insert(dataTable, 1) else table.insert(dataTable, 0) end

			-- Send it off.
			saveSettings(1, dataTable)
		elseif (parentUI) == settings_accountGUI then
			local setting1 = emGUI:dxGetAlpha(accountSettings[1][2]) or 1
			local setting2 = emGUI:dxGetAlpha(accountSettings[2][2]) or 1
			local setting3 = emGUI:dxGetAlpha(accountSettings[3][2]) or 1
			local setting4 = emGUI:dxGetAlpha(accountSettings[4][2]) or 1

			if (setting1 == 1) then table.insert(dataTable, 1) else table.insert(dataTable, 0) end
			if (setting2 == 1) then table.insert(dataTable, 1) else table.insert(dataTable, 0) end
			if (setting3 == 1) then table.insert(dataTable, 1) else table.insert(dataTable, 0) end
			if (setting4 == 1) then table.insert(dataTable, 1) else table.insert(dataTable, 0) end

			saveSettings(2, dataTable)
		elseif (parentUI) == settings_notificationGUI then
			local setting1 = emGUI:dxGetAlpha(notificationSettings[1][2]) or 1
			local setting2 = emGUI:dxGetAlpha(notificationSettings[2][2]) or 1
			local setting3 = emGUI:dxGetAlpha(notificationSettings[3][2]) or 1
			local setting4 = emGUI:dxGridListGetSelectedItem(socialNotifTypeGrid) or 1
			local setting5 = emGUI:dxGetAlpha(notificationSettings[4][2]) or 1

			if (setting1 == 1) then table.insert(dataTable, 1) else table.insert(dataTable, 0) end
			if (setting2 == 1) then table.insert(dataTable, 1) else table.insert(dataTable, 0) end
			if (setting3 == 1) then table.insert(dataTable, 1) else table.insert(dataTable, 0) end
			if (setting4) then table.insert(dataTable, setting4) end
			if (setting5 == 1) then table.insert(dataTable, 1) else table.insert(dataTable, 0) end

			saveSettings(3, dataTable)
		elseif (parentUI) == settings_graphicsGUI then
			local setting1 = emGUI:dxGetAlpha(graphicSettings[1][2]) or 1
			local setting2 = emGUI:dxGetAlpha(graphicSettings[2][2]) or 1
			local setting3 = emGUI:dxGetAlpha(graphicSettings[3][2]) or 1
			local setting4 = emGUI:dxGetAlpha(graphicSettings[4][2]) or 1
			local setting5 = emGUI:dxGetAlpha(graphicSettings[5][2]) or 1
			local setting6 = emGUI:dxGetAlpha(graphicSettings[6][2]) or 1
			local setting7 = emGUI:dxGridListGetSelectedItem(hudStyleGrid) or 1

			if (setting1 == 1) then table.insert(dataTable, 1) else table.insert(dataTable, 0) end
			if (setting2 == 1) then table.insert(dataTable, 1) else table.insert(dataTable, 0) end
			if (setting3 == 1) then table.insert(dataTable, 1) else table.insert(dataTable, 0) end
			if (setting4 == 1) then table.insert(dataTable, 1) else table.insert(dataTable, 0) end
			if (setting5 == 1) then table.insert(dataTable, 1) else table.insert(dataTable, 0) end
			if (setting6 == 1) then table.insert(dataTable, 1) else table.insert(dataTable, 0) end
			if (setting7) then table.insert(dataTable, setting7) end

			saveSettings(4, dataTable)
		else -- Impossible else but hey, what can you do?
			outputDebugString("[account-system] @settings_applyChangeClick: ERROR: Attempt to save settings of parent UI that doesn't exist.", 3)
			outputChatBox("ERROR: Something went wrong whilst attempting to save your changes!", 255, 0, 0)
		end

		emGUI:dxCloseWindow(parentUI)
	end
end


---------------------------------------------------------------------------------------------------------------------------------------
--																 FUNCTIONS			 												 --
---------------------------------------------------------------------------------------------------------------------------------------

--[[		[Group IDs]
	0 = None, used to create default settings and file.
	1 = General Settings
	2 = Account Settings
	3 = Notification Settings
	4 = Graphic settings 		]]
function loadSettings(group)
	if not tonumber(group) or not (tonumber(group) >= 0) or not (tonumber(group) < 5) then
		outputDebugString("[account-system] @loadSettings: No settings group received to load or group ID is invalid.", 3)
		return false
	end

	local group = tonumber(group)
	local settingsFile = xmlLoadFile("settings.xml")
	if not (settingsFile) then
		settingsFile = xmlCreateFile("settings.xml", "settings")
		local settingsGeneral = xmlCreateChild(settingsFile, "general")
			local settingsGeneral_1_Node = xmlCreateChild(settingsGeneral, "General_1")
				xmlNodeSetValue(settingsGeneral_1_Node, "1")
			local settingsGeneral_2_Node = xmlCreateChild(settingsGeneral, "General_2")
				xmlNodeSetValue(settingsGeneral_2_Node, "1")
			local settingsGeneral_3_Node = xmlCreateChild(settingsGeneral, "General_3")
				xmlNodeSetValue(settingsGeneral_3_Node, "1")

		---------------------- [XML File Structure Tree] ----------------------

		local settingsAccount = xmlCreateChild(settingsFile, "account")
			local settingsAccount_1_Node = xmlCreateChild(settingsAccount, "Account_1")
				xmlNodeSetValue(settingsAccount_1_Node, "1")
			local settingsAccount_2_Node = xmlCreateChild(settingsAccount, "Account_2")
				xmlNodeSetValue(settingsAccount_2_Node, "1")
			local settingsAccount_3_Node = xmlCreateChild(settingsAccount, "Account_3")
				xmlNodeSetValue(settingsAccount_3_Node, "1")
			local settingsAccount_4_Node = xmlCreateChild(settingsAccount, "Account_4")
				xmlNodeSetValue(settingsAccount_4_Node, "1")

		local settingsNotifications = xmlCreateChild(settingsFile, "notifications")
			local settingsNotifications_1_Node = xmlCreateChild(settingsNotifications, "Notifications_1")
				xmlNodeSetValue(settingsNotifications_1_Node, "1")
			local settingsNotifications_2_Node = xmlCreateChild(settingsNotifications, "Notifications_2")
				xmlNodeSetValue(settingsNotifications_2_Node, "1")
			local settingsNotifications_3_Node = xmlCreateChild(settingsNotifications, "Notifications_3")
				xmlNodeSetValue(settingsNotifications_3_Node, "1")
			local settingsNotifications_4_Node = xmlCreateChild(settingsNotifications, "Notifications_4")
				xmlNodeSetValue(settingsNotifications_4_Node, "1")
			local settingsNotifications_5_Node = xmlCreateChild(settingsNotifications, "Notifications_5")
				xmlNodeSetValue(settingsNotifications_5_Node, "1")

		local settingsGraphics = xmlCreateChild(settingsFile, "graphics")
			local settingsGraphics_1_Node = xmlCreateChild(settingsGraphics, "Graphics_1")
				xmlNodeSetValue(settingsGraphics_1_Node, "1")
			local settingsGraphics_2_Node = xmlCreateChild(settingsGraphics, "Graphics_2")
				xmlNodeSetValue(settingsGraphics_2_Node, "1")
			local settingsGraphics_3_Node = xmlCreateChild(settingsGraphics, "Graphics_3")
				xmlNodeSetValue(settingsGraphics_3_Node, "0")
			local settingsGraphics_4_Node = xmlCreateChild(settingsGraphics, "Graphics_4")
				xmlNodeSetValue(settingsGraphics_4_Node, "1")
			local settingsGraphics_5_Node = xmlCreateChild(settingsGraphics, "Graphics_5")
				xmlNodeSetValue(settingsGraphics_5_Node, "1")
			local settingsGraphics_6_Node = xmlCreateChild(settingsGraphics, "Graphics_6")
				xmlNodeSetValue(settingsGraphics_6_Node, "1")
			local settingsGraphics_7_Node = xmlCreateChild(settingsGraphics, "Graphics_7")
				xmlNodeSetValue(settingsGraphics_7_Node, "1")

		xmlSaveFile(settingsFile)
	end

	if (group == 0) then
		xmlUnloadFile(settingsFile)
		return true
	end
		
	-------------------- Get XML nodes and data. --------------------
	local settingsGeneral = xmlFindChild(settingsFile, "general", 0)
	local settingsGeneralData = xmlNodeGetChildren(settingsGeneral)

	local settingsAccount = xmlFindChild(settingsFile, "account", 0)
	local settingsAccountData = xmlNodeGetChildren(settingsAccount)

	local settingsNotifications = xmlFindChild(settingsFile, "notifications", 0)
	local settingsNotificationsData = xmlNodeGetChildren(settingsNotifications)

	local settingsGraphics = xmlFindChild(settingsFile, "graphics", 0)
	local settingsGraphicsData = xmlNodeGetChildren(settingsGraphics)


	-------------------- Load data from Nodes Table --------------------
	
	local settingsToReturn = {}
	local val = 1
	if (group == 1) then
		for i, settingValue in ipairs(settingsGeneralData) do
			val = xmlNodeGetValue(settingValue)
			local val = tonumber(val)
			
			if (val == 0) or (val == 1) then
				table.insert(settingsToReturn, val)
			else
				table.insert(settingsToReturn, 1)
			end
		end
	elseif (group == 2) then
		for i, settingValue in ipairs(settingsAccountData) do
			val = xmlNodeGetValue(settingValue)
			local val = tonumber(val)
			
			if (val == 0) or (val == 1) then
				table.insert(settingsToReturn, val)
			else
				table.insert(settingsToReturn, 1)
			end
		end
	elseif (group == 3) then
		for i, settingValue in ipairs(settingsNotificationsData) do
			val = xmlNodeGetValue(settingValue)
			local val = tonumber(val)
			
			if (i == 4) then
				if (val >= 1) and (val <= 3) then
					table.insert(settingsToReturn, val)
				else
					table.insert(settingsToReturn, 1)
				end
			else
				if (val == 0) or (val == 1) then
					table.insert(settingsToReturn, val)
				else
					table.insert(settingsToReturn, 1)
				end
			end
		end
	elseif (group == 4) then
		for i, settingValue in ipairs(settingsGraphicsData) do
			val = xmlNodeGetValue(settingValue)
			local val = tonumber(val)
			
			if (i == 7) then
				if (val == 1) or (val == 2) then
					table.insert(settingsToReturn, val)
				else
					table.insert(settingsToReturn, 1)
				end
			else
				if (val == 0) or (val == 1) then
					table.insert(settingsToReturn, val)
				else
					table.insert(settingsToReturn, 1)
				end
			end
		end
	end

	xmlUnloadFile(settingsFile)

	if (settingsToReturn) then
		return settingsToReturn
	else
		outputDebugString("[account-system] @loadSettings: Invalid or no node values for settingsToReturn.", 3)
		fileDelete("settings.xml") -- Delete the settings because we don't want to keep the broken one.
		return false
	end
end

function saveSettings(group, dataTable)
	if not tonumber(group) or not (tonumber(group) > 0) or not (tonumber(group) < 5) then
		outputDebugString("[account-system] @saveSettings: No settings group received to load or group ID is invalid.", 3)
		return false
	end

	if not (dataTable) or not (type(dataTable) == "table") then
		outputDebugString("[account-system] @saveSettings: dataTable not received or is invalid.", 3)
		return false
	end
	
	local settingsFile = xmlLoadFile("settings.xml")
	if not (settingsFile) then
		outputDebugString("[account-system] saveSettings: Attempted to save settings though settingsFile doesn't exist.", 3)
		return false
	end

	local group = tonumber(group)
	if (group == 1) then
		local settingsGeneral = xmlFindChild(settingsFile, "general", 0)
		local settingsGeneralData = xmlNodeGetChildren(settingsGeneral)

		for i, k in ipairs(dataTable) do
			xmlNodeSetValue(settingsGeneralData[i], k)
		end
	elseif (group == 2) then
		local settingsAccount = xmlFindChild(settingsFile, "account", 0)
		local settingsAccountData = xmlNodeGetChildren(settingsAccount)

		for i, k in ipairs(dataTable) do
			xmlNodeSetValue(settingsAccountData[i], k)
		end
	elseif (group == 3) then
		local settingsNotifications = xmlFindChild(settingsFile, "notifications", 0)
		local settingsNotificationsData = xmlNodeGetChildren(settingsNotifications)

		for i, k in ipairs(dataTable) do
			xmlNodeSetValue(settingsNotificationsData[i], k)
		end
	elseif (group == 4) then
		local settingsGraphics = xmlFindChild(settingsFile, "graphics", 0)
		local settingsGraphicsData = xmlNodeGetChildren(settingsGraphics)

		for i, k in ipairs(dataTable) do
			xmlNodeSetValue(settingsGraphicsData[i], k)
		end
	end

	triggerServerEvent("account:updateSettingsData", localPlayer, localPlayer, group, dataTable)
	xmlSaveFile(settingsFile)
	xmlUnloadFile(settingsFile)
	return true
end

function client_loadAccountSettings()
	local settingsFile = xmlLoadFile("settings.xml")
	if not (settingsFile) then
		loadSettings(0)
		local settingsFile = xmlLoadFile("settings.xml")
		if not (settingsFile) then
			return false
		end
	end

	local settingsGeneral = xmlFindChild(settingsFile, "general", 0)
	local settingsGeneralDataNodes = xmlNodeGetChildren(settingsGeneral)
	local settingsGeneralData = {}

	for i, k in ipairs(settingsGeneralDataNodes) do
		table.insert(settingsGeneralData, xmlNodeGetValue(settingsGeneralDataNodes[i]))
	end

	local settingsAccount = xmlFindChild(settingsFile, "account", 0)
	local settingsAccountDataNodes = xmlNodeGetChildren(settingsAccount)
	local settingsAccountData = {}
	
	for i, k in ipairs(settingsAccountDataNodes) do
		table.insert(settingsAccountData, xmlNodeGetValue(settingsAccountDataNodes[i]))
	end

	local settingsNotifications = xmlFindChild(settingsFile, "notifications", 0)
	local settingsNotificationsDataNodes = xmlNodeGetChildren(settingsNotifications)
	local settingsNotificationsData = {}
	
	for i, k in ipairs(settingsNotificationsDataNodes) do
		table.insert(settingsNotificationsData, xmlNodeGetValue(settingsNotificationsDataNodes[i]))
	end

	local settingsGraphics = xmlFindChild(settingsFile, "graphics", 0)
	local settingsGraphicsDataNodes = xmlNodeGetChildren(settingsGraphics)
	local settingsGraphicsData = {}
	
	for i, k in ipairs(settingsGraphicsDataNodes) do
		table.insert(settingsGraphicsData, xmlNodeGetValue(settingsGraphicsDataNodes[i]))
	end

	local settingsTable = {
		settingsGeneralData,
		settingsAccountData,
		settingsNotificationsData,
		settingsGraphicsData,
	}

	triggerServerEvent("account:loadAccountSettings", localPlayer, localPlayer, settingsTable)
	xmlUnloadFile(settingsFile)
end
addEvent("account:c_loadAccountSettings", true)
addEventHandler("account:c_loadAccountSettings", getRootElement(), client_loadAccountSettings)


--[[ SETTINGS GUI WINDOW TO ADD NEW ELEMENTS IN GUIEDITOR.
addEventHandler("onClientResourceStart", resourceRoot,
	function()
		settingsGUI = guiCreateWindow(0.31, 0.24, 0.39, 0.53, "", true)
		guiWindowSetSizable(settingsGUI, false)    
	end
)
]]

-- Set all element data.
addEventHandler("onClientResourceStart", resourceRoot, function()
	for i = 1, 4 do
		local settingsTable = loadSettings(i)
		saveSettings(i, settingsTable)
	end
end)

