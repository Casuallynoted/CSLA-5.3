--[[ScreenSelectMusic BannerFrame]]
local coursemode = GAMESTATE:IsCourseMode();
local t = Def.ActorFrame{};

local bpm_coordinate = {-162,-151};
local glowcolor = {"0.6,0.3,0,0.45","0.6,0.3,0,0"};
if getenv("exflag") == "csc" then
	bpm_coordinate = {-152,-66};
	glowcolor = {"0,0.9,0.8,0.3","0,0.9,0.8,0"};
end;

if not IsNetConnected() then
	t[#t+1] = Def.Sprite{
		OnCommand=function(self)
			if coursemode then
				self:Load(THEME:GetPathG("ScreenSelectMusic","BannerFrame/musicnumframe"));
				self:x(math.max(WideScale(SCREEN_CENTER_X-146,SCREEN_CENTER_X-226),SCREEN_CENTER_X-226));
				self:y(SCREEN_CENTER_Y-144);
			else
				self:Load(THEME:GetPathG("ScreenSelectMusic","BannerFrame/stageframe"));
				self:x(SCREEN_CENTER_X+180);
				self:y(SCREEN_CENTER_Y-168);
			end;
			if getenv("ReloadAnimFlag") == 1 then self:playcommand("NoAnim");
			else self:playcommand("Anim");
			end;
		end;
		AnimCommand=cmd(cropleft,1;addx,15;sleep,0.4;accelerate,0.4;addx,-15;cropleft,0;
			glow,color("1,0.5,0,0");linear,0.05;glow,color("1,0.5,0,1");decelerate,0.4;glow,color("1,0.5,0,0");queuecommand,"Repeat";);
		RepeatCommand=cmd(sleep,19.5;diffusealpha,1;glow,color("1,0.5,0,0");linear,0.05;glow,color("1,0.5,0,0.5");decelerate,1;glow,color("1,0.5,0,0");queuecommand,"Repeat";);
		OffCommand=cmd(stoptweening;);
	};
end;

if getenv("exflag") == "csc" then
	t[#t+1] = LoadActor("fpointframe")..{
		InitCommand=cmd(x,SCREEN_CENTER_X-146;y,SCREEN_CENTER_Y-110;);
		OnCommand=cmd(diffusealpha,0;zoom,2;addx,15;addy,15;sleep,0.7;accelerate,0.4;addx,-15;addy,-15;diffusealpha,1;zoom,1;
					glow,color("1,0.5,0,0");linear,0.05;glow,color("1,0.5,0,1");decelerate,0.4;glow,color("1,0.5,0,0");queuecommand,"Repeat";);
		RepeatCommand=cmd(sleep,19.5;diffusealpha,1;glow,color("1,0.5,0,0");linear,0.05;glow,color("1,0.5,0,0.5");decelerate,1;glow,color("1,0.5,0,0");queuecommand,"Repeat";);
		OffCommand=cmd(stoptweening;);
	};
end;

if coursemode then
	t[#t+1] = LoadActor("songinfoframe")..{
		InitCommand=cmd(x,math.min(WideScale(SCREEN_CENTER_X+114,SCREEN_CENTER_X+254),SCREEN_CENTER_X+254);y,SCREEN_CENTER_Y-148;);
		OnCommand=cmd(diffusealpha,0;zoom,2;addx,15;addy,15;sleep,0.7;accelerate,0.4;addx,-15;addy,-15;diffusealpha,1;zoom,1;
					glow,color("1,0.5,0,0");linear,0.05;glow,color("1,0.5,0,1");decelerate,0.4;glow,color("1,0.5,0,0");queuecommand,"Repeat";);
		RepeatCommand=cmd(sleep,19.5;diffusealpha,1;glow,color("1,0.5,0,0");linear,0.05;glow,color("1,0.5,0,0.5");decelerate,1;glow,color("1,0.5,0,0");queuecommand,"Repeat";);
		OffCommand=cmd(stoptweening;);
	};
else
	t[#t+1] = Def.ActorFrame{
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;);
		LoadActor("sortframe")..{
			InitCommand=function(self)
				(cmd(visible,true;x,204;y,-136;))(self)
				if getenv("exflag") == "csc" then self:visible(false);
				end;
			end;
			OnCommand=function(self)
				if getenv("ReloadAnimFlag") == 1 then self:playcommand("NoAnim");
				else self:playcommand("Anim");
				end;
			end;
			AnimCommand=cmd(cropright,1;addx,25;sleep,0.5;accelerate,0.4;addx,-25;cropright,0;
						glow,color("1,0.5,0,0");linear,0.05;glow,color("1,0.5,0,1");decelerate,0.4;glow,color("1,0.5,0,0");queuecommand,"Repeat";);
			NoAnimCommand=cmd(diffusealpha,1;zoom,1;queuecommand,"Repeat";);
			RepeatCommand=cmd(sleep,20.5;diffusealpha,1;glow,color("1,0.5,0,0");linear,0.05;glow,color("1,0.5,0,0.5");decelerate,1;glow,color("1,0.5,0,0");queuecommand,"Repeat";);
			OffCommand=cmd(stoptweening;);
		};
		
		LoadActor("musicsonginfoframe")..{
			InitCommand=function(self)
				if getenv("exflag") == "csc" then
					self:x(-122-70);
					self:y(-35);
				else
					self:x(-122-80);
					self:y(-35-95);
				end;
			end;
			OnCommand=function(self)
				if getenv("ReloadAnimFlag") == 1 then self:playcommand("NoAnim");
				else self:playcommand("Anim");
				end;
			end;
			AnimCommand=cmd(cropleft,1;addx,30;sleep,0.4;accelerate,0.4;addx,-30;cropleft,0;
						glow,color("1,0.5,0,0");linear,0.05;glow,color("1,0.5,0,1");decelerate,0.4;glow,color("1,0.5,0,0");queuecommand,"Repeat";);
			NoAnimCommand=cmd(visible,true;diffusealpha,1;zoom,1;queuecommand,"Repeat";);
			RepeatCommand=cmd(sleep,20.75;diffusealpha,1;glow,color("1,0.5,0,0");linear,0.05;glow,color("1,0.5,0,0.5");decelerate,1;glow,color("1,0.5,0,0");queuecommand,"Repeat";);
			OffCommand=cmd(stoptweening;);
		};

		LoadActor("bpmframe")..{
			InitCommand=function(self)
				if getenv("exflag") == "csc" then
					self:x(-114-70);
					self:y(-56-10);
				else
					self:x(-114-80);
					self:y(-56-95);
				end;
			end;
			OnCommand=function(self)
				if getenv("ReloadAnimFlag") == 1 then self:playcommand("NoAnim");
				else self:playcommand("Anim");
				end;
			end;
			AnimCommand=cmd(cropright,1;addx,-20;sleep,0.3;accelerate,0.4;addx,20;cropright,0;
						glow,color("1,0.5,0,0");linear,0.05;glow,color("1,0.5,0,1");decelerate,0.4;glow,color("1,0.5,0,0");queuecommand,"Repeat";);
			NoAnimCommand=cmd(visible,true;diffusealpha,1;zoom,1;queuecommand,"Repeat";);
			RepeatCommand=cmd(sleep,21.25;diffusealpha,1;glow,color("1,0.5,0,0");linear,0.05;glow,color("1,0.5,0,0.5");decelerate,1;glow,color("1,0.5,0,0");queuecommand,"Repeat";);
			OffCommand=cmd(stoptweening;);
		};
	};
end;

--20180208
-- _bannerback3
t[#t+1] = Def.ActorFrame{
	OnCommand=function(self)
		if getenv("exflag") == "csc" then
			self:x(SCREEN_CENTER_X+210);
		else self:x(SCREEN_CENTER_X+160);
		end;
		(cmd(y,SCREEN_CENTER_Y+52;zoomx,10;zoomy,0;))(self)
		if getenv("ReloadAnimFlag") == 1 then self:playcommand("NoAnim");
		else self:playcommand("Anim");
		end;
	end;
	AnimCommand=cmd(sleep,0.2;decelerate,0.3;zoom,1;);
	NoAnimCommand=cmd(zoom,1;);
	LoadActor("_bannerback3")..{
		CurrentSongChangedMessageCommand=function(self)
			if getenv("wheelstop") == 1 then
				(cmd(stoptweening;diffusealpha,1;x,0;y,-4;decelerate,0.15;x,4;y,0;diffusealpha,1;glow,color(glowcolor[1]);decelerate,0.15;glow,color(glowcolor[2]);))(self)
			else (cmd(stoptweening;diffusealpha,1;x,0;y,-4;diffusealpha,1;glow,color(glowcolor[1]);))(self)
			end;
		end;
		SectionSetFMessageCommand=cmd(playcommand,"CurrentSongChanged";);
	};
};

-- _bannerback2
t[#t+1] = Def.ActorFrame{
	OnCommand=function(self)
		if getenv("exflag") == "csc" then
			self:x(SCREEN_CENTER_X+50);
		else self:x(SCREEN_CENTER_X);
		end;
		(cmd(y,SCREEN_CENTER_Y+52;zoomx,10;zoomy,0;))(self)
		if getenv("ReloadAnimFlag") == 1 then self:playcommand("NoAnim");
		else self:playcommand("Anim");
		end;
	end;
	AnimCommand=cmd(sleep,0.2;decelerate,0.3;zoom,1;);
	NoAnimCommand=cmd(zoom,1;);
	-- mask
	Def.Quad{
		InitCommand=cmd(diffuse,color("0,0,0,1");zoomto,200,34;);
	};
	-- titleback
	LoadActor("_bannerback2")..{
		CurrentSongChangedMessageCommand=function(self)
			if getenv("wheelstop") == 1 then
				(cmd(y,-8;stoptweening;diffusealpha,1;x,6;decelerate,0.15;x,2;diffusealpha,1;glow,color(glowcolor[1]);decelerate,0.15;glow,color(glowcolor[2]);))(self)
			else (cmd(y,-8;stoptweening;diffusealpha,1;x,6;diffusealpha,1;glow,color(glowcolor[1]);))(self)
			end;
		end;
		SectionSetFMessageCommand=cmd(playcommand,"CurrentSongChanged";);
	};
	LoadActor("_bannerback2")..{
		CurrentSongChangedMessageCommand=function(self)
			if getenv("wheelstop") == 1 then
				(cmd(y,8;rotationz,180;stoptweening;diffusealpha,1;x,2;decelerate,0.15;x,6;glow,color(glowcolor[1]);decelerate,0.15;glow,color(glowcolor[2]);))(self)
			else (cmd(y,8;rotationz,180;stoptweening;diffusealpha,1;x,2;glow,color(glowcolor[1]);))(self)
			end;
		end;
		SectionSetFMessageCommand=cmd(playcommand,"CurrentSongChanged";);
	};
};

-- songtitle
if getenv("exflag") == "csc" then
	t[#t+1] = Def.ActorFrame{
		InitCommand=function(self)
			self:stoptweening();
			self:x(SCREEN_CENTER_X-80);
			self:y(SCREEN_CENTER_Y+51);
		end;
		
		Def.Banner {
			InitCommand=cmd(diffusealpha,0.9;fadeleft,0.05;faderight,0.05;);
			OnCommand=function(self)
			--20180209
				self:x(316);
				self:scaletoclipped(112,35);
				(cmd(zoomy,0;sleep,0.2;decelerate,0.4;zoomy,1;playcommand,"Set"))(self)
			end;
			CSCSongSetMessageCommand=function(self,params)
				self:visible(false);
				if getenv("wheelstop") == 1 then
					if params.Banner and params.Banner[params.Folder] then
						self:visible(true);
						self:Load(params.Banner[params.Folder]);
					elseif GAMESTATE:GetCurrentSong() then
						if getenv("rnd_song") ~= 1 then
							self:visible(true);
							self:LoadFromSong(GAMESTATE:GetCurrentSong());
						end;
					end;
				end;
			end;
		};
		LoadActor("cscsonginfotitle")..{
			InitCommand=function(self)
				self:stoptweening();
			end;
			OffCommand=cmd(stoptweening;);
		};
	};
else
	t[#t+1] = Def.ActorFrame{
		InitCommand=function(self)
			self:stoptweening();
			--if GAMESTATE:IsCourseMode() and CAspect() <= 1.33333) then
			--	self:x(SCREEN_CENTER_X-184);
			--else
				self:x(SCREEN_CENTER_X-130);
			--end;
			self:y(SCREEN_CENTER_Y+51);
		end;
		--20180110
		Def.Banner {
			InitCommand=cmd(diffusealpha,0.9;fadeleft,0.05;faderight,0.05;);
			OnCommand=function(self)
				self:x(316);
				self:scaletoclipped(112,35);
				if getenv("ReloadAnimFlag") == 1 then self:playcommand("NoAnim");
				else self:playcommand("Anim");
				end;
			end;
			SetCommand=function(self)
				self:visible(false);
				local SongOrCourse = "";
				if getenv("wheelstop") == 1 then
					local envgroup = getenv("wheelsectiongroup");
					local sctext = getenv("SortCh");
					
					SongOrCourse = CurSOSet();
					--20160710
					if not SongOrCourse and sctext == "Group" and envgroup ~= "" and envgroup ~= nil then
						self:visible(true);
						self:LoadFromSongGroup(envgroup);
					elseif SongOrCourse then
						local pcheck = true;
						if getenv("rnd_song") == 1 then
							local sdirs = split("/",SongOrCourse:GetSongDir());
							if getenv("br_set")[sdirs[3].."/"..sdirs[4]] then
								if getenv("br_set")[sdirs[3].."/"..sdirs[4]].banner and
								FILEMAN:DoesFileExist( sdirs[2].."/"..sdirs[3].."/"..getenv("br_set")[sdirs[3].."/"..sdirs[4]].banner ) then
									self:visible(true);
									self:Load(sdirs[2].."/"..sdirs[3].."/"..getenv("br_set")[sdirs[3].."/"..sdirs[4]].banner);
									pcheck = false;
								end;
							end;
						end;
						if pcheck then
							self:visible(true);
							if coursemode then
								self:LoadFromCourse(SongOrCourse);
							else self:LoadFromSong(SongOrCourse);
							end;
						end;
					end;
				else SongOrCourse = "";
				end;
			end;
			AnimCommand=cmd(zoomy,0;sleep,0.2;decelerate,0.4;zoomy,1;);
			NoAnimCommand=cmd(zoomy,1;);
			CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
			CurrentCourseChangedMessageCommand=cmd(playcommand,"Set");
		};
		LoadActor("songinfotitle")..{
			OnCommand=function(self)
				self:playcommand("Anim");
				--if getenv("ReloadAnimFlag") == 1 then self:playcommand("NoAnim");
				--else self:playcommand("Anim");
				--end;
			end;
			AnimCommand=cmd(diffusealpha,0;sleep,0.2;decelerate,0.4;diffusealpha,1;);
			NoAnimCommand=cmd(diffusealpha,1;);
			OffCommand=cmd(stoptweening;);
		};
	};
end;
--20160821
--BPMDisplay
if not GAMESTATE:IsCourseMode() then
	t[#t+1] = Def.ActorFrame{
		InitCommand=cmd(x,SCREEN_CENTER_X+bpm_coordinate[1];y,SCREEN_CENTER_Y+bpm_coordinate[2];);
		OnCommand=cmd(addx,15;zoom,0.5;zoomy,0;sleep,0.55;decelerate,0.4;addx,-15;zoomy,0.5;);
		Def.BPMDisplay {
			File=THEME:GetPathF("","_cum");
			Name="BPMDisplay";
			SetCommand=function(self)
				self:maxwidth(180);
				self:stoptweening();
				self:visible(true);
				if getenv("rnd_song") == 1 then
					self:settext("???");
					(cmd(stoptweening;linear,0.2;diffuse,color("1,1,0,1");diffusetopedge,color("1,0,1,1");strokecolor,color("0,0,0,1");))(self)
				else self:SetFromGameState();
				end;
			end;
			CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
			CurrentCourseChangedMessageCommand=cmd(playcommand,"Set");
		};
	};
end;

return t;