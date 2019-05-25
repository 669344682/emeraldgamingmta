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

function SetEldClient(theElement, index, newvalue, sync)
	local sync2 = false
	local nosyncatall = true
	if (sync == 1) then
		sync2 = false
		nosyncatall = false
		setElementData(theElement, index, newvalue)
	elseif (sync == 2) then
		sync2 = true
		nosyncatall = false
	else
		return setElementData(theElement, index, newvalue)
	end
	return triggerServerEvent("blackhawk:changeEld", theElement, index, newvalue, sync2, nosyncatall)
end

function update_updateElementData(theElement, theParameter, theValue)
	if (theElement) and (theParameter) then
		if (theValue == nil) then theValue = false end
		setElementData(theElement, theParameter, theValue, false)
	end
end
addEvent("blackhawk:updateElementData", true)
addEventHandler("blackhawk:updateElementData", root, update_updateElementData)