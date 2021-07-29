return Def.ActorFrame {
	InitCommand=cmd(visible,not GAMESTATE:IsDemonstration(););
	LoadActor(THEME:GetPathB("","_delay"),2.5);
--[[
	Def.Quad {
		OnCommand=cmd(diffuse,color("0.2,0.3,1,0");x,SCREEN_CENTER_X;y,SCREEN_TOP+26;zoomtowidth,0;zoomtoheight,0;sleep,0.55;
					diffuse,color("0.2,0.3,1,1");accelerate,0.15;zoomtowidth,SCREEN_WIDTH;accelerate,0.3;zoomtoheight,100;diffusealpha,0);
	};
	
	Def.Quad {
		OnCommand=cmd(blend,'BlendMode_Add';diffuse,color("0.4,0,0.8,0");x,SCREEN_CENTER_X;y,SCREEN_TOP+25;fadetop,0.2;fadebottom,0.2;sleep,0.75;
					diffuse,color("0.4,0,0.8,1");zoomtowidth,SCREEN_WIDTH;zoomtoheight,50;accelerate,0.25;zoomtoheight,0;diffusealpha,0);
	};

	
	Def.Quad {
		OnCommand=cmd(diffuse,color("0.2,0.3,1,0");x,SCREEN_CENTER_X;y,SCREEN_BOTTOM-26;zoomtowidth,0;zoomtoheight,0;sleep,0.55;
					diffuse,color("0.2,0.3,1,1");accelerate,0.15;zoomtowidth,SCREEN_WIDTH;accelerate,0.3;zoomtoheight,100;diffusealpha,0);
	};
	
	Def.Quad {
		OnCommand=cmd(blend,'BlendMode_Add';diffuse,color("0.4,0,0.8,0");x,SCREEN_CENTER_X;y,SCREEN_BOTTOM-25;fadetop,0.2;fadebottom,0.2;sleep,0.75;
					diffuse,color("0.4,0,0.8,1");zoomtowidth,SCREEN_WIDTH;zoomtoheight,50;accelerate,0.25;zoomtoheight,0;diffusealpha,0);
	};
]]
}