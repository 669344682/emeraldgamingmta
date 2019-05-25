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

addEvent("onCharacterSelected", true)
addEvent("onPlayerCharacterSelection", true)

emGUI = exports.emGUI

buttonFont_14 = emGUI:dxCreateNewFont(":emGUI/fonts/buttonFont.ttf", 14)
buttonFont_18 = emGUI:dxCreateNewFont(":emGUI/fonts/buttonFont.ttf", 18)
buttonFont_30 = emGUI:dxCreateNewFont(":emGUI/fonts/buttonFont.ttf", 30)
buttonFont_34 = emGUI:dxCreateNewFont(":emGUI/fonts/buttonFont.ttf", 34)
tabFont_10 = emGUI:dxCreateNewFont(":emGUI/fonts/tabsFont.ttf", 10)
tabFont_13 = emGUI:dxCreateNewFont(":emGUI/fonts/tabsFont.ttf", 13)
mainFont_9 = emGUI:dxCreateNewFont(":emGUI/fonts/mainFont.ttf", 9)

local dummyCharSpawnLocations = {
	[1] = {1624.35742, 590.45020, 1.75781, 180},
	[2] = {1626.35742, 590.45020, 1.75781, 180},
	[3] = {1628.35742, 590.45020, 1.75781, 180},
	[4] = {1630.35742, 590.45020, 1.75781, 180},
	[5] = {1632.35742, 590.45020, 1.75781, 180},
	[6] = {1623.53906, 597.57715, 2.32966, 180},
	[7] = {1625.34961, 598.76172, 3.08356, 180},
	[8] = {1623.62695, 601.10840, 4.57068, 180},
	[9] = {1632.97461, 597.50000, 2.29501, 180},
	[10] = {1631.01172, 598.78809, 3.11383, 180},
	[11] = {1632.88281, 600.83887, 4.43146, 180},
	[12] = {1631.05469, 601.45312, 4.79961, 180},
	[13] = {1625.20020, 601.40723, 4.76031, 180},
	[14] = {1627.22051, 602.00586, 5.48628, 180},
	[15] = {1629.42012, 602.00586, 5.48628, 180},
}

local dummyPeds = {}
local characterSelectorGUI = {}
local characterSelectorGUIPos = {
	[1] = {0.274, 0.695, 0.037, 0.185},
	[2] = {0.378, 0.696, 0.039, 0.186},
	[3] = {0.482, 0.695, 0.041, 0.19},
	[4] = {0.587, 0.70, 0.04, 0.187},
	[5] = {0.693, 0.696, 0.04, 0.189},
	[6] = {0.328, 0.643, 0.028, 0.125},
	[7] = {0.396, 0.60, 0.026, 0.096},
	[8] = {0.358, 0.52, 0.027, 0.11},
	[9] = {0.65, 0.644, 0.032, 0.124},
	[10] = {0.58, 0.59, 0.028, 0.111},
	[11] = {0.628, 0.528, 0.03, 0.108},
	[12] = {0.573, 0.513, 0.025, 0.077},
	[13] = {0.404, 0.52, 0.023, 0.081},
	[14] = {0.465, 0.48, 0.025, 0.1},
	[15] = {0.525, 0.482, 0.025, 0.1},
}

function character_logoutPlayer(passMode)
	if not (passMode) then passMode = false end

	triggerServerEvent("character:logoutPlayerServer", getLocalPlayer(), localPlayer, passMode)
	fadeCamera(false, 3)
	triggerEvent("hud:updateHudData", localPlayer, "hud:enabledstatus", 3)
	setElementData(localPlayer, "loggedin", 0, true)

	logoutGUI = emGUI:dxCreateWindow(0.34, 0.30, 0.33, 0.41, "", true, true, _, true, _, _, _, tocolor(0, 0, 0, 150), _, tocolor(0, 0, 0, 150))

	emeraldLogoLarge = emGUI:dxCreateImage(0.1, 0.07, 0.75, 0.35, ":assets/images/logoLarge.png", true, logoutGUI)
	loggingOutLabel = emGUI:dxCreateLabel(0.13, 0.64, 0.74, 0.30, "Logging you out", true, logoutGUI)
	dotsLabel = emGUI:dxCreateLabel(0.844, 0.642, 0.74, 0.30, "", true, logoutGUI)
	emGUI:dxSetAlpha(logoutGUI, 0)
	emGUI:dxAlphaTo(logoutGUI, 1, false, "OutQuad", 3000)

	emGUI:dxSetFont(loggingOutLabel, buttonFont_30)
	emGUI:dxSetFont(dotsLabel, buttonFont_30)
	emGUI:dxLabelSetHorizontalAlign(loggingOutLabel, "center")

	
	local dotslabelText = ""
	setTimer(function()
		dotslabelText = dotslabelText .. "."
		emGUI:dxSetText(dotsLabel, dotslabelText)
	end, 1000, 3)
end
addEvent("character:logoutPlayer", true)
addEventHandler("character:logoutPlayer", getRootElement(), character_logoutPlayer)

function character_returnToCharSelection()
	-- Need to stop reconning first due to position saving.
	local reconStatus = getElementData(localPlayer, "var:recon")
	if (reconStatus== 1) then triggerServerEvent("admin:stopReconning", root, localPlayer) end

	triggerServerEvent("global:savePlayer", localPlayer, localPlayer, 1)
	triggerServerEvent("report:removeReportQuit", localPlayer, localPlayer) -- Triggers an event in g_reports.lua that removes the player's report if they quit or unassigns the handler.
	triggerEvent("hud:updateHudData", localPlayer, "hud:enabledstatus", 2)
	
	local reconer = getElementData(localPlayer, "var:beingreconned")
	if (reconer) then triggerServerEvent("admin:stopReconning", root, reconer) end
	
	setElementAlpha(localPlayer, 200)
	showChat(false)
	fadeCamera(false, 3)

	charSelGUI = emGUI:dxCreateWindow(0.34, 0.30, 0.33, 0.41, "", true, true, _, true, _, _, _, tocolor(0, 0, 0, 150), _, tocolor(0, 0, 0, 150))

	emeraldLogoLarge = emGUI:dxCreateImage(0.1, 0.07, 0.75, 0.35, ":assets/images/logoLarge.png", true, charSelGUI)
	loggingOutLabel = emGUI:dxCreateLabel(0.13, 0.59, 0.74, 0.30, "Returning to\ncharacter selection", true, charSelGUI)
	dotsLabel = emGUI:dxCreateLabel(0.922, 0.715, 0.74, 0.30, "", true, charSelGUI)
	emGUI:dxSetAlpha(charSelGUI, 0)
	emGUI:dxAlphaTo(charSelGUI, 1, false, "OutQuad", 3000)

	emGUI:dxSetFont(loggingOutLabel, buttonFont_30)
	emGUI:dxSetFont(dotsLabel, buttonFont_30)
	emGUI:dxLabelSetHorizontalAlign(loggingOutLabel, "center")

	
	local dotslabelText = ""
	setTimer(function()
		dotslabelText = dotslabelText .. "."
		emGUI:dxSetText(dotsLabel, dotslabelText)
	end, 1000, 3)

	setTimer(function()
		emGUI:dxCloseWindow(charSelGUI)
		local randomDim = 50000 + getElementData(localPlayer, "player:id")
		setElementDimension(localPlayer, randomDim)
		triggerServerEvent("setLoginTempNames", localPlayer)
		triggerServerEvent("character:showCharacterSelection", getLocalPlayer(), localPlayer, true)
	end, 3500, 1)
end
addEvent("character:returnToCharSelection", true)
addEventHandler("character:returnToCharSelection", getRootElement(), character_returnToCharSelection)

------------------------------------ Character Selection ------------------------------------

function showCharacterSelection(characterTable, skipCam)
	local cameraTimer = 5050
	if not skipCam then
		exports.global:smoothMoveCamera(1875.212890625, 475.1435546875, 91.699554443359, 1960.2685546875, 665.509765625, 89.779525756836, 1628.6279296875, 576.66796875, 3.321236371994, 1627.98046875, 608.5986328125, 6.7526760101318, 5000)
	else
		cameraTimer = 100
		fadeCamera(true, 3)
		setCameraMatrix(1628.6279296875, 576.66796875, 3.321236371994, 1627.98046875, 608.5986328125, 6.7526760101318)
	end
	
	-- Preload code while smoothMoveCamera animation is executing.
	setElementAlpha(localPlayer, 0) -- Set alpha to zero so they aren't visible within the selection screen.
	setElementData(localPlayer, "loggedin", 2, true) -- Set to character selection.
	triggerEvent("hud:updateHudData", localPlayer, "hud:enabledstatus", 2)
	setElementPosition(localPlayer, 1628.3279296875, 595.66796875, 3.521236371994) -- Place in center of selection screen.

	if (characterTable) then
		for i, character in ipairs(characterTable) do
			dummyPeds[i] = createPed(characterTable[i].skin, dummyCharSpawnLocations[i][1], dummyCharSpawnLocations[i][2], dummyCharSpawnLocations[i][3], dummyCharSpawnLocations[i][4])
			local playerDim = getElementDimension(localPlayer)
			setElementDimension(dummyPeds[i], playerDim)
			setElementInterior(localPlayer, 0)
			if (characterTable[i].active == 0) then
				setElementAlpha(dummyPeds[i], 100)
				setElementData(dummyPeds[i], "temp:ped:active", 0)
			end
			setElementData(dummyPeds[i], "name", characterTable[i].name)
			setElementData(dummyPeds[i], "temp:ped:pedid", i)
			setElementData(dummyPeds[i], "temp:ped:charid", characterTable[i].id)
			setElementData(dummyPeds[i], "temp:ped:dob", characterTable[i].dob)
			setElementData(dummyPeds[i], "temp:ped:height", characterTable[i].height)
			setElementData(dummyPeds[i], "temp:ped:weight", characterTable[i].weight)
			setElementData(dummyPeds[i], "temp:ped:gender", characterTable[i].gender)
			setElementData(dummyPeds[i], "temp:ped:language", characterTable[i].language)
			setElementData(dummyPeds[i], "temp:ped:language2", characterTable[i].language2)
			setElementData(dummyPeds[i], "temp:ped:language3", characterTable[i].language3)
			setElementData(dummyPeds[i], "temp:ped:ethnicity", characterTable[i].ethnicity)
			setElementData(dummyPeds[i], "temp:ped:skills", characterTable[i].skills)
			setElementData(dummyPeds[i], "temp:ped:origin", characterTable[i].origin)
			setElementData(dummyPeds[i], "temp:ped:status", characterTable[i].status)
			setElementData(dummyPeds[i], "temp:ped:hours", characterTable[i].hours)
			setElementData(dummyPeds[i], "temp:ped:lastused", characterTable[i].last_used)
			setElementData(dummyPeds[i], "temp:ped:created", characterTable[i].created)
			setElementData(dummyPeds[i], "temp:ped:locationarea", characterTable[i].location_area)
			setElementData(dummyPeds[i], "temp:ped:walkstyle", characterTable[i].walkstyle)
			setElementData(dummyPeds[i], "temp:ped:maxinteriors", characterTable[i].maxinteriors)
			setElementData(dummyPeds[i], "temp:ped:maxvehicles", characterTable[i].maxvehicles)
			setElementData(dummyPeds[i], "temp:ped:money", characterTable[i].money)
			setElementData(dummyPeds[i], "temp:ped:bankmoney", characterTable[i].bankmoney)
			setElementData(dummyPeds[i], "temp:ped:job", characterTable[i].job)
			setElementData(dummyPeds[i], "temp:ped:dimension", characterTable[i].dimension)
			setElementData(dummyPeds[i], "temp:ped:interior", characterTable[i].interior)
			setElementData(dummyPeds[i], "temp:ped:fightstyle", characterTable[i].fightstyle)
			setElementData(dummyPeds[i], "temp:ped:skin", characterTable[i].skin)
			setElementData(dummyPeds[i], "temp:ped:origin", characterTable[i].origin)
			setElementData(dummyPeds[i], "temp:ped:licenses", characterTable[i].licenses)

			setPedWalkingStyle(dummyPeds[i], characterTable[i].walkstyle)
		end
	else
		outputDebugString("[character-system] showCharacterSelection: No characterTable received from server.")
	end

	-- Execute after smoothMoveCamera has completed.
	setTimer(function()
		showCursor(true)

		local labels = {}

		-------------------------- [Top Bar] --------------------------
		topBarBackground = emGUI:dxCreateWindow(0, 0, 1, 0.17, "", true, true, true, true)

		labels[1] = emGUI:dxCreateLabel(0.565, 0.179, 0.06, 0.11, "Want to start fresh?", true, topBarBackground)
		labels[2] = emGUI:dxCreateLabel(0.13, 0.35, 0.06, 0.11, "Your last login:", true, topBarBackground)
		labels[3] = emGUI:dxCreateLabel(0.13, 0.50, 0.06, 0.11, "Total hours played:", true, topBarBackground)
		labels[4] = emGUI:dxCreateLabel(0.13, 0.65, 0.06, 0.11, "Total Characters:", true, topBarBackground)

		labels[5] = emGUI:dxCreateLabel(0.35, 0.35, 0.05, 0.11, "Email Address:", true, topBarBackground)
		labels[6] = emGUI:dxCreateLabel(0.35, 0.50, 0.05, 0.11, "Registration Date:", true, topBarBackground)
		labels[7] = emGUI:dxCreateLabel(0.35, 0.65, 0.05, 0.11, "Emeralds:", true, topBarBackground)
		emGUI:dxLabelSetHorizontalAlign(labels[2], "right")
		emGUI:dxLabelSetHorizontalAlign(labels[3], "right")
		emGUI:dxLabelSetHorizontalAlign(labels[4], "right")
		emGUI:dxLabelSetHorizontalAlign(labels[5], "right")
		emGUI:dxLabelSetHorizontalAlign(labels[6], "right")
		emGUI:dxLabelSetHorizontalAlign(labels[7], "right")

		playerImage = emGUI:dxCreateImage(0.03, 0.07, 0.07, 0.77, ":assets/images/logoIcon.png", true, topBarBackground)

		local playerName = getElementData(localPlayer, "account:username")
		playerNameLabel = emGUI:dxCreateLabel(0.29, 0.02, 0.05, 0.11, "Welcome to Emerald Gaming, " .. playerName .. "!", true, topBarBackground)
		emGUI:dxSetFont(playerNameLabel, buttonFont_18)
		emGUI:dxLabelSetHorizontalAlign(playerNameLabel, "center")

		local lastLogin = getElementData(localPlayer, "temp:account:lastlogin")
		lastLogin = exports.global:convertTime(lastLogin) or "Unknown"
		lastLoginLabel = emGUI:dxCreateLabel(0.194, 0.35, 0.08, 0.11, lastLogin[2] .. " at " .. lastLogin[1], true, topBarBackground)
		
		local hoursPlayed = getElementData(localPlayer, "account:hours"); hoursPlayed = exports.global:formatNumber(hoursPlayed)
		totalHoursLabel = emGUI:dxCreateLabel(0.194, 0.50, 0.08, 0.11, hoursPlayed .. " Hours", true, topBarBackground)

		local pedCount = #dummyPeds or 0
		totalCharactersLabel = emGUI:dxCreateLabel(0.194, 0.65, 0.08, 0.11, pedCount .. " Characters", true, topBarBackground)

		local emailAddress = getElementData(localPlayer, "temp:account:email") or "Unknown"
		emailAddressLabel = emGUI:dxCreateLabel(0.403, 0.35, 0.08, 0.11, emailAddress, true, topBarBackground)

		local registerDate = getElementData(localPlayer, "temp:account:registerdate")
		registerDate = exports.global:convertTime(registerDate) or "Unknown"
		registrationDateLabel = emGUI:dxCreateLabel(0.403, 0.50, 0.08, 0.11, registerDate[2] .. " at " .. registerDate[1], true, topBarBackground)

		local emeralds = getElementData(localPlayer, "account:emeralds")
		emeraldsLabel = emGUI:dxCreateLabel(0.403, 0.65, 0.08, 0.11, exports.global:formatNumber(emeralds), true, topBarBackground)

		createCharButton = emGUI:dxCreateButton(0.55, 0.34, 0.10, 0.42, "Create Character", true, topBarBackground)
		addEventHandler("onClientDgsDxMouseClick", createCharButton, createCharacterButtonClick)

		-- If they have 15 characters, prevent further creation.
		if (#dummyPeds >= 15) then
			emGUI:dxSetEnabled(createCharButton, false)
			emGUI:dxSetText(labels[1], "      Limit Reached!")
		end

		accountHistoryButton =emGUI:dxCreateButton(0.66, 0.34, 0.10, 0.42, "Account History", true, topBarBackground)
		addEventHandler("onClientDgsDxMouseClick", accountHistoryButton, accountHistoryButtonClick)

		accountSettingsButton = emGUI:dxCreateButton(0.77, 0.34, 0.10, 0.42, "Account Settings", true, topBarBackground)
		addEventHandler("onClientDgsDxMouseClick", accountSettingsButton, accountSettingsButtonClick)

		logoutButton = emGUI:dxCreateButton(0.88, 0.34, 0.10, 0.42, "Logout", true, topBarBackground)
		addEventHandler("onClientDgsDxMouseClick", logoutButton, logoutButtonClick)

		--------------------- [Character Selectors] --------------------
		local totalChars = #dummyPeds

		-- Check to see if they have any characters first.
		if (totalChars < 1) then
			emGUI:dxSetEnabled(createCharButton, false)
			emGUI:dxSetEnabled(accountHistoryButton, false)
			emGUI:dxSetEnabled(accountSettingsButton, false)
			noCharactersGUI = emGUI:dxCreateWindow(0.22, 0.36, 0.55, 0.34, "", true, true, _, true)
			noCharactersGUILabel = emGUI:dxCreateLabel(0.18, 0.12, 0.54, 0.13, "YOU HAVE NO CHARACTERS!", true, noCharactersGUI)
			emGUI:dxSetFont(noCharactersGUILabel, buttonFont_34)
			noCharactersGUILabl2 = emGUI:dxCreateLabel(0.13, 0.32, 0.75, 0.24, "First things first, we need to get you set up with your own character! Characters are your unique playable civilians of Las Vanturas.\nYou choose their past, roleplay out their present and see what adventures hold for them in their future!\n\nOnce you create a character, they cannot be deleted and are permanent. You can only have up to 15 characters so be wise with\nyour available slots!", true, noCharactersGUI)
			emGUI:dxLabelSetHorizontalAlign(noCharactersGUILabl2, "center")
			createFirstCharButton = emGUI:dxCreateButton(0.35, 0.63, 0.30, 0.27, "CREATE FIRST CHARACTER", true, noCharactersGUI)
			addEventHandler("onClientDgsDxMouseClick", createFirstCharButton, createCharacterButtonClick)

			emGUI:dxSetVisible(labels[1], false)
			return
		end

		local i = 1
		while (i <= totalChars) do
			characterSelectorGUI[i] = emGUI:dxCreateWindow(characterSelectorGUIPos[i][1], characterSelectorGUIPos[i][2], characterSelectorGUIPos[i][3], characterSelectorGUIPos[i][4], "", true, true, _, true, _, _, _, tocolor(255, 0, 0, 0), _, tocolor(255, 0, 0, 0))
			i = i + 1
		end

		-------------------------- [Side Bar] --------------------------
		sideGUI_labels = {}
		selectedCharacterGUI = emGUI:dxCreateWindow(0.74, 0.24, 0.25, 0.52, "", true, true, _, true, _, 1.5, _, tocolor(0, 255, 0), _, _, _)

		sideGUI_charImage = emGUI:dxCreateImage(0.06, 0.04, 0.25, 0.21, ":assets/images/logoIcon.png", true, selectedCharacterGUI) -- To be replaced to show char face.
		sideGUI_charName = emGUI:dxCreateLabel(0.355, 0.04, 0.60, 0.11, "First Name\nLast Name", true, selectedCharacterGUI)
		emGUI:dxSetFont(sideGUI_charName, buttonFont_14)
		emGUI:dxLabelSetHorizontalAlign(sideGUI_charName, "center", false)
		emGUI:dxLabelSetVerticalAlign(sideGUI_charName, "center")

		sideGUI_labels[1] = emGUI:dxCreateLabel(0.38, 0.16, 0.19, 0.04, "LAST USED:", true, selectedCharacterGUI)
		sideGUI_labels[2] = emGUI:dxCreateLabel(0.34, 0.20, 0.23, 0.04, "TOTAL HOURS:", true, selectedCharacterGUI)
		sideGUI_labels[3] = emGUI:dxCreateLabel(0.34, 0.24, 0.23, 0.04, "STATUS:", true, selectedCharacterGUI)
		sideGUI_labels[4] = emGUI:dxCreateLabel(0.02, 0.33, 0.33, 0.04, "CURRENT LOCATION:", true, selectedCharacterGUI)
		sideGUI_labels[5] = emGUI:dxCreateLabel(0.02, 0.38, 0.33, 0.04, "PROPERTIES:", true, selectedCharacterGUI)
		sideGUI_labels[6] = emGUI:dxCreateLabel(0.02, 0.43, 0.33, 0.04, "VEHICLES:", true, selectedCharacterGUI)
		sideGUI_labels[7] = emGUI:dxCreateLabel(0.02, 0.48, 0.33, 0.04, "FACTIONS:", true, selectedCharacterGUI)
		sideGUI_labels[8] = emGUI:dxCreateLabel(0.02, 0.53, 0.33, 0.04, "CASH IN HAND:", true, selectedCharacterGUI)
		sideGUI_labels[9] = emGUI:dxCreateLabel(0.02, 0.58, 0.33, 0.04, "CASH IN BANK:", true, selectedCharacterGUI)
		sideGUI_labels[10] = emGUI:dxCreateLabel(0.02, 0.63, 0.33, 0.04, "CURRENT JOB:", true, selectedCharacterGUI)

		local ii = 1
		while (ii <= 10) do
			emGUI:dxSetFont(sideGUI_labels[ii], tabFont_10)
			emGUI:dxLabelSetHorizontalAlign(sideGUI_labels[ii], "right", false)
			ii = ii + 1
		end

		sideGUI_lastUsedLabel = emGUI:dxCreateLabel(0.579, 0.162, 0.37, 0.04, "01/01/2018 at 00:00", true, selectedCharacterGUI)
		sideGUI_totalHoursLabel = emGUI:dxCreateLabel(0.579, 0.202, 0.37, 0.04, "0 Hours", true, selectedCharacterGUI)
		sideGUI_charStatusLabel = emGUI:dxCreateLabel(0.579, 0.242, 0.37, 0.04, "Alive", true, selectedCharacterGUI)

		sideGUI_currentLocLabel = emGUI:dxCreateLabel(0.366, 0.332, 0.58, 0.04, "Unknown.", true, selectedCharacterGUI)
		sideGUI_PropertiesLabel = emGUI:dxCreateLabel(0.366, 0.382, 0.58, 0.04, "None.", true, selectedCharacterGUI)
		sideGUI_vehiclesLabel = emGUI:dxCreateLabel(0.366, 0.432, 0.58, 0.04, "None.", true, selectedCharacterGUI)
		sideGUI_factionsLabel = emGUI:dxCreateLabel(0.366, 0.482, 0.58, 0.04, "None.", true, selectedCharacterGUI)
		sideGUI_cashInHandLabel = emGUI:dxCreateLabel(0.366, 0.532, 0.58, 0.04, "$0", true, selectedCharacterGUI)
		sideGUI_cashInBankLabel = emGUI:dxCreateLabel(0.366, 0.582, 0.58, 0.04, "$0", true, selectedCharacterGUI)
		sideGUI_currentJobLabel = emGUI:dxCreateLabel(0.366, 0.632, 0.58, 0.04, "None.", true, selectedCharacterGUI)

		emGUI:dxSetFont(sideGUI_lastUsedLabel, mainFont_9)
		emGUI:dxSetFont(sideGUI_totalHoursLabel, mainFont_9)
		emGUI:dxSetFont(sideGUI_charStatusLabel, mainFont_9)
		emGUI:dxSetFont(sideGUI_currentLocLabel, mainFont_9)
		emGUI:dxSetFont(sideGUI_PropertiesLabel, mainFont_9)
		emGUI:dxSetFont(sideGUI_vehiclesLabel, mainFont_9)
		emGUI:dxSetFont(sideGUI_factionsLabel, mainFont_9)
		emGUI:dxSetFont(sideGUI_cashInHandLabel, mainFont_9)
		emGUI:dxSetFont(sideGUI_cashInBankLabel, mainFont_9)
		emGUI:dxSetFont(sideGUI_currentJobLabel, mainFont_9)

		sideGUI_selectCharButton = emGUI:dxCreateButton(0.06, 0.79, 0.53, 0.14, "SELECT CHARACTER", true, selectedCharacterGUI)
		addEventHandler("onClientDgsDxMouseClick", sideGUI_selectCharButton, characterSelected)
		sideGUI_charInfoButton = emGUI:dxCreateButton(0.64, 0.79, 0.29, 0.14, "INFO", true, selectedCharacterGUI)
		addEventHandler("onClientDgsDxMouseClick", sideGUI_charInfoButton, sideGUI_charInfoButtonClick)
		emGUI:dxSetVisible(selectedCharacterGUI, false) -- Hides the sidebar until a character is highlighted.

		addEventHandler("onClientClick", getRootElement(), onClientClickCharacterSelect)
	end, cameraTimer, 1)
end
addEvent("character:clientShowCharacterSelection", true)
addEventHandler("character:clientShowCharacterSelection", getRootElement(), showCharacterSelection)

-- Debug character creation.
function debugCharacterSel()
	if exports.global:isPlayerLeadDeveloper(localPlayer) or (getElementData(localPlayer, "staff:developer") == 3) then
		setElementInterior(localPlayer, 0)
		triggerServerEvent("character:showCharacterSelection", getLocalPlayer(), localPlayer, true)
	end
end
addCommandHandler("debugcharsel", debugCharacterSel)

function character_leavingCharSelection()
	if emGUI:dxIsWindowVisible(charInfoGUI) then
		emGUI:dxCloseWindow(charInfoGUI)
	end
	
	if (noCharactersGUI) then
		emGUI:dxCloseWindow(noCharactersGUI)
		emGUI:dxCloseWindow(topBarBackground)
	else
		emGUI:dxCloseWindow(topBarBackground)
		emGUI:dxCloseWindow(selectedCharacterGUI)
	end

	setElementAlpha(localPlayer, 254)
	toggleAllControls(true)
	removeEventHandler("onClientClick", getRootElement(), onClientClickCharacterSelect)
	local totalPeds = #dummyPeds
	for i, ped in ipairs(dummyPeds) do
		destroyElement(ped)
		emGUI:dxCloseWindow(characterSelectorGUI[i])
	end
end

function createCharacterButtonClick(button, state)
	if (button == "left") and (state == "down") then
		character_leavingCharSelection()
		showCursor(false)
		fadeCamera(false, 0.1)
		beginCharCreation(localPlayer)
	end
end

function accountHistoryButtonClick(button, state)
	if (button == "left") and (state == "down") then
		triggerServerEvent("admin:s_showAccountHistory", localPlayer, localPlayer)
	end
end

settingsUIState = false
function accountSettingsButtonClick(button, state)
	if (button == "left") and (state == "down") then

		if not (settingsUIState) then
			settingsUIState = true
			triggerEvent("account:gui:settingsSubMenuGUI", localPlayer)
		else
			triggerEvent("account:gui:closeCharSelSettings", localPlayer)
			settingsUIState = false
		end
	end
end

function logoutButtonClick(button, state)
	if (button == "left") and (state == "down") then
		showCursor(false)
		if (emGUI:dxIsWindowVisible(noCharactersGUI)) then
			emGUI:dxCloseWindow(noCharactersGUI)
		end

		if (emGUI:dxIsWindowVisible(selectedCharacterGUI)) then
			emGUI:dxCloseWindow(selectedCharacterGUI)
		end
		
		emGUI:dxCloseWindow(topBarBackground)

		triggerEvent("character:logoutPlayer", localPlayer, true)
	end
end

------------------------------------ Character Selected ------------------------------------

highlightedPedID = false

function onClientClickCharacterSelect(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
	if (button == "left") and (state == "down") and clickedElement then
		local elementType = getElementType(clickedElement)

		if (elementType == "ped") and (getElementData(clickedElement, "temp:ped:active") ~= 0) then
			emGUI:dxSetVisible(selectedCharacterGUI, true)
			highlightedPedID = getElementData(clickedElement, "temp:ped:pedid")
			setPedAnimation(clickedElement, "ON_LOOKERS", "wave_loop", -1, false, false, false, false)
			if (emGUI:dxIsWindowVisible(charInfoGUI)) then
				emGUI:dxCloseWindow(charInfoGUI)
			end
			character_characterHighlighted()
		end
	end
end

function character_characterHighlighted()
	emGUI:dxSetVisible(selectedCharacterGUI, true)

	local charFullName = getElementData(dummyPeds[highlightedPedID], "name")
	
	if #charFullName > 20 then
		charFullName = charFullName:gsub("_", "\n")
	else
		charFullName = charFullName:gsub("_", " ")
	end

	emGUI:dxSetText(sideGUI_charName, charFullName)

	local lastuse = getElementData(dummyPeds[highlightedPedID], "temp:ped:lastused")
	if (tostring(lastuse) == "NEVER") then
		emGUI:dxSetText(sideGUI_lastUsedLabel, "Never.")
	else
		local parsedTime = exports.global:convertTime(lastuse)
		emGUI:dxSetText(sideGUI_lastUsedLabel, parsedTime[2] .. " at " .. parsedTime[1])
	end

	emGUI:dxSetText(sideGUI_totalHoursLabel, getElementData(dummyPeds[highlightedPedID], "temp:ped:hours"))
	
	local status = getElementData(dummyPeds[highlightedPedID], "temp:ped:status")
	if (status == 2) then
		status = "Arrested"
	elseif (status == 1) then
		status = "Dead"
	else
		status = "Alive"
	end
	emGUI:dxSetText(sideGUI_charStatusLabel, status)

	emGUI:dxSetText(sideGUI_currentLocLabel, getElementData(dummyPeds[highlightedPedID], "temp:ped:locationarea"))
	emGUI:dxSetText(sideGUI_labels[5], "PROPERTIES (0/" .. getElementData(dummyPeds[highlightedPedID], "temp:ped:maxinteriors") .. "):")
	emGUI:dxSetText(sideGUI_labels[6], "VEHICLES (0/" .. getElementData(dummyPeds[highlightedPedID], "temp:ped:maxvehicles") .. "):")
	local money, bankmoney = getElementData(dummyPeds[highlightedPedID], "temp:ped:money"), getElementData(dummyPeds[highlightedPedID], "temp:ped:bankmoney")
	emGUI:dxSetText(sideGUI_cashInHandLabel, "$" .. exports.global:formatNumber(money))
	emGUI:dxSetText(sideGUI_cashInBankLabel, "$" .. exports.global:formatNumber(bankmoney))

	local parsedJob = getElementData(dummyPeds[highlightedPedID], "temp:ped:job")
	if (parsedJob == 0) then parsedJob = "None." end -- Add more job IDs here.
	emGUI:dxSetText(sideGUI_currentJobLabel, parsedJob)
end

function character_CharInfoOpen(charid)
	local charInfoGUILabels = {}
	
	charInfoGUI = emGUI:dxCreateWindow(0.49, 0.24, 0.25, 0.52, "", true, true, _, true, _, 1.5, _, tocolor(0, 255, 0))

	charInfoGUILabels[1] = emGUI:dxCreateLabel(0.09, 0.06, 0.82, 0.07, "CHARACTER INFORMATION", true, charInfoGUI)
	charInfoGUILabels[2] = emGUI:dxCreateLabel(0.07, 0.23, 0.16, 0.03, "ETHNICITY:", true, charInfoGUI)
	charInfoGUILabels[3] = emGUI:dxCreateLabel(0.09, 0.28, 0.14, 0.03, "GENDER:", true, charInfoGUI)
	charInfoGUILabels[4] = emGUI:dxCreateLabel(0.09, 0.33, 0.14, 0.03, "WEIGHT:", true, charInfoGUI)
	charInfoGUILabels[5] = emGUI:dxCreateLabel(0.09, 0.38, 0.14, 0.03, "HEIGHT:", true, charInfoGUI)

	charInfoGUILabels[6] = emGUI:dxCreateLabel(0.49, 0.23, 0.16, 0.03, "DIMENSION:", true, charInfoGUI)
	charInfoGUILabels[7] = emGUI:dxCreateLabel(0.49, 0.28, 0.16, 0.03, "INTERIOR:", true, charInfoGUI)
	charInfoGUILabels[8] = emGUI:dxCreateLabel(0.46, 0.33, 0.19, 0.03, "FIGHTSTYLE:", true, charInfoGUI)
	charInfoGUILabels[9] = emGUI:dxCreateLabel(0.49, 0.38, 0.16, 0.03, "SKIN:", true, charInfoGUI)

	charInfoGUILabels[10] = emGUI:dxCreateLabel(0.05, 0.47, 0.27, 0.03, "ORIGIN:", true, charInfoGUI)
	charInfoGUILabels[11] = emGUI:dxCreateLabel(0.05, 0.51, 0.27, 0.03, "LANGUAGES:", true, charInfoGUI)
	charInfoGUILabels[12] = emGUI:dxCreateLabel(0.05, 0.55, 0.27, 0.03, "LICENSES:", true, charInfoGUI)

	charInfoGUILabels[13] = emGUI:dxCreateLabel(0.15, 0.65, 0.36, 0.04, "SKILLS PROGRESSION", true, charInfoGUI)
	charInfoGUILabels[14] = emGUI:dxCreateLabel(0.05, 0.708, 0.23, 0.03, "STRENGTH", true, charInfoGUI)
	charInfoGUILabels[15] = emGUI:dxCreateLabel(0.05, 0.748, 0.23, 0.03, "MARKSMANSHIP", true, charInfoGUI)
	charInfoGUILabels[16] = emGUI:dxCreateLabel(0.05, 0.787, 0.23, 0.03, "MECHANICS", true, charInfoGUI)
	charInfoGUILabels[17] = emGUI:dxCreateLabel(0.05, 0.827, 0.23, 0.03, "KNOWLEDGE", true, charInfoGUI)
	charInfoGUILabels[18] = emGUI:dxCreateLabel(0.05, 0.866, 0.23, 0.03, "STAMINA", true, charInfoGUI)

	local charName = getElementData(dummyPeds[charid], "name") or "Unknown"; charName = charName:gsub("_", " ")
	local createdDate = getElementData(dummyPeds[charid], "temp:ped:created"); local parsedDate = exports.global:convertTime(createdDate, true)
	charInfoSubLabel = emGUI:dxCreateLabel(0.05, 0.13, 0.90, 0.04, charName .. " was created on the " .. parsedDate[2], true, charInfoGUI)

	for i, v in ipairs(charInfoGUILabels) do
		emGUI:dxLabelSetHorizontalAlign(charInfoGUILabels[i], "right")
		emGUI:dxSetFont(charInfoGUILabels[i], tabFont_10)
	end

	emGUI:dxSetFont(charInfoGUILabels[1], buttonFont_18)
	emGUI:dxSetFont(charInfoGUILabels[13], tabFont_13)
	emGUI:dxLabelSetHorizontalAlign(charInfoGUILabels[1], "center")
	emGUI:dxLabelSetHorizontalAlign(charInfoSubLabel, "center")
	
	local charEthnicity = getElementData(dummyPeds[charid], "temp:ped:ethnicity")
	if tonumber(charEthnicity) then
		if (charEthnicity == 1) then charEthnicity = "Caucasian"
			elseif(charEthnicity == 2) then charEthnicity = "Black"
			elseif(charEthnicity == 3) then charEthnicity = "Hispanic"
			elseif(charEthnicity == 4) then charEthnicity = "Asian"
			else charEthnicity = "Unknown"
		end
	end

	local charGender = getElementData(dummyPeds[charid], "temp:ped:gender")
	if tonumber(charGender) then
		if (charGender == 1) then charGender = "Male"
			elseif (charGender == 2) then charGender = "Female"
			else charGender = "Unknown"
		end
	end

	local charWeight = getElementData(dummyPeds[charid], "temp:ped:weight") or 0
	local charHeight = getElementData(dummyPeds[charid], "temp:ped:height") or 0
	local charDimension = getElementData(dummyPeds[charid], "temp:ped:dimension") or 0
	local charInterior = getElementData(dummyPeds[charid], "temp:ped:interior") or 0

	local charFightstyle = getElementData(dummyPeds[charid], "temp:ped:fightstyle")

	if tonumber(charFightstyle) then
		if (charFightstyle == 4) then charFightstyle = "Normal"
			elseif (charFightstyle == 5) then charFightstyle = "Boxing"
			elseif (charFightstyle == 6) then charFightstyle = "Kung Fu"
			elseif (charFightstyle == 7) then charFightstyle = "Kneehead"
			elseif (charFightstyle == 15) then charFightstyle = "Grab Kick"
			elseif (charFightstyle == 16) then charFightstyle = "Elbow Fighting"
			else charFightstyle = "Unknown"
		end
	end

	local charSkinID = getElementData(dummyPeds[charid], "temp:ped:skin") or 0
	local charOrigin = getElementData(dummyPeds[charid], "temp:ped:origin") or "Unknown"
	local charLicenses = getElementData(dummyPeds[charid], "temp:ped:licenses") or "None"; local parsedLicenses = split(charLicenses, ",")
	local hasLicense = false

	for i, license in ipairs(parsedLicenses) do
		if tonumber(parsedLicenses[i]) == 1 then
			hasLicense = true
		end
	end

	local charLicenseString
	
	if hasLicense then
		local c = false
		if (tonumber(parsedLicenses[1]) == 1) then
			charLicenseString = "Motorvehicle"
			c = true
		end
		if (tonumber(parsedLicenses[2]) == 1) then
			if (c) then
				charLicenseString = charLicenseString .. ", Bike"
				c = true
			else
				charLicenseString = "Bike"
			end
		end
		if (tonumber(parsedLicenses[3]) == 1) then
			if (c) then
				charLicenseString = charLicenseString .. ", Boat"
				c = true
			else
				charLicenseString = "Boat"
			end
		end
		if (tonumber(parsedLicenses[7]) == 1) then
			if (c) then
				charLicenseString = charLicenseString .. ", Helicopter"
				c = true
			else
				charLicenseString = "Helicopter"
			end
		end
		if (tonumber(parsedLicenses[8]) == 1) then
			if (c) then
				charLicenseString = charLicenseString .. ", Plane"
				c = true
			else
				charLicenseString = "Plane"
			end
		end
		if (#charLicenseString > 42) then
			charLicenseString = "All Licenses."
		end
	else
		charLicenseString = "None."
	end


	local language = getElementData(dummyPeds[charid], "temp:ped:language")
	local language2 = getElementData(dummyPeds[charid], "temp:ped:language2")
	local language3 = getElementData(dummyPeds[charid], "temp:ped:language3")
	local charLanguageString

	if (language ~= 0) then
		local lang = exports.global:getLanguageName(language)
		charLanguageString = lang
	end

	if (language2 ~= 0) then
		lang = exports.global:getLanguageName(language2)
		charLanguageString = charLanguageString .. ", " .. lang
	end

	if (language3 ~= 0) then
		lang = exports.global:getLanguageName(language3)
		charLanguageString = charLanguageString .. ", " .. lang
	end

	local charSkills = getElementData(dummyPeds[charid], "temp:ped:skills"); local parsedSkills = split(charSkills, ",")

	local skillStrengthPercent = parsedSkills[1] * 10
	local skillMarksmanshipPercent = parsedSkills[2] * 10
	local skillMechanicsPercent = parsedSkills[3] * 10
	local skillKnowledgePercent = parsedSkills[4] * 10
	local skillStaminahPercent = parsedSkills[5] * 10

	infoEthnicityLabel = emGUI:dxCreateLabel(0.24, 0.231, 0.27, 0.03, charEthnicity, true, charInfoGUI)
	infoGenderLabel = emGUI:dxCreateLabel(0.24, 0.2815, 0.27, 0.03, charGender, true, charInfoGUI)
	infoWeightLabel = emGUI:dxCreateLabel(0.24, 0.332, 0.27, 0.03, charWeight .. "kg", true, charInfoGUI)
	infoHeightLabel = emGUI:dxCreateLabel(0.24, 0.383, 0.27, 0.03, charHeight .. "cm", true, charInfoGUI)
	
	infoDimensionLabel = emGUI:dxCreateLabel(0.66, 0.232, 0.27, 0.03, charDimension, true, charInfoGUI)
	infoInteriorLabel = emGUI:dxCreateLabel(0.66, 0.282, 0.27, 0.03, charInterior, true, charInfoGUI)
	infoFightStyleLabel = emGUI:dxCreateLabel(0.66, 0.332, 0.27, 0.03, charFightstyle, true, charInfoGUI)
	infoSkinLabel = emGUI:dxCreateLabel(0.66, 0.3836, 0.27, 0.03, "ID " .. charSkinID, true, charInfoGUI)
	
	infoOriginLabel = emGUI:dxCreateLabel(0.33, 0.472, 0.60, 0.03, charOrigin, true, charInfoGUI)
	infoLanguagesLabel = emGUI:dxCreateLabel(0.33, 0.512, 0.60, 0.03, charLanguageString, true, charInfoGUI)
	infoLicensesLabel = emGUI:dxCreateLabel(0.33, 0.551, 0.60, 0.03, charLicenseString, true, charInfoGUI)

	emGUI:dxSetFont(infoGenderLabel, mainFont_9)
	emGUI:dxSetFont(infoEthnicityLabel, mainFont_9)
	emGUI:dxSetFont(infoWeightLabel, mainFont_9)
	emGUI:dxSetFont(infoHeightLabel, mainFont_9)
	emGUI:dxSetFont(infoDimensionLabel, mainFont_9)
	emGUI:dxSetFont(infoInteriorLabel, mainFont_9)
	emGUI:dxSetFont(infoFightStyleLabel, mainFont_9)
	emGUI:dxSetFont(infoSkinLabel, mainFont_9)
	emGUI:dxSetFont(infoOriginLabel, mainFont_9)
	emGUI:dxSetFont(infoLicensesLabel, mainFont_9)
	emGUI:dxSetFont(infoLanguagesLabel, mainFont_9)

	strengthProgBar = emGUI:dxCreateProgressBar(0.30, 0.71, 0.51, 0.03, true, charInfoGUI)
	marksmanshipProgBar = emGUI:dxCreateProgressBar(0.30, 0.75, 0.51, 0.03, true, charInfoGUI)
	mechanicsProgBar = emGUI:dxCreateProgressBar(0.30, 0.788, 0.51, 0.03, true, charInfoGUI)
	knowledgeProgBar = emGUI:dxCreateProgressBar(0.30, 0.828, 0.51, 0.03, true, charInfoGUI)
	staminaProgBar = emGUI:dxCreateProgressBar(0.30, 0.868, 0.51, 0.03, true, charInfoGUI)

	emGUI:dxProgressBarSetProgress(strengthProgBar, skillStrengthPercent)
	emGUI:dxProgressBarSetProgress(marksmanshipProgBar, skillMarksmanshipPercent)
	emGUI:dxProgressBarSetProgress(mechanicsProgBar, skillMechanicsPercent)
	emGUI:dxProgressBarSetProgress(knowledgeProgBar, skillKnowledgePercent)
	emGUI:dxProgressBarSetProgress(staminaProgBar, skillStaminahPercent)

	infoStrengthPercent = emGUI:dxCreateLabel(0.825, 0.709, 0.07, 0.03, skillStrengthPercent .. "%", true, charInfoGUI)
	infoMarksmanPercent = emGUI:dxCreateLabel(0.825, 0.749, 0.07, 0.03, skillMarksmanshipPercent .. "%", true, charInfoGUI)
	infoMechanicsPercent = emGUI:dxCreateLabel(0.825, 0.788, 0.07, 0.03, skillMechanicsPercent .. "%", true, charInfoGUI)
	infoKnowledgePercent = emGUI:dxCreateLabel(0.825, 0.828, 0.07, 0.03, skillKnowledgePercent .. "%", true, charInfoGUI)
	infoStaminaPercent = emGUI:dxCreateLabel(0.825, 0.867, 0.07, 0.03, skillStaminahPercent .. "%", true, charInfoGUI)

	emGUI:dxSetFont(infoStrengthPercent, mainFont_9)
	emGUI:dxSetFont(infoMarksmanPercent, mainFont_9)
	emGUI:dxSetFont(infoMechanicsPercent, mainFont_9)
	emGUI:dxSetFont(infoKnowledgePercent, mainFont_9)
	emGUI:dxSetFont(infoStaminaPercent, mainFont_9)
end

function sideGUI_charInfoButtonClick(button, state)
	if (button == "left") and (state == "down") then
		if (emGUI:dxIsWindowVisible(charInfoGUI)) then
			emGUI:dxCloseWindow(charInfoGUI)
		else
			local charid = highlightedPedID
			character_CharInfoOpen(charid)
		end
	end
end

function characterSelected(button, state)
	if (button == "left") and (state == "down") then
		triggerEvent("account:gui:closeCharSelSettings", localPlayer)

		fadeCamera(false, 0.7)
		local selectedCharID = getElementData(dummyPeds[highlightedPedID], "temp:ped:charid")
		setElementAlpha(localPlayer, 0)
		showCursor(false)

		setTimer(character_leavingCharSelection, 1000, 1)
		setTimer(function()
			triggerServerEvent("character:spawnCharacter", localPlayer, localPlayer, selectedCharID)
		end, 2000, 1)
		highlightedPedID = nil
	end
end

function character_cancelLoginDamage(state)
	if (state) then
		addEventHandler("onClientPlayerDamage", localPlayer, character_cancelLoginDamageNil)
	else
		removeEventHandler("onClientPlayerDamage", localPlayer, character_cancelLoginDamageNil)
	end
end
addEvent("character:cancelLoginDamage", true)
addEventHandler("character:cancelLoginDamage", getRootElement(), character_cancelLoginDamage)

function character_cancelLoginDamageNil()
	cancelEvent()
end