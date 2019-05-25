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

resourceDxGUI = {}
builtins = {}
builtins.Linear = true
builtins.InQuad = true
builtins.OutQuad = true
builtins.InOutQuad = true
builtins.OutInQuad = true
builtins.InElastic = true
builtins.OutElastic = true
builtins.InOutElastic = true
builtins.OutInElastic = true
builtins.InBack = true
builtins.OutBack = true
builtins.InOutBack = true
builtins.OutInBack = true
builtins.InBounce = true
builtins.OutBounce = true
builtins.InOutBounce = true
builtins.OutInBounce = true
builtins.SineCurve = true
builtins.CosineCurve = true
SelfEasing = {}
SEInterface = [[
local args = {...};
local value,setting = args[1],args[2];
]]
function addEasingFunction(name,str)
	assert(type(name) == "string","Bad at argument @addEasingFunction at argument 1, expected a string got "..type(name))
	assert(type(str) == "string","Bad at argument @addEasingFunction at argument 2, expected a string got "..type(str))
	assert(not builtins[name],"Bad at argument @addEasingFunction at argument 1, duplicated name with builtins ("..name..")")
	assert(not SelfEasing[name],"Bad at argument @addEasingFunction at argument 1, this name has been used ("..name..")")
	local str = SEInterface..str
	local fnc = loadstring(str)
	assert(type(fnc) == "function","Bad at argument @addEasingFunction at argument 2, failed to load the code")
	SelfEasing[name] = fnc
	return true
end

function removeEasingFunction(name)
	assert(type(name) == "string","Bad at argument @removeEasingFunction at argument 1, expected a string got "..type(name))
	if SelfEasing[name] then
		SelfEasing[name] = nil
		return true
	end
	return false
end

function doesEasingFunctionExist(name)
	assert(type(name) == "string","Bad at argument @doesEasingFunctionExist at argument 1, expected a string got "..type(name))
	return builtins[name] or (SelfEasing[name] and true)
end	

function insertResourceDxGUI(res,gui)
	if res and isElement(gui) then
		resourceDxGUI[res] = resourceDxGUI[res] or {}
		table.insert(resourceDxGUI[res],gui)
		setElementData(gui,"resource",res)
	end
end

addEventHandler("onClientResourceStop",root,function(res)
	local guiTable = resourceDxGUI[res]
	if guiTable then
		for k,v in pairs(guiTable) do
			local ele = v
			guiTable[k] = ""
			if isElement(ele) then
				destroyElement(ele)
			end
		end
		resourceDxGUI[res] = nil
	end
end)

function dgsGetGuiLocationOnScreen(baba,relative,rndsup)
	if isElement(baba) then
		guielex,guieley = getParentLocation(baba,rndsup,dgsElementData[baba].absPos[1],dgsElementData[baba].absPos[2])
		if relative then
			return guielex/sW,guieley/sH
		else
			return guielex,guieley
		end
	end
	return false
end

function getParentLocation(baba,rndsup,x,y)
	local baba = FatherTable[baba]
	if not isElement(baba) or (rndsup and dgsElementData[baba].renderTarget_parent) then return x,y end
	if dgsElementType[baba] == "dgs-dxtab" then
		baba = dgsElementData[baba]["parent"]
		local h = dgsElementData[baba].absSize[2]
		local tabheight = dgsElementData[baba]["tabheight"][2] and dgsElementData[baba]["tabheight"][1]*h or dgsElementData[baba]["tabheight"][1]
		x = x+dgsElementData[baba].absPos[1]
		y = y+dgsElementData[baba].absPos[2]+tabheight
	else
		x = x+dgsElementData[baba].absPos[1]
		y = y+dgsElementData[baba].absPos[2]
	end
	return getParentLocation(baba,rndsup,x,y)
end

function dxGetPosition(gui,bool,includeParent,rndsupport)
	assert(emIsDxElement(gui),"Bad argument @dxGetPosition at argument 1, expect dgs-dxgui got "..dxGetType(gui))
	if includeParent then
		return dgsGetGuiLocationOnScreen(gui,bool,rndsupport)
	else
		local pos = dgsElementData[gui][bool and "rltPos" or "absPos"]
		return pos[1],pos[2]
	end
end

function dxSetPosition(gui,x,y,bool)
	if emIsDxElement(gui) then
		calculateGuiPositionSize(gui,x,y,bool or false)
		return true
	end
	return false,"not a dx-gui"
end

function dxGetSize(gui,bool)
	assert(emIsDxElement(gui),"Bad argument @dxGetSize at argument 1, expect dgs-dxgui got "..dxGetType(gui))
	return unpack(dgsElementData[gui][bool and "rltSize" or "absSize"])
end

function dxSetSize(gui,x,y,bool)
	if emIsDxElement(gui) then
		calculateGuiPositionSize(gui,_,_,_,x,y,bool or false)
		return true
	end
	return false,"not a dx-gui"
end

function dxSetProperty(dxgui,key,value,...)
	assert(emIsDxElement(dxgui),"Bad argument @dxSetProperty at argument 1, expect a dgs-dxgui element got "..dxGetType(dxgui))
	if key == "functions" then
		local fnc = loadstring(value)
		assert(fnc,"Bad argument @dxSetProperty at argument 2, failed to load function")
		value = {fnc,{...}}
	elseif key == "textcolor" then
		if not tonumber(value) then
			assert(false,"Bad argument @dxSetProperty at argument 3, expect a number got "..type(value))
		end
	elseif key == "text" then
		local dgsType = dxGetType(dxgui)
		if dgsType == "dgs-dxmemo" then
			return handleDxMemoText(dxgui,value)
		end
	end
	return emSetData(dxgui,tostring(key),value)
end

function dxSetProperties(dxgui,theTable,additionArg)
	assert(emIsDxElement(dxgui),"Bad argument @dxSetProperties at argument 1, expect a dgs-dxgui element got "..dxGetType(dxgui))
	assert(type(theTable)=="table","Bad argument @dxSetProperties at argument 2, expect a table got "..type(theTable))
	assert((additionArg and type(additionArg)=="table") or additionArg == nil,"Bad argument @dxSetProperties at argument 3, expect a table or nil/none got "..type(additionArg))
	local success = true
	local dgsType = dxGetType(dxgui)
	for key,value in pairs(theTable) do
		local skip = false
		if key == "functions" then
			value = {loadstring(value),additionArg.functions or {}}
		elseif key == "textcolor" then
			if not tonumber(value) then
				assert(false,"Bad argument @dxSetProperties at argument 2 with property 'textcolor', expect a number got "..type(value))
			end
		elseif key == "text" then
			if dgsType == "dgs-dxtab" then
				local tabpanel = dgsElementData[dxgui]["parent"]
				local font = dgsElementData[tabpanel]["font"]
				local wid = min(max(dxGetTextWidth(value,dgsElementData[dxgui]["textsize"][1],font),dgsElementData[tabpanel]["tabminwidth"]),dgsElementData[tabpanel]["tabmaxwidth"])
				local owid = dgsElementData[tab]["width"]
				emSetData(tabpanel,"allleng",dgsElementData[tabpanel]["allleng"]-owid+wid)
				emSetData(dxgui,"width",wid)
			elseif dgsType == "dgs-dxmemo" then
				success = success and handleDxMemoText(dxgui,value)
				skip = true
			end
		end
		if not skip then
			success = success and emSetData(dxgui,tostring(key),value)
		end
	end
	return success
end

function dxGetProperty(dxgui,key)
	assert(emIsDxElement(dxgui),"Bad argument @dxGetProperty at argument 1, expect a dgs-dxgui element got "..dxGetType(dxgui))
	if dgsElementData[dxgui] then
		return dgsElementData[dxgui][key]
	end
	return false
end

function dxGetProperties(dxgui,properties)
	assert(emIsDxElement(dxgui),"Bad argument @dxGetProperties at argument 1, expect a dgs-dxgui element got "..dxGetType(dxgui))
	assert(not properties or type(properties) == "table","Bad argument @dxGetProperties at argument 2, expect none or table got "..type(properties))
	if dgsElementData[dxgui] then
		if not properties then
			return dgsElementData[dxgui]
		else
			local data = {}
			for k,v in ipairs(properties) do
				data[v] = dgsElementData[dxgui][v]
			end
			return data
		end
	end
	return false
end

function getType(thing)
	if isElement(thing) then
		return dxGetType(thing)
	else
		return type(thing)
	end
end

function dgsGUIApplyVisible(parent,visible)
	for k,v in pairs(ChildrenTable[parent] or {}) do
		if dgsElementType[v] == "dgs-dxedit" then
			local edit = dgsElementData[v]["edit"]
			guiSetVisible(edit,visible)
		else
			dgsGUIApplyVisible(v,visible)
		end
	end
end

function dxSetVisible(dxgui,visible)
	assert(emIsDxElement(dxgui),"Bad argument @dxSetVisible at argument 1, expect a dgs-dxgui element got "..dxGetType(dxgui))
	if dxGetType(dxgui) == "dgs-dxedit" then
		local edit = emGetData(dxgui,"edit")
		guiSetVisible(edit,visible)
	else
		dgsGUIApplyVisible(dxgui,false)
	end
	return emSetData(dxgui,"visible",visible and true or false)
end

function dxGetVisible(dxgui)
	assert(emIsDxElement(dxgui),"Bad argument @dxGetVisible at argument 1, expect a dgs-dxgui element got "..dxGetType(dxgui))
	return dgsElementData[dxgui]["visible"]
end

function dxSetSide(dxgui,side,topleft)
	assert(emIsDxElement(dxgui),"Bad argument @dxSetSide at argument 1, expect a dgs-dxgui element got "..dxGetType(dxgui))
	return emSetData(dxgui,topleft and "tob" or "lor",side)
end

function dxGetSide(dxgui,topleft)
	assert(emIsDxElement(dxgui),"Bad argument @dxGetSide at argument 1, expect a dgs-dxgui element got "..dxGetType(dxgui))
	return emGetData(dxgui,topleft and "tob" or "lor")
end

function blurEditMemo()
	local gui = guiCreateLabel(0,0,0,0,"",false)
	guiBringToFront(gui)
	destroyElement(gui)
end

lastFront = false
function dxBringToFront(dxgui,mouse,dontMoveParent,dontChangeData)
	assert(emIsDxElement(dxgui),"Bad argument @dxBringToFront at argument 1, expect a dgs-dxgui element got "..dxGetType(dxgui))
	local parent = dxGetParent(dxgui)
	local mouse = mouse or "left"
	if not dontChangeData then
		local oldShow = MouseData.nowShow
		MouseData.nowShow = dxgui
		if dxGetType(dxgui) == "dgs-dxedit" then
			MouseData.editCursor = true
			resetTimer(MouseData.EditTimer)
			local edit = dgsElementData[dxgui].edit
			guiBringToFront(edit)
		elseif dxgui ~= oldShow then
			local dgsType = dxGetType(oldShow)
			if dgsType == "dgs-dxedit" or dgsType == "dgs-dxmemo" then
				blurEditMemo()
			end
		end
		if isElement(oldShow) and dgsElementData[oldShow].clearSelection then
			emSetData(oldShow,"selectfrom",dgsElementData[oldShow].cursorpos)
		end
	end
	if not isElement(parent) then
		local id = table.find(MaxFatherTable,dxgui)
		if id then
			table.remove(MaxFatherTable,id)
			table.insert(MaxFatherTable,dxgui)
		end
	else
		local parents = dxgui
		while true do
			local uparents = dxGetParent(parents)
			if isElement(uparents) then
				local children = dxGetChildren(uparents)
				local id = table.find(children,parents)
				if id then
					table.remove(children,id)
					table.insert(children,parents)
					if dxGetType(parents) == "dgs-dxscrollpane" then
						local scrollbar = emGetData(parents,"scrollbars")
						dxBringToFront(scrollbar[1],"left",_,true)
						dxBringToFront(scrollbar[2],"left",_,true)
					end
				end
				parents = uparents
			else
				local id = table.find(MaxFatherTable,parents)
				if id then
					table.remove(MaxFatherTable,id)
					table.insert(MaxFatherTable,parents)
					if dxGetType(parents) == "dgs-dxscrollpane" then
						local scrollbar = emGetData(parents,"scrollbars")
						dxBringToFront(scrollbar[1],"left",_,true)
						dxBringToFront(scrollbar[2],"left",_,true)
					end
				end
				break
			end
			if dontMoveParent then
				break
			end
		end
	end
	if isElement(lastFront) and lastFront ~= dxgui then
		triggerEvent("onDgsBlur",lastFront,dxgui)
	end
	triggerEvent("onDgsFocus",dxgui,lastFront)
	lastFront = dxgui
	if mouse == "left" then
		MouseData.clickl = dxgui
		MouseData.clickData = nil
	elseif mouse == "right" then
		MouseData.clickr = dxgui
	end
	return true
end

function calculateGuiPositionSize(gui,x,y,relativep,sx,sy,relatives,notrigger)
	local parent = dxGetParent(gui)
	local px,py = 0,0
	local psx,psy = sW,sH
	local oldRelativePos,oldRelativeSize = unpack(dgsElementData[gui].relative or {relativep,relatives})
	local titleOffset = 0
	if isElement(parent) then
		if dxGetType(parent) == "dgs-dxtab" then
			local tabpanel = dgsElementData[parent]["parent"]
			psx,psy = unpack(dgsElementData[tabpanel].absSize)
			local height = dgsElementData[tabpanel]["tabheight"][2] and dgsElementData[tabpanel]["tabheight"][1]*psx or dgsElementData[tabpanel]["tabheight"][1]
			psy = psy-height
		else
			psx,psy = unpack(dgsElementData[parent].absSize)
		end
		if dgsElementData[gui].ignoreParentTitle or dgsElementData[parent].ignoreTitleSize then
			titleOffset = 0
		else
			titleOffset = dgsElementData[parent].titlesize or 0
		end
	end
	if x and y then
		local oldPosAbsx,oldPosAbsy = unpack(dgsElementData[gui].absPos or {})
		local oldPosRltx,oldPosRlty = unpack(dgsElementData[gui].rltPos or {})
		x,y = relativep and x*psx or x,relativep and y*(psy-titleOffset) or y
		local abx,aby,relatx,relaty = x,y+titleOffset,x/psx,y/(psy-titleOffset)
		if psx == 0 then
			relatx = 0
		end
		if psy-titleOffset == 0 then
			relaty = 0
		end
		emSetData(gui,"absPos",{abx,aby})
		emSetData(gui,"rltPos",{relatx,relaty})
		emSetData(gui,"relative",{relativep,oldRelativeSize})
		if not notrigger then
			triggerEvent("onDgsPositionChange",gui,oldPosAbsx,oldPosAbsy,oldPosRltx,oldPosRlty)
		end
	end
	if sx and sy then
		local oldSizeAbsx,oldSizeAbsy = unpack(dgsElementData[gui].absSize or {})
		local oldSizeRltx,oldSizeRlty = unpack(dgsElementData[gui].rltSize or {})
		sx,sy = relatives and sx*psx or sx,relatives and sy*(psy-titleOffset) or sy
		local absx,absy,relatsx,relatsy = sx,sy,sx/psx,sy/(psy-titleOffset)
		if psx == 0 then
			relatsx = 0
		end
		if psy-titleOffset == 0 then
			relatsy = 0
		end
		emSetData(gui,"absSize",{absx,absy})
		emSetData(gui,"rltSize",{relatsx,relatsy})
		emSetData(gui,"relative",{oldRelativePos,relatives})
		if not notrigger then
			triggerEvent("onDgsSizeChange",gui,oldSizeAbsx,oldSizeAbsy,oldSizeRltx,oldSizeRlty)
		end
	end
	return true
end

function dxSetAlpha(dxgui,alpha)
	assert(emIsDxElement(dxgui),"Bad argument @dxSetAlpha at argument 1, expect a dgs-dxgui element got "..dxGetType(dxgui))
	assert(type(alpha) == "number","Bad argument @dxSetAlpha at argument 2, expect a number got "..type(alpha))
	return emSetData(dxgui,"alpha",(alpha > 1 and 1) or (alpha < 0 and 0) or alpha)
end

function dxGetAlpha(dxgui)
	assert(emIsDxElement(dxgui),"Bad argument @dxGetAlpha at argument 1, expect a dgs-dxgui element got "..dxGetType(dxgui))
	return emGetData(dxgui,"alpha")
end

function dxSetEnabled(dxgui,enabled)
	assert(emIsDxElement(dxgui),"Bad argument @dxSetEnabled at argument 1, expect a dgs-dxgui element got "..dxGetType(dxgui))	
	assert(type(enabled) == "boolean","Bad argument @dxSetEnabled at argument 2, expect a boolean element got "..type(enabled))	
	return emSetData(dxgui,"enabled",enabled)
end

function dxGetEnabled(dxgui)
	assert(emIsDxElement(dxgui),"Bad argument @dxGetEnabled at argument 1, expect a dgs-dxgui element got "..dxGetType(dxgui))
	return emGetData(dxgui,"enabled")
end

function dxCreateNewFont(path,...) -- Originally dxCreateFont though this conflicts with the MTA function, so added 'new' in between to differentiate.
	assert(type(path) == "string","Bad argument @dxCreateNewFont at argument 1, expect string got "..type(path))
	if not fileExists(":"..getResourceName(getThisResource()).."/"..path) and not fileExists(path) then
		if not fileExists(path) then
			assert(false,"Bad argument @dxCreateNewFont at argument 1,couldn't find such file '"..path.."'")
		end
		local filename = split(path,"/")
		fileCopy(path,":"..getResourceName(getThisResource()).."/"..filename[#filename])
		path = filename[#filename]
	end
	local font = dxCreateFont(path,...)
	return font
end

function dxSetFont(dxgui,font)
	assert(emIsDxElement(dxgui),"Bad argument @dxSetFont at argument 1, expect a dgs-dxgui element got "..dxGetType(dxgui))
	if font then
		emSetData(dxgui,"font",font)	
	end
end

function dxGetFont(dxgui)
	assert(emIsDxElement(dxgui),"Bad argument @dxGetFont at argument 1, expect a dgs-dxgui element got "..dxGetType(dxgui))
	if emIsDxElement(dxgui) then
		return emGetData(dxgui,"font")	
	end
end

function dxSetText(dxgui,text)
	assert(emIsDxElement(dxgui),"Bad argument @dxSetText at argument 1, expect a dgs-dxgui element got "..dxGetType(dxgui))
	return dxSetProperty(dxgui,"text",tostring(text))
end

function dxGetText(dxgui)
	assert(emIsDxElement(dxgui),"Bad argument @dxGetText at argument 1, expect a dgs-dxgui element got "..dxGetType(dxgui))
	local dxtype = dxGetType(dxgui)
	if dxtype == "dgs-dxmemo" then
		return dxMemoGetPartOfText(dxgui)
	else
		return dgsElementData[dxgui].text
	end
end

function dgsSetShaderValue(...)
	return dxSetShaderValue(...)
end

defaultRoundUpPoints = 3
function dxRoundUp(num,points)
	if points then
		assert(type(points) == "number","Bad Argument @dxRoundUp at argument 2, expect a positive integer got "..dxGetType(points))
		assert(points%1 == 0,"Bad Argument @dxRoundUp at argument 2, expect a positive integer got float")
		assert(points > 0,"Bad Argument @dxRoundUp at argument 2, expect a positive integer got "..points)
	end
	local points = points or defaultRoundUpPoints
	local s_num = tostring(num)
	local from,to = utf8.find(s_num,"%.")
	if from then
		local single = s_num:sub(from+points,from+points)
		local single = tonumber(single) or 0
		local a = s_num:sub(0,from+points-1)
		if single >= 5 then
			a = a+10^(-points+1)
		end
		return tonumber(a)
	end
	return num
end

function dxGetRoundUpPoints()
	return defaultRoundUpPoints
end

function dxSetRoundUpPoints(points)
	assert(type(points) == "number","Bad Argument @dxSetRoundUpPoints at argument 1, expect a positive integer got "..dxGetType(points))
	assert(points%1 == 0,"Bad Argument @dxSetRoundUpPoints at argument 1, expect a positive integer got float")
	assert(points > 0,"Bad Argument @dxSetRoundUpPoints at argument 1, expect a positive integer got 0")
	defaultRoundUpPoints = points
	return true
end

addEventHandler("onDgsPreCreate",root,function()
	emSetData(source,"lor","left")
	emSetData(source,"tob","top")
	emSetData(source,"visible",true)
	emSetData(source,"enabled",true)
	emSetData(source,"ignoreParentTitle",false)
	emSetData(source,"textRelative",false)
	emSetData(source,"alpha",1)
	emSetData(source,"hitoutofparent",false)
	emSetData(source,"PixelInt",true)
	emSetData(source,"functionRunBefore",true) --true : after render; false : before render
	emSetData(source,"disabledColor",schemeColor.disabledColor)
	emSetData(source,"disabledColorPercent",schemeColor.disabledColorPercent)
end)
