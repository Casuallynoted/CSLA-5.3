local t = Def.ActorFrame {
	LoadFont("_cum") ..{
		InitCommand=cmd(horizalign,right;shadowlength,2;skewx,-0.2;maxwidth,220;diffuse,color("1,1,1,1");strokecolor,color("0,0,0,1"););
		OnCommand=cmd(playcommand,"Set");
		SetCommand=function(self)
			self:finishtweening();
			local SongOrCourse = CurSOSet();
			local timeText = "??:??.??";
			if SongOrCourse then
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
	
};

return t;