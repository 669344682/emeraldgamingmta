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

local colorizePed = {0, 1, 0, 1} -- r,g,b,a index (0-1)
local specularPower = 1.4
local effectMaxDistance = 25
local isPostAura = true
local scx, scy = guiGetScreenSize()
local myRT = nil
local myShader = nil
local isOutlineEnabled = false
local wallShader = {}
local PWTimerUpdate = 110

function enableWallView(distance, isOutline)
	if tonumber(distance) then effectMaxDistance = distance end
	if isOutline and isPostAura then 
		myRT = dxCreateRenderTarget(scx, scy, true)
		myShader = dxCreateShader("fx/post_edge.fx")
		if not myRT or not myShader then 
			isOutlineEnabled = false
			return
		else
			dxSetShaderValue(myShader, "sTex0", myRT)
			dxSetShaderValue(myShader, "sRes", scx, scy)
			isOutlineEnabled = true
		end
	else
		isOutlineEnabled = false
	end
	pwEffectEnabled = true
	enableWallViewTimer(isOutlineEnabled)
end
addEvent("admin:enablewallview", true)
addEventHandler("admin:enablewallview", root, enableWallView)

function disablePedWall()
	pwEffectEnabled = false
	disablePedWallTimer()
	if isElement(myRT) then
		destroyElement(myRT)
	end
end
addEvent("admin:disablewallview", true)
addEventHandler("admin:disablewallview", root, disablePedWall)

function createWallEffectForPlayer(thisPlayer, isOutline)
    if not wallShader[thisPlayer] then
		if isOutline then 
			wallShader[thisPlayer] = dxCreateShader("fx/ped_wall_mrt.fx", 1, 0, true, "ped")
		else
			wallShader[thisPlayer] = dxCreateShader("fx/ped_wall.fx", 1, 0, true, "ped")
		end
		if not wallShader[thisPlayer] then return false
		else
			if myRT then
				dxSetShaderValue (wallShader[thisPlayer], "secondRT", myRT)
			end
			dxSetShaderValue(wallShader[thisPlayer], "sColorizePed",colorizePed)
			dxSetShaderValue(wallShader[thisPlayer], "sSpecularPower",specularPower)
			engineApplyShaderToWorldTexture (wallShader[thisPlayer], "*" , thisPlayer)
			engineRemoveShaderFromWorldTexture(wallShader[thisPlayer],"muzzle_texture*", thisPlayer)
			if not isOutline then
				if getElementAlpha(thisPlayer) == 255 then setElementAlpha(thisPlayer, 254) end
			end
		return true
		end
    end
end

function destroyShaderForPlayer(thisPlayer)
    if wallShader[thisPlayer] then
		engineRemoveShaderFromWorldTexture(wallShader[thisPlayer], "*", thisPlayer)
		destroyElement(wallShader[thisPlayer])
		wallShader[thisPlayer] = nil
	end
end

function enableWallViewTimer(isOutline)
	if PWenTimer then 
		return 
	end
	PWenTimer = setTimer(function()
		if pwEffectEnabled then 
			effectOn = true
		else 
			effectOn = false			
		end
		for index,thisPlayer in ipairs(getElementsByType("player")) do
			if isElementStreamedIn(thisPlayer) and (thisPlayer ~= localPlayer) then
				local hx,hy,hz = getElementPosition(thisPlayer)            
				local cx,cy,cz = getCameraMatrix()
				local dist = getDistanceBetweenPoints3D(cx,cy,cz,hx,hy,hz)
				local isItClear = isLineOfSightClear(cx,cy,cz, hx,hy, hz, true, false, false, true, false, true, false, thisPlayer)
				if (dist < effectMaxDistance) and not isItClear and effectOn then 
					createWallEffectForPlayer(thisPlayer, isOutline)
				end 
				if (dist > effectMaxDistance) or  isItClear or not effectOn then 
					destroyShaderForPlayer(thisPlayer) 
				end
			end
			if not isElementStreamedIn(thisPlayer) then destroyShaderForPlayer(thisPlayer) end
		end
	end, PWTimerUpdate, 0)
end

function disablePedWallTimer()
	if PWenTimer then
		for index,thisPlayer in ipairs(getElementsByType("player")) do
			destroyShaderForPlayer(thisPlayer)
		end
		killTimer(PWenTimer)
		PWenTimer = nil		
	end
end

addEventHandler("onClientPreRender", root, function()
	if not pwEffectEnabled or not isOutlineEnabled then return end
	dxSetRenderTarget(myRT, true)
	dxSetRenderTarget()
end, true, "high")

addEventHandler("onClientHUDRender", root, function()
	if not pwEffectEnabled or not isOutlineEnabled then return end
	dxDrawImage(0, 0, scx, scy, myShader)
end)