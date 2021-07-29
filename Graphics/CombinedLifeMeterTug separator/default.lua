--[[CombinedLifeMeterTug separator]]
local t = Def.ActorFrame {
	LoadActor("separator")..{
		OnCommand=cmd(blend,'BlendMode_Add';diffuseshift;effectcolor1,color("1,0.5,0,1");effectcolor2,color("1,0,0,1");effectperiod,2.5;);
	};
};
	
return t;