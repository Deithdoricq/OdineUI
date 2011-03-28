local OUI = LibStub("AceAddon-3.0"):NewAddon("OUI", "AceConsole-3.0", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("OUI", false)
local LSM = LibStub("LibSharedMedia-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local db
local defaults

function OUI:LoadDefaults()
	local _, _, _, DB = unpack(Tukui)

	defaults = {
		profile = {
			general = DB["general"],
			unitframes = DB["unitframes"],
			nameplate = DB["nameplate"],
			arena = DB["arena"],
			actionbar = DB["actionbar"],
			auras = DB["auras"],
			bags = DB["bags"],
			map = DB["map"],
			loot = DB["loot"],
			cooldown = DB["cooldown"],
			misc = DB["misc"],
			chat = DB["chat"],
			datatext = DB["datatext"],
			tooltip = DB["tooltip"],
			merchant = DB["merchant"],
			invite = DB["invite"],
			buffreminder = DB["buffreminder"],
			addonskins = DB["addonskins"],
			media = DB["media"],
			error = DB["error"],
		},
	}
end

function OUI:OnInitialize()
	self:RegisterEvent("PLAYER_LOGIN")
	
	self.OnInitialize = nil
	
	StaticPopupDialogs["RELOAD_UI"] = {
		text = "You must reload your UI",
		button1 = ACCEPT,
		button2 = CANCEL,
		OnAccept = function() ReloadUI() end,
		timeout = 0,
		whileDead = 1,
	}

end

function OUI:PLAYER_LOGIN()
	self:LoadDefaults()

	self.db = LibStub("AceDB-3.0"):New("OUIDB", defaults) -- PerChar
	
	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")
	db = self.db.profile
	
	self:SetupOptions()
end

function OUI:OnProfileChanged(event, database, newProfileKey)
	StaticPopup_Show("RELOAD_UI")
end

function OUI:ChatCommand(input)
	if not input or input:trim() == "" then
		LibStub("AceConfigDialog-3.0"):Open("OUI")
	else
		LibStub("AceConfigCmd-3.0").HandleCommand(OUI, "oui", "OUI", input)
	end
end

local ouioptions = {
	type = "group",
	name = "OUI",
	args = {
		general = {
			order = 1,
			type = "group",
			name = L["General Settings"],
			desc = L["General Settings"],
			get = function(info) return db.general[ info[#info] ] end,
			set = function(info, value) db.general[ info[#info] ] = value; StaticPopup_Show("RELOAD_UI") end,
			args = {
				intro = {
					order = 1,
					type = "description",
					name = L["OUI_INTRO"],
				},
				autoscale = {
					order = 2,
					name = L["Auto Scale"],
					desc = L["GEN_ASCALE"],
					type = "toggle",
				},					
				uiscale = {
					order = 3,
					name = L["Scale"],
					desc = L["GEN_SCALE"],
					disabled = function(info) return db.general.autoscale end,
					type = "range",
					min = 0.64, max = 1, step = 0.01,
					isPercent = true,
				},
				multisampleprotect = {
					order = 4,
					name = L["Multisample Protection"],
					desc = L["GEN_SAMPLE"],
					type = "toggle",
				},
				overridelowtohigh = {
					order = 5,
					name = "Override LOW -> HIGH",
					desc = "This is EXPERIMENTAL! Override lower version to higher version on a lower reso setup!",
					type = "toggle",
				},
			},
		},
		unitframes = {
			order = 2,
			type = "group",
			name = "UnitFrames",
			desc = "Configure Settings for Unit Frames",
			get = function(info) return db.unitframes[ info[#info] ] end,
			set = function(info, value) db.unitframes[ info[#info] ] = value; StaticPopup_Show("RELOAD_UI") end,
			args = {
				enable = {
					order = 2,
					name = "Enable",
					desc = L["UF_ENABLE"],
					type = "toggle",
				},
				enablearena = {
					order = 2.5,
					name = "Arena Frames",
					desc = "Toggle whether you want to use arena frames.",
					type = "toggle",
					get = function(info) return db.arena.unitframes end,
					set = function(info, value) db.arena.unitframes = value; StaticPopup_show("RELOAD_UI") end,
					disabled = function() return not db.unitframes.enable end,
				},
				UFOptions = {
					order = 3,
					type = "group",
					name = "General Options",
					guiInline = true,
					disabled = function() return not db.unitframes.enable end,
					args = {
						enemyhcolor = {
							type = "toggle",
							order = 1,
							name = "Show Hostility Color",
							desc = "Enemy target (players) color by hostility, very useful for healer.",
						},
						charportrait = {
							type = "toggle",
							order = 2,
							name = "Portraits",
							desc = "Enable displaying character portraits on select frames",
						},
						showtotalhpmp = {
							type = "toggle",
							order = 3,
							name = "Total HP/MP",
							desc = "Changes the display of info text on player and target frame with XXXX/Total if enabled.",
						},
						targetpowerpvponly = {
							type = "toggle",
							order = 4,
							name = "Show PVP Target Mana",
							desc = "When enabled will show pvp targets amount of mana.",
						},
						showsmooth = {
							type = "toggle",
							order = 5,
							name = "Smooth Bars",
							desc = "Enables bars having a smooth look n feel.",
						},
						combatfeedback = {
							type = "toggle",
							order = 6,
							name = "Combat Feedback",
							desc = "Enable combat text on player and target",
						},
						playeraggro = {
							type = "toggle",
							order = 7,
							name = "Player Aggro",
							desc = "Enable coloring border red when player has aggro",
						},
						percentage = {
							type = "toggle",
							order = 8,
							name = "Show Percentages",
							desc = "Enable showing percentages for health/mana outside of unitframes.",
						},
						vengeance = {
							type = "toggle",
							order = 9,
							name = "Vengeance bar",
							desc = "Enable displaying a vengeance bar over bottom middle datatext panel.",
						},
						swingbar = {
							type = "toggle",
							order = 10,
							name = "Swing bar",
							desc = "Enable showing your swingbar.",
						},
						lowThreshold = {
							type = "range",
							order = 11,
							name = "Low Mana Threshold",
							desc = "When to be warned about low mana",
							type = "range",
							min = 1, max = 99, step = 1,							
						},
					},
				},
				Colors = {
					type = "group",
					order = 4,
					name = "Color Options",
					guiInline = true,
					disabled = function() return not db.unitframes.enable end,
					args = {
						unicolor = {
							type = "toggle",
							order = 1,
							name = "Unicolor Theme",
							desc = "When checked allows you to choose health and bg colors below, unchecked will use class colors",
						},
						empty5 = {
							name = "   ",
							width = "half",
							type = "description",
							order = 1.5,
						},
						healthColor = {
							type = "color",
							order = 2,
							name = "Healthbar Color",
							desc = "Allows you to select a custom color for health bars",
							disabled = function() return not db.unitframes.unicolor end,
							get = function(info)
								local r, g, b = unpack(db.unitframes[ info[#info] ])
								return r, g, b
							end,
							set = function(info, r, g, b)
								StaticPopup_Show("RELOAD_UI")
								db.unitframes[ info[#info] ] = {r, g, b}
							end,
							hasAlpha = false,
						},
						healthBgColor = {
							type = "color",
							order = 3,
							name = "Healthbar BG Color",
							desc = "Allows you to select a custom color for health bars BG",
							disabled = function() return not db.unitframes.unicolor end,
							get = function(info)
								local r, g, b = unpack(db.unitframes[ info[#info] ])
								return r, g, b
							end,
							set = function(info, r, g, b)
								StaticPopup_Show("RELOAD_UI")
								db.unitframes[ info[#info] ] = {r, g, b}
							end,
							hasAlpha = false,
						},
					},
				},
				Castbar = {
					order = 5,
					type = "group",
					name = "Castbar Settings",
					guiInline = true,
					disabled = function() return not db.unitframes.enable end,
					get = function(info) return db.unitframes[ info[#info] ] end,
					set = function(info, value) db.unitframes[ info[#info] ] = value; StaticPopup_Show("RELOAD_UI") end,
					args = {
						unitcastbar = {
							type = "toggle",
							order = 1,
							name = "Enable Cast Bars",
							desc = "Customize settings of your cast bars",
						},
						cblatency = {
							type = "toggle",
							order = 2,
							name = "Show latency",
							desc = "Show your latency in castbar",
							disabled = function() return not db.unitframes.unitcastbar end,
						},
						cbicons = {
							type = "toggle",
							order = 3,
							name = "Show icons",
							desc = "Show icons with castbar",
							disabled = function() return not db.unitframes.unitcastbar end,
						},
						cbinside = {
							type = "toggle",
							order = 3.5,
							name = "Inside UF",
							desc = "When enabled castbars are inside of your player/target frame. (ONLY WORKS IF LARGE PLAYER CASTBAR IS DISABLED)",
							disabled = function() return (not db.unitframes.unitcastbar or db.unitframes.large_player) end,
						},
						large_player = {
							type = "toggle",
							order = 4,
							name = "Large Player castbar",
							desc = "Allows you to use a bigger castbar for your casts",										
							disabled = function() return (not db.unitframes.unitcastbar or db.unitframes.cbinside) end,
						},
						emptyuf88 = {
							name = "   ",
							width = "full",
							type = "description",
							order = 4.5,
						},
						cbclasscolor = {
							type = "toggle",
							order = 5,
							name = "Class colors",
							desc = "Allows you to use class colors for castbars",										
						},
						cbcustomcolor = {
							type = "color",
							order = 6,
							name = "Castbar Color",
							desc = "Allows you to select a custom color for castbars",
							disabled = function() return (db.unitframes.cbclasscolor or not db.unitframes.unitcastbar) end,
							hasAlpha = false,
						},
					},
				},
				Auras = {
					order = 6,
					type = "group",
					name = "Buffs & Debuffs",
					guiInline = true,
					disabled = function() return not db.unitframes.enable end,
					get = function(info) return db.unitframes[ info[#info] ] end,
					set = function(info, value) db.unitframes[ info[#info] ] = value; StaticPopup_Show("RELOAD_UI") end,
					args = {
						auratimer = {
							type = "toggle",
							order = 1,
							name = "Aura Timers",
							desc = "Enable aura timers on buffs/debuffs",
						},
						auratextscale = {
							type = "range",
							order = 2,
							name = "Aura Text Scale",
							desc = "Controls the size of the aura font",
							type = "range",
							min = 8, max = 16, step = 1,									
						},
						playerauras = {
							type = "toggle",
							order = 3,
							name = "Player Auras",
							desc = "Display auras on player frame",				
						},
						targetauras = {
							type = "toggle",
							order = 4,
							name = "Target Auras",
							desc = "Display auras on target frame",								
						},
						totdebuffs = {
							type = "toggle",
							order = 5,
							name = "ToT Debuffs",
							desc = "Display debuffs on target of target frame",									
						},
						focusdebuffs = {
							type = "toggle",
							order = 6,
							name = "Focus Debuffs",
							desc = "Display debuffs on focus frame",									
						},
						focusbuffs = {
							type = "toggle",
							order = 7,
							name = "Focus Debuffs",
							desc = "Display buffs on focus frame",									
						},
						petbuffs = {
							type = "toggle",
							order = 8,
							name = "Pet Buffs",
							desc = "Display buffs on your pet",									
						},
						onlyselfdebuffs = {
							type = "toggle",
							order = 9,
							name = "Only My Debuffs",
							desc = "Display only your debuffs on target frame",									
						},
						onlyselfbuffs = {
							type = "toggle",
							order = 10,
							name = "Only My Buffs",
							desc = "Display only your buffs on target frame",									
						},
						buffrows = {
							type = "range",
							order = 11,
							name = "Buff Rows",
							desc = "Controls how many rows of buffs are allowed",
							type = "range",
							min = 1, max = 3, step = 1,									
						},
						debuffrows = {
							type = "range",
							order = 12,
							name = "Debuff Rows",
							desc = "Controls how many rows of debuffs are allowed",
							type = "range",
							min = 1, max = 3, step = 1,									
						},
					},
				},
				Frames = {
					order = 7,
					type = "group",
					name = "Raid/Party Settings",
					guiInline = true,
					disabled = function() return not db.unitframes.enable end,
					get = function(info) return db.unitframes[ info[#info] ] end,
					set = function(info, value) db.unitframes[ info[#info] ] = value; StaticPopup_Show("RELOAD_UI") end,
					args = {
						showrange = {
							type = "toggle",
							order = 1,
							name = "Range Opacity",
							desc = "Toggles whether you want to use alpha opacity for units out of range",									
						},
						raidalphaoor = {
							type = "range",
							order = 2,
							name = "Alpha Amount",
							desc = "Controls how much alpha is used when unit is out of range",
							type = "range",
							disabled = function() return (not db.unitframes.enable or not db.unitframes.showrange) end,
							min = 1, max = 3, step = 1,									
						},
						showplayerinparty = {
							type = "toggle",
							order = 3,
							name = "Show Self",
							desc = "Toggles whether you want to be displayed in party frames",									
						},
						showsymbols = {
							type = "toggle",
							order = 4,
							name = "Show Symbols",
							desc = "Toggles whether you want to show raid symbols in frames",									
						},
						aggro = {
							type = "toggle",
							order = 5,
							name = "Show Aggro",
							desc = "Toggles whether you want to show aggro on all raid frames",									
						},
						raidunitdebuffwatch = {
							type = "toggle",
							order = 6,
							name = "Show Debuffs",
							desc = "Toggles whether you want to show aggro on all raid frames",									
						},
						healcomm = {
							type = "toggle",
							order = 7,
							name = "Healcomm",
							desc = "Toggles whether you want to display incoming heals",						
						},
						healthvertical = { -- healer layout only
							type = "toggle",
							order = 8,
							name = "Display HP Vertically",
							desc = "Toggles whether you want to display health vertically instead.(HEAL LAYOUT ONLY)",
						},
						healthdeficit = { -- healer layout only
							type = "toggle",
							order = 9,
							name = "Display HP Deficit",
							desc = "Toggles whether you want to display HP deficits instead.(HEAL LAYOUT ONLY)",
						},
						hidepower = { -- dps layout only
							type = "toggle",
							order = 10,
							name = "Hide Power",
							desc = "Toggles whether you want to hide Power from being displayed on raid/party frames.(DPS LAYOUT ONLY)",
						},
						maintank = { 
							type = "toggle",
							order = 11,
							name = "Show Main Tank",
							desc = "Toggles Main Tank display.",
						},
						mainassist = { 
							type = "toggle",
							order = 12,
							name = "Show Main Assist",
							desc = "Toggles Main Assist display.",
						},
						showboss = {
							type = "toggle",
							order = 13,
							name = "Show Boss Frames",
							desc = "Toggles whether you want to display frames for bosses.",
						},
					},
				},
				ClassOpts = {
					order = 8,
					type = "group",
					name = "Class Related",
					guiInline = true,
					disabled = function() return not db.unitframes.enable end,
					get = function(info) return db.unitframes[ info[#info] ] end,
					set = function(info, value) db.unitframes[ info[#info] ] = value; StaticPopup_Show("RELOAD_UI") end,
					args = {
						classbar = {
							type = "toggle",
							order = 1,
							name = "Class Bars",
							desc = "Toggles whether you want to use class related bars.(ie: totem bar, rune bar, eclipse bar)",
						},
						empty7 = {
							name = "   ",
							width = "full",
							type = "description",
							order = 1.5,
						},
						deathknight = {
							type = "toggle",
							order = 2,
							name = "Deathknight",
							desc = "Toggles whether you want to display a rune bar.",
							disabled = function() return not db.unitframes.classbar end,
						},
						warlock = {
							type = "toggle",
							order = 3,
							name = "Warlock",
							desc = "Toggles whether you want to display warlock options.",
							disabled = function() return not db.unitframes.classbar end,
						},
						shaman = {
							type = "toggle",
							order = 4,
							name = "Shaman",
							desc = "Toggles whether you want to display a totem bar.",
							disabled = function() return not db.unitframes.classbar end,
						},
						druid = {
							type = "toggle",
							order = 5,
							name = "Druid",
							desc = "Toggles whether you want to display an eclipse bar.",
							disabled = function() return not db.unitframes.classbar end,
						},
						paladin = {
							type = "toggle",
							order = 6,
							name = "Paladin",
							desc = "Toggles whether you want to display holy power.",
							disabled = function() return not db.unitframes.classbar end,
						},
						weakenedsoulbar = {
							type = "toggle",
							order = 7,
							name = "Priest",
							desc = "Toggles whether you want to display a weakened soul bar",
							disabled = function() return not db.unitframes.classbar end,
						},
					},
				},
			},
		},
		nameplate = {
			order = 5,
			type = "group",
			name = "Nameplates",
			desc = L["NP_DESC"],
			get = function(info) return db.nameplate[ info[#info] ] end,
			set = function(info, value) db.nameplate[ info[#info] ] = value; StaticPopup_Show("RELOAD_UI") end,
			args = {
				intro = {
					order = 1,
					type = "description",
					name = L["NP_DESC"],
				},				
				enable = {
					type = "toggle",
					order = 2,
					name = ENABLE,
					desc = "Enable/Disable Nameplates",
					set = function(info, value)
						db.nameplate[ info[#info] ] = value; 
						StaticPopup_Show("RELOAD_UI")
					end,
				},
				Nameplates = {
					type = "group",
					order = 3,
					name = "Nameplate Options",
					guiInline = true,		
					disabled = function() return not db.nameplate.enable end,
					args = {
						showhealth = {
							type = "toggle",
							order = 1,
							name = "Show Health",
							desc = "Display health values on nameplates, this will also increase the size of the nameplate",
						},
						enhancethreat = {
							type = "toggle",
							order = 2,
							name = "Health Threat Coloring",
							desc = "Color the nameplate's healthbar by your current threat, Example: good threat color is used if your a tank when you have threat, opposite for DPS.",
						},
						combat = {
							type = "toggle",
							order = 3,
							name = "Toggle Combat",
							desc = "Toggles the nameplates off when not in combat.",							
						},
						trackdebuffs = {
							type = "toggle",
							order = 4,
							name = "Track Debuffs",
							desc = "Tracks your debuffs on nameplates.",									
						},
						trackcc = {
							type = "toggle",
							order = 5,
							name = "Track CC",
							desc = "Tracks CC debuffs on nameplates from you or a friendly player",										
						},
						Colors = {
							type = "group",
							order = 6,
							name = "Colors",
							guiInline = true,	
							get = function(info)
								local r, g, b = unpack(db.nameplate[ info[#info] ])
								return r, g, b
							end,
							set = function(info, r, g, b)
								db.nameplate[ info[#info] ] = {r, g, b}
								StaticPopup_Show("RELOAD_UI")
							end,
							disabled = function() return (not db.nameplate.enhancethreat or not db.nameplate.enable) end,								
							args = {
								goodcolor = {
									type = "color",
									order = 1,
									name = "Good Color",
									desc = "This is displayed when you have threat as a tank, if you don't have threat it is displayed as a DPS/Healer",
									hasAlpha = false,
									
								},		
								badcolor = {
									type = "color",
									order = 2,
									name = "Bad Color",
									desc = "This is displayed when you don't have threat as a tank, if you do have threat it is displayed as a DPS/Healer",
									hasAlpha = false,
								},
								transitioncolor = {
									type = "color",
									order = 3,
									name = "Transition Color",
									desc = "This color is displayed when gaining/losing threat",
									hasAlpha = false,									
								},
							},
						},
					},
				},
			},
		},
		actionbar = {
			order = 6,
			type = "group",
			name = "Actionbars",
			desc = "Customize your actionbars",
			get = function(info) return db.actionbar[ info[#info] ] end,
			set = function(info, value) db.actionbar[ info[#info] ] = value; StaticPopup_Show("RELOAD_UI") end,
			args = {
				enable = {
					type = "toggle",
					order = 1,
					name = "Enable",
					desc = "Enable using built in actionbars.",									
				},
				hotkey = {
					type = "toggle",
					order = 2,
					name = "Show Hotkeys",
					desc = "Toggle whether you want to show keybindings on your actionbar buttons.",									
				},
				hideshapeshift = {
					type = "toggle",
					order = 3,
					name = "Hide Shapeshift",
					desc = "Toggle whether you want to show your shapeshift/totems.",									
				},
				showgrid = {
					type = "toggle",
					order = 4,
					name = "Show Grid",
					desc = "Toggle whether you want to show a grid on empty buttons.",									
				},
				vertical_rightbars = {
					type = "toggle",
					order = 5,
					name = "Vertical Rightbars",
					desc = "Toggle whether you want .",									
				},
				empty8 = {
					name = "   ",
					width = "full",
					type = "description",
					order = 6,
				},
				buttonsize = {
					type = "range",
					order = 7,
					name = "Button Size",
					desc = "Controls the size of actionbar buttons.",
					type = "range",
					min = 20, max = 33, step = 1,									
				},
				petbuttonsize = {
					type = "range",
					order = 8,
					name = "Pet Button Size",
					desc = "Controls the size of your pets actionbar buttons.",
					type = "range",
					min = 20, max = 33, step = 1,									
				},
				stancebuttonsize = {
					type = "range",
					order = 9,
					name = "Stance Button Size",
					desc = "Controls the size of your stance actionbar buttons.",
					type = "range",
					min = 20, max = 33, step = 1,									
				},
				buttonspacing = {
					type = "range",
					order = 10,
					name = "Button Spacing",
					desc = "Controls the spacing between buttons.",
					type = "range",
					min = 0, max = 8, step = 1,									
				},
			},
		},
		misc = {
			order = 7,
			type = "group",
			name = "Misc Options",
			desc = "Misc Options",
			args = {
				Loot = {
					order = 1,
					type = "group",
					name = "Loot",
					guiInline = true,
					get = function(info) return db.loot[ info[#info] ] end,
					set = function(info, value) db.loot[ info[#info] ] = value; StaticPopup_Show("RELOAD_UI") end,
					args = {
						lootframe = {
							type = "toggle",
							order = 1,
							name = "Loot frame",
							desc = "Toggles whether you want to use built in loot frames.",
						},
						rolllootframe = {
							type = "toggle",
							order = 2,
							name = "Roll frame",
							desc = "Toggles whether you want to use built in roll frames.",
						},
						autogreed = {
							type = "toggle",
							order = 3,
							name = "Auto greed",
							desc = "Toggles whether you auto-dez or auto-greed item at max level.",
						},
					},
				},
				Merchant = {
					order = 2,
					type = "group",
					name = "Merchant",
					guiInline = true,
					get = function(info) return db.merchant[ info[#info] ] end,
					set = function(info, value) db.merchant[ info[#info] ] = value; StaticPopup_Show("RELOAD_UI") end,
					args = {
						sellgrays = {
							type = "toggle",
							order = 1,
							name = "Sell Grays",
							desc = "Toggles whether you automatically sell grey items when talking to a merchant.",
						},
						autorepair = {
							type = "toggle",
							order = 2,
							name = "Auto repair",
							desc = "Toggles whether you automatically sell repair when talking to a merchant.",
						},
						sellmisc = {
							type = "toggle",
							order = 3,
							name = "Sell Misc",
							desc = "Toggles whether you automatically sell misc/junk items when talking to a merchant.",
						},
					},
				},
				Bags = {
					order = 3,
					type = "group",
					name = "Bags",
					guiInline = true,
					get = function(info) return db.bags[ info[#info] ] end,
					set = function(info, value) db.bags[ info[#info] ] = value; StaticPopup_Show("RELOAD_UI") end,
					args = {
						enable = {
							type = "toggle",
							order = 1,
							name = "Enable",
							desc = "Toggles whether you want to use built bags addon.",
						},
					},
				},
				Map = {
					order = 4,
					type = "group",
					name = "Map",
					guiInline = true,
					get = function(info) return db.map[ info[#info] ] end,
					set = function(info, value) db.map[ info[#info] ] = value; StaticPopup_Show("RELOAD_UI") end,
					args = {
						enable = {
							type = "toggle",
							order = 1,
							name = "Enable",
							desc = "Toggles whether you want to use built map addon.",
						},
					},
				},
				Cooldown = {
					order = 5,
					type = "group",
					name = "Cooldowns",
					guiInline = true,
					get = function(info) return db.cooldown[ info[#info] ] end,
					set = function(info, value) db.cooldown[ info[#info] ] = value; StaticPopup_Show("RELOAD_UI") end,
					args = {
						enable = {
							type = "toggle",
							order = 1,
							name = "Enable",
							desc = "Toggles whether you want to use tukui cooldown addon.",
						},
						treshold = {
							type = "range",
							order = 2,
							name = "Threshold",
							desc = "Toggles when to show decimal under X seconds and turn text turn red.",
							min = 1, max = 30, step = 1,
						},
					},
				},
				Auras = {
					order = 6,
					type = "group",
					name = "Auras",
					guiInline = true,
					get = function(info) return db.auras[ info[#info] ] end,
					set = function(info, value) db.auras[ info[#info] ] = value; StaticPopup_Show("RELOAD_UI") end,
					args = {
						player = {
							type = "toggle",
							order = 1,
							name = "Enable",
							desc = "Toggles whether you want to enable tukui buffs/debuffs.",
						},
					},
				},
				Derp = {
					order = 7,
					type = "group",
					name = "Other",
					guiInline = true,
					get = function(info) return db.misc[ info[#info] ] end,
						set = function(info, value) db.misc[ info[#info] ] = value; StaticPopup_Show("RELOAD_UI") end,
					args = {
						announceint = {
							type = "toggle",
							order = 1,
							name = "Announce interrupts",
							desc = "Toggles whether you want to announce your interrupts to chat.",
						},
						combo = {
							type = "toggle",
							order = 2,
							name = "Combo bar",
							desc = "Toggles whether you want to use a combo bar for rogues/druids.",
						},
						autoaccept = {
							type = "toggle",
							order = 3,
							name = "Auto-accept invites",
							desc = "Toggles whether you want to auto accept invites from friends or guild members.",
							get = function(info) return db.invite.autoaccept end,
							set = function(info, value) db.invite.autoaccept = value; StaticPopup_Show("RELOAD_UI") end,
						},
						autoquest = {
							type = "toggle",
							order = 4,
							name = "Auto-accept quests",
							desc = "Toggles whether you want to autoaccept and auto turn in quests.",
						},
						epgp = {
							type = "toggle",
							order = 5,
							name = "Display EPGP",
							desc = "Toggles whether you want to display EPGP in related sections (guild datatext).",
						},
						viewport = {
							type = "toggle",
							order = 6,
							name = "Viewport",
							desc = "Toggles whether you want to use a viewport.",
						},
						sct = {
							type = "toggle",
							order = 7,
							name = "Combat Text",
							desc = "Toggle whether you want to use Monolit's lightweight SCT mod.",
						},
					},
				},
				Errors = {
					order = 8,
					type = "group",
					name = "Errors",
					guiInline = true,
					get = function(info) return db.error[ info[#info] ] end,
					set = function(info, value) db.error[ info[#info] ] = value; StaticPopup_Show("RELOAD_UI") end,
					args = {
						enable = {
							type = "toggle",
							order = 1,
							name = "Hide Error Text",
							desc = "Toggles whether you want to display the red error text.(out of range, cant cast that yet).",
						},
					},
				},
				Reminders = {
					order = 9,
					type = "group",
					name = "Buff Reminders",
					guiInline = true,
					get = function(info) return db.buffreminder[ info[#info] ] end,
					set = function(info, value) db.buffreminder[ info[#info] ] = value; StaticPopup_Show("RELOAD_UI") end,
					args = {
						enable = {
							type = "toggle",
							order = 1,
							name = "Enable",
							desc = "Toggles whether you want to receive reminders when missing certain buffs.",
						},
						sound = {
							type = "toggle",
							order = 1,
							name = "Warning sound",
							desc = "Toggles whether you want to receive a warning sound when missing certain buffs.",
						},
					},
				},
				Addonskins = {
					order = 10,
					type = "group",
					name = "Addon Skins",
					guiInline = true,
					get = function(info) return db.addonskins[ info[#info] ] end,
					set = function(info, value) db.addonskins[ info[#info] ] = value; StaticPopup_Show("RELOAD_UI") end,
					args = {
						kle = {
							type = "toggle",
							order = 1,
							name = "KLE",
							desc = "Toggles skinning of this addon.",
						},
						tinydps = {
							type = "toggle",
							order = 2,
							name = "TinyDPS",
							desc = "Toggles skinning of this addon.",
						},
						dbm = {
							type = "toggle",
							order = 3,
							name = "DBM",
							desc = "Toggles skinning of this addon.",
						},
						recount = {
							type = "toggle",
							order = 4,
							name = "Recount",
							desc = "Toggles skinning of this addon.",
						},
						omen = {
							type = "toggle",
							order = 5,
							name = "OMEN",
							desc = "Toggles skinning of this addon.",
						},
					},
				},
			},
		},
		chat = {
			order = 8,
			type = "group",
			name = "Chat Options",
			desc = "Chat Options",
			get = function(info) return db.chat[ info[#info] ] end,
			set = function(info, value) db.chat[ info[#info] ] = value; StaticPopup_Show("RELOAD_UI") end,
			args = {
				enable = {
					type = "toggle",
					order = 1,
					name = "Enable",
					desc = "Toggles whether you want to use tukui chat system.",
				},
				whispersound = {
					type = "toggle",
					order = 2,
					name = "Whisper sound",
					desc = "Toggles whether you want to play a sound when you receive whispers.",
					disabled = function() return not db.chat.enable end,
				},
				background = {
					type = "toggle",
					order = 3,
					name = "Background",
					desc = "Toggles whether you want to use backgrounds for chat windows.",
					disabled = function() return not db.chat.enable end,
				},
				fading = {
					type = "toggle",
					order = 4,
					name = "Fading",
					desc = "Toggles whether you want to fade out chat text when not active.",
					disabled = function() return not db.chat.enable end,
				},
				justifyRight = {
					type = "toggle",
					order = 5,
					name = "Justify Right",
					desc = "Toggles whether you want to justify text to the right in your right char box window.",
					disabled = function() return not db.chat.enable end,
				},
				emptyderp5 = {
					name = "   ",
					width = "full",
					type = "description",
					order = 6,
				},
				height = {
					type = "range",
					order = 7,
					name = "Height",
					desc = "Choose the height of chat windows.",
					min = 100, max = 300, step = 1,
					disabled = function() return not db.chat.enable end,
				},
			},
		},
		tooltip = {
			order = 9,
			type = "group",
			name = "Tooltips",
			desc = "Tooltips",
			get = function(info) return db.tooltip[ info[#info] ] end,
			set = function(info, value) db.tooltip[ info[#info] ] = value; StaticPopup_Show("RELOAD_UI") end,
			args = {
				enable = {
					type = "toggle",
					order = 1,
					name = "Enable",
					desc = "Toggles whether you want to use tukui tooltips.",
				},
				empty5t = {
					name = "   ",
					width = "full",
					type = "description",
					order = 1.5,
				},
				hidecombat = {
					type = "toggle",
					order = 2,
					name = "Hide In Combat",
					desc = "Toggles whether you want to show tooltips while in combat.",
					disabled = function() return not db.tooltip.enable end,
				},
				hidebuttons = {
					type = "toggle",
					order = 3,
					name = "Hide Actionbar Tooltips",
					desc = "Toggles whether you want to hide tooltips from actionbar buttons.",
					disabled = function() return not db.tooltip.enable end,
				},
				hideuf = {
					type = "toggle",
					order = 4,
					name = "Hide Unitframe Tooltips",
					desc = "Toggles whether you want to hide tooltips from unitframes.",
					disabled = function() return not db.tooltip.enable end,
				},
				cursor = {
					type = "toggle",
					order = 5,
					name = "Cursor",
					desc = "When enabled allows you to have tooltips display where your mouse is.",
					disabled = function() return not db.tooltip.enable end,
				},
			},
		},
		datatext = {
			order = 10,
			type = "group",
			name = "Datatext",
			desc = "Datatext",
			get = function(info) return db.datatext[ info[#info] ] end,
			set = function(info, value) db.datatext[ info[#info] ] = value; StaticPopup_Show("RELOAD_UI") end,
			args = {
				battleground = {
					type = "toggle",
					order = 1,
					name = "BG Panel",
					desc = "Toggles a datatext panel for battleground stats.",
				},
				time24 = {
					type = "toggle",
					order = 2,
					name = "24H Format",
					desc = "Sets time to 24 hour format.",
				},
				localtime = {
					type = "toggle",
					order = 3,
					name = "Local Time",
					desc = "Set time to use local time instead of server time.",
				},
				empty5dt = {
					name = "   ",
					width = "full",
					type = "description",
					order = 4,
				},
				classcolor = {
					type = "toggle",
					order = 5,
					name = "Classcolor Text",
					desc = "Sets text color from datatext to your class color.",
				},
				color = {
					type = "color",
					order = 6,
					name = "Datatext Color",
					desc = "Set default color used for datatext font when classcolor is not enabled.",
					disabled = function() return db.datatext.classcolor end,
					get = function(info)
						local r, g, b = unpack(db.datatext[ info[#info] ])
						return r, g, b
					end,
					set = function(info, r, g, b)
						db.datatext[ info[#info] ] = {r, g, b}
						StaticPopup_Show("RELOAD_UI")
					end,
					hasAlpha = false,
				},
				DataConfig = {
					order = 6,
					type = "group",
					name = "Text Positions",
					guiInline = true,
					args = {
						armor = {
							order = 1,
							type = "range",
							name = "Armor",
							desc = "Display amount of armor",
							min = 0, max = 8, step = 1,
						},
						avd = {
							order = 2,
							type = "range",
							name = "Avoidance",
							desc = "Display avoidance you currently have",
							min = 0, max = 8, step = 1,
						},
						bags = {
							order = 3,
							type = "range",
							name = "Bags",
							desc = "Display ammount of bag space",
							min = 0, max = 8, step = 1,								
						},
						crit = {
							order = 4,
							type = "range",
							name = "Crit",
							desc = "Display ammount of crit rating",
							min = 0, max = 8, step = 1,								
						},
						currency = {
							order = 5,
							type = "range",
							name = "Currency",
							desc = "Display currency you are tracking",
							min = 0, max = 8, step = 1,								
						},
						dps_text = {
							order = 6,
							type = "range",
							name = "DPS Text",
							desc = "Display ammount of DPS",
							min = 0, max = 8, step = 1,								
						},
						dur = {
							order = 7,
							type = "range",
							name = "Durability",
							desc = "Display your current durability",
							min = 0, max = 8, step = 1,								
						},
						friends = {
							order = 8,
							type = "range",
							name = "Friends",
							desc = "Display ammount of friends online",
							min = 0, max = 8, step = 1,								
						},
						gold = {
							order = 9,
							type = "range",
							name = "Gold",
							desc = "Display gold you have across all toons",
							min = 0, max = 8, step = 1,								
						},
						guild = {
							order = 10,
							type = "range",
							name = "Guild",
							desc = "Display guilld members online",
							min = 0, max = 8, step = 1,								
						},
						haste = {
							order = 11,
							type = "range",
							name = "Haste",
							desc = "Display ammount of haste",
							min = 0, max = 8, step = 1,								
						},
						hit = {
							order = 12,
							type = "range",
							name = "Hit",
							desc = "Display ammount of hit rating",
							min = 0, max = 8, step = 1,								
						},
						hps_text = {
							order = 13,
							type = "range",
							name = "HPS Text",
							desc = "Display your hps in combat",
							min = 0, max = 8, step = 1,								
						},
						mastery = {
							order = 14,
							type = "range",
							name = "Mastery",
							desc = "Display ammount of mastery rating",
							min = 0, max = 8, step = 1,								
						},
						spec = {
							order = 15,
							type = "range",
							name = "Spec",
							desc = "Display current spec, and can be clicked to change to other spec",
							min = 0, max = 8, step = 1,								
						},
						micromenu = {
							order = 16,
							type = "range",
							name = "Micromenu",
							desc = "Display a micromenu",
							min = 0, max = 8, step = 1,								
						},
						power = {
							order = 17,
							type = "range",
							name = "Power",
							desc = "Display ammount of power you have (STR, AGI, INT)",
							min = 0, max = 8, step = 1,								
						},
					},
				},
			},
		},
		media = {
			order = 11,
			type = "group",
			name = "Media",
			desc = "Customize display settings",
			get = function(info) return db.media[ info[#info] ] end,
			set = function(info, value) db.media[ info[#info] ] = value; StaticPopup_Show("RELOAD_UI") end,
			args = {
				Fonts = {
					type = "group",
					order = 1,
					name = "Fonts",
					guiInline = true,
					args = {
						font = {
							type = "select",
							dialogControl = 'LSM30_Font',
							order = 1,
							name = "Font",
							desc = "The font that the core of the UI will use",
							values = AceGUIWidgetLSMlists.font,	
						},
						uffont = {
							type = "select",
							dialogControl = 'LSM30_Font',
							order = 2,
							name = "UnitFrame Font",
							desc = "The font that unitframes will use",
							values = AceGUIWidgetLSMlists.font,	
						},
						dmgfont = {
							type = "select",
							dialogControl = 'LSM30_Font',
							order = 3,
							name = "Combat Text Font",
							desc = "The font that combat text will use. WARNING: This requires a game restart after changing this option.",
							values = AceGUIWidgetLSMlists.font,						
						},
						empty8 = {
							name = "   ",
							width = "full",
							type = "description",
							order = 3.5,
						},
						cfont = {
							type = "select",
							dialogControl = 'LSM30_Font',
							order = 4,
							name = "Chat Font",
							desc = "The font that chatframes will use",
							values = AceGUIWidgetLSMlists.font,
						},
						ct_fsize = {
							order = 5,
							type = "range",
							name = "Chat Font Size",
							desc = "Change the size of your chat font.",
							min = 1, max = 20, step = 1,
							get = function() return db.chat.fsize end,
							set = function(info, value) db.chat.fsize = value; StaticPopup_Show("RELOAD_UI") end,
						},
						dfont = {
							type = "select",
							dialogControl = 'LSM30_Font',
							order = 6,
							name = "Datatext Font",
							desc = "The font that datatexts will use",
							values = AceGUIWidgetLSMlists.font,						
						},
						dt_fsize = {
							order = 7,
							type = "range",
							name = "Datatext Font Size",
							desc = "Change the size of your datatext font.",
							min = 1, max = 20, step = 1,
							get = function() return db.datatext.fsize end,
							set = function(info, value) db.datatext.fsize = value; StaticPopup_Show("RELOAD_UI") end,
						},
					},
				},
				Textures = {
					type = "group",
					order = 2,
					name = "Textures",
					guiInline = true,
					args = {
						normTex = {
							type = "select", dialogControl = 'LSM30_Statusbar',
							order = 1,
							name = "Default Texture",
							desc = "Texture that gets used on just about everything",
							values = AceGUIWidgetLSMlists.statusbar,								
						},
						glowTex = {
							type = "select", dialogControl = 'LSM30_Border',
							order = 2,
							name = "Glow Border",
							desc = "Shadow Effect",
							values = AceGUIWidgetLSMlists.border,								
						},
						blank = {
							type = "select", dialogControl = 'LSM30_Background',
							order = 3,
							name = "Backdrop Texture",
							desc = "Used on almost all frames",
							values = AceGUIWidgetLSMlists.background,							
						},
					},
				},
				Sounds = {
					type = "group",
					order = 3,
					name = "Sounds",
					guiInline = true,					
					args = {
						whisper = {
							type = "select", dialogControl = 'LSM30_Sound',
							order = 1,
							name = "Whisper Sound",
							desc = "Sound that is played when recieving a whisper",
							values = AceGUIWidgetLSMlists.sound,								
						},			
						warning = {
							type = "select", dialogControl = 'LSM30_Sound',
							order = 2,
							name = "Warning Sound",
							desc = "Sound that is played when you don't have a buff active",
							values = AceGUIWidgetLSMlists.sound,								
						},							
					},
				},
				GenColors = {
					type = "group",
					order = 4,
					name = "Colors",
					guiInline = true,
					args = {
						bordercolor = {
							type = "color",
							order = 1,
							name = "Border Color",
							desc = "Main Frame's Border Color",
							hasAlpha = false,
							get = function() return unpack(db.media.bordercolor) end,
							set = function(_,r,g,b,a)
								db.media.bordercolor = { r, g, b, a }
								StaticPopup_Show("RELOAD_UI")
							end,
						},
						backdropcolor = {
							type = "color",
							order = 2,
							name = "Backdrop Color",
							desc = "Main Frame's Backdrop Color",
							hasAlpha = false,
							get = function() return unpack(db.media.backdropcolor) end,
							set = function(_,r,g,b,a)
								db.media.backdropcolor = { r, g, b, a }
								StaticPopup_Show("RELOAD_UI")
							end,						
						},
						altbordercolor = {
							type = "color",
							order = 3,
							name = "Alt Border Color",
							desc = "Main Frame's Alternate Border Color",
							hasAlpha = false,
							get = function() return unpack(db.media.altbordercolor) end,
							set = function(_,r,g,b,a)
								db.media.altbordercolor = { r, g, b, a }
								StaticPopup_Show("RELOAD_UI")
							end,				
						},
					},
				},	
			},
		},
	},
}

function OUI:SetupOptions()
	self.optionsFrames = {}

	LibStub("AceConfig-3.0"):RegisterOptionsTable("OUI", ouioptions)
	ouioptions.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)

	
	AceConfigDialog:SetDefaultSize("OUI", 680, 525)
	self:RegisterChatCommand( "oui", "ChatCommand")
	self:RegisterChatCommand( "OUI", "ChatCommand")
	self:RegisterChatCommand( "odineui", "ChatCommand")
	self:RegisterChatCommand( "ODINEUI", "ChatCommand")
	
end