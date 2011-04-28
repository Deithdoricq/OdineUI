local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
if not C["unitframes"].enable == true then return end

------------------------------------------------------------------------
--	unitframes Functions
------------------------------------------------------------------------

local ADDON_NAME, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, "Tukui was unable to locate oUF install.")

T.updateAllElements = function(frame)
	for _, v in ipairs(frame.__elements) do
		v(frame, "UpdateElement", frame.unit)
	end
end

local SetUpAnimGroup = function(self)
	self.anim = self:CreateAnimationGroup("Flash")
	self.anim.fadein = self.anim:CreateAnimation("ALPHA", "FadeIn")
	self.anim.fadein:SetChange(1)
	self.anim.fadein:SetOrder(2)

	self.anim.fadeout = self.anim:CreateAnimation("ALPHA", "FadeOut")
	self.anim.fadeout:SetChange(-1)
	self.anim.fadeout:SetOrder(1)
end

local Flash = function(self, duration)
	if not self.anim then
		SetUpAnimGroup(self)
	end

	self.anim.fadein:SetDuration(duration)
	self.anim.fadeout:SetDuration(duration)
	self.anim:Play()
end

local StopFlash = function(self)
	if self.anim then
		self.anim:Finish()
	end
end

T.SpawnMenu = function(self)
	local unit = self.unit:gsub("(.)", string.upper, 1)
	if unit == "Targettarget" or unit == "focustarget" or unit == "pettarget" then return end

	if _G[unit.."FrameDropDown"] then
		ToggleDropDownMenu(1, nil, _G[unit.."FrameDropDown"], "cursor")
	elseif (self.unit:match("party")) then
		ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor")
	else
		FriendsDropDown.unit = self.unit
		FriendsDropDown.id = self.id
		FriendsDropDown.initialize = RaidFrameDropDown_Initialize
		ToggleDropDownMenu(1, nil, FriendsDropDown, "cursor")
	end
end

T.PostUpdatePower = function(element, unit, min, max)
	element:GetParent().Health:SetHeight(max ~= 0 and 20 or 22)
end

local ShortValue = function(value)
	if value >= 1e6 then
		return ("%.1fm"):format(value / 1e6):gsub("%.?0+([km])$", "%1")
	elseif value >= 1e3 or value <= -1e3 then
		return ("%.1fk"):format(value / 1e3):gsub("%.?0+([km])$", "%1")
	else
		return value
	end
end

local ShortValueNegative = function(v)
	if v <= 999 then return v end
	if v >= 1000000 then
		local value = string.format("%.1fm", v/1000000)
		return value
	elseif v >= 1000 then
		local value = string.format("%.1fk", v/1000)
		return value
	end
end

T.AuraFilter = function(icons, unit, icon, name, rank, texture, count, dtype, duration, timeLeft, caster, isStealable, shouldConsolidate, spellID)	
	local inInstance, instanceType = IsInInstance()
	icon.owner = caster
	icon.isStealable = isStealable
	
	if (unit and unit:find("arena%d")) then --Arena frames
		if dtype then
			if T.DebuffWhiteList[name] then
				return true
			else
				return false
			end			
		else
			if T.ArenaBuffWhiteList[name] then
				return true
			else
				return false
			end		
		end
	elseif unit == "target" or (unit and unit:find("boss%d")) then --Target/Boss Only
		if C["unitframes"].playerdebuffsonly == true then
			-- Show all debuffs on friendly targets
			if UnitIsFriend("player", "target") then return true end
			
			local isPlayer
			
			if(caster == 'player' or caster == 'vehicle') then
				isPlayer = true
			else
				isPlayer = false
			end

			if isPlayer then
				return true
			elseif T.DebuffWhiteList[name] or (inInstance and ((instanceType == "pvp" or instanceType == "arena") and T.TargetPVPOnly[name])) then
				return true
			else
				return false
			end
		else
			return true
		end
	else --Everything else
		if unit ~= "player" and unit ~= "targettarget" and unit ~= "focus" and C["unitframes"].arenadebuffs == true and inInstance and (instanceType == "pvp" or instanceType == "arena") then
			if T.DebuffWhiteList[name] or T.TargetPVPOnly[name] then
				return true
			else
				return false
			end
		else
			if T.DebuffBlacklist[name] then
				return false
			else
				return true
			end
		end
	end
end

T.PostUpdateHealth = function(health, unit, min, max)
	if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
		if not UnitIsConnected(unit) then
			health.value:SetText("|cffD7BEA5"..L.unitframes_ouf_offline.."|r")
		elseif UnitIsDead(unit) then
			health.value:SetText("|cffD7BEA5"..L.unitframes_ouf_dead.."|r")
		elseif UnitIsGhost(unit) then
			health.value:SetText("|cffD7BEA5"..L.unitframes_ouf_ghost.."|r")
		end
	else
		local r, g, b
		
		-- overwrite healthbar color for enemy player (a tukui option if enabled), target vehicle/pet too far away returning unitreaction nil and friend unit not a player. (mostly for overwrite tapped for friendly)
		-- I don't know if we really need to call C["unitframes"].unicolor but anyway, it's safe this way.
		if (C["unitframes"].unicolor ~= true and C["unitframes"].enemyhcolor and unit == "target" and UnitIsEnemy(unit, "player") and UnitIsPlayer(unit)) or (C["unitframes"].unicolor ~= true and unit == "target" and not UnitIsPlayer(unit) and UnitIsFriend(unit, "player")) then
			local c = T.oUF_colors.reaction[UnitReaction(unit, "player")]
			if c then 
				r, g, b = c[1], c[2], c[3]
				health:SetStatusBarColor(r, g, b)
			else
				-- if "c" return nil it's because it's a vehicle or pet unit too far away, we force friendly color
				-- this should fix color not updating for vehicle/pet too far away from yourself.
				r, g, b = 75/255,  175/255, 76/255
				health:SetStatusBarColor(r, g, b)
			end					
		end

		if min ~= max then
			local r, g, b
			r, g, b = oUF.ColorGradient(min/max, 0.69, 0.31, 0.31, 0.65, 0.63, 0.35, 0.33, 0.59, 0.33)
			if unit == "player" and health:GetAttribute("normalUnit") ~= "pet" or unit == "target" then
				if C["unitframes"].percentage then
					health.percent:SetFormattedText("|cff%02x%02x%02x%d%%|r", r * 255, g * 255, b * 255, floor(min / max * 100))
				end
				health.value:SetFormattedText("|cffAF5050%s|r |cffD7BEA5|||r |cff559655%s|r", ShortValue(min), ShortValue(max))
			elseif (unit and unit:find("arena%d")) or (unit and unit:find("boss%d")) then
				if C["unitframes"].percentage then
					health.percent:SetFormattedText("|cff%02x%02x%02x%d%%|r", r * 255, g * 255, b * 255, floor(min / max * 100))
				end
			else
				health.value:SetText("|cff559655-"..ShortValueNegative(max-min).."|r")
			end
		elseif min == max then
			if unit == "player" and health:GetAttribute("normalUnit") ~= "pet" or unit == "target" then
				if C["unitframes"].percentage then
					health.percent:SetText(" ")
				end
				health.value:SetText("|cff559655" .. max .. "|r")
			elseif (unit and unit:find("arena%d")) or (unit and unit:find("boss%d")) then
				if C["unitframes"].percentage then
					health.percent:SetText(" ")
				end
			else
				health.value:SetText("|cff559655" .. max .. "|r")
			end
		end
	end
end

T.PostUpdateHealthRaid = function(health, unit, min, max)
	if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
		if not UnitIsConnected(unit) then
			health.value:SetText("|cffD7BEA5"..L.unitframes_ouf_offline.."|r")
		elseif UnitIsDead(unit) then
			health.value:SetText("|cffD7BEA5"..L.unitframes_ouf_dead.."|r")
		elseif UnitIsGhost(unit) then
			health.value:SetText("|cffD7BEA5"..L.unitframes_ouf_ghost.."|r")
		end
	else
		-- doing this here to force friendly unit (vehicle or pet) very far away from you to update color correcly
		-- because if vehicle or pet is too far away, unitreaction return nil and color of health bar is white.
		if not UnitIsPlayer(unit) and UnitIsFriend(unit, "player") and C["unitframes"].unicolor ~= true then
			local c = T.oUF_colors.reaction[5]
			local r, g, b = c[1], c[2], c[3]
			health:SetStatusBarColor(r, g, b)
			health.bg:SetTexture(.1, .1, .1)
		end
		
		if min ~= max then
			health.value:SetText("|cff559655-"..ShortValueNegative(max-min).."|r")
		else
			health.value:SetText(" ")
		end
	end
end

T.PostUpdatePetColor = function(health, unit, min, max)
	-- doing this here to force friendly unit (vehicle or pet) very far away from you to update color correcly
	-- because if vehicle or pet is too far away, unitreaction return nil and color of health bar is white.
	if not UnitIsPlayer(unit) and UnitIsFriend(unit, "player") and C["unitframes"].unicolor ~= true then
		local c = T.oUF_colors.reaction[5]
		local r, g, b = c[1], c[2], c[3]

		if health then health:SetStatusBarColor(r, g, b) end
		if health.bg then health.bg:SetTexture(.1, .1, .1) end
	end
end

T.PostNamePosition = function(self)
	self.Name:ClearAllPoints()
	if (self.Power.value:GetText() and UnitIsEnemy("player", "target") and C["unitframes"].targetpowerpvponly == true) or (self.Power.value:GetText() and C["unitframes"].targetpowerpvponly == false) then
		self.Name:SetPoint("CENTER", self.panel, "CENTER", 0, 1)
	else
		self.Power.value:SetAlpha(0)
		self.Name:SetPoint("LEFT", self.panel, "LEFT", 4, 1)
	end
end

T.PreUpdatePower = function(power, unit)
	local _, pType = UnitPowerType(unit)
	
	local color = T.oUF_colors.power[pType]
	if color then
		power:SetStatusBarColor(color[1], color[2], color[3])
	end
end

T.PostUpdatePower = function(power, unit, min, max)
	local self = power:GetParent()
	local pType, pToken = UnitPowerType(unit)
	local color = T.oUF_colors.power[pToken]

	if color then
		power.value:SetTextColor(color[1], color[2], color[3])
		if C["unitframes"].percentage then
			power.percent:SetTextColor(color[1], color[2], color[3])
		end
	end

	if not UnitIsPlayer(unit) and not UnitPlayerControlled(unit) or not UnitIsConnected(unit) then
		power.value:SetText()
		if C["unitframes"].percentage then
			power.percent:SetText()
		end
	elseif UnitIsDead(unit) or UnitIsGhost(unit) then
		power.value:SetText()
		if C["unitframes"].percentage then
			power.percent:SetText()
		end
	else
		if min ~= max then
			if pType == 0 then
				if unit == "player" or unit == "target" then
					if C["unitframes"].percentage then
						power.percent:SetFormattedText("%d%%", floor(min / max * 100))
					end
					power.value:SetFormattedText("%s |cffD7BEA5|||r %s", ShortValue(max - (max - min)), ShortValue(max))
				elseif (unit and unit:find("arena%d")) or (unit and unit:find("boss%d")) then
					if C["unitframes"].percentage then
						power.percent:SetText(" ")
					end
					power.value:SetText(max - (max - min))
				else
					if C["unitframes"].percentage then
						power.percent:SetText(" ")
					end
					power.value:SetText(ShortValue(min))
				end
			else
				if C["unitframes"].percentage then
					power.percent:SetText(" ")
				end
				power.value:SetText(max - (max - min))
			end
		elseif min == max then
			if pType == 0 then
				if unit == "player" or unit == "target" then
					if C["unitframes"].percentage then
						power.percent:SetText(" ")
					end
					power.value:SetText(min)
				elseif (unit and unit:find("arena%d")) or (unit and unit:find("boss%d")) then
					if C["unitframes"].percentage then
						power.percent:SetText(" ")
					end
					power.value:SetText(ShortValue(min))
				else
					if C["unitframes"].percentage then
						power.percent:SetText(" ")
					end
					power.value:SetText(ShortValue(min))
				end
			else
				if C["unitframes"].percentage then
					power.percent:SetText(" ")
				end
				power.value:SetText(ShortValue(min))
			end
		end
	end
	if self.Name then
		if unit == "target" then T.PostNamePosition(self, power) end
	end
end

T.CustomCastTimeText = function(self, duration)
	self.Time:SetText(("%.1f / %.1f"):format(self.channeling and duration or self.max - duration, self.max))
end

T.CustomCastDelayText = function(self, duration)
	self.Time:SetText(("%.1f |cffaf5050%s %.1f|r"):format(self.channeling and duration or self.max - duration, self.channeling and "- " or "+", self.delay))
end

local FormatTime = function(s)
	local day, hour, minute = 86400, 3600, 60
	if s >= day then
		return format("%dd", ceil(s / day))
	elseif s >= hour then
		return format("%dh", ceil(s / hour))
	elseif s >= minute then
		return format("%dm", ceil(s / minute))
	elseif s >= minute / 12 then
		return floor(s)
	end
	return format("%.1f", s)
end

local CreateAuraTimer = function(self, elapsed)
	if self.timeLeft then
		self.elapsed = (self.elapsed or 0) + elapsed
		if self.elapsed >= 0.1 then
			if not self.first then
				self.timeLeft = self.timeLeft - self.elapsed
			else
				self.timeLeft = self.timeLeft - GetTime()
				self.first = false
			end
			if self.timeLeft > 0 then
				local time = FormatTime(self.timeLeft)
				self.remaining:SetText(time)
				if self.timeLeft <= 5 then
					self.remaining:SetTextColor(0.99, 0.31, 0.31)
				else
					self.remaining:SetTextColor(1, 1, 1)
				end
			else
				self.remaining:Hide()
				self:SetScript("OnUpdate", nil)
			end
			self.elapsed = 0
		end
	end
end

T.PostCreateAura = function(element, button)
	T.SetTemplate(button)
	button:CreateShadow("Default")
	
	button.remaining = T.SetFontString(button, C["media"].font, 12, "OUTLINE")
	button.remaining:Point("CENTER", 1, 4)
	
	button.cd.noOCC = true		 	-- hide OmniCC CDs
	button.cd.noCooldownCount = true	-- hide CDC CDs
	
	button.cd:SetReverse()
	button.icon:Point("TOPLEFT", 2, -2)
	button.icon:Point("BOTTOMRIGHT", -2, 2)
	button.icon:SetTexCoord(.09, .91, .09, .91)
	button.icon:SetDrawLayer('ARTWORK')
	
	button.count:Point("BOTTOMRIGHT", -1, 1)
	button.count:SetJustifyH("RIGHT")
	button.count:SetFont(C["media"].font, 12, "OUTLINE")
	button.count:SetTextColor(0.84, 0.75, 0.65)
	
	button.overlayFrame = CreateFrame("frame", nil, button, nil)
	button.cd:SetFrameLevel(button:GetFrameLevel() + 1)
	button.cd:ClearAllPoints()
	button.cd:Point("TOPLEFT", button, "TOPLEFT", 2, -2)
	button.cd:Point("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
	button.overlayFrame:SetFrameLevel(button.cd:GetFrameLevel() + 1)	   
	button.overlay:SetParent(button.overlayFrame)
	button.count:SetParent(button.overlayFrame)
	button.remaining:SetParent(button.overlayFrame)
end

T.PostUpdateAura = function(icons, unit, icon, index, offset, filter, isDebuff, duration, timeLeft)
	local _, _, _, _, dtype, duration, expirationTime, unitCaster, _ = UnitAura(unit, index, icon.filter)

	if(icon.debuff) then
		if(not UnitIsFriend("player", unit) and icon.owner ~= "player" and icon.owner ~= "vehicle") and (not T.DebuffWhiteList[name]) then
			icon:SetBackdropBorderColor(unpack(C["media"].bordercolor))
			icon.icon:SetDesaturated(true)
		else
			local color = DebuffTypeColor[dtype] or DebuffTypeColor.none
			if (name == "Unstable Affliction" or name == "Vampiric Touch") and T.myclass ~= "WARLOCK" then
				icon:SetBackdropBorderColor(0.05, 0.85, 0.94)
			else
				icon:SetBackdropBorderColor(color.r * 0.6, color.g * 0.6, color.b * 0.6)
			end
			icon.icon:SetDesaturated(false)
		end
	else
		if (icon.isStealable or ((T.myclass == "PRIEST" or T.myclass == "SHAMAN") and dtype == "Magic")) and not UnitIsFriend("player", unit) then
			icon:SetBackdropBorderColor(237/255, 234/255, 142/255)
		else
			icon:SetBackdropBorderColor(unpack(C["media"].bordercolor))		
		end
	end
	
	if duration and duration > 0 then
		if C["unitframes"].auratimer == true then
			icon.remaining:Show()
		else
			icon.remaining:Hide()
		end
	else
		icon.remaining:Hide()
	end
 
	icon.duration = duration
	icon.timeLeft = expirationTime
	icon.first = true
	icon:SetScript("OnUpdate", CreateAuraTimer)
end

--Credit Monolit
local ticks = {}
local function SetCastTicks(self, num)
	if num and num > 0 then
		local d = self:GetWidth() / num
		for i = 1, num do
			if not ticks[i] then
				ticks[i] = self:CreateTexture(nil, 'OVERLAY')
				ticks[i]:SetTexture(C["media"].blank)
				ticks[i]:SetVertexColor(0, 0, 0)
				ticks[i]:SetWidth(2)
				ticks[i]:SetHeight(self:GetHeight())
			end
			ticks[i]:ClearAllPoints()
			ticks[i]:SetPoint("CENTER", self, "LEFT", d * i, 0)
			ticks[i]:Show()
		end
	else
		for _, tick in pairs(ticks) do
			tick:Hide()
		end
	end
end

T.PostCastStart = function(self, unit, name, rank, castid)
	if unit == "vehicle" then unit = "player" end
	--Fix blank castbar with opening text
	if name == "Opening" then
		self.Text:SetText(OPENING)
	else
		self.Text:SetText(string.sub(name, 0, math.floor((((32/245) * self:GetWidth()) / 12) * 12)))
	end
	
	if C["unitframes"].cbticks == true and unit == "player" then
		if T.ChannelTicks[name] then
			SetCastTicks(self, T.ChannelTicks[name])
		else
			for _, tick in pairs(ticks) do
				tick:Hide()
			end		
		end
	end
	
	if self.interrupt and unit ~= "player" then
		if UnitCanAttack("player", unit) then
			self:SetStatusBarColor(unpack(C["unitframes"].nointerruptcolor))
		else
			self:SetStatusBarColor(unpack(C["unitframes"].castbarcolor))	
		end
	else
		if C["unitframes"].cbclasscolor == true then
			self:SetStatusBarColor(unpack(oUF.colors.class[select(2, UnitClass(unit))]))
		else
			self:SetStatusBarColor(unpack(C["unitframes"].cbcustomcolor))
		end	
	end
end

T.HidePortrait = function(self, unit)
	if self.unit == "target" then
		if not UnitExists(self.unit) or not UnitIsConnected(self.unit) or not UnitIsVisible(self.unit) then
			self.Portrait:SetAlpha(0)
		else
			self.Portrait:SetAlpha(1)
		end
	end
end

T.UpdateShards = function(self, event, unit, powerType)
	if(self.unit ~= unit or (powerType and powerType ~= 'SOUL_SHARDS')) then return end
	local num = UnitPower(unit, SPELL_POWER_SOUL_SHARDS)
	for i = 1, SHARD_BAR_NUM_SHARDS do
		if(i <= num) then
			self.SoulShards[i]:SetAlpha(1)
		else
			self.SoulShards[i]:SetAlpha(.2)
		end
	end
end

T.Phasing = function(self, event)
	local inPhase = UnitInPhase(self.unit)
	local picon = self.PhaseIcon

	if not UnitIsPlayer(self.unit) then picon:Hide() return end

	-- TO BE COMPLETED
end

T.UpdateHoly = function(self, event, unit, powerType)
	if(self.unit ~= unit or (powerType and powerType ~= 'HOLY_POWER')) then return end
	local num = UnitPower(unit, SPELL_POWER_HOLY_POWER)
	for i = 1, MAX_HOLY_POWER do
		if(i <= num) then
			self.HolyPower[i]:SetAlpha(1)
		else
			self.HolyPower[i]:SetAlpha(.2)
		end
	end
end

T.EclipseDirection = function(self)
	if ( GetEclipseDirection() == "sun" ) then
			self.Text:SetText("|cffE5994C"..L.unitframes_ouf_starfirespell.."|r")
	elseif ( GetEclipseDirection() == "moon" ) then
			self.Text:SetText("|cff4478BC"..L.unitframes_ouf_wrathspell.."|r")
	else
			self.Text:SetText("")
	end
end

T.EclipseDisplay = function(self, login)
	local eb = self.EclipseBar
	local txt = self.EclipseBar.Text

	if login then
		eb:SetScript("OnUpdate", nil)
	end
	
	if eb:IsShown() then
		txt:Show()
		self.FlashInfo:Hide()
		if self.Buffs then self.Buffs:SetPoint("BOTTOMLEFT", self.ufbg, "TOPLEFT", 0, 7) end
	else
		txt:Hide()
		self.FlashInfo:Show()
		if self.Buffs then self.Buffs:SetPoint("BOTTOMLEFT", self.ufbg, "TOPLEFT", 0, 3) end
	end
end

T.MLAnchorUpdate = function (self)
	if self.Leader:IsShown() then
		self.MasterLooter:SetPoint("TOPLEFT", 14, 8)
	else
		self.MasterLooter:SetPoint("TOPLEFT", 2, 8)
	end
end

T.UpdateName = function(self,event)
	if self.Name then self.Name:UpdateTag(self.unit) end
end

local UpdateManaLevelDelay = 0
T.UpdateManaLevel = function(self, elapsed)
	UpdateManaLevelDelay = UpdateManaLevelDelay + elapsed
	if self.parent.unit ~= "player" or UpdateManaLevelDelay < 0.2 or UnitIsDeadOrGhost("player") or UnitPowerType("player") ~= 0 then return end
	UpdateManaLevelDelay = 0

	local percMana = UnitMana("player") / UnitManaMax("player") * 100

	if percMana <= C.unitframes.lowThreshold then
		self.ManaLevel:SetText("|cffaf5050"..L.unitframes_ouf_lowmana.."|r")
		Flash(self, 0.3)
	else
		self.ManaLevel:SetText()
		StopFlash(self)
	end
end

T.UpdateDruidMana = function(self)
	if self.unit ~= "player" then return end

	local num, str = UnitPowerType("player")
	if num ~= 0 then
		local min = UnitPower("player", 0)
		local max = UnitPowerMax("player", 0)

		local percMana = min / max * 100
		if percMana <= C["unitframes"].lowThreshold then
			self.FlashInfo.ManaLevel:SetText("|cffaf5050"..L.unitframes_ouf_lowmana.."|r")
			Flash(self.FlashInfo, 0.3)
		else
			self.FlashInfo.ManaLevel:SetText()
			StopFlash(self.FlashInfo)
		end

		if min ~= max then
			if self.Power.value:GetText() then
				self.DruidMana:SetPoint("LEFT", self.Power.value, "RIGHT", 1, 0)
				self.DruidMana:SetFormattedText("|cffD7BEA5-|r  |cff4693FF%d%%|r|r", floor(min / max * 100))
			else
				self.DruidMana:SetPoint("LEFT", self.panel, "LEFT", 7, 1)
				self.DruidMana:SetFormattedText("%d%%", floor(min / max * 100))
			end
		else
			self.DruidMana:SetText()
		end

		self.DruidMana:SetAlpha(1)
	else
		self.DruidMana:SetAlpha(0)
	end
end

T.UpdateThreat = function(self, event, unit)
	if (self.unit ~= unit) or (unit == "target" or unit == "pet" or unit == "focus" or unit == "focustarget" or unit == "targettarget") then return end
	local threat = UnitThreatSituation(self.unit)
	if (threat == 3) then
		if self.panel then
			self.panel:SetBackdropBorderColor(.69,.31,.31,1)
		else
			self.Name:SetTextColor(1,0.1,0.1)
		end
		if self.ufbg then
			self.ufbg:SetBackdropColor(.69,.31,.31,1)
		elseif self.t then
			self.t:SetBackdropBorderColor(.69,.31,.31,1)
			
			if self.tt then
				self.tt:SetBackdropBorderColor(.69,.31,.31,1)
			end
		end
	else
		if self.panel then
			self.panel:SetBackdropBorderColor(unpack(C["media"].bordercolor))
		else
			self.Name:SetTextColor(1,1,1)
		end
		
		if self.ufbg then
			self.ufbg:SetBackdropColor(unpack(C["media"].bordercolor))
		elseif self.t then
			self.t:SetBackdropBorderColor(unpack(C["media"].bordercolor))
			
			if self.tt then
				self.tt:SetBackdropBorderColor(unpack(C["media"].bordercolor))
			end
		end
	end 
end

--------------------------------------------------------------------------------------------
-- THE AURAWATCH FUNCTION ITSELF. HERE BE DRAGONS!
--------------------------------------------------------------------------------------------

T.countOffsets = {
	TOPLEFT = {6, 1},
	TOPRIGHT = {-6, 1},
	BOTTOMLEFT = {6, 1},
	BOTTOMRIGHT = {-6, 1},
	LEFT = {6, 1},
	RIGHT = {-6, 1},
	TOP = {0, 0},
	BOTTOM = {0, 0},
}

T.CreateAuraWatchIcon = function(self, icon)
	if (icon.cd) then
		icon.cd:SetReverse()
	end
end

T.createAuraWatch = function(self, unit)
	local auras = CreateFrame("Frame", nil, self)
	auras:SetPoint("TOPLEFT", self.Health, 2, -2)
	auras:SetPoint("BOTTOMRIGHT", self.Health, -2, 2)
	auras.presentAlpha = 1
	auras.missingAlpha = 0
	auras.icons = {}
	auras.PostCreateIcon = T.CreateAuraWatchIcon

	if (not C["unitframes"].auratimer) then
		auras.hideCooldown = true
	end

	local buffs = {}
	if IsAddOnLoaded("Tukui_DPS") then
		if (T.DPSBuffIDs[T.myclass]) then
			for key, value in pairs(T.DPSBuffIDs[T.myclass]) do
				if value["enabled"] == true then
					tinsert(buffs, value)
				end
			end
		end
	else
		if (T.HealerBuffIDs[T.myclass]) then
			for key, value in pairs(T.HealerBuffIDs[T.myclass]) do
				if value["enabled"] == true then
					tinsert(buffs, value)
				end
			end
		end
	end
	
	if T.PetBuffs[T.myclass] then
		for key, value in pairs(T.PetBuffs[T.myclass]) do
			tinsert(buffs, value)
		end
	end
	
	if (buffs) then
		for key, spell in pairs(buffs) do
			local icon = CreateFrame("Frame", nil, auras)
			icon.spellID = spell["id"]
			icon.anyUnit = spell["anyUnit"]
			icon:SetWidth(T.Scale(C["unitframes"].buffindicatorsize))
			icon:SetHeight(T.Scale(C["unitframes"].buffindicatorsize))
			icon:SetPoint(spell["point"], 0, 0)

			local tex = icon:CreateTexture(nil, "OVERLAY")
			tex:SetAllPoints(icon)
			tex:SetTexture(C["media"].blank)
			if (spell["color"]) then
				local color = spell["color"]
				tex:SetVertexColor(color.r, color.g, color.b)
			else
				tex:SetVertexColor(0.8, 0.8, 0.8)
			end
			
			local border = icon:CreateTexture(nil, "ARTWORK")
			border:Point("TOPLEFT", -T.mult, T.mult)
			border:Point("BOTTOMRIGHT", T.mult, -T.mult)
			border:SetTexture(C["media"].blank)
			border:SetVertexColor(0, 0, 0)

			local count = icon:CreateFontString(nil, "OVERLAY")
			count:SetFont(C["media"].uffont, 9, "THINOUTLINE")
			count:SetPoint("CENTER", unpack(T.countOffsets[spell["point"]]))
			icon.count = count

			auras.icons[spell["id"]] = icon
		end
	end
	
	self.AuraWatch = auras
end

local _, ns = ...
local ORD = ns.oUF_RaidDebuffs or oUF_RaidDebuffs

if not ORD then return end

ORD.ShowDispelableDebuff = true
ORD.FilterDispellableDebuff = true
ORD.MatchBySpellName = true

ORD:RegisterDebuffs(T.RaidDebuffs)