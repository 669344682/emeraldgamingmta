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

function playNudgeSound()
	local nudgesound = playSound("sounds/nudgeSound.mp3", false)
	setSoundVolume(nudgesound, 1)
	setWindowFlashing(true, 10)
end
addEvent("nudgeSoundFX", true)
addEventHandler("nudgeSoundFX", getRootElement(), playNudgeSound)

-- /devmode - by Skully (03/02/18) [Developer]
function setPlayerDevMode(thePlayer)
	if exports.global:isPlayerDeveloper(localPlayer) then
		local boolean = not getDevelopmentMode()
		setDevelopmentMode(boolean)
		
		if (boolean) then
			outputChatBox("You have enabled developer mode, useful commands:", 204, 102, 255)
			outputChatBox("- /showcol, /showsound", 204, 102, 255)
		else
			outputChatBox("You have disabled developer mode.", 204, 102, 255)
		end
	end
end
addCommandHandler("devmode", setPlayerDevMode)

-- /gotolist - by Zil (07/07/18) [Helper]
function showGotoList()
	if (exports.global:isPlayerHelper(localPlayer)) then
		if (emGUI:dxIsWindowVisible(gotoListWindow)) then emGUI:dxCloseWindow(gotoListWindow) end

		gotoListWindow = emGUI:dxCreateWindow(0.39, 0.24, 0.22, 0.52, "Teleportation Locations", true)
		gotoListGrid = emGUI:dxCreateGridList(0.02, 0.02, 0.96, 0.885, true, gotoListWindow)
		closeDeleteButton = emGUI:dxCreateButton(0.27, 0.91, 0.45, 0.07, "CLOSE", true, gotoListWindow)
		addEventHandler("onClientDgsDxMouseClick", closeDeleteButton, closeDelete)

		emGUI:dxGridListAddColumn(gotoListGrid, "ID", 0.1)
		emGUI:dxGridListAddColumn(gotoListGrid, "Name", 0.6)
		emGUI:dxGridListAddColumn(gotoListGrid, "Command", 0.2)
		emGUI:dxWindowSetSizable(gotoListWindow, false)

		triggerServerEvent("admin:getGotoLocations", localPlayer, localPlayer)
		addEventHandler("onClientDgsDxMouseDoubleClick", gotoListGrid, selectedGoto, false)

		addEventHandler("onClientDgsDxMouseClick", gotoListGrid, function(button, state)
			if (button == "left") and (state == "up") and (exports.global:isPlayerLeadAdmin(localPlayer)) then
				local selectedRow, selectedCol = emGUI:dxGridListGetSelectedItem(gotoListGrid)

				if (selectedRow) and (selectedCol) and (selectedRow ~= -1) and (selectedCol ~= -1) then emGUI:dxSetText(closeDeleteButton, "Delete")
				else emGUI:dxSetText(closeDeleteButton, "CLOSE") end
			end
		end)
	end
end
addCommandHandler("gotolist", showGotoList)

function closeDelete(button, state)
	if (button == "left") and (state == "up") then
		if (emGUI:dxGetText(closeDeleteButton) == "CLOSE") then emGUI:dxCloseWindow(gotoListWindow) return end
		local selectedRow, selectedCol = emGUI:dxGridListGetSelectedItem(gotoListGrid)

		if (selectedRow ~= -1) and (selectedCol ~= -1) then
			local id = tonumber(emGUI:dxGridListGetItemText(gotoListGrid, selectedRow, 1))

			triggerServerEvent("admin:deleteGoto", localPlayer, id)
			emGUI:dxGridListRemoveRow(gotoListGrid, selectedRow)
			emGUI:dxSetText(closeDeleteButton, "CLOSE")
		end
	end
end

gotoLocations = {} -- (id) element is the location as a string, needs to be split 
function populateGotoList(gotoLocationsTable)
	if not (gotoLocations) then
		outputChatBox("ERROR: Something went wrong whilst receiving goto locations!", 255, 0, 0, localPlayer)
		return false 
	end

	local rows = {}
	for i, gotoLocation in pairs(gotoLocationsTable) do
		gotoLocations[gotoLocation["id"]] = gotoLocation["location"]

		local row = emGUI:dxGridListAddRow(gotoListGrid) 
		emGUI:dxGridListSetItemText(gotoListGrid, row, 1, gotoLocation["id"])
		emGUI:dxGridListSetItemText(gotoListGrid, row, 2, gotoLocation["location_name"])
		emGUI:dxGridListSetItemText(gotoListGrid, row, 3, gotoLocation["command"])
	end
end
addEvent("admin:populateGotoList", true)
addEventHandler("admin:populateGotoList", root, populateGotoList)

function selectedGoto(button, state)
	if (button == "left") and (state == "down") then
		local selectedRow, selectedCol = emGUI:dxGridListGetSelectedItem(gotoListGrid)

		if (selectedRow) and (selectedCol) and (selectedRow ~= -1) and (selectedCol ~= -1) then
			local command = emGUI:dxGridListGetItemText(gotoListGrid, selectedRow, 3)

			if (command) then
				triggerServerEvent("admin:gotoPlace", localPlayer, localPlayer, "gotoplace", command)
			end
		end
	end
end