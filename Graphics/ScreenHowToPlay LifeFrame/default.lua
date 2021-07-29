--[[ScreenHowToPlay LifeFrame]]

local t = Def.ActorFrame{};

local playerset = { PLAYER_1,PLAYER_2 };

local setx,zoomxset,setaddx,afteraddx,pn = THEME:GetMetric("ScreenGameplay","PlayerP2TwoPlayersTwoSidesX")+11,-1,100,-100,playerset[math.random(#playerset)];
local p = (pn == PLAYER_1) and 1 or 2;
local meterwidth = math.min(216,WideScale(213,216));
local meterheight = 14;

if not GAMESTATE:IsDemonstration() then
	t[#t+1] = Def.ActorFrame{
		InitCommand=cmd(y,SCREEN_TOP+28);
		
		LoadActor(THEME:GetPathG("","GameFSet/Life/Regular_LifeFrame/lifeframe_left_frame"))..{
			InitCommand=cmd(x,setx;zoomx,zoomxset;);
			OnCommand=cmd(diffusealpha,0;addx,setaddx;sleep,0.2;accelerate,0.2;diffusealpha,1;addx,afteraddx;
						glow,color("1,1,0,0");linear,0.05;glow,color("1,1,0,1");linear,0.4;glow,color("1,1,0,0"););
		};
		
		LoadActor("hclife")..{
			InitCommand=cmd(visible,true;x,setx+106;y,3;skewx,-1);
			OnCommand=cmd(zoomx,0;sleep,0.8;linear,0.2;zoomx,1;);
		};

		LoadActor(THEME:GetPathG("","GameFSet/Life/Regular_LifeFrame/lifeframe_life_frame"))..{
			InitCommand=cmd(x,setx;zoomx,zoomxset;);
			OnCommand=cmd(diffusealpha,0;addy,20;sleep,0.4;decelerate,0.3;diffusealpha,1;addy,-20;
						glow,color("1,0.7,0,0");linear,0.05;glow,color("1,0.7,0,1");linear,0.4;glow,color("1,0.7,0,0"););
		};

		LoadActor(THEME:GetPathG("","GameFSet/Life/Regular_LifeFrame/lifeframe_right_frame"))..{
			InitCommand=cmd(x,SCREEN_CENTER_X+182;zoomx,zoomxset;);
			OnCommand=cmd(cropleft,1;zoomy,2;sleep,0.5;accelerate,0.2;cropleft,0;zoomy,1;
						glow,color("1,0.5,0,0");linear,0.05;glow,color("1,0.5,0,1");linear,0.4;glow,color("1,0.5,0,0"););
		};
		
		LoadActor(THEME:GetPathG("","GameFSet/Life/p"..p.."_left_lamp"))..{
			InitCommand=cmd(x,setx+121;y,2;zoomx,zoomxset;);
			OnCommand=cmd(diffusealpha,0;sleep,0.8;linear,0.2;diffusealpha,1;glow,color("0,1,1,0");queuecommand,"Repeat";);
			RepeatCommand=cmd(glow,PlayerColor(pn);linear,1;glow,color("0,1,1,0");sleep,4;queuecommand,"Repeat";);
		};
		
		LoadActor(THEME:GetPathG("","GameFSet/Life/p"..p.."_right_lamp"))..{
			InitCommand=cmd(x,SCREEN_CENTER_X+65;y,-4;zoomx,zoomxset;);
			OnCommand=cmd(diffusealpha,0;sleep,0.4;linear,0.1;diffusealpha,1;glow,color("0,1,1,0");queuecommand,"Repeat";);
			RepeatCommand=cmd(glow,PlayerColor(pn);linear,1;glow,color("0,1,1,0");sleep,4;queuecommand,"Repeat";);
		};
	};
end;

return t;
