----------------------------------------------------------------------------
-- This Module loads new user settings if TukUI_ConfigUI is loaded
----------------------------------------------------------------------------
local T, C, L, DB = unpack(select(2, ...)) -- Import Functions/Constants, Config, Locales

local myPlayerRealm = GetCVar("realmName")
local myPlayerName  = UnitName("player")


for group,options in pairs(DB) do
	if not C[group] then C[group] = {} end
	for option, value in pairs(options) do
		C[group][option] = value
	end
end


if IsAddOnLoaded("Tukui_Config") and OUIDB then
	local profile = OUIDB["profileKeys"][myPlayerName.." - "..myPlayerRealm]
	local path = OUIDB["profiles"][profile]
	if path then
		for group,options in pairs(path) do
			if C[group] then
				for option, value in pairs(options) do
					if C[group][option] ~= nil then
						C[group][option] = value
					end
				end
			end
		end
	end
	
	--Raid Debuffs
	do
		local list = T.RaidDebuffs
		T.debuffids = {}
		for spell, value in pairs(list) do
			if value == true then
				tinsert(T.debuffids, spell)
			end
		end
		
		if path and path["spellfilter"] and path["spellfilter"]["RaidDebuffs"] then
			for spell, value in pairs(path["spellfilter"]["RaidDebuffs"]) do
				if value == true then
					tinsert(T.debuffids, spell)
				end			
			end
		end
	end
	
	--Error Messages
	do
		local list = T.ErrorList
		if path and path["spellfilter"] and path["spellfilter"]["ErrorList"] then
			for name, value in pairs(path["spellfilter"]["ErrorList"]) do
				T.ErrorList[name] = value			
			end
		end	
	end
	
	--DebuffWhiteList
	do
		local list = T.DebuffWhiteList
		if path and path["spellfilter"] and path["spellfilter"]["DebuffWhiteList"] then
			for spell, value in pairs(path["spellfilter"]["DebuffWhiteList"]) do
				T.DebuffWhiteList[spell] = value			
			end
		end			
	end
	
	--Target PVP Only
	do
		local list = T.TargetPVPOnly
		if path and path["spellfilter"] and path["spellfilter"]["TargetPVPOnly"] then
			for spell, value in pairs(path["spellfilter"]["TargetPVPOnly"]) do
				T.TargetPVPOnly[spell] = value			
			end
		end		
	end
	
	--ArenaBuffs
	do
		local list = T.ArenaBuffWhiteList
		if path and path["spellfilter"] and path["spellfilter"]["ArenaBuffWhiteList"] then
			for spell, value in pairs(path["spellfilter"]["ArenaBuffWhiteList"]) do
				T.ArenaBuffWhiteList[spell] = value			
			end
		end			
	end
	
	--Nameplate Filter
	do
		local list = T.PlateBlacklist
		if path and path["spellfilter"] and path["spellfilter"]["PlateBlacklist"] then
			for name, value in pairs(path["spellfilter"]["PlateBlacklist"]) do
				T.PlateBlacklist[name] = value			
			end
		end	
	end	
end