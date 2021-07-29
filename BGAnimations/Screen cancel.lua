
local t = Def.ActorFrame{
	InitCommand=cmd(sleep,0.6);
	
	LoadActor(THEME:GetPathS("_Screen","cancel")) .. {
		StartTransitioningCommand=cmd(play);
	};
	Def.Quad{
		BeginCommand=cmd(FullScreen);
		OnCommand=cmd(diffuse,color("0,0,0,0");linear,0.1;diffuse,color("0,0,0,1"););
	};

	Def.Quad{
		BeginCommand=cmd(FullScreen);
		OnCommand=cmd(diffuse,color("0,0,0,0");linear,0.1;diffuse,color("0,0.3,0.4,1");linear,0.3;diffusealpha,0);
	};

	Def.Quad{
		OnCommand=cmd(blend,'BlendMode_Add';x,SCREEN_LEFT;y,SCREEN_CENTER_Y;horizalign,left;diffuse,color("0,1,0.9,0.75");zoomtowidth,SCREEN_WIDTH;zoomtoheight,SCREEN_HEIGHT;
				fadetop,0.4;fadebottom,0.4;faderight,1;decelerate,0.6;zoomtoheight,20;accelerate,0.05;zoomtowidth,0;);
	};

	Def.Quad{
		OnCommand=cmd(blend,'BlendMode_Add';x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;diffuse,color("1,0.5,0,0.75");zoomtowidth,SCREEN_WIDTH;zoomtoheight,SCREEN_HEIGHT;
				decelerate,0.4;fadetop,0.2;fadebottom,0.2;zoomtoheight,0;sleep,0.2;diffusealpha,0;);
	};

	Def.Quad{
		OnCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;diffuse,color("0,0.8,1,1");zoomtowidth,SCREEN_WIDTH;zoomtoheight,SCREEN_HEIGHT;
				decelerate,0.2;fadetop,0.2;fadebottom,0.2;zoomtoheight,0;);
	};
};

return t;