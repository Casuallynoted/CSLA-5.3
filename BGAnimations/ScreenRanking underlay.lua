local t = Def.ActorFrame{};

local ScreenName = Var "LoadingScreen";
local metricscoretype = THEME:GetMetric(ScreenName, "HighScoresType");

t[#t+1] = LoadActor("_ranking")..{
};

t[#t+1] = Def.Sprite{
	InitCommand=function(self)
		self:x(SCREEN_CENTER_X-100);
		if metricscoretype == "HighScoresType_AllSteps" then
			self:Load(THEME:GetPathB("ScreenStageInformation","in/mode/mode_regular"));
			(cmd(y,SCREEN_TOP+52;horizalign,right;zoomy,0;sleep,0.1;decelerate,0.4;zoomy,1;))(self)
		elseif metricscoretype == "HighScoresType_NonstopCourses" then
			self:Load(THEME:GetPathB("ScreenStageInformation","in/stageregular_effect/_label Stage_Nonstop"));
			(cmd(y,SCREEN_TOP+50;horizalign,right;zoom,0.675;zoomy,0;sleep,0.1;decelerate,0.4;zoomy,0.675;))(self)
		elseif metricscoretype == "HighScoresType_OniCourses" then
			self:Load(THEME:GetPathB("ScreenStageInformation","in/stageregular_effect/_label Stage_Oni"));
			(cmd(y,SCREEN_TOP+50;horizalign,right;zoom,0.675;zoomy,0;sleep,0.1;decelerate,0.4;zoomy,0.675;))(self)
		else self:visible(false);
		end;
	end;
};

t[#t+1] = Def.Sprite{
	InitCommand=function(self)
		if string.find(ScreenName,"Solo") then
			self:Load(THEME:GetPathB("ScreenStageInformation","in/mode/_style Solo"));
		elseif string.find(ScreenName,"Double") then
			self:Load(THEME:GetPathB("ScreenStageInformation","in/mode/_style Double"));
		else self:Load(THEME:GetPathB("ScreenStageInformation","in/mode/_style Single"));
		end;
		(cmd(x,SCREEN_CENTER_X-100;y,SCREEN_TOP+64;horizalign,right;zoomy,0;sleep,0.1;decelerate,0.4;zoomy,1;))(self)
	end;
};

t[#t+1] = Def.Sprite{
	InitCommand=function(self)
		self:horizalign(left);
		self:x(SCREEN_CENTER_X-110);
		self:y(SCREEN_TOP+56);
		if metricscoretype == "HighScoresType_AllSteps" then
			self:Load(THEME:GetPathB("","_ranking/diff"));
			(cmd(cropleft,1;cropleft,-0.3;diffusealpha,0;accelerate,0.4;cropright,-0.3;diffusealpha,1;))(self)
		elseif metricscoretype == "HighScoresType_NonstopCourses" or metricscoretype == "HighScoresType_OniCourses" then
			self:Load(THEME:GetPathB("","_ranking/coursediff"));
			(cmd(cropleft,1;cropleft,-0.3;diffusealpha,0;accelerate,0.4;cropright,-0.3;diffusealpha,1;))(self)
		else self:visible(false);
		end;
	end;
};
	
return t;