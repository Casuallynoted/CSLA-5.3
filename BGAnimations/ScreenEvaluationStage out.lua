return Def.ActorFrame {
	LoadActor(THEME:GetPathB("","_delay"),2);

	LoadActor(THEME:GetPathS("_m","and swoosh" ))..{
		StartTransitioningCommand=cmd(play);
	};

	LoadActor( THEME:GetPathB("","_menu out" ) )..{
	};
}