local gc = Var("GameCommand");
local squareSize = 8; -- was 18
--[ja] 20150719修正
return Def.ActorFrame {
	Def.Quad{
		InitCommand=cmd(x,-12;y,2;zoom,squareSize;diffuse,Color("Orange");shadowlength,2;);
		GainFocusCommand=cmd(stoptweening;accelerate,0.25;zoom,squareSize;);
		LoseFocusCommand=cmd(stoptweening;decelerate,0.25;zoom,0;rotationz,360;);
	};
	LoadFont("Common Normal") .. {
		Text=gc:GetText();
		InitCommand=cmd(halign,0;zoom,0.625;wrapwidthpixels,200*1.375;strokecolor,Color("Black");shadowlength,2;);
		GainFocusCommand=cmd(stoptweening;decelerate,0.25;diffuse,Color("Orange"););
		LoseFocusCommand=cmd(stoptweening;accelerate,0.25;diffuse,color("0.4,0.4,0.4,1"));
	};
};