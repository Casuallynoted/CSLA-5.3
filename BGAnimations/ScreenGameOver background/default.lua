PREFSMAN:SetPreference("AllowExtraStage",GetAdhocPref("envAllowExtraStage"));

local t = Def.ActorFrame {};

t[#t+1] = Def.ActorFrame {
	Def.Quad{
		InitCommand=cmd(FullScreen;);
		OnCommand=cmd(diffuse,color("0,0,0,0");linear,0.5;diffuse,color("0,0.5,0.5,1");linear,3;diffuse,color("0,0,0,0"););
	};

	Def.ActorFrame{
		InitCommand=cmd(fov,170);
		Def.ActorFrame{
			InitCommand=cmd(x,SCREEN_CENTER_X+320;y,SCREEN_CENTER_Y;rotationy,300;zoomx,6;zoomy,6;rotationy,-2;rotationz,100;);
			OnCommand=cmd(accelerate,1;zoomx,0;linear,0.01;diffusealpha,0;);

			LoadActor( THEME:GetPathB("_shared","models/_l_wall1") )..{
				OnCommand=cmd(diffuse,color("0,0.7,0.8,1");queuecommand,"Repeat";);
				RepeatCommand=cmd(spin;effectmagnitude,-40,-20,30;);
			};
		};
	};

	Def.ActorFrame{
		InitCommand=cmd(fov,100);
		Def.ActorFrame{
			InitCommand=cmd(x,SCREEN_RIGHT-400;y,SCREEN_CENTER_Y+50;zoom,0.45;queuecommand,"Repeat";);
			RepeatCommand=cmd(spin;effectmagnitude,0,-10,0;);
			OnCommand=cmd(accelerate,1;addy,-60;zoom,0;);
			LoadActor( THEME:GetPathB("_shared","models/_l_2") )..{
				InitCommand=cmd(blend,'BlendMode_Add';diffuse,color("1,0.5,0,0.4"););
				OnCommand=cmd(spin;effectmagnitude,-16,30,20;);
			};
		};
	};

	Def.Quad {
		InitCommand=cmd(FullScreen;);
		OnCommand=cmd(accelerate,0.5;diffuse,color("0,0.9,1,0.35");diffuserightedge,color("0,0,0,0.35");sleep,0.1;linear,0.7;diffusealpha,0;);
	};

	LoadActor( "gameover" )..{
		OnCommand=cmd(x,SCREEN_RIGHT-10;y,SCREEN_CENTER_Y+93;horizalign,right;vertalign,bottom;glow,color("0,0,0,0");cropleft,1;
					linear,0.5;cropleft,0;glow,color("1,1,0,0.8");linear,0.2;glow,color("0,0,0,0");sleep,1.4;linear,0.5;cropleft,1;diffusealpha,0;);
	};

	LoadActor( "thanks" )..{
		OnCommand=cmd(x,SCREEN_RIGHT-16;y,SCREEN_CENTER_Y+101;horizalign,right;glow,color("0,0,0,0");
					addx,-20;linear,1;addx,20;glow,color("1,0,0,1");linear,0.2;glow,color("0,0,0,0");sleep,0.9;linear,0.5;cropleft,1;diffusealpha,0;);
	};
};

return t;