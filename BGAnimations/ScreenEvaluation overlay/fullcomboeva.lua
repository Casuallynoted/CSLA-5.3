local pn = ...
assert(pn);

local t = Def.ActorFrame{};

local pm = GAMESTATE:GetPlayMode();
local ssStats = STATSMAN:GetCurStageStats();
local pnstats = ssStats:GetPlayerStageStats(pn);
local kflag = 0;
local fpc = (pn == PLAYER_1) and getenv("fcplayercheck_p1") or getenv("fcplayercheck_p2");
local fcj = (pn == PLAYER_1) and getenv("fullcjudgep1") or getenv("fullcjudgep2");
local yadd = -10;
if pm ~= 'PlayMode_Battle' and pm ~= 'PlayMode_Rave' then yadd = 16;
end;

t[#t+1] = Def.ActorFrame{
	InitCommand=function(self)
		self:visible(false);
		if pn == PLAYER_1 then
			self:x(SCREEN_CENTER_X * 0.55 - 20);
		else self:x(SCREEN_CENTER_X * 1.55 - 20);
		end;
		if THEME:GetMetric( Var "LoadingScreen","Summary" ) == false and fpc == 0 then
			if tonumber(fcj) > 0 and tonumber(fcj) < 5 then self:visible(true);
			end;
		end;
	end;

	LoadActor("lineeffect")..{
	};

	LoadActor(THEME:GetPathG("","combo01"))..{
		InitCommand=cmd(y,SCREEN_CENTER_Y;zoom,0;);
		BeginCommand=cmd(playcommand,"Set");
		SetCommand=function(self)
			self:diffuse(color("0.8,1,0,1"));
			if kflag == 0 then
				(cmd(linear,0.1;zoomx,5;zoomy,0.3;decelerate,0.6;zoomx,1;accelerate,0.2;zoomy,1;sleep,0.8;linear,0.2;glowshift;effectperiod,0.2;
				effectcolor1,color("1,1,1,0");effectcolor2,color("0.8,0.3,0,1");linear,0.3;zoom,0.35;x,92;y,SCREEN_CENTER_Y-33+yadd))(self);
			end;
		end;
		UpdateNetEvalStatsMessageCommand=function(self, params)
			if params.Difficulty == pnstats:GetPlayedSteps()[1]:GetDifficulty() then
				if params.Score == pnstats:GetScore() then
					self:queuecommand("Set");
				else self:queuecommand("NotNet");
				end;
			else self:queuecommand("NotNet");
			end;
		end;
		NotNetCommand=cmd(diffuse,color("0,0,0,0"););
	};

	LoadActor(THEME:GetPathB("","graph"))..{
		InitCommand=function(self)
			if pm ~= 'PlayMode_Battle' and pm ~= 'PlayMode_Rave' then
				self:x(-108);
			else self:x(-58);
			end;				
			(cmd(y,SCREEN_CENTER_Y-94+16;zoom,0;))(self)
		end;
		BeginCommand=cmd(playcommand,"Set");
		SetCommand=function(self)
			if kflag == 0 then (cmd(linear,1;zoom,0.4;diffusealpha,1;rotationy,-30;rotationx,70;rotationz,100;spin;effectmagnitude,0,0,-200))(self)
			else (cmd(zoom,0.4;diffusealpha,1;rotationy,-30;rotationx,70;rotationz,100;spin;effectmagnitude,0,0,-200))(self)
			end;
		end;
		UpdateNetEvalStatsMessageCommand=function(self, params)
			if params.Difficulty == pnstats:GetPlayedSteps()[1]:GetDifficulty() then
				if params.Score == pnstats:GetScore() then
					self:queuecommand("Set");
				else self:queuecommand("NotNet");
				end;
			else self:queuecommand("NotNet");
			end;
		end;
		NotNetCommand=cmd(diffusealpha,0;);
	};
		
	LoadActor(THEME:GetPathB("","graph"))..{
		InitCommand=function(self)
			if pm ~= 'PlayMode_Battle' and pm ~= 'PlayMode_Rave' then
				self:x(-108);
			else self:x(-58);
			end;	
			(cmd(y,SCREEN_CENTER_Y-104+16;diffuse,color("1,0.8,0,1");zoom,0;))(self)
		end;
		BeginCommand=cmd(playcommand,"Set");
		SetCommand=function(self)
			if kflag == 0 then (cmd(linear,1;zoom,0.4;diffusealpha,1;rotationy,30;rotationx,70;rotationz,100;spin;effectmagnitude,60,100,-200))(self)
			else (cmd(zoom,0.4;diffusealpha,1;rotationy,30;rotationx,70;rotationz,100;spin;effectmagnitude,60,100,-200))(self)
			end;
		end;
		UpdateNetEvalStatsMessageCommand=function(self, params)
			if params.Difficulty == pnstats:GetPlayedSteps()[1]:GetDifficulty() then
				if params.Score == pnstats:GetScore() then
					self:queuecommand("Set");
				else self:queuecommand("NotNet");
				end;
			else self:queuecommand("NotNet");
			end;
		end;
		NotNetCommand=cmd(diffusealpha,0;);
	};

	Def.Sprite {
		InitCommand=function(self)
			self:y(SCREEN_CENTER_Y-33+yadd);
			(cmd(x,52;horizalign,right;zoom,0.35;zoomy,0;sleep,1.6;linear,0.2;zoomy,0.375;
			glowshift;effectperiod,0.2;effectcolor1,color("1,1,1,0");effectcolor2,color("0.8,0.3,0,1");))(self)
		end;
		BeginCommand=cmd(playcommand,"Set");
		SetCommand=function(self)
			self:diffusealpha(1);
			local hp = GAMESTATE:IsHumanPlayer(pn);
			if hp then
				if tonumber(fcj) == 1 then
					self:visible(true);
					self:Load(THEME:GetPathB("ScreenEvaluation","overlay/Award FullComboMarvelous"));
				elseif tonumber(fcj) == 2 then
					self:visible(true);
					self:Load(THEME:GetPathB("ScreenEvaluation","overlay/Award FullComboPerfects"));
				elseif tonumber(fcj) == 3 then
					self:visible(true);
					self:Load(THEME:GetPathB("ScreenEvaluation","overlay/Award FullComboGreates"));
				else
					self:visible(false);
					if GetAdhocPref("GoodCombo") == "TapNoteScore_W4" then
						if tonumber(fcj) == 4 then
							self:visible(true);
							self:Load(THEME:GetPathB("ScreenEvaluation","overlay/Award FullComboGoods"));
						end;
					end;
				end;
			end;
		end;
		UpdateNetEvalStatsMessageCommand=function(self, params)
			if params.Difficulty == pnstats:GetPlayedSteps()[1]:GetDifficulty() then
				if params.Score == pnstats:GetScore() then
					kflag = 1;
					self:queuecommand("Set");
				else self:queuecommand("NotNet");
				end;
			else self:queuecommand("NotNet");
			end;
		end;
		NotNetCommand=cmd(diffusealpha,0;);
	};
};

return t;