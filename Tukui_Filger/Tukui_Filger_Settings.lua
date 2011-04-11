local _, ns = ...
local asize = 35 - 3.35

ns.Filger_Settings = {
	configmode = false,
}

ns.Filger_Spells = {
	["DRUID"] = {
		{
			Name = "P_BUFF_ICON",
			Direction = "LEFT",
			Interval = 4,
			Opacity = 1,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", TukuiPlayer, "TOPRIGHT", 0, 240 },

			-- Lifebloom/Blühendes Leben
			{ spellID = 33763, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Rejuvenation/Verjüngung
			{ spellID = 774, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Regrowth/Nachwachsen
			{ spellID = 8936, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Wild Growth/Wildwuchs
			{ spellID = 48438, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
		},
		{
			Name = "T_BUFF_ICON",
			Direction = "RIGHT",
			Interval = 4,
			Opacity = 1,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", TukuiTarget, "TOPLEFT", 0, 240 },

			-- Lifebloom/Blühendes Leben
			{ spellID = 33763, size = asize, unitId = "target", caster = "player", filter = "BUFF" },
			-- Rejuvenation/Verjüngung
			{ spellID = 774, size = asize, unitId = "target", caster = "player", filter = "BUFF" },
			-- Regrowth/Nachwachsen
			{ spellID = 8936, size = asize, unitId = "target", caster = "player", filter = "BUFF" },
			-- Wild Growth/Wildwuchs
			{ spellID = 48438, size = asize, unitId = "target", caster = "player", filter = "BUFF" },
		},
		{
			Name = "P_PROC_ICON",
			Direction = "LEFT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", TukuiPlayer, "TOPRIGHT", 0, 240 },

			-- Eclipse (Lunar)/Mondfinsternis
			{ spellID = 48518, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Eclipse (Solar)/Sonnenfinsternis
			{ spellID = 48517, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Shooting Stars/Sternschnuppen
			{ spellID = 93400, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Savage Roar/Wildes Brüllen
			{ spellID = 52610, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Survival Instincts/Überlebensinstinkte
			{ spellID = 61336, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Tree of Life/Baum des Lebens
			{ spellID = 33891, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Clearcasting/Freizaubern
			{ spellID = 16870, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Innervate/Anregen
			{ spellID = 29166, size = asize*1.5, unitId = "player", caster = "all", filter = "BUFF" },
			-- Barkskin/Baumrinde
			{ spellID = 22812, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
		},
		{
			Name = "T_DEBUFF_ICON",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", TukuiTarget, "TOPLEFT", 0, 240 },

			-- Hibernate/Winterschlaf
			{ spellID = 2637, size = asize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Entangling Roots/Wucherwurzeln
			{ spellID = 339, size = asize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Cyclone/Wirbelsturm
			{ spellID = 33786, size = asize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Moonfire/Mondfeuer
			{ spellID = 8921, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Sunfire/Sonnenfeuer
			{ spellID = 93402, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Insect Swarm/Insektenschwarm
			{ spellID = 5570, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Rake/Krallenhieb
			{ spellID = 1822, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Rip/Zerfetzen
			{ spellID = 1079, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Lacerate/Aufschlitzen
			--{ spellID = 33745, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Pounce Bleed/Anspringblutung
			{ spellID = 9007, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Mangle/Zerfleischen
			{ spellID = 33876, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Earth and Moon/Erde und Mond
			{ spellID = 48506, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Faerie Fire/Feenfeuer
			{ spellID = 770, size = asize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
		},
		{
			Name = "F/DEBUFF_BAR",
			Direction = "UP",
			IconSide = "LEFT",
			Interval = 4,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", TukuiFocus, "TOPLEFT", 0, 100 },

			-- Hibernate/Winterschlaf
			{ spellID = 2637, size = asize, barWidth = 200, unitId = "focus", caster = "all", filter = "DEBUFF" },
			-- Entangling Roots/Wucherwurzeln
			{ spellID = 339, size = asize, barWidth = 200, unitId = "focus", caster = "all", filter = "DEBUFF" },
			-- Cyclone/Wirbelsturm
			{ spellID = 33786, size = asize, barWidth = 200, unitId = "focus", caster = "all", filter = "DEBUFF" },
		},
	},
	["HUNTER"] = {
		{
			Name = "P_PROC_ICON",
			Direction = "LEFT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", TukuiPlayer, "TOPRIGHT", 0, 240 },

			-- Lock and Load
			{ spellID = 56342, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Fury of the Five Flights
			{ spellID = 60314, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Quick Shots
			--{ spellID = 6150, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Master Tactician
			{ spellID = 34837, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Improved Steady Shot/Verbesserter zuverlässiger Schuss
			{ spellID = 53224, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Expose Weakness
			--{ spellID = 34503, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Rapid Fire
			{ spellID = 3045, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Call of the Wild
			{ spellID = 53434, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Mend Pet/Tier heilen
			{ spellID = 136, size = asize*1.5, unitId = "pet", caster = "player", filter = "BUFF" },
			-- Feed Pet/Tier füttern
			{ spellID = 6991, size = asize*1.5, unitId = "pet", caster = "player", filter = "BUFF" },
		},
		{
			Name = "T_DEBUFF_ICON",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", TukuiTarget, "TOPLEFT", 0, 240 },
			
			-- Wyvern Sting
			{ spellID = 19386, size = asize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Silencing Shot
			{ spellID = 34490, size = asize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Serpent Sting
			{ spellID = 1978, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Widow Venom/Witwentoxin
			{ spellID = 82654, size = asize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Black Arrow
			{ spellID = 3674, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Explosive Shot
			{ spellID = 53301, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Hunter's Mark
			{ spellID = 1130, size = asize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },

		},
		{
			Name = "F/DEBUFF_BAR",
			Direction = "UP",
			IconSide = "LEFT",
			Interval = 4,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", TukuiFocus, "TOPLEFT", 0, 100 },

			-- Wyvern Sting
			{ spellID = 19386, size = asize, barWidth = 200, unitId = "focus", caster = "all", filter = "DEBUFF" },
			-- Silencing Shot
			{ spellID = 34490, size = asize, barWidth = 200, unitId = "focus", caster = "all", filter = "DEBUFF" },
		},
	},
	["MAGE"] = {
		{
			Name = "P_PROC_ICON",
			Direction = "LEFT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", TukuiPlayer, "TOPRIGHT", 0, 240 },

			-- Frostbite
			--{ spellID = 11071, size = asize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Winter's Chill
			{ spellID = 28593, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Fingers of Frost
			{ spellID = 44544, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Fireball!
			{ spellID = 57761, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Hot Streak
			{ spellID = 44445, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Missile Barrage
			{ spellID = 54486, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Clearcasting
			{ spellID = 12536, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Impact
			{ spellID = 12358, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
		},
		{
			Name = "T_DEBUFF_ICON",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", TukuiTarget, "TOPLEFT", 0, 240 },

			-- Polymorph
			{ spellID = 118, size = asize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Slow
			{ spellID = 31589, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Ignite
			--{ spellID = 11119, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Living Bomb
			{ spellID = 44457, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
		},
		{
			Name = "F/DEBUFF_BAR",
			Direction = "UP",
			IconSide = "LEFT",
			Interval = 4,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", TukuiFocus, "TOPLEFT", 0, 100 },

			-- Polymorph
			{ spellID = 118, size = asize, barWidth = 200, unitId = "focus", caster = "all", filter = "DEBUFF" },
		},
	},
	["WARRIOR"] = {
		{
			Name = "P_PROC_ICON",
			Direction = "LEFT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", TukuiPlayer, "TOPRIGHT", 0, 240 },

			-- Sudden Death
			{ spellID = 52437, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Slam!
			{ spellID = 46916, size = asize*1.5, unitId = "player", caster = "all", filter = "BUFF" },
			-- Sword and Board
			{ spellID = 50227, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Blood Reserve
			{ spellID = 64568, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Last Stand
			{ spellID = 12975, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Shield Wall
			{ spellID = 871, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Battle Trance
			{ spellID = 12964, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Rude Interruption
			{ spellID = 86663, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Executioner
			{ spellID = 90806, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Inner Rage
			{ spellID = 1134, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
		},
		{
			Name = "T_DEBUFF_ICON",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", TukuiTarget, "TOPLEFT", 0, 240 },

			-- Hamstring
			{ spellID = 1715, size = asize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Rend
			{ spellID = 94009, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Sunder Armor
			{ spellID = 7386, size = asize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Thunder Clap
			{ spellID = 6343, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Demoralizing Shout
			{ spellID = 1160, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
		},
	},
	["SHAMAN"] = {
		{
			Name = "P_BUFF_ICON",
			Direction = "LEFT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", TukuiPlayer, "TOPRIGHT", 0, 240 },

			-- Earth Shield/Erdschild
			{ spellID = 974, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Riptide/Springflut
			{ spellID = 61295, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Lightning Shield/Blitzschlagschild
			--{ spellID = 324, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Water Shield/Wasserschild
			{ spellID = 52127, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Spiritwalker's Grace
			{ spellID = 79206, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
		},
		{
			Name = "T_BUFF_ICON",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", TukuiTarget, "TOPLEFT", 0, 240 },

			-- Earth Shield/Erdschild
			{ spellID = 974, size = asize, unitId = "target", caster = "player", filter = "BUFF" },
			-- Riptide/Springflut
			{ spellID = 61295, size = asize, unitId = "target", caster = "player", filter = "BUFF" },
			-- Earthliving
			{ spellID = 51945, size = asize, unitId = "target", caster = "player", filter = "BUFF" },
		},
		{
			Name = "P_PROC_ICON",
			Direction = "LEFT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", TukuiPlayer, "TOPRIGHT", 0, 240 },

			-- Maelstorm Weapon
			--{ spellID = 53817, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Shamanistic Rage
			{ spellID = 30823, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Clearcasting
			{ spellID = 16246, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Tidal Waves
			--{ spellID = 51562, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Unleash Flame
			{ spellID = 73683, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Unleash Life
			{ spellID = 73685, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
		},
		{
			Name = "T_DEBUFF_ICON",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", TukuiTarget, "TOPLEFT", 0, 240 },

			-- Hex
			{ spellID = 51514, size = asize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Earth Shock
			--{ spellID = 8042, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Frost Shock
			{ spellID = 8056, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Flame Shock
			{ spellID = 8050, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Searing Flames
			{ spellID = 77661, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Frostbrand Attack
			{ spellID = 8034, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" }, 
			-- Unleash Frost
			{ spellID = 73682, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" }, 
			-- Unleash Earth
			{ spellID = 73684, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
		},
		{
			Name = "F/DEBUFF_BAR",
			Direction = "UP",
			IconSide = "LEFT",
			Interval = 4,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", TukuiFocus, "TOPLEFT", 0, 100 },

			-- Hex
			{ spellID = 51514, size = asize, barWidth = 200, unitId = "focus", caster = "all", filter = "DEBUFF" },
			-- Bind Elemental
			{ spellID = 76780, size = asize, barWidth = 200, unitId = "focus", caster = "all", filter = "DEBUFF" },
		},
	},
	["PALADIN"] = {
		{
			Name = "P_BUFF_ICON",
			Direction = "LEFT",
			Interval = 4,
			Opacity = 1,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", TukuiPlayer, "TOPRIGHT", 0, 240 },

			-- Beacon of Light/Flamme des Glaubens
			{ spellID = 53563, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Judgements of the Pure
			{ spellID = 53657, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Illuminated Healing
			{ spellID = 86273, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
		},
		{
			Name = "T_BUFF_ICON",
			Direction = "RIGHT",
			Interval = 4,
			Opacity = 1,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", TukuiTarget, "TOPLEFT", 0, 240 },

			-- Beacon of Light/Flamme des Glaubens
			{ spellID = 53563, size = asize, unitId = "target", caster = "player", filter = "BUFF" },
			-- Illuminated Healing
			{ spellID = 86273, size = asize, unitId = "target", caster = "player", filter = "BUFF" },
		},
		{
			Name = "P_PROC_ICON",
			Direction = "LEFT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", TukuiPlayer, "TOPRIGHT", 0, 240 },

			-- Holy Shield
			{ spellID = 20925, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Infusion of Light
			{ spellID = 54149, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Divine Plea
			{ spellID = 54428, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Divine Illumination
			{ spellID = 31842, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Denounse
			{ spellID = 85509, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
		},
		{
			Name = "T_DEBUFF_ICON",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", TukuiTarget, "TOPLEFT", 0, 240 },

			-- Hammer of Justice/Hammer der Gerechtigkeit
			{ spellID = 853, size = asize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Judgement
			{ spellID = 20271, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Repentance 
			{ spellID = 20066, size = asize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
		},
		{
			Name = "F/DEBUFF_BAR",
			Direction = "UP",
			IconSide = "LEFT",
			Interval = 4,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", TukuiFocus, "TOPLEFT", 0, 100 },

			-- Hammer of Justice/Hammer der Gerechtigkeit
			{ spellID = 853, size = asize, barWidth = 200, unitId = "focus", caster = "all", filter = "DEBUFF" },
			-- Repentance 
			{ spellID = 20066, size = asize, barWidth = 200, unitId = "focus", caster = "all", filter = "DEBUFF" },
		},
	},
	["PRIEST"] = {
		{
			Name = "P_BUFF_ICON",
			Direction = "LEFT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", TukuiPlayer, "TOPRIGHT", 0, 240 },

			-- Prayer of Mending/Gebet der Besserung
			{ spellID = 41637, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Guardian Spirit/Schutzgeist
			{ spellID = 47788, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Pain Suppression/Schmerzunterdrückung
			{ spellID = 33206, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Power Word: Shield/Machtwort: Schild
			{ spellID = 17, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Renew/Erneuerung
			{ spellID = 139, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Fade/Verblassen
			{ spellID = 586, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Fear Ward/Furchtzauberschutz
			{ spellID = 6346, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Inner Fire/Inneres Feuer
			{ spellID = 588, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Chakra States
			{ spellID = 81208, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			{ spellID = 81206, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
		},
		{
			Name = "T_BUFF_ICON",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", TukuiTarget, "TOPLEFT", 0, 240 },

			-- Prayer of Mending/Gebet der Besserung
			{ spellID = 41637, size = asize, unitId = "target", caster = "player", filter = "BUFF" },
			-- Guardian Spirit/Schutzgeist
			{ spellID = 47788, size = asize, unitId = "target", caster = "player", filter = "BUFF" },
			-- Pain Suppression/Schmerzunterdrückung
			{ spellID = 33206, size = asize, unitId = "target", caster = "player", filter = "BUFF" },
			-- Power Word: Shield/Machtwort: Schild
			{ spellID = 17, size = asize, unitId = "target", caster = "player", filter = "BUFF" },
			-- Renew/Erneuerung
			{ spellID = 139, size = asize, unitId = "target", caster = "player", filter = "BUFF" },
			-- Fear Ward/Furchtzauberschutz
			{ spellID = 6346, size = asize, unitId = "target", caster = "player", filter = "BUFF" },
		},
		{
			Name = "P_PROC_ICON",
			Direction = "LEFT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", TukuiPlayer, "TOPRIGHT", 0, 240 },

			-- Surge of Light
			{ spellID = 33151, size = asize*1.5, unitId = "player", caster = "all", filter = "BUFF" },
			-- Serendipity
			{ spellID = 63730, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Shadow Weaving
			--{ spellID = 15258, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Improved Spirit Tap
			-- { spellID = 59000, size = 37, unitId = "player", caster = "all", filter = "BUFF" },
			-- Shadow Orb
			{ spellID = 77487, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Archangel
			{ spellID = 81700, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Evangelism
			--{ spellID = 81661, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Dispersion
			{ spellID = 47585, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
		},
		{
			Name = "T_DEBUFF_ICON",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", TukuiTarget, "TOPLEFT", 0, 240 },

			-- Shackle undead
			{ spellID = 9484, size = asize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Psychic Scream
			{ spellID = 8122, size = asize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Shadow Word: Pain
			{ spellID = 589, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Devouring Plague
			{ spellID = 2944, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Vampiric Touch
			{ spellID = 34914, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
		},
		{
			Name = "F/DEBUFF_BAR",
			Direction = "UP",
			IconSide = "LEFT",
			Interval = 4,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", TukuiFocus, "TOPLEFT", 0, 100 },

			-- Shackle undead
			{ spellID = 9484, size = asize, barWidth = 200, unitId = "focus", caster = "all", filter = "DEBUFF" },
			-- Psychic Scream
			{ spellID = 8122, size = asize, barWidth = 200, unitId = "focus", caster = "all", filter = "DEBUFF" },
		},
	},
	["WARLOCK"] = {
		{
			Name = "P_PROC_ICON",
			Direction = "LEFT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", TukuiPlayer, "TOPRIGHT", 0, 240 },

			--Devious Minds/Teuflische Absichten
			{ spellID = 70840, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Improved Soul Fire
			{ spellID = 85114, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Molten Core
			{ spellID = 47383, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Decimation
			{ spellID = 63158, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Backdraft
			{ spellID = 54277, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Backlash
			{ spellID = 34939, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Nether Protection
			{ spellID = 30301, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Nightfall
			{ spellID = 18095, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Burning Soul
			{ spellID = 74434, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
		},
		{
			Name = "T_DEBUFF_ICON",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", TukuiTarget, "TOPLEFT", 0, 240 },

			-- Fear
			{ spellID = 5782, size = asize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Banish
			{ spellID = 710, size = asize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Curse of the Elements
			{ spellID = 1490, size = asize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Curse of Tongues
			{ spellID = 1714, size = asize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Curse of Exhaustion
			{ spellID = 18223, size = asize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Curse of Weakness
			{ spellID = 702, size = asize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Shadow Embrace
			{ spellID = 32385, size = asize*1.5, unitId = "target", caster = "player", filter = "BUFF" },
			-- Corruption
			{ spellID = 172, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Immolate
			{ spellID = 348, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Curse of Agony
			{ spellID = 980, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Bane of Doom
			{ spellID = 603, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Unstable Affliction
			{ spellID = 30108, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Haunt
			{ spellID = 48181, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Seed of Corruption
			{ spellID = 27243, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Howl of Terror
			{ spellID = 5484, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Death Coil
			{ spellID = 6789, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Enslave Demon
			{ spellID = 1098, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Demon Charge
			{ spellID = 54785, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
		},
		{
			Name = "F/DEBUFF_BAR",
			Direction = "UP",
			IconSide = "RIGHT",
			Interval = 4,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", TukuiFocus, "TOPLEFT", 0, 100 },

			-- Fear
			{ spellID = 5782, size = asize, barWidth = 200, unitId = "focus", caster = "all", filter = "DEBUFF" },
			-- Banish
			{ spellID = 710, size = asize, barWidth = 200, unitId = "focus", caster = "all", filter = "DEBUFF" },
		},
	},
	["ROGUE"] = {
		{
			Name = "P_PROC_ICON",
			Direction = "LEFT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", TukuiPlayer, "TOPRIGHT", 0, 240 },

			-- Sprint
			{ spellID = 2983, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Cloak of Shadows
			{ spellID = 31224, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Adrenaline Rush
			{ spellID = 13750, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Evasion
			{ spellID = 5277, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Envenom
			{ spellID = 32645, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Overkill
			{ spellID = 58426, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Slice and Dice
			{ spellID = 5171, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Tricks of the Trade
			{ spellID = 57934, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Turn the Tables
			{ spellID = 51627, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Recuperate
			{ spellID = 73651, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Shadow Step
			{ spellID = 36563, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
		},
		{
			Name = "T_DEBUFF_ICON",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", TukuiTarget, "TOPLEFT", 0, 240 },

			-- Cheap shot
			{ spellID = 1833, size = asize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Kidney shot
			{ spellID = 408, size = asize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Blind
			{ spellID = 2094, size = asize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Sap
			{ spellID = 6770, size = asize*1.5, unitId = "target", caster = "all", filter = "DEBUFF" },
			-- Rupture
			{ spellID = 1943, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Garrote
			{ spellID = 703, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Gouge
			{ spellID = 1776, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Expose Armor
			{ spellID = 8647, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Dismantle
			{ spellID = 51722, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Deadly Poison
			{ spellID = 2818, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Mind-numbing Poison
			{ spellID = 5760, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Crippling Poison
			{ spellID = 3409, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Wound Poison
			{ spellID = 13218, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
		},
		{
			Name = "F/DEBUFF_BAR",
			Direction = "UP",
			IconSide = "LEFT",
			Interval = 4,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", TukuiFocus, "TOPLEFT", 0, 100 },

			-- Blind
			{ spellID = 2094, size = asize, barWidth = 200, unitId = "focus", caster = "all", filter = "DEBUFF" },
			-- Sap
			{ spellID = 6770, size = asize, barWidth = 200, unitId = "focus", caster = "all", filter = "DEBUFF" },
		},
	},
	["DEATHKNIGHT"] = {
		{
			Name = "P_BUFF_ICON",
			Direction = "LEFT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", TukuiPlayer, "TOPRIGHT", 0, 240 },

			-- Bone Shield
			{ spellID = 49222, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Icebound Fortitude
			{ spellID = 48792, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Anti-Magic Shield
			{ spellID = 48707, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Vampiric Blood
			{ spellID = 55233, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Horn of Winter
			--{ spellID = 57330, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
		},
		{
			Name = "P_PROC_ICON",
			Direction = "LEFT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", TukuiPlayer, "TOPRIGHT", 0, 240 },

			-- Unholy Force/Unheilige Kraft
			{ spellID = 67383, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Desolation/Verwüstung
			--{ spellID = 66817, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Unholy Strength/Unheilige Stärke
			{ spellID = 53365, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Unholy Might/Unheilige Macht
			{ spellID = 67117, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Dancing Rune Weapon/Tanzende Runenwaffe
			{ spellID = 49028, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Killing machine
			{ spellID = 51124, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Freezing fog
			{ spellID = 59052, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
			-- Dark Simulacrum
			{ spellID = 77606, size = asize*1.5, unitId = "player", caster = "player", filter = "BUFF" },
		},
		{
			Name = "T_DEBUFF_ICON",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", TukuiTarget, "TOPLEFT", 0, 240 },

			-- Blood Plague/Blutseuche
			{ spellID = 59879, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Frost Fever/Frostfieber
			{ spellID = 59921, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Unholy Blight/Unheilige Verseuchung
			{ spellID = 49194, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
			-- Summon Gargoyle/Gargoyle beschwören
			{ spellID = 49206, size = asize*1.5, unitId = "target", caster = "player", filter = "DEBUFF" },
		},
	},
	["ALL"] = {
		{
			Name = "SPECIAL_P_BUFF_ICON",
			Direction = "LEFT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", TukuiPlayer, "TOPRIGHT", 0, 130 },

			-- Eyes of Twilight/Augen des Zwielichts
			{ spellID = 75495, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Piercing Twilight/Durchbohrendes Zwielicht
			{ spellID = 75456, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Twilight Flames/Zwielichtflammen
			{ spellID = 75473, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Scaly Nimbleness/Schuppige Gewandtheit
			{ spellID = 75480, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Surge of Power/Kraftsog
			{ spellID = 71644, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Thick Skin/Dicke Haut
			{ spellID = 71639, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Siphoned Power/Entzogene Kraft
			{ spellID = 71636, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Aegis of Dalaran/Aegis von Dalaran
			{ spellID = 71638, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Speed of the Vrykul/Geschwindigkeit der Vrykul
			{ spellID = 71560, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Power of the Taunka/Macht der Taunka
			{ spellID = 71558, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Agility of the Vrykul/Beweglichkeit der Vrykul
			{ spellID = 71556, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Mote of Anger/Partikel des Zorns
			{ spellID = 71432, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Icy Rage/Eisige Wut
			{ spellID = 71541, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Cultivated Power/Kultivierte Macht
			{ spellID = 71572, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Invigorated/Gestärkt
			{ spellID = 71577, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Revitalized/Revitalisiert
			{ spellID = 71584, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Rage of the Fallen/Zorn der Gefallenen
			{ spellID = 71396, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Hardened Skin/Gehärtete Haut
			{ spellID = 71586, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Elusive Power/Flüchtige Macht
			{ spellID = 71579, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Shard of Flame/Flammensplitter
			{ spellID = 67759, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Necrotic Touch
			{ spellID = 71875, size = asize, unitId = "player", caster = "player", filter = "BUFF" },

			-- Frostforged Champion/Frostgeschmiedeter Champion
			{ spellID = 72412, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Chilling Knowledge/Kühlendes Wissen
			{ spellID = 72418, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Frostforged Sage/Frostgeschmiedeter Weiser
			{ spellID = 72416, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Frostforged Defender/Frostgeschmiedeter Verteidiger
			{ spellID = 72414, size = asize, unitId = "player", caster = "player", filter = "BUFF" },

			-- Hyperspeed Accelerators/Hypergeschwindigkeitsbeschleuniger
			{ spellID = 54999, size = asize, unitId = "player", caster = "player", filter = "BUFF" },

			-- Speed/Geschwindigkeit
			{ spellID = 53908, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Wild Magic/Wilde Magie
			{ spellID = 53909, size = asize, unitId = "player", caster = "player", filter = "BUFF" },

			--Tricks of the Trade/Schurkenhandel
			{ spellID = 57934, size = asize, unitId = "player", caster = "all", filter = "BUFF" },
			--Power Infusion/Seele der Macht
			{ spellID = 10060, size = asize, unitId = "player", caster = "all", filter = "BUFF" },
			-- Bloodlust/Kampfrausch
			{ spellID = 2825, size = asize, unitId = "player", caster = "all", filter = "BUFF" },
			-- Heroism/Heldentum
			{ spellID = 32182, size = asize, unitId = "player", caster = "all", filter = "BUFF" },
			
			--[[	Cataclysm Buffs	   ]]--
			-- Race Against Death
			{ spellID = 91821, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Dire Magic
			{ spellID = 91007, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Revelation
			{ spellID = 91024, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Heedless Carnage
			{ spellID = 92108, size = asize, unitId = "player", caster = "player", filter = "BUFF" },			
			-- Agony and Torment
			{ spellID = 95762, size = asize, unitId = "player", caster = "player", filter = "BUFF" },		
			-- Inner Eye
			{ spellID = 91320, size = asize, unitId = "player", caster = "player", filter = "BUFF" },		
			-- Inner Eye (Heroic)
			{ spellID = 92329, size = asize, unitId = "player", caster = "player", filter = "BUFF" },		
			-- Heart's Revelation
			{ spellID = 91027, size = asize, unitId = "player", caster = "player", filter = "BUFF" },		
			-- Heart's Revelation (Heroic)
			{ spellID = 92325, size = asize, unitId = "player", caster = "player", filter = "BUFF" },		
			-- River of Death
			{ spellID = 92104, size = asize, unitId = "player", caster = "player", filter = "BUFF" },		
			-- Slayer
			{ spellID = 91810, size = asize, unitId = "player", caster = "player", filter = "BUFF" },		
			-- Raw Fury
			{ spellID = 91832, size = asize, unitId = "player", caster = "player", filter = "BUFF" },

			-- Blind Spot (Jar of Ancient Remedies)
			{ spellID = 91322, size = asize, unitId = "player", caster = "player", filter = "DEBUFF" },
			
			-- Weapon Enchants
			-- Hurricane
			{ spellID = 74221, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Heartsong
			{ spellID = 74224, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Power Torrent
			{ spellID = 74241, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Landslide
			{ spellID = 74245, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
			-- Memory of Invicibility
			{ spellID = 92213, size = asize, unitId = "player", caster = "player", filter = "BUFF" },
		},
		{
			Name = "PVE/PVP_P_DEBUFF_ICON",
			Direction = "LEFT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", TukuiPlayer, "TOPRIGHT", 0, 170 },

			-- Death Knight
			-- Gnaw (Ghoul)
			{ spellID = 47481, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Strangulate
			{ spellID = 47476, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Chains of Ice
			{ spellID = 45524, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Desecration (no duration, lasts as long as you stand in it)
			{ spellID = 55741, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Glyph of Heart Strike
			{ spellID = 58617, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Icy Clutch (Chilblains)
			--{ spellID = 50436, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Hungering Cold
			{ spellID = 51209, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },

			-- Druid
			-- Cyclone
			{ spellID = 33786, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Hibernate
			{ spellID = 2637, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Bash
			{ spellID = 5211, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Maim
			{ spellID = 22570, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Pounce
			{ spellID = 9005, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Entangling Roots
			{ spellID = 339, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Feral Charge Effect
			{ spellID = 45334, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Infected Wounds
			{ spellID = 58179, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },

			-- Hunter
			-- Freezing Trap Effect
			{ spellID = 3355, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Freezing Arrow Effect
			--{ spellID = 60210, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Scare Beast
			{ spellID = 1513, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Scatter Shot
			{ spellID = 19503, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Chimera Shot - Scorpid
			--{ spellID = 53359, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Snatch (Bird of Prey)
			{ spellID = 50541, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Silencing Shot
			{ spellID = 34490, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Intimidation
			{ spellID = 24394, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Sonic Blast (Bat)
			{ spellID = 50519, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Ravage (Ravager)
			{ spellID = 50518, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Concussive Barrage
			{ spellID = 35101, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Concussive Shot
			{ spellID = 5116, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Frost Trap Aura
			{ spellID = 13810, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Glyph of Freezing Trap
			{ spellID = 61394, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Wing Clip
			{ spellID = 2974, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Counterattack
			{ spellID = 19306, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Entrapment
			{ spellID = 19185, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Pin (Crab)
			{ spellID = 50245, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Venom Web Spray (Silithid)
			{ spellID = 54706, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Web (Spider)
			{ spellID = 4167, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Froststorm Breath (Chimera)
			{ spellID = 51209, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Tendon Rip (Hyena)
			{ spellID = 51209, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },

			-- Mage
			-- Dragon's Breath
			{ spellID = 31661, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Polymorph
			{ spellID = 118, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Silenced - Improved Counterspell
			{ spellID = 18469, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Deep Freeze
			{ spellID = 44572, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Freeze (Water Elemental)
			{ spellID = 33395, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Frost Nova
			{ spellID = 122, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Shattered Barrier
			{ spellID = 55080, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Chilled
			{ spellID = 6136, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Cone of Cold
			{ spellID = 120, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Slow
			{ spellID = 31589, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },

			-- Paladin
			-- Repentance
			{ spellID = 20066, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Turn Evil
			{ spellID = 10326, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Shield of the Templar
			{ spellID = 63529, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Hammer of Justice
			{ spellID = 853, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Holy Wrath
			{ spellID = 2812, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Stun (Seal of Justice proc)
			{ spellID = 20170, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Avenger's Shield
			{ spellID = 31935, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },

			-- Priest
			-- Psychic Horror
			{ spellID = 64058, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Mind Control
			{ spellID = 605, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Psychic Horror
			{ spellID = 64044, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Psychic Scream
			{ spellID = 8122, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Silence
			{ spellID = 15487, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Mind Flay
			{ spellID = 15407, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },

			-- Rogue
			-- Dismantle
			{ spellID = 51722, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Blind
			{ spellID = 2094, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Gouge
			{ spellID = 1776, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Sap
			{ spellID = 6770, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Garrote - Silence
			{ spellID = 1330, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Silenced - Improved Kick
			{ spellID = 18425, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Cheap Shot
			{ spellID = 1833, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Kidney Shot
			{ spellID = 408, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Blade Twisting
			{ spellID = 31125, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Crippling Poison
			{ spellID = 3409, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Deadly Throw
			{ spellID = 26679, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },

			-- Shaman
			-- Hex
			{ spellID = 51514, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Earthgrab
			{ spellID = 64695, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Freeze
			{ spellID = 63685, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Stoneclaw Stun
			{ spellID = 39796, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Earthbind
			{ spellID = 3600, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Frost Shock
			{ spellID = 8056, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },

			-- Warlock
			-- Banish
			{ spellID = 710, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Death Coil
			{ spellID = 6789, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Fear
			{ spellID = 5782, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Howl of Terror
			{ spellID = 5484, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Seduction (Succubus)
			{ spellID = 6358, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Spell Lock (Felhunter)
			{ spellID = 24259, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Shadowfury
			{ spellID = 30283, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Intercept (Felguard)
			{ spellID = 30153, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Aftermath
			{ spellID = 18118, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Curse of Exhaustion
			{ spellID = 18223, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },

			-- Warrior
			-- Intimidating Shout
			{ spellID = 20511, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Disarm
			{ spellID = 676, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Silenced (Gag Order)
			{ spellID = 18498, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Charge Stun
			{ spellID = 7922, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Concussion Blow
			{ spellID = 12809, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Intercept
			{ spellID = 20253, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Revenge Stun
			--{ spellID = 12798, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Shockwave
			{ spellID = 46968, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Glyph of Hamstring
			{ spellID = 58373, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Improved Hamstring
			{ spellID = 23694, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Hamstring
			{ spellID = 1715, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Piercing Howl
			{ spellID = 12323, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },

			-- Racials
			-- War Stomp
			{ spellID = 20549, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },

			-- Baradin Hold(PvP)
			-- Meteor Slash/Meteorschlag (Argaloth)
			{ spellID = 88942, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },

			-- Bastion of Twilight
			-- Blackout/Blackout (Valiona & Theralion)
			{ spellID = 92879, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Engulfing Magic/Einhüllende Magie (Valiona & Theralion)
			{ spellID = 86631, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Waterlogged/Wasserdurchtränkt (Twilight Ascendant Council)
			{ spellID = 82762, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Burning Blood/Brennendes Blut (Twilight Ascendant Council)
			{ spellID = 82662, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Heart of Ice/Herz aus Eis (Twilight Ascendant Council)
			{ spellID = 82667, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Frozen/Gefroren (Twilight Ascendant Council)
			{ spellID = 92503, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Swirling Winds/Wirbelnde Winde (Twilight Ascendant Council)
			{ spellID = 83500, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Magnetic Pull/Magnetische Anziehung (Twilight Ascendant Council)
			{ spellID = 83587, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Corruption: Accelerated/Verderbnis: Beschleunigung (Cho'gall)
			{ spellID = 81836, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Corruption: Malformation/Verderbnis: Missbildung (Cho'gall)
			{ spellID = 82125, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Corruption: Absolute/Verderbnis: Vollendet (Cho'gall)
			{ spellID = 82170, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Corruption: Sickness/Verderbnis: Krankheit (Cho'gall)
			{ spellID = 93200, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },

			-- Blackwing Descent
			-- Constricting Chains/Fesselnde Ketten (Magmaw)
			{ spellID = 91911, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Parasitic Infection/Parasitäre Infektion (Magmaw)
			{ spellID = 94679, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Infectious Vomit/Infektiöses Erbrochenes (Magmaw)
			{ spellID = 91923, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Lightning Conductor (Omnitron Defense System)
			{ spellID = 91433, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Flash Freeze/Blitzeis (Maloriak)
			{ spellID = 77699, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Consuming Flames/Verzehrende Flammen (Maloriak)
			{ spellID = 77786, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Finkle's Mixture/Finkels Mixtur (Chimaeron)
			{ spellID = 82705, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Shadow Conductor/Schattenleiter (Nefarian)
			{ spellID = 92053, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },

			-- Throne of Four Winds
			-- Wind Chill/Windkühle (Conclave of Wind)
			{ spellID = 93123, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Slicing Gale/Schneidender Orkan (Conclave of Wind)
			{ spellID = 93058, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Static Shock/Statischer Schock (Al'Akir)
			{ spellID = 87873, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
			-- Acid Rain/Säureregen (Al'Akir)
			{ spellID = 93279, size = asize*2, unitId = "player", caster = "all", filter = "DEBUFF" },
		},
		{
			Name = "PVP_T_BUFF_ICON",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", TukuiTarget, "TOPLEFT", 0, 170 },

			-- Aspect of the Pack
			{ spellID = 13159, size = asize*2, unitId = "player", caster = "player", filter = "BUFF" },
			-- Innervate
			{ spellID = 29166, size = asize*2, unitId = "target", caster = "all", filter = "BUFF"},
			-- Spell Reflection
			{ spellID = 23920, size = asize*2, unitId = "target", caster = "all", filter = "BUFF" },
			-- Aura Mastery
			{ spellID = 31821, size = asize*2, unitId = "target", caster = "all", filter = "BUFF" },
			-- Ice Block
			{ spellID = 45438, size = asize*2, unitId = "target", caster = "all", filter = "BUFF" },
			-- Cloak of Shadows
			{ spellID = 31224, size = asize*2, unitId = "target", caster = "all", filter = "BUFF" },
			-- Divine Shield
			{ spellID = 642, size = asize*2, unitId = "target", caster = "all", filter = "BUFF" },
			-- Deterrence
			{ spellID = 19263, size = asize*2, unitId = "target", caster = "all", filter = "BUFF" },
			-- Anti-Magic Shell
			{ spellID = 48707, size = asize*2, unitId = "target", caster = "all", filter = "BUFF" },
			-- Lichborne
			{ spellID = 49039, size = asize*2, unitId = "target", caster = "all", filter = "BUFF" },
			-- Hand of Freedom
			{ spellID = 1044, size = asize*2, unitId = "target", caster = "all", filter = "BUFF" },
			-- Hand of Sacrifice
			{ spellID = 6940, size = asize*2, unitId = "target", caster = "all", filter = "BUFF" },
			-- Grounding Totem Effect
			{ spellID = 8178, size = asize*2, unitId = "target", caster = "all", filter = "BUFF" },
			-- Dark Simulacrum
			{ spellID = 77606, size = asize*2, unitId = "target", caster = "all", filter = "BUFF" },
		},
	},
}