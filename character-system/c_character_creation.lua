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

buttonFont_14 = emGUI:dxCreateNewFont(":emGUI/fonts/buttonFont.ttf", 14)
buttonFont_16 = emGUI:dxCreateNewFont(":emGUI/fonts/buttonFont.ttf", 16)
buttonFont_20 = emGUI:dxCreateNewFont(":emGUI/fonts/buttonFont.ttf", 20)
buttonFont_27 = emGUI:dxCreateNewFont(":emGUI/fonts/buttonFont.ttf", 27)
buttonFont_38 = emGUI:dxCreateNewFont(":emGUI/fonts/buttonFont.ttf", 38)

validationComplete = false

function beginCharCreation(player)
	local randomDim = 50000 + getElementData(player, "player:id")
	setElementInterior(player, 20)
	setElementDimension(player, randomDim)
	setElementPosition(player, 1726.17285, -2232.33008, 39.38027)
	setElementRotation(player, 0, 0, 0)
	setElementModel(player, 240)

	toggleAllControls(false)

	---- [Text Window and Labels] ----
	contentWindow = emGUI:dxCreateWindow(0.24, 0.43, 0.51, 0.14, "", true, true, true, true, _, _, _, tocolor(0, 0 , 0, 0), _, tocolor(0, 0 , 0, 0))

	lvLabel = emGUI:dxCreateLabel(0.03, 0.01, 0.95, 0.36, "San Andreas International Airport", true, contentWindow)
	emGUI:dxSetFont(lvLabel, buttonFont_38)
	emGUI:dxLabelSetHorizontalAlign(lvLabel, "center", false)
	
	lvLabel2 = emGUI:dxCreateLabel(0.88, 0.45, 0.16, 0.25, "Arrivals", true, contentWindow)
	emGUI:dxSetFont(lvLabel2, buttonFont_27)

	emGUI:dxSetAlpha(contentWindow, 0)
	emGUI:dxAlphaTo(contentWindow, 1, false, "OutQuad", 2000)
	----

	setCameraTarget(player)
	-- Timer to begin moving camera.
	setTimer(function()
		exports.global:smoothMoveCamera(1726.515625, -2241.4072265625, 40.019786834717, 1726.37890625, -2232.2197265625, 39.380271911621, 1727.353515625, -2230.4580078125, 40.599353790283, 1726.48828125, -2232.0204296875, 39.680271911621, 11000)
	end, 4000, 1)

	-- Timer to fade camera into view and to fade labels out.
	setTimer(function()
		fadeCamera(true, 2)
		emGUI:dxAlphaTo(contentWindow, 0, false, "OutQuad", 2000)
	end, 7000, 1)

	-- Time to wait until character creation GUI is shown.
	setTimer(function()
		triggerEvent("showCharCreGUI", getRootElement())
	end, 15050, 1)
end
addEvent("character:beginCharCreation", true)
addEventHandler("character:beginCharCreation", getRootElement(), beginCharCreation)

------------------------------------------------------ [Primary Character Creation GUI] ------------------------------------------------------

label = {}

addEvent("showCharCreGUI", true)
addEventHandler("showCharCreGUI", resourceRoot,
function()

	showCursor(true) -- Display the cursor in the background too, this is to keep the cursor up if the player clicks out of the GUI.

	charCreLeftMenu = emGUI:dxCreateWindow(0.19, 0.18, 0.25, 0.35, "", true, true, _, true)

	label[1] = emGUI:dxCreateLabel(0.09, 0.06, 0.12, 0.05, "First Name", true, charCreLeftMenu)
	label[2] = emGUI:dxCreateLabel(0.51, 0.06, 0.13, 0.05, "Last Name", true, charCreLeftMenu)
	label[3] = emGUI:dxCreateLabel(0.08, 0.24, 0.35, 0.04, "Date of Birth (DD/MM/YYYY)", true, charCreLeftMenu)
	label[4] = emGUI:dxCreateLabel(0.11, 0.39, 0.05, 0.05, "Day", true, charCreLeftMenu)
	label[5] = emGUI:dxCreateLabel(0.225, 0.39, 0.07, 0.05, "Month", true, charCreLeftMenu)
	label[6] = emGUI:dxCreateLabel(0.38, 0.39, 0.05, 0.05, "Year", true, charCreLeftMenu)
	label[7] = emGUI:dxCreateLabel(0.14, 0.55, 0.26, 0.05, "Character Height (cm)", true, charCreLeftMenu)
	label[8] = emGUI:dxCreateLabel(0.54, 0.55, 0.26, 0.05, "Character Weight (kg)", true, charCreLeftMenu)
	label[9] = emGUI:dxCreateLabel(0.56, 0.30, 0.26, 0.04, "Your character will be", true, charCreLeftMenu)
	yearsOldLabel = emGUI:dxCreateLabel(0.62, 0.34, 0.15, 0.04, "XX years old.", true, charCreLeftMenu)
	emGUI:dxSetVisible(label[9], false)
	emGUI:dxSetVisible(yearsOldLabel, false)

	feedbackLabel = emGUI:dxCreateLabel(0.33, 0.71, 0.30, 0.5, "", true, charCreLeftMenu)
	emGUI:dxLabelSetHorizontalAlign(feedbackLabel, "center")

	firstnameInput = emGUI:dxCreateEdit(0.09, 0.12, 0.36, 0.06, "", true, charCreLeftMenu)
	lastnameInput = emGUI:dxCreateEdit(0.51, 0.12, 0.36, 0.06, "", true, charCreLeftMenu)
	dobDD = emGUI:dxCreateEdit(0.08, 0.30, 0.11, 0.07, "", true, charCreLeftMenu)
	dobMM = emGUI:dxCreateEdit(0.21, 0.30, 0.11, 0.07, "", true, charCreLeftMenu)
	dobYYYY = emGUI:dxCreateEdit(0.34, 0.30, 0.15, 0.07, "", true, charCreLeftMenu)
	addEventHandler("onDgsTextChange", dobDD, updateAgeDisplay)
	addEventHandler("onDgsTextChange", dobMM, updateAgeDisplay)
	addEventHandler("onDgsTextChange", dobYYYY, updateAgeDisplay)

	charHeightInput = emGUI:dxCreateEdit(0.16, 0.615, 0.26, 0.07, "", true, charCreLeftMenu)
	charWeightInput = emGUI:dxCreateEdit(0.56, 0.615, 0.26, 0.07, "", true, charCreLeftMenu)
	
	exitButton = emGUI:dxCreateButton(0.06, 0.77, 0.39, 0.15, "Exit", true, charCreLeftMenu)
	addEventHandler("onClientDgsDxMouseClick", exitButton, exitButtonClick)

	continueButton = emGUI:dxCreateButton(0.52, 0.77, 0.39, 0.15, "Continue", true, charCreLeftMenu)
	addEventHandler("onClientDgsDxMouseClick", continueButton, continueButtonClick)

	----- [Side Panel] -----
	charCreationSideWindow = emGUI:dxCreateWindow(0.70, 0.17, 0.20, 0.20, "", true, true, _, true)

	label[10] = emGUI:dxCreateLabel(0.10, 0.16, 0.13, 0.09, "Origin", true, charCreationSideWindow)
	sidePanelFeedbackLabel = emGUI:dxCreateLabel(0.45, 0.02, 0.13, 0.09, "Origin must be between 3 and 30 characters!", true, charCreationSideWindow)
	emGUI:dxLabelSetHorizontalAlign(sidePanelFeedbackLabel, "center")
	emGUI:dxLabelSetColor(sidePanelFeedbackLabel, 255, 0, 0)
	emGUI:dxSetVisible(sidePanelFeedbackLabel, false)

	charOriginInput = emGUI:dxCreateEdit(0.34, 0.16, 0.50, 0.11, "", true, charCreationSideWindow)
	languageLabel = emGUI:dxCreateLabel(0.08, 0.58, 0.17, 0.09, "Language", true, charCreationSideWindow)
	
	charLangGrid = emGUI:dxCreateGridList(0.34, 0.36, 0.50, 0.51, true, charCreationSideWindow)
	emGUI:dxGridListAddColumn(charLangGrid, "Select Below", 0.9)
	for i = 1, 5 do
		emGUI:dxGridListAddRow(charLangGrid)
	end
	emGUI:dxGridListSetItemText(charLangGrid, 1, 1, "English")
	emGUI:dxGridListSetItemText(charLangGrid, 2, 1, "Irish")
	emGUI:dxGridListSetItemText(charLangGrid, 3, 1, "Spanish")
	emGUI:dxGridListSetItemText(charLangGrid, 4, 1, "German")
	emGUI:dxGridListSetItemText(charLangGrid, 5, 1, "French")
	emGUI:dxGridListSetSelectedItem(charLangGrid, 1, 1)
end)

-------------------- [Buttons] --------------------
function exitButtonClick(button, state)
	if (button == "left") and (state == "down") then
		emGUI:dxCloseWindow(charCreLeftMenu)
		emGUI:dxCloseWindow(charCreationSideWindow)
		fadeCamera(false, 1)
		toggleAllControls(true)

		setElementInterior(localPlayer, 0)
		triggerServerEvent("character:showCharacterSelection", getLocalPlayer(), localPlayer, true)
	end
end

function continueButtonClick(button, state)
	if (button == "left") and (state == "down") then
		if validateCharacterDetails() then
			character_clientisNameAvailable()

			setTimer(function()
				if (validationComplete) then
					validationComplete = false
					emGUI:dxCloseWindow(charCreLeftMenu)
					emGUI:dxCloseWindow(charCreationSideWindow)
					exports.global:smoothMoveCamera(1727.353515625, -2230.4580078125, 40.599353790283, 1726.48828125, -2232.0204296875, 39.680271911621, 1725.96875, -2230.4638671875, 40.721321105957, 1726.4921875, -2232.4658203125, 39.380271911621, 2000)
					triggerEvent("showSkinSelectorGUI", getRootElement())

					-- Set data again if it already exists from player returning to the previous menu.
					if (gender) then
						if (gender == "Female") then
							emGUI:dxSetEnabled(femaleGenderButton, false)
							emGUI:dxSetEnabled(maleGenderButton, true)
							setPedWalkingStyle(localPlayer, 129)
						else
							emGUI:dxSetEnabled(maleGenderButton, false)
							emGUI:dxSetEnabled(femaleGenderButton, true)
							setPedWalkingStyle(localPlayer, 128)
						end
					end

					if (ethnicity) then
						if (ethnicity == "Black") then
							emGUI:dxRadioButtonSetSelected(ethnicityBlackCheck, true)
						elseif(ethnicity == "Asian") then
							emGUI:dxRadioButtonSetSelected(ethnicityAsianCheck, true)
						elseif(ethnicity == "Hispanic") then
							emGUI:dxRadioButtonSetSelected(ethnicityHispanicCheck, true)
						else
							emGUI:dxRadioButtonSetSelected(ethnicityWhiteCheck, true)
						end
					end
				end
			end, 1000, 1)
		end
	end
end

-------------------- [Functions] --------------------

function updateAgeDisplay()
	local dd = emGUI:dxGetText(dobDD) or 1
	local mm = emGUI:dxGetText(dobMM) or 1
	local yyyy = emGUI:dxGetText(dobYYYY) or 2018

	if tonumber(dd) and tonumber(mm) and tonumber(yyyy) then
		dd = tonumber(dd); mm = tonumber(mm); yyyy = tonumber(yyyy)

		local ddmmyyyy = dd .. "," .. mm .. "," .. yyyy
		local age = exports.global:dobToAge(ddmmyyyy) or false
		local monthCheck = {1, 2, 3, 5, 7, 8, 10, 12}

		if tonumber(age) and (dd > 0) and (dd <= 31) and (mm > 0) and (mm <= 12) and (tonumber(age) >= 16) and (tonumber(age) <= 112) then
			if (dd == 31) then
				if not exports.global:table_find(mm, monthCheck) then
					emGUI:dxSetVisible(label[9], false)
					emGUI:dxSetVisible(yearsOldLabel, false)
					return false
				end
			end
			emGUI:dxSetText(yearsOldLabel, age .. " years old.")
			emGUI:dxSetVisible(label[9], true)
			emGUI:dxSetVisible(yearsOldLabel, true)
			return true
		end
	end
	emGUI:dxSetVisible(label[9], false)
	emGUI:dxSetVisible(yearsOldLabel, false)
	return false
end

function setFeedbackText(text, r, g, b)
	local guiState = emGUI:dxIsWindowVisible(charCreLeftMenu)
	if not r then r = 255 end
	if not g then g = 0 end
	if not b then b = 0 end

	if (guiState) and tostring(text) and tonumber(r) and tonumber(g) and tonumber(b) then
		emGUI:dxSetText(feedbackLabel, text)
		emGUI:dxLabelSetColor(feedbackLabel, r, g, b)
	end
end

function validateCharacterDetails()
	firstName = emGUI:dxGetText(firstnameInput)
	lastName = emGUI:dxGetText(lastnameInput)
	dobDay = emGUI:dxGetText(dobDD)
	dobMonth = emGUI:dxGetText(dobMM)
	dobYear = emGUI:dxGetText(dobYYYY)
	height = emGUI:dxGetText(charHeightInput)
	weight = emGUI:dxGetText(charWeightInput)
	origin = emGUI:dxGetText(charOriginInput)
	language = emGUI:dxGridListGetSelectedItem(charLangGrid)

	local validated = false

	-- Checks to see each field has a value
	if string.len(firstName) <= 0 then
		setFeedbackText("Please input a first name.")
		return false
	elseif string.len(lastName) <= 0 then
		setFeedbackText("Please input a last name.")
		return false
	elseif string.len(dobDay) <= 0 then
		setFeedbackText("Please input a Day of birth.")
		return false
	elseif string.len(dobMonth) <= 0 then
		setFeedbackText("Please input a month of birth.")
		return false
	elseif string.len(dobYear) <= 0 then
		setFeedbackText("Please input a year of birth.")
		return false
	elseif string.len(height) <= 0 then
		setFeedbackText("Please input a height.")
		return false
	elseif string.len(weight) <= 0 then
		setFeedbackText("Please input a weight.")
		return false
	end

	-- Character name validation
	local foundSpace, valid = false, true
	local lastChar, current = ' ', ''
	local fullName = firstName .. " " .. lastName

	for i = 1, #fullName do
		local char = fullName:sub(i, i)
		if char == ' ' then -- it's a space
			if i == #fullName then -- space at the end of name is not allowed
				valid = false
				setFeedbackText("Cannot have space at the end of name!")
				return false
			else
				foundSpace = true -- we have at least two name parts
				fullName = fullName:sub(1, i-1) .. "_" .. fullName:sub(i+1)
			end
			
			if #current < 2 then -- check if name's part is at least 2 chars
				valid = false
				setFeedbackText("Your name is too short!")
				return false
			end
			current = ''
		elseif lastChar == ' ' then -- this character follows a space, we need a capital letter
			if char < 'A' or char > 'Z' then
				valid = false
				setFeedbackText("You didn't capitalize the first letter of your name!")
				return false
			end
			current = current .. char
		elseif (char >= 'a' and char <= 'z') or (char >= 'A' and char <= 'Z') or (char == "'") then
			current = current .. char
		else -- unrecognized character (numbers, special character, symbols)
			valid = false
			setFeedbackText("There are invalid characters in your name!")
			return false
		end
		lastChar = char
	end
	
	if valid and foundSpace and #fullName < 26 and #current >= 2 then
		vaildated = true
	else
		setFeedbackText("Your name is an invalid length! (Min. 4, Max 25)")
		return false
	end

	-- DOB Validation
	if not tonumber(dobDay) or not tonumber(dobMonth) or not tonumber(dobYear) or (string.len(dobDay) > 2) or (string.len(dobMonth) > 2)  or (string.len(dobYear) < 4) or (string.len(dobYear) > 4) then
		setFeedbackText("Please input a valid date of birth.")
		return false
	else
		if (tonumber(dobDay) < 0) or (tonumber(dobDay) > 31) or (tonumber(dobMonth) < 0) or (tonumber(dobMonth) > 12) or (tonumber(dobYear) < 1906) or (tonumber(dobYear) > 2002) then 
			setFeedbackText("Please input a valid date of birth.")
			return false
		else
			if (tonumber(dobMonth) == 4) or (tonumber(dobMonth) == 6) or (tonumber(dobMonth) == 9) or (tonumber(dobMonth) == 11) then
				if (tonumber(dobDay) > 30) then 
					setFeedbackText("Please input a valid date of birth.")
					return false
				end
			elseif (tonumber(dobMonth) == 2) then
				if (tonumber(dobYear) % 400 == 0) or (tonumber(dobYear) % 100 ~= 0) and (tonumber(dobYear) % 4 == 0) then
					if (tonumber(dobDay) > 29) then
						setFeedbackText("Please input a valid date of birth.")
						return false
					end
				elseif (tonumber(dobDay) > 28) then
					setFeedbackText("Please input a valid date of birth.")
					return false
				end
			end
			validated = true
		end
	end

	-- Height Validation
	if not tonumber(height) or (tonumber(height) < 140) or (tonumber(height) > 205) then
		setFeedbackText("Height must be between 140cm and 205cm!")
		return false
	end

	-- Weight Validation
	if not tonumber(weight) or (tonumber(weight) < 40) or (tonumber(weight) > 205) then
		setFeedbackText("Weight must be between 40kg and 205kg!")
		return false
	end

	-- Origin validation
	if (string.len(origin) < 3) or (string.len(origin) > 30) or (tonumber(origin)) then
		emGUI:dxSetVisible(sidePanelFeedbackLabel, true)
		return false
	end

	-- Parse the language from a grid value into a text value.
	local gridSelection = emGUI:dxGridListGetSelectedItem(charLangGrid)
	if (gridSelection ~= -1) then
		language = emGUI:dxGridListGetItemText(charLangGrid, gridSelection, 1)
	else
		setFeedbackText("Select a language!", 255, 0, 0)
		return false
	end

	-- Final check to see if we're still validated, if we are then return true.
	if validated then
		emGUI:dxSetEnabled(continueButton, false)
		setFeedbackText("Validating..", 0, 255, 0)
		return true
	end
end

function character_clientisNameAvailable()
	triggerServerEvent("character:isNameAvailableCheck", getRootElement(), firstName .. "_" .. lastName)
end

function character_clientUpdateNameValidation(status)
	validationComplete = status
	if (status) then
		setFeedbackText("Looks good!", 0, 255, 0)
	else
		setFeedbackText("That name is already taken!", 255, 0, 0)
		emGUI:dxSetEnabled(continueButton, true)
	end
end
addEvent("character:character_clientUpdateNameValidation", true)
addEventHandler("character:character_clientUpdateNameValidation", getRootElement(), character_clientUpdateNameValidation)

----------------------------------------- [Skin Selection GUI] -----------------------------------------


skinsLabel = {}

addEvent("showSkinSelectorGUI", true)
addEventHandler("showSkinSelectorGUI", resourceRoot,
function()
	skinSelectorGUI = emGUI:dxCreateWindow(0.16, 0.52, 0.30, 0.24, "", true, true, _, true, _, _, _, _, _, _, _)

	skinsLabel[1] = emGUI:dxCreateLabel(0.08, 0.08, 0.09, 0.07, "Gender", true, skinSelectorGUI)
	skinsLabel[2] = emGUI:dxCreateLabel(0.26, 0.08, 0.10, 0.07, "Ethnicity", true, skinSelectorGUI)

	maleGenderButton = emGUI:dxCreateButton(0.05, 0.18, 0.15, 0.15, "Male", true, skinSelectorGUI)
	addEventHandler("onClientDgsDxMouseClick", maleGenderButton, maleGenderButtonClick)
	femaleGenderButton = emGUI:dxCreateButton(0.05, 0.35, 0.15, 0.15, "Female", true, skinSelectorGUI)
	addEventHandler("onClientDgsDxMouseClick", femaleGenderButton, femaleGenderButtonClick)

	-- Disable male gender selection button as it's already selected by default.
	emGUI:dxSetEnabled(maleGenderButton, false)
	emGUI:dxSetEnabled(femaleGenderButton, true)

	ethnicityWhiteCheck = emGUI:dxCreateRadioButton(0.26, 0.17, 0.10, 0.07, "Caucasian", true, skinSelectorGUI)
	ethnicityAsianCheck = emGUI:dxCreateRadioButton(0.26, 0.25, 0.10, 0.07, "Asian", true, skinSelectorGUI)
	ethnicityBlackCheck = emGUI:dxCreateRadioButton(0.26, 0.33, 0.10, 0.07, "Black", true, skinSelectorGUI)
	ethnicityHispanicCheck = emGUI:dxCreateRadioButton(0.26, 0.41, 0.12, 0.07, "Hispanic", true, skinSelectorGUI)
	emGUI:dxRadioButtonSetSelected(ethnicityWhiteCheck, true)
	addEventHandler("onDgsRadioButtonChange", ethnicityWhiteCheck, ethnicityWhiteCheckEvent)
	addEventHandler("onDgsRadioButtonChange", ethnicityAsianCheck, ethnicityAsianCheckEvent)
	addEventHandler("onDgsRadioButtonChange", ethnicityBlackCheck, ethnicityBlackCheckEvent)
	addEventHandler("onDgsRadioButtonChange", ethnicityHispanicCheck, ethnicityHispanicCheckEvent)

	prevSkinButton = emGUI:dxCreateButton(0.47, 0.16, 0.24, 0.24, "Previous Skin", true, skinSelectorGUI)
	addEventHandler("onClientDgsDxMouseClick", prevSkinButton, prevSkinButtonClick)
	nextSkinButton = emGUI:dxCreateButton(0.72, 0.16, 0.24, 0.24, "Next Skin", true, skinSelectorGUI)
	addEventHandler("onClientDgsDxMouseClick", nextSkinButton, nextSkinButtonClick)

	skinBackButton = emGUI:dxCreateButton(0.13, 0.64, 0.35, 0.26, "Back", true, skinSelectorGUI)
	addEventHandler("onClientDgsDxMouseClick", skinBackButton, skinBackClicked)

	skinContinueButton = emGUI:dxCreateButton(0.53, 0.64, 0.35, 0.26, "Continue", true, skinSelectorGUI)
	addEventHandler("onClientDgsDxMouseClick", skinContinueButton, skinContinueClicked)
	
	emGUI:dxSetEnabled(skinBackButton, false)
	emGUI:dxSetEnabled(skinContinueButton, false)
	setTimer(function()
		emGUI:dxSetEnabled(skinBackButton, true)
		emGUI:dxSetEnabled(skinContinueButton, true)
	end, 2050, 1)
end)

-----------------------------------------------------------------------------------------------
skinTable = {
	["whiteMale"] = {1, 2, 23, 26, 27, 29, 30, 32, 33, 34, 35, 36, 37, 43, 45, 46, 49, 50, 52, 58, 59, 60, 61, 62, 68, 70, 72, 73, 78, 81, 82, 94, 95, 96, 97, 98, 99, 100, 101, 111, 112, 113, 124, 125, 126, 127, 128, 132, 133, 135, 137, 146, 147, 153, 154, 155, 158, 159, 160, 161, 164, 165, 167, 170, 171, 177, 179, 181, 186, 187, 188, 189, 202, 204, 206, 210, 212, 213, 217, 223, 230, 234, 235, 236, 239, 240, 241, 242, 247, 248, 249, 250, 252, 254, 255, 258, 259, 261, 268, 272, 291, 295, 299, 303, 305, 308},
	["blackMale"] = {7, 14, 15, 16, 17, 18, 19, 20, 21, 22, 24, 25, 28, 43, 51, 66, 67, 79, 80, 82, 83, 84, 102, 103, 104, 105, 106, 107, 134, 136, 142, 143, 144, 156, 163, 166, 168, 180, 182, 183, 185, 220, 221, 222, 249, 262, 269, 270, 271, 293, 296, 297, 302, 310},
	["asianMale"] = {23, 43, 45, 46, 49, 57, 59, 60, 95, 98, 117, 118, 120, 121, 122, 123, 124, 126, 170, 171, 186, 187, 189, 203, 210, 227, 228, 229, 235, 294},
	["hispanicMale"] = {23, 30, 33, 36, 44, 46, 47, 48, 50, 51, 60, 81, 98, 101, 108, 109, 110, 111, 112, 113, 114, 115, 116, 126, 127, 128, 170, 173, 174, 175, 176, 177, 184, 223, 242, 268, 292, 303, 307, 308},

	["whiteFemale"] = {31, 38, 39, 41, 53, 54, 56, 75, 77, 85, 88, 89, 90, 91, 93, 129, 130, 131, 150, 151, 157, 172, 191, 192, 193, 194, 196, 197, 199, 201, 211, 216, 226, 233, 263, 298},
	["blackFemale"] = {9, 10, 11, 12, 13, 40, 41, 54, 69, 190, 195, 214, 215, 218, 219, 238, 243, 245, 263, 298, 304},
	["asianFemale"] = {40, 41, 53, 54, 55, 56, 77, 90, 91, 141, 150, 169, 191, 193, 194, 224, 225, 226, 263},
	["hispanicFemale"] = {39, 40, 41, 53, 54, 55, 77, 85, 90, 91, 93, 129, 130, 150, 191, 192, 193, 211, 216, 263, 298},
}
-- Default values.
currentSkinTable = skinTable["whiteMale"]
currentTablePos = 1
gender = "Male"
ethnicity = "Caucasian"

-------------- [Radio Box] --------------
function ethnicityWhiteCheckEvent(state)
	ethnicity = "Caucasian"
	if (gender == "Male") then
		currentSkinTable = skinTable["whiteMale"]
	elseif (gender == "Female") then
		currentSkinTable = skinTable["whiteFemale"]
	end
	currentTablePos = 1

	setElementModel(localPlayer, currentSkinTable[currentTablePos])
end
function ethnicityAsianCheckEvent(state)
	ethnicity = "Asian"
	if (gender == "Male") then
		currentSkinTable = skinTable["asianMale"]
	elseif (gender == "Female") then
		currentSkinTable = skinTable["asianFemale"]
	end
	currentTablePos = 1

	setElementModel(localPlayer, currentSkinTable[currentTablePos])
end
function ethnicityBlackCheckEvent(state)
	ethnicity = "Black"
	if (gender == "Male") then
		currentSkinTable = skinTable["blackMale"]
	elseif (gender == "Female") then
		currentSkinTable = skinTable["blackFemale"]
	end
	currentTablePos = 1

	setElementModel(localPlayer, currentSkinTable[currentTablePos])
end
function ethnicityHispanicCheckEvent(state)
	ethnicity = "Hispanic"
	if (gender == "Male") then
		currentSkinTable = skinTable["hispanicMale"]
	elseif (gender == "Female") then
		currentSkinTable = skinTable["hispanicFemale"]
	end
	currentTablePos = 1

	setElementModel(localPlayer, currentSkinTable[currentTablePos])
end

-------------------- [Buttons] --------------------

function maleGenderButtonClick(button, state)
	if (button == "left") and (state == "down") then
		emGUI:dxSetEnabled(maleGenderButton, false)
		emGUI:dxSetEnabled(femaleGenderButton, true)
		if (ethnicity == "Caucasian") then
			currentSkinTable = skinTable["whiteMale"]
			currentTablePos = 1
		elseif (ethnicity == "Black") then
			currentSkinTable = skinTable["blackMale"]
			currentTablePos = 1
		elseif (ethnicity == "Hispanic") then
			currentSkinTable = skinTable["hispanicMale"]
			currentTablePos = 1
		elseif (ethnicity == "Asian") then
			currentSkinTable = skinTable["asianMale"]
			currentTablePos = 1
		else
			outputDebugString("[character-system] @maleGenderButtonClick: No value for ethnicity detected!")
		end
		setElementModel(localPlayer, currentSkinTable[currentTablePos])
		setPedWalkingStyle(localPlayer, 128)
		gender = "Male"
	end
end

function femaleGenderButtonClick(button, state)
	if (button == "left") and (state == "down") then
		emGUI:dxSetEnabled(femaleGenderButton, false)
		emGUI:dxSetEnabled(maleGenderButton, true)
		if (ethnicity == "Caucasian") then
			currentSkinTable = skinTable["whiteFemale"]
			currentTablePos = 1
		elseif (ethnicity == "Black") then
			currentSkinTable = skinTable["blackFemale"]
			currentTablePos = 1
		elseif (ethnicity == "Hispanic") then
			currentSkinTable = skinTable["hispanicFemale"]
			currentTablePos = 1
		elseif (ethnicity == "Asian") then
			currentSkinTable = skinTable["asianFemale"]
			currentTablePos = 1
		else
			outputDebugString("[character-system] @femaleGenderButtonClick: No value for ethnicity detected!")
		end
		setElementModel(localPlayer, currentSkinTable[currentTablePos])
		setPedWalkingStyle(localPlayer, 129)
		gender = "Female"
	end
end

function prevSkinButtonClick(button, state)
	if (button == "left") and (state == "down") then
		local tableLength = 0
		for _, skin in ipairs(currentSkinTable) do
			tableLength = tableLength + 1
		end
		currentTablePos = currentTablePos - 1

		if (currentTablePos > tableLength) then
			currentTablePos = 1
		end
		if (currentTablePos < 1) then
			currentTablePos = tableLength
		end

		setElementModel(localPlayer, currentSkinTable[currentTablePos])
	end
end

function nextSkinButtonClick(button, state)
	if (button == "left") and (state == "down") then
		local tableLength = 0
		for _, skin in ipairs(currentSkinTable) do
			tableLength = tableLength + 1
		end
		currentTablePos = currentTablePos + 1

		if (currentTablePos > tableLength) then
			currentTablePos = 1
		end
		if (currentTablePos < 1) then
			currentTablePos = tableLength
		end

		setElementModel(localPlayer, currentSkinTable[currentTablePos])
	end
end

function skinBackClicked(button, state)
	if (button == "left") and (state == "down") then
		emGUI:dxCloseWindow(skinSelectorGUI)
		exports.global:smoothMoveCamera(1725.96875, -2230.4638671875, 40.721321105957, 1726.4921875, -2232.4658203125, 39.380271911621, 1727.353515625, -2230.4580078125, 40.599353790283, 1726.48828125, -2232.0204296875, 39.680271911621, 2000)
		triggerEvent("showCharCreGUI", getRootElement())
		emGUI:dxSetText(firstnameInput, firstName)
		emGUI:dxSetText(lastnameInput, lastName)
		emGUI:dxSetText(dobDD, dobDay)
		emGUI:dxSetText(dobMM, dobMonth)
		emGUI:dxSetText(dobYYYY, dobYear)
		emGUI:dxSetText(charHeightInput, height)
		emGUI:dxSetText(charWeightInput, weight)
		emGUI:dxSetText(charOriginInput, origin)
		emGUI:dxSetEnabled(continueButton, false)

		setTimer(function()
			emGUI:dxSetEnabled(continueButton, true)
		end, 2050, 1)
	end
end

function skinContinueClicked(button, state)
	if (button == "left") and (state == "down") then
		local playerSkin = getElementModel(localPlayer)
		emGUI:dxCloseWindow(skinSelectorGUI)
		triggerEvent("showSkillAssignGUI", getRootElement())
		totalSkillPoints, strength, marksmanship, mechanics, knowledge, stamina = 8, 0, 0, 0, 0, 0
	end
end

------------------------------------ [Skill Point Allocation GUI] ------------------------------------


skillMenuLabels = {}

addEvent("showSkillAssignGUI", true)
addEventHandler("showSkillAssignGUI", resourceRoot,
function()
	skillAssignmentWindow = emGUI:dxCreateWindow(0.16, 0.14, 0.27, 0.62, "", true, true, _, true)

	skillMenuLabels[1] = emGUI:dxCreateLabel(0.04, 0, 0.28, 0.04, "Skill Points", true, skillAssignmentWindow)
	emGUI:dxSetFont(skillMenuLabels[1], buttonFont_16)
	skillMenuLabels[2] = emGUI:dxCreateLabel(0.6, 0, 0.28, 0.04, "(Available: 8)", true, skillAssignmentWindow)
	emGUI:dxSetFont(skillMenuLabels[2], buttonFont_16)
	skillMenuLabels[3] = emGUI:dxCreateLabel(0.04, 0.05, 0.94, 0.12, "Skill points make up your character's unique characteristics. You can \nallocate the available points to your character according to their\nbackground and story.\n\nEach characteristic will effect your character in a different way,\nso be sure to place them on skills that are relative to them!", true, skillAssignmentWindow)
	
	-- Strength
	skillMenuLabels[4] = emGUI:dxCreateLabel(0.04, 0.23, 0.20, 0.04, "Strength", true, skillAssignmentWindow)
	emGUI:dxSetFont(skillMenuLabels[4], buttonFont_14)
	strengthRemoveButton = emGUI:dxCreateButton(0.04, 0.27, 0.09, 0.06, "-", true, skillAssignmentWindow)
	strengthBar = emGUI:dxCreateProgressBar(0.15, 0.28, 0.69, 0.04, true, skillAssignmentWindow)
	strengthAddButton = emGUI:dxCreateButton(0.86, 0.27, 0.09, 0.06, "+", true, skillAssignmentWindow)
	emGUI:dxSetEnabled(strengthRemoveButton, false)
	addEventHandler("onClientDgsDxMouseClick", strengthRemoveButton, strengthRemoveButtonClick)
	addEventHandler("onClientDgsDxMouseClick", strengthAddButton, strengthAddButtonClick)
	
	-- Marksmanship
	skillMenuLabels[5] = emGUI:dxCreateLabel(0.04, 0.35, 0.28, 0.04, "Marksmanship", true, skillAssignmentWindow)
	emGUI:dxSetFont(skillMenuLabels[5], buttonFont_14)
	marksmanshipRemoveButton = emGUI:dxCreateButton(0.04, 0.39, 0.09, 0.06, "-", true, skillAssignmentWindow)
	marksmanshipBar = emGUI:dxCreateProgressBar(0.15, 0.40, 0.69, 0.04, true, skillAssignmentWindow)
	marksmanshipAddButton = emGUI:dxCreateButton(0.86, 0.39, 0.09, 0.06, "+", true, skillAssignmentWindow)
	emGUI:dxSetEnabled(marksmanshipRemoveButton, false)
	addEventHandler("onClientDgsDxMouseClick", marksmanshipRemoveButton, marksmanshipRemoveButtonClick)
	addEventHandler("onClientDgsDxMouseClick", marksmanshipAddButton, marksmanshipAddButtonClick)

	-- Mechanics
	skillMenuLabels[6] = emGUI:dxCreateLabel(0.04, 0.47, 0.28, 0.04, "Mechanics", true, skillAssignmentWindow)
	emGUI:dxSetFont(skillMenuLabels[6], buttonFont_14)
	mechanicsRemoveButton = emGUI:dxCreateButton(0.04, 0.51, 0.09, 0.06, "-", true, skillAssignmentWindow)
	mechanicsBar = emGUI:dxCreateProgressBar(0.15, 0.52, 0.69, 0.04, true, skillAssignmentWindow)
	mechanicsAddButton = emGUI:dxCreateButton(0.86, 0.51, 0.09, 0.06, "+", true, skillAssignmentWindow)
	emGUI:dxSetEnabled(mechanicsRemoveButton, false)
	addEventHandler("onClientDgsDxMouseClick", mechanicsRemoveButton, mechanicsRemoveButtonClick)
	addEventHandler("onClientDgsDxMouseClick", mechanicsAddButton, mechanicsAddButtonClick)

	-- Knowledge
	skillMenuLabels[7] = emGUI:dxCreateLabel(0.04, 0.59, 0.28, 0.04, "Knowledge", true, skillAssignmentWindow)
	emGUI:dxSetFont(skillMenuLabels[7], buttonFont_14)
	knowledgeRemoveButton = emGUI:dxCreateButton(0.04, 0.63, 0.09, 0.06, "-", true, skillAssignmentWindow)
	knowledgeBar = emGUI:dxCreateProgressBar(0.15, 0.64, 0.69, 0.04, true, skillAssignmentWindow)
	knowledgeAddButton = emGUI:dxCreateButton(0.86, 0.63, 0.09, 0.06, "+", true, skillAssignmentWindow)
	emGUI:dxSetEnabled(knowledgeRemoveButton, false)
	addEventHandler("onClientDgsDxMouseClick", knowledgeRemoveButton, knowledgeRemoveButtonClick)
	addEventHandler("onClientDgsDxMouseClick", knowledgeAddButton, knowledgeAddButtonClick)

	-- Stamina
	skillMenuLabels[8] = emGUI:dxCreateLabel(0.04, 0.71, 0.28, 0.04, "Stamina", true, skillAssignmentWindow)
	emGUI:dxSetFont(skillMenuLabels[8], buttonFont_14)
	staminaRemoveButton = emGUI:dxCreateButton(0.04, 0.75, 0.09, 0.06, "-", true, skillAssignmentWindow)
	staminaBar = emGUI:dxCreateProgressBar(0.15, 0.76, 0.69, 0.04, true, skillAssignmentWindow)
	staminaAddButton = emGUI:dxCreateButton(0.86, 0.75, 0.09, 0.06, "+", true, skillAssignmentWindow)
	emGUI:dxSetEnabled(staminaRemoveButton, false)
	addEventHandler("onClientDgsDxMouseClick", staminaRemoveButton, staminaRemoveButtonClick)
	addEventHandler("onClientDgsDxMouseClick", staminaAddButton, staminaAddButtonClick)


	skillContinueButton = emGUI:dxCreateButton(0.57, 0.87, 0.34, 0.09, "CONTINUE", true, skillAssignmentWindow)
	addEventHandler("onClientDgsDxMouseClick", skillContinueButton, skillContinueButtonClick)
	skillPreviousButton = emGUI:dxCreateButton(0.08, 0.87, 0.34, 0.09, "PREVIOUS", true, skillAssignmentWindow)
	addEventHandler("onClientDgsDxMouseClick", skillPreviousButton, skillPreviousButtonClick)
end)


----------------------- [Buttons] -----------------------

if not (totalSkillPoints) then
	totalSkillPoints = 8
end

strength, marksmanship, mechanics, knowledge, stamina = 0, 0, 0, 0, 0

function totalSkillPointUpdate()
	if (totalSkillPoints == 0) then
		emGUI:dxSetEnabled(strengthAddButton, false)
		emGUI:dxSetEnabled(marksmanshipAddButton, false)
		emGUI:dxSetEnabled(mechanicsAddButton, false)
		emGUI:dxSetEnabled(knowledgeAddButton, false)
		emGUI:dxSetEnabled(staminaAddButton, false)
	else
		emGUI:dxSetEnabled(strengthAddButton, true)
		emGUI:dxSetEnabled(marksmanshipAddButton, true)
		emGUI:dxSetEnabled(mechanicsAddButton, true)
		emGUI:dxSetEnabled(knowledgeAddButton, true)
		emGUI:dxSetEnabled(staminaAddButton, true)
	end
	-- Update the label.
	emGUI:dxSetText(skillMenuLabels[2], "(Available: " .. totalSkillPoints .. ")")
	-- Reset the color.
	emGUI:dxLabelSetColor(skillMenuLabels[2], 255, 255, 255)
end

-- Strength
function strengthRemoveButtonClick(button, state)
	if (button == "left") and (state == "down") then
		strength = strength - 1
		totalSkillPoints = totalSkillPoints + 1
		emGUI:dxProgressBarSetProgress(strengthBar, strength * 10)
		totalSkillPointUpdate()
		if (strength == 0) then
			emGUI:dxSetEnabled(strengthRemoveButton, false)
		else
			emGUI:dxSetEnabled(strengthRemoveButton, true)
		end
	end
end

function strengthAddButtonClick(button, state)
	if (button == "left") and (state == "down") then
		strength = strength + 1
		if (strength >= 1) then
			emGUI:dxSetEnabled(strengthRemoveButton, true)
		end

		totalSkillPoints = totalSkillPoints - 1
		emGUI:dxProgressBarSetProgress(strengthBar, strength * 10)
		totalSkillPointUpdate()
	end
end

-- Marksmanship
function marksmanshipRemoveButtonClick(button, state)
	if (button == "left") and (state == "down") then
		marksmanship = marksmanship - 1
		totalSkillPoints = totalSkillPoints + 1
		emGUI:dxProgressBarSetProgress(marksmanshipBar, marksmanship * 10)
		totalSkillPointUpdate()
		if (marksmanship == 0) then
			emGUI:dxSetEnabled(marksmanshipRemoveButton, false)
		else
			emGUI:dxSetEnabled(marksmanshipRemoveButton, true)
		end
	end
end

function marksmanshipAddButtonClick(button, state)
	if (button == "left") and (state == "down") then
		marksmanship = marksmanship + 1
		if (marksmanship >= 1) then
			emGUI:dxSetEnabled(marksmanshipRemoveButton, true)
		end

		totalSkillPoints = totalSkillPoints - 1
		emGUI:dxProgressBarSetProgress(marksmanshipBar, marksmanship * 10)
		totalSkillPointUpdate()
	end
end

-- Mechanics
function mechanicsRemoveButtonClick(button, state)
	if (button == "left") and (state == "down") then
		mechanics = mechanics - 1
		totalSkillPoints = totalSkillPoints + 1
		emGUI:dxProgressBarSetProgress(mechanicsBar, mechanics * 10)
		totalSkillPointUpdate()
		if (mechanics == 0) then
			emGUI:dxSetEnabled(mechanicsRemoveButton, false)
		else
			emGUI:dxSetEnabled(mechanicsRemoveButton, true)
		end
	end
end

function mechanicsAddButtonClick(button, state)
	if (button == "left") and (state == "down") then
		mechanics = mechanics + 1
		if (mechanics >= 1) then
			emGUI:dxSetEnabled(mechanicsRemoveButton, true)
		end

		totalSkillPoints = totalSkillPoints - 1
		emGUI:dxProgressBarSetProgress(mechanicsBar, mechanics * 10)
		totalSkillPointUpdate()
	end
end

-- Knowledge
function knowledgeRemoveButtonClick(button, state)
	if (button == "left") and (state == "down") then
		knowledge = knowledge - 1
		totalSkillPoints = totalSkillPoints + 1
		emGUI:dxProgressBarSetProgress(knowledgeBar, knowledge * 10)
		totalSkillPointUpdate()
		if (knowledge == 0) then
			emGUI:dxSetEnabled(knowledgeRemoveButton, false)
		else
			emGUI:dxSetEnabled(knowledgeRemoveButton, true)
		end
	end
end

function knowledgeAddButtonClick(button, state)
	if (button == "left") and (state == "down") then
		knowledge = knowledge + 1
		if (knowledge >= 1) then
			emGUI:dxSetEnabled(knowledgeRemoveButton, true)
		end

		totalSkillPoints = totalSkillPoints - 1
		emGUI:dxProgressBarSetProgress(knowledgeBar, knowledge * 10)
		totalSkillPointUpdate()
	end
end

-- Stamina
function staminaRemoveButtonClick(button, state)
	if (button == "left") and (state == "down") then
		stamina = stamina - 1
		totalSkillPoints = totalSkillPoints + 1
		emGUI:dxProgressBarSetProgress(staminaBar, stamina * 10)
		totalSkillPointUpdate()
		if (stamina == 0) then
			emGUI:dxSetEnabled(staminaRemoveButton, false)
		else
			emGUI:dxSetEnabled(staminaRemoveButton, true)
		end
	end
end

function staminaAddButtonClick(button, state)
	if (button == "left") and (state == "down") then
		stamina = stamina + 1
		if (stamina >= 1) then
			emGUI:dxSetEnabled(staminaRemoveButton, true)
		end

		totalSkillPoints = totalSkillPoints - 1
		emGUI:dxProgressBarSetProgress(staminaBar, stamina * 10)
		totalSkillPointUpdate()
	end
end


function skillContinueButtonClick(button, state)
	if (button == "left") and (state == "down") then
		-- Check to see the player has used up all of their skill points.
		if totalSkillPoints ~= 0 then
			emGUI:dxLabelSetColor(skillMenuLabels[2], 255, 0, 0)
			return false
		end

		emGUI:dxCloseWindow(skillAssignmentWindow)
		attemptCharacterCreation()
	end
end

function skillPreviousButtonClick(button, state)
	if (button == "left") and (state == "down") then
		emGUI:dxCloseWindow(skillAssignmentWindow)
		triggerEvent("showSkinSelectorGUI", getRootElement())

		-- Set data of previous GUI.
		if (gender == "Female") then
			emGUI:dxSetEnabled(femaleGenderButton, false)
			emGUI:dxSetEnabled(maleGenderButton, true)
			setPedWalkingStyle(localPlayer, 129)
		else
			emGUI:dxSetEnabled(maleGenderButton, false)
			emGUI:dxSetEnabled(femaleGenderButton, true)
			setPedWalkingStyle(localPlayer, 128)
		end

		if (ethnicity == "Black") then
			emGUI:dxRadioButtonSetSelected(ethnicityBlackCheck, true)
		elseif(ethnicity == "Asian") then
			emGUI:dxRadioButtonSetSelected(ethnicityAsianCheck, true)
		elseif(ethnicity == "Hispanic") then
			emGUI:dxRadioButtonSetSelected(ethnicityHispanicCheck, true)
		else
			emGUI:dxRadioButtonSetSelected(ethnicityWhiteCheck, true)
		end
	end
end


function attemptCharacterCreation()
	local sW, sH = guiGetScreenSize()
	setCursorPosition(sW, sH) -- Just move the cursor out of the way.

	exports.global:smoothMoveCamera(1727.353515625, -2230.4580078125, 40.599353790283, 1726.48828125, -2232.0204296875, 39.680271911621, 1720.2216796875, -2236.107421875, 39.751026153564,  1707.8037109375, -2235.9931640625, 40.125679016113, 6000)
	
	selectedSkin = getElementModel(localPlayer)
	setTimer(function()
		triggerServerEvent("character:creationSpawnPlayer", localPlayer, localPlayer, selectedSkin)

		toggleAllControls(true)
		setPedControlState(localPlayer, "walk", true)
		setPedControlState(localPlayer, "forwards", true)
	end, 6200, 1)

	setTimer(function()
		fadeCamera(false, 2)
	end, 11500, 1)

	setTimer(function()
		setPedControlState(localPlayer, "walk", false)
		setPedControlState(localPlayer, "forwards", false)
		triggerEvent("showSpawnSelectionGUI", getRootElement())
		setCursorPosition(sW/2, sH/2)
		showCursor(false)
	end, 13500, 1)
end


------------------------------------ [Spawn Area Selection GUI] ------------------------------------

addEvent("showSpawnSelectionGUI", true)
addEventHandler("showSpawnSelectionGUI", resourceRoot,
function()
	spawnSelectionGUI = emGUI:dxCreateWindow(0.31, 0.35, 0.38, 0.30, "", true, true, false, true)

	travelToLVLabel = emGUI:dxCreateLabel(0.05, 0.12, 0.90, 0.24, "How do you travel to\nLas Venturas?", true, spawnSelectionGUI)
	emGUI:dxSetFont(travelToLVLabel, buttonFont_20)
	emGUI:dxLabelSetHorizontalAlign(travelToLVLabel, "center", false)
	
	spawnSelectorComboBox = emGUI:dxCreateComboBox(0.09, 0.38, 0.82, 0.11, true, spawnSelectionGUI)
	emGUI:dxComboBoxAddItem(spawnSelectorComboBox, "Walk to the train station and take the train.")
	emGUI:dxComboBoxAddItem(spawnSelectorComboBox, "Wait at the bus stop and take the bus.")
	emGUI:dxComboBoxAddItem(spawnSelectorComboBox, "Wait for the next flight to Las Venturas Airport.")
	emGUI:dxComboBoxAddItem(spawnSelectorComboBox, "Head to the docks and take the next boat.")
	addEventHandler("onDgsComboBoxSelect", spawnSelectorComboBox, spawnSelectorComboBoxUpdate)
	
	emGUI:dxComboBoxSetSelectedItem(spawnSelectorComboBox, 1)

	takeMeButton = emGUI:dxCreateButton(0.10, 0.62, 0.80, 0.27, "Take me to the city!", true, spawnSelectionGUI)
	addEventHandler("onClientDgsDxMouseClick", takeMeButton, takeMeButtonClick)
end)

function spawnSelectorComboBoxUpdate(current, previous)
	selection = current
	--[[ Selection values
	1: Train Station
	2: Bus Stop
	3: LV Airport
	4: LV Docks 		]]
end

function takeMeButtonClick(button, state)
	if (button == "left") and (state == "down") then
		local parsedDOB = dobDay .. "/" .. dobMonth .. "/" .. dobYear
		local parsedSkills = strength .. "," .. marksmanship .. "," .. mechanics .. "," .. knowledge .. "," .. stamina
		local characterData = {fullName = firstName .. "_" .. lastName, parsedDOB = parsedDOB, height = height, weight = weight, origin = origin, language = language, ethnicity = ethnicity, gender = gender, selectedSkin = selectedSkin, skills = parsedSkills, spawnArea = selection}
		triggerServerEvent("character:creationAttempt", localPlayer, localPlayer, characterData)
		emGUI:dxCloseWindow(spawnSelectionGUI)
		-- Function to pass shit to server and execute character spawn.
	end
end