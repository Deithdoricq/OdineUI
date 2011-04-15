--------------------------------------------------------------------
-- spec switcher -- by sortokk
--------------------------------------------------------------------
local T, C, L, DB = unpack(select(2, ...)) -- Import Functions/Constants, Config, Locales

if not C["datatext"].spec or C["datatext"].spec == 0 then return end

local Stat = CreateFrame("Frame")
Stat:EnableMouse(true)
Stat:SetFrameStrata("BACKGROUND")
Stat:SetFrameLevel(3)

local Text  = TukuiDataBottom:CreateFontString(nil, "OVERLAY")
Text:SetFont(C["media"].dfont, C["datatext"].fsize, "OUTLINE")
T.PP(C["datatext"].spec, Text)



local talent = {}
local active
local talentString = string.join("", T.cStart.."%s|r"..": ", "%d"..T.cStart.."/|r".."%d"..T.cStart.."/|r".."%d")
local activeString = string.join("", "|cff00FF00" , "Active", "|r")
local inactiveString = string.join("", "|cffFF0000", "Inactive", "|r")

local function LoadTalentTrees()
	for i = 1, GetNumTalentGroups(false, false) do
		talent[i] = {} -- init talent group table
		for j = 1, GetNumTalentTabs(false, false) do
			talent[i][j] = select(5, GetTalentTabInfo(j, false, false, i))
		end
	end
end

local int = 1
local function Update(self, t)
	int = int - t
	if int > 0 or not GetPrimaryTalentTree() then return end

	active = GetActiveTalentGroup(false, false)
	Text:SetFormattedText(talentString, select(2, GetTalentTabInfo(GetPrimaryTalentTree(false, false, active))), talent[active][1], talent[active][2], talent[active][3])
	int = 1

	-- disable script	
	self:SetScript("OnUpdate", nil)
end

Stat:SetScript("OnEnter", function(self)
	if InCombatLockdown() then return end

	local anchor, panel, xoff, yoff = T.DataTextTooltipAnchor(Text)
	GameTooltip:SetOwner(panel, anchor, xoff, yoff)

	GameTooltip:ClearLines()
	for i = 1, GetNumTalentGroups() do
		if GetPrimaryTalentTree(false, false, i) then
			GameTooltip:AddLine(string.join(" ", string.format(talentString, select(2, GetTalentTabInfo(GetPrimaryTalentTree(false, false, i))), talent[i][1], talent[i][2], talent[i][3]), (i == active and activeString or inactiveString)),1,1,1)
		end
	end
	GameTooltip:Show()
end)

Stat:SetScript("OnLeave", function() GameTooltip:Hide() end)

local function OnEvent(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
	
	-- load talent information
	LoadTalentTrees()

	-- Setup Talents Tooltip
	self:SetAllPoints(Text)

	-- update datatext
	if event ~= "PLAYER_ENTERING_WORLD" then
		self:SetScript("OnUpdate", Update)
	end
end

Stat:RegisterEvent("PLAYER_ENTERING_WORLD");
Stat:RegisterEvent("CHARACTER_POINTS_CHANGED");
Stat:RegisterEvent("PLAYER_TALENT_UPDATE");
Stat:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
Stat:SetScript("OnEvent", OnEvent)
Stat:SetScript("OnUpdate", Update)

Stat:SetScript("OnMouseDown", function()
	SetActiveTalentGroup(active == 1 and 2 or 1)
end)