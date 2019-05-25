--[[
 _____                         _     _   _____                 _             
|  ___|                       | |   | | |  __ \               (_)            
| |__ _ __ ___   ___ _ __ __ _| | __| | | |  \/ __ _ _ __ ___  _ _ __   __ _ 
|  __| '_ ` _ \ / _ \ '__/ _` | |/ _` | | | __ / _` | '_ ` _ \| | '_ \ / _` |
| |__| | | | | |  __/ | | (_| | | (_| | | |_\ \ (_| | | | | | | | | | | (_| |
\____/_| |_| |_|\___|_|  \__,_|_|\__,_|  \____/\__,_|_| |_| |_|_|_| |_|\__, |
																		__/ |
																	   |___/ 
______ _____ _      ___________ _       _____   __                           
| ___ \  _  | |    |  ___| ___ \ |     / _ \ \ / /                           
| |_/ / | | | |    | |__ | |_/ / |    / /_\ \ V /                            
|    /| | | | |    |  __||  __/| |    |  _  |\ /          Created by                   
| |\ \\ \_/ / |____| |___| |   | |____| | | || |         	Skully          
\_| \_|\___/\_____/\____/\_|   \_____/\_| |_/\_/                             
																			 
Created for Emerald Gaming Roleplay, do not distribute - All rights reserved. ]]

addEvent("giveIPBack", true)
thePlayerIP = "Unknown"
triggerServerEvent("getMyIP", localPlayer)
addEventHandler("giveIPBack", root, function(ip)
	thePlayerIP = ip
end)

cmdSystem = {}
netSystem = {}
dxStatus = {}
addCommandHandler("emguicmd",function()
	if not exports.global:isPlayerLeadDeveloper(localPlayer, true) then return end
	guiSetInputMode("no_binds_when_editing")
	if not isElement(cmdSystem["window"]) then
		cmdSystem["window"] = dxCreateWindow(sW * 0.5 - 20, sH * 0.5, 40, 25, "Emerald GUI Command Menu", false)
		dxSetFont(cmdSystem["window"], textFont)
		dxMoveTo(cmdSystem["window"],sW*0.25,sH*0.5,false,false,"OutQuad",300)
		dxSizeTo(cmdSystem["window"],sW*0.5,25,false,false,"OutQuad",300)
		setTimer(function()
			dxMoveTo(cmdSystem["window"],sW*0.25,sH*0.25,false,false,"InQuad",300)
			dxSizeTo(cmdSystem["window"],sW*0.5,sH*0.6,false,false,"InQuad",300)
			setTimer(function()
				cmdSystem["cmd"] = emDxCreateCmd(0,0,1,1,true,cmdSystem["window"],1,1)
				dxSetFont(cmdSystem.cmd, textFont)
				dxSetFont(dgsElementData[cmdSystem.cmd].cmdEdit, textFont)
				emDxCmdAddEventToWhiteList(cmdSystem["cmd"],{"changeMode"})
				emOutputCmdMessage(cmdSystem["cmd"],"(Skully's emGUI Framework) Version: 2.0")
			end, 310, 1)
		end, 310, 1)
	else
		for k,v in pairs(cmdSystem) do
			if k ~= "window" then
				destroyElement(v)
			end
		end
		local x,y = unpack(emGetData(cmdSystem["window"],"absPos",false))
		local sx,sy = unpack(emGetData(cmdSystem["window"],"absSize",false))
		dxSetProperty(cmdSystem["window"],"title","")
		dxMoveTo(cmdSystem["window"],x,y+sy/2-20,false,false,"InQuad",450)
		dxSizeTo(cmdSystem["window"],sx,40,false,false,"InQuad",450)
		setTimer(function()
			destroyElement(cmdSystem["window"])
		end,500,1)
	end
end)

addEventHandler("onDgsWindowClose",root,function()
	if source == cmdSystem["window"] then
		cancelEvent()
		for k,v in pairs(cmdSystem) do
			if k ~= "window" then
				destroyElement(v)
			end
		end
		local x,y = unpack(emGetData(cmdSystem["window"],"absPos",false))
		local sx,sy = unpack(emGetData(cmdSystem["window"],"absSize",false))
		dxSetProperty(cmdSystem["window"],"title","")
		dxMoveTo(cmdSystem["window"],x,y+sy/2-20,false,false,"InQuad",450)
		dxSizeTo(cmdSystem["window"],sx,40,false,false,"InQuad",450)
		setTimer(function()
			destroyElement(cmdSystem["window"])
		end,500,1)
	elseif emGetData(source,"animated") == 1 then
		if isElement(cmdSystem["cmd"]) then
			if source == netSystem["window"] then
				emOutputCmdMessage(cmdSystem["cmd"],"[Network Monitor]: Closed monitor window.")
			elseif source == dxStatus["window"] then
				emOutputCmdMessage(cmdSystem["cmd"],"[DxStatus Monitor]: Closed dxStatus window.")
			end
		end
		cancelEvent()
		local children = dxGetChildren(source)
		for i=1,#children do
			destroyElement(children[1])
		end
		local x,y = unpack(emGetData(source,"absPos",false))
		local sx,sy = unpack(emGetData(source,"absSize",false))
		emSetData(source,"title","")
		dxMoveTo(source,x,y+sy/2-20,false,false,"InQuad",350)
		dxSizeTo(source,sx,40,false,false,"InQuad",350)
		setTimer(function(source)
			destroyElement(source)
		end,380,1,source)
	end
end)

----------------------------------------Insides
emDxCmdAddCommandHandler("version",function(cmd)
	emOutputCmdMessage(cmd, "Emerald GUI Framework by Skully.")
	emOutputCmdMessage(cmd, "Currently running version 2.0.")
	emOutputCmdMessage(cmd, " ")
end)

emDxCmdAddCommandHandler("mode",function(cmd,cmdtype)
	triggerEvent("onCmdModePreChange",cmd,cmdtype)
	if not wasEventCancelled() then
		if cmdtype == "function" then
			emSetData(cmd,"cmdType","function")
			emOutputCmdMessage(cmd,"[Mode Switch] Switched to functions.")
			return
		elseif cmdtype == "event" then
			emSetData(cmd,"cmdType","event")
			emOutputCmdMessage(cmd,"[Mode Switch] Switched to events.")
			return
		end
		triggerEvent("onCmdModeChange",cmd,cmdtype)
		emOutputCmdMessage(cmd,"[Mode Switch] Usage: mode <argument>")
		emOutputCmdMessage(cmd,"   Function --> Function: Only run the command added by 'emDxCmdAddCommandHandler'")
		emOutputCmdMessage(cmd,"   Event      --> Event: Only run the command added by 'addEvent', such as 'triggerEvent'")
	end
end)

emDxCmdAddCommandHandler("serial",function(cmd)
	emOutputCmdMessage(cmd,"Your serial: "..getPlayerSerial())
end)

emDxCmdAddCommandHandler("cls",function(cmd)
	local winSize = 31
	while winSize > 1 do
		emOutputCmdMessage(cmd," ")
		winSize = winSize - 1
	end
end)

emDxCmdAddCommandHandler("mtaversion",function(cmd)
	emOutputCmdMessage(cmd,"MTA Client Version:")
	for k,v in pairs(getVersion()) do
		emOutputCmdMessage(cmd, k..":  "..tostring(v))
	end
end)

emDxCmdAddCommandHandler("dxstatus",function(cmd)
	if not isElement(dxStatus["window"]) then
		dxStatus["window"] = dxCreateAnimationWindow(sW/2 - 250, sH/2 - 150, 500, 300, "DxStatus", false)
		dxWindowSetSizable(dxStatus["window"],false)
		dxBringToFront(dxStatus["window"])
		emOutputCmdMessage(cmd,"[DxStatus Monitor] Opened monitor window.")
	else
		triggerEvent("onDgsWindowClose",dxStatus["window"])
	end
end)

function netstatus(cmd)
	if not isElement(netSystem["window"]) then
		netSystem["window"] = dxCreateAnimationWindow(sW - 610, sH - 410, 600, 400, "Network Status", false, _, true)
		dxWindowSetSizable(netSystem["window"], false)
		dxBringToFront(netSystem["window"])
		emOutputCmdMessage(cmd,"[Network Monitor]: Opened monitor window.")
		dgsShowCursor(true, "net")
	else
		triggerEvent("onDgsWindowClose",netSystem["window"])
	end
end
emDxCmdAddCommandHandler("netstatus",netstatus)

emDxCmdAddCommandHandler("help",function(cmd)
	emOutputCmdMessage(cmd,"Commands:")
	emOutputCmdMessage(cmd,"  netstatus - Toggles the Network Monitor display.")
	emOutputCmdMessage(cmd,"  dxstatus - Toggles the DirectX information display.")
	emOutputCmdMessage(cmd,"  ping - Gets your current ping to the emGUI resource.")
	emOutputCmdMessage(cmd,"  cls - Clears this console display.")
	emOutputCmdMessage(cmd,"  exit - Exits out of the console.")
end)


emDxCmdAddCommandHandler("ping",function(cmd,times,time)
	times = times or 1
	time = time or 500
	setTimer(function(cmd)
		if not isElement(cmd) then killTimer(selfTimer) end
		emOutputCmdMessage(cmd,"Ping: "..getPlayerPing(localPlayer).."ms")
	end,time,times,cmd)
end)

emDxCmdAddCommandHandler("exit",function(cmd)
    if isElement(cmdSystem["window"]) then
        dxCloseWindow(cmdSystem["window"])
    end
end)

addEvent("onDGSCmdOutput",true)
addEventHandler("onDGSCmdOutput",root,function(message)
    if isElement(cmdSystem["cmd"]) then
        emOutputCmdMessage(cmdSystem["cmd"],message)
    end
end)

-- Inside CMD_Event.
preinstallWhiteList = {}

function emAddEventCommand(str)
	addEvent(str,true)
	table.insert(preinstallWhiteList,str)
end

emAddEventCommand("mode")
addEventHandler("mode",resourceRoot,function(cmdtype)
	triggerEvent("onCmdModePreChange",source,cmdtype)
	if not wasEventCancelled() then
		if cmdtype == "function" then
			emSetData(source,"cmdType","function")
			emOutputCmdMessage(source,"[Mode Switch] Switched to functions.")
			return
		elseif cmdtype == "event" then
			emSetData(source,"cmdType","event")
			emOutputCmdMessage(source,"[Mode Switch] Switched to events.")
			return	
		end
		triggerEvent("onCmdModeChange",source,cmdtype)
		emOutputCmdMessage(source,"[Mode Switch] Usage: mode <argument>")
		emOutputCmdMessage(source,"   Function --> Function: Only run the commands added by 'dxAddCommandHandler'")
		emOutputCmdMessage(source,"   Event      --> Event: Only run the commands added by 'addEvent', such as 'triggerEvent'")
	end
end)

--------------------------------------------------
local byteSent = false
local byteRecevied = false
local tick = getTickCount()
local speedSend = {}
local speedRecv = {}
local percentLoss = {}
function netUpdate()
	if isElement(netSystem["Sent"]) then
		local network = getNetworkStats()
		if getTickCount()-tick >= 1000 then
			if not byteSent then
				byteSent = network.bytesSent
			end
			if not byteRecevied then
				byteRecevied = network.bytesReceived
			end
			local _sent,_received = network.bytesSent-byteSent,network.bytesReceived-byteRecevied
			local sent,received = string.format("%.2f",_sent/1024),string.format("%.2f",_received/1024)
			dxSetText(netSystem["Sent"],"Sent "..sent.." kb/s")
			dxSetText(netSystem["Received"],"Received "..received.." kb/s")
			byteSent = network.bytesSent
			byteRecevied = network.bytesReceived
			speedSend[0] = speedSend[0] or 100
			speedRecv[0] = speedRecv[0] or 100
			percentLoss[0] = 100
			if speedSend[0] < _sent then
				speedSend[0] = _sent
			end
			if speedRecv[0] < _received then
				speedRecv[0] = _received
			end
			table.insert(speedSend,1,_sent)
			table.insert(speedRecv,1,_received)
			table.insert(percentLoss,1,network.packetlossLastSecond)
			if #speedSend > 21 then
				if speedSend[22] == speedSend[0] then
					speedSend[0] = speedSend[1]
					for i=2,21 do
						speedSend[0] = speedSend[0] <= speedSend[i] and speedSend[i] or speedSend[0]
					end
				end
				speedSend[22] = nil
			end
			if #speedRecv > 21 then
				if speedRecv[22] == speedRecv[0] then
					speedRecv[0] = speedRecv[1]
					for i=2,21 do
						speedRecv[0] = speedRecv[0] <= speedRecv[i] and speedRecv[i] or speedRecv[0]
					end
				end
				speedRecv[22] = nil
			end
			if #percentLoss > 21 then
				percentLoss[22] = nil
			end
			tick = getTickCount()
		end
		dxSetText(netSystem["BytesReceived"],"Bytes: "..(network.bytesReceived))
		dxSetText(netSystem["PacketsReceived"],"Packets: "..(network.packetsReceived))
		dxSetText(netSystem["ByteSent"],"Bytes: "..(network.bytesSent))
		dxSetText(netSystem["PacketsSent"],"Packets: "..(network.packetsSent))
		dxSetText(netSystem["packetlossLastSecond"],"Packet Loss: "..string.format("%.2f",network.packetlossLastSecond).."%")
		dxSetText(netSystem["PacketLossTotal"],"Average Loss: "..string.format("%.2f",network.packetlossTotal).."%")
		dxSetText(netSystem["IP"],"Your IP: "..thePlayerIP)
	else
		byteSent = false
		byteRecevied = false
		speedSend = {}
		speedRecv = {}
		percentLoss = {}
		removeEventHandler("onClientPreRender", root, netUpdate)
	end
end

addEventHandler("onDgsDestroy",root,function()
	if source == cmdSystem["window"] then
		dgsShowCursor(false,"cmd")
		dgsShowCursor(false,"net")
	elseif source == netSystem["window"] then
		dgsShowCursor(false,"net")
	elseif source == dxStatus["window"] then
		dgsShowCursor(false,"dx")
	end
end)

cursorManager = {}
function dgsShowCursor(bool,code)
	assert(type(code) == "string","Bad argument @dgsShowCursor at argument 1, expect a string got "..dxGetType(code))
	bool = bool and true or false
	cursorManager[code] = bool
	if bool then
		showCursor(true)
	else
		local noPass
		for k,v in pairs(cursorManager) do
			if v then
				noPass = true
				break
			end
		end
		if not noPass then
			showCursor(false)
		end
	end
end

function dxCreateAnimationWindow(...)
	local tabl = {...}
	local x,y = tabl[6] and tabl[1]*sW or tabl[1],tabl[6] and tabl[2]*sH or tabl[2]
	local sx,sy = tabl[6] and tabl[3]*sW or tabl[3],tabl[6] and tabl[4]*sH or tabl[4]
	tabl[6] = false
	tabl[1] = x+sx/2-30
	tabl[2] = y+sy/2-12.5
	tabl[3] = 60
	tabl[4] = 25
	local window = dxCreateWindow(unpack(tabl))
	emSetData(window,"animated",1)
	dxMoveTo(window,x,y+sy/2-12.5,false,false,"OutQuad",200)
	dxSizeTo(window,sx,25,false,false,"OutQuad",200)
	setTimer(function(window)
		dxMoveTo(window,x,y,false,false,"InQuad",200)
		dxSizeTo(window,sx,sy,false,false,"InQuad",200)
		setTimer(function(window)
			triggerEvent("onAnimationWindowCreate",window)
		end,202,1,window)
	end,210,1,window)
	return window
end

function dxStatusUpdate()
	if not isElement(dxStatus["dxList"]) then return removeEventHandler("onClientRender",root,dxStatusUpdate) end
	local rowData = dxGetProperty(dxStatus["dxList"],"rowData")
	local count = 0
	for k,v in pairs(dxGetStatus()) do
		count = count+1
		if not rowData[count] then
			dxGridListAddRow(dxStatus["dxList"])
		end
		rowData[count][1] = {k,white}
		rowData[count][2] = {tostring(v),white}
	end
	dxSetProperty(dxStatus["dxList"],"rowData",rowData)
end
addEvent("onDGSObjectRender",true)
addEvent("onAnimationWindowCreate",true)
addEventHandler("onAnimationWindowCreate",root,function()
	if source == netSystem["window"] then
		netSystem["Sent"] = dxCreateLabel(10,25,100,30,"Sent",false,netSystem["window"],_,1.1,1.1)
		netSystem["ByteSent"] = dxCreateLabel(10,50,200,20,"Bytes: ",false,netSystem["window"],_,1,1)
		netSystem["PacketsSent"] = dxCreateLabel(10,70,200,20,"Packets: ",false,netSystem["window"],_,1, 1)
		netSystem["Received"] = dxCreateLabel(10,135,100,30,"Received",false,netSystem["window"],_,1.1,1.1)
		netSystem["BytesReceived"] = dxCreateLabel(10,160,200,20,"Bytes: ",false,netSystem["window"],_,1,1)
		netSystem["PacketsReceived"] = dxCreateLabel(10,180,200,20,"Packets: ",false,netSystem["window"],_,1, 1)
		netSystem["PacketLoss"] = dxCreateLabel(10,245,200,30,"Packet Loss",false,netSystem["window"],_,1.1,1.1)
		netSystem["packetlossLastSecond"] = dxCreateLabel(10,270,200,20,"Packet Loss: ",false,netSystem["window"],_,1,1)
		netSystem["PacketLossTotal"] = dxCreateLabel(10,290,200,20,"Average Loss: ",false,netSystem["window"],_,1,1)
		netSystem["IP"] = dxCreateLabel(10,340,200,20,"Your IP:"..thePlayerIP,false,netSystem["window"],_,1.1,1.1)
		
		netSystem["picture_sen"] = dxCreateImage(290,10,300,90,_,false,netSystem["window"],tocolor(255,255,255,50))
		dxSetProperty(netSystem.picture_sen,"functionRunBefore",false)
		dxSetProperty(netSystem.picture_sen,"functions","triggerEvent('onDGSObjectRender',self)")
		netSystem["picture_sen_max"] = dxCreateLabel(240,15,40,0,"N/A",false,netSystem["window"],_,1.2,1.2,_,_,_,"right","center")
		netSystem["picture_sen_min"] = dxCreateLabel(240,95,40,0,"0 Byte/s",false,netSystem["window"],_,1.2,1.2,_,_,_,"right","center")
		dxSetProperty(netSystem["picture_sen"],"sideSize",1)
		dxSetProperty(netSystem["picture_sen"],"sideState","out")
		dxSetProperty(netSystem["picture_sen"],"sideColor",tocolor(255,255,255,255))
		
		netSystem["picture_rec"] = dxCreateImage(290,120,300,90,_,false,netSystem["window"],tocolor(255,255,255,50))
		dxSetProperty(netSystem.picture_rec,"functionRunBefore",false)
		dxSetProperty(netSystem.picture_rec,"functions","triggerEvent('onDGSObjectRender',self)")
		netSystem["picture_rec_max"] = dxCreateLabel(240,125,40,0,"N/A",false,netSystem["window"],_,1.2,1.2,_,_,_,"right","center")
		netSystem["picture_rec_min"] = dxCreateLabel(240,205,40,0,"0 Byte/s",false,netSystem["window"],_,1.2,1.2,_,_,_,"right","center")
		dxSetProperty(netSystem["picture_rec"],"sideSize",1)
		dxSetProperty(netSystem["picture_rec"],"sideState","out")
		dxSetProperty(netSystem["picture_rec"],"sideColor",tocolor(255,255,255,255))
		
		netSystem["picture_pkl"] = dxCreateImage(290,230,300,90,_,false,netSystem["window"],tocolor(255,255,255,50))
		dxSetProperty(netSystem.picture_pkl,"functionRunBefore",false)
		dxSetProperty(netSystem.picture_pkl,"functions","triggerEvent('onDGSObjectRender',self)")
		netSystem["picture_pkl_max"] = dxCreateLabel(240,235,40,0,"100%",false,netSystem["window"],_,1.2,1.2,_,_,_,"right","center")
		netSystem["picture_pkl_min"] = dxCreateLabel(240,315,40,0,"0%",false,netSystem["window"],_,1.2,1.2,_,_,_,"right","center")
		dxSetProperty(netSystem["picture_pkl"],"sideSize",1)
		dxSetProperty(netSystem["picture_pkl"],"sideState","out")
		dxSetProperty(netSystem["picture_pkl"],"sideColor",tocolor(255,255,255,255))
		
		addEventHandler("onClientPreRender",root,netUpdate)
		addEventHandler("onDGSObjectRender",netSystem["picture_sen"],function()
			local x,y = dxGetPosition(source,false,true)
			local sx,sy = dxGetSize(source,false)
			local maxPos = math.floor((speedSend[0] or 0)*1.2)
			for i=1,#speedSend-1 do
				local nextone = speedSend[i+1] or 0 
				dxDrawLine(x+sx-sx*i/20,y+sy-sy*(nextone/maxPos),x+sx-sx*(i-1)/20,y+sy-sy*(speedSend[i]/maxPos),tocolor(80,180,255,255),1,not DEBUG_MODE)
			end
			dxSetText(netSystem["picture_sen_max"],maxPos.." Byte/s")
		end)
		
		addEventHandler("onDGSObjectRender",netSystem["picture_rec"],function()
			local x,y = dxGetPosition(source,false,true)
			local sx,sy = dxGetSize(source,false)
			local maxPos = math.floor((speedRecv[0] or 0)*1.2)
			for i=1,#speedRecv-1 do
				local nextone = speedRecv[i+1] or 0 
				dxDrawLine(x+sx-sx*i/20,y+sy-sy*(nextone/maxPos),x+sx-sx*(i-1)/20,y+sy-sy*(speedRecv[i]/maxPos),tocolor(80,180,255,255),1,not DEBUG_MODE)
			end
			dxSetText(netSystem["picture_rec_max"],maxPos.." Byte/s")
		end)
		
		addEventHandler("onDGSObjectRender",netSystem["picture_pkl"],function()
			local x,y = dxGetPosition(source,false,true)
			local sx,sy = dxGetSize(source,false)
			for i=1,#percentLoss-1 do
				local nextone = percentLoss[i+1] or 0 
				dxDrawLine(x+sx-sx*i/20,y+sy-sy*(nextone/100),x+sx-sx*(i-1)/20,y+sy-sy*(percentLoss[i]/100),tocolor(80,180,255,255),1,not DEBUG_MODE)
			end
		end)
		
	elseif source == dxStatus["window"] then
		dxStatus["dxList"] = dxCreateGridList(10,10,480,255,false,dxStatus["window"],_,tocolor(0,0,0,100),white,tocolor(0,0,0,100),tocolor(0,0,0,0),tocolor(100,100,100,100),tocolor(200,200,200,150))
		dxGridListAddColumn(dxStatus["dxList"],"Name",0.55)
		dxGridListAddColumn(dxStatus["dxList"],"Value",0.35)
		local scrollBars = dxGridListGetScrollBar(dxStatus["dxList"])
		dxSetProperty(scrollBars[1],"scrollArrow",false)
		dxSetProperty(scrollBars[2],"scrollArrow",false)
		dxSetProperty(dxStatus["dxList"],"mode",true)
		addEventHandler("onClientRender",root,dxStatusUpdate)
	end
end)