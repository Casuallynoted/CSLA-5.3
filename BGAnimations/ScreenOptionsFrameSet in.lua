return Def.ActorFrame{
	LoadActor( THEME:GetPathS("","_swoosh" ) )..{
		StartTransitioningCommand=cmd(play);
	};

	LoadActor(THEME:GetPathB("","_fade in" ))..{
	};
};

