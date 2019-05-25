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

DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH
DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH

									MAKING ANY CHANGES TO THIS FILE CAN RESULT IN UNEXPECTED RESULTS.

DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH
DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH | DO NOT TOUCH						]]

local cachedReports = {}

function saveReports(reportsTable)
	if reportsTable and type(reportsTable) == "table" then
		cachedReports = reportsTable
		outputDebugString("[DATA] report-system has stopped, storing " .. #reportsTable .. " reports.")
		return true
	else
		outputDebugString("[DATA] DEBUG: report-system has stopped, no reports to save.")
		return false
	end
end

function loadReports(reportsTable)
	if cachedReports and type(cachedReports) == "table" then
		outputDebugString("[DATA] report-system has started, restoring " .. #cachedReports .. " reports.")
		return cachedReports
	else
		outputDebugString("[DATA] DEBUG: report-system has started, no reports to restore.")
		return false
	end
end