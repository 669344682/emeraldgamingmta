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

function dxCreateLabel(x, y, sx, sy, text, relative, parent, textcolor, scalex, scaley, shadowoffsetx, shadowoffsety, shadowcolor, right, bottom)
	assert(tonumber(x),"Bad argument @dxCreateLabel at argument 1, expect number got "..type(x))
	assert(tonumber(y),"Bad argument @dxCreateLabel at argument 2, expect number got "..type(y))
	assert(tonumber(sx),"Bad argument @dxCreateLabel at argument 3, expect number got "..type(sx))
	assert(tonumber(sy),"Bad argument @dxCreateLabel at argument 4, expect number got "..type(sy))
	if isElement(parent) then
		assert(emIsDxElement(parent),"Bad argument @dxCreateLabel at argument 7, expect dgs-dxgui got "..dxGetType(parent))
	end
	local label = createElement("dgs-dxlabel")
	local _ = emIsDxElement(parent) and dxSetParent(label,parent,true) or table.insert(MaxFatherTable,1,label)
	dgsSetType(label,"dgs-dxlabel")
	emSetData(label,"text",tostring(text))
	emSetData(label,"textcolor",textcolor or tocolor(255,255,255,255))
	emSetData(label,"textsize",{scalex or 1,scaley or 1})
	emSetData(label,"clip",false)
	emSetData(label,"wordbreak",false)
	emSetData(label,"colorcoded",false)
	emSetData(label,"shadow",{shadowoffsetx,shadowoffsety,shadowcolor})
	emSetData(label,"rightbottom",{right or "left",bottom or "top"})
	emSetData(label,"font", labelFont)
	insertResourceDxGUI(sourceResource,label)
	triggerEvent("onDgsPreCreate",label)
	calculateGuiPositionSize(label,x,y,relative or false,sx,sy,relative or false,true)
	triggerEvent("onDgsCreate",label)
	return label
end

function dxLabelSetColor(label, r, g, b, a)
	assert(dxGetType(label) == "dgs-dxlabel","Bad argument @dxLabelSetColor at at argument 1, except a dgs-dxlabel got "..(dxGetType(label) or type(label)))
	if tonumber(r) and g == true then
		return emSetData(label,"textcolor",r)
	else
		local _r,_g,_b,_a = fromcolor(dgsElementData[label].textcolor)
		return emSetData(label,"textcolor",tocolor(r or _r,g or _g,b or _b,a or _a))
	end
end

function dxLabelGetColor(label, notSplit)
	assert(dxGetType(label) == "dgs-dxlabel","Bad argument @dxLabelGetColor at at argument 1, except a dgs-dxlabel got "..(dxGetType(label) or type(label)))
	return notSplit and dgsElementData[label].textcolor or fromcolor(dgsElementData[label].textcolor)
end

local HorizontalAlign = {}
HorizontalAlign.left = true
HorizontalAlign.center = true
HorizontalAlign.right = true
local VerticalAlign = {}
VerticalAlign.top = true
VerticalAlign.center = true
VerticalAlign.bottom = true

function dxLabelSetHorizontalAlign(label, align)
	assert(dxGetType(label) == "dgs-dxlabel","Bad argument @dxLabelSetHorizontalAlign at at argument 1, except a dgs-dxlabel got "..(dxGetType(label) or type(label)))
	assert(HorizontalAlign[align],"Bad argument @dxLabelSetHorizontalAlign at at argument 2, except a string [left/center/right], got"..tostring(align))
	local rightbottom = dgsElementData[label].rightbottom
	return emSetData(label,"rightbottom",{align,rightbottom[2]})
end

function dxLabelSetVerticalAlign(label, align)
	assert(dxGetType(label) == "dgs-dxlabel","Bad argument @dxLabelSetVerticalAlign at at argument 1, except a dgs-dxlabel got "..(dxGetType(label) or type(label)))
	assert(VerticalAlign[align],"Bad argument @dxLabelSetVerticalAlign at at argument 2, except a string [top/center/bottom], got"..tostring(align))
	local rightbottom = dgsElementData[label].rightbottom
	return emSetData(label,"rightbottom",{rightbottom[1],align})
end

function dxLabelGetHorizontalAlign(label)
	assert(dxGetType(label) == "dgs-dxlabel","Bad argument @dxLabelGetHorizontalAlign at at argument 1, except a dgs-dxlabel got "..(dxGetType(label) or type(label)))
	local rightbottom = dgsElementData[label].rightbottom
	return rightbottom[1]
end

function dxLabelGetVerticalAlign(label)
	assert(dxGetType(label) == "dgs-dxlabel","Bad argument @dxLabelGetVerticalAlign at at argument 1, except a dgs-dxlabel got "..(dxGetType(label) or type(label)))
	local rightbottom = dgsElementData[label].rightbottom
	return rightbottom[2]
end