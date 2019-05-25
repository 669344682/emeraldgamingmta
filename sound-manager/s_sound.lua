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

function playSoundEffectServer(theElement, soundPath, volume, looped, minDistance, maxDistance, throttled)
	if not isElement(theElement) then exports.global:outputDebug("@playSoundEffectServer: theElement not provided or is not an element.") return false end
	if not tostring(soundPath) then exports.global:outputDebug("@playSoundEffectServer: soundPath not provided or is not a string.") return false end
	if not tonumber(volume) then volume = 1 end
	if not looped then looped = false end
	if not tonumber(minDistance) then minDistance = 5 end
	if not tonumber(maxDistance) then maxDistance = 20 end
	if not throttled then throttled = false end

	triggerClientEvent(theElement, "sound:playSoundEffect", theElement, theElement, soundPath, volume, looped, minDistance, maxDistance, throttled)
end
addEvent("sound:playSoundEffectServer", true)
addEventHandler("sound:playSoundEffectServer", root, playSoundEffectServer)

function playSoundToNearbyClients(theElement, soundPath, volume, looped, minDistance, maxDistance, throttled)
	if not isElement(theElement) then exports.global:outputDebug("@playSoundToNearbyClients: theElement provided is not an element.") return false end
	if not tostring(soundPath) then exports.global:outputDebug("@playSoundToNearbyClients: soundPath not provided or is not a string.") return false end
	if not tonumber(maxDistance) then maxDistance = 20 end
	local soundTable = {}
	local indexTable = {}
	for i, thePlayer in ipairs(getElementsByType("player")) do
		local em, ey, ez = getElementPosition(theElement)
		local emdim, emint = getElementDimension(theElement), getElementInterior(theElement)
		local dim, int = getElementDimension(thePlayer), getElementInterior(thePlayer)
		local x, y, z = getElementPosition(thePlayer)
		if (getDistanceBetweenPoints3D(em, ey, ez, x, y, z) < maxDistance) and (emdim == dim) and (emint == int) then
			local sound, index = playSoundEffectServer(thePlayer, soundPath, volume, looped, minDistance, maxDistance, throttled)
			table.insert(soundTable, sound)
			table.insert(indexTable, index)
		end
	end
	return soundTable, indexTable
end
addEvent("sound:playSoundToNearbyClients", true)
addEventHandler("sound:playSoundToNearbyClients", root, playSoundToNearbyClients)