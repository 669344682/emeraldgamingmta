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

playerFound = false

function showMakeGun()
	local loggedin = getElementData(localPlayer, "loggedin")
	if (loggedin == 1) then
		if exports.global:isPlayerTrialAdmin(localPlayer) then
			local guiState = emGUI:dxIsWindowVisible(makeGunWindow)
			if not (guiState) then
				triggerEvent("showCreateGunGui", getRootElement())
			else
				emGUI:dxCloseWindow(makeGunWindow)
			end
		end
	end
end
addCommandHandler("makegun", showMakeGun)
addEvent("showMakeGun", true)

addEvent("showCreateGunGui", true)
addEventHandler("showCreateGunGui", resourceRoot,
function()
	local createGunLabels = {}
	
	makeGunWindow = emGUI:dxCreateWindow(0.27, 0.28, 0.47, 0.45, "Weapon Creator", true)
	emGUI:dxWindowSetSizable(makeGunWindow, false)

	createGunList = emGUI:dxCreateGridList(0.01, 0.05, 0.69, 0.92, true, makeGunWindow)
	emGUI:dxGridListAddColumn(createGunList, "ID", 0.06)
	emGUI:dxGridListAddColumn(createGunList, "Type", 0.4)
	emGUI:dxGridListAddColumn(createGunList, "Weapon", 0.45)

	for i = 1, 25 do
		emGUI:dxGridListAddRow(createGunList)
	end

	emGUI:dxSetProperty(createGunList,"mode", true) -- Temp fix for rendering since second column font appears terribly.
	emGUI:dxGridListSetItemText(createGunList, 25, 1, "35", false, false)
	emGUI:dxGridListSetItemText(createGunList, 25, 2, "Heavy Weapons", false, false)
	emGUI:dxGridListSetItemText(createGunList, 25, 3, "Rocket Launcher", false, false)
	emGUI:dxGridListSetItemText(createGunList, 24, 1, "34", false, false)
	emGUI:dxGridListSetItemText(createGunList, 24, 2, "Rifle", false, false)
	emGUI:dxGridListSetItemText(createGunList, 24, 3, "Sniper", false, false)
	emGUI:dxGridListSetItemText(createGunList, 23, 1, "33", false, false)
	emGUI:dxGridListSetItemText(createGunList, 23, 2, "Rifle", false, false)
	emGUI:dxGridListSetItemText(createGunList, 23, 3, "Rifle", false, false)
	emGUI:dxGridListSetItemText(createGunList, 22, 1, "31", false, false)
	emGUI:dxGridListSetItemText(createGunList, 22, 2, "Assault Rifle", false, false)
	emGUI:dxGridListSetItemText(createGunList, 22, 3, "M4", false, false)
	emGUI:dxGridListSetItemText(createGunList, 21, 1, "30", false, false)
	emGUI:dxGridListSetItemText(createGunList, 21, 2, "Assault Rifle", false, false)
	emGUI:dxGridListSetItemText(createGunList, 21, 3, "AK-47", false, false)
	emGUI:dxGridListSetItemText(createGunList, 20, 1, "32", false, false)
	emGUI:dxGridListSetItemText(createGunList, 20, 2, "Sub-Machine Gun", false, false)
	emGUI:dxGridListSetItemText(createGunList, 20, 3, "Tec-9", false, false)
	emGUI:dxGridListSetItemText(createGunList, 19, 1, "29", false, false)
	emGUI:dxGridListSetItemText(createGunList, 19, 2, "Sub-Machine Gun", false, false)
	emGUI:dxGridListSetItemText(createGunList, 19, 3, "MP5", false, false)
	emGUI:dxGridListSetItemText(createGunList, 18, 1, "28", false, false)
	emGUI:dxGridListSetItemText(createGunList, 18, 2, "Sub-Machine Gun", false, false)
	emGUI:dxGridListSetItemText(createGunList, 18, 3, "Uzi", false, false)
	emGUI:dxGridListSetItemText(createGunList, 17, 1, "27", false, false)
	emGUI:dxGridListSetItemText(createGunList, 17, 2, "Shotgun", false, false)
	emGUI:dxGridListSetItemText(createGunList, 17, 3, "Combat Shotgun", false, false)
	emGUI:dxGridListSetItemText(createGunList, 16, 1, "26", false, false)
	emGUI:dxGridListSetItemText(createGunList, 16, 2, "Shotgun", false, false)
	emGUI:dxGridListSetItemText(createGunList, 16, 3, "Sawed-off", false, false)
	emGUI:dxGridListSetItemText(createGunList, 15, 1, "25", false, false)
	emGUI:dxGridListSetItemText(createGunList, 15, 2, "Shotgun", false, false)
	emGUI:dxGridListSetItemText(createGunList, 15, 3, "Shotgun", false, false)
	emGUI:dxGridListSetItemText(createGunList, 14, 1, "24", false, false)
	emGUI:dxGridListSetItemText(createGunList, 14, 2, "Handgun", false, false)
	emGUI:dxGridListSetItemText(createGunList, 14, 3, "Deagle", false, false)
	emGUI:dxGridListSetItemText(createGunList, 13, 1, "23", false, false)
	emGUI:dxGridListSetItemText(createGunList, 13, 2, "Handgun", false, false)
	emGUI:dxGridListSetItemText(createGunList, 13, 3, "Silenced", false, false)
	emGUI:dxGridListSetItemText(createGunList, 12, 1, "22", false, false)
	emGUI:dxGridListSetItemText(createGunList, 12, 2, "Handgun", false, false)
	emGUI:dxGridListSetItemText(createGunList, 12, 3, "Colt 45", false, false)
	emGUI:dxGridListSetItemText(createGunList, 11, 1, "17", false, false)
	emGUI:dxGridListSetItemText(createGunList, 11, 2, "Projectiles", false, false)
	emGUI:dxGridListSetItemText(createGunList, 11, 3, "Molotov", false, false)
	emGUI:dxGridListSetItemText(createGunList, 10, 1, "16", false, false)
	emGUI:dxGridListSetItemText(createGunList, 10, 2, "Projectiles", false, false)
	emGUI:dxGridListSetItemText(createGunList, 10, 3, "Grenade", false, false)
	emGUI:dxGridListSetItemText(createGunList, 9, 1, "9", false, false)
	emGUI:dxGridListSetItemText(createGunList, 9, 2, "Melee", false, false)
	emGUI:dxGridListSetItemText(createGunList, 9, 3, "Chainsaw", false, false)
	emGUI:dxGridListSetItemText(createGunList, 8, 1, "8", false, false)
	emGUI:dxGridListSetItemText(createGunList, 8, 2, "Melee", false, false)
	emGUI:dxGridListSetItemText(createGunList, 8, 3, "Katana", false, false)
	emGUI:dxGridListSetItemText(createGunList, 7, 1, "7", false, false)
	emGUI:dxGridListSetItemText(createGunList, 7, 2, "Melee", false, false)
	emGUI:dxGridListSetItemText(createGunList, 7, 3, "Pool Stick", false, false)
	emGUI:dxGridListSetItemText(createGunList, 6, 1, "6", false, false)
	emGUI:dxGridListSetItemText(createGunList, 6, 2, "Melee", false, false)
	emGUI:dxGridListSetItemText(createGunList, 6, 3, "Shovel", false, false)
	emGUI:dxGridListSetItemText(createGunList, 5, 1, "5", false, false)
	emGUI:dxGridListSetItemText(createGunList, 5, 2, "Melee", false, false)
	emGUI:dxGridListSetItemText(createGunList, 5, 3, "Bat", false, false)
	emGUI:dxGridListSetItemText(createGunList, 4, 1, "4", false, false)
	emGUI:dxGridListSetItemText(createGunList, 4, 2, "Melee", false, false)
	emGUI:dxGridListSetItemText(createGunList, 4, 3, "Knife", false, false)
	emGUI:dxGridListSetItemText(createGunList, 3, 1, "3", false, false)
	emGUI:dxGridListSetItemText(createGunList, 3, 2, "Melee", false, false)
	emGUI:dxGridListSetItemText(createGunList, 3, 3, "Nightstick", false, false)
	emGUI:dxGridListSetItemText(createGunList, 2, 1, "2", false, false)
	emGUI:dxGridListSetItemText(createGunList, 2, 2, "Melee", false, false)
	emGUI:dxGridListSetItemText(createGunList, 2, 3, "Golf Club", false, false)
	emGUI:dxGridListSetItemText(createGunList, 1, 1, "1", false, false)
	emGUI:dxGridListSetItemText(createGunList, 1, 2, "Hand", false, false)
	emGUI:dxGridListSetItemText(createGunList, 1, 3, "Brass Knuckle", false, false)

	targetPlayer_input = emGUI:dxCreateEdit(0.71, 0.36, 0.27, 0.06, "", true, makeGunWindow)
	rounds_input = emGUI:dxCreateEdit(0.93, 0.50, 0.05, 0.07, "", true, makeGunWindow)
	mags_input = emGUI:dxCreateEdit(0.72, 0.50, 0.05, 0.07, "", true, makeGunWindow)

	createGunLabels[1] = emGUI:dxCreateLabel(0.79, 0.30, 0.12, 0.04, "Player To Give", true, makeGunWindow)
	createGunLabels[2] = emGUI:dxCreateLabel(0.93, 0.44, 0.04, 0.03, "Rounds", true, makeGunWindow)
	createGunLabels[3] = emGUI:dxCreateLabel(0.725, 0.44, 0.03, 0.03, "Mags", true, makeGunWindow)

	feedbackLabel = emGUI:dxCreateLabel(0.79, 0.62, 0.12, 0.04, "", true, makeGunWindow) -- Says if the player is found or not.
	emGUI:dxLabelSetHorizontalAlign(feedbackLabel, "center")
	addEventHandler("onClientDgsDxGUITextChange", targetPlayer_input, updatePlayerFoundLabel)

	spawn_button = emGUI:dxCreateButton(0.79, 0.89, 0.13, 0.06, "Spawn", true, makeGunWindow)
	addEventHandler("onClientDgsDxMouseClick", spawn_button, spawnGunButtonClick)
end)

playerFound = false
function spawnGunButtonClick(button, state)
	if (button == "left") and (state == "down") then
		if (playerFound) then
			local targetPlayer = playerFound
			local selection = emGUI:dxGridListGetSelectedItem(createGunList)

			if not (selection) or (selection == -1) then
				emGUI:dxSetText(feedbackLabel, "Select a weapon!")
				emGUI:dxLabelSetColor(feedbackLabel, 255, 0, 0)
				return false
			end
			local id = emGUI:dxGridListGetItemText(createGunList, selection, 1); id = tonumber(id)
			local mags = emGUI:dxGetText(mags_input)
			local rounds = emGUI:dxGetText(rounds_input)

			if (id ~= nil) and (id > 0) then -- Make sure the admin selected something & check if we have a target player.
				if (mags == "") or not tonumber(mags) or (mags == nil) then
					local mags = 0
				end
				if (rounds == "") or not tonumber(rounds) or (mags == nil) then
					emGUI:dxSetText(feedbackLabel, "Input some rounds!")
					emGUI:dxLabelSetColor(feedbackLabel, 255, 0, 0)
					return false
				end

				triggerServerEvent("spawnWeapon", localPlayer, localPlayer, targetPlayer, id, mags, rounds)
			else
				emGUI:dxSetText(feedbackLabel, "Select a weapon!")
				emGUI:dxLabelSetColor(feedbackLabel, 255, 0, 0)
			end
		else
			emGUI:dxSetText(feedbackLabel, "Input a player!")
			emGUI:dxLabelSetColor(feedbackLabel, 255, 0, 0)
		end
	end
end

function updatePlayerFoundLabel()
	local targetInputValue = emGUI:dxGetText(targetPlayer_input)
	local targetPlayer, targetPlayerName = exports.global:getPlayerFromPartialNameOrID(targetInputValue, localPlayer)

	if (targetPlayer) then
		emGUI:dxSetText(feedbackLabel, "Player " .. targetPlayerName .. " found!")
		emGUI:dxLabelSetColor(feedbackLabel, 0, 255, 0)
		playerFound = targetPlayer
	else
		emGUI:dxSetText(feedbackLabel, "Player not found.")
		emGUI:dxLabelSetColor(feedbackLabel, 255, 0, 0)
		playerFound = false
	end
end