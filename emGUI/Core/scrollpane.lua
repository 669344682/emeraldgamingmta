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

function dxCreateScrollPane(x, y, sx, sy, relative, parent)
	assert(tonumber(x), "Bad argument @dxCreateScrollPane at argument 1, expect number got " .. type(x))
	assert(tonumber(y), "Bad argument @dxCreateScrollPane at argument 2, expect number got " .. type(y))
	assert(tonumber(sx), "Bad argument @dxCreateScrollPane at argument 3, expect number got " .. type(sx))
	assert(tonumber(sy), "Bad argument @dxCreateScrollPane at argument 4, expect number got " .. type(sy))
	if isElement(parent) then
		assert(emIsDxElement(parent), "Bad argument @dxCreateScrollPane at argument 6, expect dgs-dxgui got ".. dxGetType(parent))
	end
	local scrollpane = createElement("dgs-dxscrollpane")
	local _ = emIsDxElement(parent) and dxSetParent(scrollpane, parent, true) or table.insert(MaxFatherTable, 1, scrollpane)
	dgsSetType(scrollpane, "dgs-dxscrollpane")
	emSetData(scrollpane, "scrollBarThick", 20, true)
	triggerEvent("onDgsPreCreate", scrollpane)
	calculateGuiPositionSize(scrollpane, x, y, relative or false, sx, sy, relative or false, true)
	local sx, sy = unpack(emGetData(scrollpane, "absSize"))
	local x, y = unpack(emGetData(scrollpane, "absPos"))
	local renderTarget = dxCreateRenderTarget(sx, sy, true)
	emSetData(scrollpane, "renderTarget_parent", renderTarget)
	emSetData(scrollpane, "maxChildSize", {0, 0})
	local scrbThick = 20
	local titleOffset = 0
	if isElement(parent) then
		if emGetData(scrollpane, "withoutTitle") then
			titleOffset = emGetData(parent,"titlesize") or 0
		end
	end
	local scrollbar1 = dxCreateScrollBar(x+sx-scrbThick,y-titleOffset,scrbThick,sy-scrbThick,false,false,parent)
	local scrollbar2 = dxCreateScrollBar(x,y+sy-scrbThick-titleOffset,sx-scrbThick,scrbThick,true,false,parent)
	dxSetVisible(scrollbar1,false)
	dxSetVisible(scrollbar2,false)
	emSetData(scrollbar1,"length",{0,true})
	emSetData(scrollbar2,"length",{0,true})
	emSetData(scrollpane,"scrollbars",{scrollbar1,scrollbar2})
	emSetData(scrollbar1,"parent_sp",scrollpane)
	emSetData(scrollbar2,"parent_sp",scrollpane)
	triggerEvent("onDgsCreate",scrollpane)
	return scrollpane
end

addEventHandler("onDgsCreate",root,function()
	local parent = dxGetParent(source)
	if isElement(parent) and dxGetType(parent) == "dgs-dxscrollpane" then
		local relativePos,relativeSize = unpack(emGetData(source,"relative"))
		local x,y,sx,sy
		if relativePos then
			x,y = unpack(emGetData(source,"rltPos"))
		end
		if relativeSize then
			sx,sy = unpack(emGetData(source,"rltSize"))
		end
		calculateGuiPositionSize(source,x,y,relativePos or _,sx,sy,relativeSize or _)
		local sx,sy = unpack(emGetData(source,"absSize"))
		local x,y = unpack(emGetData(source,"absPos"))
		local maxSize = emGetData(parent,"maxChildSize")
		local tempx,tempy = x+sx,y+sy
		local ntempx,ntempy
		if maxSize[1] <= tempx then
			ntempx = 0
			for k,v in ipairs(dxGetChildren(parent)) do
				local pos = emGetData(source,"absPos")
				local size = emGetData(source,"absSize")
				ntempx = ntempx > pos[1]+size[1] and ntempx or pos[1]+size[1]
			end
		end
		if maxSize[2] <= tempy then
			ntempy = 0
			for k,v in ipairs(dxGetChildren(parent)) do
				local pos = emGetData(source,"absPos")
				local size = emGetData(source,"absSize")
				ntempy = ntempy > pos[2]+size[2] and ntempy or pos[2]+size[2]	
			end
		end
		emSetData(parent,"maxChildSize",{ntempx or maxSize[1],ntempy or maxSize[2]})
		dgsScrollPaneUpdateScrollBar(parent,ntempx or maxSize[1],ntempy or maxSize[2])
		local renderTarget = emGetData(parent,"renderTarget_parent")
		if isElement(renderTarget) then
			destroyElement(renderTarget)
		end
		local scrbThick = emGetData(parent,"scrollBarThick")
		local scrollbar = emGetData(parent,"scrollbars")
		local xthick,ythick = 0,0
		if scrollbar then
			xthick = dxGetVisible(scrollbar[1]) and scrbThick or 0
			ythick = dxGetVisible(scrollbar[2]) and scrbThick or 0
		end
		local sx,sy = unpack(emGetData(parent,"absSize"))
		local renderTarget = dxCreateRenderTarget(sx-xthick,sy-ythick,true)
		emSetData(parent,"renderTarget_parent",renderTarget)
	end
end)

function dgsScrollPaneUpdateScrollBar(scrollpane,ntempx,ntempy)
	if dxGetType(scrollpane) == "dgs-dxscrollpane" then
		local scrollbar = emGetData(scrollpane,"scrollbars")
		if isElement(scrollbar[1]) and isElement(scrollbar[2]) then
			local ntmpx,ntmpy = unpack(emGetData(scrollpane,"maxChildSize"))
			ntempx,ntempy = ntempx or ntmpx,ntempy or ntmpy
			local sx,sy = unpack(emGetData(scrollpane,"absSize"))
			local scbstate = {dxGetVisible(scrollbar[1]),dxGetVisible(scrollbar[2])}
			local scbThick = emGetData(scrollpane,"scrollBarThick")
			local xthick,ythick = scbstate[1] and scbThick or 0,scbstate[2] and scbThick or 0
			
			if ntempx then
				if ntempx > sx then
					dxSetVisible(scrollbar[2],true)
				else
					dxSetVisible(scrollbar[2],false)
				end
			end
			if ntempy then
				if ntempy > sy then
					dxSetVisible(scrollbar[1],true)
				else
					dxSetVisible(scrollbar[1],false)
				end
			end
		end
	end
end

addEventHandler("onDgsDestroy",root,function()
	local parent = dxGetParent(source)
	if isElement(parent) then
		if dxGetType(parent) == "dgs-dxscrollpane" then
			local x,y = unpack(emGetData(source,"absPos"))
			local sx,sy = unpack(emGetData(source,"absSize"))
			local maxSize = emGetData(parent,"maxChildSize")
			local tempx,tempy = x+sx,y+sy
			local ntempx,ntempy
			if maxSize[1]-10 <= tempx then
				ntempx = 0
				for k,v in ipairs(dxGetChildren(parent)) do
					if v ~= source then
						local pos = emGetData(v,"absPos")
						local size = emGetData(v,"absSize")
						ntempx = ntempx > pos[1]+size[1] and ntempx or pos[1]+size[1]
					end
				end
			end
			if maxSize[2]-10 <= tempy then
				ntempy = 0
				for k,v in ipairs(dxGetChildren(parent)) do
					if v ~= source then
						local pos = emGetData(v,"absPos")
						local size = emGetData(v,"absSize")
						ntempy = ntempy > pos[2]+size[2] and ntempy or pos[2]+size[2]
					end
				end	
			end
			emSetData(parent,"maxChildSize",{ntempx or maxSize[1],ntempy or maxSize[2]})
			dgsScrollPaneUpdateScrollBar(parent,ntempx or maxSize[1],ntempy or maxSize[2])
		end
	end
end)

function configScrollPane(source)
	local renderTarget = emGetData(source,"renderTarget_parent")
	if isElement(renderTarget) then
		destroyElement(renderTarget)
	end
	local sx,sy = unpack(emGetData(source,"absSize"))
	local x,y = unpack(emGetData(source,"absPos"))
	local scrbThick = emGetData(source,"scrollBarThick")
	local scrollbar = emGetData(source,"scrollbars")
	local xthick,ythick = 0,0
	dgsScrollPaneUpdateScrollBar(source)
	if scrollbar then
		local parent = dxGetParent(source)
		local titleOffset = 0
		if isElement(parent) then
			if emGetData(source,"withoutTitle") then
				titleOffset = emGetData(parent,"titlesize") or 0
			end
		end
		xthick = dxGetVisible(scrollbar[1]) and scrbThick or 0
		ythick = dxGetVisible(scrollbar[2]) and scrbThick or 0
		dxSetPosition(scrollbar[1],x+sx-scrbThick,y-titleOffset,false)
		dxSetPosition(scrollbar[2],x,y+sy-scrbThick-titleOffset,false)
		dxSetSize(scrollbar[1],scrbThick,sy-scrbThick,false)
		dxSetSize(scrollbar[2],sx-scrbThick,scrbThick,false)
	end
	local renderTarget = dxCreateRenderTarget(sx-xthick,sy-ythick,true)
	emSetData(source,"renderTarget_parent",renderTarget)
end

function sortScrollPane(source,parent)
	local sx,sy = unpack(emGetData(source,"absSize"))
	local x,y = unpack(emGetData(source,"absPos"))
	local maxSize = emGetData(parent,"maxChildSize")
	local tempx,tempy = x+sx,y+sy
	local ntempx,ntempy
	if maxSize[1] <= tempx then
		ntempx = tempx
	else
		ntempx = 0
		for k,v in ipairs(dxGetChildren(parent)) do
			local pos = emGetData(v,"absPos")
			local size = emGetData(v,"absSize")
			ntempx = ntempx > pos[1]+size[1] and ntempx or pos[1]+size[1]
		end
	end
	if maxSize[2] <= tempy then
		ntempy = tempy
	else
		ntempy = 0
		for k,v in ipairs(dxGetChildren(parent)) do
			local pos = emGetData(v,"absPos")
			local size = emGetData(v,"absSize")
			ntempy = ntempy > pos[2]+size[2] and ntempy or pos[2]+size[2]
		end
	end
	maxSize[1] = ntempx or maxSize[1]
	maxSize[2] = ntempy or maxSize[2]
	dgsScrollPaneUpdateScrollBar(parent,ntempx,ntempy)
	emSetData(parent,"maxChildSize",maxSize)
end

function dxScrollPaneGetScrollBar(scrollpane)
	assert(dxGetType(scrollpane) == "dgs-dxscrollpane","Bad argument @dxScrollPaneGetScrollBar at at argument 1, expect dgs-dxscrollpane got "..tostring(dxGetType(scrollpane) or type(scrollpane)))
	return emGetData(scrollpane,"scrollbars")
end