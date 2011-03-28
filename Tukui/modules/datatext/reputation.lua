local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

local rep = CreateFrame("Frame", "TukuiReputation", UIParent)
if UnitLevel("player") ~= MAX_PLAYER_LEVEL then
	rep:CreatePanel("Default", TukuiMinimap:GetWidth()+1, 10, "TOPLEFT", TukuiExperience, "BOTTOMLEFT", 0, -3)
else
	rep:CreatePanel("Default", TukuiMinimap:GetWidth()+1, 10, "TOPLEFT", TukuiMinimap, "BOTTOMLEFT", 0, -3)
end
rep:EnableMouse(true)

local bar = CreateFrame("StatusBar", "TukuiReputationBar", rep)
bar:SetPoint("TOPLEFT", rep, TukuiDB.Scale(2), TukuiDB.Scale(-2))
bar:SetPoint("BOTTOMRIGHT", rep, TukuiDB.Scale(-2), TukuiDB.Scale(2))
bar:SetStatusBarTexture(C["media"].normTex)
rep.bar = bar

local text = bar:CreateFontString(nil, "LOW")
text:SetFont(C["media"].dfont, C["datatext"].fsize, "OUTLINE")
text:SetPoint("CENTER", rep)
rep.text = text

local factioncolors = {
	{ r = .9, g = .3, b = .3 }, -- Hated
	{ r = .7, g = .3, b = .3 }, -- Hostile
	{ r = .7, g = .3, b = .3 }, -- Unfriendly
	{ r = .8, g = .7, b = .4 }, -- Neutral
	{ r = .3, g = .7, b = .3 }, -- Friendly
	{ r = .3, g = .7, b = .3 }, -- Honored
	{ r = .3, g = .7, b = .3 }, -- Revered
	{ r = .3, g = .9, b = .3 }, -- Exalted
}

local function event(self, event, ...)
	local _, id, min, max, value = GetWatchedFactionInfo()
	local colors = factioncolors[id]
	
	bar:SetMinMaxValues(min, max)
	bar:SetValue(value)
	
	if id > 0 then
		text:SetText(" ")
		bar:SetStatusBarColor(colors.r, colors.g, colors.b)
		
		rep:Show()
	else
		rep:Hide()
	end
end

rep:HookScript("OnEnter", function()
	local name, id, min, max, value = GetWatchedFactionInfo()
	local colors = factioncolors[id]
	
	local perMax = max - min
	local perGValue = value - min
	local perNValue = max - value
	
	local perGain = format("%.1f%%", (perGValue / perMax) * 100)
	local perNeed = format("%.1f%%", (perNValue / perMax) * 100)

	GameTooltip:SetOwner(rep, "ANCHOR_BOTTOMRIGHT", -rep:GetWidth(), -(rep:GetHeight() - 10 + 3))
	GameTooltip:ClearLines()
	GameTooltip:AddLine(T.cStart .. "Reputation:|r")
	GameTooltip:AddLine" "
	GameTooltip:AddDoubleLine(T.cStart .. "Faction: |r", name, 1, 1, 1, 1, 1, 1)
	GameTooltip:AddDoubleLine(T.cStart .. "Standing: |r", _G['FACTION_STANDING_LABEL'..id], 1, 1, 1, colors.r, colors.g, colors.b)
	GameTooltip:AddDoubleLine(T.cStart .. "Gained: |r", value - min .. " (" .. perGain .. ")", 1, 1, 1, 1, 1, 1)
	GameTooltip:AddDoubleLine(T.cStart .. "Needed: |r", max - value .. " (" .. perNeed .. ")", 1, 1, 1, .8, .2, .2)
	GameTooltip:AddDoubleLine(T.cStart .. "Total: |r", max - min, 1, 1, 1, 1, 1, 1)
	
	GameTooltip:Show()
end)
rep:HookScript("OnLeave", function() GameTooltip:Hide() end)

rep:RegisterEvent("UPDATE_FACTION")
rep:RegisterEvent("PLAYER_ENTERING_WORLD")
rep:HookScript("OnEvent", event)
