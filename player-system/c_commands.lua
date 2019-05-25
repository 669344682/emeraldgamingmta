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

local sW, sH = guiGetScreenSize()
local showfps = false
local prevFPS = 0
local fps = 0
local timer = nil


function setLocalFPSLimit(fps) setFPSLimit(tonumber(fps)) end
addEvent("player:setfpslimit", true)
addEventHandler("player:setfpslimit", root, setLocalFPSLimit)

-- /showfps - By Skully (08/02/18) [Player]
function toggleShowFPS()
	showfps = not showfps

	if (showfps) then
		fps = 0
		prevFPS = 0
		addEventHandler("onClientRender", root, countFPS)
		timer = setTimer(resetFPS, 1000, 0)
	else
		killTimer(timer)
		timer = nil
		removeEventHandler("onClientRender", root, countFPS)
	end
end
addCommandHandler("showfps", toggleShowFPS)

function resetFPS() prevFPS = fps; fps = 0 end

function countFPS()
	local r, g, b = 255, 255, 255
	
	fps = fps + 1
	if (prevFPS == 0) then prevFPS = "Loading.." end
	if (prevFPS ~= "Loading..") then
		if (prevFPS > 35) then r, g, b = 0, 255, 0
			elseif (prevFPS > 20) then r, g, b = 255, 255, 0
			elseif (prevFPS <= 20) then r, g, b = 255, 0, 0
		end
	end

	dxDrawText("FPS: " .. tostring(prevFPS), 24, sH - 48, 50, 30, tocolor(0, 0, 0, 100), 2, "default-bold-small")
	dxDrawText("FPS: " .. tostring(prevFPS), 23, sH - 48, 50, 30, tocolor(r, g, b, 160), 2, "default-bold-small")
end


emGUI = exports.emGUI

staffsMenu = {
	window = {},
	labelTitle = {},
	labelName = {},
	labelRank = {},
	labelStatus = {}
}

addEvent("showStaffsGUI", true)
addEventHandler("showStaffsGUI", resourceRoot, function()
	local staffMemberCount = 0
	local labelY = -0.055
	local windowHeight = 0.17
	staffsMenuWindow = emGUI:dxCreateWindow(0.35, -1, 0.46, windowHeight, "", true, false, true, true)

	for _, player in ipairs(getElementsByType("player")) do
		if (exports.global:isPlayerStaff(player, true)) then
			staffMemberCount = staffMemberCount + 1

			if (staffMemberCount >= 8) then
				windowHeight = windowHeight + 0.02
				emGUI:dxSizeTo(stafsMenuWindow, 0.46, windowHeight, true, false, "Linear", 0)
			end

			labelY = labelY + 0.11
			staffsMenu.labelName[staffMemberCount] = emGUI:dxCreateLabel(0.07, labelY, 0.48, 0.09, "", true, staffsMenuWindow)
			staffsMenu.labelRank[staffMemberCount] = emGUI:dxCreateLabel(0.45, labelY, 0.20, 0.09, "", true, staffsMenuWindow)
			staffsMenu.labelStatus[staffMemberCount] = emGUI:dxCreateLabel(0.83, labelY, 0.20, 0.09, "", true, staffsMenuWindow)
		end
	end

	emGUI:dxSizeTo(staffsMenuWindow, 0, 0, true, false, "OutQuad", 300)
	staffsMenu.labelTitle[1] = emGUI:dxCreateLabel(0.07, -0.085, 0.10, 0.11, "NAME", true, staffsMenuWindow)
	staffsMenu.labelTitle[2] = emGUI:dxCreateLabel(0.45, -0.085, 0.14, 0.12, "RANK", true, staffsMenuWindow)
	staffsMenu.labelTitle[3] = emGUI:dxCreateLabel(0.83, -0.085, 0.14, 0.12, "STATUS", true, staffsMenuWindow)

	emGUI:dxMoveTo(staffsMenuWindow, 0.35, 0, true, false, "OutQuad", 300)
	emGUI:dxSizeTo(staffsMenuWindow, 0.31, windowHeight, true, false,"OutQuad", 300)
	setTimer(function()
		emGUI:dxMoveTo(staffsMenuWindow, 0.35, -0.4, true, false, "OutQuad", 300)
		emGUI:dxSizeTo(staffsMenuWindow, 0.35, 0, true, false,"OutQuad", 300)
	end, 6000, 1)
	setTimer(function()
		emGUI:dxCloseWindow(staffsMenuWindow)
	end, 6100, 1)
end)

function showStaffs()
	local guiState = emGUI:dxIsWindowVisible(staffsMenuWindow)
	if not (guiState) then
		triggerEvent("showStaffsGUI", root)
		findStaffOnline()
	end
end
addCommandHandler("staff", showStaffs)
addCommandHandler("admins", showStaffs)

function findStaffOnline()
	for i = 6, 1, -1 do
		for _, player in ipairs(getElementsByType("player")) do
			if (getElementData(player, "staff:rank") == i) then
				local thePlayerAccountName = getElementData(player, "account:username")
				local thePlayerRank = exports.global:getStaffTitle(player, 3)
				local thePlayerDuty = exports.global:isPlayerOnStaffDuty(player)

				addToStaff(player, thePlayerAccountName, thePlayerRank, thePlayerDuty)
			end
		end
	end
end


function addToStaff(thePlayer, thePlayerAccountName, thePlayerRank, thePlayerDuty)
	for _, labelName in ipairs(staffsMenu.labelName) do -- Go through all of the name labels and find an empty one to write into.
		if (emGUI:dxGetText(labelName) == "") then -- If that label is empty we can add the staff member's name in it.
			-- Hidden Admin Checks
			if (getElementData(thePlayer, "var:hiddenAdmin") == 1) then -- If the staff member has hidden status enabled. (Manager and above only)
				if (exports.global:isPlayerHelper(localPlayer, true)) then -- Checks if the player who is viewing /staff is at least a Helper.
					emGUI:dxSetText(labelName, "(Hidden) " .. thePlayerAccountName) -- Show the hidden admin on /staff, but specify that he is hidden.
				end
			else -- The staff member doesn't have hidden status enabled.
				emGUI:dxSetText(labelName, thePlayerAccountName) -- Set the staff member's name on the label for everyone.
			end
			break
		end
	end

	for _, labelRank in ipairs(staffsMenu.labelRank) do
		if (emGUI:dxGetText(labelRank) == "") then
			-- Hidden Admin Checks
			if (getElementData(thePlayer, "var:hiddenAdmin") == 1) then
				if (exports.global:isPlayerHelper(localPlayer, true)) then
					emGUI:dxSetText(labelRank, thePlayerRank)
				end
			else
				emGUI:dxSetText(labelRank, thePlayerRank)
			end
			break
		end
	end

	for _, labelStatus in ipairs(staffsMenu.labelStatus) do
		if (emGUI:dxGetText(labelStatus) == "") then
			if (thePlayerDuty == false) then
				-- Hidden Admin Checks
				if (getElementData(thePlayer, "var:hiddenAdmin") == 1) then
					if (exports.global:isPlayerHelper(localPlayer, true)) then
						emGUI:dxSetText(labelStatus, "Off Duty")
						emGUI:dxLabelSetColor(labelStatus, 255, 0, 0)
					end
				else
					emGUI:dxSetText(labelStatus, "Off Duty")
					emGUI:dxLabelSetColor(labelStatus, 255, 0, 0)
				end
				break
			else 
				-- Hidden Admin Checks
				if (getElementData(thePlayer, "var:hiddenAdmin") == 1) then
					if (exports.global:isPlayerHelper(localPlayer, true)) then
						emGUI:dxSetText(labelStatus, "On Duty")
						emGUI:dxLabelSetColor(labelStatus, 0, 255, 0)
					end
				else
					emGUI:dxSetText(labelStatus, "On Duty")
					emGUI:dxLabelSetColor(labelStatus, 0, 255, 0)
				end
				break
			end
		end
	end
end