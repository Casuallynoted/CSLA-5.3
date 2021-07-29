
local t = Def.ActorFrame{};

local pm = GAMESTATE:GetPlayMode();
local function pload()
	if pm == 'PlayMode_Regular' then
		return {"regular",-SCREEN_CENTER_X-58};
	elseif pm == 'PlayMode_Rave' then
		return {"battle",-SCREEN_CENTER_X-44};
	elseif GAMESTATE:IsCourseMode() then
		return {"course",-SCREEN_CENTER_X-44};
	else return {"regular",-SCREEN_CENTER_X-58};
	end;
end;

if pm then
	t[#t+1] = Def.ActorFrame{
		InitCommand=cmd(x,SCREEN_RIGHT-13;y,SCREEN_TOP+94;);
		LoadActor("mode_"..pload()[1])..{
			OnCommand=cmd(horizalign,right;shadowlength,2;addx,5;diffusealpha,0;decelerate,0.5;addx,-10;diffusealpha,1;
						sleep,0.85;linear,0.1;y,SCREEN_CENTER_Y+40-10;linear,0.1;x,pload()[2];sleep,1.1;
						linear,0.1;rotationz,45;linear,0.1;addx,100;addy,-100;diffusealpha,0;zoomy,0);
		};
	};
end;

local style = GAMESTATE:GetCurrentStyle();
if style then
	local st = style:GetName();
	t[#t+1] = Def.ActorFrame {
		LoadActor("_style "..st)..{
			InitCommand=cmd(x,SCREEN_RIGHT-13;y,SCREEN_TOP+108;);
			OnCommand=cmd(horizalign,right;shadowlength,2;addx,5;diffusealpha,0;sleep,0.15;decelerate,0.5;addx,-10;diffusealpha,1;sleep,0.6;linear,0.1;
						y,SCREEN_CENTER_Y+132;linear,0.1;x,SCREEN_CENTER_X-34;diffusealpha,0;);
		};
		LoadActor("_style "..st)..{
			InitCommand=cmd(x,SCREEN_CENTER_X-197;y,SCREEN_CENTER_Y+148-10;);
			OnCommand=cmd(horizalign,left;shadowlength,2;diffusealpha,0;addx,400;sleep,1.4;linear,0.1;addx,-400;diffusealpha,1;sleep,1;
						linear,0.1;rotationz,-45;linear,0.1;addx,100;addy,-100;diffusealpha,0;zoomy,0);
		};
	};
end;

return t;