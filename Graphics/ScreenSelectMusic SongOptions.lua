local t = Def.ActorFrame{
	Def.Quad{
		InitCommand=cmd(horizalign,left;x,SCREEN_LEFT;y,-30;visible,false;pause;diffuse,color("0,0.9,0.8,0");zoomto,SCREEN_WIDTH,2;);
		ShowPressStartForOptionsCommand=cmd(visible,true;stoptweening;diffusealpha,0;sleep,0.19;linear,0.1;diffusealpha,1;linear,1.3;zoomtowidth,0;);
		ShowEnteringOptionsCommand=cmd(stoptweening;linear,0.1;zoomtowidth,0;);
		HidePressStartForOptionsCommand=cmd(stoptweening;linear,0.1;zoomtowidth,0;);
	};
	
	Def.Quad{
		InitCommand=cmd(horizalign,right;x,SCREEN_RIGHT;y,30;visible,false;pause;diffuse,color("0,0.9,0.8,0");zoomto,SCREEN_WIDTH,2;);
		ShowPressStartForOptionsCommand=cmd(visible,true;stoptweening;diffusealpha,0;sleep,0.19;linear,0.1;diffusealpha,1;linear,1.3;zoomtowidth,0;);
		ShowEnteringOptionsCommand=cmd(stoptweening;linear,0.1;zoomtowidth,0;);
		HidePressStartForOptionsCommand=cmd(stoptweening;linear,0.1;zoomtowidth,0;);
	};

	LoadFont("_shared2")..{
		InitCommand=cmd(CenterX;y,-4;visible,false;pause;diffusealpha,0);
		ShowPressStartForOptionsCommand=cmd(visible,true;stoptweening;diffusealpha,0;zoom,0.8;zoomy,0;
								settext,THEME:GetString("ScreenSelectMusic","Press Start For Options");sleep,0.2;decelerate,0.1;diffusealpha,1;zoomy,0.8;);
		ShowEnteringOptionsCommand=cmd(finishtweening;uppercase,true;settext,THEME:GetString("ScreenSelectMusic","Entering Options");sleep,0.2;linear,0.2;zoomy,0;);
		HidePressStartForOptionsCommand=cmd(stoptweening;linear,0.1;zoomy,0;);
	};
};

return t;