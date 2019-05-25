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

Copyright of the Emerald Gaming Development Team, do not distribute - All rights reserved.

[WARNING] This is the master file which defines each interior, DO NOT adjust unless you know what you're doing.]]

--[[	Interior Definitions
[Categories]					[Sizes]
1 = HOUSE						1 = SMALL
2 = GARAGE						2 = MEDIUM
3 = BUSINESS					3 = LARGE
4 = MOTEL						4 = HUGE
5 = GOVERNMENT
6 = OTHER										]]

g_interiors = {
--	[ID]	 Interior		  x				y 			z		rz		 Category  Size      Description
	[1] = {		5,			{2233.53,	 -1115.26,	 1050.88,	0},			4,		1, "Small Motel Bedroom"},
	[2] = {		1,			{243.71,	 304.93,	 999.14,	270},		4,		1, "Small Bedroom, Messy"},
	[3] = {		6,			{343.98,	 305.14,	 999.14,	270},		1,		1, "Small Bedroom, Sex Theme"},
	[4] = {		5,			{2233.57,	 -1115.08,	 1050.88,	0},			4,		1, "Small Bedroom"},
	[5] = {		2,			{266.56,	 305.02,	 999.14,	270},		4,		1, "Small Bedroom 2"},
	[6] = {		1,			{2218.24,	 -1076.27,	 1050.48,	90},		4,		1, "Medium Bedroom"},
	[7] = {		14,			{254.46,	 -41.60,	 1002.02,	270},		1,		1, "Small Wardrobe"},
	[8] = {		2,			{1.90,		 -3.20,	 	 999.40,	0},			1,		1, "Small Trailer"},
	[9] = {		10,			{422.26,	 2536.37,	 10.00,		90},		1,		1, "Small House, 1 Room, 1 Floor"},
	[10] = {	6,			{2308.80,	 -1212.94,	 1049.02,	0},			1,		1, "Small House, 2 Rooms, 1 Floor"},
	[11] = {	8,			{-42.65,	 1405.46,	 1084.42,	0},			1,		1, "Small House, 3 Rooms, 1 Floor"},
	[12] = {	10,			{2259.68,	 -1136.09,	 1050.63,	270},		1,		1, "Small House, 3 Rooms, 1 Floor"},
	[13] = {	2,			{2237.52,	 -1081.64,	 1049.02,	0},			1,		1, "Small House, 3 Rooms, 1 Floor"},
	[14] = {	4,			{221.77,	 1140.43,	 1082.60,	0},			1,		1, "Small House, 3 Rooms, 1 Floor"},
	[15] = {	6,			{-68.83,	 1351.46,	 1080.21,	0},			1,		1, "Small House, 3 Rooms, 1 Floor"},
	[16] = {	6,			{2333.00,	 -1077.00,	 1049.00,	0},			1,		1, "Small House, 3 Rooms, 1 Floor"},
	[17] = {	11,			{2282.98,	 -1140.15,	 1050.90,	0},			1,		1, "Small House, 3 Rooms, 1 Floor"},
	[18] = {	15,			{387.22,	 1471.76,	 1080.18,	90},		1,		1, "Small House, 3 Rooms, 1 Floor"},
	[19] = {	2,			{2468.77,	 -1698.25,	 1013.50,	90},		1,		1, "Small House (Ryder), 3 Rooms, 1 Floor"},
	[20] = {	8,			{2365.14,	 -1135.35,	 1050.87,	0},			1,		1, "Small House, 4 Rooms, 1 Floor"},
	[21] = {	4,			{261.14,	 1284.56,	 1080.25,	0},			1,		1, "Small House, 4 Rooms, 1 Floor"},
	[22] = {	2,			{226.48,	 1239.87,	 1082.14,	90},		1,		1, "Small House, 4 Rooms, 1 Floor"},
	[23] = {	1,			{223.22,	 1287.17,	 1082.14,	0},			1,		1, "Small House, 4 Rooms, 1 Floor"},
	[24] = {	9,			{260.67,	 1237.32,	 1084.25,	0},			1,		1, "Small House, 5 Rooms, 1 Floor"},
	[25] = {	6,			{744.46,	 1436.68,	 1102.70,	0},			1,		1, "Small Bar/House, 5 Rooms, 1 Floor"},
	[26] = {	5,			{318.55,	 1114.47,	 1083.88,	0},			1,		1, "Small House, 5 Rooms, 1 Floor"},
	[27] = {	15,			{327.96,	 1477.72,	 1084.43,	0},			1,		1, "Small House, 5 Rooms, 1 Floor"},
	[28] = {	4,			{299.78,	 311.09,	 1003.30,	270},		1,		1, "Small House, 2 Rooms, 2 Floors"},
	[29] = {	15,			{377.15,	 1417.42,	 1081.30,	90},		1,		2, "Medium House, 4 Rooms, 1 Floor"},
	[30] = {	15,			{295.05,	 1472.36,	 1080.25,	0},			1,		2, "Medium House, 5 Rooms, 1 Floor"},
	[31] = {	5,			{22.98,	 	 1403.60,	 1084.42,	0},			1,		2, "Medium House, 5 Rooms, 1 Floor"},
	[32] = {	10,			{2270.41,	 -1210.46,	 1047.56,	0},			1,		2, "Medium House, 5 Rooms, 1 Floor"},
	[33] = {	2,			{446.97,	 1397.22,	 1084.30,	0},			1,		2, "Medium House, 6 Rooms, 1 Floor"},
	[34] = {	6,			{2196.85,	 -1204.40,	 1049.00,	0},			1,		2, "Medium House, 6 Rooms, 1 Floor"},
	[35] = {	8,			{2807.66,	 -1174.54,	 1025.57,	0},			1,		2, "Medium House, 3 Rooms, 2 Floors"},
	[36] = {	4,			{-260.78,	 1456.73,	 1084.36,	90},		1,		2, "Medium House, 3 Rooms, 2 Floors"},
	[37] = {	3,			{2496.03,	 -1692.17,	 1014.74,	180},		1,		2, "Medium House (CJ), 3 Rooms, 2 Floors"},
	[38] = {	10,			{24.00,	 	 1340.33,	 1084.37,	0},			1,		2, "Medium House, 4 Rooms, 2 Floors"},
	[39] = {	9,			{2317.81,	 -1026.55,	 1050.21,	0},			1,		3, "Large House, 5 Rooms, 2 Floors"},
	[40] = {	12,			{2324.42,	 -1149.20,	 1050.71,	0},			1,		3, "Large House, 5 Rooms, 2 Floors"},
	[41] = {	9,			{83.00,		 1322.48,	 1083.86,	0},			1,		3, "Large House, 6 Rooms, 2 Floors"},
	[42] = {	3,			{235.44,	 1186.83,	 1080.25,	0},			1,		3, "Large House, 6 Rooms, 2 Floors"},
	[43] = {	5,			{226.56,	 1114.19,	 1080.99,	270},		1,		3, "Large House, 9 Rooms, 2 Floors"},
	[44] = {	5,			{140.39,	 1366.36,	 1083.85,	0},			1,		4, "Luxurious House, 7 Rooms, 2 Floors"},
	[45] = {	7,			{225.71,	 1021.44,	 1084.01,	0},			1,		4, "Luxurious House, 8 Rooms, 2 Floors"},
	[46] = {	6,			{234.20,	 1063.85,	 1084.21,	0},			1,		4, "Luxurious House, 8 Rooms, 2 Floors"},
	[47] = {	5,			{1260.84,	 -785.42,	 1091.90,	270},		1,		4, "Mad Dog's Mansion"},
	[48] = {	3,			{620.01,	 -119.85,	 998.84,	180},		2,		1, "Small Garage, 1 Car"},
	[49] = {	2,			{620.18,	 -70.89,	 997.99,	0},			2,		1, "Small Garage, 1 Car"},
	[50] = {	1,			{613.52,	 3.31,	 	 1000.92,	180},		2,		1, "Small Garage, 5 Cars"},
	[51] = {	18,			{1726.86,	 -1638.05,	 20.22,		180},		4,		4, "Atrium"},
	[52] = {	15,			{2214.62,	 -1150.38,	 1025.79,	270},		4,		4, "Jefferson Motel"},
	[53] = {	1,			{2266.32,	 1647.59,	 1084.23,	270},		4,		3, "Apartment Complex Hallway"},
	[54] = {	3,			{1494.28,	 1303.91,	 1093.28,	0},			3,		1, "Office"},
	[55] = {	1,			{1412.14,	 -2.28,	 	 1000.92,	115},		6,		3, "Empty Warehouse"},
	[56] = {	18,			{1306.86,	 6.83,	 	 1001.02,	90},		6,		3, "Full Warehouse"},
	[57] = {	2,			{2541.72,	 -1303.89,	 1025.07,	265},		6,		4, "Big Smoke's Crack House"},
	[58] = {	3,			{834.61,	 7.54,	 	 1004.18,	90},		3,		1, "Small Business (Betting Shop)"},
	[59] = {	1,			{-2158.81,	 643.14,	 1052.37,	180},		3,		2, "Medium Business (Horse Betting)"},
	[60] = {	12,			{1133.25,	 -15.26,	 1000.67,	0},			3,		2, "Medium Business (Casino)"},
	[61] = {	17,			{493.34,	 -24.48,	 1000.67,	0},			3,		2, "Medium Business (Alhambra Club)"},
	[62] = {	6,			{-2240.69,	 128.43,	 1035.41,	270},		3,		2, "Medium Business (Zero's RC Shop)"},
	[63] = {	1,			{964.94,	 2159.97,	 1011.03,	90},		3,		2, "Medium Business (Sindacco Meat Factory)"},
	[64] = {	18,			{-229.17,	 1401.14,	 27.76,		270},		3,		2, "Medium Bar (Lil' Probe Inn)"},
	[65] = {	1,			{681.54,	 -451.20, 	 -25.61,	180},		3,		1, "Small Bar/Restaurant"},
	[66] = {	11,			{501.84,	 -67.84,	 998.75,	180},		3,		2, "Medium Bar (Ten Green Bottles)"},
	[67] = {	5,			{772.43,	 -5.19,	 	 1000.72,	0},			3,		1, "Ganton Gym"},
	[68] = {	7,			{773.93,	 -78.49,	 1000.66,	0},			3,		1, "Medium Gym"},
	[69] = {	6,			{774.20,	 -50.20,	 1000.58,	0},			3,		1, "Medium Gym (SF)"},
	[70] = {	3,			{418.75,	 -84.31,	 1001.80,	0},			3,		1, "Small Barber Shop (Ganton Barbers)"},
	[71] = {	2,			{411.63,	 -23.06,	 1001.80,	0},			3,		1, "Small Barber Shop"},
	[72] = {	12,			{411.86,	 -54.20,	 1001.89,	0},			3,		1, "Small Barber Shop 2"},
	[73] = {	3,			{-204.31,	 -44.08,	 1002.27,	0},			3,		1, "Small Tattoo Parlor 1"},
	[74] = {	17,			{-204.23,	 -8.88,		 1002.27,	0},			3,		1, "Small Tattoo Parlor 2"},
	[75] = {	16,			{-204.41,	 -27.22,	 1002.27,	0},			3,		1, "Small Tattoo Parlor 3"},
	[76] = {	6,			{-27.15,	 -57.87,	 1003.54,	0},			3,		1, "Small 24/7"},
	[77] = {	18,			{-31.02,	 -91.92,	 1003.54,	0},			3,		2, "Medium 24/7"},
	[78] = {	16,			{-25.68,	 -140.99,	 1003.54,	0},			3,		2, "Medium 24/7 2"},
	[79] = {	4,			{-27.30,	 -31.41,	 1003.55,	0},			3,		2, "Medium 24/7 3"},
	[80] = {	17,			{-25.91,	 -188.05,	 1003.54,	0},			3,		3, "Large 24/7"},
	[81] = {	10,			{6.05,	 	 -31.27,	 1003.54,	0},			3,		3, "Large 24/7 2"},
	[82] = {	9,			{364.95,	 -11.60,	 1001.85,	0},			3,		1, "Small Restaurant (Cluckin' Bell)"},
	[83] = {	5,			{372.18,	 -133.28,	 1001.49,	0},			3,		2, "Medium Restaurant (Pizza Stacks)"},
	[84] = {	17,			{377.16,	 -192.91,	 1000.64,	0},			3,		2, "Medium Restaurant (Donut Store)"},
	[85] = {	10,			{362.88,	 -75.11,	 1001.50,	315},		3,		2, "Medium Restaurant (Burger Shot)"},
	[86] = {	4,			{460.18,	 -88.41,	 999.55,	90},		3,		2, "Medium Restaurant"},
	[87] = {	1,			{-794.98,	 489.78,	 1376.20,	0},			3,		3, "Large Restaurant (Marco's Bistro)"},
	[88] = {	7,			{315.79,	 -143.27,	 999.60,	0},			3,		3, "Large Ammunation (LS)"},
	[89] = {	1,			{285.39,	 -41.44,	 1001.51,	0},			3,		2, "Medium Ammunation w/Range"},
	[90] = {	4,			{285.71,	 -86.37,	 1001.52,	0},			3,		2, "Medium Ammunation w/Range 2"},
	[91] = {	6,			{297.05,	 -111.79,	 1001.51,	0},			3,		1, "Small Ammunation"},
	[92] = {	6,			{316.37,	 -170.02,	 999.59,	0},			3,		1, "Small Ammunation 2"},
	[93] = {	10,			{2019.02,	 1017.93,	 996.87,	90},		3,		4, "Four Dragons Casino"},
	[94] = {	1,			{2233.92,	 1714.58,	 1012.38,	180},		3,		4, "Caligula's Casino"},
	[95] = {	14,			{204.44,	 -168.58,	 1000.52,	0},			3,		1, "Small Clothing Store (DidierSach)"},
	[96] = {	15,			{207.58,	 -111.00,	 1005.13,	0},			3,		1, "Small Clothing Store (Binco)"},
	[97] = {	3,			{207.01,	 -139.91,	 1003.50,	0},			3,		2, "Medium Clothing Store (Prolap)"},
	[98] = {	5,			{227.08,	 -8.14,	 	 1002.21,	90},		3,		2, "Medium Clothing Store (Victim)"},
	[99] = {	1,			{203.79,	 -50.34,	 1001.80,	0},			3,		2, "Medium Clothing Store (Suburb)"},
	[100] = {	18,			{161.46,	 -96.72,	 1001.80,	0},			3,		3, "Large Clothing Store (Zip)"},
	[101] = {	3,			{1212.18,	 -25.93,	 1000.95,	180},		3,		1, "Small Strip Club"},
	[102] = {	3,			{965.16,	 -53.21,	 1001.12,	90},		3,		2, "Medium Strip Club"},
	[103] = {	2,			{1204.81,	 -13.60,	 1000.92,	0},			3,		2, "Medium Strip Club 2"},
	[104] = {	3,			{975.26,	 -8.64,	 	 1001.14,	90},		3,		3, "Large Strip Club"},
	[105] = {	3,			{-2636.77,	 1402.60,	 906.46,	0},			3,		3, "Large Strip Club (Jizzy's Pleasure Dome)"},
	[106] = {	3,			{-100.40,	 -24.96,	 1000.71,	0},			3,		2, "Medium Sex Store"},
	[107] = {	3,			{390.44,	 173.91,	 1008.38,	90},		5,		4, "City Hall"},
	[108] = {	3,			{-2029.61,	 -119.36,	 1035.17,	0},			5,		1, "Small DMV"},
	[109] = {	6,			{246.85,	 62.49,		 1003.64,	0},			5,		4, "LSPD HQ"},
	[110] = {	10,			{246.37,	 107.51,	 1003.21,	0},			5,		4, "SFPD HQ"},
	[111] = {	3,			{288.75,	 167.23,	 1007.17,	0},			5,		4, "LVPD HQ"},
	[112] = {	5,			{322.24,	 302.45,	 999.14,	0},			5,		1, "PD Fort Carson"},
	[113] = {	10,			{-1128.64,	 1066.33,	 1345.74,	270},		6,		4, "Zero's RC Battlefield"},
	[114] = {	14,			{-1464.86,	 1556.02,	 1052.53,	0},			6,		4, "Motorcross Arena"},
	[115] = {	15,			{-1424.42,	 928.36,	 1036.39,	350},		6,		4, "Arena"},
	[116] = {	4,			{-1435.86,	 -662.25,	 1052.46,	270},		6,		4, "Dirt Bike Track"},
	[117] = {	7,			{-1409.35,	 -255.91,	 1043.66,	250},		6,		4, "Race Track"},
	[118] = {   20,			{1725.384,   -2243.05,  39.38025,	0},			5,		3, "Airport"}, -- custom/interiors/airport.lua
	[119] = { 	3,			{288.86035, 167.37012, 1007.17188,  0},			5,		4, "LVMPD HQ"}, -- custom/interiors/lvmpd.lua
}

g_interiorTypes = {
	[1] = {"House", 1},
	[2] = {"Garage", 2},
	[3] = {"Business", 3},
	[4] = {"Rentable/Apartment", 4},
	[5] = {"Government", 5},
	[6] = {"Other", 6},
}

g_interiorSizes = {
	[1] = {"Small", 1},
	[2] = {"Medium", 2},
	[3] = {"Large", 3},
	[4] = {"Huge", 4},
}

function getInteriorType(typeID)
	if g_interiorTypes[tonumber(typeID)] then
		return g_interiorTypes[typeID][1]
	end
	return false
end