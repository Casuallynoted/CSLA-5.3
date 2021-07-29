return Def.ActorFrame{
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y),
	Def.Quad{
		InitCommand=cmd(zoomto,SCREEN_WIDTH,120;diffuse,Color.Black;diffusealpha,0),
		TweenOnCommand=cmd(stoptweening;diffusealpha,0;linear,0.15;diffusealpha,0.8),
		TweenOffCommand=cmd(stoptweening;linear,0.15;diffusealpha,0),
	},
	Def.ActorFrame{
		Def.BitmapText{
			Font="Common Normal",
			Text=ScreenString("NoSetListPrompt"),
			InitCommand=cmd(y,-4;wrapwidthpixels,SCREEN_WIDTH-48;zoom,0.8;diffusealpha,0),
			TweenOnCommand=cmd(stoptweening;diffusealpha,0;linear,0.175;diffusealpha,1),
			TweenOffCommand=cmd(stoptweening;linear,0.15;diffusealpha,0),
		},
	},
}
