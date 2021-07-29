return LoadFont("_titleMenu_scroller")..{
	InitCommand=cmd(horizalign,right;diffuse,color("0,0,0,1");strokecolor,color("1,0.75,0,0.6");zoom,0.45;maxwidth,SCREEN_WIDTH;queuecommand,"Set";);
	SetCommand=cmd(settext, string.format("%04i/%i/%i %i:%02i", Year(), MonthOfYear()+1,DayOfMonth(), Hour(), Minute());sleep,1;queuecommand,"Set";);
};