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

schemeColor = {}
defcolor = {}
defcolor.disabledColor = true
defcolor.disabledColorPercent = 0.8
defcolor.button = {}
defcolor.button.color = {tocolor(0,120,200,200),tocolor(0,90,255,200),tocolor(50,90,250,200)}
defcolor.button.textcolor = tocolor(255,255,255,255)
defcolor.checkbox = {}
defcolor.checkbox.defcolor_f = {tocolor(255,255,255,255),tocolor(255,255,255,255),tocolor(180,180,180,255)}
defcolor.checkbox.defcolor_t = {tocolor(255,255,255,255),tocolor(255,255,255,255),tocolor(180,180,180,255)}
defcolor.checkbox.defcolor_i = {tocolor(255,255,255,255),tocolor(255,255,255,255),tocolor(180,180,180,255)}
defcolor.checkbox.textcolor = tocolor(255,255,255,255)
defcolor.radiobutton = {}
defcolor.radiobutton.defcolor_f = {tocolor(255,255,255,255),tocolor(255,255,255,255),tocolor(180,180,180,255)}
defcolor.radiobutton.defcolor_t = {tocolor(255,255,255,255),tocolor(255,255,255,255),tocolor(180,180,180,255)}
defcolor.radiobutton.textcolor = tocolor(255,255,255,255)
defcolor.cmd = {}
defcolor.cmd.bgcolor = tocolor(0,0,0,150)
defcolor.combobox = {}
defcolor.combobox.color = {tocolor(0,120,200,200),tocolor(0,90,255,200),tocolor(50,90,250,200)}
defcolor.combobox.itemColor = {tocolor(200,200,200,255),tocolor(160,160,160,255),tocolor(130,130,130,255)}
defcolor.combobox.combobgColor = tocolor(200,200,200,200)
defcolor.combobox.arrowColor = tocolor(255,255,255,255)
defcolor.combobox.arrowOutSideColor = tocolor(255,255,255,255)
defcolor.combobox.textcolor = tocolor(0,0,0,255)
defcolor.combobox.listtextcolor = tocolor(0,0,0,255)
defcolor.edit = {}
defcolor.edit.bgcolor = tocolor(200,200,200,255)
defcolor.edit.textcolor = tocolor(0,0,0,255)
defcolor.edit.sidecolor = tocolor(0,0,0,255)
defcolor.memo = {}
defcolor.memo.bgcolor = tocolor(200,200,200,255)
defcolor.memo.textcolor = tocolor(0,0,0,255)
defcolor.memo.sidecolor = tocolor(0,0,0,255)
defcolor.progressbar = {}
defcolor.progressbar.bgcolor = tocolor(100,100,100,200)
defcolor.progressbar.barcolor = tocolor(40,60,200,200)
defcolor.gridlist = {}
defcolor.gridlist.bgcolor = tocolor(210,210,210,255)
defcolor.gridlist.columncolor = tocolor(220,220,220,255)
defcolor.gridlist.columntextcolor = tocolor(0,0,0,255)
defcolor.gridlist.rowcolor = {tocolor(200,200,200,255),tocolor(150,150,150,255),tocolor(0,170,242,255)}
defcolor.gridlist.rowtextcolor = tocolor(0,0,0,255)
defcolor.scrollbar = {}
defcolor.scrollbar.colorn = {tocolor(240,240,240,255),tocolor(192,192,192,255),tocolor(240,240,240,255)}
defcolor.scrollbar.colore = {tocolor(218,218,218,255),tocolor(166,166,166,255)}
defcolor.scrollbar.colorc = {tocolor(180,180,180,255),tocolor(96,96,96,255)}
defcolor.tabpanel = {}
defcolor.tabpanel.defbackground = tocolor(0,0,0,180)
defcolor.tab = {}
defcolor.tab.textcolor = tocolor(255,255,255,255)
defcolor.tab.bgcolor = tocolor(0,0,0,200)
defcolor.tab.tabcolor = {tocolor(40,40,40,180),tocolor(80,80,80,190),tocolor(0,0,0,200)}
defcolor.window = {}
defcolor.window.titnamecolor = tocolor(255,255,255,255)
defcolor.window.titcolor = tocolor(20,20,20,200)
defcolor.window.color = tocolor(20,20,20,150)

function loadColorScheme()
	local scheme = fileOpen("colorScheme.txt")
	if scheme then
		local str = fileRead(scheme,fileGetSize(scheme))
		fileClose(scheme)
		local fnc = loadstring(str)
		if not str then outputDebugString("[emGUI] Failed to load colour scheme! (colorScheme.txt)", 2) return end
		fnc()
	end
end

function restoreColorScheme()
	table.remove(schemeColor)
	schemeColor = table.deepcopy(defcolor)
end
restoreColorScheme()
loadColorScheme()