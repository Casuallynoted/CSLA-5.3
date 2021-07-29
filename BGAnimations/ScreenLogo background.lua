local t = Def.ActorFrame{};

local waittime = 19.5;

local colortable1 = {
	{"#23CBC4","#269895"},
	{"#64E4DF","#2ACEC7"},
	{"#F7FFFF","#21F9F6"},
	{"#006E6A","#00F3F1"},
	{"#15FFDA","#007F7B"},
	{"#AA4868","#ADAEFF"},
	{"#5F51A1","#A10509"},
	{"#FFFF00","#1CFFE3"},
	{"#23CBC4","#007F7B"},
};

if bUse3dModels() == 'On' then
	t[#t+1] = Def.ActorFrame{
		InitCommand=cmd(fov,100);
		--back
		Def.Quad {
			InitCommand=cmd(FullScreen;diffuse,color("0,0.2,0.2,1");diffuserightedge,color("0,0.2,0.3,0.35");sleep,19.75;accelerate,0.25;
						diffuse,color("0,0.2,0.2,1");diffuserightedge,color("0,0.3,0.2,0.35"));
		};
		
		Def.ActorFrame{
			InitCommand=cmd(fov,100;);
			Def.ActorFrame{
				InitCommand=cmd(Center;zoomy,0.75;zoomy,0;sleep,19.75;accelerate,0.25;zoomy,1;);
				OnCommand=cmd(addx,10;addy,-10;rotationz,-100;zoom,0.75;queuecommand,"Repeat";);
				RepeatCommand=cmd(spin;effectmagnitude,6,0,0;);

				LoadActor( THEME:GetPathB("_shared","models/_l_wall2") )..{
					InitCommand=cmd(blend,'BlendMode_Add';diffuse,color("1,1,1,0.2"););
				};
			};
		};
		
		Def.ActorFrame{
			InitCommand=cmd(fov,100;Center;zoomy,0.75);
			OnCommand=cmd(rotationy,140;rotationz,-50;sleep,19.25;accelerate,0.8;rotationy,0;rotationz,360;sleep,0.1;zoomy,0;diffusealpha,0;);
			Def.ActorFrame{
				OnCommand=cmd(addx,10;addy,-10;rotationz,-100;zoom,0.75;queuecommand,"Repeat1";);
				Repeat1Command=cmd(spin;effectmagnitude,12,0,0;);
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

t[#t+1] = LoadActor( THEME:GetPathB("","_logo/parts") )..{
};

t[#t+1] = Def.Quad{
	OnCommand=cmd(diffuse,color("0,0,0,1");Center;FullScreen;
				sleep,5;linear,0.4;diffuse,color("0,0,0,0"););
};

t[#t+1] = Def.Quad{
	OnCommand=cmd(diffuse,color("0,0,0,0");Center;FullScreen;
				sleep,waittime+0.4;accelerate,0.05;diffuse,color("0,1,1,1");linear,1;diffuse,color("0,1,1,0"););
};
	
t[#t+1] = LoadActor( THEME:GetPathB("","back_effect/sele") )..{
	InitCommand=cmd(x,SCREEN_LEFT+270;CenterY;);
	OnCommand=cmd(diffusealpha,0;linear,0.4;diffusealpha,0.4;sleep,waittime+0.1;linear,0.1;diffusealpha,0;);
};

for i=1,#colortable1 do
	local s_time = 0;
	if i == #colortable1 then
		s_time = 1;
	end;
	t[#t+1] = LoadActor( THEME:GetPathB("","back_effect/setline") )..{
		InitCommand=cmd(x,SCREEN_CENTER_X+26+100;CenterY;);
		OnCommand=function(self)
			(cmd(fadeleft,0.2;faderight,0.2;glow,color(colortable1[i][1].."99");rotationz,45;croptop,1;cropbottom,0;
			sleep,5.5+(1.4*i);accelerate,0.3;croptop,0;sleep,s_time;))(self)
			if i < #colortable1 then
				(cmd(accelerate,0.3;cropbottom,1;))(self)
			else (cmd(accelerate,0.6;zoom,10;rotationz,-90;glow,color("0,0,0,0");diffusealpha,0;addx,100;))(self)
			end;
		end;
	};
	
	t[#t+1] = LoadActor( THEME:GetPathB("","back_effect/setline") )..{
		InitCommand=cmd(x,SCREEN_CENTER_X+80+100;CenterY;);
		OnCommand=function(self)
			(cmd(fadeleft,0.2;faderight,0.2;glow,color(colortable1[i][2].."99");rotationz,45;croptop,0;cropbottom,1;
			sleep,5.5+(1.4*i);accelerate,0.2;cropbottom,0;sleep,0.2;sleep,s_time;))(self)
			if i < #colortable1 then
				(cmd(accelerate,0.2;croptop,1;))(self)
			else (cmd(accelerate,0.6;zoom,10;rotationz,90;glow,color("0,0,0,0");diffusealpha,0;addx,-100;))(self)
			end;
		end;
	};
end;

t[#t+1] = LoadActor( THEME:GetPathB("","_logo/ch" ) )..{
	InitCommand=cmd(x,SCREEN_CENTER_X-62;y,SCREEN_CENTER_Y+12;);
	OnCommand=cmd(addx,-10;diffusealpha,1;cropright,1;sleep,6;accelerate,0.25;cropright,0;addx,10;sleep,11;decelerate,0.25;addx,-10;diffusealpha,0;);
};

t[#t+1] = LoadActor( THEME:GetPathB("","_logo/bc" ) )..{
	InitCommand=cmd(x,SCREEN_CENTER_X-62;y,SCREEN_CENTER_Y+12;);
	OnCommand=cmd(addx,10;diffusealpha,1;cropright,1;sleep,17.5;decelerate,0.25;cropright,0;addx,-10;sleep,1.75;accelerate,0.25;addx,10;diffusealpha,0;);
};

t[#t+1] = LoadActor( THEME:GetPathB("","_logo/next" ) )..{
	InitCommand=cmd(Center;diffusealpha,0;);
	OnCommand=cmd(sleep,1.25;linear,0.25;diffusealpha,1;sleep,1.5;linear,0.25;diffusealpha,0;);
};

t[#t+1] = LoadActor( THEME:GetPathB("","_logo/cst" ) )..{
	InitCommand=cmd(Center;diffusealpha,0;);
	OnCommand=cmd(sleep,3.5;linear,0.25;diffusealpha,1;sleep,1.5;linear,0.25;diffusealpha,0;);
};

t[#t+1] = Def.ActorFrame{
	Def.ActorFrame{
		InitCommand=function(self)
			self:x(SCREEN_CENTER_X+60);
			self:y(SCREEN_CENTER_Y);
		end;
		
		Def.Quad{
			OnCommand=cmd(diffuse,color("0,0,0,0.4");horizalign,left;x,275+200;zoomto,WideScale(100,260),SCREEN_HEIGHT;
						croptop,1;sleep,waittime;linear,0.4;diffusealpha,0.4;accelerate,0.3;croptop,0;);
		};
		
		LoadActor( THEME:GetPathB("","back_effect/sele") )..{
			OnCommand=cmd(x,200;rotationz,180;cropbottom,1;sleep,waittime;linear,0.4;diffusealpha,0.4;accelerate,0.3;cropbottom,0;);
		};
		
		LoadActor(THEME:GetPathB("","_logo/_bg1"))..{
			InitCommand=cmd(x,-70;y,10;);
			OnCommand=cmd(zoom,1;diffusealpha,0;sleep,waittime+0.55;linear,0.1;diffusealpha,1;decelerate,0.1;zoom,1.1;linear,1.6;zoom,1.25;diffusealpha,0;sleep,0.7;zoom,1;sleep,1.95;queuecommand,"Repeat1";);
			Repeat1Command=cmd(diffusealpha,1;decelerate,0.1;zoom,1.1;linear,1.6;zoom,1.25;diffusealpha,0;sleep,0.7;zoom,1;queuecommand,"Repeat2";);
			Repeat2Command=cmd(sleep,4.2;diffusealpha,1;decelerate,0.1;zoom,1.1;linear,1.6;zoom,1.25;diffusealpha,0;sleep,0.7;zoom,1;queuecommand,"Repeat2";);
		};
		LoadActor(THEME:GetPathB("","_logo/_bg1"))..{
			InitCommand=cmd(x,-70;y,10;);
			OnCommand=cmd(glow,color("0,0,0,0");cropleft,1;addx,-30;addy,30;sleep,waittime;sleep,0.3;decelerate,0.5;addx,30;addy,-30;glow,color("1,0.5,0,0.6");cropleft,0;linear,1.6;glow,color("0,0,0,0");queuecommand,"Repeat1";);
			Repeat1Command=cmd(sleep,2.6;decelerate,0.5;glow,color("1,0.5,0,0.6");linear,1.6;glow,color("0,0,0,0");sleep,0.3;queuecommand,"Repeat2";);
			Repeat2Command=cmd(sleep,4.2;decelerate,0.5;glow,color("1,0.5,0,0.6");linear,1.6;glow,color("0,0,0,0");sleep,0.3;queuecommand,"Repeat2";);
		};
		LoadActor(THEME:GetPathB("","_logo/_bg2"))..{
			InitCommand=cmd(x,-72;y,23;);
			OnCommand=cmd(diffusealpha,0;addx,-10;sleep,waittime+0.5;decelerate,0.5;addx,10;diffusealpha,1;);
		};
		LoadActor(THEME:GetPathB("","_logo/_bg3"))..{
			InitCommand=cmd(x,-28;y,36;);
			OnCommand=cmd(croptop,1;addx,-10;sleep,waittime+0.5;decelerate,0.5;addx,10;croptop,0;);
		};
		

		LoadActor(THEME:GetPathB("","_logo/_bg5"))..{
			InitCommand=cmd(x,-300;y,-30;);
			OnCommand=cmd(diffusealpha,0;sleep,waittime;queuecommand,"Repeat";);
			RepeatCommand=cmd(addx,SCREEN_WIDTH*1.5;diffusealpha,0;sleep,5.1;accelerate,0.3;diffusealpha,1;accelerate,0.2;addx,-SCREEN_WIDTH*1.5;diffusealpha,0;sleep,1;queuecommand,"Repeat";);
		};	
		LoadActor(THEME:GetPathB("","_logo/_bg5"))..{
			InitCommand=cmd(x,500;y,-30;);
			OnCommand=cmd(diffusealpha,0;sleep,waittime;queuecommand,"Repeat";);
			RepeatCommand=cmd(addx,SCREEN_WIDTH*1.2;diffusealpha,0;sleep,4.9;accelerate,0.2;diffusealpha,1;accelerate,0.3;addx,-SCREEN_WIDTH*1.2;diffusealpha,0;sleep,1.2;queuecommand,"Repeat";);
		};
		LoadActor(THEME:GetPathB("","_logo/_bg5"))..{
			InitCommand=cmd(x,-100;y,-30;diffusealpha,0.7;);
			OnCommand=cmd(cropleft,1;addx,-10;sleep,waittime+0.5;decelerate,0.5;addx,10;cropleft,0;queuecommand,"Repeat";);
			RepeatCommand=cmd(sleep,4.2;decelerate,0.3;addx,70;cropleft,1;linear,0.6;cropright,1;linear,0.3;addx,-70;cropleft,0;accelerate,0.4;cropright,0;sleep,0.8;queuecommand,"Repeat";);
		};
		LoadActor(THEME:GetPathB("","_logo/_bg4"))..{
			InitCommand=cmd(x,112;y,53;);
			OnCommand=cmd(cropbottom,1;sleep,waittime+0.65;linear,0.2;cropbottom,0;);
		};

		LoadActor(THEME:GetPathB("","_logo/backcs"))..{
			InitCommand=cmd(x,-88;y,-19;);
			OnCommand=cmd(diffusealpha,0;sleep,waittime+0.6;cropbottom,1;decelerate,0.3;cropbottom,0;zoomy,1;diffuse,color("1,1,1,1");sleep,3.8;
						zoom,1.1;diffuse,color("0,0,0,0");cropright,1;linear,0.5;diffuse,color("1,1,1,1");cropright,0;zoom,1;sleep,0.3;queuecommand,"Repeat";);
			RepeatCommand=cmd(diffuse,color("1,1,1,1");sleep,5.8;zoom,1.1;diffuse,color("0,0,0,0");cropright,1;
							linear,0.5;diffuse,color("1,1,1,1");cropright,0;zoom,1;sleep,0.3;queuecommand,"Repeat";);
		};
		
		LoadActor(THEME:GetPathB("","_logo/cl"))..{
			InitCommand=cmd(x,120;y,8;);
			OnCommand=cmd(diffusealpha,0;addx,-10;sleep,waittime+0.5;decelerate,0.5;addx,10;diffusealpha,1;);
		};
		LoadActor(THEME:GetPathB("","_logo/la_title"))..{
			InitCommand=cmd(x,30;y,30;);
			OnCommand=cmd(diffusealpha,0;addx,-10;sleep,waittime+0.5;decelerate,0.5;addx,10;diffusealpha,1;queuecommand,"Repeat";);
			RepeatCommand=cmd(glow,color("1,0,0,1");accelerate,0.6;glow,color("0,0,0,0");sleep,5.7;queuecommand,"Repeat";);
		};
		LoadActor(THEME:GetPathB("","_logo/cslc"))..{
			InitCommand=cmd(x,30;y,48;);
			OnCommand=cmd(cropleft,1;addx,10;sleep,waittime+0.55;decelerate,0.5;addx,-10;cropleft,0;);
		};

		LoadActor(THEME:GetPathB("","_logo/title-cs"))..{
			InitCommand=cmd(x,-174;y,-20;);
			OnCommand=cmd(diffuse,color("0,0,0,0");sleep,waittime+0.6;sleep,4.2;diffuse,color("1,0,0,1");zoom,1;
						linear,0.3;zoom,1.25;diffuse,color("0,0,0,0");sleep,0.1;queuecommand,"Repeat";);
			RepeatCommand=cmd(diffuse,color("0,0,0,0");sleep,6.2;diffuse,color("1,0,0,1");zoom,1;linear,0.3;zoom,1.25;diffuse,color("0,0,0,0");sleep,0.1;queuecommand,"Repeat";);
		};

		LoadActor(THEME:GetPathB("","_logo/title-tyle"))..{
			InitCommand=cmd(x,-12;y,-6.5;);
			OnCommand=cmd(diffuse,color("0,0,0,0");sleep,waittime+0.6;sleep,4.3;diffuse,color("1,0.5,0,1");zoom,1;linear,0.3;diffuse,color("0,0,0,0");queuecommand,"Repeat";);
			RepeatCommand=cmd(diffuse,color("0,0,0,0");sleep,6.3;diffuse,color("1,0.5,0,1");zoom,1;linear,0.3;diffuse,color("0,0,0,0");queuecommand,"Repeat";);
		};
		LoadActor(THEME:GetPathB("","_logo/title-yberia"))..{
			InitCommand=cmd(x,-48;y,-48;);
			OnCommand=cmd(diffuse,color("0,0,0,0");sleep,waittime+0.6;sleep,4.1;diffuse,color("1,0.5,0,1");zoom,1;linear,0.3;diffuse,color("0,0,0,0");sleep,0.2;queuecommand,"Repeat";);
			RepeatCommand=cmd(diffuse,color("0,0,0,0");sleep,6.1;diffuse,color("1,0.5,0,1");zoom,1;linear,0.3;diffuse,color("0,0,0,0");sleep,0.2;queuecommand,"Repeat";);
		};

		LoadActor(THEME:GetPathB("","_logo/wau"))..{
			InitCommand=cmd(x,-88;y,-19;);
			OnCommand=cmd(diffusealpha,0;diffuse,color("0,1,1,1");cropright,1;sleep,waittime;decelerate,0.6;cropright,0;
						linear,1;diffusealpha,0;sleep,3;queuecommand,"Repeat";);
			RepeatCommand=cmd(diffusealpha,0;diffuse,color("0,1,1,1");cropright,1;decelerate,0.6;cropright,0;linear,1;
						diffusealpha,0;sleep,5;queuecommand,"Repeat";);
		};
		LoadActor(THEME:GetPathB("","_logo/title-cybst"))..{
			InitCommand=cmd(x,-88;y,-19;);
			OnCommand=cmd(diffusealpha,0;sleep,waittime+0.3;diffuse,color("0,1,0.7,1");fadetop,1;fadebottom,1;zoom,2;accelerate,0.2;zoom,1;fadetop,0;fadebottom,0;diffusealpha,1;
						linear,1;diffusealpha,0;sleep,3.4;queuecommand,"Repeat";);
			RepeatCommand=cmd(diffuse,color("0,1,0.7,1");fadetop,1;fadebottom,1;zoom,2;accelerate,0.2;zoom,1;fadetop,0;fadebottom,0;diffusealpha,1;
						linear,1;diffusealpha,0;sleep,5.4;queuecommand,"Repeat";);
		};
		LoadActor(THEME:GetPathB("","_logo/title-cs"))..{
			InitCommand=cmd(x,-174;y,-20;);
			OnCommand=cmd(diffuse,color("0,0,0,0");sleep,waittime+0.4;diffuse,color("0,1,1,1");zoom,5;linear,0.1;zoom,1;linear,0.5;diffuse,color("0,0,0,0"););
		};
	};
};

t.OffCommand=cmd(stoptweening;);

return t;