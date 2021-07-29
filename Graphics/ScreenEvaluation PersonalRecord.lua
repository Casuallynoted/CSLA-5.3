local Player = ...
assert(Player,"PersonalRecord needs Player")
local stats = STATSMAN:GetCurStageStats():GetPlayerStageStats(Player);
local record = stats:GetPersonalHighScoreIndex()
local hasPersonalRecord = record ~= -1
--20160820
local t = Def.ActorFrame{
	BeginCommand=cmd(visible,hasPersonalRecord;);
	NetMessageCommand=cmd(visible,hasPersonalRecord;);
	NotNetMessageCommand=cmd(visible,false;);
	LoadFont("_shared2")..{
		Text = string.format("#%i", record+1);
		InitCommand=cmd(zoom,0.45;x,10;horizalign,right;diffuse,color("0,1,1,1");strokecolor,Color("Black"));
	};
	LoadFont("_shared2")..{
		Text = string.format("personal", record+1);
		InitCommand=cmd(zoom,0.35;x,-24;y,1;diffuse,color("0,1,1,1");strokecolor,Color("Black"));
	};
};

return t;