local t = Def.ActorFrame{};

local coursemode = GAMESTATE:IsCourseMode();
local showjacket = GetAdhocPref("WheelGraphics");

if not coursemode then return t; end;

t[#t+1] = Def.ActorFrame{
	LoadActor("stagesongback_effect")..{
	};
	LoadActor("stageback_effect")..{
	};
};

t[#t+1] = LoadActor("banner")..{
};

if showjacket ~= "Off" then
	t[#t+1] = LoadActor("jacket")..{
	};
	t[#t+1] = LoadActor("plus")..{
	};
end;

t[#t+1] = LoadActor("songtitle")..{
};

return t;