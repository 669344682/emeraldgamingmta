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

animGUIList = {}
moveGUIList = {}
sizeGUIList = {}
alphaGUIList = {}

function dxIsAnimating(gui)
	assert(emIsDxElement(gui),"Bad argument @dxIsAnimating at argument 1, expect dgs-dxgui got "..dxGetType(gui))
	return moveGUIList[gui] or false
end

function dxAnimTo(gui,property,value,easing,thetime)
	assert(emIsDxElement(gui),"Bad argument @dxAnimTo at argument 1, expect dgs-dxgui got "..dxGetType(gui))
	local thetime = tonumber(thetime)
	assert(type(property) == "string","Bad argument @dxAnimTo at argument 2, expect string got "..type(property))
	assert(thetime,"Bad argument @dxAnimTo at argument 6, expect number got "..type(thetime))
	local easing = easing or "Linear"
	assert(doesEasingFunctionExist(easing),"Bad argument @dxAnimTo at argument 4, easing function doesn't exist ("..tostring(easing)..")")
	assert(not(type(value) ~= "number" and builtins[easing]),"Bad argument @dxAnimTo, only number can be passed with mta built-in easing type")
	emSetData(gui,"anim",{[0]=getTickCount(),property,value,dgsElementData[gui][property],easing,thetime})
	if not animGUIList[gui] then
		animGUIList[gui] = true
		return true
	end
	return false
end

function dxStopAnimating(gui)
	assert(emIsDxElement(gui),"Bad argument @dxStopAnimating at argument 1, expect dgs-dxgui got "..dxGetType(gui))
	if animGUIList[gui] then
		emSetData(gui,"anim",false)
		animGUIList[gui] = nil
		return true
	end
	return false
end

function dxIsMoving(gui)
	assert(emIsDxElement(gui),"Bad argument @dxIsMoving at argument 1, expect dgs-dxgui got "..dxGetType(gui))
	return moveGUIList[gui] or false
end

function dxMoveTo(gui,x,y,relative,movetype,easing,torvx,vy,tab)
	assert(emIsDxElement(gui),"Bad argument @dxMoveTo at argument 1, expect dgs-dxgui got "..dxGetType(gui))
	local x,y,torvx = tonumber(x),tonumber(y),tonumber(torvx)
	assert(x,"Bad argument @dxMoveTo at argument 2, expect number got "..type(x))
	assert(y,"Bad argument @dxMoveTo at argument 3, expect number got "..type(y))
	assert(torvx,"Bad argument @dxMoveTo at argument 7, expect number got "..type(torvx))
	local easing = easing or "Linear"
	assert(doesEasingFunctionExist(easing),"Bad argument @dxMoveTo at argument 6, easing function doesn't exist ("..tostring(easing)..")")
	local ox,oy = dxGetPosition(gui,relative or false)
	emSetData(gui,"move",{[-1]=tab,[0]=getTickCount(),getDistanceBetweenPoints2D(ox,oy,x,y),ox,oy,x,y,relative or false,movetype,easing,torvx,vy or torvx})
	if not moveGUIList[gui] then
		moveGUIList[gui] = true
		return true
	end
	return false
end

function dxStopMoving(gui)
	assert(emIsDxElement(gui),"Bad argument @dxStopMoving at argument 1, expect dgs-dxgui got "..dxGetType(gui))
	if moveGUIList[gui] then
		emSetData(gui,"move",false)
		moveGUIList[gui] = nil
		return true
	end
	return false
end

function dxIsSizing(gui)
	assert(emIsDxElement(gui),"Bad argument @dxIsSizing at argument 1, expect dgs-dxgui got "..dxGetType(gui))
	return sizeGUIList[gui] or false
end

function dxSizeTo(gui,x,y,relative,movetype,easing,torvx,vy,tab)
	assert(emIsDxElement(gui),"Bad argument @dxSizeTo at argument 1, expect dgs-dxgui got "..dxGetType(gui))
	local x,y,torvx = tonumber(x),tonumber(y),tonumber(torvx)
	assert(x,"Bad argument @dxSizeTo at argument 2, expect number got "..type(x))
	assert(y,"Bad argument @dxSizeTo at argument 3, expect number got "..type(y))
	assert(torvx,"Bad argument @dxSizeTo at argument 7, expect number got "..type(torvx))
	local easing = easing or "Linear"
	assert(doesEasingFunctionExist(easing),"Bad argument @dxSizeTo at argument 6, easing function doesn't exist ("..tostring(easing)..")")
	local ox,oy = dxGetSize(gui,relative or false)
	emSetData(gui,"size",{[-1]=tab,[0]=getTickCount(),getDistanceBetweenPoints2D(ox,oy,x,y),ox,oy,x,y,relative or false,movetype,easing,torvx,vy or torvx})
	if not sizeGUIList[gui] then
		sizeGUIList[gui] = true
		return true
	end
	return false
end

function dxStopSizing(gui)
	assert(emIsDxElement(gui),"Bad argument @dxStopSizing at argument 1, expect dgs-dxgui got "..dxGetType(gui))
	if sizeGUIList[gui] then
		emSetData(gui,"size",false)
		sizeGUIList[gui] = nil
		return true
	end
	return false
end

function dxIsAlphaing(gui)
	assert(emIsDxElement(gui),"Bad argument @dxIsAlphaing at argument 1, expect dgs-dxgui got "..dxGetType(gui))
	return alphaGUIList[gui] or false
end

function dxAlphaTo(gui,toalpha,movetype,easing,torv,tab)
	assert(emIsDxElement(gui),"Bad argument @dxAlphaTo at argument 1, expect dgs-dxgui got "..dxGetType(gui))
	local toalpha,torv = tonumber(toalpha),tonumber(torv)
	assert(toalpha,"Bad argument @dxAlphaTo at argument 2, expect number got "..type(toalpha))
	assert(torv,"Bad argument @dxAlphaTo at argument 5, expect number got "..type(torv))
	local easing = easing or "Linear"
	assert(doesEasingFunctionExist(easing),"Bad argument @dxAlphaTo at argument 4, easing function doesn't exist ("..tostring(easing)..")")
	local toalpha = (toalpha > 1 and 1) or (toalpha < 0 and 0) or toalpha
	emSetData(gui,"calpha",{[-1]=tab,[0]=getTickCount(),emGetData(gui,"alpha")-toalpha,toalpha,movetype,easing,torv})
	if not alphaGUIList[gui] then
		alphaGUIList[gui] = true
		return true
	end
	return
end

function dxStopAlphaing(gui)
	assert(emIsDxElement(gui),"Bad argument @dxStopAlphaing at argument 1, expect dgs-dxgui got "..dxGetType(gui))
	if alphaGUIList[gui] then
		emSetData(gui,"calpha",false)
		alphaGUIList[gui] = nil
		return true
	end
	return false
end

addEventHandler("onClientRender",root,function()
	local tickCount = getTickCount()
	for v,value in pairs(animGUIList) do
		if not emIsDxElement(v) or not value then animGUIList[v] = nil end
		local data = dgsElementData[v].anim
		if not data then animGUIList[v] = nil end
		if animGUIList[v] then
			local propertyName,targetValue,oldValue,easing,thetime = data[1],data[2],data[3],data[4],data[5]
			local changeTime = tickCount-data[0]
			if changeTime <= thetime then
				if builtins[easing] then
					local percent = oldValue+getEasingValue(changeTime/thetime,easing)*(targetValue-oldValue)
					dxSetProperty(v,propertyName,percent)
				else
					if SelfEasing[easing] then
						local value = SelfEasing[easing](changeTime/thetime,{propertyName,targetValue,oldValue})
						dxSetProperty(v,propertyName,value)
					else
						animGUIList[v] = nil
						assert(false,"Bad argument @dxAnimTo, easing function is missing during running easing funcition("..easing..")")
					end
				end
			else
				animGUIList[v] = nil
			end
		end
	end
	for v,value in pairs(moveGUIList) do
		if not emIsDxElement(v) or not value then moveGUIList[v] = nil end
		local data = dgsElementData[v].move
		if not data then moveGUIList[v] = nil end
		if moveGUIList[v] then
			local allDistance,ox,oy,x,y,rlt,mtype,easing,torvx,vy,settings = data[1],data[2],data[3],data[4],data[5],data[6],data[7],data[8],data[9],data[-1]
			local nx,ny = dxGetPosition(v,rlt)
			local tx,ty
			local compMove = false
			local percentx,percenty
			if mtype then
				local disx,disy = x-ox,y-oy
				local percentxo,percentyo = disx~=0 and (nx-ox)/disx or 1,disy ~= 0 and (ny-oy)/disy or 1
				if builtins[easing] then
					percentx,percenty = getEasingValue(percentxo,easing)*percentxo,getEasingValue(percentyo,easing)*percentyo
				else
					percentx,percenty = getEasingValue2(percentxo,easing,settings)*percentxo,getEasingValue2(percentyo,easing,settings)*percentyo
				end
				if percentxo >= 1 and percentyo >= 1 then
					compMove = true
					tx,ty = x,y
				else
					tx,ty = nx+torvx,ny+vy
				end
			else
				local changeTime = tickCount-data[0]
				local temp = changeTime/torvx
				if builtins[easing] then
					percentx,percenty = interpolateBetween(ox,oy,0,x,y,0,temp,easing)
				else
					percentx,percenty = interpolateBetween2(ox,oy,0,x,y,0,temp,easing,settings)
				end
				if temp >= 1 then
					compMove = true
					tx,ty = x,y
				else
					tx,ty = percentx,percenty
				end
			end
			dxSetPosition(v,tx,ty,rlt)
			if compMove then
				dxStopMoving(v)
			end
		end
	end
	for v,value in pairs(sizeGUIList) do
		if not emIsDxElement(v) or not value then sizeGUIList[v] = nil end
		local data = emGetData(v,"size")
		if not data then sizeGUIList[v] = nil end
		if sizeGUIList[v] then
			local allDistance,ox,oy,x,y,rlt,mtype,easing,torvx,vy,settings = data[1],data[2],data[3],data[4],data[5],data[6],data[7],data[8],data[9],data[-1]
			local nx,ny = dxGetSize(v,rlt)
			local tx,ty
			local compSize = false
			local percentx,percenty
			if mtype then
				local disx,disy = x-ox,y-oy
				local percentxo,percentyo = disx~=0 and (nx-ox)/disx or 1,disy ~= 0 and (ny-oy)/disy or 1
				if builtins[easing] then
					percentx,percenty = getEasingValue(percentxo,easing)*percentxo,getEasingValue(percentyo,easing)*percentyo
				else
					percentx,percenty = getEasingValue2(percentxo,easing,settings)*percentxo,getEasingValue2(percentyo,easing,settings)*percentyo
				end
				if percentxo >= 1 and percentyo >= 1 then
					compSize = true
					tx,ty = x,y
				else
					tx,ty = nx+torvx,ny+vy
				end
			else
				local changeTime = tickCount-data[0]
				local temp = changeTime/torvx
				if builtins[easing] then
					percentx,percenty = interpolateBetween(ox,oy,0,x,y,0,temp,easing)
				else
					percentx,percenty = interpolateBetween2(ox,oy,0,x,y,0,temp,easing,settings)
				end
				if temp >= 1 then
					compSize = true
					tx,ty = x,y
				else
					tx,ty = percentx,percenty
				end
			end
			dxSetSize(v,tx,ty,rlt)
			if compSize then
				dxStopSizing(v)
			end
		end
	end
	for v,value in pairs(alphaGUIList) do
		if not emIsDxElement(v) or not value then alphaGUIList[v] = nil end
		local data = dgsElementData[v].calpha
		if not data then alphaGUIList[v] = nil end
		local allDistance,endalpha,mtype,easing,torv,settings = data[1],data[2],data[3],data[4],data[5],data[-1]
		local alp = dgsElementData[v].alpha
		if not alp then alphaGUIList[v] = nil end
		if alphaGUIList[v] then
			local talp
			local compAlpha = false
			local percentalp
			if mtype then
				local percentalpo = alp-(endalpha+allDistance)/allDistance
				if builtins[easing] then
					percentalp = getEasingValue(percentalpo,easing or "Linear")*percentalpo
				else
					percentalp = getEasingValue2(percentalpo,easing,settings)*percentalpo
				end
				if percentalpo >= 1 then
					compAlpha = true
					talp = endalpha
				else
					talp = talp+torv+percentalp*torv
				end
			else
				local changeTime = tickCount-data[0]
				local temp = changeTime/torv
				if builtins[easing] then
					percentalp = interpolateBetween(endalpha+allDistance,0,0,endalpha,0,0,temp,easing or "Linear")
				else
					percentalp = interpolateBetween2(endalpha+allDistance,0,0,endalpha,0,0,temp,easing,settings)
				end
				if temp >= 1 then
					compAlpha = true
					talp = endalpha
				else
					talp = percentalp
				end
			end
			emSetData(v,"alpha",talp)
			if compAlpha then
				dxStopAlphaing(v)
			end
		end
	end
	tickCount = getTickCount()
end)

function interpolateBetween2(x,y,z,tx,ty,tz,percent,easing,settings)
	if SelfEasing[easing] then
		local nx,ny,nz = 0,0,0
		local temp = SelfEasing[easing](percent,settings)
		local diff = {tx-x,ty-y,tz-z}
		if diff[1] ~= 0 then
			nx = temp*diff[1]+x
		end
		if diff[2] ~= 0 then
			ny = temp*diff[2]+y
		end
		if diff[3] ~= 0 then
			ny = temp*diff[3]+z
		end
		return nx,ny,nz
	end
	return false
end

function getEasingValue2(percent,easing,settings)
	if SelfEasing[easing] then
		return SelfEasing[easing](percent,settings)
	end
end