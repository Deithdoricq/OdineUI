local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

-- Chat Frames
local TukuiChatLeft = CreateFrame("Frame", "TukuiChatLeft", UIParent)
TukuiChatLeft:CreatePanel("Transparent", T.InfoLeftRightWidth, C["chat"].height, "BOTTOMLEFT", UIParent, "BOTTOMLEFT", 8, 8)

local TukuiChatRight = CreateFrame("Frame", "TukuiChatRight", UIParent)
TukuiChatRight:CreatePanel("Transparent", T.InfoLeftRightWidth, C["chat"].height, "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -8, 8)

-- Chat Tabs
local TukuiTabsLeft = CreateFrame("Frame", "TukuiTabsLeft", UIParent)
TukuiTabsLeft:CreatePanel("Default", 1, 23, "TOPLEFT", TukuiChatLeft, "TOPLEFT", 5, -5)
TukuiTabsLeft:Point("TOPRIGHT", TukuiChatLeft, "TOPRIGHT", -5, -5)
TukuiTabsLeft:SetFrameLevel(TukuiChatLeft:GetFrameLevel() + 1)
TukuiTabsLeft:SetTemplate("Default", true)

local TukuiTabsRight = CreateFrame("Frame", "TukuiTabsRight", UIParent)
TukuiTabsRight:CreatePanel("Default", 1, 23, "TOPLEFT", TukuiChatRight, "TOPLEFT", 5, -5)
TukuiTabsRight:Point("TOPRIGHT", TukuiChatRight, "TOPRIGHT", -5, -5)
TukuiTabsRight:SetFrameLevel(TukuiChatRight:GetFrameLevel() + 1)
TukuiTabsRight:SetTemplate("Default", true)

if not C["chat"].background then
	TukuiChatLeft:SetAlpha(0)
	TukuiChatRight:SetAlpha(0)
	TukuiTabsLeft:SetAlpha(0)
	TukuiTabsRight:SetAlpha(0)
end

-- Data Frames
local TukuiInfoLeft = CreateFrame("Frame", "TukuiInfoLeft", UIParent)
TukuiInfoLeft:CreatePanel("Default", 1, 23, "BOTTOMLEFT", TukuiChatLeft, "BOTTOMLEFT", 5, 5)
TukuiInfoLeft:Point("BOTTOMRIGHT", TukuiChatLeft, "BOTTOMRIGHT", -5, 5)
TukuiInfoLeft:SetFrameLevel(TukuiChatLeft:GetFrameLevel() + 1)
TukuiInfoLeft:SetTemplate("Default", true)

local TukuiInfoRight = CreateFrame("Frame", "TukuiInfoRight", UIParent)
TukuiInfoRight:CreatePanel("Default", 1, 23, "BOTTOMLEFT", TukuiChatRight, "BOTTOMLEFT", 5, 5)
TukuiInfoRight:Point("BOTTOMRIGHT", TukuiChatRight, "BOTTOMRIGHT", -5, 5)
TukuiInfoRight:SetFrameLevel(TukuiChatRight:GetFrameLevel() + 1)
TukuiInfoRight:SetTemplate("Default", true)

-- Bottom Data Panels

local dbottom = CreateFrame("Frame", "TukuiDataBottom", UIParent)
dbottom:CreatePanel("Default", (T.buttonsize * 12 + T.buttonspacing * 13) + 2, 20, "BOTTOM", UIParent, "BOTTOM", 0, T.Scale(7))
dbottom:SetFrameLevel(2)
dbottom:SetTemplate("Default", true)

local leftsd = CreateFrame("Frame", "TukuiLeftSplitBarData", UIParent)
leftsd:CreatePanel("Default", (T.buttonsize * 3 + T.buttonspacing * 4) + 2, 20, "RIGHT", TukuiDataBottom, "LEFT", T.Scale(-5), 0)
leftsd:SetFrameLevel(2)
leftsd:SetTemplate("Default", true)

local rightsd = CreateFrame("Frame", "TukuiRightSplitBarData", UIParent)
rightsd:CreatePanel("Default", (T.buttonsize * 3 + T.buttonspacing * 4) + 2, 20, "LEFT", TukuiDataBottom, "RIGHT", T.Scale(5), 0)
rightsd:SetFrameLevel(2)
rightsd:SetTemplate("Default", true)

-- Action Bars
if C["actionbar"].enable then
	local TukuiBar1 = CreateFrame("Frame", "TukuiBar1", UIParent, "SecureHandlerStateTemplate")
	TukuiBar1:CreatePanel("Transparent", (T.buttonsize * 12) + (T.buttonspacing * 13) + 2, (T.buttonsize * 2) + (T.buttonspacing * 3) + 2, "BOTTOM", UIParent, "BOTTOM", 0, 8)
	TukuiBar1:SetPoint("BOTTOM", TukuiDataBottom, "TOP", 0, T.Scale(3))

	local TukuiBar2 = CreateFrame("Frame", "TukuiBar2", UIParent)
	TukuiBar2:SetAllPoints(TukuiBar1)--("BOTTOM")
	
	local TukuiBar3 = CreateFrame("Frame", "TukuiBar3", UIParent)
	TukuiBar3:SetAllPoints(TukuiBar1)--Point("BOTTOM")

	local TukuiBar4 = CreateFrame("Frame", "TukuiBar4", UIParent)
	TukuiBar2:SetAllPoints(TukuiBar1)--Point("BOTTOM")

	local TukuiSplitBarLeft = CreateFrame("Frame", "TukuiSplitBarLeft", UIParent)
	TukuiSplitBarLeft:CreatePanel("Transparent", (T.buttonsize * 3) + (T.buttonspacing * 4) + 2, TukuiBar1:GetHeight(), "BOTTOMRIGHT", TukuiBar1, "BOTTOMLEFT", -6, 0)

	local TukuiSplitBarRight = CreateFrame("Frame", "TukuiSplitBarRight", UIParent)
	TukuiSplitBarRight:CreatePanel("Transparent", (T.buttonsize * 3) + (T.buttonspacing * 4) + 2, TukuiBar1:GetHeight(), "BOTTOMLEFT", TukuiBar1, "BOTTOMRIGHT", 6, 0)

	local TukuiRightBar = CreateFrame("Frame", "TukuiRightBar", UIParent)
	TukuiRightBar:CreatePanel("Transparent", (T.buttonsize * 12 + T.buttonspacing * 13) + 2,  (T.buttonsize * 12 + T.buttonspacing * 13) + 2, "BOTTOMRIGHT", TukuiChatRight, "TOPRIGHT", 0, 3)
	if not C["chat"].background then
		TukuiRightBar:ClearAllPoints()
		TukuiRightBar:Point("RIGHT", UIParent, "RIGHT", -8, -250)
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