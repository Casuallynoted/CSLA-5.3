local t = Def.ActorFrame{};

t[#t+1] = Def.ActorFrame{
	LoadActor(THEME:GetPathB("","_delay"),0.5);

	LoadActor( THEME:GetPathS("","_swoosh" ) )..{
		StartTransitioningCommand=cmd(play);
	};
};

t[#t+1] = Def.ActorFrame{
	OnCommand=cmd(zoom,1;accelerate,0.5;zoom,1.5;);
	Def.ActorFrame{
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;);
		Def.Quad{
			InitCommand=cmd(FullScreen;diffuse,color("#021113"););
			OnCommand=cmd(linear,0.5;diffusealpha,0;);
		};
		LoadActor(THEME:GetPathB("ScreenCSOpen", "overlay/csc_back"))..{
			InitCommand=function(self)
				local gw = self:GetWidth();
				(cmd(x,SCREEN_RIGHT-(gw/2);y,SCREEN_CENTER_Y;))(self)
			end;
			OnCommand=cmd(linear,0.5;diffusealpha,0;);
		};
	};

	Def.ActorFrame{
		Def.Quad{
			InitCommand=cmd(diffuse,color("0,0,0,1");horizalign,right;x,SCREEN_CENTER_X-366;CenterY;zoomto,WideScale(100,260),SCREEN_HEIGHT;);
			OnCommand=cmd(linear,0.25;diffusealpha,0;);
		};
		LoadActor( THEME:GetPathB("","back_effect/sele" ) )..{
			InitCommand=cmd(x,SCREEN_CENTER_X-92;CenterY;);
			OnCommand=cmd(linear,0.25;diffusealpha,0;);
		};
		
		LoadActor(THEME:GetPathB("ScreenCSOpen", "overlay/csc_title"))..{
			InitCommand=cmd(x,SCREEN_LEFT+170;y,SCREEN_TOP+120;);
			OnCommand=cmd(linear,0.25;diffusealpha,0;);
		};
	};
};

t[#t+1] = Def.ActorFrame{
	OnCommand=cmd(zoom,1;accelerate,0.25;zoom,2;);
	Def.ActorFrame{
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;);
		Def.Quad{
			InitCommand=cmd(zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,color("0,1,1,1"););
			OnCommand=cmd(linear,0.25;diffusealpha,0;);
		};
		LoadActor(THEME:GetPathB("ScreenCSOpen", "overlay/csc_back"))..{
			OnCommand=cmd(linear,0.25;diffusealpha,0;);
		};
	};

	Def.ActorFrame{
		Def.Quad{
			InitCommand=cmd(diffuse,color("0,0,0,1");horizalign,right;x,SCREEN_CENTER_X-366;CenterY;zoomto,WideScale(100,260),SCREEN_HEIGHT;);
			OnCommand=cmd(linear,0.25;diffusealpha,0;);
		};
		LoadActor( THEME:GetPathB("","back_effect/sele") )..{
			InitCommand=cmd(x,SCREEN_CENTER_X-92;CenterY;);
			OnCommand=cmd(linear,0.25;diffusealpha,0;);
		};
		
		LoadActor(THEME:GetPathB("ScreenCSOpen", "overlay/csc_title"))..{
			InitCommand=cmd(x,SCREEN_LEFT+170;y,SCREEN_TOP+120;);
			OnCommand=cmd(linear,0.25;diffusealpha,0;);
		};
	};
};

return t;