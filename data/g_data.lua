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

local storage = {}

function saveData(data, i) if data then storage[i] = data return true else return false end end
function loadData(i) if storage[i] then local v = storage[i]; storage[i] = nil return v else return false end end