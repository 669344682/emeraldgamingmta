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

local mainAnimations = {
	-- Command | Maximum of one space after command name is allowed
	[1] = {"aim", "beg", "bat [1-3]", "bitchslap", "cheer [1-3]", "crack [1-4]", "carchat", "cpr", "copaway", "copcome", "copleft", "copstop", "cry", "cover", "drink", "dance [1-3]", "dive", "drag", "fixcar", "fu", "fall", "fallfront", "gsign [1-5]", "handsup", "hailtaxi", "idle", "laugh", "lay [1-2]", "lightup", "mourn", "piss", "puke", "rap [1-3]", "slapass", "scratch", "strip [1-2]", "sit [1-5]", "smoke [1-3]", "smokelean", "startrace", "shove", "shocked", "shake", "tired", "think", "wank", "wait", "win [1-2]", "what"},
	 -- Group/Block
	[2] = {"SHOP", "SHOP", "Baseball", "MISC", "OTB", "CRACK", "CAR_CHAT", "medic", "police", "POLICE", "POLICE", "POLICE", "GRAVEYARD", "ped", "BAR", "DANCING", "ped", "SMOKING", "CAR", "RIOT", "ped", "ped", "GHANDS", "ped", "MISC", "DEALER", "RAPPING", "BEACH", "SMOKING", "GRAVEYARD", "PAULNMAC", "FOOD", "LOWRIDER", "SWEET", "MISC", "STRIP", "ped", "GANGS", "LOWRIDER", "CAR", "GANGS", "ON_LOOKERS", "COP_AMBIENT", "FAT", "COP_AMBIENT", "PAULNMAC", "COP_AMBIENT", "CASINO", "RIOT"},
	-- Name
	[3] = {"ROB_Loop_Threat", "SHP_Rob_React", "Bat_IDLE", "bitchslap", "wtchrace_win", "crackidle1", "car_talkm_loop", "cpr", "coptraf_away", "CopTraf_Come", "CopTraf_Left", "CopTraf_Stop", "mrnF_loop", "duck_cower", "dnk_stndM_loop", "dnce_M_d", "EV_dive", "M_smk_drag", "Fixn_Car_loop", "RIOT_FUKU", "FLOOR_hit", "FLOOR_hit_f", "gsign5", "handsup", "Hiker_Pose", "DEALER_IDLE_01", "Laugh_01", "Lay_Bac_Loop", "M_smk_in", "mrnM_loop", "Piss_loop", "EAT_Vomit_P", "RAP_A_Loop", "sweet_ass_slap", "Scratchballs_01", "strip_D", "SEAT_idle", "smkcig_prtl", "M_smklean_loop", "flag_drop", "shake_carSH", "panic_loop", "Coplook_shake", "idle_tired", "Coplook_think", "wank_loop", "Coplook_loop", "manwind", "RIOT_ANGRY"},
}

function startAnimation(thePlayer, animationGroup, animationName, animationTime, loop, updatePosition, forced, freezeLastFrame)
	if not (animationTime) then animationTime = -1 end -- Set the animation to never stop.
	if not (loop) then loop = false end -- Make the animation loop.
	if not (updatePosition) then updatePosition = false end -- Change position of player according to animation.
	if not (forced) then forced = false end -- Set the animation to forced, not allowing the player to stop it.
	if (freezeLastFrame == nil) then freezeLastFrame = true end

	if not (isElement(thePlayer)) then
		outputDebugString("[animation-system] @startAnimation: ERROR: Attempted to start animation on a non-element.", 3)
		return false
	end

	if (getElementData(thePlayer, "loggedin") == 1) and not (getPedOccupiedVehicle(thePlayer)) and not (isElementFrozen(thePlayer)) and not (getElementData(thePlayer, "superman:state")) then
		bindKey(thePlayer, "space", "down", triggerStopAnimation)
		setPedWeaponSlot(thePlayer, 0)

		local animation = setPedAnimation(thePlayer, animationGroup, animationName, animationTime, loop, updatePosition, false, freezeLastFrame)

		if not (animation) then
			exports.global:outputDebug("@startAnimation: Failed to play animation for player " .. getPlayerName(thePlayer):gsub("_", " ") .. ".", 2)
			return false
		end
		toggleAllControls(thePlayer, false, true, false)

		if (forced) then
			exports.blackhawk:changeElementData(thePlayer, "animation:forced", true, true)
		else
			exports.blackhawk:changeElementData(thePlayer, "animation:forced", false, true)
		end

		if (animationTime >= 0) then
			setTimer(triggerStopAnimation, animationTime, 1, thePlayer)
		end
	end
end
addEvent("animation:startAnimation", true)
addEventHandler("animation:startAnimation", getRootElement(), startAnimation)

function triggerStopAnimation(thePlayer)
	if not (getElementData(thePlayer, "superman:state")) then
		triggerClientEvent(thePlayer, "animation:stopAnimation", getRootElement())
	end
end
addCommandHandler("stopanim", triggerStopAnimation)
addCommandHandler("animstop", triggerStopAnimation)

function stopAnimationServer(forced)
	if not (isElement(source)) or not (getElementType(source) == "player") then
		outputDebugString("[animation-system] @stopAnimationServer: ERROR: Attempted to stop an animation for a non-element or a non-player element.", 3)
		return false
	end

	if not (forced) then
		unbindKey(source, "space", "down", triggerStopAnimation)
		setPedAnimation(source)
	end
end
addEvent("animation:stopAnimationServer", true)
addEventHandler("animation:stopAnimationServer", getRootElement(), stopAnimationServer)

-- /anims - by Zil (02/04/18) [Player]
function animationHelp(thePlayer, commandName)
	if (getElementData(thePlayer, "loggedin") == 1) then
		outputChatBox(" ", thePlayer)

		local index = 1
		local output = ""
		for i = 1, #mainAnimations[1] do -- Go through the table and output each command, 10 commands per outputChatBox.
			output = output .. "/" .. mainAnimations[1][i] .. "  "
			index = index + 1

			if (index >= 8) then
				outputChatBox(output, thePlayer, 60, 215, 0)
				output = ""
				index = 0
			end
		end

		if (output ~= "") then -- Dump the last remaining commands out.
			outputChatBox(output, thePlayer, 60, 215, 0)
		end
		outputChatBox("For a full list of animations, please use the /animlist command.", thePlayer, 75, 230, 10)
		outputChatBox("For a list of saved animations, please use the /savedanims command.", thePlayer, 75, 230, 10)
		outputChatBox("Press the spacebar or use the command /stopanim to stop your animation.", thePlayer, 75, 230, 10)
	end
end
addCommandHandler("anims", animationHelp)
addCommandHandler("animation", animationHelp)
addCommandHandler("animhelp", animationHelp)
addEvent("animation:showAnimationHelp", true)
addEventHandler("animation:showAnimationHelp", getRootElement(), animationHelp)

function playMainAnimation(thePlayer, commandName, variation, targetPlayer)
	if (getElementData(thePlayer, "loggedin") == 1) then
		for i, animationCommandName in ipairs(mainAnimations[1]) do
			local animationCommandName = mainAnimations[1][i]:gsub("(.*)%s.*$","%1")

			if (animationCommandName == commandName) then
				local animationName
				local freezeLast = true
				local animationGroup = mainAnimations[2][i]

				if (variation) and tonumber(variation) then -- If the animation has multiple variations.
					local variation = tonumber(variation)

					-- Set the animation name depending on the variation number
					if (commandName == "bat") then
						if (variation == 1) then animationName = "Bat_IDLE"
						elseif (variation == 2) then animationName = "Bbalbat_Idle_02"; animationGroup = "CRACK"
						else animationName = "Bbalbat_Idle_01"; animationGroup = "CRACK" end

					elseif (commandName == "cheer") then
						if (variation == 1) then animationName = "PUN_HOLLER"; animationGroup = "OTB"
						elseif (variation == 2) then animationName = "wtchrace_win"; animationGroup = "OTB"
						else animationName = "RIOT_shout"; animationGroup = "RIOT" end

					elseif (commandName == "crack") then
						if (variation == 1) then animationName = "crckidle2"
						elseif (variation == 2) then animationName = "crckidle1"
						elseif (variation == 3) then animationName = "crckidle3"
						else animationName = "crckidle4" end

					elseif (commandName == "dance") then
						if (variation == 2) then animationName = "DAN_Right_A"
						elseif (variation == 3) then animationName = "DAN_Down_A"
						else animationName = "dnce_M_d" end

					elseif (commandName == "gsign") then
						if (variation == 2) then animationName = "gsign2"
						elseif (variation == 3) then animationName = "gsign3"
						elseif (variation == 4) then animationName = "gsign4"
						elseif (variation == 5) then animationName = "gsign5"
						else animationName = "gsign1" end

					elseif (commandName == "lay") then
						if (variation == 2) then animationName = "sitnwait_Loop_W"
						else animationName = "Lay_Bac_Loop" end

					elseif (commandName == "rap") then
						if (variation == 2) then animationName = "RAP_B_Loop"
						elseif (variation == 3) then animationName = "RAP_C_Loop"
						else animationName = "RAP_A_Loop" end

					elseif (commandName == "strip") then
						if (variation == 2) then animationName = "STR_Loop_C"
						else animationName = "strip_D" end

					elseif (commandName == "sit") then
						if (variation == 1) then animationName = "SEAT_idle"; animationGroup = "ped"
						elseif (variation == 2) then animationName = "FF_Sit_Look"; animationGroup = "FOOD"
						elseif (variation == 3) then animationName = "Stepsit_loop"; animationGroup = "Attractors"
						elseif (variation == 4) then animationName = "ParkSit_W_loop"; animationGroup = "BEACH"
						else animationName = "ParkSit_M_loop"; animationGroup = "BEACH" end

					elseif (commandName == "smoke") then
						if (variation == 1) then animationName = "smkcig_prtl"; animationGroup = "GANGS"
						elseif (variation == 2) then animationName = "M_smkstnd_loop"; animationGroup = "SMOKING"
						else animationName = "M_smkstnd_loop"; animationGroup = "LOWRIDER" end

					elseif (commandName == "win") then
						if (variation == 1) then animationName = "manwind"
						else animationName = "manwinb" end
					end
				else
					animationName = mainAnimations[3][i]
				end
				startAnimation(thePlayer, animationGroup, animationName, -1, true, false, false, freezeLast)
				return true
			end
		end
	end
end

local walkAnimations = {
	"WALK_armed", "WALK_civi", "WALK_csaw", "WOMAN_walksexy", "WALK_drunk", "WALK_fat", "WALK_fatold", "WALK_gang1", "WALK_gang2", "WALK_old",
	"WALK_player", "WALK_rocket", "WALK_shuffle", "Walk_Wuzi", "woman_run", "WOMAN_runbusy", "WOMAN_runfatold", "woman_runpanic", "WOMAN_runsexy", "WOMAN_walkbusy",
	"WOMAN_walkfatold", "WOMAN_walknorm", "WOMAN_walkold", "WOMAN_walkpro", "WOMAN_walksexy", "WOMAN_walkshop", "run_1armed", "run_armed", "run_civi", "run_csaw",
	"run_fat", "run_fatold", "run_gang1", "run_old", "run_player", "run_rocket", "Run_Wuzi"
}

function walkAnimation(thePlayer, commandName, variation)
	if (getElementData(thePlayer, "loggedin") == 1) then
		if not tonumber(variation) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Walkstyle ID]", thePlayer, 75, 230, 10)
			return false
		end

		if (getPedOccupiedVehicle(thePlayer)) then return false end

		variation = tonumber(variation)
		if (#walkAnimations < variation) then variation = 2 end

		startAnimation(thePlayer, "PED", walkAnimations[variation], -1, true, true)
	end
end
addCommandHandler("walk", walkAnimation)

function specialAnimation(thePlayer, commandName, targetPlayer)
	if (getElementData(thePlayer, "loggedin") == 1) then
		local animationGroup, animationName
		if (commandName == "handshake") then
			animationGroup = "GANGS"
			animationName = "prtial_hndshk_biz_01"
		elseif (commandName == "daps") then
			animationGroup = "GANGS"
			animationName = "hndshkfa"
		elseif (commandName == "kiss") then
			animationGroup = "KISSING"
			animationName = "Grlfrd_Kiss_01"
		end

		if not (targetPlayer) then
			startAnimation(thePlayer, animationGroup, animationName, -1, false, false, false, false)
			return true
		end

		local targetPlayer, targetPlayerName = exports.global:getPlayerFromPartialNameOrID(targetPlayer, thePlayer)
		if (targetPlayer) then
			if (targetPlayer == thePlayer) then
				outputChatBox("Why are you trying to " .. commandName .. " yourself?", thePlayer, 255, 0, 0)
				return false
			end

			local targetPlayerID = getElementData(targetPlayer, "player:id")
			-- Check if player already has a request with the target player already.
			local hasRequest = getElementData(thePlayer, "animation:" .. targetPlayerID .. commandName)
			if (hasRequest) then
				outputChatBox("You already have a pending " .. commandName .. " request to " .. targetPlayerName .. ".", thePlayer, 255, 0, 0)
				return false
			end

			if not (getPedOccupiedVehicle(thePlayer)) and not (getPedOccupiedVehicle(targetPlayer)) then
				local x, y, z = getElementPosition(thePlayer)
				local targetX, targetY, targetZ = getElementPosition(targetPlayer)
				
				if (getDistanceBetweenPoints3D(x, y, z, targetX, targetY, targetZ) < 1.5) then
					local thePlayerName = getPlayerName(thePlayer):gsub("_", " ")
					local thePlayerID = getElementData(thePlayer, "player:id")

					local hasRequest = getElementData(thePlayer, "animation:" .. targetPlayerID .. commandName)
					local hasPermission = getElementData(targetPlayer, "animation:" .. thePlayerID .. commandName)

					if (hasPermission == thePlayerID .. commandName) then
						setElementData(targetPlayer, "animation:" .. thePlayerID .. commandName, thePlayerID .. commandName, false)
					elseif (hasRequest == targetPlayerID .. commandName) then
						setElementData(thePlayer, "animation:" .. targetPlayerID .. commandName, targetPlayerID .. commandName, false)
						return false
					else
						outputChatBox("You have sent a " .. commandName .. " request to " .. targetPlayerName .. ".", thePlayer, 0, 255, 0)
						outputChatBox(thePlayerName .. " has requested to " .. commandName .. " you, respond with '/" .. commandName .. " " .. thePlayerID .. "'.", targetPlayer, 255, 255, 0)
						setElementData(thePlayer, "animation:" .. targetPlayerID .. commandName, targetPlayerID .. commandName, false)
						setTimer(function()
							local hasRequest = getElementData(thePlayer, "animation:" .. targetPlayerID .. commandName)
							local hasPermission = getElementData(targetPlayer, "animation:" .. thePlayerID .. commandName)

							if (hasRequest) or (hasPermission) then
								removeElementData(thePlayer, "animation:" .. targetPlayerID .. commandName)
								removeElementData(targetPlayer, "animation:" .. thePlayerID .. commandName)
								outputChatBox("Your " .. commandName .. " request to " .. targetPlayerName .. " has timed out.", thePlayer, 255, 0, 0)
							end
						end, 20000, 1)
						return false
					end
					removeElementData(thePlayer, "animation:" .. targetPlayerID .. commandName)
					removeElementData(targetPlayer, "animation:" .. thePlayerID .. commandName)
					
					startAnimation(thePlayer, animationGroup, animationName, -1, false, false, false, false)
					startAnimation(targetPlayer, animationGroup, animationName, -1, false, false, false, false)
				else
					outputChatBox("You are too far away from " .. targetPlayerName .. ".", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("kiss", specialAnimation)
addCommandHandler("daps", specialAnimation)
addCommandHandler("handshake", specialAnimation)

-- Create the command handlers, such as /aim, /beg etc. from the mainAnimations table.
function createMainCommandHandlers()
	for i, command in ipairs(mainAnimations[1]) do
		command = command:gsub("(.*)%s.*$","%1")
		addCommandHandler(command, playMainAnimation)
	end
end
addEvent("onResourceStart", true)
addEventHandler("onResourceStart", resourceRoot, createMainCommandHandlers)
