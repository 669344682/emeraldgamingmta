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

player = false

function drawReconPlayerGUI(thePlayer)
	if (thePlayer) then
		player = thePlayer
	else
		outputDebugString("[admin-system] @drawReconPlayerGUI: thePlayer not received or does not exist.", 3)
		return false
	end

	local guiState = emGUI:dxIsWindowVisible(reconPlayerGUI)
	if (guiState) then emGUI:dxCloseWindow(reconPlayerGUI) end

	reconPlayerLabels = {}

	reconPlayerGUI = emGUI:dxCreateWindow(0.26, 0.81, 0.49, 0.16, "", true, true, true, true, _, 0, _, tocolor(0, 0, 0, 100), _, tocolor(0, 0, 0, 100))

	reconPlayerLabels[1] = emGUI:dxCreateLabel(0.031, 0.17, 0.26, 0.11, "Player: (?) Unknown", true, reconPlayerGUI)
	reconPlayerLabels[2] = emGUI:dxCreateLabel(0.031, 0.28, 0.26, 0.11, "Health: 100HP", true, reconPlayerGUI)
	reconPlayerLabels[3] = emGUI:dxCreateLabel(0.03, 0.40, 0.26, 0.11, "Armour: 0%", true, reconPlayerGUI)
	reconPlayerLabels[4] = emGUI:dxCreateLabel(0.03, 0.51, 0.26, 0.11, "Weapon: Fists", true, reconPlayerGUI)
	reconPlayerLabels[5] = emGUI:dxCreateLabel(0.03, 0.62, 0.26, 0.11, "Dimension: 0", true, reconPlayerGUI)
	reconPlayerLabels[6] = emGUI:dxCreateLabel(0.03, 0.73, 0.26, 0.11, "Interior: 0", true, reconPlayerGUI)

	reconPlayerLabels[7] = emGUI:dxCreateLabel(0.30, 0.17, 0.26, 0.11, "Money (Inventory): $0", true, reconPlayerGUI)
	reconPlayerLabels[8] = emGUI:dxCreateLabel(0.30, 0.28, 0.26, 0.11, "Money (Bank): $0", true, reconPlayerGUI)
	reconPlayerLabels[9] = emGUI:dxCreateLabel(0.30, 0.40, 0.26, 0.11, "Inventory Capacity: 0/60", true, reconPlayerGUI)
	reconPlayerLabels[10] = emGUI:dxCreateLabel(0.30, 0.51, 0.26, 0.11, "Languages: English", true, reconPlayerGUI)
	reconPlayerLabels[11] = emGUI:dxCreateLabel(0.30, 0.62, 0.26, 0.11, "Location: Unknown", true, reconPlayerGUI)
	reconPlayerLabels[12] = emGUI:dxCreateLabel(0.30, 0.73, 0.26, 0.11, "Vehicle: None", true, reconPlayerGUI)
	
	reconPlayerLabels[13] = emGUI:dxCreateLabel(0.57, 0.17, 0.26, 0.11, "Factions: None", true, reconPlayerGUI)
	reconPlayerLabels[14] = emGUI:dxCreateLabel(0.57, 0.28, 0.26, 0.11, "Character Hours: 0 Hours", true, reconPlayerGUI)
	reconPlayerLabels[15] = emGUI:dxCreateLabel(0.57, 0.40, 0.26, 0.11, "Ping: 0ms", true, reconPlayerGUI)

	freezePlayerButton = emGUI:dxCreateButton(0.86, 0.16, 0.11, 0.30, "FREEZE", true, reconPlayerGUI)
	addEventHandler("onClientDgsDxMouseClick", freezePlayerButton, freezePlayerButtonClick)
	punishPlayerButton = emGUI:dxCreateButton(0.86, 0.57, 0.11, 0.30, "PUNISH", true, reconPlayerGUI)
	addEventHandler("onClientDgsDxMouseClick", punishPlayerButton, punishPlayerButtonClick)

	addEventHandler("onClientRender", root, reconGUIRender)
	addEventHandler("onClientDgsDxWindowClose", reconPlayerGUI, function()
		removeEventHandler("onClientRender", root, reconGUIRender)
	end)
end
addEvent("admin:showReconGUI", true)
addEventHandler("admin:showReconGUI", root, drawReconPlayerGUI)

function reconGUIRender()

	if (isElement(player)) then
		local loggedin = getElementData(player, "loggedin")
		if (loggedin == 1) then
			local ploggedin = getElementData(player, "loggedin")
			if (ploggedin == 1) then
				local thePlayerID = getElementData(player, "player:id")
				local thePlayerAccountName = getElementData(player, "account:username")
				local health = getElementHealth(player) or 100
				local armor = getPedArmor(player) or 0
				local weapon = getPedWeapon(player)
				if (weapon) then weapon = getWeaponNameFromID(weapon) else weapon = "Fists" end

				local dimension = getElementDimension(player)
				local interior = getElementDimension(player)

				local moneyOnHand = getElementData(player, "character:money") or 0; moneyOnHand = exports.global:formatNumber(moneyOnHand)
				local bankMoney = "0" -- @requires bank-system
				local inventoryCap = "0/60" -- @requires inventory-system

				local language1 = getElementData(player, "character:language") or 1
				local language1 = exports.global:getLanguageName(language1)
				local languageString = language1
				local language2 = getElementData(player, "character:language2") or nil
				if (language2 ~= 0) then
					language2 = exports.global:getLanguageName(language2)
					languageString = languageString .. ", " .. language2
				end
				local language3 = getElementData(player, "character:language3") or nil
				if (language3 ~= 0) then
					language3 = exports.global:getLanguageName(language3)
					languageString = languageString .. ", " .. language3 .. "."
				end

				local x, y, z = getElementPosition(player)
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
					vehicleString = "[" .. vehicleID .. "] " .. vehicleName .. " | HP: " .. string.format("%.0f", vehicleHealth) .. "/1000 | Seat: " .. getPedOccupiedVehicleSeat(player)
				end

				local factions = "None"
				local hours = getElementData(player, "character:hours") or 0
				local ping = getPlayerPing(player)

				emGUI:dxSetText(reconPlayerLabels[1], "Player: (" .. thePlayerID .. ") " .. thePlayerAccountName)
				emGUI:dxSetText(reconPlayerLabels[2], "Health: " .. string.format("%.0f", health) .. " HP")
				emGUI:dxSetText(reconPlayerLabels[3], "Armour: " .. string.format("%.0f", armor) .. "%") 
				emGUI:dxSetText(reconPlayerLabels[4], "Weapon: " .. weapon)
				emGUI:dxSetText(reconPlayerLabels[5], "Dimension: " .. dimension)
				emGUI:dxSetText(reconPlayerLabels[6], "Interior: " .. interior)
				emGUI:dxSetText(reconPlayerLabels[7], "Money (Inventory): $" .. moneyOnHand)
				emGUI:dxSetText(reconPlayerLabels[8], "Money (Bank): $" .. bankMoney)
				emGUI:dxSetText(reconPlayerLabels[9], "Inventory Capacity: " .. inventoryCap)
				emGUI:dxSetText(reconPlayerLabels[10], "Languages: " .. languageString)
				emGUI:dxSetText(reconPlayerLabels[11], "Location: " .. locationString)
				emGUI:dxSetText(reconPlayerLabels[12], "Vehicle: " .. vehicleString)
				emGUI:dxSetText(reconPlayerLabels[13], "Factions: " .. factions)
				emGUI:dxSetText(reconPlayerLabels[14], "Character Hours: " .. hours .. " Hours")
				emGUI:dxSetText(reconPlayerLabels[15], "Ping: " .. ping .. "ms")
			else
				removeEventHandler("onClientRender", root, reconGUIRender)
				local uiState = emGUI:dxIsWindowVisible(reconPlayerGUI)
				if uiState then emGUI:dxCloseWindow(reconPlayerGUI) end
			end
		else
			removeEventHandler("onClientRender", root, reconGUIRender)
		end
	else
		removeEventHandler("onClientRender", root, reconGUIRender)
	end
end

function c_stopReconning()
	removeEventHandler("onClientRender", root, reconGUIRender)
	emGUI:dxCloseWindow(reconPlayerGUI)
end
addEvent("admin:stopReconningGUI", true)
addEventHandler("admin:stopReconningGUI", root, c_stopReconning)

function freezePlayerButtonClick(button, state)
	if (button == "left") and (state == "down") then
		triggerServerEvent("admin:freezePlayer", localPlayer, localPlayer, "freeze", player)
	end
end

function punishPlayerButtonClick(button, state)
	if (button == "left") and (state == "down") then
		triggerEvent("admin:showPunishPlayerGUI", localPlayer)
	end
end