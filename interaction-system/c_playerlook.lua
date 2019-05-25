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
| |\ \\ \_/ / |____| |___| |   | |____| | | || |            Skully
\_| \_|\___/\_____/\____/\_|   \_____/\_| |_/\_/

Copyright of the Emerald Gaming Development Team, do not distribute - All rights reserved. ]]

-- Customization variables.
local MAX_DESCRIPTION_WIDTH = 0.3 -- Relative value of how wide description text can be.

-- Functional variables.
emGUI = exports.emGUI
local sW, sH = guiGetScreenSize()
local labelFont_10 = emGUI:dxCreateNewFont(":emGUI/fonts/labelFont.ttf", 10)
local buttonFont_10 = emGUI:dxCreateNewFont(":emGUI/fonts/buttonFont.ttf", 10)
local buttonFont_20 = emGUI:dxCreateNewFont(":emGUI/fonts/buttonFont.ttf", 20)

function showLookCharacterWindow(targetPlayer)
	if not isElement(targetPlayer) then return end

	if emGUI:dxIsWindowVisible(characterLookWindow) then emGUI:dxCloseWindow(characterLookWindow) end
	if emGUI:dxIsWindowVisible(charDescWindow) then emGUI:dxCloseWindow(charDescWindow) end

	characterLookWindow = emGUI:dxCreateWindow(0.26, 0.13, 0.19, 0.35, " ", true, true, true, true, _, 8)

	charNameLabel = emGUI:dxCreateLabel(0.13, 0.06, 0.74, 0.12, getPlayerName(targetPlayer):gsub("_", " "), true, characterLookWindow)
	emGUI:dxSetFont(charNameLabel, buttonFont_20)
	emGUI:dxLabelSetHorizontalAlign(charNameLabel, "center")
	emGUI:dxLabelSetVerticalAlign(charNameLabel, "center")

	local charAge = getElementData(targetPlayer, "character:age")
	local charHeight = getElementData(targetPlayer, "character:height")
	local charWeight = getElementData(targetPlayer, "character:weight")
	local charGender = getElementData(targetPlayer, "character:gender")
	local charEthnicity = getElementData(targetPlayer, "character:ethnicity")
	local descriptionTable = getElementData(targetPlayer, "character:description")
	local currentMood = getElementData(targetPlayer, "character:mood"); currentMood = g_selectableMoods[currentMood]

	-- Parse gender.
	if (charGender == 1) then charGender = "male" else charGender = "female" end
	
	-- Parse ethnicity.
	if (charEthnicity == 1) then charEthnicity = "white"
		elseif (charEthnicity == 2) then charEthnicity = "black"
		elseif (charEthnicity == 3) then charEthnicity = "hispanic"
	else charEthnicity = "asian"
	end

	charAgeRaceLabel = emGUI:dxCreateLabel(0.26, 0.18, 0.48, 0.04, "A " .. charAge .. " year old " .. charEthnicity .. " " .. charGender .. ".", true, characterLookWindow)
	emGUI:dxLabelSetHorizontalAlign(charAgeRaceLabel, "center")
	emGUI:dxLabelSetVerticalAlign(charAgeRaceLabel, "center")
	heightWeightLabel = emGUI:dxCreateLabel(0.17, 0.237, 0.66, 0.05, "Appears to be " .. charHeight .. "cm tall and weighs " .. charWeight .. "kg.", true, characterLookWindow)
	emGUI:dxLabelSetHorizontalAlign(heightWeightLabel, "center")
	emGUI:dxLabelSetVerticalAlign(heightWeightLabel, "center")

	charEmotionLabel = emGUI:dxCreateLabel(0.17, 0.30, 0.66, 0.05, "They are currently " .. string.gsub(currentMood, "^.", string.lower) .. ".", true, characterLookWindow)
	emGUI:dxLabelSetHorizontalAlign(charEmotionLabel, "center")
	emGUI:dxLabelSetVerticalAlign(charEmotionLabel, "center")

	local healthState = "healthy."
	local playerHP = getElementHealth(targetPlayer)
	if (playerHP < 30) then healthState = "hurt and in pain."
		elseif (playerHP < 35) then healthState = "slightly in pain."
		elseif (playerHP < 65) then healthState = "slightly hurt."
	end
	charStateLabel = emGUI:dxCreateLabel(0.18, 0.79, 0.66, 0.05, "They appear to be " .. healthState, true, characterLookWindow)
	emGUI:dxLabelSetHorizontalAlign(charStateLabel, "center")

	-- Parse character skin image.
	local charSkinID = getElementModel(targetPlayer)
	local skinPath = ":assets/images/skin_faces/no_face.png"
	if fileExists(":assets/images/skin_faces/" .. charSkinID .. ".png") then
		skinPath = string.gsub(skinPath, "no_face", charSkinID)
	end
	charSkinImage = emGUI:dxCreateImage(0.32, 0.40, 0.36, 0.35, skinPath, true, characterLookWindow)

	viewCharDetailsButton = emGUI:dxCreateButton(0.5, 0.9, 0.5, 0.1, "Show Details", true, characterLookWindow)
	addEventHandler("onClientDgsDxMouseClick", viewCharDetailsButton, function(b, c)
		if (b == "left") and (c == "down") then
			if emGUI:dxIsWindowVisible(charDescWindow) then
				emGUI:dxCloseWindow(charDescWindow)
				emGUI:dxSetText(viewCharDetailsButton, "Show Details")
				return
			end

			showCharDetailsWindow(targetPlayer)
		end
	end)

	closeUIButton = emGUI:dxCreateButton(0, 0.9, 0.5, 0.1, "Close", true, characterLookWindow)
	addEventHandler("onClientDgsDxMouseClick", closeUIButton, function(b, c)
		if (b == "left") and (c == "down") then
			emGUI:dxCloseWindow(characterLookWindow)
			if emGUI:dxIsWindowVisible(charDescWindow) then emGUI:dxCloseWindow(charDescWindow) end
		end
	end)
end
addCommandHandler("previewlook", function() showLookCharacterWindow(localPlayer) end)
addEvent("interaction:showLookCharacterWindow", true) -- Used by interaction-system player right-click.
addEventHandler("interaction:showLookCharacterWindow", root, showLookCharacterWindow)

-- /look [Player/ID] - By Skully (15/02/19) [Player]
function lookPlayerCmd(commandName, targetPlayer)
	if not (getElementData(localPlayer, "loggedin") == 1) then return end
	if not targetPlayer then
		outputChatBox("SYNTAX: /" .. commandName .. " [Player/ID]", 75, 230, 10)
		return
	end

	local targetPlayer, targetPlayerName = exports.global:getPlayerFromPartialNameOrID(targetPlayer, localPlayer, true)
	if targetPlayer then
		local px, py, pz = getElementPosition(localPlayer)
		local tx, ty, tz = getElementPosition(targetPlayer)
		if (getDistanceBetweenPoints3D(px, py, pz, tx, ty, tz) > MAX_INTERACTION_DISTANCE) then
			outputChatBox("You are too far away from " .. getPlayerName(targetPlayer):gsub("_", " ") .. "!", 255, 0, 0)
			return
		end

		showLookCharacterWindow(targetPlayer)
	end
end
addCommandHandler("look", lookPlayerCmd)

function showCharDetailsWindow(targetPlayer)
	if not isElement(targetPlayer) then return end
	if not emGUI:dxIsWindowVisible(characterLookWindow) then return end

	local descriptionTable = getElementData(targetPlayer, "character:description")
	if (type(descriptionTable) ~= "table") then return end

	emGUI:dxSetText(viewCharDetailsButton, "Hide Details")

	local maxTextWidth = 0.1


	for i, desc in pairs(descriptionTable) do
		local width = (dxGetTextWidth(desc, 1, labelFont_10) / sW)
		if (width > maxTextWidth) then maxTextWidth = width end
	end
	if (maxTextWidth > MAX_DESCRIPTION_WIDTH) then maxTextWidth = MAX_DESCRIPTION_WIDTH end

	local charDescLabels = {}
	charDescWindow = emGUI:dxCreateWindow(0.4499, 0.13, maxTextWidth + 0.02, 0.35, " ", true, true, true, true, _, 8)

	charDescLabels[1] = emGUI:dxCreateLabel(0.02, 0.09, 0.35, 0.05, "Hair Color & Style:", true, charDescWindow)
	charDescLabels[2] = emGUI:dxCreateLabel(0.02, 0.21, 0.29, 0.05, "Facial Features:", true, charDescWindow)
	charDescLabels[3] = emGUI:dxCreateLabel(0.02, 0.33, 0.28, 0.05, "Physical Build:", true, charDescWindow)
	charDescLabels[4] = emGUI:dxCreateLabel(0.02, 0.44, 0.19, 0.05, "Clothing:", true, charDescWindow)
	charDescLabels[5] = emGUI:dxCreateLabel(0.02, 0.56, 0.25, 0.05, "Accessories:", true, charDescWindow)
	charDescLabels[6] = emGUI:dxCreateLabel(0.02, 0.68, 0.21, 0.05, "Walk Style:", true, charDescWindow)
	charDescLabels[7] = emGUI:dxCreateLabel(0.02, 0.80, 0.14, 0.05, "Makeup:", true, charDescWindow)
	for i, label in ipairs(charDescLabels) do emGUI:dxSetFont(label, buttonFont_10) end

	hairColorStyleLabel = 	emGUI:dxCreateLabel(0.02, 0.14, 0.92, 0.04, descriptionTable["haircolstyle"], true, charDescWindow)
	facialFeatureLabel = 	emGUI:dxCreateLabel(0.02, 0.25, 0.92, 0.04, descriptionTable["facialfeatures"], true, charDescWindow)
	physicalBuildLabel = 	emGUI:dxCreateLabel(0.02, 0.37, 0.92, 0.04, descriptionTable["physicalbuild"], true, charDescWindow)
	clothingLabel = 		emGUI:dxCreateLabel(0.02, 0.49, 0.92, 0.04, descriptionTable["clothing"], true, charDescWindow)
	accessoriesLabel = 		emGUI:dxCreateLabel(0.02, 0.61, 0.92, 0.04, descriptionTable["accessories"], true, charDescWindow)
	walkstyleLabel = 		emGUI:dxCreateLabel(0.02, 0.73, 0.92, 0.04, descriptionTable["walkstyle"], true, charDescWindow)
	makeupLabel = 			emGUI:dxCreateLabel(0.02, 0.85, 0.92, 0.04, descriptionTable["makeup"], true, charDescWindow)
end

function showEditLookWindow()
	if emGUI:dxIsWindowVisible(editLookWindow) then emGUI:dxCloseWindow(editLookWindow) return end

	local descriptionTable = getElementData(localPlayer, "character:description")

	local editorLabels = {}
	editLookWindow = emGUI:dxCreateWindow(0.64, 0.5, 0.27, 0.39, "Update Look Description", true)

	editorLabels[1] = emGUI:dxCreateLabel(0.04, 0.05, 0.21, 0.04, "Character Weight:", true, editLookWindow)
	editorLabels[2] = emGUI:dxCreateLabel(0.04, 0.13, 0.21, 0.04, "Hair Color & Style:", true, editLookWindow)
	editorLabels[3] = emGUI:dxCreateLabel(0.04, 0.21, 0.21, 0.04, "Facial Features:", true, editLookWindow)
	editorLabels[4] = emGUI:dxCreateLabel(0.04, 0.29, 0.21, 0.04, "Physical Build:", true, editLookWindow)
	editorLabels[5] = emGUI:dxCreateLabel(0.04, 0.37, 0.21, 0.04, "Clothing:", true, editLookWindow)
	editorLabels[6] = emGUI:dxCreateLabel(0.04, 0.45, 0.21, 0.04, "Accessories:", true, editLookWindow)
	editorLabels[7] = emGUI:dxCreateLabel(0.04, 0.53, 0.21, 0.04, "Walk Style:", true, editLookWindow)
	editorLabels[8] = emGUI:dxCreateLabel(0.04, 0.61, 0.21, 0.04, "Makeup:", true, editLookWindow)
	editorLabels[9] = emGUI:dxCreateLabel(0.45, 0.05, 0.21, 0.04, "Current Mood:", true, editLookWindow)
	for i, label in ipairs(editorLabels) do emGUI:dxLabelSetHorizontalAlign(label, "right") end
	emGUI:dxCreateLabel(0.39, 0.05, 0.05, 0.04, "kg", true, editLookWindow)

	local charWeight = getElementData(localPlayer, "character:weight")
	charWeightInput = 		emGUI:dxCreateEdit(0.26, 0.05, 0.12, 0.05, charWeight, true, editLookWindow)
	charHairColInput = 		emGUI:dxCreateEdit(0.26, 0.13, 0.71, 0.05, descriptionTable["haircolstyle"], true, editLookWindow)
	facialFeatureInput =	emGUI:dxCreateEdit(0.26, 0.21, 0.71, 0.05, descriptionTable["facialfeatures"], true, editLookWindow)
	physicalBuildInput = 	emGUI:dxCreateEdit(0.26, 0.29, 0.71, 0.05, descriptionTable["physicalbuild"], true, editLookWindow)
	clothingInput = 		emGUI:dxCreateEdit(0.26, 0.37, 0.71, 0.05, descriptionTable["clothing"], true, editLookWindow)
	accessoriesInput =		emGUI:dxCreateEdit(0.26, 0.45, 0.71, 0.05, descriptionTable["accessories"], true, editLookWindow)
	walkstyleInput = 		emGUI:dxCreateEdit(0.26, 0.53, 0.71, 0.05, descriptionTable["walkstyle"], true, editLookWindow)
	makeupInput = 			emGUI:dxCreateEdit(0.26, 0.61, 0.71, 0.05, descriptionTable["makeup"], true, editLookWindow)
	
	charMoodCombobox = emGUI:dxCreateComboBox(0.67, 0.045, 0.3, 0.06, true, editLookWindow)
	for i, mood in ipairs(g_selectableMoods) do emGUI:dxComboBoxAddItem(charMoodCombobox, mood) end

	local currentMood = getElementData(localPlayer, "character:mood") or 1
	emGUI:dxComboBoxSetSelectedItem(charMoodCombobox, currentMood)

	feedbackLabel = emGUI:dxCreateLabel(0.13, 0.71, 0.75, 0.04, "You can also use /previewlook to see your character description.", true, editLookWindow)
	emGUI:dxLabelSetHorizontalAlign(feedbackLabel, "center")
	
	local previewLookButton = emGUI:dxCreateButton(0.08, 0.8, 0.38, 0.15, "Preview Look", true, editLookWindow)
	addEventHandler("onClientDgsDxMouseClick", previewLookButton, function(b, c)
		if (b == "left") and (c == "down") then showLookCharacterWindow(localPlayer) end
	end)

	saveChangesButton = emGUI:dxCreateButton(0.54, 0.8, 0.38, 0.15, "Save Changes", true, editLookWindow)
	addEventHandler("onClientDgsDxMouseClick", saveChangesButton, saveChangesButtonClick)
end
addCommandHandler("editlook", showEditLookWindow)

function updateFeedbackLabel(text, r, g, b)
	if not (r) then r = 255; g = 255; b = 255; end
	emGUI:dxSetText(feedbackLabel, text)
	emGUI:dxLabelSetColor(feedbackLabel, r, g, b, 255)
end

function saveChangesButtonClick(b, c)
	if (b == "left") and (c == "down") then
		local weightText = emGUI:dxGetText(charWeightInput)
		local hairColStyleText = emGUI:dxGetText(charHairColInput)
		local facialFeatureText = emGUI:dxGetText(facialFeatureInput)
		local physicalBuildText = emGUI:dxGetText(physicalBuildInput)
		local clothingText = emGUI:dxGetText(clothingInput)
		local accessoriesText = emGUI:dxGetText(accessoriesInput)
		local walkstyleText = emGUI:dxGetText(walkstyleInput)
		local makeupText = emGUI:dxGetText(makeupInput)
		local selectedMood = emGUI:dxComboBoxGetSelectedItem(charMoodCombobox)

		if not (weightText) or not tonumber(weightText) then
			updateFeedbackLabel("Input a weight!", 255, 0, 0)
			return
		end
		weightText = tonumber(weightText)

		if (weightText < 40) or (weightText > 400) then
			updateFeedbackLabel("Weight must be between 40kg and 400kg!", 255, 0, 0)
			return
		end

		if ((dxGetTextWidth(hairColStyleText, 1, labelFont_10) / sW) > MAX_DESCRIPTION_WIDTH) then
			updateFeedbackLabel("Hair Color & Style description is too long!", 255, 0, 0)
			return
		elseif (string.len(hairColStyleText) < 3) then hairColStyleText = "No description available." end

		if ((dxGetTextWidth(facialFeatureText, 1, labelFont_10) / sW) > MAX_DESCRIPTION_WIDTH) then
			updateFeedbackLabel("Facial Features description is too long!", 255, 0, 0)
			return
		elseif (string.len(facialFeatureText) < 3) then facialFeatureText = "No description available." end

		if ((dxGetTextWidth(physicalBuildText, 1, labelFont_10) / sW) > MAX_DESCRIPTION_WIDTH) then
			updateFeedbackLabel("Physical Build description is too long!", 255, 0, 0)
			return
		elseif (string.len(physicalBuildText) < 3) then physicalBuildText = "No description available." end

		if ((dxGetTextWidth(clothingText, 1, labelFont_10) / sW) > MAX_DESCRIPTION_WIDTH) then
			updateFeedbackLabel("Clothing description is too long!", 255, 0, 0)
			return
		elseif (string.len(clothingText) < 3) then clothingText = "No description available." end

		if ((dxGetTextWidth(accessoriesText, 1, labelFont_10) / sW) > MAX_DESCRIPTION_WIDTH) then
			updateFeedbackLabel("Accessories description is too long!", 255, 0, 0)
			return
		elseif (string.len(accessoriesText) < 3) then accessoriesText = "No description available." end

		if ((dxGetTextWidth(walkstyleText, 1, labelFont_10) / sW) > MAX_DESCRIPTION_WIDTH) then
			updateFeedbackLabel("Walk Style description is too long!", 255, 0, 0)
			return
		elseif (string.len(walkstyleText) < 3) then walkstyleText = "No description available." end

		if ((dxGetTextWidth(makeupText, 1, labelFont_10) / sW) > MAX_DESCRIPTION_WIDTH) then
			updateFeedbackLabel("Makeup description is too long!", 255, 0, 0)
			return
		elseif (string.len(makeupText) < 3) then makeupText = "No description available." end

		local outputDescTable = {
			["haircolstyle"] = hairColStyleText,
			["facialfeatures"] = facialFeatureText,
			["physicalbuild"] = physicalBuildText,
			["clothing"] = clothingText,
			["accessories"] = accessoriesText,
			["walkstyle"] = walkstyleText,
			["makeup"] = makeupText,
		}

		triggerServerEvent("interaction:updateCharacterDescription", localPlayer, outputDescTable, selectedMood, weightText)
		updateFeedbackLabel("Your changes have been saved!", 0, 255, 0)
		if emGUI:dxIsWindowVisible(characterLookWindow) then emGUI:dxCloseWindow(characterLookWindow) end
		if emGUI:dxIsWindowVisible(charDescWindow) then emGUI:dxCloseWindow(charDescWindow) end
	end
end