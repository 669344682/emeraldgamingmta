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

function updateCharacterDescription(descriptionTable, selectedMood, newWeight)
	exports.blackhawk:changeElementDataEx(source, "character:description", descriptionTable, true)
	exports.blackhawk:changeElementDataEx(source, "character:weight", newWeight, true)
	exports.blackhawk:changeElementDataEx(source, "character:mood", selectedMood, true)
	outputChatBox("You have updated your character's description.", source, 0, 255, 0)
end
addEvent("interaction:updateCharacterDescription", true)
addEventHandler("interaction:updateCharacterDescription", root, updateCharacterDescription)

function updateCharacterMood(newMood)
	exports.blackhawk:changeElementDataEx(source, "character:mood", newMood, true)
	triggerEvent("rp:sendAme", source, "is now " .. string.gsub(g_selectableMoods[newMood], "^.", string.lower) .. ".")
end
addEvent("interaction:updateCharacterMood", true)
addEventHandler("interaction:updateCharacterMood", root, updateCharacterMood)