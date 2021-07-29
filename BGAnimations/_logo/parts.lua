--[[_logo]]

local t = Def.ActorFrame{};
local waittime = 20;
local check = 0;
local cset1 = "0,1,1,0.2";
local cset2 = "0,0.9,1,0.65";
local cset3 = "0,0.7,0.7";
local cset4 = "0.7,0.4,0";
local cset5 = "0,0.7,0.7";

local pm = GAMESTATE:GetPlayMode();
local ssStage;

t[#t+1] = Def.ActorFrame{
	OnCommand=cmd(sleep,waittime;zoomy,0;diffusealpha,0;);
	Def.Quad {
		InitCommand=cmd(Center;scaletoclipped,SCREEN_WIDTH,SCREEN_HEIGHT-80;diffuse,color("0,0,0,0");sleep,20;queuecommand,"Set";);
		SetCommand=cmd(diffuseleftedge,color(cset1);zoomy,0;decelerate,0.4;zoomy,1;queuecommand,"Repeat1";);
		Repeat1Command=cmd(linear,12;diffuseleftedge,color(cset2);queuecommand,"Repeat2";);
		Repeat2Command=cmd(linear,12;diffuseleftedge,color(cset1);queuecommand,"Repeat1";);
	};

	Def.ActorFrame{
		InitCommand=cmd(x,SCREEN_LEFT+98+60;y,SCREEN_TOP+96+60;queuecommand,"Set";);
		SetCommand=cmd(diffusealpha,0;addx,-30;addy,30;sleep,0.2;decelerate,0.6;diffusealpha,1;addx,30;addy,-30;);

		LoadActor( THEME:GetPathB("","_background_parts/_c_2") )..{
			InitCommand=cmd(queuecommand,"Set";);
			SetCommand=cmd(diffuseshift;effectcolor1,color("1,1,1,0.2");effectcolor2,color("1,1,1,0.4");effectperiod,4);
		};
	};
	Def.ActorFrame{
		InitCommand=cmd(x,SCREEN_LEFT+89;y,SCREEN_TOP+85;queuecommand,"Set";);
		SetCommand=cmd(diffusealpha,0;addx,10;addy,-10;sleep,0.2;decelerate,0.6;diffusealpha,1;addx,-10;addy,10;);

		LoadActor( THEME:GetPathB("","_background_parts/_c_1") )..{
			InitCommand=cmd(queuecommand,"Set";);
			SetCommand=cmd(diffuseshift;effectcolor1,color("1,1,1,0.3");effectcolor2,color("1,1,1,0.7");effectperiod,7);
		};
	};
};

t[#t+1] = Def.ActorFrame{
	InitCommand=function(self)
		self:fov(100);
	end;
	OnCommand=cmd(sleep,waittime;zoomy,0;diffusealpha,0;);
	Def.ActorFrame{
		InitCommand=cmd(x,SCREEN_LEFT+247;y,SCREEN_TOP+85;);

		LoadActor( THEME:GetPathB("","_background_parts/_b_3") )..{
			InitCommand=cmd(diffusetopedge,color("0,0.8,0.75,1");diffusebottomedge,color("0,0.4,0.4,0.4");queuecommand,"Set";);
			SetCommand=cmd(croptop,1;sleep,0.6;decelerate,0.5;croptop,0;);
		};
		
		LoadActor( THEME:GetPathB("","_background_parts/_b_3") )..{
			InitCommand=cmd(queuecommand,"Set";);
			SetCommand=cmd(cropright,1;sleep,1;queuecommand,"CC4");
			CC4Command=cmd(stoptweening;diffusealpha,1;glow,color(cset3..",1");croptop,1;sleep,0.3;decelerate,0.7;croptop,0;
						linear,0.45;glow,color(cset3..",0");diffusealpha,0;sleep,6.25;queuecommand,"CC4");
		};
	};
	
	Def.ActorFrame{
		InitCommand=cmd(x,SCREEN_LEFT+137;y,SCREEN_TOP+137;);
		
		LoadActor( THEME:GetPathB("","_background_parts/_b_1") )..{
			InitCommand=cmd(diffusetopedge,color("0,0.8,0.75,1");diffusebottomedge,color("0,0.4,0.4,0.4");queuecommand,"Set";);
			SetCommand=cmd(cropbottom,1;sleep,0.5;decelerate,0.5;cropbottom,0;);
		};

		LoadActor( THEME:GetPathB("","_background_parts/_b_1") )..{
			InitCommand=cmd(queuecommand,"Set";);
			SetCommand=cmd(croptop,1;sleep,3;queuecommand,"CC3");
			CC3Command=cmd(stoptweening;diffusealpha,1;glow,color(cset3..",1");croptop,1;sleep,0.3;decelerate,0.4;croptop,0;
						linear,0.45;glow,color(cset3..",0");diffusealpha,0;sleep,6.5;queuecommand,"CC3");
		};
	};

	Def.ActorFrame{
		InitCommand=cmd(x,SCREEN_LEFT+170;y,SCREEN_TOP+232;);

		LoadActor( THEME:GetPathB("","_background_parts/_b_2") )..{
			InitCommand=cmd(diffusetopedge,color("0,0.8,0.75,1");diffusebottomedge,color("0,0.4,0.4,0.4");queuecommand,"Set";);
			SetCommand=cmd(cropright,1;sleep,0.7;decelerate,0.5;cropright,0;);
		};
		
		LoadActor( THEME:GetPathB("","_background_parts/_b_2") )..{
			InitCommand=cmd(queuecommand,"Set";);
			SetCommand=cmd(cropright,1;sleep,1;queuecommand,"CC2");
			CC2Command=cmd(stoptweening;diffusealpha,1;glow,color(cset3..",1");cropright,1;sleep,0.35;decelerate,0.4;cropright,0;
						linear,0.45;glow,color(cset3..",0");diffusealpha,0;sleep,6.5;queuecommand,"CC2");
		};
	};
	
	Def.ActorFrame{
		InitCommand=cmd(x,SCREEN_LEFT+69;y,SCREEN_TOP+272;);

		LoadActor( THEME:GetPathB("","_background_parts/_access") )..{
			InitCommand=cmd(queuecommand,"Set";);
			SetCommand=cmd(cropright,1;sleep,0.5;linear,0.25;cropright,0;);
		};
		
		LoadActor( THEME:GetPathB("","_background_parts/_access") )..{
			InitCommand=cmd(queuecommand,"Set";);
			SetCommand=function(self)
				(cmd(cropright,1;sleep,0.6;decelerate,0.5;cropright,0;))(self)
				self:queuecommand("CC");
			end;
			CCCommand=cmd(stoptweening;diffusealpha,1;glow,color("1,1,0,1");cropright,1;sleep,4;linear,14.75;cropright,0;
						linear,0.1;glow,color("1,1,0,0");diffusealpha,0;sleep,7.15;queuecommand,"CC6";);
			CC6Command=cmd(stoptweening;diffusealpha,1;glow,color("1,1,0,1");cropright,1;sleep,0.1;decelerate,0.2;cropright,0;
						linear,0.25;glow,color("1,1,0,0");diffusealpha,0;sleep,7.15;queuecommand,"CC6";);
		};
	};
};

t[#t+1] = Def.ActorFrame{
	OnCommand=cmd(sleep,waittime;zoomy,0;diffusealpha,0;);
	Def.ActorFrame{
		InitCommand=cmd(x,SCREEN_RIGHT-98;y,SCREEN_BOTTOM-96;queuecommand,"Set";);
		SetCommand=cmd(diffusealpha,0;addx,-30;addy,30;sleep,0.4;decelerate,0.6;diffusealpha,1;addx,30;addy,-30;);

		LoadActor( THEME:GetPathB("","_background_parts/_c_2") )..{
			InitCommand=cmd(queuecommand,"Set";);
			SetCommand=cmd(diffuseshift;effectcolor1,color("1,1,1,0.1");effectcolor2,color("1,1,1,0.5");effectperiod,6);
		};
	};
	Def.ActorFrame{
		InitCommand=cmd(x,SCREEN_LEFT+89+40;y,SCREEN_TOP+85+40;queuecommand,"Set";);
		SetCommand=cmd(diffusealpha,0;addx,10;addy,-10;sleep,0.4;decelerate,0.6;diffusealpha,1;addx,-10;addy,10;);

		LoadActor( THEME:GetPathB("","_background_parts/_c_1") )..{
			InitCommand=cmd(queuecommand,"Set";);
			SetCommand=cmd(diffuseshift;effectcolor1,color("1,1,1,0.2");effectcolor2,color("1,0,0,0.4");effectperiod,3);
		};
	};
};

return t;