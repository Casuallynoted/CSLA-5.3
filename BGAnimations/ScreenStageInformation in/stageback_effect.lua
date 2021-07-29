local t = Def.ActorFrame{
	Def.Quad{
		OnCommand=cmd(FullScreen;Center;diffuse,color("0,0,0");diffusealpha,1;linear,0.2;diffusealpha,0;);
	};

	Def.Quad{
		OnCommand=cmd(x,SCREEN_CENTER_X-44;CenterY;rotationz,45;diffuse,color("1,0.5,0,0.7");fadeleft,0.3;faderight,0.3;
					zoomto,400,SCREEN_HEIGHT*2;linear,0.5;zoomtowidth,0;diffusealpha,0;);
	};
	Def.Quad{
		OnCommand=cmd(diffuse,color("0,0,0,1");horizalign,right;x,SCREEN_CENTER_X-366;CenterY;zoomto,WideScale(100,260),SCREEN_HEIGHT;
					cropbottom,0;accelerate,0.3;cropbottom,1;);
	};
	Def.Quad{
		OnCommand=cmd(diffuse,color("0,0,0,1");horizalign,left;x,SCREEN_CENTER_X+275;CenterY;zoomto,WideScale(100,260),SCREEN_HEIGHT;
					croptop,0;sleep,0.3;linear,1;diffusealpha,0.7;accelerate,0.3;croptop,1;);
	};
	
	LoadActor( THEME:GetPathB("","back_effect/sele") )..{
		OnCommand=cmd(x,SCREEN_CENTER_X-92;CenterY;cropbottom,0;accelerate,0.3;cropbottom,1;);
	};
	LoadActor( THEME:GetPathB("","back_effect/sele") )..{
		OnCommand=cmd(rotationz,180;x,SCREEN_CENTER_X;CenterY;cropbottom,0;sleep,0.3;linear,1.4-0.4;diffusealpha,0.7;accelerate,0.3;cropbottom,1;);
	};

	Def.Quad{
		OnCommand=cmd(horizalign,right;x,SCREEN_CENTER_X-92;CenterY;rotationz,45;blend,'BlendMode_Add';diffuse,color("0,1,1,0.5");
					fadeleft,0.3;faderight,0.3;zoomto,0,SCREEN_HEIGHT*2;sleep,0.1;linear,0.2;fadeleft,0;zoomtowidth,400;diffusealpha,0;);
	};

	Def.Quad{
		OnCommand=cmd(horizalign,left;x,SCREEN_CENTER_X;CenterY;rotationz,45;blend,'BlendMode_Add';diffuse,color("0,1,1,0.5");
					fadeleft,0.3;faderight,0.3;zoomto,0,SCREEN_HEIGHT*2;sleep,1.7-0.4;sleep,0.1;linear,0.2;faderight,0;zoomtowidth,400;diffusealpha,0;);
	};

	LoadActor( THEME:GetPathB("","back_effect/setline") )..{
		OnCommand=cmd(x,SCREEN_CENTER_X+26;CenterY;rotationz,45;diffusealpha,0.5;glow,color("0,1,1,0.6");croptop,1;
					sleep,3.1-0.8;linear,0.3;croptop,0;linear,0.35;croptop,1;);
	};
	
	Def.Quad{
		OnCommand=cmd(diffuse,color("0,0,0");diffusealpha,0.65;cropbottom,1;vertalign,bottom;CenterX;y,SCREEN_BOTTOM;
					zoomto,416,SCREEN_HEIGHT;sleep,1.9-0.4;linear,0.2;cropbottom,0;sleep,1.25-0.4;linear,0.1;diffusealpha,0;);
	};
	
	Def.Quad{
		OnCommand=cmd(zoomto,0,SCREEN_HEIGHT*3;x,SCREEN_CENTER_X-56;CenterY;croptop,0;rotationz,45;diffuse,color("1,0.6,0,0.5");
					fadeleft,0.025;faderight,0.025;sleep,3.4-0.8;linear,0.1;zoomtowidth,400;linear,0.2;croptop,1;);
	};
	
	Def.Quad{
		OnCommand=cmd(zoomto,0,SCREEN_HEIGHT*3;x,SCREEN_CENTER_X-56;CenterY;cropbottom,0;rotationz,45;diffuse,color("0,1,1,0.5");
					fadeleft,0.025;faderight,0.025;sleep,3.55-0.8;linear,0.1;zoomtowidth,300;linear,0.2;cropbottom,1;);
	};

	LoadActor( THEME:GetPathB("","back_effect/setline") )..{
		OnCommand=cmd(x,SCREEN_CENTER_X+80;CenterY;rotationz,45;diffusealpha,0.7;glow,color("1,0.5,0,0.5");cropbottom,1;
					sleep,2.4;linear,0.3;cropbottom,0;linear,0.35;cropbottom,1;);
	};
--[[	
	LoadActor( THEME:GetPathB("","back_effect/setline" ) )..{
		OnCommand=cmd(x,SCREEN_CENTER_X-320;CenterY;rotationz,45;diffusealpha,0.7;glow,color("0,0,0,0");cropbottom,1;
					sleep,1.9;accelerate,0.3;cropbottom,0;linear,1.2;glow,color("0,1,0.9,0.2");linear,0.25;cropbottom,1;);
	};
	LoadActor( THEME:GetPathB("","back_effect/setline" ) )..{
		OnCommand=cmd(rotationx,180;x,SCREEN_CENTER_X+208;CenterY;rotationz,-45;diffusealpha,0.7;glow,color("0,0,0,0");cropbottom,1;
					sleep,1.9;accelerate,0.3;cropbottom,0;linear,1.2;glow,color("0,1,0.9,0.2");linear,0.25;cropbottom,1;);
	};
]]
};

return t;
