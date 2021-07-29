local t = Def.ActorFrame{
	Def.Quad {
		OnCommand=cmd(y,SCREEN_CENTER_Y;diffuse,color("0,0.8,0.8,0");zoomtowidth,320;zoomtoheight,SCREEN_WIDTH;
		linear,0.2;diffuse,color("0,0.8,0.8,0.7");decelerate,2;diffuse,color("0,0.8,0.8,0");zoomtowidth,0);
	};
	Def.Quad {
		OnCommand=cmd(y,SCREEN_CENTER_Y+240;diffuse,color("0.8,0.3,0,0");vertalign,bottom;zoomtowidth,320;zoomtoheight,0;
		linear,0.2;diffuse,color("0.8,0.3,0,0.7");decelerate,1;zoomtoheight,SCREEN_WIDTH;diffuse,color("0.8,0.3,0,0.4");decelerate,1;zoomtowidth,0;diffuse,color("0,0.8,0.8,0"));
	};
	Def.Quad {
		OnCommand=cmd(y,SCREEN_CENTER_Y+240;diffuse,color("0,0.8,1,0");vertalign,bottom;zoomtowidth,0;zoomtoheight,320;
		linear,0.2;diffuse,color("0,0.8,1,0.6");accelerate,0.4;zoomtowidth,0;zoomtoheight,640;linear,0.6;diffusealpha,0);
	};
	Def.Quad {
		OnCommand=cmd(y,SCREEN_CENTER_Y+240;diffuse,color("0.8,0.3,0,0");vertalign,bottom;zoomtowidth,320;zoomtoheight,0;
		linear,0.3;diffuse,color("0.8,0.3,0,0.7");accelerate,1;zoomtoheight,SCREEN_WIDTH;diffuse,color("0.8,0.3,0,0");linear,0.2;zoomtowidth,0);
	};
	Def.Quad {
		OnCommand=cmd(y,SCREEN_CENTER_Y+140;diffuse,color("0.8,0.3,0,0.4");zoomtowidth,0;zoomtoheight,0;sleep,0.2;accelerate,0.15;zoomtowidth,320;
		zoomtoheight,10;linear,1;zoomtoheight,2;diffuse,color("0.8,0.3,0,0");addy,-200);
	};
	Def.Quad {
		OnCommand=cmd(y,SCREEN_CENTER_Y+160;diffuse,color("0,1,1,0.5");zoomtowidth,0;zoomtoheight,0;sleep,0.15;accelerate,0.175;zoomtowidth,320;
		zoomtoheight,32;linear,0.8;zoomtowidth,320;zoomtoheight,6;diffuse,color("0,1,1,0");addy,-380);
	};
	Def.Quad {
		OnCommand=cmd(y,SCREEN_CENTER_Y+152;diffuse,color("0,1,0.9,0.4");zoomtowidth,0;zoomtoheight,0;sleep,0.125;accelerate,0.075;zoomtowidth,320;
		zoomtoheight,12;linear,0.5;zoomtoheight,24;diffuse,color("0,1,0.9,0");addy,-320);
	};
	Def.Quad {
		OnCommand=cmd(y,SCREEN_CENTER_Y+156;diffuse,color("0.8,0.3,0,0.5");zoomtowidth,0;zoomtoheight,0;sleep,0.175;accelerate,0.125;zoomtowidth,320;
		zoomtoheight,10;linear,0.9;zoomtoheight,2;diffuse,color("0.8,0.3,0,0");addy,-260);
	};
	Def.Quad {
		OnCommand=cmd(y,SCREEN_CENTER_Y+240;diffuse,color("0,0.8,0.8,0.7");vertalign,bottom;zoomtowidth,0;zoomtoheight,0;sleep,0.7;zoomtowidth,320;
		decelerate,1;zoomtoheight,SCREEN_WIDTH;diffuse,color("0,0.8,0.8,0");linear,0.2;zoomtowidth,0);
	};
};
return t;