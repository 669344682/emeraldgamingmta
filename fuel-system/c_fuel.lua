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

emGUI = exports.emGUI
fuelFont_14 = emGUI:dxCreateNewFont(":fuel-system/assets/fuelFont.ttf", 14)
fuelFont_18 = emGUI:dxCreateNewFont(":fuel-system/assets/fuelFont.ttf", 18)

local hasRefueled = false
local fuel = 0
local totalRefueled = 0
local fuelType = 1
local station = 0

function showRefuelGUI(vehicleFuel, fuelStation)
	if emGUI:dxIsWindowVisible(refuelVehicleGUI) then emGUI:dxCloseWindow(refuelVehicleGUI) return end
	if not (vehicleFuel) then vehicleFuel = 0 end
	if not (fuelStation) then fuelStation = 1 end

	fuel = vehicleFuel
	station = fuelStation

	refuelVehicleGUI = emGUI:dxCreateWindow(0.305, 0.37, 0.39, 0.26, "Vehicle Refuel", true, true, _, true)
	
	fuelProgressBar = emGUI:dxCreateProgressBar(0.06, 0.3, 0.61, 0.19, true, refuelVehicleGUI)
	emGUI:dxProgressBarSetUpDownDistance(fuelProgressBar, 0.95, true)
	emGUI:dxProgressBarSetLeftRightDistance(fuelProgressBar, 0, true)
	emGUI:dxProgressBarSetProgress(fuelProgressBar, vehicleFuel)
	emGUI:dxSetEnabled(fuelProgressBar, false)

	local backgroundButton = emGUI:dxCreateButton(0.055, 0.141, 0.62, 0.12, "", true, refuelVehicleGUI, _, _, _, _, _, _, tocolor(0, 0, 0, 200), tocolor(0, 0, 0, 200), tocolor(0, 0, 0, 200))
	emGUI:dxSetEnabled(backgroundButton, false)
	
	currentlyLoadedLabel = emGUI:dxCreateLabel(0.06, 0.15, 0.28, 0.12, "Currently Loading: Petrol", true, refuelVehicleGUI)
	emGUI:dxSetFont(currentlyLoadedLabel, fuelFont_14)
	
	pricePerltLabel = emGUI:dxCreateLabel(0.525, 0.15, 0.14, 0.12, "Price: $" .. g_fuelStations[fuelStation]["price"][1] .. "/L", true, refuelVehicleGUI)
	emGUI:dxSetFont(pricePerltLabel, fuelFont_14)
	emGUI:dxLabelSetHorizontalAlign(pricePerltLabel, "right")

	emptyFuelLabel = emGUI:dxCreateLabel(0.07, 0.33, 0.07, 0.07, "EMPTY", true, refuelVehicleGUI, tocolor(255, 0, 0))
	if (fuel > 15) then
		emGUI:dxSetVisible(emptyFuelLabel, false)
	end
	emGUI:dxSetFont(emptyFuelLabel, fuelFont_18)
	
	costButton = emGUI:dxCreateButton(0.06, 0.52, 0.16, 0.12, "Cost: $0", true, refuelVehicleGUI, _, _, _, _, _, _, tocolor(0, 0, 0, 200), tocolor(0, 0, 0, 200), tocolor(0, 0, 0, 200))
	emGUI:dxSetFont(costButton, fuelFont_14)
	
	stateButton = emGUI:dxCreateButton(0.51, 0.52, 0.16, 0.12, "Idle", true, refuelVehicleGUI, tocolor(253, 106, 2), _, _, _, _, _, tocolor(0, 0, 0, 200), tocolor(0, 0, 0, 200), tocolor(0, 0, 0, 200))
	emGUI:dxSetFont(stateButton, fuelFont_14)

	petrolButton = emGUI:dxCreateButton(0.73, 0.07, 0.23, 0.26, "PETROL", true, refuelVehicleGUI)
	emGUI:dxSetFont(petrolButton, fuelFont_14)
	emGUI:dxSetEnabled(petrolButton, false)
	addEventHandler("onClientDgsDxMouseClick", petrolButton, function()
		fuelType = 1
		emGUI:dxSetEnabled(petrolButton, false)
		emGUI:dxSetEnabled(dieselButton, true)
		emGUI:dxSetText(pricePerltLabel, "Price: $" .. g_fuelStations[fuelStation]["price"][1] .. "/L")
		emGUI:dxSetText(currentlyLoadedLabel, "Currently Loading: Petrol")
	end)
	
	dieselButton = emGUI:dxCreateButton(0.73, 0.38, 0.23, 0.26, "DIESEL", true, refuelVehicleGUI)
	emGUI:dxSetFont(dieselButton, fuelFont_14)
	addEventHandler("onClientDgsDxMouseClick", dieselButton, function()
		fuelType = 2
		emGUI:dxSetEnabled(dieselButton, false)
		emGUI:dxSetEnabled(petrolButton, true)
		emGUI:dxSetText(pricePerltLabel, "Price: $" .. g_fuelStations[fuelStation]["price"][2] .. "/L")
		emGUI:dxSetText(currentlyLoadedLabel, "Currently Loading: Diesel")
	end)
	
	fuelCloseButton = emGUI:dxCreateButton(0.73, 0.69, 0.23, 0.26, "CLOSE", true, refuelVehicleGUI)
	emGUI:dxSetFont(fuelCloseButton, fuelFont_14)
	addEventHandler("onClientDgsDxMouseClick", fuelCloseButton, function(b, c) if (b == "left") and (c == "down") then emGUI:dxCloseWindow(refuelVehicleGUI) end end)
	
	refuelButton = emGUI:dxCreateButton(0.06, 0.76, 0.62, 0.13, "HOLD SPACEBER TO REFUEL", true, refuelVehicleGUI)
	emGUI:dxSetFont(refuelButton, fuelFont_14)
	addEventHandler("onClientDgsDxMouseClick", refuelButton, doneFueling)

	local doneFuelingSound = playSound("assets/unhook.ogg")

	addEventHandler("onClientDgsDxWindowClose", root, function()
		if not (hasRefueled) then triggerServerEvent("refuel:removedata", localPlayer) end
		hasRefueled, fuel, totalRefueled, fuelType = false, 0, 0, 1
		removeEventHandler("onClientKey", root, handleRefueling)
	end)

	addEventHandler("onClientKey", root, handleRefueling)
end
addEvent("fuel:showRefuelGUI", true)
addEventHandler("fuel:showRefuelGUI", root, showRefuelGUI)

local refuelingSound = false

function handleRefueling(button, press)
	if (button == "space") then
		if (press) and not isChatBoxInputActive() then
			hasRefueled = true
			local startFuelingSound = playSound("assets/release_trigger.ogg")
			if not (refuelingSound) and (fuel ~= 100) then
				refuelingSound = playSound("assets/fuel_loop.ogg", true)
				emGUI:dxSetText(stateButton, "Fueling")
			end
			addEventHandler("onClientRender", root, increaseFuelBar)
		elseif not press and not isChatBoxInputActive() then
			if (refuelingSound) then stopSound(refuelingSound); refuelingSound = false end
			if (fuel < 100) then emGUI:dxSetText(stateButton, "Idle") end
			removeEventHandler("onClientRender", root, increaseFuelBar)
		end
	end
end

totalCost = 0
function increaseFuelBar()
	fuel = fuel + 0.1
	totalRefueled = totalRefueled + 0.1
	if (fuel <= 100) then
		if (fuel > 15) then
			emGUI:dxSetVisible(emptyFuelLabel, false)
		end
		emGUI:dxSetText(refuelButton, "PAY")
		totalCost = round(totalRefueled, 1) * g_fuelStations[station]["price"][fuelType]
		emGUI:dxSetText(costButton, "Cost: $" .. totalCost)
		emGUI:dxProgressBarSetProgress(fuelProgressBar, fuel)
	else
		if (refuelingSound) then stopSound(refuelingSound); refuelingSound = false end
		removeEventHandler("onClientRender", root, increaseFuelBar)
		emGUI:dxSetText(stateButton, "FULL")
		emGUI:dxButtonSetTextColor(stateButton, tocolor(0, 255, 0))
	end
end

function doneFueling(b, c)
	if (b == "left") and (c == "down") then
		if (hasRefueled) then
			local doneFuelingSound = playSound("assets/unhook.ogg")
			triggerServerEvent("fuel:doneRefueling", localPlayer, localPlayer, totalCost, totalRefueled, fuelType)
			totalCost = 0
			emGUI:dxCloseWindow(refuelVehicleGUI)
		end
	end
end

function round(n, p) local mult = 10 ^ (p or 0); return math.floor(n * mult + 0.5) / mult end

addCommandHandler("refuel", function()
	if emGUI:dxIsWindowVisible(refuelVehicleGUI) then emGUI:dxCloseWindow(refuelVehicleGUI) return end
	triggerServerEvent("fuel:refuelCall", localPlayer, localPlayer)
end)