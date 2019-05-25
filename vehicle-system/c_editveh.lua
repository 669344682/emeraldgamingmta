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

emGUI = exports.emGUI
local c_fromCreation = false
local buttonFont_12 = emGUI:dxCreateNewFont("fonts/buttonFont.ttf", 12)

--[[

NOTE FOR DEVELOPERS:
	This is some beautiful and very questionable code that is literally a maze, pretty sure I wrote
	this on a long night at 3am, if something is broken I don't recommend fucking with the code below
	unless you're experienced enough to do so - open an issue on the GitHub repo instead. - Skully

]]

function showVehicleEditorGUI(vehicleData, fromCreation)
	if not (vehicleData) then outputChatBox("ERROR: Failed to load vehicle handling.", 255, 0, 0) return end
	if emGUI:dxIsWindowVisible(vehicleEditorGUI) then emGUI:dxCloseWindow(vehicleEditorGUI) return end
	vehEditorLabels = {}
	vehEditorItems = {}
	modelFlags = {}
	handlingFlags = {}
	helpItems = {}

	local data = vehicleData[1] -- Store vehicle handling data.

	c_fromCreation = fromCreation
	vehicleEditorGUI = emGUI:dxCreateWindow(0.75, 0.26, 0.24, 0.51, " ", true, false, true, true, _, 10)

	settingsTabPanel = emGUI:dxCreateTabPanel(0.03, 0.03, 0.95, 0.82, true, vehicleEditorGUI)
		engineTab = emGUI:dxCreateTab("Engine", settingsTabPanel)
			helpItems[1] = {}
			helpItems[1][1] = emGUI:dxCreateButton(0, 0.7, 1, 0.3, "Engine\n\n\n\n\n\n", true, engineTab, _, _, _, _, _, _, tocolor(0, 0, 0, 180))
			emGUI:dxSetEnabled(helpItems[1][1], false)
			helpItems[1][2] = emGUI:dxCreateLabel(0.03, 0.78, 0.2, 0.05, "Adjust the vehicle engine states and maximum performance\ncapabilities.", true, engineTab)

			vehEditorLabels[1] = emGUI:dxCreateLabel(0.03, 0.03, 0.45, 0.03, "Number of Gears", true, engineTab)
			vehEditorLabels[2] = emGUI:dxCreateLabel(0.03, 0.1, 0.45, 0.03, "Maximum Velocity", true, engineTab)
			vehEditorLabels[3] = emGUI:dxCreateLabel(0.03, 0.17, 0.45, 0.03, "Acceleration", true, engineTab)
			vehEditorLabels[4] = emGUI:dxCreateLabel(0.03, 0.24, 0.45, 0.03, "Inertia", true, engineTab)
			vehEditorLabels[5] = emGUI:dxCreateLabel(0.03, 0.31, 0.45, 0.03, "Wheel Drive", true, engineTab)
			vehEditorLabels[6] = emGUI:dxCreateLabel(0.03, 0.38, 0.45, 0.03, "Engine Type", true, engineTab)
			vehEditorLabels[7] = emGUI:dxCreateLabel(0.03, 0.45, 0.45, 0.03, "Steering Lock", true, engineTab)
			vehEditorLabels[8] = emGUI:dxCreateLabel(0.03, 0.52, 0.45, 0.03, "Collision Damage Multiplier", true, engineTab)
			
			vehEditorItems[1] = emGUI:dxCreateButton(0.5, 0.025, 0.23, 0.05, data.numberOfGears, true, engineTab)
			addEventHandler("onClientDgsDxMouseClick", vehEditorItems[1], onButtonClickEngine)
			vehEditorItems[2] = emGUI:dxCreateButton(0.5, 0.095, 0.23, 0.05, data.maxVelocity, true, engineTab)
			addEventHandler("onClientDgsDxMouseClick", vehEditorItems[2], onButtonClickEngine)
			vehEditorItems[3] = emGUI:dxCreateButton(0.5, 0.165, 0.23, 0.05, data.engineAcceleration, true, engineTab)
			addEventHandler("onClientDgsDxMouseClick", vehEditorItems[3], onButtonClickEngine)
			vehEditorItems[4] = emGUI:dxCreateButton(0.5, 0.235, 0.23, 0.05, data.engineInertia, true, engineTab)
			addEventHandler("onClientDgsDxMouseClick", vehEditorItems[4], onButtonClickEngine)
			vehEditorItems[5] = emGUI:dxCreateComboBox(0.5, 0.305, 0.33, 0.05, true, engineTab)
				emGUI:dxComboBoxAddItem(vehEditorItems[5], "All Wheels (AWD)")
				emGUI:dxComboBoxAddItem(vehEditorItems[5], "Front Wheels (FWD)")
				emGUI:dxComboBoxAddItem(vehEditorItems[5], "Rear Wheels (RWD)")

				if (data.driveType == "awd") then emGUI:dxComboBoxSetSelectedItem(vehEditorItems[5], 1)
					elseif (data.driveType == "fwd") then emGUI:dxComboBoxSetSelectedItem(vehEditorItems[5], 2)
					elseif (data.driveType == "rwd") then emGUI:dxComboBoxSetSelectedItem(vehEditorItems[5], 3)
				end

			vehEditorItems[6] = emGUI:dxCreateComboBox(0.5, 0.375, 0.33, 0.05, true, engineTab)
				emGUI:dxComboBoxAddItem(vehEditorItems[6], "Petrol")
				emGUI:dxComboBoxAddItem(vehEditorItems[6], "Diesel")
				emGUI:dxComboBoxAddItem(vehEditorItems[6], "Electric")
				if (data.engineType == "petrol") then emGUI:dxComboBoxSetSelectedItem(vehEditorItems[6], 1)
					elseif (data.engineType == "diesel") then emGUI:dxComboBoxSetSelectedItem(vehEditorItems[6], 2)
					elseif (data.engineType == "electric") then emGUI:dxComboBoxSetSelectedItem(vehEditorItems[6], 3)
				end
			vehEditorItems[7] = emGUI:dxCreateButton(0.5, 0.445, 0.23, 0.05, data.steeringLock, true, engineTab)
			addEventHandler("onClientDgsDxMouseClick", vehEditorItems[7], onButtonClickEngine)
			vehEditorItems[8] = emGUI:dxCreateButton(0.5, 0.515, 0.23, 0.05, data.collisionDamageMultiplier, true, engineTab)
			addEventHandler("onClientDgsDxMouseClick", vehEditorItems[8], onButtonClickEngine)

		bodyTab = emGUI:dxCreateTab("Body", settingsTabPanel)
			helpItems[2] = {}
			helpItems[2][1] = emGUI:dxCreateButton(0, 0.7, 1, 0.3, "Body\n\n\n\n\n\n", true, bodyTab, _, _, _, _, _, _, tocolor(0, 0, 0, 180))
			emGUI:dxSetEnabled(helpItems[2][1], false)
			helpItems[2][2] = emGUI:dxCreateLabel(0.03, 0.78, 0.2, 0.05, "Change characteristics of the vehicles physical body.", true, bodyTab)

			vehEditorLabels[9] = emGUI:dxCreateLabel(0.03, 0.03, 0.45, 0.03, "Mass", true, bodyTab)
			vehEditorLabels[10] = emGUI:dxCreateLabel(0.03, 0.1, 0.45, 0.03, "Turn Mass", true, bodyTab)
			vehEditorLabels[11] = emGUI:dxCreateLabel(0.03, 0.17, 0.45, 0.03, "Drag Multiplier", true, bodyTab)
			vehEditorLabels[12] = emGUI:dxCreateLabel(0.03, 0.24, 0.45, 0.03, "Center of Mass (X Y Z)", true, bodyTab)
			vehEditorLabels[13] = emGUI:dxCreateLabel(0.03, 0.31, 0.45, 0.03, "Percent Submerged", true, bodyTab)
			vehEditorLabels[14] = emGUI:dxCreateLabel(0.03, 0.38, 0.45, 0.03, "Animation Group", true, bodyTab)
			vehEditorLabels[15] = emGUI:dxCreateLabel(0.03, 0.45, 0.45, 0.03, "Seat Offset Distance", true, bodyTab)

			vehEditorItems[9] = emGUI:dxCreateButton(0.5, 0.025, 0.23, 0.05, data.mass, true, bodyTab)
			addEventHandler("onClientDgsDxMouseClick", vehEditorItems[9], onButtonClickBody)
			vehEditorItems[10] = emGUI:dxCreateButton(0.5, 0.095, 0.23, 0.05, data.turnMass, true, bodyTab)
			addEventHandler("onClientDgsDxMouseClick", vehEditorItems[10], onButtonClickBody)
			vehEditorItems[11] = emGUI:dxCreateButton(0.5, 0.165, 0.23, 0.05, data.dragCoeff, true, bodyTab)
			addEventHandler("onClientDgsDxMouseClick", vehEditorItems[11], onButtonClickBody)
			vehEditorItems[12] = {}
				vehEditorItems[12][1] = emGUI:dxCreateButton(0.5, 0.235, 0.076, 0.05, data.centerOfMass[1], true, bodyTab)
				addEventHandler("onClientDgsDxMouseClick", vehEditorItems[12][1], onButtonClickBody)
				vehEditorItems[12][2] = emGUI:dxCreateButton(0.576, 0.235, 0.076, 0.05, data.centerOfMass[2], true, bodyTab)
				addEventHandler("onClientDgsDxMouseClick", vehEditorItems[12][2], onButtonClickBody)
				vehEditorItems[12][3] = emGUI:dxCreateButton(0.651, 0.235, 0.076, 0.05, data.centerOfMass[3], true, bodyTab)
				addEventHandler("onClientDgsDxMouseClick", vehEditorItems[12][3], onButtonClickBody)
			vehEditorItems[13] = emGUI:dxCreateButton(0.5, 0.305, 0.23, 0.05, data.percentSubmerged, true, bodyTab)
			addEventHandler("onClientDgsDxMouseClick", vehEditorItems[13], onButtonClickBody)
			vehEditorItems[14] = emGUI:dxCreateButton(0.5, 0.375, 0.23, 0.05, data.animGroup, true, bodyTab)
			--addEventHandler("onClientDgsDxMouseClick", vehEditorItems[14], onButtonClickBody) -- Disabling animation group editing to prevent bugs.
			emGUI:dxSetEnabled(vehEditorItems[14], false)
			vehEditorItems[15] = emGUI:dxCreateButton(0.5, 0.445, 0.23, 0.05, data.seatOffsetDistance, true, bodyTab)
			addEventHandler("onClientDgsDxMouseClick", vehEditorItems[15], onButtonClickBody)

		wheelsTab = emGUI:dxCreateTab("Wheels", settingsTabPanel)
			helpItems[3] = {}
			helpItems[3][1] = emGUI:dxCreateButton(0, 0.87, 1, 0.13, "Wheels\n\n", true, wheelsTab, _, _, _, _, _, _, tocolor(0, 0, 0, 180))
			emGUI:dxSetEnabled(helpItems[3][1], false)
			helpItems[3][2] = emGUI:dxCreateLabel(0.4, 0.935, 0.2, 0.05, "Adjust the properties and traits of the vehicle's wheels.", true, wheelsTab)
			emGUI:dxLabelSetHorizontalAlign(helpItems[3][2], "center")
			vehEditorLabels[16] = emGUI:dxCreateLabel(0.06, 0.03, 0.45, 0.03, "Traction Multiplier", true, wheelsTab)
			vehEditorLabels[17] = emGUI:dxCreateLabel(0.06, 0.1, 0.45, 0.03, "Traction Loss", true, wheelsTab)
			vehEditorLabels[18] = emGUI:dxCreateLabel(0.06, 0.17, 0.45, 0.03, "Traction Bias", true, wheelsTab)
			vehEditorLabels[19] = emGUI:dxCreateLabel(0.06, 0.24, 0.45, 0.03, "Brake Deceleration", true, wheelsTab)
			vehEditorLabels[20] = emGUI:dxCreateLabel(0.06, 0.31, 0.45, 0.03, "Brake Bias", true, wheelsTab)
			vehEditorLabels[21] = emGUI:dxCreateLabel(0.06, 0.38, 0.45, 0.03, "Suspension Force Level", true, wheelsTab)
			vehEditorLabels[22] = emGUI:dxCreateLabel(0.06, 0.45, 0.45, 0.03, "Suspension Damping", true, wheelsTab)
			vehEditorLabels[23] = emGUI:dxCreateLabel(0.06, 0.52, 0.45, 0.03, "Suspension High Speed Damping", true, wheelsTab)
			vehEditorLabels[24] = emGUI:dxCreateLabel(0.06, 0.59, 0.45, 0.03, "Suspension Upper Limit", true, wheelsTab)
			vehEditorLabels[25] = emGUI:dxCreateLabel(0.06, 0.66, 0.45, 0.03, "Suspension Lower Limit", true, wheelsTab)
			vehEditorLabels[26] = emGUI:dxCreateLabel(0.06, 0.73, 0.45, 0.03, "Suspension Anti Dive Multiplier", true, wheelsTab)
			vehEditorLabels[27] = emGUI:dxCreateLabel(0.06, 0.8, 0.45, 0.03, "Suspension Bias", true, wheelsTab)

			vehEditorItems[16] = emGUI:dxCreateButton(0.54, 0.025, 0.23, 0.05, data.tractionMultiplier, true, wheelsTab)
			addEventHandler("onClientDgsDxMouseClick", vehEditorItems[16], onButtonClickWheels)
			vehEditorItems[17] = emGUI:dxCreateButton(0.54, 0.095, 0.23, 0.05, data.tractionLoss, true, wheelsTab)
			addEventHandler("onClientDgsDxMouseClick", vehEditorItems[17], onButtonClickWheels)
			vehEditorItems[18] = emGUI:dxCreateButton(0.54, 0.165, 0.23, 0.05, data.tractionBias, true, wheelsTab)
			addEventHandler("onClientDgsDxMouseClick", vehEditorItems[18], onButtonClickWheels)
			vehEditorItems[19] = emGUI:dxCreateButton(0.54, 0.235, 0.23, 0.05, data.brakeDeceleration, true, wheelsTab)
			addEventHandler("onClientDgsDxMouseClick", vehEditorItems[19], onButtonClickWheels)
			vehEditorItems[20] = emGUI:dxCreateButton(0.54, 0.305, 0.23, 0.05, data.brakeBias, true, wheelsTab)
			addEventHandler("onClientDgsDxMouseClick", vehEditorItems[20], onButtonClickWheels)
			vehEditorItems[21] = emGUI:dxCreateButton(0.54, 0.375, 0.23, 0.05, data.suspensionForceLevel, true, wheelsTab)
			addEventHandler("onClientDgsDxMouseClick", vehEditorItems[21], onButtonClickWheels)
			vehEditorItems[22] = emGUI:dxCreateButton(0.54, 0.445, 0.23, 0.05, data.suspensionDamping, true, wheelsTab)
			addEventHandler("onClientDgsDxMouseClick", vehEditorItems[22], onButtonClickWheels)
			vehEditorItems[23] = emGUI:dxCreateButton(0.54, 0.515, 0.23, 0.05, data.suspensionHighSpeedDamping, true, wheelsTab)
			addEventHandler("onClientDgsDxMouseClick", vehEditorItems[23], onButtonClickWheels)
			vehEditorItems[24] = emGUI:dxCreateButton(0.54, 0.585, 0.23, 0.05, data.suspensionUpperLimit, true, wheelsTab)
			addEventHandler("onClientDgsDxMouseClick", vehEditorItems[24], onButtonClickWheels)
			vehEditorItems[25] = emGUI:dxCreateButton(0.54, 0.655, 0.23, 0.05, data.suspensionLowerLimit, true, wheelsTab)
			addEventHandler("onClientDgsDxMouseClick", vehEditorItems[25], onButtonClickWheels)
			vehEditorItems[26] = emGUI:dxCreateButton(0.54, 0.725, 0.23, 0.05, data.suspensionAntiDiveMultiplier, true, wheelsTab)
			addEventHandler("onClientDgsDxMouseClick", vehEditorItems[26], onButtonClickWheels)
			vehEditorItems[27] = emGUI:dxCreateButton(0.54, 0.795, 0.23, 0.05, data.suspensionFrontRearBias, true, wheelsTab)
			addEventHandler("onClientDgsDxMouseClick", vehEditorItems[27], onButtonClickWheels)
		
		modelFlagsTab = emGUI:dxCreateTab("Model Flags", settingsTabPanel)
			helpItems[4] = {}
			helpItems[4][1] = emGUI:dxCreateButton(0, 0.87, 1, 0.13, "Vehicle Model Flags\n\n", true, modelFlagsTab, _, _, _, _, _, _, tocolor(0, 0, 0, 180))
			emGUI:dxSetEnabled(helpItems[4][1], false)
			helpItems[4][2] = emGUI:dxCreateLabel(0.4, 0.935, 0.2, 0.05, "Change the model flags of the vehicle.", true, modelFlagsTab)
			emGUI:dxLabelSetHorizontalAlign(helpItems[4][2], "center")
			modelFlags[1] = emGUI:dxCreateCheckBox(0.1, 0.025, 0.2, 0.05, "IS_VAN", false, true, modelFlagsTab)
			modelFlags[2] = emGUI:dxCreateCheckBox(0.1, 0.075, 0.2, 0.05, "IS_BUS", false, true, modelFlagsTab)
			modelFlags[3] = emGUI:dxCreateCheckBox(0.1, 0.125, 0.2, 0.05, "REVERSE_BONNET", false, true, modelFlagsTab)
			modelFlags[4] = emGUI:dxCreateCheckBox(0.1, 0.175, 0.2, 0.05, "HANGING_BOOT", false, true, modelFlagsTab)
			modelFlags[5] = emGUI:dxCreateCheckBox(0.1, 0.225, 0.2, 0.05, "NO_DOORS", false, true, modelFlagsTab)
			modelFlags[6] = emGUI:dxCreateCheckBox(0.1, 0.275, 0.2, 0.05, "TANDEM_SEATS", false, true, modelFlagsTab)
			modelFlags[7] = emGUI:dxCreateCheckBox(0.1, 0.325, 0.2, 0.05, "NO_EXHAUST", false, true, modelFlagsTab)
			modelFlags[8] = emGUI:dxCreateCheckBox(0.1, 0.375, 0.2, 0.05, "DBL_EXHAUST", false, true, modelFlagsTab)
			modelFlags[9] = emGUI:dxCreateCheckBox(0.1, 0.425, 0.2, 0.05, "AXLE_F_NOTILT", false, true, modelFlagsTab)
			modelFlags[10] = emGUI:dxCreateCheckBox(0.1, 0.475, 0.2, 0.05, "AXLE_F_SOLID", false, true, modelFlagsTab)
			modelFlags[11] = emGUI:dxCreateCheckBox(0.1, 0.525, 0.2, 0.05, "AXLE_R_NOTILT", false, true, modelFlagsTab)
			modelFlags[12] = emGUI:dxCreateCheckBox(0.1, 0.575, 0.2, 0.05, "AXLE_R_SOLID", false, true, modelFlagsTab)
			modelFlags[13] = emGUI:dxCreateCheckBox(0.1, 0.625, 0.2, 0.05, "IS_BIKE", false, true, modelFlagsTab)
			modelFlags[14] = emGUI:dxCreateCheckBox(0.1, 0.675, 0.2, 0.05, "IS_HELI", false, true, modelFlagsTab)
			modelFlags[15] = emGUI:dxCreateCheckBox(0.1, 0.725, 0.2, 0.05, "BOUNCE_PANELS", false, true, modelFlagsTab)
			modelFlags[16] = emGUI:dxCreateCheckBox(0.1, 0.775, 0.2, 0.05, "DOUBLE_RWHEELS", false, true, modelFlagsTab)
			modelFlags[17] = emGUI:dxCreateCheckBox(0.5, 0.025, 0.2, 0.05, "IS_LOW", false, true, modelFlagsTab)
			modelFlags[18] = emGUI:dxCreateCheckBox(0.5, 0.075, 0.2, 0.05, "IS_BIG", false, true, modelFlagsTab)
			modelFlags[19] = emGUI:dxCreateCheckBox(0.5, 0.125, 0.2, 0.05, "TAILGATE_BOOT", false, true, modelFlagsTab)
			modelFlags[20] = emGUI:dxCreateCheckBox(0.5, 0.175, 0.2, 0.05, "NOSWING_BOOT", false, true, modelFlagsTab)
			modelFlags[21] = emGUI:dxCreateCheckBox(0.5, 0.225, 0.2, 0.05, "SIT_IN_BOAT", false, true, modelFlagsTab)
			modelFlags[22] = emGUI:dxCreateCheckBox(0.5, 0.275, 0.2, 0.05, "CONVERTIBLE", false, true, modelFlagsTab)
			modelFlags[23] = emGUI:dxCreateCheckBox(0.5, 0.325, 0.2, 0.05, "NO1FPS_LOOK_BEHIND", false, true, modelFlagsTab)
			modelFlags[24] = emGUI:dxCreateCheckBox(0.5, 0.375, 0.2, 0.05, "FORCE_DOOR_CHECK", false, true, modelFlagsTab)
			modelFlags[25] = emGUI:dxCreateCheckBox(0.5, 0.425, 0.2, 0.05, "AXLE_F_MCPHERSON", false, true, modelFlagsTab)
			modelFlags[26] = emGUI:dxCreateCheckBox(0.5, 0.475, 0.2, 0.05, "AXLE_F_REVERSE", false, true, modelFlagsTab)
			modelFlags[27] = emGUI:dxCreateCheckBox(0.5, 0.525, 0.2, 0.05, "AXLE_R_MCPHERSON", false, true, modelFlagsTab)
			modelFlags[28] = emGUI:dxCreateCheckBox(0.5, 0.575, 0.2, 0.05, "AXLE_R_REVERSE", false, true, modelFlagsTab)
			modelFlags[29] = emGUI:dxCreateCheckBox(0.5, 0.625, 0.2, 0.05, "IS_PLANE", false, true, modelFlagsTab)
			modelFlags[30] = emGUI:dxCreateCheckBox(0.5, 0.675, 0.2, 0.05, "IS_BOAT", false, true, modelFlagsTab)
			modelFlags[31] = emGUI:dxCreateCheckBox(0.5, 0.725, 0.2, 0.05, "FORCE_GROUND_CLEARANCE", false, true, modelFlagsTab)
			modelFlags[32] = emGUI:dxCreateCheckBox(0.5, 0.775, 0.2, 0.05, "IS_HATCHBACK", false, true, modelFlagsTab)

		handlingTab = emGUI:dxCreateTab("Handling Flags", settingsTabPanel)
			helpItems[5] = {}
			helpItems[5][1] = emGUI:dxCreateButton(0, 0.87, 1, 0.13, "Vehicle Handling Flags\n\n", true, handlingTab, _, _, _, _, _, _, tocolor(0, 0, 0, 180))
			emGUI:dxSetEnabled(helpItems[5][1], false)
			helpItems[5][2] = emGUI:dxCreateLabel(0.4, 0.935, 0.2, 0.05, "Change the handling flags of the vehicle.", true, handlingTab)
			emGUI:dxLabelSetHorizontalAlign(helpItems[5][2], "center")
			handlingFlags[1] = emGUI:dxCreateCheckBox(0.1, 0.025, 0.2, 0.05, "1G_BOOST", false, true, handlingTab)
			handlingFlags[2] = emGUI:dxCreateCheckBox(0.1, 0.075, 0.2, 0.05, "2G_BOOST", false, true, handlingTab)
			handlingFlags[3] = emGUI:dxCreateCheckBox(0.1, 0.125, 0.2, 0.05, "NO_HANDBRAKE", false, true, handlingTab)
			handlingFlags[4] = emGUI:dxCreateCheckBox(0.1, 0.175, 0.2, 0.05, "STEER_REARWHEELS", false, true, handlingTab)
			handlingFlags[5] = emGUI:dxCreateCheckBox(0.1, 0.225, 0.2, 0.05, "WHEEL_F_NARROW2", false, true, handlingTab)
			handlingFlags[6] = emGUI:dxCreateCheckBox(0.1, 0.275, 0.2, 0.05, "WHEEL_F_NARROW", false, true, handlingTab)
			handlingFlags[7] = emGUI:dxCreateCheckBox(0.1, 0.325, 0.2, 0.05, "WHEEL_R_NARROW2", false, true, handlingTab)
			handlingFlags[8] = emGUI:dxCreateCheckBox(0.1, 0.375, 0.2, 0.05, "WHEEL_R_NARROW", false, true, handlingTab)
			handlingFlags[9] = emGUI:dxCreateCheckBox(0.1, 0.425, 0.2, 0.05, "HYDRAULIC_GEOM", false, true, handlingTab)
			handlingFlags[10] = emGUI:dxCreateCheckBox(0.1, 0.475, 0.2, 0.05, "HYDRAULIC_INST", false, true, handlingTab)
			handlingFlags[11] = emGUI:dxCreateCheckBox(0.1, 0.525, 0.2, 0.05, "OFFROAD_ABILITY", false, true, handlingTab)
			handlingFlags[12] = emGUI:dxCreateCheckBox(0.1, 0.575, 0.2, 0.05, "OFFROAD_ABILITY2", false, true, handlingTab)
			handlingFlags[13] = emGUI:dxCreateCheckBox(0.1, 0.625, 0.2, 0.05, "USE_MAXSP_LIMIT", false, true, handlingTab)
			handlingFlags[14] = emGUI:dxCreateCheckBox(0.1, 0.675, 0.2, 0.05, "LOW_RIDER", false, true, handlingTab)
			handlingFlags[15] = emGUI:dxCreateCheckBox(0.1, 0.725, 0.2, 0.05, "SWINGING_CHASSIS", false, true, handlingTab)
			handlingFlags[16] = emGUI:dxCreateCheckBox(0.1, 0.775, 0.2, 0.05, "NPC_ANTI_ROLL", false, true, handlingTab)
			handlingFlags[17] = emGUI:dxCreateCheckBox(0.5, 0.025, 0.2, 0.05, "NPC_NEUTRAL_HANDLE", false, true, handlingTab)
			handlingFlags[18] = emGUI:dxCreateCheckBox(0.5, 0.075, 0.2, 0.05, "HB_REARWHEEL_STEER", false, true, handlingTab)
			handlingFlags[19] = emGUI:dxCreateCheckBox(0.5, 0.125, 0.2, 0.05, "ALT_STEER_OPT", false, true, handlingTab)
			handlingFlags[20] = emGUI:dxCreateCheckBox(0.5, 0.175, 0.2, 0.05, "WHEEL_F_WIDE", false, true, handlingTab)
			handlingFlags[21] = emGUI:dxCreateCheckBox(0.5, 0.225, 0.2, 0.05, "WHEEL_F_WIDE2", false, true, handlingTab)
			handlingFlags[22] = emGUI:dxCreateCheckBox(0.5, 0.275, 0.2, 0.05, "WHEEL_R_WIDE", false, true, handlingTab)
			handlingFlags[23] = emGUI:dxCreateCheckBox(0.5, 0.325, 0.2, 0.05, "WHEEL_R_WIDE2", false, true, handlingTab)
			handlingFlags[24] = emGUI:dxCreateCheckBox(0.5, 0.375, 0.2, 0.05, "HYDRAULIC_NONE", false, true, handlingTab)
			handlingFlags[25] = emGUI:dxCreateCheckBox(0.5, 0.425, 0.2, 0.05, "NOS_INST", false, true, handlingTab)
			handlingFlags[26] = emGUI:dxCreateCheckBox(0.5, 0.475, 0.2, 0.05, "HALOGEN_LIGHTS", false, true, handlingTab)
			handlingFlags[27] = emGUI:dxCreateCheckBox(0.5, 0.525, 0.2, 0.05, "PROC_REARWHEEL_1ST", false, true, handlingTab)
			handlingFlags[28] = emGUI:dxCreateCheckBox(0.5, 0.575, 0.2, 0.05, "STREET_RACER", false, true, handlingTab)

		otherTab = emGUI:dxCreateTab("Other", settingsTabPanel)
			vehEditorLabels[28] = emGUI:dxCreateLabel(0.04, 0.04, 0.45, 0.03, "FUEL CONSUMPTION", true, otherTab)
			emGUI:dxSetFont(vehEditorLabels[28], buttonFont_12)
			vehEditorLabels[29] = emGUI:dxCreateLabel(0.04, 0.1, 0.45, 0.03, [[The vehicle fuel consumption determines how fast the fuel
				in the vehicle depletes over time. Keep in mind that the
				consumption is also effected by the mass of the vehicle
				as well as the engine type.]], true, otherTab)
			vehEditorLabels[30] = emGUI:dxCreateLabel(0.04, 0.3, 0.23, 0.05, "Input fuel consumption:", true, otherTab)
			vehEditorLabels[31] = emGUI:dxCreateLabel(0.04, 0.38, 0.23, 0.05, "Vehicle Fuel Consumption (X/1km)\nPress calculate to determine fuel usage.", true, otherTab)
			vehEditorItems[28] = emGUI:dxCreateEdit(0.41, 0.298, 0.23, 0.05, vehicleData[3], true, otherTab)
			calculateConsumptionButton = emGUI:dxCreateButton(0.67, 0.272, 0.23, 0.1, "Calculate", true, otherTab)
			addEventHandler("onClientDgsDxMouseClick", calculateConsumptionButton, calculateConsumptionButtonClick)

			vehEditorLabels[32] = emGUI:dxCreateLabel(0.04, 0.59, 0.45, 0.03, "UNSET CUSTOM PROPERTIES", true, otherTab)
			emGUI:dxSetFont(vehEditorLabels[32], buttonFont_12)

			vehEditorLabels[33] = emGUI:dxCreateLabel(0.04, 0.65, 0.45, 0.03, [[If this vehicle has been modified specifically then it uses
				it's own handling information and properties whilst ignoring
				the original data from the vehicle library model that this
				vehicle replicates.]], true, otherTab)
			local unsetCustomButton = emGUI:dxCreateButton(0.14, 0.85, 0.7, 0.1, "UNSET CUSTOM PROPERTIES", true, otherTab)
			if not (vehicleData[2]) then emGUI:dxSetEnabled(unsetCustomButton, false) end
			local wantsReset = false
			addEventHandler("onClientDgsDxMouseClick", unsetCustomButton, function(b, c)
				if (b == "left") and (c == "down") then
					if (wantsReset) then
						triggerServerEvent("vehicle:modding:unsetcustom", localPlayer)
						emGUI:dxCloseWindow(vehicleEditorGUI)
						return
					end
					emGUI:dxSetText(unsetCustomButton, "Are you sure?")
					emGUI:dxButtonSetColor(unsetCustomButton, tocolor(255, 0, 0), tocolor(230, 0, 0), tocolor(200, 0, 0))
					wantsReset = true
					setTimer(function()
						if not emGUI:dxIsWindowVisible(vehicleEditorGUI) then return end
						emGUI:dxSetText(unsetCustomButton, "UNSET CUSTOM PROPERTIES")
						emGUI:dxButtonSetColor(unsetCustomButton)
						wantsReset = false
					end, 5000, 1)
				end
			end)

	for i = 1, #vehEditorLabels do
		if (i == 28) then break end
		emGUI:dxLabelSetHorizontalAlign(vehEditorLabels[i], "right")
	end

	saveEditButton = emGUI:dxCreateButton(0.688, 0.87, 0.29, 0.10, "SAVE", true, vehicleEditorGUI)
	addEventHandler("onClientDgsDxMouseClick", saveEditButton, applyEditButtonClick)
	applyEditButton = emGUI:dxCreateButton(0.36, 0.87, 0.29, 0.10, "APPLY\nCHANGES", true, vehicleEditorGUI)
	addEventHandler("onClientDgsDxMouseClick", applyEditButton, applyEditButtonClick)
	cancelEditButton = emGUI:dxCreateButton(0.03, 0.87, 0.29, 0.10, "DISCARD\nCHANGES", true, vehicleEditorGUI)
	addEventHandler("onClientDgsDxMouseClick", cancelEditButton, cancelEditButtonClick)

	addEventHandler("onClientElementDataChange", root, closeOnVehicleExit)
	addEventHandler("onClientDgsDxWindowClose", vehicleEditorGUI, function()
		removeEventHandler("onClientElementDataChange", root, closeOnVehicleExit)
		inputLabelEngine, inputLabelBody, inputLabelWheels, vehEditorLabels, vehEditorItems, modelFlags, handlingFlags, helpItems = nil, nil, nil, nil, nil, nil, nil, nil
	end)
end
addEvent("vehicle:modding:showVehicleEditor", true)
addEventHandler("vehicle:modding:showVehicleEditor", root, showVehicleEditorGUI)

local currentlyEditting = false
local hasAdjusted = false

function onButtonClickEngine(button, state)
	if (button == "left") and (state == "down") then
		if (currentlyEditting) then return end
		local buttonX, buttonY = emGUI:dxGetPosition(source, true)
		local buttonSX, buttonSY = emGUI:dxGetSize(source, true)
		local buttonText = emGUI:dxGetText(source)
		emGUI:dxSetVisible(source, false)

		if not (inputLabelEngine) then
			inputLabelEngine = emGUI:dxCreateEdit(buttonX, buttonY, buttonSX, buttonSY, buttonText, true, engineTab)
		else
			emGUI:dxSetPosition(inputLabelEngine, buttonX, buttonY, true)
			emGUI:dxSetVisible(inputLabelEngine, true)
			emGUI:dxSetText(inputLabelEngine, buttonText)
		end

		currentlyEditting = source
		addEventHandler("onClientKey", root, onEnterPress)
	end
end

function onButtonClickBody(button, state)
	if (button == "left") and (state == "down") then
		if (currentlyEditting) then return end
		local buttonX, buttonY = emGUI:dxGetPosition(source, true)
		local buttonSX, buttonSY = emGUI:dxGetSize(source, true)
		local buttonText = emGUI:dxGetText(source)
		emGUI:dxSetVisible(source, false)

		if not (inputLabelBody) then
			inputLabelBody = emGUI:dxCreateEdit(buttonX, buttonY, buttonSX, buttonSY, buttonText, true, bodyTab)
		else
			emGUI:dxSetPosition(inputLabelBody, buttonX, buttonY, true)
			emGUI:dxSetSize(inputLabelBody, buttonSX, buttonSY, true)
			emGUI:dxSetVisible(inputLabelBody, true)
			emGUI:dxSetText(inputLabelBody, buttonText)
		end

		currentlyEditting = source
		addEventHandler("onClientKey", root, onEnterPress)
	end
end

function onButtonClickWheels(button, state)
	if (button == "left") and (state == "down") then
		if (currentlyEditting) then return end
		local buttonX, buttonY = emGUI:dxGetPosition(source, true)
		local buttonSX, buttonSY = emGUI:dxGetSize(source, true)
		local buttonText = emGUI:dxGetText(source)
		emGUI:dxSetVisible(source, false)

		if not (inputLabelWheels) then
			inputLabelWheels = emGUI:dxCreateEdit(buttonX, buttonY, buttonSX, buttonSY, buttonText, true, wheelsTab)
		else
			emGUI:dxSetPosition(inputLabelWheels, buttonX, buttonY, true)
			emGUI:dxSetVisible(inputLabelWheels, true)
			emGUI:dxSetText(inputLabelWheels, buttonText)
		end

		currentlyEditting = source
		addEventHandler("onClientKey", root, onEnterPress)
	end
end

function onEnterPress(button, press)
	if (button == "enter") or (button == "num_enter") and press then
		if (currentlyEditting) then

			local newInput = 0
			if (emGUI:dxGetSelectedTab(settingsTabPanel) == engineTab) then
				newInput = emGUI:dxGetText(inputLabelEngine)
				emGUI:dxSetVisible(inputLabelEngine, false)
			elseif (emGUI:dxGetSelectedTab(settingsTabPanel) == bodyTab) then
				newInput = emGUI:dxGetText(inputLabelBody)
				emGUI:dxSetVisible(inputLabelBody, false)
			elseif (emGUI:dxGetSelectedTab(settingsTabPanel) == wheelsTab) then
				newInput = emGUI:dxGetText(inputLabelWheels)
				emGUI:dxSetVisible(inputLabelWheels, false)
			end

			emGUI:dxSetText(currentlyEditting, newInput)
			emGUI:dxSetVisible(currentlyEditting, true)
			currentlyEditting = false
			removeEventHandler("onClientKey", root, onEnterPress)
		else
			outputChatBox("ERROR: Select something to edit!", 255, 0, 0)
		end
	elseif (button == "lshift") and press then
		if (emGUI:dxGetSelectedTab(settingsTabPanel) == engineTab) then
			emGUI:dxSetVisible(inputLabelEngine, false)
		elseif (emGUI:dxGetSelectedTab(settingsTabPanel) == bodyTab) then
			emGUI:dxSetVisible(inputLabelBody, false)
		elseif (emGUI:dxGetSelectedTab(settingsTabPanel) == wheelsTab) then
			emGUI:dxSetVisible(inputLabelWheels, false)
		end

		emGUI:dxSetVisible(currentlyEditting, true)
		currentlyEditting = false
		removeEventHandler("onClientKey", root, onEnterPress)
	end
end

function closeOnVehicleExit(d)
	if getElementType(source) == "player" and (source == localPlayer) and (d == "character:invehicle") then
		if emGUI:dxIsWindowVisible(vehicleEditorGUI) then emGUI:dxCloseWindow(vehicleEditorGUI) end
		if emGUI:dxIsWindowVisible(edittingWindow) then emGUI:dxCloseWindow(edittingWindow) end
		local veh = getPedOccupiedVehicle(localPlayer)
		if veh then if (getElementData(veh, "vehicle:id") == 0) then destroyElement(veh) end end
		outputChatBox("Vehicle editing has been aborted.", 255, 0, 0)
	end
end

function handleValidation(z)
	local p = {}
	for i, x in ipairs(z) do
		if (i == 5) or (i == 6) or (i == 12) then
			table.insert(p, x)
		else
			if not tonumber(x) then
				return false, "All values must be input as numerical."
			else
				table.insert(p, tonumber(x))
			end
		end
	end

	if p[1] < 1 or p[1] > 5 then
		return false, "Number of gears must be between 1 and 5."
	end
	if p[2] < 0.1 or p[2] > 200000 then
		return false, "Max Veocity must be between 0.1 and 200,000."
	end
	if p[3] < 0 or p[3] > 100000 then
		return false, "Engine Acceleration must be between 0 and 100,000."
	end
	if p[4] < -1000 or p[4] > 1000 then
		return false, "Engine Inertia must be between -1000 and 1000."
	end
	if p[4] == 0 then
		return false, "Engine Inertia cannot be 0."
	end
	if p[7] < 0 or p[7] > 360 then
		return false, "Steering lock must be between 0 and 360."
	end
	if p[8] < 0 or p[8] > 10 then
		return false, "Collision Damage Multiplier must be between 0 and 10."
	end
	if p[9] < 1 or p[9] > 100000 then
		return false, "Mass must be between 1 and 100,000."
	end
	if p[10] < 0 or p[10] > 1000000 then
		return false, "Turn Mass must be between 0 and 1,000,000."
	end
	if p[11] < -200 or p[11] > 200 then
		return false, "Drag Coeffiency must be between -200 and 200."
	end
	for i, v in ipairs(p[12]) do
		if tonumber(v) < -10 or tonumber(v) > 10 then
			return false, "Center of mass must be between -10 and 10."
		end
	end
	if p[13] < 1 or p[13] > 99999 then
		return false, "Percent Submerged must be between 1 and 99,999."
	end
	if p[14] < 0 or p[14] > 50 then
		return false, "Animation group must be between 0 and 50."
	end
	if p[15] < -20 or p[15] > 20 then
		return false, "Seat offset position must be between -20 and 20."
	end
	if p[16] < -100000 or p[16] > 100000 then
		return false, "Traction multiplier must be between -100,000 and 100,000."
	end
	if p[17] < 0 or p[17] > 100 then
		return false, "Traction loss must be between 0 and 100."
	end
	if p[18] < 0 or p[18] > 1 then
		return false, "Traction bias must be between 0.0 and 1.0."
	end
	if p[19] < 0.1 or p[19] > 100000 then
		return false, "Brake deceleration must be between 0.1 and 100,000."
	end
	if p[20] < 0 or p[20] > 1 then
		return false, "Brake bias must be between 0.0 and 1.0."
	end
	if p[21] < 0 or p[21] > 100 then
		return false, "Suspenison Force Level must be between 0 and 100."
	end
	if p[22] < 0 or p[22] > 100 then
		return false, "Suspenison Damping Level must be between 0 and 100."
	end
	if p[23] < 0 or p[23] > 600 then
		return false, "Suspenison High Speed Damping must be between 0 and 100."
	end
	if p[24] < -50 or p[24] > 50 then
		return false, "Suspension Upper Limit must be between -50 and 50."
	end
	if p[25] < -50 or p[25] > 50 then
		return false, "Suspension Lower Limit must be between -50 and 50."
	end
	if p[24] == p[25] then
		return false, "Suspension Upper Limit cannot be the same as the Suspension Lower Limit."
	end
	if p[26] < 0 or p[26] > 30 then
		return false, "Suspension Anti Dive Multiplier must be between 0 and 30."
	end
	if p[27] < 0 or p[27] > 1 then
		return false, "Suspension Bias must be between 0 and 1."
	end
	if p[28] < 0 or p[28] > 500 then
		return false, "Fuel Consumption must be between 0 and 500."
	end
	return true
end

---------------------------------- Button Clicks ----------------------------------

function applyEditButtonClick(button, state)
	if (button == "left") and (state == "down") then
		local handlingTable = {}
		for i, element in ipairs(vehEditorItems) do
			local value = nil
			if (i == 5) then
				local selection = emGUI:dxComboBoxGetSelectedItem(vehEditorItems[5])
				if (selection == 1) then value = "awd"
					elseif (selection == 2) then value = "fwd"
					elseif (selection == 3) then value = "rwd"
				end
			elseif (i == 6) then
				local selection = emGUI:dxComboBoxGetSelectedItem(vehEditorItems[6])
				if (selection == 1) then value = "petrol"
					elseif (selection == 2) then value = "diesel"
					elseif (selection == 3) then value = "electric"
				end
			elseif (i == 12) then
				local comTable = emGUI:dxGetText(vehEditorItems[12][1]) .. "," .. emGUI:dxGetText(vehEditorItems[12][2]) .. "," .. emGUI:dxGetText(vehEditorItems[12][3])
				value = split(comTable, ",")
			else
				value = emGUI:dxGetText(element)
			end
			table.insert(handlingTable, value)
		end

		local fuelConsumption = emGUI:dxGetText(vehEditorItems[28]) or 1
		table.insert(handlingTable, fuelConsumption)

		local modelFlagsTable = {}
		for j, flag in ipairs(modelFlags) do
			local flagState = emGUI:dxCheckBoxGetSelected(flag)
			table.insert(modelFlagsTable, flagState)
		end

		local handlingFlagsTable = {}
		for k, flag in ipairs(handlingFlags) do
			local flagState = emGUI:dxCheckBoxGetSelected(flag)
			table.insert(handlingFlagsTable, flagState)
		end

		local theVehicle = getPedOccupiedVehicle(localPlayer)
		if not (theVehicle) then
			outputChatBox("ERROR: You need to be in a vehicle to apply changes!", 255, 0, 0)
			return
		end
		
		local validation, reason = handleValidation(handlingTable)
		if validation then
			if (source == saveEditButton) then
				triggerServerEvent("vehicle:modding:saveVehicleSettings", localPlayer, localPlayer, theVehicle, handlingTable, modelFlagsTable, handlingFlagsTable, c_fromCreation)
				emGUI:dxCloseWindow(vehicleEditorGUI)
				c_fromCreation = false
			else
				triggerServerEvent("vehicle:modding:applyVehicleSettings", localPlayer, theVehicle, handlingTable)
				outputChatBox("All vehicle changes have been applied.", 75, 230, 10)
				hasAdjusted = true
			end
		else
			outputChatBox("ERROR: " .. reason, 255, 0, 0)
		end
	end
end

function cancelEditButtonClick(button, state)
	if (button == "left") and (state == "down") then
		emGUI:dxCloseWindow(vehicleEditorGUI)
		if (hasAdjusted) and not (c_fromCreation) then
			local theVehicle = getPedOccupiedVehicle(localPlayer)
			if (theVehicle) then
				triggerServerEvent("vehicle:modding:discardVehicleChanges", localPlayer, localPlayer, theVehicle)
				outputChatBox("You have discarded all changes made to the vehicle.", 255, 0, 0)
				hasAdjusted = false
			end
		end
	end
end

function calculateConsumptionButtonClick(b, c)
	if (b == "left") and (c == "down") then
		local fc = emGUI:dxGetText(vehEditorItems[28]) or 1
		if (fc) and tonumber(fc) then
			fc = tonumber(fc)
			if (fc >= 0) and (fc <= 500) then
				local vehicleMass = emGUI:dxGetText(vehEditorItems[9])
				if not tonumber(vehicleMass) then outputChatBox("ERROR: Input a valid value for vehicle mass to calculate.", 255, 0, 0) return end
				
				local calculationString = "Vehicle Fuel Consumption (" .. fc .. "/km)"
				emGUI:dxSetText(vehEditorLabels[31], calculationString)

				local consumption = 0.820209975 + (vehicleMass / 20000)
				calculationString = calculationString .. "\nVehicle mass contribution: " .. consumption
				emGUI:dxSetText(vehEditorLabels[31], calculationString)

				local theVehicle = getPedOccupiedVehicle(localPlayer)
				local vehType = getElementData(theVehicle, "vehicle:type") or 20
				local tankSize = g_vehicleTypes[vehType]["tank"]
				calculationString = calculationString .. "\nVehicle tank size: " .. tankSize
				emGUI:dxSetText(vehEditorLabels[31], calculationString)

				local deduction = (((consumption / 100) * tankSize) * fc)
				calculationString = calculationString .. "\nTotal deduction: " .. deduction
				emGUI:dxSetText(vehEditorLabels[31], calculationString)
				return true
			end
		end
		emGUI:dxSetText(vehEditorLabels[31], "Fuel consumption must be between 0 and 500.")
		emGUI:dxLabelSetColor(vehEditorLabels[31], 255, 0, 0)
		setTimer(function()
			emGUI:dxLabelSetColor(vehEditorLabels[31], 255, 255, 255)
		end, 3000, 1)
	end
end