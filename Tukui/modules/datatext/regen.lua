-----------------------------------------
-- Mana Regen
-----------------------------------------
local T, C, L = unpack(select(2, ...)) -- Import Functions/Constants, Config, Locales

if not C["datatext"].regen or C["datatext"].regen == 0 then return end

local Stat = CreateFrame("Frame")
Stat:SetFrameStrata("MEDIUM")
Stat:SetFrameLevel(3)

local Text  = TukuiInfoLeft:CreateFontString(nil, "LOW")
Text:SetFont(C["media"].dfont, C["datatext"].fsize, "OUTLINE")
Text:SetShadowOffset(T.mult, -T.mult)
T.PP(C["datatext"].regen, Text)

local _G = getfenv(0)
local format = string.format
--local displayManaRegen = string.join("", T.cStart, "%s", "|r%.2f (%.2f)")
local displayManaRegen = string.join("", T.cStart, "%s", "|r%.2f")

-- initial delay for update (let the ui load)
local int = 5
local function Update(self, t)
	int = int - t
	if int > 0 then return end

	local baseMR, castingMR = GetManaRegen()

	--Text:SetFormattedText(displayManaRegen, "MANA: ", baseMR, castingMR)
	Text:SetFormattedText(displayManaRegen, "MANA: ", baseMR)
	int = 2
end

Stat:SetScript("OnUpdate", Update)
Update(Stat, 6)