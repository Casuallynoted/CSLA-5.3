
local t = Def.ActorFrame{
	LoadFont("_shared4") .. {
		InitCommand=cmd(horizalign,right;diffuse,color("0,0,0,1");strokecolor,color("0,1,1,1");zoom,0.5;shadowlength,1;maxwidth,SCREEN_WIDTH;);
		BeginCommand=function(self)
			self:settextf( Screen.String("CurrentGametype"), CurGameName() );
		end;
	};
};
return t;