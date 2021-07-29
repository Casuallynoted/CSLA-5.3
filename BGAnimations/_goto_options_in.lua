local t = Def.ActorFrame {
	Def.Quad{
		InitCommand=cmd(diffuse,color("0,0,0,0"););
		ShowPSFOMessageCommand=cmd(stoptweening;Center;diffuse,color("0,1,1,0.4");zoomtowidth,SCREEN_WIDTH;zoomtoheight,0;fadetop,0.2;fadebottom,0.2;
							decelerate,0.2;fadetop,0;fadebottom,0;zoomtoheight,SCREEN_HEIGHT;linear,0.2;diffuse,color("0,0,0,0"););
		ClosePSFOMessageCommand=cmd(stoptweening;linear,0.2;diffuse,color("0,0,0,0");zoomtowidth,SCREEN_WIDTH;zoomtoheight,0;);
	};

	Def.Quad{
		InitCommand=cmd(diffuse,color("0,0,0,0"););
		ShowPSFOMessageCommand=cmd(stoptweening;diffuse,color("0,0,0,0");x,SCREEN_CENTER_X;y,SCREEN_TOP;vertalign,top;zoomtowidth,SCREEN_WIDTH;zoomtoheight,0;
							accelerate,0.2;diffuse,color("0,0,0,1");zoomtowidth,SCREEN_WIDTH;zoomtoheight,SCREEN_HEIGHT/2+10);
		ClosePSFOMessageCommand=cmd(stoptweening;linear,0.2;diffuse,color("0,0,0,0");zoomtowidth,SCREEN_WIDTH;zoomtoheight,0;);
	};

	Def.Quad{
		InitCommand=cmd(diffuse,color("0,0,0,0"););
		ShowPSFOMessageCommand=cmd(stoptweening;diffuse,color("0,0,0,0");x,SCREEN_CENTER_X;y,SCREEN_BOTTOM;vertalign,bottom;zoomtowidth,SCREEN_WIDTH;zoomtoheight,0;
							accelerate,0.2;diffuse,color("0,0,0,1");zoomtowidth,SCREEN_WIDTH;zoomtoheight,SCREEN_HEIGHT/2+10);
		ClosePSFOMessageCommand=cmd(stoptweening;linear,0.2;diffuse,color("0,0,0,0");zoomtowidth,SCREEN_WIDTH;zoomtoheight,0;);
	};
	
	Def.Quad{
		InitCommand=cmd(horizalign,left;x,SCREEN_LEFT;y,SCREEN_CENTER_Y-30;visible,false;pause;diffuse,color("0,0.9,0.8,0");zoomto,SCREEN_WIDTH,2;);
		ShowPressStartForOptionsCommand=cmd(visible,true;stoptweening;diffusealpha,0;sleep,0.19;linear,0.1;diffusealpha,1;linear,1.3;zoomtowidth,0;);
		ShowEnteringOptionsCommand=cmd(stoptweening;linear,0.1;zoomtowidth,0;);
		HidePressStartForOptionsCommand=cmd(stoptweening;linear,0.1;zoomtowidth,0;);
		ShowPSFOMessageCommand=cmd(playcommand,"ShowPressStartForOptions";);
		ShowEOMessageCommand=cmd(playcommand,"ShowEnteringOptions";);
		HidePSFOMessageCommand=cmd(playcommand,"HidePressStartForOptions";);
		ClosePSFOMessageCommand=cmd(horizalign,left;x,SCREEN_LEFT;y,SCREEN_CENTER_Y-30;visible,false;pause;diffuse,color("0,0.9,0.8,0");zoomto,SCREEN_WIDTH,2;);
	};
	
	Def.Quad{
		InitCommand=cmd(horizalign,right;x,SCREEN_RIGHT;y,SCREEN_CENTER_Y+30;visible,false;pause;diffuse,color("0,0.9,0.8,0");zoomto,SCREEN_WIDTH,2;);
		ShowPressStartForOptionsCommand=cmd(visible,true;stoptweening;diffusealpha,0;sleep,0.19;linear,0.1;diffusealpha,1;linear,1.3;zoomtowidth,0;);
		ShowEnteringOptionsCommand=cmd(stoptweening;linear,0.1;zoomtowidth,0;);
		HidePressStartForOptionsCommand=cmd(stoptweening;linear,0.1;zoomtowidth,0;);
		ShowPSFOMessageCommand=cmd(playcommand,"ShowPressStartForOptions";);
		ShowEOMessageCommand=cmd(playcommand,"ShowEnteringOptions";);
		HidePSFOMessageCommand=cmd(playcommand,"HidePressStartForOptions";);
		ClosePSFOMessageCommand=cmd(horizalign,right;x,SCREEN_RIGHT;y,SCREEN_CENTER_Y+30;visible,false;pause;diffuse,color("0,0.9,0.8,0");zoomto,SCREEN_WIDTH,2;);
	};

	LoadFont("_shared2")..{
		InitCommand=cmd(CenterX;y,SCREEN_CENTER_Y-4;visible,false;pause;diffusealpha,0;strokecolor,Color("Black"));
		ShowPressStartForOptionsCommand=cmd(visible,true;stoptweening;diffusealpha,0;zoom,0.8;zoomy,0;
								settext,THEME:GetString("ScreenSelectMusic","Press Start For Options");sleep,0.2;decelerate,0.1;diffusealpha,1;zoomy,0.8;);
		ShowEnteringOptionsCommand=cmd(finishtweening;uppercase,true;settext,THEME:GetString("ScreenSelectMusic","Entering Options");sleep,0.2;linear,0.2;zoomy,0;);
		HidePressStartForOptionsCommand=cmd(stoptweening;linear,0.1;zoomy,0;);
		ShowPSFOMessageCommand=cmd(playcommand,"ShowPressStartForOptions";);
		ShowEOMessageCommand=cmd(playcommand,"ShowEnteringOptions";);
		HidePSFOMessageCommand=cmd(playcommand,"HidePressStartForOptions";);
		ClosePSFOMessageCommand=cmd(stoptweening;);
	};
};

return t;