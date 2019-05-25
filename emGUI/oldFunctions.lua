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

-- This file redirects all of the old functions from emGUI v1.0 into the newer version. Only temporary and older functions will become depreciated.
-- Compiled events.luac is a workaround for having two separate files though considered as the same path to handle this efficiently.

addEvent("onClientDgsDxMouseLeave", true)
addEvent("onClientDgsDxMouseEnter", true)
addEvent("onClientDgsDxMouseClick", true)
addEvent("onClientDgsDxMouseDoubleClick", true)
addEvent("onClientDgsDxWindowClose", true)
addEvent("onClientDgsDxGUIPositionChange", true)
addEvent("onClientDgsDxGUISizeChange", true)
addEvent("onClientDgsDxGUITextChange", true)
addEvent("onClientDgsDxScrollBarScrollPositionChange", true)
addEvent("onClientDgsDxGUIDestroy", true)
addEvent("onClientDgsDxGridListSelect", true)
addEvent("onClientDgsDxGridListItemDoubleClick", true)
addEvent("onClientDgsDxProgressBarChange", true)
addEvent("onClientDgsDxGUICreate", true)
addEvent("onClientDgsDxGUIPreCreate", true)
addEvent("onClientDgsDxPreRender", true)
addEvent("onClientDgsDxRender", true)
addEvent("onClientDgsDxFocus", true)
addEvent("onClientDgsDxBlur", true)
addEvent("onClientDgsDxGUICursorMove", true)
addEvent("onClientDgsDxTabPanelTabSelect", true)
addEvent("onClientDgsDxRadioButtonChange", true)
addEvent("onClientDgsDxCheckBoxChange", true)
addEvent("onClientDgsDxComboBoxSelect", true)
addEvent("onClientDgsDxComboBoxStateChange", true)
addEvent("onClientDgsDxEditPreSwitch", true)
addEvent("onClientDgsDxEditSwitched", true)

transfer = {}
transfer["onDgsMouseLeave"] = "onClientDgsDxMouseLeave"
transfer["onDgsMouseEnter"] = "onClientDgsDxMouseEnter"
transfer["onDgsMouseClick"] = "onClientDgsDxMouseClick"
transfer["onDgsMouseDoubleClick"] = "onClientDgsDxMouseDoubleClick"
transfer["onDgsPositionChange"] = "onClientDgsDxGUIPositionChange"
transfer["onDgsSizeChange"] = "onClientDgsDxGUISizeChange"
transfer["onDgsTextChange"] = "onClientDgsDxGUITextChange"
transfer["onDgsScrollBarScrollPositionChange"] = "onClientDgsDxScrollBarScrollPositionChange"
transfer["onDgsDestroy"] = "onClientDgsDxGUIDestroy"
transfer["ondxGridListSelect"] = "onClientDgsDxGridListSelect"
transfer["ondxGridListItemDoubleClick"] = "onClientDgsDxGridListItemDoubleClick"
transfer["ondxProgressBarChange"] = "onClientDgsDxProgressBarChange"
transfer["onDgsCreate"] = "onClientDgsDxGUICreate"
transfer["onDgsPreCreate"] = "onClientDgsDxGUIPreCreate"
transfer["onDgsPreRender"] = "onClientDgsDxPreRender"
transfer["onDgsRender"] = "onClientDgsDxRender"
transfer["onDgsFocus"] = "onClientDgsDxFocus"
transfer["onDgsBlur"] = "onClientDgsDxBlur"
transfer["onDgsCursorMove"] = "onClientDgsDxGUICursorMove"
transfer["onDgsTabPanelTabSelect"] = "onClientDgsDxTabPanelTabSelect"
transfer["onDgsRadioButtonChange"] = "onClientDgsDxRadioButtonChange"
transfer["onDgsCheckBoxChange"] = "onClientDgsDxCheckBoxChange"
transfer["onDgsComboBoxSelect"] = "onClientDgsDxComboBoxSelect"
transfer["onDgsComboBoxStateChange"] = "onClientDgsDxComboBoxStateChange"
transfer["onDgsEditPreSwitch"] = "onClientDgsDxEditPreSwitch"
transfer["onDgsEditSwitched"] = "onClientDgsDxEditSwitched"

function eventTransfer(...)
	if transfer[eventName] then
		if isElement(source) then
			triggerEvent(transfer[eventName], source, ...)
		end
	end
end
addEventHandler("onDgsMouseLeave", root, eventTransfer)
addEventHandler("onDgsMouseEnter", root, eventTransfer)
addEventHandler("onDgsMouseClick", root, eventTransfer)
addEventHandler("onDgsMouseDoubleClick", root, eventTransfer)
addEventHandler("onDgsWindowClose", root, eventTransfer)
addEventHandler("onDgsPositionChange", root, eventTransfer)
addEventHandler("onDgsSizeChange", root, eventTransfer)
addEventHandler("onDgsTextChange", root, eventTransfer)
addEventHandler("onDgsScrollBarScrollPositionChange", root, eventTransfer)
addEventHandler("onDgsDestroy", root, eventTransfer)
addEventHandler("ondxGridListSelect", root, eventTransfer)
addEventHandler("ondxGridListItemDoubleClick", root, eventTransfer)
addEventHandler("ondxProgressBarChange", root, eventTransfer)
addEventHandler("onDgsCreate", root, eventTransfer)
addEventHandler("onDgsPreCreate", root, eventTransfer)
addEventHandler("onDgsPreRender", root, eventTransfer)
addEventHandler("onDgsRender", root, eventTransfer)
addEventHandler("onDgsFocus", root, eventTransfer)
addEventHandler("onDgsBlur", root, eventTransfer)
addEventHandler("onDgsCursorMove", root, eventTransfer)
addEventHandler("onDgsTabPanelTabSelect", root, eventTransfer)
addEventHandler("onDgsRadioButtonChange", root, eventTransfer)
addEventHandler("onDgsCheckBoxChange", root, eventTransfer)
addEventHandler("onDgsComboBoxSelect", root, eventTransfer)
addEventHandler("onDgsComboBoxStateChange", root, eventTransfer)
addEventHandler("onDgsEditPreSwitch", root, eventTransfer)
addEventHandler("onDgsEditSwitched", root, eventTransfer)

-- Transfer to new functions from old dgs dudes resource
dgsDxGUIGetProperty = dxGetProperty
dgsDxGUISetProperty = dxSetProperty
dgsDxGUIGetProperties = dxGetProperties
dgsDxGUISetProperties = dxSetProperties
dgsDxGUIGetVisible = dxGetVisible
dgsDxGUISetVisible = dxSetVisible
dgsDxGUIGetEnabled = dxGetEnabled
dgsdxSetEnabled = dxSetEnabled
dgsDxGUIGetSide = dxGetSide
dgsDxGUISetSide = dxSetSide
dgsDxGUIGetAlpha = dxGetAlpha
dgsdxSetAlpha = dxSetAlpha
dgsDxGUIGetFont = dxGetFont
dgsDxGUISetFont = dxSetFont
dgsdxSetText = dxSetText
dgsdxGetText = dxGetText
dgsDxGUICreateFont = dxCreateNewFont
dgsDxGUIBringToFront = dxBringToFront
dgsDxCreateWindow = dxCreateWindow
dgsDxWindowSetSizable = dxWindowSetSizable
dgsDxWindowSetMovable = dxWindowSetMovable
dgsdxCloseWindow = dxCloseWindow
dgsDxWindowSetCloseButtonEnabled = dxWindowSetCloseButtonEnabled
dgsDxWindowGetCloseButtonEnabled = dxWindowGetCloseButtonEnabled
dgsDxCreateScrollPane = dxCreateScrollPane
dgsDxScrollPaneGetScrollBar = dxScrollPaneGetScrollBar
dgsDxCreateRadioButton = dxCreateRadioButton
dgsDxRadioButtonGetSelected = dxRadioButtonGetSelected
dgsDxRadioButtonSetSelected = dxRadioButtonSetSelected
dgsDxCreateCheckBox = dxCreateCheckBox
dgsDxCheckBoxGetSelected = dxCheckBoxGetSelected
dgsDxCheckBoxSetSelected = dxCheckBoxSetSelected
dgsDxCreateComboBox = dxCreateComboBox
dgsDxComboBoxAddItem = dxComboBoxAddItem
dgsDxComboBoxRemoveItem = dxComboBoxRemoveItem
dgsDxComboBoxSetItemText = dxComboBoxSetItemText
dgsDxComboBoxGetItemText = dxComboBoxGetItemText
dgsDxComboBoxClear = dxComboBoxClear
dgsDxComboBoxSetSelectedItem = dxComboBoxSetSelectedItem
dgsDxComboBoxGetSelectedItem = dxComboBoxGetSelectedItem
dgsDxComboBoxSetItemColor = dxComboBoxSetItemColor
dgsDxComboBoxGetItemColor = dxComboBoxGetItemColor
dgsDxComboBoxSetState = dxComboBoxSetState
dgsDxComboBoxGetState = dxComboBoxGetState
dgsDxComboBoxSetBoxHeight = dxComboBoxSetBoxHeight
dgsDxComboBoxGetBoxHeight = dxComboBoxGetBoxHeight
dgsDxComboBoxGetScrollBar = dxComboBoxGetScrollBar
dgsDxCreateButton = dxCreateButton
dgsemDxCreateCmd = emDxCreateCmd
dgsemDxCmdSetMode = emDxCmdSetMode
dgsemDxEventCmdSetPreName = emDxEventCmdSetPreName
dgsDxCmdGetEdit = emDxCmdGetEdit
dgsDxCmdAddEventToWhiteList = emDxCmdAddEventToWhiteList
dgsDxCmdRemoveEventFromWhiteList = emDxCmdRemoveEventFromWhiteList
dgsDxCmdRemoveAllEvents = emDxCmdRemoveAllEvents
dgsDxCmdIsInWhiteList = emDxCmdIsInWhiteList
dgsDxCmdAddCommandHandler = emDxCmdAddCommandHandler
dgsDxCmdRemoveCommandHandler = emDxCmdRemoveCommandHandler
dgsDxCmdClearText = emDxCmdClearText
dgsDxCreateEdit = dxCreateEdit
dgsDxEditMoveCaret = dxEditMoveCaret
dgsDxEditGetCaretPosition = dxEditGetCaretPosition
dgsDxEditSetCaretPosition = dxEditSetCaretPosition
dgsDxEditGetCaretStyle = dxEditGetCaretStyle
dgsDxEditSetCaretStyle = dxEditSetCaretStyle
dgsDxEditSetWhiteList = dxEditSetWhiteList
dgsDxEditGetMaxLength = dxEditGetMaxLength
dgsDxEditSetMaxLength = dxEditSetMaxLength
dgsDxEditSetReadOnly = dxEditSetReadOnly
dgsDxEditGetReadOnly = dxEditGetReadOnly
dgsDxEditSetMasked = dxEditSetMasked
dgsDxEditGetMasked = dxEditGetMasked
dgsDxCreateMemo = dxCreateMemo
dgsDxMemoMoveCaret = dxMemoMoveCaret
dgsDxMemoSeekPosition = dxMemoSeekPosition
dgsDxMemoSetCaretPosition = dxMemoSetCaretPosition
dgsDxMemoGetCaretPosition = dxMemoGetCaretPosition
dgsDxMemoSetCaretStyle = dxMemoSetCaretStyle
dgsDxMemoGetCaretStyle = dxMemoGetCaretStyle
dgsDxMemoSetReadOnly = dxMemoSetReadOnly
dgsDxMemoGetReadOnly = dxMemoGetReadOnly
dgsDxMemoGetPartOfText = dxMemoGetPartOfText
dgsDxMemoDeleteText = dxMemoDeleteText
dgsDxMemoInsertText = dxMemoInsertText
dgsDxMemoGetScrollBar = dxMemoGetScrollBar
dgsDxCreateImage = dxCreateImage
dgsDxImageSetImage = dxImageSetImage
dgsDxImageGetImage = dxImageGetImage
dgsDxImageSetImageSize = dxImageSetImageSize
dgsDxImageGetImageSize = dxImageGetImageSize
dgsDxImageSetImagePosition = dxImageSetImagePosition
dgsDxImageGetImagePosition = dxImageGetImagePosition
dgsDxCreateProgressBar = dxCreateProgressBar
dgsDxProgressBarGetProgress = dxProgressBarGetProgress
dgsDxProgressBarSetProgress = dxProgressBarSetProgress
dgsDxProgressBarGetMode = dxProgressBarGetMode
dgsDxProgressBarSetMode = dxProgressBarSetMode
dgsDxProgressBarGetUpDownDistance = dxProgressBarGetUpDownDistance
dgsDxProgressBarSetUpDownDistance = dxProgressBarSetUpDownDistance
dgsDxProgressBarGetLeftRightDistance = dxProgressBarGetLeftRightDistance
dgsDxProgressBarSetLeftRightDistance = dxProgressBarSetLeftRightDistance
dgsDxCreateLabel = dxCreateLabel
dgsDxLabelGetColor = dxLabelGetColor
dgsDxLabelSetColor = dxLabelSetColor
dgsDxLabelSetHorizontalAlign = dxLabelSetHorizontalAlign
dgsDxLabelSetVerticalAlign = dxLabelSetVerticalAlign
dgsDxLabelGetHorizontalAlign = dxLabelGetHorizontalAlign
dgsDxLabelGetVerticalAlign = dxLabelGetVerticalAlign
dgsDxCreateTabPanel = dxCreateTabPanel
dgsDxCreateTab = dxCreateTab
dgsDxTabPanelGetTabFromID = dxTabPanelGetTabFromID
dgsDxTabPanelMoveTab = dxTabPanelMoveTab
dgsDxTabPanelGetTabID = dxTabPanelGetTabID
dgsDxDeleteTab = dxDeleteTab
dgsDxCreateScrollBar = dxCreateScrollBar
dgsDxScrollBarSetScrollBarPosition = dxScrollBarSetScrollBarPosition
dgsDxScrollBarGetScrollBarPosition = dxScrollBarGetScrollBarPosition
dgsDxScrollBarSetColor = dxScrollBarSetColor
dgsDxCreateGridList = dxCreateGridList
dgsDxScrollPaneGetScrollBar = dxScrollPaneGetScrollBar
dgsDxGridListResetScrollBarPosition = dxGridListResetScrollBarPosition
dgsDxGridListSetColumnRelative = dxGridListSetColumnRelative
dgsDxGridListGetColumnRelative = dxGridListGetColumnRelative
dgsDxGridListAddColumn = dxGridListAddColumn
dgsDxGridListGetColumnCount = dxGridListGetColumnCount
dgsDxGridListRemoveColumn = dxGridListRemoveColumn
dgsDxGridListGetColumnAllLength = dxGridListGetColumnAllLength
dgsDxGridListGetColumnLength = dxGridListGetColumnLength
dgsDxGridListGetColumnTitle = dxGridListGetColumnTitle
dgsDxGridListSetColumnTitle = dxGridListSetColumnTitle
dgsDxGridListAddRow = dxGridListAddRow
dgsDxGridListRemoveRow = dxGridListRemoveRow
dgsDxGridListClearRow = dxGridListClearRow
dgsDxGridListGetRowCount = dxGridListGetRowCount
dgsDxGridListSetItemText = dxGridListSetItemText
dgsDxGridListGetItemText = dxGridListGetItemText
dgsDxGridListGetSelectedItem = dxGridListGetSelectedItem
dgsDxGridListSetSelectedItem = dxGridListSetSelectedItem
dgsDxGridListSetItemColor = dxGridListSetItemColor
dgsDxGridListGetItemColor = dxGridListGetItemColor
dgsDxGridListGetRowBackGroundImage = dxGridListGetRowBackGroundImage
dgsDxGridListSetRowBackGroundImage = dxGridListSetRowBackGroundImage
dgsDxGridListSetRowBackGroundColor = dxGridListSetRowBackGroundColor
dgsDxGridListGetRowBackGroundColor = dxGridListGetRowBackGroundColor
dgsDxGridListGetItemData = dxGridListGetItemData
dgsDxGridListSetItemData = dxGridListSetItemData
dgsDxGridListSetRowAsSection = dxGridListSetRowAsSection
dgsDxCreateEDA = dxCreateEDA
dgsDxEDASetDebugModeEnabled = dxEDASetDebugModeEnabled
dgsDxEDAGetDebugModeEnabled = dxEDAGetDebugModeEnabled
dgsDxGridListGetItemImage = dxGridListGetItemImage
dgsDxGridListSetItemImage = dxGridListSetItemImage
dgsDxGridListRemoveItemImage = dxGridListRemoveItemImage
dgsDxGetMouseEnterGUI = dxGetMouseEnterGUI
