local pn = ...
assert(pn,"Must pass in a player, dingus");

--local pm = GAMESTATE:GetPlayMode();
local coursetype = "normal";
local SongOrCourse;
if GAMESTATE:IsCourseMode() then
	local course = GAMESTATE:GetCurrentCourse();
	if course:GetCourseType() == 'CourseType_Endless' or course:GetCourseType() == 'CourseType_Survival' then
		coursetype = "endless";
	end;
end;

local t = Def.ActorFrame{
	Name="EvaluationFrame"..pn;
	BeginCommand=function(self)
		self:visible(GAMESTATE:IsHumanPlayer(pn));
	end;
	PlayerJoinedMessageCommand=function(self,param)
		if param.Player == pn then
			self:visible(true);
		end;
	end;
	PlayerUnjoinedMessageCommand=function(self,param)
		if param.Player == pn then
			self:visible(false);
		end;
	end;
};

t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(x,GetGraphPosX(pn)-26;y,SCREEN_CENTER_Y);

	LoadActor("_graph_back")..{
		InitCommand=cmd(x,-6;y,-98;rotationz,180;diffusealpha,0.6;);
		OnCommand=cmd(croptop,1;sleep,0.1;decelerate,0.5;croptop,0;);
	};

	LoadActor("_graph_back")..{
		InitCommand=cmd(x,6;y,-48;diffusealpha,0.6;);
		OnCommand=cmd(croptop,1;sleep,0.1;decelerate,0.5;croptop,0;);
	};
	
	Def.Sprite{
		InitCommand=cmd(x,-84;y,-19;);
		OnCommand=function(self)
			if pn == PLAYER_1 then self:Load(THEME:GetPathB("ScreenEvaluation","underlay/_player1"));
			else self:Load(THEME:GetPathB("ScreenEvaluation","underlay/_player2"));
			end;
			(cmd(diffusealpha,0;zoom,1.5;sleep,0.075;accelerate,0.4;diffusealpha,1;zoom,1;))(self)
		end;
	};

	LoadActor("_text_back")..{
		InitCommand=function(self)
			self:visible(false);
			if coursetype ~= "endless" then
				self:visible(true);
			end;
			self:x(16);
			self:y(-4);
		end;
		OnCommand=cmd(croptop,1;sleep,0.1;decelerate,0.5;croptop,0;);
	};

	LoadActor("_graph_top")..{
		InitCommand=function(self)
			self:visible(false);
			if coursetype ~= "endless" then
				self:visible(true);
			end;
			self:x(10);
			self:y(-90+16);
		end;
		OnCommand=cmd(cropbottom,1;sleep,0.3;decelerate,0.3;cropbottom,0;);
	};

	LoadActor("grade_frame")..{
		InitCommand=function(self)
			self:visible(false);
			if coursetype ~= "endless" then
				self:visible(true);
			end;
			self:y(14);
		end;
		OnCommand=cmd(cropleft,1;addx,20;sleep,0.1;decelerate,0.4;cropleft,0;addx,-20;);
	};

	LoadActor("exscore_frame")..{
		InitCommand=function(self)
			self:visible(false);
			if coursetype ~= "endless" then
				self:visible(true);
			end;
			self:y(36);
		end;
		OnCommand=cmd(cropleft,1;addx,20;sleep,0.15;decelerate,0.4;cropleft,0;addx,-20;);
	};

	LoadActor("target_frame")..{
		InitCommand=function(self)
			self:visible(false);
			if coursetype ~= "endless" then
				self:visible(true);
			end;
			self:y(62);
		end;
		OnCommand=cmd(cropleft,1;addx,20;sleep,0.2;decelerate,0.4;cropleft,0;addx,-20;);
	};
	
	LoadActor("fastslow_frame")..{
		InitCommand=function(self)
			if coursetype == "endless" then
				self:y(118);
			else self:y(158);
			end;
		end;
		OnCommand=cmd(cropright,1;addx,-20;sleep,0.175;decelerate,0.4;cropright,0;addx,20;);
	};
};

t[#t+1] = Def.Sprite{
	InitCommand=function(self)
		self:x(GetGraphPosX(pn)-26);
		if coursetype == "endless" then
			self:Load(THEME:GetPathB("ScreenEvaluation","underlay/time_frame"));
			self:y(SCREEN_CENTER_Y-46);
		else
			self:Load(THEME:GetPathB("ScreenEvaluation","underlay/score_frame"));
			self:y(SCREEN_CENTER_Y+180);
		end;
	end;
	OnCommand=cmd(cropright,1;addx,-20;sleep,0.125;decelerate,0.4;cropright,0;addx,20;);
};

return t;