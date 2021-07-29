
local t = Def.ActorFrame{};

 t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;);
	LoadActor( THEME:GetPathB("","ScreenInstructions_back") )..{
		OnCommand=cmd(diffuse,color("0,0,0,0.6");y,20;zoom,0;fadeleft,0.2;faderight,0.2;
					sleep,0.1;linear,0.1;zoom,1;decelerate,0.3;fadeleft,0;faderight,0;zoomx,1.2;zoomy,2;diffusealpha,0;);
		OffCommand=cmd(finishtweening;);
	};
	LoadActor( THEME:GetPathB("","ScreenInstructions_back") )..{
		OnCommand=cmd(diffusealpha,0.725;zoomy,0;sleep,0.2;decelerate,0.3;zoomy,1;);
		OffCommand=cmd(zoomy,1;sleep,0.2;decelerate,0.2;fadetop,0.2;fadebottom,0.2;zoomy,0.05;linear,0.1;zoomx,3;zoomy,0;);
	};

	Def.ActorFrame {
		LoadFont("Common Normal") .. {
			InitCommand=cmd(y,-30;maxwidth,800;settext,THEME:GetString("ScreenVersionWarning","WarningText").."\n\n\n"..THEME:GetString("ScreenVersionWarning","HomeText");
						strokecolor,Color("Black"););
			OnCommand=cmd(diffusealpha,0;zoomx,210;zoomy,4;sleep,0.2;linear,0.1;diffusealpha,1;zoomx,0.75;zoomy,0.75;);
			OffCommand=cmd(cropbottom,0;sleep,0.1;accelerate,0.3;cropbottom,1;);
		};
	};
	
	Def.ActorFrame {
		LoadFont("Common Normal") .. {
			InitCommand=cmd(y,100;maxwidth,800;settext,THEME:GetString("ScreenVersionWarning","CurrentVersion").." : "..ProductID().." "..ProductVersion();
						strokecolor,Color("Black"););
			OnCommand=cmd(diffusealpha,0;zoomx,210;zoomy,4;sleep,0.2;linear,0.1;diffusealpha,1;zoomx,0.75;zoomy,0.75;);
			OffCommand=cmd(cropbottom,0;sleep,0.1;accelerate,0.3;cropbottom,1;);
		};
	};
};

return t;