local T, C, L, DB = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
------------------------------------------------------------------------
--	GM ticket position
------------------------------------------------------------------------

-- create our moving area
local TukuiGMFrameAnchor = CreateFrame("Button", "TukuiGMFrameAnchor", UIParent)
TukuiGMFrameAnchor:SetFrameStrata("TOOLTIP")
TukuiGMFrameAnchor:SetFrameLevel(20)
TukuiGMFrameAnchor:SetHeight(40)
TukuiGMFrameAnchor:SetWidth(TicketStatusFrameButton:GetWidth())
TukuiGMFrameAnchor:SetClampedToScreen(true)
TukuiGMFrameAnchor:SetMovable(true)
TukuiGMFrameAnchor:SetTemplate("Default", true)
TukuiGMFrameAnchor:SetBackdropBorderColor(1,0,0,1)
TukuiGMFrameAnchor:SetBackdropColor(unpack(C.media.backdropcolor))
TukuiGMFrameAnchor:Point("TOPLEFT", 450, -8)
TukuiGMFrameAnchor.text = T.SetFontString(TukuiGMFrameAnchor, C["media"].font, 12, "OUTLINE")
TukuiGMFrameAnchor.text:SetPoint("CENTER")
TukuiGMFrameAnchor.text:SetText(L.move_gmframe)
TukuiGMFrameAnchor.text:SetParent(TukuiGMFrameAnchor)
TukuiGMFrameAnchor:Hide()

TicketStatusFrame:ClearAllPoints()
TicketStatusFrame:SetPoint("TOP", TukuiGMFrameAnchor, "TOP")

------------------------------------------------------------------------
--	GM toggle command
------------------------------------------------------------------------

SLASH_GM1 = "/gm"
SlashCmdList["GM"] = function() ToggleHelpFrame() end