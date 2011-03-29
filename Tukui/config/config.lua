local T, C, L, DB = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

DB["general"] = {
	["autoscale"] = true,                               -- mainly enabled for users that don't want to mess with the config file
	["uiscale"] = 0.71,                                 -- set your value (between 0.64 and 1) of your uiscale if autoscale is off
	["overridelowtohigh"] = false,                      -- EXPERIMENTAL ONLY! override lower version to higher version on a lower reso.
	["multisampleprotect"] = true,                      -- i don't recommend this because of shitty border but, voila!
}

DB["unitframes"] = {
	-- Gen.
	["enable"] = true,                                  -- do i really need to explain this?
	
	-- Colors
	["enemyhcolor"] = false,                            -- enemy target (players) color by hostility, very useful for healer.
	["unicolor"] = true,                               -- enable unicolor theme
		["healthColor"] = { .12, .12, .12 },
		["healthBgColor"] = { .7, .1, .1 },
	
	-- Castbar
	["unitcastbar"] = true,                             -- enable tukui castbar
	["cblatency"] = false,                              -- enable castbar latency
	["cbicons"] = true,                                 -- enable icons on castbar
	["cbinside"] = false,								-- castbar inside unit frames, disable for outside of them (will not work if using large player castbar)
	["large_player"] = true,							-- enable larger player castbar above actionbar
	["cbclasscolor"] = false,
		["cbcustomcolor"] = { .15, .15, .15 },
		
	-- Auras
	["auratimer"] = true,                               -- enable timers on buffs/debuffs
	["auratextscale"] = 11,                             -- the font size of buffs/debuffs timers on unitframes
	["playerauras"] = false,                            -- enable auras
	["targetauras"] = true,                             -- enable auras on target unit frame
	["totdebuffs"] = true,                             -- enable tot debuffs (high reso only)
	["focusdebuffs"] = true,                            -- enable focus debuffs
	["focusbuffs"] = true,                              -- enable focus buffs
	["petbuffs"] = false,								-- display pets buffs
	["onlyselfdebuffs"] = false,                        -- display only our own debuffs applied on target
	["onlyselfbuffs"] = false,                        	-- display only our own buffs applied on target
	["buffrows"] = 2,                       
	["debuffrows"] = 2,                        
	
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
		["raidalphaoor"] = 0.5,                             -- alpha of unitframes when unit is out of range
		["showplayerinparty"] = true,                      -- show my player frame in party
		["showsymbols"] = true,	                            -- show symbol.
		["aggro"] = true,                                   -- show aggro on all raids layouts
		["raidunitdebuffwatch"] = true,                     -- track important spell to watch in pve for grid mode.
		["healcomm"] = true,                               -- enable healprediction support.

		-- Heal
		["healthvertical"] = false,
		["healthdeficit"] = false,	
		
		-- Dps
		["hidepower"] = false,
	

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
	["showgrid"] = true,                                -- show grid on empty button
	["buttonsize"] = 30,                                -- normal buttons size 27
	["petbuttonsize"] = 30,                             -- pet & stance buttons size
	["stancebuttonsize"] = 30,                             -- pet & stance buttons size
	["buttonspacing"] = 3,                              -- buttons spacing 4 
}

DB["bags"] = {
	["enable"] = true,                                  -- enable an all in one bag mod that fit tukui perfectly
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
	["micromenu"] = 0,
	["power"] = 7,                                      -- show your attackpower/spellpower/healpower/rangedattackpower whatever stat is higher gets displayed

	["battleground"] = true,                            -- enable 3 stats in battleground only that replace stat1,stat2,stat3.
	["time24"] = false,                                  -- set time to 24h format.
	["localtime"] = true,                              -- set time to local time instead of server time.
	["bars"] = true,									-- enable rep/exp bars under minimap
	["fsize"] = 13,										-- default font size
	
	["classcolor"] = true,
		["color"] = { .4, .4, .4 },
}

DB["misc"] = {
	["announceint"] = true,								-- announce your interrupts in chat
	["epgp"] = false,									-- enable to show epgp points in guild datatext
	["viewport"] = false,								-- enable viewport
	["autoquest"] = false,								-- enable automatic turn in/autoaccept quests
	["sct"] = true,										-- enable lightweight scrolling combat text mod by Monolit
}

DB["chat"] = {
	["enable"] = true,                                  -- blah
	["whispersound"] = true,                            -- play a sound when receiving whisper
	["height"] = 215,									-- adjust the chatframe height default: 165
	["background"] = true,								-- chat frame backgrounds
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
}

DB["merchant"] = {
	["sellgrays"] = true,                               -- automaticly sell grays?
	["autorepair"] = false,                              -- automaticly repair?
	["sellmisc"] = true,                                -- sell defined items automatically
}

DB["error"] = {
	["enable"] = false,                                  -- true to enable this mod, false to disable
	filter = {                                          -- what messages to not hide
		[INVENTORY_FULL] = true,                        -- inventory is full will not be hidden by default
	},
}

DB["invite"] = { 
	["autoaccept"] = true,                              -- auto-accept invite from guildmate and friends.
}

DB["buffreminder"] = {
	["enable"] = true,                                  -- this is now the new innerfire warning script for all armor/aspect class.
	["sound"] = false,                                   -- enable warning sound notification for reminder.
}

-- Addons skins by Darth Android
DB["addonskins"] = {
	["kle"] = true,										-- skins KLE
	["tinydps"] = true,									-- skins TinyDPS
	["dbm"] = true,										-- skins DBM
	["recount"] = true,									-- skins Recount 
	["omen"] = true,									-- skins Omen
}

DB["media"] = {
	--fonts
	["font"] = "Tukui Font",
	["uffont"] = "Tukui UF",
	["dmgfont"] = "Tukui Combat",
	["cfont"] = "Tukui Font",
	["dfont"] = "Tukui Font",
	
	-- textures
	["normTex"] = "Tukui Norm",
	["glowTex"] = "Tukui Glow",
	["blank"] = "Tukui Blank",
	
	["striped"] = [[Interface\AddOns\Tukui\medias\textures\Striped]], -- unitframes combo points
	["copyicon"] = [[Interface\AddOns\Tukui\medias\textures\copy]], -- copy icon
	["buttonhover"] = [[Interface\AddOns\Tukui\medias\textures\button_hover]],

	["bordercolor"] = { .05, .05, .05, 1 }, -- border color of tukui panels 
	["backdropcolor"] = { .1, .1, .1, 1 }, -- background color of tukui panels
	["altbordercolor"] = { .4, .4, .4 }, -- alternative border color, mainly for unitframes text panels.
	
	-- sound
	["whisper"] = "Tukui Whisper",
	["warning"] = "Tukui Warning",
}