--[[_StepsDisplayListRow cursor]]

local p = ...;
assert(p)

local setting_t = {
	{"0,1,0.7,1","0,1,0.5,0"};
	{"0.8,0.2,0.6,0.5","1,1,1,0"};
	{"1,0.7,0.3,1","0,0,0,0"};
};
if p == "2" then
	setting_t = {
		{"0,0.5,1,0","0,0.7,1,1"};
		{"0,0.7,1,0.5","1,1,1,0"};
		{"0,0,0,0","1,0.7,0.3,1"};
	};
end;

local t = Def.ActorFrame {
	LoadActor(p.."/_1")..{
		InitCommand=cmd(x,-2.5+5;y,-15-5;blend,'BlendMode_Add';glowshift;effectcolor1,color(setting_t[1][1]);effectcolor2,color(setting_t[1][2]);effectperiod,2.5;);
	};

	LoadActor(p.."/_2")..{
		InitCommand=cmd(x,-2.5+5;y,-15-5;diffusealpha,0;linear,1;diffusealpha,0.65;glowshift;effectcolor1,color(setting_t[2][1]);effectcolor2,color(setting_t[2][2]);effectperiod,2.5;);
	};

	LoadActor(p.."/_3")..{
		InitCommand=cmd(x,-24.5+5;y,4-5;diffusealpha,0;linear,1;diffusealpha,1;diffuseshift;effectcolor1,color(setting_t[3][1]);effectcolor2,color(setting_t[3][2]);effectperiod,2;);
	};

	LoadActor(p.."/_4")..{
		InitCommand=cmd(x,-24.5+5;y,4-5;diffusealpha,0;linear,1;diffusealpha,1;);
	};
};

return t