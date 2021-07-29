local t = Def.ActorFrame{};

t[#t+1] = LoadActor( THEME:GetPathB("ScreenSelectMusic","background") )..{
};

local randomtext = THEME:GetString("MusicWheel","CustomItemRandomText");
local evabackset = false;
if GAMESTATE:IsCourseMode() then
	evabackset = true;
else
	evabackset = true;
	if getenv("wheelsectioncsc") == randomtext then
		evabackset = false;
	end;
	if getenv("rnd_song") == 1 then
		evabackset = false;
	end;
end;

if evabackset then
	t[#t+1] = LoadActor( THEME:GetPathB("","eva_back") )..{
	};
end;

return t;