local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
if C["tooltip"].enable ~= true then return end

GameTooltip:HookScript("OnTooltipCleared", function(self) self.TukuiItemTooltip=nil end)
GameTooltip:HookScript("OnTooltipSetItem", function(self)
	if (IsShiftKeyDown() or IsAltKeyDown()) and (TukuiItemTooltip and not self.TukuiItemTooltip and (TukuiItemTooltip.id or TukuiItemTooltip.count)) then
		local item, link = self:GetItem()
		local num = GetItemCount(link)
		local left = ""
		local right = ""
		
		if TukuiItemTooltip.id and link ~= nil then
			left = "|cFFCA3C3CID|r "..link:match(":(%w+)")
		end
		
		if TukuiItemTooltip.count and num > 1 then
			right = "|cFFCA3C3C"..L.tooltip_count.."|r "..num
		end

		self:AddLine(" ")
		self:AddDoubleLine(left, right)
		self.TukuiItemTooltip = 1
	end
end)

GameTooltip:HookScript("OnTooltipSetSpell", function(self)
	if (IsShiftKeyDown() or IsAltKeyDown()) and TukuiItemTooltip and not self.TukuiItemTooltip and (TukuiItemTooltip.spell) then
		local id = select(3, self:GetSpell())
				
		if id ~= nil then
			self:AddLine' '
			self:AddLine("|cFFCA3C3CSpell ID|r "..id)
		end
							
		self.TukuiItemTooltip = 1
	end
end)

hooksecurefunc(GameTooltip, "SetUnitBuff", function(self, ...)
	if (IsShiftKeyDown() or IsAltKeyDown()) and TukuiItemTooltip and not self.TukuiItemTooltip and (TukuiItemTooltip.buff) then
		local name = select(1, UnitBuff(...))
		local id = select(11, UnitBuff(...))
		
		if name ~= nil and id ~= nil then
			self:AddLine' ' 
			self:AddLine("|cFFCA3C3CBuff ID|r " .. id)
			self:Show()
		end
		
		print("Buff: " .. name, id)
	end
end)

hooksecurefunc(GameTooltip, "SetUnitDebuff", function(self, ...)
	if (IsShiftKeyDown() or IsAltKeyDown()) and TukuiItemTooltip and not self.TukuiItemTooltip and (TukuiItemTooltip.debuff) then
		local name = select(1, UnitDebuff(...))
		local id = select(11, UnitDebuff(...))
		
		if name ~= nil and id ~= nil then
			self:AddLine' ' 
			self:AddLine("|cFFCA3C3CDebuff ID|r " .. id)
			self:Show()
		end
		
		print("Debuff: " .. name, id)
	end
end)

hooksecurefunc(GameTooltip, "SetUnitAura", function(self, ...)
	if (IsShiftKeyDown() or IsAltKeyDown()) and TukuiItemTooltip and not self.TukuiItemTooltip and (TukuiItemTooltip.aura) then
		local name = select(1, UnitAura(...))
		local id = select(11, UnitAura(...))
		
		if name ~= nil and id ~= nil then
			self:AddLine' ' 
			self:AddLine("|cFFCA3C3CAura ID|r " .. id)
			self:Show()
		end
		
		print("Aura: " .. name, id)
	end
end)

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(_, _, name)
	if name ~= "Tukui" then return end
	f:UnregisterEvent("ADDON_LOADED")
	f:SetScript("OnEvent", nil)
	TukuiItemTooltip = TukuiItemTooltip or {count=true,id=true,spell=true,buff=true,debuff=true,aura=true}
end)