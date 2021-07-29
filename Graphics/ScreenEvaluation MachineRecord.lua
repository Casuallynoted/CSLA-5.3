local Player = ...
assert(Player,"MachineRecord needs Player")
local stats = STATSMAN:GetCurStageStats():GetPlayerStageStats(Player);
local record = stats:GetMachineHighScoreIndex()
local hasMachineRecord = record ~= -1
--20160820
local t = Def.ActorFrame{
	BeginCommand=cmd(visible,hasMachineRecord;);
	NetMessageCommand=cmd(visible,hasMachineRecord;);
	NotNetMessageCommand=cmd(visible,false;);
	LoadFont("_shared2")..{
		Text = string.format("#%i", record+1);
		InitCommand=cmd(zoom,0.45;x,10;horizalign,right;strokecolor,Color("Black"););
	};
	LoadFont("_shared2")..{
		Text = string.format("machine", record+1);
		InitCommand=cmd(zoom,0.35;x,-24;y,1;strokecolor,Color("Black"););
	};
};

return t;