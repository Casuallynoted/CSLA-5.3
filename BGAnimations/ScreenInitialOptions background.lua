
local t = Def.ActorFrame{
	LoadActor( THEME:GetPathB("ScreenEditMenu","background") )..{
	};
	Def.ActorFrame{
		OffCommand=function(self)
			SetAdhocPref("CSLInitialFlag","1");
		end;
	};
};

return t;