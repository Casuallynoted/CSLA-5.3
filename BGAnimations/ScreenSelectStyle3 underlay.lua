
local intime = 0.13;
local stf = "";
if CurGameName() ~= "dance" then stf = CurGameName().."_";
end;

local t = Def.ActorFrame{
-- part1
	LoadActor(THEME:GetPathG("ScreenSelectStyle","Icon/"..stf.."Single"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X-209;y,SCREEN_CENTER_Y+108+10);
		OnCommand=cmd(diffuse,color("0.15,0.15,0.15,1");addx,14;addy,14;diffusealpha,0;rotationy,50;
					sleep,tonumber(intime);decelerate,0.45;addx,-14;addy,-14;diffusealpha,1;rotationy,0;);
	};
	Def.Sprite{
		InitCommand=function(self)
			self:visible(false);
			if CurGameName() == "dance" then
				self:visible(true);
				self:x(SCREEN_CENTER_X-69.5);
				self:Load(THEME:GetPathG("ScreenSelectStyle","Icon/Solo"));
			elseif CurGameName() == "pump" then
				self:visible(true);
				self:x(SCREEN_CENTER_X+69.5);
				self:Load(THEME:GetPathG("ScreenSelectStyle","Icon/pump_HalfDouble"));
				intime = 0.3;
			end;
			(cmd(y,SCREEN_CENTER_Y+108+10))(self)
		end;
		OnCommand=cmd(diffuse,color("0.15,0.15,0.15,1");addx,14;addy,14;diffusealpha,0;rotationy,50;
					sleep,tonumber(intime);decelerate,0.45;addx,-14;addy,-14;diffusealpha,1;rotationy,0;);
	};
	LoadActor(THEME:GetPathG("ScreenSelectStyle","Icon/"..stf.."Double"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X+209;y,SCREEN_CENTER_Y+108+10);
		OnCommand=cmd(diffuse,color("0.15,0.15,0.15,1");addx,14;addy,14;diffusealpha,0;rotationy,50;
					sleep,0.175;decelerate,0.45;addx,-14;addy,-14;diffusealpha,1;rotationy,0;);
	};

};

return t;