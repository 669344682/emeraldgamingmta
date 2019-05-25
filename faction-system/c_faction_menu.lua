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
local buttonFont_40 = emGUI:dxCreateNewFont("fonts/buttonFont.ttf", 34)
local consoleFont_11 = emGUI:dxCreateNewFont("fonts/consoleFont.ttf", 11)

local isFactionLeader = false
local fetchedVehicleData = false
local fetchedInteriorData = false
local fetchedLeaderData = false
local fetchedFinanceData = false
local gItems = {}

function showFactionMenu(animateIn, factionElement, menuData, memberNames, memberRanks, memberLastSeen, memberLeaderships)
	if emGUI:dxIsWindowVisible(factionMenuGUI) then emGUI:dxCloseWindow(factionMenuGUI) return end
	if not isElement(factionElement) then outputChatBox("Something went wrong whilst fetching your faction information, try again later.", 255, 0, 0) return false end

	isFactionLeader = menuData[1] or false
	local factionID = getElementData(factionElement, "faction:id"); factionID = tonumber(factionID)
	local x, y = 0.22, 0.22; if animateIn then x, y = 0.22, 1 end

	factionMenuGUI = emGUI:dxCreateWindow(x, y, 0.56, 0.57, menuData[4], true)
	if animateIn then emGUI:dxMoveTo(factionMenuGUI, 0.22, 0.22, true, false, "OutQuad", 250) end
		-- Logo and abbreviation.
		-- Set faction logo with URL obtained from menuData[2] @requires faction-system logos.
		local logoPos = ":assets/images/logoIcon.png"
		if factionID == 1 then logoPos = ":dev/pd.png"
			elseif factionID == 2 then logoPos = ":dev/fd.png"
			elseif factionID == 2 then logoPos = ":dev/gov.png"
		end
		factionLogoImage = emGUI:dxCreateImage(0.83, 0.1, 0.13, 0.21, logoPos, true, factionMenuGUI)

		local facAbbr = getElementData(factionElement, "faction:abbreviation") or ""
		factionAbbrLabel = emGUI:dxCreateLabel(0.82, 0.32, 0.15, 0.07, facAbbr, true, factionMenuGUI)
		emGUI:dxSetFont(factionAbbrLabel, buttonFont_40)
		emGUI:dxLabelSetHorizontalAlign(factionAbbrLabel, "center")

		-- Bottom MOTD.
		motdLabel = emGUI:dxCreateLabel(0.015, 0.9, 0.9, 0.08, menuData[3], true, factionMenuGUI)
		emGUI:dxLabelSetVerticalAlign(motdLabel, "center")
		emGUI:dxSetFont(motdLabel, consoleFont_11)

		leaveFactionButton = emGUI:dxCreateButton(0.82, 0.685, 0.15, 0.10, "Leave Faction", true, factionMenuGUI)
		local wantsToLeave = false
		addEventHandler("onClientDgsDxMouseClick", leaveFactionButton, function(b, c)
			if (b == "left") and (c == "down") then
				if wantsToLeave then
					triggerServerEvent("faction:leaveFactionEvent", localPlayer, factionID)
					emGUI:dxMoveTo(factionMenuGUI, 0.22, 1, true, false, "OutQuad", 250)
					setTimer(function()
						if emGUI:dxIsWindowVisible(factionMenuGUI) then emGUI:dxCloseWindow(factionMenuGUI) end
					end, 300, 1)
					return
				end

				emGUI:dxSetText(leaveFactionButton, "Are you sure?")
				emGUI:dxButtonSetColor(leaveFactionButton, tocolor(255, 0, 0), tocolor(230, 0, 0), tocolor(200, 0, 0))
				wantsToLeave = true
				setTimer(function()
					if not emGUI:dxIsWindowVisible(factionMenuGUI) then return end
					emGUI:dxSetText(leaveFactionButton, "Leave Faction")
					emGUI:dxButtonSetColor(leaveFactionButton)
					wantsToLeave = false
				end, 5000, 1)
			end
		end)

		returnFacSelectButton = emGUI:dxCreateButton(0.82, 0.805, 0.15, 0.10, "Faction\nSelection", true, factionMenuGUI)
		addEventHandler("onClientDgsDxMouseClick", returnFacSelectButton, function(b, c)
			if (b == "left") and (c == "down") then
				emGUI:dxMoveTo(factionMenuGUI, 0.22, 1, true, false, "OutQuad", 250)
				setTimer(function()
					if emGUI:dxIsWindowVisible(factionMenuGUI) then emGUI:dxCloseWindow(factionMenuGUI) end
				end, 300, 1)
				triggerServerEvent("faction:showFactionSelectorCall", localPlayer)
			end
		end)


	factionMenuTabPanel = emGUI:dxCreateTabPanel(0.01, 0.05, 0.79, 0.90, true, factionMenuGUI)

	overviewTab = emGUI:dxCreateTab("Overview", factionMenuTabPanel, _, _, _, _, tocolor(0, 0, 0, 0))
		memberGridlList = emGUI:dxCreateGridList(0, 0, 1, 0.95, true, overviewTab, true, _, tocolor(0, 0, 0, 100))
		emGUI:dxGridListAddColumn(memberGridlList, "Name", 0.25)
		emGUI:dxGridListAddColumn(memberGridlList, "Rank", 0.23)
		emGUI:dxGridListAddColumn(memberGridlList, "Status", 0.1)
		emGUI:dxGridListAddColumn(memberGridlList, "Availability", 0.1)
		emGUI:dxGridListAddColumn(memberGridlList, "Last Seen", 0.14)
		emGUI:dxGridListAddColumn(memberGridlList, "Faction Leader", 0.1)
		local factionRanks = getElementData(factionElement, "faction:ranks")
		for i = 1, #memberNames do
			local row = emGUI:dxGridListAddRow(memberGridlList)
			emGUI:dxGridListSetItemText(memberGridlList, row, 1, memberNames[i])
			local rankName = factionRanks[memberRanks[i]][1]
			emGUI:dxGridListSetItemText(memberGridlList, row, 2, rankName)
			
			local isOnline = "Offline"
			local facMember = getPlayerFromName(memberNames[i]:gsub(" ", "_"))
			if facMember then
				isOnline = "Online"
				emGUI:dxGridListSetItemColor(memberGridlList, row, 3, 0, 255, 0, 255)
			else
				emGUI:dxGridListSetItemColor(memberGridlList, row, 3, 255, 0, 0, 255)
			end
			emGUI:dxGridListSetItemText(memberGridlList, row, 3, isOnline)

			local availabilityString = "Unavailable"
			if facMember then
				local isAvailable = getElementData(facMember, "character:activefaction") == factionID
				if isAvailable then
					local isOnDuty = getElementData(facMember, "character:factionduty") == factionID
					if isOnDuty then
						availabilityString = "On Duty"
						emGUI:dxGridListSetItemColor(memberGridlList, row, 4, 0, 162, 255, 255)
					else
						availabilityString = "Off Duty"
						emGUI:dxGridListSetItemColor(memberGridlList, row, 4, 170, 170, 170, 255)
					end
				else
					emGUI:dxGridListSetItemColor(memberGridlList, row, 4, 255, 0, 0, 255)
				end
			end

			emGUI:dxGridListSetItemText(memberGridlList, row, 4, availabilityString)
			local lastSeen = memberLastSeen[i] .. " days ago"
			if memberLastSeen[i] == 0 or facMember then lastSeen = "Today" end
			emGUI:dxGridListSetItemText(memberGridlList, row, 5, lastSeen)

			local isMemberLeader = "No"; if memberLeaderships[i] then isMemberLeader = "Yes" end
			emGUI:dxGridListSetItemText(memberGridlList, row, 6, isMemberLeader)			
		end

	notesTab = emGUI:dxCreateTab("Notes", factionMenuTabPanel, _, _, _, _, tocolor(0, 0, 0, 0))

	if not isFactionLeader then
		emGUI:dxCreateLabel(0.01, 0.01, 0.2, 0.04, "Faction Notes", true, notesTab)
		local factionNote = getElementData(factionElement, "faction:note") or ""
		factionNotesMemo = emGUI:dxCreateMemo(0.01, 0.06, 0.96, 0.89, factionNote, true, notesTab)
		emGUI:dxMemoSetReadOnly(factionNotesMemo, true)
		return
	end

	editMemberButton = emGUI:dxCreateButton(0.82, 0.445, 0.15, 0.10, "Edit Member", true, factionMenuGUI)
	emGUI:dxSetEnabled(editMemberButton, false)
	addEventHandler("onClientDgsDxMouseClick", editMemberButton, function(b, c)
		if (b == "left") and (c == "down") then
			local selected = emGUI:dxGridListGetSelectedItem(memberGridlList)
			local memberName = emGUI:dxGridListGetItemText(memberGridlList, selected, 1)
			triggerServerEvent("faction:menuEditMemberCall", localPlayer, factionID, memberName, factionRanks)
		end
	end)

	addMemberButton = emGUI:dxCreateButton(0.82, 0.565, 0.15, 0.10, "Invite Member", true, factionMenuGUI)
	addEventHandler("ondxGridListSelect", memberGridlList, function(c) emGUI:dxSetEnabled(editMemberButton, c ~= -1) end)
	addEventHandler("onClientDgsDxMouseClick", addMemberButton, function(b, c)
		if (b == "left") and (c == "down") then
			if emGUI:dxIsWindowVisible(motdEditorGUI) then emGUI:dxCloseWindow(motdEditorGUI) end
			if emGUI:dxIsWindowVisible(logoEditorGUI) then emGUI:dxCloseWindow(logoEditorGUI) end
			emGUI:dxMoveTo(factionMenuGUI, 0.22, 1, true, false, "OutQuad", 250)
			setTimer(function()
				showMemberInviteGUI(factionElement, factionRanks)
			end, 300, 1)
		end
	end)

	updateNotesButton = emGUI:dxCreateButton(0.82, 0.445, 0.15, 0.10, "Save Notes", true, factionMenuGUI)
	emGUI:dxSetVisible(updateNotesButton, false)
	addEventHandler("ondxGridListSelect", memberGridlList, function(c) emGUI:dxSetEnabled(editMemberButton, c ~= -1) end)
	addEventHandler("onClientDgsDxMouseClick", updateNotesButton, function(b, c)
		if (b == "left") and (c == "down") then
			local factionNotes = emGUI:dxGetText(factionNotesMemo) or ""
			local leaderNotes = emGUI:dxGetText(factionLeaderNotesMemo) or ""
			triggerServerEvent("faction:menu:saveFactionNotes", localPlayer, factionID, factionNotes, leaderNotes)
		end
	end)

	vehiclesTab = emGUI:dxCreateTab("Vehicles", factionMenuTabPanel, _, _, _, _, tocolor(0, 0, 0, 0))
	interiorsTab = emGUI:dxCreateTab("Interiors", factionMenuTabPanel, _, _, _, _, tocolor(0, 0, 0, 0))
	leadershipTab = emGUI:dxCreateTab("Leadership", factionMenuTabPanel, _, _, _, _, tocolor(0, 0, 0, 0))
	finanaceTab = emGUI:dxCreateTab("Finance", factionMenuTabPanel, _, _, _, _, tocolor(0, 0, 0, 0))

	loadingLabel = emGUI:dxCreateLabel(0.19, 0.4, 0.4, 0.1, "Loading Data..", true, factionMenuGUI)
	emGUI:dxSetFont(loadingLabel, buttonFont_40)
	emGUI:dxSetVisible(loadingLabel, false)

	addEventHandler("onDgsTabPanelTabSelect", factionMenuTabPanel, function(n)
		if (n == 1) then emGUI:dxSetVisible(editMemberButton, true) else emGUI:dxSetVisible(editMemberButton, false) end
		if (n == 2) then
			if isFactionLeader then
				emGUI:dxCreateLabel(0.01, 0.01, 0.2, 0.04, "Faction Notes", true, notesTab)
				local factionNote = getElementData(factionElement, "faction:note") or ""
				factionNotesMemo = emGUI:dxCreateMemo(0.01, 0.06, 0.96, 0.4, factionNote, true, notesTab)
				emGUI:dxSetVisible(updateNotesButton, true)
				local factionLeaderNote = getElementData(factionElement, "faction:leadernote") or ""
				emGUI:dxCreateLabel(0.01, 0.48, 0.2, 0.04, "Faction Leader Notes", true, notesTab)
				factionLeaderNotesMemo = emGUI:dxCreateMemo(0.01, 0.53, 0.96, 0.42, factionLeaderNote, true, notesTab)
			end
		else
			if isFactionLeader then
				if isElement(factionNotesMemo) then destroyElement(factionNotesMemo); destroyElement(factionLeaderNotesMemo) end
				emGUI:dxSetVisible(updateNotesButton, false)
			end
		end
		if (n == 3) and not fetchedVehicleData then
			emGUI:dxSetVisible(loadingLabel, true)
			fetchedVehicleData = true
			triggerServerEvent("faction:fetchVehicleData", localPlayer, factionID)
		end
		if (n == 4) and not fetchedInteriorData then
			emGUI:dxSetVisible(loadingLabel, true)
			fetchedInteriorData = true
			triggerServerEvent("faction:fetchInteriorData", localPlayer, factionID)
		end
		if (n == 5) and not fetchedLeaderData then
			emGUI:dxSetVisible(loadingLabel, true)
			fetchedLeaderData = true
			triggerServerEvent("faction:fetchLeadershipData", localPlayer, factionID)
		end
		if (n == 6) and not fetchedFinanceData then
			emGUI:dxSetVisible(loadingLabel, true)
			fetchedFinanceData = true
			triggerServerEvent("faction:fetchFinanceData", localPlayer, factionID)
		end
	end)

	addEventHandler("onDgsWindowClose", factionMenuGUI, function()
		if isFactionLeader then
			if emGUI:dxIsWindowVisible(inviteMemberGUI) then emGUI:dxCloseWindow(inviteMemberGUI) end
			if emGUI:dxIsWindowVisible(editMemberGUI) then emGUI:dxCloseWindow(editMemberGUI) end
			if emGUI:dxIsWindowVisible(motdEditorGUI) then emGUI:dxCloseWindow(motdEditorGUI) end
			if emGUI:dxIsWindowVisible(logoEditorGUI) then emGUI:dxCloseWindow(logoEditorGUI) end
			if emGUI:dxIsWindowVisible(rankWageEditorGUI) then emGUI:dxCloseWindow(rankWageEditorGUI) end
			if emGUI:dxIsWindowVisible(dutyEditorPreGUI) then emGUI:dxCloseWindow(dutyEditorPreGUI) end
			if emGUI:dxIsWindowVisible(deDutyLocationsGUI) then emGUI:dxCloseWindow(deDutyLocationsGUI) end
			if emGUI:dxIsWindowVisible(dutyGroupManagerGUI) then emGUI:dxCloseWindow(dutyGroupManagerGUI) end
			if emGUI:dxIsWindowVisible(dutyGroupLocationsGUI) then emGUI:dxCloseWindow(dutyGroupLocationsGUI) end
			if emGUI:dxIsWindowVisible(vehiclePermissionGUI) then emGUI:dxCloseWindow(vehiclePermissionGUI) end
		end
		isFactionLeader, fetchedVehicleData, fetchedInteriorData, fetchedLeaderData, fetchedFinanceData = false, false, false, false, false
	end)
end
addEvent("faction:showFactionMenu", true)
addEventHandler("faction:showFactionMenu", root, showFactionMenu)

function fetchVehicleDataCallback(vehicleIDs, vehicleNames, vehiclePlates)
	if emGUI:dxIsWindowVisible(factionMenuGUI) then
		emGUI:dxSetVisible(loadingLabel, false)
		facVehiclesGridList = emGUI:dxCreateGridList(0, 0, 1, 0.81, true, vehiclesTab, true, _, tocolor(0, 0, 0, 100))
		emGUI:dxGridListAddColumn(facVehiclesGridList, "ID", 0.08)
		emGUI:dxGridListAddColumn(facVehiclesGridList, "Vehicle", 0.4)
		emGUI:dxGridListAddColumn(facVehiclesGridList, "Plates", 0.2)

		respawnVehicleButton = emGUI:dxCreateButton(0, 0.832, 0.19, 0.117, "Respawn Vehicle", true, vehiclesTab)
		emGUI:dxSetEnabled(respawnVehicleButton, false)
		addEventHandler("onClientDgsDxMouseClick", respawnVehicleButton, function(b, c)
			if (b == "left") and (c == "down") then
				local selected = emGUI:dxGridListGetSelectedItem(facVehiclesGridList)
				selected = emGUI:dxGridListGetItemText(facVehiclesGridList, selected, 1)
				triggerServerEvent("faction:menu:respawnFactionVehicle", localPlayer, selected)
			end
		end)
		respawnAllVehButton = emGUI:dxCreateButton(0.21, 0.832, 0.19, 0.117, "Respawn All\nVehicles", true, vehiclesTab)
		local wantsToRespawn = false
		addEventHandler("onClientDgsDxMouseClick", respawnAllVehButton, function(b, c)
			if (b == "left") and (c == "down") then
				if wantsToRespawn then
					triggerServerEvent("faction:menu:respawnAllFactionVehicles", localPlayer, localPlayer)
					emGUI:dxSetText(respawnAllVehButton, "Respawning..")
					emGUI:dxSetEnabled(respawnAllVehButton, false)
					return
				end

				emGUI:dxSetText(respawnAllVehButton, "Are you sure?")
				emGUI:dxButtonSetColor(respawnAllVehButton, tocolor(255, 0, 0), tocolor(230, 0, 0), tocolor(200, 0, 0))
				wantsToRespawn = true
				setTimer(function()
					if not emGUI:dxIsWindowVisible(factionMenuGUI) then return end
					emGUI:dxSetText(respawnAllVehButton, "Respawn All\nVehicles")
					emGUI:dxButtonSetColor(respawnAllVehButton)
					wantsToRespawn = false
				end, 5000, 1)
			end
		end)

		for i = 1, #vehicleIDs do
			local row = emGUI:dxGridListAddRow(facVehiclesGridList)
			emGUI:dxGridListSetItemText(facVehiclesGridList, row, 1, vehicleIDs[i])
			emGUI:dxGridListSetItemText(facVehiclesGridList, row, 2, vehicleNames[i])
			emGUI:dxGridListSetItemText(facVehiclesGridList, row, 3, vehiclePlates[i])
		end

		addEventHandler("ondxGridListSelect", facVehiclesGridList, function(c) emGUI:dxSetEnabled(respawnVehicleButton, c ~= -1) end)
	end
end
addEvent("faction:fetchVehicleDataCallback", true)
addEventHandler("faction:fetchVehicleDataCallback", root, fetchVehicleDataCallback)

function fetchInteriorDataCallback(interiorIDs, interiorNames, interiorTypes, interiorLocations)
	if emGUI:dxIsWindowVisible(factionMenuGUI) then
		emGUI:dxSetVisible(loadingLabel, false)
		facInteriorGridList = emGUI:dxCreateGridList(0, 0, 1, 0.95, true, interiorsTab, true, _, tocolor(0, 0, 0, 100))
		emGUI:dxGridListAddColumn(facInteriorGridList, "ID", 0.08)
		emGUI:dxGridListAddColumn(facInteriorGridList, "Name", 0.4)
		emGUI:dxGridListAddColumn(facInteriorGridList, "Type", 0.16)
		emGUI:dxGridListAddColumn(facInteriorGridList, "Location", 0.2)

		for i = 1, #interiorIDs do
			local row = emGUI:dxGridListAddRow(facInteriorGridList)
			emGUI:dxGridListSetItemText(facInteriorGridList, row, 1, interiorIDs[i])
			emGUI:dxGridListSetItemText(facInteriorGridList, row, 2, interiorNames[i])
			local intType = exports["interior-system"]:getInteriorType(interiorTypes[i]) or "Unknown"
			emGUI:dxGridListSetItemText(facInteriorGridList, row, 3, intType)
			local intLocation = getZoneName(interiorLocations[i][1], interiorLocations[i][2], interiorLocations[i][3]) .. ", " .. getZoneName(interiorLocations[i][1], interiorLocations[i][2], interiorLocations[i][3], true) .. "."
			emGUI:dxGridListSetItemText(facInteriorGridList, row, 4, intLocation)
		end
	end
end
addEvent("faction:fetchInteriorDataCallback", true)
addEventHandler("faction:fetchInteriorDataCallback", root, fetchInteriorDataCallback)

function fetchLeadershipDataCallback(factionMotd, factionRanks, leaderLogTexts, leaderLogNames, leaderLogTimes)
	if emGUI:dxIsWindowVisible(factionMenuGUI) then
		emGUI:dxSetVisible(loadingLabel, false)

		editRankWagesButton = emGUI:dxCreateButton(0, 0.03, 0.19, 0.117, "Edit Ranks\n& Wages", true, leadershipTab)
		addEventHandler("onClientDgsDxMouseClick", editRankWagesButton, function(b, c)
			if (b == "left") and (c == "down") then
				if emGUI:dxIsWindowVisible(motdEditorGUI) then emGUI:dxCloseWindow(motdEditorGUI) end
				if emGUI:dxIsWindowVisible(logoEditorGUI) then emGUI:dxCloseWindow(logoEditorGUI) end
				showRankEditor(factionRanks)
			end
		end)

		dutyManagerButton = emGUI:dxCreateButton(0.21, 0.03, 0.19, 0.117, "Duty Manager", true, leadershipTab)
		addEventHandler("onClientDgsDxMouseClick", dutyManagerButton, dutyManagerButtonClick)
		updateMotdButton = emGUI:dxCreateButton(0.42, 0.03, 0.19, 0.117, "MOTD Editor", true, leadershipTab)
		addEventHandler("onClientDgsDxMouseClick", updateMotdButton, function(b, c) if (b == "left") and (c == "down") then showMotdEditorGUI(factionMotd) end end)
		updateLogoButton = emGUI:dxCreateButton(0.63, 0.03, 0.19, 0.117, "Change Logo", true, leadershipTab)
		addEventHandler("onClientDgsDxMouseClick", updateLogoButton, function(b, c) if (b == "left") and (c == "down") then showLogoEditorGUI() end end)
		
	

		factionLogsGridList = emGUI:dxCreateGridList(0, 0.2, 1, 0.75, true, leadershipTab, false, _, tocolor(0, 0, 0, 100))
		emGUI:dxGridListAddColumn(factionLogsGridList, "Player", 0.12)
		emGUI:dxGridListAddColumn(factionLogsGridList, "Time", 0.18)
		emGUI:dxGridListAddColumn(factionLogsGridList, "Log", 0.75)

		for i = 1, #leaderLogTexts do
			local row = emGUI:dxGridListAddRow(factionLogsGridList)
			emGUI:dxGridListSetItemText(factionLogsGridList, row, 1, leaderLogNames[i])
			local parsedTime = exports.global:convertTime(leaderLogTimes[i])
			emGUI:dxGridListSetItemText(factionLogsGridList, row, 2, parsedTime[2] .. " at " .. parsedTime[1])
			emGUI:dxGridListSetItemText(factionLogsGridList, row, 3, leaderLogTexts[i])
		end
	end
end
addEvent("faction:fetchLeadershipDataCallback", true)
addEventHandler("faction:fetchLeadershipDataCallback", root, fetchLeadershipDataCallback)

function fetchFinanceDataCallback(financeData, financeLogIDs, financeTypes, financeReasons, finanacePrices)
	if emGUI:dxIsWindowVisible(factionMenuGUI) then
		emGUI:dxSetVisible(loadingLabel, false)
		emGUI:dxCreateLabel(0.012, 0.04, 0.13, 0.03, "Faction Bank Balance", true, finanaceTab)
		factionBalanaceLabel = emGUI:dxCreateLabel(0.01, 0.08, 0.13, 0.03, "$" .. exports.global:formatNumber(financeData[1]), true, finanaceTab)

		emGUI:dxCreateLabel(0.2, 0.04, 0.13, 0.03, "Vehicle Asset Worth", true, finanaceTab)
		facVehicleWorthLabel = emGUI:dxCreateLabel(0.2, 0.08, 0.13, 0.03, "$" .. exports.global:formatNumber(financeData[2]), true, finanaceTab)

		emGUI:dxCreateLabel(0.4, 0.04, 0.13, 0.03, "Properties Asset Worth", true, finanaceTab)
		facPropertyWorthLabel = emGUI:dxCreateLabel(0.4, 0.08, 0.13, 0.03, "$" .. exports.global:formatNumber(financeData[3]), true, finanaceTab)

		emGUI:dxCreateLabel(0.83, 0.04, 0.13, 0.03, "Faction Net Worth", true, finanaceTab)
		facNetWorthLabel = emGUI:dxCreateLabel(0.83, 0.08, 0.13, 0.03, "$" .. exports.global:formatNumber(financeData[4]), true, finanaceTab)

		financeLogsGridList = emGUI:dxCreateGridList(0, 0.15, 1, 0.8, true, finanaceTab, true, _, tocolor(0, 0, 0, 100))
		emGUI:dxGridListAddColumn(financeLogsGridList, "ID", 0.06)
		emGUI:dxGridListAddColumn(financeLogsGridList, "Type", 0.1)
		emGUI:dxGridListAddColumn(financeLogsGridList, "Reason", 0.73)
		emGUI:dxGridListAddColumn(financeLogsGridList, "Price", 0.04)
	end
end
addEvent("faction:fetchFinanceDataCallback", true)
addEventHandler("faction:fetchFinanceDataCallback", root, fetchFinanceDataCallback)

---------------------------------------------------------------------------------------------------------------------------------------

function showMemberInviteGUI(factionElement, factionRanks)
	if not emGUI:dxIsWindowVisible(factionMenuGUI) then return end

	inviteMemberGUI = emGUI:dxCreateWindow(0.41, 1, 0.17, 0.38, "Invite To Faction", true, _, _, true)
	emGUI:dxMoveTo(inviteMemberGUI, 0.41, 0.31, true, false, "OutQuad", 250)

	emGUI:dxCreateLabel(0.08, 0.08, 0.42, 0.04, "Input Player Name or ID", true, inviteMemberGUI)
	invNameInput = emGUI:dxCreateEdit(0.08, 0.14, 0.84, 0.06, "", true, inviteMemberGUI)
	local playerFound = false
	addEventHandler("onClientDgsDxGUITextChange", invNameInput, function(n)
		local targetPlayer, targetPlayerName = exports.global:getPlayerFromPartialNameOrID(n, localPlayer)
		if (targetPlayer) then
			emGUI:dxSetText(inviteFeedbackLabel, "Player " .. targetPlayerName .. " found!")
			emGUI:dxLabelSetColor(inviteFeedbackLabel, 0, 255, 0)
			playerFound = targetPlayer
		else
			emGUI:dxSetText(inviteFeedbackLabel, "Player not found.")
			emGUI:dxLabelSetColor(inviteFeedbackLabel, 255, 0, 0)
			playerFound = false
		end
	end)
	
	invRanksGridlist = emGUI:dxCreateGridList(0.08, 0.22, 0.84, 0.50, true, inviteMemberGUI, true)
	emGUI:dxGridListAddColumn(invRanksGridlist, "Rank Name", 1)
	for i, rank in ipairs(factionRanks) do
		emGUI:dxGridListAddRow(invRanksGridlist)
		emGUI:dxGridListSetItemText(invRanksGridlist, i, 1, rank[1])
	end

	inviteFeedbackLabel = emGUI:dxCreateLabel(0.14, 0.74, 0.73, 0.03, "Input player to invite.", true, inviteMemberGUI)
	emGUI:dxLabelSetHorizontalAlign(inviteFeedbackLabel, "center")
	
	invCancelButton = emGUI:dxCreateButton(0.06, 0.81, 0.41, 0.15, "Cancel", true, inviteMemberGUI)
	addEventHandler("onClientDgsDxMouseClick", invCancelButton, function(b, c)
		if (b == "left") and (c == "down") then
			emGUI:dxMoveTo(inviteMemberGUI, 0.41, 1, true, false, "OutQuad", 250)
			setTimer(function()
				if emGUI:dxIsWindowVisible(inviteMemberGUI) then emGUI:dxCloseWindow(inviteMemberGUI) end
				emGUI:dxMoveTo(factionMenuGUI, 0.22, 0.22, true, false, "OutQuad", 250)
			end, 300, 1)
		end
	end)

	invInviteMemberButton = emGUI:dxCreateButton(0.54, 0.81, 0.41, 0.15, "Invite\nMember", true, inviteMemberGUI)
	addEventHandler("onClientDgsDxMouseClick", invInviteMemberButton, function(b, c)
		if (b == "left") and (c == "down") then
			if not playerFound then emGUI:dxSetText(inviteFeedbackLabel, "Input a player to invite!"); emGUI:dxLabelSetColor(inviteFeedbackLabel, 255, 0, 0) return end
			local rankID = emGUI:dxGridListGetSelectedItem(invRanksGridlist)
			emGUI:dxMoveTo(inviteMemberGUI, 0.41, 1, true, false, "OutQuad", 250)
			triggerServerEvent("faction:inviteMemberToFaction", localPlayer, playerFound, factionElement, rankID)
			setTimer(function()
				if emGUI:dxIsWindowVisible(inviteMemberGUI) then emGUI:dxCloseWindow(inviteMemberGUI) end
				emGUI:dxMoveTo(factionMenuGUI, 0.22, 0.22, true, false, "OutQuad", 250)
			end, 300, 1)
		end
	end)
	emGUI:dxSetEnabled(invInviteMemberButton, false)
	addEventHandler("ondxGridListSelect", invRanksGridlist, function(c) emGUI:dxSetEnabled(invInviteMemberButton, c ~= -1) end)
end

---------------------------------------------------------------------------------------------------------------------------------------

function showMemberEditorGUI(factionID, playerName, characterID, playerRank, playerLeader, factionRanks, factionDutyPerks, factionDutyGroups)
	emGUI:dxMoveTo(factionMenuGUI, 0.22, 1, true, false, "OutQuad", 250)
	editMemberGUI = emGUI:dxCreateWindow(0.23, 1, 0.53, 0.46, "Editing Member: " .. playerName, true, _, _, true)

	setTimer(function()
		emGUI:dxMoveTo(editMemberGUI, 0.23, 0.27, true, false, "OutQuad", 250)
	end, 300, 1)

	playerDutyGroups = {}
	---------------------------- Player Ranks [Left] ----------------------------
	editMemRankGridlist = emGUI:dxCreateGridList(0.01, 0.06, 0.29, 0.72, true, editMemberGUI, true)
	emGUI:dxGridListAddColumn(editMemRankGridlist, "Player Rank", 1)
	for i, rank in ipairs(factionRanks) do
		local row = emGUI:dxGridListAddRow(editMemRankGridlist)
		emGUI:dxGridListSetItemText(editMemRankGridlist, row, 1, rank[1])
	end
	emGUI:dxGridListSetSelectedItem(editMemRankGridlist, playerRank)

	---------------------------- Available Duty Groups [Center] ----------------------------
	editAllGroupsGridlist = emGUI:dxCreateGridList(0.32, 0.06, 0.29, 0.72, true, editMemberGUI, true)
	emGUI:dxGridListAddColumn(editAllGroupsGridlist, "Available Duty Groups", 1)
	factionDutyGroups = fromJSON(factionDutyGroups)

	---------------------------- Player Duty Groups [Right] ------------------------------------------
	editMemDutyGridlist = emGUI:dxCreateGridList(0.70, 0.06, 0.29, 0.72, true, editMemberGUI, true)
	emGUI:dxGridListAddColumn(editMemDutyGridlist, "Player Duty Groups", 1)
	emGUI:dxGridListSetMultiSelectionEnabled(editMemDutyGridlist, true)
	factionDutyPerks = fromJSON(factionDutyPerks)

	for i, group in pairs(factionDutyGroups) do
		local beenAdded = false
		for v, hasGroup in pairs(factionDutyPerks) do
			if (group.name == hasGroup) then
				local row = emGUI:dxGridListAddRow(editMemDutyGridlist)
				emGUI:dxGridListSetItemText(editMemDutyGridlist, row, 1, hasGroup)
				playerDutyGroups[hasGroup] = hasGroup
				beenAdded = true
			end
		end

		if not beenAdded then
			local row = emGUI:dxGridListAddRow(editAllGroupsGridlist)
			emGUI:dxGridListSetItemText(editAllGroupsGridlist, row, 1, group.name)
		end
	end

	---------------------------- Buttons ------------------------------------------
	editMemLeaderOffbutton = emGUI:dxCreateButton(0.01, 0.81, 0.29, 0.08, "Faction Member", true, editMemberGUI)
	editMemLeaderOnButton = emGUI:dxCreateButton(0.01, 0.888, 0.29, 0.08, "Faction Leader", true, editMemberGUI)
	if playerLeader then
		emGUI:dxSetEnabled(editMemLeaderOffbutton, true)
		emGUI:dxSetEnabled(editMemLeaderOnButton, false)
	else
		emGUI:dxSetEnabled(editMemLeaderOffbutton, false)
		emGUI:dxSetEnabled(editMemLeaderOnButton, true)
	end
	addEventHandler("onClientDgsDxMouseClick", editMemLeaderOffbutton, editMemHandleButtonSwap)
	addEventHandler("onClientDgsDxMouseClick", editMemLeaderOnButton, editMemHandleButtonSwap)


	dutyGroupAddButton = emGUI:dxCreateButton(0.62, 0.33, 0.07, 0.09, "⏩", true, editMemberGUI)
	emGUI:dxSetEnabled(dutyGroupAddButton, false)
	addEventHandler("onClientDgsDxMouseClick", dutyGroupAddButton, handleDutyGroupAssign)
	dutyGroupRemoveButton = emGUI:dxCreateButton(0.62, 0.43, 0.07, 0.09, "⏪", true, editMemberGUI)
	emGUI:dxSetEnabled(dutyGroupRemoveButton, false)
	addEventHandler("onClientDgsDxMouseClick", dutyGroupRemoveButton, handleDutyGroupAssign)

	local isKicking = false
	local memKickMemberButton = emGUI:dxCreateButton(0.32, 0.81, 0.21, 0.16, "Remove\nMember", true, editMemberGUI)
	addEventHandler("onClientDgsDxMouseClick", memKickMemberButton, function(b, c)
			if (b == "left") and (c == "down") then
				if not isKicking then
					emGUI:dxSetText(memKickMemberButton, "Are you sure?")
					emGUI:dxButtonSetColor(memKickMemberButton, tocolor(255, 0, 0), tocolor(230, 0, 0), tocolor(200, 0, 0))
					isKicking = true
				else
					isKicking = false
					emGUI:dxMoveTo(editMemberGUI, 0.23, 1, true, false, "OutQuad", 250)
					triggerServerEvent("faction:menu:kickFactionMember", localPlayer, characterID)
					setTimer(function()
						if emGUI:dxIsWindowVisible(factionMenuGUI) then emGUI:dxCloseWindow(factionMenuGUI) end
						if emGUI:dxIsWindowVisible(editMemberGUI) then emGUI:dxCloseWindow(editMemberGUI) end
					end, 300, 1)
				end
			end
		end)

	local memDiscardChangesButton = emGUI:dxCreateButton(0.55, 0.81, 0.21, 0.16, "Discard\nAll Changes", true, editMemberGUI)
	addEventHandler("onClientDgsDxMouseClick", memDiscardChangesButton, function(b, c)
		if (b == "left") and (c == "down") then
			emGUI:dxMoveTo(editMemberGUI, 0.23, 1, true, false, "OutQuad", 250)
			setTimer(function()
				if emGUI:dxIsWindowVisible(editMemberGUI) then emGUI:dxCloseWindow(editMemberGUI) end
				emGUI:dxMoveTo(factionMenuGUI, 0.22, 0.22, true, false, "OutQuad", 250)
			end, 300, 1)
		end
	end)

	editMemUpdateButton = emGUI:dxCreateButton(0.78, 0.81, 0.21, 0.16, "Update\nMember", true, editMemberGUI)
	addEventHandler("onClientDgsDxMouseClick", editMemUpdateButton, function(b, c)
		if (b == "left") and (c == "down") then
			local selectedRank = emGUI:dxGridListGetSelectedItem(editMemRankGridlist)
			if not (selectedRank or selectedRank == -1) then
				outputChatBox("ERROR: Select a rank for the player!", 255, 0, 0)
				return
			end

			local leaderStatus = emGUI:dxGetEnabled(editMemLeaderOffbutton) or false; if leaderStatus then leaderStatus = 1 else leaderStatus = 0 end
			local selectedRankName = factionRanks[selectedRank][1]
			local parsedGroupTable = {}
			for i, group in pairs(playerDutyGroups) do table.insert(parsedGroupTable, group) end

			parsedGroupTable = toJSON(parsedGroupTable)

			triggerServerEvent("faction:menu:updateMemberCall", localPlayer, factionID, characterID, playerName, selectedRank, selectedRankName, leaderStatus, parsedGroupTable)

			emGUI:dxMoveTo(editMemberGUI, 0.23, 1, true, false, "OutQuad", 250)
			setTimer(function()
				emGUI:dxCloseWindow(factionMenuGUI)
				if emGUI:dxIsWindowVisible(editMemberGUI) then emGUI:dxCloseWindow(editMemberGUI) end
				triggerServerEvent("faction:showFactionMenuCall", localPlayer, localPlayer, factionID, true)
			end, 300, 1)
		end
	end)

	addEventHandler("ondxGridListSelect", editAllGroupsGridlist, function(c) emGUI:dxSetEnabled(dutyGroupAddButton, c ~= -1) end)
	addEventHandler("ondxGridListSelect", editMemDutyGridlist, function(c) emGUI:dxSetEnabled(dutyGroupRemoveButton, c ~= -1) end)
end
addEvent("faction:menu:showMemberEditorGUI", true)
addEventHandler("faction:menu:showMemberEditorGUI", root, showMemberEditorGUI)

function editMemHandleButtonSwap(b, c)
	if (b == "left") and (c == "down") then
		local state = source == editMemLeaderOffbutton
		emGUI:dxSetEnabled(editMemLeaderOffbutton, not state)
		emGUI:dxSetEnabled(editMemLeaderOnButton, state)
	end
end

function handleDutyGroupAssign(b, c)
	if (b == "left") and (c == "down") then
		if (source == dutyGroupAddButton) then
			if playerDutyGroups[dutyGroup] then return end
			local s = emGUI:dxGridListGetSelectedItem(editAllGroupsGridlist)
			local dutyGroup = emGUI:dxGridListGetItemText(editAllGroupsGridlist, s, 1)
			emGUI:dxGridListRemoveRow(editAllGroupsGridlist, s)

			local row = emGUI:dxGridListAddRow(editMemDutyGridlist)
			emGUI:dxGridListSetItemText(editMemDutyGridlist, row, 1, dutyGroup)
			playerDutyGroups[dutyGroup] = dutyGroup

			local rowCount = emGUI:dxGridListGetRowCount(editAllGroupsGridlist)
			if (rowCount == 0) or (rowCount < s) then emGUI:dxSetEnabled(dutyGroupAddButton, false) end
		elseif (source == dutyGroupRemoveButton) then
			local s = emGUI:dxGridListGetSelectedItem(editMemDutyGridlist)
			local dutyGroup = emGUI:dxGridListGetItemText(editMemDutyGridlist, s, 1)
			emGUI:dxGridListRemoveRow(editMemDutyGridlist, s)

			local row = emGUI:dxGridListAddRow(editAllGroupsGridlist)
			emGUI:dxGridListSetItemText(editAllGroupsGridlist, row, 1, dutyGroup)
			playerDutyGroups[dutyGroup] = nil

			local rowCount = emGUI:dxGridListGetRowCount(editMemDutyGridlist)
			if (rowCount == 0) or (rowCount < s) then emGUI:dxSetEnabled(dutyGroupRemoveButton, false) end
		end
	end
end

---------------------------------------------------------------------------------------------------------------------------------------

function showMotdEditorGUI(oldFacMotd)
	if emGUI:dxIsWindowVisible(motdEditorGUI) then
		emGUI:dxMoveTo(motdEditorGUI, 0.26, 1, true, false, "OutQuad", 250)
		setTimer(function()
			if emGUI:dxIsWindowVisible(motdEditorGUI) then emGUI:dxCloseWindow(motdEditorGUI) end
		end, 300, 1)
		return
	end
	if emGUI:dxIsWindowVisible(logoEditorGUI) then emGUI:dxCloseWindow(logoEditorGUI) end

	motdEditorGUI = emGUI:dxCreateWindow(0.26, 1, 0.48, 0.11, "Update Faction Message of The Day (MOTD)", true)
	emGUI:dxMoveTo(motdEditorGUI, 0.26, 0.80, true, false, "OutQuad", 250)

	emGUI:dxCreateLabel(0.04, 0.29, 0.04, 0.15, "Line 1", true, motdEditorGUI)
	emGUI:dxCreateLabel(0.04, 0.59, 0.04, 0.15, "Line 2", true, motdEditorGUI)

	local firstLine, _, secondLine = oldFacMotd:match('^(.*)(\n)(.*)$')
	if not string.find(oldFacMotd, "\n") then firstLine = oldFacMotd; secondLine = "" end
	local motdLine1Input = emGUI:dxCreateEdit(0.09, 0.27, 0.58, 0.23, firstLine, true, motdEditorGUI)
	local motdLine2Input = emGUI:dxCreateEdit(0.09, 0.58, 0.58, 0.23, secondLine, true, motdEditorGUI)
	emGUI:dxEditSetMaxLength(motdLine1Input, 100)
	emGUI:dxEditSetMaxLength(motdLine2Input, 100)

	motdPreviewButton = emGUI:dxCreateButton(0.68, 0.27, 0.13, 0.54, "PREVIEW", true, motdEditorGUI)
	local isSaving = false
	addEventHandler("onClientDgsDxMouseClick", motdPreviewButton, function(b, c)
		if (b == "left") and (c == "down") then
			local motdText = emGUI:dxGetText(motdLine1Input) .. "\n" .. emGUI:dxGetText(motdLine2Input)
			emGUI:dxSetText(motdLabel, motdText)
		end
	end)

	motdApplyButton = emGUI:dxCreateButton(0.83, 0.27, 0.13, 0.54, "APPLY", true, motdEditorGUI)
	addEventHandler("onClientDgsDxMouseClick", motdApplyButton, function(b, c)
		if (b == "left") and (c == "down") then
			isSaving = true
			local motdLine1 = emGUI:dxGetText(motdLine1Input) or ""
			local motdLine2 = emGUI:dxGetText(motdLine2Input) or ""

			local motdText = motdLine1 .. "\n" .. motdLine2
			triggerServerEvent("faction:menu:updateFactionMotd", localPlayer, motdText)
			emGUI:dxSetText(motdLabel, motdText)
			emGUI:dxMoveTo(motdEditorGUI, 0.26, 1, true, false, "OutQuad", 250)
			setTimer(function()
				if emGUI:dxIsWindowVisible(motdEditorGUI) then emGUI:dxCloseWindow(motdEditorGUI) end
			end, 300, 1)
		end
	end)

	addEventHandler("onDgsWindowClose", motdEditorGUI, function()
		if not isSaving and emGUI:dxIsWindowVisible(factionMenuGUI) then emGUI:dxSetText(motdLabel, oldFacMotd)  end
	end)

	addEventHandler("onDgsTabPanelTabSelect", factionMenuTabPanel, function()
		if emGUI:dxIsWindowVisible(motdEditorGUI) then emGUI:dxCloseWindow(motdEditorGUI) end
	end)
end

function showLogoEditorGUI()
	if emGUI:dxIsWindowVisible(logoEditorGUI) then
		emGUI:dxMoveTo(logoEditorGUI, 0.26, 1, true, false, "OutQuad", 250)
		setTimer(function()
			if emGUI:dxIsWindowVisible(logoEditorGUI) then emGUI:dxCloseWindow(logoEditorGUI) end
		end, 300, 1)
		return
	end
	if emGUI:dxIsWindowVisible(motdEditorGUI) then emGUI:dxCloseWindow(motdEditorGUI) end

	logoEditorGUI = emGUI:dxCreateWindow(0.26, 1, 0.48, 0.11, "Adjust Faction Logo", true)
	emGUI:dxMoveTo(logoEditorGUI, 0.26, 0.80, true, false, "OutQuad", 250)

	emGUI:dxCreateLabel(0.04, 0.29, 0.04, 0.15, "Logo URL (png, jpg from www.imgur.com):", true, logoEditorGUI)

	local logoURLInput = emGUI:dxCreateEdit(0.04, 0.56, 0.58, 0.23, "", true, logoEditorGUI)
	emGUI:dxEditSetMaxLength(logoURLInput, 60)

	logoPreviewButton = emGUI:dxCreateButton(0.68, 0.27, 0.13, 0.54, "PREVIEW", true, logoEditorGUI)
	local isSaving = false
	addEventHandler("onClientDgsDxMouseClick", logoPreviewButton, function(b, c)
		if (b == "left") and (c == "down") then
			-- do something here xdd
		end
	end)

	logoApplyButton = emGUI:dxCreateButton(0.83, 0.27, 0.13, 0.54, "APPLY", true, logoEditorGUI)
	addEventHandler("onClientDgsDxMouseClick", logoApplyButton, function(b, c)
		if (b == "left") and (c == "down") then
			isSaving = true
			local logoURL = emGUI:dxGetText(logoURLInput) or ""

			--trigg server event

			emGUI:dxMoveTo(logoEditorGUI, 0.26, 1, true, false, "OutQuad", 250)
			setTimer(function()
				if emGUI:dxIsWindowVisible(logoEditorGUI) then emGUI:dxCloseWindow(logoEditorGUI) end
			end, 300, 1)
		end
	end)

	addEventHandler("onDgsWindowClose", logoEditorGUI, function()
		if not isSaving and emGUI:dxIsWindowVisible(factionMenuGUI) then --[[change image back here]] end
	end)

	addEventHandler("onDgsTabPanelTabSelect", factionMenuTabPanel, function()
		if emGUI:dxIsWindowVisible(logoEditorGUI) then emGUI:dxCloseWindow(logoEditorGUI) end
	end)
end

function showRankEditor(ranksTable)
	if emGUI:dxIsWindowVisible(rankWageEditorGUI) then emGUI:dxCloseWindow(rankWageEditorGUI) return end

	emGUI:dxMoveTo(factionMenuGUI, 0.22, 1, true, false, "OutQuad", 250)
	rankWageEditorGUI = emGUI:dxCreateWindow(0.36, 1, 0.29, 0.35, "Edit Ranks & Wages", true, _, _, true)
	
	setTimer(function()
		emGUI:dxMoveTo(rankWageEditorGUI, 0.36, 0.32, true, false, "OutQuad", 250)
	end, 300, 1)

	local rwRanksGridlist = emGUI:dxCreateGridList(0.01, 0.01, 0.46, 0.97, true, rankWageEditorGUI, true)

	emGUI:dxGridListAddColumn(rwRanksGridlist, "Rank Name", 0.7)
	emGUI:dxGridListAddColumn(rwRanksGridlist, "Wages", 0.3)

	for i, rank in ipairs(ranksTable) do
		emGUI:dxGridListAddRow(rwRanksGridlist)
		emGUI:dxGridListSetItemText(rwRanksGridlist, i, 1, rank[1] or "Default Rank")
		emGUI:dxGridListSetItemText(rwRanksGridlist, i, 2, rank[2] or 0)
	end
	emGUI:dxGridListSetSelectedItem(rwRanksGridlist, 1)

	emGUI:dxCreateLabel(0.50, 0.09, 0.12, 0.04, "Rank Name", true, rankWageEditorGUI)
	emGUI:dxCreateLabel(0.50, 0.315, 0.03, 0.05, "$", true, rankWageEditorGUI)
	emGUI:dxCreateLabel(0.50, 0.24, 0.21, 0.04, "Wages ($/Per Hour)", true, rankWageEditorGUI)

	local rwFeedbackLabel = emGUI:dxCreateLabel(0.58, 0.4, 0.3, 0.1, "", true, rankWageEditorGUI)
	emGUI:dxLabelSetHorizontalAlign(rwFeedbackLabel, "center")

	local rwRankNameInput = emGUI:dxCreateEdit(0.50, 0.15, 0.43, 0.06, ranksTable[1][1], true, rankWageEditorGUI)
	local rwWagesInput = emGUI:dxCreateEdit(0.53, 0.31, 0.25, 0.06, ranksTable[1][2], true, rankWageEditorGUI)
	emGUI:dxEditSetMaxLength(rwRankNameInput, 30)
	emGUI:dxEditSetMaxLength(rwWagesInput, 4)

	local rwApplyButton = emGUI:dxCreateButton(0.55, 0.52, 0.36, 0.19, "Apply Changes", true, rankWageEditorGUI)
	addEventHandler("onClientDgsDxMouseClick", rwApplyButton, function(b, c)
		if (b == "left") and (c == "down") then
			local s = emGUI:dxGridListGetSelectedItem(rwRanksGridlist)
			if s and (s ~= -1) then
				local rankName = emGUI:dxGetText(rwRankNameInput) or ""
				local rankWage = emGUI:dxGetText(rwWagesInput)

				if #rankName < 3 then
					emGUI:dxSetText(rwFeedbackLabel, "Rank name must be between\n3 and 30 characters!")
					emGUI:dxLabelSetColor(rwFeedbackLabel, 255, 0, 0)
					return
				end

				if not tonumber(rankWage) or (tonumber(rankWage) < 0) then
					emGUI:dxSetText(rwFeedbackLabel, "That isn't a valid wage amount!")
					emGUI:dxLabelSetColor(rwFeedbackLabel, 255, 0, 0)
					return
				end

				emGUI:dxGridListSetItemText(rwRanksGridlist, s, 1, rankName)
				emGUI:dxGridListSetItemText(rwRanksGridlist, s, 2, rankWage)
				emGUI:dxSetText(rwFeedbackLabel, "Changes have been applied.\nSave changes for them to take effect.")
				emGUI:dxLabelSetColor(rwFeedbackLabel, 0, 255, 0)
			end
		end
	end)

	local rwSaveButton = emGUI:dxCreateButton(0.55, 0.76, 0.36, 0.19, "Save Changes", true, rankWageEditorGUI)
	addEventHandler("onClientDgsDxMouseClick", rwSaveButton, function(b, c)
		if (b == "left") and (c == "down") then
			local ranksTable = {}
			for i = 1, NUMBER_OF_RANKS do
				ranksTable[i] = {
					emGUI:dxGridListGetItemText(rwRanksGridlist, i, 1),
					emGUI:dxGridListGetItemText(rwRanksGridlist, i, 2),
				}
			end

			if #ranksTable ~= NUMBER_OF_RANKS then
				emGUI:dxSetText(rwFeedbackLabel, "Failed to save ranks, recheck all\nvalues and try again.")
				emGUI:dxLabelSetColor(rwFeedbackLabel, 255, 0, 0)
				return
			end

			triggerServerEvent("faction:menu:updateFactionRanksWages", localPlayer, ranksTable)
			emGUI:dxMoveTo(rankWageEditorGUI, 0.36, 1, true, false, "OutQuad", 250)
			setTimer(function()
				if emGUI:dxIsWindowVisible(factionMenuGUI) then emGUI:dxCloseWindow(factionMenuGUI) end
				if emGUI:dxIsWindowVisible(rankWageEditorGUI) then emGUI:dxCloseWindow(rankWageEditorGUI) end
			end, 300, 1)	
		end
	end)

	local returnToMenuButton = emGUI:dxCreateButton(0, -0.071, 0.05, 0.071, "↩️", true, rankWageEditorGUI, _, _, _, _, _, _, tocolor(50, 200, 0, 0))
	addEventHandler("onClientDgsDxMouseClick", returnToMenuButton, function(b, c)
		if (b == "left") and (c == "down") then
			emGUI:dxMoveTo(rankWageEditorGUI, 0.36, 1, true, false, "OutQuad", 250)
			setTimer(function()
				emGUI:dxMoveTo(factionMenuGUI, 0.22, 0.22, true, false, "OutQuad", 250)
				if emGUI:dxIsWindowVisible(rankWageEditorGUI) then emGUI:dxCloseWindow(rankWageEditorGUI) end
			end, 300, 1)
		end
	end)

	addEventHandler("ondxGridListSelect", rwRanksGridlist, function(s)
		if (s) and (s ~= -1) then
			local rankName = emGUI:dxGridListGetItemText(rwRanksGridlist, s, 1)
			local rankWage = emGUI:dxGridListGetItemText(rwRanksGridlist, s, 2)
			emGUI:dxSetText(rwRankNameInput, rankName)
			emGUI:dxSetText(rwWagesInput, rankWage)
			emGUI:dxSetText(rwFeedbackLabel, "")
		end
	end)
end

---------------------------------------------------------------------------------------------------------------------------------------

function dutyManagerButtonClick(b, c)
	if (b == "left") and (c == "down") then
		if emGUI:dxIsWindowVisible(dutyEditorPreGUI) then return end
		if emGUI:dxIsWindowVisible(motdEditorGUI) then emGUI:dxCloseWindow(motdEditorGUI) end
		if emGUI:dxIsWindowVisible(logoEditorGUI) then emGUI:dxCloseWindow(logoEditorGUI) end

		emGUI:dxMoveTo(factionMenuGUI, 0.22, 1, true, false, "OutQuad", 250)

		dutyEditorPreGUI = emGUI:dxCreateWindow(0.31, 1, 0.38, 0.11, "Duty Manager", true, true, _, true)

		setTimer(function()
			emGUI:dxMoveTo(dutyEditorPreGUI, 0.31, 0.41, true, false, "OutQuad", 250)
		end, 300, 1)

		preDutyLocButton = emGUI:dxCreateButton(0.05, 0.15, 0.25, 0.68, "Duty Locations", true, dutyEditorPreGUI)
		addEventHandler("onClientDgsDxMouseClick", preDutyLocButton, function(b, c)
			if (b == "left") and (c == "down") then
				handleDutyManagerAnimations(1)
			end
		end)
		preDutyGroupEditor = emGUI:dxCreateButton(0.38, 0.15, 0.25, 0.68, "Duty Group\nEditor", true, dutyEditorPreGUI)
		addEventHandler("onClientDgsDxMouseClick", preDutyGroupEditor, function(b, c)
			if (b == "left") and (c == "down") then
				handleDutyManagerAnimations(2)
			end
		end)
		preVehPermissionButton = emGUI:dxCreateButton(0.71, 0.15, 0.25, 0.68, "Vehicle\nPermissions", true, dutyEditorPreGUI)
		addEventHandler("onClientDgsDxMouseClick", preVehPermissionButton, function(b, c)
			if (b == "left") and (c == "down") then
				handleDutyManagerAnimations(3)
			end
		end)

		local returnToMenuButton = emGUI:dxCreateButton(0, -0.27, 0.036, 0.27, "↩️", true, dutyEditorPreGUI, _, _, _, _, _, _, tocolor(50, 200, 0, 0))
		addEventHandler("onClientDgsDxMouseClick", returnToMenuButton, function(b, c)
			if (b == "left") and (c == "down") then
				handleDutyManagerAnimations(0)
			end
		end)
	end
end

function handleDutyManagerAnimations(toUI)
	-- Move selector GUI up.
	local guix, guiy = emGUI:dxGetPosition(dutyEditorPreGUI, true)
	if (guiy == 0.41) then
		emGUI:dxMoveTo(dutyEditorPreGUI, 0.31, 0.14, true, false, "OutQuad", 250)
	end

	-- GUI handler.
	local openGUI = false
	if emGUI:dxIsWindowVisible(deDutyLocationsGUI) then openGUI = deDutyLocationsGUI
		elseif emGUI:dxIsWindowVisible(dutyGroupManagerGUI) then openGUI = dutyGroupManagerGUI; if emGUI:dxIsWindowVisible(dutyGroupLocationsGUI) then emGUI:dxCloseWindow(dutyGroupLocationsGUI) end
		elseif emGUI:dxIsWindowVisible(vehiclePermissionGUI) then openGUI = vehiclePermissionGUI
	end

	if openGUI then
		local guix, guiy = emGUI:dxGetPosition(openGUI, true)
		emGUI:dxMoveTo(openGUI, guix, 1, true, false, "OutQuad", 250)
		setTimer(function() if emGUI:dxIsWindowVisible(openGUI) then emGUI:dxCloseWindow(openGUI) end end, 300, 1)
	end


	-- Button handler.
	if not emGUI:dxGetEnabled(preDutyLocButton) then emGUI:dxSetEnabled(preDutyLocButton, true) end
	if not emGUI:dxGetEnabled(preVehPermissionButton) then emGUI:dxSetEnabled(preVehPermissionButton, true) end
	if not emGUI:dxGetEnabled(preDutyGroupEditor) then emGUI:dxSetEnabled(preDutyGroupEditor, true) end

	if (toUI == 1) then -- Duty locations.
		triggerServerEvent("faction:menu:fetchFactionDutyLocations", localPlayer)
		emGUI:dxSetEnabled(preDutyLocButton, false)
	elseif (toUI == 2) then -- Duty Group Editor.
		triggerServerEvent("faction:menu:fetchFactionDutyManagerInfo", localPlayer)
		emGUI:dxSetEnabled(preDutyGroupEditor, false)
	elseif (toUI == 3) then -- Vehicle permissions.
		triggerServerEvent("faction:menu:showVehiclePermEditorMenu", localPlayer, true)
		emGUI:dxSetEnabled(preVehPermissionButton, false)
	else -- Return to faction menu.
		emGUI:dxMoveTo(dutyEditorPreGUI, 0.31, 1, true, false, "OutQuad", 250)

		setTimer(function()
			emGUI:dxCloseWindow(dutyEditorPreGUI)
			emGUI:dxMoveTo(factionMenuGUI, 0.22, 0.22, true, false, "OutQuad", 300)
		end, 300, 1)
	end
end

function showDutyLocationEditorGUI(dutyLocData, animateIn)
	if emGUI:dxIsWindowVisible(deDutyLocationsGUI) then emGUI:dxCloseWindow(deDutyLocationsGUI) end
	local y = 0.28; if animateIn then y = 1 end
	deDutyLocationsGUI = emGUI:dxCreateWindow(0.26, y, 0.48, 0.43, "Duty Locations", true, true, _, true)
	if animateIn then emGUI:dxMoveTo(deDutyLocationsGUI, 0.26, 0.28, true, false, "OutQuad", 250) end

	deDutyLocationGridlist = emGUI:dxCreateGridList(0.01, 0.02, 0.60, 0.72, true, deDutyLocationsGUI, true)
	emGUI:dxGridListAddColumn(deDutyLocationGridlist, "Duty Point", 0.3)
	emGUI:dxGridListAddColumn(deDutyLocationGridlist, "x", 0.15)
	emGUI:dxGridListAddColumn(deDutyLocationGridlist, "y", 0.15)
	emGUI:dxGridListAddColumn(deDutyLocationGridlist, "z", 0.15)
	emGUI:dxGridListAddColumn(deDutyLocationGridlist, "Dimension", 0.13)
	emGUI:dxGridListAddColumn(deDutyLocationGridlist, "Interior", 0.1)

	deDutyVehicleGridlist = emGUI:dxCreateGridList(0.62, 0.02, 0.37, 0.72, true, deDutyLocationsGUI, true)
	emGUI:dxGridListAddColumn(deDutyVehicleGridlist, "Duty Vehicle Name", 0.83)
	emGUI:dxGridListAddColumn(deDutyVehicleGridlist, "VIN", 0.17)


	dutyNameLabel = emGUI:dxCreateLabel(0.02, 0.81, 0.12, 0.03, "Duty Point Name", true, deDutyLocationsGUI)
	deDutyLocNameInput = emGUI:dxCreateEdit(0.02, 0.86, 0.29, 0.06, "", true, deDutyLocationsGUI)
	emGUI:dxEditSetMaxLength(deDutyLocNameInput, 40)

	deDutyRemDutyButton = emGUI:dxCreateButton(0.333, 0.79, 0.21, 0.075, "Remove Duty Point", true, deDutyLocationsGUI)
	emGUI:dxSetEnabled(deDutyRemDutyButton, false)
	addEventHandler("onClientDgsDxMouseClick", deDutyRemDutyButton, handleDutyPointRemove)

	deDutyRemDutyVehButton = emGUI:dxCreateButton(0.333, 0.875, 0.21, 0.075, "Remove Duty Vehicle", true, deDutyLocationsGUI)
	emGUI:dxSetEnabled(deDutyRemDutyVehButton, false)
	addEventHandler("onClientDgsDxMouseClick", deDutyRemDutyVehButton, handleDutyPointRemove)

	deDutyLocAddButton = emGUI:dxCreateButton(0.555, 0.79, 0.21, 0.16, "Insert Duty Point\n(Current Location)", true, deDutyLocationsGUI)
	addEventHandler("onClientDgsDxMouseClick", deDutyLocAddButton, handleDutyPointAdd)

	deDutyLocAddVehButton = emGUI:dxCreateButton(0.777, 0.79, 0.21, 0.16, "Insert\nCurrent Vehicle", true, deDutyLocationsGUI)
	addEventHandler("onClientDgsDxMouseClick", deDutyLocAddVehButton, handleDutyPointAdd)
	local theVehicle = getPedOccupiedVehicle(localPlayer)
	if not theVehicle then emGUI:dxSetEnabled(deDutyLocAddVehButton, false) end

	if not dutyLocData then dutyLocData = {} end
	for i, dutypoint in ipairs(dutyLocData) do
		if (dutypoint.isvehicle == 0) then
			local row = emGUI:dxGridListAddRow(deDutyLocationGridlist)
			emGUI:dxGridListSetItemText(deDutyLocationGridlist, row, 1, dutypoint.name)
			local loc = split(dutypoint.location, ",")
			emGUI:dxGridListSetItemText(deDutyLocationGridlist, row, 2, loc[1])
			emGUI:dxGridListSetItemText(deDutyLocationGridlist, row, 3, loc[2])
			emGUI:dxGridListSetItemText(deDutyLocationGridlist, row, 4, loc[3])
			emGUI:dxGridListSetItemText(deDutyLocationGridlist, row, 5, loc[4])
			emGUI:dxGridListSetItemText(deDutyLocationGridlist, row, 6, loc[5])
		else
			local row = emGUI:dxGridListAddRow(deDutyVehicleGridlist)
			emGUI:dxGridListSetItemText(deDutyVehicleGridlist, row, 1, dutypoint.name)
			emGUI:dxGridListSetItemText(deDutyVehicleGridlist, row, 2, dutypoint.location)
		end
	end

	addEventHandler("ondxGridListSelect", deDutyLocationGridlist, function(c)
		emGUI:dxSetEnabled(deDutyRemDutyButton, c ~= -1)
	end)

	addEventHandler("ondxGridListSelect", deDutyVehicleGridlist, function(c)
		emGUI:dxSetEnabled(deDutyRemDutyVehButton, c ~= -1)
	end)
end
addEvent("faction:menu:showDutyLocationEditorGUI", true)
addEventHandler("faction:menu:showDutyLocationEditorGUI", root, showDutyLocationEditorGUI)

function handleDutyPointAdd(b, c)
	if (b == "left") and (c == "down") then
		local dutyName = emGUI:dxGetText(deDutyLocNameInput) or ""
		if #dutyName < 1 then
			emGUI:dxLabelSetColor(dutyNameLabel, 255, 0, 0)
			setTimer(function() if emGUI:dxIsWindowVisible(deDutyLocationsGUI) then emGUI:dxLabelSetColor(dutyNameLabel, 255, 255, 255) end end, 3000, 1)
			return
		end

		local parsedLocation = {}
		local theVehicle = getPedOccupiedVehicle(localPlayer) or false
		if (source == deDutyLocAddButton) then
			theVehicle = false
			local x, y, z = getElementPosition(localPlayer)
			local dim, int = getElementDimension(localPlayer), getElementInterior(localPlayer)
			parsedLocation = {x, y, z, dim, int}
		elseif (source == deDutyLocAddVehButton) then
			if theVehicle then
				parsedLocation[1] = getElementData(theVehicle, "vehicle:id")
			end
		end

		triggerServerEvent("faction:menu:addFactionDutyPoint", localPlayer, dutyName, parsedLocation, theVehicle)
	end
end

function handleDutyPointRemove(b, c)
	if (b == "left") and (c == "down") then
		local sel = -1
		local id = false
		if (source == deDutyRemDutyButton) then
			sel = emGUI:dxGridListGetSelectedItem(deDutyLocationGridlist)
			id = deDutyLocationGridlist
		elseif (source == deDutyRemDutyVehButton) then
			sel = emGUI:dxGridListGetSelectedItem(deDutyVehicleGridlist)
			id = deDutyVehicleGridlist
		end

		local pointName = emGUI:dxGridListGetItemText(id, sel, 1)
		triggerServerEvent("faction:menu:removeFactionDutyPoint", localPlayer, pointName)
	end
end

---------------------------------------------------------------------------------------------------------------------------------------

function showFactionGroupManager(groupData, itemData, animateIn)
	local groupData = fromJSON(groupData)
	local factionItems = fromJSON(itemData.item_table)
	local factionSkins = fromJSON(itemData.skin_table)

	if not groupData or not factionItems or not factionSkins then
		outputChatBox("ERROR: Something went wrong whilst fetching duty group data.", 255, 0, 0)
		return
	end

	if emGUI:dxIsWindowVisible(dutyGroupManagerGUI) then emGUI:dxCloseWindow(dutyGroupManagerGUI) end
	local y = 0.26; if animateIn then y = 1 end

	dutyGroupManagerGUI = emGUI:dxCreateWindow(0.17, y, 0.67, 0.62, "Duty Group Manager", true, true, _, true)
	if animateIn then emGUI:dxMoveTo(dutyGroupManagerGUI, 0.17, 0.26, true, false, "OutQuad", 250) end

	-------------------------------- ADDING GROUPS --------------------------------
	local dutyGroupNewLabel = emGUI:dxCreateLabel(0.025, 0.635, 0.13, 0.02, "New Group Name", true, dutyGroupManagerGUI)
	dutyNewGroupInput = emGUI:dxCreateEdit(0.025, 0.67, 0.19, 0.035, "", true, dutyGroupManagerGUI)
	emGUI:dxEditSetMaxLength(dutyNewGroupInput, 30)

	local dutyWagesLabel = emGUI:dxCreateLabel(0.025, 0.716, 0.13, 0.02, "Group Wages ($/H)", true, dutyGroupManagerGUI)
	dutyWagesLabelInput = emGUI:dxCreateEdit(0.135, 0.714, 0.08, 0.035, "", true, dutyGroupManagerGUI)
	emGUI:dxEditSetMaxLength(dutyWagesLabelInput, 4)

	dutyGroupsGridlist = emGUI:dxCreateGridList(0.01, 0.02, 0.22, 0.6, true, dutyGroupManagerGUI)
	emGUI:dxGridListSetSortEnabled(dutyGroupsGridlist, false)
	emGUI:dxGridListAddColumn(dutyGroupsGridlist, "Group Name", 1)
	dutyCreateGroupButton = emGUI:dxCreateButton(0.03, 0.76, 0.18, 0.10, "Create New\nDuty Group", true, dutyGroupManagerGUI)
	dutyDeleteGroupButton = emGUI:dxCreateButton(0.03, 0.87, 0.18, 0.10, "Delete Selected\nDuty Group", true, dutyGroupManagerGUI)
	emGUI:dxSetEnabled(dutyDeleteGroupButton, false)
	addEventHandler("onClientDgsDxMouseClick", dutyDeleteGroupButton, function(b, c)
		if (b == "left") and (c == "down") then
			local sel = emGUI:dxGridListGetSelectedItem(dutyGroupsGridlist)
			local groupName = emGUI:dxGridListGetItemText(dutyGroupsGridlist, sel, 1)

			triggerServerEvent("faction:menu:factionDutyDeleteGroup", localPlayer, groupName, groupData)
		end
	end)

	for i, group in pairs(groupData) do
		local row = emGUI:dxGridListAddRow(dutyGroupsGridlist)
		emGUI:dxGridListSetItemText(dutyGroupsGridlist, row, 1, group.name)
	end

	local totalGroups = emGUI:dxGridListGetRowCount(dutyGroupsGridlist)
	if (totalGroups >= NUMBER_OF_GROUPS) then emGUI:dxSetEnabled(dutyCreateGroupButton, false) end

	addEventHandler("onClientDgsDxMouseClick", dutyCreateGroupButton, function(b, c)
	if (b == "left") and (c == "down") then
			local groupNameInput = emGUI:dxGetText(dutyNewGroupInput) or ""

			if #groupNameInput < 1 then
				emGUI:dxLabelSetColor(dutyGroupNewLabel, 255, 0, 0)
				setTimer(function() if emGUI:dxIsWindowVisible(dutyGroupManagerGUI) then emGUI:dxLabelSetColor(dutyGroupNewLabel, 255, 255, 255) end end, 3000, 1)
				return
			end

			local groupWages = emGUI:dxGetText(dutyWagesLabelInput)
			if not tonumber(groupWages) then
				emGUI:dxLabelSetColor(dutyWagesLabel, 255, 0, 0)
				setTimer(function() if emGUI:dxIsWindowVisible(dutyGroupManagerGUI) then emGUI:dxLabelSetColor(dutyWagesLabel, 255, 255, 255) end end, 3000, 1)
				return
			end

			triggerServerEvent("faction:menu:factionDutyCreateGroup", localPlayer, groupNameInput, tonumber(groupWages))
		end
	end)

	-------------------------------- FACTION ITEMS --------------------------------
	emGUI:dxCreateLabel(0.24, 0.02, 0.13, 0.02, "Available Faction Duty Items", true, dutyGroupManagerGUI)
	emGUI:dxCreateLabel(0.66, 0.02, 0.13, 0.02, "Duty Group Items", true, dutyGroupManagerGUI)
	dutyItemAmountLabel = emGUI:dxCreateLabel(0.593, 0.425,  0.08, 0.02, "Amount", true, dutyGroupManagerGUI)

	dutyAvailableItemsGridlist = emGUI:dxCreateGridList(0.24, 0.06, 0.33, 0.912, true, dutyGroupManagerGUI)
	emGUI:dxGridListSetSortEnabled(dutyAvailableItemsGridlist, false)
	emGUI:dxGridListAddColumn(dutyAvailableItemsGridlist, "ID", 0.09)
	emGUI:dxGridListAddColumn(dutyAvailableItemsGridlist, "Item", 0.9)
	for i, itemID in ipairs(factionItems) do
		local row = emGUI:dxGridListAddRow(dutyAvailableItemsGridlist)
		local itemName = exports["item-system"]:getItemName(itemID)
		emGUI:dxGridListSetItemText(dutyAvailableItemsGridlist, row, 1, itemID)
		emGUI:dxGridListSetItemText(dutyAvailableItemsGridlist, row, 2, itemName)
	end
	
	dutyGroupItemsGridlist = emGUI:dxCreateGridList(0.66, 0.06, 0.33, 0.54, true, dutyGroupManagerGUI)
	emGUI:dxGridListSetSortEnabled(dutyGroupItemsGridlist, false)
	emGUI:dxGridListAddColumn(dutyGroupItemsGridlist, "ID", 0.09)
	emGUI:dxGridListAddColumn(dutyGroupItemsGridlist, "Item", 0.78)
	emGUI:dxGridListAddColumn(dutyGroupItemsGridlist, "Amount", 0.13)

	dutyItemAmountInput = emGUI:dxCreateEdit(0.585, 0.46, 0.06, 0.04, "", true, dutyGroupManagerGUI)
	emGUI:dxEditSetMaxLength(dutyItemAmountInput, 3)

	dutyItemAddButton = emGUI:dxCreateButton(0.585, 0.25, 0.06, 0.06, "⏩", true, dutyGroupManagerGUI)
	emGUI:dxSetEnabled(dutyItemAddButton, false)
	addEventHandler("onClientDgsDxMouseClick", dutyItemAddButton, dutyItemsHandleStocking)

	dutyItemRemoveButton = emGUI:dxCreateButton(0.585, 0.33, 0.06, 0.06, "⏪", true, dutyGroupManagerGUI)
	emGUI:dxSetEnabled(dutyItemRemoveButton, false)
	addEventHandler("onClientDgsDxMouseClick", dutyItemRemoveButton, dutyItemsHandleStocking)

	addEventHandler("ondxGridListSelect", dutyAvailableItemsGridlist, function(c)
		local d = emGUI:dxGridListGetSelectedItem(dutyGroupsGridlist) or -1
		emGUI:dxSetEnabled(dutyItemAddButton, c ~= -1 and d ~= -1)
	end)
	addEventHandler("ondxGridListSelect", dutyGroupItemsGridlist, function(c)
		local d = emGUI:dxGridListGetSelectedItem(dutyGroupsGridlist) or -1
		emGUI:dxSetEnabled(dutyItemRemoveButton, c ~= -1 and d ~= -1)
	end)

	-------------------------------- FACTION SKINS --------------------------------
	dutyGroupSkinsGridlist = emGUI:dxCreateGridList(0.58, 0.61, 0.22, 0.36, true, dutyGroupManagerGUI)
	emGUI:dxGridListSetSortEnabled(dutyGroupSkinsGridlist, false)
	emGUI:dxGridListAddColumn(dutyGroupSkinsGridlist, "Skin ID", 0.7)
	emGUI:dxGridListAddColumn(dutyGroupSkinsGridlist, "Available", 0.3)
	for i, skinID in ipairs(factionSkins) do
		local row = emGUI:dxGridListAddRow(dutyGroupSkinsGridlist)
		emGUI:dxGridListSetItemText(dutyGroupSkinsGridlist, row, 1, skinID)
		emGUI:dxGridListSetItemText(dutyGroupSkinsGridlist, row, 2, "")
	end
	
	dutyToggleSkinButton = emGUI:dxCreateButton(0.81, 0.61, 0.18, 0.11, "Toggle Skin\nAvailability", true, dutyGroupManagerGUI)
	emGUI:dxSetEnabled(dutyToggleSkinButton, false)
	addEventHandler("onClientDgsDxMouseClick", dutyToggleSkinButton, function(b, c)
		if (b == "left") and (c == "down") then
			local s = emGUI:dxGridListGetSelectedItem(dutyGroupSkinsGridlist)
			local isActive = emGUI:dxGridListGetItemText(dutyGroupSkinsGridlist, s, 2) == "Yes"
			if isActive then
				emGUI:dxGridListSetItemText(dutyGroupSkinsGridlist, s, 2, "No")
			else
				emGUI:dxGridListSetItemText(dutyGroupSkinsGridlist, s, 2, "Yes")
			end
		end
	end)

	addEventHandler("ondxGridListSelect", dutyGroupSkinsGridlist, function(c)
		local d = emGUI:dxGridListGetSelectedItem(dutyGroupsGridlist) or -1
		emGUI:dxSetEnabled(dutyToggleSkinButton, c ~= -1 and d ~= -1)
	end)

	------------------------------- WAGE EDITOR -----------------------------------

	-------------------------------- DUTY LOCATIONS -------------------------------
	dutyGroupLocationsButton = emGUI:dxCreateButton(0.81, 0.737, 0.18, 0.11, "Duty Locations", true, dutyGroupManagerGUI)
	emGUI:dxSetEnabled(dutyGroupLocationsButton, false)
	addEventHandler("onClientDgsDxMouseClick", dutyGroupLocationsButton, function(b, c)
		if (b == "left") and (c == "down") then
			local s = emGUI:dxGridListGetSelectedItem(dutyGroupsGridlist)
			local groupName = emGUI:dxGridListGetItemText(dutyGroupsGridlist, s, 1)

			triggerServerEvent("faction:menu:fetchDutyGroupLocationData", localPlayer, groupName)
			emGUI:dxMoveTo(dutyGroupManagerGUI, 1, 0.26, true, false, "OutQuad", 350)
		end
	end)	

	------------------------------------ SAVING -----------------------------------
	dutySaveChangesButton = emGUI:dxCreateButton(0.81, 0.86, 0.18, 0.11, "Save Group", true, dutyGroupManagerGUI)
	emGUI:dxSetEnabled(dutySaveChangesButton, false)
	addEventHandler("onClientDgsDxMouseClick", dutySaveChangesButton, handleGroupSaving)

	------------------------------------ EVENTS -----------------------------------
	addEventHandler("ondxGridListSelect", dutyGroupsGridlist, function(c)
		emGUI:dxSetEnabled(dutySaveChangesButton, c ~= -1)
		emGUI:dxSetEnabled(dutyDeleteGroupButton, c ~= -1)
		emGUI:dxSetEnabled(dutyGroupLocationsButton, c~= -1)
		emGUI:dxGridListClear(dutyGroupItemsGridlist)
		gItems = {}
		if (c ~= -1) then
			local selected = emGUI:dxGridListGetItemText(dutyGroupsGridlist, c, 1)
			emGUI:dxSetText(dutyNewGroupInput, selected)
			emGUI:dxSetText(dutyWagesLabelInput, groupData[selected].wages)
			for i, item in ipairs(groupData[selected].items) do
				local row = emGUI:dxGridListAddRow(dutyGroupItemsGridlist)
				local itemName = exports["item-system"]:getItemName(item[1])
				emGUI:dxGridListSetItemText(dutyGroupItemsGridlist, row, 1, item[1])
				emGUI:dxGridListSetItemText(dutyGroupItemsGridlist, row, 2, itemName)
				emGUI:dxGridListSetItemText(dutyGroupItemsGridlist, row, 3, item[2])
				gItems[item[1]] = {row = row, amount = item[2]}
			end

			if (#groupData[selected].skins == 0) then
				for i, j in ipairs(factionSkins) do
					emGUI:dxGridListSetItemText(dutyGroupSkinsGridlist, i, 2, "No")
				end
				return
			end

			for k, skinID in ipairs(factionSkins) do
				for v, skin in ipairs(groupData[selected].skins) do
					if (skin == skinID) then
						emGUI:dxGridListSetItemText(dutyGroupSkinsGridlist, k, 2, "Yes")
						break
					else
						emGUI:dxGridListSetItemText(dutyGroupSkinsGridlist, k, 2, "No")
					end
				end
			end
		else
			for i, j in ipairs(factionSkins) do
				emGUI:dxGridListSetItemText(dutyGroupSkinsGridlist, i, 2, "")
			end
			emGUI:dxSetEnabled(dutyItemAddButton, false)
			emGUI:dxSetEnabled(dutyItemRemoveButton, false)
			emGUI:dxSetEnabled(dutyToggleSkinButton, false)
		end
	end)
end
addEvent("faction:menu:showFactionGroupManager", true)
addEventHandler("faction:menu:showFactionGroupManager", root, showFactionGroupManager)

function dutyItemsHandleStocking(b, c)
	if (b == "left") and (c == "down") then
		local reqAmount = emGUI:dxGetText(dutyItemAmountInput)
		if not tonumber(reqAmount) or (tonumber(reqAmount) < 0) then
			emGUI:dxLabelSetColor(dutyItemAmountLabel, 255, 0, 0)
			setTimer(function() if emGUI:dxIsWindowVisible(dutyGroupManagerGUI) then emGUI:dxLabelSetColor(dutyItemAmountLabel, 255, 255, 255) end end, 3000, 1)
			return
		end

		if (source == dutyItemAddButton) then
			local s = emGUI:dxGridListGetSelectedItem(dutyAvailableItemsGridlist)
			local itemID = emGUI:dxGridListGetItemText(dutyAvailableItemsGridlist, s, 1); itemID = tonumber(itemID)
			local itemName = emGUI:dxGridListGetItemText(dutyAvailableItemsGridlist, s, 2)
			
			if gItems[itemID] then
				local r = gItems[itemID].row
				local newAmount = reqAmount + gItems[itemID].amount
				emGUI:dxGridListSetItemText(dutyGroupItemsGridlist, r, 3, newAmount)
				gItems[itemID] = {row = r, amount = newAmount}
			else
				local row = emGUI:dxGridListAddRow(dutyGroupItemsGridlist)
				emGUI:dxGridListSetItemText(dutyGroupItemsGridlist, row, 1, itemID)
				emGUI:dxGridListSetItemText(dutyGroupItemsGridlist, row, 2, itemName)
				emGUI:dxGridListSetItemText(dutyGroupItemsGridlist, row, 3, reqAmount)
				gItems[itemID] = {row = row, amount = reqAmount}
			end
		elseif (source == dutyItemRemoveButton) then
			local s = emGUI:dxGridListGetSelectedItem(dutyGroupItemsGridlist)
			local itemID = emGUI:dxGridListGetItemText(dutyGroupItemsGridlist, s, 1); itemID = tonumber(itemID)
			local newAmount = gItems[itemID].amount - reqAmount

			if (reqAmount == gItems[itemID].amount) or (newAmount <= 0) then
				emGUI:dxGridListRemoveRow(dutyGroupItemsGridlist, s)
				gItems[itemID] = nil
				emGUI:dxSetEnabled(dutyItemRemoveButton, false)
			else
				emGUI:dxGridListSetItemText(dutyGroupItemsGridlist, s, 3, newAmount)
				gItems[itemID].amount = newAmount
			end
		end
	end
end

---------------------------------------------------------------------------------------------------------------------------------------

function showFactionDutyLocationEditor(groupName, groupData, dutyLocations, animateIn)
	if emGUI:dxIsWindowVisible(dutyGroupLocationsGUI) then emGUI:dxCloseWindow(dutyGroupLocationsGUI) end
	local x = 0.3; if animateIn then x = 1 end
	dutyGroupLocationsGUI = emGUI:dxCreateWindow(x, 0.27, 0.39, 0.56, groupName .. " - Duty Locations", true, true, _, true)
	if animateIn then emGUI:dxMoveTo(dutyGroupLocationsGUI, 0.3, 0.27, true, false, "OutQuad", 350) end

	----------- LEFT SIDE ----------
	dutyLocationsGridlist = emGUI:dxCreateGridList(0.01, 0.01, 0.41, 0.4, true, dutyGroupLocationsGUI)
	emGUI:dxGridListAddColumn(dutyLocationsGridlist, "ID", 0)
	emGUI:dxGridListAddColumn(dutyLocationsGridlist, "Inactive Duty Locations", 1)

	dutyVehiclesLocGridlist = emGUI:dxCreateGridList(0.01, 0.409, 0.41, 0.4, true, dutyGroupLocationsGUI)
	emGUI:dxGridListAddColumn(dutyVehiclesLocGridlist, "ID", 0)
	emGUI:dxGridListAddColumn(dutyVehiclesLocGridlist, "Inactive Duty Vehicles", 1)
	
	----------- RIGHT SIDE ----------
	locDutyLocationsAddedGridlist = emGUI:dxCreateGridList(0.58, 0.01, 0.41, 0.4, true, dutyGroupLocationsGUI)
	emGUI:dxGridListAddColumn(locDutyLocationsAddedGridlist, "ID", 0)
	emGUI:dxGridListAddColumn(locDutyLocationsAddedGridlist, "Active Duty Locations", 1)

	locDutyVehAddedGridlist = emGUI:dxCreateGridList(0.58, 0.409, 0.41, 0.4, true, dutyGroupLocationsGUI)
	emGUI:dxGridListAddColumn(locDutyVehAddedGridlist, "ID", 0)
	emGUI:dxGridListAddColumn(locDutyVehAddedGridlist, "Active Duty Vehicles", 1)

	------------- SORTING FUNCTION -------------------
	groupData = fromJSON(groupData)
	local groupLocations = groupData[groupName].locations
	groupLocations = groupLocations or {}
	local gSelections = {}

	for i, location in ipairs(dutyLocations) do
		local isVehicle = location.isvehicle == 1
		local notAdded = true
		for j, loc in ipairs(groupLocations) do
			-- If location already exists.
			if (tonumber(loc) == location.id) then
				notAdded = false
				gSelections[location.name] = location.id
				if (isVehicle) then -- If it's a duty vehicle.
					local row = emGUI:dxGridListAddRow(locDutyVehAddedGridlist)
					emGUI:dxGridListSetItemText(locDutyVehAddedGridlist, row, 1, location.id)
					emGUI:dxGridListSetItemText(locDutyVehAddedGridlist, row, 2, location.name)
				else -- If it's a duty point.
					local row = emGUI:dxGridListAddRow(locDutyLocationsAddedGridlist)
					emGUI:dxGridListSetItemText(locDutyLocationsAddedGridlist, row, 1, location.id)
					emGUI:dxGridListSetItemText(locDutyLocationsAddedGridlist, row, 2, location.name)
				end
			end
		end

		if notAdded then
			if (isVehicle) then -- If it's a duty vehicle.
				local row = emGUI:dxGridListAddRow(dutyVehiclesLocGridlist)
				emGUI:dxGridListSetItemText(dutyVehiclesLocGridlist, row, 1, location.id)
				emGUI:dxGridListSetItemText(dutyVehiclesLocGridlist, row, 2, location.name)
			else -- If it's a duty point.
				local row = emGUI:dxGridListAddRow(dutyLocationsGridlist)
				emGUI:dxGridListSetItemText(dutyLocationsGridlist, row, 1, location.id)
				emGUI:dxGridListSetItemText(dutyLocationsGridlist, row, 2, location.name)
			end
		end
	end

	----------- CENTER ----------
	dutyLocAddButton = emGUI:dxCreateButton(0.446, 0.15, 0.11, 0.07, "⏩", true, dutyGroupLocationsGUI, _, 1, 1)
	emGUI:dxSetEnabled(dutyLocAddButton, false)
	addEventHandler("onClientDgsDxMouseClick", dutyLocAddButton, function(b, c)
		if (b == "left") and (c == "down") then
			local s = emGUI:dxGridListGetSelectedItem(dutyLocationsGridlist)
			local dutyID = emGUI:dxGridListGetItemText(dutyLocationsGridlist, s, 1); dutyID = tonumber(dutyID)
			local dutyName = emGUI:dxGridListGetItemText(dutyLocationsGridlist, s, 2)
			emGUI:dxGridListRemoveRow(dutyLocationsGridlist, s)
			local rowCount = emGUI:dxGridListGetRowCount(dutyLocationsGridlist)
			if (rowCount == 0) or (rowCount < s) then emGUI:dxSetEnabled(dutyLocAddButton, false) end

			local row = emGUI:dxGridListAddRow(locDutyLocationsAddedGridlist)
			emGUI:dxGridListSetItemText(locDutyLocationsAddedGridlist, row, 1, dutyID)
			emGUI:dxGridListSetItemText(locDutyLocationsAddedGridlist, row, 2, dutyName)
			gSelections[dutyName] = dutyID
		end
	end)

	dutyLocDelButton = emGUI:dxCreateButton(0.446, 0.23, 0.11, 0.07, "⏪", true, dutyGroupLocationsGUI)
	emGUI:dxSetEnabled(dutyLocDelButton, false)
	addEventHandler("onClientDgsDxMouseClick", dutyLocDelButton, function(b, c)
		if (b == "left") and (c == "down") then
			local s = emGUI:dxGridListGetSelectedItem(locDutyLocationsAddedGridlist)
			local dutyID = emGUI:dxGridListGetItemText(locDutyLocationsAddedGridlist, s, 1); dutyID = tonumber(dutyID)
			local dutyName = emGUI:dxGridListGetItemText(locDutyLocationsAddedGridlist, s, 2)
			emGUI:dxGridListRemoveRow(locDutyLocationsAddedGridlist, s)
			local rowCount = emGUI:dxGridListGetRowCount(locDutyLocationsAddedGridlist)
			if (rowCount == 0) or (rowCount < s) then emGUI:dxSetEnabled(dutyLocDelButton, false) end

			local row = emGUI:dxGridListAddRow(dutyLocationsGridlist)
			emGUI:dxGridListSetItemText(dutyLocationsGridlist, row, 1, dutyID)
			emGUI:dxGridListSetItemText(dutyLocationsGridlist, row, 2, dutyName)
			gSelections[dutyName] = nil
		end
	end)

	dutyVehAddButton = emGUI:dxCreateButton(0.446, 0.54, 0.11, 0.07, "⏩", true, dutyGroupLocationsGUI)
	emGUI:dxSetEnabled(dutyVehAddButton, false)
	addEventHandler("onClientDgsDxMouseClick", dutyVehAddButton, function(b, c)
		if (b == "left") and (c == "down") then
			local s = emGUI:dxGridListGetSelectedItem(dutyVehiclesLocGridlist)
			local dutyID = emGUI:dxGridListGetItemText(dutyVehiclesLocGridlist, s, 1); dutyID = tonumber(dutyID)
			local dutyName = emGUI:dxGridListGetItemText(dutyVehiclesLocGridlist, s, 2)
			emGUI:dxGridListRemoveRow(dutyVehiclesLocGridlist, s)
			local rowCount = emGUI:dxGridListGetRowCount(dutyVehiclesLocGridlist)
			if (rowCount == 0) or (rowCount < s) then emGUI:dxSetEnabled(dutyVehAddButton, false) end

			local row = emGUI:dxGridListAddRow(locDutyVehAddedGridlist)
			emGUI:dxGridListSetItemText(locDutyVehAddedGridlist, row, 1, dutyID)
			emGUI:dxGridListSetItemText(locDutyVehAddedGridlist, row, 2, dutyName)
			gSelections[dutyName] = dutyID
		end
	end)
	
	dutyVehRemoveButton = emGUI:dxCreateButton(0.446, 0.62, 0.11, 0.07, "⏪", true, dutyGroupLocationsGUI)
	emGUI:dxSetEnabled(dutyVehRemoveButton, false)
	addEventHandler("onClientDgsDxMouseClick", dutyVehRemoveButton, function(b, c)
		if (b == "left") and (c == "down") then
			local s = emGUI:dxGridListGetSelectedItem(locDutyVehAddedGridlist)
			local dutyID = emGUI:dxGridListGetItemText(locDutyVehAddedGridlist, s, 1); dutyID = tonumber(dutyID)
			local dutyName = emGUI:dxGridListGetItemText(locDutyVehAddedGridlist, s, 2)
			emGUI:dxGridListRemoveRow(locDutyVehAddedGridlist, s)
			local rowCount = emGUI:dxGridListGetRowCount(locDutyVehAddedGridlist)
			if (rowCount == 0) or (rowCount < s) then emGUI:dxSetEnabled(dutyVehRemoveButton, false) end

			local row = emGUI:dxGridListAddRow(dutyVehiclesLocGridlist)
			emGUI:dxGridListSetItemText(dutyVehiclesLocGridlist, row, 1, dutyID)
			emGUI:dxGridListSetItemText(dutyVehiclesLocGridlist, row, 2, dutyName)
			gSelections[dutyName] = nil
		end
	end)
	
	------------- SAVING ------------
	dutyLocationsReturnButton = emGUI:dxCreateButton(0.05, 0.84, 0.32, 0.13, "Return To\nDuty Editor", true, dutyGroupLocationsGUI)
	addEventHandler("onClientDgsDxMouseClick", dutyLocationsReturnButton, function(b, c)
		if (b == "left") and (c == "down") then
			emGUI:dxMoveTo(dutyGroupLocationsGUI, 1, 0.27, true, false, "OutQuad", 300)
			setTimer(function()
				emGUI:dxCloseWindow(dutyGroupLocationsGUI)
				emGUI:dxMoveTo(dutyGroupManagerGUI, 0.17, 0.26, true, false, "OutQuad", 300)
			end, 300, 1)
		end
	end)
	dutyLocationsSaveButton = emGUI:dxCreateButton(0.625, 0.84, 0.32, 0.13, "Save Changes", true, dutyGroupLocationsGUI)
	addEventHandler("onClientDgsDxMouseClick", dutyLocationsSaveButton, function(b, c)
		if (b == "left") and (c == "down") then
			local newTable = {}
			for i, v in pairs(gSelections) do table.insert(newTable, v) end
			groupData[groupName].locations = newTable
			groupData = toJSON(groupData)
			triggerServerEvent("faction:menu:dutyLocationsUpdateTable", localPlayer, groupData, groupName)
			emGUI:dxMoveTo(dutyGroupLocationsGUI, 1, 0.27, true, false, "OutQuad", 300)
			setTimer(function()
				emGUI:dxCloseWindow(dutyGroupLocationsGUI)
				emGUI:dxMoveTo(dutyGroupManagerGUI, 0.17, 0.26, true, false, "OutQuad", 300)
			end, 300, 1)
		end
	end)

	addEventHandler("ondxGridListSelect", dutyLocationsGridlist, function(c) emGUI:dxSetEnabled(dutyLocAddButton, c ~= -1) end)
	addEventHandler("ondxGridListSelect", locDutyLocationsAddedGridlist, function(c) emGUI:dxSetEnabled(dutyLocDelButton, c ~= -1) end)
	addEventHandler("ondxGridListSelect", dutyVehiclesLocGridlist, function(c) emGUI:dxSetEnabled(dutyVehAddButton, c ~= -1) end)
	addEventHandler("ondxGridListSelect", locDutyVehAddedGridlist, function(c) emGUI:dxSetEnabled(dutyVehRemoveButton, c ~= -1) end)
end
addEvent("faction:menu:showFactionDutyLocationEditor", true)
addEventHandler("faction:menu:showFactionDutyLocationEditor", root, showFactionDutyLocationEditor)

function handleGroupSaving(b, c)
	if (b == "left") and (c == "down") then
		local s = emGUI:dxGridListGetSelectedItem(dutyGroupsGridlist)
		local groupName = emGUI:dxGridListGetItemText(dutyGroupsGridlist, s, 1)
		local groupWages = emGUI:dxGetText(dutyWagesLabelInput)
		if not tonumber(groupWages) then
			emGUI:dxLabelSetColor(dutyWagesLabel, 255, 0, 0)
			setTimer(function() if emGUI:dxIsWindowVisible(dutyGroupManagerGUI) then emGUI:dxLabelSetColor(dutyWagesLabel, 255, 255, 255) end end, 3000, 1)
			return false
		end

		local dutyGroupItems = {}
		local totalItems = emGUI:dxGridListGetRowCount(dutyGroupItemsGridlist)
		for i = 1, totalItems do
			local itemID = emGUI:dxGridListGetItemText(dutyGroupItemsGridlist, i, 1)
			local itemAmount = emGUI:dxGridListGetItemText(dutyGroupItemsGridlist, i, 3)
			dutyGroupItems[i] = {tonumber(itemID), tonumber(itemAmount)}
		end

		local dutyGroupSkins = {}
		local totalSkins = emGUI:dxGridListGetRowCount(dutyGroupSkinsGridlist)
		for i = 1, totalSkins do
			local skinState = emGUI:dxGridListGetItemText(dutyGroupSkinsGridlist, i, 2)
			if (skinState == "Yes") then
				local skinID = emGUI:dxGridListGetItemText(dutyGroupSkinsGridlist, i, 1)
				table.insert(dutyGroupSkins, tonumber(skinID))
			end
		end

		triggerServerEvent("faction:menu:saveDutyGroupChanges", localPlayer, groupName, tonumber(groupWages), dutyGroupItems, dutyGroupSkins)
	end
end

function dutyManagerUpdateFeedback(feedbackText)
	if emGUI:dxIsWindowVisible(dutyGroupManagerGUI) then
		emGUI:dxSetText(dutySaveChangesButton, feedbackText)

		setTimer(function()
			if emGUI:dxIsWindowVisible(dutyGroupManagerGUI) then emGUI:dxSetText(dutySaveChangesButton, "Save Group") end
		end, 3000, 1)
	end
end
addEvent("faction:menu:dutyManagerUpdateFeedback", true)
addEventHandler("faction:menu:dutyManagerUpdateFeedback", root, dutyManagerUpdateFeedback)

------------------------------------------------------------------------------------------------------------------

function showVehiclePermissionEditor(groupData, vehicleData, animateIn)
	if emGUI:dxIsWindowVisible(vehiclePermissionGUI) then emGUI:dxCloseWindow(vehiclePermissionGUI) end

	local y = 0.26; if animateIn then y = 1 end
	vehiclePermissionGUI = emGUI:dxCreateWindow(0.215, y, 0.57, 0.39, "Vehicle Permissions Editor", true, true, _, true)
	if animateIn then emGUI:dxMoveTo(vehiclePermissionGUI, 0.215, 0.26, true, false, "OutQuad", 250) end

	local vehPermSelections = {}
	groupData = fromJSON(groupData)

	-- Vehicle Gridlist [Left]
	vehpermVehicleGridlist = emGUI:dxCreateGridList(0.01, 0.02, 0.23, 0.96, true, vehiclePermissionGUI)
	emGUI:dxGridListAddColumn(vehpermVehicleGridlist, "ID", 0.08)
	emGUI:dxGridListAddColumn(vehpermVehicleGridlist, "Vehicle Name", 0.92)
	for i, veh in pairs(vehicleData) do
		local row = emGUI:dxGridListAddRow(vehpermVehicleGridlist)
		emGUI:dxGridListSetItemText(vehpermVehicleGridlist, row, 1, i)
		emGUI:dxGridListSetItemText(vehpermVehicleGridlist, row, 2, veh.name)
	end

	-- Duty Groups Gridlist [Center]
	vehpermDutyGroupGridlist = emGUI:dxCreateGridList(0.25, 0.02, 0.26, 0.96, true, vehiclePermissionGUI)
	emGUI:dxGridListAddColumn(vehpermDutyGroupGridlist, "Available Duty Groups", 1)

	-- Available Groups Gridlist [Right]
	vehpermGroupsGridlist = emGUI:dxCreateGridList(0.59, 0.02, 0.26, 0.96, true, vehiclePermissionGUI)
	emGUI:dxGridListAddColumn(vehpermGroupsGridlist, "Vehicle Duty Groups", 1)

	-- Buttons
	vehpermAddButton = emGUI:dxCreateButton(0.52, 0.40, 0.06, 0.10, "⏩", true, vehiclePermissionGUI)
	emGUI:dxSetEnabled(vehpermAddButton, false)
	addEventHandler("onClientDgsDxMouseClick", vehpermAddButton, function(b, c)
		if (b == "left") and (c == "down") then
			local s = emGUI:dxGridListGetSelectedItem(vehpermDutyGroupGridlist)
			local groupName = emGUI:dxGridListGetItemText(vehpermDutyGroupGridlist, s, 1)
			emGUI:dxGridListRemoveRow(vehpermDutyGroupGridlist, s)

			local rowCount = emGUI:dxGridListGetRowCount(vehpermDutyGroupGridlist)
			if (rowCount == 0) or (rowCount < s) then emGUI:dxSetEnabled(vehpermAddButton, false) end

			local row = emGUI:dxGridListAddRow(vehpermGroupsGridlist)
			emGUI:dxGridListSetItemText(vehpermGroupsGridlist, row, 1, groupName)
			vehPermSelections[groupName] = groupName
		end
	end)
	
	vehpermRemoveButton = emGUI:dxCreateButton(0.52, 0.52, 0.06, 0.10, "⏪", true, vehiclePermissionGUI)
	emGUI:dxSetEnabled(vehpermRemoveButton, false)
	addEventHandler("onClientDgsDxMouseClick", vehpermRemoveButton, function(b, c)
		if (b == "left") and (c == "down") then
			local s = emGUI:dxGridListGetSelectedItem(vehpermGroupsGridlist)
			local groupName = emGUI:dxGridListGetItemText(vehpermGroupsGridlist, s, 1)
			emGUI:dxGridListRemoveRow(vehpermGroupsGridlist, s)

			local rowCount = emGUI:dxGridListGetRowCount(vehpermGroupsGridlist)
			if (rowCount == 0) or (rowCount < s) then emGUI:dxSetEnabled(vehpermRemoveButton, false) end

			local row = emGUI:dxGridListAddRow(vehpermDutyGroupGridlist)
			emGUI:dxGridListSetItemText(vehpermDutyGroupGridlist, row, 1, groupName)
			vehPermSelections[groupName] = nil
		end
	end)

	vehpermSaveButton = emGUI:dxCreateButton(0.86, 0.37, 0.13, 0.24, "Save Vehicle\nPermissions", true, vehiclePermissionGUI)
	if not animateIn then -- Using this variable to check if the GUI is being recalled.
		emGUI:dxSetText(vehpermSaveButton, "Permissions\nSaved!")
		setTimer(function() if emGUI:dxIsWindowVisible(vehiclePermissionGUI) then emGUI:dxSetText(vehpermSaveButton, "Save Vehicle\nPermissions") end end, 3000, 1)
	end
	emGUI:dxSetEnabled(vehpermSaveButton, false)
	addEventHandler("onClientDgsDxMouseClick", vehpermSaveButton, function(b, c)
		if (b == "left") and (c == "down") then
			local parsedVehPermTable = {}
			for i, group in pairs(vehPermSelections) do table.insert(parsedVehPermTable, group) end
			local s = emGUI:dxGridListGetSelectedItem(vehpermVehicleGridlist)
			local vehicleID = emGUI:dxGridListGetItemText(vehpermVehicleGridlist, s, 1)
			parsedVehPermTable = toJSON(parsedVehPermTable)
			triggerServerEvent("faction:menu:saveVehicleGroupPermissions", localPlayer, vehicleID, parsedVehPermTable)
		end
	end)

	addEventHandler("ondxGridListSelect", vehpermVehicleGridlist, function(c)
		local state = c ~= -1
		emGUI:dxSetEnabled(vehpermSaveButton, state)

		emGUI:dxGridListClear(vehpermDutyGroupGridlist)
		emGUI:dxGridListClear(vehpermGroupsGridlist)
		vehPermSelections = {}
		if (state) then
			local selectedVehID = emGUI:dxGridListGetItemText(vehpermVehicleGridlist, c, 1); selectedVehID = tonumber(selectedVehID)
			for i, group in pairs(groupData) do
				local groupAdded = false
				for j, vehgroup in pairs(vehicleData[selectedVehID].groups) do
					if (vehgroup == group.name) then
						groupAdded = true
						local row = emGUI:dxGridListAddRow(vehpermGroupsGridlist)
						emGUI:dxGridListSetItemText(vehpermGroupsGridlist, row, 1, vehgroup)
						vehPermSelections[vehgroup] = vehgroup
					end
				end

				if not groupAdded then
					local row = emGUI:dxGridListAddRow(vehpermDutyGroupGridlist)
					emGUI:dxGridListSetItemText(vehpermDutyGroupGridlist, row, 1, group.name)
				end
			end
		end
	end)
	addEventHandler("ondxGridListSelect", vehpermDutyGroupGridlist, function(c) emGUI:dxSetEnabled(vehpermAddButton, c ~= -1) end)
	addEventHandler("ondxGridListSelect", vehpermGroupsGridlist, function(c) emGUI:dxSetEnabled(vehpermRemoveButton, c ~= -1) end)
end
addEvent("faction:menu:showVehiclePermissionEditor", true)
addEventHandler("faction:menu:showVehiclePermissionEditor", root, showVehiclePermissionEditor)