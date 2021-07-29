
local t = Def.ActorFrame {};

local cStage = "";
local maxStages = PREFSMAN:GetPreference("SongsPerPlay");
local pm = GAMESTATE:GetPlayMode();

if GAMESTATE:IsCourseMode() then
	cStage = 'Stage_'..ToEnumShortString(pm);
elseif GAMESTATE:IsEventMode() then
	cStage = 'Stage_Event';
else
	local stagetable = {};
	setmetatable( stagetable, { __index = function() return 1 end; } );
	local mStages = STATSMAN:GetStagesPlayed();
	local v = mStages;
	while v > 0 do
		local i = 1;
		if v then i = v;
		end;
		
		local w;
		if i == mStages then w = 1;
		elseif i == mStages - 1 then w = 2;
		elseif i == mStages - 2 then w = 3;
		elseif i == mStages - 3 then w = 4;
		elseif i == mStages - 4 then w = 5;
		elseif i == mStages - 5 then w = 6;
		elseif i == mStages - 6 then w = 7;
		else w = 1;
		end;
		
		local ssStats = STATSMAN:GetPlayedStageStats( i );
		local iStage = ssStats:GetStageIndex();
		iStage = iStage + 1;
		local pStage = ssStats:GetStage();
		local sssong = ssStats:GetPlayedSongs()[1];
		
		local stageStr = "1st";
		cStage = estage_set(w,stagetable,pStage,sssong,maxStages);
		v = v - 1;
	end;
end;

t[#t+1] = Def.ActorFrame {
	Def.Sprite {
		InitCommand=function(self)
			self:Load( THEME:GetPathG("","_stages/_selmusic "..cStage) );
		end;
		OnCommand=THEME:GetMetric(Var "LoadingScreen","StageDisplayOnCommand");
		OffCommand=function(self)
			--[ja] 1ステージの時AllowExtraStageの状態を戻すのを忘れていた(20140813)
			if maxStages == 1 and cStage == 'Stage_Final' then
				PREFSMAN:SetPreference("AllowExtraStage",GetAdhocPref("envAllowExtraStage"));
			end;
		end;
	};
};

return t;