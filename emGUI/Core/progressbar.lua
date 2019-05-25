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

function dxCreateProgressBar(x, y, sx, sy, relative, parent, bgimg, bgcolor, barimg, barcolor, barmode)
	assert(tonumber(x),"Bad argument @dxCreateProgressBar at argument 1, expect number got "..type(x))
	assert(tonumber(y),"Bad argument @dxCreateProgressBar at argument 2, expect number got "..type(y))
	assert(tonumber(sx),"Bad argument @dxCreateProgressBar at argument 3, expect number got "..type(sx))
	assert(tonumber(sy),"Bad argument @dxCreateProgressBar at argument 4, expect number got "..type(sy))
	if isElement(parent) then
		assert(emIsDxElement(parent),"Bad argument @dxCreateProgressBar at argument 6, expect dgs-dxgui got "..dxGetType(parent))
	end
	if isElement(bgimg) then
		local imgtyp = getElementType(bgimg)
		assert(imgtyp == "texture" or imgtyp == "shader","Bad argument @dxCreateProgressBar at argument 7, expect texture got "..getElementType(bgimg))
	end
	if isElement(barimg) then
		local imgtyp = getElementType(barimg)
		assert(imgtyp == "texture" or imgtyp == "shader","Bad argument @dxCreateProgressBar at argument 9, expect texture got "..getElementType(barimg))
	end
	local progressbar = createElement("dgs-dxprogressbar")
	dgsSetType(progressbar,"dgs-dxprogressbar")
	emSetData(progressbar,"bgcolor",bgcolor or schemeColor.progressbar.bgcolor)
	emSetData(progressbar,"barcolor",barcolor or schemeColor.progressbar.barcolor)
	emSetData(progressbar,"bgimg",bgimg)
	emSetData(progressbar,"barimg",barimg)
	emSetData(progressbar,"barmode",barmode and true or false)
	emSetData(progressbar,"udspace",{5,false})
	emSetData(progressbar,"lrspace",{5,false})
	emSetData(progressbar,"progress",0)
	if isElement(parent) then
		dxSetParent(progressbar,parent)
	else
		table.insert(MaxFatherTable,progressbar)
	end
	insertResourceDxGUI(sourceResource,progressbar)
	triggerEvent("onDgsPreCreate",progressbar)
	calculateGuiPositionSize(progressbar,x,y,relative or false,sx,sy,relative or false,true)
	local mx,my = false,false
	if isElement(barimg) then
		mx,my = dxGetMaterialSize(barimg)
	end
	emSetData(progressbar,"barsize",{mx,my})
	triggerEvent("onDgsCreate",progressbar)
	return progressbar
end

function dxProgressBarGetProgress(gui)
	assert(dxGetType(gui) == "dgs-dxprogressbar","Bad argument @dxProgressBarGetProgress at argument 1, expect dgs-dxprogressbar got "..(dxGetType(gui) or type(gui)))
	return dgsElementData[gui].progress
end

function dxProgressBarSetProgress(gui,progress)
	assert(dxGetType(gui) == "dgs-dxprogressbar","Bad argument @dxProgressBarSetProgress at argument 1, expect dgs-dxprogressbar got "..(dxGetType(gui) or type(gui)))
	if progress < 0 then progress = 0 end
	if progress > 100 then progress = 100 end
	if dgsElementData[gui].progress ~= progress then
		emSetData(gui,"progress",progress)
	end
	return true
end

function dxProgressBarSetMode(gui,mode)
	assert(dxGetType(gui) == "dgs-dxprogressbar","Bad argument @dxProgressBarSetBarMode at argument 1, expect dgs-dxprogressbar got "..(dxGetType(gui) or type(gui)))
	return emSetData(gui,"barmode",mode and true or false)
end

function dxProgressBarGetMode(gui)
	assert(dxGetType(gui) == "dgs-dxprogressbar","Bad argument @dxProgressBarSetBarMode at argument 1, expect dgs-dxprogressbar got "..(dxGetType(gui) or type(gui)))
	return dgsElementData[gui].barmode
end

function dxProgressBarGetUpDownDistance(gui,forcerelative)
	assert(dxGetType(gui) == "dgs-dxprogressbar","Bad argument @dxProgressBarGetUpDownDistance at argument 1, expect dgs-dxprogressbar got "..(dxGetType(gui) or type(gui)))
	if forcerelative == false then
		local value = dgsElementData[gui].udspace[1]
		if dgsElementData[gui].udspace[2] == true then
			local sy = dgsElementData[gui].absSize[2]
			value = sy*value
		end
		return value
	elseif forcerelative == true then
		local value = dgsElementData[gui].udspace[1]
		if dgsElementData[gui].udspace[2] == false then
			local sy = dgsElementData[gui].absSize[2]
			value = value/sy
		end
		return value
	else
		return dgsElementData[gui].udspace[1],dgsElementData[gui].udspace[2]
	end
end

function dxProgressBarGetLeftRightDistance(gui,forcerelative)
	assert(dxGetType(gui) == "dgs-dxprogressbar","Bad argument @dxProgressBarGetLeftRightDistance at argument 1, expect dgs-dxprogressbar got "..(dxGetType(gui) or type(gui)))
	if forcerelative == false then
		local value = dgsElementData[gui].lrspace[1]
		if dgsElementData[gui].lrspace[2] == true then
			local sy = dgsElementData[gui].absSize[1]
			value = sy*value
		end
		return value
	elseif forcerelative == true then
		local value = dgsElementData[gui].lrspace[1]
		if dgsElementData[gui].lrspace[2] == false then
			local sy = dgsElementData[gui].absSize[1]
			value = value/sy
		end
		return value
	else
		return dgsElementData[gui].lrspace[1],dgsElementData[gui].lrspace[2]
	end
end

function dxProgressBarSetUpDownDistance(gui,value,relative)
	assert(dxGetType(gui) == "dgs-dxprogressbar","Bad argument @dxProgressBarSetUpDownDistance at argument 1, expect dgs-dxprogressbar got "..(dxGetType(gui) or type(gui)))
	assert(type(value) == "number","Bad argument @dxProgressBarSetUpDownDistance at argument 2, expect number got "..type(value))
	assert(type(relative) == "boolean","Bad argument @dxProgressBarSetUpDownDistance at argument 3, expect boolean got "..type(relative))
	return emSetData(gui,"udspace",{value,relative})
end

function dxProgressBarSetLeftRightDistance(gui,value,relative)
	assert(dxGetType(gui) == "dgs-dxprogressbar","Bad argument @dxProgressBarSetLeftRightDistance at argument 1, expect dgs-dxprogressbar got "..(dxGetType(gui) or type(gui)))
	assert(type(value) == "number","Bad argument @dxProgressBarSetLeftRightDistance at argument 2, expect number got "..type(value))
	assert(type(relative) == "boolean","Bad argument @dxProgressBarSetLeftRightDistance at argument 3, expect boolean got "..type(relative))
	return emSetData(gui,"lrspace",{value,relative})
end
