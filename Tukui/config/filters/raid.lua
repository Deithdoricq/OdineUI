local T, C, L, DB = unpack(select(2, ...)) -- Import Functions/Constants, Config, Locales

local function SpellName(id)
	local name, _, _, _, _, _, _, _, _ = GetSpellInfo(id) 	
	return name
end

T.buffids = {
	PRIEST = {
		{6788, "TOPLEFT", {1, 0, 0}, true}, -- Weakened Soul
		{33076, "TOPRIGHT", {0.2, 0.7, 0.2}}, -- Prayer of Mending
		{139, "BOTTOMLEFT", {0.4, 0.7, 0.2}}, -- Renew
		{17, "BOTTOMRIGHT", {0.81, 0.85, 0.1}, true}, -- Power Word: Shield
	},
	DRUID = {
		{774, "TOPLEFT", {0.8, 0.4, 0.8}}, -- Rejuvenation
		{8936, "TOPRIGHT", {0.2, 0.8, 0.2}}, -- Regrowth
		{33763, "BOTTOMLEFT", {0.4, 0.8, 0.2}}, -- Lifebloom
		{48438, "BOTTOMRIGHT", {0.8, 0.4, 0}}, -- Wild Growth
	},
	PALADIN = {
		{53563, "TOPLEFT", {0.7, 0.3, 0.7}}, -- Beacon of Light
	},
	SHAMAN = {
		{61295, "TOPLEFT", {0.7, 0.3, 0.7}}, -- Riptide 
		{51945, "TOPRIGHT", {0.2, 0.7, 0.2}}, -- Earthliving
		{16177, "BOTTOMLEFT", {0.4, 0.7, 0.2}}, -- Ancestral Fortitude
		{974, "BOTTOMRIGHT", {0.7, 0.4, 0}, true}, -- Earth Shield
	},
	ALL = {
		{14253, "RIGHT", {0, 1, 0}}, -- Abolish Poison
		{23333, "LEFT", {1, 0, 0}}, -- Warsong flag xD
	},
}

--RAID DEBUFFS
T.debuffids = {
	
	-- Other debuff
	[SpellName(67479)] = true, -- Impale

	--Blackwing Descent
	--Magmaw
	[SpellName(91911)] = true, -- Constricting Chains
	[SpellName(94679)] = true, -- Parasitic Infection
	[SpellName(94617)] = true, -- Mangle
	[SpellName(78199)] = true, -- Sweltering Armor

	--Omintron Defense System
	[SpellName(91433)] = true, --Lightning Conductor
	[SpellName(91521)] = true, --Incineration Security Measure
	[SpellName(80094)] = true, --Fixate 

	--Maloriak
	[SpellName(77699)] = true, -- Flash Freeze
	[SpellName(77760)] = true, -- Biting Chill

	--Atramedes
	[SpellName(92423)] = true, -- Searing Flame
	[SpellName(92485)] = true, -- Roaring Flame
	[SpellName(92407)] = true, -- Sonic Breath

	--Chimaeron
	[SpellName(82881)] = true, -- Break
	[SpellName(89084)] = true, -- Low Health

	--Nefarian

	--Sinestra
	[SpellName(92956)] = true, --Wrack

	--The Bastion of Twilight
	--Valiona & Theralion
	[SpellName(92878)] = true, -- Blackout
	[SpellName(86840)] = true, -- Devouring Flames
	[SpellName(95639)] = true, -- Engulfing Magic
	[SpellName(93051)] = true, -- Twilight Shift
	[SpellName(92886)] = true, -- Twilight Zone
	[SpellName(88518)] = true, -- Twilight Meteorite

	--Halfus Wyrmbreaker
	[SpellName(39171)] = true, -- Malevolent Strikes

	--Twilight Ascendant Council
	[SpellName(92511)] = true, -- Hydro Lance
	[SpellName(82762)] = true, -- Waterlogged
	[SpellName(92505)] = true, -- Frozen
	[SpellName(92518)] = true, -- Flame Torrent
	[SpellName(83099)] = true, -- Lightning Rod
	[SpellName(92075)] = true, -- Gravity Core
	[SpellName(92488)] = true, -- Gravity Crush

	--Cho'gall
	[SpellName(86028)] = true, -- Cho's Blast
	[SpellName(86029)] = true, -- Gall's Blast

	--Throne of the Four Winds
	--Conclave of Wind
		--Nezir <Lord of the North Wind>
		[SpellName(93131)] = true, --Ice Patch
		--Anshal <Lord of the West Wind>
		[SpellName(86206)] = true, --Soothing Breeze
		[SpellName(93122)] = true, --Toxic Spores
		--Rohash <Lord of the East Wind>
		[SpellName(93058)] = true, --Slicing Gale
		
	--Al'Akir
	[SpellName(93260)] = true, -- Ice Storm
	[SpellName(93295)] = true, -- Lightning Rod
}
