--[[ScreenJukeBox overlay]]

local t = Def.ActorFrame{};

local showjacket = GetAdhocPref("WheelGraphics");
local sectioncolorlist = getenv("sectioncolorlist");

if GAMESTATE:IsDemonstration() then
	t[#t+1] = LoadActor(THEME:GetPathG("ScreenWithMenuElements","Statusbar/at"))..{
		InitCommand=cmd(rotationy,180;x,SCREEN_RIGHT-100;y,SCREEN_BOTTOM-50;);
		OnCommand=cmd(diffusealpha,0;cropbottom,1;sleep,0.4;accelerate,0.3;diffusealpha,1;cropbottom,0;);
	};

	t[#t+1] = LoadActor(THEME:GetPathG("ScreenSelectMusic","BannerFrame/_bannerback2"))..{
		InitCommand=cmd(horizalign,right;vertalign,bottom;x,SCREEN_RIGHT+80;y,SCREEN_BOTTOM-46;shadowlength,0;);
		OnCommand=cmd(diffusealpha,0;cropleft,1;sleep,0.2;accelerate,0.3;diffusealpha,1;cropleft,0;);
	};

	t[#t+1] = Def.Banner{
		Name="SongJacket";
		InitCommand=function(self, params)
			(cmd(horizalign,right;vertalign,bottom;shadowlength,2;
			x,SCREEN_RIGHT-28;y,SCREEN_BOTTOM-80;diffusetopedge,color("1,1,1,0.8");))(self)
			local song = GAMESTATE:GetCurrentSong();
			if song then
				self:Load(GetSongImage(song));
				self:zoomto(GetSongImageSize(song,"jukebox")[1],GetSongImageSize(song,"jukebox")[2]);
			end;
		end;
		OnCommand=function(self, params)
			local song = GAMESTATE:GetCurrentSong();
			if song then
				(cmd(diffusealpha,0;croptop,1;sleep,0.8;decelerate,0.2;diffusealpha,0.8;croptop,0;))(self)
			end;
		end;
	};

	t[#t+1] = LoadFont("_shared2")..{
		InitCommand=cmd(x,SCREEN_RIGHT-25;y,SCREEN_BOTTOM-36;shadowlength,2;horizalign,right;strokecolor,Color("Black"););
		SetSongCommand=function(self)
			(cmd(maxwidth,300;zoom,0.6;cropright,1;diffusealpha,0;sleep,0.2;decelerate,0.2;cropright,0;diffusealpha,1;))(self)
			local song = GAMESTATE:GetCurrentSong();
			self:visible(true);	
			if song then
				self:settext(song:GetGroupName());
				local sectiontextlist = getenv("sectionsubnamelist");
				if sectiontextlist ~= "" then
					if sectiontextlist[song:GetGroupName()] then
						self:settext(sectiontextlist[song:GetGroupName()]);
					end;
				end;
				self:diffuse(SONGMAN:GetSongColor(song));
				local sdirs = split("/",song:GetSongDir());
				if sectioncolorlist ~= "" then
					if sectioncolorlist[song:GetGroupName()] then
						self:diffuse(color(sectioncolorlist[song:GetGroupName()]));
					end;
				end;
			end;
			
		end;
		OnCommand=cmd(playcommand,"SetSong";);
		UpdateCommand=cmd(playcommand,"SetSong";);
		CurrentSongChangedMessageCommand=cmd(playcommand,"SetSong";);
	};

	t[#t+1] = Def.TextBanner {
		InitCommand=cmd(Load,"DemoTextBanner";SetFromString,"", "", "", "", "", "";);
		OnCommand=cmd(x,SCREEN_RIGHT-38;y,SCREEN_BOTTOM-46-16;zoom,0.8;diffusealpha,0;sleep,0.4;decelerate,0.2;diffusealpha,1;);
		SetSongCommand=function(self)
			local SongOrCourse = CurSOSet();
			local coursemode = GAMESTATE:IsCourseMode();
			self:visible(true);
			if SongOrCourse then
				if coursemode then
					self:SetFromString( SongOrCourse:GetDisplayFullTitle(), "", "", "", "", "" );
					self:diffuse( SONGMAN:GetCourseColor( SongOrCourse ) );
				else			
					self:SetFromSong( SongOrCourse );
					--20170114
					--self:SetFromString( SongOrCourse:GetDisplayMainTitle(), SongOrCourse:GetTranslitMainTitle(), SongOrCourse:GetDisplaySubTitle(), 
					--SongOrCourse:GetTranslitSubTitle(), SongOrCourse:GetDisplayArtist(), SongOrCourse:GetTranslitArtist() );
					self:diffuse(SONGMAN:GetSongColor(SongOrCourse));
					local sdirs = split("/",SongOrCourse:GetSongDir());
					if sectioncolorlist ~= "" then
						if sectioncolorlist[SongOrCourse:GetGroupName().."/"..sdirs[4]] then
							self:diffuse(color(sectioncolorlist[SongOrCourse:GetGroupName().."/"..sdirs[4]]));
						elseif sectioncolorlist[SongOrCourse:GetGroupName()] then
							self:diffuse(color(sectioncolorlist[SongOrCourse:GetGroupName()]));
						end;
					end;
				end;
			end;
		end;
		UpdateCommand=cmd(playcommand,"SetSong";);
		CurrentSongChangedMessageCommand=cmd(playcommand,"SetSong";);
	};

	t[#t+1] = LoadActor(THEME:GetPathB("","premium"))..{
	};
end;

return t;