local t = Def.ActorFrame{};

t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(sleep,4);

	LoadActor( "sound_failed" )..{
		StartTransitioningCommand=cmd(play);
	};
	
	Def.Quad{
		OnCommand=cmd(FullScreen;Center;diffuse,color("0,0,0");diffusealpha,0;sleep,0.5;linear,1;diffusealpha,1;);
	};

	Def.Quad{
		OnCommand=cmd(x,SCREEN_CENTER_X-44;CenterY;rotationz,45;diffuse,color("1,0.5,0,0.7");fadeleft,0.3;faderight,0.3;
					zoomto,0,SCREEN_HEIGHT*2;sleep,0.2;linear,0.2;zoomtowidth,400;linear,1;diffuse,color("1,0.25,0,0.5"));
	};

	Def.Quad{
		OnCommand=cmd(diffuse,color("0,0,0,1");horizalign,right;x,SCREEN_CENTER_X-366-300;CenterY;zoomto,WideScale(100,260),SCREEN_HEIGHT;
					diffusealpha,0.5;decelerate,0.4;diffusealpha,1;x,SCREEN_CENTER_X-366;linear,0.1;x,SCREEN_CENTER_X-366-4;linear,0.1;x,SCREEN_CENTER_X-366;);
	};
	Def.Quad{
		OnCommand=cmd(diffuse,color("0,0,0,1");horizalign,left;x,SCREEN_CENTER_X+274+300;CenterY;zoomto,WideScale(100,260),SCREEN_HEIGHT;
					diffusealpha,0.5;decelerate,0.4;diffusealpha,1;x,SCREEN_CENTER_X+274;linear,0.1;x,SCREEN_CENTER_X+274+4;linear,0.1;x,SCREEN_CENTER_X+274;);
	};

	LoadActor( THEME:GetPathB("","back_effect/sele") )..{
		OnCommand=cmd(x,SCREEN_CENTER_X-92-300;CenterY;diffusealpha,0.5;decelerate,0.4;
					diffusealpha,1;x,SCREEN_CENTER_X-92;linear,0.1;x,SCREEN_CENTER_X-92-4;linear,0.1;x,SCREEN_CENTER_X-92;);
	};
	LoadActor( THEME:GetPathB("","back_effect/sele") )..{
		OnCommand=cmd(rotationz,180;x,SCREEN_CENTER_X+300;CenterY;diffusealpha,0.5;decelerate,0.4;
					diffusealpha,1;x,SCREEN_CENTER_X;linear,0.1;x,SCREEN_CENTER_X+4;linear,0.1;x,SCREEN_CENTER_X;);
	};
	
	Def.Quad{
		OnCommand=cmd(horizalign,right;x,SCREEN_CENTER_X-62;CenterY;rotationz,45;blend,'BlendMode_Add';glow,color("1,0.5,0,0.5");
					fadeleft,0.3;faderight,0.3;zoomto,100,SCREEN_HEIGHT*2;linear,0.3;zoomtowidth,0;);
	};

	Def.Quad{
		OnCommand=cmd(horizalign,left;x,SCREEN_CENTER_X-30;CenterY;rotationz,45;blend,'BlendMode_Add';glow,color("1,0.5,0,0.5");
					fadeleft,0.3;faderight,0.3;zoomto,100,SCREEN_HEIGHT*2;linear,0.3;zoomtowidth,0;);
	};

	
	LoadActor( THEME:GetPathB("","back_effect/setline") )..{
		OnCommand=cmd(x,SCREEN_CENTER_X-92-160;CenterY;rotationz,45;diffusealpha,0.5;glow,color("1,1,1,0.2");croptop,1;
					sleep,1;linear,0.3;croptop,0;);
	};
	
	LoadActor( THEME:GetPathB("","back_effect/setline") )..{
		OnCommand=cmd(x,SCREEN_CENTER_X+92+180;CenterY;rotationz,45;diffusealpha,0.5;glow,color("1,1,1,0.2");cropbottom,1;
					sleep,1;linear,0.3;cropbottom,0;);
	};
	
	Def.Quad{
		OnCommand=cmd(horizalign,right;x,SCREEN_RIGHT;CenterY;diffuse,color("1,0.5,0,0");fadetop,0.3;fadebottom,0.3;
					zoomto,0,60;sleep,1;linear,2;diffuse,color("1,0,0,0.3");zoomtowidth,SCREEN_WIDTH;);
	};
	
	Def.Quad{
		OnCommand=cmd(horizalign,left;x,SCREEN_LEFT;CenterY;diffuse,color("1,0.5,0,0");fadetop,0.3;fadebottom,0.3;
					zoomto,0,60;sleep,1;linear,2;diffuse,color("1,0,0,0.3");zoomtowidth,SCREEN_WIDTH;);
	};
	
	Def.ActorFrame{
		OnCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;addx,20;linear,4;addx,-20;);
		LoadActor( "ff" )..{
			OnCommand=cmd(diffuse,color("1,0.5,0,1");diffusealpha,0;zoom,2;sleep,0.75;diffusealpha,1;accelerate,0.5;zoom,1;
						linear,0.05;glow,color("1,1,0,1");linear,0.05;glow,color("0,0,0,0");linear,0.05;glow,color("1,1,0,1");
						linear,0.05;glow,color("0,0,0,0");linear,0.05;diffusealpha,0;);
		};

		LoadActor( "failed" )..{
			OnCommand=cmd(cropleft,1;sleep,0.5;sleep,0.5;decelerate,0.5;cropleft,0;
						sleep,0.5;linear,0.05;glow,color("1,1,0,1");linear,0.05;glow,color("0,0,0,0");linear,0.05;glow,color("1,1,0,1");linear,0.05;glow,color("0,0,0,0"););
		};
	};

	LoadActor( THEME:GetPathB("","_black") )..{
		BeginCommand=cmd(FullScreen;);
		OnCommand=cmd(diffusealpha,0;sleep,2;linear,2;diffusealpha,1;);
	};
};

return t;