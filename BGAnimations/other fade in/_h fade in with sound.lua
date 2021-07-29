return Def.ActorFrame {

	LoadActor(THEME:GetPathS("","_swoosh.ogg" ))..{
		StartTransitioningCommand=cmd(play);
	};

	Def.Quad{
		InitCommand=cmd(FullScreen);
		OnCommand=cmd(diffuse,color("0.1,0,0.1,1");linear,0.18;diffuse,color("0.1,0,0.1,0"));
	};
	
	Def.Quad{
		OnCommand=cmd(blend,'BlendMode_Add';Center;diffuse,color("0,1,0.85,0.2");zoomtowidth,SCREEN_WIDTH;zoomtoheight,SCREEN_HEIGHT;
				decelerate,0.3;fadetop,0.4;fadebottom,0.4;zoomtoheight,0;);
	};

	Def.Quad{
		OnCommand=cmd(blend,'BlendMode_Add';Center;diffuse,color("0,1,1,0.2");zoomtowidth,SCREEN_WIDTH;zoomtoheight,SCREEN_HEIGHT;
				decelerate,0.2;fadetop,0.2;fadebottom,0.2;zoomtoheight,0;);
	};
}