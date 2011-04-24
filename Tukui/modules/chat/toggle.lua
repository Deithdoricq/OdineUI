local T, C, L, DB = unpack(select(2, ...)) -- Import Functions/Constants, Config, Locales

------------------------------------------------------------------------
-- Chat Toggle Functions
------------------------------------------------------------------------

T.ToggleSlideChatL = function()
	if T.ChatLIn == true then
		ChatLBackground:Hide()
		T.ChatLIn = false
		TukuiInfoLeftLButton.text:SetTextColor(unpack(C["media"].txtcolor))
	else
		ChatLBackground:Show()
		T.ChatLIn = true
		TukuiInfoLeftLButton.text:SetTextColor(1,1,1,1)
	end
end

T.ToggleSlideChatR = function()
	if T.RightChat ~= true then return end
	if T.ChatRIn == true then
		ChatRBackground:Hide()	
		T.ChatRIn = false
		T.ChatRightShown = false
		TukuiInfoRightRButton.text:SetTextColor(unpack(C["media"].txtcolor))
	else
		ChatRBackground:Show()
		T.ChatRIn = true
		T.ChatRightShown = true
		TukuiInfoRightRButton.text:SetTextColor(1,1,1,1)
	end
end

--Setup Button Scripts
TukuiInfoLeftLButton:SetScript("OnMouseDown", function(self, btn)
	if btn == "RightButton" then
		T.ToggleSlideChatR()
		T.ToggleSlideChatL()
	else
		T.ToggleSlideChatL()	
	end
end)

TukuiInfoRightRButton:SetScript("OnMouseDown", function(self, btn)
	if T.RightChat ~= true then return end
	if InCombatLockdown() then
		print(ERR_NOT_IN_COMBAT)
		return
	end
	if btn == "RightButton" then
		T.ToggleSlideChatR()
		T.ToggleSlideChatL()
	else
		T.ToggleSlideChatR()
	end
end)