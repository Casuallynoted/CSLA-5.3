--[[ScreenOptionsFrameSet Icon]]
local t = Def.ActorFrame{};

local frame = {
	"Regular",
	"Nonstop",
	"Oni",
	"Endless",
	"Rave",
};

local name = Var("GameCommand"):GetName();
local setname = "Regular";

if name == "Default" then setname = frame[math.random(#frame)];
elseif name == "Challenge" then setname = "Oni"
elseif name == "Cyan" then setname = "CSC"
elseif name == "Cyan_Special" then setname = "CSC_Special"
else setname = name;
end;

t[#t+1] = Def.ActorFrame{
	OnCommand=cmd(x,SCREEN_LEFT+(SCREEN_WIDTH*0.4);y,SCREEN_TOP+(SCREEN_HEIGHT*0.13);zoom,0.8;);
	LoadActor("frame",1,setname)..{
	};
	LoadActor("frame",2,setname)..{
	};
};

return t;