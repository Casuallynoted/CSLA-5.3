local t = Def.ActorFrame{};

if bUse3dModels() == 'On' then
	t[#t+1] = Def.ActorFrame{
		InitCommand=cmd(fov,130);
		LoadActor( THEME:GetPathB("_shared","models/_l_wall1") )..{
			InitCommand=cmd(x,SCREEN_CENTER_X-300;y,SCREEN_CENTER_Y+50;diffuse,color("1,1,1,0.5");queuecommand,"Set";);
			SetCommand=cmd(addx,-50;addy,100;zoom,2;rotationz,-10;rotationy,200;decelerate,0.6;addx,50;addy,-100;zoom,1;rotationz,200;queuecommand,"Repeat";);
			RepeatCommand=cmd(spin;effectmagnitude,0,8,0;);
		};
	};
	t[#t+1] = Def.ActorFrame{
		InitCommand=cmd(fov,100);
		Def.ActorFrame{
			InitCommand=cmd(x,SCREEN_CENTER_X+80;y,SCREEN_CENTER_Y;queuecommand,"Set";);
			SetCommand=cmd(addx,-50;addy,100;zoom,0.25;decelerate,0.7;addx,50;addy,-100;zoom,1;queuecommand,"Repeat";);
			RepeatCommand=cmd(zoom,1;spin;effectmagnitude,10,2,5;);
			LoadActor( THEME:GetPathB("_shared","models/_l_2") )..{
				InitCommand=cmd(blend,'BlendMode_Add';diffusealpha,0.7;);
			};
		};
	};
else
	t[#t+1] = LoadActor( THEME:GetPathB("","_movie/_default_back") )..{
		InitCommand=cmd(Center;FullScreen);
	};
	t[#t+1] = Def.Quad {
		InitCommand=cmd(FullScreen;diffuse,color("0,0.7,0.7,0.1");diffuserightedge,color("0,0.7,0.7,0.25"););
	};
end;

t[#t+1] = LoadActor( THEME:GetPathB("","_background_parts") )..{
};

t[#t+1] = LoadActor( THEME:GetPathB("","underlay") )..{
};

return t;