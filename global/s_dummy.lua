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

Copyright of the Emerald Gaming Development Team, do not distribute - All rights reserved.

FOR MORE IN-DEPTH EXPLANATION AND INFORMATION REGARDING GLOBAL EXPORTS, CHECK THE WIKI. ]]

function createServerDummy()
	serverDummy = createElement("serverdummy")

	-- Include all data which needs to be set on startup.
	local oocState = exports.mysql:QuerySingle("SELECT `goocstate` FROM `variables`")
	if (oocState) then
		setElementData(serverDummy, "goocstate", oocState.goocstate, false)
	end
end
addEventHandler("onResourceStart", resourceRoot, createServerDummy)

function setDummyData(data, value)
	if not (data) or not (value) then
		outputDebugString("[global] @setDummyData: Data or value not provided.", 3)
		return false
	end

	setElementData(serverDummy, data, value, false)
	return true
end

function getDummyData(data)
	if not (data) then
		outputDebugString("[global] @getDummyData: Data not provided.", 3)
		return false
	end

	return getElementData(serverDummy, data)
end