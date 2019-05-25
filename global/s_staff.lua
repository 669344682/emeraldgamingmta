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

defaultRank = "Player"
rank1 = "Helper"
rank2 = "Trial Administrator"
rank3 = "Administrator"
rank4 = "Lead Administrator"
rank5 = "Manager"
rank6 = "Lead Manager"

rankdev1 = "Trial Developer"
rankdev2 = "Developer"
rankdev3 = "Lead Developer"

rankfac1 = "FT Member"
rankfac2 = "FT Leader"

rankveh1 = "VT Member"
rankveh2 = "VT Leader"

rankmap1 = "MT Member"
rankmap2 = "MT Leader"

-- Gets the number given and converts it to its equivalent rank name.
function numberToRankName(number)
	if not tonumber(number) or not (number) then
		outputDebugString("[GLOBAL] Error whilst converting numberToRankName, number given is not a number!", 3)
		return false
	end
	
	if (number == 1) then
		return rank1
	elseif (number == 2) then
		return rank2
	elseif (number == 3) then
		return rank3
	elseif (number == 4) then
		return rank4
	elseif (number == 5) then
		return rank5
	elseif (number == 6) then
		return rank6
	else
		return defaultRank
	end
end

---------------------------- [ elementData Titles ] ----------------------------

local blackhawk = exports.blackhawk
function setPlayerTitles(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		outputDebugString("[GLOBAL] Error with export 'setPlayerTitles', player given is not an element.", 3)
		return false
	end

	local defaultTitle = getStaffTitle(player, 3)

	-- Set all titles to a default value.
	blackhawk:setElementDataEx(player, "title:staff", defaultTitle, true)
	blackhawk:setElementDataEx(player, "title:admin", defaultRank, true)
	blackhawk:setElementDataEx(player, "title:developer", defaultRank, true)
	blackhawk:setElementDataEx(player, "title:vt", defaultRank, true)
	blackhawk:setElementDataEx(player, "title:mt", defaultRank, true)
	blackhawk:setElementDataEx(player, "title:ft", defaultRank, true)

	-- Helper/Admin
	if (exports.global:isPlayerHelper(player, true)) then
		local rankLevel = getElementData(player, "staff:rank")

		if (tonumber(rankLevel) == 6) then
			blackhawk:setElementDataEx(player, "title:admin", rank6, true)
		elseif (tonumber(rankLevel) == 5) then
			blackhawk:setElementDataEx(player, "title:admin", rank5, true)
		elseif (tonumber(rankLevel) == 4) then
			blackhawk:setElementDataEx(player, "title:admin", rank4, true)
		elseif (tonumber(rankLevel) == 3) then
			blackhawk:setElementDataEx(player, "title:admin", rank3, true)
		elseif (tonumber(rankLevel) == 2) then
			blackhawk:setElementDataEx(player, "title:admin", rank2, true)
		else
			blackhawk:setElementDataEx(player, "title:admin", rank1, true)
		end
	end
	-- Developer
	if (exports.global:isPlayerTrialDeveloper(player, true)) then
		local rankLevel = getElementData(player, "staff:developer")

		if (tonumber(rankLevel) == 3) then
			blackhawk:setElementDataEx(player, "title:developer", rankdev3, true)
		elseif (tonumber(rankLevel) == 2) then
			blackhawk:setElementDataEx(player, "title:developer", rankdev2, true)
		else
			blackhawk:setElementDataEx(player, "title:developer", rankdev1, true)
		end
	end

	-- VT
	if (exports.global:isPlayerVehicleTeam(player, true)) then
		local rankLevel = getElementData(player, "staff:vt")

		if (tonumber(rankLevel) == 2) then
			blackhawk:setElementDataEx(player, "title:vt", rankveh2, true)
		else
			blackhawk:setElementDataEx(player, "title:vt", rankveh1, true)
		end
	end

	-- FT
	if (exports.global:isPlayerFactionTeam(player, true)) then
		local rankLevel = getElementData(player, "staff:ft")

		if (tonumber(rankLevel) == 2) then
			blackhawk:setElementDataEx(player, "title:ft", rankfac2, true)
		else
			blackhawk:setElementDataEx(player, "title:ft", rankfac1, true)
		end
	end

	-- MT
	if (exports.global:isPlayerMappingTeam(player, true)) then
		local rankLevel = getElementData(player, "staff:mt")

		if (tonumber(rankLevel) == 2) then
			blackhawk:setElementDataEx(player, "title:mt", rankmap2, true)
		else
			blackhawk:setElementDataEx(player, "title:mt", rankmap1, true)
		end
	end

	return true
end