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

validSkins = {0, 1, 2, 7, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 66, 67, 68, 69, 70, 71, 72, 73, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 288, 290, 291, 292, 293, 294, 295, 296, 297, 298, 299, 300, 301, 302, 303, 304, 305, 306, 307, 308, 309, 310, 311, 312}

function isValidSkin(skinID)
	if table_find(tonumber(skinID), validSkins) then
		return true
	else
		return false
	end
end

-- Checks if a value in a table matches one that is provided.
function table_find(key, table, loopType)
	if not (key) then
		outputDebug("@table_find: No key provided.")
		return false
	end

	if not type(table) == "table" then
		outputDebug("@tabe_find: No table provided or table is not a table.")
		return false
	end

	if not (loopType) then loopType = ipairs else loopType = pairs end
	for i, value in loopType(table) do
		if value == key then
			return true
		end
	end

	return false
end

-- Returns the distance between two elements, A and B.
function getElementDistance(a, b)
	if not isElement(a) or not isElement(b) then outputDebug("@getElementDistance: One or both elements provided are not elements.", 2) return false end
	
	if (getElementDimension(a) == getElementDimension(b)) and (getElementInterior(a) == getElementInterior(b)) then
		local x, y, z = getElementPosition(a)
		return getDistanceBetweenPoints3D(x, y, z, getElementPosition(b))
	end
	return math.huge -- Return inf.
end

-- Rounds off the number given.
function math_round(number, decimals, method)
	decimals = decimals or 0
	local factor = 10 ^ decimals
	if (method == "ceil" or method == "floor") then
		return math[method](number * factor) / factor
	else
		return tonumber(("%."..decimals.."f"):format(number))
	end
end

-- Takes the given skin ID and returns whether it is male or female in numerical values.
function getSkinGender(skinID)
	if not tonumber(SkinID) then
		outputDebug("@getSkinGender: No skinID provided or skinID is not a number.")
		return false
	end
	local maleSkins = {0, 1, 2, 7, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 32, 33, 34, 35, 36, 37, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 57, 58, 59, 60, 61, 62, 66, 67, 68, 70, 71, 72, 73, 78, 79, 80, 81, 82, 83, 84, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 120, 121, 122, 123, 124, 125, 126, 127, 128, 132, 133, 134, 135, 136, 137, 142, 143, 144, 146, 147, 153, 154, 155, 156, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 170, 171, 173, 174, 175, 176, 177, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 200, 202, 203, 204, 206, 209, 210, 212, 213, 217, 220, 221, 222, 223, 227, 228, 229, 230, 234, 235, 236, 239, 240, 241, 242, 247, 248, 249, 250, 252, 253, 254, 255, 258, 259, 260, 261, 262, 264, 265, 266, 267, 268, 269, 270, 271, 272, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 288, 290, 291, 292, 293, 294, 295, 296, 297, 299, 300, 301, 302, 303, 305, 306, 307, 308, 309, 310, 311, 312}
	local femaleSkins = {9, 10, 11, 12, 13, 31, 38, 39, 40, 41, 53, 54, 55, 56, 63, 64, 69, 75, 76, 77, 85, 87, 88, 89, 90, 91, 92, 93, 129, 130, 131, 138, 139, 140, 141, 145, 148, 150, 151, 152, 157, 169, 172, 178, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 201, 205, 207, 211, 214, 215, 216, 218, 219, 224, 225, 226, 231, 232, 233, 237, 238, 243, 244, 245, 246, 251, 256, 257, 263, 298, 304}

	if table_find(skinID, maleSkins) then
		return 1
	elseif table_find(skinID, femaleSkins) then
		return 2
	else
		outputDebug("@getSkinGender: skinID is not a male or female skin!")
		return false
	end
end

-- Takes the given language as a numerical value and returns the language name.
function getLanguageName(languageID)
	if not tonumber(languageID) then
		outputDebug("@getLanguageName: LanguageID provided is not a number.")
		return false
	end

	local languageTable = {
		[1] = "English",
		[2] = "Irish",
		[3] = "Spanish", 
		[4] = "German",
		[5] = "French",
	}

	local langName = languageTable[languageID]

	if not tostring(langName) then
		outputDebug("@getLanguageName: Language ID " .. tostring(languageID) .. " is not a valid ID.")
		return "None"
	end

	return langName
end

-- Returns the current time as a table. Check the wiki for more information regarding this function.
function getCurrentTime(asAlphanumerical)
	local tableToReturn = {}
	local timeNow = getRealTime()
	local parsedHour = timeNow.hour
	local parsedMinute = timeNow.minute
	local parsedSecond = timeNow.second
	local parsedDay = timeNow.monthday
	local parsedMonth = timeNow.month + 1
	local parsedYear = timeNow.year + 1900

	if (parsedHour < 10) then parsedHour = "0" .. parsedHour end
	if (parsedMinute < 10) then parsedMinute = "0" .. parsedMinute end
	if (parsedSecond < 10) then parsedSecond = "0" .. parsedSecond end
	if (parsedDay < 10) then parsedDay = "0" .. parsedDay end

	if (asAlphanumerical) then
		-- Parse the date.
		if (parsedDay == 1) or (parsedDay == 21) or (parsedDay == 31) then
			parsedDay = parsedDay .. "st"
		elseif (parsedDay == 2) or (parsedDay == 22) then
			parsedDay = parsedDay .. "nd"
		elseif (parsedDay == 3) or (parsedDay == 23) then
			parsedDay = parsedDay .. "rd"
		else
			parsedDay = parsedDay .. "th"
		end

		-- Parse the month.
		if parsedMonth == 1 then parsedMonth = "January"
			elseif parsedMonth == 2 then parsedMonth = "February"
			elseif parsedMonth == 3 then parsedMonth = "March"
			elseif parsedMonth == 4 then parsedMonth = "April"
			elseif parsedMonth == 5 then parsedMonth = "May"
			elseif parsedMonth == 6 then parsedMonth = "June"
			elseif parsedMonth == 7 then parsedMonth = "July"
			elseif parsedMonth == 8 then parsedMonth = "August"
			elseif parsedMonth == 9 then parsedMonth = "September"
			elseif parsedMonth == 10 then parsedMonth = "October"
			elseif parsedMonth == 11 then parsedMonth = "November"
			elseif parsedMonth == 12 then parsedMonth = "December"
			else parsedMonth = "Unknown"
		end

		tableToReturn = { -- hh,mm,ss,dd,mm,yyyy
			[1] = parsedHour .. ":" .. parsedMinute .. ":" .. parsedSecond,
			[2] = parsedDay .. " of " .. parsedMonth .. ", " .. parsedYear
		}
	else
		if (parsedMonth < 10) then parsedMonth = "0" .. parsedMonth end -- We parse the month down here because alphanumerical requires number checks of it.

		tableToReturn = {
			[1] = parsedHour .. ":" .. parsedMinute .. ":" .. parsedSecond,
			[2] = parsedDay .. "/" .. parsedMonth .. "/" .. parsedYear,
			[3] = parsedHour .. "," .. parsedMinute .. "," .. parsedSecond .. "," .. parsedDay .. "," .. parsedMonth .. "," .. parsedYear
		}
	end

	return tableToReturn
end

-- Takes the given table containing time (preferably from SQL) and returns the time as a table, check the wiki for more information regarding this function. 
function convertTime(timeTable, asAlphanumericalDate)
	-- timeTable should be in the format of: hh,mm,ss,dd,mm,yyyy
	local time = split(timeTable, ",")
	local tableToReturn

	if (asAlphanumericalDate) then
		time[4] = tonumber(time[4])
		time[5] = tonumber(time[5])

		-- Parse the date.
		if (time[4] == 1) or (time[4] == 21) or (time[4] == 31) then
			time[4] = time[4] .. "st"
		elseif (time[4] == 2) or (time[4] == 22) then
			time[4] = time[4] .. "nd"
		elseif (time[4] == 3) or (time[4] == 23) then
			time[4] = time[4] .. "rd"
		else
			time[4] = time[4] .. "th"
		end

		-- Parse the month.
		if time[5] == 1 then time[5] = "January"
			elseif time[5] == 2 then time[5] = "February"
			elseif time[5] == 3 then time[5] = "March"
			elseif time[5] == 4 then time[5] = "April"
			elseif time[5] == 5 then time[5] = "May"
			elseif time[5] == 6 then time[5] = "June"
			elseif time[5] == 7 then time[5] = "July"
			elseif time[5] == 8 then time[5] = "August"
			elseif time[5] == 9 then time[5] = "September"
			elseif time[5] == 10 then time[5] = "October"
			elseif time[5] == 11 then time[5] = "November"
			elseif time[5] == 12 then time[5] = "December"
			else time[5] = "Unknown"
		end

		tableToReturn = {
			[1] = time[1] .. ":" .. time[2] .. ":" .. time[3],
			[2] = time[4] .. " of " .. time[5] .. ", " .. time[6]
		}

	else
		tableToReturn = {
			[1] = time[1] .. ":" .. time[2] .. ":" .. time[3],
			[2] = time[4] .. "/" .. time[5] .. "/" .. time[6]
		}

	end

	return tableToReturn
end

-- Takes the given money amount and formats commas accordingly.
function formatNumber(amount)
	local left, num, right = string.match(tostring(amount), '^([^%d]*%d)(%d*)(.-)$')
	return left .. (num:reverse():gsub('(%d%d%d)','%1,'):reverse()) .. right
end

-- Takes the given date of birth as a string in the format of "dd,mm,yyyy" and returns it's respective age.
function dobToAge(dobString)
	if (type(dobString) ~= "string") then
		outputDebug("@dobToAge: Given date of birth is not a string.")
		return false
	end

	local table = split(dobString, ",")

	local day = tonumber(table[1])
	local month = tonumber(table[2])
	local year = tonumber(table[3])

	if not (day) or not (month) or not (year) then return false end -- If the day, month or year could not be turned into a number, then DD/MM/YYYY format was given wrong.

	local time = getRealTime();
	time.year = time.year + 1900
	time.month = time.month + 1
	
	year = time.year - year
	month = time.month - month
	
	if month < 0 then 
		year = year - 1 
	elseif month == 0 then
		if time.monthday < day then
			year = year - 1
		end
	end
	
	return year
end

-- Takes the given account ID and returns the respective account ID's player.
function getPlayerFromAccountID(accountID)
	if not tonumber(accountID) then
		outputDebug("@getPlayerFromAccountID: accountID not provided or is not a numerical value.")
		return false
	end

	local allPlayers = getElementsByType("player")
	for i, thePlayer in ipairs(allPlayers) do
		local playerID = getElementData(thePlayer, "account:id")
		if tonumber(playerID) == accountID then
			return thePlayer
		end
	end

	return false
end

-- Returns a table containing all elements that are within the specified distance of the given element and of the type provided.
function getNearbyElements(theElement, type, distance)
	local x, y, z = getElementPosition(theElement)
	local nearbyElements = {}
	
	if getElementType(theElement) == "player" and (getElementData(theElement, "loggedin") ~= 1) then return nearbyElements end
	
	for i, nearbyElement in ipairs(getElementsByType(type)) do
		if isElement(nearbyElement) and getDistanceBetweenPoints3D(x, y, z, getElementPosition(nearbyElement)) < (distance or 20) then
			if (getElementDimension(theElement) == getElementDimension(nearbyElement)) and (getElementInterior(theElement) == getElementInterior(nearbyElement)) then
				table.insert(nearbyElements, nearbyElement)
			end
		end
	end
	return nearbyElements
end

-- Takes the given player and returns the closest provided element type.
function getNearestElement(thePlayer, type, distance)
	if not tostring(type) then outputDebug("@getNearestVehicle: type provided is invalid, expected string.") return false end
	if not tonumber(distance) then distance = 10 end
	local tempTable = {}
	local lastMinDis = distance - 0.0001
	local nearestElement = false
	local px, py, pz = getElementPosition(thePlayer)
	local pdim, pint = getElementDimension(thePlayer), getElementInterior(thePlayer)

	for _, v in pairs(getElementsByType(type)) do
		local vint, vdim = getElementInterior(v), getElementDimension(v)
		if (vint == pint) and (vdim == pdim) then
			local vx, vy, vz = getElementPosition(v)
			local dis = getDistanceBetweenPoints3D(px, py, pz, vx, vy, vz)
			if dis < distance then
				if dis < lastMinDis then 
					lastMinDis = dis
					nearestElement = v
				end
			end
		end
	end
	return nearestElement
end

-- Takes two elements and a distance value, then checks if they are within that provided distance.
function areElementsWithinDistance(theElement, targetElement, distance)
	if not isElement(theElement) or not isElement(targetElement) then outputDebug("@areElementsWithinDistance: theElement or targetElement are not elements.") return false end
	if not tonumber(distance) then distance = 20; outputDebug("@areElementsWithinDistance: Distance not provided, defaulting to 20.", 2) end

	local x, y, z = getElementPosition(theElement)

	-- If elements are within the given distance.
	if getDistanceBetweenPoints3D(x, y, z, getElementPosition(targetElement)) < (distance) then
		-- If elements are in the same dimension and interior.
		if (getElementDimension(theElement) == getElementDimension(targetElement)) and (getElementInterior(theElement) == getElementInterior(targetElement)) then
			return true
		end
	end
	return false
end