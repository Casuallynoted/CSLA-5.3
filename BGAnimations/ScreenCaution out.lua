local t = Def.ActorFrame{
	LoadActor(THEME:GetPathB("","_delay"),1);

	LoadActor( THEME:GetPathS("","_swoosh") )..{
		StartTransitioningCommand=cmd(play);
	};
};
return t;