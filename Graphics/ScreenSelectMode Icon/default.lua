--[[ScreenSelectMode Icon]]

local gc = Var "GameCommand";

local gamenum = {
	Dance	= 0,
	Rave		= 0.045,
	Nonstop	= 0.09,
	Oni		= 0.135,
	Endless	= 0.18
};
local slsec = gamenum[gc:GetName()];

local t = Def.ActorFrame{
	Def.ActorFrame{
		OnCommand=cmd(queuecommand,"Set";);
		SetCommand=cmd(diffusealpha,0;addx,50;addy,-50;sleep,tonumber(slsec);decelerate,0.2;diffusealpha,1;addx,-50;addy,50;);
		LoadActor("icon_decide1")..{
			GainFocusCommand=cmd(finishtweening;diffusealpha,1;cropright,1;linear,0.4;cropright,0;);
			LoseFocusCommand=cmd(stoptweening;cropright,1;diffusealpha,0;);
		};
	};
	
	Def.ActorFrame{
		OnCommand=cmd(queuecommand,"Set";);
		SetCommand=cmd(addx,-24;zoomy,0;sleep,tonumber(slsec);decelerate,0.45;addx,24;zoomy,1;);
		LoadActor("icon_decide4")..{
			InitCommand=cmd(y,2;);
			GainFocusCommand=cmd(finishtweening;visible,true;diffusealpha,1;croptop,1;linear,0.2;croptop,0;
							glowshift;effectcolor1,color("1,0,0,1");effectcolor2,color("0,1,0.9,0.7");effectperiod,1);
			LoseFocusCommand=cmd(stoptweening;diffusealpha,0);
		};
	};

	Def.ActorFrame{
		OnCommand=cmd(queuecommand,"Set";);
		SetCommand=cmd(addx,14;addy,14;diffusealpha,0;rotationy,50;sleep,tonumber(slsec);decelerate,0.45;addx,-14;addy,-14;diffusealpha,1;rotationy,0;);
		--iconbase
		LoadActor(gc:GetName())..{
			OnCommand=function(self)
				if GAMESTATE:GetCurrentStyle():GetStepsType() == "StepsType_Dance_Solo"or
				GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_OnePlayerTwoSides" then
					if gc:GetName() == "Rave" then
						self:diffuse(color("0.2,0.2,0.2,1"));
					end;
				end;
			end;
			GainFocusCommand=cmd(finishtweening;linear,0.2;diffuse,color("1,1,1,1"););
			LoseFocusCommand=cmd(stoptweening;linear,0.1;diffuse,color("0.45,0.45,0.45,1"););
		};

		--iconfocusglow
		LoadActor(gc:GetName())..{
			OnCommand=function(self)
				if gc:GetName() == "Dance" then
					self:playcommand("GainFocus");
				end;
			end;
			GainFocusCommand=cmd(finishtweening;diffusealpha,1;glow,color("1,0.5,0,0.5");croptop,1;cropbottom,1;linear,0.4;croptop,0;
							linear,0.2;cropbottom,0;linear,0.2;croptop,1;queuecommand,"Sleep";);
			SleepCommand=cmd(sleep,4;queuecommand,"GainFocus";);
			LoseFocusCommand=cmd(finishtweening;diffusealpha,0;);
		};
	};

	LoadActor(THEME:GetPathG("","stylemodeback/icon_decide2"))..{
		InitCommand=cmd(x,-16;y,-45;);
		OnCommand=cmd(queuecommand,"Set";);
		SetCommand=cmd(diffusealpha,0;addx,-16;addy,16;sleep,tonumber(slsec);decelerate,0.3;diffusealpha,1;addx,16;addy,-16;);
		GainFocusCommand=cmd(finishtweening;visible,true;cropbottom,1;decelerate,0.35;cropbottom,0;
						glowshift;effectcolor1,color("1,1,0,0.8");effectcolor2,color("0,1,0.9,0.4");effectperiod,0.75);
		LoseFocusCommand=cmd(stoptweening;cropbottom,1;);
	};
};
return t;