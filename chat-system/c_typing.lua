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

local isChatting = false
local playersTyping = {}

function isPlayerTyping()
	if not (getElementAlpha(localPlayer) == 0) then
		if (isChatBoxInputActive() and not isChatting) then
			isChatting = true
			triggerServerEvent("chat:getvisiblechatters", localPlayer)
		elseif (not isChatBoxInputActive() and isChatting) then
			isChatting = false
			triggerServerEvent("chat:gettinghiddenchatters", localPlayer)
		end
	end
end
setTimer(isPlayerTyping, 200, 0)

function addChatter()
	for i, thePlayer in ipairs(playersTyping) do if (thePlayer == source) then return end end
	table.insert(playersTyping, source)
end
addEvent("chat:addClient", true)
addEventHandler("chat:addClient", root, addChatter)

function delChatter()
	for i, thePlayer in ipairs(playersTyping) do
		if (thePlayer == source) then table.remove(playersTyping, i) end
	end
end
addEvent("chat:removeClient", true)
addEventHandler("chat:removeClient", root, delChatter)
addEventHandler("onClientPlayerQuit", root, delChatter)

function renderTypingIcons()
	if not exports["hud-system"]:isHudEnabled() then return end
	local x, y, z = getElementPosition(localPlayer)
	local isReconning = getElementData(localPlayer, "var:recon") == 1
	for i, thePlayer in ipairs(playersTyping) do
		if (isElement(thePlayer)) then
			if getElementType(thePlayer) == "player" then
				local px, py, pz = getPedBonePosition(thePlayer, 6)
				
				local distance = getDistanceBetweenPoints3D(x, y, z, px, py, pz)
				if isElementOnScreen(thePlayer) and getElementAlpha(thePlayer) ~= 0 and not getElementData(thePlayer, "freecam:state") then
					if (distance > 20) then playersTyping[thePlayer] = nil return end
				
					local lx, ly, lz = getCameraMatrix()
					local theVehicle = getPedOccupiedVehicle(thePlayer) or nil
					local visiblityBlocked = processLineOfSight(lx, ly, lz, px, py, pz + 1, true, true, true, true, false, false, true, false, theVehicle)
					if not (visiblityBlocked) or (isReconning) then
						local screenX, screenY = getScreenFromWorldPosition(px, py, pz + 0.3)
						if (screenX and screenY) then
							local scale = 3
							local paddingFactor = 50
							distance = distance / scale
								
							if (distance < 1) then
								distance = 1
								paddingFactor = 50
							end

							local chatIcon = "images/typing.png"
							local iconSizeW, iconSizeH, iconScale = 186, 165, 0.6
							if (distance > scale and isReconning) then distance = iconScale end

							-- Insert code here to replace icon if donator player has donator icon. @requires donator-system
							dxDrawImage(screenX + (paddingFactor / distance), screenY, iconSizeW * iconScale / distance, iconSizeH * iconScale / distance, chatIcon)
						end
					end
				end
			else playersTyping[i] = nil end
		else playersTyping[i] = nil end
	end
end
addEventHandler("onClientRender", root, renderTypingIcons)

local hasEnabled = true
function updateTypingIcon(thePlayer, isEnabled)
	if (isEnabled) then
		if (hasEnabled) then return end
		hasEnabled = true
		triggerServerEvent("chat:chatterAddedCall", thePlayer)
		addEventHandler("onClientRender", root, renderTypingIcons)
	else
		hasEnabled = false
		triggerServerEvent("chat:chatterRemovedCall", thePlayer)
		removeEventHandler("onClientRender", root, renderTypingIcons)
	end
end
addEvent("chat:updateIconVisibility", true)
addEventHandler("chat:updateIconVisibility", root, updateTypingIcon)