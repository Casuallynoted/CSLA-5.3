local t = Def.ActorFrame{};

t[#t+1] = Def.ActorFrame{
	Def.Quad{
		OnCommand=cmd(x,SCREEN_CENTER_X-44;CenterY;rotationz,45;diffuse,color("1,0.5,0,0.7");
					fadeleft,0.3;faderight,0.3;zoomto,400,SCREEN_HEIGHT*2;);
	};

	Def.Quad{
		OnCommand=cmd(diffuse,color("0,0,0,1");horizalign,right;x,SCREEN_CENTER_X-366;CenterY;
					zoomto,WideScale(100,260),SCREEN_HEIGHT;);
	};
	Def.Quad{
		OnCommand=cmd(diffuse,color("0,0,0,1");horizalign,left;x,SCREEN_CENTER_X+274;CenterY;
					zoomto,WideScale(100,260),SCREEN_HEIGHT;);
	};

	LoadActor( THEME:GetPathB("","back_effect/sele") )..{
		OnCommand=cmd(x,SCREEN_CENTER_X-92;CenterY;);
	};
	LoadActor( THEME:GetPathB("","back_effect/sele") )..{
		OnCommand=cmd(rotationz,180;x,SCREEN_CENTER_X;CenterY;);
	};

	LoadActor( THEME:GetPathB("","back_effect/ng6_img" ) )..{
		OnCommand=cmd(horizalign,right;x,WideScale(SCREEN_CENTER_X+300,SCREEN_CENTER_X+390);y,SCREEN_CENTER_Y+120+12;
					zoom,0.8;diffuse,color("0,1,1,0.7"););
	};
};

return t;