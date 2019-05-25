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
| |\ \\ \_/ / |____| |___| |   | |____| | | || |            Skully
\_| \_|\___/\_____/\____/\_|   \_____/\_| |_/\_/

Copyright of the Emerald Gaming Development Team, do not distribute - All rights reserved. ]]

function adjustAlphaRanks(thePlayer)
	if (getElementData(thePlayer, "loggedin") == 1) then
		local staffRank = getElementData(thePlayer, "staff:rank")
		local vtRank = getElementData(thePlayer, "staff:vt")
		local mtRank = getElementData(thePlayer, "staff:mt")
		local ftRank = getElementData(thePlayer, "staff:ft")

		triggerClientEvent(thePlayer, "alpha:adjustRanks", thePlayer, staffRank, vtRank, mtRank, ftRank)
	else
		outputChatBox("ERROR: You need to be logged in to use this.", thePlayer, 255, 0, 0)
	end
end
addCommandHandler("adjustranks", adjustAlphaRanks)
addCommandHandler("adjustrank", adjustAlphaRanks)
addCommandHandler("editrank", adjustAlphaRanks)
addCommandHandler("editranks", adjustAlphaRanks)

function updateRanksCallback(selectedStaff, selectedVt, selectedMt, selectedFt)
	if not tonumber(selectedStaff) or not tonumber(selectedVt) or not tonumber(selectedMt) or not tonumber(selectedFt) then
		outputChatBox("ERROR: Failed to update ranks, try again.", source, 255, 0, 0)
		return false
	end

	local accountID = getElementData(source, "account:id")

	exports.mysql:Execute(
		"UPDATE `accounts` SET `rank` = (?), `vehicleteam` = (?), `mappingteam` = (?), `factionteam` = (?) WHERE `id` = (?);",
		selectedStaff, selectedVt, selectedMt, selectedFt, accountID
	)

	exports.blackhawk:setElementDataEx(source, "staff:rank", selectedStaff, true)
	exports.blackhawk:setElementDataEx(source, "staff:vt", selectedVt, true)
	exports.blackhawk:setElementDataEx(source, "staff:mt", selectedMt, true)
	exports.blackhawk:setElementDataEx(source, "staff:ft", selectedFt, true)
	exports.global:setPlayerTitles(source)

	outputChatBox("You have updated your staff ranks.", source, 0, 255, 0)
end
addEvent("alpha:updateRanks", true)
addEventHandler("alpha:updateRanks", root, updateRanksCallback)