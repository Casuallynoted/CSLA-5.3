-- how does installed song??? let's find out

local t = Def.ActorFrame{
	LoadFont("Common Normal")..{
		Name="Header";
		InitCommand=cmd(x,SCREEN_LEFT+24;y,SCREEN_TOP+24;halign,0;settext,Screen.String("BodyHeader");diffuse,color("1,1,1,1");strokecolor,color("0,0,0,1");shadowlength,2;);
		OnCommand=cmd(queuecommand,"Anim");
		AnimCommand=cmd(cropright,1;faderight,1;addx,20;decelerate,0.5;addx,-20;cropright,0;faderight,0;);
	};
	-- todo: add explantion paragraph here (above the scroller)
};

return t;