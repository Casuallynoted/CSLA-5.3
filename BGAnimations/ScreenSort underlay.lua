
local t = LoadActor(THEME:GetPathB("ScreenSelectMusic","underlay/choiceback"))..{
	InitCommand=function(self)
		self:x(SCREEN_CENTER_X);
		if CAspect() >= 1.77778 then
			self:zoom(1);
			self:y(SCREEN_CENTER_Y-45);
		else
			self:zoom(WideScale(0.85,1));
			self:y(WideScale(SCREEN_CENTER_Y-36,SCREEN_CENTER_Y-46));
		end;
		(cmd(diffusealpha,0;croptop,1;glowshift;effectcolor1,color("1,0.5,0,1");effectcolor2,color("1,0,0,0.75");effectperiod,1;playcommand,"Set";))(self)
	end;
	OnCommand=cmd(playcommand,"NoAnim";);
	NoAnimCommand=cmd(croptop,0;diffusealpha,1;);
};

return t;