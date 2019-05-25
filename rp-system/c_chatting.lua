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

bindKey("b", "down", "chatbox", "LocalOOC")

local messageQueue = {} -- {text, player, lastTick, alpha, yPos}
local fontHeight = 22
local maxOutputs = 5
local selfVisible = true
local timeVisible = 6000
local distanceVisible = 20
local rpR, rpG, rpB = 230, 25, 140 -- Colour of /ame's and /ado's.

function queueText(source, text, color, font, sticky, type)
	if getElementData(localPlayer, "hud:enabledstatus") ~= 0 then return end
	if not messageQueue[source] then messageQueue[source] = {} end

	local tick = getTickCount()
	local info = {
		text = text,
		player = source,
		color = color or {255, 255, 255},
		tick = tick,
		expires = tick + (timeVisible + #text * 50),
		alpha = 0,
		sticky = sticky,
		type = type
	}

	if sticky then
		table.insert(messageQueue[source], 1, info)
	else
		table.insert(messageQueue[source], info)
	end

	if #messageQueue[source] > maxOutputs then
		for k, msg in ipairs(messageQueue[source]) do
			if not msg.sticky then
				table.remove(messageQueue[source], k)
				break
			end
		end
	end
end

addEvent("rp:createChatBubble", true)
addEventHandler("rp:createChatBubble", root,
function(message, command)
	if source ~= localPlayer or selfVisible then
		if command == "ado" or command == "ame" then
			queueText(source, message, {rpR, rpG, rpB}, "default-bold", false, command)
		else
			queueText(source, message)
		end
	end
end)

function removeTexts(player, type)
	local t = messageQueue[player] or {}
	for i = #t, 1, -1 do
		if t[i].type == type then
			table.remove(t, i)
		end
	end

	if #t == 0 then
		messageQueue[player] = nil
	end
end

addEventHandler("onClientElementDataChange", root, function(d)
	if d == "chat:status" and getElementType(source) == "player" then
		updateStatus(source, "status")
	end
end)
addEventHandler("onClientResourceStart", resourceRoot, function()
	for _, player in ipairs(getElementsByType("player")) do
		if getElementData(player, "chat:status") then
			updateStatus(player, "status")
		end
	end
end)

function updateStatus(source, d)
	removeTexts(source, d)
	if getElementData(source, "chat:status") then
		queueText(source, getElementData(source, "chat:status"), {140, 200, 180}, "default-bold", true, d)
	end
end

local pi = math.pi
function outElastic(t, b, c, d, a, p)
	if t == 0 then return b end
	t = t / d
	if t == 1 then return b + c end
	if not p then p = d * 0.3 end
	local s
	if not a or a < math.abs(c) then
	  a = c
	  s = p / 4
	else
	  s = p / (2 * pi) * math.asin(c/a)
	end
	return a * math.pow(2, -10 * t) * math.sin((t * d - s) * (2 * pi) / p) + c + b
end

local function renderChatBubbles()
	local tick = getTickCount()
	local x, y, z = getElementPosition(localPlayer)
	for player, texts in pairs(messageQueue) do
		if isElement(player) then
			for i, msg in ipairs(texts) do
				if tick < msg.expires or msg.sticky then
					local px, py, pz = getElementPosition(player)
					local dim, pdim = getElementDimension(player), getElementDimension(localPlayer)
					local int, pint = getElementInterior(player), getElementInterior(localPlayer)
					local veh = getPedOccupiedVehicle(player)

					if (veh) then
						--local windowTint = getElementData(veh, "vehicle:windowtint")
						local windowTint = 0 -- NOT TINTED PLACEHOLDER TODO
						local windowState = getElementData(veh, "vehicle:windows")

						if getDistanceBetweenPoints3D(x, y, z, px, py, pz) > 8 and windowTint == 1 and windowState == 0 then
							return false
						end
					end

					if getDistanceBetweenPoints3D(x, y, z, px, py, pz) < distanceVisible and isLineOfSightClear(x, y, z, px, py, pz, true, not isPedInVehicle(player), false, true) and (pdim == dim) and (pint == int) then
						msg.alpha = msg.alpha < 200 and msg.alpha + 5 or msg.alpha
						local bx, by, bz = getPedBonePosition(player, 6)
						local sx, sy = getScreenFromWorldPosition(bx, by, bz)

						local elapsedTime = tick - msg.tick
						local duration = msg.expires - msg.tick

						if sx and sy then
							if not msg.yPos then msg.yPos = sy end
							local width = dxGetTextWidth(msg.text:gsub("#%x%x%x%x%x%x", ""), 1, "default-bold")
							local yPos = outElastic(elapsedTime, msg.yPos - 40, (sy - fontHeight * i) - msg.yPos - 10, 1000, 5, 500)

							dxDrawRectangle(sx - (12 + (0.5 * width)), yPos - 2, width + 23, 19, tocolor(20, 20, 20, 200))
							dxDrawRectangle(sx - (12 + (0.5 * width)), yPos - 2, 1, 19, tocolor(msg.color[1], msg.color[2], msg.color[3], 255))
							dxDrawText(msg.text, sx - (0.5 * width), yPos, sx - (0.5 * width), yPos - (i * fontHeight), tocolor(unpack(msg.color)), 1, "default-bold", "left", "top", false, false, false)
						end
					end
				else
					table.remove(messageQueue[player], i)
				end
			end

			if #texts == 0 then
				messageQueue[player] = nil
			end
		else
			messageQueue[player] = nil
		end
	end
end
addEventHandler("onClientPlayerQuit", root, function() messageQueue[source] = nil end)
addEventHandler("onClientRender", root, renderChatBubbles)