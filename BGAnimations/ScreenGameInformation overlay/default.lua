
local playMode = GAMESTATE:GetPlayMode();

local t = Def.ActorFrame{
	InitCommand=cmd(fov,100;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;);
	
	Def.ActorFrame{
		OnCommand=cmd(addy,30;rotationx,30;rotationy,90;rotationz,-20;decelerate,0.8;addy,-30;rotationx,0;rotationy,0;rotationz,0;);
		LoadActor( THEME:GetPathB("","ScreenInstructions_back") )..{
			OnCommand=cmd(glow,color("0,0.8,0.8,0.6");zoom,0;fadeleft,0.2;faderight,0.2;
						sleep,0.35;linear,0.1;zoom,1;decelerate,0.3;fadeleft,0;faderight,0;zoomx,1.2;zoomy,2;glow,color("0,0,0,0");diffusealpha,0;);
			OffCommand=cmd(finishtweening;);
		};
		LoadActor( THEME:GetPathB("","ScreenInstructions_back") )..{
			OnCommand=cmd(diffusealpha,0.725;zoomy,0;sleep,0.4;decelerate,0.3;zoomy,1;);
			OffCommand=cmd(finishtweening;);
		};


		LoadActor( "_"..ToEnumShortString(playMode) )..{
			OnCommand=cmd(y,-4;diffusealpha,0;sleep,0.5;decelerate,0.2;diffusealpha,1);
			OffCommand=cmd(finishtweening;);
		};
	};
};

return t;