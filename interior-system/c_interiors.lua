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

local sW, sH = guiGetScreenSize()
local darknessTint = {}
local blackShader = 0

function updateIntLights(lightStatus)
	darknessTint[localPlayer] = lightStatus
	blackShader = currentLightLevel()
end
addEvent("interior:updateIntLights", true)
addEventHandler("interior:updateIntLights", root, updateIntLights)

function drawShadow()
	if not darknessTint[localPlayer] then
		dxDrawRectangle(0, 0, sW, sH, tocolor(0, 0, 0, blackShader), false)
	end
end
addEventHandler("onClientRender", root, drawShadow)

function currentLightLevel()
	local h, m = getTime()
	if h > 4 and h < 18 then
		if h < 6 then  return 240 end
		if h < 8 then return 200 end
		if h < 14 then return 50 end
		return 100
	else
		if h < 23 then return 240 end
		return 247
	end
	return 0
end

-----------------------------------------------------------------------------------------------------------------------------

emGUI = exports.emGUI
local buttonFont_30 = emGUI:dxCreateNewFont("fonts/buttonFont.ttf", 30)
local buttonFont_12 = emGUI:dxCreateNewFont("fonts/buttonFont.ttf", 12)
local previewTimer = false

function showPurchasePropertyGUI(interiorData, theSeller, isFromSell, price, isLinked)
	if emGUI:dxIsWindowVisible(buyPropertyWindow) then emGUI:dxCloseWindow(buyPropertyWindow) end
	local buyPropertyWindowLabels = {}

	setElementData(localPlayer, "var:int:previewint", interiorData[1])
	buyPropertyWindow = emGUI:dxCreateWindow(0.35, 0.21, 0.29, 0.58, "", true, true, _, true)

	buyPropertyWindowLabels[1] = emGUI:dxCreateLabel(0.06, 0.02, 0.87, 0.08, "PURCHASE PROPERTY", true, buyPropertyWindow)
	buyPropertyWindowLabels[2] = emGUI:dxCreateLabel(0.06, 0.13, 0.87, 0.06, "[" .. interiorData[1] .. "] " .. interiorData[2], true, buyPropertyWindow)
	buyPropertyWindowLabels[3] = emGUI:dxCreateLabel(0.09, 0.19, 0.82, 0.07, "Prior to purchasing this property, please review all of the information provided\nbelow carefully and thoroughly to ensure you are aware of the property\ndetails and specifications prior to purchasing it.", true, buyPropertyWindow)
	emGUI:dxSetFont(buyPropertyWindowLabels[1], buttonFont_30)
	emGUI:dxSetFont(buyPropertyWindowLabels[2], buttonFont_12)

	for i = 1, 3 do emGUI:dxLabelSetHorizontalAlign(buyPropertyWindowLabels[i], "center") end

	buyPropertyWindowLabels[4] = emGUI:dxCreateLabel(0.24, 0.3, 0.24, 0.03, "Property Owner:", true, buyPropertyWindow)
	buyPropertyWindowLabels[5] = emGUI:dxCreateLabel(0.24, 0.335, 0.24, 0.03, "Price:", true, buyPropertyWindow)
	buyPropertyWindowLabels[6] = emGUI:dxCreateLabel(0.24, 0.375, 0.24, 0.03, "Type:", true, buyPropertyWindow)
	buyPropertyWindowLabels[7] = emGUI:dxCreateLabel(0.24, 0.415, 0.24, 0.03, "(( Custom Interior:", true, buyPropertyWindow)

	for i = 4, 7 do emGUI:dxLabelSetHorizontalAlign(buyPropertyWindowLabels[i], "right") end

	local hasLink = false
	if isLinked and not isFromSell then price = price + isLinked; hasLink = true end
	buyPropertyWindowLabels[8] =	emGUI:dxCreateLabel(0.50, 0.3, 0.24, 0.03, interiorData[3], true, buyPropertyWindow)
	buyPropertyWindowLabels[9] = 	emGUI:dxCreateLabel(0.50, 0.335, 0.24, 0.03, "$" .. exports.global:formatNumber(price), true, buyPropertyWindow)
	if hasLink then emGUI:dxSetText(buyPropertyWindowLabels[9], "$" .. exports.global:formatNumber(price) .. " ($" .. exports.global:formatNumber(isLinked) .. " Linked Property)") end
	
	local intTypeID = interiorData[4]
	buyPropertyWindowLabels[10] = 	emGUI:dxCreateLabel(0.50, 0.375, 0.24, 0.03, g_interiorTypes[intTypeID][1], true, buyPropertyWindow)
	buyPropertyWindowLabels[11] = 	emGUI:dxCreateLabel(0.50, 0.415, 0.24, 0.03, interiorData[5] .. ". ))", true, buyPropertyWindow)
	
	local intImage = emGUI:dxCreateButton(0.04, 0.48, 0.91, 0.28, "INTERIOR IMAGE", true, buyPropertyWindow)
	local propCheckbox = emGUI:dxCreateCheckBox(0.235, 0.7, 0.1, 0.2, "I confirm that I would like to purchase this property.", false, true, buyPropertyWindow)
	
	local propCancelButton = emGUI:dxCreateButton(0.04, 0.84, 0.3, 0.11, "CANCEL", true, buyPropertyWindow)
	addEventHandler("onClientDgsDxMouseClick", propCancelButton, function(b, c)
		if (b == "left") and (c == "down") then
			triggerServerEvent("interior:handleIntSaleCallback", localPlayer, interiorData[1], 1, theSeller)
			emGUI:dxCloseWindow(buyPropertyWindow)
		end
	end)

	if not isFromSell then
		local propPreviewButton = emGUI:dxCreateButton(0.345, 0.84, 0.3, 0.11, "PREVIEW", true, buyPropertyWindow)
		addEventHandler("onClientDgsDxMouseClick", propPreviewButton, function(b, c)
			if (b == "left") and (c == "down") then
				emGUI:dxCloseWindow(buyPropertyWindow)
				-- Restrict inventory from opening. @requires item-system inventory.
				-- Prevent ability to pick up items. @requires item-system inventory.

				triggerServerEvent("interior:handleIntSaleCallback", localPlayer, interiorData[1], 0)
				outputChatBox("You are now previewing the property '(" .. interiorData[1] .. ") " .. interiorData[2] .. "'.", 75, 230, 10)
				outputChatBox("Exit through the front entrance to exit, preview will end in 1 minute.", 75, 230, 10)
				previewTimer = setTimer(function()
					outputChatBox("You are no longer previewing the property.", 75, 230, 10)
					triggerServerEvent("interior:handleIntSaleCallback", localPlayer, interiorData[1], 2)
				end, 60000, 1)
			end
		end)
	else
		propBankPurchase = emGUI:dxCreateButton(0.345, 0.84, 0.3, 0.11, "PURCHASE WITH\nCARD", true, buyPropertyWindow)
		emGUI:dxSetEnabled(propBankPurchase, false)
		addEventHandler("onClientDgsDxMouseClick", propBankPurchase, function(b, c)
			if (b == "left") and (c == "down") then
				triggerServerEvent("interior:handleIntSaleCallback", localPlayer, interiorData[1], 3, theSeller, interiorData[4], true)
				emGUI:dxCloseWindow(buyPropertyWindow)
			end
		end)
	end

	propPurchaseButton = emGUI:dxCreateButton(0.651, 0.84, 0.3, 0.11, "PURCHASE", true, buyPropertyWindow)
	if isFromSell then emGUI:dxSetText(propPurchaseButton, "PURCHASE VIA\nCASH") end
	emGUI:dxSetEnabled(propPurchaseButton, false)
	addEventHandler("onClientDgsDxMouseClick", propPurchaseButton, function(b, c)
		if (b == "left") and (c == "down") then
			triggerServerEvent("interior:handleIntSaleCallback", localPlayer, interiorData[1], 3, theSeller, price)
			emGUI:dxCloseWindow(buyPropertyWindow)
		end
	end)
	
	addEventHandler("onDgsCheckBoxChange", propCheckbox, function(c)
		emGUI:dxSetEnabled(propPurchaseButton, c)
		if propBankPurchase then emGUI:dxSetEnabled(propBankPurchase, c) end
	end)
end
addEvent("interior:showPurchasePropertyGUI", true)
addEventHandler("interior:showPurchasePropertyGUI", root, showPurchasePropertyGUI)

function stopIntPreview()
	local intID = getElementData(localPlayer, "var:int:previewint")
	if isTimer(previewTimer) then killTimer(previewTimer) end
	triggerServerEvent("interior:handleIntSaleCallback", localPlayer, intID, 2)
end
addEvent("interior:stopIntPreview", true)
addEventHandler("interior:stopIntPreview", root, stopIntPreview)