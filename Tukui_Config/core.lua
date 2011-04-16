local OUI = LibStub("AceAddon-3.0"):NewAddon("OUI", "AceConsole-3.0", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("OUI", false)
local LSM = LibStub("LibSharedMedia-3.0")
local db
local defaults

function OUI:LoadDefaults()
	local T, _, _, DB = unpack(Tukui)
	
	defaults = {
		profile = {
			general = DB["general"],
			media = DB["media"],
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
			classtimer = DB["classtimer"],
			error = DB["error"],
			spellfilter = {
				FilterPicker = "ErrorList",
				RaidDebuffs = T["RaidDebuffs"],
				DebuffBlacklist = T["DebuffBlacklist"],
				ErrorList = T["ErrorList"],
				DebuffWhiteList = T["DebuffWhiteList"],
				PlateBlacklist = T["PlateBlacklist"],
				TargetPVPOnly = T["TargetPVPOnly"],
				ArenaBuffWhiteList = T["ArenaBuffWhiteList"],
				HealerBuffIDs = T["HealerBuffIDs"],
				DPSBuffIDs = T["DPSBuffIDs"],
				PetBuffs = T["PetBuffs"],
				TRINKET_FILTER = TRINKET_FILTER,
				CLASS_FILTERS = CLASS_FILTERS
			},
		},
	}	
end

function OUI:Load()
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

function OUI:SetupOptions()
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("OUI", self.GenerateOptions)

	self.profileOptions = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db);
	LibStub("AceConfig-3.0"):RegisterOptionsTable("OUIProfiles", self.profileOptions)
	
	-- Add dual-spec support
	local LDS = LibStub("LibDualSpec-1.0")
	LDS:EnhanceDatabase(self.db, "OUI")
	LDS:EnhanceOptions(self.profileOptions, self.db)

	local ACD3 = LibStub("AceConfigDialog-3.0")
	self.optionsFrames = {}
	self.optionsFrames.OUI = ACD3:AddToBlizOptions("OUI", "OdineUI", nil, "general")
	self.optionsFrames.Actionbar = ACD3:AddToBlizOptions("OUI", L["Action Bars"], "OdineUI", "actionbar")
	self.optionsFrames.Nameplates = ACD3:AddToBlizOptions("OUI", L["Nameplates"], "OdineUI", "nameplate")
	self.optionsFrames.Unitframes = ACD3:AddToBlizOptions("OUI", L["Unit Frames"], "OdineUI", "unitframes")
	self.optionsFrames.Raidparty = ACD3:AddToBlizOptions("OUI", L["Raid/Party Settings"], "OdineUI", "raidparty")
	self.optionsFrames.Datatext = ACD3:AddToBlizOptions("OUI", L["Data Texts"], "OdineUI", "datatext")
	self.optionsFrames.Chat = ACD3:AddToBlizOptions("OUI", L["Chat"], "OdineUI", "chat")
	self.optionsFrames.Misc = ACD3:AddToBlizOptions("OUI", L["Misc"], "OdineUI", "misc")
	self.optionsFrames.Tooltip = ACD3:AddToBlizOptions("OUI", L["Tooltip"], "OdineUI", "tooltip")
	self.optionsFrames.Media = ACD3:AddToBlizOptions("OUI", L["Media"], "OdineUI", "media")
	self.optionsFrames.Classtimer = ACD3:AddToBlizOptions("OUI", L["Class Timers"], "OdineUI", "classtimer")
	self.optionsFrames.SpellFilter = ACD3:AddToBlizOptions("OUI", L["Filters"], "OdineUI", "spellfilter")
	self.optionsFrames.Profiles = ACD3:AddToBlizOptions("OUIProfiles", L["Profiles"], "OdineUI")
	
	self.SetupOptions = nil
end

function OUI:ShowConfig(arg)
	InterfaceOptionsFrame_OpenToCategory(self.optionsFrames.Profiles)
	InterfaceOptionsFrame_OpenToCategory(self.optionsFrames.OUI)
end

function OUI:OnInitialize()
	self:RegisterChatCommand("oui", "ShowConfig")
	self:RegisterChatCommand("odineui", "ShowConfig")
	
	self.OnInitialize = nil
end

function OUI.GenerateOptions()
	if OUI.noconfig then assert(false, OUI.noconfig) end
	if not OUI.Options then
		OUI.GenerateOptionsInternal()
		OUI.GenerateOptionsInternal = nil
	end
	return OUI.Options
end

function OUI.GenerateOptionsInternal()
	local T, C, _, DB = unpack(Tukui)
	
	StaticPopupDialogs["RELOAD_UI"] = {
		text = L["RELOAD_UI"],
		button1 = ACCEPT,
		button2 = CANCEL,
		OnAccept = function() ReloadUI() end,
		timeout = 0,
		whileDead = 1,
	}
	
	local RaidBuffs = {
		["HealerBuffIDs"] = true,
		["DPSBuffIDs"] = true,
		["PetBuffs"] = true
	}
	
	local ClassTimerShared = {
		["TRINKET_FILTER"] = true,
	}
	
	local ClassTimer = {
		["CLASS_FILTERS"] = true
	}
	
	-- Credit to Elv all filter related code by him.. simply mod to fit my edit!
	local function CreateFilterTable(tab)
		local spelltable = db.spellfilter[tab]
		if not spelltable then error("db.spellfilter could not find value 'tab'") return {} end
		local newtable = {}
		
		if ClassTimer[tab] then
			newtable["SelectSpellFilter"] = {
				name = L["Choose Filter"],
				desc = L["Choose the filter you want to modify."],
				type = "select",
				order = 1,
				values = {
					["target"] = TARGET,
					["player"] = PLAYER,
					["procs"] = L["Procs"],
				},
				set = function(info, value) 
					db.spellfilter[ info[#info] ] = value;
					local config = LibStub("AceConfigRegistry-3.0"):GetOptionsTable("OUI", "dialog", "MyLib-1.2")
					local curfilter = db.spellfilter.FilterPicker
		
					config.args.spellfilter.args.SpellListTable.args = CreateFilterTable(curfilter)
				end,
			}
			local curfilter = db.spellfilter["SelectSpellFilter"]
			if curfilter ~= nil then
				newtable["SelectSpell"] = {
					name = L["Select Spell"],
					type = "select",
					order = 2,
					values = {},
					set = function(info, value) 
						db.spellfilter[ info[#info] ] = value;
						local config = LibStub("AceConfigRegistry-3.0"):GetOptionsTable("OUI", "dialog", "MyLib-1.2")
						local curfilter = db.spellfilter.FilterPicker
			
						config.args.spellfilter.args.SpellListTable.args = CreateFilterTable(curfilter)
					end,
				}
				
				if not spelltable[T.myclass] then spelltable[T.myclass] = {} end
				
				for i, spell in pairs(spelltable[T.myclass][curfilter]) do
					local id = spell["id"]
					newtable["SelectSpell"]["values"][id] = GetSpellInfo(id)

					if id == db.spellfilter["SelectSpell"] then
						newtable["SpellGroup"] = {
							order = 3,
							type = "group",
							name = GetSpellInfo(id).." ("..id..")",
							guiInline = true,				
							args = {
								Enabled = {
									type = "toggle",
									order = 1,
									name = L["Enabled"],
									get = function(info) return db.spellfilter[tab][T.myclass][curfilter][i]["enabled"] end,
									set = function(info, value) db.spellfilter[tab][T.myclass][curfilter][i]["enabled"] = value; StaticPopup_Show("RELOAD_UI") end,										
								},
								CastByAnyone = {
									type = "toggle",
									order = 2,
									name = L["Any Unit"],
									desc = L["Display the buff if cast by anyone?"],
									get = function(info) return db.spellfilter[tab][T.myclass][curfilter][i]["castByAnyone"] end,
									set = function(info, value) db.spellfilter[tab][T.myclass][curfilter][i]["castByAnyone"] = value; StaticPopup_Show("RELOAD_UI") end,									
								},
								Color = {
									type = "color",
									order = 3,
									name = L["Color"],
									hasAlpha = false,
									get = function(info)
										local t = db.spellfilter[tab][T.myclass][curfilter][i]["color"]
										if not t then
											t = {}
											t.r = 0
											t.g = 0
											t.b = 0
										end
										
										return t.r, t.g, t.b
									end,
									set = function(info, r, g, b)
										db.spellfilter[tab][T.myclass][curfilter][i]["color"] = {}
										local t = db.spellfilter[tab][T.myclass][curfilter][i]["color"]
										t.r, t.g, t.b = r, g, b
										StaticPopup_Show("RELOAD_UI")
									end,							
								},
								UnitType = {
									type = "select",
									order = 4,
									name = L["Unit Type"],
									desc = L["Only display on this type of unit"],
									values = {
										[0] = L["All"],
										[1] = L["Friendly"],
										[2] = L["Enemy"],
									},
									get = function(info) if db.spellfilter[tab][T.myclass][curfilter][i]["unitType"] == nil then return 0 else return db.spellfilter[tab][T.myclass][curfilter][i]["unitType"] end end,
									set = function(info, value) db.spellfilter[tab][T.myclass][curfilter][i]["unitType"] = value; StaticPopup_Show("RELOAD_UI") end,									
								},
							},
						}					
					end
				end
			end
		elseif ClassTimerShared[tab] then
			newtable["SelectSpell"] = {
				name = L["Select Spell"],
				type = "select",
				order = 1,
				values = {},
				set = function(info, value) 
					db.spellfilter[ info[#info] ] = value;
					local config = LibStub("AceConfigRegistry-3.0"):GetOptionsTable("OUI", "dialog", "MyLib-1.2")
					local curfilter = db.spellfilter.FilterPicker
		
					config.args.spellfilter.args.SpellListTable.args = CreateFilterTable(curfilter)
				end,
			}
			
			for i, spell in pairs(spelltable) do
				local id = spell["id"]

				newtable["SelectSpell"]["values"][id] = GetSpellInfo(id)
				
				if id == db.spellfilter["SelectSpell"] then
					newtable["SpellGroup"] = {
						order = 2,
						type = "group",
						name = GetSpellInfo(id).." ("..id..")",
						guiInline = true,				
						args = {
							Enabled = {
								type = "toggle",
								order = 1,
								name = L["Enabled"],
								get = function(info) return db.spellfilter[tab][i]["enabled"] end,
								set = function(info, value) db.spellfilter[tab][i]["enabled"] = value; StaticPopup_Show("RELOAD_UI") end,										
							},
							CastByAnyone = {
								type = "toggle",
								order = 2,
								name = L["Any Unit"],
								desc = L["Display the buff if cast by anyone?"],
								get = function(info) return db.spellfilter[tab][i]["castByAnyone"] end,
								set = function(info, value) db.spellfilter[tab][i]["castByAnyone"] = value; StaticPopup_Show("RELOAD_UI") end,									
							},
							Color = {
								type = "color",
								order = 3,
								name = L["Color"],
								hasAlpha = false,
								get = function(info)
									local t = db.spellfilter[tab][i]["color"]
									if not t then
										t = {}
										t.r = 0
										t.g = 0
										t.b = 0
									end
									
									return t.r, t.g, t.b
								end,
								set = function(info, r, g, b)
									db.spellfilter[tab][i]["color"] = {}
									local t = db.spellfilter[tab][i]["color"]
									t.r, t.g, t.b = r, g, b
									StaticPopup_Show("RELOAD_UI")
								end,							
							},
							UnitType = {
								type = "select",
								order = 4,
								name = L["Unit Type"],
								desc = L["Only display on this type of unit"],
								values = {
									[0] = L["All"],
									[1] = L["Friendly"],
									[2] = L["Enemy"],
								},
								get = function(info) if db.spellfilter[tab][i]["unitType"] == nil then return 0 else return db.spellfilter[tab][i]["unitType"] end end,
								set = function(info, value) db.spellfilter[tab][i]["unitType"] = value; StaticPopup_Show("RELOAD_UI") end,									
							},
						},
					}
				end
			end
		elseif RaidBuffs[tab] then
			if not spelltable[T.myclass] then spelltable[T.myclass] = {} end
			newtable["SelectSpell"] = {
				name = L["Select Spell"],
				type = "select",
				order = 1,
				values = {},
				set = function(info, value) 
					db.spellfilter[ info[#info] ] = value;
					local config = LibStub("AceConfigRegistry-3.0"):GetOptionsTable("OUI", "dialog", "MyLib-1.2")
					local curfilter = db.spellfilter.FilterPicker
		
					config.args.spellfilter.args.SpellListTable.args = CreateFilterTable(curfilter)
				end,
			}
			
			for i, spell in pairs(spelltable[T.myclass]) do
				local id = spell["id"]
				
				newtable["SelectSpell"]["values"][id] = GetSpellInfo(id)
				
				if id == db.spellfilter["SelectSpell"] then
					newtable["SpellGroup"] = {
						order = 2,
						type = "group",
						name = GetSpellInfo(id).." ("..id..")",
						guiInline = true,				
						args = {
							Enabled = {
								type = "toggle",
								order = 1,
								name = L["Enabled"],
								get = function(info) return db.spellfilter[tab][T.myclass][i]["enabled"] end,
								set = function(info, value) db.spellfilter[tab][T.myclass][i]["enabled"] = value; StaticPopup_Show("RELOAD_UI") end,										
							},
							Position = {
								type = "select",
								order = 2,
								name = L["Position"],
								desc = L["POS_DESC"],
								get = function(info) return db.spellfilter[tab][T.myclass][i]["point"] end,
								set = function(info, value) db.spellfilter[tab][T.myclass][i]["point"] = value; StaticPopup_Show("RELOAD_UI") end,		
								values = {
									["TOPLEFT"] = "TOPLEFT",
									["TOP"] = "TOP",
									["TOPRIGHT"] = "TOPRIGHT",
									["LEFT"] = "LEFT",
									["RIGHT"] = "RIGHT",
									["BOTTOMLEFT"] = "BOTTOMLEFT",
									["BOTTOM"] = "BOTTOM",
									["BOTTOMRIGHT"] = "BOTTOMRIGHT",
								},
							},
							anyUnit = {
								type = "toggle",
								order = 3,
								name = L["Any Unit"],
								desc = L["ANYUNIT_DESC"],
								get = function(info) return db.spellfilter[tab][T.myclass][i]["anyUnit"] end,
								set = function(info, value) db.spellfilter[tab][T.myclass][i]["anyUnit"] = value; StaticPopup_Show("RELOAD_UI") end,									
							},
							Color = {
								type = "color",
								order = 4,
								name = L["Color"],
								hasAlpha = false,
								get = function(info)
									local t = db.spellfilter[tab][T.myclass][i]["color"]
									return t.r, t.g, t.b, t.a
								end,
								set = function(info, r, g, b)
									db.spellfilter[tab][T.myclass][i]["color"] = {}
									local t = db.spellfilter[tab][T.myclass][i]["color"]
									t.r, t.g, t.b = r, g, b
									StaticPopup_Show("RELOAD_UI")
								end,																	
							},					
						},
					}
				end
			end
		else
			for spell, value in pairs(spelltable) do
				if db.spellfilter[tab][spell] ~= nil then
					newtable[spell] = {
						name = spell,
						type = "toggle",
						get = function(info) if db.spellfilter[tab][spell] then return true else return false end end,
						set = function(info, value) db.spellfilter[tab][spell] = value; T[tab] = db.spellfilter[tab]; StaticPopup_Show("RELOAD_UI") end,
					}
				end
			end
		end
		
		return newtable
	end
				
	local function GetFilterDesc()
		if db.spellfilter.FilterPicker == "PlateBlacklist" then
			return "Filter whether or not a nameplate is shown by the name of the nameplate"
		elseif db.spellfilter.FilterPicker == "ErrorList" then
			return "Allows you to customize which error messages will be hidden."
		elseif db.spellfilter.FilterPicker == "RaidDebuffs" then
			return "These debuffs will be displayed on your raid frames in addition to any debuff that is dispellable."
		elseif db.spellfilter.FilterPicker == "TargetPVPOnly" then
			return "These debuffs only get displayed on the target unit when the unit happens to be an enemy player."
		elseif db.spellfilter.FilterPicker == "DebuffWhiteList" then
			return "These debuffs will always get displayed on the Target Frame, Arena Frames, and Nameplates."
		elseif db.spellfilter.FilterPicker == "ArenaBuffWhiteList" then
			return "Filter the buffs that get displayed on arena units."
		elseif db.spellfilter.FilterPicker == "DebuffBlacklist" then
			return "Set buffs that will never get displayed."
		elseif db.spellfilter.FilterPicker == "HealerBuffIDs" then
			return "These buffs are displayed on the healer raid and party layouts"
		elseif db.spellfilter.FilterPicker == "DPSBuffIDs" then
			return "These buffs are displayed on the DPS raid and party layouts"
		elseif db.spellfilter.FilterPicker == "PetBuffs" then
			return "These buffs are displayed on the pet frame"
		elseif db.spellfilter.FilterPicker == "TRINKET_FILTER" then
			return "These buffs are displayed no matter your class you must have a layout enabled that uses trinkets however for them to show"
		elseif db.spellfilter.FilterPicker == "CLASS_FILTERS" then
			return "These buffs/debuffs are displayed as a classtimer, where they get positioned is based on your layout option choice"
		else
			return ""
		end
	end
	
	local function GetFilterName()
		if db.spellfilter.FilterPicker == "PlateBlacklist" then
			return "Nameplate Names"
		elseif db.spellfilter.FilterPicker == "ErrorList" then
			return "Error Filters"
		else
			return "Auras"
		end	
	end
	
	local function UpdateSpellFilter()
		local config = LibStub("AceConfigRegistry-3.0"):GetOptionsTable("OUI", "dialog", "MyLib-1.2")
		local curfilter = db.spellfilter.FilterPicker
		
		config.args.spellfilter.args.SpellListTable.args = CreateFilterTable(curfilter)
		config.args.spellfilter.args.FilterDesc.name = GetFilterDesc()
		config.args.spellfilter.args.SpellListTable.name = GetFilterName()
		
		collectgarbage("collect")
	end

	OUI.Options = {
		type = "group",
		name = "OdineUI",
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
						order = 3,
						name = L["Auto Scale"],
						desc = L["GEN_ASCALE"],
						type = "toggle",
					},					
					uiscale = {
						order = 4,
						name = L["Scale"],
						desc = L["GEN_SCALE"],
						disabled = function(info) return db.general.autoscale end,
						type = "range",
						min = 0.64, max = 1, step = 0.01,
						isPercent = true,
					},
					multisampleprotect = {
						order = 5,
						name = L["Multisample Protection"],
						desc = L["GEN_SAMPLE"],
						type = "toggle",
					},
					overridelowtohigh = {
						order = 6,
						name = L["Override LOW -> HIGH"],
						desc = L["OVERRIDE_DESC"],
						type = "toggle",
					},
					empty5 = {
						name = "   ",
						width = "full",
						type = "description",
						order = 7,
					},
					Colors = {
						type = "group",
						order = 8,
						name = L["Color Options"],
						guiInline = true,
						disabled = function() return not db.unitframes.enable end,
						args = {
							unicolor = {
								type = "toggle",
								order = 1,
								name = L["Unicolor Theme"],
								desc = L["UNICOLOR_DESC"],
								get = function() return db.unitframes.unicolor end,
								set = function(info, value) db.unitframes.unicolor = value; StaticPopup_Show("RELOAD_UI") end,
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
								name = L["Healthbar Color"],
								desc = L["HBAR_DESC"],
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
								name = L["Healthbar BG Color"],
								desc = L["HBARBG_DESC"],
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
				},
			},
			unitframes = {
				order = 2,
				type = "group",
				name = L["Unit Frames"],
				desc = L["Configure Settings for Unit Frames"],
				get = function(info) return db.unitframes[ info[#info] ] end,
				set = function(info, value) db.unitframes[ info[#info] ] = value; StaticPopup_Show("RELOAD_UI") end,
				args = {
					enable = {
						order = 2,
						name = "Enable",
						desc = L["Enable or Disable Unit Frames"],
						type = "toggle",
					},
					enablearena = {
						order = 2.5,
						name = L["Arena Frames"],
						desc = "Toggle whether you want to use arena frames.",
						type = "toggle",
						get = function(info) return db.arena.unitframes end,
						set = function(info, value) db.arena.unitframes = value; StaticPopup_show("RELOAD_UI") end,
						disabled = function() return not db.unitframes.enable end,
					},
					UFOptions = {
						order = 3,
						type = "group",
						name = L["General Options"],
						guiInline = true,
						disabled = function() return not db.unitframes.enable end,
						args = {
							enemyhcolor = {
								type = "toggle",
								order = 1,
								name = L["Show Hostility Color"],
								desc = L["Enemy target (players) color by hostility, very useful for healer."],
							},
							charportrait = {
								type = "toggle",
								order = 2,
								name = L["Portraits"],
								desc = L["Enable displaying character portraits on select frames"],
							},
							showtotalhpmp = {
								type = "toggle",
								order = 3,
								name = L["Total HP/MP"],
								desc = L["Changes the display of info text on player and target frame with XXXX/Total if enabled."],
							},
							targetpowerpvponly = {
								type = "toggle",
								order = 4,
								name = L["Show PVP Target Mana"],
								desc = L["When enabled will show pvp targets amount of mana."],
							},
							showsmooth = {
								type = "toggle",
								order = 5,
								name = L["Smooth Bars"],
								desc = L["Enables bars having a smooth look n feel."],
							},
							combatfeedback = {
								type = "toggle",
								order = 6,
								name = L["Combat Feedback"],
								desc = L["Enable combat text on player and target"],
							},
							playeraggro = {
								type = "toggle",
								order = 7,
								name = L["Player Aggro"],
								desc = L["Enable coloring border red when player has aggro"],
							},
							percentage = {
								type = "toggle",
								order = 8,
								name = L["Show Percentages"],
								desc = L["Enable showing percentages for health/mana outside of unitframes."],
							},
							vengeance = {
								type = "toggle",
								order = 9,
								name = L["Vengeance Bar"],
								desc = L["Enable displaying a vengeance bar over bottom middle datatext panel."],
							},
							swingbar = {
								type = "toggle",
								order = 10,
								name = L["Swing bar"],
								desc = L["Enable showing your swingbar."],
							},
							lowThreshold = {
								type = "range",
								order = 11,
								name = L["Low Mana Threshold"],
								desc = L["When to be warned about low mana"],
								type = "range",
								min = 1, max = 99, step = 1,							
							},
						},
					},
					Castbar = {
						order = 5,
						type = "group",
						name = L["Castbar Settings"],
						guiInline = true,
						disabled = function() return not db.unitframes.enable end,
						get = function(info) return db.unitframes[ info[#info] ] end,
						set = function(info, value) db.unitframes[ info[#info] ] = value; StaticPopup_Show("RELOAD_UI") end,
						args = {
							unitcastbar = {
								type = "toggle",
								order = 1,
								name = L["Enable Cast Bars"],
								desc = L["Customize settings of your cast bars"],
							},
							cblatency = {
								type = "toggle",
								order = 2,
								name = L["Show latency"],
								desc = L["Show your latency in castbar"],
								disabled = function() return not db.unitframes.unitcastbar end,
							},
							cbicons = {
								type = "toggle",
								order = 3,
								name = L["Show icons"],
								desc = L["Show icons with castbar"],
								disabled = function() return not db.unitframes.unitcastbar end,
							},
							cbinside = {
								type = "toggle",
								order = 3.5,
								name = L["Inside UF"],
								desc = L["When enabled castbars are inside of your player/target frame. (ONLY WORKS IF LARGE PLAYER CASTBAR IS DISABLED)"],
								disabled = function() return (not db.unitframes.unitcastbar or db.unitframes.large_player) end,
							},
							large_player = {
								type = "toggle",
								order = 4,
								name = L["Large Player castbar"],
								desc = L["Allows you to use a bigger castbar for your casts"],										
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
								name = L["Class colors"],
								desc = L["Allows you to use class colors for castbars"],										
							},
							cbcustomcolor = {
								type = "color",
								order = 6,
								name = L["Castbar Color"],
								desc = L["Allows you to select a custom color for castbars"],
								disabled = function() return (db.unitframes.cbclasscolor or not db.unitframes.unitcastbar) end,
								hasAlpha = false,
								get = function() return unpack(db.unitframes.cbcustomcolor) end,
								set = function(_,r,g,b)
									db.unitframes.cbcustomcolor = { r, g, b }
									StaticPopup_Show("RELOAD_UI")
								end,
							},
						},
					},
					Auras = {
						order = 6,
						type = "group",
						name = L["Auras"],
						guiInline = true,
						disabled = function() return not db.unitframes.enable end,
						get = function(info) return db.unitframes[ info[#info] ] end,
						set = function(info, value) db.unitframes[ info[#info] ] = value; StaticPopup_Show("RELOAD_UI") end,
						args = {
							auratimer = {
								type = "toggle",
								order = 1,
								name = L["Aura Timers"],
								desc = L["Enables timers on buffs and debuffs"],
							},
							auratextscale = {
								type = "range",
								order = 2,
								name = L["Aura Text Scale"],
								desc = L["Controls the size of the aura font"],
								type = "range",
								min = 8, max = 16, step = 1,									
							},
							emptyuf41 = {
								name = "   ",
								width = "full",
								type = "description",
								order = 2.5,
							},
							playerauras = {
								type = "toggle",
								order = 3,
								name = L["Player Auras"],
								desc = L["Display auras on player frame"],				
							},
							playershowonlydebuffs = {
								type = "toggle",
								order = 4,
								name = L["Player Only My Debuffs"],
								desc = L["Display only debuffs on your player frame (must have playerauras enabled)"],
								disabled = function() return not db.unitframes.playerauras end,
							},
							targetauras = {
								type = "toggle",
								order = 5,
								name = L["Target Auras"],
								desc = L["Display auras on target frame"],								
							},
							playerdebuffsonly = {
								type = "toggle",
								order = 6,
								name = L["Target Only My Debuffs"],
								desc = L["Display only your debuffs on the target frame. (and anything displayed in the debuff whitelist)"],								
							},
							emptyuf16 = {
								name = "   ",
								width = "full",
								type = "description",
								order = 6.5,
							},
							totdebuffs = {
								type = "toggle",
								order = 7,
								name = L["ToT Debuffs"],
								desc = L["Display debuffs on target of target frame"],									
							},
							focusdebuffs = {
								type = "toggle",
								order = 8,
								name = L["Focus Debuffs"],
								desc = L["Display only your debuffs on the targets frame."],									
							},
							bossbuffs = {
								type = "toggle",
								order = 9,
								name = L["Boss Buffs"],
								desc = L["Display buffs on boss frames"],									
							},
							bossdebuffs = {
								type = "toggle",
								order = 10,
								name = L["Boss Debuffs"],
								desc = L["Display debuffs on boss frames."],									
							},
							arenabuffs = {
								type = "toggle",
								order = 11,
								name = L["Arena Buffs"],
								desc = L["Display buffs on arena frames."],									
							},
							arenadebuffs = {
								type = "toggle",
								order = 12,
								name = L["Arena Debuffs"],
								desc = L["Display debuffs on arena frames."],									
							},
							emptyuf122 = {
								name = "   ",
								width = "full",
								type = "description",
								order = 12.5,
							},
							debuffHighlightFilter = { 
								type = "toggle",
								order = 13,
								name = L["Filter Debuff Borders"],
								desc = L["Toggles whether you want border of debuffs filtered."],
							},
							emptyuf1 = {
								name = "   ",
								width = "full",
								type = "description",
								order = 14,
							},
							buffsperrow = {
								type = "range",
								order = 15,
								name = L["Buff Rows"],
								desc = L["Controls how many buffs are displayed.(player/target frames only)"],
								type = "range",
								min = 5, max = 9, step = 1,									
							},
							debuffsperrow = {
								type = "range",
								order = 16,
								name = L["Debuff Rows"],
								desc = L["Controls how many debuffs are displayed.(player/target frames only)"],
								type = "range",
								min = 5, max = 9, step = 1,									
							},
						},
					},
					ClassOpts = {
						order = 8,
						type = "group",
						name = L["Other Stuff"],
						guiInline = true,
						disabled = function() return not db.unitframes.enable end,
						get = function(info) return db.unitframes[ info[#info] ] end,
						set = function(info, value) db.unitframes[ info[#info] ] = value; StaticPopup_Show("RELOAD_UI") end,
						args = {
							classbar = {
								type = "toggle",
								order = 1,
								name = L["Class Bars"],
								desc = L["Toggles whether you want to use class related bars.(ie: totem bar, rune bar, eclipse bar)"],
							},
							weakenedsoulbar = {
								type = "toggle",
								order = 2,
								name = L["Weakened Soul Bar"],
								desc = L["Toggles whether you want to display a weakened soul bar"],
							},
						},
					},
				},
			},
			raidparty = {
				order = 3,
				type = "group",
				name = L["Raid/Party Settings"],
				desc = L["Configure Settings for Raid and Parties."],
				get = function(info) return db.unitframes[ info[#info] ] end,
				set = function(info, value) db.unitframes[ info[#info] ] = value; StaticPopup_Show("RELOAD_UI") end,
				args = {
					showrange = {
						type = "toggle",
						order = 1,
						name = L["Range Opacity"],
						desc = L["Toggles whether you want to use alpha opacity for units out of range"],									
					},
					raidalphaoor = {
						type = "range",
						order = 2,
						name = L["Alpha Amount"],
						desc = L["Controls how much alpha is used when unit is out of range"],
						type = "range",
						disabled = function() return (not db.unitframes.enable or not db.unitframes.showrange) end,
						min = 0.1, max = 1, step = 0.1,									
					},
					emptyrp1 = {
						name = "   ",
						width = "full",
						type = "description",
						order = 2.5,
					},
					showplayerinparty = {
						type = "toggle",
						order = 3,
						name = L["Show Self"],
						desc = L["Toggles whether you want to be displayed in party frames"],									
					},
					showsymbols = {
						type = "toggle",
						order = 4,
						name = L["Show Symbols"],
						desc = L["Toggles whether you want to show raid symbols in frames"],									
					},
					aggro = {
						type = "toggle",
						order = 5,
						name = L["Show Aggro"],
						desc = L["Toggles whether you want to show aggro on all raid frames"],									
					},
					raidunitdebuffwatch = {
						type = "toggle",
						order = 6,
						name = L["Show Debuffs"],
						desc = L["Toggles whether you want to show aggro on all raid frames"],									
					},
					healcomm = {
						type = "toggle",
						order = 8,
						name = L["Healcomm"],
						desc = L["Toggles whether you want to display incoming heals"],						
					},
					healthvertical = { -- healer layout only
						type = "toggle",
						order = 9,
						name = L["Display HP Vertically"],
						desc = L["Toggles whether you want to display health vertically instead.(HEAL LAYOUT ONLY)"],
					},
					healthdeficit = { -- healer layout only
						type = "toggle",
						order = 10,
						name = L["Display HP Deficit"],
						desc = L["Toggles whether you want to display HP deficits instead.(HEAL LAYOUT ONLY)"],
					},
					hidepower = { -- dps layout only
						type = "toggle",
						order = 11,
						name = L["Hide Power"],
						desc = L["Toggles whether you want to hide Power from being displayed on raid/party frames.(DPS LAYOUT ONLY)"],
					},
					emptyrp2 = {
						name = "   ",
						width = "full",
						type = "description",
						order = 12,
					},
					maintank = { 
						type = "toggle",
						order = 13,
						name = L["Show Main Tank"],
						desc = L["Toggles Main Tank display."],
					},
					mainassist = { 
						type = "toggle",
						order = 14,
						name = L["Show Main Assist"],
						desc = L["Toggles Main Assist display."],
					},
					showboss = {
						type = "toggle",
						order = 15,
						name = L["Show Boss Frames"],
						desc = L["Toggles whether you want to display frames for bosses."],
					},
					emptyrp8 = {
						name = "   ",
						width = "full",
						type = "description",
						order = 16,
					},
					buffindicatorsize = {
						type = "range",
						order = 17,
						name = L["Raid Buff Display Size"],
						desc = L["Size of the buff icon on raidframes"],
						disabled = function() return not db.unitframes.enable end,
						type = "range",
						min = 3, max = 9, step = 1,									
					},
				},
			},
			nameplate = {
				order = 5,
				type = "group",
				name = L["Nameplates"],
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
							empty733 = {
								name = "   ",
								width = "full",
								type = "description",
								order = 3.5,
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
						disabled = function() return not db.actionbar.enable end,
					},
					hideshapeshift = {
						type = "toggle",
						order = 3,
						name = "Hide Shapeshift",
						desc = "Toggle whether you want to show your shapeshift/totems.",
						disabled = function() return not db.actionbar.enable end,
					},
					shapeshiftmouseover = {
						type = "toggle",
						order = 4,
						name = "Mouseover Shapeshift",
						desc = "Toggle whether you want to show the shapeshift bar only when moused over.",
						disabled = function() return (not db.actionbar.enable or db.actionbar.hideshapeshift) end,
					},
					showgrid = {
						type = "toggle",
						order = 5,
						name = "Show Grid",
						desc = "Toggle whether you want to show a grid on empty buttons.",
						disabled = function() return not db.actionbar.enable end,
					},
					vertical_rightbars = {
						type = "toggle",
						order = 6,
						name = "Vertical rightbars",
						desc = "Toggle whether you want to have your rightbars vertical instead of horizontal.",
						disabled = function() return not db.actionbar.enable end,
					},
					empty7 = {
						name = "   ",
						width = "full",
						type = "description",
						order = 7,
					},
					buttonsize = {
						type = "range",
						order = 8,
						name = "Button Size",
						desc = "Controls the size of actionbar buttons.",
						type = "range",
						min = 22, max = 32, step = 1,
						disabled = function() return not db.actionbar.enable end,
					},
					petbuttonsize = {
						type = "range",
						order = 9,
						name = "Pet Button Size",
						desc = "Controls the size of your pets actionbar buttons.",
						type = "range",
						min = 22, max = 32, step = 1,
						disabled = function() return not db.actionbar.enable end,
					},
					buttonspacing = {
						type = "range",
						order = 10,
						name = "Button Spacing",
						desc = "Controls the spacing between buttons.",
						type = "range",
						min = 1, max = 7, step = 1,
						disabled = function() return not db.actionbar.enable end,
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
						--guiInline = true,
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
						--guiInline = true,
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
						--guiInline = true,
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
						--guiInline = true,
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
						--guiInline = true,
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
						--guiInline = true,
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
						--guiInline = true,
						get = function(info) return db.misc[ info[#info] ] end,
							set = function(info, value) db.misc[ info[#info] ] = value; StaticPopup_Show("RELOAD_UI") end,
						args = {
							announceint = {
								type = "toggle",
								order = 1,
								name = "Announce interrupts",
								desc = "Toggles whether you want to announce your interrupts to chat.",
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
						},
					},
					Errors = {
						order = 8,
						type = "group",
						name = "Errors",
						--guiInline = true,
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
						--guiInline = true,
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
						--guiInline = true,
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
					empty6t = {
						name = "   ",
						width = "full",
						type = "description",
						order = 6,
					},
					whotarget = {
						type = "toggle",
						order = 5,
						name = "Who Target",
						desc = "When enabled allows you to see who is targetting you while in a raid or party.",
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
					statblock = {
						type = "toggle",
						order = 2,
						name = "Statblock",
						desc = "Toggles a datatext panel for fps/mb/time at top left screen.",
					},
					location = {
						type = "toggle",
						order = 3,
						name = "Location",
						desc = "Toggles a datatext panel for location and coords.",
					},
					empty5dt = {
						name = "   ",
						width = "full",
						type = "description",
						order = 4,
					},
					time24 = {
						type = "toggle",
						order = 5,
						name = "24H Format",
						desc = "Sets time to 24 hour format.",
					},
					localtime = {
						type = "toggle",
						order = 6,
						name = "Local Time",
						desc = "Set time to use local time instead of server time.",
					},
					classcolor = {
						type = "toggle",
						order = 7,
						name = "Classcolor Text",
						desc = "Sets text color from datatext to your class color.",
					},
					color = {
						type = "color",
						order = 8,
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
					empty8dtt = {
						name = "   ",
						width = "full",
						type = "description",
						order = 9,
					},
					bars = {
						type = "toggle",
						order = 10,
						name = "Show Rep/Exp Bar",
						desc = "Enables showing reputation/experience bars under your minimap.",
					},
					bar_text = {
						type = "toggle",
						order = 11,
						name = "Show Bar Text",
						desc = "Enables showing text inside your reputation/experience bar (bar must be enabled).",
						disabled = function() return not db.datatext.bars end,
					},
					DataConfig = {
						order = 12,
						type = "group",
						name = "Text Positions",
						guiInline = true,
						args = {
							armor = {
								order = 1,
								type = "range",
								name = "Armor",
								desc = "Display amount of armor"..L["DT_POS"],
								min = 0, max = 11, step = 1,
							},
							avd = {
								order = 2,
								type = "range",
								name = "Avoidance",
								desc = "Display avoidance you currently have"..L["DT_POS"],
								min = 0, max = 11, step = 1,
							},
							bags = {
								order = 3,
								type = "range",
								name = "Bags",
								desc = "Display ammount of bag space"..L["DT_POS"],
								min = 0, max = 11, step = 1,								
							},
							crit = {
								order = 4,
								type = "range",
								name = "Crit",
								desc = "Display ammount of crit rating"..L["DT_POS"],
								min = 0, max = 11, step = 1,								
							},
							currency = {
								order = 5,
								type = "range",
								name = "Currency",
								desc = "Display currency you are tracking"..L["DT_POS"],
								min = 0, max = 11, step = 1,								
							},
							dps_text = {
								order = 6,
								type = "range",
								name = "DPS Text",
								desc = "Display ammount of DPS"..L["DT_POS"],
								min = 0, max = 11, step = 1,								
							},
							dur = {
								order = 7,
								type = "range",
								name = "Durability",
								desc = "Display your current durability"..L["DT_POS"],
								min = 0, max = 11, step = 1,								
							},
							friends = {
								order = 8,
								type = "range",
								name = "Friends",
								desc = "Display ammount of friends online"..L["DT_POS"],
								min = 0, max = 11, step = 1,								
							},
							gold = {
								order = 9,
								type = "range",
								name = "Gold",
								desc = "Display gold you have across all toons",
								min = 0, max = 11, step = 1,								
							},
							guild = {
								order = 10,
								type = "range",
								name = "Guild",
								desc = "Display guilld members online"..L["DT_POS"],
								min = 0, max = 11, step = 1,								
							},
							haste = {
								order = 11,
								type = "range",
								name = "Haste",
								desc = "Display ammount of haste"..L["DT_POS"],
								min = 0, max = 11, step = 1,								
							},
							hit = {
								order = 12,
								type = "range",
								name = "Hit",
								desc = "Display ammount of hit rating"..L["DT_POS"],
								min = 0, max = 11, step = 1,								
							},
							hps_text = {
								order = 13,
								type = "range",
								name = "HPS Text",
								desc = "Display your hps in combat"..L["DT_POS"],
								min = 0, max = 11, step = 1,								
							},
							mastery = {
								order = 14,
								type = "range",
								name = "Mastery",
								desc = "Display ammount of mastery rating"..L["DT_POS"],
								min = 0, max = 11, step = 1,								
							},
							spec = {
								order = 15,
								type = "range",
								name = "Spec",
								desc = "Display current spec, and can be clicked to change to other spec"..L["DT_POS"],
								min = 0, max = 11, step = 1,								
							},
							regen = {
								order = 16,
								type = "range",
								name = "Mana Regen",
								desc = "Display ammount of mana regen you have (base/combat)"..L["DT_POS"],
								min = 0, max = 11, step = 1,								
							},
							power = {
								order = 17,
								type = "range",
								name = "Power",
								desc = "Display ammount of power you have (STR, AGI, INT)"..L["DT_POS"],
								min = 0, max = 11, step = 1,								
							},
						},
					},
				},
			},
			media = {
				order = 11,
				type = "group",
				name = L["Media"],
				desc = L["MEDIA_DESC"],
				get = function(info) return db.media[ info[#info] ] end,
				set = function(info, value) db.media[ info[#info] ] = value; StaticPopup_Show("RELOAD_UI") end,
				args = {
					Fonts = {
						type = "group",
						order = 1,
						name = L["Fonts"],
						guiInline = true,
						args = {
							font = {
								type = "select",
								dialogControl = 'LSM30_Font',
								order = 1,
								name = L["General Font"],
								desc = L["GFONT_DESC"],
								values = AceGUIWidgetLSMlists.font,	
							},
							uffont = {
								type = "select",
								dialogControl = 'LSM30_Font',
								order = 2,
								name = L["UnitFrame Font"],
								desc = L["UFFONT_DESC"],
								values = AceGUIWidgetLSMlists.font,	
							},
							dmgfont = {
								type = "select",
								dialogControl = 'LSM30_Font',
								order = 3,
								name = L["Combat Font"],
								desc = L["COMFONT_DESC"],
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
								name = L["Chat Font"],
								desc = L["CHTFONT_DESC"],
								values = AceGUIWidgetLSMlists.font,
							},
							ct_fsize = {
								order = 5,
								type = "range",
								name = L["Chat Font Size"],
								desc = L["CHTSIZE_DESC"],
								min = 1, max = 20, step = 1,
								get = function() return db.chat.fsize end,
								set = function(info, value) db.chat.fsize = value; StaticPopup_Show("RELOAD_UI") end,
							},
							dfont = {
								type = "select",
								dialogControl = 'LSM30_Font',
								order = 6,
								name = L["Datatext Font"],
								desc = L["DTFONT_DESC"],
								values = AceGUIWidgetLSMlists.font,						
							},
							dt_fsize = {
								order = 7,
								type = "range",
								name = L["Datatext Font Size"],
								desc = L["DTSIZE_DESC"],
								min = 1, max = 20, step = 1,
								get = function() return db.datatext.fsize end,
								set = function(info, value) db.datatext.fsize = value; StaticPopup_Show("RELOAD_UI") end,
							},
						},
					},
					Textures = {
						type = "group",
						order = 2,
						name = L["Textures"],
						guiInline = true,
						args = {
							normTex = {
								type = "select", dialogControl = 'LSM30_Statusbar',
								order = 1,
								name = L["Default Texture"],
								desc = L["DTEX_DESC"],
								values = AceGUIWidgetLSMlists.statusbar,								
							},
							glowTex = {
								type = "select", dialogControl = 'LSM30_Border',
								order = 2,
								name = L["Glow Border"],
								desc = L["GTEX_DESC"],
								values = AceGUIWidgetLSMlists.border,								
							},
							blank = {
								type = "select", dialogControl = 'LSM30_Background',
								order = 3,
								name = L["Backdrop Texture"],
								desc = L["BTEX_DESC"],
								values = AceGUIWidgetLSMlists.background,							
							},
						},
					},
					Sounds = {
						type = "group",
						order = 3,
						name = L["Sounds"],
						guiInline = true,					
						args = {
							whisper = {
								type = "select", dialogControl = 'LSM30_Sound',
								order = 1,
								name = L["Whisper Sound"],
								desc = L["WHISOUND_DESC"],
								values = AceGUIWidgetLSMlists.sound,								
							},			
							warning = {
								type = "select", dialogControl = 'LSM30_Sound',
								order = 2,
								name = L["Warning Sound"],
								desc = L["WARSOUND_DESC"],
								values = AceGUIWidgetLSMlists.sound,								
							},							
						},
					},
					GenColors = {
						type = "group",
						order = 4,
						name = L["Colors"],
						guiInline = true,
						args = {
							bordercolor = {
								type = "color",
								order = 1,
								name = L["Border Color"],
								desc = L["BCOLOR_DESC"],
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
								name = L["Backdrop Color"],
								desc = L["BDROP_DESC"],
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
								name = L["Alt Border Color"],
								desc = L["ABDROP_DESC"],
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
			classtimer = {
				order = 12,
				type = "group",
				name = L["Class Timers"],
				desc = L["CLASSTIMER_DESC"],
				get = function(info) return db.classtimer[ info[#info] ] end,
				set = function(info, value) db.classtimer[ info[#info] ] = value; StaticPopup_Show("RELOAD_UI") end,
				args = {
					intro = {
						order = 1,
						type = "description",
						name = L["CLASSTIMER_DESC"],
					},
					enable = {
						order = 2,
						type = "toggle",
						name = ENABLE,
						desc = L["Enable Class Timers"],
					},
					CTGroup = {
						order = 3,
						type = "group",
						name = L["General Settings"],
						guiInline = true,
						disabled = function() return not db.classtimer.enable or (not TukuiPlayer and not TukuiTarget) or not db.unitframes.enable end,	
						args = {
							bar_height = {
								type = "range",
								order = 1,
								name = L["Bar Height"],
								desc = L["Controls the height of the bar"],
								type = "range",
								min = 9, max = 25, step = 1,								
							},
							bar_spacing = {
								type = "range",
								order = 2,
								name = L["Bar Spacing"],
								desc = L["Controls the spacing in between bars"],
								type = "range",
								min = 5, max = 10, step = 1,								
							},
							icon_position = {
								type = "range",
								order = 3,
								name = L["Icon Position"],
								desc = L["0 = Left\n1 = Right\n2 = Outside Left\n3 = Outside Right"],
								type = "range",
								min = 0, max = 3, step = 1,								
							},
							layout = {
								type = "range",
								order = 4,
								name = L["Layout"],
								desc = L["LAYOUT_DESC"],
								type = "range",
								min = 1, max = 5, step = 1,								
							},
							showspark = {
								type = "toggle",
								order = 5,
								name = L["Spark"],
								desc = L["Display spark"],
							},
							cast_suparator = {
								type = "toggle",
								order = 6,
								name = L["Cast Seperator"],							
							},
							emptyct5 = {
								name = "   ",
								width = "full",
								type = "description",
								order = 6.5,
							},
							gen_font = {
								type = "select",
								dialogControl = 'LSM30_Font',
								order = 7,
								name = "General Font",
								desc = "Font used as text inside your classtimer bars.",
								values = AceGUIWidgetLSMlists.font,	
							},
							gen_size = {
								type = "range",
								order = 8,
								name = "General Font Size",
								desc = "Size used for the General Font",
								type = "range",
								min = 5, max = 18, step = 1,								
							},
							ColorGroup = {
								order = 9,
								type = "group",
								name = L["Colors"],
								guiInline = true,
								disabled = function() return not db.classtimer.enable or (not TukuiTarget and not TukuiPlayer) or not db.unitframes.enable end,
								get = function(info)
									local t = db.classtimer[ info[#info] ]
									return t.r, t.g, t.b, t.a
								end,
								set = function(info, r, g, b)
									db.classtimer[ info[#info] ] = {}
									local t = db.classtimer[ info[#info] ]
									t.r, t.g, t.b = r, g, b
									StaticPopup_Show("CFG_RELOAD")
								end,									
								args = {
									buffcolor = {
										type = "color",
										order = 1,
										name = L["Buff"],
										hasAlpha = false,	
									},
									debuffcolor = {
										type = "color",
										order = 2,
										name = L["Debuff"],
										hasAlpha = false,	
									},	
									proccolor = {
										type = "color",
										order = 3,
										name = L["Proc"],
										hasAlpha = false,	
									},
								},
							},				
						},
					},
				},
			},
			spellfilter = {
				order = 13,
				type = "group",
				name = "Filters",
				desc = "Allows you to customize various buffs/debuffs and other filters.",
				get = function(info) return db.spellfilter[ info[#info] ] end,
				set = function(info, value) db.spellfilter[ info[#info] ] = value end,
				args = {
					FilterPicker = {
						order = 2,
						type = "select",
						name = L["Choose Filter"],
						desc = L["CFILTER_DESC"],
						set = function(info, value) 
							db.spellfilter[ info[#info] ] = value 
							UpdateSpellFilter()
						end,
						values = {
							["RaidDebuffs"] = "Raid Debuffs",
							["ErrorList"] = "Error Messages",
							["PlateBlacklist"] = "Nameplate Blacklist",
							["DebuffWhiteList"] = "Debuff Whitelist",
							["TargetPVPOnly"] = "Target Debuffs (PvP Only)",
							["DebuffBlacklist"] = "Debuff Blacklist",
							["ArenaBuffWhiteList"] = "Arena Buffs",
							["HealerBuffIDs"] = "Raid Buffs (Healer)",
							["DPSBuffIDs"] = "Raid Buffs (DPS)",
							["PetBuffs"] = "Pet Buffs",
							["TRINKET_FILTER"] = "Trinket Procs",
							["CLASS_FILTERS"] = "Class Timers"
						},						
					},			
					spacer = {
						type = 'description',
						name = '',
						desc = '',
						order = 3,
					},		
					FilterDesc = {
						type = 'description',
						name = GetFilterDesc(),
						order = 4,
					},						
					NewName = {
						type = 'input',
						name = function() if RaidBuffs[db.spellfilter.FilterPicker] then return L["New Spell ID"] else return L["New name"] end end,
						desc = L["Add a new spell name / ID to the list."],
						get = function(info) return "" end,
						set = function(info, value)						
							if RaidBuffs[db.spellfilter.FilterPicker] then
								if not GetSpellInfo(value) then
									print("Not valid spell id")
								else
									local num = #db.spellfilter[db.spellfilter.FilterPicker][T.myclass] + 1
									db.spellfilter[db.spellfilter.FilterPicker][T.myclass][num] = {["enabled"] = true, ["id"] = tonumber(value), ["point"] = "TOPRIGHT", ["color"] = {["r"] = 1, ["g"] = 0, ["b"] = 0}, ["anyUnit"] = false}
									UpdateSpellFilter()								
									StaticPopup_Show("RELOAD_UI")
								end
							else							
								local name_list = db.spellfilter[db.spellfilter.FilterPicker]
								name_list[value] = true
								UpdateSpellFilter()
								T[name_list] = db.spellfilter[name_list]
								
								if db.spellfilter.FilterPicker ~= "PlateBlacklist" then
									StaticPopup_Show("RELOAD_UI")
								end
							end
						end,
						order = 5,
					},
					DeleteName = {
						type = 'input',
						name = function() if RaidBuffs[db.spellfilter.FilterPicker] then return L["Remove ID"] else return L["Remove Name"] end end,
						desc = "You may only delete spells that you have added. Default spells can be disabled by unchecking the option",
						get = function(info) return "" end,
						set = function(info, value)
							if RaidBuffs[db.spellfilter.FilterPicker] then
								if not GetSpellInfo(value) then
									print("Not valid spell id")
								else
									local match
									for x, y in pairs(db.spellfilter[db.spellfilter.FilterPicker][T.myclass]) do
										if y["id"] == tonumber(value) then
											match = y
											db.spellfilter[db.spellfilter.FilterPicker][T.myclass][x] = nil
										end
									end
									if match == nil then
										print("Spell not found in list")
									else
										UpdateSpellFilter()								
										StaticPopup_Show("RELOAD_UI")									
									end									
								end								
							else
								local name_list = db.spellfilter[db.spellfilter.FilterPicker]
								if db.spellfilter[db.spellfilter.FilterPicker][value] == nil then
									print("Spell not found in list")
								else
									name_list[value] = nil
									UpdateSpellFilter()
									T[name_list] = db.spellfilter[name_list]
									
									if name_list == "RaidDebuffs" then
										StaticPopup_Show("RELOAD_UI")
									end
								end
							end
						end,
						order = 6,
					},
					SpellListTable = {
						order = 7,
						type = "group",
						name = GetFilterName(),
						guiInline = true,
						args = CreateFilterTable(db.spellfilter.FilterPicker),
					},
				},
			},
		},
	}
end