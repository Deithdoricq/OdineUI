local T, C, L, DB = unpack(select(2, ...)) -- Import Functions/Constants, Config, Locales

T.ErrorList = {
	[INVENTORY_FULL] = true,
	[NOT_ENOUGH_MANA] = true,
	[OUT_OF_MANA] = true,
	["Players cannot be kicked while in combat, or shortly after combat."] = true,
}