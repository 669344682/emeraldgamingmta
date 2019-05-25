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

function createNewVehicle()
	if (emGUI:dxIsWindowVisible(createVehGUI)) then emGUI:dxCloseWindow(createVehGUI) return end
	if exports.global:isPlayerTrialAdmin(localPlayer) or exports.global:isPlayerVehicleTeamLeader(localPlayer) then

		local createVehGUILabels = {}
		createVehGUI = emGUI:dxCreateWindow(0.40, 0.34, 0.20, 0.35, "Create Vehicle", true)

		createVehGUILabels[1] = emGUI:dxCreateLabel(0.07, 0.09, 0.15, 0.04, "Vehicle ID", true, createVehGUI)
		createVehGUILabels[2] = emGUI:dxCreateLabel(0.07, 0.29, 0.23, 0.05, "Player Name/ID:", true, createVehGUI)
		createVehGUILabels[3] = emGUI:dxCreateLabel(0.18, 0.45, 0.15, 0.05, "Faction ID:", true, createVehGUI)
		createVehGUILabels[4] = emGUI:dxCreateLabel(0.17, 0.575, 0.13, 0.05, "Colours:", true, createVehGUI)
		createVehGUILabels[5] = emGUI:dxCreateLabel(0.36, 0.655, 0.13, 0.05, "R          G          B", true, createVehGUI)
		vehFeedbackLabel = emGUI:dxCreateLabel(0.24, 0.715, 0.51, 0.04, "", true, createVehGUI)
		emGUI:dxLabelSetColor(vehFeedbackLabel, 255, 0, 0)
		emGUI:dxLabelSetHorizontalAlign(vehFeedbackLabel, "center")

		isFactionCheckbox = emGUI:dxCreateCheckBox(0.07, 0.38, 0.34, 0.04, "Spawn to faction?", false, true, createVehGUI)

		vehicleIDInput = emGUI:dxCreateEdit(0.07, 0.15, 0.30, 0.06, "", true, createVehGUI)
		playerInput = emGUI:dxCreateEdit(0.38, 0.285, 0.49, 0.06, "", true, createVehGUI)
		addEventHandler("onDgsTextChange", playerInput, updatePlayerFoundLabel)

		factionIDInput = emGUI:dxCreateEdit(0.38, 0.45, 0.49, 0.06, "", true, createVehGUI)
		emGUI:dxSetEnabled(factionIDInput, false)
		colorRInput = emGUI:dxCreateEdit(0.33, 0.56, 0.10, 0.09, "", true, createVehGUI)
		colorGInput = emGUI:dxCreateEdit(0.45, 0.56, 0.10, 0.09, "", true, createVehGUI)
		colorBInput = emGUI:dxCreateEdit(0.58, 0.56, 0.10, 0.09, "", true, createVehGUI)
		emGUI:dxEditSetMaxLength(colorRInput, 3)
		emGUI:dxEditSetMaxLength(colorGInput, 3)
		emGUI:dxEditSetMaxLength(colorBInput, 3)
		emGUI:dxEditSetMaxLength(vehicleIDInput, 3)
		emGUI:dxEditSetMaxLength(factionIDInput, 3)

		addEventHandler("onDgsCheckBoxChange", isFactionCheckbox, function(state)
			if (state) then
				emGUI:dxSetEnabled(playerInput, false)
				emGUI:dxSetEnabled(factionIDInput, true)
			else
				emGUI:dxSetEnabled(playerInput, true)
				emGUI:dxSetEnabled(factionIDInput, false)
			end
		end)
		
		vehlistButton = emGUI:dxCreateButton(0.45, 0.09, 0.42, 0.15, "Vehicle Library", true, createVehGUI)
		addEventHandler("onClientDgsDxMouseClick", vehlistButton, vehlistButtonClick)
		
		createVehButton = emGUI:dxCreateButton(0.29, 0.78, 0.43, 0.17, "Create", true, createVehGUI)
		addEventHandler("onClientDgsDxMouseClick", createVehButton, createVehButtonClick)
	end
end
addCommandHandler("createveh", createNewVehicle)

function setFeedbackLabel(text, r, g, b)
	if not (r) or not (g) or not (b) then r, g, b = 255, 0, 0 end

	emGUI:dxSetText(vehFeedbackLabel, text)
	emGUI:dxLabelSetColor(vehFeedbackLabel, r, g, b)
end
addEvent("vehicle:updatevehcrefeedbacklabel", true)
addEventHandler("vehicle:updatevehcrefeedbacklabel", root, setFeedbackLabel)

function closeCreateVehGUI() if (emGUI:dxIsWindowVisible(createVehGUI)) then emGUI:dxCloseWindow(createVehGUI) return true end end
addEvent("vehicle:closecreatevehgui", true)
addEventHandler("vehicle:closecreatevehgui", root, closeCreateVehGUI)

playerFound = false
function updatePlayerFoundLabel(input)
	local targetPlayer, targetPlayerName = exports.global:getPlayerFromPartialNameOrID(input, localPlayer)

	if (targetPlayer) then
		local targAccountName = getElementData(targetPlayer, "account:username")
		setFeedbackLabel("Player " .. targetPlayerName .. " (" .. targAccountName .. ") found!", 0, 255, 0)
		playerFound = targetPlayer
	else
		setFeedbackLabel("Player not found.")
		playerFound = false
	end
end

function vehlistButtonClick(button, state)
	if (button == "left") and (state == "down") then
		triggerServerEvent("vehicle:s_showvehlist", localPlayer, localPlayer)
	end
end

function createVehButtonClick(button, state)
	if (button == "left") and (state == "down") then
		local vehID = emGUI:dxGetText(vehicleIDInput)
		if not tonumber(vehID) then
			setFeedbackLabel("That is not a valid vehicle ID.")
			return false
		end

		local isFaction = emGUI:dxCheckBoxGetSelected(isFactionCheckbox)
		local spawnTo = false
		if (isFaction) then
			local factionID = emGUI:dxGetText(factionIDInput)
			if not tonumber(factionID) then
				setFeedbackLabel("Please enter a valid faction ID.")
				return false
			else
				spawnTo = factionID
			end
		else
			if not playerFound then
				setFeedbackLabel("Please enter a player to spawn the vehicle to.")
				return false
			else
				spawnTo = playerFound
			end
		end

		local r, g, b = emGUI:dxGetText(colorRInput), emGUI:dxGetText(colorGInput), emGUI:dxGetText(colorBInput)
		if not tonumber(r) or not tonumber(g) or not tonumber(b) then
			r, g, b = 0, 0, 0
		end

		if (spawnTo) then
			triggerServerEvent("vehicle:createnewvehicle", localPlayer, localPlayer, vehID, isFaction, spawnTo, r, g, b)
		end
		playerFound = false
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------

function showVehicleMasterlist(vehicleData, createdBy, vehicleNames, characterNames)
	if not (vehicleData) or not (vehicleNames) or not (characterNames) then exports.global:outputDebug("@showVehicleMasterlist: All required vehicle data tables were not received.") return false end
	if (emGUI:dxIsWindowVisible(allVehiclesGUI)) then emGUI:dxCloseWindow(allVehiclesGUI) return end

	local allVehiclesGUILabels = {}
	allVehiclesGUI = emGUI:dxCreateWindow(0.19, 0.19, 0.62, 0.62, "Vehicle Database", true)

	allVehiclesGUILabels[1] = emGUI:dxCreateLabel(0.045, 0.043, 0.13, 0.02, "Search (Vehicle Name/ID):", true, allVehiclesGUI)
	allVehiclesGUILabels[2] = emGUI:dxCreateLabel(0.103, 0.093, 0.08, 0.02, "Search (Owner):", true, allVehiclesGUI)
	searchVehNameInput = emGUI:dxCreateEdit(0.2, 0.04, 0.20, 0.04, "", true, allVehiclesGUI)
	searchOwnerInput = emGUI:dxCreateEdit(0.2, 0.09, 0.20, 0.04, "", true, allVehiclesGUI)
	
	if exports.global:isPlayerManager(localPlayer, true) then
		removeVehicleButton = emGUI:dxCreateButton(0.43, 0.04, 0.16, 0.09, "Remove Vehicle", true, allVehiclesGUI)
		addEventHandler("onClientDgsDxMouseClick", removeVehicleButton, removeVehicleButtonClick)
	end

	if exports.global:isPlayerLeadAdmin(localPlayer, true) then
		restoreVehicleButton = emGUI:dxCreateButton(0.63, 0.04, 0.16, 0.09, "Restore Vehicle", true, allVehiclesGUI)
		addEventHandler("onClientDgsDxMouseClick", restoreVehicleButton, restoreVehicleButtonClick)
	end

	deleteVehicleButton = emGUI:dxCreateButton(0.83, 0.04, 0.16, 0.09, "Delete Vehicle", true, allVehiclesGUI)
	addEventHandler("onClientDgsDxMouseClick", deleteVehicleButton, deleteVehicleButtonClick)
	
	vehicleListGridlist = emGUI:dxCreateGridList(0.01, 0.16, 0.98, 0.82, true, allVehiclesGUI)
	emGUI:dxGridListAddColumn(vehicleListGridlist, "ID", 0.034)
	emGUI:dxGridListAddColumn(vehicleListGridlist, "Model", 0.035)
	emGUI:dxGridListAddColumn(vehicleListGridlist, "Vehicle", 0.25)
	emGUI:dxGridListAddColumn(vehicleListGridlist, "Dimension", 0.06)
	emGUI:dxGridListAddColumn(vehicleListGridlist, "Interior", 0.05)
	emGUI:dxGridListAddColumn(vehicleListGridlist, "Health", 0.04)
	emGUI:dxGridListAddColumn(vehicleListGridlist, "Owner", 0.12)
	emGUI:dxGridListAddColumn(vehicleListGridlist, "Impounded", 0.065)
	emGUI:dxGridListAddColumn(vehicleListGridlist, "Odometer", 0.06)
	emGUI:dxGridListAddColumn(vehicleListGridlist, "Deleted", 0.05)
	emGUI:dxGridListAddColumn(vehicleListGridlist, "Stolen", 0.04)
	emGUI:dxGridListAddColumn(vehicleListGridlist, "Chopped", 0.05)
	emGUI:dxGridListAddColumn(vehicleListGridlist, "Created", 0.13)
	emGUI:dxGridListAddColumn(vehicleListGridlist, "Created By", 0.1)
	emGUI:dxGridListAddColumn(vehicleListGridlist, "Last Updated", 0.13)
	emGUI:dxGridListAddColumn(vehicleListGridlist, "Damage Proof", 0.08)
	emGUI:dxGridListAddColumn(vehicleListGridlist, "Job Vehicle", 0.06)

	for i, vehicle in ipairs(vehicleData) do
		emGUI:dxGridListAddRow(vehicleListGridlist)
		emGUI:dxGridListSetItemText(vehicleListGridlist, i, 1, vehicle.id)
		emGUI:dxGridListSetItemText(vehicleListGridlist, i, 2, vehicle.model)
		emGUI:dxGridListSetItemText(vehicleListGridlist, i, 3, vehicleNames[i])
		emGUI:dxGridListSetItemText(vehicleListGridlist, i, 4, vehicle.dimension)
		emGUI:dxGridListSetItemText(vehicleListGridlist, i, 5, vehicle.interior)
		emGUI:dxGridListSetItemText(vehicleListGridlist, i, 6, vehicle.hp)
		emGUI:dxGridListSetItemText(vehicleListGridlist, i, 7, characterNames[i])
		
		local isImpounded = "No"
		if (vehicle.impounded == 1) then isImpounded = "Yes" end
		emGUI:dxGridListSetItemText(vehicleListGridlist, i, 8, isImpounded)

		emGUI:dxGridListSetItemText(vehicleListGridlist, i, 9, vehicle.odometer)

		local isDeleted = "No"
		if (vehicle.deleted == 1) then isDeleted = "Yes" end
		emGUI:dxGridListSetItemText(vehicleListGridlist, i, 10, isDeleted)

		local isStolen = "No"
		local isChopped = "No"
		local statesTable = split(vehicle.state, ",")
		if (tonumber(statesTable[1]) == 1) then isStolen = "Yes" end
		if (tonumber(statesTable[2]) == 1) then isChopped = "Yes" end
		emGUI:dxGridListSetItemText(vehicleListGridlist, i, 11, isStolen)
		emGUI:dxGridListSetItemText(vehicleListGridlist, i, 12, isChopped)

		local createdTime = exports.global:convertTime(vehicle.created_date)
		emGUI:dxGridListSetItemText(vehicleListGridlist, i, 13, createdTime[2] .. " at " .. createdTime[1])

		emGUI:dxGridListSetItemText(vehicleListGridlist, i, 14, createdBy[i])

		local lastUpdated = exports.global:convertTime(vehicle.last_used)
		emGUI:dxGridListSetItemText(vehicleListGridlist, i, 15, lastUpdated[2] .. " at " .. lastUpdated[1])

		local isDamageProof = "No"
		if (vehicle.damageproof == 1) then isDamageProof = "Yes" end
		emGUI:dxGridListSetItemText(vehicleListGridlist, i, 16, isDamageProof)

		local isJobVehicle = "No"
		if (vehicle.job ~= 0) then isJobVehicle = "Yes" end
		emGUI:dxGridListSetItemText(vehicleListGridlist, i, 17, isJobVehicle)
	end

	addEventHandler("ondxGridListItemDoubleClick", vehicleListGridlist, function(b, s, id)
		if b == "left" and s == "down" and (id) then
			triggerServerEvent("vehicle:checkvehcall", localPlayer, localPlayer, "checkveh", id)
		end
	end)

	-- Vehicle Name/ID search.
	addEventHandler("onDgsTextChange", searchVehNameInput, function(newText)
		if (#newText ~= 0) then emGUI:dxSetEnabled(searchOwnerInput, false) else emGUI:dxSetEnabled(searchOwnerInput, true) end
		emGUI:dxGridListClearRow(vehicleListGridlist)
		for v, vehicle in pairs(vehicleData) do
			if vehicleNames[v]:lower():find(newText:lower()) or tostring(vehicle.id):find(newText) then
				local row = emGUI:dxGridListAddRow(vehicleListGridlist)
				emGUI:dxGridListSetItemText(vehicleListGridlist, row, 1, vehicle.id)
				emGUI:dxGridListSetItemText(vehicleListGridlist, row, 2, vehicle.model)
				emGUI:dxGridListSetItemText(vehicleListGridlist, row, 3, vehicleNames[v])
				emGUI:dxGridListSetItemText(vehicleListGridlist, row, 4, vehicle.dimension)
				emGUI:dxGridListSetItemText(vehicleListGridlist, row, 5, vehicle.interior)
				emGUI:dxGridListSetItemText(vehicleListGridlist, row, 6, vehicle.hp)
				emGUI:dxGridListSetItemText(vehicleListGridlist, row, 7, characterNames[v])
				
				local isImpounded = "No"
				if (vehicle.impounded == 1) then isImpounded = "Yes" end
				emGUI:dxGridListSetItemText(vehicleListGridlist, row, 8, isImpounded)
	
				emGUI:dxGridListSetItemText(vehicleListGridlist, row, 9, vehicle.odometer)
	
				local isDeleted = "No"
				if (vehicle.deleted == 1) then isDeleted = "Yes" end
				emGUI:dxGridListSetItemText(vehicleListGridlist, row, 10, isDeleted)
	
				local isStolen = "No"
				local isChopped = "No"
				local statesTable = split(vehicle.state, ",")
				if (tonumber(statesTable[1]) == 1) then isStolen = "Yes" end
				if (tonumber(statesTable[2]) == 1) then isChopped = "Yes" end
				emGUI:dxGridListSetItemText(vehicleListGridlist, row, 11, isStolen)
				emGUI:dxGridListSetItemText(vehicleListGridlist, row, 12, isChopped)
	
				local createdTime = exports.global:convertTime(vehicle.created_date)
				emGUI:dxGridListSetItemText(vehicleListGridlist, row, 13, createdTime[2] .. " at " .. createdTime[1])
	
				emGUI:dxGridListSetItemText(vehicleListGridlist, row, 14, createdBy[v])
	
				local lastUpdated = exports.global:convertTime(vehicle.last_used)
				emGUI:dxGridListSetItemText(vehicleListGridlist, row, 15, lastUpdated[2] .. " at " .. lastUpdated[1])
	
				local isDamageProof = "No"
				if (vehicle.damageproof == 1) then isDamageProof = "Yes" end
				emGUI:dxGridListSetItemText(vehicleListGridlist, row, 16, isDamageProof)
	
				local isJobVehicle = "No"
				if (vehicle.job == 1) then isJobVehicle = "Yes" end
				emGUI:dxGridListSetItemText(vehicleListGridlist, row, 17, isJobVehicle)
			end
		end
	end)

	-- Character name search.
	addEventHandler("onDgsTextChange", searchOwnerInput, function(newText)
		if (#newText ~= 0) then emGUI:dxSetEnabled(searchVehNameInput, false) else emGUI:dxSetEnabled(searchVehNameInput, true) end
		emGUI:dxGridListClearRow(vehicleListGridlist)
		for v, vehicle in pairs(vehicleData) do
			if characterNames[v]:lower():find(newText:lower()) then
				local row = emGUI:dxGridListAddRow(vehicleListGridlist)
				emGUI:dxGridListSetItemText(vehicleListGridlist, row, 1, vehicle.id)
				emGUI:dxGridListSetItemText(vehicleListGridlist, row, 2, vehicle.model)
				emGUI:dxGridListSetItemText(vehicleListGridlist, row, 3, vehicleNames[v])
				emGUI:dxGridListSetItemText(vehicleListGridlist, row, 4, vehicle.dimension)
				emGUI:dxGridListSetItemText(vehicleListGridlist, row, 5, vehicle.interior)
				emGUI:dxGridListSetItemText(vehicleListGridlist, row, 6, vehicle.hp)
				emGUI:dxGridListSetItemText(vehicleListGridlist, row, 7, characterNames[v])
				
				local isImpounded = "No"
				if (vehicle.impounded == 1) then isImpounded = "Yes" end
				emGUI:dxGridListSetItemText(vehicleListGridlist, row, 8, isImpounded)
	
				emGUI:dxGridListSetItemText(vehicleListGridlist, row, 9, vehicle.odometer)
	
				local isDeleted = "No"
				if (vehicle.deleted == 1) then isDeleted = "Yes" end
				emGUI:dxGridListSetItemText(vehicleListGridlist, row, 10, isDeleted)
	
				local isStolen = "No"
				local isChopped = "No"
				local statesTable = split(vehicle.state, ",")
				if (tonumber(statesTable[1]) == 1) then isStolen = "Yes" end
				if (tonumber(statesTable[2]) == 1) then isChopped = "Yes" end
				emGUI:dxGridListSetItemText(vehicleListGridlist, row, 11, isStolen)
				emGUI:dxGridListSetItemText(vehicleListGridlist, row, 12, isChopped)
	
				local createdTime = exports.global:convertTime(vehicle.created_date)
				emGUI:dxGridListSetItemText(vehicleListGridlist, row, 13, createdTime[2] .. " at " .. createdTime[1])
	
				emGUI:dxGridListSetItemText(vehicleListGridlist, row, 14, createdBy[v])
	
				local lastUpdated = exports.global:convertTime(vehicle.last_used)
				emGUI:dxGridListSetItemText(vehicleListGridlist, row, 15, lastUpdated[2] .. " at " .. lastUpdated[1])
	
				local isDamageProof = "No"
				if (vehicle.damageproof == 1) then isDamageProof = "Yes" end
				emGUI:dxGridListSetItemText(vehicleListGridlist, row, 16, isDamageProof)
	
				local isJobVehicle = "No"
				if (vehicle.job == 1) then isJobVehicle = "Yes" end
				emGUI:dxGridListSetItemText(vehicleListGridlist, row, 17, isJobVehicle)
			end
		end
	end)
end
addEvent("vehicle:showvehiclelist", true)
addEventHandler("vehicle:showvehiclelist", root, showVehicleMasterlist)

function removeVehicleButtonClick(button, state)
	if (button == "left") and (state == "down") then
		local selection = emGUI:dxGridListGetSelectedItem(vehicleListGridlist)
		if not (selection) or (selection == -1) then
			outputChatBox("ERROR: Select a vehicle to remove first!", 255, 0, 0)
			return false
		end

		local vehicleID = emGUI:dxGridListGetItemText(vehicleListGridlist, selection, 1)
		triggerServerEvent("vehicle:removevehiclecall", localPlayer, localPlayer, "removeveh", vehicleID)
		emGUI:dxCloseWindow(allVehiclesGUI)
	end
end

function restoreVehicleButtonClick(button, state)
	if (button == "left") and (state == "down") then
		local selection = emGUI:dxGridListGetSelectedItem(vehicleListGridlist)
		if not (selection) or (selection == -1) then
			outputChatBox("ERROR: Select a vehicle to restore first!", 255, 0, 0)
			return false
		end

		local vehicleID = emGUI:dxGridListGetItemText(vehicleListGridlist, selection, 1)
		triggerServerEvent("vehicle:restorevehiclecall", localPlayer, localPlayer, "restoreveh", vehicleID)
		emGUI:dxCloseWindow(allVehiclesGUI)
	end
end

function deleteVehicleButtonClick(button, state)
	if (button == "left") and (state == "down") then
		local selection = emGUI:dxGridListGetSelectedItem(vehicleListGridlist)
		if not (selection) or (selection == -1) then
			outputChatBox("ERROR: Select a vehicle to delete first!", 255, 0, 0)
			return false
		end

		local vehicleID = emGUI:dxGridListGetItemText(vehicleListGridlist, selection, 1)
		triggerServerEvent("vehicle:deletevehiclecall", localPlayer, localPlayer, "delveh", vehicleID)
		emGUI:dxCloseWindow(allVehiclesGUI)
	end
end

-- /ed - By Skully (11/02/19) [Helper/VT]
function showVehicleDescEditor()
	if exports.global:isPlayerHelper(localPlayer) or exports.global:isPlayerVehicleTeam(localPlayer) then
		if emGUI:dxIsWindowVisible(vehicleDescriptionEditWindow) then emGUI:dxCloseWindow(vehicleDescriptionEditWindow) return end
		local theVehicle = getPedOccupiedVehicle(localPlayer)
		if not theVehicle then outputChatBox("ERROR: You aren't inside a vehicle!", 255, 0, 0) return end

		vehicleDescriptionEditWindow = emGUI:dxCreateWindow(0.34, 0.38, 0.31, 0.23, "Edit Vehicle Description", true)

		local inputBoxes = {}
		inputBoxes[1] = emGUI:dxCreateEdit(0.03, 0.1, 0.94, 0.12, "", true, vehicleDescriptionEditWindow)
		inputBoxes[2] = emGUI:dxCreateEdit(0.03, 0.248, 0.94, 0.12, "", true, vehicleDescriptionEditWindow)
		inputBoxes[3] = emGUI:dxCreateEdit(0.03, 0.395, 0.94, 0.12, "", true, vehicleDescriptionEditWindow)
		inputBoxes[4] = emGUI:dxCreateEdit(0.03, 0.54, 0.94, 0.12, "", true, vehicleDescriptionEditWindow)

		-- Populate existing vehicle description.
		local vehicleDescription = getElementData(theVehicle, "vehicle:description")
		for i, desc in ipairs(vehicleDescription) do emGUI:dxSetText(inputBoxes[i], desc) end

		cancelEditButton = emGUI:dxCreateButton(0.22, 0.7, 0.27, 0.26, "CANCEL", true, vehicleDescriptionEditWindow)
		addEventHandler("onClientDgsDxMouseClick", cancelEditButton, function(b, c)
			if (b == "left") and (c == "down") then
				emGUI:dxCloseWindow(vehicleDescriptionEditWindow)
			end
		end)

		saveVehDescButton = emGUI:dxCreateButton(0.51, 0.7, 0.27, 0.26, "SAVE", true, vehicleDescriptionEditWindow)
		addEventHandler("onClientDgsDxMouseClick", saveVehDescButton, function(b, c)
			if (b == "left") and (c == "down") then
				local descInputs = {}
				descInputs[1] = emGUI:dxGetText(inputBoxes[1])
				descInputs[2] = emGUI:dxGetText(inputBoxes[2])
				descInputs[3] = emGUI:dxGetText(inputBoxes[3])
				descInputs[4] = emGUI:dxGetText(inputBoxes[4])

				for i, input in ipairs(inputBoxes) do
					if (string.len(descInputs[i]) > 60) then
						emGUI:dxSetText(vehicleDescriptionEditWindow, "Line " .. i .. " is too long!")
						emGUI:dxWindowSetTitleTextColor(vehicleDescriptionEditWindow, tocolor(255, 0, 0, 255))
						return
					end
				end

				local saveTable = descInputs
				triggerServerEvent("vehicle:updateVehicleDescription", localPlayer, theVehicle, saveTable)
				emGUI:dxCloseWindow(vehicleDescriptionEditWindow)
			end
		end)
	end
end
addCommandHandler("ed", showVehicleDescEditor)
addCommandHandler("editdescription", showVehicleDescEditor)