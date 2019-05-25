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

local txd, dff, col
local pickup = "models/pickups/"

local modifications = {
	{pickup, "color_green.txd", "teleporter.dff", false, 1461}, -- Board with lifeline. (DYN_LIFE_P)
	{pickup, "color_green.txd", "property_house.dff", false, 1273}, -- Green house.
	{pickup, "color_yellow.txd", "property_garage.dff", false, 1248}, -- GTA3 pickup.
	{pickup, "color_red.txd", "property_house.dff", false, 1314}, -- Multiplayer icon.
	{pickup, "color_blue.txd", "property_business.dff", false, 1272}, -- Blue house icon.
}

function replaceModels()
	for i, v in pairs(modifications) do
		if v[2] then
			txd = engineLoadTXD(v[1] .. v[2])
			engineImportTXD(txd, v[5])
		end

		if v[3] then
			dff = engineLoadDFF(v[1] .. v[3])
			engineReplaceModel(dff, v[5])
		end

		if v[4] then
			col = engineLoadCOL(v[1] .. v[4])
			engineReplaceCOL(col, v[5])
		end
	end
end
addEventHandler("onClientResourceStart", resourceRoot, replaceModels)