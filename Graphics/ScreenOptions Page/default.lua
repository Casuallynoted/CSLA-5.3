--[[ ScreenOptions Page ]]

local t = Def.ActorFrame{};
local screen = SCREENMAN:GetTopScreen();

--[ja] ネット選曲画面ほか対策
if screen then
	if THEME:GetMetric( Var "LoadingScreen","ScreenType") == 1 then
		t[#t+1] = Def.Quad{
			InitCommand=cmd(x,0;y,12;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,color("0,0,0,0.8");diffusetopedge,color("0,0.5,0.5,0.8"););
		};
	end;
end;

t[#t+1] = LoadActor("_Page")..{
};

return t;