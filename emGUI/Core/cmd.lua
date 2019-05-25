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

cmdBaseWhiteList = {}
eventHandlers = {}

function emDxCreateCmd(x, y, sx, sy, relative, parent, scalex, scaley, hangju, bgimg, bgcolor)
	assert(tonumber(x),"Bad argument @emDxCreateCmd at argument 1, expect number [got "..type(x).."]")
	assert(tonumber(y),"Bad argument @emDxCreateCmd at argument 2, expect number [got "..type(y).."]")
	assert(tonumber(sx),"Bad argument @emDxCreateCmd at argument 3, expect number [got "..type(sx).."]")
	assert(tonumber(sy),"Bad argument @emDxCreateCmd at argument 4, expect number [got "..type(sy).."]")
	if isElement(parent) then
		assert(emIsDxElement(parent),"Bad argument @emDxCreateCmd at argument 6, expect dgs-dxgui [got "..dxGetType(parent).."]")
	end
	local cmd = createElement("dgs-dxcmd")
	scalex,scaley = tonumber(scalex) or 1,tonumber(scaley) or 1
	dgsSetType(cmd,"dgs-dxcmd")
	emSetData(cmd,"textsize",{scalex,scaley})
	emSetData(cmd,"bgimg",bgimg)
	emSetData(cmd,"hangju",tonumber(hangju) or 20)
	emSetData(cmd,"bgcolor",bgcolor or schemeColor.cmd.bgcolor)
	emSetData(cmd,"texts",{})
	emSetData(cmd,"preName","")
	emSetData(cmd,"startRow",0)
	emSetData(cmd,"font", textFont)
	emSetData(cmd,"whitelist",cmdBaseWhiteList)
	emSetData(cmd,"cmdType","function")
	local tabl = {}
	tabl[0] = ""
	emSetData(cmd,"cmdHistory",tabl)
	emSetData(cmd,"cmdCurrentHistory",0)
	if isElement(parent) then
		dxSetParent(cmd,parent)
	else
		table.insert(MaxFatherTable,cmd)
	end
	insertResourceDxGUI(sourceResource,cmd)
	triggerEvent("onDgsPreCreate",cmd)
	calculateGuiPositionSize(cmd,x,y,relative or false,sx,sy,relative or false,true)
	triggerEvent("onDgsCreate",cmd)
	local sx,sy = dxGetSize(cmd,false)
	local edit = dxCreateEdit(0,sy-scaley*20,sx,scaley*20,"",false,cmd,tocolor(0,0,0,255),scalex,scaley)
	emSetData(cmd,"cmdEdit",edit)
	emSetData(edit,"cursorStyle",1)
	emSetData(edit,"cursorThick",1.2)
	emSetData(edit,"mycmd",cmd)
	return cmd
end

function emDxCmdSetMode(cmd, mode, output)
	assert(dxGetType(cmd) == "dgs-dxcmd","Bad argument @emDxCmdSetMode at argument 1, expect dgs-dxcmd [got "..dxGetType(cmd).."]")
	assert(type(mode) == "string","Bad argument @emDxCmdSetMode at argument 2, expect string [got "..type(mode).."]")
	if mode == "function" or mode == "event" then
		triggerEvent("onCMDModePreChange",cmd,mode)
		if not wasEventCancelled() then
			emSetData(cmd,"cmdType","event")
			if output then
				emOutputCmdMessage(cmd,"[Mode]Current Mode is ‘"..(mode == "function" and "Function" or "Event").." CMD’")
			end
			return true
		end
	end
	return false
end

function emDxCmdClearText(cmd)
	assert(dxGetType(cmd) == "dgs-dxcmd","Bad argument @emDxCmdSetMode at argument 1, expect dgs-dxcmd [got "..dxGetType(cmd).."]")
	emSetData(cmd,"texts",{})
end

function emDxCmdAddEventToWhiteList(cmd,rules)
	assert(dxGetType(cmd) == "dgs-dxcmd" or cmd == "all","Bad argument @emDxCmdAddEventToWhiteList at argument 1, expect dgs-dxcmd or string('all') [got "..dxGetType(cmd).."]")
	assert(type(rules) == "table","Bad argument @emDxCmdAddEventToWhiteList at argument 2, expect table [got "..type(rules).."]")
	if cmd == "all" then
		for k,v in pairs(getElementsByType("dgs-dxcmd")) do
			local oldrule = emGetData(v,"whitelist")
			local newrule = table.merger(oldrule,rules)
			if newrule then
				emSetData(v,"whitelist",newrule)
			end
		end
		cmdBaseWhiteList = table.merger(cmdBaseWhiteList,rules)
	else
		local oldrule = emGetData(cmd,"whitelist")
		local newrule = table.merger(oldrule,rules)
		if newrule then
			emSetData(cmd,"whitelist",newrule)
		end
	end
end

function emDxCmdRemoveEventFromWhiteList(cmd, rules)
	assert(dxGetType(cmd) == "dgs-dxcmd" or cmd == "all","Bad argument @emDxCmdRemoveEventFromWhiteList at argument 1, expect dgs-dxcmd or string('all') [got "..dxGetType(cmd).."]")
	assert(type(rules) == "table","Bad argument @emDxCmdAddEventToWhiteList at argument 2, expect table [got "..type(rules).."]")
	if cmd == "all" then
		for k,v in pairs(getElementsByType("dgs-dxcmd")) do
			local oldrule = emGetData(v,"whitelist")
			local newrule = table.complement(oldrule,rules)
			if newrule then
				emSetData(v,"whitelist",newrule)
			end
		end
		cmdBaseWhiteList = table.complement(cmdBaseWhiteList,rules)
	else
		local oldrule = emGetData(cmd,"whitelist")
		local newrule = table.complement(oldrule,rules)
		if newrule then
			emSetData(cmd,"whitelist",newrule)
		end
	end
end

function emDxCmdRemoveAllEvents(cmd)
	assert(dxGetType(cmd) == "dgs-dxcmd" or cmd == "all","Bad argument @emDxCmdRemoveAllEvents at argument 1, expect dgs-dxcmd or string('all') [got "..dxGetType(cmd).."]")
	if cmd == "all" then
		cmdBaseWhiteList = {}
		for k,v in pairs(getElementsByType("dgs-dxcmd")) do
			emSetData(v,"whitelist",{})
		end
	else
		emSetData(cmd,"whitelist",{})
	end
end

function emDxCmdIsInWhiteList(cmd, rule)
	assert(dxGetType(cmd) == "dgs-dxcmd" or cmd == "all","Bad argument @emDxCmdIsInWhiteList at argument 1, expect dgs-dxcmd or string('all') [got "..dxGetType(cmd).."]")
	assert(type(rule) == "string","Bad argument @emDxCmdIsInWhiteList at argument 2, expect string [got "..type(rule).."]")
	if table.find(preinstallWhiteList,rule) then
		return true
	else
		if cmd == "all" then
			if table.find(cmdBaseWhiteList,rule) then
				return true
			end
		else
			local wtlist = emGetData(cmd,"whitelist")
			if table.find(wtlist,rule) then
				return true
			end
		end
	end
	return false
end

function emOutputCmdMessage(cmd, str)
	assert(dxGetType(cmd) == "dgs-dxcmd","Bad argument @emOutputCmdMessage at argument 1, expect dgs-dxcmd [got "..dxGetType(cmd).."]")
	local texts = emGetData(cmd,"texts")
	table.insert(texts,1,emDxGetChars(str))
end

function receiveCmdEditInput(cmd, str)
	if dxGetType(cmd) == "dgs-dxcmd" then
		local history = emGetData(cmd,"cmdHistory")
		if history[1] ~= str then
			table.insert(history,1,str)
			emSetData(cmd,"cmdHistory",history)
		end
		executeCmdCommand(cmd,unpack(split(str," ")))
	end
end

function emDxGetChars(str, max)
	tabl = {}
	local strCode = utfCode(str)
	table.insert(tabl,utfChar(strCode))
	local number = 0
	max = max or 500
	while strCode ~= 0 and number <= max do
		str = utfSub(str,utfLen(utfChar(strCode))+1,utfLen(str))
		strCode = utfCode(str)
		if strCode == 0 then
			break
		end
		table.insert(tabl,utfChar(strCode))
		number = number+1
	end
	return tabl
end

function emDxCmdGetEdit(cmd)
	if dxGetType(cmd) == "dgs-dxcmd" then
		return emGetData(cmd,"cmdEdit")
	end
	return false
end

function configCMD(source)
	local dxedit = emGetData(source,"cmdEdit")
	local scalex,scaley = unpack(emGetData(source,"textsize"))
	local sx,sy = dxGetSize(source,false)
	dxSetPosition(dxedit,0,sy-scaley*20,false)
	dxSetSize(dxedit,sx,scaley*20,false)
end

function emDxCmdAddCommandHandler(str, func)
	eventHandlers[str] = eventHandlers[str] or {}
	assert(type(str) == "string","bad argument @addEventHandler at argument 1, expect string [got "..type(str).."]")
	assert(type(func) == "function","bad argument @addEventHandler at argument 2, expect function [got "..type(func).."]")
	return table.insert(eventHandlers[str],func)
end

function emDxCmdRemoveCommandHandler(str, func)
	eventHandlers[str] = eventHandlers[str] or {}
	assert(type(str) == "string","bad argument @addEventHandler at argument 1, expect string [got "..type(str).."]")
	assert(type(func) == "function","bad argument @addEventHandler at argument 2, expect function [got "..type(func).."]")
	local id = table.find(eventHandlers[str],func)
	if id then
		return table.remove(eventHandlers[str],id)
	end
	return true
end

function executeCmdCommand(cmd, str, ...)
	local arg = {...}
	local ifound = false
	local cmdType = emGetData(cmd,"cmdType")
	if cmdType == "function" then
		for k,v in pairs(eventHandlers[str] or {}) do
			if type(v) == "function" then
				ifound = true
				v(cmd,unpack(arg))
			end
		end
		if not ifound then
			emOutputCmdMessage(cmd,"ERROR: command '".. str .. "' does not exist.")
		end
	elseif cmdType == "event" then
		if emDxCmdIsInWhiteList(cmd,emGetData(cmd,"preName")..str) then
			ifound = true
			triggerEvent(emGetData(cmd,"preName") .. str, cmd, ...)
		end
		if not ifound then
			emOutputCmdMessage(cmd,"ERROR: Insufficient permission to call event: "..str)
		end
	end
end

function emDxEventCmdSetPreName(cmd, preName)
    assert(dxGetType(cmd) == "dgs-dxcmd","Bad argument @emDxEventCmdSetPreName at argument 1, expect dgs-dxcmd [got "..dxGetType(cmd).."]")
    assert(type(preName) == "string","Bad argument @emDxEventCmdSetPreName at argument 2, expect string [got "..type(preName).."]")
    return emSetData(cmd,"preName", preName)
end