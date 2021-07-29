-- Loads up a slew of objects to load into the screen, like how 3.9 does.
-- I prefer to keep these optional, in case another screen wants to hide 
-- these elements.

--[ja] ここのアニメーションが終わるまで操作ホールド
local t = Def.ActorFrame {};
t[#t+1] = StandardDecorationFromFileOptional("Header","Header");
t[#t+1] = StandardDecorationFromFileOptional("Help","Help");
t[#t+1] = StandardDecorationFromFileOptional("StyleIcon","StyleIcon");
t[#t+1] = StandardDecorationFromFileOptional("Statusbar","Statusbar");
t[#t+1] = StandardDecorationFromFileOptional("IHelpunder","IHelpunder");
return t