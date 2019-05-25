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

local myShader
local timer
function applyCarShader()
	local carShader = getElementData(localPlayer, "settings:graphics:setting4")
	if (carShader == 1) then
		if myShader then return end

		myShader, tec = dxCreateShader("car_paint.fx")
		
		if myShader then
			local textureVol = dxCreateTexture("images/smallnoise3d.dds")
			local textureCube = dxCreateTexture("images/cube_env256.dds")
			dxSetShaderValue(myShader, "sRandomTexture", textureVol)
			dxSetShaderValue(myShader, "sReflectionTexture", textureCube)
			engineApplyShaderToWorldTexture(myShader, "vehiclegrunge256")
			engineApplyShaderToWorldTexture(myShader, "?emap*")
			
			timer = setTimer(function()
				if myShader then
					local r, g, b, a = getWaterColor()
					dxSetShaderValue (myShader, "gVehicleColor", r/255, g/255, b/255, a/255)
				end
			end, 5000, 0)
		end
	else
		if myShader then
			destroyElement(myShader)
			killTimer(timer)
			myShader = nil
		end
	end
end
addEventHandler("onClientResourceStart", resourceRoot, applyCarShader)
addEvent("shader:cars:toggle", true)
addEventHandler("shader:cars:toggle", root, applyCarShader)