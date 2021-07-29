local t = Def.ActorFrame {
	--song length
	LoadFont("_cum")..{
		InitCommand=cmd(zoom,0.5;horizalign,right;shadowlength,0;strokecolor,color("0,0,0,1");maxwidth,180;);
		OnCommand=cmd(playcommand,"Set");
		SetCommand=function(self)
			self:stoptweening();
			local SongOrCourse = CurSOSet();
			local timeText = "?:??.??";
			if getenv("rnd_song") == 1 then
				timeText = "?:??.??";
			elseif SongOrCourse then
				if GAMESTATE:IsCourseMode() then
					local trail = GAMESTATE:GetCurrentTrail(GAMESTATE:GetMasterPlayerNumber());
					if trail then
						local st = trail:GetStepsType();
						if st then
							timeText = SecondsToMSSMsMs(TrailUtil.GetTotalSeconds(trail));
						end;
					end;
				else
					timeText = SecondsToMSSMsMs(SongOrCourse:MusicLengthSeconds());
				end;
			else
				timeText = "";
			end;
			self:settext(timeText);
		end;
		CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
		CurrentCourseChangedMessageCommand=cmd(playcommand,"Set");
		CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Set");
		CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Set");
	};
	
	--machine rank
	LoadFont("_um")..{
		InitCommand=cmd(x,-21;y,14;horizalign,right;shadowlength,0;diffuse,color("0,1,1,1");strokecolor,color("0,0,0,1");maxwidth,120;);
		OnCommand=cmd(zoom,0.5;playcommand,"Set");
		SetCommand=function(self)
			self:stoptweening();
			if not GAMESTATE:IsCourseMode() then
				local song = GAMESTATE:GetCurrentSong();
				if getenv("rnd_song") == 1 then
					self:visible(false);
				elseif song then
					self:visible(true);
					self:settext(SONGMAN:GetSongRank(song));
				else
					self:visible(false);
				end;
			else
				self:visible(false);	
			end;
		end;
		CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
		CurrentCourseChangedMessageCommand=cmd(playcommand,"Set");
	};
	
	LoadActor(THEME:GetPathG("ScreenSelectMusic","BannerFrame/branchmusic"))..{
		InitCommand=cmd(y,18;horizalign,right;shadowlength,2;);
		OnCommand=cmd(playcommand,"Set");
		SetCommand=function(self)
			self:stoptweening();
			if not GAMESTATE:IsCourseMode() then
				local song = GAMESTATE:GetCurrentSong();
				if getenv("wheelstop") == 1 and getenv("rnd_song") == 1 then
					self:visible(true);
				else self:visible(false);
				end;
			else self:visible(false);	
			end;
		end;
		CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
		CurrentCourseChangedMessageCommand=cmd(playcommand,"Set");
	};
};

return t;