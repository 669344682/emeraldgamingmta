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
| |\ \\ \_/ / |____| |___| |   | |____| | | || |         	Skully
\_| \_|\___/\_____/\____/\_|   \_____/\_| |_/\_/

Created for Emerald Gaming Roleplay, do not distribute - All rights reserved. ]]

g_itemList = {
--  ID	   OBJID     Item Name			     Description		                             		  		  Category  Weight	rx      ry      rz      z+
	[1] = {1271,	"Generic Item", 		"A generic item.",													4,		1.0,	0,		0,		0,		0.4},
	[2] = {80, 		"Wallet",				"A nice leather wallet.", 											1,		0.1,	0,		0,		0,		0},
	[3] = {80,		"Purse",				"A standard purse for all your goods.",								5,		1.0,	0,		0,		0,		0},
	[4] = {1212,	"Money",				"Lovely money.",													1,		0.1,	0,		0,		0,		0},
	[5] = {11746,	"Vehicle Key",			"A vehicle key.",													3,		0.15,	0,		0,		0,		0},
	[6] = {11746,	"House Key",			"A house key.",														3,		0.15,	0,		0,		0,		0},
	[7] = {11746,	"Property Key",			"A property key.",													3,		0.15,	0,		0,		0,		0},
	[8] = {1581,	"Keycard",				"A keycard.",														3,		0.05,	0,		0,		0,		0},
	[9] = {364,		"Teleporter Remote",	"A remote to manage a teleporter.",									3,		0.1,	0,		0,		0,		0},
	[10] = {364,	"Car Lift Key",			"A lift key to raise or lower a car lift.",							3,		0.1,	0,		0,		0,		0},
	[11] = {18868,	"Phone",				"A generic phone.",													4,		0.1,	0,		0,		0,		0},
	[12] = {2386,	"Clothes",				"A set of clothes.",												4,		1.5,	0,		0,		0,		0},
	[13] = {19039,	"Watch",				"A standard watch that tells the time.",							4,		0.1,	0,		0,		0,		0},
	[14] = {19942,	"Radio",				"A radio for long distance communication.",							6,		1.0,	0,		0,		0,		0},
	[15] = {1581,	"Identification Card",	"Las Venturas Identification Card",									1,		0.05,	0,		0,		0,		0},
	[16] = {1581,	"Debit Card",			"A Bank of Las Venturas debit card.",								1,		0.05,	0,		0,		0,		0},
	[17] = {1581,	"Vehicle License",		"A standard motor vehicle license.",								1,		0.05,	0,		0,		0,		0},
	[18] = {1581,	"Bike License",			"A bike license.",													1,		0.05,	0,		0,		0,		0},
	[19] = {1581,	"Boat License",			"A boat license.",													1,		0.05,	0,		0,		0,		0},
	[20] = {1581,	"Pilot License",		"A pilot license.",													1,		0.05,	0,		0,		0,		0},
	[21] = {1581,	"Concealed Carry Weapon Permit",	"A permit issued by the police department.",			1,		0.05,	0,		0,		0,		0},
	[22] = {3026,	"Backpack",				"A large backpack to store all your general goods.",				5,		2.0,	0,		0,		0,		0},
	[23] = {11745,	"Dufflebag",			"A dufflebag to hold your general items",							5,		3.5,	0,		0,		0,		0},
	[24] = {1210,	"Briefcase",			"A briefcase which makes you look important.",						5,		2.0,	0,		0,		0,		0},
	[25] = {2386,	"Duty Belt",			"A duty belt to store all your duty equipment.",					5,		1.5,	0,		0,		0,		0},
	[26] = {11745,	"Medical Bag",			"A medical bag to store all sorts of medical equipment.",			5,		3.0,	0,		0,		0,		0},
	[27] = {1242,	"Level II Body Armor",	"Level II light body armor.",										5,		1.0,	0,		0,		0,		0},
	[28] = {1242,	"Level IIIa Body Armor","Level IIIa medium body armor.",									5,		1.5,	0,		0,		0,		0},
	[29] = {1242,	"Level IV Body Armor",	"Level IV heavy body armor.",										5,		2.5,	0,		0,		0,		0},
	[30] = {18875,	"Portable GPS",			"A portable GPS used for navigation.",								6,		0.5,	0,		0,		0,		0},
	[31] = {1581,	"Earpiece",				"An earpiece used to play sound right into your ears.",				6,		0.1,	0,		0,		0,		0},
	[32] = {19169,	"Map",					"A navigational map.",												4,		0.05,	0,		0,		0,		0},
	[33] = {1581,	"Business Card",		"A business card.",													4,		0.05,	0,		0,		0,		0},
	[34] = {2222,	"Generic Food",			"A generic food.",													8,		0.1,	0,		0,		0,		0},
	[35] = {19346,	"Hotdog",				"A lovely hotdog!",													8,		0.1,	0,		0,		0,		0},
	[36] = {2894,	"Phonebook",			"A phone book to search up names and numbers.",						4,		0.3,	0,		0,		0,		0},
	[37] = {2355,	"Sandwich",				"A nice Sandwich.",													8,		0.1,	0,		0,		0,		0},
	[38] = {1484,	"Drink",				"A refreshing drink.",												8,		0.1,	0,		0,		0,		0},
	[39] = {1852,	"Dice",					"A standard 6-sided dice.",											4,		0.05,	0,		0,		0,		0},
	[40] = {2215,	"Taco",					"A nice and crispy taco.",											8,		0.1,	0,		0,		0,		0},
	[41] = {2703,	"Burger",				"A good ol' burger.",												8,		0.1,	0,		0,		0,		0},
	[42] = {2222,	"Donut",				"A lovely pink glazed donut.",										8,		0.1,	0,		0,		0,		0},
	[43] = {2222,	"Cookie",				"A sweet chocolate chip cookie.",									8,		0.1,	0,		0,		0,		0},
	[44] = {1271,	"Cabbage",				"A green cabbage.",													8,		0.1,	0,		0,		0,		0},
	[45] = {1484,	"Water",				"A bottle of water.",												8,		0.1,	0,		0,		0,		0},
	[46] = {19835,	"Coffee",				"A nice cup of coffee.",											8,		0.1,	0,		0,		0,		0},
	[47] = {2222,	"Pancake",				"A flat pancake.",													8,		0.1,	0,		0,		0,		0},
	[48] = {2222,	"Fruit",				"A fruit.",															8,		0.1,	0,		0,		0,		0},
	[49] = {18874,	"MP3 Player",			"An MP3 player which plays music.",									6,		0.2,	0,		0,		0,		0},
	[50] = {2386,	"Gas Mask",				"A mask which prevents the intake of gases.",						5,		0.25,	0,		0,		0,		0},
	[51] = {343,	"Flashbang",			"A DID MA1008 standard flashbang.",									2,		0.15,	0,		0,		0,		0},
	[52] = {1271,	"Door Ram",				"A Bronco ENFORCER™ door ram.",										4,		2.0,	0,		0,		0,		0},
	[53] = {1271,	"Breathalyzer",			"A breathalyser which detects levels of intoxication.",				4,		0.1,	0,		0,		0,		0},
	[54] = {11749,	"Handcuffs",			"Can be used to restrain someone.",									4,		0.3,	0,		0,		0,		0},
	[55] = {330,	"Snakecam",				"A small snake like wire to see into small areas using a camera.",	6,		0.1,	0,		0,		0,		0},
	[56] = {18875,	"Dispatch Device",		"A dispatch device.",												6,		0.1,	0,		0,		0,		0},
	[57] = {1271,	"Emergency Light Strobes","A set of emergency light strobes.",								9,		0.5,	0,		0,		0,		0},
	[58] = {1271,	"Emergency Siren",		"An emergency siren.",												9,		0.5,	0,		0,		0,		0},
	[59] = {19347,	"PD Badge",				"A Police Department issued badge.",								4,		0.1,	0,		0,		0,		0},
	[60] = {19775,	"FD Badge",				"A Fire Department issued badge.",									4,		0.1,	0,		0,		0,		0},
	[61] = {18637,	"Riot Shield",			"A re-enforced riot shield used to deflect minor bullets.",			4,		1.5,	0,		0,		0,		0},
	[62] = {1271,	"Yellow Strobes",		"A set of yellow strobe lights.",									9,		0.3,	0,		0,		0,		0},
	[63] = {1271,	"Rope",					"A rope to climb things or tie someone up with.",					4,		0.1,	0,		0,		0,		0},
	[64] = {11746,	"Handcuff Keys",		"A set of handcuff keys to unlock the handcuffs they are from.",	4,		0.05,	0,		0,		0,		0},
	[65] = {2232,	"Speaker",				"A large speaker to amplify sound.",								6,		0.5,	0,		0,		0,		0.67},
	[66] = {2226,	"Stereo Box",			"A portable stereo box for music on the go.",						6,		0.1,	0,		0,		0,		0},
	[67] = {19163,	"Balaclava",			"A balaclava mask to conceal your face.",							5,		0.05,	0,		0,		0,		0},
	[68] = {1650,	"Fuel Can",				"A red fuel can to store fuel.",									4,		0.3,	0,		0,		0,		0},
	[69] = {2332,	"Safe",					"A large metal safe to hold important items.",						4,		1.0,	0,		0,		0,		0},
	[70] = {2386,	"Blindfold",			"A blindfold to prevent people from seeing.",						5,		0.05,	0,		0,		0,		0},
	[71] = {2894,	"Notebook",				"A notebook to write all your notes and stories.",					4,		0.05,	0,		0,		0,		0},
	[72] = {2894,	"Note",					"A note.",															4,		0.05,	0,		0,		0,		0},
	[73] = {2824,	"Card Deck",			"A standard deck of 52 cards.",										4,		0.05,	0,		0,		0,		0},
	[74] = {1271,	"Porn Tape",			"A porn tape for all your sexual desires.",							4,		0.1,	0,		0,		0,		0},
	[75] = {1840,	"Motorbike Helmet",		"A protective motorbike helmet.",									5,		0.3,	0,		0,		0,		0},
	[76] = {18645,	"Full Face Helmet",		"A full face concealing motorbike helmet with visor.",				5,		0.7,	0,		0,		0,		0},
	[77] = {19894,	"Laptop",				"A standard laptop.",												6,		0.7,	0,		0,		0,		0},
	[78] = {3761,	"Shelf",				"A large shelf to store items.",									4,		1.0,	0,		0,		0,		0},
	[79] = {1518,	"Portable TV",			"A portable television.",											6,		1.0,	0,		0,		0,		0},
	[80] = {19998,	"Lighter",				"A lighter to.. light things.",										4,		0.05,	0,		0,		0,		0},
	[81] = {19896,	"Packet of Cigarettes",	"A standard packet of cigarettes.",									8,		0.1,	0,		0,		0,		0},
	[82] = {19625,	"Cigarette",			"A cigarette, best used when lit by a lighter.",					8,		0.05,	0,		0,		0,		0},
	[83] = {1271,	"Vehicle Upgrade",		"A vehicle upgrade.",												9,		0.7,	0,		0,		0,		0},
	[84] = {1271,	"Megaphone",			"A megaphone to make YOU SOUND LOUDER.",							6,		0.5,	0,		0,		0,		0},
	[85] = {18641,	"Flashlight",			"A flashlight to brighten up the area it points over.",				6,		0.3,	0,		0,		0,		0},
	[86] = {2894,	"Wallpaper",			"A wallpaper to change textures.",									4,		0.1,	0,		0,		0,		0},
	[87] = {19921,	"Toolbox",				"A toolbox containing various tools.",								4,		0.5,	0,		0,		0,		0},
	[88] = {18898,	"Bandana",				"A coloured bandana to conceal the lower half of your face.",		5,		0.05,	0,		0,		0,		0},
	[89] = {2717,	"Poster",				"A poster to display your message or art.",							4,		0.05,	0,		0,		0,		0},
	[90] = {2814,	"Pizza",				"A box containing delicious pizza.",								8,		0.3,	0,		0,		0,		0},
	[91] = {2894,	"DMV Ownership Papers",	"A legal document by the DMV to transfer ownership of a vehicle.",	9,		0.05,	0,		0,		0,		0},
}

-- Item references for efficiency.
ITEMS = {
	MONEY = 4,
	BACKPACK = 22,
	DUFFLEBAG = 23,
	BRIEFCASE = 24,
	DUTY_BELT = 25,
	MEDICAL_BAG = 26,
}

categoryTable = {
	"Wallet", 					-- 1
	"Weapons",					-- 2
	"Keys", 					-- 3
	"General Items", 			-- 4
	"Clothing & Accessories",	-- 5
	"Electronics",				-- 6
	"Ammunition",				-- 7
	"Consumables",				-- 8
	"Vehicle",					-- 9
	"Drugs",					-- 10
	"Other",					-- 11
}

inventoryStorageItems = {
	[22] = true, -- Backpack
	[23] = true, -- Dufflebag
	[24] = true, -- Briefcase
	[25] = true, -- Duty Belt
	[26] = true, -- Medical Bag
	[27] = true, -- Level II Body Armor
	[28] = true, -- Level IIIa Body Armor
	[29] = true, -- Level IV Body Armor
}

function isItemStorage(itemID) if inventoryStorageItems[tonumber(itemID)] then return true else return false end end

function getItemCategory(itemID)
	if g_itemList[itemID] then
		return categoryTable[g_itemList[4]]
	end
	return false
end

function getItemName(itemID)
	if g_itemList[itemID] then
		return g_itemList[itemID][2]
	end
	return false
end

-- Used by faction-system.
function getItemTable() return g_itemList end

function getItemObjectID(itemID)
	if g_itemList[itemID] then
		return g_itemList[itemID][1]
	end
	return false
end