local T, C, L, DB = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

if not IsAddOnLoaded("TinyDPS") or C["addonskins"].tinydps == false then return end

-- TinyDPS editless skin, by Dajova
local TinyDPS = CreateFrame("Frame")
TinyDPS:RegisterEvent("ADDON_LOADED")
TinyDPS:RegisterEvent("PLAYER_ENTERING_WORLD")
TinyDPS:SetScript("OnEvent", function(self, event, addon)
	if not addon == "TinyDPS" then return end
	
	if event == "ADDON_LOADED" then
		tdps.width = TukuiMinimap:GetWidth()
		tdps.barHeight = 16
		tdpsFont.name = C["media"].font
		tdpsFont.size = 10

		tdpsPosition = {x = 0, y = -6}

		tdpsFrame:SetHeight(tdps.barHeight + 4)
		tdpsFrame:SetTemplate("Default", true)
		tdpsFrame:CreateShadow("Default")

		if tdpsStatusBar then
			tdpsStatusBar:SetBackdrop({bgFile = C["media"].normTex, edgeFile = C["media"].blank, tile = false, tileSize = 1, edgeSize = 1, insets = { left = 0, right = 0, top = 0, bottom = 0}})
			tdpsStatusBar:SetStatusBarTexture(C["media"].normTex)
		end

		self:UnregisterEvent("ADDON_LOADED")
	end
	
	if event == "PLAYER_ENTERING_WORLD" then
		if tdpsStatusBar then
			tdpsStatusBar:SetWidth(TukuiMinimap:GetWidth()-4)
		end
		
		tdpsFrame:SetWidth(TukuiMinimap:GetWidth())
		tdpsAnchor:SetPoint('BOTTOMLEFT', TukuiReputation or TukuiMinimap, 'BOTTOMLEFT', 0, -10)
		
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
	
end)
