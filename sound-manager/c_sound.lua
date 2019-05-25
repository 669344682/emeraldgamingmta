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

local sounds = {}

function playSoundEffect(theElement, soundPath, volume, looped, minDistance, maxDistance, throttled)
	if not tonumber(volume) then volume = 1 end
	if not looped then looped = false end
	if not tonumber(minDistance) then minDistance = 5 end
	if not tonumber(maxDistance) then maxDistance = 20 end
	if not throttled then throttled = false end
	
	local soundElement = playSound(soundPath, looped, throttled)
	if (soundElement) then
		local x, y, z = getElementPosition(theElement)
		local dim, int = getElementDimension(theElement), getElementInterior(theElement)
		attachElements(soundElement, theElement)
		setElementDimension(soundElement, dim)
		setElementInterior(soundElement, int)

		setSoundVolume(soundElement, volume)
		setSoundMinDistance(soundElement, minDistance)
		setSoundMaxDistance(soundElement, maxDistance)
		local index = tostring(soundPath) .. "/" .. tostring(theElement) .. "/" .. type(theElement)

		if (looped) then sounds[index] = soundElement end
		if (index) then
			return soundElement, index
		else
			exports.global:outputDebug("@playSoundEffect: Failed to create index for sound '" .. soundPath .. "'.", 2)
			return soundElement, false
		end
	else
		exports.global:outputDebug("@playSoundEffect: Failed to create sound element. (Sound: " .. soundPath .. ")")
	end
	return false
end
addEvent("sound:playSoundEffect", true)
addEventHandler("sound:playSoundEffect", root, playSoundEffect)

function stopSoundEffect(index)
	if (index) and sounds[index] then
		local stopped = stopSound(sounds[index])
		if not stopped then stopped = destroyElement(sounds[index]) end
		if (stopped) then
			sounds[index] = nil
		else
			exports.global:outputDebug("@stopSoundEffect: Failed to stop sound at index '" .. index .. "'.")
			return stopped
		end
	end
	exports.global:outputDebug("@stopSoundEffect: Sound index not provided or does not exist.")
	return false
end
addEvent("sound:stopSoundEffect", true)
addEventHandler("sound:stopSoundEffect", root, stopSoundEffect)