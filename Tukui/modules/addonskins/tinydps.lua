local T, C, L, DB = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

if not IsAddOnLoaded("TinyDPS") or C["addonskins"].tinydps == false then return end

local TinyDPS = CreateFrame("Frame")
TinyDPS:RegisterEvent('ADDON_LOADED')
TinyDPS:SetScript("OnEvent", function(self, event, addon)
	if not addon == "TinyDPS" then return end

	if tdps then
		tdps.width = TukuiMinimap:GetWidth()
		tdps.spacing = 2
		tdps.barHeight = T.buttonsize - 14
		tdpsFont.name = C["media"].font
		tdpsFont.size = 10
		tdpsFont.outline = "OUTLINE"
	end
	
	-- need 2 anchors for some reason, ask the author of TinyDPS why -_-"
	tdpsPosition = {x = 0, y = -6}
    tdpsAnchor:SetPoint('BOTTOMLEFT', TukuiReputation or TukuiMinimap, 'BOTTOMLEFT', 0, -7)
		
	tdpsFrame:SetTemplate("Default", true)
	tdpsFrame:CreateShadow("Default")
	
	if tdpsStatusBar then
		tdpsStatusBar:SetBackdrop({bgFile = C["media"].normTex, edgeFile = C["media"].blank, tile = false, tileSize = 0, edgeSize = 1, insets = { left = 0, right = 0, top = 0, bottom = 0}})
		tdpsStatusBar:SetStatusBarTexture(C["media"].normTex)
	end
	
	self:UnregisterEvent('ADDON_LOADED')
end)
