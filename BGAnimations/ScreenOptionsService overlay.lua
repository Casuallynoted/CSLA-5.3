local t = Def.ActorFrame {};

t[#t+1] = LoadActor(THEME:GetPathB("","_options screen"),"ScreenOptionsServiceSubMenu");

--20160420
t[#t+1] = netstatecheck();

return t