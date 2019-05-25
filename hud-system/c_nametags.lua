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

local font = dxCreateFont(":assets/fonts/nametagsFont.ttf", 16)
local maxIconsPerLine = 6
local playerhp = {}
local lasthp = {}
local playerarmor = {}
local lastarmor = {}

function startRes()
	for key, value in ipairs(getElementsByType("player")) do
		setPlayerNametagShowing(value, false)
		setPedTargetingMarkerEnabled(false)
	end
end
addEventHandler("onClientResourceStart", getResourceRootElement(), startRes)

function playerQuit()
	if (getElementType(source) 	== "player") then
		playerhp[source] = nil
		lasthp[source] = nil
		playerarmor[source] = nil
		lastarmor[source] = nil
	end
end
addEventHandler("onClientElementStreamOut", getRootElement(), playerQuit)
addEventHandler("onClientPlayerQuit", getRootElement(), playerQuit)

function setNametagOnJoin()
	setPlayerNametagShowing(source, false)
end
addEventHandler("onClientPlayerJoin", getRootElement(), setNametagOnJoin)

function streamIn()
	if (getElementType(source) == "player") then
		playerhp[source] = getElementHealth(source)
		lasthp[source] = playerhp[source]
		
		playerarmor[source] = getPedArmor(source)
		lastarmor[source] = playerarmor[source]
	end
end
addEventHandler("onClientElementStreamIn", getRootElement(), streamIn)

function isPlayerMoving(player)
	return (not isPedInVehicle(player) and (getPedControlState(player, "forwards") or getPedControlState(player, "backwards") or getPedControlState(player, "left") or getPedControlState(player, "right") or getPedControlState(player, "accelerate") or getPedControlState(player, "brake_reverse") or getPedControlState(player, "enter_exit") or getPedControlState(player, "enter_passenger")))
end

function aimsSniper() return getPedControlState(localPlayer, "aim_weapon") and getPedWeapon(localPlayer) == 34 end
function aimsAt(player) return getPedTarget(localPlayer) == player and aimsSniper() end

function getPlayerIcons(name, player, distance)
	distance = distance or 0
	local tinted, masked = false, false
	local icons = {}

	-- Staff Icons
	if getElementData(player,"var:hiddenAdmin") ~= 1 then -- Note that HideAdmin applies to ALL staff HUD icons, if admin is hidden, no staff icons appear.
		if exports.global:isPlayerManager(player) and getElementData(player,"duty:staff") == 1 then
			table.insert(icons, "manager")
		elseif exports.global:isPlayerTrialAdmin(player) and getElementData(player,"duty:staff") == 1 then
			table.insert(icons, "admin")
		elseif exports.global:isPlayerHelper(player) and getElementData(player,"duty:staff") == 1 then
			table.insert(icons, 'helper')
		end

		-- Auxiliary Team Icons
		if exports.global:isPlayerDeveloper(player) and getElementData(player,"duty:developer") == 1 then
			table.insert(icons, 'developer')
		end
		if exports.global:isPlayerVehicleTeam(player) and getElementData(player,"duty:vt") == 1 then
			table.insert(icons, 'vehicleteam')
		end
		if exports.global:isPlayerMappingTeam(player) and getElementData(player,"duty:mt") == 1 then
			table.insert(icons, 'mappingteam')
		end
		triggerServerEvent("updateNametagColor", localPlayer)
	end

	-- Vehicle icons.
	local theVehicle = getPedOccupiedVehicle(player)
	if (theVehicle) then
		if getElementData(player, "character:seatbelt") then
			table.insert(icons, 'seatbelt')
		end
		if (getElementData(theVehicle, "vehicle:windows") == 1) then
			table.insert(icons, 'windowdown')
		end
	end

	--[[
	-- Smoking icon. @requires item-system
	if getElementData(player,"character:smoking") == true then
		table.insert(icons, "cigarette")
	end]]

	local health = getElementHealth( player )
	local tick = math.floor(getTickCount() / 1000) % 2
	if health <= 10 and tick == 0 then
		table.insert(icons, 'lowhealth2')
	elseif (health <= 30) then
		table.insert(icons, 'lowhealth')
	end

	if getElementData(player, "restrain") == 1 then
		table.insert(icons, "handcuffs")
	end

	if getPedArmor( player ) > 50 then
		table.insert(icons, "armour")
	end

	return name, icons, tinted
end

function renderNametags()
	local hudState = getElementData(localPlayer, "hud:enabledstatus")
	if not isPlayerMapVisible() and (hudState == 0) or (hudState == 2) then
		local players = {}
		local distances = {}
		local lx, ly, lz = getElementPosition(localPlayer)
		local dim = getElementDimension(localPlayer)
		
		for key, player in ipairs(getElementsByType("player")) do
			local showOwnNametag = getElementData(localPlayer, "settings:general:setting3") or 1
			if (player ~= localPlayer) or (showOwnNametag == 1 and player == localPlayer) then
				if (isElement(player)) and (getElementDimension(player) == dim) then
					local logged = getElementData(player, "loggedin")
					if (logged == 1) or (logged == 2) then
						local rx, ry, rz = getElementPosition(player)
						local distance = getDistanceBetweenPoints3D(lx, ly, lz, rx, ry, rz)
						local distanceLimit = 20
						
						if isElementOnScreen(player) then
							if aimsAt(player) or (distance < distanceLimit) then
								if not (getElementAlpha(player) < 255) then
									local lx, ly, lz = getCameraMatrix()
									local vehicle = getPedOccupiedVehicle(player) or nil
									local collision, cx, cy, cz, element = processLineOfSight(lx, ly, lz, rx, ry, rz + 1, true, true, true, true, false, false, true, false, vehicle)

									if not (collision or aimsSniper()) then
										local x, y, z = getElementPosition(player)
										
										if not isPedDucked(player) then z = z + 1 else z = z + 0.5 end
										
										local sx, sy = getScreenFromWorldPosition(x, y, z + 0.30, 100, false)
										local oldsy = nil
										local badge = false
										local tinted = false

										local name = getPlayerName(player):gsub("_", " ")

										if (getElementData(player, "staff:rank") >= 1) and (getElementData(player, "duty:staff") > 0) and not (getElementData(player, "var:hiddenAdmin") == 1) then
											name = getElementData(player, "account:username")
										end

										if (sx) and (sy) then
											distance = distance / 5
											
											if (aimsAt(player)) then distance = 1
											elseif (distance < 1) then distance = 1
											elseif (distance > 2) then distance = 2 end
											
											oldsy = sy

											local iconSizeX, iconSizeY = 32, 32
											local xpos, ypos = 0, 75 -- Icon padding from nametag, x, y (Icons height)

											name, icons, tinted = getPlayerIcons(name, player, distance)
											local expectedIcons = math.min(#icons, maxIconsPerLine)
											local iconsThisLine = 0
											local hudStyle = getElementData(localPlayer, "settings:graphics:setting7") or 1
											if (tonumber(hudStyle) == 1) then
												hudStyle = "black_on_white"
											elseif (tonumber(hudStyle) == 2) then
												hudStyle = "white_on_black"
											else
												hudStyle = "black_on_white"
											end
											local offset = 16 * expectedIcons
											for k, theIcon in ipairs(icons) do
												local theIcon = tostring(theIcon)
												if (theIcon == "manager") or (theIcon == "admin") or (theIcon == "helper") or (theIcon == "developer") or (theIcon == "mappingteam") or (theIcon == "vehicleteam") then
													dxDrawImage(sx - offset + xpos, oldsy + ypos, iconSizeX, iconSizeY, "images/staff/" .. theIcon .. ".png")
												else
													dxDrawImage(sx - offset + xpos, oldsy + ypos, iconSizeX, iconSizeY, "images/hud/" .. hudStyle .. "/" .. theIcon .. ".png")
												end

												iconsThisLine = iconsThisLine + 1
												if iconsThisLine == expectedIcons then
													expectedIcons = math.min(#icons - k, maxIconsPerLine)
													offset = 16 * expectedIcons
													iconsThisLine = 0
													xpos = 0
													ypos = ypos + 32
												else
													xpos = xpos + 32
												end
											end
											
											if (distance <= 2) then
												sy = math.ceil(sy + (2 - distance ) * 20)
											end
											sy = sy + 10
											
											
											if (sx) and (sy) then
												if (6 > 5) then
													local offset = 45 / distance
												end
											end
											
											if (distance <= 2) then
												sy = math.ceil(sy - (2 - distance) * 40)
											end
											sy = sy - 20
												
											if (sx) and (sy) and oldsy then
												if (distance < 1) then distance = 1 end
												if (distance > 2) then distance = 2 end
												local offset = 67 / distance
												local scale = 1 --/ distance

												r, g, b = getPlayerNametagColor(player)
												local id = getElementData(player, "player:id")
												if badge then sy = sy - dxGetFontHeight(scale, font) * scale + 2.5 end
												if getKeyState("lctrl") or getKeyState("rctrl") then
													if (getElementData(localPlayer, "staff:rank") >= 2) and (getElementData(localPlayer, "duty:staff") == 1) and (player ~= localPlayer) then
														name = id .. " (" .. getElementData(player, "account:username") .. ")"
													else
														name = id
													end
												end
												local nameHeight = 170 -- Nametag height.
												if (vehicle) then nameHeight = 130 end

												dxDrawText(name, sx - offset + 2, sy + 2, (sx - offset) + 130 / distance, sy + nameHeight / distance, tocolor(0, 0, 0, 255), scale, font, "center", "center", false, false, false, false, false)
												dxDrawText(name, sx - offset, sy, (sx - offset) + 130 / distance, sy + nameHeight / distance, tocolor(r, g, b, 255), scale, font, "center", "center", false, false, false, false, false)
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
		
		for key, player in ipairs(getElementsByType("ped")) do
			if (isElement(player) and (player ~= localPlayer) and (isElementOnScreen(player))) then
				local lx, ly, lz = getElementPosition(localPlayer)
				local rx, ry, rz = getElementPosition(player)
				local distance = getDistanceBetweenPoints3D(lx, ly, lz, rx, ry, rz)
				local distanceLimit = 20

				playerhp[player] = getElementHealth(player)
				
				if (lasthp[player] == nil) then lasthp[player] = playerhp[player] end
				playerarmor[player] = getPedArmor(player)
				
				if (lastarmor[player] == nil) then lastarmor[player] = playerarmor[player] end
				if (aimsAt(player) or distance < distanceLimit) then
					if not getElementData(player, "freecam:state") then
						local lx, ly, lz = getCameraMatrix()
						local vehicle = getPedOccupiedVehicle(player) or nil
						local collision, cx, cy, cz, element = processLineOfSight(lx, ly, lz, rx, ry, rz + 1, true, true, true, true, false, false, true, false, vehicle)
							if not (collision) or aimsSniper() then
							local x, y, z = getElementPosition(player)
							
							if not (isPedDucked(player)) then
								z = z + 1
							else
								z = z + 0.5
							end
							
							local sx, sy = getScreenFromWorldPosition(x, y, z + 0.1, 100, false)
							local oldsy = nil
							
							-- Health.
							if (sx) and (sy) then
								if (1 > 0) then
									distance = distance / 5
									if (aimsAt(player)) then distance = 1
									elseif (distance<1) then distance = 1
									elseif (distance>2) then distance = 2 end
									local offset = 45 / distance
									oldsy = sy 
								end
							end
							
							if (sx) and (sy) then
								if (distance <= 2) then
									sy = math.ceil( sy + ( 2 - distance ) * 20 )
								end
								sy = sy + 10
								
								if (sx) and (sy) then
									if (4 > 5) then
										local offset = 45 / distance
										
										-- Background.
										dxDrawRectangle(sx - offset - 5, sy, 95 / distance, 20 / distance, tocolor(0, 0, 0, 100), false)
										
										-- Draw health.
										local width = 85
										local armorsize = (width / 100) * armor
										local barsize = (width / 100) * (100 - armor)
										
										
										if (distance < 1.2) then
											dxDrawRectangle(sx-offset, sy+5, armorsize/distance, 10 / distance, tocolor(197, 197, 197, 130), false)
											dxDrawRectangle((sx-offset)+(armorsize/distance), sy+5, barsize/distance, 10 / distance, tocolor(162, 162, 162, 100), false)
										else
											dxDrawRectangle(sx-offset, sy+5, armorsize/distance-5, 10 / distance-3, tocolor(197, 197, 197, 130), false)
											dxDrawRectangle((sx-offset)+(armorsize/distance-5), sy+5, barsize/distance-2, 10 / distance-3, tocolor(162, 162, 162, 100), false)
										end
									end
								end
								
								if (distance <= 2) then sy = math.ceil(sy - (2 - distance) * 40) end
								sy = sy - 20
									
								if (sx) and (sy) then
									if (distance < 1) then distance = 1 end
									if (distance > 2) then distance = 2 end
									local offset = 75 / distance
									local scale = 1 / distance
									local r, g, b = 255, 255, 255 -- Placeholder for function to get faction badge colour.
									if not r or tinted then
										r = 255
										g = 255
										b = 255
									end
									local pedName = getElementData(player, "name") and tostring(getElementData(player, "name")):gsub("_", " ") or "John Doe"
									local npcID = getElementData(player, "npc_id") or "?"
									local logged = getElementData(localPlayer, "loggedin")

									if getKeyState("lctrl") or getKeyState("rctrl") and (logged ~= 2) then
										if exports.global:isPlayerHelper(localPlayer) or exports.global:isPlayerDeveloper(localPlayer) then
											pedName = "NPC ID: " .. tostring(npcID)
										end
									end

									dxDrawText(pedName, sx - offset + 2, sy + 2, (sx - offset) + 130 / distance, sy + 20 / distance, tocolor(0, 0, 0, 220), scale, font, "center", "center", false, false, false)
									dxDrawText(pedName, sx - offset, sy, (sx - offset) + 130 / distance, sy+20 / distance, tocolor(r, g, b, 220), scale, font, "center", "center", false, false, false)
									
									local offset = 65 / distance
								end
							end
						end
					end
				end
			end
		end
	end
end
addEventHandler("onClientRender", root, renderNametags)