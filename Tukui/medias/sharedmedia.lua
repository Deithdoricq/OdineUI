local LSM = LibStub("LibSharedMedia-3.0")
if LSM == nil then return end

-- Fonts
LSM:Register("font", "Tukui Font", [=[Interface\Addons\Tukui\medias\fonts\normal_font.ttf]=])
LSM:Register("font", "Tukui UF", [[Interface\AddOns\Tukui\medias\fonts\uf_font.ttf]])
LSM:Register("font", "Tukui Combat", [[Interface\AddOns\Tukui\medias\fonts\combat_font.ttf]])
LSM:Register("font", "Impact", [[Interface\AddOns\Tukui\medias\fonts\impact.ttf]])
LSM:Register("font", "Caith", [[Interface\AddOns\Tukui\medias\fonts\caith.ttf]])
LSM:Register("font", "Sugo", [[Interface\AddOns\Tukui\medias\fonts\sugo.ttf]])

-- Textures
LSM:Register("statusbar", "Tukui Norm", [[Interface\AddOns\Tukui\medias\textures\normTex]])

-- Borders
LSM:Register("border", "Tukui Glow", [[Interface\AddOns\Tukui\medias\textures\glowTex]])

-- Backgrounds
LSM:Register("background", "Tukui Blank", [[Interface\AddOns\Tukui\medias\textures\blank]])

-- Sounds
LSM:Register("sound", "Tukui Warning", [[Interface\AddOns\Tukui\medias\sounds\warning.mp3]])
LSM:Register("sound", "Tukui Whisper", [[Interface\AddOns\Tukui\medias\sounds\whisper.mp3]])