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

scrollBarSettings = {}
scrollBarSettings.arrow = "image/scrollbar/scrollbar_arrow.png"

function dxCreateScrollBar(x, y, sx, sy, voh, relative, parent, img1, imgmid, imgcursor, colorn1, colornmid, colorncursor, colore1, colorecursor, colorc1, colorccursor)
	if isElement(parent) then
		assert(emIsDxElement(parent),"Bad argument @dxCreateScrollBar at argument 7, expect dgs-dxgui got "..dxGetType(parent))
	end
	local scrollbar = createElement("dgs-dxscrollbar")
	dgsSetType(scrollbar,"dgs-dxscrollbar")
	emSetData(scrollbar,"imgs",{img1 or scrollBarSettings.arrow,imgcursor,imgmid})
	emSetData(scrollbar,"colorn",{colorn1 or schemeColor.scrollbar.colorn[1],colorncursor or schemeColor.scrollbar.colorn[2],colornmid or schemeColor.scrollbar.colorn[3]})
	emSetData(scrollbar,"colore",{colore1 or schemeColor.scrollbar.colore[1],colorecursor or schemeColor.scrollbar.colore[2]})
	emSetData(scrollbar,"colorc",{colorc1 or schemeColor.scrollbar.colorc[1],colorccursor or schemeColor.scrollbar.colorc[2]})
	emSetData(scrollbar,"voh",voh or false)
	emSetData(scrollbar,"position",0)
	emSetData(scrollbar,"length",{30,false},true)
	emSetData(scrollbar,"multiplier",{1,false})
	emSetData(scrollbar,"scrollmultiplier",{12,false})
	emSetData(scrollbar,"scrollArrow",true)
	if isElement(parent) then
		dxSetParent(scrollbar,parent)
	else
		table.insert(MaxFatherTable,scrollbar)
	end
	triggerEvent("onDgsPreCreate",scrollbar)
	calculateGuiPositionSize(scrollbar,x,y,relative or false,sx,sy,relative or false,true)
	triggerEvent("onDgsCreate",scrollbar)
	return scrollbar
end

function dxScrollBarSetScrollBarPosition(scrollbar,pos)
	assert(dxGetType(scrollbar) == "dgs-dxscrollbar","Bad argument @dgsSetScrollBarPosition at argument at 1, expect dgs-dxscrollbar got "..tostring(dxGetType(scrollbar) or type(scrollbar)))
	assert(type(pos) == "number","Bad argument @dgsSetScrollBarPosition at argument at 2, expect number got "..type(pos))
	emSetData(scrollbar,"position",pos)
end

function dxScrollBarGetScrollBarPosition(scrollbar)
	assert(dxGetType(scrollbar) == "dgs-dxscrollbar","Bad argument @dgsGetScrollBarPosition at argument at 1, expect dgs-dxscrollbar got "..tostring(dxGetType(scrollbar) or type(scrollbar)))
	return emGetData(scrollbar,"position")
end

function dxScrollBarSetColor(scrollbar,colorn1,colorncursor,colornmid,colore1,colorecursor,colorc1,colorccursor)
	assert(dxGetType(scrollbar) == "dgs-dxscrollbar","Bad argument @dxScrollBarSetColor at argument at 1, expect dgs-dxscrollbar got "..tostring(dxGetType(scrollbar) or type(scrollbar)))
	local colorn = emGetData(scrollbar,"colorn")
	local colore = emGetData(scrollbar,"colore")
	local colorc = emGetData(scrollbar,"colorc")
	colorn[1] = colorn1 or colorn[1]
	colorn[2] = colorncursor or colorn[2]
	colorn[3] = colornmid or colorn[3]
	colore[1] = colore1 or colore[1]
	colore[2] = colorecursor or colore[2]
	colorc[1] = colorc1 or colorc[1]
	colorc[2] = colorccursor or colorc[2]
	return true
end