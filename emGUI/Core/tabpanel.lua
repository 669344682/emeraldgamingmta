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

function dxCreateTabPanel(x, y, sx, sy, relative, parent, tabheight, defbgcolor)
	if isElement(parent) then
		assert(emIsDxElement(parent),"Bad argument @dxCreateTabPanel at argument 6, expect dgs-dxgui got "..dxGetType(parent))
	end
	assert(tonumber(x),"Bad argument @dxCreateTabPanel at argument 1, expect number got "..type(x))
	assert(tonumber(y),"Bad argument @dxCreateTabPanel at argument 2, expect number got "..type(y))
	assert(tonumber(sx),"Bad argument @dxCreateTabPanel at argument 3, expect number got "..type(sx))
	assert(tonumber(sy),"Bad argument @dxCreateTabPanel at argument 4, expect number got "..type(sy))
	local tabpanel = createElement("dgs-dxtabpanel")
	dgsSetType(tabpanel,"dgs-dxtabpanel")
	if isElement(parent) then
		dxSetParent(tabpanel,parent)
	else
		table.insert(MaxFatherTable,tabpanel)
	end
	emSetData(tabpanel,"tabheight",{tabheight or 20,false})
	emSetData(tabpanel,"tabmaxwidth",{10000,false})
	emSetData(tabpanel,"tabminwidth",{10,false})
	emSetData(tabpanel,"font",tabsFont)
	emSetData(tabpanel,"defbackground", tonumber(defbgcolor) or schemeColor.tabpanel.defbackground)
	emSetData(tabpanel,"tabs",{})
	emSetData(tabpanel,"selected",-1)
	emSetData(tabpanel,"preSelect",-1)
	emSetData(tabpanel,"tabsidesize",{6,false},true)
	emSetData(tabpanel,"tabgapsize",{2,false},true)
	emSetData(tabpanel,"scrollSpeed",{10,false})
	emSetData(tabpanel,"taboffperc",0)
	emSetData(tabpanel,"allleng",0)
	insertResourceDxGUI(sourceResource,tabpanel)
	triggerEvent("onDgsPreCreate",tabpanel)
	calculateGuiPositionSize(tabpanel,x,y,relative,sx,sy,relative,true)
	local abx,aby = unpack(emGetData(tabpanel,"absSize"))
	local rendertarget = dxCreateRenderTarget(abx,tabheight or 20,true)
	emSetData(tabpanel,"renderTarget",rendertarget)
	triggerEvent("onDgsCreate",tabpanel)
	return tabpanel
end

function dxCreateTab(text,tabpanel,textsizex,textsizey,textcolor,bgimg,bgcolor,tabdefimg,tabselimg,tabcliimg,tabdefcolor,tabselcolor,tabclicolor)
	assert(type(text) == "string" or type(text) == "number","Bad argument @dxCreateTab at argument 1, expect string/number got "..type(text))
	assert(dxGetType(tabpanel) == "dgs-dxtabpanel","Bad argument @dxCreateTab at argument 2, expect dgs-dxtabpanel got "..(dxGetType(tabpanel) or type(tabpanel)))
	local tab = createElement("dgs-dxtab")
	dgsSetType(tab,"dgs-dxtab")
	emSetData(tab, "text", text, true)
	emSetData(tab,"parent",tabpanel)
	local tabs = dgsElementData[tabpanel].tabs
	local id = #tabs+1
	table.insert(tabs,id,tab)
	emSetData(tab,"id",id)
	local wh = dgsElementData[tabpanel].absSize
	local w,h = wh[1], wh[2]
	local font = dgsElementData[tabpanel]["font"]
	local minwidth = dgsElementData[tabpanel]["tabminwidth"][2] and dgsElementData[tabpanel]["tabminwidth"][1]*w or dgsElementData[tabpanel]["tabminwidth"][1]
	local maxwidth = dgsElementData[tabpanel]["tabmaxwidth"][2] and dgsElementData[tabpanel]["tabmaxwidth"][1]*w or dgsElementData[tabpanel]["tabmaxwidth"][1]
	local wid = math.min(math.max(dxGetTextWidth(text,textsizex or 1,font),minwidth),maxwidth)
	local tabsidesize = dgsElementData[tabpanel]["tabsidesize"][2] and dgsElementData[tabpanel]["tabsidesize"][1]*w or dgsElementData[tabpanel]["tabsidesize"][1]
	local gap = dgsElementData[tabpanel]["tabgapsize"][2] and dgsElementData[tabpanel]["tabgapsize"][1]*w or dgsElementData[tabpanel]["tabgapsize"][1]
	emSetData(tabpanel,"allleng",dgsElementData[tabpanel]["allleng"]+wid+tabsidesize*2+gap*math.min(#tabs,1))
	emSetData(tab,"width",wid,true)
	emSetData(tab,"absrltWidth",{-1,false},false)
	emSetData(tab,"textcolor",tonumber(textcolor) or schemeColor.tab.textcolor)
	emSetData(tab,"textsize",{textsizex or 1,textsizey or 1})
	emSetData(tab,"bgcolor",tonumber(bgcolor) or schemeColor.tab.bgcolor)
	emSetData(tab,"bgimg",bgimg or nil)
	emSetData(tab,"tabimg",{tabdefimg,tabselimg,tabcliimg})
	emSetData(tab,"tabcolor",{tonumber(tabdefcolor) or schemeColor.tab.tabcolor[1],tonumber(tabselcolor) or schemeColor.tab.tabcolor[2],tonumber(tabclicolor) or schemeColor.tab.tabcolor[3]})
	insertResourceDxGUI(sourceResource,tabpanel)
	triggerEvent("onDgsPreCreate",tab)
	if dgsElementData[tabpanel]["selected"] == -1 then
		emSetData(tabpanel,"selected",id)
	end
	triggerEvent("onDgsCreate",tab)
	return tab
end

function dxTabPanelGetTabFromID(tabpanel,id)
	assert(dxGetType(tabpanel) == "dgs-dxtabpanel","Bad argument @dxTabPanelGetTabFromID at at argument 1, expect dgs-dxtabpanel got "..(dxGetType(tabpanel) or type(tabpanel)))
	assert(type(id) == "number","Bad argument @dxTabPanelGetTabFromID at at argument 2, expect number got "..type(id))
	local tabs = dgsElementData[tabpanel]["tabs"]
	return tabs[id]
end

function dxTabPanelMoveTab(tabpanel,from,to)
	assert(dxGetType(tabpanel) == "dgs-dxtabpanel","Bad argument @dxTabPanelMoveTab at at argument 1, expect dgs-dxtabpanel got "..(dxGetType(tabpanel) or type(tabpanel)))
	assert(type(from) == "number","Bad argument @dxTabPanelMoveTab at at argument 2, expect number got "..type(from))
	assert(type(to) == "number","Bad argument @dxTabPanelMoveTab at at argument 3, expect number got "..type(to))
	local tab = dgsElementData[tabpanel]["tabs"][from]
	local myid = dgsElementData[tab].id
	local parent = dgsElementData[tab].parent
	local tabs = dgsElementData[parent].tabs
	for i=myid+1,#tabs do
		dgsElementData[tabs[i]].id = dgsElementData[tabs[i]].id-1
	end
	table.remove(tabs,myid)
	for i=to,#tabs do
		dgsElementData[tabs[i]].id = dgsElementData[tabs[i]].id+1
	end
	table.insert(tabs,to,tab)
	return true
end

function dxTabPanelGetTabID(tab)
	assert(dxGetType(tab) == "dgs-dxtab","Bad argument @dxTabPanelGetTabID at at argument 1, expect dgs-dxtab got "..(dxGetType(tab) or type(tab)))
	return dgsElementData[tab].id
end

function dxDeleteTab(tab)
	assert(dxGetType(tab) == "dgs-dxtab","Bad argument @dxDeleteTab at at argument 1, expect dgs-dxtab got "..(dxGetType(tab) or type(tab)))
	local tabpanel = emGetData(tab,"parent")
	if dxGetType(tabpanel) == "dgs-dxtabpanel" then
		local wid = dgsElementData[tab]["width"]
		local tabs = dgsElementData[tabpanel].tabs
		local tabsidesize = dgsElementData[tabpanel]["tabsidesize"][2] and dgsElementData[tabpanel]["tabsidesize"][1]*w or dgsElementData[tabpanel]["tabsidesize"][1]
		local gap = dgsElementData[tabpanel]["tabgapsize"][2] and dgsElementData[tabpanel]["tabgapsize"][1]*w or dgsElementData[tabpanel]["tabgapsize"][1]
		emSetData(tabpanel,"allleng",dgsElementData[tabpanel]["allleng"]-wid-tabsidesize*2-gap*math.min(#tabs,1))
		local id = emGetData(tab,"id")
		for i=id,#tabs do
			dgsElementData[tabs[i]].id = dgsElementData[tabs[i]].id-1
		end
		table.remove(tabs,id)
	end
	for k,v in pairs(dxGetChildren(tab)) do
		destroyElement(v)
	end
	destroyElement(tab)
	return true
end

function configTabPanel(source)
	local sx,sy = unpack(emGetData(source,"absSize"))
	local sx,sy = dgsElementData[source].absSize[1],dgsElementData[source].absSize[2]
	local tabHeight = emGetData(source,"tabheight")
	local tabHeight = dgsElementData[source].tabheight
	local rentarg = emGetData(source,"renderTarget")
	local rentarg = dgsElementData[source].renderTarget
	if isElement(rentarg[1]) then
		if isElement(rentarg[1]) then
			destroyElement(rentarg[1])
			destroyElement(rentarg[1])
		end	
	end
	local tabRender = dxCreateRenderTarget(sx,tabHeight[2] and tabHeight[1]*sy or tabHeight[1],true)
	local tabRender = dxCreateRenderTarget(sx,tabHeight[2] and tabHeight[1]*sy or tabHeight[1],true)
	emSetData(source,"renderTarget",tabRender)
	emSetData(source,"renderTarget",tabRender)
end

function dxGetSelectedTab(tabpanel,useNumber)
	assert(dxGetType(tabpanel) == "dgs-dxtabpanel","Bad argument @dgsGetSelectedTab at at argument 1, expect dgs-dxtabpanel got "..dxGetType(tabpanel))
	local id = dgsElementData[tabpanel].selected
	local tabs = dgsElementData[tabpanel].tabs
	if useNumber then
		return id
	else
		return tabs[id] or false
	end
end

function dxSetSelectedTab(tabpanel,id)
	assert(dxGetType(tabpanel) == "dgs-dxtabpanel","Bad argument @dgsSetSelectedTab at at argument 1, expect dgs-dxtabpanel got "..dxGetType(tabpanel))
	local idtype = dxGetType(id)
	assert(idtype == "number" or idtype == "dgs-dxtab","Bad argument @dgsSetSelectedTab at at argument 2, expect number/dgs-dxtab got "..idtype)
	local tabs = dgsElementData[tabpanel].tabs
	id = idtype == "dgs-dxtab" and dgsElementData[id].id or id
	if id >= 1 and id <= #tabs then
		return emSetData(tabpanel,"selected",id)
	end
	return false
end