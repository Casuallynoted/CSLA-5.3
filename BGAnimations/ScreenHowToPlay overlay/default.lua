local t = Def.ActorFrame {};

local px = THEME:GetMetric(Var "LoadingScreen","PlayerX");
local meterwidth = 230;

t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(x,px;y,SCREEN_CENTER_Y-144;);
	--stepzone
	Def.ActorFrame {
		InitCommand=cmd(diffuse,color("0.8,0.4,0,0.8"););
		OnCommand=cmd(zoom,1.2;sleep,6.2;linear,0.6;zoom,1;linear,0.6;zoom,1.2;linear,0.6;zoom,1;linear,0.6;zoom,1.2;);

		LoadActor( "05_circle_half" )..{
			InitCommand=cmd(x,-96-32;);
			OnCommand=cmd(diffusealpha,0;sleep,6;linear,0.2;diffusealpha,0.8;linear,2.2;linear,0.2;diffusealpha,0;);
		};
		
		LoadActor( "06_circle_wide" )..{
			InitCommand=cmd(zoomtowidth,64*3+24;);
			OnCommand=cmd(diffusealpha,0;sleep,6;linear,0.2;diffusealpha,0.8;linear,2.2;linear,0.2;diffusealpha,0;);
		};
		
		LoadActor( "05_circle_half" )..{
			InitCommand=cmd(rotationz,180;x,96+32);
			OnCommand=cmd(diffusealpha,0;sleep,6;linear,0.2;diffusealpha,0.8;linear,2.2;linear,0.2;diffusealpha,0;);
		};
	};

	LoadActor( "01_circle" )..{
		InitCommand=cmd(x,-32;y,128;);
		OnCommand=cmd(diffuse,color("1,1,0,1");diffusealpha,0;sleep,4;zoom,1.4;linear,0.2;diffusealpha,0.8;linear,0.6;zoom,1;linear,0.6;zoom,1.4;linear,0.6;zoom,1;linear,0.6;diffusealpha,0;zoom,1.4;);
	};

	LoadActor( "01_circle" )..{
		InitCommand=cmd(x,-32;);
		OnCommand=cmd(diffuse,color("1,1,0,1");diffusealpha,0;sleep,9;zoom,1.4;linear,0.2;diffusealpha,0.8;linear,0.6;zoom,1;linear,0.6;zoom,1.4;linear,0.6;zoom,1;linear,0.6;diffusealpha,0;zoom,1.4);
	};

	LoadActor( "01_circle" )..{
		InitCommand=cmd(x,32;);
		OnCommand=cmd(diffuse,color("1,1,0,1");diffusealpha,0;sleep,12.5;zoom,1.4;linear,0.2;diffusealpha,0.8;linear,0.6;zoom,1;linear,0.6;zoom,1.4;linear,0.6;zoom,1;linear,0.6;diffusealpha,0;zoom,1.4;);
	};

	LoadActor( "objet" )..{
		InitCommand=cmd(x,-32;y,128+36;);
		OnCommand=cmd(diffusealpha,0;sleep,4;linear,0.2;diffusealpha,1;sleep,1.8;linear,0.6;zoomy,0;diffusealpha,0;);
	};

	LoadActor( "stepzone" )..{
		InitCommand=cmd(y,36;);
		OnCommand=cmd(diffusealpha,0;sleep,6;linear,0.2;diffusealpha,1;sleep,1.8;linear,0.6;zoomy,0;diffusealpha,0;);
	};
	
	LoadActor( "01_circle" )..{
		InitCommand=cmd(x,-96;y,128;);
		OnCommand=cmd(diffuse,color("1,0.5,0,1");diffusealpha,0;sleep,15;zoom,1.4;linear,0.2;diffusealpha,1;linear,0.6;zoom,1;linear,0.6;zoom,1.4;linear,0.6;zoom,1;linear,0.6;diffusealpha,0;zoom,1.4);
	};

	LoadActor( "01_circle" )..{
		InitCommand=cmd(x,96;y,128;);
		OnCommand=cmd(diffuse,color("1,0.5,0,1");diffusealpha,0;sleep,15;zoom,1.4;linear,0.2;diffusealpha,1;linear,0.6;zoom,1;linear,0.6;zoom,1.4;linear,0.6;zoom,1;linear,0.6;diffusealpha,0;zoom,1.4);
	};

	LoadActor( "01_circle" )..{
		InitCommand=cmd(x,-96;);
		OnCommand=cmd(diffuse,color("1,0.5,0,1");diffusealpha,0;sleep,20.15;zoom,2.5;linear,0.1;zoom,1.2;diffusealpha,0.8;sleep,2;linear,0.2;diffusealpha,0;);
	};

	LoadActor( "01_circle" )..{
		InitCommand=cmd(x,96;);
		OnCommand=cmd(diffuse,color("1,0.5,0,1");diffusealpha,0;sleep,20.15;zoom,2.5;linear,0.1;zoom,1.2;diffusealpha,0.8;sleep,2;linear,0.2;diffusealpha,0;);
	};

	LoadActor( "01_circle")..{
		InitCommand=cmd(x,-32;);
		OnCommand=cmd(diffuse,color("1,0.5,0,1");diffusealpha,0;sleep,23.35;zoom,2.5;linear,0.1;zoom,1.2;diffusealpha,0.8;sleep,2;linear,0.2;diffusealpha,0;);
	};

	LoadActor( "01_circle" )..{
		InitCommand=cmd(x,96;);
		OnCommand=cmd(diffuse,color("1,0.5,0,1");diffusealpha,0;sleep,23.35;zoom,2.5;linear,0.1;zoom,1.2;diffusealpha,0.8;sleep,2;linear,0.2;diffusealpha,0;);
	};

	LoadActor( "c_jump" )..{
		InitCommand=cmd(y,36;);
		OnCommand=cmd(diffusealpha,0;sleep,19.15;zoom,2.5;linear,0.1;zoom,1;diffusealpha,1;sleep,3;linear,0.2;diffusealpha,0;zoomy,0;);
	};

	LoadActor( "c_jump" )..{
		InitCommand=cmd(x,32;y,36;);
		OnCommand=cmd(diffusealpha,0;sleep,22.35;zoom,2.5;linear,0.1;zoom,1;diffusealpha,1;sleep,3;linear,0.2;diffusealpha,0;zoomy,0;);
	};
	--hold
	Def.ActorFrame {
		InitCommand=cmd(x,32;y,128+48;rotationz,90;diffuse,color("0,1,0,1"););
		OnCommand=cmd(zoom,1.2;sleep,26;linear,0.6;zoom,1;linear,0.6;zoom,1.2;linear,0.6;zoom,1;linear,0.6;zoom,1.2;);

		LoadActor( "05_circle_half" )..{
			InitCommand=cmd(x,-32-32;);
			OnCommand=cmd(diffusealpha,0;sleep,26;linear,0.2;diffusealpha,0.8;linear,2.2;linear,0.2;diffusealpha,0;);
		};
		
		LoadActor( "06_circle_wide" )..{
			InitCommand=cmd(zoomtowidth,64+24;);
			OnCommand=cmd(diffusealpha,0;sleep,26;linear,0.2;diffusealpha,0.8;linear,2.2;linear,0.2;diffusealpha,0;);
		};
		
		LoadActor( "05_circle_half" )..{
			InitCommand=cmd(rotationz,180;x,32+32);
			OnCommand=cmd(diffusealpha,0;sleep,26;linear,0.2;diffusealpha,0.8;linear,2.2;linear,0.2;diffusealpha,0;);
		};
	};

	LoadActor( "01_circle" )..{
		InitCommand=cmd(x,32;);
		OnCommand=cmd(diffuse,color("0,1,0,1");diffusealpha,0;sleep,29.5;zoom,1.4;linear,0.2;diffusealpha,0.8;linear,0.6;zoom,1;
					linear,0.6;zoom,1.4;linear,0.6;zoom,1;linear,0.6;zoom,1.4;linear,0.6;zoom,1;linear,0.6;diffusealpha,0;zoom,1.4);
	};

	LoadActor( "holdarrow" )..{
		InitCommand=cmd(x,32;y,128+72;);
		OnCommand=cmd(diffusealpha,0;sleep,26;linear,0.2;diffusealpha,1;sleep,1.8;linear,0.6;zoomy,0;diffusealpha,0;);
	};

	--roll
	Def.ActorFrame {
		InitCommand=cmd(x,-32;y,128+48;rotationz,90;diffuse,color("1,0,1,1"););
		OnCommand=cmd(zoom,1.2;sleep,33;linear,0.6;zoom,1;linear,0.6;zoom,1.2;linear,0.6;zoom,1;linear,0.6;zoom,1.2;);

		LoadActor( "05_circle_half" )..{
			InitCommand=cmd(x,-32-32;);
			OnCommand=cmd(diffusealpha,0;sleep,33;linear,0.2;diffusealpha,0.8;linear,2.2;linear,0.2;diffusealpha,0;);
		};
		
		LoadActor( "06_circle_wide" )..{
			InitCommand=cmd(zoomtowidth,64+24;);
			OnCommand=cmd(diffusealpha,0;sleep,33;linear,0.2;diffusealpha,0.8;linear,2.2;linear,0.2;diffusealpha,0;);
		};
		
		LoadActor( "05_circle_half" )..{
			InitCommand=cmd(rotationz,180;x,32+32);
			OnCommand=cmd(diffusealpha,0;sleep,33;linear,0.2;diffusealpha,0.8;linear,2.2;linear,0.2;diffusealpha,0;);
		};
	};

	LoadActor( "01_circle" )..{
		InitCommand=cmd(x,-32;);
		OnCommand=cmd(diffuse,color("1,0,1,1");diffusealpha,0;sleep,36.5;zoom,1.4;linear,0.2;diffusealpha,0.8;linear,0.6;zoom,1;
					linear,0.6;zoom,1.4;linear,0.6;zoom,1;linear,0.6;zoom,1.4;linear,0.6;zoom,1;linear,0.6;diffusealpha,0;zoom,1.4);
	};

	LoadActor( "rollarrow" )..{
		InitCommand=cmd(x,-32;y,128+72;);
		OnCommand=cmd(diffusealpha,0;sleep,33;linear,0.2;diffusealpha,1;sleep,1.8;linear,0.6;zoomy,0;diffusealpha,0;);
	};
	
	--lift
	Def.ActorFrame {
		InitCommand=cmd(y,128;diffuse,color("1,1,1,1"););
		OnCommand=cmd(zoom,1.2;sleep,40.5;linear,0.6;zoom,1;linear,0.6;zoom,1.2;linear,0.6;zoom,1;linear,0.6;zoom,1.2;);

		LoadActor( "05_circle_half" )..{
			InitCommand=cmd(x,-32-32;);
			OnCommand=cmd(diffusealpha,0;sleep,40.5;linear,0.2;diffusealpha,0.8;linear,2.2;linear,0.2;diffusealpha,0;);
		};
		
		LoadActor( "06_circle_wide" )..{
			InitCommand=cmd(zoomtowidth,64+24;);
			OnCommand=cmd(diffusealpha,0;sleep,40.5;linear,0.2;diffusealpha,0.8;linear,2.2;linear,0.2;diffusealpha,0;);
		};
		
		LoadActor( "05_circle_half" )..{
			InitCommand=cmd(rotationz,180;x,32+32);
			OnCommand=cmd(diffusealpha,0;sleep,40.5;linear,0.2;diffusealpha,0.8;linear,2.2;linear,0.2;diffusealpha,0;);
		};
	};

	LoadActor( "c_lift" )..{
		InitCommand=cmd(y,128+36;);
		OnCommand=cmd(diffusealpha,0;sleep,40.5;linear,0.2;diffusealpha,1;sleep,1.8;linear,0.6;diffusealpha,0;zoomy,0);
	};
	
	--mine
	Def.ActorFrame {
		InitCommand=cmd(y,128;diffuse,color("1,0,0,1"););
		OnCommand=cmd(zoom,1.2;sleep,45;linear,0.6;zoom,1;linear,0.6;zoom,1.2;linear,0.6;zoom,1;linear,0.6;zoom,1.2;);

		LoadActor( "05_circle_half" )..{
			InitCommand=cmd(x,-32-32;);
			OnCommand=cmd(diffusealpha,0;sleep,45;linear,0.2;diffusealpha,0.8;linear,2.2;linear,0.2;diffusealpha,0;);
		};
		
		LoadActor( "06_circle_wide" )..{
			InitCommand=cmd(zoomtowidth,64+24;);
			OnCommand=cmd(diffusealpha,0;sleep,45;linear,0.2;diffusealpha,0.8;linear,2.2;linear,0.2;diffusealpha,0;);
		};
		
		LoadActor( "05_circle_half" )..{
			InitCommand=cmd(rotationz,180;x,32+32);
			OnCommand=cmd(diffusealpha,0;sleep,45;linear,0.2;diffusealpha,0.8;linear,2.2;linear,0.2;diffusealpha,0;);
		};
	};

	LoadActor( "c_mine" )..{
		InitCommand=cmd(y,128+36;);
		OnCommand=cmd(diffusealpha,0;sleep,45;linear,0.2;diffusealpha,1;sleep,1.8;linear,0.6;diffusealpha,0;zoomy,0);
	};

	--life
	Def.ActorFrame {
		InitCommand=cmd(x,20;y,-65;diffuse,color("1,0,0,1"););
		OnCommand=cmd(zoom,1.2;sleep,50;linear,0.6;zoom,1;linear,0.6;zoom,1.2;linear,0.6;zoom,1;linear,0.6;zoom,1.2;);

		LoadActor( "life_circle_half" )..{
			InitCommand=cmd(x,-(meterwidth/2););
			OnCommand=cmd(diffusealpha,0;sleep,50;linear,0.2;diffusealpha,0.8;linear,2.2;linear,0.2;diffusealpha,0;);
		};
		
		LoadActor( "life_circle_wide" )..{
			InitCommand=cmd(zoomtowidth,meterwidth-14;);
			OnCommand=cmd(diffusealpha,0;sleep,50;linear,0.2;diffusealpha,0.8;linear,2.2;linear,0.2;diffusealpha,0;);
		};
		
		LoadActor( "life_circle_half" )..{
			InitCommand=cmd(rotationz,180;x,(meterwidth/2););
			OnCommand=cmd(diffusealpha,0;sleep,50;linear,0.2;diffusealpha,0.8;linear,2.2;linear,0.2;diffusealpha,0;);
		};
	};

	LoadActor( "danger" )..{
		InitCommand=cmd(y,140;zoom,1.3;);
		OnCommand=cmd(diffuse,color("1,0,0,0");sleep,50.5;linear,0.5;diffuse,color("1,0,0,1");linear,0.5;diffuse,color("1,0.5,0,0.3");linear,0.5;
				diffuse,color("1,0.5,0,1");linear,0.5;diffuse,color("1,0,0,0.5");linear,0.5;diffuse,color("1,0,0,1");linear,0.5;diffuse,color("1,0.5,0,0.5");linear,0.5;
				diffuse,color("1,0.5,0,1");linear,0.5;diffuse,color("1,0,0,0.5");linear,0.5;diffuse,color("1,0,0,1");linear,0.5;diffuse,color("1,0.5,0,1"));
	};
};


t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(x,SCREEN_CENTER_X-300;y,SCREEN_CENTER_Y+80);
	LoadActor( "feetmessage" )..{
		OnCommand=cmd(horizalign,left;diffusealpha,0;sleep,1;linear,0.2;diffusealpha,1;sleep,2;linear,0.2;diffusealpha,0;);
	};

	LoadActor( "tapmessage1" )..{
		OnCommand=cmd(horizalign,left;diffusealpha,0;sleep,4;linear,0.2;diffusealpha,1;sleep,10;linear,0.2;diffusealpha,0;);
	};

	LoadActor( "jumpmessage" )..{
		OnCommand=cmd(horizalign,left;diffusealpha,0;sleep,15;linear,0.2;diffusealpha,1;sleep,10;linear,0.2;diffusealpha,0;);
	};

	LoadActor( "freezemessage" )..{
		OnCommand=cmd(horizalign,left;diffusealpha,0;sleep,26;linear,0.2;diffusealpha,1;sleep,6;linear,0.2;diffusealpha,0;);
	};
	
	LoadActor( "rollmessage" )..{
		OnCommand=cmd(horizalign,left;diffusealpha,0;sleep,33;linear,0.2;diffusealpha,1;sleep,6;linear,0.2;diffusealpha,0;);
	};

	LoadActor( "liftmessage" )..{
		OnCommand=cmd(horizalign,left;diffusealpha,0;sleep,40.5;linear,0.2;diffusealpha,1;sleep,4;linear,0.2;diffusealpha,0;);
	};
	
	LoadActor( "minesmessage" )..{
		OnCommand=cmd(horizalign,left;diffusealpha,0;sleep,45;linear,0.2;diffusealpha,1;sleep,4;linear,0.2;diffusealpha,0;);
	};

	LoadActor( "missmessage" )..{
		OnCommand=cmd(horizalign,left;diffusealpha,0;sleep,50;linear,0.2;diffusealpha,1;sleep,5;linear,0.2;diffusealpha,0;);
	};
};

t[#t+1] = LoadActor(THEME:GetPathG("ScreenSelectMusic","BannerFrame/".."_bannerback2"))..{
	InitCommand=cmd(horizalign,left;zoomy,-1;x,SCREEN_LEFT-40;y,SCREEN_TOP+46;shadowlength,0;);
	OnCommand=cmd(diffusealpha,0;cropright,1;sleep,0.2;accelerate,0.3;diffusealpha,1;cropright,0;);
};

t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(x,SCREEN_LEFT+200;y,SCREEN_TOP+34;);

	LoadActor("howtoglow")..{
		OnCommand=cmd(zoomy,0;sleep,0.6;decelerate,0.1;zoomy,1;diffuseshift;effectcolor1,color("1,1,1,0");effectcolor2,color("1,1,1,0.75");effectperiod,2);
	};
	LoadActor("howtoplay")..{
		OnCommand=cmd(zoomy,0;sleep,0.6;decelerate,0.1;zoomy,1;diffuseshift;effectcolor1,color("1,1,1,1");effectcolor2,color("1,1,1,0.2");effectperiod,2);
	};
};

return t;