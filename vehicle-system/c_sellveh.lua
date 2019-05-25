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
tabsFont_30 = emGUI:dxCreateNewFont(":emGUI/fonts/tabsFont.ttf", 25)

function showReviewSaleGUI(sellingPlayer, tradeData)
	local helpLabels = {}
	saleWindow = emGUI:dxCreateWindow(0.38, 0.28, 0.24, 0.43, " ", true, true, _, true, _, 2)

	helpLabels[1] = emGUI:dxCreateLabel(0.07, 0.06, 0.81, 0.10, "CONFIRM PURCHASE", true, saleWindow)
	emGUI:dxSetFont(helpLabels[1], tabsFont_30)

	helpLabels[2] = emGUI:dxCreateLabel(0.08, 0.22, 0.14, 0.04, "Offer from:", true, saleWindow)
	helpLabels[3] = emGUI:dxCreateLabel(0.08, 0.28, 0.14, 0.04, "Purchasing:", true, saleWindow)
	helpLabels[4] = emGUI:dxCreateLabel(0.08, 0.34, 0.14, 0.04, "Price:", true, saleWindow)
	emGUI:dxLabelSetHorizontalAlign(helpLabels[2], "right", false)
	emGUI:dxLabelSetHorizontalAlign(helpLabels[3], "right", false)
	emGUI:dxLabelSetHorizontalAlign(helpLabels[4], "right", false)

	helpLabels[5] = emGUI:dxCreateLabel(0.25, 0.22, 0.37, 0.04, tradeData[1]:gsub("_", " "), true, saleWindow)
	helpLabels[7] = emGUI:dxCreateLabel(0.25, 0.28, 0.37, 0.04, tradeData[2], true, saleWindow)
	local formattedPrice = exports.global:formatNumber(tradeData[3])
	helpLabels[8] = emGUI:dxCreateLabel(0.25, 0.34, 0.37, 0.04, "$" .. formattedPrice, true, saleWindow)
	
	helpLabels[5] = emGUI:dxCreateLabel(0.06, 0.42, 0.88, 0.22,
	[[Please read the information above and pay close attention
	to the details provided, once you confirm this purchase,
	you will transfer the amount specified in the price field above.

	If you do not agree with the terms listed above, you may
	decline the trade and no transfer will take place.]], true, saleWindow)
	

	declinePurchaseButton = emGUI:dxCreateButton(0.055, 0.80, 0.38, 0.14, "Decline", true, saleWindow)
	addEventHandler("onClientDgsDxMouseClick", declinePurchaseButton, function(b, c)
		if (b == "left") and (c == "down") then
			triggerServerEvent("vehicle:sale:handleSaleCancel", localPlayer, sellingPlayer, tradeData)
			emGUI:dxCloseWindow(saleWindow)
		end
	end)
	confirmPurchaseButton = emGUI:dxCreateButton(0.56, 0.80, 0.38, 0.14, "Confirm", true, saleWindow)
	emGUI:dxSetEnabled(confirmPurchaseButton, false)
	addEventHandler("onClientDgsDxMouseClick", confirmPurchaseButton, function(b, c)
		if (b == "left") and (c == "down") then
			emGUI:dxCloseWindow(saleWindow)
			triggerServerEvent("vehicle:sale:handleSaleConfirmed", localPlayer, sellingPlayer, tradeData)
		end
	end)

	confirmedCheckbox = emGUI:dxCreateCheckBox(0.14, 0.68, 0.72, 0.06, "I have read and fully understand the agreement above.", false, true, saleWindow)
	addEventHandler("onDgsCheckBoxChange", confirmedCheckbox, function(state)
		emGUI:dxSetEnabled(confirmPurchaseButton, state)
	end)
end
addEvent("vehicle:sale:reviewsaleGUI", true)
addEventHandler("vehicle:sale:reviewsaleGUI", root, showReviewSaleGUI)