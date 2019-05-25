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

emGUI = exports.emGUI

local tabsFont_17 = emGUI:dxCreateNewFont(":emGUI/fonts/tabsFont.ttf", 17)
local soundElement = nil
local soundElementsOutside = {}
local streams = {[0] = {"Radio Off", ""},}
local radio = 0

-- Optimization.
function getStreams() return streams end

function saveRadio(station)
	if getElementData(localPlayer, "settings:general:setting2") == 0 then cancelEvent() return false end
	if exports.scoreboard:isVisible() then cancelEvent() return end
	if (station == 0) then return end

	local theVehicle = getPedOccupiedVehicle(localPlayer)
	if (theVehicle) then
		--if not getVehicleEngineState(theVehicle) then cancelEvent() return end // Disabled. (0000076: [SUGGESTION] Radio.)
		if (getVehicleOccupant(theVehicle) == localPlayer) or (getVehicleOccupant(theVehicle, 1) == localPlayer) then
			if (getVehicleType(theVehicle) ~= "BMX") and (getVehicleType(theVehicle) ~= "Bike") and (getVehicleType(theVehicle) ~= "Quad") then
				local tempVeh = getElementData(theVehicle, "vehicle:id") or 0
				if (tempVeh == 0) then return end
				if (station == 12) then
					if (radio == 0) then radio = #streams + 1 end
					if (streams[radio - 1]) then radio = radio - 1 else radio = 0 end
				elseif (station == 1) then
					if (streams[radio + 1]) then radio = radio + 1 else radio = 0 end
				end
				triggerServerEvent("radio:vehicle:sync", localPlayer, radio)
			end
		end
		cancelEvent()
	end
end
addEventHandler("onClientPlayerRadioSwitch", localPlayer, saveRadio)

addEventHandler("onClientPlayerVehicleEnter", localPlayer, function(theVehicle)
	if getElementData(localPlayer, "settings:general:setting2") == 0 then return false end
	endRadioStream()
	showRadioGUI()
	radio = getElementData(theVehicle, "vehicle:radio") or 0
	updateStreamVolume(theVehicle)
end)

function endRadioStream()
	removeEventHandler("onClientPlayerRadioSwitch", localPlayer, saveRadio)
	setRadioChannel(0)
	addEventHandler("onClientPlayerRadioSwitch", localPlayer, saveRadio)
end

addEventHandler("onClientElementDataChange", root, function(d)
	if (getElementType(source) == "vehicle") and (d == "vehicle:radio") then
		local newStation =  getElementData(source, "vehicle:radio")  or 0
		if (isElementStreamedIn (source)) then
			if (newStation ~= 0) then
				if isElement(soundElementsOutside[source]) then stopSound(soundElementsOutside[source]) end

				local x, y, z = getElementPosition(source)
				local newSoundElement = playSound3D(streams[newStation][2], x, y, z, true)
				soundElementsOutside[source] = newSoundElement
				updateStreamVolume(source)
				setElementDimension(newSoundElement, getElementDimension(source))
				setElementDimension(newSoundElement, getElementDimension(source))
			else
				if (soundElementsOutside[source]) then
					stopSound(soundElementsOutside[source])
					soundElementsOutside[source] = nil
				end
			end
		end
	elseif (getElementType(source) == "vehicle") and (d == "vehicle:windows") then
		if (isElementStreamedIn (source)) then
			if (soundElementsOutside[source]) then
				updateStreamVolume(source)
			end
		end
	elseif (getElementType(source) == "vehicle") and (d == "vehicle:radio:volume") then
		if (isElementStreamedIn(source)) then if (soundElementsOutside[source]) then updateStreamVolume(source) end end
	end
end)

addEventHandler("onClientPreRender", root, function()
	if (soundElementsOutside ~= nil) then
		for element, sound in pairs(soundElementsOutside) do
			if (isElement(sound) and isElement(element)) then
				local x, y, z = getElementPosition(element)
				setElementPosition(sound, x, y, z)
				setElementInterior(sound, getElementInterior(element))
				getElementDimension(sound, getElementDimension(element))
			end
		end
	end
end)

addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), function()
	local vehicles = getElementsByType("vehicle")
	for _, theVehicle in ipairs(vehicles) do
		if (isElementStreamedIn(theVehicle)) then createSoundElement(theVehicle) end
	end
end)

function createSoundElement(theVehicle)
	if getElementData(localPlayer, "settings:general:setting2") == 0 then return false end

	if getElementType(theVehicle) == "vehicle" then
		local radioStation = getElementData(theVehicle, "vehicle:radio") or 0
		if radioStation ~= 0 and streams[radioStation] then
			if (soundElementsOutside[theVehicle]) then stopSound(soundElementsOutside[theVehicle]) end
			
			local x, y, z = getElementPosition(theVehicle)
			local newSoundElement = playSound3D(streams[radioStation][2], x, y, z, true)
			soundElementsOutside[theVehicle] = newSoundElement
			setElementDimension(newSoundElement, getElementDimension(theVehicle))
			setElementDimension(newSoundElement, getElementDimension(theVehicle))
			updateStreamVolume(theVehicle)
		end
	end
end

function updateStreamVolume(theVehicle)
	local windowState = getElementData(theVehicle, "vehicle:windows") or 0
	local volumeLevel = getElementData(theVehicle, "vehicle:radio:volume") or 50

	if getElementData(localPlayer, "settings:general:setting2") == 0 then volumeLevel = 0 else volumeLevel = volumeLevel / 100 end
	if isElement(soundElementsOutside[theVehicle]) then
		if (getPedOccupiedVehicle(localPlayer) == theVehicle) then -- Player's inside vehicle.
			setSoundMinDistance(soundElementsOutside[theVehicle], 25)
			setSoundMaxDistance(soundElementsOutside[theVehicle], 70)
			setSoundVolume(soundElementsOutside[theVehicle], 1 * volumeLevel)
		elseif (windowState == 1) then -- Outside vehicle with an open window.
			setSoundMinDistance(soundElementsOutside[theVehicle], 25)
			setSoundMaxDistance(soundElementsOutside[theVehicle], 70)
			setSoundVolume(soundElementsOutside[theVehicle], 0.1 * volumeLevel)
		else -- Outside vehicle with a closed window.
			setSoundMinDistance(soundElementsOutside[theVehicle], 3)
			setSoundMaxDistance(soundElementsOutside[theVehicle], 10)
			setSoundVolume(soundElementsOutside[theVehicle], 0.05 * volumeLevel)
		end
	end
end

function closeOnEvent(theVehicle)
	if not (theVehicle) then theVehicle = getPedOccupiedVehicle(localPlayer) end

	if theVehicle then
		endRadioStream()
		if emGUI:dxIsWindowVisible(radioInfoGUI) then
			emGUI:dxCloseWindow(radioInfoGUI)
			removeEventHandler("onClientRender", root, updateRadioInformation)
		end

		radio = getElementData(theVehicle, "vehicle:radio") or 0
		updateStreamVolume(theVehicle)
	end
end
addEventHandler("onClientPlayerVehicleExit", localPlayer, closeOnEvent)
addEventHandler("onClientPlayerWasted", localPlayer, closeOnEvent)

addEventHandler("onClientElementStreamIn", root, function() createSoundElement(source) end)
addEventHandler("onClientElementStreamOut", root, function()
	if getElementType(source) == "vehicle" then
		if (soundElementsOutside[source]) then
			stopSound(soundElementsOutside[source])
			soundElementsOutside[source] = nil
		end
	end
end)

function stopVehicleSounds()
	if isElement(source) and getElementType(source) == "vehicle" then
		if (soundElementsOutside[source]) then
			stopSound(soundElementsOutside[source])
			soundElementsOutside[source] = nil
		end
	end
end
addEvent("radio:stopVehicleSounds", true)
addEventHandler("radio:stopVehicleSounds", root, stopVehicleSounds)

--------------------------------------[Radio GUI]--------------------------------------

function showRadioGUI()
	local theVehicle = getPedOccupiedVehicle(localPlayer)
	if not theVehicle or (getElementData(localPlayer, "settings:general:setting2") == 0) then return end
	local radioID = getElementData(theVehicle, "vehicle:radio") or 0
	local tempVeh = getElementData(theVehicle, "vehicle:id") or 0

	if (streams[radioID]) and not (tempVeh == 0) and getVehicleType(theVehicle) ~= "BMX" and getVehicleType(theVehicle) ~= "Bike" and getVehicleType(theVehicle) ~= "Quad" then
		local songText = getMetaInfo()

		if emGUI:dxIsWindowVisible(radioInfoGUI) then
			emGUI:dxCloseWindow(radioInfoGUI)
			removeEventHandler("onClientRender", root, updateRadioInformation)
		end
		
		radioInfoGUI = emGUI:dxCreateWindow(0.02, 0.89, 0.20, 0.09, " ", true, true, true, true, _, 2, _, _, _, tocolor(0, 0, 0, 150))

		radioStationName = emGUI:dxCreateLabel(0.03, 0.12, 0.92, 0.27, "#" .. radioID .. " - " .. streams[radioID][1], true, radioInfoGUI)
		emGUI:dxSetFont(radioStationName, tabsFont_17)
		songMetaInfo = emGUI:dxCreateLabel(0.03, 0.47, 0.92, 0.15, songText, true, radioInfoGUI)
		volumeBar = emGUI:dxCreateProgressBar(0.03, 0.7, 0.7, 0.16, true, radioInfoGUI)
		emGUI:dxProgressBarSetUpDownDistance(volumeBar, 1, true)
		emGUI:dxProgressBarSetLeftRightDistance(volumeBar, 0, true)
		emGUI:dxSetFont(songMetaInfo, "default-bold")

		addEventHandler("onClientRender", root, updateRadioInformation)
		updateVolumeLevel()
	end
end
addEventHandler("onClientResourceStart", resourceRoot, function()
setTimer(function()
	showRadioGUI()
	end, 8000, 1)
end)

function getMetaInfo()
	local returnString = "Listening to: No information provided."
	local theVehicle = getPedOccupiedVehicle(localPlayer)
	if not (theVehicle) then return returnString end
	
	local sound = soundElementsOutside[theVehicle]
	if sound and isElement(sound) and getSoundMetaTags(sound) then
		local metaInfo = getSoundMetaTags(sound)["stream_title"]
		if not metaInfo or not (type(metaInfo) == "string") or (dxGetTextWidth(metaInfo, 1, "default-bold") >= 345) then
			metaInfo = getSoundMetaTags(sound)["stream_name"]
		end

		if not metaInfo or not (type(metaInfo) == "string") then
			return returnString
		else
			return "Listening to: " .. metaInfo
		end
	else
		return returnString
	end
end

function updateVolumeLevel()
	if not emGUI:dxIsWindowVisible(radioInfoGUI) then return end
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if not vehicle then return end
	local volume = getElementData(vehicle, "vehicle:radio:volume") or 50
	if (volume) then
		emGUI:dxProgressBarSetProgress(volumeBar, volume)
	end
end
addEvent("radio:gui:updateVolumeLevel", true)
addEventHandler("radio:gui:updateVolumeLevel", root, updateVolumeLevel)

function updateRadioInformation()
	if not emGUI:dxIsWindowVisible(radioInfoGUI) then
		removeEventHandler("onClientRender", root, updateRadioInformation)
		return false
	end
	local theVehicle = getPedOccupiedVehicle(localPlayer)
	if (theVehicle) then
		local radioID = getElementData(theVehicle, "vehicle:radio") or 0
		emGUI:dxSetText(radioStationName, "#" .. radioID .. " - " .. streams[radioID][1])
		
		if (radioID) == 0 then emGUI:dxSetText(songMetaInfo, "Turn on the radio for song information.") return end
		local songText = getMetaInfo()
		emGUI:dxSetText(songMetaInfo, songText)
	end
end

------------------------------------------------------------------------------------------

--[[

NOTE FOR DEVELOPERS:
	There is a known issue with radio stations duplicating when using mouse scroll wheel, this
	was never fixed, if you happen to resolve it please open a PR on the GitHub Repo. (: - Skully
]]

function updateCarRadio()
	local state = getElementData(localPlayer, "settings:general:setting2")
	if (state == 0) then
		setRadioChannel(0)

		for _, value in pairs(soundElementsOutside) do stopSound(value) end
		soundElementsOutside = {}
	else
		-- Create all radio sounds.
		local allVehicles = getElementsByType("vehicle")
		for _, theVehicle in ipairs(allVehicles) do
			if (isElementStreamedIn(theVehicle)) then createSoundElement(theVehicle) end
		end
	end
end
addEvent("accounts:settings:updateCarRadio", false)
addEventHandler("accounts:settings:updateCarRadio", root, updateCarRadio)

function getStationsFromServer(streamsFromServer)
	if streamsFromServer and #streamsFromServer > 0 then streams = streamsFromServer end
end
addEvent("radio:getStationsFromServer", true)
addEventHandler("radio:getStationsFromServer", root, getStationsFromServer)

function requestStations() triggerServerEvent("radio:requestRadioStations", localPlayer) end
function resourceStart()
	setTimer(requestStations, 5000, 1)
	setTimer(requestStations, 1200000, 0)
end
addEventHandler("onClientResourceStart", resourceRoot, resourceStart)