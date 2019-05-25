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

local chatIconsHidden = {}

function sendChatIconShown()
	local px, py, pz = getElementPosition(client)

	for key, value in ipairs(getElementsByType("player")) do
		local zx, zy, zz = getElementPosition(value)
	
		-- If player is within distance and has typing icons enabled.
		if (getDistanceBetweenPoints3D(px, py, pz, zx, zy, zz) <= 20) and (chatIconsHidden[value] == nil) then
			triggerClientEvent(value, "chat:addClient", client)
		end
	end
end
addEvent("chat:getvisiblechatters", true)
addEventHandler("chat:getvisiblechatters", root, sendChatIconShown)

function sendChatIconHidden()
	local px, py, pz = getElementPosition(client)
	
	for key, value in ipairs(getElementsByType("player")) do
		local zx, zy, zz = getElementPosition(value)
		
		-- If player is within distance and has typing icons enabled.
		if (getDistanceBetweenPoints3D(px, py, pz, zx, zy, zz) <= 20) and chatIconsHidden[value] == nil then
			triggerClientEvent(value, "chat:removeClient", client)
		end
	end
end
addEvent("chat:gettinghiddenchatters", true)
addEventHandler("chat:gettinghiddenchatters", root, sendChatIconHidden)

addEvent("chat:chatterAddedCall", true)
addEventHandler("chat:chatterAddedCall", root, function() chatIconsHidden[client] = nil end)

addEvent("chat:chatterRemovedCall", true)
addEventHandler("chat:chatterRemovedCall", root, function() chatIconsHidden[client] = true end)