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

-- Used to find the player by just a partial amount of their name.
function getPlayerFromPartialNameOrID(targetPlayer, thePlayer, forCommand)
	if not targetPlayer and not isElement(thePlayer) and type(thePlayer) == "string" then
		outputDebugString("[GLOBAL] @getPlayerFromPartialNameOrID: Incorrect parameters provided.", 3)
		targetPlayer = thePlayer
		thePlayer = nil
	end
	local possibleTargets = {}
	local matchPlayer = nil
	local matchNick = nil
	local matchNickAccuracy = -1
	
	if type(targetPlayer) == "string" then
		targetPlayer = string.lower(targetPlayer)
	elseif isElement(targetPlayer) and getElementType(targetPlayer) == "player" then
		if (getElementData(targetPlayer, "loggedin") == 1) then
			return targetPlayer, getPlayerName(targetPlayer):gsub("_", " ") -- Return targetPlayer and their name gsub'd.
		else
			if forCommand then outputChatBox("ERROR: That player is not logged in!", 255, 0, 0) end
			return false
		end
	end

	if thePlayer and targetPlayer == "*" then
		if (getElementData(thePlayer, "loggedin") == 1) then
			return thePlayer, getPlayerName(thePlayer):gsub("_", " ") -- Return the source player.
		else
			if forCommand then outputChatBox("ERROR: That player is not logged in!", 255, 0, 0) end
			return false
		end
	elseif type(targetPlayer) == "string" and getPlayerFromName(targetPlayer) then
		local tPlayer = getPlayerFromName(targetPlayer)
		if (getElementData(tPlayer, "loggedin") == 1) then
			return tPlayer, getPlayerName(getPlayerFromName(targetPlayer)):gsub("_", " ")
		else
			if forCommand then outputChatBox("ERROR: That player is not logged in!", 255, 0, 0) end
			return false
		end
	elseif tonumber(targetPlayer) then
		matchPlayer = nil
		for i, player in pairs(getElementsByType("player")) do
			if getElementData(player, "player:id") == tonumber(targetPlayer) then
				matchPlayer = player
				break
			end
		end
		possibleTargets = { matchPlayer }
	else -- Look for player names.
		local allPlayers = getElementsByType("player")
		for playerKey, arrayPlayer in ipairs(allPlayers) do
			if isElement(arrayPlayer) then
				local found = false
				local playerName = string.lower(getPlayerName(arrayPlayer))
				local posStart, posEnd = string.find(playerName, tostring(targetPlayer), 1, true)
				if not posStart and not posEnd then
					posStart, posEnd = string.find(playerName:gsub(" ", "_"), tostring(targetPlayer), 1, true)
				end

				if posStart and posEnd then
					if posEnd - posStart > matchNickAccuracy then
						matchNickAccuracy = posEnd - posStart
						matchNick = playerName
						matchPlayer = arrayPlayer
						possibleTargets = { arrayPlayer }
					elseif posEnd - posStart == matchNickAccuracy then
						matchNick = nil
						matchPlayer = nil
						table.insert(possibleTargets, arrayPlayer)
					end
				end
			end
		end
	end
	
	if not matchPlayer or not isElement(matchPlayer) then
		if isElement(thePlayer) then
			if #possibleTargets == 0 then
				if (forCommand) then
					outputChatBox("ERROR: That player does not exist!", 255, 0, 0)
				else
					return false
				end
			else
				if (forCommand) then
					outputChatBox("Found " .. #possibleTargets .. " players who match:", 75, 230, 10)
					for _, arrayPlayer in ipairs(possibleTargets) do
						outputChatBox("  (" .. tostring(getElementData(arrayPlayer, "player:id")) .. ") " .. getPlayerName(arrayPlayer), 75, 230, 10)
					end
				end
			end
		end
		return false
	else
		if (getElementData(matchPlayer, "loggedin") == 1) then
			return matchPlayer, getPlayerName(matchPlayer):gsub("_", " ")
		else
			if forCommand then outputChatBox("ERROR: That player is not logged in!", 255, 0, 0) end
			return false
		end
	end
end

---------------------------------------- smoothMoveCamera ----------------------------------------
local sm = {}
sm.moov = 0
sm.object1, sm.object2 = nil, nil
 
local function removeCamHandler()
	if(sm.moov == 1)then
		sm.moov = 0
	end
end

local function camRender()
	if (sm.moov == 1) then
		local x1, y1, z1 = getElementPosition(sm.object1)
		local x2, y2, z2 = getElementPosition(sm.object2)
		setCameraMatrix(x1, y1, z1, x2, y2, z2)
	end
end
addEventHandler("onClientPreRender", root, camRender)

--[[								Function Parameters
x1, y1, z1 = Starting Camera Position
x1t, y1t, z1t = Starting Camera Target
x2, y2, z2 = Ending Camera Position
x2t, y2t, z2t = Ending Camera Target
time = Time in ms the camera movement should take, otherwise speed.							]]

function smoothMoveCamera(x1, y1, z1, x1t, y1t, z1t, x2, y2, z2, x2t, y2t, z2t, time)
	if(sm.moov == 1)then return false end
	sm.object1 = createObject(1337, x1,y1, z1)
	sm.object2 = createObject(1337, x1t, y1t, z1t)
	setElementAlpha(sm.object1, 0)
	setElementAlpha(sm.object2, 0)
	setObjectScale(sm.object1, 0.01)
	setObjectScale(sm.object2, 0.01)
	moveObject(sm.object1, time, x2, y2, z2, 0, 0, 0, "InOutQuad")
	moveObject(sm.object2, time, x2t, y2t, z2t, 0, 0, 0, "InOutQuad")
	sm.moov = 1
	setTimer(removeCamHandler, time, 1)
	setTimer(destroyElement, time, 1, sm.object1)
	setTimer(destroyElement, time, 1, sm.object2)
	return true
end
addEvent("smoothMoveCamera", true)
addEventHandler("smoothMoveCamera", getRootElement(), smoothMoveCamera)

-----------------------------------------------------------------------------------------------