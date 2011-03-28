local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

----- [[     Panels     ]] -----

local stat = CreateFrame("Frame")
local width = (350 / 4) - 3


for i = 1, 4 do
	stat[i] = CreateFrame("Frame", "TukuiStat"..i, UIParent)
	stat[i]:CreatePanel("Default", width, 20, "CENTER")
	stat[i]:SetFrameLevel(2)
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

----- [[     Memory     ]] -----

local colorme = string.format("%02x%02x%02x", 1*255, 1*255, 1*255)

local function formatMem(memory, color)
	if color then
		statColor = { "|cff"..colorme, "|r" }
	else
		statColor = { "", "" }
	end

	local mb, kb = (T.cStart .. "mb|r"), (T.cStart .. "kb|r")
	
	local mult = 10^1
	if memory > 999 then
		local mem = floor((memory/1024) * mult + 0.5) / mult
		if mem % 1 == 0 then
			return mem..string.format(".0 %s" .. mb .. "%s", unpack(statColor))
		else
			return mem..string.format(" %s" .. mb .. "%s", unpack(statColor))
		end
	else
		local mem = floor(memory * mult + 0.5) / mult
			if mem % 1 == 0 then
				return mem..string.format(".0 %s" .. kb .. "%s", unpack(statColor))
			else
				return mem..string.format(" %s" .. kb .. "%s", unpack(statColor))
			end
	end
end

local Total, Mem, MEMORY_TEXT, LATENCY_TEXT, Memory

local function RefreshMem(self)
	Memory = {}

	UpdateAddOnMemoryUsage()
	Total = 0
	for i = 1, GetNumAddOns() do
		Mem = GetAddOnMemoryUsage(i)
		Memory[i] = { select(2, GetAddOnInfo(i)), Mem, IsAddOnLoaded(i) }
		Total = Total + Mem
	end

	MEMORY_TEXT = formatMem(Total, true)
	table.sort(Memory, function(a, b)
		if a and b then
			return a[2] > b[2]
		end
	end)

end

local int, int10 = 10, 1
local function MemUpdate(self, t)
	int = int - t
	int10 = int10 - t
	if int < 0 then
		RefreshMem(self)
		int = 10
	end
	if int10 < 0 then
		local memC

		if Total > 5000 then
			memC = format("|cffCC3333 %s|r ", MEMORY_TEXT)
		elseif Total > 2500 then
			memC = format("|cffFDD842 %s|r ", MEMORY_TEXT)
		else
			memC = format("|cff32DC46 %s|r ", MEMORY_TEXT)
		end

		stat[2].text:SetText(memC)
		int10 = 1
	end
end

stat[2]:SetScript("OnMouseDown", function() collectgarbage("collect") MemUpdate(stat[2], 20) end)
stat[2]:SetScript("OnUpdate", MemUpdate) 

stat[2]:SetScript("OnEnter", function()
	if not InCombatLockdown() then
		-- local bandwidth = GetAvailableBandwidth()
		GameTooltip:SetOwner(stat[2], "ANCHOR_BOTTOMRIGHT", -stat[2]:GetWidth(), T.Scale(-3))
		-- GameTooltip:ClearLines()
		-- if bandwidth ~= 0 then
			-- GameTooltip:AddDoubleLine(T.cStart .. tukuilocal.datatext_bandwidth,format("%s ".. T.cStart .. "Mbps",bandwidth), _, _, _, 1, 1, 1)
			-- GameTooltip:AddDoubleLine(T.cStart .. tukuilocal.datatext_download,format("%s%%", floor(GetDownloadedPercentage()*100+0.5)), _, _, _, 1, 1, 1)
			-- GameTooltip:AddLine' ' 
		-- end
		GameTooltip:AddDoubleLine(T.cStart .. tukuilocal.datatext_totalmemusage, formatMem(Total), _, _, _, 1, 1, 1)
		GameTooltip:AddLine' '
		for i = 1, #Memory do
			if Memory[i][3] then 
				local red = Memory[i][2]/Total*2
				local green = 1 - red
				GameTooltip:AddDoubleLine(Memory[i][1], formatMem(Memory[i][2], false), 1, 1, 1, red, green+1, 0)						
			end
		end
		GameTooltip:Show()
	end
end)
stat[2]:SetScript("OnLeave", function() GameTooltip:Hide() end)
MemUpdate(stat[2], 20)

----- [[     Fps     ]] -----

local int2 = 1
local function FpsUpdate(self, t)
	int2 = int2 - t
	if int2 < 0 then
		local fps = floor(GetFramerate())
		local color_fps
		
		-- stat[3].bar:SetMinMaxValues(0, 180)
		-- stat[3].bar:SetValue(fps)

		if fps >= 50 then
			color_fps = "|cff32DC46"..floor(GetFramerate()).."|r"
			-- stat[3].bar:SetStatusBarColor(.3, .9, .3)
		elseif fps >= 25 then
			color_fps = "|cffFDD842"..floor(GetFramerate()).."|r"
			-- stat[3].bar:SetStatusBarColor(.8, .7, .4)
		elseif fps >= 0 then
			color_fps = "|cffCC3333"..floor(GetFramerate()).."|r"
			-- stat[3].bar:SetStatusBarColor(.9, .3, .3)
		end
		
		stat[3].text:SetText(T.cStart .. "FPS " .. color_fps)
		
		int2 = 1
	end	
end
stat[3]:SetScript("OnUpdate", FpsUpdate)
FpsUpdate(stat[3], 10)

----- [[     Latency     ]] -----

local int3 = 1
local function LatencyUpdate(self, t)
	int3 = int3 - t
	if int3 < 0 then
		local _, _, ms = GetNetStats()
		local color_ms
		
		if ms >= 300 then
			color_ms = "|cffCC3333"..select(4, GetNetStats()).."|r"
		elseif ms >= 200 then
			color_ms = "|cffFDD842"..select(4, GetNetStats()).."|r"
		elseif ms >= 0 then
			color_ms = "|cff32DC46"..select(4, GetNetStats()).."|r"
		end

		stat[4].text:SetText(T.cStart .. "MS " .. color_ms)

		int3 = 1
	end	
end
stat[4]:SetScript("OnUpdate", LatencyUpdate)
LatencyUpdate(stat[4], 10)

stat[4]:SetScript("OnEnter", function(self)
	if not InCombatLockdown() then
		local _, _, latencyHome, latencyWorld = GetNetStats()
		local latency = format(MAINMENUBAR_LATENCY_LABEL, latencyHome, latencyWorld)
		GameTooltip:SetOwner(stat[4], "ANCHOR_BOTTOMRIGHT", -stat[4]:GetWidth(), -3)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(latency)
		GameTooltip:Show()
	end
end)
stat[4]:SetScript("OnLeave", function() GameTooltip:Hide() end)


