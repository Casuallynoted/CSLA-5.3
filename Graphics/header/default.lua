--[[header]]

local t = Def.ActorFrame {};

local HTitle = CScreen(Var("LoadingScreen"));
setenv("htitle",HTitle);
--SCREENMAN:SystemMessage(tostring(Var("LoadingScreen")));

-- 1
if tobool(GetAdhocPref("CSLAEasterEggs")) == true and ((HTitle and GetAdhocPref("FrameSet") == "Cs1") or cs1md) then
	t[#t+1] = Def.ActorFrame {
		InitCommand=cmd(playcommand,"Set");
		SetCommand=function(self)
			if getenv("ReloadAnimFlag") == 1 then self:queuecommand("NoAnim");
			else self:queuecommand("Anim");
			end;
		end;
	--left
		LoadActor("1/top_left")..{
			InitCommand=cmd(x,SCREEN_LEFT;y,SCREEN_TOP;horizalign,left;vertalign,top;);
			AnimCommand=cmd(addx,-100;addy,-100;decelerate,0.5;addx,100;addy,100);
			NoAnimCommand=cmd(diffusealpha,1;);
			OffCommand=cmd(finishtweening;);
		};
		
	--_left_title
		Def.Sprite {
			InitCommand=cmd(horizalign,left;x,SCREEN_LEFT+26;y,SCREEN_TOP+18;);
			BeginCommand=function(self)
				local screen = SCREENMAN:GetTopScreen();
				if screen then
					local sclassname = screen:GetName();
					if sclassname ~= "ScreenTextEntry" then
						local HeaderTitle = THEME:GetMetric( sclassname , "HeaderTitle" );
						if HeaderTitle ~= false then
							self:Load(THEME:GetPathG("","_title/1/"..HeaderTitle));
						end;
					else return
					end;
				end;
			end;
			AnimCommand=cmd(croptop,1;sleep,0.5;addx,10;glow,color("0,1,1,1");decelerate,0.3;addx,-10;
						glow,color("0,1,1,1");linear,0.1;croptop,0;linear,0.25;glow,color("0,1,1,0"););
			NoAnimCommand=cmd(cropright,0;diffusealpha,1;);
			OffCommand=cmd(finishtweening;);
		};
		
	--right
		LoadActor("1/top_right")..{
			InitCommand=cmd(x,SCREEN_RIGHT;y,SCREEN_TOP;horizalign,right;vertalign,top;);
			AnimCommand=cmd(addx,100;addy,-100;decelerate,0.5;addx,-100;addy,100);
			NoAnimCommand=cmd(diffusealpha,1;);
			OffCommand=cmd(finishtweening;);
		};

		LoadActor("timeremain")..{
			InitCommand=cmd(x,SCREEN_RIGHT-10;y,SCREEN_TOP+9;horizalign,right;vertalign,top;);
			BeginCommand=function(self)
				if not IsNetConnected() then
					local TimeR = THEME:GetMetric(Var "LoadingScreen","ShowHeaderTimeR");
					self:visible(TimeR);
				else
					self:visible(false);
				end;
			end;
			AnimCommand=cmd(addx,20;diffusealpha,0;sleep,0.3;linear,0.4;addx,-20;diffusealpha,1;queuecommand,"Repeat";);
			NoAnimCommand=cmd(diffusealpha,1;queuecommand,"Repeat";);
			RepeatCommand=cmd(glow,color("0,0,0,0");linear,2;glow,color("1,0.5,0,1");linear,2;glow,color("0,0,0,0");queuecommand,"Repeat";);
			OffCommand=cmd(finishtweening;);
		};
	};

-- 6
elseif tobool(GetAdhocPref("CSLAEasterEggs")) == true and ((HTitle and GetAdhocPref("FrameSet") == "Cs6") or cs6md) then
	t[#t+1] = Def.ActorFrame {
		InitCommand=cmd(playcommand,"Set");
		SetCommand=function(self)
			if getenv("ReloadAnimFlag") == 1 then self:queuecommand("NoAnim");
			else self:queuecommand("Anim");
			end;
		end;
	--left
		LoadActor("6/top_left")..{
			InitCommand=cmd(x,SCREEN_LEFT;y,SCREEN_TOP;horizalign,left;vertalign,top;);
			AnimCommand=cmd(zoomx,210;sleep,0.1;accelerate,0.5;zoomx,1;);
			NoAnimCommand=cmd(diffusealpha,1;);
			OffCommand=cmd(finishtweening;);
		};

		LoadActor("6/top_left")..{
			InitCommand=cmd(x,SCREEN_LEFT;y,SCREEN_TOP;horizalign,left;vertalign,top;);
			AnimCommand=cmd(visible,true;diffusealpha,0;sleep,0.6;diffusealpha,1;decelerate,0.8;addx,16;zoom,1.2;diffusealpha,0;);
			NoAnimCommand=cmd(visible,false;);
			OffCommand=cmd(finishtweening;);
		};


	--_left_title
		Def.Sprite {
			InitCommand=cmd(horizalign,left;x,SCREEN_LEFT+26;y,SCREEN_TOP+23;);
			BeginCommand=function(self)
				local screen = SCREENMAN:GetTopScreen();
				if screen then
					local sclassname = screen:GetName();
					if sclassname ~= "ScreenTextEntry" then
						local HeaderTitle = THEME:GetMetric( sclassname , "HeaderTitle" );
						if HeaderTitle ~= false then
							self:Load(THEME:GetPathG("","_title/6/"..HeaderTitle));
						end;
					else return
					end;
				end;
			end;
			AnimCommand=cmd(cropright,1;diffusealpha,0;sleep,0.2;accelerate,0.6;cropright,0;diffusealpha,1;);
			NoAnimCommand=cmd(cropright,0;diffusealpha,1;);
			OffCommand=cmd(finishtweening;);
		};

	--right	
		Def.ActorFrame {
			InitCommand=function(self)
				local HeaderR = THEME:GetMetric(Var "LoadingScreen","ShowHeaderRight");
				self:visible(HeaderR);
			end;
			LoadActor("6/top_right")..{
				InitCommand=cmd(x,SCREEN_RIGHT;y,SCREEN_TOP;horizalign,right;vertalign,top;);
				AnimCommand=cmd(visible,true;addx,360;zoomy,0;decelerate,0.25;addx,-180;zoomy,0.25;decelerate,0.25;zoomy,1;addx,-180;playcommand,"Repeat";);
				RepeatCommand=cmd(diffuseshift;effectcolor1,color("1,1,1,0.7");effectcolor2,color("1,1,1,1");effectperiod,5;);
				NoAnimCommand=cmd(visible,true;queuecommand,"Repeat";);
				OffCommand=cmd(finishtweening;);
			};
		};

		LoadActor("6/timeremain")..{
			InitCommand=cmd(x,SCREEN_RIGHT-66;y,SCREEN_TOP+10;);
			BeginCommand=function(self)
				if not IsNetConnected() then
					local TimeR = THEME:GetMetric(Var "LoadingScreen","ShowHeaderTimeR");
					self:visible(TimeR);
				else
					self:visible(false);
				end;
			end;
			AnimCommand=cmd(diffusealpha,0;addx,-10;addy,-10;sleep,0.4;linear,0.2;diffusealpha,1;addx,10;addy,10);
			NoAnimCommand=cmd(diffusealpha,1;);
			OffCommand=cmd(finishtweening;);
		};
		
		LoadActor("6/lamp_orange")..{
			InitCommand=cmd(x,SCREEN_LEFT+11.5;y,SCREEN_TOP+25.5;);
			AnimCommand=cmd(addx,-20;sleep,0.4;linear,0.001;addx,20;glowshift;effectcolor1,color("0.5,0,0,0");effectcolor2,color("1,0.8,0,1");effectperiod,1;);
			NoAnimCommand=cmd(diffusealpha,1;glowshift;effectcolor1,color("0.5,0,0,0");effectcolor2,color("1,0.8,0,1");effectperiod,1;);
			OffCommand=cmd(finishtweening;);
		};
		
		LoadActor("6/lamp_cyan")..{
			InitCommand=cmd(x,SCREEN_LEFT+11.5;y,SCREEN_TOP+25.5;);
			AnimCommand=cmd(diffusealpha,0;playcommand,"Repeat";);
			RepeatCommand=cmd(stoptweening;zoom,1;diffusealpha,0;linear,0.1;diffusealpha,1;decelerate,0.6;zoom,3;diffusealpha,0;sleep,9.3;queuecommand,"Repeat";);
			NoAnimCommand=cmd(diffusealpha,0;playcommand,"Repeat";);
			OffCommand=cmd(finishtweening;);
		};
	};

--[[
	LoadFont("Common Normal")..{
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoom,0.75;strokecolor,color("0,0,0,1"););
		OnCommand=function(self)
			if screen then
				local Class = screen:GetName();
				local fallback = THEME:GetMetric( Class , "Fallback" );
				self:settext("failback :"..fallback);
			end;
		end;
	};

	LoadFont("Common Normal")..{
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+20;zoom,0.75;strokecolor,color("0,0,0,1"););
		OnCommand=function(self)
			if screen then
				local Class = screen:GetName();
				self:settext("class :"..Class);
			end;
		end;
	};
]]
else
	t[#t+1] = Def.ActorFrame {
		InitCommand=cmd(playcommand,"Set");
		SetCommand=function(self)
			if getenv("ReloadAnimFlag") == 1 then self:queuecommand("NoAnim");
			else self:queuecommand("Anim");
			end;
		end;
	--left
		LoadActor("top_left")..{
			InitCommand=cmd(x,SCREEN_LEFT;y,SCREEN_TOP;horizalign,left;vertalign,top;);
			AnimCommand=cmd(visible,true;diffusealpha,0.5;glow,color("1,0.5,0,0.5");zoom,1.2;cropright,1;linear,0.5;cropright,0;linear,0.2;diffusealpha,0;glow,color("1,0.5,0,0"););
			NoAnimCommand=cmd(visible,false;);
			OffCommand=cmd(finishtweening;);
		};
		
		LoadActor("top_left")..{
			InitCommand=cmd(x,SCREEN_LEFT;y,SCREEN_TOP;horizalign,left;vertalign,top;);
			AnimCommand=cmd(cropright,1;sleep,0.2;linear,0.4;cropright,0;);
			NoAnimCommand=cmd(diffusealpha,1;);
			OffCommand=cmd(finishtweening;);
		};

		LoadActor("leftlight")..{
			InitCommand=cmd(x,SCREEN_LEFT;y,SCREEN_TOP+4;horizalign,left;vertalign,top;);
			AnimCommand=cmd(addx,60;diffusealpha,0;sleep,0.25;decelerate,0.25;addx,-60;diffusealpha,1;linear,0.3;queuecommand,"Repeat";);
			NoAnimCommand=cmd(zoom,1;diffusealpha,1;linear,0.3;queuecommand,"Repeat";);
			RepeatCommand=cmd(glow,color("0,1,1,0");linear,0.3;glow,color("0,1,1,1");linear,0.3;glow,color("0,1,1,0");linear,0.3;queuecommand,"Repeat2";);
			Repeat2Command=cmd(glow,color("1,0.5,0,0");linear,0.3;glow,color("1,0.5,0,1");linear,0.3;glow,color("1,0.5,0,0");linear,0.3;queuecommand,"Repeat";);
			OffCommand=cmd(finishtweening;);
		};

		LoadActor("cs_mini")..{
			InitCommand=cmd(shadowlength,1;horizalign,left;x,SCREEN_LEFT+66;y,SCREEN_TOP+24;);
			AnimCommand=cmd(addx,-40/2;diffusealpha,0;sleep,0.5;decelerate,0.6;addx,40/2;diffusealpha,1;);
			NoAnimCommand=cmd(diffusealpha,1;);
			OffCommand=cmd(finishtweening;);
		};

	--_left_title
		Def.Sprite {
			InitCommand=cmd(horizalign,left;x,SCREEN_LEFT+64;y,SCREEN_TOP+31;);
			BeginCommand=function(self)
				local screen = SCREENMAN:GetTopScreen();
				if screen then
					local sclassname = screen:GetName();
					if sclassname ~= "ScreenTextEntry" then
						local HeaderTitle = THEME:GetMetric( sclassname , "HeaderTitle" );
						if HeaderTitle ~= false then
							self:Load(THEME:GetPathG("","_title/"..HeaderTitle));
						end;
					else return
					end;
				end;
			end;
			AnimCommand=cmd(cropright,1;diffusealpha,0;sleep,0.2;accelerate,0.6;cropright,0;diffusealpha,1;);
			NoAnimCommand=cmd(cropright,0;diffusealpha,1;);
			OffCommand=cmd(finishtweening;);
		};

	--right	
		Def.ActorFrame {
			InitCommand=function(self)
				local HeaderR = THEME:GetMetric(Var "LoadingScreen","ShowHeaderRight");
				self:visible(HeaderR);
			end;
			LoadActor("top_right")..{
				InitCommand=cmd(x,SCREEN_RIGHT;y,SCREEN_TOP;horizalign,right;vertalign,top;);
				AnimCommand=cmd(visible,true;diffusealpha,0.5;glow,color("1,0.5,0,0.5");zoom,1.2;cropright,1;linear,0.5;cropright,0;linear,0.2;diffusealpha,0;glow,color("1,0.5,0,0"););
				NoAnimCommand=cmd(visible,false;);
				OffCommand=cmd(finishtweening;);
			};

			LoadActor("top_right")..{
				InitCommand=cmd(x,SCREEN_RIGHT;y,SCREEN_TOP;horizalign,right;vertalign,top;);
				AnimCommand=cmd(cropleft,1;sleep,0.2;linear,0.4;cropleft,0;);
				NoAnimCommand=cmd(diffusealpha,1;);
				OffCommand=cmd(finishtweening;);
			};
		};

		LoadActor("timeremain")..{
			InitCommand=cmd(x,SCREEN_RIGHT-10;y,SCREEN_TOP+9;horizalign,right;vertalign,top;);
			BeginCommand=function(self)
				if not IsNetConnected() then
					local TimeR = THEME:GetMetric(Var "LoadingScreen","ShowHeaderTimeR");
					self:visible(TimeR);
				else
					self:visible(false);
				end;
			end;
			AnimCommand=cmd(addx,20;diffusealpha,0;sleep,0.3;linear,0.4;addx,-20;diffusealpha,1;queuecommand,"Repeat";);
			NoAnimCommand=cmd(diffusealpha,1;queuecommand,"Repeat";);
			RepeatCommand=cmd(glow,color("0,0,0,0");linear,2;glow,color("1,0.5,0,1");linear,2;glow,color("0,0,0,0");queuecommand,"Repeat";);
			OffCommand=cmd(finishtweening;);
		};
		
		Def.Quad{
			InitCommand=cmd(zoomto,55,1;rotationz,-45;x,SCREEN_RIGHT-84;y,SCREEN_TOP+10;diffuse,color("1,0.5,0,1");diffuserightedge,color("0,1,1,1");horizalign,right;vertalign,top;);
			BeginCommand=function(self)
				if not IsNetConnected() then
					local TimeR = THEME:GetMetric(Var "LoadingScreen","ShowHeaderTimeR");
					self:visible(TimeR);
				else
					self:visible(false);
				end;
			end;
			AnimCommand=cmd(cropright,1;sleep,1;queuecommand,"Repeat";);
			NoAnimCommand=cmd(cropright,1;queuecommand,"Repeat";);
			RepeatCommand=cmd(cropright,1;linear,1;cropright,0;queuecommand,"Repeat";);
			OffCommand=cmd(finishtweening;);	
		};
		
		Def.Quad{
			InitCommand=cmd(zoomto,55,1;rotationz,135;x,SCREEN_RIGHT-121;y,SCREEN_TOP+50;diffuse,color("1,0.5,0,1");diffuserightedge,color("0,1,1,1");horizalign,right;vertalign,top;);
			BeginCommand=function(self)
				if not IsNetConnected() then
					local TimeR = THEME:GetMetric(Var "LoadingScreen","ShowHeaderTimeR");
					self:visible(TimeR);
				else
					self:visible(false);
				end;
			end;
			AnimCommand=cmd(cropright,1;sleep,1;queuecommand,"Repeat";);
			NoAnimCommand=cmd(cropright,1;queuecommand,"Repeat";);
			RepeatCommand=cmd(cropright,1;linear,1;cropright,0;queuecommand,"Repeat";);
			OffCommand=cmd(finishtweening;);	
		};
	};
end;

return t

