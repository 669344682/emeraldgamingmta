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

function c_checkPlayer(commandName, targetPlayer)
	triggerServerEvent("admin:s_checkPlayer", localPlayer, localPlayer, commandName, targetPlayer)
end
addCommandHandler("check", c_checkPlayer)
-- NOTE: This  command handler is located clientside since "check" is a default MTA server-sided command.

-------------------------------------------------------------------------------------------
--										CHECK GUI 										 --
-------------------------------------------------------------------------------------------

player = false
function showCheckGUI(targetPlayer, accountData, characterData)
	local guiState = emGUI:dxIsWindowVisible(checkPlayerGUI)
	if (guiState) then
		emGUI:dxCloseWindow(checkPlayerGUI)
		removeEventHandler("onClientRender", root, updateCheckUI)
	end
	if not (targetPlayer) then outputDebugString("[admin-system] @showCheckGUI: targetPlayer not provided or does not exist.", 3) return false end

	if not type(accountData) == "table" or not type(characterData) == "table" then
		outputDebugString("[admin-system] @showCheckGUI: accountData or characterData not received or is not a table.", 3)
		return false
	end

	player = targetPlayer

	local adminNote = accountData[1]
	local playerIP = accountData[2]

	checkGUILabels = {}
	answerLabels = {}

	local posX, posY = handleXMLLocation(2)
	checkPlayerGUI = emGUI:dxCreateWindow(posX, posY, 0.24, 0.53, "[?] Unknown (Unknown)", true, _, true, _, _, _, _, tocolor(50, 200, 0, 200), _, tocolor(0, 0, 0, 200))

	checkGUILabels[1] = emGUI:dxCreateLabel(0.06, 0.02, 0.20, 0.03, "Character:", true, checkPlayerGUI)
	checkGUILabels[2] = emGUI:dxCreateLabel(0.06, 0.055, 0.20, 0.03, "Account:", true, checkPlayerGUI)
	checkGUILabels[3] = emGUI:dxCreateLabel(0.06, 0.085, 0.20, 0.03, "Rank:", true, checkPlayerGUI)
	checkGUILabels[4] = emGUI:dxCreateLabel(0.06, 0.115, 0.20, 0.03, "IP:", true, checkPlayerGUI)
	checkGUILabels[5] = emGUI:dxCreateLabel(0.06, 0.145, 0.20, 0.03, "Ping:", true, checkPlayerGUI)
	checkGUILabels[6] = emGUI:dxCreateLabel(0.06, 0.175, 0.20, 0.03, "Factions:", true, checkPlayerGUI)
	checkGUILabels[7] = emGUI:dxCreateLabel(0.06, 0.209, 0.20, 0.03, "Hours:", true, checkPlayerGUI)

	checkGUILabels[8] = emGUI:dxCreateLabel(0.55, 0.02, 0.20, 0.03, "Health:", true, checkPlayerGUI)
	checkGUILabels[9] = emGUI:dxCreateLabel(0.55, 0.055, 0.20, 0.03, "Armour:", true, checkPlayerGUI)
	checkGUILabels[10] = emGUI:dxCreateLabel(0.55, 0.085, 0.20, 0.03, "Skin ID:", true, checkPlayerGUI)
	checkGUILabels[11] = emGUI:dxCreateLabel(0.55, 0.116, 0.20, 0.03, "Emeralds:", true, checkPlayerGUI)
	checkGUILabels[12] = emGUI:dxCreateLabel(0.55, 0.147, 0.20, 0.03, "Reports:", true, checkPlayerGUI)

	checkGUILabels[13] = emGUI:dxCreateLabel(0.06, 0.26, 0.04, 0.03, "X:", true, checkPlayerGUI)
	checkGUILabels[14] = emGUI:dxCreateLabel(0.06, 0.29, 0.04, 0.03, "Y:", true, checkPlayerGUI)
	checkGUILabels[15] = emGUI:dxCreateLabel(0.06, 0.32, 0.04, 0.03, "Z:", true, checkPlayerGUI)
	checkGUILabels[16] = emGUI:dxCreateLabel(0.06, 0.35, 0.15, 0.03, "Location:", true, checkPlayerGUI)
	checkGUILabels[17] = emGUI:dxCreateLabel(0.06, 0.38, 0.15, 0.03, "Vehicle:", true, checkPlayerGUI)

	checkGUILabels[18] = emGUI:dxCreateLabel(0.55, 0.26, 0.20, 0.03, "Dimension:", true, checkPlayerGUI)
	checkGUILabels[19] = emGUI:dxCreateLabel(0.55, 0.29, 0.20, 0.03, "Interior:", true, checkPlayerGUI)

	answerLabels[1] = emGUI:dxCreateLabel(0.24, 0.022, 0.36, 0.03, "Unknown", true, checkPlayerGUI)
	answerLabels[2] = emGUI:dxCreateLabel(0.24, 0.056, 0.36, 0.03, "Unknown", true, checkPlayerGUI)
	answerLabels[3] = emGUI:dxCreateLabel(0.24, 0.087, 0.36, 0.03, "Player", true, checkPlayerGUI)
	answerLabels[4] = emGUI:dxCreateLabel(0.24, 0.116, 0.36, 0.03, playerIP, true, checkPlayerGUI)
	answerLabels[5] = emGUI:dxCreateLabel(0.24, 0.147, 0.36, 0.03, "0ms", true, checkPlayerGUI)
	answerLabels[6] = emGUI:dxCreateLabel(0.24, 0.179, 0.36, 0.03, "None.", true, checkPlayerGUI)
	answerLabels[7] = emGUI:dxCreateLabel(0.24, 0.211, 0.36, 0.03, "0", true, checkPlayerGUI)

	answerLabels[8] = emGUI:dxCreateLabel(0.76, 0.022, 0.21, 0.03, "100HP", true, checkPlayerGUI)
	answerLabels[9] = emGUI:dxCreateLabel(0.76, 0.056, 0.21, 0.03, "0%", true, checkPlayerGUI)
	answerLabels[10] = emGUI:dxCreateLabel(0.76, 0.087, 0.21, 0.03, "Unknown", true, checkPlayerGUI)
	answerLabels[11] = emGUI:dxCreateLabel(0.76, 0.116, 0.21, 0.03, "Unknown", true, checkPlayerGUI)
	answerLabels[12] = emGUI:dxCreateLabel(0.76, 0.148, 0.21, 0.03, "0", true, checkPlayerGUI)

	answerLabels[13] = emGUI:dxCreateLabel(0.24, 0.261, 0.33, 0.03, "Unknown", true, checkPlayerGUI)
	answerLabels[14] = emGUI:dxCreateLabel(0.24, 0.291, 0.33, 0.03, "Unknown", true, checkPlayerGUI)
	answerLabels[15] = emGUI:dxCreateLabel(0.24, 0.321, 0.33, 0.03, "Unknown", true, checkPlayerGUI)
	answerLabels[16] = emGUI:dxCreateLabel(0.24, 0.352, 0.33, 0.03, "Unknown", true, checkPlayerGUI)
	answerLabels[17] = emGUI:dxCreateLabel(0.24, 0.4, 0.33, 0.03, "None.", true, checkPlayerGUI)

	answerLabels[18] = emGUI:dxCreateLabel(0.77, 0.261, 0.21, 0.03, "0", true, checkPlayerGUI)
	answerLabels[19] = emGUI:dxCreateLabel(0.77, 0.291, 0.21, 0.03, "0", true, checkPlayerGUI)
	
	for i = 1, #checkGUILabels do
		emGUI:dxLabelSetHorizontalAlign(checkGUILabels[i], "left")
		emGUI:dxLabelSetVerticalAlign(answerLabels[i], "center")
	end

	playerNoteMemo = emGUI:dxCreateMemo(0.26, 0.46, 0.69, 0.40, "", true, checkPlayerGUI)

	historyButton = emGUI:dxCreateButton(0.053, 0.46, 0.18, 0.13, "HISTORY\n0 Points\n0 Warns", true, checkPlayerGUI, _, 0.78, 0.78)
	addEventHandler("onClientDgsDxMouseClick", historyButton, historyButtonClick)

	local totalPoints = getElementData(player, "account:punishments") or 0
	local totalWarns = getElementData(player, "account:warns") or 0
	emGUI:dxSetText(historyButton, "HISTORY\n" .. totalPoints .. " Points\n" .. totalWarns .." Warns")

	inventoryButton = emGUI:dxCreateButton(0.053, 0.60, 0.18, 0.13, "View\nInventory", true, checkPlayerGUI, _, 0.78, 0.78)
	emGUI:dxSetEnabled(inventoryButton, false)
	addEventHandler("onClientDgsDxMouseClick", inventoryButton, inventoryButtonClick)

	assetsButton = emGUI:dxCreateButton(0.053, 0.74, 0.18, 0.12, "Assets", true, checkPlayerGUI, _, 0.78, 0.78)
	addEventHandler("onClientDgsDxMouseClick", assetsButton, assetsButtonClick)

	actionsButton = emGUI:dxCreateButton(0.053, 0.89, 0.41, 0.09, "ACTIONS", true, checkPlayerGUI)
	addEventHandler("onClientDgsDxMouseClick", actionsButton, actionsButtonClick)

	updateNoteButton = emGUI:dxCreateButton(0.53, 0.89, 0.42, 0.09, "UPDATE NOTE", true, checkPlayerGUI)
	addEventHandler("onClientDgsDxMouseClick", updateNoteButton, updateNoteButtonClick)

	resetPosButton = emGUI:dxCreateButton(0, -0.045, 0.05, 0.046, "↩️", true, checkPlayerGUI, _, _, _, _, _, _, tocolor(50, 200, 0, 0))
	addEventHandler("onClientDgsDxMouseClick", resetPosButton, resetPosButtonClick)

	local staffRank = getElementData(localPlayer, "staff:rank")
	if (staffRank < 3) and player == localPlayer then
		emGUI:dxSetEnabled(playerNoteMemo, false)
		emGUI:dxSetEnabled(updateNoteButton, false)
		emGUI:dxSetText(playerNoteMemo, "\n\n\n\n\n             You cannot read your own note.")
	else
		emGUI:dxSetText(playerNoteMemo, adminNote)
	end

	addEventHandler("onClientRender", root, updateCheckUI)
	addEventHandler("onClientDgsDxWindowClose", checkPlayerGUI, function()
		removeEventHandler("onClientRender", root, updateCheckUI)
		local rx, ry = emGUI:dxGetPosition(checkPlayerGUI, true)
		local actionMenuState = emGUI:dxIsWindowVisible(actionsMenuGUI)
		if (actionMenuState) then
			removeEventHandler("onClientRender", root, drawButtonLabels)
			emGUI:dxCloseWindow(actionsMenuGUI)
		end
		handleXMLLocation(1, rx, ry)
	end)
end
addEvent("admin:showCheckGUI", true)
addEventHandler("admin:showCheckGUI", root, showCheckGUI)

-------------------------------------------------------------------------------------------
--								ONCLIENTRENDER UPDATES 								 	 --
-------------------------------------------------------------------------------------------

function updateCheckUI()
	if isElement(player) then
		local loggedin = getElementData(player, "loggedin")
		local ploggedin = getElementData(localPlayer, "loggedin")
		if (loggedin == 1) and (ploggedin == 1) then
			local playerID = getElementData(player, "player:id")
			local characterName = getElementData(player, "character:name") or "Unknown"; characterName = characterName:gsub("_", " ")
			local accountName = getElementData(player, "account:username") or "Unknown"
			local playerRank = getElementData(player, "title:staff")
			local ping = getPlayerPing(player) or 0
			local playerFactions = getElementData(player, "character:factions")
			local playerFactionString = ""
			for i, fac in ipairs(playerFactions) do
				if (fac ~= 0) then
					if (i == 1) then
						playerFactionString = fac
					else
						playerFactionString = playerFactionString .. ", " .. fac
					end
				end
			end
			if (#tostring(playerFactionString) < 1) then playerFactionString = "None" end
			playerFactionString = playerFactionString .. "."
			local accHours = getElementData(player, "account:hours") or 0; accHours = exports.global:formatNumber(accHours)
			local charHours = getElementData(player, "character:hours") or 0; charHours = exports.global:formatNumber(charHours)
			local health = getElementHealth(player) or 100
			local armor = getPedArmor(player) or 0
			local skinID = getElementData(player, "character:skin") or 0
			local emeralds = getElementData(player, "account:emeralds") or 0; emeralds = exports.global:formatNumber(emeralds)
			local reports = getElementData(player, "account:reports") or 0; reports = exports.global:formatNumber(reports)

			local x, y, z = getElementPosition(player)
			local dimension = getElementDimension(player) or 0
			local interior = getElementInterior(player) or 0
			local locationString = getZoneName(x, y, z)
			if (dimension ~= 0) and (interior ~= 0) then
				locationString = "Inside Interior #" .. dimension
			else
				local city = getZoneName(x, y, z, true)
				if not (locationString == city) then
					locationString = locationString .. ", " .. city .. "."
				else
					locationString = locationString .. "."
				end
			end

			local vehicleString = "None"
			local vehicle = getPedOccupiedVehicle(player)
			if (vehicle) then
				local vehicleID = getElementData(vehicle, "vehicle:id")
				local vehicleName = getElementData(vehicle, "vehicle:name")
				local vehicleHealth = getElementHealth(vehicle)
				vehicleString = "[" .. vehicleID .. "] " .. vehicleName .. " \nHP: " .. string.format("%.0f", vehicleHealth) .. "/1000 | Seat: " .. getPedOccupiedVehicleSeat(player)
			end

			emGUI:dxSetText(checkPlayerGUI, "ID: " .. playerID .. " | "  .. characterName .. " | " .. accountName)
			emGUI:dxSetText(answerLabels[1], characterName)
			emGUI:dxSetText(answerLabels[2], accountName)
			emGUI:dxSetText(answerLabels[3], playerRank)
			emGUI:dxSetText(answerLabels[5], ping .. "ms")
			emGUI:dxSetText(answerLabels[6], playerFactionString)
			emGUI:dxSetText(answerLabels[7], "Character: " .. charHours .. " Hours | Total: " .. accHours .. " Hours")
			emGUI:dxSetText(answerLabels[8], string.format("%.0f", health) .. " HP")
			emGUI:dxSetText(answerLabels[9], string.format("%.0f", armor) .. "%") 
			emGUI:dxSetText(answerLabels[10], skinID)
			emGUI:dxSetText(answerLabels[11], emeralds)
			emGUI:dxSetText(answerLabels[12], reports)

			emGUI:dxSetText(answerLabels[13], string.format("%.5f", x))
			emGUI:dxSetText(answerLabels[14], string.format("%.5f", y))
			emGUI:dxSetText(answerLabels[15], string.format("%.5f", z))
			emGUI:dxSetText(answerLabels[16], locationString)
			emGUI:dxSetText(answerLabels[17], vehicleString)
			emGUI:dxSetText(answerLabels[18], dimension)
			emGUI:dxSetText(answerLabels[19], interior)
		else
			if (loggedin == 2) then
				if (localPlayer == player) then
					emGUI:dxCloseWindow(checkPlayerGUI)
				else
					outputChatBox("The player you were checking has returned to character selection.", 255, 0, 0)
					emGUI:dxSetText(answerLabels[15], "Character Selection")
					removeEventHandler("onClientRender", root, updateCheckUI)
				end
			end
		end
	else
		outputChatBox("The player you were checking is no longer online.", 255, 0, 0)
		removeEventHandler("onClientRender", root, updateCheckUI)
	end
end

-------------------------------------------------------------------------------------------
--									BUTTON FUNCTIONS 								 	 --
-------------------------------------------------------------------------------------------

function historyButtonClick(button, state)
	if (button == "left") and (state == "down") then
		local targetAccountName = getElementData(player, "account:username")
		triggerServerEvent("admin:s_showAccountHistory", localPlayer, localPlayer, nil, targetAccountName)
	end
end

function inventoryButtonClick(button, state)
	if (button == "left") and (state == "down") then
		outputDebugString("View Inventory Button Click", 3)
	end
end

function assetsButtonClick(button, state)
	if (button == "left") and (state == "down") then
		checkAssetsGUI()
	end
end

function actionsButtonClick(button, state)
	if (button == "left") and (state == "down") then
		showActionsMenu()
	end
end

function resetPosButtonClick(button, state)
	if (button == "left") and (state == "up") then
		emGUI:dxSetPosition(checkPlayerGUI, 0.70, 0.22, true)
	end
end

function updateNoteButtonClick(button, state)
	if (button == "left") and (state == "down") then
		local aNote = emGUI:dxGetText(playerNoteMemo)
		if not tostring(aNote) then
			outputChatBox("ERROR: The note contains invalid characters!", 255, 0, 0)
			return false
		end

		triggerServerEvent("admin:updateCheckNote", localPlayer, localPlayer, player, aNote)
	end
end

function handleXMLLocation(mode, posx, posy)
	local defaultX, defaultY = 0.70, 0.22
	if not tonumber(mode) then return defaultX, defaultY end
	
	if (mode == 1) then
		local posFile = xmlLoadFile("checkpos.xml")
		if not posFile then
			local posFile = xmlCreateFile("checkpos.xml", "check")
			local xNode = xmlCreateChild(posFile, "x")
			local yNode = xmlCreateChild(posFile, "y")

			if not tonumber(posx) or not tonumber(posy) then
				posx = defaultX
				posy = defaultY
			end

			xmlNodeSetValue(xNode, posx)
			xmlNodeSetValue(yNode, posy)
			xmlSaveFile(posFile)
			xmlUnloadFile(posFile)
			return true
		end

		local xNode = xmlFindChild(posFile, "x", 0)
		local yNode = xmlFindChild(posFile, "y", 0)

		if not tonumber(posx) or not tonumber(posy) then
			posx = defaultX
			posy = defaultY
		end

		xmlNodeSetValue(xNode, posx)
		xmlNodeSetValue(yNode, posy)
		xmlSaveFile(posFile)
		xmlUnloadFile(posFile)
	elseif (mode == 2) then
		local posFile = xmlLoadFile("checkpos.xml")
		if not (posFile) then
			return defaultX, defaultY
		else
			local xNode = xmlFindChild(posFile, "x", 0)
			local yNode = xmlFindChild(posFile, "y", 0)

			local rx, ry = xmlNodeGetValue(xNode) or defaultX, xmlNodeGetValue(yNode) or defaultY
			xmlUnloadFile(posFile)

			if (rx ~= "") and (rx) and (ry ~= "") and (ry) then
				return rx, ry
			else
				return defaultX, defaultY
			end
		end
	end
end

-------------------------------------------------------------------------------------------
--										ACTIONS GUI 								 	 --
-------------------------------------------------------------------------------------------

function showActionsMenu()
	local guiState = emGUI:dxIsWindowVisible(actionsMenuGUI)
	if (guiState) then
		emGUI:dxCloseWindow(actionsMenuGUI)
		emGUI:dxWindowSetMovable(checkPlayerGUI, true)
		removeEventHandler("onClientRender", root, drawButtonLabels)
		return
	end

	local x, y = emGUI:dxGetPosition(checkPlayerGUI, true)
	actionsMenuGUI = emGUI:dxCreateWindow(x, y + 0.53, 0.24, 0.08, "", true, true, true, true, _, 1, _, tocolor(0, 0, 0, 200), _, tocolor(0, 0, 0, 200))
	emGUI:dxWindowSetMovable(checkPlayerGUI, false)
	reconButton = emGUI:dxCreateButton(0.05, 0.14, 0.16, 0.7, "R", true, actionsMenuGUI, _, 1.3)
	addEventHandler("onClientDgsDxMouseClick", reconButton, reconButtonClick)
	freezeButton = emGUI:dxCreateButton(0.233, 0.14, 0.16, 0.7, "✋", true, actionsMenuGUI, _, 1.3)
	addEventHandler("onClientDgsDxMouseClick", freezeButton, freezeButtonClick)
	punishButton = emGUI:dxCreateButton(0.415, 0.14, 0.16, 0.7, "⚒️", true, actionsMenuGUI, _, 1.4)
	addEventHandler("onClientDgsDxMouseClick", punishButton, punishButtonClick)
	gotoButton = emGUI:dxCreateButton(0.60, 0.14, 0.16, 0.7, "↪️", true, actionsMenuGUI, _, 1.3)
	addEventHandler("onClientDgsDxMouseClick", gotoButton, gotoButtonClick)
	gethereButton = emGUI:dxCreateButton(0.79, 0.14, 0.16, 0.7, "↩️", true, actionsMenuGUI, _, 1.3)
	addEventHandler("onClientDgsDxMouseClick", gethereButton, gethereButtonClick)

	addEventHandler("onClientRender", root, drawButtonLabels)
end

function reconButtonClick(button, state)
	if (button == "left") and (state == "down") then
		triggerServerEvent("admin:reconPlayer", localPlayer, localPlayer, "recon", player)
	end
end

function freezeButtonClick(button, state)
	if (button == "left") and (state == "down") then
		triggerServerEvent("admin:freezePlayer", localPlayer, localPlayer, "freeze", player)
	end
end
function punishButtonClick(button, state)
	if (button == "left") and (state == "down") then
		triggerEvent("admin:showPunishPlayerGUI", localPlayer)
	end
end
function gotoButtonClick(button, state)
	if (button == "left") and (state == "down") then
		triggerServerEvent("admin:gotoPlayer", localPlayer, localPlayer, "goto", player)
	end
end
function gethereButtonClick(button, state)
	if (button == "left") and (state == "down") then
		triggerServerEvent("admin:getherePlayer", localPlayer, localPlayer, "gethere", player)
	end
end

function drawButtonLabels()
	if isCursorShowing() then
		local x, y = getCursorPosition()
		local screenX, screenY = guiGetScreenSize() 
		local cursorX, cursorY = x * screenX, y * screenY
		local uiX, uiY = emGUI:dxGetPosition(actionsMenuGUI)

		local sizeX = uiX + 96
		local sizeY = uiY + 71.5

		if isInBox(cursorX, cursorY, uiX + 23, uiY + 13, sizeX + 0.5, sizeY) then
			createLabel(cursorX, cursorY, "Recon")
		end

		if isInBox(cursorX, cursorY, uiX + 108, uiY + 13, sizeX + 84, sizeY) then
			createLabel(cursorX, cursorY, "Freeze")
		end

		if isInBox(cursorX, cursorY, uiX + 192, uiY + 13, sizeX + 169, sizeY) then
			createLabel(cursorX, cursorY, "Punish")
		end

		if isInBox(cursorX, cursorY, uiX + 276.5, uiY + 13, sizeX + 254, sizeY) then
			createLabel(cursorX, cursorY, "Go To")
		end

		if isInBox(cursorX, cursorY, uiX + 365, uiY + 13, sizeX + 342, sizeY) then
			createLabel(cursorX, cursorY, "Get Here")
		end
	end
end

pointerFont = dxCreateFont(":assets/fonts/hudTextFont.ttf", 12)
function isInBox(x, y, xmin, ymin, xmax, ymax)
	return x >= xmin and x <= xmax and y >= ymin and y <= ymax
end

function createLabel(x, y, firstLine, secondLine)
	local screenWidth, screenHeight = guiGetScreenSize()
	firstLine = tostring(firstLine)
	if secondLine then
		secondLine = tostring(secondLine)
	end
	
	if firstLine == secondLine then
		secondLine = nil
	end
	
	local width = dxGetTextWidth(firstLine, 1, pointerFont) + 20
	if secondLine then
		width = math.max(width, dxGetTextWidth(secondLine, 1, pointerFont) + 20)
		firstLine = firstLine .. "\n" .. secondLine
	end
	local height = 10 * (secondLine and 5 or 3)
	x = math.max(10, math.min(x, screenWidth - width)) + 8
	y = math.max(10, math.min(y, screenHeight - height)) + 10

	dxDrawRectangle(x, y, width, height, tocolor(70, 180, 90, 180), true)
	dxDrawText(firstLine, x, y, x + width, y + height, tocolor(255, 255, 255, 255), 1, pointerFont, "center", "center", false, false, true)
end

------------------------------------------------------------------------------------------

local assetsInfoLabels = {}
local assetsInfoProgressBars = {}

function checkAssetsGUI()
	local guiState = emGUI:dxIsWindowVisible(assetsInfoGUI)
	if (guiState) then
		emGUI:dxCloseWindow(assetsInfoGUI)
		removeEventHandler("onClientRender", root, renderAssetsInfo)
		return
	end

	local playerID = getElementData(player, "player:id")
	local playerName = getPlayerName(player); playerName = playerName:gsub("_", " ")
	local accountName = getElementData(player, "account:username") or "Unknown"
	assetsInfoGUI = emGUI:dxCreateWindow(0.36, 0.25, 0.28, 0.51, "Assets View | " .. playerName .. " (" .. accountName .. ")", true)

	assetsTabPanel = emGUI:dxCreateTabPanel(0.04, 0.05, 0.92, 0.90, true, assetsInfoGUI)
	assetsCharactersTab = emGUI:dxCreateTab("Characters", assetsTabPanel)
	assetsVehiclesTab = emGUI:dxCreateTab("Vehicles", assetsTabPanel)
	assetsPropertiesTab = emGUI:dxCreateTab("Properties", assetsTabPanel)

	assetsInfoLabels[1] = emGUI:dxCreateLabel(0.10, 0.036, 0.45, 0.04, "Character: " .. playerName .. " (" .. playerID .. ")", true, assetsCharactersTab)
	emGUI:dxLabelSetHorizontalAlign(assetsInfoLabels[1], "right")

	findAltsButton = emGUI:dxCreateButton(0.58, 0.02, 0.22, 0.07, "FINDALTS", true, assetsCharactersTab)
	addEventHandler("onClientDgsDxMouseClick", findAltsButton, findAltsButtonClick)
	
	assetsInfoLabels[2] = emGUI:dxCreateLabel(0.05, 0.12, 0.44, 0.14, "Character Languages\n  • Slot 1: English\n  • Slot 2: None\n  • Slot 3: None", true, assetsCharactersTab)
	assetsInfoLabels[3] = emGUI:dxCreateLabel(0.43, 0.12, 0.44, 0.14, "            Character Licenses\n  • Car: No\n  • Bike: No\n  • Boat: No", true, assetsCharactersTab)
	assetsInfoLabels[4] = emGUI:dxCreateLabel(0.65, 0.16, 0.44, 0.14, "• Helicopter: No\n• Plane: No", true, assetsCharactersTab)
	assetsInfoLabels[5] = emGUI:dxCreateLabel(0.385, 0.305, 0.18, 0.04, "Character Skills", true, assetsCharactersTab)
	
	assetsInfoLabels[6] = emGUI:dxCreateLabel(0.08, 0.365, 0.18, 0.04, "Strength", true, assetsCharactersTab)
	assetsInfoLabels[7] = emGUI:dxCreateLabel(0.08, 0.435, 0.18, 0.04, "Marksmanship", true, assetsCharactersTab)
	assetsInfoLabels[8] = emGUI:dxCreateLabel(0.08, 0.505, 0.18, 0.04, "Mechanics", true, assetsCharactersTab)
	assetsInfoLabels[9] = emGUI:dxCreateLabel(0.08, 0.575, 0.18, 0.04, "Knowledge", true, assetsCharactersTab)
	assetsInfoLabels[10] = emGUI:dxCreateLabel(0.08, 0.645, 0.18, 0.04, "Stamina", true, assetsCharactersTab)
	
	for i = 5, 10 do emGUI:dxLabelSetHorizontalAlign(assetsInfoLabels[i], "right") end

	assetsInfoProgressBars[1] = emGUI:dxCreateProgressBar(0.28, 0.36, 0.45, 0.05, true, assetsCharactersTab)
	assetsInfoProgressBars[2] = emGUI:dxCreateProgressBar(0.28, 0.43, 0.45, 0.05, true, assetsCharactersTab)
	assetsInfoProgressBars[3] = emGUI:dxCreateProgressBar(0.28, 0.50, 0.45, 0.05, true, assetsCharactersTab)
	assetsInfoProgressBars[4] = emGUI:dxCreateProgressBar(0.28, 0.57, 0.45, 0.05, true, assetsCharactersTab)
	assetsInfoProgressBars[5] = emGUI:dxCreateProgressBar(0.28, 0.64, 0.45, 0.05, true, assetsCharactersTab)
	assetsInfoLabels[11] = emGUI:dxCreateLabel(0.75, 0.365, 0.11, 0.04, "0%", true, assetsCharactersTab)
	assetsInfoLabels[12] = emGUI:dxCreateLabel(0.75, 0.435, 0.11, 0.04, "0%", true, assetsCharactersTab)
	assetsInfoLabels[13] = emGUI:dxCreateLabel(0.75, 0.505, 0.11, 0.04, "0%", true, assetsCharactersTab)
	assetsInfoLabels[14] = emGUI:dxCreateLabel(0.75, 0.575, 0.11, 0.04, "0%", true, assetsCharactersTab)
	assetsInfoLabels[15] = emGUI:dxCreateLabel(0.75, 0.645, 0.11, 0.04, "0%", true, assetsCharactersTab)

	assetsInfoLabels[16] = emGUI:dxCreateLabel(0.07, 0.71, 0.45, 0.04, "Money (Inventory): $0", true, assetsCharactersTab)
	assetsInfoLabels[17] = emGUI:dxCreateLabel(0.07, 0.75, 0.45, 0.04, "Money (Bank): $0", true, assetsCharactersTab)
	assetsInfoLabels[18] = emGUI:dxCreateLabel(0.07, 0.79, 0.45, 0.04, "Inventory Capacity: 0/60", true, assetsCharactersTab)
	assetsInfoLabels[19] = emGUI:dxCreateLabel(0.07, 0.83, 0.86, 0.15, "Factions:\n  • Slot 1: None.\n  • Slot 2: None.\n  • Slot 3: None.", true, assetsCharactersTab)

	addEventHandler("onClientRender", root, renderAssetsInfo)
	addEventHandler("onClientDgsDxWindowClose", assetsInfoGUI, function()
		removeEventHandler("onClientRender", root, renderAssetsInfo)
	end)
end

function renderAssetsInfo()
	local loggedin = getElementData(player, "loggedin")
	if isElement(player) and (loggedin == 1) then
		local ploggedin = getElementData(localPlayer, "loggedin")
		if (ploggedin == 1) then
			local lang1 = getElementData(player, "character:language") or 1; lang1 = exports.global:getLanguageName(lang1)
			local lang2 = getElementData(player, "character:language2")
			if (lang2 ~= 0) then lang2 = exports.global:getLanguageName(lang2) else lang2 = "None" end
			local lang3 = getElementData(player, "character:language3")
			if (lang3 ~= 0) then lang3 = exports.global:getLanguageName(lang3) else lang3 = "None" end

			local licenseTable = getElementData(player, "character:licenses"); licenseTable = split(licenseTable, ",")

			local carLicense, bikeLicense, boatLicense, helicopterLicense, planeLicense
			if tonumber(licenseTable[1]) == 1 then carLicense = "Yes" else carLicense = "No" end
			if tonumber(licenseTable[2]) == 1 then bikeLicense = "Yes" else bikeLicense = "No" end
			if tonumber(licenseTable[3]) == 1 then boatLicense = "Yes" else boatLicense = "No" end
			if tonumber(licenseTable[7]) == 1 then helicopterLicense = "Yes" else helicopterLicense = "No" end
			if tonumber(licenseTable[8]) == 1 then planeLicense = "Yes" else planeLicense = "No" end

			local licenseString = "            Character Licenses\n  • Car: " .. carLicense .. "\n  • Bike: " .. bikeLicense .. "\n  • Boat: " .. boatLicense
			local licenseString2 = "• Helicopter: " .. helicopterLicense .. "\n• Plane: " .. planeLicense

			local skillsTable = getElementData(player, "character:skills"); skillsTable = split(skillsTable, ",")
			for k, skill in ipairs(skillsTable) do
				skillsTable[k] = tonumber(skill) * 10
			end
			local inventoryMoney = getElementData(player, "character:money"); inventoryMoney = exports.global:formatNumber(inventoryMoney)
			local bankMoney = 0 -- @requires bank-system
			local inventoryCap = "0/60" -- @requires inventory-system
			local playerFactions = getElementData(player, "character:factions")
			local factionNames = {}
			for i, fac in ipairs(playerFactions) do
				if (fac ~= 0) then
					factionNames[i] = exports.global:getFactionName(fac)
				else
					factionNames[i] = "None."
				end
			end

			emGUI:dxSetText(assetsInfoLabels[2], "Character Languages\n  • Slot 1: " .. lang1 .. "\n  • Slot 2: ".. lang2 .. "\n  • Slot 3: ".. lang3)
			emGUI:dxSetText(assetsInfoLabels[3], licenseString)
			emGUI:dxSetText(assetsInfoLabels[4], licenseString2)
			emGUI:dxProgressBarSetProgress(assetsInfoProgressBars[1], skillsTable[1])
			emGUI:dxProgressBarSetProgress(assetsInfoProgressBars[2], skillsTable[2])
			emGUI:dxProgressBarSetProgress(assetsInfoProgressBars[3], skillsTable[3])
			emGUI:dxProgressBarSetProgress(assetsInfoProgressBars[4], skillsTable[4])
			emGUI:dxProgressBarSetProgress(assetsInfoProgressBars[5], skillsTable[5])
			emGUI:dxSetText(assetsInfoLabels[11], skillsTable[1] .. "%")
			emGUI:dxSetText(assetsInfoLabels[12], skillsTable[2] .. "%")
			emGUI:dxSetText(assetsInfoLabels[13], skillsTable[3] .. "%")
			emGUI:dxSetText(assetsInfoLabels[14], skillsTable[4] .. "%")
			emGUI:dxSetText(assetsInfoLabels[15], skillsTable[5] .. "%")
			emGUI:dxSetText(assetsInfoLabels[16], "Money (Inventory): $" .. inventoryMoney)
			emGUI:dxSetText(assetsInfoLabels[17], "Money (Bank): $" .. bankMoney)
			emGUI:dxSetText(assetsInfoLabels[18], "Inventory Capacity: " .. inventoryCap)
			emGUI:dxSetText(assetsInfoLabels[19], "Factions:\n  • Slot 1: " .. factionNames[1] .. "\n  • Slot 2: " .. factionNames[2] .. "\n  • Slot 3: " .. factionNames[3] .. "")
		else
			removeEventHandler("onClientRender", root, renderAssetsInfo)
			emGUI:dxCloseWindow(assetsInfoGUI)
		end
	else
		removeEventHandler("onClientRender", root, renderAssetsInfo)
		emGUI:dxCloseWindow(assetsInfoGUI)
	end
end

-----------------------------------------------------------------------------
function findAltsButtonClick(button, state)
	if (button == "left") and (state == "down") then
		triggerServerEvent("admin:findAlts", localPlayer, localPlayer, "findalts", player)
	end
end
