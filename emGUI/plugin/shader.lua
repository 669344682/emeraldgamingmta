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

--this one allows you just create one shader to apply multi gui
function dgsDxGUIAddShader(dxgui,shader,tab)
	assert(emIsDxElement(dxgui),"@dgsDxGUIAddShader argument at 1,expect a dgs-dxgui element got "..(dxGetType(dxgui) or type(dxgui)))
	assert(isElement(shader) and getElementType(shader) == "shader","@dgsDxGUIAddShader argument at 2,expect a shader element got "..tostring(isElement(shader) and getElementType(shader) or shader))
	for k,v in pairs(tab) do
		emSetData(dxgui,"shader_"..v,{emGetData(dxgui,v),{}})
		emSetData(dxgui,v,shader)
	end
end

function dgsDxGUISetShaderValue(gdxguim,key,vkey,values)
	assert(isElement(shader) and getElementType(shader) == "shader","@dgsDxGUISetShaderValue argument at 1,expect a shader element got "..tostring(isElement(shader) and getElementType(shader) or shader))
	if type(vkey) == "table" and not values then
		for k,v in pairs(vkey) do
			local data = emGetData(dxgui,"shader_"..key) or {}
			data[2][k] = v
			emSetData(dxgui,"shader_"..key,data)
		end
	elseif type(vkey) == "string" and values then
		local data = emGetData(dxgui,"shader_"..key) or {}
		data[2][vkey] = values
		emSetData(dxgui,"shader_"..key,data)
	end
end

function dgsDxGUIRemoveShader(dxgui,tab)
	assert(emIsDxElement(dxgui),"@dgsDxGUIRemoveShader argument at 1,expect a dgs-dxgui element got "..(dxGetType(dxgui) or type(dxgui)))
	for k,v in pairs(tab) do
		local data = emGetData(dxgui,"shader_"..v)
		emSetData(dxgui,v,data[1])
		emSetData(dxgui,"shader_"..v,false)
	end
	return true
end

--[[addEventHandler("onDGSPreRender",root,function(x,y,w,h)
	for k,v in pairs(emGetData(source)) do
		if string.find(k,"shader_") then
			local options = emGetData(v,"k")[2]
			for a,b in pairs(options) do
				dxSetShaderValue(v,"a",b)
			end
		end
	end
end)]]