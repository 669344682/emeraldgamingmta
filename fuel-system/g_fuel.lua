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

g_tanklessVehicle = {}

--[[
	g_fuelStations
	name: Name of the gas station, usually contains its location.
	pos: Contains x, y, z and radius of gas station.
	price: Holds the prices for fuel at the given station, first item in table is petrol, second is diesel. 	]]

g_fuelStations = {
	[1] = {
		["name"] = "LVPD Gas Station",
		["pos"] = {2202.01465, 2476.93457, 10.60431, 15},
		["price"] = {1.7, 1.2},
	},
	[2] = {
		["name"] = "Redsand's West Gas Station",
		["pos"] = {1595.8564, 2198.9169, 10.8, 15},
		["price"] = {1, 1},
	},
	[3] = {
		["name"] = "Southern Strip Gas Station",
		["pos"] = {2115.1796, 920.4785, 10.8, 15},
		["price"] = {1, 1},
	},
	[4] = {
		["name"] = "Tierra Robada Gas Station",
		["pos"] = {-1328.4453, 2677.4941, 50.06, 15},
		["price"] = {1, 1},
	},
	[5] = {
		["name"] = "Montgomery Gas Station",
		["pos"] = {1381.5820, 459.8876, 19.95, 15},
		["price"] = {1, 1},
	},
	[6] = {
		["name"] = "Blueberry Gas Station",
		["pos"] = {657.4169, -564.9755, 16.3, 10},
		["price"] = {1, 1},
	},
}

-- Debug create blips.
for i, item in ipairs(g_fuelStations) do local x, y, z = unpack(item["pos"]); createBlip(x, y, z, 55) end

-- Takes the given player and checks if they are at a gas station with the provided vehicle.
function isPlayerAtGasStation(thePlayer)
	if not isElement(thePlayer) then return false end
	local px, py, pz = getElementPosition(thePlayer)
	local isAtStation = false
	for i, station in ipairs(g_fuelStations) do
		local x, y, z, radius = unpack(g_fuelStations[i]["pos"])

		if getDistanceBetweenPoints3D(x, y, z, px, py, pz) < radius then
			isAtStation = i
			break
		end
	end
	return isAtStation
end
