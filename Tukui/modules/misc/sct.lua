local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

if C["misc"].sct ~= true then return end

-- m_CombatText by Monolit
local addon, ns = ...
local cfg = ns.cfg
local mCT = ns.mCT
local aoe = ns.aoe

local cfg = CreateFrame("Frame")

cfg.show_damage = true					-- enable outgoing damage combat text display
cfg.show_healing = true					-- enable outgoing healing combat text display

cfg.show_icons = true						-- enable icons display for outgoing damage/healing frame
cfg.iconsize = T.buttonsize - 2				-- icon size
cfg.show_overhealing = true					-- display outgoing overhealing in a specific format 'EFFECTIVE_HEALING (OVERHEALING)'

cfg.heal_threshold = 1						-- the minimum ammount of healing done to display
cfg.damage_threshold = 1					-- the minimum ammount of damage done to display
cfg.heal_threshold_85 = 2000				-- different healing threshold for level 85 players
cfg.damage_threshold_85 = 500				-- different damage threshold for level 85 players

cfg.merge_aoe_spam = true					-- merge multiple damage/healing events happening simultaniously in a single message
cfg.merge_aoe_time = 1						-- set the delay in seconds for calculating merged values 

ns.cfg = cfg

-- Change default combat text variables
if not IsAddOnLoaded("Blizzard_CombatText") then UIParentLoadAddOn("Blizzard_CombatText") end
if cfg.show_damage == true and IsAddOnLoaded("MikScrollingBattleText") then SetCVar("CombatDamage", 0) else SetCVar("CombatDamage", 1) end
if cfg.show_healing == true and IsAddOnLoaded("MikScrollingBattleText") then SetCVar("CombatHealing", 0) else SetCVar("CombatHealing", 1) end
CombatText:SetScript("OnUpdate", nil)
CombatText:SetScript("OnEvent", nil)
CombatText:UnregisterAllEvents()

-- disable rest if addon is loaded
if IsAddOnLoaded("MikScrollingBattleText") or IsAddOnLoaded("xCT") then return end

local font, fonts, fontf = C["media"].dmgfont, 15, "OUTLINE"

-- Set specific threshold for level 85 players
if T.level == 85 then
	cfg.heal_threshold = cfg.heal_threshold_85
	cfg.damage_threshold = cfg.damage_threshold_85
end
-- Create scrolling frames
local frames = {}
for i = 1, 3 do
	local f = CreateFrame("ScrollingMessageFrame", "mCT"..i, UIParent)
	f:SetFont(font,fonts,fontf)
	f:SetShadowColor(unpack(C["media"].backdropcolor))
	f:SetShadowOffset(1.5, -1.5)
	f:SetFadeDuration(0.2)
	f:SetTimeVisible(1.5)
	f:SetMaxLines(20)
	f:SetSpacing(2)
	f:SetWidth(200)
	f:SetHeight(200)
	if(i==1) then
		f:SetJustifyH"LEFT"
		f:SetPoint("CENTER", TukuiPlayer, "CENTER", -50, 500)
	elseif(i==2) then
		f:SetJustifyH"LEFT"
		f:SetPoint("CENTER", TukuiPlayer, "CENTER", -50, 450) -- 75 might be a better number
	elseif(i==3) then
		f:SetJustifyH"RIGHT"
		f:SetPoint("CENTER", TukuiTarget, "CENTER", 50, 450)
		f:SetWidth(300)
	end
	frames[i] = f
end
-- Incoming damage/healing events
local tbl = {
	["DAMAGE"] = 			{frame = 1, prefix =  "-", arg2 = true, r = 1, g = 0.1, b = 0.1},
	["DAMAGE_CRIT"] = 		{frame = 1, prefix = "|cffFF0000*|r-", arg2 = true, suffix = "|cffFF0000*|r", r = 1, g = 0.1, b = 0.1},
	["SPELL_DAMAGE"] = 		{frame = 1, prefix =  "-", 	arg2 = true, r = 0.79, g = 0.3, b = 0.85},
	["SPELL_DAMAGE_CRIT"] = {frame = 1, prefix = "|cffFF0000*|r-", arg2 = true, suffix = "|cffFF0000*|r", r = .98, g = .84, b = 0.67},
	["HEAL"] = 				{frame = 2, prefix =  "+", arg3 = true, r = 0.1, 	g = .65,	b = 0.1},
	["HEAL_CRIT"] = 		{frame = 2, prefix = "|cffFF0000*|r+", arg3 = true, suffix = "|cffFF0000*|r", r = 0.1, g = 1, b = 0.1},
	["PERIODIC_HEAL"] = 	{frame = 2, prefix =  "+", arg3 = true, r = 0.1, g = .65, b = 0.1},
	["MISS"] = 				{frame = 1, prefix = "Miss", r = 1, g = 0.1, b = 0.1},
	["SPELL_MISS"] = 		{frame = 1, prefix = "Miss", r = 0.79, g = 0.3, b = 0.85},
	["SPELL_REFLECT"] = 	{frame = 1, prefix = "Reflect", r = 1, g = 1, b = 1},
	["DODGE"] = 			{frame = 1, prefix = "Dodge", r = 1, g = 0.1, b = 0.1},
	["PARRY"] = 			{frame = 1, prefix = "Parry", r = 1, g = 0.1, b = 0.1},
	["BLOCK"] = 			{frame = 1, prefix = "Block", spec = true, r = 1, g = 0.1, b = 0.1},
	["RESIST"] = 			{frame = 1, prefix = "Resist", spec = true,	r = 1, g = 0.1, b = 0.1},
	["SPELL_RESIST"] = 		{frame = 1, prefix = "Resist", spec = true,	r = 0.79, g = 0.3, b = 0.85},
	["ABSORB"] = 			{frame = 1, prefix = "Absorb", spec = true, r = 1, g = 0.1, b = 0.1},
	["SPELL_ABSORBED"] = 	{frame = 1, prefix = "Absorb", spec = true, r = 0.79, g = 0.3, b = 0.85},
	["HONOR_GAINED"] = 		{frame = 1, prefix = HONOR..": +", arg2 = true, r = 0.4, g = 0.4, b = 0.4},
}

local aoe = CreateFrame("Frame")  

if not cfg.merge_aoe_spam then return end
aoe.spell = {}
if T.myclass=="WARLOCK" then
	if(cfg.merge_aoe_spam)then
		aoe.spell[27243]=true		-- Seed of Corruption (DoT)
		aoe.spell[27285]=true		-- Seed of Corruption (Explosion)
		aoe.spell[87385]=true		-- Seed of Corruption (Explosion Soulburned)
		aoe.spell[172]=true			-- Corruption
		aoe.spell[87389]=true		-- Corruption (Soulburn: Seed of Corruption)
		aoe.spell[30108]=true		-- Unstable Affliction
		aoe.spell[348]=true			-- Immolate
		aoe.spell[980]=true			-- Bane of Agony
		aoe.spell[85455]=true		-- Bane of Havoc
		aoe.spell[85421]=true		-- Burning Embers
		aoe.spell[42223]=true		-- Rain of Fire
		aoe.spell[5857]=true		-- Hellfire Effect
		aoe.spell[47897]=true		-- Shadowflame (shadow direct damage)
		aoe.spell[47960]=true		-- Shadowflame (fire dot)
		aoe.spell[50590]=true		-- Immolation Aura
		aoe.spell[30213]=true		-- Legion Strike (Felguard)
		aoe.spell[89753]=true		-- Felstorm (Felguard)
		aoe.spell[20153]=true		-- Immolation (Infrenal)
	end
elseif T.myclass=="DRUID"then
	if(cfg.merge_aoe_spam)then
		-- Healer spells
		aoe.spell[774]=true			-- Rejuvenation (Normal)
		aoe.spell[64801]=true		-- Rejuvenation (First tick)
		aoe.spell[48438]=true		-- Wild Growth
		aoe.spell[8936]=true		-- Regrowth
		aoe.spell[33763]=true		-- Lifebloom
		aoe.spell[44203]=true		-- Tranquility
		aoe.spell[81269]=true		-- Efflorescence
		-- Damager spells
		aoe.spell[8921]=true		-- Moonfire
		aoe.spell[93402]=true		-- Sunfire
		aoe.spell[5570]=true		-- Insect Swarm
		aoe.spell[42231]=true		-- Hurricane
		aoe.spell[50288]=true		-- Starfall
		aoe.spell[78777]=true		-- Wild Mushroom
		aoe.spell[61391]=true		-- Typhoon
		aoe.spell[1822]=true		-- Rake
		aoe.spell[62078]=true		-- Swipe (Cat Form)
		aoe.spell[779]=true			-- Swipe (Bear Form)
		aoe.spell[33745]=true		-- Lacerate
		aoe.spell[1079]=true		-- Rip
	end
elseif T.myclass=="PALADIN"then
	if(cfg.merge_aoe_spam)then
		aoe.spell[81297]=true		-- Consecration
		aoe.spell[2812]=true		-- Holy Wrath
		aoe.spell[53385]=true		-- Divine Storm
		aoe.spell[31803]=true		-- Censure
		aoe.spell[20424]=true		-- Seals of Command
		aoe.spell[42463]=true		-- Seal of Truth
		aoe.spell[25742]=true		-- Seal of Righteousness
		aoe.spell[20167]=true		-- Seal of Insight (Heal Effect)
		aoe.spell[88263]=true		-- Hammer of the Righteous
		aoe.spell[31935]=true		-- Avenger's Shield
		aoe.spell[94289]=true		-- Protector of the Innocent
		aoe.spell[53652]=true		-- Beacon of Light
		aoe.spell[85222]=true		-- Light of Dawn		
	end
elseif T.myclass=="PRIEST"then
	if(cfg.merge_aoe_spam)then
		-- Healer spells
--		aoe.spell[47750]=true		-- Penance (Heal Effect)
		aoe.spell[139]=true			-- Renew
		aoe.spell[596]=true			-- Prayer of Healing
		aoe.spell[56161]=true		-- Glyph of Prayer of Healing
		aoe.spell[64844]=true		-- Divine Hymn
		aoe.spell[32546]=true		-- Binding Heal
		aoe.spell[77489]=true		-- Echo of Light
		aoe.spell[34861]=true		-- Circle of Healing
		aoe.spell[23455]=true		-- Holy Nova (Healing Effect)
--		aoe.spell[33110]=true		-- Prayer of Mending
		aoe.spell[63544]=true		-- Divine Touch
		-- Damager spells
		aoe.spell[47666]=true		-- Penance (Damage Effect)
		aoe.spell[15237]=true		-- Holy Nova (Damage Effect)
		aoe.spell[589]=true			-- Shadow Word: Pain
		aoe.spell[34914]=true		-- Vampiric Touch
		aoe.spell[2944]=true		-- Devouring Plague
		aoe.spell[63675]=true		-- Improved Devouring Plague
		aoe.spell[15407]=true		-- Mind Flay
		aoe.spell[49821]=true		-- Mind Seer
		aoe.spell[87532]=true		-- Shadowy Apparition
	end
elseif T.myclass=="SHAMAN"then
	if(cfg.merge_aoe_spam)then
		aoe.spell[73921]=true		-- Healing Rain
		aoe.spell[421]=true			-- Chain Lightning
		aoe.spell[45297]=true		-- Chain Lightning (mastery proc)
		aoe.spell[8349]=true		-- Fire Nova
		aoe.spell[77478]=true 		-- Earhquake
		aoe.spell[51490]=true 		-- Thunderstorm
		aoe.spell[8187]=true 		-- Magma Totem
	end
elseif T.myclass=="MAGE"then
	if(cfg.merge_aoe_spam)then
		aoe.spell[44461]=true		-- Living Bomb Explosion
		aoe.spell[44457]=true		-- Living Bomb Dot
		aoe.spell[2120]=true		-- Flamestrike
		aoe.spell[12654]=true		-- Ignite
		aoe.spell[11366]=true		-- Pyroblast
		aoe.spell[31661]=true		-- Dragon's Breath
		aoe.spell[42208]=true		-- Blizzard
		aoe.spell[122]=true			-- Frost Nova
		aoe.spell[1449]=true		-- Arcane Explosion
	end
elseif T.myclass=="WARRIOR"then
	if(cfg.merge_aoe_spam)then
		aoe.spell[845]=true			-- Cleave
		aoe.spell[46968]=true		-- Shockwave
		aoe.spell[6343]=true		-- Thunder Clap
		aoe.spell[1680]=true		-- Whirlwind
		aoe.spell[94009]=true		-- Rend
		aoe.spell[12721]=true		-- Deep Wounds
	end
elseif T.myclass=="HUNTER"then
	if(cfg.merge_aoe_spam)then
		aoe.spell[2643]=true		-- Multi-Shot
	end
elseif T.myclass=="DEATHKNIGHT"then
	if(cfg.merge_aoe_spam)then
		aoe.spell[55095]=true		-- Frost Fever
		aoe.spell[55078]=true		-- Blood Plague
		aoe.spell[55536]=true		-- Unholy Blight
		aoe.spell[48721]=true		-- Blood Boil
		aoe.spell[49184]=true		-- Howling Blast
		aoe.spell[52212]=true		-- Death and Decay
	end
elseif T.myclass=="ROGUE"then
	if(cfg.merge_aoe_spam)then
		aoe.spell[51723]=true		-- Fan of Knives
		aoe.spell[2818]=true		-- Deadly Poison
		aoe.spell[8680]=true		-- Instant Poison
	end
end

aoe.SQ={}
if (cfg.show_damage or cfg.show_healing) then
	if not cfg.merge_aoe_time then
		cfg.merge_aoe_time=0
	end
	local pairs=pairs
	for k,v in pairs(aoe.spell) do
		aoe.SQ[k]={queue = 0, msg = "", color={}, count=0, utime=0, locked=false}
	end
	SpamQueue=function(spellId, add)
		local amount
		local spam=aoe.SQ[spellId]["queue"]
		if (spam and type(spam=="number"))then
			amount=spam+add
		else
			amount=add
		end
		return amount
	end
	local tslu=0
	local update=CreateFrame"Frame"
	update:SetScript("OnUpdate", function(self, elapsed)
		local count
		tslu=tslu+elapsed
		if tslu > 0.5 then
			tslu=0
		local utime=time()
			for k,v in pairs(aoe.SQ) do
				if not aoe.SQ[k]["locked"] and aoe.SQ[k]["queue"]>0 and aoe.SQ[k]["utime"]+cfg.merge_aoe_time<=utime then
					if aoe.SQ[k]["count"]>1 then
						count=" |cffFFFFFF x "..aoe.SQ[k]["count"].."|r"
					else
						count=""
					end
					mCT3:AddMessage(aoe.SQ[k]["queue"]..aoe.SQ[k]["msg"]..count, unpack(aoe.SQ[k]["color"]))
					aoe.SQ[k]["queue"]=0
					aoe.SQ[k]["count"]=0
				end
			end
		end
	end)
end

ns.aoe = aoe

local info
local template = "-%s (%s)"
local mCTi = CreateFrame"Frame"
mCTi:RegisterEvent"COMBAT_TEXT_UPDATE"
mCTi:RegisterEvent"PLAYER_REGEN_ENABLED"
mCTi:RegisterEvent"PLAYER_REGEN_DISABLED"
mCTi:SetScript("OnEvent", function(self, event, subev, arg2, arg3)
	if event=="COMBAT_TEXT_UPDATE" then
		info = tbl[subev]
		if (subev=="HEAL" or subev=="HEAL_CRIT" or subev=="PERIODIC_HEAL") and arg3<cfg.heal_threshold then return end
		if (subev=="HONOR_GAINED") and abs(arg2)<1 then return end
		if(info) then
			local msg = info.prefix or ""
			if(info.spec) then
				if(arg3) then
					msg = template:format(arg2, arg3)
				end
			else
				if(info.arg2) then msg = msg..floor(arg2) end
				if(info.arg3) then msg = msg..arg3 end
			end
			local suffix = info.suffix or ""
			frames[info.frame]:AddMessage(msg..suffix or "", info.r, info.g, info.b)
		end
	elseif event=="PLAYER_REGEN_ENABLED" then
		frames[1]:AddMessage("-"..LEAVING_COMBAT.."-",.1,1,.1)
	elseif event=="PLAYER_REGEN_DISABLED" then
		frames[1]:AddMessage("+"..ENTERING_COMBAT.."+",1,.1,.1)
	end
end)
-- Outgoing damage
if cfg.show_damage then
	local unpack,select,time=unpack,select,time
	local	gflags=bit.bor(	COMBATLOG_OBJECT_AFFILIATION_MINE,
 			COMBATLOG_OBJECT_REACTION_FRIENDLY,
 			COMBATLOG_OBJECT_CONTROL_PLAYER,
 			COMBATLOG_OBJECT_TYPE_GUARDIAN
 			)
	local mCTd=CreateFrame"Frame"
	mCTd:RegisterEvent"COMBAT_LOG_EVENT_UNFILTERED"
	mCTd:SetScript("OnEvent",function(self,event,...) 
		local msg,icon
		local timestamp, eventType, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags = select(1,...)
		if(sourceGUID==UnitGUID"player" and destGUID~=UnitGUID"player")or(sourceGUID==UnitGUID"pet")or(sourceFlags==gflags)then
			if(eventType=="SWING_DAMAGE")then
				local amount,_,_,_,_,_,critical=select(9,...)
				if(amount>=cfg.damage_threshold)then -- threshold
					msg=amount
					if (critical) then
						msg="|cffFF0000*|r|cffFAD8AC"..msg.."|r|cffFF0000*|r"
					end
					if cfg.show_icons then
						if(sourceGUID==UnitGUID"pet") or (sourceFlags==gflags)then
							icon=PET_ATTACK_TEXTURE
						else
							icon=GetSpellTexture(6603)
						end
						msg=msg.." \124T"..icon..":"..cfg.iconsize..":"..cfg.iconsize..":0:0:64:64:5:59:5:59\124t"
					end
					mCT3:AddMessage(msg)
				end
			elseif(eventType=="RANGE_DAMAGE")then
				local spellId,_,_,amount,_,_,_,_,_,critical=select(9,...)
				if(amount>=cfg.damage_threshold)then
					msg=amount
					if (critical) then
						msg="|cffFF0000*|r|cffFAD8AC"..msg.."|r|cffFF0000*|r"
					end
					if cfg.show_icons then
						icon=GetSpellTexture(spellId)
						msg=msg.." \124T"..icon..":"..cfg.iconsize..":"..cfg.iconsize..":0:0:64:64:5:59:5:59\124t"
					end
					mCT3:AddMessage(msg)
				end
			elseif(eventType=="SPELL_DAMAGE")or(eventType=="SPELL_PERIODIC_DAMAGE")then
				local spellId,_,spellSchool,amount,_,_,_,_,_,critical=select(9,...)
				if(amount>=cfg.damage_threshold)then
					local color={}
					local rawamount=amount
					if (critical) then
						amount="|cffFF0000*|r|cffFAD8AC"..amount.."|r|cffFF0000*|r"
					end
					if cfg.show_icons then
						icon=GetSpellTexture(spellId)
					end
					if (icon) then
						msg=" \124T"..icon..":"..cfg.iconsize..":"..cfg.iconsize..":0:0:64:64:5:59:5:59\124t"
					elseif(cfg.show_icons)then
						msg=" \124T"..C["media"].blank..":"..cfg.iconsize..":"..cfg.iconsize..":0:0:64:64:5:59:5:59\124t"
					else
						msg=""
					end
 					if cfg.merge_aoe_spam and aoe.spell[spellId] then
						aoe.SQ[spellId]["locked"]=true
						aoe.SQ[spellId]["queue"]=SpamQueue(spellId, rawamount)
						aoe.SQ[spellId]["msg"]=msg
						aoe.SQ[spellId]["color"]=color
						aoe.SQ[spellId]["count"]=aoe.SQ[spellId]["count"]+1
						if aoe.SQ[spellId]["count"]==1 then
							aoe.SQ[spellId]["utime"]=time()
						end
						aoe.SQ[spellId]["locked"]=false
						return
					end
					color = { 1, 0.82, 0 } -- tmp fix to make spells yellow color until i rewrite this entire mod
					mCT3:AddMessage(amount..""..msg,unpack(color))
				end
			elseif(eventType=="SWING_MISSED")then
				local missType,_=select(9,...)
				if(cfg.show_icons)then
					if(sourceGUID==UnitGUID"pet") or (sourceFlags==gflags)then
						icon=PET_ATTACK_TEXTURE
					else
						icon=GetSpellTexture(6603)
					end
					missType=missType.." \124T"..icon..":"..cfg.iconsize..":"..cfg.iconsize..":0:0:64:64:5:59:5:59\124t"
				end
	
				mCT3:AddMessage(missType)
			elseif(eventType=="SPELL_MISSED")or(eventType=="RANGE_MISSED")then
				local spellId,_,_,missType,_ = select(9,...)
				if(cfg.show_icons)then
					icon=GetSpellTexture(spellId)
					missType=missType.." \124T"..icon..":"..cfg.iconsize..":"..cfg.iconsize..":0:0:64:64:5:59:5:59\124t"
				end 
				mCT3:AddMessage(missType)
			elseif(eventType=="SPELL_DISPEL") then
				local target,_, _, id, effect, _, etype = select(9,...)
				local color
				if(cfg.show_icons)then
					icon=GetSpellTexture(id)
				end
				if (icon) then
					msg=" \124T"..icon..":"..cfg.iconsize..":"..cfg.iconsize..":0:0:64:64:5:59:5:59\124t"
				elseif(cfg.show_icons)then
					msg=" \124T"..C["media"].blank..":"..cfg.iconsize..":"..cfg.iconsize..":0:0:64:64:5:59:5:59\124t"
				else
					msg=""
				end
				if etype=="BUFF"then
					color={0,1,.5}
				else
					color={1,0,.5}
				end
				mCT3:AddMessage(ACTION_SPELL_DISPEL..": "..effect..msg,unpack(color))
			elseif(eventType=="SPELL_INTERRUPT") then
				local target,_, _, id, effect = select(9,...)
				local color={1,.5,0}
				if(cfg.show_icons)then
					icon=GetSpellTexture(id)
				end
				if (icon) then
					msg=" \124T"..icon..":"..cfg.iconsize..":"..cfg.iconsize..":0:0:64:64:5:59:5:59\124t"
				elseif(cfg.show_icons)then
					msg=" \124T"..C["media"].blank..":"..cfg.iconsize..":"..cfg.iconsize..":0:0:64:64:5:59:5:59\124t"
				else
					msg=""
				end
				mCT3:AddMessage(ACTION_SPELL_INTERRUPT..": "..effect..msg,unpack(color))
			elseif(eventType=="PARTY_KILL") then
				local tname=select(7,...)
				mCT3:AddMessage(ACTION_PARTY_KILL..": "..tname, .2, 1, .2)
			end	
		end
	end)
end
-- Outgoing healing
if cfg.show_healing then
	local unpack,select,time=unpack,select,time
	local mCTh=CreateFrame"Frame"
	mCTh:RegisterEvent"COMBAT_LOG_EVENT_UNFILTERED"
	mCTh:SetScript("OnEvent",function(self,event,...)
		local msg,icon
		local timestamp, eventType, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags = select(1,...)
		if(sourceGUID==UnitGUID"player")then
			if(eventType=='SPELL_HEAL')or(eventType=='SPELL_PERIODIC_HEAL')then
				local spellId,spellName,spellSchool,amount,overhealing,absorbed,critical = select(9,...)
				if(amount>=cfg.heal_threshold)then
					local color={.1,1,.1}
					local rawamount=amount
					if cfg.show_overhealing and abs(overhealing) > 0 then amount = math.floor(amount-overhealing).." ("..floor(overhealing)..")" end
					if (critical) then 
						amount="|cffFF0000*|r"..amount.."|cffFF0000*|r"
						color={.1,1,.1}
					else
						color={.1,.65,.1}
					end 
					if(cfg.show_icons)then
						icon=GetSpellTexture(spellId)
					else
						msg=""
					end
              			if (icon) then 
               			msg=" \124T"..icon..":"..cfg.iconsize..":"..cfg.iconsize..":0:0:64:64:5:59:5:59\124t"
					elseif(cfg.show_icons)then
						msg=" \124T"..C["media"].blank..":"..cfg.iconsize..":"..cfg.iconsize..":0:0:64:64:5:59:5:59\124t"
               		end
 					if cfg.merge_aoe_spam and aoe.spell[spellId] then
						aoe.SQ[spellId]["locked"]=true
						aoe.SQ[spellId]["queue"]=SpamQueue(spellId, rawamount)
						aoe.SQ[spellId]["msg"]=msg
						aoe.SQ[spellId]["color"]=color
						aoe.SQ[spellId]["count"]=aoe.SQ[spellId]["count"]+1
						if aoe.SQ[spellId]["count"]==1 then
							aoe.SQ[spellId]["utime"]=time()
						end
						aoe.SQ[spellId]["locked"]=false
						return
					end
					mCT3:AddMessage(amount..""..msg,unpack(color))
				end
			end
		end
	end)
end

--[[code for support with moveui command
for i = 1, 3 do
	local sctbarpanel = CreateFrame("Frame", frames[i]:GetName().."_Panel", frames[i])
    sctbarpanel:CreateShadow("Default")
    local anchor = CreateFrame("Button", frames[i]:GetName().."_PanelAnchor", frames[i])
    anchor:SetTemplate("Default")
    anchor:SetBackdropBorderColor(1, 0, 0, 1)
    anchor:SetMovable(true)
    anchor.text = T.SetFontString(anchor, C["media"].font, 12)
    anchor.text:SetPoint("CENTER")
    anchor.text:SetText(frames[i]:GetName())
    anchor.text.Show = function() anchor:Show() end
    anchor.text.Hide = function() anchor:Hide() end
    anchor:Hide()

	T.MoverFrames[(#T.MoverFrames)+1] = anchor
	local originalExec = T.exec
	function T.exec(...)
		self, enable = ...
		if self == anchor then
			if enable then
				self:Show()
			else
				self:Hide()
			end
		end
		return originalExec(...)
	end
end--]]