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

function dxCreateEDA(x, y, sx, sy, relative, parent)
	assert(type(x) == "number","Bad argument @dxCreateEDA at argument 1, expect number got "..type(x))
	assert(type(y) == "number","Bad argument @dxCreateEDA at argument 2, expect number got "..type(y))
	assert(type(sx) == "number","Bad argument @dxCreateEDA at argument 3, expect number got "..type(sx))
	assert(type(sy) == "number","Bad argument @dxCreateEDA at argument 4, expect number got "..type(sy))
	if isElement(parent) then
		assert(emIsDxElement(parent),"@dxCreateEDA argument 5,expect dgs-dxgui got "..dxGetType(parent))
	end
	local eda = createElement("dgs-dxeda")
	dgsSetType(eda,"dgs-dxeda")
	if isElement(parent) then
		dxSetParent(eda,parent)
	else
		table.insert(MaxFatherTable,eda)
	end
	insertResourceDxGUI(sourceResource,eda)
	triggerEvent("onDgsPreCreate",eda)
	calculateGuiPositionSize(eda,x,y,relative or false,sx,sy,relative or false,true)
	triggerEvent("onDgsCreate",eda)
	return eda
end

function dxEDASetDebugModeEnabled(eda, debug)
	assert(dxGetType(eda) == "dgs-dxeda","Bad argument @dxEDASetDebugModeEnabled at argument 1, expect dgs-dxeda got "..dxGetType(eda))
	if not debug then
		if isElement(dgsElementData[v].debugShader) then
			destroyElement(dgsElementData[v].debugShader)
			dgsElementData[v].debugShader = nil
		end
	end
	emSetData(eda,"debug",debug and debug or false)
	return true
end

function dxEDAGetDebugModeEnabled(eda)
	assert(dxGetType(eda) == "dgs-dxeda","Bad argument @dxEDAGetDebugModeEnabled at argument 1, expect dgs-dxeda got "..dxGetType(eda))
	return dgsElementData[eda].debug
end

function dgsCheckRadius(eda, mx, my)
	if mx and my then
		local x,y = dxGetPosition(eda,false,true)
		local size = dgsElementData[eda].absSize
		if ((mx-x-size[1]/2)/size[1]*2)^2+((my-y-size[2]/2)/size[2]*2)^2 <= 1 then
			return true
		end
	end
	return false
end
