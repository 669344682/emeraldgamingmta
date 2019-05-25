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
bindKey("F3", "down", "faction")

local FACTION_SELECTOR_VISIBLE = false

function showFaction()
	local activeFaction = getElementData(localPlayer, "character:activefaction") or 0
	if (activeFaction ~= 0) then
		triggerServerEvent("faction:showFactionMenuCall", localPlayer, localPlayer, activeFaction, false)
	else
		triggerServerEvent("faction:showFactionSelectorCall", localPlayer)
	end
end
addCommandHandler("faction", showFaction)

function showFactionSelectorMenu(dataTable)
	if emGUI:dxIsWindowVisible(factionSelectorGUI) then
		emGUI:dxMoveTo(factionSelectorGUI, 0.29, 1, true, false, "OutQuad", 250)
		setTimer(function()
			if emGUI:dxIsWindowVisible(factionSelectorGUI) then emGUI:dxCloseWindow(factionSelectorGUI) end
			FACTION_SELECTOR_VISIBLE = false
		end, 300, 1)
		return
	end

	if not FACTION_SELECTOR_VISIBLE then
		FACTION_SELECTOR_VISIBLE = true

		local factionNameLabels = {}
		local factionLogos = {}

		factionSelectorGUI = emGUI:dxCreateWindow(0.29, 1, 0.41, 0.22, "Select Faction", true, true, _, true)
		emGUI:dxMoveTo(factionSelectorGUI, 0.29, 0.61, true, false, "OutQuad", 250)

		-- Setup faction logo loading. @requires faction-system logo images.
		local logos = {
			[1] = ":assets/images/logoIcon.png",
			[2] = ":assets/images/logoIcon.png",
			[3] = ":assets/images/logoIcon.png",
		}
		local logoPos = {
			[1] = ":dev/pd.png",
			[2] = ":dev/fd.png",
			[3] = ":dev/gov.png",
		}
		if dataTable[1] and logoPos[dataTable[1][1]] then logos[1] = logoPos[dataTable[1][1]] end
		if dataTable[2] and logoPos[dataTable[2][1]] then logos[2] = logoPos[dataTable[2][1]] end
		if dataTable[3] and logoPos[dataTable[3][1]] then logos[3] = logoPos[dataTable[3][1]] end

		if not dataTable[1] then dataTable[1] = {0, "Vacant", false} end
		factionLogos[1] = emGUI:dxCreateImage(0.08, 0.07, 0.19, 0.64, logos[1], true, factionSelectorGUI)
		factionNameLabels[1] = emGUI:dxCreateLabel(0.035, 0.73, 0.28, 0.17, dataTable[1][2] .. "\n[Slot 1]", true, factionSelectorGUI)
		
		if not dataTable[2] then dataTable[2] = {0, "Vacant", false} end
		factionLogos[2] = emGUI:dxCreateImage(0.41, 0.07, 0.19, 0.64, logos[2], true, factionSelectorGUI)
		factionNameLabels[2] = emGUI:dxCreateLabel(0.365, 0.73, 0.28, 0.17, dataTable[2][2] .. "\n[Slot 2]", true, factionSelectorGUI)
		
		if not dataTable[3] then dataTable[3] = {0, "Vacant", false} end
		factionLogos[3] = emGUI:dxCreateImage(0.73, 0.07, 0.19, 0.64, logos[3], true, factionSelectorGUI)
		factionNameLabels[3] = emGUI:dxCreateLabel(0.685, 0.73, 0.28, 0.17, dataTable[3][2] .. "\n[Slot 3]", true, factionSelectorGUI)

		for i = 1, 3 do
			emGUI:dxLabelSetHorizontalAlign(factionNameLabels[i], "center")
			setElementData(factionLogos[i], "temp:emGUI:faction:id", dataTable[i][1], false)
			addEventHandler("onClientDgsDxMouseClick", factionLogos[i], handleFactionSelection)
			addEventHandler("onDgsMouseEnter", factionLogos[i], handleIconFadeIn)
			addEventHandler("onDgsMouseLeave", factionLogos[i], handleIconFadeOut)
		end
	end
end
addEvent("faction:showFactionSelector", true)
addEventHandler("faction:showFactionSelector", root, showFactionSelectorMenu)

function handleIconFadeIn() emGUI:dxImageSetColor(source, 255, 255, 255, 180) end
function handleIconFadeOut() emGUI:dxImageSetColor(source, 255, 255, 255, 255) end

function handleFactionSelection(b, c)
	if (b == "left") and (c == "down") then
		local factionID = getElementData(source, "temp:emGUI:faction:id") or 0
		if (tonumber(factionID) ~= 0) then
			triggerServerEvent("faction:showFactionMenuCall", localPlayer, localPlayer, factionID, true)
			emGUI:dxMoveTo(factionSelectorGUI, 0.29, 1, true, false, "OutQuad", 250)
			setTimer(function() emGUI:dxCloseWindow(factionSelectorGUI); FACTION_SELECTOR_VISIBLE = false end, 300, 1)
		end
	end
end