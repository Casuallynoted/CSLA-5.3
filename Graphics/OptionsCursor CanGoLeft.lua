local t = Def.ActorFrame{
	LoadActor(THEME:GetPathG("EditMenu","left"))..{
		InitCommand=cmd(x,-20;zoom,0.55;);
	};
};

return t;