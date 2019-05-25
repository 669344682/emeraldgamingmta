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
animations = {
	[1] = { }, -- Name
	[2] = { } -- Group/Block
 }

 savedAnimations = {
	[1] = { }, -- Name
	[2] = { }, -- Group/Block
	[3] = { }, -- Command Name
	[4] = { } -- Loop
}

function getAnimationsFromXML(xmlFileName, index)
	local xmlFile
	if (xmlFileName == "animations.xml") then
		xmlFile = getResourceConfig("animations.xml")
	else
		xmlFile = xmlLoadFile(xmlFileName)

		if not (xmlFile) and (xmlFileName == "savedAnimations.xml") then
			xmlFile = xmlCreateFile("savedAnimations.xml", "savedAnimations")
			xmlSaveFile(xmlFile)
			xmlUnloadFile(xmlFile)
			return { }
		end
	end

	if not (xmlFile) then
		exports.global:outputDebug("@getAnimationsFromXML: Failed to retrieve XML file.")
		outputChatBox("ERROR: Something went wrong whilst retrieving the animation list!", localPlayer, 255, 0, 0)
		return false
	else
		local result = {}
		local i = 0
		local key = "group"
		local parentNode = xmlFile

		if (index) then
			key = "anim"
			parentNode = xmlFindChild(xmlFile, "group", index)
		end

		local groupNode = xmlFindChild(parentNode, key, i)
		while (groupNode) do
			local group = { }
			if (xmlFileName == "savedAnimations.xml") then
				group = {"group", name = xmlNodeGetAttribute(groupNode, 'name'), command = xmlNodeGetAttribute(groupNode, 'command'), loop = xmlNodeGetAttribute(groupNode, 'loop'), index = i}
			else
				group = {"group", name = xmlNodeGetAttribute(groupNode, 'name'), index = i}
			end

			table.insert(result, group)
			i = i + 1
			groupNode = xmlFindChild(parentNode, key, i)
		end

		xmlUnloadFile(xmlFile)
		return result
	end
end

function setAnimationsTableFromXML(targetTable, xmlFile)
	for key, node in pairs(getAnimationsFromXML(xmlFile)) do
		for index, group in pairs(getAnimationsFromXML(xmlFile, node.index)) do
			table.insert(targetTable[1], group.name)
			table.insert(targetTable[2], node.name)
			if (xmlFile == "savedAnimations.xml") then 
				table.insert(targetTable[3], group.command)
				local loop
				if (group.loop == "true") then loop = true else loop = false end
				table.insert(targetTable[4], loop)
			end
		end
	end
end

--------------------------------------- [ANIMATION LIST GUI] ---------------------------------------

function showAnimationList()
	if (emGUI:dxIsWindowVisible(animationListWindow)) then emGUI:dxCloseWindow(animationListWindow) return end
	outputChatBox("For a list of predefined animations, please use the /anims command.", 75, 230, 10)

	animationListWindow = emGUI:dxCreateWindow(0.78, 0.23, 0.21, 0.54, "Animation List", true, _, true)
	animationsGridlist = emGUI:dxCreateGridList(0.037, 0.02, 0.92, 0.95, true, animationListWindow)
	emGUI:dxGridListAddColumn(animationsGridlist, "Group - Double click to view.", 1)
 
	animationLoopCheckBox = emGUI:dxCreateCheckBox(0.037, 0.8257, 0.17, 0.03, "Loop", false, true, animationListWindow)

	playAnimationButton = emGUI:dxCreateButton(0.045, 0.89, 0.38, 0.09, "PLAY", true, animationListWindow)
	addEventHandler("onClientDgsDxMouseClick", playAnimationButton, playAnimationClick)

	saveAnimationButton = emGUI:dxCreateButton(0.56, 0.89, 0.38, 0.09, "SAVE", true, animationListWindow)
	addEventHandler("onClientDgsDxMouseClick", saveAnimationButton, saveButtonClick)
   
	saveAnimationText = emGUI:dxCreateLabel(0.275, 0.825, 0.21, 0.03, "Custom Name:", true, animationListWindow)
	animationCustomNameInput = emGUI:dxCreateEdit(0.54, 0.822, 0.40, 0.042, "", true, animationListWindow)
 	emGUI:dxEditSetMaxLength(animationCustomNameInput, 20)

 	animationsBackButton = emGUI:dxCreateButton(0, -0.0468, 0.06, 0.048, "↩️", true, animationListWindow, _, _, _, _, _, _, tocolor(50, 200, 0, 0))
	addEventHandler("onClientDgsDxMouseClick", animationsBackButton, goBackButton)

 	setAnimationsTableFromXML(animations, "animations.xml")
	animationContent(false)

	addEventHandler("onClientDgsDxMouseClick", animationsGridlist, function() if (emGUI:dxGetVisible(saveAnimationButton)) then savedStatus() end end)
	addEventHandler("onClientDgsDxMouseDoubleClick", animationsGridlist, function() if not (emGUI:dxGetVisible(playAnimationButton)) then animationContent(true) end end)
end
addCommandHandler("animlist", showAnimationList)
addCommandHandler("animations", showAnimationList)
addCommandHandler("animationlist", showAnimationList)

local animatingMenu = false
function animationContent(state)
	if (animatingMenu) then return end

	animatingMenu = true

	if (state) then
		local selectedRow, selectedCol = emGUI:dxGridListGetSelectedItem(animationsGridlist) 

		if (selectedRow ~= -1) and (selectedCol ~= -1) then
			local category = emGUI:dxGridListGetItemText(animationsGridlist, selectedRow, selectedCol)
			emGUI:dxGridListSetColumnTitle(animationsGridlist, 1, "Name")
			emGUI:dxSetText(animationListWindow, category)
			emGUI:dxGridListClear(animationsGridlist)
			emGUI:dxSizeTo(animationsGridlist, 0.92, 0.78, true, false, "Linear", 200)
			emGUI:dxSetVisible(animationsBackButton, true)

			setTimer(function()
				emGUI:dxSetVisible(animationLoopCheckBox, true)
				emGUI:dxSetVisible(playAnimationButton, true)
				emGUI:dxSetVisible(saveAnimationButton, true)
				emGUI:dxSetVisible(saveAnimationText, true)
				emGUI:dxSetVisible(animationCustomNameInput, true)
				animatingMenu = false
			end, 400, 1)

			local addedAnimations = { }
			for i = 1, #animations[1] do
				local animGroup = animations[2][i]
				if (animGroup:lower() == category:lower()) then
					local animName = animations[1][i]
					local alreadyAdded = false

					for i, animationName in ipairs(addedAnimations) do
						if (animationName == animName) then alreadyAdded = true break end
					end

					if not (alreadyAdded) then
						local row = emGUI:dxGridListAddRow(animationsGridlist)
						emGUI:dxGridListSetItemText(animationsGridlist, row, 1, animName, false, false)
						table.insert(addedAnimations, animName)
						alreadyAdded = false
					end
				end
			end
		end
	else
		emGUI:dxSetVisible(animationLoopCheckBox, false)
		emGUI:dxSetVisible(playAnimationButton, false)
		emGUI:dxSetVisible(saveAnimationButton, false)
		emGUI:dxSetVisible(saveAnimationText, false)
		emGUI:dxSetVisible(animationCustomNameInput, false)
		emGUI:dxSetVisible(animationsBackButton, false)
		emGUI:dxSizeTo(animationsGridlist, 0.92, 0.95, true, false, "Linear", 200)
		setTimer(function() animatingMenu = false end, 210, 1)
		emGUI:dxGridListClear(animationsGridlist)
		emGUI:dxGridListSetColumnTitle(animationsGridlist, 1, "Group - Double click to view.")
		emGUI:dxSetText(animationListWindow, "Animation List")

		local categories = { }
		for i, category in ipairs(animations[2]) do
			if (#categories == 0) then table.insert(categories, category) end

			local containsCategory = false 
			for i, addedCategory in ipairs(categories) do
				if (addedCategory == category) then containsCategory = true break end
			end

			if not (containsCategory) then
				local row = emGUI:dxGridListAddRow(animationsGridlist)
				emGUI:dxGridListSetItemText(animationsGridlist, row, 1, category:lower():gsub("^%l", string.upper), false, false)
				table.insert(categories, category)
				containsCategory = false
			end
		end
	end
end

function goBackButton(button, state)
	if (button == "left") and (state == "down") then animationContent(false) end
end

function saveButtonClick(button, state)
	if (button == "left") and (state == "down") then
		local buttonText = emGUI:dxGetText(saveAnimationButton)
		if (buttonText == "Save") then
			triggerSaveAnimation("left", "down") 
		else 
			triggerUnsaveAnimation("left", "down") 
		end
	end
end

function playAnimationClick(button, state)
	if (button == "left") and (state == "down") then
		local selectedAnimation = emGUI:dxGridListGetSelectedItem(animationsGridlist)
		local animationLoopState = emGUI:dxCheckBoxGetSelected(animationLoopCheckBox)

		if (selectedAnimation ~= -1) then
			local animationName = emGUI:dxGridListGetItemText(animationsGridlist, selectedAnimation, 1)
			local animationGroup = emGUI:dxGetText(animationListWindow)

			triggerAnimationStart(animationName, animationGroup, animationLoopState)
		end
	end
end

-------------------------------------------------------------------------------------------------------------------

function showSavedAnimationList()	
	if (emGUI:dxIsWindowVisible(savedAnimationsWindow)) then emGUI:dxCloseWindow(savedAnimationsWindow) return end

	savedAnimationsWindow = emGUI:dxCreateWindow(0.78, 0.23, 0.21, 0.54, "Saved Animations", true, _, true)
	savedAnimationsList = emGUI:dxCreateGridList(0.037, 0.02, 0.92, 0.85, true, savedAnimationsWindow)

	closeSavedAnimationsButton = emGUI:dxCreateButton(0.045, 0.89, 0.38, 0.09, "CLOSE", true, savedAnimationsWindow)
	addEventHandler("onClientDgsDxMouseClick", closeSavedAnimationsButton, function(button, state)
		if (button == "left") and (state == "down") then emGUI:dxCloseWindow(savedAnimationsWindow) end
	end)

	unsaveAnimationButton = emGUI:dxCreateButton(0.56, 0.89, 0.38, 0.09, "UNSAVE", true, savedAnimationsWindow)
	addEventHandler("onClientDgsDxMouseClick", unsaveAnimationButton, triggerUnsaveAnimation)

	emGUI:dxGridListAddColumn(savedAnimationsList, "Name", 0.4)
	emGUI:dxGridListAddColumn(savedAnimationsList, "Group", 0.3)
	emGUI:dxGridListAddColumn(savedAnimationsList, "Command", 0.3)
	emGUI:dxGridListClear(savedAnimationsList)

	for i, savedAnimationName in ipairs(savedAnimations[1]) do
		local row = emGUI:dxGridListAddRow(savedAnimationsList)
		local savedAnimationGroup = savedAnimations[2][i]:lower():gsub("^%l", string.upper)
		local savedAnimationCommand = savedAnimations[3][i]:lower():gsub("^%l", string.upper)

		emGUI:dxGridListSetItemText(savedAnimationsList, row, 1, savedAnimationName:lower():gsub("^%l", string.upper), false, false)
		emGUI:dxGridListSetItemText(savedAnimationsList, row, 2, savedAnimationGroup, false, false)
		emGUI:dxGridListSetItemText(savedAnimationsList, row, 3, savedAnimationCommand, false, false)
	end
end
addCommandHandler("savedanims", showSavedAnimationList)
addCommandHandler("savedanimations", showSavedAnimationList)

----------------------------------------------------------------------------------------------------------

function savedStatus()
	local selectedAnimation = emGUI:dxGridListGetSelectedItem(animationsGridlist)
	emGUI:dxLabelSetColor(saveAnimationText, 255, 255, 255)

	if (selectedAnimation ~= -1) and (#savedAnimations > 0) then
		local animationName = emGUI:dxGridListGetItemText(animationsGridlist, selectedAnimation, 1)
		local animationGroup = emGUI:dxGetText(animationListWindow)

		for i = 1, #savedAnimations[1] do
			local savedAnimationName = savedAnimations[1][i]
			local savedAnimationGroup = savedAnimations[2][i]

			if (savedAnimationName:lower()  == animationName:lower() ) and (savedAnimationGroup:lower() == animationGroup:lower()) then
				emGUI:dxSetText(saveAnimationButton, "Unsave")
				return true
			end
		end
		emGUI:dxSetText(saveAnimationButton, "Save")
	end
end

function triggerSaveAnimation(button, state)
	if (button == "left") and (state == "down") then
		local selectedAnimation = emGUI:dxGridListGetSelectedItem(animationsGridlist)

		if (selectedAnimation ~= -1) then
			local commandName = emGUI:dxGetText(animationCustomNameInput):gsub("%s+", "")
			if (commandName == "") then
				emGUI:dxLabelSetColor(saveAnimationText, 255, 0, 0)
				return false
			end
			local animationName = emGUI:dxGridListGetItemText(animationsGridlist, selectedAnimation, 1)
			local animationGroup = emGUI:dxGetText(animationListWindow)
			local animationLoopState = emGUI:dxCheckBoxGetSelected(animationLoopCheckBox)
			local buttonText = emGUI:dxGetText(saveAnimationButton)

			if (buttonText == "Save") then
				saveAnimation(animationName, animationGroup, commandName:lower(), animationLoopState) 
			else 
				for i = 1, #savedAnimations[1] do
					local savedAnimationName = savedAnimations[1][i]
					local savedAnimationGroup = savedAnimations[2][i]

					if (savedAnimationName == animationName) and (savedAnimationGroup == animationGroup) then
						unsaveAnimation(i)
						emGUI:dxSetText(saveAnimationButton, "Save")
						return true
					end
				end
			end
		end
	end
end

function triggerUnsaveAnimation(button, state)
	if (button == "left") and (state == "down") then
		local gridList = savedAnimationsList
		local isInSavedAnimations = true
		if (isElement(animationListWindow)) then if (emGUI:dxGetVisible(animationListWindow)) then gridList = animationsGridlist; isInSavedAnimations = false end end

		local selectedAnimation = emGUI:dxGridListGetSelectedItem(gridList)
		if (selectedAnimation ~= -1) then
			local animationName = emGUI:dxGridListGetItemText(gridList, selectedAnimation, 1):lower()

			for i = 1, #savedAnimations[1] do
				local savedAnimationName = savedAnimations[1][i]:lower()

				if (savedAnimationName == animationName) then
					unsaveAnimation(i)
					if (isInSavedAnimations) then emGUI:dxGridListRemoveRow(gridList, selectedAnimation) end
					if not (isInSavedAnimations) then emGUI:dxSetText(saveAnimationButton, "Save") end
					return true
				end
			end
		end
	end
end

function saveAnimation(animationName, animationGroup, animationCommand, animationLoop)
	local xmlFile = xmlLoadFile("savedAnimations.xml")
	if not (xmlFile) then
		exports.global:outputDebug("@saveAnimation: Could not load XML file.")
		outputChatBox("ERROR: Something went wrong whilst saving the animation!", 255, 0, 0)
		return false
	end

	for i, command in ipairs(savedAnimations[3]) do
		if (command:lower() == animationCommand) then
			emGUI:dxLabelSetColor(saveAnimationText, 255, 0, 0)
			return false 
		end
	end

	local savedAnimationGroupParent = xmlCreateChild(xmlFile, "group")
	local savedAnimationNameParent = xmlCreateChild(savedAnimationGroupParent, "anim")
	local savedAnimationGroup = xmlNodeSetAttribute(savedAnimationGroupParent, "name", animationGroup)
	local savedAnimationName = xmlNodeSetAttribute(savedAnimationNameParent, "name", animationName)
	local savedAnimationCommandName = xmlNodeSetAttribute(savedAnimationNameParent, "command", animationCommand:lower())
	local savedAnimationLoop = xmlNodeSetAttribute(savedAnimationNameParent, "loop", tostring(animationLoop))
	xmlSaveFile(xmlFile)

	if (savedAnimationName) and (savedAnimationGroup) and (savedAnimationCommandName) and (savedAnimationLoop) then
		table.insert(savedAnimations[1], animationName)
		table.insert(savedAnimations[2], animationGroup)
		table.insert(savedAnimations[3], animationCommand)
		table.insert(savedAnimations[4], animationLoop)
		emGUI:dxSetText(saveAnimationButton, "Unsave")

		outputChatBox(" ")
		outputChatBox("You have saved the animation '" .. animationName .. "'.", 0, 255, 0)
		outputChatBox("Type /anim " .. animationCommand .. " to use the animation or check the F8 console for details on how to bind it.", 75, 230, 10)

		outputConsole(" ")
		outputConsole("Paste the following line and press enter to bind animation:")
		outputConsole("bind ReplaceWithKey down anim " .. animationCommand .. "")
	else
		exports.global:outputDebug("@saveAnimation: Failed to save animation in XML file.")
		outputChatBox("ERROR: Something went wrong whilst saving the animation!", 255, 0, 0)
	end
	xmlUnloadFile(xmlFile)
end

function unsaveAnimation(animationID)
	local xmlFile = xmlLoadFile("savedAnimations.xml")
	if not (xmlFile) then
		exports.global:outputDebug("@unsaveAnimation: Could not load XML file.")
		outputChatBox("ERROR: Something went wrong whilst unsaving the animation!", 255, 0, 0)
		return false
	end
	local savedAnimation = xmlFindChild(xmlFile, "group", animationID - 1)

	if not (savedAnimation) then
		exports.global:outputDebug("@unsaveAnimation: Failed to find node.")
		outputChatBox("ERROR: Something went wrong whilst unsaving the animation!", 255, 0, 0)
		return false
	end
	local destroyAnimationNode = xmlDestroyNode(savedAnimation)

	if (destroyAnimationNode) then
		local animationCommandName = savedAnimations[3][animationID]

		xmlSaveFile(xmlFile)
		table.remove(savedAnimations[1], animationID)
		table.remove(savedAnimations[2], animationID)
		table.remove(savedAnimations[3], animationID)
		table.remove(savedAnimations[4], animationID)

		outputChatBox("You have unsaved the animation '" .. animationCommandName .. "'.", 0, 255, 0)
	else 
		exports.global:outputDebug("@unsaveAnimation: Failed to destroy nodes.")
		outputChatBox("ERROR: Something went wrong whilst unsaving the animation!", 255, 0, 0)
	end
	xmlUnloadFile(xmlFile)
end

----------------------------------------------------------------------------------------------------------
anim = false
attachedRotation = falsem
local walkingAnimations = { WALK_armed = true, WALK_civi = true, WALK_csaw = true, Walk_DoorPartial = true, WALK_drunk = true, WALK_fat = true, WALK_fatold = true, WALK_gang1 = true, WALK_gang2 = true, WALK_old = true, WALK_player = true, WALK_rocket = true, WALK_shuffle = true, Walk_Wuzi = true, woman_run = true, WOMAN_runbusy = true, WOMAN_runfatold = true, woman_runpanic = true, WOMAN_runsexy = true, WOMAN_walkbusy = true, WOMAN_walkfatold = true, WOMAN_walknorm = true, WOMAN_walkold = true, WOMAN_walkpro = true, WOMAN_walksexy = true, WOMAN_walkshop = true, run_1armed = true, run_armed = true, run_civi = true, run_csaw = true, run_fat = true, run_fatold = true, run_gang1 = true, run_old = true, run_player = true, run_rocket = true, Run_Wuzi = true }

function triggerAnimationStart(animationName, animationGroup, loop)
	triggerServerEvent("animation:startAnimation", localPlayer, localPlayer, animationGroup, animationName, -1, loop, false, false)
end

function onRender()
	local forced = getElementData(localPlayer, "animation:forced")

	if (getPedAnimation(localPlayer)) and not (forced) then
		local animationGroup, animationName = getPedAnimation(localPlayer)
		anim = true

		if (animationGroup == "ped") and (walkingAnimations[animationName]) then
			local px, py, pz, lx, ly, lz = getCameraMatrix()
			setPedRotation(localPlayer, math.deg(math.atan2(ly - py, lx - px)) - 90)
		end

	elseif not (getPedAnimation(localPlayer)) and (anim) then
		toggleAllControls(true, true, false)
		anim = false 
	end
	
	local attachedElement = getElementAttachedTo(localPlayer)
	if (attachedElement) and (getElementType(attachedElement) == "vehicle") then
		if (attachedRotation) then
			local rx, ry, rz = getElementRotation(attachedElement)
			setPedRotation(localPlayer, rz + attachedRotation)
		else
			local rx, ry, rz = getElementRotation(attachedElement)
			attachedRotation = getPedRotation(localPlayer) - rz
		end
	elseif (attachedRotation) then
		attachedRotation = false
	end
end
addEventHandler("onClientRender", getRootElement(), onRender)

function stopAnimation()
	if (getPedAnimation(localPlayer)) then
		local forced = getElementData(localPlayer, "animation:forced")

		setPedAnimation(localPlayer)
		triggerServerEvent("animation:stopAnimationServer", localPlayer, forced)
	end
end
addEvent("animation:stopAnimation", true)
addEventHandler("animation:stopAnimation", getRootElement(), stopAnimation)

function playSavedAnimation(commandName, animationCommand)
	if not (animationCommand) then triggerServerEvent("animation:showAnimationHelp", localPlayer, localPlayer, "anims") end

	for i, command in ipairs(savedAnimations[3]) do
		if (command:lower() == animationCommand:lower()) then 
			local animationName = savedAnimations[1][i]
			local animationGroup = savedAnimations[2][i]
			local animationLoop = savedAnimations[4][i]
		
			triggerAnimationStart(animationName, animationGroup, animationLoop)
			return true
		end
	end
	outputChatBox("You don't have an animation saved as '" .. animationCommand .. "'. To view saved animations, use /savedanims.", 255, 0, 0)
end
addCommandHandler("anim", playSavedAnimation)

addEvent("onClientResourceStart", true)
addEventHandler("onClientResourceStart", resourceRoot, function() setAnimationsTableFromXML(savedAnimations, "savedAnimations.xml") end)