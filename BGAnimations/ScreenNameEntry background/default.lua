--[[ScreenNameEntry background]]

local t = Def.ActorFrame{};

if bUse3dModels() == 'On' then
	t[#t+1] = Def.ActorFrame{
		InitCommand=cmd(fov,100);

		Def.Quad {
			InitCommand=cmd(FullScreen;);
			OnCommand=cmd(diffuse,color("0,0.3,0.3,0.5");diffusebottomedge,color("0,0.3,0.3,0");linear,0.5;diffusebottomedge,color("0,0.3,0.3,0.8"););
		};
		
		Def.ActorFrame{
			InitCommand=cmd(fov,170);
			Def.ActorFrame{
				InitCommand=cmd(x,SCREEN_CENTER_X+320;y,SCREEN_CENTER_Y;rotationy,300;zoomx,6;zoomy,6;rotationy,-2;rotationz,100;);
				--OffCommand=cmd(accelerate,0.5;zoomx,0;diffusealpha,0;);

				LoadActor( THEME:GetPathB("_shared","models/_l_wall1") )..{
					OnCommand=cmd(diffuse,color("0.5,0.5,0.5,1");queuecommand,"Repeat";);
					RepeatCommand=cmd(spin;effectmagnitude,-2,-5,0;);
				};
			};
		};
	};
else
	t[#t+1] = LoadActor( THEME:GetPathB("","_movie/_back_1") )..{
		InitCommand=cmd(Center;FullScreen);
	};
	t[#t+1] = Def.Quad {
		InitCommand=cmd(FullScreen;diffuse,color("0,0.7,0.7,1");diffuserightedge,color("0,0.7,0.7,0.35"););
	};
end;

return t;