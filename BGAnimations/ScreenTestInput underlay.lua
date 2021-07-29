return Def.ActorFrame {
	--Def.ControllerStateDisplay {
	--	InitCommand=cmd(LoadGameController,
	--};
	Def.DeviceList {
		Font=THEME:GetPathF("Common","Normal");
		InitCommand=cmd(x,SCREEN_LEFT+20;y,SCREEN_TOP+80;strokecolor,color("0,0,0,1");zoom,0.5;halign,0);
	};

	Def.InputList {
		Font=THEME:GetPathF("Common","Normal");
		InitCommand=cmd(x,SCREEN_CENTER_X-250;y,SCREEN_CENTER_Y;strokecolor,color("0,0,0,1");zoom,0.75;halign,0;vertspacing,8);
	};
};
