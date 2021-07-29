
local intime = 0.13;
local stf = "";
if CurGameName() ~= "dance" then stf = CurGameName().."_";
end;

local t = Def.ActorFrame{
-- part1
	LoadActor(THEME:GetPathG("ScreenSelectStyle","Icon/"..highdefcheck(stf.."Versus")))..{
		InitCommand=function(self)
			self:y(SCREEN_CENTER_Y+108+10);
			if CurGameName() == "dance" then
				self:x(SCREEN_CENTER_X+69.5);
			else
				self:x(SCREEN_CENTER_X-69.5);
				intime = 0.15;
			end;
		end;
		OnCommand=cmd(diffuse,color("0.15,0.15,0.15,1");addx,14;addy,14;diffusealpha,0;rotationy,50;
					sleep,tonumber(intime);decelerate,0.45;addx,-14;addy,-14;diffusealpha,1;rotationy,0;);
	};

};

return t;