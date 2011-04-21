-- Editless skin by Tacsko
local T, C, L, DB = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

if not IsAddOnLoaded("CoolLine") or C["addonskins"].coolline == false then return end

local cl = CoolLine
local db = CoolLineDB

-- Checking for variables...
if db then
	-- Positions below info line, comment both lines below to allow for manual placement
	db.x = 0
	db.y = 490

	db.h = T.buttonsize - 6
	db.w = T.InfoLeftRightWidth - 6
	db.font = "Tukui UF"
	db.fontsize = 13
	db.bgcolor = { r = 0, g = 0, b = 0, a = 0, }
	db.border = "None"
	db.inactivealpha = 0
	db.activealpha = 1.0
end
			
local setup = function()
	local background = CreateFrame("Frame", nil, cl)
	background:Point("TOPLEFT", 2, 2)
	background:Point("BOTTOMRIGHT", 2, -2)
	background:SetFrameLevel(cl:GetFrameLevel() - 1)
	background:SetTemplate("Default", true)
	background:CreateShadow("Default")
	cl.background = background
end

setup()
