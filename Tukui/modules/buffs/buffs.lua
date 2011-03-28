local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
if not C["auras"].player then return end

local font, fonts, fontf = C["media"].uffont, 14, "OUTLINE"

local FormatTime = function(s)
	local day, hour, minute = 86400, 3600, 60
	if s >= day then
		return format("|cffeeeeee%d " .. T.cStart .. "d|r", ceil(s / day))
	elseif s >= hour then
		return format("|cffeeeeee%d " .. T.cStart .. "h|r", ceil(s / hour))
	elseif s >= minute then
		return format("|cffeeeeee%d " .. T.cStart .. "m|r", ceil(s / minute))
	elseif s >= minute / 12 then
		return floor(s)
	end
	return format("%.1f", s)
end

local function UpdateTime(self, elapsed)
	if(self.expiration) then	
		self.expiration = math.max(self.expiration - elapsed, 0)
		if(self.expiration <= 0) then
			self.time:SetText("")
		else
			local time = FormatTime(self.expiration)
			if self.expiration <= 86400.5 and self.expiration > 3600.5 then
				self.time:SetText(time)
				self.time:SetTextColor(1, 1, 1)
			elseif self.expiration <= 3600.5 and self.expiration > 60.5 then
				self.time:SetText(time)
				self.time:SetTextColor(1, 1, 1)
			elseif self.expiration <= 60.5 and self.expiration > 10.5 then
				self.time:SetText(time)
				self.time:SetTextColor(.83, .63, 0)
			elseif self.expiration <= 10.5 then
				self.time:SetText(time)
				self.time:SetTextColor(.69, .31, .31)
			end
		end
	end
end

local function UpdateWeapons(button, slot, active, expiration)
	if not button.texture then
		button.texture = button:CreateTexture(nil, "BORDER")
		button.texture:SetAllPoints()
		
		button.time = button:CreateFontString(nil, "ARTWORK")
		button.time:SetPoint("BOTTOM", 0, -17)
		button.time:SetFont(font, fonts, fontf)

		button.bg = CreateFrame("Frame", nil, button)
		button.bg:CreatePanel("Default", 30, 30, "CENTER", button, "CENTER", 0, 0)
		button.bg:SetFrameLevel(button:GetFrameLevel() - 1)
		button.bg:SetFrameStrata(button:GetFrameStrata())
		button.bg:SetAlpha(0)
	end
	
	if active then
		button.id = GetInventorySlotInfo(slot)
		button.icon = GetInventoryItemTexture("player", button.id)
		button.texture:SetTexture(button.icon)
		button.texture:SetTexCoord(.09, .91, .09, .91)		
		button.expiration = (expiration/1000)
		button.bg:SetAlpha(1)
		button:SetScript("OnUpdate", UpdateTime)		
	elseif not active then
		button.texture:SetTexture(nil)
		button.time:SetText("")
		button.bg:SetAlpha(0)
		button:SetScript("OnUpdate", nil)
	end
end

local function UpdateAuras(header, button, weapon)
	if(not button.texture) then
		button.texture = button:CreateTexture(nil, "BORDER")
		button.texture:SetAllPoints()

		button.count = button:CreateFontString(nil, "ARTWORK")
		button.count:SetPoint("BOTTOMRIGHT", -1, 1)
		button.count:SetFont(C.media.font, 12, "OUTLINE")

		button.time = button:CreateFontString(nil, "ARTWORK")
		button.time:SetPoint("BOTTOM", 0, -17)
		button.time:SetFont(C.media.font, 12, "OUTLINE")

		button:SetScript("OnUpdate", UpdateTime)
		
		button.bg = CreateFrame("Frame", nil, button)
		button.bg:CreatePanel("Default", 30, 30, "CENTER", button, "CENTER", 0, 0)
		button.bg:SetFrameLevel(button:GetFrameLevel() - 1)
		button.bg:SetFrameStrata(button:GetFrameStrata())
	end
	
	local name, _, texture, count, dtype, duration, expiration = UnitAura(header:GetAttribute("unit"), button:GetID(), header:GetAttribute("filter"))
	
	if(name) then
		button.texture:SetTexture(texture)
		button.texture:SetTexCoord(.09, .91, .09, .91)		
		button.count:SetText(count > 1 and count or "")
		button.expiration = expiration - GetTime()
		
		if(header:GetAttribute("filter") == "HARMFUL") then
			local color = DebuffTypeColor[dtype] or DebuffTypeColor.none
			button.bg:SetBackdropBorderColor(color.r * 3/5, color.g * 3/5, color.b * 3/5)
		end
	end
end

local function ScanAuras(self, event, unit)
	if(unit) then
		if(unit ~= PlayerFrame.unit) then return end
		if(unit ~= self:GetAttribute("unit")) then
			self:SetAttribute("unit", unit)
		end
	end
	
	for index = 1, 32 do		
		local child = self:GetAttribute("child" .. index)
		if(child) then
			UpdateAuras(self, child)
		end
	end
end

local TimeSinceLastUpdate = 1
local function CheckWeapons(self, elapsed)
	TimeSinceLastUpdate = TimeSinceLastUpdate + elapsed
	
	if (TimeSinceLastUpdate >= 1) then
		local e1, e1time, _, e2, e2time, _, e3, e3time, _  = GetWeaponEnchantInfo()
		
		local w1 = self:GetAttribute("tempEnchant1")
		local w2 = self:GetAttribute("tempEnchant2")
		local w3 = self:GetAttribute("tempEnchant3")

		if w1 then UpdateWeapons(w1, "MainHandSlot", e1, e1time) end
		if w2 then UpdateWeapons(w2, "SecondaryHandSlot", e2, e2time) end
		if w3 then UpdateWeapons(w3, "RangedSlot", e3, e3time) end

		TimeSinceLastUpdate = 0
	end
end

local function CreateAuraHeader(filter, ...)
	local name	
	if filter == "HELPFUL" then name = "TukuiPlayerBuffs" else name = "TukuiPlayerDebuffs" end

	local header = CreateFrame("Frame", name, UIParent, "SecureAuraHeaderTemplate")
	header:SetPoint(...)
	header:SetClampedToScreen(true)
	header:SetMovable(true)
	header:HookScript("OnEvent", ScanAuras)
	
	header:SetAttribute("unit", "player")
	header:SetAttribute("sortMethod", "TIME")
	header:SetAttribute("template", "TukuiAuraTemplate")
	header:SetAttribute("filter", filter)
	header:SetAttribute("point", "TOPRIGHT")
	header:SetAttribute("minWidth", 300)
	header:SetAttribute("minHeight", 94)
	header:SetAttribute("xOffset", -34)
	header:SetAttribute("wrapYOffset", -64)
	header:SetAttribute("wrapAfter", 14)
	header:SetAttribute("maxWraps", 2)
	
	-- look for weapons buffs
	if filter == "HELPFUL" then
		header:SetAttribute("includeWeapons", 1)
		header:SetAttribute("weaponTemplate", "TukuiAuraTemplate")
		header:HookScript("OnUpdate", CheckWeapons)
	end
	
	header:SetTemplate("Transparent")
	header:SetBackdropColor(0,0,0,0)
	header:SetBackdropBorderColor(0,0,0,0)
	header:Show()
	
	header.text = T.SetFontString(header, font, fonts, fontf)
	header.text:SetPoint("CENTER")
	if filter == "HELPFUL" then
		header.text:SetText(L.move_buffs)
	else
		header.text:SetText(L.move_debuffs)
	end	
	header.text:Hide()

	return header
end

ScanAuras(CreateAuraHeader("HELPFUL", "TOPRIGHT", -165, -10))
ScanAuras(CreateAuraHeader("HARMFUL", "TOPRIGHT", -165, -130))

-- create our aura
local start = CreateFrame("Frame")
start:RegisterEvent("VARIABLES_LOADED")
start:SetScript("OnEvent", function(self)
	local frames = {TukuiPlayerBuffs,TukuiPlayerDebuffs}
	for i = 1, getn(frames) do
		local frame = frames[i]
		local position = frame:GetPoint()
		if position:match("TOPLEFT") or position:match("BOTTOMLEFT") or position:match("BOTTOMRIGHT") then
			frame:SetAttribute("point", position)
		end
		if position:match("LEFT") then
			frame:SetAttribute("xOffset", 34)
		end
		if position:match("BOTTOM") then
			frame:SetAttribute("wrapYOffset", 64)
		end
		if T.lowversion then
			frame:SetAttribute("wrapAfter", 14)
		end
	end
end)