local t = Def.BitmapText{
	Font="Common Normal",
	InitCommand=cmd(x,SCREEN_CENTER_X;y,2;diffuse,color("#808080");strokecolor,color("0,0,0,1");shadowlength,0;maxwidth,300;zoom,0.75),
	OnCommand=function(self)
		self:MaskDest();
		self:diffusealpha(0)
		self:decelerate(0.5)
		self:diffusealpha(1)
		-- fancy effect:  Look at the name (which is set by the screen) to set text
		self:settext(
			THEME:GetString("ScreenMapControllers", "Action" .. self:GetName()))
	end,
	OffCommand=cmd(stoptweening;accelerate,0.3;diffusealpha,0;queuecommand,"Hide"),
	HideCommand=cmd(visible,false),
	GainFocusCommand=THEME:GetMetric("ScreenMapControllers", "MappedToGainFocusCommand"),
	LoseFocusCommand=THEME:GetMetric("ScreenMapControllers", "MappedToLoseFocusCommand"),
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
