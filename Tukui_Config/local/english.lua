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
	L["Override LOW -> HIGH"] = true
		L["OVERRIDE_DESC"] = "This is EXPERIMENTAL! Override lower version to higher version on a lower reso setup!"
	L["Color Options"] = true
	L["Unicolor Theme"] = true
		L["UNICOLOR_DESC"] = "When checked allows you to choose health and bg colors below, unchecked will use class colors"
	L["Healthbar Color"] = true
		L["HBAR_DESC"] = "Allows you to select a custom color for health bars"
	L["Healthbar BG Color"] = true
		L["HBARBG_DESC"] = "Allows you to select a custom color for health bars BG"
	
		
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


-- Media group
L["Media"] = true
	L["MEDIA_DESC"] = "Customize display settings"
L["Fonts"] = true
L["General Font"] = true
	L["GFONT_DESC"] = "The font that the core of the UI will use"
L["UnitFrame Font"] = true
	L["UFFONT_DESC"] = "The font that unitframes will use"
L["Combat Font"] = true
	L["COMFONT_DESC"] = "The font that combat text will use. WARNING: This requires a game restart after changing this option."
L["Chat Font"] = true
	L["CHTFONT_DESC"] = "The font that chatframes will use"
L["Chat Font Size"] = true
	L["CHTSIZE_DESC"] = "Change the size of your chat font."
L["Datatext Font"] = true
	L["DTFONT_DESC"] = "The font that datatexts will use"
L["Datatext Font Size"] = true
	L["DTSIZE_DESC"] = "Change the size of your datatext font."
L["Textures"] = true
L["Default Texture"] = true
	L["DTEX_DESC"] = "Texture that gets used on just about everything"
L["Glow Border"] = true
	L["GTEX_DESC"] = "Shadow Effect"
L["Backdrop Texture"] = true
	L["BTEX_DESC"] = "Used on almost all frames"
L["Sounds"] = true
L["Whisper Sound"] = true
	L["WHISOUND_DESC"] = "Sound that is played when recieving a whisper"
L["Warning Sound"] = true
	L["WARSOUND_DESC"] = "Sound that is played when you don't have a buff active"
L["Colors"] = true
L["Border Color"] = true
	L["BCOLOR_DESC"] = "Main Frame's Border Color"
L["Backdrop Color"] = true
	L["BDROP_DESC"] = "Main Frame's Backdrop Color"
L["Alt Border Color"] = true
	L["ABDROP_DESC"] = "Main Frame's Alternate Border Color"
	
	
	
-- Spellfilters
L["Select Spell"] = true
L["Enabled"] = true
L["Position"] = true
	L["POS_DESC"] = "Position where the buff appears on the frame"
L["Any Unit"] = true
	L["ANYUNIT_DESC"] = "Display the buff if cast by anyone?"
L["Color"] = true

L["Choose Filter"] = true
	L["CFILTER_DESC"] = "Choose the filter you want to modify."
L["New Spell ID"] = true
L["New name"] = true
L["Remove ID"] = true
L["Remove Name"] = true
L["Add a new spell name / ID to the list."] = true