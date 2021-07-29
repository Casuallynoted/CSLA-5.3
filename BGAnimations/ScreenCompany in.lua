return Def.ActorFrame {
	LoadActor(THEME:GetPathB("","_delay"),17);

	Def.Quad{
		InitCommand=cmd(FullScreen);
		OnCommand=cmd(diffuse,color("0.1,0,0.1,1");linear,0.18;diffuse,color("0.1,0,0.1,0"));
	};

	Def.Quad{
		OnCommand=cmd(diffuse,color("0,0,0,1");x,SCREEN_LEFT;y,SCREEN_TOP;vertalign,top;horizalign,left;zoomtowidth,SCREEN_WIDTH;zoomtoheight,SCREEN_HEIGHT/2+10;decelerate,0.2;diffuse,color("0.8,0.2,0.4,0");zoomtowidth,0;zoomtoheight,0);
	};

	Def.Quad{
		OnCommand=cmd(diffuse,color("0,0,0,1");x,SCREEN_RIGHT;y,SCREEN_BOTTOM;vertalign,bottom;horizalign,right;zoomtowidth,SCREEN_WIDTH;zoomtoheight,SCREEN_HEIGHT/2+10;decelerate,0.2;diffuse,color("0.8,0.2,0.4,0");zoomtowidth,0;zoomtoheight,0);
	};
}