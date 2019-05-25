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
|    /| | | | |    |  __||  __/| |    |  _  |\ /          Created by
| |\ \\ \_/ / |____| |___| |   | |____| | | || |            Skully
\_| \_|\___/\_____/\____/\_|   \_____/\_| |_/\_/

Copyright of the Emerald Gaming Development Team, do not distribute - All rights reserved. ]]

emGUI = exports.emGUI

function showRankAdjuster(staffRank, vtRank, mtRank, ftRank)
	if emGUI:dxIsWindowVisible(editRankWindow) then emGUI:dxCloseWindow(editRankWindow) return end
	local labels = {}

	if (staffRank > 5) then staffRank = 5 end

	editRankWindow = emGUI:dxCreateWindow(0.41, 0.28, 0.18, 0.40, "Adjust Ranks", true)

	labels[1] = emGUI:dxCreateLabel(0.21, 0.07, 0.17, 0.04, "Staff Rank", true, editRankWindow)
	labels[2] = emGUI:dxCreateLabel(0.21, 0.25, 0.30, 0.04, "Vehicle Team Rank", true, editRankWindow)
	labels[3] = emGUI:dxCreateLabel(0.21, 0.43, 0.33, 0.04, "Mapping Team Rank", true, editRankWindow)
	labels[4] = emGUI:dxCreateLabel(0.21, 0.60, 0.33, 0.04, "Faction Team Rank", true, editRankWindow)
	
	staffRanksCombobox = emGUI:dxCreateComboBox(0.21, 0.13, 0.59, 0.06, true, editRankWindow)
	emGUI:dxComboBoxAddItem(staffRanksCombobox, "Player")
	emGUI:dxComboBoxAddItem(staffRanksCombobox, "Helper")
	emGUI:dxComboBoxAddItem(staffRanksCombobox, "Trial Administrator")
	emGUI:dxComboBoxAddItem(staffRanksCombobox, "Administrator")
	emGUI:dxComboBoxAddItem(staffRanksCombobox, "Lead Administrator")
	emGUI:dxComboBoxAddItem(staffRanksCombobox, "Manager")
	emGUI:dxComboBoxSetSelectedItem(staffRanksCombobox, staffRank + 1)

	vehicleTeamCombo = emGUI:dxCreateComboBox(0.21, 0.31, 0.59, 0.06, true, editRankWindow)
	emGUI:dxComboBoxAddItem(vehicleTeamCombo, "None")
	emGUI:dxComboBoxAddItem(vehicleTeamCombo, "Vehicle Team Member")
	emGUI:dxComboBoxAddItem(vehicleTeamCombo, "Vehicle Team Leader")
	emGUI:dxComboBoxSetSelectedItem(vehicleTeamCombo, vtRank + 1)

	mappingTeamCombo = emGUI:dxCreateComboBox(0.21, 0.49, 0.59, 0.06, true, editRankWindow)
	emGUI:dxComboBoxAddItem(mappingTeamCombo, "None")
	emGUI:dxComboBoxAddItem(mappingTeamCombo, "Mapping Team Member")
	emGUI:dxComboBoxAddItem(mappingTeamCombo, "Mapping Team Leader")
	emGUI:dxComboBoxSetSelectedItem(mappingTeamCombo, mtRank + 1)

	factionTeamCombo = emGUI:dxCreateComboBox(0.21, 0.66, 0.59, 0.06, true, editRankWindow)
	emGUI:dxComboBoxAddItem(factionTeamCombo, "None")
	emGUI:dxComboBoxAddItem(factionTeamCombo, "Faction Team Member")
	emGUI:dxComboBoxAddItem(factionTeamCombo, "Faction Team Leader")
	emGUI:dxComboBoxSetSelectedItem(factionTeamCombo, ftRank + 1)

	applyChangesButton = emGUI:dxCreateButton(0.21, 0.80, 0.59, 0.14, "Apply Changes", true, editRankWindow)
	addEventHandler("onClientDgsDxMouseClick", applyChangesButton, applyChangesButtonClick)
end
addEvent("alpha:adjustRanks", true)
addEventHandler("alpha:adjustRanks", root, showRankAdjuster)

function applyChangesButtonClick(b, c)
	if (b == "left") and (c == "down") then
		local selectedStaff = emGUI:dxComboBoxGetSelectedItem(staffRanksCombobox) - 1
		local selectedVt = emGUI:dxComboBoxGetSelectedItem(vehicleTeamCombo) - 1
		local selectedMt = emGUI:dxComboBoxGetSelectedItem(mappingTeamCombo) - 1
		local selectedFt = emGUI:dxComboBoxGetSelectedItem(factionTeamCombo) - 1

		triggerServerEvent("alpha:updateRanks", localPlayer, selectedStaff, selectedVt, selectedMt, selectedFt)
		emGUI:dxCloseWindow(editRankWindow)
	end
end