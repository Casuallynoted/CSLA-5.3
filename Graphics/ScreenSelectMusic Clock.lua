local t = Def.ActorFrame {
	LoadFont("_titleMenu_scroller")..{
		InitCommand=function(self)
			(cmd(horizalign,right;diffuse,color("0,0,0,1");strokecolor,color("1,0.75,0,0.6");))(self)
			if getenv("ReloadAnimFlag") == 1 then self:playcommand("NoAnim");
			else self:playcommand("Anim");
			end;
		end;
		AnimCommand=cmd(zoom,0.45;zoomy,0;sleep,0.5;linear,0.4;zoomy,0.45;);
		NoAnimCommand=cmd(zoom,0.45;);
		BeginCommand=cmd(settext, string.format("%04i/%i/%i %i:%02i", Year(), MonthOfYear()+1,DayOfMonth(), Hour(), Minute());sleep,1;queuecommand,"Begin");
	};
};

return t;