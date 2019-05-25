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

function hideGTAHUD()
	setPlayerHudComponentVisible("all", false) -- Disable all the default GTA HUD.
	setPlayerHudComponentVisible("radar", true) -- Show the radar.
	setPlayerHudComponentVisible("crosshair", true) -- Show the crosshair.
	setPlayerHudComponentVisible("radar", false)
end
addEventHandler("onClientResourceStart", root, hideGTAHUD)
---------------------------------------------- [ MAIN HUD SYSTEM ] ----------------------------------------------

------- [Primary Mouse Toggle Function] ------
function toggleCursor()
	if (isCursorShowing()) then
		showCursor(false)
	else
		showCursor(true)
		local screenX, screenY = guiGetScreenSize() -- Gets player screen size.
		setCursorPosition(screenX/2, screenY/2) -- Centers the mouse again.
	end
end
addCommandHandler("togglecursor", toggleCursor)
bindKey("m", "down", "togglecursor")

-- /fixmouse - By Skully (11/03/18) [Player]
function mouseFix()
	showCursor(false)
	exports.emGUI:dxShowCursor(false)
end
addCommandHandler("fixmouse", mouseFix)
addCommandHandler("mousefix", mouseFix)
addEvent("hud:mouseFix", true)
addEventHandler("hud:mouseFix", root, mouseFix)

------- [TOP-RIGHT HUD] ------
screenWidth, screenHeight = guiGetScreenSize()
local iconW, iconH = 32, 32
local offsetSize = 5 -- Size how much for icons to come inwards so they are not touching the edge of the screen. (Padding)
local seperation = 3 -- How far each icon should be separated from each other.
local fontToolTip = dxCreateFont(":assets/fonts/hudTextFont.ttf", 12)--"Bard" -- hudTextFont.ttf

-- Checks if the HUD is enabled.
function isHudEnabled()
	local hudStatus = getElementData(localPlayer, "hud:enabledstatus")

	if (hudStatus == 0) then
		--setPlayerHudComponentVisible("radar", true) disabled temporarily.
		return true
	else
		--setPlayerHudComponentVisible("radar", false)
		return false
	end
end

-- Disabled icon value to change image/icon color.
function setIconAlpha(value)
	return tocolor(value, value, value)
end

-- Detects button clicks within divbox.
addEventHandler("onClientClick", root, function(button, state) if button == "left" and state == "up" then justClicked = true end end)

-- Main HUD creation.
function createHUD()
	if not isPlayerMapVisible() then
		local ax, ay = screenWidth - iconW - offsetSize, offsetSize -- Side bar.
		local cx, cy = screenWidth - iconW - offsetSize, offsetSize -- Top bar.
		local cursorX, cursorY = getCursorPosition()
		local topbar = {} -- topbar, icons going across.
		local sidebar = {} -- Sidebar, icons going top-down.
		local hudStyle = getElementData(localPlayer, "settings:graphics:setting7") or 1

		if (hudStyle == 1) then hudStyle = "black_on_white"
			elseif (hudStyle == 2) then hudStyle = "white_on_black"
			else hudStyle = "black_on_white"
		end

		if getElementData(localPlayer, "loggedin") == 1 then
			local hudState = getElementData(localPlayer,"hud:enabledstatus")
			if (hudState == 0) then
				dxDrawImage(ax, ay, iconW, iconH, "images/hud/" .. hudStyle .. "/hudicon.png")
				table.insert(sidebar, "hudtoggle:on")
				ay = ay + iconH + seperation
				cx = cx - iconW - seperation
			elseif (hudState == 1) then
				dxDrawImage(ax, ay, iconW, iconH, "images/hud/" .. hudStyle .. "/hudicon.png", 0, 0, 0, setIconAlpha(100))
				table.insert(sidebar, "hudtoggle:off")
				ay = ay + iconH + seperation
				cx = cx - iconW - seperation
			end

			if isHudEnabled() then -- If the HUD is enabled.
				------------------------------------- [TOP BAR] -------------------------------------
				 -- Report Panel
				if getElementData(localPlayer, "staff:rank") >= 1 then
					if getElementData(localPlayer, "hud:reportpanel") == 1 then
						table.insert(topbar, "reportpanel:on")
						cx = cx - iconW - seperation
					else
						table.insert(topbar, "reportpanel:off")
						cx = cx - iconW - seperation
					end
				end
				 -- Staff Toggle PMs
				if getElementData(localPlayer, "staff:rank") >= 1 then
					if getElementData(localPlayer, "duty:staff") == 1 then -- Only show icon if they are on admin duty.
						if getElementData(localPlayer, "var:toggledpms") == 0 then -- If they are not blocking PMs
							dxDrawImage(cx, cy, iconW, iconH, "images/hud/" .. hudStyle .. "/togpm.png")
							table.insert(topbar, "togpm:on")
							cx = cx - iconW - seperation
						else -- If they are blocking PMs.
							dxDrawImage(cx, cy, iconW, iconH, "images/hud/" .. hudStyle .. "/togpm.png", 0, 0, 0, setIconAlpha(100))
							table.insert(topbar, "togpm:off")
							cx = cx - iconW - seperation
						end
					end
				end
				------------------------------------- [SIDE BAR] -------------------------------------
				----- [STAFF TAGS] -----
				-- If the player is a manager+
				if getElementData(localPlayer, "staff:rank") >= 5 then
					-- Togmgtwarn icon.
					if (getElementData(localPlayer, "var:togmgtwarn") == 0) then
						dxDrawImage(ax, ay, iconW, iconH, "images/hud/" .. hudStyle .. "/togmgtwarn.png")
						table.insert(sidebar, "togmgtwarn:on")
					else
						dxDrawImage(ax, ay, iconW, iconH, "images/hud/" .. hudStyle .. "/togmgtwarn.png", 0, 0, 0, setIconAlpha(100))
						table.insert(sidebar, "togmgtwarn:off")
					end
					ay = ay + iconH + seperation

					-- Manager icon.
					if (getElementData(localPlayer, "duty:staff") == 1) then
						dxDrawImage(ax, ay, iconW, iconH, "images/staff/manager.png")
						table.insert(sidebar, "manager:on")
					else
						dxDrawImage(ax, ay, iconW, iconH, "images/staff/manager.png", 0, 0, 0, setIconAlpha(100))
						table.insert(sidebar, "manager:off")
					end
					ay = ay + iconH + seperation

				-- If the player is a Trial Admin+.
				elseif getElementData(localPlayer, "staff:rank") >= 2 then
					if (getElementData(localPlayer,"duty:staff") == 1)  then
						dxDrawImage(ax, ay, iconW, iconH,"images/staff/admin.png")
						table.insert(sidebar, "admin:on")
					else
						dxDrawImage(ax, ay, iconW, iconH,"images/staff/admin.png", 0, 0, 0, setIconAlpha(100))
						table.insert(sidebar, "admin:off")
					end
					ay = ay + iconH + seperation
				-- If the player is a Helper.
				elseif getElementData(localPlayer, "staff:rank") == 1 then
					if (getElementData(localPlayer,"duty:staff") == 1)  then
						dxDrawImage(ax, ay, iconW, iconH,"images/staff/helper.png")
						table.insert(sidebar, "helper:on")
					else
						dxDrawImage(ax, ay, iconW, iconH,"images/staff/helper.png", 0, 0, 0, setIconAlpha(100))
						table.insert(sidebar, "helper:off")
					end
					ay = ay + iconH + seperation
				end

				----- [AUXILLARY STAFF TAGS] -----
				-- If the player is a Developer.
				if getElementData(localPlayer, "staff:developer") >= 2 then
					if (getElementData(localPlayer,"duty:developer") == 1) then
						dxDrawImage(ax, ay, iconW, iconH,"images/staff/developer.png")
						table.insert(sidebar, "developer:on")
					else
						dxDrawImage(ax, ay, iconW, iconH,"images/staff/developer.png", 0, 0, 0, setIconAlpha(100))
						table.insert(sidebar, "developer:off")
					end
					ay = ay + iconH + seperation
				end

				-- If the player is VT.
				if getElementData(localPlayer, "staff:vt") >= 1 then
					if (getElementData(localPlayer,"duty:vt") == 1) then
						dxDrawImage(ax, ay, iconW, iconH,"images/staff/vehicleteam.png")
						table.insert(sidebar, "vehicleteam:on")
					else
						dxDrawImage(ax, ay, iconW, iconH,"images/staff/vehicleteam.png", 0, 0, 0, setIconAlpha(100))
						table.insert(sidebar, "vehicleteam:off")
					end
					ay = ay + iconH + seperation
				end

				-- If the player is MT.
				if getElementData(localPlayer, "staff:mt") >= 1 then
					if (getElementData(localPlayer,"duty:mt") == 1) then
						dxDrawImage(ax, ay, iconW, iconH,"images/staff/mappingteam.png")
						table.insert(sidebar, "mappingteam:on")
					else
						dxDrawImage(ax, ay, iconW, iconH,"images/staff/mappingteam.png", 0, 0, 0, setIconAlpha(100))
						table.insert(sidebar, "mappingteam:off")
					end
					ay = ay + iconH + seperation
				end
			end
		end

		-- Mouse Hover Events
		if isCursorShowing() then --       W,   H    [W = Left/Right of Edge | H = Up/Down]
			ax, ay = screenWidth - iconW - offsetSize, offsetSize -- Side bar.
			cx, cy = screenWidth - iconW - offsetSize, offsetSize -- Top bar.
			cursorX, cursorY = cursorX * screenWidth, cursorY * screenHeight

			------------------------------------------------ [TOP BAR] ------------------------------------------------
			for i = 1, #topbar do
				cx = cx - iconW - seperation
				if isInBox(cursorX, cursorY, cx, cx + iconW, cy, cy + iconH) then
					-- Report Panel
					if topbar[i] == "reportpanel:off" then
						createLabel(cursorX, cursorY, "Report Panel Disabled", "Click to enable.")
						if justClicked then
							playToggleSound()
							triggerEvent("hud:updateHudData", localPlayer, "hud:reportpanel", 1)
							triggerEvent("report:toggleReportMenuState", localPlayer)
						end
					elseif topbar[i] == "reportpanel:on" then
						createLabel(cursorX, cursorY, "Report Panel Enabled", "Click to disable.")
						if justClicked then
							playToggleSound()
							triggerEvent("hud:updateHudData", localPlayer, "hud:reportpanel", 0)
							triggerEvent("report:toggleReportMenuState", localPlayer)
						end
					end
					-- Toggle PMs
					if topbar[i] == "togpm:off" then
						createLabel(cursorX, cursorY, "Incoming PMs Disabled", "Click to enable.")
						if justClicked then
							playToggleSound()
							triggerEvent("hud:updateHudData", localPlayer, "var:toggledpms", 0)
						end
					elseif topbar[i] == "togpm:on" then
						createLabel(cursorX, cursorY, "Incoming PMs Enabled", "Click to disable.")
						if justClicked then
							playToggleSound()
							triggerEvent("hud:updateHudData", localPlayer, "var:toggledpms", 1)
						end
					end
				end
			end

			------------------------------------------------ [SIDE BAR] ------------------------------------------------
			for i = 1, #sidebar do
				if isInBox(cursorX, cursorY, ax, ax + iconW, ay, ay + iconH) then

					-- Titles
					local adminTitle = getElementData(localPlayer, "title:admin")
					local developerTitle = getElementData(localPlayer, "title:developer")
					local vtTitle = getElementData(localPlayer, "title:vt")
					local ftTitle = getElementData(localPlayer, "title:ft")
					local mtTitle = getElementData(localPlayer, "title:mt")

					-- HUD Icon
					if sidebar[i] == "hudtoggle:on" then
						createLabel(cursorX, cursorY, "HUD ENABLED", "Click to disable.")
						if justClicked then
							playToggleSound()
							triggerEvent("hud:updateHudData", localPlayer, "hud:enabledstatus", 1)
						end
					elseif sidebar[i] == "hudtoggle:off" then
						createLabel(cursorX, cursorY, "HUD DISABLED", "Click to enable.")
						if justClicked then
							playToggleSound()
							triggerEvent("hud:updateHudData", localPlayer, "hud:enabledstatus", 0)
						end
					-- Manager Duty Tag
					elseif sidebar[i] == "manager:on" then
						createLabel(cursorX, cursorY, adminTitle, "Click to go off duty.")
						if justClicked then
							triggerEvent("hud:updateHudData", localPlayer, "duty:staff", 0)
							playToggleSound()
						end
					elseif sidebar[i] == "manager:off" then
						createLabel(cursorX, cursorY, adminTitle, "Click to go on duty.")
						if justClicked then
							triggerEvent("hud:updateHudData", localPlayer, "duty:staff", 1)
							playToggleSound()
						end
					-- Admin Duty Tag
					elseif sidebar[i] == "admin:on" then
						createLabel(cursorX, cursorY, adminTitle, "Click to go off duty.")
						if justClicked then
							triggerEvent("hud:updateHudData", localPlayer, "duty:staff", 0)
							playToggleSound()
						end
					elseif sidebar[i] == "admin:off" then
						createLabel(cursorX, cursorY, adminTitle, "Click to go on duty.")
						if justClicked then
							triggerEvent("hud:updateHudData", localPlayer, "duty:staff", 1)
							playToggleSound()
						end
					-- Helper Duty Tag
					elseif sidebar[i] == "helper:on" then
						createLabel(cursorX, cursorY, adminTitle, "Click to go off duty.")
						if justClicked then
							triggerEvent("hud:updateHudData", localPlayer, "duty:staff", 0)
							playToggleSound()
						end
					elseif sidebar[i] == "helper:off" then
						createLabel(cursorX, cursorY, adminTitle, "Click to go on duty.")
						if justClicked then
							triggerEvent("hud:updateHudData", localPlayer, "duty:staff", 1)
							playToggleSound()
						end
					-- Developer Duty Tag
					elseif sidebar[i] == "developer:on" then
						createLabel(cursorX, cursorY, developerTitle, "Click to go off duty.")
						if justClicked then
							triggerEvent("hud:updateHudData", localPlayer, "duty:developer", 0)
							playToggleSound()
						end
					elseif sidebar[i] == "developer:off" then
						createLabel(cursorX, cursorY, developerTitle, "Click to go on duty.")
						if justClicked then
							triggerEvent("hud:updateHudData", localPlayer, "duty:developer", 1)
							playToggleSound()
						end
					-- Vehicle Team Tag
					elseif sidebar[i] == "vehicleteam:on" then
						createLabel(cursorX, cursorY, vtTitle, "Click to go off duty.")
						if justClicked then
							triggerEvent("hud:updateHudData", localPlayer, "duty:vt", 0)
							playToggleSound()
						end
					elseif sidebar[i] == "vehicleteam:off" then
						createLabel(cursorX, cursorY, vtTitle, "Click to go on duty.")
						if justClicked then
							triggerEvent("hud:updateHudData", localPlayer, "duty:vt", 1)
							playToggleSound()
						end
					-- Mapping Team Tag
					elseif sidebar[i] == "mappingteam:on" then
						createLabel(cursorX, cursorY, mtTitle, "Click to go off duty.")
						if justClicked then
							triggerEvent("hud:updateHudData", localPlayer, "duty:mt", 0)
							playToggleSound()
						end
					elseif sidebar[i] == "mappingteam:off" then
						createLabel(cursorX, cursorY, mtTitle, "Click to go on duty.")
						if justClicked then
							triggerEvent("hud:updateHudData", localPlayer, "duty:mt", 1)
							playToggleSound()
						end
					elseif sidebar[i] == "togmgtwarn:on" then
						createLabel(cursorX, cursorY, "MANAGER WARNINGS ON", "Click to disable warnings.")
						if justClicked then
							triggerEvent("hud:updateHudData", localPlayer, "var:togmgtwarn", 1)
							playToggleSound()
						end
					elseif sidebar[i] == "togmgtwarn:off" then
						createLabel(cursorX, cursorY, "MANAGER WARNINGS OFF", "Click to enable warnings.")
						if justClicked then
							triggerEvent("hud:updateHudData", localPlayer, "var:togmgtwarn", 0)
							playToggleSound()
						end
					end
				end
				ay = ay + iconH + seperation
			end
		end
	end
	justClicked = false
end
addEventHandler("onClientRender", root, createHUD)
addEventHandler("onClientResourceStart", root, createHUD)

----------------------------- [Mouse Hover Info] ---------------------------------

-- Checks to see if the mouse is over a div icon.
function isInBox(x, y, xmin, xmax, ymin, ymax) return x >= xmin and x <= xmax and y >= ymin and y <= ymax end

function createLabel(x, y, firstLine, secondLine)
	firstLine = tostring(firstLine)
	if secondLine then secondLine = tostring(secondLine) end
	if firstLine == secondLine then secondLine = nil end
	
	local width = dxGetTextWidth(firstLine, 1, fontToolTip) + 20
	if secondLine then
		width = math.max(width, dxGetTextWidth(secondLine, 1, fontToolTip) + 20)
		firstLine = firstLine .. "\n" .. secondLine
	end
	local height = 10 * (secondLine and 5 or 3)
	x = math.max(10, math.min(x, screenWidth - width - 10))
	y = math.max(10, math.min(y, screenHeight - height - 10)) + iconH / 3
	
	dxDrawLine(x - 3, y - 1, x - 3, y + height - 1, tocolor(255, 255, 255, 180), 5)
	dxDrawRectangle(x, y, width, height, tocolor(70, 180, 90, 180), true)
	dxDrawText(firstLine, x, y, x + width, y + height, tocolor(255, 255, 255, 255), 1, fontToolTip, "center", "center", false, false, true)
end

function playToggleSound() playSound(":assets/sounds/toggleSound.mp3") end

-- Takes the data given from HUD icon clicks and changes their elementData.
function updateHudData(name, value)
	if name and value then
		value = tonumber(value) or value
		triggerServerEvent("hud:hudEvent", localPlayer, name, value)
	end
end
addEvent("hud:updateHudData", true)
addEventHandler("hud:updateHudData", localPlayer, updateHudData)