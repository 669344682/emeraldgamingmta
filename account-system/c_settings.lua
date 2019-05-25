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

function implementSettings()
	-- General Settings
	local typingIcon = getElementData(localPlayer, "settings:general:setting1") == 1
	triggerEvent("chat:updateIconVisibility", localPlayer, localPlayer, typingIcon)

	-- Account Settings

	-- Notification Settings

	-- Graphic Settings
		-- [Setting 1 - Motion Blur]
		local motionBlur = getElementData(localPlayer, "settings:graphics:setting1")
		if (tonumber(motionBlur) == 0) then setBlurLevel(0)
		else setBlurLevel(36) end

		-- [Setting 2 - Road Shader]
		triggerEvent("shader:roadshine:toggle", localPlayer)

		-- [Setting 3 - HDR Shader]
		triggerEvent("shader:hdr:toggle", localPlayer)

		-- [Setting 4 - Car Shader]
		triggerEvent("shader:cars:toggle", localPlayer)

		-- [Setting 5 - Sky Shader]
		triggerEvent("shader:sky:toggle", localPlayer)

		-- [Setting 6 - Water Shader]
		triggerEvent("shader:water:toggle", localPlayer)

end
addEvent("account:c_implementSettings", true)
addEventHandler("account:c_implementSettings", root, implementSettings)