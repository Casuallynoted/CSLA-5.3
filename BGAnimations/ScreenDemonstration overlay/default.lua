
SnamecolorSet("song");

local t = Def.ActorFrame{
	Def.Quad{
		InitCommand=cmd(vertalign,top;x,SCREEN_CENTER_X;y,SCREEN_TOP;zoomto,SCREEN_WIDTH,40;fadebottom,0.5;diffuse,color("0,1,1,0.3"));
	};
	
	Def.Quad{
		InitCommand=cmd(vertalign,bottom;x,SCREEN_CENTER_X;y,SCREEN_BOTTOM;zoomto,SCREEN_WIDTH,40;fadetop,0.5;diffuse,color("0,1,1,0.3"));
	};

	LoadActor(THEME:GetPathG("ScreenSelectMusic","BannerFrame/_bannerback2"))..{
		InitCommand=cmd(horizalign,left;zoomy,-1;x,SCREEN_LEFT-40;y,SCREEN_TOP+46;shadowlength,0;);
		OnCommand=cmd(diffusealpha,0;cropright,1;sleep,0.2;accelerate,0.3;diffusealpha,1;cropright,0;);
	};

	Def.ActorFrame{
		InitCommand=cmd(x,SCREEN_LEFT+200;y,SCREEN_TOP+34;);

		LoadActor("demoglow")..{
			OnCommand=cmd(zoomy,0;sleep,0.6;decelerate,0.1;zoomy,1;diffuseshift;effectcolor1,color("1,1,1,0");effectcolor2,color("1,1,1,0.75");effectperiod,2);
		};
		LoadActor("demonstration")..{
			OnCommand=cmd(zoomy,0;sleep,0.6;decelerate,0.1;zoomy,1;diffuseshift;effectcolor1,color("1,1,1,1");effectcolor2,color("1,1,1,0.2");effectperiod,2);
		};
	};

	LoadActor(THEME:GetPathB("ScreenJukeBox","overlay"))..{
	};
};


return t;