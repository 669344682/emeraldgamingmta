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
|    /| | | | |    |  __||  __/| |    |  _  |\ /
| |\ \\ \_/ / |____| |___| |   | |____| | | || |
\_| \_|\___/\_____/\____/\_|   \_____/\_| |_/\_/

Copyright of the Emerald Gaming Development Team, do not distribute - All rights reserved. ]]

emGUI = exports.emGUI

buttonFont_15 = emGUI:dxCreateNewFont("fonts/buttonFont.ttf", 15)
buttonFont_20 = emGUI:dxCreateNewFont("fonts/buttonFont.ttf", 20)
nametagsFont_15 = emGUI:dxCreateNewFont(":assets/fonts/nametagsFont.ttf", 15)

function initLoginEvents()
	local logged = getElementData(localPlayer, "loggedin")
	if (logged == 1) or (logged == 2) then return end

	fadeCamera(true, 3)
	showChat(false)
	showCursor(false)
	triggerServerEvent("setLoginTempNames", localPlayer)
	setElementData(localPlayer, "loggedin", 0, true)
	setCameraMatrix(1875.212890625, 475.1435546875, 91.699554443359, 1960.2685546875, 665.509765625, 89.779525756836) -- Set player overlooking LV.
	
	backgroundMusic = playSound("/sounds/music.mp3", true)
	setSoundVolume(backgroundMusic, 0.8)
	setTimer(startAnimatedLoginGUI, 2500, 1)
end
addEventHandler("onClientResourceStart", resourceRoot, initLoginEvents)

function startAnimatedLoginGUI()
	animatedLoginMenu = emGUI:dxCreateWindow(0.32, -1, 0.36, 0.27, "", true, true, true, true)
	
	loginMenuMirrorUI = emGUI:dxCreateWindow(0.32, -1, 0.36, 0.65, "", true, true, true, true, _, _, _, tocolor(255,0,0,0), _, tocolor(255,0,0,0))
	emeraldLogoImage = emGUI:dxCreateImage(0.11, 0.1, 0.72, 0.22, ":assets/images/logoLarge.png", true, loginMenuMirrorUI)

	emGUI:dxMoveTo(animatedLoginMenu, 0.32, 0.19, true, false, "OutQuad", 1500)
	emGUI:dxMoveTo(loginMenuMirrorUI, 0.32, 0.19, true, false, "OutQuad", 1500)

	setTimer(function()
		emGUI:dxSizeTo(animatedLoginMenu, 0.36, 0.63, true, false, "Linear", 400)
	end, 1510, 1)

	setTimer(function()
		emGUI:dxSetVisible(loginMenuMirrorUI, false)
		emGUI:dxSetVisible(animatedLoginMenu, false)
		emGUI:dxSizeTo(animatedLoginMenu, 0.36, 0.65, true, false, "Linear", 400)
		drawLoginMenuGUI()
	end, 1970, 1)
end

function startAnimatedLoginToReg()
	emGUI:dxSetVisible(loginMenuGUI, false)
	emGUI:dxSetVisible(loginMenuMirrorUI, true)
	emGUI:dxSetVisible(animatedLoginMenu, true)

	emGUI:dxSizeTo(animatedLoginMenu, 0.36, 0.27, true, false, "Linear", 400)
	setTimer(function()
		emGUI:dxMoveTo(loginMenuMirrorUI, 0.32, 0.11, true, false, "OutQuad", 1000)
		emGUI:dxMoveTo(animatedLoginMenu, 0.32, 0.11, true, false, "OutQuad", 1000)
	end, 450, 1)

	setTimer(function()
		emGUI:dxSizeTo(animatedLoginMenu, 0.36, 0.75, true, false, "Linear", 600)
	end, 1000, 1)

	setTimer(function()
		emGUI:dxSetVisible(loginMenuMirrorUI, false)
		emGUI:dxSetVisible(animatedLoginMenu, false)
		drawRegisterMenuGUI()
	end, 1600, 1)
end

function startAnimatedRegToLogin()
	
	emGUI:dxCloseWindow(registerMenuGUI)
	emGUI:dxSetVisible(loginMenuMirrorUI, true)
	emGUI:dxSetVisible(animatedLoginMenu, true)

	emGUI:dxSizeTo(animatedLoginMenu, 0.36, 0.27, true, false, "Linear", 400)
	setTimer(function()
		emGUI:dxMoveTo(loginMenuMirrorUI, 0.32, 0.19, true, false, "OutQuad", 1000)
		emGUI:dxMoveTo(animatedLoginMenu, 0.32, 0.19, true, false, "OutQuad", 1000)
	end, 500, 1)

	setTimer(function()
		emGUI:dxSizeTo(animatedLoginMenu, 0.36, 0.65, true, false, "Linear", 600)
	end, 1000, 1)

	setTimer(function()
		emGUI:dxSetVisible(loginMenuMirrorUI, false)
		emGUI:dxSetVisible(animatedLoginMenu, false)
		emGUI:dxSetVisible(loginMenuGUI, true)
	end, 1600, 1)
end

function startAnimateRegToRegDone()
	emGUI:dxCloseWindow(registerMenuGUI)
	emGUI:dxSetVisible(loginMenuMirrorUI, true)
	emGUI:dxSetVisible(animatedLoginMenu, true)

	emGUI:dxSizeTo(animatedLoginMenu, 0.36, 0.27, true, false, "Linear", 600)
	setTimer(function()
		emGUI:dxSizeTo(animatedLoginMenu, 0.36, 0.75, true, false, "Linear", 600)
	end, 1000, 1)

	setTimer(function()
		emGUI:dxSetVisible(loginMenuMirrorUI, false)
		emGUI:dxSetVisible(animatedLoginMenu, false)
		drawRegisterDoneMenuGUI()
	end, 1700, 1)
end

function startAnimateRegDoneToLogin()
	emGUI:dxCloseWindow(regDoneMenuGUI)
	emGUI:dxSetVisible(loginMenuMirrorUI, true)
	emGUI:dxSetVisible(animatedLoginMenu, true)

	emGUI:dxSizeTo(animatedLoginMenu, 0.36, 0.27, true, false, "Linear", 400)
	setTimer(function()
		emGUI:dxMoveTo(loginMenuMirrorUI, 0.32, 0.19, true, false, "OutQuad", 1000)
		emGUI:dxMoveTo(animatedLoginMenu, 0.32, 0.19, true, false, "OutQuad", 1000)
	end, 500, 1)

	setTimer(function()
		emGUI:dxSizeTo(animatedLoginMenu, 0.36, 0.65, true, false, "Linear", 600)
	end, 1100, 1)

	setTimer(function()
		emGUI:dxSetVisible(loginMenuMirrorUI, false)
		emGUI:dxSetVisible(animatedLoginMenu, false)
		emGUI:dxSetVisible(loginMenuGUI, true)
	end, 1700, 1)
end

function startAnimateLoginClose()
	emGUI:dxCloseWindow(loginMenuGUI)
	emGUI:dxSetVisible(loginMenuMirrorUI, true)
	emGUI:dxSetVisible(animatedLoginMenu, true)

	emGUI:dxSizeTo(animatedLoginMenu, 0.36, 0, true, false, "Linear", 400)
	setTimer(function()
		emGUI:dxCloseWindow(loginMenuMirrorUI)
	end, 100, 1)

	setTimer(function()
		emGUI:dxCloseWindow(animatedLoginMenu)
	end, 500, 1)
end
addEvent("login:hideLoginMenu", true)
addEventHandler("login:hideLoginMenu", root, startAnimateLoginClose)


function drawLoginMenuGUI()
	loginMenuGUI = emGUI:dxCreateWindow(0.32, 0.19, 0.36, 0.65, "", true, true, _, true)

	emeraldLogoImage = emGUI:dxCreateImage(0.11, 0.1, 0.72, 0.22, ":assets/images/logoLarge.png", true, loginMenuGUI)

	usernameImage = emGUI:dxCreateImage(0.27, 0.40, 0.42, 0.09, ":login-system/images/usernameImage.png", true, loginMenuGUI)
	passwordImage = emGUI:dxCreateImage(0.27, 0.59, 0.42, 0.09, ":login-system/images/passwordImage.png", true, loginMenuGUI)

	usernameInput = emGUI:dxCreateEdit(0.27, 0.50, 0.43, 0.04, "", true, loginMenuGUI)
	emGUI:dxEditSetMaxLength(usernameInput, 20)
	
	passwordInput = emGUI:dxCreateEdit(0.27, 0.69, 0.43, 0.04, "", true, loginMenuGUI)
	emGUI:dxEditSetMaxLength(passwordInput, 199)
	emGUI:dxSetProperty(passwordInput, "masked", true)

	loginFeedbackLabel = emGUI:dxCreateLabel(0.38, 0.955, 0.2, 0.2, "", true, loginMenuGUI)
	emGUI:dxLabelSetHorizontalAlign(loginFeedbackLabel, "center")

	rememberDetailsCheck = emGUI:dxCreateCheckBox(0.14, 0.78, 0.30, 0.02, "Remember Login Information", true, true, loginMenuGUI)
	addEventHandler("onDgsCheckBoxChange", rememberDetailsCheck, rememberDetailsCheckChanged)
	
	loginButton = emGUI:dxCreateButton(0.09, 0.81, 0.37, 0.13, "", true, loginMenuGUI)
	addEventHandler("onClientDgsDxMouseClick", loginButton, loginButtonClick)
	addEventHandler("onClientKey", root, onLoginEnterClick)
	loginButtonText = emGUI:dxCreateLabel(0.21, 0.85, 0, 0, "LOGIN", true, loginMenuGUI)
	emGUI:dxSetFont(loginButtonText, buttonFont_20)
	
	registerButton = emGUI:dxCreateButton(0.51, 0.81, 0.37, 0.13, "", true, loginMenuGUI)
	addEventHandler("onClientDgsDxMouseClick", registerButton, registerButtonClick)
	registerButtonText = emGUI:dxCreateLabel(0.595, 0.85, 0, 0, "REGISTER", true, loginMenuGUI)
	emGUI:dxSetFont(registerButtonText, buttonFont_20)

	local username, password = handleLoginDetails("load")
	if (username ~= "") and (username) and (username ~= nil) then
		emGUI:dxSetEnabled(passwordInput, false)
		emGUI:dxSetText(usernameInput, tostring(username))
		emGUI:dxSetText(passwordInput, tostring(password))
	else
		emGUI:dxCheckBoxSetSelected(rememberDetailsCheck, false)
	end
end


function drawRegisterMenuGUI()
	local registerMenuLabels = {}
	registerMenuGUI = emGUI:dxCreateWindow(0.32, 0.11, 0.36, 0.75, "", true, true, _, true)

	emeraldLogo = emGUI:dxCreateImage(0.11, 0.09, 0.72, 0.18, ":assets/images/logoLarge.png", true, registerMenuGUI)
	
	rUsernameImage = emGUI:dxCreateImage(0.03, 0.34, 0.42, 0.08, ":login-system/images/usernameImage.png", true, registerMenuGUI)
	rUsernameInput = emGUI:dxCreateEdit(0.08, 0.45, 0.40, 0.03, "", true, registerMenuGUI)
	
	rPasswordImage = emGUI:dxCreateImage(0.03, 0.49, 0.42, 0.08, ":login-system/images/passwordImage.png", true, registerMenuGUI)
	rPasswordInput = emGUI:dxCreateEdit(0.08, 0.60, 0.40, 0.03, "", true, registerMenuGUI)
	rPasswordRepeatInput = emGUI:dxCreateEdit(0.50, 0.60, 0.40, 0.03, "", true, registerMenuGUI)
	emGUI:dxSetProperty(rPasswordInput, "masked", true)
	emGUI:dxSetProperty(rPasswordRepeatInput, "masked", true)
	
	rEmailImage = emGUI:dxCreateImage(0.03, 0.65, 0.42, 0.08, ":login-system/images/emailImage.png", true, registerMenuGUI)
	rEmailInput = emGUI:dxCreateEdit(0.08, 0.762, 0.40, 0.03, "", true, registerMenuGUI)
	
	registerMenuLabels[1] = emGUI:dxCreateLabel(0.08, 0.42, 0.57, 0.03, "This will be your account's name throughout your stay on the server.", true, registerMenuGUI)
	registerMenuLabels[2] = emGUI:dxCreateLabel(0.08, 0.57, 0.39, 0.02, "Input Password", true, registerMenuGUI)
	registerMenuLabels[3] = emGUI:dxCreateLabel(0.50, 0.57, 0.39, 0.02, "Repeat Password", true, registerMenuGUI)
	registerMenuLabels[4] = emGUI:dxCreateLabel(0.08, 0.73, 0.58, 0.02, "Make sure your email is valid, you will need it to activate your account!", true, registerMenuGUI)
	
	registerFeedbackLabel = emGUI:dxCreateLabel(0.34, 0.818, 0.31, 0.02, "", true, registerMenuGUI)
	emGUI:dxLabelSetHorizontalAlign(registerFeedbackLabel, "center")

	rBackButton = emGUI:dxCreateButton(0.092, 0.85, 0.35, 0.11, "", true, registerMenuGUI)
	addEventHandler("onClientDgsDxMouseClick", rBackButton, rBackButtonClick)
	rBackButtonText = emGUI:dxCreateLabel(0.203, 0.885, 0, 0, "BACK", true, registerMenuGUI)
	emGUI:dxSetFont(rBackButtonText, buttonFont_20)
	
	rSubmitButton = emGUI:dxCreateButton(0.56, 0.85, 0.35, 0.11, "", true, registerMenuGUI)
	addEventHandler("onClientDgsDxMouseClick", rSubmitButton, rSubmitButtonClick)
	rSubmitButtonText = emGUI:dxCreateLabel(0.657, 0.885, 0, 0, "SUBMIT", true, registerMenuGUI)
	emGUI:dxSetFont(rSubmitButtonText, buttonFont_20)
end


function drawRegisterDoneMenuGUI()
	local rdLabels = {}
	regDoneMenuGUI = emGUI:dxCreateWindow(0.32, 0.11, 0.36, 0.75, "", true, true, _, true)

	rdemeraldLogo = emGUI:dxCreateImage(0.11, 0.1, 0.72, 0.22, ":assets/images/logoLarge.png", true, regDoneMenuGUI)
	rdLabels[1] = emGUI:dxCreateLabel(0.15, 0.34, 0.68, 0.04, "WELCOME TO THE COMMUNITY!", true, regDoneMenuGUI)
	rdLabels[2] = emGUI:dxCreateLabel(0.14, 0.40, 0.71, 0.03, "You're one step closer to joining the server.", true, regDoneMenuGUI)
	rdLabels[3] = emGUI:dxCreateLabel(0.106, 0.44, 0.79, 0.38, "Now that your account is made, there's just one more step to get out of the\nway and you'll be ready to roleplay.\n\nHead on over to our website and login with the account you just\nmade at: https://emeraldgaming.net\n\nWhen you log in, you'll need to submit an application to join the server.\nA staff member will review it as soon as possible and when your application has\nbeen accepted, you'll be notified via email.\n\nIf you need any help, head on over to our forums!", true, regDoneMenuGUI)
	
	emGUI:dxSetFont(rdLabels[1], buttonFont_20)
	emGUI:dxSetFont(rdLabels[2], buttonFont_15)
	emGUI:dxSetFont(rdLabels[3], nametagsFont_15)
	emGUI:dxLabelSetHorizontalAlign(rdLabels[1], "center")
	emGUI:dxLabelSetHorizontalAlign(rdLabels[2], "center")
	emGUI:dxLabelSetHorizontalAlign(rdLabels[3], "center")

	rdCompleteRegButton = emGUI:dxCreateButton(0.19, 0.84, 0.62, 0.12, "", true, regDoneMenuGUI)
	addEventHandler("onClientDgsDxMouseClick", rdCompleteRegButton, rdCompleteRegButtonClick)
	rdCompleteRegLabel = emGUI:dxCreateLabel(0.215, 0.88, 0, 0, "COMPLETE REGISTRATION", true, regDoneMenuGUI)
	emGUI:dxSetFont(rdCompleteRegLabel, buttonFont_20)
end


function handleLoginDetails(state, u, p)
	if (state == "load") then
		local loginDetailsXML = xmlLoadFile("creds.xml")
		if not loginDetailsXML then
			return false
		end

		local usernameNode = xmlFindChild(loginDetailsXML, "username", 0)
		local passwordNode = xmlFindChild(loginDetailsXML, "password", 0)
		local username, password = xmlNodeGetValue(usernameNode) or "", xmlNodeGetValue(passwordNode) or ""
		xmlUnloadFile(loginDetailsXML)
		return username, password
	elseif (state == "save") then
		local loginDetailsXML = xmlLoadFile ("creds.xml")
		if not loginDetailsXML then
			loginDetailsXML = xmlCreateFile("creds.xml", "emcreds")
		end
		if (u ~= "") and (u) then
			local usernameNode = xmlFindChild(loginDetailsXML, "username", 0)
			local passwordNode = xmlFindChild(loginDetailsXML, "password", 0)
			if not usernameNode then
				usernameNode = xmlCreateChild(loginDetailsXML, "username")
			end
			if not passwordNode then
				passwordNode = xmlCreateChild(loginDetailsXML, "password")
			end
			xmlNodeSetValue(usernameNode, u)
			xmlNodeSetValue(passwordNode, p)
		end
		xmlSaveFile(loginDetailsXML)
		xmlUnloadFile (loginDetailsXML)
	elseif (state == "delete") then
		local loginDetailsXML = xmlLoadFile("creds.xml")
		if (loginDetailsXML) then
			fileDelete("creds.xml")
			xmlUnloadFile(loginDetailsXML)
		end
	end
end
addEvent("login:handleLoginDetails", true)
addEventHandler("login:handleLoginDetails", root, handleLoginDetails)

function setFeedbackText(label, text, r, g, b, togButtonState)
	if not tonumber(label) then label = 1 end
	if not tostring(text) then return false end
	if not (r) or not (g) or not (b) then r, g, b = 255, 0, 0 end

	if (label == 1) then
		emGUI:dxSetText(loginFeedbackLabel, text)
		emGUI:dxLabelSetColor(loginFeedbackLabel, r, g, b)
	elseif (label == 2) then
		emGUI:dxSetText(registerFeedbackLabel, text)
		emGUI:dxLabelSetColor(registerFeedbackLabel, r, g, b)
	end

	if (tonumber(togButtonState) == 1) then
		emGUI:dxSetEnabled(loginButton, true)
		emGUI:dxBringToFront(loginButtonText)
	elseif (tonumber(togButtonState) == 2) then
		emGUI:dxSetEnabled(rSubmitButton, true)
		emGUI:dxBringToFront(rSubmitButtonText)
	end
end
addEvent("login:setFeedbackText", true)
addEventHandler("login:setFeedbackText", root, setFeedbackText)

function rememberDetailsCheckChanged(state)
	if not (state) then
		local isPassEnabled = emGUI:dxGetEnabled(passwordInput)
		if not isPassEnabled then
			emGUI:dxSetEnabled(passwordInput, true)
			emGUI:dxSetText(passwordInput, "")
		end
	end
end

function onLoginEnterClick(button, press)
	if (button == "enter") or (button == "num_enter") and press then
		loginButtonClick("left", "down")
	end
end

local spamPreventTimer = nil
function loginButtonClick(button, state)
	if (button == "left") and (state == "down") then
		if not getElementData(localPlayer, "temp:login:logintimer") then
			setElementData(localPlayer, "temp:login:logintimer", true)
			local theUsername = emGUI:dxGetText(usernameInput)
			local thePassword = emGUI:dxGetText(passwordInput)
			local saveDetails = emGUI:dxCheckBoxGetSelected(rememberDetailsCheck)

			if isTimer(spamPreventTimer) then
				killTimer(spamPreventTimer)
			end
			spamPreventTimer = setTimer(setElementData, 1000, 1, localPlayer, "temp:login:logintimer", nil)

			if (saveDetails) then saveDetails = true end
			playSoundFrontEnd(18)
			emGUI:dxSetEnabled(loginButton, false)
			setFeedbackText(1, "Logging in..", 0, 255, 0)
			triggerServerEvent("login:attemptLogin", localPlayer, theUsername, thePassword, saveDetails)
		else
			setFeedbackText(1, "Slow down, you're logging in too quick!")
		end
	elseif (button == "left") and (state == "up") then
		emGUI:dxBringToFront(loginButtonText)
	end
end

function registerButtonClick(button, state)
	if (button == "left") and (state == "down") then
		startAnimatedLoginToReg()
		setFeedbackText(1, "")
		emGUI:dxBringToFront(registerButtonText)
	elseif (button == "left") and (state == "up") then
		emGUI:dxBringToFront(registerButtonText)
	end
end

function rBackButtonClick(button, state)
	if (button == "left") and (state == "down") then
		startAnimatedRegToLogin()
	elseif (button == "left") and (state == "up") then
		emGUI:dxBringToFront(rBackButtonText)
	end
end

function rSubmitButtonClick(button, state)
	if (button == "left") and (state == "down") then
		local theUsername = emGUI:dxGetText(rUsernameInput)
		local thePassword = emGUI:dxGetText(rPasswordInput)
		local passwordConfirm = emGUI:dxGetText(rPasswordRepeatInput)
		local theEmail = emGUI:dxGetText(rEmailInput)

		if not theUsername or theUsername == "" or not thePassword or thePassword == "" or not passwordConfirm or passwordConfirm == "" or not theEmail or theEmail == ""  then
			setFeedbackText(2, "Please fill in all the information!")
			playSoundFrontEnd(4)
		elseif string.len(theUsername) < 3 then
			setFeedbackText(2, "Your username must have at least 3 characters!")
			playSoundFrontEnd(4)
		elseif string.len(theUsername) > 25 then
			setFeedbackText(2, "Your username cannot have more than 25 characters!")
			playSoundFrontEnd(4)
		elseif string.find(thePassword, "'") or string.find(thePassword, '"') then
			setFeedbackText(2, "Sorry, but your password can't contain ' or "..'"!')
			playSoundFrontEnd(4)
		elseif string.len(thePassword) < 8 then
			setFeedbackText(2, "Your password must be more than 8 characters!")
			playSoundFrontEnd(4)
		elseif thePassword ~= passwordConfirm then
			setFeedbackText(2, "Your passwords don't match!")
			playSoundFrontEnd(4)
		elseif string.match(theUsername,"%W") then
			setFeedbackText(2, "You can't have special symbols in your username!")
			playSoundFrontEnd(4)
		elseif string.len(theEmail) < 6 or not string.find(theEmail,"%.") or not (string.find(theEmail,"%@")) then
			setFeedbackText(2, "That's not a valid email address!")
			playSoundFrontEnd(4)
		else
			setFeedbackText(2, "Registering..", 0, 255, 0)
			emGUI:dxSetEnabled(rSubmitButton, false)
			triggerServerEvent("login:attemptRegister", localPlayer, theUsername, thePassword, theEmail)
		end
	elseif (button == "left") and (state == "up") then
		emGUI:dxBringToFront(rSubmitButtonText)
	end
end

function rdCompleteRegButtonClick(button, state)
	if (button == "left") and (state == "down") then
		startAnimateRegDoneToLogin()
	elseif (button == "left") and (state == "up") then
		emGUI:dxBringToFront(rdCompleteRegLabel)
	end
end

function onLoginSuccess()
	stopSound(backgroundMusic)
	removeEventHandler("onClientKey", root, onLoginEnterClick)
	
	if (getElementData(localPlayer, "staff:developer") >= 3) and (getElementData(localPlayer, "staff:rank") >= 6) then
		setDebugViewActive(true)
		outputDebugString("[DEBUG] Debug mode has been automatically set to 1 (Errors).")
	end
end
addEvent("login:onLoginSuccess", true)
addEventHandler("login:onLoginSuccess", root, onLoginSuccess)

function onRegisterSuccess(username)
	playSoundFrontEnd(18)
	emGUI:dxSetText(usernameInput, username)
	startAnimateRegToRegDone()
end
addEvent("login:onRegisterSuccess", true)
addEventHandler("login:onRegisterSuccess", root, onRegisterSuccess)