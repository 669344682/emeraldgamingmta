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

local radioButton_s = {}
radioButton_s.false_ = dxCreateTexture("image/radiobutton/rb_f.png")
radioButton_s.true_ = dxCreateTexture("image/radiobutton/rb_t.png")
radioButton_s.false_cli = dxCreateTexture("image/radiobutton/rb_f_s.png")
radioButton_s.true_cli = dxCreateTexture("image/radiobutton/rb_t_s.png")

function dxCreateRadioButton(x, y, sx, sy, text, relative, parent, textcolor, scalex, scaley, defimg_f, hovimg_f, cliimg_f, defcolor_f, hovcolor_f, clicolor_f, defimg_t, hovimg_t, cliimg_t, defcolor_t, hovcolor_t, clicolor_t)
	assert(tonumber(x),"Bad argument @dxCreateRadioButton at argument 1, expect number got "..type(x))
	assert(tonumber(y),"Bad argument @dxCreateRadioButton at argument 2, expect number got "..type(y))
	assert(tonumber(sx),"Bad argument @dxCreateRadioButton at argument 3, expect number got "..type(sx))
	assert(tonumber(sy),"Bad argument @dxCreateRadioButton at argument 4, expect number got "..type(sy))
	if isElement(parent) then
		assert(emIsDxElement(parent),"Bad argument @dxCreateRadioButton at argument 7, expect dgs-dxgui got "..dxGetType(parent))
	end
	local rb = createElement("dgs-dxradiobutton")
	dgsSetType(rb,"dgs-dxradiobutton")
	local _x = emIsDxElement(parent) and dxSetParent(rb,parent,true) or table.insert(MaxFatherTable,1,rb)
	defimg_f = defimg_f or radioButton_s.false_
	hovimg_f = hovimg_f or radioButton_s.false_cli
	cliimg_f = cliimg_f or hovimg_f
	defcolor_f = defcolor_f or schemeColor.radiobutton.defcolor_f[1]
	hovcolor_f = hovcolor_f or schemeColor.radiobutton.defcolor_f[2]
	clicolor_f = clicolor_f or schemeColor.radiobutton.defcolor_f[3]
	
	defimg_t = defimg_t or radioButton_s.true_
	hovimg_t = hovimg_t or radioButton_s.true_cli
	cliimg_t = cliimg_t or hovimg_t
	
	defcolor_t = defcolor_t or schemeColor.radiobutton.defcolor_t[1]
	hovcolor_t = hovcolor_t or schemeColor.radiobutton.defcolor_t[2]
	clicolor_t = clicolor_t or schemeColor.radiobutton.defcolor_t[3]
	
	emSetData(rb,"rbParent",emIsDxElement(parent) and parent or resourceRoot)
	emSetData(rb,"image_f",{defimg_f,hovimg_f,cliimg_f})
	emSetData(rb,"image_t",{defimg_t,hovimg_t,cliimg_t})
	emSetData(rb,"color_f",{defcolor_f,hovcolor_f,clicolor_f})
	emSetData(rb,"color_t",{defcolor_t,hovcolor_t,clicolor_t})
	emSetData(rb,"text",tostring(text))
	emSetData(rb,"textcolor",textcolor or schemeColor.radiobutton.textcolor)
	emSetData(rb,"textsize",{tonumber(scalex) or 1,tonumber(scaley) or 1})
	emSetData(rb,"textImageSpace",{2,false})
	emSetData(rb,"shadow",{_,_,_})
	emSetData(rb,"font",systemFont)
	emSetData(rb,"buttonsize",{16,false})
	emSetData(rb,"clip",false)
	emSetData(rb,"wordbreak",false)
	emSetData(rb,"colorcoded",false)
	emSetData(rb,"rightbottom",{"left","center"})
	insertResourceDxGUI(sourceResource,rb)
	triggerEvent("onDgsPreCreate",rb)
	calculateGuiPositionSize(rb,x,y,relative or false,sx,sy,relative or false,true)
	triggerEvent("onDgsCreate",rb)
	return rb
end

function dxRadioButtonGetSelected(rb)
	assert(dxGetType(rb) == "dgs-dxradiobutton","Bad argument @dxRadioButtonGetSelected at argument 1, expect dgs-dxradiobutton got "..dxGetType(rb))
	local _parent = dxGetParent(rb)
	local parent = emIsDxElement(_parent) and _parent or resourceRoot
	return emGetData(parent,"RadioButton") == rb
end

function dxRadioButtonSetSelected(rb,state)
	assert(dxGetType(rb) == "dgs-dxradiobutton","Bad argument @dxRadioButtonSetSelected at argument 1, expect dgs-dxradiobutton got "..dxGetType(rb))
	state = state and true or false
	local _parent = dxGetParent(rb)
	local parent = emIsDxElement(_parent) and _parent or resourceRoot
	local _rb = emGetData(parent,"RadioButton")
	if state then
		if rb ~= _rb then
			emSetData(parent,"RadioButton",rb)
			if emIsDxElement(_rb) then
				triggerEvent("onDgsRadioButtonChange",_rb,false)
			end
			triggerEvent("onDgsRadioButtonChange",rb,true)
		end
		return true
	else
		emSetData(parent,"RadioButton",false)
		triggerEvent("onDgsRadioButtonChange",rb,false)
		return true
	end
end