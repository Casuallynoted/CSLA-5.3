local t = Def.ActorFrame{};

if bUse3dModels() == 'On' then
	t[#t+1] = Def.ActorFrame{
		InitCommand=cmd(fov,170);
		Def.ActorFrame{
			InitCommand=cmd(x,SCREEN_CENTER_X+320;y,SCREEN_CENTER_Y;rotationy,30;zoomy,0;zoomx,6;queuecommand,"Set";);
			SetCommand=cmd(decelerate,0.7;rotationy,-2;rotationz,20;zoomy,6;);
			LoadActor( THEME:GetPathB("_shared","models/_l_wall1") )..{
				InitCommand=cmd(diffuse,color("0.5,0.5,0.5,1");queuecommand,"Repeat";);
				RepeatCommand=cmd(spin;effectmagnitude,0,-10,0;);
			};
		};
	};
	
	t[#t+1] = Def.ActorFrame{
		InitCommand=cmd(fov,100);
		Def.ActorFrame{
			InitCommand=cmd(x,SCREEN_RIGHT-400;y,SCREEN_CENTER_Y+50;rotationx,-120;rotationz,-200;queuecommand,"Set";);
			SetCommand=cmd(addx,-400;zoom,8;decelerate,0.6;zoom,0.4;rotationx,0;rotationz,0;addx,400;queuecommand,"Repeat";);
			RepeatCommand=cmd(spin;effectmagnitude,0,-10,0;);
			LoadActor( THEME:GetPathB("_shared","models/_l_1") )..{
				InitCommand=cmd(blend,'BlendMode_Add';diffusealpha,0.4;);
			};
		};
	};
else
	t[#t+1] = LoadActor( THEME:GetPathB("","_movie/_default_back") )..{
		InitCommand=cmd(Center;FullScreen);
	};
	t[#t+1] = Def.Quad {
		InitCommand=cmd(FullScreen;diffuse,color("0.15,0.15,0.15,1");diffuserightedge,color("0.15,0.15,0.15,0.35"););
	};
end;
--under
--etc
t[#t+1] = Def.ActorFrame{
	LoadActor( THEME:GetPathB("","_background_parts") )..{
	};
	LoadActor( THEME:GetPathB("","underlay") )..{
	};
};

return t;