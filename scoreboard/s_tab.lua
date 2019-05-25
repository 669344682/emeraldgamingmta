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

local scoreboardDummy

addEventHandler("onResourceStart", resourceRoot, function()
	scoreboardDummy = createElement("scoreboard")
	setElementData(scoreboardDummy, "serverName", "         Emerald Gaming Roleplay ")
	setElementData(scoreboardDummy, "maxPlayers", getMaxPlayers())
	setElementData(scoreboardDummy, "allow", true)
	
	-- Uncomment to test with dummies.
	--[[
	for k = 70, 270 do
		local dummy = createElement("playerDummy")
		setElementData(dummy, "player:id", k)
		setElementData(dummy, "name", "dummy" .. tostring(k), false)
		setElementData(dummy, "ping", math.random(1, 300))
		setElementData(dummy, "color", {math.random(0, 255), math.random(0, 255), math.random(0, 255)})
	end]]
end, false)

addEventHandler("onResourceStop", resourceRoot, function() if scoreboardDummy then destroyElement(scoreboardDummy) end end, false)