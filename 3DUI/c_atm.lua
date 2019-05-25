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

ATM = createObject(2942, 1628.0866699219, 611.337890625, 7.4721841812134)

passwordString = ""

local myGuiPanel = {
	["window:ATM1:background"] = {
		name = "ATM Window",
		render = {
			size = Vector2(300, 320)
		},
		draw = {
			{funct = dxDrawRectangle, parameters = {0, 0, 500, 500, tocolor(0, 0, 0, 240)}},
			{funct = dxDrawRectangle, parameters = {0, 0, 500, 50, tocolor(50, 200, 0, 240)}},
			{funct = dxDrawText, parameters = {"Bank of Las Venturas", 0, 0, 300, 50, tocolor(255, 255, 255, 255), 2, "default", "center", "center"}},
			{funct = dxDrawText, parameters = {"Input your PIN:", 0, 0, 140, 150, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center"}},
			{funct = dxDrawRectangle, parameters = {28, 85, 230, 30, tocolor(180, 180, 180, 250)}},
			{funct = dxDrawText, parameters = {passwordString, 35, 0, 0, 200, tocolor(0, 0, 0, 255), 2, "default-bold", "left", "center"}},
			{funct = dxDrawText, parameters = {"", 30, 0, 250, 200, tocolor(0, 0, 0, 255), 1.5, "default-bold", "center", "center"}},
		},
		matrix = {
			position = Vector3(1628.1, 611.63, 8.5),
			rotation = 270,
			color = tocolor(255, 255, 255, 255)
		}
	},
	["button:ATM1:number1"] = { 
		name = "Number 1",
		render = {
			size = Vector2(50, 50) 
		},
		draw = { 
			{funct = dxDrawRectangle, parameters = {0, 0, 50, 50, tocolor(50, 200, 0, 200)}},
			{funct = dxDrawText, parameters = {"1", 0, 0, 50, 50, tocolor(255, 255, 255, 255), 2, "default", "center", "center"}}
		},
		matrix = {
			position = Vector3(1627.907, 611.5, 8.5),
			rotation = 270,
			color = tocolor(255, 255, 255, 255)
		},
		message = "1"
	},
	["button:ATM1:number2"] = { 
		name = "Number 2",
		render = {
			size = Vector2(50, 50) 
		},
		draw = { 
			{funct = dxDrawRectangle, parameters = {0, 0, 50, 50, tocolor(50, 200, 0, 200)}},
			{funct = dxDrawText, parameters = {"2", 0, 0, 50, 50, tocolor(255, 255, 255, 255), 2, "default", "center", "center"}}
		},
		matrix = {
			position = Vector3(1628.03, 611.5, 8.5),
			rotation = 270,
			color = tocolor(255, 255, 255, 255)
		},
		message = "2"
	},
	["button:ATM1:number3"] = { 
		name = "Number 3",
		render = {
			size = Vector2(50, 50) 
		},
		draw = { 
			{funct = dxDrawRectangle, parameters = {0, 0, 50, 50, tocolor(50, 200, 0, 200)}},
			{funct = dxDrawText, parameters = {"3", 0, 0, 50, 50, tocolor(255, 255, 255, 255), 2, "default", "center", "center"}}
		},
		matrix = {
			position = Vector3(1628.153, 611.5, 8.5),
			rotation = 270,
			color = tocolor(255, 255, 255, 255)
		},
		message = "3"
	},
	["button:ATM1:number4"] = { 
		name = "Number 4",
		render = {
			size = Vector2(50, 50) 
		},
		draw = { 
			{funct = dxDrawRectangle, parameters = {0, 0, 50, 50, tocolor(50, 200, 0, 200)}},
			{funct = dxDrawText, parameters = {"4", 0, 0, 50, 50, tocolor(255, 255, 255, 255), 2, "default", "center", "center"}}
		},
		matrix = {
			position = Vector3(1627.907, 611.5, 8.38),
			rotation = 270,
			color = tocolor(255, 255, 255, 255)
		},
		message = "4"
	},
	["button:ATM1:number5"] = { 
		name = "Number 5",
		render = {
			size = Vector2(50, 50) 
		},
		draw = { 
			{funct = dxDrawRectangle, parameters = {0, 0, 50, 50, tocolor(50, 200, 0, 200)}},
			{funct = dxDrawText, parameters = {"5", 0, 0, 50, 50, tocolor(255, 255, 255, 255), 2, "default", "center", "center"}}
		},
		matrix = {
			position = Vector3(1628.03, 611.5, 8.38),
			rotation = 270,
			color = tocolor(255, 255, 255, 255)
		},
		message = "5"
	},
	["button:ATM1:number6"] = { 
		name = "Number 6",
		render = {
			size = Vector2(50, 50) 
		},
		draw = { 
			{funct = dxDrawRectangle, parameters = {0, 0, 50, 50, tocolor(50, 200, 0, 200)}},
			{funct = dxDrawText, parameters = {"6", 0, 0, 50, 50, tocolor(255, 255, 255, 255), 2, "default", "center", "center"}}
		},
		matrix = {
			position = Vector3(1628.153, 611.5, 8.38),
			rotation = 270,
			color = tocolor(255, 255, 255, 255)
		},
		message = "6"
	},
	["button:ATM1:number7"] = { 
		name = "Number 7",
		render = {
			size = Vector2(50, 50) 
		},
		draw = { 
			{funct = dxDrawRectangle, parameters = {0, 0, 50, 50, tocolor(50, 200, 0, 200)}},
			{funct = dxDrawText, parameters = {"7", 0, 0, 50, 50, tocolor(255, 255, 255, 255), 2, "default", "center", "center"}}
		},
		matrix = {
			position = Vector3(1627.907, 611.5, 8.26),
			rotation = 270,
			color = tocolor(255, 255, 255, 255)
		},
		message = "7"
	},
	["button:ATM1:number8"] = { 
		name = "Number 8",
		render = {
			size = Vector2(50, 50) 
		},
		draw = { 
			{funct = dxDrawRectangle, parameters = {0, 0, 50, 50, tocolor(50, 200, 0, 200)}},
			{funct = dxDrawText, parameters = {"8", 0, 0, 50, 50, tocolor(255, 255, 255, 255), 2, "default", "center", "center"}}
		},
		matrix = {
			position = Vector3(1628.03, 611.5, 8.26),
			rotation = 270,
			color = tocolor(255, 255, 255, 255)
		},
		message = "8"
	},
	["button:ATM1:number9"] = { 
		name = "Number 9",
		render = {
			size = Vector2(50, 50) 
		},
		draw = { 
			{funct = dxDrawRectangle, parameters = {0, 0, 50, 50, tocolor(50, 200, 0, 200)}},
			{funct = dxDrawText, parameters = {"9", 0, 0, 50, 50, tocolor(255, 255, 255, 255), 2, "default", "center", "center"}}
		},
		matrix = {
			position = Vector3(1628.153, 611.5, 8.26),
			rotation = 270,
			color = tocolor(255, 255, 255, 255)
		},
		message = "9"
	},
	["button:ATM1:erase"] = { 
		name = "Erase",
		render = {
			size = Vector2(80, 50) 
		},
		draw = { 
			{funct = dxDrawRectangle, parameters = {0, 0, 80, 50, tocolor(50, 200, 0, 200)}},
			{funct = dxDrawText, parameters = {"⬅️", 30, 0, 50, 50, tocolor(255, 255, 255, 255), 2, "default", "center", "center"}}
		},
		matrix = {
			position = Vector3(1628.294, 611.5, 8.38),
			rotation = 270,
			color = tocolor(255, 255, 255, 255)
		},
		message = "Erase"
	},
	["button:ATM1:enter"] = { 
		name = "Enter",
		render = {
			size = Vector2(80, 50) 
		},
		draw = { 
			{funct = dxDrawRectangle, parameters = {0, 0, 80, 50, tocolor(50, 200, 0, 200)}},
			{funct = dxDrawText, parameters = {"✅", 30, 0, 50, 50, tocolor(255, 255, 255, 255), 2, "default", "center", "center"}}
		},
		matrix = {
			position = Vector3(1628.294, 611.5, 8.26),
			rotation = 270,
			color = tocolor(255, 255, 255, 255)
		},
		message = "Enter"
	},
}

function createGui()
	for key, item in pairs(myGuiPanel) do
		gui.items[key] = item-- Add every item from myGuiPanel to the 3D GUI system.
	end
end
addEventHandler("onClientResourceStart", root, createGui)

function mouseEnter(key)
	local values = split(key, ":")
	
	local type = values[1]
	local root = values[2]
	local name = values[3]
	if type == "button" and root == "ATM1" then
		gui.items[key].draw[1].parameters[5] = tocolor(35, 150, 0, 255)
	end
end
addEventHandler("on3DMouseEnter", root, mouseEnter)

function mouseLeave(key)
	local values = split(key, ":")
	
	local type = values[1]
	local root = values[2]
	local name = values[3]
	if type == "button" and root == "ATM1" then 
		gui.items[key].draw[1].parameters[5] = tocolor(50, 200, 0, 200)
	end
end
addEventHandler("on3DMouseLeave", root, mouseLeave)

function mouseClick(key, button, state)
	if button == "mouse1" and state == "down" then
		local values = split(key, ":")
		
		local type = values[1]
		local root = values[2]
		local name = values[3]
		if type == "button" and root == "ATM1" then
			if (gui.items[key].message == "Erase") then
				passwordString = passwordString:sub(1, -2)
				myGuiPanel["window:ATM1:background"].draw[6].parameters[1] = passwordString
			elseif (gui.items[key].message == "Enter") then
				if passwordString == "1234" then
					myGuiPanel["window:ATM1:background"].draw[7].parameters[1] = "Password Accepted!"
					myGuiPanel["window:ATM1:background"].draw[7].parameters[6] = tocolor(0, 210, 0, 255)
					myGuiPanel["window:ATM1:background"].draw[6].parameters[1] = ""
					setTimer(function()
						myGuiPanel["window:ATM1:background"].draw[6].parameters[1] = passwordString
						myGuiPanel["window:ATM1:background"].draw[7].parameters[1] = ""
					end, 2000, 1)
				else
					myGuiPanel["window:ATM1:background"].draw[7].parameters[1] = "Invalid PIN!"
					myGuiPanel["window:ATM1:background"].draw[7].parameters[6] = tocolor(210, 0, 0, 255)
					myGuiPanel["window:ATM1:background"].draw[6].parameters[1] = ""
					setTimer(function()
						myGuiPanel["window:ATM1:background"].draw[6].parameters[1] = passwordString
						myGuiPanel["window:ATM1:background"].draw[7].parameters[1] = ""
					end, 2000, 1)
				end
			else
				if (string.len(passwordString) > 8) then return end
				passwordString = passwordString .. gui.items[key].message
				myGuiPanel["window:ATM1:background"].draw[6].parameters[1] = passwordString
			end
		end
	end
end
addEventHandler("on3DMouseClick", root, mouseClick)