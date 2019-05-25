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

-- Used to update elementData given by client.
function hudEvent(event, value)
	if (event) and (value) then
		local thePlayerName = getPlayerName(source)
		local thePlayer = getPlayerFromName(thePlayerName)

		if (event == "var:togmgtwarn") then -- If event was togmgtwarn, we need to also update the element data.
			local theValue = tonumber(value) -- Convert value to number just in case it isn't one.
			exports.blackhawk:setElementDataEx(thePlayer, "var:togmgtwarn", theValue, true)
			return true
		end

		exports.blackhawk:setElementDataEx(thePlayer, event, value, true) -- Set the elementData received from the HUD.
	else
		outputDebugString("[hud-system] @hudEvent: Syntax error in function usage of 'hudEvent', no event or value given.", 3)
	end
end
addEvent("hud:hudEvent", true)
addEventHandler("hud:hudEvent", root, hudEvent)