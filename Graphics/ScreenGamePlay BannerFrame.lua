local t = Def.ActorFrame{
	LoadActor(THEME:GetPathG("","GameFSet/Score/"..GetGameFrame().."_ScoreFrame/bannerframe"))..{
		InitCommand=cmd(x,mplayerposition()+stylecheckposition();y,SCREEN_BOTTOM-25;);
		OnCommand=cmd(addy,30;decelerate,0.3;addy,-30;glow,color("1,0.5,0,0");linear,0.05;glow,color("1,0.5,0,1");linear,0.4;glow,color("1,0.5,0,0"););
	};
};

return t;