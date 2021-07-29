local t = Def.ActorFrame {
	LoadActor(THEME:GetPathG("","_stages/_selmusic Stage_Extra1"))..{
		OnCommand=THEME:GetMetric(Var "LoadingScreen","StageDisplayOnCommand");
	};
};

return t;