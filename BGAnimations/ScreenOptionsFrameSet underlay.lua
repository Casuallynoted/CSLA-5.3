local cf_count = split(",",SelectFrameSet());

local t = Def.ActorFrame{
	Def.Quad{
		InitCommand=cmd(x,SCREEN_LEFT;y,SCREEN_CENTER_Y+10;zoomtoheight,SCREEN_HEIGHT*0.7;
					diffuse,color("0,0.6,0.6,0.5");fadetop,0.1;fadebottom,0.1;);
		OnCommand=cmd(horizalign,left;zoomtowidth,0;accelerate,0.3;zoomtowidth,SCREEN_WIDTH;);
	};

	Def.Quad{
		InitCommand=cmd(horizalign,left;x,SCREEN_LEFT;y,SCREEN_CENTER_Y+18;);
		OnCommand=cmd(diffuse,color("1,0.4,0,0.8");fadetop,0.2;fadebottom,0.2;
					zoomtowidth,SCREEN_LEFT+(SCREEN_WIDTH*0.4);zoomtoheight,46;diffuserightedge,color("1,0.4,0,0"));
	};
};
return t;