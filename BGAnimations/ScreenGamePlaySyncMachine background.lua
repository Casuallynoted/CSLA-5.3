return Def.ActorFrame {

	LoadActor( THEME:GetPathG("Common","fallback background" ) )..{
		InitCommand=cmd(FullScreen;Center;);
		OnCommand=cmd(diffuse,color("0.6,0.6,0.6,1"));
	};
}