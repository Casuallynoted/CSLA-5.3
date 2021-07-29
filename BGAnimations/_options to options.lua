return Def.ActorFrame{
	LoadActor(THEME:GetPathB("","_delay"),0.4);

	LoadActor(THEME:GetPathS("","_swoosh"))..{
		OnCommand=cmd(play);
	};

	LoadActor(THEME:GetPathB("","_fade in"))..{
	};
};