--[[ScreenGameplay SongPosition]]

local t = Def.ActorFrame{};
local width = math.min(218,WideScale(170,218));
local linear = math.min(-198,WideScale(-150,-198));

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
	t[#t+1] = Def.SongMeterDisplay {
		Name="SongMeterDisplay";
		InitCommand=cmd(x,GetPosition(pn)+stylecheckposition();y,SCREEN_CENTER_Y;SetStreamWidth,width);
		OnCommand=cmd(stoptweening;diffusealpha,0;addx,math.abs(linear);decelerate,2;diffusealpha,1;addx,linear);
		Stream=Def.Actor{};
		Tip=Def.ActorFrame{
			LoadActor("_tip")..{
				InitCommand=cmd(stoptweening;glowshift;effectperiod,3;effectcolor1,color("0,0,0,0");effectcolor2,color("1,0.7,0,0.6"););
			};
		};
	};
end;

return t;