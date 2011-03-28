local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
--------------------------------------------------------------------
-- FPS
--------------------------------------------------------------------

if C["datatext"].fps_ms and C["datatext"].fps_ms > 0 then
	local Stat = CreateFrame("Frame")
	Stat:SetFrameStrata("BACKGROUND")
	Stat:SetFrameLevel(3)
	Stat:EnableMouse(true)
	
	local Text  = TukuiInfoLeft:CreateFontString(nil, "OVERLAY")
	Text:SetFont(C["media"].dfont, C["datatext"].fsize, "OUTLINE")
	T.PP(C["datatext"].fps_ms, Text)

	local int = 1
	local function Update(self, t)
		int = int - t
		if int < 0 then
			Text:SetText(floor(GetFramerate()) .. T.cStart .. L.datatext_fps .. T.cEnd .. select(3, GetNetStats()) .. T.cStart .. L.datatext_ms .. T.cEnd)
			
			self:SetAllPoints(Text)
			int = 1
		end	
	end
	Stat:SetScript("OnUpdate", Update)
	
	Stat:SetScript("OnEnter", function(self)
		if not InCombatLockdown() then
			local anchor, panel, xoff, yoff = T.DataTextTooltipAnchor(Text)
			local _, _, latencyHome, latencyWorld = GetNetStats()
			local latency = format(MAINMENUBAR_LATENCY_LABEL, latencyHome, latencyWorld)
			GameTooltip:SetOwner(panel, anchor, xoff, yoff)
			GameTooltip:ClearLines()
			GameTooltip:AddLine(latency)
			GameTooltip:Show()
		end
	end)  
	Stat:SetScript("OnLeave", function() GameTooltip:Hide() end) 
	Update(Stat, 10)
end