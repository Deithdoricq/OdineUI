local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales	

-- all the frame we want to move
-- all our frames that we want being movable.
T.MoverFrames = {
	TukuiMinimap,
	TukuiTooltipAnchor,
	TukuiPlayerBuffs,
	TukuiPlayerDebuffs,
	TukuiShiftBar,
	TukuiRollAnchor,
	TukuiAchievementHolder,
	TukuiWatchFrameAnchor,
	TukuiGMFrameAnchor,
	TukuiVehicleAnchor,
	TukuiWorldStateAnchor
}

-- used to exec various code if we enable or disable moving
function T.exec(self, enable)

	if self == TukuiGMFrameAnchor then
		if enable then
			self:Show()
		else
			self:Hide()
		end
	end
	
	if self == TukuiMinimap then
		if enable then 
			Minimap:Hide()
			self:SetBackdropBorderColor(1,0,0,1)
		else 
			Minimap:Show()
			self:SetBackdropBorderColor(unpack(C.media.bordercolor))
		end
	end
	
	if self == TukuiPlayerBuffs or self == TukuiPlayerDebuffs then
		if enable then
			self:SetBackdropColor(unpack(C.media.backdropcolor))
			self:SetBackdropBorderColor(1,0,0,1)	
		else
			local position = self:GetPoint()			
			if position:match("TOPLEFT") or position:match("BOTTOMLEFT") or position:match("BOTTOMRIGHT") or position:match("TOPRIGHT") then
				self:SetAttribute("point", position)
			end
			if position:match("LEFT") then
				self:SetAttribute("xOffset", 34)
			else
				self:SetAttribute("xOffset", -34)
			end
			if position:match("BOTTOM") then
				self:SetAttribute("wrapYOffset", 64)
			else
				self:SetAttribute("wrapYOffset", -64)
			end
			self:SetBackdropColor(0,0,0,0)
			self:SetBackdropBorderColor(0,0,0,0)
		end
	end
	
	if self == TukuiTooltipAnchor or self == TukuiRollAnchor or self == TukuiAchievementHolder or self == TukuiVehicleAnchor then
		if enable then
			self:SetAlpha(1)
		else
			self:SetAlpha(0)
			if self == TukuiTooltipAnchor then 
				local position = TukuiTooltipAnchor:GetPoint()
				local healthBar = GameTooltipStatusBar
				if position:match("TOP") then
					healthBar:ClearAllPoints()
					healthBar:Point("TOPLEFT", healthBar:GetParent(), "BOTTOMLEFT", 2, -5)
					healthBar:Point("TOPRIGHT", healthBar:GetParent(), "BOTTOMRIGHT", -2, -5)
					if healthBar.text then healthBar.text:Point("CENTER", healthBar, 0, -6) end
				else
					healthBar:ClearAllPoints()
					healthBar:Point("BOTTOMLEFT", healthBar:GetParent(), "TOPLEFT", 2, 5)
					healthBar:Point("BOTTOMRIGHT", healthBar:GetParent(), "TOPRIGHT", -2, 5)
					if healthBar.text then healthBar.text:Point("CENTER", healthBar, 0, 6) end			
				end
			end
		end		
	end
	
	if self == TukuiWatchFrameAnchor then
		if enable then
			TukuiWatchFrameAnchor:SetBackdropBorderColor(1,0,0,1)
			TukuiWatchFrameAnchor:SetBackdropColor(unpack(C.media.backdropcolor))		
		else
			TukuiWatchFrameAnchor:SetBackdropBorderColor(0,0,0,0)
			TukuiWatchFrameAnchor:SetBackdropColor(0,0,0,0)		
		end
	end
	
	if self == TukuiShiftBar then
		if enable then
			TukuiShapeShiftHolder:SetAlpha(1)
			for i = 1, GetNumShapeshiftForms() do
				_G["ShapeshiftButton"..i]:Hide()
			end
			MultiCastActionBarFrame:Hide()
		else
			TukuiShapeShiftHolder:SetAlpha(0)
			for i = 1, GetNumShapeshiftForms() do
				_G["ShapeshiftButton"..i]:Show()
			end
			MultiCastActionBarFrame:Show()
		end
	end
	
	if self == TukuiWorldStateAnchor then
		if enable then
			TukuiWorldStateAnchor:SetBackdropBorderColor(1,0,0,1)
			TukuiWorldStateAnchor:SetBackdropColor(unpack(C.media.backdropcolor))		
		else
			TukuiWorldStateAnchor:SetBackdropBorderColor(0,0,0,0)
			TukuiWorldStateAnchor:SetBackdropColor(0,0,0,0)		
		end
	end
end

local enable = true
local origa1, origf, origa2, origx, origy

local function moving()
	-- don't allow moving while in combat
	if InCombatLockdown() then print(ERR_NOT_IN_COMBAT) return end
	
	for i = 1, getn(T.MoverFrames) do
		if T.MoverFrames[i] then		
			if enable then			
				T.MoverFrames[i]:EnableMouse(true)
				T.MoverFrames[i]:RegisterForDrag("LeftButton", "RightButton")
				T.MoverFrames[i]:SetScript("OnDragStart", function(self) 
					origa1, origf, origa2, origx, origy = T.MoverFrames[i]:GetPoint() 
					self.moving = true 
					self:SetUserPlaced(true) 
					self:StartMoving() 
				end)			
				T.MoverFrames[i]:SetScript("OnDragStop", function(self) 
					self.moving = false 
					self:StopMovingOrSizing() 
				end)			
				T.exec(T.MoverFrames[i], enable)			
				if T.MoverFrames[i].text then 
					T.MoverFrames[i].text:Show() 
				end
			else			
				T.MoverFrames[i]:EnableMouse(false)
				if T.MoverFrames[i].moving == true then
					T.MoverFrames[i]:StopMovingOrSizing()
					T.MoverFrames[i]:ClearAllPoints()
					T.MoverFrames[i]:SetPoint(origa1, origf, origa2, origx, origy)
				end
				T.exec(T.MoverFrames[i], enable)
				if T.MoverFrames[i].text then T.MoverFrames[i].text:Hide() end
				T.MoverFrames[i].moving = false
			end
		end
	end
	
	if T.MoveUnitFrames then T.MoveUnitFrames() end
	
	if enable then
		enable = false
		T.UILocked = false
		TukuiInfoLeftRButton.text:SetTextColor(unpack(C["media"].txtcolor))
	else
		enable = true
		T.UILocked = true
		TukuiInfoLeftRButton.text:SetTextColor(1,1,1)
	end
end
SLASH_MOVING1 = "/mtukui"
SLASH_MOVING2 = "/moveui"
SlashCmdList["MOVING"] = moving

TukuiInfoLeftRButton:SetScript("OnMouseDown", function(self)
	if InCombatLockdown() then return end
	
	moving()

	if TukuiInfoLeftRButton.hovered == true then
		local locked = false
		GameTooltip:ClearLines()
		
		if enable == true then
			GameTooltip:AddDoubleLine("User Interface", UNLOCK,1,1,1,unpack(C["media"].txtcolor))
			TukuiInfoLeftRButton.text:SetTextColor(1,1,1)
		else
			GameTooltip:AddDoubleLine("User Interface", LOCK,1,1,1,unpack(C["media"].txtcolor))
			TukuiInfoLeftRButton.text:SetTextColor(unpack(C["media"].txtcolor))
		end
	end
	GameTooltip:Show()
end)

TukuiInfoLeftRButton:SetScript("OnEnter", function(self)
	TukuiInfoLeftRButton.hovered = true
	if InCombatLockdown() then return end
	GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, T.Scale(6));
	GameTooltip:ClearAllPoints()
	GameTooltip:SetPoint("BOTTOM", self, "TOP", 0, T.mult)
	GameTooltip:ClearLines()
	
	if enable == true then
		GameTooltip:AddDoubleLine("User Interface", UNLOCK,1,1,1,unpack(C["media"].txtcolor))
		TukuiInfoLeftRButton.text:SetTextColor(1,1,1)
	else
		GameTooltip:AddDoubleLine("User Interface", LOCK,1,1,1,unpack(C["media"].txtcolor))
		TukuiInfoLeftRButton.text:SetTextColor(unpack(C["media"].txtcolor))
	end
	GameTooltip:Show()
end)

TukuiInfoLeftRButton:SetScript("OnLeave", function(self)
	TukuiInfoLeftRButton.hovered = false
	GameTooltip:Hide()
end)

local protection = CreateFrame("Frame")
protection:RegisterEvent("PLAYER_REGEN_DISABLED")
protection:SetScript("OnEvent", function(self, event)
	if enable then return end
	print(ERR_NOT_IN_COMBAT)
	enable = false
	moving()
end)