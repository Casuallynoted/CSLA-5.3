local t = Def.ActorFrame{};
local pm = GAMESTATE:GetPlayMode();

t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-148;);
	LoadActor(THEME:GetPathG("ScreenSelectMusic","BannerFrame/_bannerback2"))..{
		InitCommand=cmd(y,-8;zoomx,10;zoomy,1;);
		OnCommand=cmd(diffusealpha,0;sleep,0.2;accelerate,0.25;diffusealpha,1;zoomx,1;glow,color("0.6,0.3,0,0.75");decelerate,0.15;glow,color("0.6,0.3,0,0"););
	};
	LoadActor(THEME:GetPathG("ScreenSelectMusic","BannerFrame/_bannerback2"))..{
		InitCommand=cmd(y,8;rotationz,180;zoomx,10;zoomy,1;);
		OnCommand=cmd(diffusealpha,0;sleep,0.2;accelerate,0.25;diffusealpha,1;zoomx,1;glow,color("0.6,0.3,0,0.75");decelerate,0.15;glow,color("0.6,0.3,0,0"););
	};
};

if pm ~= 'PlayMode_Battle' and pm ~= 'PlayMode_Rave' then	
	for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
		t[#t+1] = LoadActor("frame", pn);
	end;
else
	t[#t+1] = Def.ActorFrame{
		InitCommand=cmd(y,SCREEN_CENTER_Y;);
		LoadActor("_graph_rave_top")..{
			InitCommand=cmd(x,SCREEN_CENTER_X;y,30;);
			OnCommand=cmd(croptop,1;sleep,0.3;linear,0.3;croptop,0;);
		};

		LoadActor("_graph_back")..{
			InitCommand=cmd(x,SCREEN_CENTER_X*0.45;y,-98;diffusealpha,0.6;);
			OnCommand=cmd(croptop,1;sleep,0.1;decelerate,0.5;croptop,0;);
		};

		LoadActor("_graph_back")..{
			InitCommand=cmd(x,SCREEN_CENTER_X*1.55;y,-98;diffusealpha,0.6;);
			OnCommand=cmd(croptop,1;sleep,0.1;decelerate,0.5;croptop,0;);
		};
	
		LoadActor("_player1")..{
			InitCommand=cmd(x,SCREEN_CENTER_X*0.45+32;y,-63;);
			OnCommand=cmd(diffusealpha,0;zoom,1.5;sleep,0.075;accelerate,0.4;diffusealpha,1;zoom,1;);
		};
		
		LoadActor("_player2")..{
			InitCommand=cmd(x,SCREEN_CENTER_X*1.55+32;y,-63;);
			OnCommand=cmd(diffusealpha,0;zoom,1.5;sleep,0.075;accelerate,0.4;diffusealpha,1;zoom,1;);
		};
	};
end;
return t;