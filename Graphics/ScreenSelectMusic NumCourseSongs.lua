local t = Def.ActorFrame {
	LoadFont("_um") ..{
		InitCommand=cmd(shadowlength,2;skewx,-0.2;maxwidth,140;diffuse,color("0,1,1,1");strokecolor,color("0,0,0,1"););
		SetCommand=function(self)
			self:finishtweening();
			local course = GAMESTATE:GetCurrentCourse();
			local stages = 0;
			if course then
				stages = course:GetEstimatedNumStages();
			end;
			self:settext(stages);
		end;
		CurrentCourseChangedMessageCommand=cmd(playcommand,"Set");
		CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Set");
		CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Set");
	};
};

return t;