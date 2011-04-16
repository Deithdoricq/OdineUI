-- English localization file for enUS and enGB.
local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("OUI", "enUS", true)
if not L then return end

-- Menu
L["Action Bars"] = true
L["Nameplates"] = true
L["Unit Frames"] = true
L["Raid/Party Settings"] = true
L["Data Texts"] = true
L["Chat"] = true
L["Misc"] = true
L["Tooltip"] = true
L["Media"] = true
L["Class Timers"] = true
L["Filters"] = true
L["Profiles"] = true
L["RELOAD_UI"] = "A setting you have changed requires a Reload UI for changes to take effect, when you are done configing hit Accept to APPLY your changes!"

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
L["Unit Frames"] = true
	L["Configure Settings for Unit Frames"] = "Configure settings for Unit Frames"
	L["Enable or Disable Unit Frames"] = "Enable or Disable Unit Frames"
	L["Arena Frames"] = true
	L["General Options"] = true
	L["Show Hostility Color"] = true
		L["Enemy target (players) color by hostility, very useful for healer."] = true
	L["Portraits"] = true
		L["Enable displaying character portraits on select frames"] = true
	L["Total HP/MP"] = true
		L["Changes the display of info text on player and target frame with XXXX/Total if enabled."] = true
	L["Show PVP Target Mana"] = true
		L["When enabled will show pvp targets amount of mana."] = true
	
-- Name plates
L["Nameplates"] = true
	L["NP_DESC"] = "Configure options for nameplates"

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
	
-- Class timers
L["Class Timers"] = true
	L["CLASSTIMER_DESC"] = "Adjust settings for classtimers"
	L["Enable Class Timers"] = true
	L["Bar Height"] = true
		L["Controls the height of the bar"] = true
	L["Bar Spacing"] = true
		L["Controls the spacing in between bars"] = true
	L["Icon Position"] = true
		L["0 = Left\n1 = Right\n2 = Outside Left\n3 = Outside Right"] = true
	L["Layout"]	 = true
		L["LAYOUT_DESC"] = "1 - Target auras in one frame right above player frame\n2 - Player and target auras separated into two frames above player frame\n3 - Player, target and trinket auras separated into three frames above player frame\n4 - Player and trinket auras are shown above player frame and target auras are shown above target frame\n 5 - Everything above player frame, no target debuffs."
	L["Spark"] = true
		L["Display spark"] = true
	L["Cast Seperator"] = true
	L["Buff"] = true
	L["Debuff"] = true
	L["Proc"] = true
	
	
	
-- Spellfilters
L["Select Spell"] = true
L["Enabled"] = true
L["Position"] = true
	L["POS_DESC"] = "Position where the buff appears on the frame"
L["Any Unit"] = true
	L["ANYUNIT_DESC"] = "Display the buff if cast by anyone?"
L["Color"] = true
L["Procs"] = true
L["Choose Filter"] = true
	L["CFILTER_DESC"] = "Choose the filter you want to modify."
L["Choose the filter you want to modify."] = true
L["New Spell ID"] = true
L["New name"] = true
L["Remove ID"] = true
L["Remove Name"] = true
L["Add a new spell name / ID to the list."] = true
L["Display the buff if cast by anyone?"] = true
L["Only display on this type of unit"] = true
L["Show Ticks"] = true
L["Unit Type"] = true
L["All"] = true
L["Friendly"] = true
L["Enemy"] = true
L["Fill only if you want to see line on bar that indicates if its safe to start casting spell and not clip the last tick, also note that this can be different from aura id."] = true