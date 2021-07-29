local t = Def.ActorFrame{};

if bUse3dModels() == 'On' then
	t[#t+1] = Def.ActorFrame{
		InitCommand=cmd(fov,100);
		
		Def.Quad {
			InitCommand=cmd(FullScreen;diffuse,color("0,0.2,0.2,1");diffuserightedge,color("0,0.2,0.3,0.35"););
		};
		
		Def.ActorFrame{
			InitCommand=cmd(Center;zoomy,0.75);
			OnCommand=cmd(rotationy,140;rotationz,-50;);
			Def.ActorFrame{
				OnCommand=cmd(addx,10;addy,-10;rotationz,-100;zoom,0.75;queuecommand,"Repeat1";);
				Repeat1Command=cmd(spin;effectmagnitude,9,0,0;);
				LoadActor( THEME:GetPathB("_shared","models/_l_wall1") )..{
					InitCommand=cmd(blend,'BlendMode_Add';diffuse,color("1,1,1,0.2"););
				};
			};
		};
	};
else
	t[#t+1] = LoadActor( THEME:GetPathB("","_movie/_logo_back") )..{
		InitCommand=cmd(Center;FullScreen;rotationz,180;);
	};
end;

t[#t+1] = Def.Quad {
	InitCommand=cmd(FullScreen;diffuse,color("0,0,0,0");sleep,85;linear,70;diffuse,color("0,0,0,1"););
};

t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(fov,130);
	Def.ActorFrame{
		OnCommand=cmd(x,SCREEN_RIGHT-300;y,SCREEN_CENTER_Y-100;rotationx,-16;rotationz,33;);
		LoadActor(THEME:GetPathB("ScreenSelectMusicCS","background/11"))..{
			InitCommand=cmd(diffusealpha,0.7;zoomto,14,SCREEN_HEIGHT*1.5;customtexturerect,0,0,1,1000/self:GetHeight());
			OnCommand=cmd(texcoordvelocity,0,0.05;);
		};

		LoadActor(THEME:GetPathB("ScreenSelectMusicCS","background/12"))..{
			InitCommand=cmd(x,-6;diffusealpha,0.5;zoomto,14,SCREEN_HEIGHT*1.5;customtexturerect,0,0,1,1000/self:GetHeight());
			OnCommand=cmd(texcoordvelocity,0,0.2;);
		};

		LoadActor(THEME:GetPathB("ScreenSelectMusicCS","background/13"))..{
			InitCommand=cmd(x,30;diffusealpha,0.8;zoomto,14,SCREEN_HEIGHT*1.5;customtexturerect,0,0,1,1000/self:GetHeight());
			OnCommand=cmd(texcoordvelocity,0,-0.15;);
		};
	};
	
	Def.ActorFrame{
		OnCommand=cmd(x,SCREEN_RIGHT-240;y,SCREEN_CENTER_Y-100;rotationx,-16;rotationz,33;);
		LoadActor(THEME:GetPathB("ScreenSelectMusicCS","background/11"))..{
			InitCommand=cmd(diffusealpha,0.7;zoomto,14,SCREEN_HEIGHT*1.5;customtexturerect,0,0,1,1000/self:GetHeight());
			OnCommand=cmd(texcoordvelocity,0,-0.3;);
		};

		LoadActor(THEME:GetPathB("ScreenSelectMusicCS","background/12"))..{
			InitCommand=cmd(x,-10;diffusealpha,0.5;zoomto,14,SCREEN_HEIGHT*1.5;customtexturerect,0,0,1,1000/self:GetHeight());
			OnCommand=cmd(texcoordvelocity,0,-0.15;);
		};

		LoadActor(THEME:GetPathB("ScreenSelectMusicCS","background/13"))..{
			InitCommand=cmd(x,18;diffusealpha,0.8;zoomto,14,SCREEN_HEIGHT*1.5;customtexturerect,0,0,1,1000/self:GetHeight());
			OnCommand=cmd(texcoordvelocity,0,0.1;);
		};
	};
	
	Def.ActorFrame{
		OnCommand=cmd(x,SCREEN_RIGHT-150;y,SCREEN_CENTER_Y-100;rotationx,-16;rotationz,33;);
		LoadActor(THEME:GetPathB("ScreenSelectMusicCS","background/11"))..{
			InitCommand=cmd(x,10;diffusealpha,0.7;zoomto,14,SCREEN_HEIGHT*1.5;customtexturerect,0,0,1,1000/self:GetHeight());
			OnCommand=cmd(texcoordvelocity,0,0.2;);
		};

		LoadActor(THEME:GetPathB("ScreenSelectMusicCS","background/12"))..{
			InitCommand=cmd(diffusealpha,0.5;zoomto,14,SCREEN_HEIGHT*1.5;customtexturerect,0,0,1,1000/self:GetHeight());
			OnCommand=cmd(texcoordvelocity,0,0.15;);
		};

		LoadActor(THEME:GetPathB("ScreenSelectMusicCS","background/13"))..{
			InitCommand=cmd(x,-12;diffusealpha,0.8;zoomto,14,SCREEN_HEIGHT*1.5;customtexturerect,0,0,1,1000/self:GetHeight());
			OnCommand=cmd(texcoordvelocity,0,0.3;);
		};
	};
	
	Def.ActorFrame{
		InitCommand=cmd(x,SCREEN_RIGHT-300;y,SCREEN_BOTTOM-200;rotationx,-30;rotationy,16;rotationz,30;);
		LoadActor(THEME:GetPathB("","_logo/_bg1"))..{
			InitCommand=cmd(shadowlength,40;);
		};
		LoadActor(THEME:GetPathB("","_logo/_bg1"))..{
			InitCommand=cmd(x,-400;y,60;shadowlength,40;fadeleft,0.6;);
		};
	};
	
	LoadActor("tt_movie")..{
		InitCommand=cmd(shadowlength,40;x,SCREEN_RIGHT-300;y,SCREEN_BOTTOM-200;rotationx,-30;rotationy,16;rotationz,30;);
	};
};

return t;