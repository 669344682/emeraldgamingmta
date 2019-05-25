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

local myGuiPanel = {
	["window:myGuiPanel:background"] = { -- Format: "type:root:name".
		name = "3D Gui Window",
		render = {
			size = Vector2(500, 500) -- renderTarget size.
		},
		draw = {
			{funct = dxDrawRectangle, parameters = {0, 0, 500, 500, tocolor(30, 30, 30, 200)}},
			{funct = dxDrawRectangle, parameters = {0, 0, 500, 50, tocolor(20, 20, 20, 200)}},
			{funct = dxDrawText, parameters = {"Sample Window", 0, 0, 500, 50, tocolor(255, 255, 255, 255), 2.4, "default", "center", "center"}}
		},
		matrix = {
			position = Vector3(0, 0, 5),
			rotation = 90,
			color = tocolor(255, 255, 255, 255)
		}
		-- Add here custom parameters for easier handling if required.
	},
	["button:myGuiPanel:yes"] = { 
		name = "Button Yes",
		render = {
			size = Vector2(250, 50) 
		},
		draw = { 
			{funct = dxDrawRectangle, parameters = {0, 0, 250, 50, tocolor(20, 20, 20, 255)}},
			{funct = dxDrawText, parameters = {"Yes", 0, 0, 250, 50, tocolor(255, 255, 255, 255), 2, "default", "center", "center"}}
		},
		matrix = {
			position = Vector3(-0.25, 0, 4.45),
			rotation = 90,
			color = tocolor(255, 255, 255, 255)
		},
		message = "onYesButtonClick"
	},
	["button:myGuiPanel:no"] = { 
		name = "Button No",
		render = {
			size = Vector2(250, 50) 
		},
		draw = { 
			{funct = dxDrawRectangle, parameters = {0, 0, 250, 50, tocolor(20, 20, 20, 255)}},
			{funct = dxDrawText, parameters = {"No", 0, 0, 250, 50, tocolor(255, 255, 255, 255), 2, "default", "center", "center"}}
		},
		matrix = {
			position = Vector3(0.25, 0, 4.45),
			rotation = 90,
			color = tocolor(255, 255, 255, 255)
		},
		message = "onNoButtonClick"
	},
}

function createGui()
	for key, item in pairs(myGuiPanel) do
		gui.items[key] = item -- Add every item from myGuiPanel to the 3DUI system.
	end
end
addEventHandler("onClientResourceStart", root, createGui)

function mouseEnter(key)
	local values = split(key, ":")
	
	local type = values[1]
	local root = values[2]
	local name = values[3]
	if type == "button" and root == "myGuiPanel" then
		gui.items[key].draw[1].parameters[5] = tocolor(60, 60, 60, 255)
	end
end
addEventHandler("on3DMouseEnter", root, mouseEnter)

function mouseLeave(key)
	local values = split(key, ":")
	
	local type = values[1]
	local root = values[2]
	local name = values[3]
	if type == "button" and root == "myGuiPanel" then 
		gui.items[key].draw[1].parameters[5] = tocolor(20, 20, 20, 255)
	end
end
addEventHandler("on3DMouseLeave", root, mouseLeave)

function mouseClick(key, button, state)
	if button == "mouse1" and state == "down" then
		local values = split(key, ":")
		
		local type = values[1]
		local root = values[2]
		local name = values[3]
		if type == "button" and root == "myGuiPanel" then 
			--outputChatBox(gui.items[key].message)
		end
	end
end
addEventHandler("on3DMouseClick", root, mouseClick)