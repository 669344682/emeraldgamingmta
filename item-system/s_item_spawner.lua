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
|    /| | | | |    |  __||  __/| |    |  _  |\ /          Created by
| |\ \\ \_/ / |____| |___| |   | |____| | | || |         	Skully
\_| \_|\___/\_____/\____/\_|   \_____/\_| |_/\_/

Created for Emerald Gaming Roleplay, do not distribute - All rights reserved. ]]

-- /items - By Skully (19/03/18) [Trial Admin]
function showItemList(thePlayer)
	if exports.global:isPlayerTrialAdmin(thePlayer) then
		local thePlayerRank = getElementData(thePlayer, "staff:rank")
		triggerClientEvent(thePlayer, "item:showItemList", thePlayer, thePlayerRank)
	end
end
addCommandHandler("items", showItemList)
addCommandHandler("itemlist", showItemList)

-- Callback function from /items to spawn the item.
function adminGivePlayerItem(thePlayer, targetPlayer, itemID, itemValue)
	if not (targetPlayer) or not tonumber(itemID) then return false end

	giveItem(targetPlayer, itemID, itemValue)

	local thePlayerName = exports.global:getStaffTitle(thePlayer)
	local targetPlayerName = getPlayerName(targetPlayer):gsub("_", " ")

	outputChatBox("You have given " .. targetPlayerName .. " a " .. g_itemList[itemID][2] .. ".", thePlayer, 75, 230, 10)
	outputChatBox(thePlayerName .. " has given you a '" .. g_itemList[itemID][2] .. "'.", targetPlayer, 75, 230, 10)
end
addEvent("item:adminGivePlayerItem", true)
addEventHandler("item:adminGivePlayerItem", root, adminGivePlayerItem)