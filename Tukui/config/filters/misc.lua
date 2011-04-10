local T, C, L, DB = unpack(select(2, ...)) -- Import Functions/Constants, Config, Locales

T.ErrorList = {
	[INVENTORY_FULL] = true,
	[NOT_ENOUGH_MANA] = true,
	[OUT_OF_ENERGY] = true,
	[OUT_OF_FOCUS] = true,
	[OUT_OF_MANA] = true,
	[OUT_OF_POWER_DISPLAY] = true,
	[OUT_OF_RAGE] = true,
	[SPELL_FAILED_OUT_OF_RANGE] = true,
	["Players cannot be kicked while in combat, or shortly after combat."] = true,
}
