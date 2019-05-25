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

local javaScript = {}
javaScript.clearelement = "clearMedia()"
javaScript.playelement = "playMedia()"
javaScript.pauseelement = "pauseMedia()"
javaScript.stopelement = "stopMedia()"
javaScript.fullscreen = "mediaFullScreen(REP1)"
javaScript.setFill = "mediaFill(REP1)"
javaScript.setSize = "resizeMedia(REP1,REP2)"
javaScript.setLoop = "mediaLoop(REP1)"
javaScript.setTime = "mediaSetCurrentTime(REP1)"
addEvent("ondxMediaPlay",true)
addEvent("ondxMediaPause",true)
addEvent("ondxMediaStop",true)
addEvent("onDgsMediaDurationGet",true)
addEvent("onDgsMediaTimeUpdate",true)

addEvent("onDgsMediaBrowserReturn",true)

-- 1: failed to create listner


--Media Element won't be rendered by DGS render, so it should be set into other dgs element(Such as dgs-dximage).
--Media Element is "cef"(browser element), but if you want to manage it well, please use the functions dgs offered.
function dxCreateMediaBrowser(w,h)
	assert(type(w) == "number","Bad argument @dxCreateMediaBrowser at argument 1, expect number got "..type(w))
	assert(type(h) == "number","Bad argument @dxCreateMediaBrowser at argument 2, expect number got "..type(h))
	local media = createBrowser(w,h,true,true)
	dgsSetType(media,"dgs-dxmedia")
	emSetData(media,"size",{w,h})
	emSetData(media,"sourcePath",false)
	emSetData(media,"fullscreen",false)
	emSetData(media,"filled",true)
	emSetData(media,"looped",false)
	emSetData(media,"functionBuffer",{})
	dgsElementData[media].duration = false
	dgsElementData[media].current = false
	insertResourceDxGUI(sourceResource,media)
	triggerEvent("onDgsPreCreate",media)
	triggerEvent("onDgsCreate",media)
	return media
end

addEventHandler("onClientBrowserCreated",resourceRoot,function()
	if dxGetType(source) == "dgs-dxmedia" then
		loadBrowserURL(source,"http://mta/"..getResourceName(getThisResource()).."/media.html")
		--toggleBrowserDevTools(source, true) < Debugging.
	end
end)

addEventHandler("onClientBrowserDocumentReady",resourceRoot,function()
	if dxGetType(source) == "dgs-dxmedia" then
		emSetData(source,"started",true)
		for k,v in ipairs(dgsElementData[source].functionBuffer) do
			v[0](unpack(v))
		end
	end
end)

function dxMediaLoadMedia(media,path,theType,sourceRes)
	assert(dxGetType(media) == "dgs-dxmedia","Bad argument @dxMediaLoadMedia at argument 1, expect dgs-dxmedia got "..dxGetType(media))
	assert(type(path) == "string","Bad argument @dxMediaLoadMedia at argument 2, expect string got "..type(path))
	local sR = sourceResource or sourceRes or getThisResource()
	local name = getResourceName(sR)
	if not path:find(":") then
		local firstOne = path:sub(1,1)
		if firstOne == "/" then
			path = path:sub(2)
		end
		path = ":"..name.."/"..path
	end
	assert(fileExists(path),"Bad argument @dxMediaLoadMedia at argument 2, file doesn't exist("..path..")")
	assert(theType == "VIDEO" or theType == "AUDIO","Bad argument @dxMediaLoadMedia at argument 3, expect string('VIDEO' or 'AUDIO') got "..tostring(theType))
	if not dgsElementData[media].started then
		local buffer = dgsElementData[media].functionBuffer
		table.insert(buffer,{[0]=dxMediaLoadMedia,media,path,theType,sR})
	else
		dxMediaClearMedia(media)
		emSetData(media,"sourcePath",path)
		local size = dgsElementData[media].size
		local filled = dgsElementData[media].filled
		local str = [[
			var element = document.createElement("]]..theType..[[");
			element.id = "element";
			element.width = ]]..size[1]..[[;
			element.height = ]]..size[2]..[[;
			createListener(element);
			document.body.appendChild(element);
			var source = document.createElement("source");
			source.src = "http://mta/]] ..path:sub(2).. [[";
			element.appendChild(source);
			mta.triggerEvent("onDgsMediaDurationGet",element.duration)
		]]
		local executed = executeBrowserJavascript(media,str)
		dxMediaSetFullScreen(media,dgsElementData[media].fullscreen)
		dgsMediaSetFilled(media,dgsElementData[media].filled)
		dxMediaSetLooped(media,dgsElementData[media].looped)
		return executed
	end
end

addEventHandler("onDgsMediaDurationGet",resourceRoot,function(duration)
	if dgsElementType[source] == "dgs-dxmedia" and duration then
		dgsElementData[source].duration = duration
	end
end)

addEventHandler("onDgsMediaTimeUpdate",resourceRoot,function(current)
	if dgsElementType[source] == "dgs-dxmedia" and current then
		dgsElementData[source].current = current
	end
end)

function dxMediaGetMediaPath(media)
	return emSetData(media,"sourcePath",path)
end

function dxMediaClearMedia(media)
	assert(dxGetType(media) == "dgs-dxmedia","Bad argument @dxMediaClearMedia at argument 1, expect dgs-dxmedia got "..dxGetType(media))
	if not dgsElementData[media].started then
		local buffer = dgsElementData[media].functionBuffer
		table.insert(buffer,{[0]=dxMediaClearMedia,media})
	else
		emSetData(media,"sourcePath",false)
		dgsElementData[media].duration = false
		return executeBrowserJavascript(media,javaScript.clearelement)
	end
end

function dxMediaPlay(media)
	assert(dxGetType(media) == "dgs-dxmedia","Bad argument @dxMediaPlay at argument 1, expect dgs-dxmedia got "..dxGetType(media))
	if not dgsElementData[media].started then
		local buffer = dgsElementData[media].functionBuffer
		table.insert(buffer,{[0]=dxMediaPlay,media})
	else
		assert(dgsElementData[media].sourcePath,"Bad argument @dxMediaPlay, no media source loaded in dgs-dxmedia")
		return executeBrowserJavascript(media,javaScript.playelement)
	end
end

function dxMediaPause(media)
	assert(dxGetType(media) == "dgs-dxmedia","Bad argument @dxMediaPause at argument 1, expect dgs-dxmedia got "..dxGetType(media))
	if not dgsElementData[media].started then
		local buffer = dgsElementData[media].functionBuffer
		table.insert(buffer,{[0]=dxMediaPause,media})
	else
		assert(dgsElementData[media].sourcePath,"Bad argument @dxMediaPause, no media source loaded in dgs-dxmedia")
		return executeBrowserJavascript(media,javaScript.pauseelement)
	end
end

function dxMediaStop(media)
	assert(dxGetType(media) == "dgs-dxmedia","Bad argument @dxMediaStop at argument 1, expect dgs-dxmedia got "..dxGetType(media))
	if not dgsElementData[media].started then
		local buffer = dgsElementData[media].functionBuffer
		table.insert(buffer,{[0]=dxMediaStop,media})
	else
		assert(dgsElementData[media].sourcePath,"Bad argument @dxMediaStop, no media source loaded in dgs-dxmedia")
		return executeBrowserJavascript(media,javaScript.stopelement)
	end
end

function dxMediaSetFullScreen(media,state)
	assert(dxGetType(media) == "dgs-dxmedia","Bad argument @dxMediaSetFullScreen at argument 1, expect dgs-dxmedia got "..dxGetType(media))
	if not dgsElementData[media].started then
		local buffer = dgsElementData[media].functionBuffer
		table.insert(buffer,{[0]=dxMediaSetFullScreen,media,state})
	else
		assert(dgsElementData[media].sourcePath,"Bad argument @dxMediaSetFullScreen, no media source loaded in dgs-dxmedia")
		local str = string.gsub(javaScript.fullscreen,"REP1",tostring(state))
		emSetData(media,"fullscreen",state)
		return executeBrowserJavascript(media,str)
	end
end

function dxMediaGetFullScreen(media)
	assert(dxGetType(media) == "dgs-dxmedia","Bad argument @dxMediaGetFullScreen at argument 1, expect dgs-dxmedia got "..dxGetType(media))
	return dgsElementData[media].fullscreen
end

function dgsMediaSetFilled(media,state)
	assert(dxGetType(media) == "dgs-dxmedia","Bad argument @dgsMediaSetFilled at argument 1, expect dgs-dxmedia got "..dxGetType(media))
	if not dgsElementData[media].started then
		local buffer = dgsElementData[media].functionBuffer
		table.insert(buffer,{[0]=dgsMediaSetFilled,media,state})
	else
		assert(dgsElementData[media].sourcePath,"Bad argument @dgsMediaSetFilled, no media source loaded in dgs-dxmedia")
		local str = string.gsub(javaScript.setFill,"REP1",tostring(state))
		emSetData(media,"filled",state)
		return executeBrowserJavascript(media,str)
	end
end

function dxMediaGetFilled(media)
	assert(dxGetType(media) == "dgs-dxmedia","Bad argument @dxMediaGetFilled at argument 1, expect dgs-dxmedia got "..dxGetType(media))
	return dgsElementData[media].filled
end

function dxMediaGetLooped(media)
	assert(dxGetType(media) == "dgs-dxmedia","Bad argument @dxMediaGetLooped at argument 1, expect dgs-dxmedia got "..dxGetType(media))
	return dgsElementData[media].loop
end

function dxMediaSetLooped(media,state)
	assert(dxGetType(media) == "dgs-dxmedia","Bad argument @dxMediaSetLooped at argument 1, expect dgs-dxmedia got "..dxGetType(media))
	if not dgsElementData[media].started then
		local buffer = dgsElementData[media].functionBuffer
		table.insert(buffer,{[0]=dxMediaSetLooped,media,state})
	else
		assert(dgsElementData[media].sourcePath,"Bad argument @dxMediaSetLooped, no media source loaded in dgs-dxmedia")
		local str = string.gsub(javaScript.setLoop,"REP1",tostring(state))
		emSetData(media,"looped",state)
		return executeBrowserJavascript(media,str)
	end
end

function dxMediaSetSize(media,w,h)
	assert(dxGetType(media) == "dgs-dxmedia","Bad argument @dxMediaSetSize at argument 1, expect dgs-dxmedia got "..dxGetType(media))
	assert(type(w) == "number" and w > 0,"Bad argument @dxMediaSetSize at argument 2, expect number ( > 0 ) got "..type(w).."("..tostring(w)..")")
	assert(type(h) == "number" and h > 0,"Bad argument @dxMediaSetSize at argument 3, expect number ( > 0 ) got "..type(h).."("..tostring(h)..")")
	if not dgsElementData[media].started then
		local buffer = dgsElementData[media].functionBuffer
		table.insert(buffer,{[0]=dxMediaSetSize,media,w,h})
	else
		resizeBrowser(media,w,h)
		local str = javaScript.setSize
		local str = str:gsub("REP1",w)
		local str = str:gsub("REP2",h)
		emSetData(media,"size",{w,h})
		return executeBrowserJavascript(media,str)
	end
end

function dxMediaGetDuration(media)
	assert(dxGetType(media) == "dgs-dxmedia","Bad argument @dxMediaGetDuration at argument 1, expect dgs-dxmedia got "..dxGetType(media))
	return dgsElementData[media].duration
end

function dxMediaGetCurrentPosition(media)
	assert(dxGetType(media) == "dgs-dxmedia","Bad argument @dxMediaGetCurrentPosition at argument 1, expect dgs-dxmedia got "..dxGetType(media))
	return dgsElementData[media].current
end

function dxMediaSetCurrentPosition(media,position) --Failed to Set current position ( IDK Why it will go back to 0 !)
	assert(dxGetType(media) == "dgs-dxmedia","Bad argument @dxMediaSetCurrentPosition at argument 1, expect dgs-dxmedia got "..dxGetType(media))
	assert(type(position) == "number" and position >= 0,"Bad argument @dxMediaSetCurrentPosition at argument 2, expect number ( >= 0 ) got "..type(position).."("..tostring(position)..")")
	if not dgsElementData[media].started then
		local buffer = dgsElementData[media].functionBuffer
		table.insert(buffer,{[0]=dxMediaSetCurrentPosition,media,position})
	else
		assert(dgsElementData[media].sourcePath,"Bad argument @dxMediaSetCurrentPosition, no media source loaded in dgs-dxmedia")
		local str = javaScript.setTime
		local str = str:gsub("REP1",position)
		return executeBrowserJavascript(media,str)
	end
end