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

--[[ 					TABLE

dOne - Coordinates of first data, Starting camera position.
dTwo - Coordinates of second data, starting camera target.
dThree - Coordinates of third data, ending camera position.
dFour - Coordinates of fourth data, ending camera target.

Object variables
oOne = nil
oTwo = nil
oThree = nil
oFour = nil															]]

-- /fixcam - by Skully (04/09/17) [Player]
function fixMyCamera(thePlayer)
	setCameraTarget(thePlayer, thePlayer)
	outputChatBox("Camera fixed!", thePlayer, 0, 255, 0)
end
addCommandHandler("fixcam", fixMyCamera)

-- /recordcam - by Skully (04/09/17) [Lead ManagerDeveloper]
function createSmoothCamera(thePlayer)
	if exports.global:isPlayerLeadManager(thePlayer) or exports.global:isPlayerDeveloper(thePlayer) then
		local dOne = getElementData(thePlayer, "dOne")
		local dTwo = getElementData(thePlayer, "dTwo")
		local dThree = getElementData(thePlayer, "dThree")
		local dFour = getElementData(thePlayer, "dFour")
		local x, y, z = getElementPosition(thePlayer)
		local theDim = getElementDimension(thePlayer)
		local theInt = getElementInterior(thePlayer)

		if not dOne then
			outputChatBox("Camera start position set. (dOne)", thePlayer, 0, 255, 0)
			outputChatBox("X: " .. x, thePlayer, 75, 230, 10)
			outputChatBox("Y: " .. x, thePlayer, 75, 230, 10)
			outputChatBox("Z: " .. x, thePlayer, 75, 230, 10)
			outputChatBox(" ", thePlayer, 0, 0, 0)
			exports.blackhawk:setElementDataEx(thePlayer, "dOne", {x, y, z}, true)
			oOne = createObject(1866, x, y, z, 0, 0, 0)
			setElementDimension(oOne, theDim)
			setElementInterior(oOne, theInt)
			return true
		elseif not dTwo then
			outputChatBox("Camera start position set. (dTwo)", thePlayer, 0, 255, 0)
			outputChatBox("X: " .. x, thePlayer, 75, 230, 10)
			outputChatBox("Y: " .. x, thePlayer, 75, 230, 10)
			outputChatBox("Z: " .. x, thePlayer, 75, 230, 10)
			outputChatBox(" ", thePlayer, 0, 0, 0)
			exports.blackhawk:setElementDataEx(thePlayer, "dTwo", {x, y, z}, true)
			oTwo = createObject(1859, x, y, z, 0, 0, 0)
			setElementDimension(oTwo, theDim)
			setElementInterior(oTwo, theInt)
			return true
		elseif not dThree then
			outputChatBox("Camera start position set. (dThree)", thePlayer, 0, 255, 0)
			outputChatBox("X: " .. x, thePlayer, 75, 230, 10)
			outputChatBox("Y: " .. x, thePlayer, 75, 230, 10)
			outputChatBox("Z: " .. x, thePlayer, 75, 230, 10)
			outputChatBox(" ", thePlayer, 0, 0, 0)
			exports.blackhawk:setElementDataEx(thePlayer, "dThree", {x, y, z}, true)
			oThree = createObject(1862, x, y, z, 0, 0, 0)
			setElementDimension(oThree, theDim)
			setElementInterior(oThree, theInt)
			return true
		elseif not dFour then
			outputChatBox("Camera start position set. (dFour)", thePlayer, 0, 255, 0)
			outputChatBox("X: " .. x, thePlayer, 75, 230, 10)
			outputChatBox("Y: " .. x, thePlayer, 75, 230, 10)
			outputChatBox("Z: " .. x, thePlayer, 75, 230, 10)
			outputChatBox(" ", thePlayer, 0, 0, 0)
			outputChatBox("All data set, you can preview your scene with /previewcam", thePlayer, 0, 255, 0)
			exports.blackhawk:setElementDataEx(thePlayer, "dFour", {x, y, z}, true)
			oFour = createObject(1876, x, y, z, 0, 0, 0)
			setElementDimension(oFour, theDim)
			setElementInterior(oFour, theInt)
			return true
		else
			outputChatBox("All four data sets exist, use /previewcam or /delcamdata.", thePlayer, 0, 255, 0)
		end
	end
end
addCommandHandler("recordcam", createSmoothCamera)

-- /delcamdata - by Skully (04/09/17) [Lead ManagerDeveloper]
function delCameraData(thePlayer)
	if exports.global:isPlayerLeadManager(thePlayer) or exports.global:isPlayerDeveloper(thePlayer) then
		local dOne = getElementData(thePlayer, "dOne")
		local dTwo = getElementData(thePlayer, "dTwo")
		local dThree = getElementData(thePlayer, "dThree")
		local dFour = getElementData(thePlayer, "dFour")
		local deletedSomething = false

		if dOne then
			outputChatBox("dOne exists, deleting..", thePlayer, 75, 230, 10)
			removeElementData(thePlayer, "dOne")
			deletedSomething = true
			destroyElement(oOne)
		end
		if dTwo then
			outputChatBox("dTwo exists, deleting..", thePlayer, 75, 230, 10)
			removeElementData(thePlayer, "dTwo")
			deletedSomething = true
			destroyElement(oTwo)
		end
		if dThree then
			outputChatBox("dThree exists, deleting..", thePlayer, 75, 230, 10)
			removeElementData(thePlayer, "dThree")
			deletedSomething = true
			destroyElement(oThree)
		end
		if dFour then
			outputChatBox("dFour exists, deleting..", thePlayer, 75, 230, 10)
			removeElementData(thePlayer, "dFour")
			deletedSomething = true
			destroyElement(oFour)
		end

		if (deletedSomething) then
			outputChatBox("Successfully cleared all recorded data.", thePlayer, 0, 255, 0)
		else
			outputChatBox("ERROR: No data is saved to be deleted.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("delcamdata", delCameraData)

-- /previewcam [Time] (sameTarget) - by Skully (05/09/17) [Lead Manager/Developer]
function previewCamera(thePlayer, commandName, time, reset, sameTarget)
	if exports.global:isPlayerLeadManager(thePlayer) or exports.global:isPlayerDeveloper(thePlayer) then
		if not tonumber(time) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Time] [Reset (0-1)] (sameTarget)", thePlayer, 75, 230, 10)
			outputChatBox("Time must be greater than 50ms, sameTarget sets dTwo/dFour the same.", thePlayer, 75, 230, 10)
		elseif tonumber(time) <= 50 then
			outputChatBox("ERROR: Time interval must be greater than 50ms!", thePlayer, 255, 0, 0)
		else
			local dOne = getElementData(thePlayer, "dOne")
			local dTwo = getElementData(thePlayer, "dTwo")
			local dThree = getElementData(thePlayer, "dThree")
			local dFour = getElementData(thePlayer, "dFour")

			if not (dOne) or not (dTwo) or not (dThree) or not (dFour) then
				outputChatBox("ERROR: You are missing some recorded data, please /recordcam first.", thePlayer, 255, 0, 0)
				return false
			end

			if tonumber(reset) == 1 then
				reset = false
			else
				reset = true
			end

			if (sameTarget) then
				dFour = dTwo
			end
			
			local dOne = table.concat(dOne,", ")
			local dTwo = table.concat(dTwo,", ")
			local dThree = table.concat(dThree,", ")
			local dFour = table.concat(dFour,", ")

			if (reset) then -- If the player had not stated that they don't want camera to reset
				setTimer(function()
					setCameraTarget(thePlayer, thePlayer)
					outputChatBox("End of scene preview, time elapsed: " .. time .. "ms", thePlayer, 0, 255, 0)
				end, time + 100, 1)
			else
				setTimer(function()
					outputChatBox("End of scene preview, time elapsed: " .. time .. "ms", thePlayer, 0, 255, 0)
					outputChatBox("Use /fixcam to exit final view.", thePlayer, 0, 255, 0)
				end, time + 100, 1)
			end

			outputChatBox(" ", thePlayer, 255, 255, 255)
			outputChatBox("Starting scene preview..", thePlayer, 0, 255, 0)
			outputChatBox("dOne: " .. dOne, thePlayer, 255, 255, 255)
			outputChatBox("dTwo: " .. dTwo, thePlayer, 255, 255, 255)
			outputChatBox("dThree: " .. dThree, thePlayer, 255, 255, 255)
			outputChatBox("dFour: " .. dFour, thePlayer, 255, 255, 255)
			--triggerClientEvent(getRootElement(), "smoothMoveCamera", getRootElement(), dOne, dTwo, dThree, dFour, time)
			
			-- Lazy fix
			executeCommandHandler("crun", thePlayer, "exports.global:smoothMoveCamera(" .. tostring(dOne) .. ", " .. tostring(dTwo) .. ", " .. tostring(dThree) .. ", " .. tostring(dFour) .. ", " .. time .. ")")
		end
	end
end
addCommandHandler("previewcam", previewCamera)

-- /setcamdata [Data (1-4)] - by Skully (06/09/17) [Lead Manager/Developer]
function setCameraData(thePlayer, commandName, data)
	if exports.global:isPlayerLeadManager(thePlayer) or exports.global:isPlayerDeveloper(thePlayer) then
		if not tonumber(data) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Data (1-4)]", thePlayer, 75, 230, 10)
		else
			local data = tonumber(data)
			local dOne = getElementData(thePlayer, "dOne")
			local dTwo = getElementData(thePlayer, "dTwo")
			local dThree = getElementData(thePlayer, "dThree")
			local dFour = getElementData(thePlayer, "dFour")
			--

			local x, y, z = getElementPosition(thePlayer)
			local theDim = getElementDimension(thePlayer)
			local theInt = getElementInterior(thePlayer)

			if (data == 1) then
				outputChatBox("dOne has been successfully set.", thePlayer, 0, 255, 0)
				if dOne then
					local dOne = table.concat(dOne, ", ")
					outputChatBox("Old Data: " .. tostring(dOne), thePlayer, 0, 255, 0)
					destroyElement(oOne)
				end
				exports.blackhawk:setElementDataEx(thePlayer, "dOne", {x, y, z}, true)
				outputChatBox("New Data: " .. x .. ", " .. y .. ", " .. z, thePlayer, 0, 255, 0)
				oOne = createObject(1866, x, y, z, 0, 0, 0)
				setElementDimension(oOne, theDim)
				setElementInterior(oOne, theInt)
			elseif (data == 2) then
				outputChatBox("dTwo has been successfully set.", thePlayer, 0, 255, 0)
				if dTwo then
					local dTwo = table.concat(dTwo, ", ")
					outputChatBox("Old Data: " .. tostring(dTwo), thePlayer, 0, 255, 0)
					destroyElement(oTwo)
				end
				exports.blackhawk:setElementDataEx(thePlayer, "dTwo", {x, y, z}, true)
				outputChatBox("New Data: " .. x .. ", " .. y .. ", " .. z, thePlayer, 0, 255, 0)
				oTwo = createObject(1859, x, y, z, 0, 0, 0)
				setElementDimension(oTwo, theDim)
				setElementInterior(oTwo, theInt)
			elseif (data == 3) then
				outputChatBox("dThree has been successfully set.", thePlayer, 0, 255, 0)
				if dThree then
					local dThree = table.concat(dThree, ", ")
					outputChatBox("Old Data: " .. tostring(dThree), thePlayer, 0, 255, 0)
					destroyElement(oThree)
				end
				exports.blackhawk:setElementDataEx(thePlayer, "dThree", {x, y, z}, true)
				outputChatBox("New Data: " .. x .. ", " .. y .. ", " .. z, thePlayer, 0, 255, 0)
				oThree = createObject(1862, x, y, z, 0, 0, 0)
				setElementDimension(oThree, theDim)
				setElementInterior(oThree, theInt)
			elseif (data == 4) then
				outputChatBox("dFour has been successfully set.", thePlayer, 0, 255, 0)
				if dFour then
					local dFour = table.concat(dFour, ", ")
					outputChatBox("Old Data: " .. tostring(dFour), thePlayer, 0, 255, 0)
					destroyElement(oFour)
				end
				exports.blackhawk:setElementDataEx(thePlayer, "dFour", {x, y, z}, true)
				outputChatBox("New Data: " .. x .. ", " .. y .. ", " .. z, thePlayer, 0, 255, 0)
				oFour = createObject(1876, x, y, z, 0, 0, 0)
				setElementDimension(oFour, theDim)
				setElementInterior(oFour, theInt)
			else
				outputChatBox("ERROR: That data type is invalid.", thePlayer, 255, 0, 0)
				return false
			end
		end
	end
end
addCommandHandler("setcamdata", setCameraData)