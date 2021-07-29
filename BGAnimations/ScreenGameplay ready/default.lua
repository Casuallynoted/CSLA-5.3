local t = Def.ActorFrame{
	InitCommand=cmd(sleep,1);

	Def.Quad {
		InitCommand=cmd(Center;zoomtowidth,SCREEN_WIDTH;);
		OnCommand=cmd(diffuse,color("0,0,0,0.8");zoomtoheight,0;sleep,0.7;accelerate,0.1;zoomtoheight,60;sleep,1;
					diffuse,color("0,1,1,0.8");accelerate,0.2;diffuse,color("0,0,0,0.8");zoomtoheight,4;accelerate,0.2;zoomtowidth,0);
	};

	LoadActor( "back" )..{
		OnCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoomx,10;diffusealpha,0;
					sleep,0.4;linear,0.05;diffusealpha,0.6;linear,0.3;zoomx,1;sleep,1.05;linear,0.3;zoomy,3;diffusealpha,0);
	};

	LoadActor( "rea" )..{
		OnCommand=cmd(x,SCREEN_CENTER_X-118;y,SCREEN_CENTER_Y;diffusealpha,0;addx,-60;addy,60;sleep,0.7;linear,0.2;diffusealpha,1;addx,60;addy,-60;
					linear,0.05;glow,color("1,1,0,1");linear,0.05;glow,color("0,0,0,0");sleep,0.7;decelerate,0.2;addx,-60;addy,60;diffuse,color("1,1,0,0"););
	};

	LoadActor( "dyq" )..{
		OnCommand=cmd(x,SCREEN_CENTER_X+118;y,SCREEN_CENTER_Y;diffusealpha,0;addx,60;addy,-60;sleep,0.7;linear,0.2;diffusealpha,1;addx,-60;addy,60;
					linear,0.05;glow,color("1,1,0,1");linear,0.05;glow,color("0,0,0,0");sleep,0.7;decelerate,0.2;addx,60;addy,-60;diffuse,color("1,1,0,0"););
	};

	LoadActor( "back" )..{
		OnCommand=cmd(blend,'BlendMode_Add';x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;
					zoom,3;diffusealpha,0;sleep,1.5;linear,0.1;diffusealpha,0.7;linear,0.3;zoom,2;diffusealpha,0);
	};

};
return t;