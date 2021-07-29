return Def.ActorFrame {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;);
	LoadActor( THEME:GetPathB("","ScreenInstructions_back") )..{
		OnCommand=cmd(diffuse,color("0,0,0,0.6");y,20;zoom,0;fadeleft,0.2;faderight,0.2;
					sleep,0.1;linear,0.1;zoom,1;decelerate,0.3;fadeleft,0;faderight,0;zoomx,1.2;zoomy,2;diffusealpha,0;);
		OffCommand=cmd(finishtweening;);
	};
	LoadActor( THEME:GetPathB("","ScreenInstructions_back") )..{
		OnCommand=cmd(diffusealpha,0.725;zoomy,0;sleep,0.2;decelerate,0.3;zoomy,1;);
		OffCommand=cmd(zoomy,1;sleep,0.2;decelerate,0.2;fadetop,0.2;fadebottom,0.2;zoomy,0.05;linear,0.1;zoomx,3;zoomy,0;);
	};

	Def.ActorFrame {
		InitCommand=cmd(y,-128;);
		LoadActor( "caution1" )..{
			OnCommand=cmd(diffusealpha,0;zoom,1;sleep,0.3;diffusealpha,0.6;linear,1.6;zoom,2;diffusealpha,0;);
		};

		LoadActor( "caution1" )..{
			OnCommand=cmd(diffusealpha,0;zoomx,210;zoomy,4;sleep,0.2;linear,0.1;diffusealpha,1;zoomx,1;zoomy,1;);
			OffCommand=cmd(cropbottom,0;sleep,0.1;accelerate,0.3;cropbottom,1;);
		};
	};

	LoadActor( "caution2" )..{
		OnCommand=cmd(y,28;diffusealpha,0;zoomx,210;zoomy,0.2;sleep,0.3;decelerate,0.2;zoomx,1;zoomy,1;diffusealpha,1;);
		OffCommand=cmd(croptop,0;decelerate,0.3;croptop,1;);
	};
};