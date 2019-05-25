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
| |\ \\ \_/ / |____| |___| |   | |____| | | || |         Zil & Skully         
\_| \_|\___/\_____/\____/\_|   \_____/\_| |_/\_/                             
                                                                             
Copyright of Emerald Gaming Development Team, do not distribute - All rights reserved. ]]

enginelessVehicle = { [481] = true, [509] = true, [510] = true, }
lightlessVehicle = { [592] = true, [577] = true, [511] = true, [548] = true, [512] = true, [593] = true, [425] = true, [520] = true, [417] = true, [487] = true, [553] = true, [488] = true, [497] = true, [563] = true, [476] = true, [447] = true, [519] = true, [460] = true, [469] = true, [513] = true, [472] = true, [473] = true, [493] = true, [595] = true, [484] = true, [430] = true, [453] = true, [452] = true, [446] = true, [454] = true, [510] = true, [509] = true, [481] = true }

-- Takes the given vehicle or GTA:SA vehicle ID and checks to see if it has an engine, returns true if it does.
function hasVehicleEngine(vehicle)
	if not (vehicle) then outputDebug("@hasVehicleEngine: vehicle not provided or is not an element or numerical value.") return false end

	if type(vehicle) == "number" then
		return not enginelessVehicle[(vehicle)]
	else
		return not enginelessVehicle[getElementModel(vehicle)]
	end
end

-- Takes the given vehicle or GTA:SA vehicle ID and checks to see if it has lights, returns true if it does.
function hasVehicleLights(vehicle)
	if not (vehicle) then outputDebug("@hasVehicleLights: vehicle not provided or is not an element or numerical value.") return false end

	if type(vehicle) == "number" then
		return not lightlessVehicle[(vehicle)]
	else
		return not lightlessVehicle[getElementModel(vehicle)]
	end
end

-- Generates a new registration plate.
function generateNumberPlate()
	local numberplate = string.char(math.random(65,90)) .. math.random(0, 9) .. string.char(math.random(65,90)) .. " " .. math.random(1000, 9899) -- Format (X is numeric, Y is alphabetical): YXY XXXX 

	local doesPlateExist = exports.mysql:QueryString("SELECT `id` FROM `vehicles` WHERE `plates` = (?);", numberplate)
	if not (doesPlateExist) then
		return numberplate
	else
		outputDebug("@generateNumberPlate: Generated plates that already exist, re-running function.", 3)
		return string.char(math.random(65,90)) .. math.random(0, 9) .. string.char(math.random(65,90)) .. " " .. math.random(9900, 9999)
	end
end

-- Takes the given vehicle and returns it's velocity as either KM/H or MPH.
function getVehicleVelocity(theVehicle, thePlayer)
	local speedx, speedy, speedz = getElementVelocity(theVehicle)
	local actualspeed = (speedx ^ 2 + speedy ^ 2 + speedz ^ 2) ^ (0.5) 
	if thePlayer and isElement(thePlayer) and getElementData(thePlayer, "hud:vehicle:speedo") == 2 then
		return actualspeed * 111.847
	else 
		return actualspeed * 180
	end
end