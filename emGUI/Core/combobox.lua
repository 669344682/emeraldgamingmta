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

--[[
	[Item List Structure]

	table = {
	index:	-2			-1					0					1
			TextColor	BackGround Image	BackGround Color	Text	
		{	color,		{def, hov, sel},	{def, hov, sel},	text},
		{	color,		{def, hov, sel},	{def, hov, sel},	text},
		{	color,		{def, hov, sel},	{def, hov, sel},	text},
		{	color,		{def, hov, sel},	{def, hov, sel},	text},
		{	color,		{def, hov, sel},	{def, hov, sel},	text},
		{	color,		{def, hov, sel},	{def, hov, sel},	text},
		{	color,		{def, hov, sel},	{def, hov, sel},	text},
		{	...															},
	}
]]

function dxCreateComboBox(x, y, sx, sy, relative, parent, itemheight, textcolor, scalex, scaley, defimg, hovimg, cliimg, defcolor, hovcolor, clicolor)
	assert(tonumber(x),"Bad argument @dxCreateComboBox at argument 1, expect number got "..type(x))
	assert(tonumber(y),"Bad argument @dxCreateComboBox at argument 2, expect number got "..type(y))
	assert(tonumber(sx),"Bad argument @dxCreateComboBox at argument 3, expect number got "..type(sx))
	assert(tonumber(sy),"Bad argument @dxCreateComboBox at argument 4, expect number got "..type(sy))
	if isElement(parent) then
		assert(emIsDxElement(parent),"Bad argument @dxCreateComboBox at argument 6, expect dgs-dxgui got "..dxGetType(parent))
	end
	local combobox = createElement("dgs-dxcombobox")
	dgsSetType(combobox,"dgs-dxcombobox")
	local _x = emIsDxElement(parent) and dxSetParent(combobox,parent,true) or table.insert(MaxFatherTable,1,combobox)
	defcolor,hovcolor,clicolor = defcolor or schemeColor.combobox.color[1],hovcolor or schemeColor.combobox.color[2],clicolor or schemeColor.combobox.color[3]
	emSetData(combobox,"image",{defimg,hovimg,cliimg})
	emSetData(combobox,"color",{defcolor,hovcolor,clicolor})
	emSetData(combobox,"textcolor",textcolor or schemeColor.combobox.textcolor)
	emSetData(combobox,"textsize",{tonumber(scalex) or 1,tonumber(scaley) or 1})
	emSetData(combobox,"listtextcolor",textcolor or schemeColor.combobox.listtextcolor)
	emSetData(combobox,"listtextsize",{tonumber(scalex) or 1,tonumber(scaley) or 1})
	emSetData(combobox,"shadow",false)
	emSetData(combobox,"font",systemFont)
	emSetData(combobox,"combobgColor",schemeColor.combobox.combobgColor)
	emSetData(combobox,"combobgImage",nil)
	emSetData(combobox,"buttonLen",{1,true}) --height
	emSetData(combobox,"textbox",true) --enable textbox
	emSetData(combobox,"select",-1)
	emSetData(combobox,"clip",false)
	emSetData(combobox,"wordbreak",false)
	emSetData(combobox,"itemHeight",itemheight or 20)
	emSetData(combobox,"colorcoded",false)
	emSetData(combobox,"itemColor",{idefcolor or schemeColor.combobox.itemColor[1],ihovcolor or schemeColor.combobox.itemColor[2],iselcolor or schemeColor.combobox.itemColor[3]})
	emSetData(combobox,"itemImage",{idefimg,ihovimg,iselimg})
	emSetData(combobox,"listState",-1,true)
	emSetData(combobox,"listStateAnim",-1)
	emSetData(combobox,"combo_BoxTextSide",{5,5})
	emSetData(combobox,"comboTextSide",{5,5})
	emSetData(combobox,"arrowColor",schemeColor.combobox.arrowColor)
	emSetData(combobox,"arrowSettings",{"height",0.15})
	emSetData(combobox,"arrowWidth",10)
	emSetData(combobox,"arrowDistance",0.6)
	emSetData(combobox,"arrowHeight",0.6)
	emSetData(combobox,"arrowOutSideColor",schemeColor.combobox.arrowOutSideColor)
	emSetData(combobox,"scrollBarThick",20,true)
	emSetData(combobox,"itemData",{})
	emSetData(combobox,"rightbottom",{"left","center"})
	emSetData(combobox,"rightbottomList",{"left","center"})
	emSetData(combobox,"FromTo",{0,0})
	emSetData(combobox,"itemMoveOffset",0)
	emSetData(combobox,"scrollFloor",true)
	local shader = dxCreateShader("image/combobox/arrow.fx")
	emSetData(combobox,"arrow",shader)
	insertResourceDxGUI(sourceResource,combobox)
	triggerEvent("onDgsPreCreate",combobox)
	calculateGuiPositionSize(combobox,x,y,relative or false,sx,sy,relative or false,true)
	local box = dgsComboBoxCreateBox(0,1,1,3,true,combobox)
	emSetData(combobox,"myBox",box)
	emSetData(box,"myCombo",combobox)
	local boxsiz = dgsElementData[box].absSize
	local rendertarget = dxCreateRenderTarget(boxsiz[1],boxsiz[2],true)
	emSetData(combobox,"renderTarget",rendertarget)
	local scrollbar = dxCreateScrollBar(boxsiz[1]-20,0,20,boxsiz[2],false,false,box)
	emSetData(scrollbar,"length",{0,true})
	dxSetVisible(scrollbar,false)
	dxSetVisible(box,false)
	emSetData(combobox,"scrollbar",scrollbar)
	triggerEvent("onDgsCreate",combobox)
	emSetData(combobox,"hitoutofparent",true)
	return combobox
end

function dxComboBoxSetBoxHeight(combobox,height,relative)
	assert(dxGetType(combobox) == "dgs-dxcombobox","Bad argument @dxComboBoxSetBoxHeight at argument 1, expect dgs-dxcombobox got "..dxGetType(combobox))
	assert(type(height) == "number","Bad argument @dxComboBoxSetBoxHeight at argument 2, expect number got "..type(height))
	relative = relative and true or false
	local box = dgsElementData[combobox].myBox
	if isElement(box) then
		local size = relative and dgsElementData[box].rltSize or dgsElementData[box].absSize
		return dxSetSize(box,size[1],height,relative)
	end
	return false
end

function dxComboBoxGetBoxHeight(combobox,relative)
	assert(dxGetType(combobox) == "dgs-dxcombobox","Bad argument @dxComboBoxGetBoxHeight at argument 1, expect dgs-dxcombobox got "..dxGetType(combobox))
	relative = relative and true or false
	local box = dgsElementData[combobox].myBox
	if isElement(box) then
		local size = relative and dgsElementData[box].rltSize or dgsElementData[box].absSize
		return size[2]
	end
	return false
end

function dxComboBoxAddItem(combobox,text)
	assert(dxGetType(combobox) == "dgs-dxcombobox","Bad argument @dxComboBoxAddItem at argument 1, expect dgs-dxcombobox got "..dxGetType(combobox))
	assert(type(text) == "string" or type(text) == "number","Bad argument @dxComboBoxAddItem at argument 2, expect number/string got "..type(text))
	local data = dgsElementData[combobox].itemData
	local itemHeight = dgsElementData[combobox].itemHeight
	local box = dgsElementData[combobox].myBox
	local size = dgsElementData[box].absSize
	local id = #data+1
	local tab = {}
	tab[-2] = dgsElementData[combobox].listtextcolor
	tab[-1] = dgsElementData[combobox].itemImage
	tab[0] = dgsElementData[combobox].itemColor
	tab[1] = text
	table.insert(data,id,tab)
	if id*itemHeight > size[2] then
		local scrollBar = dgsElementData[combobox].scrollbar
		dxSetVisible(scrollBar,true)
	end
	return id
end

function dxComboBoxSetItemText(combobox,item,text)
	assert(dxGetType(combobox) == "dgs-dxcombobox","Bad argument @dxComboBoxSetItemText at argument 1, expect dgs-dxcombobox got "..dxGetType(combobox))
	assert(type(item) == "number","Bad argument @dxComboBoxSetItemText at argument 2, expect number got "..type(item))
	assert(type(text) == "string" or type(text) == "number","Bad argument @dxComboBoxSetItemText at argument 3, expect number/string got "..type(text))
	local data = dgsElementData[combobox].itemData
	item = math.floor(item)
	if item >= 1 and item <= #data then
		data[item][1] = text
		return true
	end
	return false
end

function dxComboBoxGetItemText(combobox,item)
	assert(dxGetType(combobox) == "dgs-dxcombobox","Bad argument @dxComboBoxGetItemText at argument 1, expect dgs-dxcombobox got "..dxGetType(combobox))
	assert(tonumber(item),"Bad argument @dxComboBoxGetItemText at argument 2, expect number got "..type(item))
	local data = dgsElementData[combobox].itemData
	local item = tonumber(item)
	local item = math.floor(item)
	if item >= 1 and item <= #data then
		return data[item][1]
	end
	return false
end

function dxComboBoxSetItemColor(combobox,item,color)
	assert(dxGetType(combobox) == "dgs-dxcombobox","Bad argument @dxComboBoxSetItemColor at argument 1, expect dgs-dxcombobox got "..dxGetType(combobox))
	assert(type(item) == "number","Bad argument @dxComboBoxSetItemColor at argument 2, expect number got "..type(item))
	assert(type(color) == "number" or type(color) == "number","Bad argument @dxComboBoxSetItemColor at argument 3, expect number/string got "..type(color))
	local data = dgsElementData[combobox].itemData
	item = math.floor(item)
	if item >= 1 and item <= #data then
		data[item][-2] = color
		return true
	end
	return false
end

function dxComboBoxSetState(combobox,state)
	assert(dxGetType(combobox) == "dgs-dxcombobox","Bad argument @dxComboBoxSetState at argument 1, expect dgs-dxcombobox got "..dxGetType(combobox))
	return emSetData(combobox,"listState",state and 1 or -1)
end

function dxComboBoxGetState(combobox)
	assert(dxGetType(combobox) == "dgs-dxcombobox","Bad argument @dxComboBoxGetState at argument 1, expect dgs-dxcombobox got "..dxGetType(combobox))
	return dgsElementData[combobox].listState == 1 and true or false
end

function dxComboBoxGetItemColor(combobox,item)
	assert(dxGetType(combobox) == "dgs-dxcombobox","Bad argument @dxComboBoxGetItemColor at argument 1, expect dgs-dxcombobox got "..dxGetType(combobox))
	assert(type(item) == "number","@dxComboBoxGetItemColor argument 2,expect number got "..type(item))
	local data = dgsElementData[combobox].itemData
	item = math.floor(item)
	if item >= 1 and item <= #data then
		return data[item][-2]
	end
	return false
end

function dxComboBoxRemoveItem(combobox,item)
	assert(dxGetType(combobox) == "dgs-dxcombobox","Bad argument @dxComboBoxRemoveItem at argument 1, expect dgs-dxcombobox got "..dxGetType(combobox))
	assert(tonumber(item),"Bad argument @dxComboBoxRemoveItem at argument 2, expect number got "..type(item))
	local data = dgsElementData[combobox].itemData
	local item = tonumber(item)
	local item = math.floor(item)
	if item >= 1 and item <= #data then
		table.remove(data,item)
		local itemHeight = dgsElementData[combobox].itemHeight
		local box = dgsElementData[combobox].myBox
		local size = dgsElementData[box].absSize
		if #data*itemHeight < size[2] then
			local scrollBar = dgsElementData[combobox].scrollbar
			dxSetVisible(scrollBar,false)
		end
		return true
	end
	return false
end

function dxComboBoxClear(combobox)
	assert(dxGetType(combobox) == "dgs-dxcombobox","Bad argument @dxComboBoxClear at argument 1, expect dgs-dxcombobox got "..dxGetType(combobox))
	local data = dgsElementData[combobox].itemData
	table.remove(data)
	dgsElementData[combobox].itemData = {}
	local scrollBar = dgsElementData[combobox].scrollbar
	dxSetVisible(scrollBar,false)
	return true
end

function dgsComboBoxCreateBox(x,y,sx,sy,relative,parent)
	assert(tonumber(x),"Bad argument @dgsComboBoxCreateBox at argument 1, expect number got "..type(x))
	assert(tonumber(y),"Bad argument @dgsComboBoxCreateBox at argument 2, expect number got "..type(y))
	assert(tonumber(sx),"Bad argument @dgsComboBoxCreateBox at argument 3, expect number got "..type(sx))
	assert(tonumber(sy),"Bad argument @dgsComboBoxCreateBox at argument 4, expect number got "..type(sy))
	assert(dxGetType(parent) == "dgs-dxcombobox","Bad argument @dgsComboBoxCreateBox at argument 6, expect dgs-dxcombobox got "..dxGetType(parent))
	local box = createElement("dgs-dxcombobox-Box")
	local _x = emIsDxElement(parent) and dxSetParent(box,parent,true) or table.insert(MaxFatherTable,1,box)
	dgsSetType(box,"dgs-dxcombobox-Box")	
	insertResourceDxGUI(sourceResource,box)
	triggerEvent("onDgsPreCreate",box)
	calculateGuiPositionSize(box,x,y,relative or false,sx,sy,relative or false,true)
	triggerEvent("onDgsCreate",box)
	return box
end

function dxComboBoxSetSelectedItem(combobox,id)
	assert(dxGetType(combobox) == "dgs-dxcombobox","Bad argument @dxComboBoxSetSelectedItem at argument 1, expect dgs-dxcombobox got "..dxGetType(combobox))
	local itemData = dgsElementData[combobox].itemData
	local old = dgsElementData[combobox].select
	if not id or id == -1 then
		emSetData(combobox,"select",-1)
		triggerEvent("onDgsComboBoxSelect",combobox,old,-1)
		return true
	elseif id >= 1 and id <= #itemData then
		emSetData(combobox,"select",id)
		triggerEvent("onDgsComboBoxSelect",combobox,old,id)
		return true
	end
	return false
end

function dxComboBoxGetSelectedItem(combobox)
	assert(dxGetType(combobox) == "dgs-dxcombobox","Bad argument @dxComboBoxGetSelectedItem at argument 1, expect dgs-dxcombobox got "..dxGetType(combobox))
	local itemData = dgsElementData[combobox].itemData
	local selected = dgsElementData[combobox].select
	if selected < 1 and selected > #itemData then
		return -1
	else
		return selected
	end
end

function configComboBox_Box(box)
	local combobox = dgsElementData[box].myCombo
	local boxsiz = dgsElementData[box].absSize
	local rendertarget = dgsElementData[combobox].renderTarget
	if isElement(rendertarget) then
		destroyElement(rendertarget)
	end
	local sbt = dgsElementData[combobox].scrollBarThick
	local rendertarget = dxCreateRenderTarget(boxsiz[1],boxsiz[2],true)
	emSetData(combobox,"renderTarget",rendertarget)
	local sb = dgsElementData[combobox].scrollbar
	dxSetPosition(sb,boxsiz[1]-sbt,0,false)
	dxSetSize(sb,sbt,boxsiz[2],false)
end

addEventHandler("onDgsScrollBarScrollPositionChange",root,function(new,old)
	local parent = dxGetParent(source)
	if dxGetType(parent) == "dgs-dxcombobox-Box" then
		local combobox = dgsElementData[parent].myCombo
		local scrollBar = dgsElementData[combobox].scrollbar
		local sx,sy = unpack(dgsElementData[parent].absSize)
		if source == scrollBar then
			local itemLength = #dgsElementData[combobox].itemData*dgsElementData[combobox].itemHeight
			local temp = -new*(itemLength-sy)/100
			local temp = dgsElementData[combobox].scrollFloor and math.floor(temp) or temp 
			emSetData(combobox,"itemMoveOffset",temp)
		end
	end
end)

addEventHandler("onDgsComboBoxStateChange",root,function(state)
	if not wasEventCancelled() then
		local box = dgsElementData[source].myBox
		if state then
			dxSetVisible(box,true)
		else
			dxSetVisible(box,false)
		end
	end
end)

addEventHandler("onDgsMouseClick",root,function()
	
end)