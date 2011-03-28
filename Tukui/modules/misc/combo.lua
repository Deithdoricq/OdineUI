-- sCombo by Smelly
local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

if C["unitframes"].enable ~= true or C["misc"].combo ~= true then return end

TukuiTarget:DisableElement('CPoints')
if TukuiTarget.CPoints then
	if TukuiTarget.CPoints[1] then
		for i = 1, 5 do TukuiTarget.CPoints[i]:Hide() end
	else
		TukuiTarget.CPoints:Hide()
	end
end

local Options = {
	x = T.Scale(3),
	comboWidth = T.Scale(50),
	comboHeight = T.Scale(10),
	anchor = {"CENTER", UIParent, "CENTER", 0, -150},
	colors = {
		[1] = {0.69, 0.31, 0.31, 1},
		[2] = {0.65, 0.42, 0.31, 1},
		[3] = {0.65, 0.63, 0.35, 1},
		[4] = {0.46, 0.63, 0.35, 1},
		[5] = {0.33, 0.63, 0.33, 1},
	},
}

local sCombo = CreateFrame("Frame", "sCombo", UIParent)
sCombo:CreatePanel("Default", Options.comboWidth * 5 + Options.x * 4, Options.comboHeight, "CENTER", UIParent, "CENTER", 0,0)
sCombo:Point(unpack(Options.anchor))
sCombo:Hide()
sCombo:SetMovable(true)
for i = 1, 5 do
	sCombo[i] = CreateFrame("Frame", "sCombo"..i, UIParent)
	sCombo[i]:CreatePanel("Default", Options.comboWidth, Options.comboHeight, "CENTER", UIParent, "CENTER", 0, 0)
	sCombo[i]:CreateShadow("Default")
		
	if i == 1 then
		sCombo[i]:SetPoint("TOPLEFT", sCombo, "TOPLEFT")
	else
		sCombo[i]:Point("LEFT", sCombo[i-1], "RIGHT", Options.x, 0)
	end
	
	sCombo[i]:SetBackdropBorderColor(unpack(Options.colors[i]))
	sCombo[i]:RegisterEvent("PLAYER_ENTERING_WORLD")
	sCombo[i]:RegisterEvent("UNIT_COMBO_POINTS")
	sCombo[i]:RegisterEvent("PLAYER_TARGET_CHANGED")
	sCombo[i]:SetScript("OnEvent", function(self, event)
	local points, pt = 0, GetComboPoints("player", "target")
		if pt == points then
			sCombo[i]:Hide()
		elseif pt > points then
			for i = points + 1, pt do
				sCombo[i]:Show()
			end
		else
			for i = pt + 1, points do
				sCombo[i]:Hide()
			end
		end
		points = pt	
	end)
end

sCombo.text = T.SetFontString(sCombo, C["media"].uffont, 14, "OUTLINE")
sCombo.text:SetText("sCombo")
sCombo.text:SetPoint("CENTER")
T.MoverFrames[(#T.MoverFrames)+1] = sCombo
local originalExec = T.exec
function T.exec(...)
	self, enable = ...
	if self == sCombo then
		if enable then
			self:SetBackdropBorderColor(1,0,0,1)
			self:Show()
		else
			self:SetBackdropBorderColor(0,0,0,0)
			self:Hide()
		end
	end
	return originalExec(...)
end