return Def.ActorFrame {
	InitCommand=cmd(sleep,0.6);
	
	LoadActor(THEME:GetPathS("","_prompt")) .. {
		StartTransitioningCommand=cmd(play);
	};
}