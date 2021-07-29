local t = Def.ActorFrame{};

-- todo: add event mode indicators and such
if GAMESTATE:IsEventMode() then
	t[#t+1] = LoadFont("_shared2")..{
		Text=Screen.String("EventMode");
		InitCommand=cmd(CenterX;y,SCREEN_BOTTOM-78;zoom,0.65;shadowlength,1;diffuse,color("1,1,0,1");strokecolor,Color("Black"););
	};
end;

t[#t+1] = LoadActor( THEME:GetPathB("","_cfopen") )..{
};

return t;