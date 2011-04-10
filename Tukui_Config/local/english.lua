-- English localization file for enUS and enGB.
local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("OUI", "enUS", true)
if not L then return end

-- General Section
L["General Settings"] = true
	L["OUI_INTRO"] = "Complete UI replacement based off Tukui. Creditz: Dajova, Elv, Eclipse, Tukz"
	L["Auto Scale"] = true
		L["GEN_ASCALE"] = "Automatically scale the UI based on your current screen resolution"
	L["Scale"] = true
		L["GEN_SCALE"] = "Manualy adjust the scale of your UI"
	L["Multisample Protection"] = true
		L["GEN_SAMPLE"] = "Force the Blizzard Multisample Option to be set to 1x. WARNING: Turning this off will lead to blurry borders"

-- Unit Frames
L["UnitFrames"] = true
	L["UF_DESC"] = "Configure settings for Unit Frames"
	L["UF_ENABLE"] = "Enable or Disable Unit Frames"
	
-- Name plates
L["Nameplates"] = true
	L["NP_DESC"] = "Configure options for nameplates"

--Profiles
L["Profiles"] = true

--Datatext
L["DT_POS"] = "\n\n0 - Disabled\n1 - LEFT PANEL, LEFT\n2 - LEFT PANEL, CENTER\n3 - LEFT PANEL, RIGHT\n4 - RIGHT PANEL, LEFT\n5 - RIGHT PANEL, CENTER\n6 - RIGHT PANEL, RIGHT\n7 - MIDDLE, OUTER LEFT\n8 - MIDDLE, LEFT\n9 - MIDDLE, CENTER\n10 - MIDDLE, RIGHT\n11 - MIDDLE, OUTER RIGHT"
