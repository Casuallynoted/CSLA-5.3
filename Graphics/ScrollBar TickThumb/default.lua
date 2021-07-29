local t = Def.ActorFrame{

	LoadActor("TickThumb")..{
		OnCommand=function(self)
			self:playcommand("Anim");
			--if getenv("ReloadAnimFlag") == 1 then self:playcommand("NoAnim");
			--else self:playcommand("Anim");
			--end;
		end;
		AnimCommand=cmd(zoomy,0;linear,0.3;zoomy,1;queuecommand,"Repeat";);
		NoAnimCommand=cmd(zoomy,1;queuecommand,"Repeat";);
		RepeatCommand=cmd(blend,'BlendMode_Add';glowshift;effectperiod,3;effectcolor1,color("0,0,0,0");effectcolor2,color("0,1,1,0.4"););
		OffCommand=cmd(stoptweening;linear,0.3;zoomy,0;);
	};
};

return t;