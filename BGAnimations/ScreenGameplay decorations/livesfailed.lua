local pn = ...;
assert(pn);

local t = Def.ActorFrame{};
local p = ( (pn == "PlayerNumber_P1") and 1 or 2 );

t[#t+1] = Def.Sprite {
	LivesFailedMessageCommand=function(self,param)
		self:stoptweening();
		local vset = true;
		local holizset = {left,right};
		if param.Player == pn then
			self:zoom(1.4);
			if pn == PLAYER_1 then
				if not GAMESTATE:IsCourseMode() then
					local p1diff = GAMESTATE:GetCurrentSteps(PLAYER_1):GetDifficulty();
					if not GAMESTATE:IsEventMode() and 
					GAMESTATE:GetCurrentStage() == "Stage_1st" and p1diff == 'Difficulty_Beginner' then
						vset = false;
					end;
				end;
			else
				if not GAMESTATE:IsCourseMode() then
					local p2diff = GAMESTATE:GetCurrentSteps(PLAYER_2):GetDifficulty();
					if not GAMESTATE:IsEventMode() and 
					GAMESTATE:GetCurrentStage() == "Stage_1st" and p2diff == 'Difficulty_Beginner' then
						vset = false;
					end;
				end;
			end;
			self:visible(vset);
			self:horizalign(holizset[p]);
			self:Load( THEME:GetPathB("ScreenGameplay","decorations/battery_failed_"..ToEnumShortString(pn) ) );
			(cmd(glow,color("0,0,0,0");diffusealpha,0;linear,0.1;glow,color("1,0,0,1");
			decelerate,0.2;zoom,1;diffusealpha,1;glow,color("0,0,0,0")))(self)
		end;
	end;
};

return t;