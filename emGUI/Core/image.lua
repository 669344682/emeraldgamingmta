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

function dxCreateImage(x, y, sx, sy, img, relative, parent, color)
	assert(tonumber(x),"Bad argument @dxCreateImage at argument 1, expect number got "..type(x))
	assert(tonumber(y),"Bad argument @dxCreateImage at argument 2, expect number got "..type(y))
	assert(tonumber(sx),"Bad argument @dxCreateImage at argument 3, expect number got "..type(sx))
	assert(tonumber(sy),"Bad argument @dxCreateImage at argument 4, expect number got "..type(sy))
	if isElement(parent) then
		assert(emIsDxElement(parent),"Bad argument @dxCreateImage at argument 7, expect dgs-dxgui got "..dxGetType(parent))
	end
	local image = createElement("dgs-dximage")
	dgsSetType(image,"dgs-dximage")
	local texture = img
	if type(img) == "string" then
		texture = dxCreateTexture(img)
		if not isElement(texture) then return false end
	end
	emSetData(image,"image",texture)
	emSetData(image,"color",color or tocolor(255,255,255,255))
	emSetData(image,"sideColor",tocolor(255,255,255,255))
	emSetData(image,"sideState","in") --in/out/center
	emSetData(image,"sideSize",0)
	emSetData(image,"rotationCenter",{0,0}) --0~1
	emSetData(image,"rotation",0) --0~360
	if isElement(parent) then
		dxSetParent(image,parent)
	else
		table.insert(MaxFatherTable,image)
	end
	insertResourceDxGUI(sourceResource,image)
	triggerEvent("onDgsPreCreate",image)
	calculateGuiPositionSize(image,x,y,relative or false,sx,sy,relative or false,true)
	local mx,my = false,false
	if isElement(texture) and not getElementType(texture) == "shader" then
		mx,my = dxGetMaterialSize(texture)
	end
	emSetData(image,"imagesize",{mx,my})
	emSetData(image,"imagepos",{0,0})
	triggerEvent("onDgsCreate",image)
	return image
end

function dxImageGetImage(gui)
	assert(dxGetType(gui) == "dgs-dximage","Bad argument @dxImageGetImage at argument 1, expect dgs-dximage got "..(dxGetType(gui) or type(gui)))
	return dgsElementData[gui].image
end

function dxImageSetImage(gui, img)
	assert(dxGetType(gui) == "dgs-dximage","Bad argument @dxImageSetImage at argument 1, expect dgs-dximage got "..(dxGetType(gui) or type(gui)))
	return emSetData(gui,"image",img)
end

function dxImageSetImageSize(gui, sx, sy)
	assert(dxGetType(gui) == "dgs-dximage","Bad argument @dxImageSetImageSize at argument 1, expect dgs-dximage got "..(dxGetType(gui) or type(gui)))
	local texture = emSetData(gui,"image")
	local mx,my = dxGetMaterialSize(texture)
	sx = tonumber(sx) or mx
	sy = tonumber(sy) or my
	return emSetData(gui,"imagesize",{sx,sy})
end

function dxImageGetImageSize(gui)
	assert(dxGetType(gui) == "dgs-dximage","Bad argument @dxImageGetImageSize at argument 1, expect dgs-dximage got "..(dxGetType(gui) or type(gui)))
	return dgsElementData[gui].imagesize[1],dgsElementData[gui].imagesize[2]
end

function dxImageSetImagePosition(gui, x, y)
	assert(dxGetType(gui) == "dgs-dximage","Bad argument @dxImageSetImagePosition at argument 1, expect dgs-dximage got "..(dxGetType(gui) or type(gui)))
	x = tonumber(x) or 0
	y = tonumber(y) or 0
	return emSetData(gui,"imagepos",{x,y})
end

function dxImageGetImagePosition(gui, x, y)
	assert(dxGetType(gui) == "dgs-dximage","Bad argument @dxImageGetImagePosition at argument 1, expect dgs-dximage got "..(dxGetType(gui) or type(gui)))
	return dgsElementData[gui].imagepos[1],dgsElementData[gui].imagepos[2]
end

function dxImageSetColor(gui, r, g, b, a)
	assert(dxGetType(gui) == "dgs-dximage","Bad argument @dxImageSetColor at argument 1, expect dgs-dximage got "..(dxGetType(gui) or type(gui)))
	r = tonumber(r) or 255
	g = tonumber(g) or 255
	b = tonumber(b) or 255
	a = tonumber(a) or 255
	return emSetData(gui,"color", tocolor(r,g,b,a))
end