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

checkBox = {}
checkBox.false_ = dxCreateTexture("image/checkbox/cb_f.png")
checkBox.true_ = dxCreateTexture("image/checkbox/cb_t.png")
checkBox.inde_ = dxCreateTexture("image/checkbox/cb_i.png")
checkBox.false_cli = dxCreateTexture("image/checkbox/cb_f_s.png")
checkBox.true_cli = dxCreateTexture("image/checkbox/cb_t_s.png")
checkBox.inde_cli = dxCreateTexture("image/checkbox/cb_i_s.png")

--[[
	[CheckBox States]
	true: checked
	false: unchecked
	nil: indeterminate
]]

function dxCreateCheckBox(x, y, sx, sy, text, state, relative, parent, textcolor, scalex, scaley, defimg_f, hovimg_f, cliimg_f, defcolor_f, hovcolor_f, clicolor_f, defimg_t, hovimg_t, cliimg_t, defcolor_t, hovcolor_t, clicolor_t, defimg_i, hovimg_i, cliimg_i, defcolor_i, hovcolor_i, clicolor_i)
	assert(tonumber(x),"Bad argument @dxCreateCheckBox at argument 1, expect number got "..type(x))
	assert(tonumber(y),"Bad argument @dxCreateCheckBox at argument 2, expect number got "..type(y))
	assert(tonumber(sx),"Bad argument @dxCreateCheckBox at argument 3, expect number got "..type(sx))
	assert(tonumber(sy),"Bad argument @dxCreateCheckBox at argument 4, expect number got "..type(sy))
	assert(tonumber(sy),"Bad argument @dxCreateCheckBox at argument 4, expect number got "..type(sy))
	assert(not state or state == true,"@dxCreateCheckBox at argument 6, expect boolean/nil got "..type(state))
	if isElement(parent) then
		assert(emIsDxElement(parent),"Bad argument @dxCreateCheckBox at argument 8,expect dgs-dxgui got "..dxGetType(parent))
	end
	local cb = createElement("dgs-dxcheckbox")
	dgsSetType(cb,"dgs-dxcheckbox")
	local _x = emIsDxElement(parent) and dxSetParent(cb,parent,true) or table.insert(MaxFatherTable,1,cb)
	defimg_f = defimg_f or checkBox.false_
	hovimg_f = hovimg_f or checkBox.false_cli
	cliimg_f = cliimg_f or hovimg_f
	
	defcolor_f = defcolor_f or schemeColor.checkbox.defcolor_f[1]
	hovcolor_f = hovcolor_f or schemeColor.checkbox.defcolor_f[2]
	clicolor_f = clicolor_f or schemeColor.checkbox.defcolor_f[3]
	
	defimg_t = defimg_t or checkBox.true_
	hovimg_t = hovimg_t or checkBox.true_cli
	cliimg_t = cliimg_t or hovimg_t
	
	defcolor_t = defcolor_t or schemeColor.checkbox.defcolor_t[1]
	hovcolor_t = hovcolor_t or schemeColor.checkbox.defcolor_t[2]
	clicolor_t = clicolor_t or schemeColor.checkbox.defcolor_t[3]
	
	defimg_i = defimg_i or checkBox.inde_
	hovimg_i = hovimg_i or checkBox.inde_cli
	cliimg_i = cliimg_i or hovimg_i
	
	defcolor_i = defcolor_i or schemeColor.checkbox.defcolor_i[1]
	hovcolor_i = hovcolor_i or schemeColor.checkbox.defcolor_i[2]
	clicolor_i = clicolor_i or schemeColor.checkbox.defcolor_i[3]
	
	emSetData(cb,"cbParent",emIsDxElement(parent) and parent or resourceRoot)
	emSetData(cb,"image_f",{defimg_f,hovimg_f,cliimg_f})
	emSetData(cb,"image_t",{defimg_t,hovimg_t,cliimg_t})
	emSetData(cb,"image_i",{defimg_i,hovimg_i,cliimg_i})
	emSetData(cb,"color_f",{defcolor_f,hovcolor_f,clicolor_f})
	emSetData(cb,"color_t",{defcolor_t,hovcolor_t,clicolor_t})
	emSetData(cb,"color_i",{defcolor_i,hovcolor_i,clicolor_i})
	emSetData(cb,"text",tostring(text))
	emSetData(cb,"textcolor",textcolor or schemeColor.checkbox.textcolor)
	emSetData(cb,"textsize",{tonumber(scalex) or 1,tonumber(scaley) or 1})
	emSetData(cb,"textImageSpace",{2,false})
	emSetData(cb,"shadow",{_,_,_})
	emSetData(cb,"font",systemFont)
	emSetData(cb,"buttonsize",{16,false})
	emSetData(cb,"clip",false)
	emSetData(cb,"wordbreak",false)
	emSetData(cb,"colorcoded",false)
	emSetData(cb,"CheckBoxState",state)
	emSetData(cb,"rightbottom",{"left","center"})
	insertResourceDxGUI(sourceResource,cb)
	triggerEvent("onDgsPreCreate",cb)
	calculateGuiPositionSize(cb,x,y,relative or false,sx,sy,relative or false,true)
	triggerEvent("onDgsCreate",cb)
	return cb
end

function dxCheckBoxGetSelected(cb)
	assert(dxGetType(cb) == "dgs-dxcheckbox","Bad argument @dxCheckBoxGetSelected at argument 1,expect dgs-dxcheckbox got "..dxGetType(cb))
	return dgsElementData[cb].CheckBoxState
end

function dxCheckBoxSetSelected(cb, state)
	assert(dxGetType(cb) == "dgs-dxcheckbox","Bad argument @dxCheckBoxSetSelected at argument 1,expect dgs-dxcheckbox got "..dxGetType(cb))
	assert(not state or state == true,"Bad argument @dxCheckBoxSetSelected at argument 2,expect boolean/nil got "..type(state))
	local oldState = dgsElementData[cb].CheckBoxState
	if state ~= oldState then
		triggerEvent("onDgsCheckBoxChange",cb,state,oldState)
	end
	return true
end

addEventHandler("onDgsCheckBoxChange",resourceRoot,function(state)
	if not wasEventCancelled() then
		emSetData(source,"CheckBoxState",state)
	end
end)