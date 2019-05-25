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
	[Selection Mode]
	1 = Row Selection
	2 = Column Selection
	3 = Cell Selection
]]

self = false
function dxCreateGridList(x, y, sx, sy, relative, parent, sideScrollSuperior, columnHeight, bgcolor, columntextcolor, columncolor, rowdefc, rowhovc, rowselc, img, columnimage, rowdefi, rowhovi, rowseli)
	assert(tonumber(x),"Bad argument @dxCreateGridList at argument 1, expect number got "..type(x))
	assert(tonumber(y),"Bad argument @dxCreateGridList at argument 2, expect number got "..type(y))
	assert(tonumber(sx),"Bad argument @dxCreateGridList at argument 3, expect number got "..type(sx))
	assert(tonumber(sy),"Bad argument @dxCreateGridList at argument 4, expect number got "..type(sy))
	if isElement(parent) then
		assert(emIsDxElement(parent),"Bad argument @dxCreateGridList at argument 6, expect dgs-dxgui got "..dxGetType(parent))
	end
	local gridlist = createElement("dgs-dxgridlist")
	insertResourceDxGUI(sourceResource,gridlist)
	dgsSetType(gridlist,"dgs-dxgridlist")
	emSetData(gridlist,"columnHeight",tonumber(columnHeight) or 20,true)
	emSetData(gridlist,"bgimage",img)
	emSetData(gridlist,"bgcolor",bgcolor or schemeColor.gridlist.bgcolor)
	emSetData(gridlist,"columnimage",columnimage)
	emSetData(gridlist,"columncolor",columncolor or schemeColor.gridlist.columncolor)
	emSetData(gridlist,"columntextcolor",columntextcolor or schemeColor.gridlist.columntextcolor)
	emSetData(gridlist,"columntextsize",{1,1})
	emSetData(gridlist,"columnFont",systemFont)
	emSetData(gridlist,"columnOffset",10)
	emSetData(gridlist,"rowcolor",{rowdefc or schemeColor.gridlist.rowcolor[1],rowhovc or schemeColor.gridlist.rowcolor[2],rowselc or schemeColor.gridlist.rowcolor[3]})
	emSetData(gridlist,"rowimage",{rowdefi,rowhovi,rowseli})
	emSetData(gridlist,"columnData",{})
	emSetData(gridlist,"rowData",{})
	emSetData(gridlist,"rowtextsize",{1,1})
	emSetData(gridlist,"rowtextcolor",schemeColor.gridlist.rowtextcolor)
	emSetData(gridlist,"columnRelative",true)
	emSetData(gridlist,"columnMoveOffset",0)
	emSetData(gridlist,"UseImage",false)
	dxGridListSetSortFunction(gridlist,sortFunctions_upper)
	dgsElementData[gridlist].nextRenderSort = false
	emSetData(gridlist,"sortEnabled",true)
	emSetData(gridlist,"autoSort",true)
	emSetData(gridlist,"sortColumn",false)
	emSetData(gridlist,"sectionColumnOffset",-10)
	emSetData(gridlist,"defaultColumnOffset",0)
	emSetData(gridlist,"backgroundOffset",0)
	emSetData(gridlist,"font",systemFont)
	emSetData(gridlist,"sectionFont",systemFont)
	emSetData(gridlist,"columnShadow",false)
	emSetData(gridlist,"scrollBarThick",20,true)
	emSetData(gridlist,"rowHeight",15)
	emSetData(gridlist,"colorcoded",false)
	emSetData(gridlist,"selectionMode",1)
	emSetData(gridlist,"multiSelection",false)
	emSetData(gridlist,"mode",false,true)
	emSetData(gridlist,"clip",true)
	emSetData(gridlist,"rowShadow",false)
	emSetData(gridlist,"rowMoveOffset",0)
	emSetData(gridlist,"preSelect",{})
	emSetData(gridlist,"rowSelect",{})
	emSetData(gridlist,"itemClick",{})
	emSetData(gridlist,"selectedColumn",-1)
	emSetData(gridlist,"scrollFloor",{false,false})
	if isElement(parent) then
		dxSetParent(gridlist,parent)
	else
		table.insert(MaxFatherTable,gridlist)
	end
	triggerEvent("onDgsPreCreate",gridlist)
	calculateGuiPositionSize(gridlist,x,y,relative or false,sx,sy,relative or false,true)
	local abx,aby = unpack(dgsElementData[gridlist].absSize)
	local columnRender = dxCreateRenderTarget(abx,columnHeight or 20,true)
	local rowRender = dxCreateRenderTarget(abx,aby-(columnHeight or 20)-20,true)
	emSetData(gridlist,"renderTarget",{columnRender,rowRender})

	local bar1offset = 20
	local bar2offset = 0
	if (sideScrollSuperior) then
		bar1offset = 0; bar2offset = 20
	end

	local scrollbar1 = dxCreateScrollBar(abx-20,0,20,aby-bar1offset,false,false,gridlist)
	local scrollbar2 = dxCreateScrollBar(0,aby-20,abx-bar2offset,20,true,false,gridlist)

	dxSetVisible(scrollbar1,false)
	dxSetVisible(scrollbar2,false)
	emSetData(scrollbar1,"length",{0,true})
	emSetData(scrollbar2,"length",{0,true})
	emSetData(gridlist,"scrollbars",{scrollbar1,scrollbar2})
	triggerEvent("onDgsCreate",gridlist)
	return gridlist
end

function dxGridListSetSelectionMode(gridlist,mode)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListSetSelectionMode at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	if mode == 1 or mode == 2 or mode == 3 then
		return emSetData(gridlist,"selectionMode",mode)
	end
	return false
end

function dxGridListGetSelectionMode(gridlist)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListGetSelectionMode at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	return dgsElementData[gridlist].selectionMode
end

function dxGridListSetMultiSelectionEnabled(gridlist,multiSelection)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListSetMultiSelectionEnabled at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	return emSetData(gridlist,"multiSelection",multiSelection and true or false)
end

function dxGridListGetMultiSelectionEnabled(gridlist)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListGetMultiSelectionEnabled at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	return dgsElementData[gridlist].multiSelection
end

function sortFunctions_upper(...)
	local arg = {...}
	local column = dgsElementData[self].sortColumn
	return arg[1][column][1] < arg[2][column][1]
end

function sortFunctions_lower(...)
	local arg = {...}
	local column = dgsElementData[self].sortColumn
	return arg[1][column][1] > arg[2][column][1]
end

function dxGridListSetSortFunction(gridlist,str)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListSetSortFunction at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	local fnc
	if type(str) == "string" then
		fnc = loadstring(str)
		assert(fnc,"Bad Argument @'dxGridListSetSortFunction' at argument 1, failed to load the function.")
		local newfenv = {}
		setmetatable(newfenv, {__index = _G})
		newfenv.self = gridlist
		newfenv.dgsElementData = dgsElementData
		setfenv(fnc,newfenv)
	elseif type(str) == "function" then
		fnc = str
		local newfenv = {}
		setmetatable(newfenv, {__index = _G})
		newfenv.self = gridlist
		newfenv.dgsElementData = dgsElementData
		setfenv(fnc,newfenv)
	end
	if dgsElementData[gridlist].autoSort then
		dgsElementData[gridlist].nextRenderSort = true
	end
	return emSetData(gridlist,"sortFunction",fnc)
end

function dxGridListSetAutoSortEnabled(gridlist,state)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListSetAutoSortEnabled at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	local state = state and true or false
	return emSetData(gridlist,"autoSort",state)
end

function dxGridListGetAutoSortEnabled(gridlist)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListGetAutoSortEnabled at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	return dgsElementData[gridlist].autoSort
end

function dxGridListSetSortEnabled(gridlist,state)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListSetSortEnabled at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	local state = state and true or false
	return emSetData(gridlist,"sortEnabled",state)
end

function dxGridListGetSortEnabled(gridlist)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListGetSortEnabled at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	return dgsElementData[gridlist].sortEnabled
end

function dxGridListSetSortColumn(gridlist,sortColumn)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListSetSortColumn at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	local columnData = dgsElementData[gridlist].columnData
	if columnData then
		if dgsElementData[gridlist].autoSort then
			dgsElementData[gridlist].nextRenderSort = true
		end
		return emSetData(gridlist,"sortColumn",sortColumn)
	end
	return false
end

function dxGridListGetSortColumn(gridlist)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListGetSortColumn at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	return dgsElementData[gridlist].sortColumn
end

function dxGridListSort(gridlist,sortColumn)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListSort at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	local sortColumn = tonumber(sortColumn) or dgsElementData[gridlist].sortColumn
	if sortColumn then
		local rowData = dgsElementData[gridlist].rowData
		local sortFunction = dgsElementData[gridlist].sortFunction
		table.sort(rowData,sortFunction)
		dgsElementData[gridlist].rowData = rowData
		return true
	end
	return false
end

function dxGridListGetEnterColumn(gridlist)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListGetEnterColumn at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	return dgsElementData[gridlist].selectedColumn
end

--[[
	columnData Structure:
	  1									2									N
	  column1							column2								columnN
	{{text1,Length,AllLengthFront},		{text1,Length,AllLengthFront},		{text1,Length,AllLengthFront}, ...}
]]

function dxGridListSetColumnRelative(gridlist,relative,transformColumn)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListSetColumnRelative at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	assert(type(relative) == "boolean","Bad argument @dxGridListSetColumnRelative at argument 2, expect bool got "..type(relative))
	local relative = relative and true or false
	local transformColumn = transformColumn == false and true or false
	emSetData(gridlist,"columnRelative",relative)
	if transformColumn then
		local columnData = dgsElementData[gridlist].columnData
		local w,h = dxGetSize(v,false)
		if relative then
			for k,v in ipairs(columnData) do
				columnData[k][2] = columnData[k][2]/w
				columnData[k][3] = columnData[k][3]/w
			end
		else
			for k,v in ipairs(columnData) do
				columnData[k][2] = columnData[k][2]*w
				columnData[k][3] = columnData[k][3]*w
			end
		end
	end
	return true
end

function dxGridListSetColumnTitle(gridlist,column,name)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListSetColumnTitle at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	assert(type(column) == "number","Bad argument @dxGridListSetColumnTitle at argument 2, expect number got "..type(column))
	local columnData = dgsElementData[gridlist].columnData
	if columnData[column] then
		columnData[column][1] = name
		emSetData(gridlist,"columnData",columnData)
	end
end

function dxGridListGetColumnTitle(gridlist,column)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListGetColumnTitle at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	assert(type(column) == "number","Bad argument @dxGridListGetColumnTitle at argument 2, expect number got "..type(column))
	local columnData = dgsElementData[gridlist].columnData
	return columnData[column][1]
end

function dxGridListGetColumnRelative(gridlist)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListGetColumnRelative at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	return dgsElementData[gridlist].columnRelative
end

function dxGridListAddColumn(gridlist,name,len,pos)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListAddColumn at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	assert(type(len) == "number","Bad argument @dxGridListAddColumn at argument 2, expect number got "..dxGetType(len))
	local columnData = dgsElementData[gridlist].columnData
	pos = tonumber(pos) or #columnData+1
	if pos > #columnData+1 then
		pos = #columnData+1
	end
	local sx,sy = unpack(dgsElementData[gridlist].absSize)
	local scrollBarThick = dgsElementData[gridlist].scrollBarThick
	local multiplier = dgsElementData[gridlist].columnRelative and sx-scrollBarThick or 1
	local oldLen = 0
	if #columnData > 0 then
		oldLen = columnData[#columnData][3]+columnData[#columnData][2]
	end
	table.insert(columnData,pos,{name,len,oldLen})

	for i=pos+1,#columnData do
		columnData[i] = {columnData[i][1],columnData[i][2],dxGridListGetColumnAllLength(gridlist,i-1)}
	end
	emSetData(gridlist,"columnData",columnData)
	oldLen = multiplier*oldLen
	local columnLen = multiplier*len+oldLen
	local scrollbars = dgsElementData[gridlist].scrollbars
	if columnLen > (sx-scrollBarThick) then
		dxSetVisible(scrollbars[2],true)
	else
		dxSetVisible(scrollbars[2],false)
	end
	emSetData(scrollbars[2],"length",{(sx-scrollBarThick)/columnLen,true})
	local rowData = dgsElementData[gridlist].rowData
	for i=1,#rowData do
		rowData[i][pos] = {"",tocolor(0,0,0,255)}
	end
	return pos
end

function dxGridListGetColumnCount(gridlist)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListGetColumnCount at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	return #(dgsElementData[gridlist].columnData or {})
end

function dxGridListRemoveColumn(gridlist,pos)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListRemoveColumn at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	assert(type(pos) == "number","Bad argument @dxGridListRemoveColumn at argument 2, expect number got "..dxGetType(pos))
	local columnData = dgsElementData[gridlist].columnData
	assert(columnData[pos],"Bad argument @dxGridListRemoveColumn at argument 2, column index is out of range [max "..#columnData..", got "..pos.."]")
	local oldLen = columnData[pos][3]
    local pLen = columnData[pos][2]
	table.remove(columnData,pos)
	local lastColumnLen = 0
	for k,v in ipairs(columnData) do
		if k >= pos then
			columnData[k] = v[2]-oldLen
			lastColumnLen = columnData[k]
		end
	end
	local sx,sy = dgsElementData[gridlist].absSize[1],dgsElementData[gridlist].absSize[2]
	local scrollbars = dgsElementData[gridlist].scrollbars
	local scrollBarThick = dgsElementData[gridlist].scrollBarThick
	if lastColumnLen > (sx-scrollBarThick) then
		dxSetVisible(scrollbars[2],true)
	else
		dxSetVisible(scrollbars[2],false)
	end
	emSetData(scrollbars[2],"length",{(sx-scrollBarThick)/pLen,true})
	emSetData(scrollbars[2],"position",dgsElementData[scrollbars[2]].position)
	return true
end

-- Modes: true - fast, false - slow.
function dxGridListGetColumnAllLength(gridlist,pos,relative,mode)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListGetColumnAllLength at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	assert(type(pos) == "number","Bad argument @dxGridListGetColumnAllLength at argument 2, expect number got "..dxGetType(pos))
	local columnData = dgsElementData[gridlist].columnData
	local scbThick = dgsElementData[gridlist].scrollBarThick
	local columnSize = dgsElementData[gridlist].absSize[1]-scbThick
	local rlt = dgsElementData[gridlist].columnRelative
	if pos > 0 then
		if mode then
			local data = columnData[pos][3]+columnData[pos][2]
			if relative then
				return rlt and data or data/columnSize
			else
				return rlt and data*columnSize or data
			end
		else
			local dataLength = 0
			for k,v in ipairs(columnData) do
				dataLength = dataLength + v[2]
				if k == pos then
					if relative then
						return rlt and dataLength or dataLength/columnSize
					else
						return rlt and dataLength*columnSize or dataLength
					end
				end
			end
		end
	elseif pos == 0 then
		local dataLength = 0
		if relative then
			return rlt and dataLength or dataLength/columnSize
		else
			return rlt and dataLength*columnSize or dataLength
		end
	end
	return false
end

function dxGridListGetColumnLength(gridlist,pos,relative)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListGetColumnLength at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	assert(type(pos) == "number","Bad argument @dxGridListGetColumnLength at argument 2, expect number got "..dxGetType(pos))
	local columnData = dgsElementData[gridlist].columnData
	if pos > 0 and pos <= #columnData then
		local scbThick = dgsElementData[gridlist].scrollBarThick
		local columnSize = dgsElementData[gridlist].absSize[1]-scbThick
		local rlt = dgsElementData[gridlist].columnRelative
		local data = columnData[pos][2]
		if relative then
			return rlt and data or data/columnSize
		else
			return rlt and data*columnSize or data
		end
	end
	return false
end

function dxGridListSetItemData(gridlist,row,column,data)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListSetItemData at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	assert(type(row) == "number","Bad argument @dxGridListSetItemData at argument 2, expect number got "..dxGetType(row))
	assert(type(column) == "number","Bad argument @dxGridListSetItemData at argument 3, expect number got "..dxGetType(column))
	local rowData = dgsElementData[gridlist].rowData
	if row > 0 and row <= #rowData then
		local columnData = dgsElementData[gridlist].columnData
		if column > 0 and column <= #columnData then
			rowData[row][column][-1] = data
			return true
		end
	end
	return false
end

function dxGridListGetItemData(gridlist,row,column)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListGetItemData at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	assert(type(row) == "number","Bad argument @dxGridListGetItemData at argument 2, expect number got "..dxGetType(row))
	assert(type(column) == "number","Bad argument @dxGridListGetItemData at argument 3, expect number got "..dxGetType(column))
	local rowData = dgsElementData[gridlist].rowData
	if row > 0 and row <= #rowData then
		local columnData = dgsElementData[gridlist].columnData
		if column > 0 and column <= #columnData then
			return rowData[row][column][-1]
		end
	end
	return false
end

--[[
	rowData Structure:
		-4					-3				-2				-1				0								1																													2																													...
		columnOffset		bgImage			selectable		clickable		bgColor							column1																												column2																												...
{
	{	columnOffset,		{def,hov,sel},	true/false,		true/false,		{default,hovering,selected},	{text,color,colorcoded,scalex,scaley,font,{image,color,imagex,imagey,imagew,imageh},unselectable,unclickable},		{text,color,colorcoded,scalex,scaley,font,{image,color,imagex,imagey,imagew,imageh},unselectable,unclickable},		...		},
	{	columnOffset,		{def,hov,sel},	true/false,		true/false,		{default,hovering,selected},	{text,color,colorcoded,scalex,scaley,font,{image,color,imagex,imagey,imagew,imageh},unselectable,unclickable},		{text,color,colorcoded,scalex,scaley,font,{image,color,imagex,imagey,imagew,imageh},unselectable,unclickable},		...		},
	{	columnOffset,		{def,hov,sel},	true/false,		true/false,		{default,hovering,selected},	{text,color,colorcoded,scalex,scaley,font,{image,color,imagex,imagey,imagew,imageh},unselectable,unclickable},		{text,color,colorcoded,scalex,scaley,font,{image,color,imagex,imagey,imagew,imageh},unselectable,unclickable},		...		},
	{	columnOffset,		{def,hov,sel},	true/false,		true/false,		{default,hovering,selected},	{text,color,colorcoded,scalex,scaley,font,{image,color,imagex,imagey,imagew,imageh},unselectable,unclickable},		{text,color,colorcoded,scalex,scaley,font,{image,color,imagex,imagey,imagew,imageh},unselectable,unclickable},		...		},
	{	the same as preview table																																													},
}
	table[i](i<=0) isn't counted in #table
]]


function dxGridListAddRow(gridlist,row,...)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListAddRow at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	local rowData = dgsElementData[gridlist].rowData
	local rowLength = 0
	row = row or #rowData+1
	local rowTable = {}
	local args = {...}
	rowTable[-4] = dgsElementData[gridlist].defaultColumnOffset
	rowTable[-3] = {}
	rowTable[-2] = true
	rowTable[-1] = true
	rowTable[0] = dgsElementData[gridlist].rowcolor
	for i=1,#dgsElementData[gridlist].columnData do
		rowTable[i] = {args[i] or "",dgsElementData[gridlist].rowtextcolor}
	end
	table.insert(rowData,row,rowTable)
 	local scrollbars = dgsElementData[gridlist].scrollbars
	local sx,sy = unpack(dgsElementData[gridlist].absSize)
	local scbThick = dgsElementData[gridlist].scrollBarThick
	local columnHeight = dgsElementData[gridlist].columnHeight
	if row*dgsElementData[gridlist].rowHeight > (sy-scbThick-columnHeight) then
		dxSetVisible(scrollbars[1],true)
	else
		dxSetVisible(scrollbars[1],false)
	end
	emSetData(scrollbars[1],"length",{(sy-scbThick-columnHeight)/((row+1)*dgsElementData[gridlist].rowHeight),true})
	return row
end

function dxGridListSetItemClickable(gridlist,row,column,state)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListSetItemClickable at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	assert(type(row) == "number","Bad argument @dxGridListSetItemClickable at argument 2, expect number got "..dxGetType(row))
	assert(type(column) == "number","Bad argument @dxGridListSetItemClickable at argument 3, expect number got "..dxGetType(column))
	row,column = row-row%1,column-column%1
	assert(row >= 1,"Bad argument @dxGridListSetItemClickable at argument 2, expect number >= 1 got "..row)
	assert(column >= 1 or column <= -5,"Bad argument @dxGridListSetItemClickable at argument 3, expect a number >= 1 got "..column)
	local rowData = dgsElementData[gridlist].rowData
	assert(rowData[row],"Bad argument @dxGridListSetItemClickable at argument 2, row "..row.." doesn't exist")
	rowData[row][column][9] = not state or nil
	return true
end

function dxGridListSetItemSelectable(gridlist,row,column,state)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListSetItemSelectable at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	assert(type(row) == "number","Bad argument @dxGridListSetItemSelectable at argument 2, expect number got "..dxGetType(row))
	assert(type(column) == "number","Bad argument @dxGridListSetItemSelectable at argument 3, expect number got "..dxGetType(column))
	row,column = row-row%1,column-column%1
	assert(row >= 1,"Bad argument @dxGridListSetItemSelectable at argument 2, expect number >= 1 got "..row)
	assert(column >= 1 or column <= -5,"Bad argument @dxGridListSetItemSelectable at argument 3, expect a number >= 1 got "..column)
	local rowData = dgsElementData[gridlist].rowData
	assert(rowData[row],"Bad argument @dxGridListSetItemSelectable at argument 2, row "..row.." doesn't exist")
	rowData[row][column][8] = not state or nil
	return true
end

function dxGridListGetItemClickable(gridlist,row,column,state)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListGetItemClickable at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	assert(type(row) == "number","Bad argument @dxGridListGetItemClickable at argument 2, expect number got "..dxGetType(row))
	assert(type(column) == "number","Bad argument @dxGridListGetItemClickable at argument 3, expect number got "..dxGetType(column))
	row,column = row-row%1,column-column%1
	assert(row >= 1,"Bad argument @dxGridListGetItemClickable at argument 2, expect number >= 1 got "..row)
	assert(column >= 1 or column <= -5,"Bad argument @dxGridListGetItemClickable at argument 3, expect a number >= 1 got "..column)
	local rowData = dgsElementData[gridlist].rowData
	assert(rowData[row],"Bad argument @dxGridListGetItemClickable at argument 2, row "..row.." doesn't exist")
	return not (rowData[row][column][9] and true or false)
end

function dxGridListGetItemSelectable(gridlist,row,column,state)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListGetItemSelectable at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	assert(type(row) == "number","Bad argument @dxGridListGetItemSelectable at argument 2, expect number got "..dxGetType(row))
	assert(type(column) == "number","Bad argument @dxGridListGetItemSelectable at argument 3, expect number got "..dxGetType(column))
	row,column = row-row%1,column-column%1
	assert(row >= 1,"Bad argument @dxGridListGetItemSelectable at argument 2, expect number >= 1 got "..row)
	assert(column >= 1 or column <= -5,"Bad argument @dxGridListGetItemSelectable at argument 3, expect a number >= 1 got "..column)
	local rowData = dgsElementData[gridlist].rowData
	assert(rowData[row],"Bad argument @dxGridListGetItemSelectable at argument 2, row "..row.." doesn't exist")
	return not (rowData[row][column][8] and true or false)
end

function dxGridListSetRowBackGroundColor(gridlist,row,colordef,colorsel,colorcli)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListSetRowBackGroundColor at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	assert(type(row) == "number","Bad argument @dxGridListSetRowBackGroundColor at argument 2, expect number got "..dxGetType(row))
	local rowData = dgsElementData[gridlist].rowData
	if rowData[row] then
		rowData[row][0] = {colordef or 255,colorsel or 255,colorcli or 255}
		return true
	end
	return false
end

function dxGridListGetRowBackGroundColor(gridlist,row)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListGetRowBackGroundColor at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	assert(type(row) == "number","Bad argument @dxGridListGetRowBackGroundColor at argument 2, expect number got "..dxGetType(row))
	local rowData = dgsElementData[gridlist].rowData
	if rowData[row] then
		return unpack(rowData[row][0] or {})
	end
	return false
end

function dxGridListRemoveRow(gridlist,row)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListRemoveRow at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	assert(type(row) == "number","Bad argument @dxGridListRemoveRow at argument 2, expect number got "..dxGetType(row))
	local rowData = dgsElementData[gridlist].rowData
	row = tonumber(row) or #rowData
	if row == 0 or row > #rowData then
		return false
	end
	table.remove(rowData,row)
 	local scrollbars = dgsElementData[gridlist].scrollbars
	local sx,sy = unpack(dgsElementData[gridlist].absSize)
	local scbThick = dgsElementData[gridlist].scrollBarThick
	if (row-1)*dgsElementData[gridlist].rowHeight > (sy-scbThick-dgsElementData[gridlist].columnHeight) then
		dxSetVisible(scrollbars[1],true)
	else
		dxSetVisible(scrollbars[1],false)
	end
	emSetData(scrollbars[1],"length",{(sy-scbThick-dgsElementData[gridlist].columnHeight)/((row+1)*dgsElementData[gridlist].rowHeight),true})
	emSetData(scrollbars[2],"length",dgsElementData[scrollbars[2]].length)
	return true
end

function dxGridListClearRow(gridlist,notresetSelected)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListClearRow at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	local rowData = dgsElementData[gridlist].rowData
 	local scrollbars = dgsElementData[gridlist].scrollbars
	emSetData(scrollbars[1],"length",{0,true})
	emSetData(scrollbars[1],"position",0)
	dxSetVisible(scrollbars[1],false)
	if not notresetSelected then
		 dxGridListSetSelectedItem(gridlist,-1)
	end
	return emSetData(gridlist,"rowData",{})
end

function dxGridListClear(gridlist)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListClear at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	local scrollbars = dgsElementData[gridlist].scrollbars
	emSetData(scrollbars[1],"length",{0,true})
	emSetData(scrollbars[1],"position",0)
	emSetData(scrollbars[2],"length",{0,true})
	emSetData(scrollbars[2],"position",0)
	dxSetVisible(scrollbars[1],false)
	dxSetVisible(scrollbars[2],false)
	dxGridListSetSelectedItem(gridlist,-1)
	emSetData(gridlist,"rowData",{})
	return true
 end

function dxGridListGetRowCount(gridlist)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListGetRowCount at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	return #dgsElementData[gridlist].rowData
end

function dxGridListSetItemImage(gridlist,row,column,image,color,offx,offy,w,h)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListSetItemImage at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	assert(type(row) == "number","Bad argument @dxGridListSetItemImage at argument 2, expect number got "..dxGetType(row))
	assert(type(column) == "number","Bad argument @dxGridListSetItemImage at argument 3, expect number got "..dxGetType(column))
	local rowData = dgsElementData[gridlist].rowData
	if rowData[row] and rowData[row][column] then
		local imageData = rowData[row][column][7] or {}
		local image = image or imageData[1] or _
		local color = color or imageData[2] or white
		local offx = offx or imageData[3] or 0
		local offy = offy or imageData[4] or 0
		local w,h = w or imageData[5] or dxGridListGetColumnLength(gridlist,column,false),h or imageData[6] or dgsElementData[gridlist].rowHeight
		imageData[1] = image
		imageData[2] = color
		imageData[3] = offx
		imageData[4] = offy
		imageData[5] = w
		imageData[6] = h
		rowData[row][column][7] = imageData
		return true
	end
	return false
end

function dxGridListRemoveItemImage(gridlist,row,column)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListRemoveItemImage at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	assert(type(row) == "number","Bad argument @dxGridListRemoveItemImage at argument 2, expect number got "..dxGetType(row))
	assert(type(column) == "number","Bad argument @dxGridListRemoveItemImage at argument 3, expect number got "..dxGetType(column))
	local rowData = dgsElementData[gridlist].rowData
	if rowData[row] and rowData[row][column] then
		rowData[row][column][7] = nil
		return true
	end
	return false
end

function dxGridListGetItemImage(gridlist,row,column)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListGetItemImage at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	assert(type(row) == "number","Bad argument @dxGridListGetItemImage at argument 2, expect number got "..dxGetType(row))
	assert(type(column) == "number","Bad argument @dxGridListGetItemImage at argument 3, expect number got "..dxGetType(column))
	local rowData = dgsElementData[gridlist].rowData
	if rowData[row] and rowData[row][column] then
		local imageData = rowData[row][column][7] or {}
		return unpack(rowData[row][column][7] or {})
	end
	return false
end

function dxGridListSetItemText(gridlist,row,column,text,image)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListSetItemText at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	assert(type(row) == "number","Bad argument @dxGridListSetItemText at argument 2, expect number got "..type(row))
	assert(type(column) == "number","Bad argument @dxGridListSetItemText at argument 3, expect number got "..type(column))
	row,column = row-row%1,column-column%1
	assert(row >= 1,"Bad argument @dxGridListSetItemText at argument 2, expect number >= 1 got "..row)
	assert(column >= 1 or column <= -5,"Bad argument @dxGridListSetItemText at argument 3, expect a number >= 1 got "..column)
	local rowData = dgsElementData[gridlist].rowData
	assert(rowData[row],"Bad argument @dxGridListSetItemText at argument 2, row "..row.." doesn't exist")
	if column <= -5 then
		rowData[row][column] = text
	else
		rowData[row][column][1] = tostring(text)
	end
	return emSetData(gridlist,"rowData",rowData)
end

function dxGridListSetRowAsSection(gridlist,row,enabled,enableMouseClickAndSelect)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListSetRowAsSection at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	assert(type(row) == "number","Bad argument @dxGridListSetRowAsSection at argument 2, expect number got "..type(row))
	local rowData = dgsElementData[gridlist].rowData
	if rowData[row] then
		if enabled then
			rowData[row][-4] = dgsElementData[gridlist].sectionColumnOffset
			if not enableMouseClickAndSelect then
				rowData[row][-2] = false
				rowData[row][-1] = false
			else
				rowData[row][-2] = true
				rowData[row][-1] = true
			end
		else
			rowData[row][-4] = dgsElementData[gridlist].defaultColumnOffset
			rowData[row][-2] = true
			rowData[row][-1] = true
		end
		rowData[row][-5] = enabled and true or false --Enable Section Mode
		return emSetData(gridlist,"rowData",rowData)
	end
	return false
end

function dxGridListGetItemText(gridlist,row,column)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListGetItemText at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	assert(type(row) == "number","Bad argument @dxGridListGetItemText at argument 2, expect number got "..type(row))
	assert(type(column) == "number","Bad argument @dxGridListGetItemText at argument 3, expect number got "..type(column))
	local rowData = dgsElementData[gridlist].rowData
	return rowData[row][column][1],rowData[row][column][7]
end

function dxGridListGetSelectedItem(gridlist)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListGetSelectedItem at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	local row,data = next(dgsElementData[gridlist].rowSelect or {})
	local column,bool = next(data or {})
	return row or false, column or false
end

function dxGridListGetSelectedItems(gridlist)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListGetSelectedItem at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	return dgsElementData[gridlist].rowSelect
end

function dxGridListSetSelectedItem(gridlist,row,column,notClear)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListSetSelectedItem at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	if row == -1 or row > 0 then
		local rowData = dgsElementData[gridlist].rowData
		local columndata = dgsElementData[gridlist].columnData
		local row = row <= #rowData and row or #rowData
		local column = column or -1
		local column = column <= #columndata and column or #columndata
		local old1,old2
		if dgsElementData[gridlist].multiSelection then
			old1 = dxGridListGetSelectedItems(gridlist)
		else
			old1,old2 = dxGridListGetSelectedItems(gridlist)
		end
		local selectionMode = dgsElementData[gridlist].selectionMode
		if selectionMode == 1 then
			assert(type(row) == "number","Bad argument @dxGridListSetSelectedItem at argument 2, expect number got "..type(row))
			tab = {[row]={}}
			tab[row][1] = true
			emSetData(gridlist,"rowSelect",tab)
		elseif selectionMode == 2 then
			assert(type(column) == "number","Bad argument @dxGridListSetSelectedItem at argument 3, expect number got "..type(column))
			local tab = {}
			tab[1] = {[column]=true}
			emSetData(gridlist,"rowSelect",tab)
		elseif selectionMode == 3 then
			assert(type(row) == "number","Bad argument @dxGridListSetSelectedItem at argument 2, expect number got "..type(row))
			assert(type(column) == "number","Bad argument @dxGridListSetSelectedItem at argument 3, expect number got "..type(column))
			emSetData(gridlist,"rowSelect",{[row]={[column]=true}})
		end
		if dgsElementData[gridlist].multiSelection then
			triggerEvent("ondxGridListSelect",gridlist,row,column,old1)
		else
			triggerEvent("ondxGridListSelect",gridlist,row,column,old1,old2)
		end
		dgsElementData[gridlist].itemClick = {row,column}
		return true
	end
	return false
end

function dxGridListSetSelectedItems(gridlist,tab)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListSetSelectedItems at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	assert(type(tab) == "table","Bad argument @dxGridListSetSelectedItems at argument 2, expect table got "..type(tab))
	emSetData(gridlist,"rowSelect",tab)
	triggerEvent("ondxGridListSelect",gridlist,_,_,tab)
	return true
end

function dxGridListSelectItem(gridlist,row,column,state)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListSelectItem at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	local selectedItem = dgsElementData[gridlist].rowSelect
	local rowData = dgsElementData[gridlist].rowData
	local columnData = dgsElementData[gridlist].rowData
	if rowData[row] and rowData[row][column] then
		local selectionMode = dgsElementData[gridlist].selectionMode
		if selectionMode == 1 then
			selectedItem[row] = selectedItem[row] or {}
			selectedItem[row][1] = state or nil
			if not next(selectedItem[row]) then
				selectedItem[row] = nil
			end
		elseif selectionMode == 2 then
			selectedItem[1] = selectedItem[1] or {}
			selectedItem[1][column] = state or nil
			if not next(selectedItem[1]) then
				selectedItem[1] = nil
			end
		elseif selectionMode == 3 then
			selectedItem[row] = selectedItem[row] or {}
			selectedItem[row][column] = state or nil
			if not next(selectedItem[row]) then
				selectedItem[row] = nil
			end
		end
		return true
	end
	return false
end

function dxGridListItemIsSelected(gridlist,row,column)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListItemIsSelected at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	local selectedItem = dgsElementData[gridlist].rowSelect
	local rowData = dgsElementData[gridlist].rowData
	if rowData[row] and rowData[row][column] then
		local selectionMode = dgsElementData[gridlist].selectionMode
		if selectionMode == 1 then
			selectedItem[row] = selectedItem[row] or {}
			return selectedItem[row][1] and true or false
		elseif selectionMode == 2 then
			selectedItem[1] = selectedItem[1] or {}
			return selectedItem[1][column] and true or false
		elseif selectionMode == 3 then
			selectedItem[row] = selectedItem[row] or {}
			return selectedItem[row][column] and true or false
		end
	end
	return false
end

function dxGridListSetItemColor(gridlist,row,column,r,g,b,a)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListSetItemColor at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	assert(type(row) == "number","Bad argument @dxGridListSetItemColor at argument 2, expect number got "..type(row))
	local rowData = dgsElementData[gridlist]["rowData"]
	local color
	if r and g and b then
		color = tocolor(r,g,b,a or 255)
	elseif r and (not g or not b) then
		color = r
	end
	if rowData then
		if row > 0 and row <= #rowData then
			local columnID = #dgsElementData[gridlist]["columnData"]
			if type(column) == "number" then
				if column > 0 and column <= columnID then
					rowData[row][column][2] = color
				end
			else
				for i=1,columnID do
					rowData[row][i][2] = color
				end
			end
			return true
		end
	end
	return false
end

function dxGridListGetItemColor(gridlist,row,column,notSplitColor)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListGetItemColor at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	assert(type(row) == "number","Bad argument @dxGridListGetItemColor at argument 2, expect number got "..type(row))
	assert(type(column) == "number","Bad argument @dxGridListGetItemColor at argument 3, expect number got "..type(column))
	local rowData = dgsElementData[gridlist].rowData
	if row > 0 and row <= #rowData then
		local columnID = #dgsElementData[gridlist]["columnData"]
		if column > 0 and column <= columnID then
			return notSplitColor and rowData[row][column][2] or fromcolor(rowData[row][column][2])
		end
	end
end

function dxGridListGetRowBackGroundImage(gridlist,row)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListGetRowBackGroundImage at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	assert(type(row) == "number","Bad argument @dxGridListGetRowBackGroundImage at argument 2, expect number got "..type(row))
	local rowData = dgsElementData[gridlist].rowData
	return unpack(rowData[row][-3])
end

function dxGridListSetRowBackGroundImage(gridlist,row,defimage,selimage,cliimage)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListSetRowBackGroundImage at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	assert(type(row) == "number","Bad argument @dxGridListSetRowBackGroundImage at argument 2, expect number got "..type(row))
	if defimage then
		assert(type(defimage) == "string" or isElement(defimage) and getElementType(defimage) == "texture","Bad argument @dxGridListSetRowBackGroundImage at argument 3, expect string/texture got "..tostring(isElement(defimage) or type(defimage)))
	end
	if selimage then
		assert(type(selimage) == "string" or isElement(selimage) and getElementType(selimage) == "texture","Bad argument @dxGridListSetRowBackGroundImage at argument 4, expect string/texture got "..tostring(isElement(selimage) or type(selimage)))
	end
	if cliimage then
		assert(type(cliimage) == "string" or isElement(cliimage) and getElementType(cliimage) == "texture","Bad argument @dxGridListSetRowBackGroundImage at argument 5, expect string/texture got "..tostring(isElement(cliimage) or type(cliimage)))
	end
	local rowData = dgsElementData[gridlist].rowData
	rowData[row][-3] = {defimage,selimage,cliimage}
	return emSetData(gridlist,"rowData",rowData)
end

addEventHandler("onDgsScrollBarScrollPositionChange",root,function(new,old)
	local parent = dxGetParent(source)
	if dxGetType(parent) == "dgs-dxgridlist" then
		local scrollBars = dgsElementData[parent].scrollbars
		local sx,sy = unpack(dgsElementData[parent].absSize)
		if source == scrollBars[1] then
			local rowLength = #dgsElementData[parent].rowData*dgsElementData[parent].rowHeight
			local temp = -new*(rowLength-(sy-dgsElementData[parent].scrollBarThick-dgsElementData[parent].columnHeight))/100
			local temp = dgsElementData[parent].scrollFloor[1] and math.floor(temp) or temp 
			emSetData(parent,"rowMoveOffset",temp)
		elseif source == scrollBars[2] then
			local columnCount =  dxGridListGetColumnCount(parent)
			local columnLength = dxGridListGetColumnAllLength(parent,columnCount)
			local columnOffset = dgsElementData[parent].columnOffset
			local temp = -new*(columnLength-sx+dgsElementData[parent].scrollBarThick+columnOffset)/100
			local temp = dgsElementData[parent].scrollFloor[2] and math.floor(temp) or temp
			emSetData(parent,"columnMoveOffset",temp)
		end
	end
end)

function configGridList(source)
	local scrollbar = dgsElementData[source].scrollbars
	local sx,sy = unpack(dgsElementData[source].absSize)
	local columnHeight = dgsElementData[source].columnHeight
	local rowHeight = dgsElementData[source].rowHeight
	local scbThick = dgsElementData[source].scrollBarThick
	local relSizX,relSizY = sx-scbThick,sy-scbThick
	if scrollbar then
		dxSetPosition(scrollbar[1],relSizX,0,false)
		dxSetPosition(scrollbar[2],0,relSizY,false)
		dxSetSize(scrollbar[1],scbThick,relSizY,false)
		dxSetSize(scrollbar[2],relSizX,scbThick,false)
		local maxColumn = dxGridListGetColumnCount(source)
		local columnData = dgsElementData[source].columnData
		local columnCount =  dxGridListGetColumnCount(source)
		local columnLength = dxGridListGetColumnAllLength(source,columnCount,false,true)
		if columnLength > relSizX then
			dxSetVisible(scrollbar[2],true)
		else
			dxSetVisible(scrollbar[2],false)
			emSetData(scrollbar[2],"position",0)
		end
		local rowLength = #dgsElementData[source].rowData*rowHeight
		local rowShowRange = relSizY-columnHeight
		if rowLength > rowShowRange then
			dxSetVisible(scrollbar[1],true)
		else
			dxSetVisible(scrollbar[1],false)
			emSetData(scrollbar[1],"position",0)
		end
		local scroll1 = dgsElementData[scrollbar[1]].position
		local scroll2 = dgsElementData[scrollbar[2]].position
		emSetData(source,"rowMoveOffset",-scroll1*(rowLength-relSizY+columnHeight)/100)
		emSetData(scrollbar[1],"length",{rowShowRange/rowLength,true})
		emSetData(scrollbar[2],"length",{relSizX/(columnLength+scbThick),true})
	end
	local rentarg = dgsElementData[source].renderTarget
	if rentarg then
		if isElement(rentarg[1]) then
			destroyElement(rentarg[1])
		end
		if isElement(rentarg[2]) then
			destroyElement(rentarg[2])
		end
		if not dgsElementData[source].mode then
			local columnRender = dxCreateRenderTarget(relSizX+scbThick,columnHeight,true)
			local rowRender = dxCreateRenderTarget(relSizX+scbThick,relSizY-columnHeight,true)
			emSetData(source,"renderTarget",{columnRender,rowRender})
		end
	end
end

function dxGridListResetScrollBarPosition(gridlist,vertical,horizontal)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListResetScrollBarPosition at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	local scrollbars = dgsElementData[gridlist].scrollbars
	if not vertical then
		dxScrollBarSetScrollBarPosition(scrollbars[1],0)
	end
	if not horizontal then
		dxScrollBarSetScrollBarPosition(scrollbars[2],0)
	end
	return true
end

function dxGridListGetScrollBar(gridlist)
	assert(dxGetType(gridlist) == "dgs-dxgridlist","Bad argument @dxGridListGetScrollBar at argument 1, expect dgs-dxgridlist got "..dxGetType(gridlist))
	return dgsElementData[gridlist].scrollbars
end