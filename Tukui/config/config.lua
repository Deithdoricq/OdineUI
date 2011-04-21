local T, C, L, DB = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

DB["general"] = {
	["autoscale"] = true,                               -- mainly enabled for users that don't want to mess with the config file
	["uiscale"] = 0.71,                                 -- set your value (between 0.64 and 1) of your uiscale if autoscale is off
	["overridelowtohigh"] = false,                      -- EXPERIMENTAL ONLY! override lower version to higher version on a lower reso.
	["multisampleprotect"] = true,                      -- i don't recommend this because of shitty border but, voila!
}

DB["media"] = {
	--fonts
	["font"] = "Tukui Font",
	["uffont"] = "Tukui UF",
	["dmgfont"] = "Tukui Combat",
	["cfont"] = "Tukui Font",
	["dfont"] = "Tukui UF",
	
	-- textures
	["normTex"] = "Tukui Norm",
	["glowTex"] = "Tukui Glow",
	["blank"] = "Tukui Blank",
	
	["hTex"] = [[Interface\AddOns\Tukui\medias\textures\Glamour2]], -- texture used for health bars
	["panTex"] = [[Interface\AddOns\Tukui\medias\textures\Glamour7]], -- texture used for datatext panels
	
	["striped"] = [[Interface\AddOns\Tukui\medias\textures\Striped]], -- unitframes combo points
	["copyicon"] = [[Interface\AddOns\Tukui\medias\textures\copy]], -- copy icon
	["buttonhover"] = [[Interface\AddOns\Tukui\medias\textures\button_hover]],

	["bordercolor"] = { .05, .05, .05, 1 }, -- border color of tukui panels 
	["backdropcolor"] = { .132, .132, .132, 1 }, -- background color of tukui panels
	["backdropfadecolor"] = { .1, .1, .1, 0.9 }, -- same thing just different alpha
	["altbordercolor"] = { .4, .4, .4 }, -- alternative border color, mainly for unitframes text panels.
	
	-- sound
	["whisper"] = "Tukui Whisper",
	["warning"] = "Tukui Warning",
}

DB["unitframes"] = {
	-- Gen.
	["enable"] = true,                                  -- do i really need to explain this?
	
	-- Colors
	["enemyhcolor"] = false,                            -- enemy target (players) color by hostility, very useful for healer.
	["unicolor"] = true,                               -- enable unicolor theme
		["healthColor"] = { .1, .1, .1 },
		["healthBgColor"] = { .7, .1, .1 },
	
	-- Castbar
	["unitcastbar"] = true,                             -- enable tukui castbar
	["cblatency"] = false,                              -- enable castbar latency
	["cbicons"] = true,                                 -- enable icons on castbar
	["cbinside"] = false,								-- castbar inside unit frames, disable for outside of them (will not work if using large player castbar)
	["large_player"] = true,							-- enable larger player castbar above actionbar
	["cbclasscolor"] = false,
		["cbcustomcolor"] = { .20, .21, .19 },
		
	-- Auras
	["auratimer"] = true,                               -- enable timers on buffs/debuffs
	["auratextscale"] = 11,                             -- the font size of buffs/debuffs timers on unitframes
	["playerauras"] = true,                            -- enable auras
	["playershowonlydebuffs"] = true, 					-- only show the players debuffs over the player frame, not buffs (playerauras must be true) (CODE NOT FINISHED)
	["playerdebuffsonly"] = true,						-- show the players debuffs on target, and any debuff in the whitelist.
	["targetauras"] = true,                             -- enable auras on target unit frame
	["totdebuffs"] = true,                             -- enable tot debuffs (high reso only)
	["focusdebuffs"] = true,                            -- enable focus debuffs
	["arenabuffs"] = true,								-- enable arena buffs
	["arenadebuffs"] = true, 							-- enable debuff filter for arena frames
	["bossbuffs"] = true,								-- enable boss buffs
	["bossdebuffs"] = true,								-- enable boss debuffs
	["buffsperrow"] = 8,                  				-- set amount of buffs shown (player/target only)
	["debuffsperrow"] = 7,								-- set amount of debuffs shown (player/target only)
	
	
	-- Misc.
	["charportrait"] = true,                           -- do i really need to explain this?
	["showtotalhpmp"] = false,                          -- change the display of info text on player and target with XXXX/Total.
	["targetpowerpvponly"] = true,                      -- enable power text on pvp target only
	["showsmooth"] = true,                              -- enable smooth bar
	["lowThreshold"] = 20,                              -- global low threshold, for low mana warning.
	["combatfeedback"] = false,                          -- enable combattext on player and target.
	["playeraggro"] = true,                             -- color player border to red if you have aggro on current target.
	
	-- misc
	["vengeance"] = true,								-- vengeance bar for tanks
	["swingbar"] = false,								-- swing bar
	["percentage"] = true,            					-- shows a hp/pp percent number next to a unitframe on selected frames	

	-- Party / Raid
		-- Gen.
		["showrange"] = true,                               -- show range opacity on raidframes
		["raidalphaoor"] = 0.7,                             -- alpha of unitframes when unit is out of range
		["showplayerinparty"] = true,                      -- show my player frame in party
		["showsymbols"] = true,	                            -- show symbol.
		["aggro"] = true,                                   -- show aggro on all raids layouts
		["raidunitdebuffwatch"] = true,                     -- track important spell to watch in pve for grid mode.
		["healcomm"] = true,                               -- enable healprediction support.
		["debuffHighlightFilter"] = false,					-- filter debuff border coloring
		["buffindicatorsize"] = 6,							-- size of the buff indicator on raid/party frames

		-- Heal
		["healthvertical"] = false,
		["healthdeficit"] = false,	
		
		-- Dps
		["hidepower"] = false,
		
	-- Frame Sizes
	["playtarframe"] = 215,								-- size of player/target frame
	["otherframe"] = 130,								-- size of tot/focus/pet frames
	["baframe"] = 200,									-- size of boss/arena frames
	

	-- Extra Frames
	["maintank"] = false,                               -- enable maintank
	["mainassist"] = false,                             -- enable mainassist
	["showboss"] = true,                                -- enable boss unit frames for PVELOL encounters.
	
	-- priest only plugin
	["weakenedsoulbar"] = true,                         -- show weakened soul bar
	
	-- class bar
	["classbar"] = true,                                -- enable tukui classbar over player unit, false disables all classes
}

DB["arena"] = {
	["unitframes"] = true,                              -- enable tukz arena unitframes (requirement : tukui unitframes enabled)
}

DB["auras"] = {
	["player"] = true,                                  -- enable tukui buffs/debuffs
}

DB["actionbar"] = {
	["enable"] = true,                                  -- enable tukui action bars
	["hotkey"] = true,                                 -- enable hotkey display because it was a lot requested
	["hideshapeshift"] = false,                         -- hide shapeshift or totembar because it was a lot requested.
	["shapeshiftmouseover"] = false,					-- hide shapeshift or totembar unless moused over.
	--["rightbarmouseover"] = true,						-- mouseover on rightbars
	["showgrid"] = true,                                -- show grid on empty button
	["buttonsize"] = 29,                                -- normal buttons size 27
	["petbuttonsize"] = 29,                             -- pet & stance buttons size
	["stancebuttonsize"] = 29,                             -- pet & stance buttons size
	["buttonspacing"] = 2,                              -- buttons spacing 4
	["vertical_rightbars"] = true,						-- enables vertical rightbars
}

DB["bags"] = {
	["enable"] = true,                                  -- enable an all in one bag mod that fit tukui perfectly
	["placement"] = 1,									-- allows you to position bag windows over chat windows or right above them! (option 1 - over chat windows, option 2 - above chat windows)
}

DB["map"] = {
	["enable"] = true,                                  -- reskin the map to fit tukui
}

DB["loot"] = {
	["lootframe"] = true,                               -- reskin the loot frame to fit tukui
	["rolllootframe"] = true,                           -- reskin the roll frame to fit tukui
	["autogreed"] = true,                               -- auto-dez or auto-greed item at max level, auto-greed Frozen orb
}

DB["cooldown"] = {
	["enable"] = true,                                  -- do i really need to explain this?
	["treshold"] = 6,                                   -- show decimal under X seconds and text turn red
}

DB["datatext"] = {
	["armor"] = 0,                                      -- show your armor value against the level mob you are currently targeting
	["avd"] = 0,                                        -- show your current avoidance against the level of the mob your targeting
	["bags"] = 6,                                       -- show space used in bags on panels
	["crit"] = 10,                                       -- show your crit rating on panels.
	["currency"] = 2,                                   -- show your tracked currency on panels
	["dps_text"] = 0,                                   -- show a dps meter on panels
	["dur"] = 9,                                        -- show your equipment durability on panels.
	["friends"] = 3,                                    -- show number of friends connected.
	["gold"] = 5,                                       -- show your current gold on panels
	["guild"] = 1,                                      -- show number on guildmate connected on panels
	["haste"] = 11,                                      -- show your haste rating on panels.
	["hit"] = 0,
	["hps_text"] = 0,                                   -- show a heal meter on panels
	["mastery"] = 4,
	["spec"] = 8,             							-- show your active talent group and allow you to switch on panels.
	["power"] = 7,                                      -- show your attackpower/spellpower/healpower/rangedattackpower whatever stat is higher gets displayed
	["regen"] = 0,										-- display your mana regen

	["battleground"] = true,                            -- enable 3 stats in battleground only that replace stat1,stat2,stat3.
	["statblock"] = true,								-- enables stat block at top left
	["location"] = true,								-- enables location panel at top middle
	["time24"] = false,                                  -- set time to 24h format.
	["localtime"] = true,                              -- set time to local time instead of server time.
	["bars"] = true,									-- enable rep/exp bars under minimap
		["bar_text"] = false,							-- display text in rep/exp bars
	["fsize"] = 15,										-- default font size
	
	["classcolor"] = true,
		["color"] = { .156, .149, .149 },
}

DB["misc"] = {
	["announceint"] = true,								-- announce your interrupts in chat
	["epgp"] = false,									-- enable to show epgp points in guild datatext
	["viewport"] = false,								-- enable viewport
	["autoquest"] = false,								-- enable automatic turn in/autoaccept quests
}

DB["chat"] = {
	["enable"] = true,                                  -- blah
	["whispersound"] = true,                            -- play a sound when receiving whisper
	["height"] = 150,									-- adjust the chatframe height default: 165 odine: 200
	["background"] = true,								-- chat frame backgrounds 150
	["fading"] = false,									-- allow chat windows to fade out
	["justifyRight"] = false,							-- when set to true text in right chat box will be aligned towards the right side of the chat box
	["fsize"] = 12,										-- default font size
}

DB["nameplate"] = {
	["enable"] = true,                                  -- enable nice skinned nameplates that fit into tukui
	["showhealth"] = true,				                -- show health text on nameplate
	["enhancethreat"] = true,			                -- threat features based on if your a tank or not
	["overlap"] = false,				                -- allow nameplates to overlap
	["combat"] = false,					                -- only show enemy nameplates in-combat.
	["goodcolor"] = {75/255,  175/255, 76/255},	        -- good threat color (tank shows this with threat, everyone else without)
	["badcolor"] = {0.78, 0.25, 0.25},			        -- bad threat color (opposite of above)
	["transitioncolor"] = {218/255, 197/255, 92/255},	-- threat color when gaining threat
	["trackcc"] = true,									--track all CC debuffs
	["trackdebuffs"] = true,							--track players debuffs only (debuff list derived from classtimer spell list)
}

DB["tooltip"] = {
	["enable"] = true,                                  -- true to enable this mod, false to disable
	["hidecombat"] = false,                             -- hide bottom-right tooltip when in combat
	["hidebuttons"] = false,                            -- always hide action bar buttons tooltip.
	["hideuf"] = false,                                 -- hide tooltip on unitframes
	["cursor"] = false,                                 -- tooltip via cursor only
	["whotarget"] = true,								-- show who is targeting you (raid/party only)
}

DB["merchant"] = {
	["sellgrays"] = true,                               -- automaticly sell grays?
	["autorepair"] = false,                              -- automaticly repair?
	["sellmisc"] = true,                                -- sell defined items automatically
}

DB["error"] = {
	["enable"] = true,                                  -- true to enable this mod, false to disable
}

DB["invite"] = { 
	["autoaccept"] = true,                              -- auto-accept invite from guildmate and friends.
}

DB["buffreminder"] = {
	["enable"] = true,                                  -- this is now the new innerfire warning script for all armor/aspect class.
	["sound"] = true,                                   -- enable warning sound notification for reminder.
}

-- Addons skins by Darth Android
DB["addonskins"] = {
	["kle"] = true,										-- skins KLE
	["tinydps"] = true,									-- skins TinyDPS
	["dbm"] = true,										-- skins DBM
	["recount"] = true,									-- skins Recount 
	["omen"] = true,									-- skins Omen
	["skada"] = true,									-- skins skada
	["coolline"] = true,								-- skins CoolLine
	["embed"] = "NONE",
}

DB["classtimer"] = {
	["enable"] = true,
	["bar_height"] = 16,
	["bar_spacing"] = 4,
	["icon_position"] = 2, -- 0 = left, 1 = right, 2 = Outside left, 3 = Outside Right
	["layout"] = 4, --1 - both player and target auras in one frame right above player frame, 2 - player and target auras separated into two frames above player frame, 3 - player, target and trinket auras separated into three frames above player frame, 4 - player and trinket auras are shown above player frame and target auras are shown above target frame, 5 - Everything above player frame, no target debuffs.
	["showspark"] = true,
	["cast_suparator"] = true,
	
	["classcolor"] = false,
	["buffcolor"] = { r = .05, g = .05, b = .05 },
	["debuffcolor"] = { r = 0.78, g = 0.25, b = 0.25 },
	["proccolor"] = { r = 0.84, g = 0.75, b = 0.65 },
	
	["gen_font"] = "Tukui UF",
	["gen_size"] = 13,
}