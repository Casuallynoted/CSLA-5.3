local t = Def.ActorFrame {
	LoadActor(THEME:GetPathG("","_stages/_selmusic Stage_Extra2"))..{
		OnCommand=THEME:GetMetric(Var "LoadingScreen","StageDisplayOnCommand");
	};
};

return t;