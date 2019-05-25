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

g_dealerships = {
	[1] = "No Dealership",
	[2] = "Dealership 1",
	[3] = "Dealership 2",
	[4] = "Dealership 3",
	[5] = "Dealership 4",
}

g_validVehicles = {
	400, 401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 411, 412, 413, 414, 415, 416, 417, 418, 419, 420, 421, 422, 423, 424, 425, 426, 427, 428, 429, 430,
	431, 432, 433, 434, 435, 436, 437, 438, 439, 440, 441, 442, 443, 444, 445, 446, 447, 448, 449, 450, 451, 452, 453, 454, 455, 456, 457, 458, 459, 460,
	461, 462, 463, 464, 465, 466, 467, 468, 469, 470, 471, 472, 473, 474, 475, 476, 477, 478, 479, 480, 481, 482, 483, 484, 485, 486, 487, 488, 489, 490,
	491, 492, 493, 494, 495, 496, 497, 498, 499, 500, 501, 502, 503, 504, 505, 506, 507, 508, 509, 510, 511, 512, 513, 514, 515, 516, 517, 518, 519, 520,
	521, 522, 523, 524, 525, 526, 527, 528, 529, 530, 531, 532, 533, 534, 535, 536, 537, 538, 539, 540, 541, 542, 543, 544, 545, 546, 547, 548, 549, 550,
	551, 552, 553, 554, 555, 556, 557, 558, 559, 560, 561, 562, 563, 564, 565, 566, 567, 568, 569, 570, 571, 572, 573, 574, 575, 576, 577, 578, 579, 580,
	581, 582, 583, 584, 585, 586, 587, 588, 589, 590, 591, 592, 593, 594, 595, 596, 597, 598, 599, 600, 601, 602, 603, 604, 605, 606, 607, 608, 609, 610, 611,
}

--[[
	[g_vehicleTypes]
	Type: Type of vehicle.
	Inventory: Size of the vehicle's inventory, X by Y grid.
	Ignition: Ignition sound.
	Handbrake: Handbrake sound.
	Tank: Size of vehicle tank, false means no tank.		]]
g_vehicleTypes = {
	[1] = {
		["type"] = "Car",
		["inventory"] = {4, 4},
		["ignition"] = "class1",
		["handbrake"] = "normal_handbrake.wav",
		["tank"] = 100,
	},
	[2] = {
		["type"] = "Van",
		["inventory"] = {5, 5},
		["ignition"] = "class2",
		["handbrake"] = "van_handbrake.wav",
		["tank"] = 160,
	},
	[3] = {
		["type"] = "Truck",
		["inventory"] = {6, 5},
		["ignition"] = "truck",
		["handbrake"] = "truck_handbrake.wav",
		["tank"] = 240,
	},
	[4] = {
		["type"] = "Boat",
		["inventory"] = {4, 4},
		["ignition"] = "class1",
		["handbrake"] = false,
		["tank"] = 160,
	},
	[5] = {
		["type"] = "Plane",
		["inventory"] = {6, 4},
		["ignition"] = false,
		["handbrake"] = false,
		["tank"] = false,
	},
	[6] = {
		["type"] = "Helicopter",
		["inventory"] = {4, 4},
		["ignition"] = false,
		["handbrake"] = false,
		["tank"] = 350,
	},
	[7] = {
		["type"] = "SUV",
		["inventory"] = {5, 4},
		["ignition"] = "class2",
		["handbrake"] = "van_handbrake.wav",
		["tank"] = 190,
	},
	[8] = {
		["type"] = "Bicycle",
		["inventory"] = {2, 2},
		["ignition"] = false,
		["handbrake"] = false,
		["tank"] = false,
	},
	[9] = {
		["type"] = "Motorbike",
		["inventory"] = {3, 4},
		["ignition"] = "bike",
		["handbrake"] = false,
		["tank"] = 90,
	},
	[10] = {
		["type"] = "Wagon",
		["inventory"] = {4, 4},
		["ignition"] = "class1",
		["handbrake"] = "van_handbrake.wav",
		["tank"] = 120,
	},
	[11] = {
		["type"] = "Sedan",
		["inventory"] = {4, 4},
		["ignition"] = "class1",
		["handbrake"] = "normal_handbrake.wav",
		["tank"] = 120,
	},
	[12] = {
		["type"] = "Minivan",
		["inventory"] = {5, 4},
		["ignition"] = "class2",
		["handbrake"] = "van_handbrake.wav",
		["tank"] = 115,
	},
	[13] = {
		["type"] = "Hybrid",
		["inventory"] = {4, 4},
		["ignition"] = "class3",
		["handbrake"] = "sports_handbrake.wav",
		["tank"] = 150,
	},
	[14] = {
		["type"] = "Hatchback",
		["inventory"] = {4, 5},
		["ignition"] = "class3",
		["handbrake"] = "van_handbrake.wav",
		["tank"] = 125,
	},
	[15] = {
		["type"] = "Coupe",
		["inventory"] = {4, 4},
		["ignition"] = "class1",
		["handbrake"] = "sports_handbrake.wav",
		["tank"] = 110,
	},
	[16] = {
		["type"] = "Convertible",
		["inventory"] = {4, 5},
		["ignition"] = "class3",
		["handbrake"] = "van_handbrake.wav",
		["tank"] = 115,
	},
	[17] = {
		["type"] = "Train",
		["inventory"] = {5, 5},
		["ignition"] = false,
		["handbrake"] = false,
		["tank"] = false,
	},
	[18] = {
		["type"] = "Sports",
		["inventory"] = {4, 4},
		["ignition"] = "class3",
		["handbrake"] = "sports_handbrake.wav",
		["tank"] = 135,
	},
	[19] = {
		["type"] = "Industrial",
		["inventory"] = {5, 4},
		["ignition"] = "class2",
		["handbrake"] = "van_handbrake.wav",
		["tank"] = 200,
	},
	[20] = {
		["type"] = "Other",
		["inventory"] = {4, 4},
		["ignition"] = "class1",
		["handbrake"] = "normal_handbrake.wav",
		["tank"] = 100,
	},
}

g_platelessVehicle = { [481] = true, [509] = true, [510] = true }
g_enginelessVehicle = { [481] = true, [509] = true, [510] = true }
g_windowlessVehicle = { [424] = true, [457] = true, [480] = true, [485] = true, [486] = true, [528] = true, [530] = true, [531] = true, [532] = true, [568] = true, [571] = true, [572] = true, [601] = true }
g_lightlessVehicle = { [417] = true, [425] = true, [430] = true, [446] = true, [447] = true, [452] = true, [453] = true, [454] = true, [460] = true, [469] = true, [472] = true, [473] = true, [476] = true, [481] = true, [484] = true, [487] = true, [488] = true, [493] = true, [497] = true, [509] = true, [510] = true, [511] = true, [512] = true, [513] = true, [519] = true, [520] = true, [548] = true, [553] = true, [563] = true, [577] = true, [592] = true, [593] = true, [595] = true }
g_locklessVehicle = { [448] = true, [461] = true, [462] = true, [463] = true, [468] = true, [481] = true, [509] = true, [510] = true, [521] = true, [522] = true, [581] = true, [586] = true }

function vehicleTypeToName(typeID)
	if g_vehicleTypes[typeID] then
		return g_vehicleTypes[typeID].type
	else
		return false
	end
end

function getDealershipName(dealershipID)
	if g_dealerships[dealershipID] then
		return g_dealerships[dealershipID]
	else
		return false
	end
end

function isValidVehicleModel(vehicleID)
	if exports.global:table_find(tonumber(vehicleID), g_validVehicles) then
		return true
	else
		return false
	end
end

function vehicleHasWindows(theVehicle)
	if (getVehicleType(theVehicle) == "Automobile") then
		local theVehicleModel = getElementModel(theVehicle)
		if not g_windowlessVehicle[theVehicleModel] then
			return true
		end
	end
	return false
end

function getTankSize(vehicleType)
	if g_vehicleTypes[vehicleType] then
		return g_vehicleTypes[vehicleType]["tank"]
	end
	return false
end

-- Checks if the specified vehicle/Model ID is a plateless vehicle.
function isPlatelessVehicle(theVehicle)
	local modelID = theVehicle
	if isElement(modelID) then modelID = getElementModel(theVehicle) end
	if (g_platelessVehicle[modelID]) then
		return true
	end
	return false
end