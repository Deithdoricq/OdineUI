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
end