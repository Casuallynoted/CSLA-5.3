local t = Def.ActorFrame {};

local coursemode = GAMESTATE:IsCourseMode();
local ccourse = GAMESTATE:GetCurrentCourse();
local pm = GAMESTATE:GetPlayMode();

local iStage = 0;
local cStage = GAMESTATE:GetCurrentStage();

--20160421
if coursemode then
	t[#t+1] = LoadFont("_um")..{
		InitCommand=cmd(playcommand,"Set");
		SetCommand=function(self)
			if ccourse then
				if ccourse:GetCourseType() == 'CourseType_Endless' or ccourse:GetCourseType() == 'CourseType_Survival' then
					self:settext( math.max(1,iStage) );
				else
					self:settext( math.max(1,iStage) .. " / " .. ccourse:GetEstimatedNumStages() );
					--self:settext( "100000000000000" );
				end;
				setenv("coursestindex",math.max(1,iStage));
			end;
			self:skewx(-0.2);
			self:maxwidth(120);
			self:diffuse(color("1,0.65,0,1"));
		end;
		OnCommand=THEME:GetMetric(Var "LoadingScreen","StageDisplayOnCommand");
		UpdateCommand=cmd(playcommand,"Set";);
		CurrentSongChangedMessageCommand=function(self)
			iStage = iStage + 1;
			self:playcommand("Set");
		end;
	};
elseif IsNetConnected() then
	t[#t+1] = LoadActor(THEME:GetPathG("","_stages/_selmusic Stage_Event")) .. {
		OnCommand=THEME:GetMetric(Var "LoadingScreen","StageDisplayOnCommand");
	};
else
	iStage = cstage_set(cStage);
	t[#t+1] = Def.Sprite {
		InitCommand=function(self)
			cStage = cstage_imagse_set(iStage);
			self:Load( THEME:GetPathG("","_stages/_selmusic "..cStage) );
		end;
		OnCommand=THEME:GetMetric(Var "LoadingScreen","StageDisplayOnCommand");
	};
end;

return t;