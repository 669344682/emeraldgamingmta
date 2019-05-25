--[[
  _____                          _     _  ____ _   _ ___ 
 | ____|_ __ ___   ___ _ __ __ _| | __| |/ ___| | | |_ _|
 |  _| | '_ ` _ \ / _ \ '__/ _` | |/ _` | |  _| | | || | 
 | |___| | | | | |  __/ | | (_| | | (_| | |_| | |_| || | 
 |_____|_| |_| |_|\___|_|  \__,_|_|\__,_|\____|\___/|___|
                                                         
			|_   		   _____ _          _ _       
			|_)\/		  / ____| |        | | |   
			   / 		 | (___ | | ___   _| | |_ 
						  \___ \| |/ / | | | | | | | |
						  ____) |   <| |_| | | | |_| |
						 |_____/|_|\_\\__,_|_|_|\__, |
						                         __/ |
						                        |___/ 

Created for Emerald Gaming Roleplay, do not distribute - All rights reserved. ]]

function dxCreateButton(x, y, sx, sy, text, relative, parent, textcolor, scalex, scaley, defimg, selimg, cliimg, defcolor, selcolor, clicolor)
	assert(tonumber(x), "Bad argument @dxCreateButton at argument 1, expect number got " .. type(x))
	assert(tonumber(y), "Bad argument @dxCreateButton at argument 2, expect number got " .. type(y))
	assert(tonumber(sx), "Bad argument @dxCreateButton at argument 3, expect number got " .. type(sx))
	assert(tonumber(sy), "Bad argument @dxCreateButton at argument 4, expect number got " .. type(sy))
	if isElement(parent) then
		assert(emIsDxElement(parent), "Bad argument @dxCreateButton at argument 7, expect dgs-dxgui got " .. dxGetType(parent))
	end
	local button = createElement("dgs-dxbutton")
	dgsSetType(button, "dgs-dxbutton")
	local _x = emIsDxElement(parent) and dxSetParent(button, parent, true) or table.insert(MaxFatherTable, 1, button)
	defcolor, selcolor, clicolor = defcolor or schemeColor.button.color[1], selcolor or schemeColor.button.color[2], clicolor or schemeColor.button.color[3]
	emSetData(button, "image", {defimg, selimg, cliimg})
	emSetData(button, "color", {defcolor, selcolor, clicolor})
	emSetData(button, "text", tostring(text))
	emSetData(button, "textcolor", textcolor or schemeColor.button.textcolor)
	emSetData(button, "textsize", {tonumber(scalex) or 1, tonumber(scaley) or 1})
	emSetData(button, "shadow", {_, _, _})
	emSetData(button, "font", buttonFont)
	emSetData(button, "clickoffset", {0, 0})
	emSetData(button, "clip", false)
	emSetData(button, "clickType", 1)
	emSetData(button, "wordbreak", false)
	emSetData(button, "colorcoded", false)
	emSetData(button, "rightbottom", {"center", "center"})
	insertResourceDxGUI(sourceResource, button)
	triggerEvent("onDgsPreCreate", button)
	calculateGuiPositionSize(button, x, y, relative or false, sx, sy, relative or false, true)
	triggerEvent("onDgsCreate", button)
	return button
end

function dxButtonSetColor(button, defcolor, selcolor, clicolor)
	assert(dxGetType(button) == "dgs-dxbutton","Bad argument @dxButtonSetTextColor at argument 1, expect dgs-dxbutton got "..dxGetType(button))
	defcolor, selcolor, clicolor = defcolor or schemeColor.button.color[1], selcolor or schemeColor.button.color[2], clicolor or schemeColor.button.color[3]
	local state = emSetData(button, "color", {defcolor, selcolor, clicolor})
	return state
end

function dxButtonSetTextColor(button, textcolor)
	assert(dxGetType(button) == "dgs-dxbutton","Bad argument @dxButtonSetTextColor at argument 1, expect dgs-dxbutton got "..dxGetType(button))
	local state = emSetData(button, "textcolor", textcolor)
	return state
end