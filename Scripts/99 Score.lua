--internals table
local Shared = {};
--Special Scoring types.
local r = {};
local DisabledScoringModes = { 'Hybrid' };
--the following metatable makes any missing value in a table 0 instead of nil.
local ZeroIfNotFound = { __index = function() return 0 end; };

function GetTotalItems(radars)
	local total = radars:GetValue('RadarCategory_TapsAndHolds')
	total = total + radars:GetValue('RadarCategory_Holds') 
	total = total + radars:GetValue('RadarCategory_Rolls')
	return math.max(1,total);
end;

-- Determine whether marvelous timing is to be considered.
function IsW1Allowed(tapScore)
	return (tapScore == 'TapNoteScore_W2')
		and ((PREFSMAN:GetPreference("AllowW1") ~= 'AllowW1_Never')
		or (GAMESTATE:IsCourseMode() and 
		PREFSMAN:GetPreference("AllowW1") == 'AllowW1_CoursesOnly'));
end;

-- Get the radar values directly. The individual steps aren't used much.
function GetDirectRadar(player)
	return GAMESTATE:GetCurrentSteps(player):GetRadarValues(player);
end;

local score = {0,0};
local tmp_Score = {0,0};

-----------------------------------------------------------
--DDR MAX2/Extreme Scoring by @sakuraponila
-----------------------------------------------------------
local ext_Steps = {0,0};
r['DDR Extreme'] = function(params, pss)
	local multLookup =
	{
		['TapNoteScore_W1'] = 10,
		['TapNoteScore_W2'] = (IsW1Allowed('TapNoteScore_W2')) and 9 or 10,
		['TapNoteScore_W3'] = 5
	};
	setmetatable(multLookup, ZeroIfNotFound);
	local steps = GAMESTATE:GetCurrentSteps(params.Player);
	local radarValues = GetDirectRadar(params.Player);
	local totalItems = GetTotalItems(radarValues);
	-- 1 + 2 + 3 + ... + totalItems value/の値
	local sTotal = (totalItems + 1) * totalItems / 2;
	local meter = steps:GetMeter();
	meter = (steps:IsAnEdit()) and 5 or math.min(10,meter);
	-- [en] score for one step
	-- [ja] 1ステップあたりのスコア
	local baseScore = meter * 10000000
	if (GAMESTATE:GetCurrentSong():IsMarathon()) then
		baseScore = baseScore * 3;
	elseif (GAMESTATE:GetCurrentSong():IsLong()) then
		baseScore = baseScore * 2;
	end;
	local sOne = math.floor(baseScore / sTotal);
	-- [en] measures for 5 points of units
	-- [ja] 5点単位のための処置
	sOne = sOne - sOne % 5;
	-- [en] because fractions are added by the last step, get value
	-- [ja] 端数は最後の1ステップで加算するのでその値を取得
	local sLast = baseScore - (sOne * sTotal);

	local p = (params.Player == 'PlayerNumber_P1') and 1 or 2;

	-- [en] initialized when score is 0
	-- [ja] スコアが0の時に初期化
	if pss:GetScore() == 0 then
		ext_Steps[p] = 0;
	end;
	-- [en] now step count
	-- [ja] 現在のステップ数
	if (params.TapNoteScore~='TapNoteScore_HitMine'
		and params.TapNoteScore~='TapNoteScore_AvoidMine'
		and params.TapNoteScore~='TapNoteScore_CheckpointHit'
		and params.TapNoteScore~='TapNoteScore_CheckpointMiss') then
		ext_Steps[p] = ext_Steps[p] + 1;
	end;
	-- [en] current score
	-- [ja] 今回加算するスコア（W1の時）
	local vScore = sOne * ext_Steps[p];
	pss:SetCurMaxScore(pss:GetCurMaxScore() + vScore);
	-- [ja] 判定によって加算量を変更
	if (params.HoldNoteScore == 'HoldNoteScore_Held') then
	-- [ja] O.K.判定時は問答無用で満点
		vScore = vScore;
	else
		-- [en] non-long note scoring
		-- [ja] N.G.判定時は問答無用で0点
		-- [ja] それ以外ということは、ロングノート以外の判定である
		vScore = (params.HoldNoteScore == 'HoldNoteScore_LetGo')
			 and 0 or vScore * multLookup[params.TapNoteScore] / 10;
		-- [en] measures for 5 points of units
		-- [ja] ここでも5点単位のための処置
		vScore = vScore - vScore % 5
	end;
	pss:SetScore(pss:GetScore() + vScore);
	-- if one of the last step, add the fractions
	-- [ja] 最後の1ステップの場合、端数を加算する
	if ((vScore > 0) and (ext_Steps[p] == totalItems)) then
		pss:SetScore(pss:GetScore() + sLast);
	end;
end;

-----------------------------------------------------------
--DDR SuperNOVA scoring
-----------------------------------------------------------
r['DDR SuperNOVA'] = function(params, pss)
	local radarValues = GetDirectRadar(params.Player);
	local totalItems = GetTotalItems(radarValues)
	local p = (params.Player == 'PlayerNumber_P1') and 1 or 2;
	local stepScore = string.format("%f",(10000000/totalItems));

	if pss:GetScore() == 0 then
		tmp_Score[p] = 0;
		score[p] = 0;
	end;
	
	local oneStepScore =
	{
		['TapNoteScore_W1'] = stepScore,
		['TapNoteScore_W2'] = stepScore/2,
		['TapNoteScore_W3'] = stepScore/3,
		['TapNoteScore_W4'] = 0,
		['TapNoteScore_W5'] = 0,
		['TapNoteScore_Miss'] = 0,
		['TapNoteScore_HitMine'] = 0,
		['TapNoteScore_AvoidMine'] = 0,
		['TapNoteScore_CheckpointMiss'] = 0,
		['TapNoteScore_CheckpointHit'] = 0
	};
	setmetatable(oneStepScore, ZeroIfNotFound);
	local add = 0;
	
	if params.HoldNoteScore == 'HoldNoteScore_Held' then
		add = stepScore;
	elseif (params.HoldNoteScore == 'HoldNoteScore_LetGo') then
		add = 0;
	else
		add = oneStepScore[params.TapNoteScore];
	end
	
	tmp_Score[p] = tmp_Score[p] + add;
	score[p] = math.min(tmp_Score[p],10000000);
	pss:SetScore(score[p]);
end;

-----------------------------------------------------------
--DDR SuperNOVA 2 scoring
-----------------------------------------------------------
r['DDR SuperNOVA 2'] = function(params, pss)
	local radarValues = GetDirectRadar(params.Player);
	local totalItems = GetTotalItems(radarValues);	
	local p = (params.Player == 'PlayerNumber_P1') and 1 or 2;
	local stepScore = string.format("%1.3f",(1000000/totalItems));
	
	if pss:GetScore() == 0 then
		tmp_Score[p] = 0;
		score[p] = 0;
	end;
	
	local oneStepScore =
	{
		['TapNoteScore_W1'] = stepScore,
		['TapNoteScore_W2'] = stepScore-10,
		['TapNoteScore_W3'] = (stepScore/2)-10,
		['TapNoteScore_W4'] = 0,
		['TapNoteScore_W5'] = 0,
		['TapNoteScore_Miss'] = 0,
		['TapNoteScore_HitMine'] = 0,
		['TapNoteScore_AvoidMine'] = 0,
		['TapNoteScore_CheckpointMiss'] = 0,
		['TapNoteScore_CheckpointHit'] = 0
	};
	setmetatable(oneStepScore, ZeroIfNotFound);
	local add = 0;
	
	if params.HoldNoteScore == 'HoldNoteScore_Held' then
		add = stepScore;
	elseif (params.HoldNoteScore == 'HoldNoteScore_LetGo') then
		add = 0;
	else
		add = oneStepScore[params.TapNoteScore];
	end
	
	tmp_Score[p] = tmp_Score[p] + add;
	score[p] = math.min(round(tmp_Score[p],-1),1000000);
	pss:SetScore(score[p]);
end;

-----------------------------------------------------------
--DDR A scoring
-----------------------------------------------------------
r['DDR A'] = function(params, pss)
	local radarValues = GetDirectRadar(params.Player);
	local totalItems = GetTotalItems(radarValues);	
	local p = (params.Player == 'PlayerNumber_P1') and 1 or 2;
	local stepScore = string.format("%1.3f",(1000000/totalItems));
	
	if pss:GetScore() == 0 then
		tmp_Score[p] = 0;
		score[p] = 0;
	end;
	
	local oneStepScore =
	{
		['TapNoteScore_W1'] = stepScore,
		['TapNoteScore_W2'] = stepScore-10,
		['TapNoteScore_W3'] = (stepScore*0.6)-10,
		['TapNoteScore_W4'] = (stepScore*0.2)-10,
		['TapNoteScore_W5'] = 0,
		['TapNoteScore_Miss'] = 0,
		['TapNoteScore_HitMine'] = 0,
		['TapNoteScore_AvoidMine'] = 0,
		['TapNoteScore_CheckpointMiss'] = 0,
		['TapNoteScore_CheckpointHit'] = 0
	};
	setmetatable(oneStepScore, ZeroIfNotFound);
	local add = 0;
	
	if params.HoldNoteScore == 'HoldNoteScore_Held' then
		add = stepScore;
	elseif (params.HoldNoteScore == 'HoldNoteScore_LetGo') then
		add = 0;
	else
		add = oneStepScore[params.TapNoteScore];
	end
	
	tmp_Score[p] = tmp_Score[p] + add;
	score[p] = math.min(round(tmp_Score[p],-1),1000000);
	pss:SetScore(score[p]);
end;

------------------------------------------------------------
--Marvelous Incorporated Grading System (or MIGS for short)
--basically like DP scoring with locked DP values
------------------------------------------------------------
r['MIGS'] = function(params,pss)
	local curScore = 0;
	local tapScoreTable = 
	{ 
		['TapNoteScore_W1'] = 3,
		['TapNoteScore_W2'] = 2,
		['TapNoteScore_W3'] = 1,
		['TapNoteScore_W5'] = -4,
		['TapNoteScore_Miss'] = -8
	};
	for k,v in pairs(tapScoreTable) do
		curScore = curScore + ( pss:GetTapNoteScores(k) * v );
	end;
	curScore = math.max(0,curScore + ( pss:GetHoldNoteScores('HoldNoteScore_Held') * 6 ));
	pss:SetScore(curScore);
end;

-------------------------------------------------------------------------------
-- Formulas end here.
for v in ivalues(DisabledScoringModes) do r[v] = nil end
Scoring = r;

function UserPrefScoringMode()
	local t = {
		Name = "UserPrefScoringMode";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = false;
		Choices = { 'Hybrid', 'DDR A', 'DDR SuperNOVA 2', 'DDR SuperNOVA', 'DDR Extreme', 'MIGS' };
		LoadSelections = function(self, list, pn)
			local set = true
			for i, c in ipairs(self.Choices) do
				if c == GetAdhocPref("CSScoringMode") then
					list[i] = true
					set = false
					break
				end
			end;
			if set == true then
				list[1] = true
			end;
		end;
		SaveSelections = function(self, list, pn)
			for i, c in ipairs(self.Choices) do
				if list[i] then
					SetAdhocPref("CSScoringMode",c)
				end
			end;
		end;
	};
	setmetatable( t, t );
	return t;
end;
