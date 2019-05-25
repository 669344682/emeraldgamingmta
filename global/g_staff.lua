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

--[[

[RANK TABLE]
Player: 0
Helper: 1
Trial Administrator: 2
Administrator: 3
Lead  Administrator: 4
Manager: 5
Lead Manager: 6

]]

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

function isPlayerLeadManager(player, ignoreDuty)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end

	if not (ignoreDuty) then -- If the ignoreDuty parameter is not provided or is false, then lets return false if player is not on duty.
		if (getElementData(player, "duty:staff") == 0) then return false end
	end

	if getElementData(player, "staff:rank") >= 6 then -- Checks if the player is equal to rank level or greater than.
		return true
	else
		return false
	end
end

-- Lead Developers are considered managers scriptwise due to their rank.
function isPlayerManager(player, ignoreDuty)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end

	if not (ignoreDuty) then -- If the ignoreDuty parameter is not provided or is false, then lets return false if player is not on duty.
		if (getElementData(player, "duty:staff") == 0) then return false end
	end

	if (getElementData(player, "loggedin") == 1) then
		if getElementData(player, "staff:rank") >= 5 then -- Checks if the player is equal to rank level or greater than.
			return true
		else
			return false
		end
	end
end

function isPlayerLeadAdmin(player, ignoreDuty)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end

	if not (ignoreDuty) then -- If the ignoreDuty parameter is not provided or is false, then lets return false if player is not on duty.
		if (getElementData(player, "duty:staff") == 0) then return false end
	end

	if (getElementData(player, "loggedin") == 1) then
		if getElementData(player, "staff:rank") >= 4 then -- Checks if the player is equal to rank level or greater than.
			return true
		else
			return false
		end
	end
end

function isPlayerAdmin(player, ignoreDuty)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end

	if not (ignoreDuty) then -- If the ignoreDuty parameter is not provided or is false, then lets return false if player is not on duty.
		if (getElementData(player, "duty:staff") == 0) then return false end
	end

	if (getElementData(player, "loggedin") == 1) then
		if getElementData(player, "staff:rank") >= 3 then-- Checks if the player is equal to rank level or greater than.
			return true
		else
			return false
		end
	end
end

function isPlayerTrialAdmin(player, ignoreDuty)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end

	if not (ignoreDuty) then -- If the ignoreDuty parameter is not provided or is false, then lets return false if player is not on duty.
		if (getElementData(player, "duty:staff") == 0) then return false end
	end

	if (getElementData(player, "loggedin") == 1) then
		if getElementData(player, "staff:rank") >= 2 then -- Checks if the player is equal to rank level or greater than.
			return true
		else
			return false
		end
	end
end

function isPlayerHelper(player, ignoreDuty)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end

	if not (ignoreDuty) then -- If the ignoreDuty parameter is not provided or is false, then lets return false if player is not on duty.
		if (getElementData(player, "duty:staff") == 0) then return false end
	end

	if (getElementData(player, "loggedin") == 1) then
		if getElementData(player, "staff:rank") >= 1 then -- Checks if the player is equal to rank level or greater than.
			return true
		else
			return false
		end
	end
end

function isPlayerLeadDeveloper(player, ignoreDuty)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end

	if not (ignoreDuty) then -- If the ignoreDuty parameter is not provided or is false, then lets return false if player is not on duty.
		if (getElementData(player, "duty:developer") == 0) then return false end
	end

	if (getElementData(player, "loggedin") == 1) then
		if getElementData(player, "staff:developer") >= 3 then
			return true
		else
			return false
		end
	end
end

function isPlayerDeveloper(player, ignoreDuty)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end

	if not (ignoreDuty) then -- If the ignoreDuty parameter is not provided or is false, then lets return false if player is not on duty.
		if (getElementData(player, "duty:developer") == 0) then return false end
	end

	if (getElementData(player, "loggedin") == 1) then
		if getElementData(player, "staff:developer") >= 2 then
			return true
		else
			return false
		end
	end
end

function isPlayerTrialDeveloper(player, ignoreDuty)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end

	if not (ignoreDuty) then -- If the ignoreDuty parameter is not provided or is false, then lets return false if player is not logged in.
		if (getElementData(player, "loggedin") ~= 1) then return false end
	end

	if (getElementData(player, "loggedin") == 1) then
		if getElementData(player, "staff:developer") >= 1 then
			return true
		else
			return false
		end
	end
end

function isPlayerVehicleTeamLeader(player, ignoreDuty)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end

	if not (ignoreDuty) then -- If the ignoreDuty parameter is not provided or is false, then lets return false if player is not on duty.
		if (getElementData(player, "duty:vt") == 0) then return false end
	end

	if (getElementData(player, "loggedin") == 1) then
		if getElementData(player, "staff:vt") >= 2 then
			return true
		else
			return false
		end
	end
end

function isPlayerVehicleTeam(player, ignoreDuty)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end

	if not (ignoreDuty) then -- If the ignoreDuty parameter is not provided or is false, then lets return false if player is not on duty.
		if (getElementData(player, "duty:vt") == 0) then return false end
	end

	if (getElementData(player, "loggedin") == 1) then
		if getElementData(player, "staff:vt") >= 1 then
			return true
		else
			return false
		end
	end
end

function isPlayerMappingTeamLeader(player, ignoreDuty)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end

	if not (ignoreDuty) then -- If the ignoreDuty parameter is not provided or is false, then lets return false if player is not on duty.
		if (getElementData(player, "duty:mt") == 0) then return false end
	end

	if (getElementData(player, "loggedin") == 1) then
		if getElementData(player, "staff:mt") >= 2 then
			return true
		else
			return false
		end
	end
end

function isPlayerMappingTeam(player, ignoreDuty)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end

	if not (ignoreDuty) then -- If the ignoreDuty parameter is not provided or is false, then lets return false if player is not on duty.
		if (getElementData(player, "duty:mt") == 0) then return false end
	end

	if (getElementData(player, "loggedin") == 1) then
		if getElementData(player, "staff:mt") >= 1 then
			return true
		else
			return false
		end
	end
end

function isPlayerFactionTeamLeader(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end

	if not (ignoreDuty) then -- If the ignoreDuty parameter is not provided or is false, then lets return false if player is not on duty.
		if (getElementData(player, "duty:ft") == 0) then return false end
	end

	if (getElementData(player, "loggedin") == 1) then
		if getElementData(player, "staff:ft") >= 2 then
			return true
		else
			return false
		end
	end
end

function isPlayerFactionTeam(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end

	if (getElementData(player, "loggedin") == 1) then
		if getElementData(player, "staff:ft") >= 1 then
			return true
		else
			return false
		end
	end
end
------------------------------------------------------------------------------------------------------

-- Checks if the given player is a staff member.
function isPlayerStaff(player, ignoreDuty)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	
	if not (ignoreDuty) then -- If the ignoreDuty parameter is not provided or is false, then lets return false if player is not on duty.
		if (getElementData(player, "duty:staff") == 0) then return false end
	end

	if (getElementData(player, "loggedin") == 1) then
		if isPlayerHelper(player, true) or isPlayerDeveloper(player, true) or isPlayerVehicleTeam(player, true) or isPlayerFactionTeam(player, true) or isPlayerMappingTeam(player, true) then
			return true
		else
			return false
		end
	end
end

--[[ Gets the given player and returns their rank name/admin rank with a few optional additions according to the name.
Mode 1: Returns the title and the account name. [Example: Lead Manager Skully]
Mode 2: Returns the title, the character name and the account name. [Example: Lead Manager James Clark (Skully)]
Mode 3: Returns the title alone. 																					]]
function getStaffTitle(player, mode)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		outputDebugString("[GLOBAL] Error in export 'getStaffTitle', attempting to get title on non-element.", 3)
		return false
	end
	if not tonumber(mode) then mode = 1 end

	local playerName = ""
	if (mode == 1) then
		playerName = " " .. getElementData(player, "account:username")
	elseif (mode == 2) then
		local name = getPlayerName(player)
		playerName = " " .. name:gsub("_", " ") .. " (" .. getElementData(player, "account:username") .. ")"
	elseif (mode == 3) then
		playerName = ""
	end

	if (isPlayerHelper(player, true)) then
		local rankLevel = getElementData(player, "staff:rank") 

		if (tonumber(rankLevel) == 1) then
			return rank1 .. playerName
		elseif (tonumber(rankLevel) == 2) then
			return rank2 .. playerName
		elseif (tonumber(rankLevel) == 3) then
			return rank3 .. playerName
		elseif (tonumber(rankLevel) == 4) then
			return rank4 .. playerName
		elseif (tonumber(rankLevel) == 5) then
			return rank5 .. playerName
		else
			return rank6 .. playerName
		end

	elseif (isPlayerTrialDeveloper(player, true)) then
		local rankLevel = getElementData(player, "staff:developer")

		if (tonumber(rankLevel) == 1) then
			return rankdev1 .. playerName
		elseif (tonumber(rankLevel) == 2) then
			return rankdev2 .. playerName
		else
			return rankdev3 .. playerName
		end

	elseif (isPlayerVehicleTeam(player, true)) then
		local rankLevel = getElementData(player, "staff:vt")

		if (tonumber(rankLevel) == 1) then
			return rankveh1 .. playerName
		else
			return rankveh2 .. playerName
		end

	elseif (isPlayerFactionTeam(player, true)) then
		local rankLevel = getElementData(player, "staff:ft")

		if (tonumber(rankLevel) == 1) then
			return rankfac1 .. playerName
		else
			return rankfac2 .. playerName
		end

	elseif (exports.global:isPlayerMappingTeam(player, true)) then
		local rankLevel = getElementData(player, "staff:mt")

		if (tonumber(rankLevel) == 1) then
			return rankmap1 .. playerName
		else
			return rankmap2 .. playerName
		end

	else -- The player isn't part of any team.
		return defaultRank
	end
end

-- Returns the player staff level.
function getStaffLevel(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end

	local rankLevel = getElementData(player, "staff:rank") or 0
	return tonumber(rankLevel)
end

----------------------------------- [DUTY FUNCTIONS] --------------------------------------------

-- Checks if the specified staff member is on duty.
function isPlayerOnStaffDuty(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end

	if (isPlayerHelper(player, true)) then -- Check if the player is helper+.
		local staffDuty = getElementData(player, "duty:staff")

		if (tonumber(staffDuty) == 1) then
			return true
		else
			return false
		end
	elseif (isPlayerTrialDeveloper(player, true)) then
		local developerDuty = getElementData(player, "duty:developer")

		if (tonumber(developerDuty) == 1) then
			return true
		else
			return false
		end
	elseif (isPlayerVehicleTeam(player, true)) then
		local vehicleDuty = getElementData(player, "duty:vt")

		if (tonumber(vehicleDuty) == 1) then
			return true
		else
			return false
		end
	elseif (isPlayerFactionTeam(player)) then
		return true
		
	elseif (isPlayerMappingTeam(player, true)) then
		local mappingDuty = getElementData(player, "duty:mt")

		if (tonumber(mappingDuty) == 1) then
			return true
		else
			return false
		end	
	end
end

-- Checks if a Vehicle Team Member+ is on duty.
function isPlayerOnVTDuty(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end

	if(isPlayerVehicleTeam(player, true)) then -- Check if the player is a vehicle team member+.
		local vehicleDuty = getElementData(player, "duty:vt")

		if (tonumber(vehicleDuty) == 1) then
			return true
		else
			return false
		end
	end
end

-- Checks if a Mapping Team Member+ is on duty.
function isPlayerOnMTDuty(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end

	if(isPlayerMappingTeam(player, true)) then -- Check if the player is a mapping team member+.
		local mappingDuty = getElementData(player, "duty:mt")

		if (tonumber(mappingDuty) == 1) then
			return true
		else
			return false
		end
	end
end

-- Checks if a Trial Developer+ is on duty.
function isPlayerOnDeveloperDuty(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then return false end

	if isPlayerTrialDeveloper(player, true) then -- Check if the player is a development team member+.
		local developerDuty = getElementData(player, "duty:developer")
		return tonumber(developerDuty) == 1
	end
end

-- Gets the amount of staff members with the specified level currently online.
function getOnlineStaff(staffLevel)
	local players = getElementsByType("player") -- Get a table of all the players in the server.
	local amountOfStaff = 0

	for k, player in ipairs(players) do
		local playerStaffLevel = getElementData(player, "staff:rank")
		if (playerStaffLevel >= staffLevel) then
			amountOfStaff = amountOfStaff + 1
		end
	end
	return amountOfStaff
end