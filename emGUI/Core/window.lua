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

-- Default window title colour RGBA: 50, 200, 0, 180
-- Default window body colour RGBA: 0, 0, 0, 180

function dxCreateWindow(x, y, sx, sy, title, relative, notMovable, hideCursor, nooffbutton, titnamecolor, titsize, titimg, titcolor, bgimg, bgcolor, sidesize)
	assert(tonumber(x), "Bad argument @dxCreateWindow at argument 1, expect number got " ..type(x))
	assert(tonumber(y), "Bad argument @dxCreateWindow at argument 2, expect number got " ..type(y))
	assert(tonumber(sx), "Bad argument @dxCreateWindow at argument 3, expect number got " ..type(sx))
	assert(tonumber(sy), "Bad argument @dxCreateWindow at argument 4, expect number got " ..type(sy))
	
	local window = createElement("dgs-dxwindow")
	dgsSetType(window, "dgs-dxwindow")
	table.insert(MaxFatherTable, window)
 	
 	-- Windows are movable by default unless defined as true.
	if (notMovable == true) then
		emSetData(window, "movable", false)
	else
		emSetData(window, "movable", true)
	end

	-- Cursor will always show by default unless defined to hide with true.
	if (hideCursor == true) then
		emSetData(window, "cursor", false)
	else
		emSetData(window, "cursor", true)
	end

	emSetData(window, "titimage", titimg)
	emSetData(window, "titnamecolor", tonumber(titnamecolor) or schemeColor.window.titnamecolor)
	emSetData(window, "titcolor", tonumber(titcolor) or schemeColor.window.titcolor)
	emSetData(window, "image", bgimg)
	emSetData(window, "color", tonumber(bgcolor) or schemeColor.window.color)
	if (title == "") then
		emSetData(window, "titcolor", tonumber(titcolor) or tocolor(0, 0, 0, 180))
		emSetData(window, "text", "")
	else
		emSetData(window, "text", tostring(title) or "")
	end

	emSetData(window, "textsize", {1, 1})
	emSetData(window, "titlesize", tonumber(titsize) or 25)
	emSetData(window, "sidesize", tonumber(sidesize) or 5)
	emSetData(window, "sizable", false) -- false to keep window resizing off by default.
	emSetData(window, "ignoreTitleSize", false)
	emSetData(window, "colorcoded", false)
	emSetData(window, "movetyp", false) -- how the window can be moved, true to allow window to be moved by click-holding anywhere, false for only titlebar click.
	emSetData(window, "font", textFont) -- This actually seems to have no effect, to change font, adjust in client.lua:597
	emSetData(window, "minSize", {60, 60})
	emSetData(window, "maxSize", {20000, 20000})
	insertResourceDxGUI(sourceResource, window)
	triggerEvent("onDgsPreCreate", window)
	calculateGuiPositionSize(window, x, y, relative, sx, sy, relative, true)
	triggerEvent("onDgsCreate", window)

	if not (nooffbutton) then
		local buttonOff = dxCreateButton(30, 0, 30, 25, "❌", false, window, _, 1, 1, _, _, _, tocolor(200, 0, 0, 180), tocolor(180, 0, 0, 180), tocolor(150, 0, 0, 180), true)
		emSetData(window, "closeButton", buttonOff)
		dxSetSide(buttonOff, "right", false)
		emSetData(buttonOff, "ignoreParentTitle", true)
		dxSetPosition(buttonOff, 30, 0, false)
	end
	return window
end

function dxWindowSetCloseButtonEnabled(window, bool)
	assert(dxGetType(window) == "dgs-dxwindow", "Bad argument @dxWindowSetCloseButtonEnabled at at argument 1, expect dgs-dxwindow got ".. dxGetType(window))
	local closeButton = dgsElementData[window].closeButton
	if bool then
		if not isElement(closeButton) then
			local buttonOff = dxCreateButton(30, 0, 30, 25, "❌", false, window, _, 1, 1, _, _, _, tocolor(200, 0, 0, 180), tocolor(180, 0, 0, 180), tocolor(150, 0, 0, 180), true)
			emSetData(window, "closeButton", buttonOff)
			dxSetSide(buttonOff, "right", false)
			emSetData(buttonOff, "ignoreParentTitle",true)
			dxSetPosition(buttonOff, 30, 0, false)
			return true
		end
	else
		if isElement(closeButton) then
			destroyElement(closeButton)
			emSetData(window,"closeButton", nil)
			return true
		end
	end
	return false
end

function dxWindowGetCloseButtonEnabled(window)
	assert(dxGetType(window) == "dgs-dxwindow", "Bad argument @dxWindowGetCloseButtonEnabled at argument 1, expect dgs-dxwindow got " .. dxGetType(window))
	return isElement(dgsElementData[window].closeButton)
end

function dxWindowSetSizable(window, bool)
	assert(dxGetType(window) == "dgs-dxwindow", "Bad argument @dxWindowSetSizable at argument 1, expect dgs-dxwindow got " .. dxGetType(window))
	if dxGetType(window) == "dgs-dxwindow" then
		emSetData(window,"sizable", (bool and true) or false)
		return true
	end
	return false
end

function dxWindowSetMovable(window, bool)
	assert(dxGetType(window) == "dgs-dxwindow", "Bad argument @dxWindowSetMovable at argument 1, expect dgs-dxwindow got " .. dxGetType(window))
    if dxGetType(window) == "dgs-dxwindow" then
		emSetData(window,"movable", (bool and true) or false)
		return true
	end
	return false
end

function dxWindowSetTitleTextColor(window, color)
	assert(dxGetType(window) == "dgs-dxwindow", "Bad argument @dxWindowSetTitleTextColor at argument 1, expect dgs-dxwindow got " .. dxGetType(window))
	if dxGetType(window) == "dgs-dxwindow" then
		emSetData(window, "titnamecolor", tonumber(color) or schemeColor.window.titnamecolor)
		return true
	end
	return false
end

function dxWindowSetTitleColor(window, color)
	assert(dxGetType(window) == "dgs-dxwindow", "Bad argument @dxWindowSetTitleColor at argument 1, expect dgs-dxwindow got " .. dxGetType(window))
	if dxGetType(window) == "dgs-dxwindow" then
		emSetData(window, "titcolor", tonumber(color) or schemeColor.window.titcolor)
		return true
	end
	return false
end

function dxIsWindowVisible(window)
	local state = emGetData(window, "enabled")

	if (state == true) then
		return true
	end
	return false
end
addEventHandler("dxIsWindowVisible", getRootElement(), dxIsWindowVisible)

function dxCloseWindow(window)
	assert(dxGetType(window) == "dgs-dxwindow", "Bad argument @dxCloseWindow at at argument 1, expect dgs-dxwindow got " .. dxGetType(window))
	triggerEvent("onDgsWindowClose", window)
	local canceled = wasEventCancelled()
	triggerEvent("onClientDgsDxWindowClose", window)
	local canceled2 = wasEventCancelled()
	if not canceled and not canceled2 then
		return destroyElement(window)
	end
	return false
end