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

local editsCount = 1
function dxCreateEdit(x, y, sx, sy, text, relative, parent, textcolor, scalex, scaley, bgimage, bgcolor, selectmode)
	assert(type(x) == "number","Bad argument @dxCreateEdit at argument 1, expect number got "..type(x))
	assert(type(y) == "number","Bad argument @dxCreateEdit at argument 2, expect number got "..type(y))
	assert(type(sx) == "number","Bad argument @dxCreateEdit at argument 3, expect number got "..type(sx))
	assert(type(sy) == "number","Bad argument @dxCreateEdit at argument 4, expect number got "..type(sy))
	text = tostring(text)
	if isElement(parent) then
		assert(emIsDxElement(parent),"@dxCreateEdit argument 7,expect dgs-dxgui got "..dxGetType(parent))
	end
	local edit = createElement("dgs-dxedit")
	dgsSetType(edit,"dgs-dxedit")
	emSetData(edit,"bgimage",bgimage)
	emSetData(edit,"bgcolor",bgcolor or schemeColor.edit.bgcolor)
	emSetData(edit,"text",tostring(text) or "")
	emSetData(edit,"textcolor",textcolor or schemeColor.edit.textcolor)
	emSetData(edit,"textsize",{scalex or 1,scaley or 1})
	emSetData(edit,"cursorpos",0)
	emSetData(edit,"selectfrom",0)
	emSetData(edit,"masked",false)
	emSetData(edit,"maskText","*")
	emSetData(edit,"showPos",0)
	emSetData(edit,"sideWhite",{2,1})
	emSetData(edit,"center",false)
	emSetData(edit,"cursorStyle",0)
	emSetData(edit,"cursorThick",1.2)
	emSetData(edit,"cursorOffset",3)
	emSetData(edit,"readOnly",false)
	emSetData(edit,"readOnlyCaretShow",false)
	emSetData(edit,"clearSelection",true)
	emSetData(edit,"font",systemFont)
	emSetData(edit,"side",0)
	emSetData(edit,"sidecolor",schemeColor.edit.sidecolor)
	emSetData(edit,"enableTabSwitch",true)
	emSetData(edit,"caretColor",schemeColor.edit.caretcolor)
	emSetData(edit,"caretHeight",1)
	emSetData(edit,"selectmode",selectmode and false or true) -- TRUE: Choose color at bottom of text, FALSE: Choose color at top.
	emSetData(edit,"selectcolor",selectmode and tocolor(50,150,255,100) or tocolor(50,150,255,200))
	local gedit = guiCreateEdit(0,0,0,0,tostring(text) or "",false,GlobalEditParent)
	guiSetProperty(gedit,"ClippedByParent","False")
	emSetData(edit,"edit",gedit)
	emSetData(gedit,"dxedit",edit)
	guiSetAlpha(gedit, 0)
	emSetData(edit, "maxLength", guiGetProperty(gedit, "MaxTextLength"))
	emSetData(edit, "editCounts", editsCount) -- Tab Switch.
	editsCount = editsCount + 1
	if isElement(parent) then
		dxSetParent(edit,parent)
	else
		table.insert(MaxFatherTable,edit)
	end
	insertResourceDxGUI(sourceResource,edit)
	triggerEvent("onDgsPreCreate",edit)
	calculateGuiPositionSize(edit,x,y,relative or false,sx,sy,relative or false,true)
	triggerEvent("onDgsCreate",edit)
	local sx,sy = dxGetSize(edit,false)
	local sideWhite = dgsElementData[edit].sideWhite
	local sizex,sizey = sx-sideWhite[1]*2,sy-sideWhite[2]*2
	local renderTarget = dxCreateRenderTarget(math.floor(sizex),math.floor(sizey),true)
	emSetData(edit,"renderTarget",renderTarget)
	dxEditSetCaretPosition(edit,utf8.len(tostring(text) or ""))
	return edit
end

function dxEditSetMasked(edit, masked)
	assert(dxGetType(edit) == "dgs-dxedit","Bad argument @dxEditSetMasked at argument 1, expect dgs-dxedit got "..dxGetType(edit))
	return emSetData(edit,"masked",masked and true or false)
end

function dxEditGetMasked(edit)
	assert(dxGetType(edit) == "dgs-dxedit","Bad argument @dxEditGetMasked at argument 1, expect dgs-dxedit got "..dxGetType(edit))
	return dgsElementData[edit].masked
end

function dxEditMoveCaret(edit, offset, selectText)
	assert(dxGetType(edit) == "dgs-dxedit","Bad argument @dxEditMoveCaret at argument 1, expect dgs-dxedit got "..dxGetType(edit))
	assert(type(offset) == "number","Bad argument @dxEditMoveCaret at argument 2, expect number got "..type(offset))
	local guiedit = dgsElementData[edit].edit
	local text = guiGetText(guiedit)
	if dgsElementData[edit].masked then
		text = string.rep(dgsElementData[edit].maskText,utf8.len(text))
	end
	local pos = dgsElementData[edit].cursorpos+math.floor(offset)
	if pos < 0 then
		pos = 0
	elseif pos > utf8.len(text) then
		pos = utf8.len(text)
	end
	local showPos = dgsElementData[edit].showPos
	local font = dgsElementData[edit].font
	local sx = dgsElementData[edit].absSize[1]
	local sideWhite = dgsElementData[edit].sideWhite
	local startX = 0
	local center = dgsElementData[edit].center
	if center then
		local txtSizX = dgsElementData[edit].textsize[1]
		local alllen = dxGetTextWidth(text,txtSizX,font)
		startX = sx/2-alllen/2-showPos/2
	end
	local nowLen = dxGetTextWidth(utf8.sub(text,0,pos),dgsElementData[edit].textsize[1],font)+startX
	if nowLen+showPos > sx-sideWhite[1] then
		emSetData(edit,"showPos",sx-sideWhite[1]-nowLen)
	elseif nowLen+showPos < 0 then
		emSetData(edit,"showPos",-nowLen)
	end
	emSetData(edit,"cursorpos",pos)
	local isReadOnlyShow = true
	if dgsElementData[edit].readOnly then
		isReadOnlyShow = dgsElementData[edit].readOnlyCaretShow
	end
	if not selectText or not isReadOnlyShow then
		emSetData(edit,"selectfrom",pos)
	end
	resetTimer(MouseData.EditTimer)
	MouseData.editCursor = true
	return true
end

function dxEditSetCaretPosition(edit, pos, selectText)
	assert(dxGetType(edit) == "dgs-dxedit","Bad argument @dxEditSetCaretPosition at argument 1, expect dgs-dxedit got "..dxGetType(edit))
	assert(type(pos) == "number","Bad argument @dxEditSetCaretPosition at argument 2, expect number got "..type(pos))
	local text = guiGetText(dgsElementData[edit].edit)
	if dgsElementData[edit].masked then
		text = string.rep(dgsElementData[edit].maskText,utf8.len(text))
	end
	if pos > utf8.len(text) then
		pos = utf8.len(text)
	elseif pos < 0 then
		pos = 0
	end
	emSetData(edit,"cursorpos",math.floor(pos))
	if not selectText then
		emSetData(edit,"selectfrom",math.floor(pos))
	end
	local showPos = dgsElementData[edit].showPos
	local font = dgsElementData[edit].font
	local sx = dgsElementData[edit].absSize[1]
	local sideWhite = dgsElementData[edit].sideWhite
	local startX = 0
	local center = dgsElementData[edit].center
	if center then
		local txtSizX = dgsElementData[edit].textsize[1]
		local alllen = dxGetTextWidth(text,txtSizX,font)
		startX = sx/2-alllen/2-showPos/2
	end
	local nowLen = dxGetTextWidth(utf8.sub(text,0,pos),emGetData(edit,"textsize")[1],font)+startX
	if nowLen+showPos > sx-sideWhite[1] then
		emSetData(edit,"showPos",sx-sideWhite[1]-nowLen)
	elseif nowLen+showPos < 0 then
		emSetData(edit,"showPos",-nowLen)
	end
	return true
end

function dxEditGetCaretPosition(edit)
	assert(dxGetType(edit) == "dgs-dxedit","Bad argument @dxEditGetCaretPosition at argument 1, expect dgs-dxedit got "..dxGetType(edit))
	return emGetData(edit,"cursorpos")
end

function dxEditSetCaretStyle(edit, style)
	assert(dxGetType(edit) == "dgs-dxedit","Bad argument @dxEditSetCaretStyle at argument 1, expect dgs-dxedit got "..dxGetType(edit))
	assert(type(style) == "number","Bad argument @dxEditSetCaretStyle at argument 2, expect number got "..type(style))
	return emSetData(edit,"cursorStyle",style)
end

function dxEditGetCaretStyle(edit, style)
	assert(dxGetType(edit) == "dgs-dxedit","Bad argument @dxEditGetCaretStyle at argument 1, expect dgs-dxedit got "..dxGetType(edit))
	return dgsElementData[edit].cursorStyle
end

function dxEditSetMaxLength(edit, maxLength)
	assert(dxGetType(edit) == "dgs-dxedit","Bad argument @dxEditSetMaxLength at argument 1, expect dgs-dxedit got "..dxGetType(edit))
	assert(type(maxLength) == "number","Bad argument @dxEditSetMaxLength at argument 2, expect number got "..type(maxLength))
	local guiedit = dgsElementData[edit].edit
	emSetData(edit,"maxLength",maxLength)
	return guiEditSetMaxLength(guiedit,maxLength)
end

function dxEditGetMaxLength(edit, fromgui)
	assert(dxGetType(edit) == "dgs-dxedit","Bad argument @dxEditGetMaxLength at argument 1, expect dgs-dxedit got "..dxGetType(edit))
	local guiedit = dgsElementData[edit].edit
	if fromgui then
		return guiGetProperty(guiedit,"MaxTextLength")
	else
		return dgsElementData[edit].maxLength
	end
end

function dxEditSetReadOnly(edit, state)
	assert(dxGetType(edit) == "dgs-dxedit","Bad argument @dxEditSetReadOnly at argument 1, expect dgs-dxedit got "..dxGetType(edit))
	local guiedit = dgsElementData[edit].edit
	return emSetData(edit,"readOnly",state and true or false)
end

function dxEditGetReadOnly(edit)
	assert(dxGetType(edit) == "dgs-dxedit","Bad argument @dxEditGetReadOnly at argument 1, expect dgs-dxedit got "..dxGetType(edit))
	return emGetData(edit,"readOnly")
end

function configEdit(source)
	local myedit = emGetData(source,"edit")
	local x,y = unpack(emGetData(source,"absSize"))
	guiSetSize(myedit,x,y,false)
	local sideWhite = dgsElementData[source].sideWhite
	local px,py = math.floor(x-sideWhite[1]*2), math.floor(y-sideWhite[2]*2)
	local renderTarget = dxCreateRenderTarget(px,py,true)
	emSetData(source,"renderTarget",renderTarget)
	local oldPos = dxEditGetCaretPosition(source)
	dxEditSetCaretPosition(source,0)
	dxEditSetCaretPosition(source,oldPos)
end

function resetEdit(x,y)
	if dxGetType(MouseData.nowShow) == "dgs-dxedit" then
		if MouseData.nowShow == MouseData.clickl then
			local edit = dgsElementData[MouseData.nowShow].edit
			local pos = searchEditMousePosition(MouseData.nowShow,x*sW,y*sH)
			dxEditSetCaretPosition(MouseData.nowShow,pos,true)
		end
	end
end
addEventHandler("onClientCursorMove",root,resetEdit)

function searchEditMousePosition(dxedit, posx, posy)
	local edit = dgsElementData[dxedit].edit
	if isElement(edit) then
		local text = guiGetText(edit)
		local sfrom,sto = 0,utf8.len(text)
		if dgsElementData[edit].masked then
			text = string.rep(dgsElementData[edit].maskText,sto)
		end
		local font = dgsElementData[dxedit].font or systemFont
		local txtSizX = dgsElementData[dxedit].textsize[1]
		local offset = dgsElementData[dxedit].showPos
		local x = dxGetPosition(dxedit,false,true)
		local center = dgsElementData[dxedit].center 
		local sideWhite = dgsElementData[dxedit].sideWhite
		local startX = sideWhite[1]
		if center then
			local sx,sy = dgsElementData[dxedit].absSize[1],dgsElementData[dxedit].absSize[2]
			local alllen = dxGetTextWidth(text,txtSizX,font)
			startX = sx/2-alllen/2-offset/2
		end
		local pos = posx-x-offset-startX
		local templen = 0
		for i=1,sto do
			local strlen = dxGetTextWidth(utf8.sub(text,sfrom+1,sto/2+sfrom/2),txtSizX,font)
			local len1 = strlen+templen
			if pos < len1 then
				sto = math.floor(sto/2+sfrom/2)
			elseif pos > len1 then
				sfrom = math.floor(sto/2+sfrom/2)
				templen = dxGetTextWidth(utf8.sub(text,0,sfrom),txtSizX,font)
				start = len1
			elseif pos == len1 then
				start = len1
				sto = sfrom
				templen = dxGetTextWidth(utf8.sub(text,0,sfrom),txtSizX,font)
			end
			if sto-sfrom <= 10 then
				break
			end
		end
		local start = dxGetTextWidth(utf8.sub(text,0,sfrom),txtSizX,font)
		for i=sfrom,sto do
			local poslen1 = dxGetTextWidth(utf8.sub(text,sfrom+1,i),txtSizX,font)+start
			local theNext = dxGetTextWidth(utf8.sub(text,i+1,i+1),txtSizX,font)/2
			local offsetR = theNext+poslen1
			local theLast = dxGetTextWidth(utf8.sub(text,i,i),txtSizX,font)/2
			local offsetL = poslen1-theLast
			if i <= sfrom and pos <= offsetL then
				return sfrom
			elseif i >= sto and pos >= offsetR then
				return sto
			elseif pos >= offsetL and pos <= offsetR then
				return i
			end
		end
		return -1
	end
end

function checkEditMousePosition(button, state, x, y)
	if dxGetType(source) == "dgs-dxedit" then
		if state == "down" then
			local pos = searchEditMousePosition(source,x,y)
			dxEditSetCaretPosition(source,pos)
		end
	end
end
addEventHandler("onDgsMouseClick",root,checkEditMousePosition)

addEventHandler("onClientGUIAccepted",root,function()
	local mydxedit = emGetData(source,"dxedit")
	if dxGetType(mydxedit) == "dgs-dxedit" then
		local cmd = emGetData(mydxedit,"mycmd")
		if dxGetType(cmd) == "dgs-dxcmd" then
			local text = guiGetText(source)
			if text ~= "" then
				receiveCmdEditInput(cmd,text)
			end
			guiSetText(source, "")
		end
	end
end)

function dxEditSetWhiteList(edit, str)
	assert(dxGetType(edit) == "dgs-dxedit","Bad argument @dxEditSetWhiteList at argument 1, expect dgs-dxedit got "..dxGetType(edit))
	if type(str) == "string" then
		emSetData(edit,"whiteList",str)
	else
		emSetData(edit,"whiteList",nil)
	end
end

addEventHandler("onDgsEditPreSwitch",resourceRoot,function()
	if not wasEventCancelled() then
		if not dgsElementData[source].enableTabSwitch then return end
		local parent = FatherTable[source]
		local theTable = isElement(parent) and ChildrenTable[parent] or (dgsElementData[source].alwaysOnBottom and BottomFatherTable or MaxFatherTable)
		local id = dgsElementData[source].editCounts
		if id then
			local theNext
			local theFirst
			for k,v in ipairs(theTable) do
				local editCounts = dgsElementData[v].editCounts
				if editCounts and dgsElementData[v].enabled and dgsElementData[v].visible and not dgsElementData[v].readOnly then
					if id ~= editCounts and dxGetType(v) == "dgs-dxedit" and dgsElementData[v].enableTabSwitch then
						if editCounts < id then
							theFirst = theFirst and (dgsElementData[theFirst].editCounts > editCounts and v or theFirst) or v
						else
							theNext = theNext and (dgsElementData[theNext].editCounts > editCounts and v or theNext) or v
						end
					end
				end
			end
			local theFinal = theNext or theFirst
			if theFinal then
				dxBringToFront(theFinal)
				triggerEvent("onDgsEditSwitched",theFinal,source)
			end
		end
	end
end)