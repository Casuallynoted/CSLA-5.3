local t = Def.ActorFrame{
	Def.Quad {
		InitCommand=cmd(FullScreen;);
		OnCommand=cmd(diffuse,color("0,0.3,0.3,0.5");diffusebottomedge,color("0,0.3,0.3,0");linear,0.5;diffusebottomedge,color("0,0.3,0.3,0.8"););
	};
	
	LoadActor( THEME:GetPathB("","_shared models/block4"))..{
		InitCommand=cmd(CenterY;x,SCREEN_LEFT+100;zoomto,500,SCREEN_HEIGHT;customtexturerect,0,0,1,SCREEN_HEIGHT/self:GetHeight();ztest,true);
		OnCommand=cmd(texcoordvelocity,0,0.04;diffuse,color("1,1,1,0.4");diffuserightedge,color("1,1,1,0"););
	};

	Def.ActorFrame{
		InitCommand=cmd(fov,100);
		Def.ActorFrame{
			InitCommand=cmd(x,SCREEN_LEFT+200;y,SCREEN_CENTER_Y+50;zoom,0.8;);
			OnCommand=cmd(diffusealpha,0;addx,-200;addy,200;decelerate,0.4;diffusealpha,1;addx,200;addy,-200;queuecommand,"Repeat";);
			RepeatCommand=cmd(spin;effectmagnitude,0,-10,0;);
			--OffCommand=cmd(accelerate,0.6;addy,-60;zoom,0;);
			LoadActor( THEME:GetPathB("_shared","models/_l_2") )..{
				InitCommand=cmd(blend,'BlendMode_Add';diffusealpha,0.4;);
				OnCommand=cmd(spin;effectmagnitude,-3,4,6;);
			};
		};
	};
	
	LoadActor( THEME:GetPathB("","_logo/full") )..{
		InitCommand=cmd(horizalign,right;shadowlength,2;x,SCREEN_RIGHT-50;y,SCREEN_BOTTOM-50;);
		OnCommand=cmd(zoomx,0.2*10;zoomy,0;diffusealpha,0.6;sleep,0.4;linear,0.1;zoomtoheight,2;decelerate,0.4;zoomx,0.2;decelerate,0.2;zoomy,0.2;);
	};
	
	LoadActor( "danger" )..{
		InitCommand=cmd(horizalign,right;x,SCREEN_RIGHT;y,SCREEN_CENTER_Y;);
		OnCommand=cmd(diffuse,color("1,0,0,0");sleep,50.5;linear,0.5;diffuse,color("1,0,0,0.3");linear,0.5;diffuse,color("1,0,0,0.5");linear,0.5;diffuse,color("1,0,0,0.3");
					linear,0.5;diffuse,color("1,0,0,0.5");linear,0.5;diffuse,color("1,0,0,0.3");linear,0.5;diffuse,color("1,0,0,0.5");linear,0.5;diffuse,color("1,0,0,0.3");
					linear,0.5;diffuse,color("1,0,0,0.5");linear,0.5;diffuse,color("1,0,0,0.3");linear,0.5;diffuse,color("1,0,0,0.5");linear,0.5;diffuse,color("1,0,0,0.3"););
	};
};

return t;