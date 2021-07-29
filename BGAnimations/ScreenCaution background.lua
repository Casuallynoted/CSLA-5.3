local t = Def.ActorFrame{};

if bUse3dModels() == 'On' then
	t[#t+1] = Def.ActorFrame{
		InitCommand=cmd(fov,170);
		Def.ActorFrame{
			InitCommand=cmd(x,SCREEN_CENTER_X+320;y,SCREEN_CENTER_Y;rotationy,300;zoomx,6;zoomy,6;rotationy,-2;rotationz,100;);
			OffCommand=cmd(accelerate,0.5;zoomx,0;linear,0.01;diffusealpha,0;);

			LoadActor( THEME:GetPathB("_shared","models/_l_wall1") )..{
				OnCommand=cmd(diffuse,color("0.5,0.5,0.5,1");queuecommand,"Repeat";);
				RepeatCommand=cmd(spin;effectmagnitude,0,5,0;);
			};
		};
	};

	t[#t+1] = Def.ActorFrame{
		InitCommand=cmd(fov,100);
		Def.ActorFrame{
			InitCommand=cmd(x,SCREEN_RIGHT-400;y,SCREEN_CENTER_Y+50;zoom,0.45;queuecommand,"Repeat";);
			RepeatCommand=cmd(spin;effectmagnitude,0,-10,0;);
			OffCommand=cmd(accelerate,0.6;addy,-60;zoom,0;);
			LoadActor( THEME:GetPathB("_shared","models/_l_1") )..{
				InitCommand=cmd(blend,'BlendMode_Add';diffusealpha,0.4;);
				OnCommand=cmd(spin;effectmagnitude,-3,4,6;);
			};
		};
	};

	t[#t+1] = Def.Quad {
		InitCommand=cmd(FullScreen;);
		OnCommand=cmd(diffuse,color("1,0.1,0.2,0");linear,0.5;diffuse,color("1,0.5,0,0.5"););
		OffCommand=cmd(accelerate,0.5;diffuse,color("0,0.9,1,0.35");diffuserightedge,color("0,0,0,0.35");sleep,0.1;linear,0.2;diffusealpha,0;);
	};
else
	t[#t+1] = LoadActor( THEME:GetPathB("","_movie/_default_back") )..{
		InitCommand=cmd(Center;FullScreen);
	};
	t[#t+1] = Def.Quad {
		InitCommand=cmd(FullScreen;);
		OnCommand=cmd(diffuse,color("1,0.1,0.2,0");linear,0.5;diffuse,color("1,0.5,0,0.5"););
		OffCommand=cmd(accelerate,0.3;diffuse,color("0,1,0.9,0.1");diffuserightedge,color("0,1,0.9,0.2");sleep,0.4;linear,0.2;
					diffuse,color("0,0,0,1");diffuserightedge,color("0,0,0,1"););
	};
end;

return t;