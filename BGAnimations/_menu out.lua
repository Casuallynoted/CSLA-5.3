local t = Def.ActorFrame{};

t[#t+1] = Def.ActorFrame{
	--LoadActor(THEME:GetPathB("","_delay"),0.8);

	LoadActor( THEME:GetPathS("","_swoosh" ) )..{
		StartTransitioningCommand=cmd(play);
	};
	
	Def.Quad{
		OnCommand=cmd(FullScreen;Center;diffuse,color("0,0,0");diffusealpha,0;sleep,0.3;linear,0.2;diffusealpha,1;);
	};

	Def.Quad{
		OnCommand=cmd(x,SCREEN_CENTER_X-44;CenterY;rotationz,45;diffuse,color("1,0.5,0,0.7");fadeleft,0.3;faderight,0.3;
					zoomto,0,SCREEN_HEIGHT*2;sleep,0.2;linear,0.2;zoomtowidth,400;);
	};

	Def.Quad{
		OnCommand=cmd(diffuse,color("0,0,0,1");horizalign,right;x,SCREEN_CENTER_X-366-300;CenterY;zoomto,WideScale(100,260),SCREEN_HEIGHT;
					diffusealpha,0.5;accelerate,0.3;x,SCREEN_CENTER_X-366-50;decelerate,0.1;diffusealpha,1;x,SCREEN_CENTER_X-366;);
	};
	Def.Quad{
		OnCommand=cmd(diffuse,color("0,0,0,1");horizalign,left;x,SCREEN_CENTER_X+274+300;CenterY;zoomto,WideScale(100,260),SCREEN_HEIGHT;
					diffusealpha,0.5;accelerate,0.3;x,SCREEN_CENTER_X+274+50;decelerate,0.1;diffusealpha,1;x,SCREEN_CENTER_X+274;);
	};

	LoadActor( THEME:GetPathB("","back_effect/sele") )..{
		OnCommand=cmd(x,SCREEN_CENTER_X-92-300;CenterY;diffusealpha,0.5;accelerate,0.3;
					x,SCREEN_CENTER_X-92-50;decelerate,0.1;diffusealpha,1;x,SCREEN_CENTER_X-92;);
	};
	LoadActor( THEME:GetPathB("","back_effect/sele") )..{
		OnCommand=cmd(rotationz,180;x,SCREEN_CENTER_X+300;CenterY;diffusealpha,0.5;accelerate,0.3;
					x,SCREEN_CENTER_X+50;decelerate,0.1;diffusealpha,1;x,SCREEN_CENTER_X;);
	};

	Def.Quad{
		OnCommand=cmd(horizalign,right;x,SCREEN_CENTER_X-92;CenterY;rotationz,45;blend,'BlendMode_Add';diffuse,color("0,1,1,0.5");
					fadeleft,0.3;faderight,0.3;zoomto,300,SCREEN_HEIGHT*2;linear,0.3;zoomtowidth,0;);
	};

	Def.Quad{
		OnCommand=cmd(horizalign,left;x,SCREEN_CENTER_X;CenterY;rotationz,45;blend,'BlendMode_Add';diffuse,color("0,1,1,0.5");
					fadeleft,0.3;faderight,0.3;zoomto,300,SCREEN_HEIGHT*2;linear,0.3;zoomtowidth,0;);
	};

	LoadActor( THEME:GetPathB("","back_effect/ng6_img" ) )..{
		OnCommand=cmd(horizalign,right;x,WideScale(SCREEN_CENTER_X+300,SCREEN_CENTER_X+390);y,SCREEN_CENTER_Y+120+12;zoomtowidth,SCREEN_WIDTH*0.35;
					diffuse,color("0,1,1");diffusealpha,0;zoom,0.8;addx,15;sleep,0.1;decelerate,0.3;addx,-15;diffusealpha,0.7;);
	};
};
return t;