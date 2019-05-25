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

function spawnGun(thePlayer, targetPlayer, id, mags, rounds)
	if (targetPlayer) then
		local mags = tonumber(mags)
		local rounds = tonumber(rounds)
		local id = tonumber(id)
		local weaponName = getWeaponNameFromID(id)
		local thePlayerName = getPlayerName(thePlayer)
		local thePlayerAdminTitle = exports.global:getStaffTitle(thePlayer)
		local targetPlayerName = getPlayerName(targetPlayer):gsub("_", " ")
		local affectedElements = {thePlayer, targetPlayer}

		giveWeapon(targetPlayer, id, rounds)

		outputChatBox(thePlayerAdminTitle .. " gave you a " .. weaponName .. " with " .. tostring(rounds) .. " rounds.", targetPlayer, 0, 255, 0)
		outputChatBox("You gave " .. targetPlayerName .. " a " .. weaponName .. " with " .. tostring(rounds) .. " rounds.", thePlayer, 0, 255, 0)
		exports.global:sendMessageToAdmins("[INFO] " .. thePlayerAdminTitle  .. " gave " .. targetPlayerName .. " a " .. weaponName .. " with " .. tostring(rounds) .. " rounds.")
		exports.logs:addLog(thePlayer, 1, affectedElements, "Spawned gave " .. targetPlayerName .. " a " .. weaponName .. " with " .. tostring(rounds) .. " rounds.")
	end
end
addEvent("spawnWeapon", true)
addEventHandler("spawnWeapon", getRootElement(), spawnGun)