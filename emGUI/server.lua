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

function getMyIP()
	triggerClientEvent(source, "giveIPBack", source, getPlayerIP(source))
end
addEvent("getMyIP", true)
addEventHandler("getMyIP", root, getMyIP)
