local t = Def.ActorFrame{
	InitCommand=cmd(MaskDest;x,SCREEN_CENTER_X;y,10;);
	LoadActor(THEME:GetPathG("OptionRowExit","frame/_triangle"))..{
		--effectdelay,.6;
		InitCommand=cmd(blend,Blend.Add;x,-38;diffuseblink;effectcolor1,color("0.6,0.6,0.6,1");effectperiod,0.4;effectoffset,0.2;effectclock,"beat");
		GainFocusCommand=cmd(stoptweening;linear,0.15;rotationz,-90);
		LoseFocusCommand=cmd(stoptweening;linear,0.15;rotationz,0);
	};
	LoadActor(THEME:GetPathG("OptionRowExit","frame/_triangle"))..{
		--effectdelay,.6;
		InitCommand=cmd(blend,Blend.Add;x,38;diffuseblink;effectcolor1,color("0.6,0.6,0.6,1");effectperiod,0.4;effectoffset,0.2;effectclock,"beat");
		GainFocusCommand=cmd(stoptweening;linear,0.15;rotationz,90);
		LoseFocusCommand=cmd(stoptweening;linear,0.15;rotationz,0);
	};
	LoadActor(THEME:GetPathG("OptionRowExit","frame/moreexit"))..{
		InitCommand=cmd(linear,0.01;y,16;croptop,0.07;cropbottom,0.6);
		GainFocusCommand=cmd(stoptweening;linear,0.15;y,-16;croptop,0.57;cropbottom,0.1);
		LoseFocusCommand=cmd(stoptweening;linear,0.15;y,16;croptop,0.07;cropbottom,0.6);
	};
};

t[#t+1] = Def.ActorFrame {
	Def.Quad{
		Name="TopMask";
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_TOP+62+20;zoomto,SCREEN_WIDTH,66+20;valign,1;MaskSource);
	};

	Def.Quad{
		Name="BottomMask";
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_BOTTOM-54+20;zoomto,SCREEN_WIDTH,60;valign,0;MaskSource);
	};
};

return t