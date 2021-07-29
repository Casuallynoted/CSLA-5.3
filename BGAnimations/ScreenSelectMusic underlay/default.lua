--[[ScreenSelectMusic underlay]]

local t = Def.ActorFrame{};

t[#t+1] = LoadActor("choiceback")..{
	Name = 'CBack';
	InitCommand=function(self)
		self:visible(true);
		self:x(SCREEN_CENTER_X);
		if CAspect() >= 1.77778 then
			self:zoom(1);
			self:y(SCREEN_CENTER_Y-45);
		else
			self:zoom(WideScale(0.85,1));
			self:y(WideScale(SCREEN_CENTER_Y-36,SCREEN_CENTER_Y-46));
		end;
		(cmd(diffusealpha,0;croptop,1;glowshift;effectcolor1,color("1,0.5,0,1");effectcolor2,color("1,0,0,0.75");effectperiod,1;))(self)
	end;
	SetCommand=function(self)
		if getenv("wheelstop") == 1 then
			(cmd(stoptweening;diffusealpha,0;linear,0.05;diffusealpha,1;))(self)
		else (cmd(stoptweening;diffusealpha,0;))(self)
		end;
	end;
	AnimCommand=cmd(sleep,0.4;decelerate,0.3;croptop,0;diffusealpha,1;);
	NoAnimCommand=cmd(croptop,0;diffusealpha,1;);
	CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
	CurrentCourseChangedMessageCommand=cmd(playcommand,"Set");
};

--etc
t[#t+1] = LoadActor("_back_m")..{
	Name = 'Back_m';
	InitCommand=cmd(x,SCREEN_CENTER_X-214;y,SCREEN_CENTER_Y+83;croptop,1;);
	AnimCommand=cmd(sleep,0.25;accelerate,0.3;croptop,0;diffusealpha,1;glow,color("1,0.5,0,0");linear,0.05;glow,color("1,0.5,0,1");decelerate,0.4;glow,color("1,0.5,0,0"););
	NoAnimCommand=cmd(croptop,0;diffusealpha,1;);
};
	
t[#t+1] = LoadActor("_diff")..{
	Name = 'Diff';
	InitCommand=function(self)
		self:y(SCREEN_CENTER_Y+92);
		if IsNetConnected() then self:x(DifficultyListX()+10);
		else self:x(SCREEN_CENTER_X-54);
		end;
		(cmd(diffusealpha,0;zoomy,0;))(self)
	end;
	AnimCommand=cmd(sleep,0.2;decelerate,0.3;zoomy,1;diffusealpha,1;glow,color("1,0.5,0,0");linear,0.05;glow,color("1,0.5,0,1");decelerate,0.4;glow,color("1,0.5,0,0"););
	NoAnimCommand=cmd(zoomy,1;diffusealpha,1;);
	
};

t.OnCommand=function(self)
	--20160816
	local cback = self:GetChild('CBack');
	local back_m = self:GetChild('Back_m');
	local diff_f = self:GetChild('Diff');
	local screen = SCREENMAN:GetTopScreen();
	cback:visible(false);
	back_m:visible(false);
	diff_f:visible(false);
	if screen then
		if screen:GetName() ~= "ScreenSelectMusicCS" then
			cback:visible(true);
		end;
		if not IsNetConnected() then
			back_m:visible(true);
			diff_f:visible(true);
		end;
		if getenv("ReloadAnimFlag") == 1 then self:playcommand("NoAnim");
		else self:playcommand("Anim");
		end;
	end;
end;

return t;