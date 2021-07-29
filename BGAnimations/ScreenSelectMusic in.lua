local t = Def.ActorFrame{};

t[#t+1] = LoadActor(THEME:GetPathB("","_delay"),1);
if getenv("ReloadAnimFlag") == 0 then
	t[#t+1] = LoadActor( THEME:GetPathB("","_menu in") )..{};
end;

return t;