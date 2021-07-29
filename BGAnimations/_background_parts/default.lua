--[[_background_parts]]

local t = Def.ActorFrame{};
local song;
local course;
local check = 0;
local cset1 = "0,1,1,0.2";
local cset2 = "0,0.9,1,0.65";
local cset3 = "0,0.7,0.7";
local cset4 = "0.7,0.4,0";
local cset5 = "0,0.7,0.7";

local pm = GAMESTATE:GetPlayMode();
local ssStage;

t[#t+1] = Def.ActorFrame{
	OnCommand=function(self)
		if pm then
			if pm == "PlayMode_Nonstop" then
				cset1 = "0.6,0.6,0,0.2";
				cset2 = "0.6,0.6,0,0.65";
			elseif pm == "PlayMode_Oni" then
				cset1 = "0.4,0,0.6,0.2";
				cset2 = "0.4,0,0.6,0.65";
			elseif pm == "PlayMode_Endless" then
				cset1 = "0.6,0,0.2,0.2";
				cset2 = "0.6,0,0.2,0.65";
			else
				local screen = SCREENMAN:GetTopScreen();
				if screen then
					local HeaderTitle = THEME:GetMetric( screen:GetName() , "HeaderTitle" );
					if HeaderTitle == "Evaluation" or HeaderTitle == "Summary" then 
						ssStage = STATSMAN:GetCurStageStats():GetStage();
					else ssStage = GAMESTATE:GetCurrentStage();
					end;
					--20170617
					if HeaderTitle ~= "Summary" then
						if ssStage == "Stage_Extra1" then
							if getenv("exflag") == "csc" then
								cset2 = "0,0,0,0";
							else
								cset1 = "0,0,0,0.2";
								cset2 = "0,0,0,0.65";
								cset3 = "1,0,0";
								cset5 = "1,0,0";
							end;
						elseif ssStage == "Stage_Extra2" then
							cset1 = "0,0.4,0.4,0.2";
							cset2 = "0,1,1,0.65";
							cset3 = "0,1,1";
							cset5 = "0,1,1";
						end;
					end;
				end;
			end;
		end;
	end;
	Def.Quad {
		InitCommand=cmd(Center;scaletoclipped,SCREEN_WIDTH,SCREEN_HEIGHT-80;queuecommand,"Set";);
		SetCommand=cmd(diffuse,color("0,0,0,0");diffuseleftedge,color(cset1);zoomy,0;decelerate,0.4;zoomy,1;queuecommand,"Repeat1";);
		Repeat1Command=cmd(linear,12;diffuseleftedge,color(cset2);queuecommand,"Repeat2";);
		Repeat2Command=cmd(linear,12;diffuseleftedge,color(cset1);queuecommand,"Repeat1";);
	};

	Def.ActorFrame{
		InitCommand=cmd(x,SCREEN_RIGHT-98-60;y,SCREEN_BOTTOM-96-60;queuecommand,"Set";);
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
	Def.ActorFrame{
		InitCommand=cmd(x,SCREEN_RIGHT-157;y,SCREEN_BOTTOM-185;);

		LoadActor( THEME:GetPathB("","_background_parts/_b_3") )..{
			InitCommand=cmd(diffusetopedge,color("0,0.8,0.75,1");diffusebottomedge,color("0,0.4,0.4,0.4");queuecommand,"Set";);
			SetCommand=cmd(croptop,1;sleep,0.6;decelerate,0.5;croptop,0;);
		};
		
		LoadActor( THEME:GetPathB("","_background_parts/_b_3") )..{
			InitCommand=cmd(queuecommand,"Set";);
			SetCommand=function(self)
				(cmd(croptop,1;sleep,1))(self);
				check = 1;
				if check == 1 and getenv("wheelstop") == 1 then
					self:queuecommand("CurrentSongChanged");
				end;
			end;
			CurrentSongChangedMessageCommand=function(self)
				if check == 1 and getenv("wheelstop") == 1 then
					local cset = "0,0,0"
					song = GAMESTATE:GetCurrentSong();
					course = GAMESTATE:GetCurrentCourse();
					if song or course then
						cset = cset3;
					else cset = cset4;
					end;
					(cmd(stoptweening;diffusealpha,1;glow,color(cset..",1");croptop,1;sleep,0.3;decelerate,0.7;croptop,0;
					linear,0.45;glow,color(cset..",0");diffusealpha,0;sleep,6.25;queuecommand,"CurrentSongChanged";))(self)
				end;
			end;
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
			SetCommand=function(self)
				(cmd(cropbottom,1;sleep,1))(self);
				if check == 1 and getenv("wheelstop") == 1 then
					self:queuecommand("CurrentSongChanged");
				end;
			end;
			CurrentSongChangedMessageCommand=function(self)
				if check == 1 and getenv("wheelstop") == 1 then
					local cset = "0,0,0"
					song = GAMESTATE:GetCurrentSong();
					course = GAMESTATE:GetCurrentCourse();
					if song or course then
						cset = cset3;
					else cset = cset4;
					end;
					(cmd(stoptweening;diffusealpha,1;glow,color(cset..",1");cropbottom,1;sleep,0.1;accelerate,0.6;cropbottom,0;
					linear,0.4;glow,color(cset..",0");diffusealpha,0;sleep,5;queuecommand,"CurrentSongChanged";))(self)
				end;
			end;
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
			SetCommand=function(self)
				(cmd(cropright,1;sleep,1))(self);
				if check == 1 and getenv("wheelstop") == 1 then
					self:queuecommand("CurrentSongChanged");
				end;
			end;
			CurrentSongChangedMessageCommand=function(self)
				if check == 1 and getenv("wheelstop") == 1 then
					local cset = "0,0,0"
					song = GAMESTATE:GetCurrentSong();
					course = GAMESTATE:GetCurrentCourse();
					if song or course then
						cset = cset5;
					else cset = cset4;
					end;
					(cmd(stoptweening;diffusealpha,1;glow,color(cset..",1");cropright,1;sleep,0.35;decelerate,0.4;cropright,0;
					linear,0.45;glow,color(cset..",0");diffusealpha,0;sleep,6.5;queuecommand,"CurrentSongChanged";))(self)
				end;
			end;
		};
	};
	
	Def.ActorFrame{
		InitCommand=cmd(x,SCREEN_LEFT+69;y,SCREEN_TOP+272;);
		OnCommand=function(self)
			local screen = SCREENMAN:GetTopScreen();
			if screen then
				self:visible(THEME:GetMetric(screen:GetName(),"VisibleA"));
			end;
		end;

		LoadActor( THEME:GetPathB("","_background_parts/_access") )..{
			InitCommand=cmd(queuecommand,"Set";);
			SetCommand=cmd(cropright,1;sleep,0.5;linear,0.25;cropright,0;);
		};
		
		LoadActor( THEME:GetPathB("","_background_parts/_access") )..{
			InitCommand=cmd(queuecommand,"Set";);
			SetCommand=function(self)
				(cmd(cropright,1;sleep,0.6;decelerate,0.5;cropright,0;))(self)
				if check == 1 and getenv("wheelstop") == 1 then
					self:queuecommand("CurrentSongChanged");
				end;
			end;
			CurrentSongChangedMessageCommand=function(self)
				if check == 1 and getenv("wheelstop") == 1 then
					(cmd(stoptweening;diffusealpha,1;glow,color("1,1,0,1");cropright,1;sleep,0.1;decelerate,0.2;cropright,0;
					linear,0.25;glow,color("1,1,0,0");diffusealpha,0;sleep,7.15;queuecommand,"CurrentSongChanged";))(self)
				end;
			end;
		};
	};
};

t[#t+1] = Def.ActorFrame{
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