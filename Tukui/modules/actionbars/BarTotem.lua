local T, C, L, DB = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
if C["actionbar"].enable ~= true then return end
if T.myclass ~= "SHAMAN" then return end

-- we just use default totem bar for shaman
-- we parent it to our shapeshift bar.
-- This is approx the same script as it was in WOTLK Tukui version.

if MultiCastActionBarFrame then
	MultiCastActionBarFrame:SetScript("OnUpdate", nil)
	MultiCastActionBarFrame:SetScript("OnShow", nil)
	MultiCastActionBarFrame:SetScript("OnHide", nil)
	MultiCastActionBarFrame:SetParent(TukuiShiftBar)
	MultiCastActionBarFrame:ClearAllPoints()
	MultiCastActionBarFrame:SetPoint("BOTTOMLEFT", TukuiShiftBar, "BOTTOMLEFT", -2, -2)

	hooksecurefunc("MultiCastActionButton_Update",function(actionbutton) if not InCombatLockdown() then actionbutton:SetAllPoints(actionbutton.slotButton) end end)
	
	MultiCastActionBarFrame.SetParent = T.dummy
	MultiCastActionBarFrame.SetPoint = T.dummy
	MultiCastRecallSpellButton.SetPoint = T.dummy -- bug fix, see http://www.tukui.org/v2/forums/topic.php?id=2405

	if C["actionbar"].shapeshiftmouseover == true then
		MultiCastActionBarFrame:SetAlpha(0)
		MultiCastActionBarFrame:HookScript("OnEnter", function() MultiCastActionBarFrame:SetAlpha(1) end)
		MultiCastActionBarFrame:HookScript("OnLeave", function() MultiCastActionBarFrame:SetAlpha(0) end)
	end
end