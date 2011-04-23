local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

local f = CreateFrame("Frame", "TukuiBottomPanel", UIParent)
f:SetHeight(23)
f:SetWidth(UIParent:GetWidth() + (T.mult * 2))
f:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", -T.mult, -T.mult)
f:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", T.mult, -T.mult)
f:SetFrameStrata("BACKGROUND")
f:SetFrameLevel(0)

-- Bottom Data Panels

local dbottom = CreateFrame("Frame", "TukuiDataBottom", UIParent)
dbottom:CreatePanel("Default", (T.buttonsize * 12 + T.buttonspacing * 13) + 2, 23, "BOTTOM", UIParent, "BOTTOM", 0, T.Scale(8))
dbottom:SetFrameLevel(2)

local leftsd = CreateFrame("Frame", "TukuiLeftSplitBarData", UIParent)
leftsd:CreatePanel("Default", (T.buttonsize * 3 + T.buttonspacing * 4) + 2, 23, "RIGHT", TukuiDataBottom, "LEFT", T.Scale(-6), 0)
leftsd:SetFrameLevel(2)

local rightsd = CreateFrame("Frame", "TukuiRightSplitBarData", UIParent)
rightsd:CreatePanel("Default", (T.buttonsize * 3 + T.buttonspacing * 4) + 2, 23, "LEFT", TukuiDataBottom, "RIGHT", T.Scale(6), 0)
rightsd:SetFrameLevel(2)

-- CHAT BACKGROUND LEFT (MOVES)
local chatlbgdummy = CreateFrame("Frame", "ChatLBackground", UIParent)
chatlbgdummy:SetWidth(T.InfoLeftRightWidth)
chatlbgdummy:SetHeight(C["chat"].height+6)
chatlbgdummy:SetPoint("BOTTOMLEFT", TukuiBottomPanel, "TOPLEFT", T.Scale(6),  T.Scale(12))

-- CHAT BACKGROUND LEFT (DOESN'T MOVE THIS IS WHAT WE ATTACH FRAMES TO)
local chatlbgdummy2 = CreateFrame("Frame", "ChatLBackground2", UIParent)
chatlbgdummy2:SetWidth(T.InfoLeftRightWidth)
chatlbgdummy2:SetHeight(C["chat"].height+6)
chatlbgdummy2:SetPoint("BOTTOMLEFT", TukuiBottomPanel, "TOPLEFT", T.Scale(6),  T.Scale(12))

-- CHAT BACKGROUND RIGHT (MOVES)
local chatrbgdummy = CreateFrame("Frame", "ChatRBackground", UIParent)
chatrbgdummy:SetWidth(T.InfoLeftRightWidth)
chatrbgdummy:SetHeight(C["chat"].height+6)
chatrbgdummy:SetPoint("BOTTOMRIGHT", TukuiBottomPanel, "TOPRIGHT", T.Scale(-6),  T.Scale(16))

-- CHAT BACKGROUND RIGHT (DOESN'T MOVE THIS IS WHAT WE ATTACH FRAMES TO)
local chatrbgdummy2 = CreateFrame("Frame", "ChatRBackground2", UIParent)
chatrbgdummy2:SetWidth(T.InfoLeftRightWidth)
chatrbgdummy2:SetHeight(C["chat"].height+6)
chatrbgdummy2:SetPoint("BOTTOMRIGHT", TukuiBottomPanel, "TOPRIGHT", T.Scale(-6),  T.Scale(16))

T.ChatRightShown = true
if C["chat"].background == true then
	local chatlbg = CreateFrame("Frame", "ChatLBG", ChatLBackground)
	chatlbg:SetTemplate("Transparent")
	chatlbg:SetAllPoints(chatlbgdummy)
	chatlbg:SetFrameStrata("BACKGROUND")
	
	local chatltbg = CreateFrame("Frame", nil, chatlbg)
	chatltbg:SetTemplate("Default", true)
	chatltbg:SetPoint("BOTTOMLEFT", chatlbg, "TOPLEFT", 0, T.Scale(3))
	chatltbg:SetPoint("BOTTOMRIGHT", chatlbg, "TOPRIGHT", T.Scale(0), T.Scale(3))
	chatltbg:SetHeight(T.Scale(22))
	chatltbg:SetFrameStrata("BACKGROUND")
	
	chatlbg:CreateShadow("Default")
	chatltbg:CreateShadow("Default")
end

if C["chat"].background == true then
	local chatrbg = CreateFrame("Frame", "ChatRBG", ChatRBackground)
	chatrbg:SetAllPoints(chatrbgdummy)
	chatrbg:SetTemplate("Transparent")
	chatrbg:SetFrameStrata("BACKGROUND")
	chatrbg:SetAlpha(0)

	local chatrtbg = CreateFrame("Frame", nil, chatrbg)
	chatrtbg:SetTemplate("Default", true)
	chatrtbg:SetPoint("BOTTOMLEFT", chatrbg, "TOPLEFT", 0, T.Scale(3))
	chatrtbg:SetPoint("BOTTOMRIGHT", chatrbg, "TOPRIGHT", T.Scale(0), T.Scale(3))
	chatrtbg:SetHeight(T.Scale(22))
	chatrtbg:SetFrameStrata("BACKGROUND")
	chatrbg:CreateShadow("Default")
	chatrtbg:CreateShadow("Default")
end

--INFO LEFT
local infoleft = CreateFrame("Frame", "TukuiInfoLeft", UIParent)
infoleft:SetFrameLevel(2)
infoleft:SetTemplate("Default", true)
infoleft:CreateShadow("Default")
infoleft:SetPoint("TOPLEFT", chatlbgdummy2, "BOTTOMLEFT", T.Scale(17), T.Scale(-3))
infoleft:SetPoint("BOTTOMRIGHT", chatlbgdummy2, "BOTTOMRIGHT", T.Scale(-0), T.Scale(-26))

--INFOLEFT L BUTTON
local infoleftLbutton = CreateFrame("Button", "TukuiInfoLeftLButton", TukuiInfoLeft)
infoleftLbutton:SetTemplate("Default", true)
infoleftLbutton:CreateShadow("Default")
infoleftLbutton:SetPoint("TOPRIGHT", infoleft, "TOPLEFT", T.Scale(-2), 0)
infoleftLbutton:SetPoint("BOTTOMLEFT", chatlbgdummy2, "BOTTOMLEFT", 0, T.Scale(-26))

infoleft.shadow:SetPoint("TOPLEFT", infoleftLbutton, "TOPLEFT", T.Scale(-4), T.Scale(4))

infoleftLbutton:FontString(nil, C["media"].dfont, C["datatext"].fsize, "THINOUTLINE")
infoleftLbutton.text:SetText("-")
infoleftLbutton.text:SetPoint("CENTER")

infoleftLbutton:HookScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
	GameTooltip:ClearLines()
	GameTooltip:AddLine("Left Click: Hide Left Chat")
	GameTooltip:AddLine("Right Click: Hide Both Chat Windows")
	if C["addonskins"].embed ~= "NONE" then
		GameTooltip:AddLine('')
		GameTooltip:AddLine("Holding SHIFT will toggle your active Embed Addon")
	end
	GameTooltip:Show()
end)

infoleftLbutton:HookScript("OnLeave", function()
	GameTooltip:Hide()
end)

-- INFO RIGHT
local inforight = CreateFrame("Frame", "TukuiInfoRight", UIParent)
inforight:SetTemplate("Default", true)
inforight:SetFrameLevel(2)
inforight:CreateShadow("Default")
inforight:SetPoint("TOPLEFT", chatrbgdummy2, "BOTTOMLEFT", T.Scale(0), T.Scale(-3))
inforight:SetPoint("BOTTOMRIGHT", chatrbgdummy2, "BOTTOMRIGHT", T.Scale(-17), T.Scale(-26))

-- RIGHT BUTTON
local inforightRbutton = CreateFrame("Button", "TukuiInfoRightRButton", TukuiInfoRight)
inforightRbutton:SetTemplate("Default", true)
inforightRbutton:CreateShadow("Default")
inforightRbutton:SetPoint("TOPLEFT", inforight, "TOPRIGHT", T.Scale(2), 0)
inforightRbutton:SetPoint("BOTTOMRIGHT", chatrbgdummy2, "BOTTOMRIGHT", 0, T.Scale(-26))

inforight.shadow:SetPoint("BOTTOMRIGHT", inforightRbutton, "BOTTOMRIGHT", T.Scale(4), T.Scale(-4))

inforightRbutton:FontString(nil, C["media"].dfont, C["datatext"].fsize, "THINOUTLINE")
inforightRbutton.text:SetText("-")
inforightRbutton.text:SetPoint("CENTER")

inforightRbutton:HookScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
	GameTooltip:ClearLines()
	GameTooltip:AddLine("Left Click: Hide Right Chat")
	GameTooltip:AddLine("Right Click: Hide Both Chat Windows")
	if C["addonskins"].embed ~= "NONE" then
		GameTooltip:AddLine('')
		GameTooltip:AddLine("Holding SHIFT will toggle your active Embed Addon")
	end
	GameTooltip:Show()
end)

inforightRbutton:HookScript("OnLeave", function()
	GameTooltip:Hide()
end)

-- Action Bars
if C["actionbar"].enable then
	local TukuiBar1 = CreateFrame("Frame", "TukuiBar1", UIParent, "SecureHandlerStateTemplate")
	TukuiBar1:CreatePanel("Default", (T.buttonsize * 12) + (T.buttonspacing * 13) + 2, (T.buttonsize * 2) + (T.buttonspacing * 3) + 2, "BOTTOM", UIParent, "BOTTOM", 0, 8)
	TukuiBar1:SetPoint("BOTTOM", TukuiDataBottom, "TOP", 0, T.Scale(3))

	local TukuiBar2 = CreateFrame("Frame", "TukuiBar2", UIParent)
	TukuiBar2:SetAllPoints(TukuiBar1)--("BOTTOM")
	
	local TukuiBar3 = CreateFrame("Frame", "TukuiBar3", UIParent)
	TukuiBar3:SetAllPoints(TukuiBar1)--Point("BOTTOM")

	local TukuiBar4 = CreateFrame("Frame", "TukuiBar4", UIParent)
	TukuiBar2:SetAllPoints(TukuiBar1)--Point("BOTTOM")

	local TukuiSplitBarLeft = CreateFrame("Frame", "TukuiSplitBarLeft", UIParent)
	TukuiSplitBarLeft:CreatePanel("Default", (T.buttonsize * 3) + (T.buttonspacing * 4) + 2, TukuiBar1:GetHeight(), "BOTTOMRIGHT", TukuiBar1, "BOTTOMLEFT", -6, 0)

	local TukuiSplitBarRight = CreateFrame("Frame", "TukuiSplitBarRight", UIParent)
	TukuiSplitBarRight:CreatePanel("Default", (T.buttonsize * 3) + (T.buttonspacing * 4) + 2, TukuiBar1:GetHeight(), "BOTTOMLEFT", TukuiBar1, "BOTTOMRIGHT", 6, 0)

	local TukuiRightBar = CreateFrame("Frame", "TukuiRightBar", UIParent)
	if C["actionbar"].vertical_rightbars == true then
		TukuiRightBar:CreatePanel("Default", (T.buttonsize * 12 + T.buttonspacing * 13) + 2,  (T.buttonsize * 12 + T.buttonspacing * 13) + 2, "BOTTOMRIGHT", ChatRBackground, "TOPRIGHT", 0, T.Scale(175))
	else
		TukuiRightBar:CreatePanel("Default", (T.buttonsize * 12 + T.buttonspacing * 13) + 2,  (T.buttonsize * 12 + T.buttonspacing * 13) + 2, "BOTTOMRIGHT", ChatRBackground, "TOPRIGHT", 0, T.Scale(27))
	end

	local TukuiPetBar = CreateFrame("Frame", "TukuiPetBar", UIParent)
	TukuiPetBar:CreatePanel("Default", 1, 1, "BOTTOMRIGHT", TukuiRightBar, "TOPRIGHT", 0, 3)
	if C["actionbar"].vertical_rightbars == true then
		TukuiPetBar:Width((T.petbuttonsize + T.buttonspacing * 2) + 2)
		TukuiPetBar:Height((T.petbuttonsize * NUM_PET_ACTION_SLOTS + T.buttonspacing * 11) + 2)
	else
		TukuiPetBar:Width((T.petbuttonsize * NUM_PET_ACTION_SLOTS + T.buttonspacing * 11) + 2)
		TukuiPetBar:Height((T.petbuttonsize + T.buttonspacing * 2) + 2)
	end
end

--BATTLEGROUND STATS FRAME
if C["datatext"].battleground == true then
	local bgframe = CreateFrame("Frame", "TukuiInfoLeftBattleGround", UIParent)
	bgframe:CreatePanel("Default", 1, 1, "TOPLEFT", UIParent, "BOTTOMLEFT", 0, 0)
	bgframe:SetAllPoints(TukuiInfoLeft)
	bgframe:SetFrameStrata("LOW")
	bgframe:SetFrameLevel(0)
	bgframe:EnableMouse(true)
end