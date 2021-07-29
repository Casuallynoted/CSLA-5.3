return Def.ActorFrame {
	LoadActor(THEME:GetPathB("","_delay"),0.5);

	LoadActor(THEME:GetPathS("","_swoosh"))..{
		OnCommand=cmd(play);
	};
	
	Def.Quad{
		OnCommand=cmd(Center;diffuse,color("0,0.7,0.7,0.4");zoomtowidth,SCREEN_WIDTH;zoomtoheight,0;fadetop,0.2;fadebottom,0.2;
				decelerate,0.2;fadetop,0;fadebottom,0;zoomtoheight,SCREEN_HEIGHT;linear,0.2;diffuse,color("0,0,0,0"););
	};
	
	Def.Quad{
		OnCommand=cmd(Center;diffuse,color("0,0.7,0.5,0.2");zoomtowidth,SCREEN_WIDTH;zoomtoheight,0;fadetop,0.4;fadebottom,0.4;
				decelerate,0.2;fadetop,0;fadebottom,0;zoomtoheight,SCREEN_HEIGHT;linear,0.2;diffuse,color("0,0,0,0"););
	};

};