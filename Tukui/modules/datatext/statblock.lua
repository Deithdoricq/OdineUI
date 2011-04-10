local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

if C["datatext"].statblock ~= true then return end

----- [[     Panels     ]] -----

local stat = CreateFrame("Frame")
local width = (380 / 4) - 3


for i = 1, 3 do
	stat[i] = CreateFrame("Frame", "TukuiStat"..i, UIParent)
	stat[i]:CreatePanel("Default", width, 20, "CENTER")
	stat[i]:SetFrameLevel(1)
	stat[i]:EnableMouse(true)
	
	stat[i].text = stat[i]:CreateFontString(nil, "OVERLAY")
	stat[i].text:SetFont(C["media"].dfont, C["datatext"].fsize, "OUTLINE")
	stat[i].text:SetSize(stat[i]:GetWidth() - 10, 12)
	stat[i].text:SetPoint("CENTER", 0, 1)

	if i == 1 then
		stat[i]:ClearAllPoints()
		stat[i]:SetPoint("TOPLEFT", UIParent, "TOPLEFT", T.Scale(7), T.Scale(-7))
		stat[i]:SetWidth(85)
	else
		stat[i]:ClearAllPoints()
		stat[i]:SetPoint("TOPLEFT", stat[i-1], "TOPRIGHT", T.Scale(5), 0)
	end
end

----- [[     Time     ]] -----
local europeDisplayFormat = string.join("", "%02d", ":|r%02d")
local ukDisplayFormat = string.join("", "", "%d", ":|r%02d", " %s|r")
local timerLongFormat = "%d:%02d:%02d"
local timerShortFormat = "%d:%02d"
local lockoutInfoFormat = "%s |cffaaaaaa(%s%s, %s/%s)"
local formatBattleGroundInfo = "%s: "
local lockoutColorExtended, lockoutColorNormal = { r=0.3,g=1,b=0.3 }, { r=1,g=1,b=1 }
local difficultyInfo = { "N", "N", "H", "H" }
local curHr, curMin, curAmPm

local APM = { TIMEMANAGER_PM, TIMEMANAGER_AM }

local function CalculateTimeValues(tt)
	if tt == nil then tt = false end
	local Hr, Min, AmPm
	if tt == true then
		if C["datatext"].localtime == true then
			Hr, Min = GetGameTime()
			if C["datatext"].time24 == true then
				return Hr, Min, -1
			else
				if Hr>=12 then
					if Hr>12 then Hr = Hr - 12 end
					AmPm = 1
				else
					if Hr == 0 then Hr = 12 end
					AmPm = 2
				end
				return Hr, Min, AmPm
			end			
		else
			local Hr24 = tonumber(date("%H"))
			Hr = tonumber(date("%I"))
			Min = tonumber(date("%M"))
			if C["datatext"].time24 == true then
				return Hr24, Min, -1
			else
				if Hr24>=12 then AmPm = 1 else AmPm = 2 end
				return Hr, Min, AmPm
			end
		end
	else
		if C["datatext"].localtime == true then
			local Hr24 = tonumber(date("%H"))
			Hr = tonumber(date("%I"))
			Min = tonumber(date("%M"))
			if C["datatext"].time24 == true then
				return Hr24, Min, -1
			else
				if Hr24>=12 then AmPm = 1 else AmPm = 2 end
				return Hr, Min, AmPm
			end
		else
			Hr, Min = GetGameTime()
			if C["datatext"].time24 == true then
				return Hr, Min, -1
			else
				if Hr>=12 then
					if Hr>12 then Hr = Hr - 12 end
					AmPm = 1
				else
					if Hr == 0 then Hr = 12 end
					AmPm = 2
				end
				return Hr, Min, AmPm
			end
		end	
	end
end

local function CalculateTimeLeft(time)
		local hour = floor(time / 3600)
		local min = floor(time / 60 - (hour*60))
		local sec = time - (hour * 3600) - (min * 60)
		
		return hour, min, sec
end

local function formatResetTime(sec,table)
	local table = table or {}
	local d,h,m,s = ChatFrame_TimeBreakDown(floor(sec))
	local string = gsub(gsub(format(" %dd %dh %dm "..((d==0 and h==0) and "%ds" or ""),d,h,m,s)," 0[dhms]"," "),"%s+"," ")
	local string = strtrim(gsub(string, "([dhms])", {d=table.days or "d",h=table.hours or "h",m=table.minutes or "m",s=table.seconds or "s"})," ")
	return strmatch(string,"^%s*$") and "0"..(table.seconds or L"s") or string
end

stat[1]:SetScript("OnMouseDown", function(self, btn)
	if btn == 'RightButton'  then
		ToggleTimeManager()
	else
		GameTimeFrame:Click()
	end
end)

local int4 = 1
local function TimeUpdate(self, t)
	int4 = int4 - t
	if int4 > 0 then return end
	
	local Hr, Min, AmPm = CalculateTimeValues()
	
	if CalendarGetNumPendingInvites() > 0 then
		stat[1].text:SetTextColor(1, 0, 0)
	else
		stat[1].text:SetTextColor(1, 1, 1)
	end
	
	-- no update quick exit
	if (Hr == curHr and Min == curMin and AmPm == curAmPm) then
		int4 = 2
		return
	end
	
	curHr = Hr
	curMin = Min
	curAmPm = AmPm
		
	if AmPm == -1 then
		stat[1].text:SetFormattedText(europeDisplayFormat, Hr, Min)
	else
		stat[1].text:SetFormattedText(ukDisplayFormat, Hr, Min, T.cStart .. APM[AmPm])
	end

	int4 = 2
end
stat[1]:SetScript("OnUpdate", TimeUpdate)
TimeUpdate(stat[1], 10)

stat[1]:SetScript("OnEnter", function(self)
	OnLoad = function(self) RequestRaidInfo() end
	--local anchor, panel, xoff, yoff = T.DataTextTooltipAnchor(Text)
	GameTooltip:SetOwner(stat[1], "ANCHOR_BOTTOMRIGHT", -stat[1]:GetWidth(), -3)
	GameTooltip:ClearLines()

	local localizedName, isActive, canQueue, startTime, canEnter
	for i = 1, GetNumWorldPVPAreas() do
		_, localizedName, isActive, canQueue, startTime, canEnter = GetWorldPVPAreaInfo(i)
		if canEnter then
			if isActive then
				startTime = WINTERGRASP_IN_PROGRESS
			elseif startTime == nil then
				startTime = QUEUE_TIME_UNAVAILABLE
			else
				local hour, min, sec = CalculateTimeLeft(startTime)
				if hour > 0 then 
					startTime = string.format(timerLongFormat, hour, min, sec) 
				else 
					startTime = string.format(timerShortFormat, min, sec)
				end
			end
			GameTooltip:AddDoubleLine(format(T.cStart .. formatBattleGroundInfo, localizedName), startTime,1,1,1,1,1,1)	
		end
	end	

	local timeText
	local Hr, Min, AmPm = CalculateTimeValues(true)

	if C["datatext"].localtime == true then
		timeText = T.cStart .. L.datatext_servertime
	else
		timeText = T.cStart .. L.datatext_localtime
	end
	
	if AmPm == -1 then
		GameTooltip:AddDoubleLine(timeText, string.format(europeDisplayFormat, Hr, Min),1,1,1,1,1,1)
	else
		GameTooltip:AddDoubleLine(timeText, string.format(ukDisplayFormat, Hr, Min, APM[AmPm]),1,1,1,1,1,1)
	end
	
	local oneraid, lockoutColor
	for i = 1, GetNumSavedInstances() do
		local name, _, reset, difficulty, locked, extended, _, isRaid, maxPlayers, _, numEncounters, encounterProgress  = GetSavedInstanceInfo(i)
		if isRaid and (locked or extended) then
			local tr,tg,tb,diff
			if not oneraid then
				GameTooltip:AddLine(" ")
				GameTooltip:AddLine(L.datatext_savedraid)
				oneraid = true
			end
			if extended then lockoutColor = lockoutColorExtended else lockoutColor = lockoutColorNormal end
			GameTooltip:AddDoubleLine(format(lockoutInfoFormat, name, maxPlayers, difficultyInfo[difficulty],encounterProgress,numEncounters), formatResetTime(reset), 1,1,1, lockoutColor.r,lockoutColor.g,lockoutColor.b)
		end
	end
	GameTooltip:Show()
end)
stat[1]:SetScript("OnLeave", function() GameTooltip:Hide() end)

----- [[   Fps | MS | MB   ]] -----

local bandwidthString = "%.2f Mbps"
local percentageString = "%.2f%%"
local homeLatencyString = "%d ms"
local kiloByteString = "%d kb"
local megaByteString = "%.2f mb"

local function formatMem(memory)
	local mult = 10^1
	if memory > 999 then
		local mem = ((memory/1024) * mult) / mult
		return string.format(megaByteString, mem)
	else
		local mem = (memory * mult) / mult
		return string.format(kiloByteString, mem)
	end
end

local memoryTable = {}

local function RebuildAddonList(self)
	local addOnCount = GetNumAddOns()
	if (addOnCount == #memoryTable) or self.tooltip == true then return end

	-- Number of loaded addons changed, create new memoryTable for all addons
	memoryTable = {}
	for i = 1, addOnCount do
		memoryTable[i] = { i, select(2, GetAddOnInfo(i)), 0, IsAddOnLoaded(i) }
	end
	--self:SetAllPoints(stat[2])
end

local function UpdateMemory()
	-- Update the memory usages of the addons
	UpdateAddOnMemoryUsage()
	-- Load memory usage in table
	local addOnMem = 0
	local totalMemory = 0
	for i = 1, #memoryTable do
		addOnMem = GetAddOnMemoryUsage(memoryTable[i][1])
		memoryTable[i][3] = addOnMem
		totalMemory = totalMemory + addOnMem
	end
	-- Sort the table to put the largest addon on top
	table.sort(memoryTable, function(a, b)
		if a and b then
			return a[3] > b[3]
		end
	end)
	
	return totalMemory
end

local int, int2 = 6, 5
local statusColors = {
	"|cff0CD809",
	"|cffE8DA0F",
	"|cffFF9000",
	"|cffD80909"
}

local function FpsUpdate(self, t)
	int = int - t
	int2 = int2 - t
	
	if int < 0 then
		RebuildAddonList(self)
		int = 10
	end
	if int2 < 0 then
		local framerate = floor(GetFramerate())
		local fpscolor = 4
		local latency = select(3, GetNetStats()) 
		local latencycolor = 4
					
		if latency < 150 then
			latencycolor = 1
		elseif latency >= 150 and latency < 300 then
			latencycolor = 2
		elseif latency >= 300 and latency < 500 then
			latencycolor = 3
		end
		if framerate >= 30 then
			fpscolor = 1
		elseif framerate >= 20 and framerate < 30 then
			fpscolor = 2
		elseif framerate >= 10 and framerate < 20 then
			fpscolor = 3
		end
		local displayFormat = string.join("", T.cStart.."FPS: ", statusColors[fpscolor], "%d|r"..T.cStart.." MS: ", statusColors[latencycolor], "%d|r")
		stat[2].text:SetFormattedText(displayFormat, framerate, select(3, GetNetStats()))
		int2 = 1
	end
end
stat[2]:SetScript("OnMouseDown", function () collectgarbage("collect") FpsUpdate(Stat, 20) end)
stat[2]:SetScript("OnEnter", function(self)
	local bandwidth = GetAvailableBandwidth()
	local home_latency = select(4, GetNetStats()) 
	--local anchor, panel, xoff, yoff = T.DataTextTooltipAnchor(Text)
	--GameTooltip:SetOwner(panel, anchor, xoff, yoff)
	GameTooltip:SetOwner(stat[2], "ANCHOR_BOTTOMRIGHT", -stat[2]:GetWidth(), -3)
	GameTooltip:ClearLines()
	
	GameTooltip:AddDoubleLine(L.datatext_homelatency, string.format(homeLatencyString, home_latency), 0.69, 0.31, 0.31,0.84, 0.75, 0.65)
	
	if bandwidth ~= 0 then
		GameTooltip:AddDoubleLine(L.datatext_bandwidth , string.format(bandwidthString, bandwidth),0.69, 0.31, 0.31,0.84, 0.75, 0.65)
		GameTooltip:AddDoubleLine(L.datatext_download , string.format(percentageString, GetDownloadedPercentage() *100),0.69, 0.31, 0.31, 0.84, 0.75, 0.65)
		GameTooltip:AddLine(" ")
	end
	local totalMemory = UpdateMemory()
	GameTooltip:AddDoubleLine(L.datatext_totalmemusage, formatMem(totalMemory), 0.69, 0.31, 0.31,0.84, 0.75, 0.65)
	GameTooltip:AddLine(" ")
	for i = 1, #memoryTable do
		if (memoryTable[i][4]) then
			local red = memoryTable[i][3] / totalMemory
			local green = 1 - red
			GameTooltip:AddDoubleLine(memoryTable[i][2], formatMem(memoryTable[i][3]), 1, 1, 1, red, green + .5, 0)
		end						
	end
	GameTooltip:Show()
end)
stat[2]:SetScript("OnLeave", function() GameTooltip:Hide() end)
stat[2]:SetScript("OnUpdate", FpsUpdate) 
FpsUpdate(Stat, 6)

----- [[   Game Menu   ]] -----


local function OnEvent(self, event, ...)
	stat[3].text:SetText(T.cStart..MAINMENU_BUTTON)
	--self:SetAllPoints(stat[3])
end

local function OpenMenu()
	local menuFrame = CreateFrame("Frame", "TukuiDataTextMicroMenu", UIParent, "UIDropDownMenuTemplate")
	local menuList = {
		{text = CHARACTER_BUTTON,
		func = function() ToggleCharacter("PaperDollFrame") end},
		{text = SPELLBOOK_ABILITIES_BUTTON,
		func = function() ToggleFrame(SpellBookFrame) end},
		{text = TALENTS_BUTTON,
		func = function() if not PlayerTalentFrame then LoadAddOn("Blizzard_TalentUI") end if not GlyphFrame then LoadAddOn("Blizzard_GlyphUI") end PlayerTalentFrame_Toggle() end},
		{text = ACHIEVEMENT_BUTTON,
		func = function() ToggleAchievementFrame() end},
		{text = QUESTLOG_BUTTON,
		func = function() ToggleFrame(QuestLogFrame) end},
		{text = SOCIAL_BUTTON,
		func = function() ToggleFriendsFrame(1) end},
		{text = PLAYER_V_PLAYER,
		func = function() ToggleFrame(PVPFrame) end},
		{text = ACHIEVEMENTS_GUILD_TAB,
		func = function() if IsInGuild() then if not GuildFrame then LoadAddOn("Blizzard_GuildUI") end GuildFrame_Toggle() end end},
		{text = LFG_TITLE,
		func = function() ToggleFrame(LFDParentFrame) end},
		{text = LOOKING_FOR_RAID,
		func = function() ToggleFrame(LFRParentFrame) end},
		{text = HELP_BUTTON,
		func = function() ToggleHelpFrame() end},
		{text = CALENDAR_VIEW_EVENT,
		func = function()
		if(not CalendarFrame) then LoadAddOn("Blizzard_Calendar") end
			Calendar_Toggle()
		end},
	}

	EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU", 2)
end
stat[3]:RegisterEvent("PLAYER_LOGIN")
stat[3]:SetScript("OnEvent", OnEvent)
stat[3]:SetScript("OnMouseDown", function() OpenMenu() end)

----- [[   Mark Bar   ]] -----

local function ButtonEnter(self)
	local color = RAID_CLASS_COLORS[T.myclass]
	self:SetBackdropBorderColor(color.r, color.g, color.b)
end
 
local function ButtonLeave(self)
	self:SetBackdropBorderColor(unpack(C["media"].bordercolor))
end

local MarkBarBG = CreateFrame("Frame", "MarkBarBackground", UIParent)
MarkBarBG:CreatePanel("Default", T.Scale(T.buttonsize) * 4 + T.Scale(15), T.Scale(T.buttonsize) * 3 + T.Scale(2), "BOTTOMLEFT", TukuiInfoRight, "TOPLEFT", 0, T.Scale(3))
MarkBarBG:SetFrameLevel(0)
MarkBarBG:ClearAllPoints()
MarkBarBG:SetPoint("TOPLEFT", stat[3], "TOPRIGHT", T.Scale(8), 0)
MarkBarBG:Hide()

local icon = CreateFrame("Button", "Icon", MarkBarBG)
local mark = CreateFrame("Button", "Menu", MarkBarBG)
for i = 1, 8 do
	mark[i] = CreateFrame("Button", "mark"..i, MarkBarBG)
	mark[i]:CreatePanel("Default", T.Scale(T.buttonsize), T.Scale(T.buttonsize), "LEFT", MarkBarBG, "LEFT", T.Scale(3), T.Scale(-3))
	if i == 1 then
		mark[i]:SetPoint("TOPLEFT", MarkBarBG, "TOPLEFT",  T.Scale(3), T.Scale(-3))
	elseif i == 5 then
		mark[i]:SetPoint("TOP", mark[1], "BOTTOM", 0, T.Scale(-3))
	else
		mark[i]:SetPoint("LEFT", mark[i-1], "RIGHT", T.Scale(3), 0)
	end
	mark[i]:EnableMouse(true)
	mark[i]:SetScript("OnEnter", ButtonEnter)
	mark[i]:SetScript("OnLeave", ButtonLeave)
	mark[i]:SetScript("OnMouseUp", function() SetRaidTarget("target", i) end)
	
	icon[i] = CreateFrame("Button", "icon"..i, MarkBarBG)
	icon[i]:SetNormalTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
	icon[i]:Size(25, 25)
	icon[i]:Point("CENTER", mark[i])
	
	-- Set up each button
	if i == 1 then 
		icon[i]:GetNormalTexture():SetTexCoord(0,0.25,0,0.25)
	elseif i == 2 then
		icon[i]:GetNormalTexture():SetTexCoord(0.25,0.5,0,0.25)
	elseif i == 3 then
		icon[i]:GetNormalTexture():SetTexCoord(0.5,0.75,0,0.25)
	elseif i == 4 then
		icon[i]:GetNormalTexture():SetTexCoord(0.75,1,0,0.25)
	elseif i == 5 then
		icon[i]:GetNormalTexture():SetTexCoord(0,0.25,0.25,0.5)
	elseif i == 6 then
		icon[i]:GetNormalTexture():SetTexCoord(0.25,0.5,0.25,0.5)
	elseif i == 7 then
		icon[i]:GetNormalTexture():SetTexCoord(0.5,0.75,0.25,0.5)
	elseif i == 8 then
		icon[i]:GetNormalTexture():SetTexCoord(0.75,1,0.25,0.5)
	end
end

-- Create Button for clear target
local ClearTargetButton = CreateFrame("Button", "ClearTargetButton", MarkBarBackground)
ClearTargetButton:CreatePanel("Default", (T.Scale(T.buttonsize) * 4) + 9, 20, "TOPLEFT", mark[5], "BOTTOMLEFT", 0, T.Scale(-3))
ClearTargetButton:SetScript("OnEnter", ButtonEnter)
ClearTargetButton:SetScript("OnLeave", ButtonLeave)
ClearTargetButton:SetScript("OnMouseUp", function() SetRaidTarget("target", 0) end)
ClearTargetButton:SetFrameStrata("HIGH")

ClearTargetButtonText = T.SetFontString(ClearTargetButton, C["media"].dfont, C["datatext"].fsize, "OUTLINE")
ClearTargetButtonText:SetText(L.MarkBar_button_Clear)
ClearTargetButtonText:SetPoint("CENTER")
ClearTargetButtonText:SetJustifyH("CENTER", 1, 0)

--Create toggle button
local ToggleButton = CreateFrame("Frame", "ToggleButton", UIParent)
ToggleButton:CreatePanel("Default", width, 20, "CENTER", UIParent, "CENTER", 0, 0)
ToggleButton:ClearAllPoints()
ToggleButton:SetPoint("TOPLEFT", stat[3], "TOPRIGHT", T.Scale(8), 0)
ToggleButton:EnableMouse(true)
ToggleButton:SetFrameStrata("HIGH")
ToggleButton:SetScript("OnEnter", ButtonEnter)
ToggleButton:SetScript("OnLeave", ButtonLeave)

local ToggleButtonText = T.SetFontString(ToggleButton, C["media"].dfont, C["datatext"].fsize, "OUTLINE")
ToggleButtonText:SetText(T.cStart..L.MarkBar_button_MarkBar)
ToggleButtonText:SetPoint("CENTER", ToggleButton, "CENTER")

--Create close button
local CloseButton = CreateFrame("Frame", "CloseButton", MarkBarBackground)
CloseButton:CreatePanel("Default", 15, 15, "TOPLEFT", MarkBarBackground, "TOPRIGHT", T.Scale(3), 0)
CloseButton:EnableMouse(true)
CloseButton:SetScript("OnEnter", ButtonEnter)
CloseButton:SetScript("OnLeave", ButtonLeave)

local CloseButtonText = T.SetFontString(CloseButton, C["media"].dfont, C["datatext"].fsize, "OUTLINE")
CloseButtonText:SetText("x")
CloseButtonText:SetPoint("CENTER", CloseButton, "CENTER")

ToggleButton:SetScript("OnMouseDown", function()
	if MarkBarBackground:IsShown() then
		MarkBarBackground:Hide()
	else
		MarkBarBackground:Show()
		ToggleButton:Hide()
	end
end)

CloseButton:SetScript("OnMouseDown", function()
	if MarkBarBackground:IsShown() then
		MarkBarBackground:Hide()
		ToggleButton:Show()
	else
		ToggleButton:Show()
	end
end)


--Check if we are Raid Leader or Raid Officer / Party
local function CheckRaidStatus()
	local inInstance, instanceType = IsInInstance()
	local partyMembers = GetNumPartyMembers()
 
	if not UnitInRaid("player") and partyMembers >= 1 then return true
	elseif UnitIsRaidOfficer("player") then return true
	elseif not inInstance or instanceType == "pvp" or instanceType == "arena" then return false
	end
end

--Automatically show/hide the frame if we have Raid Leader or Raid Officer or in Party
local LeadershipCheck = CreateFrame("Frame")
LeadershipCheck:RegisterEvent("RAID_ROSTER_UPDATE")
LeadershipCheck:RegisterEvent("PARTY_MEMBERS_CHANGED")
LeadershipCheck:RegisterEvent("PLAYER_ENTERING_WORLD")
LeadershipCheck:SetScript("OnEvent", function(self, event)
	if CheckRaidStatus() then
		ToggleButton:Show()
		MarkBarBackground:Hide()
	else
		ToggleButton:Hide()
		MarkBarBackground:Hide()
	end
end)