local t = Def.ActorFrame{};

t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(fov,100);
	
	Def.Quad {
		InitCommand=cmd(Center;FullScreen;diffuse,color("0,0.6,1,1");diffusebottomedge,color("0,0.1,0.4,1"););
	};

	Def.ActorFrame{
		InitCommand=cmd(fov,100);
		Def.ActorFrame{
			InitCommand=cmd(x,SCREEN_CENTER_X+320;y,SCREEN_CENTER_Y;rotationy,100;zoomx,0;zoomy,1;);
			OnCommand=function(self)
				self:playcommand("Set");
			end;
			SetCommand=cmd(addx,-10;addy,10;decelerate,0.7;addx,10;addy,-10;rotationy,0;rotationz,100;zoomx,1;);
			LoadActor( THEME:GetPathB("_shared","models/_l_wall1") )..{
				OnCommand=cmd(diffuse,color("1,1,1,0.4");queuecommand,"Repeat";);
				RepeatCommand=cmd(spin;effectmagnitude,0,6,0;);
			};
		};
	};

	Def.Quad {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_TOP+SCREEN_HEIGHT/4;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT/2;diffuse,color("0,0.6,1,1"););
	};		
	Def.Quad {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_BOTTOM-SCREEN_HEIGHT/4;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT/2;diffuse,color("0,0.6,1,1");diffusebottomedge,color("0,0.1,0.4,0"););
	};
	
	Def.ActorFrame{
		InitCommand=cmd(fov,100);
		Def.ActorFrame{
			InitCommand=cmd(x,SCREEN_LEFT+100;y,SCREEN_CENTER_Y+50;rotationx,-120;rotationz,-200;);
			OnCommand=cmd(addx,-400;zoom,0.2;decelerate,0.8;zoom,1.25;rotationx,0;rotationz,0;addx,400;queuecommand,"Repeat";);
			RepeatCommand=function(self)
				if THEME:GetMetric(SCREENMAN:GetTopScreen():GetName(),"OptionScreenType") == 1 then
					(cmd(spin;effectmagnitude,0,10,0;))(self)
				else
					(cmd(spin;effectmagnitude,0,-10,0;))(self)
				end;
			end;
			LoadActor( THEME:GetPathB("_shared","models/_l_2") )..{
				InitCommand=cmd(blend,'BlendMode_Add';diffusealpha,0.4;);
				OnCommand=cmd(spin;effectmagnitude,-3,20,6;);
			};
		};
	};

	LoadActor( THEME:GetPathB("ScreenSelectMusicExtra2","background/_particleLoader") )..{
		InitCommand=cmd(fov,100;x,SCREEN_LEFT+50;y,-SCREEN_CENTER_Y;rotationz,40;rotationy,30;);
	};
};

--over
t[#t+1] = LoadActor( THEME:GetPathB("","_background_parts") )..{
};

t[#t+1] = LoadActor( THEME:GetPathB("","underlay") )..{
};

return t;