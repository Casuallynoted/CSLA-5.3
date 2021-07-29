local t = Def.ActorFrame{};
--GAMESTATE:SetCurrentSong(getenv("csinitialsong"));

--[ja] 20150724修正
t[#t+1] = Def.ActorFrame{
	OnCommand=function(self)
		SOUND:PlayOnce(THEME:GetPathS("","_csopen music"));
	end;
};

t[#t+1] = Def.Quad{
	InitCommand=cmd(Center;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;);
	OnCommand=cmd(diffuse,color("0,0.5,0.5,1");faderight,1;linear,0.4;faderight,0;diffuse,color("0,1,1,1"););
};

t[#t+1] = Def.ActorFrame{
	OnCommand=cmd(addx,-60;decelerate,0.4;addx,60;);
	Def.Quad{
		InitCommand=cmd(FullScreen;diffuse,color("#021113"););
		OnCommand=cmd(faderight,1;decelerate,1;faderight,0;);
	};
	LoadActor(THEME:GetPathB("ScreenCSOpen", "overlay/csc_back"))..{
		InitCommand=function(self)
			local gw = self:GetWidth();
			(cmd(x,SCREEN_RIGHT-(gw/2);y,SCREEN_CENTER_Y;))(self)
		end;
		OnCommand=cmd(diffusealpha,0;faderight,1;decelerate,0.4;diffusealpha,1;faderight,0;);
	};
};

t[#t+1] = Def.ActorFrame{
	Def.Quad{
		OnCommand=cmd(diffuse,color("0,0,0,1");horizalign,right;x,SCREEN_CENTER_X-366;CenterY;zoomto,WideScale(100,260),SCREEN_HEIGHT;
					cropbottom,1;accelerate,0.3;cropbottom,0;);
	};
	LoadActor( THEME:GetPathB("","back_effect/sele") )..{
		OnCommand=cmd(x,SCREEN_CENTER_X-92;CenterY;cropbottom,1;accelerate,0.3;cropbottom,0;);
	};
	
	LoadActor( "csc_title" )..{
		InitCommand=cmd(x,SCREEN_LEFT+170;y,SCREEN_TOP+120;);
		OnCommand=cmd(diffusealpha,0;addx,20;cropright,1;decelerate,0.3;diffusealpha,1;addx,-20;cropright,0;);
	};
};

return t;