----------------------------------------------------------------------------
-- Per Class Config (overwrite general)
-- Class need to be UPPERCASE
----------------------------------------------------------------------------
local T, C, L, DB = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

if T.myclass == "PRIEST" then
	-- do some config!
end

----------------------------------------------------------------------------
-- Per Character Name Config (overwrite general and class)
-- Name need to be case sensitive
----------------------------------------------------------------------------

if T.myname == "Odine" or T.myname == "Marmon" then
	-- do something
end

----------------------------------------------------------------------------
-- Pretty sure we dont need to display master if not level 80 LOL
----------------------------------------------------------------------------

if T.level < 80 then
	DB["datatext"].mastery = 0
	DB["datatext"].hit = 4
end
