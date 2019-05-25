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

function dxCreateMemo(x, y, sx, sy, text, relative, parent, textcolor, scalex, scaley, bgimage, bgcolor)
	assert(type(x) == "number","Bad argument @dxCreateMemo at argument 1, expect number got "..type(x))
	assert(type(y) == "number","Bad argument @dxCreateMemo at argument 2, expect number got "..type(y))
	assert(type(sx) == "number","Bad argument @dxCreateMemo at argument 3, expect number got "..type(sx))
	assert(type(sy) == "number","Bad argument @dxCreateMemo at argument 4, expect number got "..type(sy))
	text = tostring(text)
	if isElement(parent) then
		assert(emIsDxElement(parent),"Bad argument @dxCreateMemo at argument 7, expect dgs-dxgui got "..dxGetType(parent))
	end

	local memo = createElement("dgs-dxmemo")

	--[[
	if (relative) then -- Memobox fix for relative.
		local guiSX, guiSY = dxGetSize(parent, false)
		x = guiSX * x
		y = guiSY * y - 25 -- 25 to compensate for titlebar.
		sx = guiSX * sx
		sy = guiSY * sy + 20

		relative = false
	end]]

	dgsSetType(memo,"dgs-dxmemo")
	emSetData(memo,"bgimage",bgimage)
	emSetData(memo,"bgcolor",bgcolor or schemeColor.memo.bgcolor)
	dgsElementData[memo].text = {}
	emSetData(memo,"textLength",{""})
	emSetData(memo,"textcolor",textcolor or schemeColor.memo.textcolor)
	emSetData(memo,"textsize",{scalex or 1, scaley or 1})
	emSetData(memo,"cursorposXY",{0,1})
	emSetData(memo,"selectfrom",{0,1})
	emSetData(memo,"rightLength",{0,1})
	emSetData(memo,"showPos",0)
	emSetData(memo,"showLine",1)
	emSetData(memo,"cursorStyle",0)
	emSetData(memo,"cursorThick",1.2)
	emSetData(memo,"caretColor",schemeColor.memo.caretcolor)
	emSetData(memo,"caretHeight",1)
	emSetData(memo,"scrollBarThick",20)
	emSetData(memo,"cursorOffset",{0,0})
	emSetData(memo,"readOnly",false)
	emSetData(memo,"font",tabsFont)
	emSetData(memo,"side",0)
	emSetData(memo,"sidecolor",schemeColor.memo.sidecolor)
	emSetData(memo,"enableTabSwitch",true)
	emSetData(memo,"useFloor",false)
	emSetData(memo,"readOnlyCaretShow",false)
	emSetData(memo,"editmemoSign",true)
	emSetData(memo,"selectcolor",selectmode and tocolor(50,150,255,100) or tocolor(50,150,255,200))
	local gmemo = guiCreateMemo(0,0,0,0,"",false)
	emSetData(memo,"memo",gmemo)
	emSetData(gmemo,"dxmemo",memo)
	guiSetAlpha(gmemo,0)
	guiSetProperty(gmemo,"AlwaysOnTop","True")
	emSetData(memo,"maxLength",guiGetProperty(gmemo,"MaxTextLength"))
	if isElement(parent) then
		dxSetParent(memo,parent)
	else
		table.insert(MaxFatherTable,memo)
	end
	insertResourceDxGUI(sourceResource,memo)
	triggerEvent("onDgsPreCreate",memo)
	calculateGuiPositionSize(memo,x,y,relative or false,sx,sy,relative or false,true)
	local abx,aby = unpack(dgsElementData[memo].absSize)
	local scrollbar1 = dxCreateScrollBar(abx-20,0,20,aby-20,false,false,memo)
	local scrollbar2 = dxCreateScrollBar(0,aby-20,abx-20,20,true,false,memo)
	dxSetVisible(scrollbar1,false)
	dxSetVisible(scrollbar2,false)
	emSetData(scrollbar1,"length",{0,true})
	emSetData(scrollbar2,"length",{0,true})
	local renderTarget = dxCreateRenderTarget(abx-4,aby,true)
	emSetData(memo,"renderTarget",renderTarget)
	emSetData(memo,"scrollbars",{scrollbar1,scrollbar2})
	handleDxMemoText(memo,text,false,true)
	dxMemoSetCaretPosition(memo,utf8.len(tostring(text)))
	triggerEvent("onDgsCreate",memo)
	return memo
end

function dxMemoGetScrollBar(memo)
	assert(dxGetType(memo) == "dgs-dxmemo","Bad argument @dxMemoGetScrollBar at argument 1, expect dgs-dxmemo got "..dxGetType(memo))
	return dgsElementData[memo].scrollbars
end

function dxMemoMoveCaret(memo,offset,lineoffset,noselect,noMoveLine)
	assert(dxGetType(memo) == "dgs-dxmemo","Bad argument @dxMemoMoveCaret at argument 1, expect dgs-dxmemo got "..dxGetType(memo))
	assert(type(offset) == "number","Bad argument @dxMemoMoveCaret at argument 2, expect number got "..type(offset))
	lineoffset = lineoffset or 0
	local xpos = dgsElementData[memo].cursorposXY[1]
	local line = dgsElementData[memo].cursorposXY[2]
	local textTable = dgsElementData[memo].text
	local text = textTable[line] or ""
	local pos,line = dxMemoSeekPosition(textTable,xpos+math.floor(offset),line+math.floor(lineoffset),noMoveLine)
	local showPos,showLine = dgsElementData[memo].showPos,dgsElementData[memo].showLine
	local font = dgsElementData[memo].font
	local nowLen = dxGetTextWidth(utf8.sub(text,0,pos),dgsElementData[memo].textsize[1],font)
	local fontHeight = dxGetFontHeight(dgsElementData[memo].textsize[2],font)
	local size = dgsElementData[memo].absSize
	local targetLen = nowLen+showPos
	local targetLine = line-showLine
	local scbThick = dgsElementData[memo].scrollBarThick
	local scrollbars = dgsElementData[memo].scrollbars
	local scbTakes = {dgsElementData[scrollbars[1]].visible and scbThick or 0,dgsElementData[scrollbars[2]].visible and scbThick or 0}
	local canHold = math.floor((size[2]-scbTakes[2])/fontHeight)
	if targetLen > size[1]-scbTakes[1]-4 then
		emSetData(memo,"showPos",size[1]-scbTakes[1]-4-nowLen)
		syncScrollBars(memo,2)
	elseif targetLen < 0 then
		emSetData(memo,"showPos",-nowLen)
		syncScrollBars(memo,2)
	end
	if targetLine >= canHold then
		emSetData(memo,"showLine",line-canHold+1)
		syncScrollBars(memo,1)
	elseif targetLine < 1 then
		emSetData(memo,"showLine",line)
		syncScrollBars(memo,1)
	end
	emSetData(memo,"cursorposXY",{pos,line})	
	local isReadOnlyShow = true
	if dgsElementData[memo].readOnly then
		isReadOnlyShow = dgsElementData[memo].readOnlyCaretShow
	end
	if not noselect or not isReadOnlyShow then
		emSetData(memo,"selectfrom",{pos,line})
	end
	resetTimer(MouseData.MemoTimer)
	MouseData.memoCursor = true
	return true
end

function dxMemoSeekPosition(textTable,pos,line,noMoveLine)
	local line = (line < 1 and 1) or (line > #textTable and #textTable) or line
	local text = textTable[line] or ""
	local strCount = utf8.len(text)
	if not noMoveLine then
		while true do
			if pos < 0 then
				if line-1 >= 1 then
					line = line-1
					text = textTable[line] or ""
					strCount = utf8.len(text)
					pos = strCount+pos+1
					if pos >= 0 then
						break
					end
				else
					pos = 0
					break
				end
			elseif pos > strCount then
				if line+1 <= #textTable then
					pos = pos-strCount-1
					line = line+1
					text = textTable[line] or ""
					strCount = utf8.len(text)
					if pos <= strCount then
						break
					end
				else
					pos = strCount
					break
				end
			else
				break
			end
		end
		return pos,line
	else
		return pos >= strCount and strCount or pos,line
	end
end

function dxMemoSetCaretPosition(memo,tpos,tline,noselect)
	assert(dxGetType(memo) == "dgs-dxmemo","Bad argument @dxMemoSetCaretPosition at argument 1, expect dgs-dxmemo got "..dxGetType(memo))
	assert(type(tpos) == "number","Bad argument @dxMemoSetCaretPosition at argument 2, expect number got "..type(tpos))
	local textTable = dgsElementData[memo].text
	local curpos = dgsElementData[memo].cursorposXY
	tline = tline or curpos[2]
	local text = textTable[tline] or ""
	local pos,line = dxMemoSeekPosition(textTable,tpos,tline)
	local showPos,showLine = dgsElementData[memo].showPos,dgsElementData[memo].showLine
	local font = dgsElementData[memo].font
	local nowLen = dxGetTextWidth(utf8.sub(text,0,pos),dgsElementData[memo].textsize[1],font)
	local fontHeight = dxGetFontHeight(dgsElementData[memo].textsize[2],font)
	local size = dgsElementData[memo].absSize
	local targetLen = nowLen+showPos
	local targetLine = tline-showLine+1
	local scbThick = dgsElementData[memo].scrollBarThick
	local scrollbars = dgsElementData[memo].scrollbars
	local scbTakes = {dgsElementData[scrollbars[1]].visible and scbThick or 0,dgsElementData[scrollbars[2]].visible and scbThick or 0}
	local canHold = math.floor((size[2]-scbTakes[2])/fontHeight)
	if targetLen > size[1]-scbTakes[1]-4 then
		emSetData(memo,"showPos",size[1]-scbTakes[1]-4-nowLen)
		syncScrollBars(memo,2)
	elseif targetLen < 0 then
		emSetData(memo,"showPos",-nowLen)
		syncScrollBars(memo,2)
	end
	if targetLine >= canHold then
		emSetData(memo,"showLine",line-canHold+1)
		syncScrollBars(memo,1)
	elseif targetLine < 0 then
		emSetData(memo,"showLine",line)
		syncScrollBars(memo,1)
	end
	emSetData(memo,"cursorposXY",{pos,line})
	if not noselect then
		emSetData(memo,"selectfrom",{pos,line})
	end
	return true
end

function dxMemoGetCaretPosition(memo,detail)
	assert(dxGetType(memo) == "dgs-dxmemo","Bad argument @dxMemoGetCaretPosition at argument 1, expect dgs-dxmemo got "..dxGetType(memo))
	return dgsElementData[memo].cursorposXY[1],dgsElementData[memo].cursorposXY[2]
end

function dxMemoSetCaretStyle(memo,style)
	assert(dxGetType(memo) == "dgs-dxmemo","Bad argument @dxMemoSetCaretStyle at argument 1, expect dgs-dxmemo got "..dxGetType(memo))
	assert(type(style) == "number","Bad argument @dxMemoSetCaretStyle at argument 2, expect number got "..type(style))
	return emSetData(memo,"cursorStyle",style)
end

function dxMemoGetCaretStyle(memo,style)
	assert(dxGetType(memo) == "dgs-dxmemo","Bad argument @dxMemoGetCaretStyle at argument 1, expect dgs-dxmemo got "..dxGetType(memo))
	return dgsElementData[memo].cursorStyle
end

function dxMemoSetReadOnly(memo,state)
	assert(dxGetType(memo) == "dgs-dxmemo","Bad argument @dxMemoSetReadOnly at argument 1, expect dgs-dxmemo got "..dxGetType(memo))
	local guimemo = dgsElementData[memo].memo
	return emSetData(memo,"readOnly",state and true or false)
end

function dxMemoGetReadOnly(memo)
	assert(dxGetType(memo) == "dgs-dxmemo","Bad argument @dxMemoGetReadOnly at argument 1, expect dgs-dxmemo got "..dxGetType(memo))
	return emGetData(memo,"readOnly")
end

function resetMemo(x,y)
	if dxGetType(MouseData.nowShow) == "dgs-dxmemo" then
		if MouseData.nowShow == MouseData.clickl then
			local pos,line = searchMemoMousePosition(MouseData.nowShow,x*sW,y*sH)
			dxMemoSetCaretPosition(MouseData.nowShow,pos,line,true)
		end
	end
end
addEventHandler("onClientCursorMove",root,resetMemo)

function searchMemoMousePosition(dxmemo,posx,posy)
	local memo = dgsElementData[dxmemo].memo
	if isElement(memo) then
		local size = dgsElementData[dxmemo].absSize
		local font = dgsElementData[dxmemo].font or systemFont
		local txtSizX = dgsElementData[dxmemo].textsize[1]
		local fontHeight = dxGetFontHeight(dgsElementData[dxmemo].textsize[2],font)
		local offset = dgsElementData[dxmemo].showPos
		local showLine = dgsElementData[dxmemo].showLine
		local x,y = dxGetPosition(dxmemo,false,true)
		local allText = dgsElementData[dxmemo].text
		local selLine = math.floor((posy-y)/fontHeight)+showLine
		selLine = selLine > #allText and #allText or selLine 
		local text = dgsElementData[dxmemo].text[selLine] or ""
		local pos = posx-x-offset
		local sfrom,sto,templen = 0,utf8.len(text),0
		for i=1,sto do
			local strlen = dxGetTextWidth(utf8.sub(text,sfrom+1,sto/2+sfrom/2),txtSizX,font)
			local len1 = strlen+templen
			if pos < len1 then
				sto = math.floor((sto+sfrom)/2)
			elseif pos > len1 then
				sfrom = math.floor((sto+sfrom)/2)
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
				return sfrom,selLine
			elseif i >= sto and pos >= offsetR then
				return sto,selLine
			elseif pos >= offsetL and pos <= offsetR then
				return i,selLine
			end
		end
		return 0,1
	end
	return false
end

local splitChar = "\r\n"
local splitChar2 = "\n"
function handleDxMemoText(memo,text,noclear,noAffectCaret,index,line)
	local textTable = dgsElementData[memo].text
	local textLen = dgsElementData[memo].textLength
	local str = textTable
	if not noclear then
		dgsElementData[memo].text = {""}
		dgsElementData[memo].textLength = {}
		textTable = dgsElementData[memo].text
		textLen = dgsElementData[memo].textLength
		emSetData(memo,"cursorposXY",{0,1})
		emSetData(memo,"selectfrom",{0,1})
		emSetData(memo,"rightLength",{0,1})
		configMemo(memo)
	end
	local font = dgsElementData[memo].font
	local textsize = dgsElementData[memo].textsize
	local _index,_line = dxMemoGetCaretPosition(memo,true)
	local index,line = index or _index,line or _line
	local fixed = utf8.gsub(text,splitChar,splitChar2)
	local fixed = utf8.gsub(fixed,"	"," ")
	fixed = " "..fixed.." "
	local tab = string.split(fixed,splitChar2)
	tab[1] = utf8.sub(tab[1],2)
	tab[#tab] = utf8.sub(tab[#tab],1,utf8.len(tab[#tab])-1)
	local offset = 0
	if tab ~= 0 then
		if #tab == 1 then
			tab[1] = tab[1] or ""
			offset = utf8.len(tab[1])+1
			textTable[line] = utf8.insert(textTable[line] or "",index+1,tab[1])
			textLen[line] = dxGetTextWidth(textTable[line],textsize[1],font)
			if dgsElementData[memo].rightLength[1] < textLen[line] then
				dgsElementData[memo].rightLength = {textLen[line],line}
			end
		else
			tab[1] = tab[1] or ""
			offset = offset+utf8.len(tab[1])+1
			textTable[line] = textTable[line] or ""
			local txt1 = utf8.sub(textTable[line],0,index) or ""
			local txt2 = utf8.sub(textTable[line],index+1) or ""
			textTable[line] = (txt1)..(tab[1])
			textLen[line] = dxGetTextWidth(textTable[line],textsize[1],font)
			for i=2,#tab do
				tab[i] = tab[i] or ""
				offset = offset+utf8.len(tab[i])+1
				local theline = line+i-1
				table.insert(textTable,theline,tab[i])
				table.insert(textLen,theline,dxGetTextWidth(tab[i],textsize[1],font))
				if dgsElementData[memo].rightLength[1] < textLen[theline] then
					dgsElementData[memo].rightLength = {textLen[theline],theline}
				elseif dgsElementData[memo].rightLength[2] > line+#tab-1 then
					dgsElementData[memo].rightLength[2] = dgsElementData[memo].rightLength[2]+1
				end
				if i == #tab then
					textTable[theline] = (tab[i] or "")..txt2
					textLen[theline] = dxGetTextWidth(textTable[theline],textsize[1],font)
					if dgsElementData[memo].rightLength[1] < textLen[theline] then
						dgsElementData[memo].rightLength = {textLen[theline],theline}
					elseif dgsElementData[memo].rightLength[2] > line+#tab-1 then
						dgsElementData[memo].rightLength[2] = dgsElementData[memo].rightLength[2]+1
					end
				end
			end
		end
		dgsElementData[memo].text = textTable
		dgsElementData[memo].textLength = textLen
		local font = dgsElementData[memo].font
		local fontHeight = dxGetFontHeight(dgsElementData[memo].textsize[2],font)
		local size = dgsElementData[memo].absSize
		local scbThick = dgsElementData[memo].scrollBarThick
		local scrollbars = dgsElementData[memo].scrollbars
		local scbTakes = {dgsElementData[scrollbars[1]].visible and scbThick or 0,dgsElementData[scrollbars[2]].visible and scbThick or 0}
		local canHold = math.floor((size[2]-scbTakes[2])/fontHeight)
		if dgsElementData[memo].rightLength[1] > size[1]-scbTakes[1] then
			configMemo(memo)
		else
			if dgsElementData[scrollbars[1]].visible then
				configMemo(memo)
			end
		end
		if #textTable > canHold then
			configMemo(memo)
		else
			if dgsElementData[scrollbars[2]].visible then
				configMemo(memo)
			end
		end
		if not noAffectCaret then
			if line < _line or (line == _line and index <= _index) then
				dxMemoSetCaretPosition(memo,index+offset-1,line)
			end
		end
		triggerEvent("onDgsTextChange",memo,str)
	end
end

function dxMemoInsertText(memo,index,line,text,noAffectCaret)
	assert(dxGetType(memo) == "dgs-dxmemo","Bad argument @dxMemoInsertText at argument 1, expect dgs-dxmemo got "..dxGetType(memo))
	assert(dxGetType(index) == "number","Bad argument @dxMemoInsertText at argument 2, expect number got "..dxGetType(index))
	assert(dxGetType(line) == "number","Bad argument @dxMemoInsertText at argument 3, expect number got "..dxGetType(line))
	assert(type(text) == "number" or type(text) == "string","Bad argument @dxMemoInsertText at argument 4, expect string/number got "..dxGetType(text))
	return handleDxMemoText(memo,tostring(text),true,noAffectCaret,index,line)
end

function dxMemoDeleteText(memo,fromindex,fromline,toindex,toline,noAffectCaret)
	assert(dxGetType(memo) == "dgs-dxmemo","Bad argument @dxMemoDeleteText at argument 1, expect dgs-dxmemo got "..dxGetType(memo))
	local textTable = dgsElementData[memo].text
	local textLen = dgsElementData[memo].textLength
	local font = dgsElementData[memo].font
	local textsize = dgsElementData[memo].textsize
	local textLines = #textTable
	if fromline < 1 then
		fromline = 1
	elseif fromline > textLines then
		fromline = textLines
	end
	if toline < 1 then
		toline = 1
	elseif toline > textLines then
		toline = textLines
	end
	local lineTextFrom = textTable[fromline]
	local lineTextTo = textTable[toline]
	local lineTextFromCnt = utf8.len(lineTextFrom)
	local lineTextToCnt = utf8.len(lineTextTo)
	if fromindex < 0 then
		fromindex = 0
	elseif fromindex > lineTextFromCnt then
		toline = lineTextFromCnt
	end
	if toindex < 0 then
		toindex = 0
	elseif toindex > lineTextToCnt then
		toline = lineTextToCnt
	end
	if fromline > toline then
		local temp = toline
		toline = fromline
		fromline = temp
		local temp = toindex
		toindex = fromindex
		fromindex = temp
	end
	if fromline == toline then
		local _to = toindex < fromindex  and fromindex or toindex
		local _from = fromindex > toindex and toindex or fromindex
		textTable[toline] = utf8.sub(textTable[toline],0,_from)..utf8.sub(textTable[toline],_to+1)
		textLen[toline] = dxGetTextWidth(textTable[toline],textsize[1],font)
	else
		textTable[fromline] = utf8.sub(textTable[fromline],0,fromindex)..utf8.sub(textTable[toline],toindex+1)
		textLen[fromline] = dxGetTextWidth(textTable[fromline],textsize[1],font)
		for i=fromline+1,toline do
			table.remove(textTable,fromline+1)
			table.remove(textLen,fromline+1)
		end
	end
	dgsElementData[memo].text = textTable
	dgsElementData[memo].textLength = textLen
	local line,len = seekMaxLengthLine(memo)
	dgsElementData[memo].rightLength = {len,line}
	local font = dgsElementData[memo].font
	local fontHeight = dxGetFontHeight(dgsElementData[memo].textsize[2],font)
	local size = dgsElementData[memo].absSize
	local scbThick = dgsElementData[memo].scrollBarThick
	local scrollbars = dgsElementData[memo].scrollbars
	local scbTakes = {dgsElementData[scrollbars[1]].visible and scbThick or 0,dgsElementData[scrollbars[2]].visible and scbThick or 0}
	local canHold = math.floor((size[2]-scbTakes[2])/fontHeight)
	if dgsElementData[memo].rightLength[1] > size[1]-scbTakes[1] then
		configMemo(memo)
	else
		if dgsElementData[scrollbars[1]].visible then
			configMemo(memo)
		end
	end
	if #textTable > canHold then
		configMemo(memo)
	else
		if dgsElementData[scrollbars[2]].visible then
			configMemo(memo)
		end
	end
	if not noAffectCaret then
		local cpos = dgsElementData[memo].cursorposXY
		if cpos[2] > fromline then
			dxMemoSetCaretPosition(memo,cpos[1]-(toindex-fromindex),cpos[2]-(toline-fromline))
		elseif cpos[2] == fromline and cpos[1] >= fromindex then
			dxMemoSetCaretPosition(memo,fromindex,fromline)
		end
	end
end

function dxMemoClearText(memo)
	assert(dxGetType(memo) == "dgs-dxmemo","Bad argument @dxMemoClearText at argument 1, expect dgs-dxmemo got "..dxGetType(memo))
	dgsElementData[memo].text = {""}
	dgsElementData[memo].textLength = {}
	emSetData(memo,"cursorposXY",{0,1})
	emSetData(memo,"selectfrom",{0,1})
	emSetData(memo,"rightLength",{0,1})
	configMemo(memo)
	return true
end

function checkMemoMousePosition(button,state,x,y)
	if dxGetType(source) == "dgs-dxmemo" then
		if state == "down" then
			local pos,line = searchMemoMousePosition(source,x,y)
			dxMemoSetCaretPosition(source,pos,line)
		end
	end
end
addEventHandler("onDgsMouseClick",root,checkMemoMousePosition)

function dxMemoGetPartOfText(memo,cindex,cline,tindex,tline,delete)
	assert(dxGetType(memo) == "dgs-dxmemo","Bad argument @dxMemoGetPartOfText at argument 1, expect dgs-dxmemo got "..dxGetType(memo))
	local outStr = ""
	local textTable = dgsElementData[memo].text
	local textLines = #textTable
	cindex,cline,tindex,tline = cindex or 0,cline or 1,tindex or utf8.len(textTable[textLines]),tline or textLines
	if cline < 1 then
		cline = 1
	elseif cline > textLines then
		cline = textLines
	end
	if tline < 1 then
		tline = 1
	elseif tline > textLines then
		tline = textLines
	end
	local lineTextFrom = textTable[cline]
	local lineTextTo = textTable[tline]
	local lineTextFromCnt = utf8.len(lineTextFrom)
	local lineTextToCnt = utf8.len(lineTextTo)
	if cindex < 0 then
		cindex = 0
	elseif cindex > lineTextFromCnt then
		tline = lineTextFromCnt
	end
	if tindex < 0 then
		tindex = 0
	elseif tindex > lineTextToCnt then
		tline = lineTextToCnt
	end
	if cline > tline then
		local temp = tline
		tline = cline
		cline = temp
		local temp = tindex
		tindex = cindex
		cindex = temp
	end
	if cline == tline then
		local _to = tindex < cindex  and cindex or tindex
		local _from = cindex > tindex and tindex or cindex
		outStr = utf8.sub(textTable[tline],_from,_to)
	else
		local txt1 = utf8.sub(textTable[cline],cindex+1) or ""
		local txt2 = utf8.sub(textTable[tline],0,tindex) or ""
		for i=cline+1,tline-1 do
			outStr = outStr..textTable[i]..splitChar2
		end
		outStr = txt1 ..splitChar2 ..outStr.. txt2
	end
	if delete then
		dxMemoDeleteText(memo,cindex,cline,tindex,tline)
	end
	return outStr
end

function seekMaxLengthLine(memo)
	local line,lineLen = -1,-1
	for k,v in ipairs(dgsElementData[memo].textLength) do
		if v > lineLen then
			lineLen = v
			line = k
		end
	end
	return line,lineLen
end

function configMemo(source)
	if dgsElementData[source].disableScrollBar then return end
	local mymemo = dgsElementData[source].memo
	local size = dgsElementData[source].absSize
	guiSetSize(mymemo,size[1],size[2],false)
	local text = dgsElementData[source].text
	local font = dgsElementData[source].font
	local textsize = dgsElementData[source].textsize
	local fontHeight = dxGetFontHeight(dgsElementData[source].textsize[2],font)
	local scbThick = dgsElementData[source].scrollBarThick
	local scrollbars = dgsElementData[source].scrollbars
	local visible1,visible2 = dgsElementData[scrollbars[1]].visible, dgsElementData[scrollbars[2]].visible
	dxSetVisible(scrollbars[1],false)
	dxSetVisible(scrollbars[2],false)
	
	dxSetVisible(scrollbars[2],dgsElementData[source].rightLength[1] > size[1])
	local scbTakes2 = dgsElementData[scrollbars[2]].visible and scbThick or 0
	local canHold = math.floor((size[2]-scbTakes2)/fontHeight)
	dxSetVisible(scrollbars[1], #text > canHold )
	local scbTakes1 = dgsElementData[scrollbars[1]].visible and scbThick+2 or 4
	dxSetVisible(scrollbars[2],dgsElementData[source].rightLength[1] > size[1]-scbTakes1)
	local scbTakes2 = dgsElementData[scrollbars[2]].visible and scbThick or 0
	local higLen = #text/(#text-canHold)/4
	higLen = higLen >= 0.95 and 0.95 or higLen
	emSetData(scrollbars[1],"length",{higLen,true})
	local widLen = dgsElementData[source].rightLength[1]/(dgsElementData[source].rightLength[1]-size[1]+scbTakes1)/4
	widLen = widLen >= 0.95 and 0.95 or widLen
	emSetData(scrollbars[2],"length",{widLen,true})
	if visible1 ~= dgsElementData[scrollbars[1]].visible or visible2 ~= dgsElementData[scrollbars[2]].visible then
		local px,py = math.floor(size[1]), math.floor(size[2])
		local rnd = dgsElementData[source].renderTarget
		if isElement(rnd) then
			destroyElement(rnd)
		end
		local renderTarget = dxCreateRenderTarget(px-scbTakes1,py-scbTakes2,true)
		emSetData(source,"renderTarget",renderTarget)
	end
end

addEventHandler("onDgsScrollBarScrollPositionChange",root,function(new,old)
	local parent = dxGetParent(source)
	if dxGetType(parent) == "dgs-dxmemo" then
		local scrollbars = dgsElementData[parent].scrollbars
		local size = dgsElementData[parent].absSize
		local scbThick = dgsElementData[parent].scrollBarThick
		local font = dgsElementData[parent].font
		local textsize = dgsElementData[parent].textsize
		local text = dgsElementData[parent].text
		local scbTakes1,scbTakes2 = dgsElementData[scrollbars[1]].visible and scbThick+2 or 4,dgsElementData[scrollbars[2]].visible and scbThick or 0
		if source == scrollbars[1] then
			local fontHeight = dxGetFontHeight(dgsElementData[parent].textsize[2],font)
			local canHold = math.floor((size[2]-scbTakes2)/fontHeight)
			local temp = math.floor((#text-canHold)*new/100)+1
			emSetData(parent,"showLine",temp)
		elseif source == scrollbars[2] then
			local len = dgsElementData[parent].rightLength[1]
			local canHold = math.floor(len-size[1]+scbTakes1+2)/100
			local temp = -new*canHold
			emSetData(parent,"showPos",temp)
		end
	end
end)

function syncScrollBars(memo,which)
	local scrollbars = dgsElementData[memo].scrollbars
	local size = dgsElementData[memo].absSize
	local scbThick = dgsElementData[memo].scrollBarThick
	local font = dgsElementData[memo].font
	local textsize = dgsElementData[memo].textsize
	local text = dgsElementData[memo].text
	local scbTakes1,scbTakes2 = dgsElementData[scrollbars[1]].visible and scbThick+2 or 4,dgsElementData[scrollbars[2]].visible and scbThick or 0
	if which == 1 or not which then
		local fontHeight = dxGetFontHeight(dgsElementData[memo].textsize[2],font)
		local canHold = math.floor((size[2]-scbTakes2)/fontHeight)
		local new = (#text-canHold) == 0 and 0 or (dgsElementData[memo].showLine-1)*100/(#text-canHold)
		dxScrollBarSetScrollBarPosition(scrollbars[1],new)
	end
	if which == 2 or not which then
		local len = dgsElementData[memo].rightLength[1]
		local canHold = math.floor(len-size[1]+scbTakes1+2)/100
		local new = -dgsElementData[memo].showPos/canHold
		dxScrollBarSetScrollBarPosition(scrollbars[2],new)
	end
end