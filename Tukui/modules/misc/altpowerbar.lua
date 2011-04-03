local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

if IsAddOnLoaded("SmellyPowerBar") then return end

-- Get rid of old Alt Power Bar
PlayerPowerBarAlt:UnregisterEvent("UNIT_POWER_BAR_SHOW")
PlayerPowerBarAlt:UnregisterEvent("UNIT_POWER_BAR_HIDE")
PlayerPowerBarAlt:UnregisterEvent("PLAYER_ENTERING_WORLD")
	
--Create the new bar
local AltPowerBar = CreateFrame("Frame", "TukuiAltPowerBar", UIParent)
AltPowerBar:CreatePanel("Default", 250, TukuiInfoLeft:GetHeight(), "TOP", UIParent, "TOP", 0, -75)
AltPowerBar:SetFrameStrata("LOW")
AltPowerBar:SetFrameLevel(0)
AltPowerBar:EnableMouse(true)
AltPowerBar:SetTemplate("Default")
AltPowerBar:SetMovable(true)

-- Create Status Bar and Text
local AltPowerBarStatus = CreateFrame("StatusBar", "TukuiAltPowerBarStatus", AltPowerBar)
AltPowerBarStatus:SetFrameLevel(AltPowerBar:GetFrameLevel() + 1)
AltPowerBarStatus:SetStatusBarTexture(C["media"].normTex)
AltPowerBarStatus:SetMinMaxValues(0, 100)
AltPowerBarStatus:Point("TOPLEFT", AltPowerBar, "TOPLEFT", 2, -2)
AltPowerBarStatus:Point("BOTTOMRIGHT", AltPowerBar, "BOTTOMRIGHT", -2, 2)
AltPowerBarStatus:SetStatusBarColor(75/255,  175/255, 76/255)

local AltPowerText = AltPowerBarStatus:CreateFontString(nil, "OVERLAY")
AltPowerText:SetFont(C["media"].font, 12, "OUTLINE")
AltPowerText:Point("CENTER", AltPowerBar, "CENTER", 0, 1)

--Event handling
AltPowerBar:RegisterEvent("UNIT_POWER")
AltPowerBar:RegisterEvent("UNIT_POWER_BAR_SHOW")
AltPowerBar:RegisterEvent("UNIT_POWER_BAR_HIDE")
AltPowerBar:RegisterEvent("PLAYER_ENTERING_WORLD")
AltPowerBar:SetScript("OnEvent", function(self)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	if UnitAlternatePowerInfo("player") then
		self:Show()
	else
		self:Hide()
	end
end)

-- Update Functions
local TimeSinceLastUpdate = 1
AltPowerBarStatus:SetScript("OnUpdate", function(self, elapsed)
	if not AltPowerBar:IsShown() then return end
	TimeSinceLastUpdate = TimeSinceLastUpdate + elapsed
	
	if (TimeSinceLastUpdate >= 1) then
		self:SetMinMaxValues(0, UnitPowerMax("player", ALTERNATE_POWER_INDEX))
		local power = UnitPower("player", ALTERNATE_POWER_INDEX)
		local mpower = UnitPowerMax("player", ALTERNATE_POWER_INDEX)
		self:SetValue(power)
		AltPowerText:SetText(power.."/"..mpower)
		self.TimeSinceLastUpdate = 0
	end
end)

--Set up text to display while being moved
AltPowerBar.text = T.SetFontString(AltPowerBarStatus, C["media"].font, 12, "OUTLINE")
AltPowerBar.text:SetText("Alt Power Bar")
AltPowerBar.text:SetPoint("CENTER")
AltPowerBar.text:Hide()


T.MoverFrames[(#T.MoverFrames)+1] = TukuiAltPowerBar
-- Hook T.exec to set display options for this addon
local originalExec = T.exec
function T.exec(...)
	self, enable = ...
	if self == TukuiAltPowerBar then
		if enable then
            -- When moving use a red border like the rest of Tukui
			self:SetBackdropBorderColor(1,0,0,1)
			self:Show()
			AltPowerText:Hide()
		else
            --Turn off the border again
			self:SetBackdropBorderColor(0,0,0,0)
			AltPowerText:Show()
			if UnitAlternatePowerInfo("player") then
				self:Show()
			else
				self:Hide()
			end
		end
	end
        -- Call the original T.exec function
	return originalExec(...)
end
