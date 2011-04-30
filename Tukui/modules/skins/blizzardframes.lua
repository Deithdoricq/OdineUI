local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

local function SetModifiedBackdrop(self)
	local color = RAID_CLASS_COLORS[T.myclass]
	self:SetBackdropBorderColor(color.r, color.g, color.b)
end

local function SetOriginalBackdrop(self)
	self:SetBackdropColor(unpack(C["media"].backdropcolor))
	self:SetBackdropBorderColor(unpack(C["media"].bordercolor))
end

local function SkinButton(f)
	if f:GetName() then
		local l = _G[f:GetName().."Left"]
		local m = _G[f:GetName().."Middle"]
		local r = _G[f:GetName().."Right"]
		
		
		if l then l:SetAlpha(0) end
		if m then m:SetAlpha(0) end
		if r then r:SetAlpha(0) end
	end
	
	if f.SetNormalTexture then
		f:SetNormalTexture("")
	end
	
	if f.SetHighlightTexture then
		f:SetHighlightTexture("")
	end
	
	if f.SetPushedTexture then
		f:SetPushedTexture("")
	end
	
	if f.SetDisabledTexture then
		f:SetDisabledTexture("")
	end
	f:SetTemplate("Default", true)
	
	f:HookScript("OnEnter", SetModifiedBackdrop)
	f:HookScript("OnLeave", SetOriginalBackdrop)
end

local function SkinScrollBar(texture)
	_G[texture.."BG"]:SetTexture(nil)
	_G[texture.."Top"]:SetTexture(nil)
	_G[texture.."Bottom"]:SetTexture(nil)
	_G[texture.."Middle"]:SetTexture(nil)
end

local TukuiSkin = CreateFrame("Frame")
TukuiSkin:RegisterEvent("ADDON_LOADED")
TukuiSkin:SetScript("OnEvent", function(self, event, addon)
	if IsAddOnLoaded("Skinner") or IsAddOnLoaded("Aurora") then return end
	
	if addon == "Blizzard_DebugTools" then
		local noscalemult = T.mult * C["general"].uiscale
		local bg = {
		  bgFile = C["media"].blank, 
		  edgeFile = C["media"].blank, 
		  tile = false, tileSize = 0, edgeSize = noscalemult, 
		  insets = { left = -noscalemult, right = -noscalemult, top = -noscalemult, bottom = -noscalemult}
		}
		
		ScriptErrorsFrame:SetBackdrop(bg)
		ScriptErrorsFrame:SetBackdropColor(unpack(C.media.backdropfadecolor))
		ScriptErrorsFrame:SetBackdropBorderColor(unpack(C.media.bordercolor))	

		EventTraceFrame:SetTemplate("Transparent")
		
		local texs = {
			"TopLeft",
			"TopRight",
			"Top",
			"BottomLeft",
			"BottomRight",
			"Bottom",
			"Left",
			"Right",
			"TitleBG",
			"DialogBG",
		}
		
		for i=1, #texs do
			_G["ScriptErrorsFrame"..texs[i]]:SetTexture(nil)
			_G["EventTraceFrame"..texs[i]]:SetTexture(nil)
		end
		
		local bg = {
		  bgFile = C["media"].normTex, 
		  edgeFile = C["media"].blank, 
		  tile = false, tileSize = 0, edgeSize = noscalemult, 
		  insets = { left = -noscalemult, right = -noscalemult, top = -noscalemult, bottom = -noscalemult}
		}
		
		for i=1, ScriptErrorsFrame:GetNumChildren() do
			local child = select(i, ScriptErrorsFrame:GetChildren())
			if child:GetObjectType() == "Button" and not child:GetName() then
				
				SkinButton(child)
				child:SetBackdrop(bg)
				child:SetBackdropColor(unpack(C.media.backdropcolor))
				child:SetBackdropBorderColor(unpack(C.media.bordercolor))	
			end
		end	
	end
	
	-- stuff not in Blizzard load-on-demand
	if addon == "Tukui" then
	
		--Character Frame
		do
			local slots = {
				"HeadSlot",
				"NeckSlot",
				"ShoulderSlot",
				"BackSlot",
				"ChestSlot",
				"ShirtSlot",
				"TabardSlot",
				"WristSlot",
				"HandsSlot",
				"WaistSlot",
				"LegsSlot",
				"FeetSlot",
				"Finger0Slot",
				"Finger1Slot",
				"Trinket0Slot",
				"Trinket1Slot",
				"MainHandSlot",
				"SecondaryHandSlot",
				"RangedSlot",
			}
			for _, slot in pairs(slots) do
				local icon = _G["Character"..slot.."IconTexture"]
				local slot = _G["Character"..slot]
				slot:StripTextures()
				slot:StyleButton(false)
				icon:SetTexCoord(.08, .92, .08, .92)
				icon:ClearAllPoints()
				icon:Point("TOPLEFT", 2, -2)
				icon:Point("BOTTOMRIGHT", -2, 2)
				
				slot:SetFrameLevel(slot:GetFrameLevel() + 2)
				slot:CreateBackdrop("Default")
				slot.backdrop:SetAllPoints()
			end
			
			--Strip Textures
			local charframe = {
				"CharacterFrame",
				"CharacterModelFrame",
				"CharacterFrameInset", 
				"CharacterStatsPane",
				"CharacterFrameInsetRight",
				"PaperDollSidebarTabs",
				"PaperDollEquipmentManagerPane",
				"PaperDollFrameItemFlyout",
			}
			
			--Swap item flyout frame (shown when holding alt over a slot)
			PaperDollFrameItemFlyout:HookScript("OnShow", function()
				PaperDollFrameItemFlyoutButtons:StripTextures()
				
				for i=1, PDFITEMFLYOUT_MAXITEMS do
					local button = _G["PaperDollFrameItemFlyoutButtons"..i]
					local icon = _G["PaperDollFrameItemFlyoutButtons"..i.."IconTexture"]
					if button then
						button:StyleButton(false)
						
						icon:SetTexCoord(.08, .92, .08, .92)
						button:GetNormalTexture():SetTexture(nil)
						
						icon:ClearAllPoints()
						icon:Point("TOPLEFT", 2, -2)
						icon:Point("BOTTOMRIGHT", -2, 2)	
						button:SetFrameLevel(button:GetFrameLevel() + 2)
						if not button.backdrop then
							button:CreateBackdrop("Default")
							button.backdrop:SetAllPoints()			
						end
					end
				end
			end)
			
			--Icon in upper right corner of character frame
			CharacterFramePortrait:Kill()
			CharacterModelFrame:CreateBackdrop("Default")

			local scrollbars = {
				"PaperDollTitlesPaneScrollBar",
				"PaperDollEquipmentManagerPaneScrollBar",
			}
			
			for _, texture in pairs(scrollbars) do
				SkinScrollBar(texture)
			end
			
			for _, object in pairs(charframe) do
				_G[object]:StripTextures()
			end
			
			--Titles
			PaperDollTitlesPane:HookScript("OnShow", function(self)
				for x, object in pairs(PaperDollTitlesPane.buttons) do
					object.BgTop:SetTexture(nil)
					object.BgBottom:SetTexture(nil)
					object.BgMiddle:SetTexture(nil)

					object.Check:SetTexture(nil)
					object.text:SetFont(C["media"].font, 10)
					object.text.SetFont = T.dummy
				end
			end)
			
			--Equipement Manager
			SkinButton(PaperDollEquipmentManagerPaneEquipSet)
			SkinButton(PaperDollEquipmentManagerPaneSaveSet)
			PaperDollEquipmentManagerPaneEquipSet:Width(PaperDollEquipmentManagerPaneEquipSet:GetWidth() - 8)
			PaperDollEquipmentManagerPaneSaveSet:Width(PaperDollEquipmentManagerPaneSaveSet:GetWidth() - 8)
			PaperDollEquipmentManagerPaneEquipSet:Point("TOPLEFT", PaperDollEquipmentManagerPane, "TOPLEFT", 8, 0)
			PaperDollEquipmentManagerPaneSaveSet:Point("LEFT", PaperDollEquipmentManagerPaneEquipSet, "RIGHT", 4, 0)
			PaperDollEquipmentManagerPaneEquipSet.ButtonBackground:SetTexture(nil)
			PaperDollEquipmentManagerPane:HookScript("OnShow", function(self)
				for x, object in pairs(PaperDollEquipmentManagerPane.buttons) do
					object.BgTop:SetTexture(nil)
					object.BgBottom:SetTexture(nil)
					object.BgMiddle:SetTexture(nil)

					object.Check:SetTexture(nil)
					object.icon:SetTexCoord(.08, .92, .08, .92)
					
					if not object.backdrop then
						object:CreateBackdrop("Default")
					end
					
					object.backdrop:Point("TOPLEFT", object.icon, "TOPLEFT", -2, 2)
					object.backdrop:Point("BOTTOMRIGHT", object.icon, "BOTTOMRIGHT", 2, -2)
					object.icon:SetParent(object.backdrop)

					--Making all icons the same size and position because otherwise BlizzardUI tries to attach itself to itself when it refreshes
					object.icon:SetPoint("LEFT", object, "LEFT", 4, 0)
					object.icon.SetPoint = T.dummy
					object.icon:Size(36, 36)
					object.icon.SetSize = T.dummy
				end
				GearManagerDialogPopup:StripTextures()
				GearManagerDialogPopup:SetTemplate("Transparent")
				GearManagerDialogPopup:Point("LEFT", PaperDollFrame, "RIGHT", 4, 0)
				GearManagerDialogPopupScrollFrame:StripTextures()
				GearManagerDialogPopupEditBox:StripTextures()
				GearManagerDialogPopupEditBox:SetTemplate("Default")
				SkinButton(GearManagerDialogPopupOkay)
				SkinButton(GearManagerDialogPopupCancel)
				
				for i=1, NUM_GEARSET_ICONS_SHOWN do
					local button = _G["GearManagerDialogPopupButton"..i]
					local icon = button.icon
					
					if button then
						button:StripTextures()
						button:StyleButton(true)
						
						icon:SetTexCoord(.08, .92, .08, .92)
						_G["GearManagerDialogPopupButton"..i.."Icon"]:SetTexture(nil)
						
						icon:ClearAllPoints()
						icon:Point("TOPLEFT", 2, -2)
						icon:Point("BOTTOMRIGHT", -2, 2)	
						button:SetFrameLevel(button:GetFrameLevel() + 2)
						if not button.backdrop then
							button:CreateBackdrop("Default")
							button.backdrop:SetAllPoints()			
						end
					end
				end
			end)
			
			--Tab Regions
			local tabs = {
				"LeftDisabled",
				"MiddleDisabled",
				"RightDisabled",
				"Left",
				"Middle",
				"Right",
			}
			
			--Handle Tabs at bottom of character frame
			for i=1, 4 do
				local tab = _G["CharacterFrameTab"..i]
				if tab then
					for _, object in pairs(tabs) do
						local tex = _G["CharacterFrameTab"..i..object]
						tex:SetTexture(nil)
					end
					tab:GetHighlightTexture():SetTexture(nil)
					tab.backdrop = CreateFrame("Frame", nil, tab)
					tab.backdrop:SetTemplate("Default")
					tab.backdrop:SetFrameLevel(tab:GetFrameLevel() - 1)
					tab.backdrop:Point("TOPLEFT", 10, -3)
					tab.backdrop:Point("BOTTOMRIGHT", -10, 3)
				end
			end
			
			--Buttons used to toggle between equipment manager, titles, and character stats
			local function FixSidebarTabCoords()
				for i=1, #PAPERDOLL_SIDEBARS do
					local tab = _G["PaperDollSidebarTab"..i]
					if tab then
						tab.Highlight:SetTexture(1, 1, 1, 0.3)
						tab.Highlight:Point("TOPLEFT", 3, -4)
						tab.Highlight:Point("BOTTOMRIGHT", -1, 0)
						tab.Hider:SetTexture(0.4,0.4,0.4,0.4)
						tab.Hider:Point("TOPLEFT", 3, -4)
						tab.Hider:Point("BOTTOMRIGHT", -1, 0)
						tab.TabBg:Kill()
						
						if i == 1 then
							for i=1, tab:GetNumRegions() do
								local region = select(i, tab:GetRegions())
								region:SetTexCoord(0.16, 0.86, 0.16, 0.86)
								region.SetTexCoord = T.dummy
							end
						end
						tab:CreateBackdrop("Default")
						tab.backdrop:Point("TOPLEFT", 1, -2)
						tab.backdrop:Point("BOTTOMRIGHT", 1, -2)	
					end
				end
			end
			hooksecurefunc("PaperDollFrame_UpdateSidebarTabs", FixSidebarTabCoords)
			
			--Stat panels, atm it looks like 7 is the max
			for i=1, 7 do
				_G["CharacterStatsPaneCategory"..i]:StripTextures()
			end
			
			--Reputation
			ReputationFrame:HookScript("OnShow", function()
				ReputationListScrollFrame:StripTextures()
				for i=1, GetNumFactions() do
					local statusbar = _G["ReputationBar"..i.."ReputationBar"]

					if statusbar then
						statusbar:SetStatusBarTexture(C["media"].normTex)
						
						if not statusbar.backdrop then
							statusbar:CreateBackdrop("Default")
						end
						
						_G["ReputationBar"..i.."Background"]:SetTexture(nil)
						_G["ReputationBar"..i.."LeftLine"]:SetTexture(nil)
						_G["ReputationBar"..i.."BottomLine"]:SetTexture(nil)
						_G["ReputationBar"..i.."ReputationBarHighlight1"]:SetTexture(nil)
						_G["ReputationBar"..i.."ReputationBarHighlight2"]:SetTexture(nil)	
						_G["ReputationBar"..i.."ReputationBarAtWarHighlight1"]:SetTexture(nil)
						_G["ReputationBar"..i.."ReputationBarAtWarHighlight2"]:SetTexture(nil)
						_G["ReputationBar"..i.."ReputationBarLeftTexture"]:SetTexture(nil)
						_G["ReputationBar"..i.."ReputationBarRightTexture"]:SetTexture(nil)
					end		
				end
				ReputationDetailFrame:StripTextures()
				ReputationDetailFrame:SetTemplate("Transparent")
				ReputationDetailFrame:Point("TOPLEFT", ReputationFrame, "TOPRIGHT", 4, -28)
			end)
			
			--Currency
			TokenFrame:HookScript("OnShow", function()
				for i=1, GetCurrencyListSize() do
					local button = _G["TokenFrameContainerButton"..i]

					button.highlight:Kill()
					button.categoryMiddle:Kill()	
					button.categoryLeft:Kill()	
					button.categoryRight:Kill()
					
					if button.icon then
						button.icon:SetTexCoord(.08, .92, .08, .92)
					end
				end
				TokenFramePopup:StripTextures()
				TokenFramePopup:SetTemplate("Transparent")
				TokenFramePopup:Point("TOPLEFT", TokenFrame, "TOPRIGHT", 4, -28)				
			end)
			
			--Pet
			PetModelFrame:CreateBackdrop("Default")
			PetPaperDollFrameExpBar:StripTextures()
			PetPaperDollFrameExpBar:SetStatusBarTexture(C["media"].normTex)
			PetPaperDollFrameExpBar:CreateBackdrop("Default")
		end
	
		-- Blizzard frame we want to reskin
		local skins = {
			"StaticPopup1",
			"StaticPopup2",
			"StaticPopup3",
			"GameMenuFrame",
			"InterfaceOptionsFrame",
			"VideoOptionsFrame",
			"AudioOptionsFrame",
			"LFDDungeonReadyStatus",
			"BNToastFrame",
			"TicketStatusFrameButton",
			"DropDownList1MenuBackdrop",
			"DropDownList2MenuBackdrop",
			"DropDownList1Backdrop",
			"DropDownList2Backdrop",
			"LFDSearchStatus",
			"AutoCompleteBox",
			"ConsolidatedBuffsTooltip",
			"ReadyCheckFrame",
			"StackSplitFrame",
			"CharacterFrame",
		}
		
		for i = 1, getn(skins) do
			_G[skins[i]]:SetTemplate("Transparent")
			if _G[skins[i]] ~= _G["AutoCompleteBox"] and _G[skins[i]] ~= _G["BNToastFrame"] then -- frame to blacklist from create shadow function
				_G[skins[i]]:CreateShadow("Default")
			end
		end
		
		local ChatMenus = {
			"ChatMenu",
			"EmoteMenu",
			"LanguageMenu",
			"VoiceMacroMenu",
		}
 
		for i = 1, getn(ChatMenus) do
			if _G[ChatMenus[i]] == _G["ChatMenu"] then
				_G[ChatMenus[i]]:HookScript("OnShow", function(self) self:SetTemplate("Default", true) self:SetBackdropColor(unpack(C["media"].backdropfadecolor)) self:ClearAllPoints() self:SetPoint("BOTTOMLEFT", ChatFrame1, "TOPLEFT", 0, T.Scale(30)) end)
			else
				_G[ChatMenus[i]]:HookScript("OnShow", function(self) self:SetTemplate("Default", true) self:SetBackdropColor(unpack(C["media"].backdropfadecolor)) end)
			end
		end
		
		-- reskin popup buttons
		for i = 1, 2 do
			for j = 1, 3 do
				SkinButton(_G["StaticPopup"..i.."Button"..j])
			end
		end
		
		-- reskin all esc/menu buttons
		local BlizzardMenuButtons = {
			"Options", 
			"SoundOptions", 
			"UIOptions", 
			"Keybindings", 
			"Macros",
			"Ratings",
			"AddOns", 
			"Logout", 
			"Quit", 
			"Continue", 
			"MacOptions",
			"Help"
		}
		
		for i = 1, getn(BlizzardMenuButtons) do
			local TukuiMenuButtons = _G["GameMenuButton"..BlizzardMenuButtons[i]]
			if TukuiMenuButtons then
				SkinButton(TukuiMenuButtons)
			end
		end
		
		-- skin return to graveyard button
		do
			SkinButton(GhostFrame)
			GhostFrame:SetBackdropColor(0,0,0,0)
			GhostFrame:SetBackdropBorderColor(0,0,0,0)
			GhostFrame.SetBackdropColor = T.dummy
			GhostFrame.SetBackdropBorderColor = T.dummy
			GhostFrame:ClearAllPoints()
			GhostFrame:SetPoint("TOP", UIParent, "TOP", 0, -75)
			SkinButton(GhostFrameContentsFrame)
			GhostFrameContentsFrameIcon:SetTexture(nil)
			local x = CreateFrame("Frame", nil, GhostFrame)
			x:SetFrameStrata("MEDIUM")
			x:SetTemplate("Default")
			x:SetPoint("TOPLEFT", GhostFrameContentsFrameIcon, "TOPLEFT", T.Scale(-2), T.Scale(2))
			x:SetPoint("BOTTOMRIGHT", GhostFrameContentsFrameIcon, "BOTTOMRIGHT", T.Scale(2), T.Scale(-2))
			local tex = x:CreateTexture(nil, "OVERLAY")
			tex:SetTexture("Interface\\Icons\\spell_holy_guardianspirit")
			tex:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			tex:SetPoint("TOPLEFT", x, "TOPLEFT", T.Scale(2), T.Scale(-2))
			tex:SetPoint("BOTTOMRIGHT", x, "BOTTOMRIGHT", T.Scale(-2), T.Scale(2))
		end
		
		-- hide header textures and move text/buttons.
		local BlizzardHeader = {
			"GameMenuFrame", 
			"InterfaceOptionsFrame", 
			"AudioOptionsFrame", 
			"VideoOptionsFrame"
		}
		
		for i = 1, getn(BlizzardHeader) do
			local title = _G[BlizzardHeader[i].."Header"]			
			if title then
				title:SetTexture("")
				title:ClearAllPoints()
				if title == _G["GameMenuFrameHeader"] then
					title:SetPoint("TOP", GameMenuFrame, 0, 7)
				else
					title:SetPoint("TOP", BlizzardHeader[i], 0, 0)
				end
			end
		end
		
		-- here we reskin all "normal" buttons
		local BlizzardButtons = {
			"VideoOptionsFrameOkay", 
			"VideoOptionsFrameCancel", 
			"VideoOptionsFrameDefaults", 
			"VideoOptionsFrameApply", 
			"AudioOptionsFrameOkay", 
			"AudioOptionsFrameCancel", 
			"AudioOptionsFrameDefaults", 
			"InterfaceOptionsFrameDefaults", 
			"InterfaceOptionsFrameOkay", 
			"InterfaceOptionsFrameCancel",
			"ReadyCheckFrameYesButton",
			"ReadyCheckFrameNoButton",
			"StackSplitOkayButton",
			"StackSplitCancelButton",
			"RolePollPopupAcceptButton"
		}
		
		for i = 1, getn(BlizzardButtons) do
		local TukuiButtons = _G[BlizzardButtons[i]]
			if TukuiButtons then
				SkinButton(TukuiButtons)
			end
		end
		
		-- if a button position or text is not really where we want, we move it here
		_G["VideoOptionsFrameCancel"]:ClearAllPoints()
		_G["VideoOptionsFrameCancel"]:SetPoint("RIGHT",_G["VideoOptionsFrameApply"],"LEFT",-4,0)		 
		_G["VideoOptionsFrameOkay"]:ClearAllPoints()
		_G["VideoOptionsFrameOkay"]:SetPoint("RIGHT",_G["VideoOptionsFrameCancel"],"LEFT",-4,0)	
		_G["AudioOptionsFrameOkay"]:ClearAllPoints()
		_G["AudioOptionsFrameOkay"]:SetPoint("RIGHT",_G["AudioOptionsFrameCancel"],"LEFT",-4,0)
		_G["InterfaceOptionsFrameOkay"]:ClearAllPoints()
		_G["InterfaceOptionsFrameOkay"]:SetPoint("RIGHT",_G["InterfaceOptionsFrameCancel"],"LEFT", -4,0)
		_G["ReadyCheckFrameYesButton"]:SetParent(_G["ReadyCheckFrame"])
		_G["ReadyCheckFrameNoButton"]:SetParent(_G["ReadyCheckFrame"]) 
		_G["ReadyCheckFrameYesButton"]:SetPoint("RIGHT", _G["ReadyCheckFrame"], "CENTER", -1, 0)
		_G["ReadyCheckFrameNoButton"]:SetPoint("LEFT", _G["ReadyCheckFrameYesButton"], "RIGHT", 3, 0)
		_G["ReadyCheckFrameText"]:SetParent(_G["ReadyCheckFrame"])	
		_G["ReadyCheckFrameText"]:ClearAllPoints()
		_G["ReadyCheckFrameText"]:SetPoint("TOP", 0, -12)	
		
		-- others
		_G["ReadyCheckListenerFrame"]:SetAlpha(0)
		_G["ReadyCheckFrame"]:HookScript("OnShow", function(self) if UnitIsUnit("player", self.initiator) then self:Hide() end end) -- bug fix, don't show it if initiator
		_G["StackSplitFrame"]:GetRegions():Hide()
		_G["StaticPopup1EditBoxLeft"]:SetTexture(nil)
		_G["StaticPopup1EditBoxMid"]:SetTexture(nil)
		_G["StaticPopup1EditBoxRight"]:SetTexture(nil)
		
		--Create backdrop for static popup editbox	
		local bg = CreateFrame("Frame", nil, StaticPopup1EditBox)
		bg:Point("TOPLEFT", StaticPopup1EditBox, "TOPLEFT", -2, -2)
		bg:Point("BOTTOMRIGHT", StaticPopup1EditBox, "BOTTOMRIGHT", 2, 2)
		bg:SetFrameLevel(StaticPopup1EditBox:GetFrameLevel())
		bg:SetTemplate("Default")
		
		RolePollPopup:SetTemplate("Transparent")
		RolePollPopup:CreateShadow("Default")
		LFDDungeonReadyDialog:SetTemplate("Transparent")
		LFDDungeonReadyDialog:CreateShadow("Default")
		SkinButton(LFDDungeonReadyDialogEnterDungeonButton)
		SkinButton(LFDDungeonReadyDialogLeaveQueueButton)
	end
	
	-- mac menu/option panel, made by affli.
	if IsMacClient() then
		-- Skin main frame and reposition the header
		MacOptionsFrame:SetTemplate("Default", true)
		MacOptionsFrameHeader:SetTexture("")
		MacOptionsFrameHeader:ClearAllPoints()
		MacOptionsFrameHeader:SetPoint("TOP", MacOptionsFrame, 0, 0)
 
		--Skin internal frames
		MacOptionsFrameMovieRecording:SetTemplate("Default", true)
		MacOptionsITunesRemote:SetTemplate("Default", true)
 
		--Skin buttons
		SkinButton(_G["MacOptionsFrameCancel"])
		SkinButton(_G["MacOptionsFrameOkay"])
		SkinButton(_G["MacOptionsButtonKeybindings"])
		SkinButton(_G["MacOptionsFrameDefaults"])
		SkinButton(_G["MacOptionsButtonCompress"])
 
		--Reposition and resize buttons
		local tPoint, tRTo, tRP, tX, tY =  _G["MacOptionsButtonCompress"]:GetPoint()
		_G["MacOptionsButtonCompress"]:SetWidth(136)
		_G["MacOptionsButtonCompress"]:ClearAllPoints()
		_G["MacOptionsButtonCompress"]:Point(tPoint, tRTo, tRP, 4, tY)
 
		_G["MacOptionsFrameCancel"]:SetWidth(96)
		_G["MacOptionsFrameCancel"]:SetHeight(22)
		tPoint, tRTo, tRP, tX, tY =  _G["MacOptionsFrameCancel"]:GetPoint()
		_G["MacOptionsFrameCancel"]:ClearAllPoints()
		_G["MacOptionsFrameCancel"]:Point(tPoint, tRTo, tRP, -14, tY)
 
		_G["MacOptionsFrameOkay"]:ClearAllPoints()
		_G["MacOptionsFrameOkay"]:SetWidth(96)
		_G["MacOptionsFrameOkay"]:SetHeight(22)
		_G["MacOptionsFrameOkay"]:Point("LEFT",_G["MacOptionsFrameCancel"],-99,0)
 
		_G["MacOptionsButtonKeybindings"]:ClearAllPoints()
		_G["MacOptionsButtonKeybindings"]:SetWidth(96)
		_G["MacOptionsButtonKeybindings"]:SetHeight(22)
		_G["MacOptionsButtonKeybindings"]:Point("LEFT",_G["MacOptionsFrameOkay"],-99,0)
 
		_G["MacOptionsFrameDefaults"]:SetWidth(96)
		_G["MacOptionsFrameDefaults"]:SetHeight(22)
		
		-- why these buttons is using game menu template? oO
		_G["MacOptionsButtonCompressLeft"]:SetAlpha(0)
		_G["MacOptionsButtonCompressMiddle"]:SetAlpha(0)
		_G["MacOptionsButtonCompressRight"]:SetAlpha(0)
		_G["MacOptionsButtonKeybindingsLeft"]:SetAlpha(0)
		_G["MacOptionsButtonKeybindingsMiddle"]:SetAlpha(0)
		_G["MacOptionsButtonKeybindingsRight"]:SetAlpha(0)
	end
end)
