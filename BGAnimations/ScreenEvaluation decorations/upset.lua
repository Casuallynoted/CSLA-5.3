local pn = ...
assert(pn,"Must pass in a player, dingus");

local IsAStage = not THEME:GetMetric( Var "LoadingScreen","Summary" ) and not GAMESTATE:IsCourseMode();
setenv("onpurposefailgradep1","");
setenv("onpurposefailgradep2","");

local p_count_check = false;
if #GAMESTATE:GetHumanPlayers() > 1 then
	p_count_check = true;
end;

--stepseconds = SorCTime;
--aliveseconds = getenv("aseconds") = hs["SurvivalSeconds"];

scf = "^(-?[ %d]+)([ %d][ %d][ %d])";
spo = ",";
spt = "x";

local rtset = "";

local hs = {};
hs_local_set(hs,0);

local bs = {};
hs_local_set(bs,0);

local ns = {};
hs_local_set(ns,0);

--20160718
local diff_n = {
	Beginner	= 1,
	Easy		= 2,
	Medium	= 3,
	Hard		= 4,
	Challenge	= 5,
};
setmetatable( diff_n, { __index = function() return 1 end; } );

local nGrade = {
	Grade_Tier01 = "MAX";
	Grade_Tier02 = "Grade_Tier01";
	Grade_Tier03 = "Grade_Tier02";
	Grade_Tier04 = "Grade_Tier03";
	Grade_Tier05 = "Grade_Tier04";
	Grade_Tier06 = "Grade_Tier05";
	Grade_Tier07 = "Grade_Tier06";
	Grade_Failed = nil;
	Grade_None = nil;
};
setmetatable( nGrade, { __index = function() return nil end; } );

local nGradeSM = {
	Grade_Tier01 = "MAX";
	Grade_Tier02 = "MAX";
	Grade_Tier03 = "Grade_Tier02";
	Grade_Tier04 = "Grade_Tier03";
	Grade_Tier05 = "Grade_Tier04";
	Grade_Tier06 = "Grade_Tier05";
	Grade_Tier07 = "Grade_Tier06";
	Grade_Failed = nil;
	Grade_None = nil;
};
setmetatable( nGradeSM, { __index = function() return nil end; } );

local fullcombo_set_color = {"1,1,1","1,0.8,0.2","0,1,0.2","0.2,0.75,1"};
setmetatable( fullcombo_set_color, { __index = function() return "1,1,1" end; } );

local scfsst = {0,0};

local low_pic_d = "GradeLowPic/GradeDisplayEval";
local ss = {ntype = "Grade_None",default = "Grade_None"};
local st = GAMESTATE:GetCurrentStyle();
local pm = GAMESTATE:GetPlayMode();
local ssStats = STATSMAN:GetCurStageStats();
local pnstats = ssStats:GetPlayerStageStats(pn);
local failed;
local judgewidth = 280;
local fcheck = 5;
local bsp1fullcombo = 0;
local bsp2fullcombo = 0;
local bsMIGS = {ntype = 0,default = 0};
local hsMIGS = {ntype = 0,default = 0};
local MIGS_MAX = {ntype = 0,default = 0};
local tMIGS_MAX = {ntype = 0,default = 0};
local htGrade = {ntype = "Grade_None",default = "Grade_None"};
local btGrade = {ntype = "Grade_None",default = "Grade_None"};
local psStats = STATSMAN:GetPlayedStageStats(1);
local p = ( (pn == PLAYER_1) and 1 or 2 );
local pct = 0;
local calories = pnstats:GetCaloriesBurned();
--20160425
local icheck = insertchecker(pn,"noset","controller_auto");
local cboxset = getenv("pjcountp"..p);

local targetset = 0;
local adhoc = {ntype = 0,default = 0};
local targethsMIGS = 0;
--Trace("Score:".. STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):GetScore());

local p1str = ProfIDSet(1);
local p2str = ProfIDSet(2);
local pstr = ProfIDSet(p);
local modstr = GAMESTATE:GetPlayerState(pn):GetPlayerOptionsString("ModsLevel_Preferred");

local adgraph = ProfIDPrefCheck("ScoreGraph",pstr,"Off");
local adtype = ProfIDPrefCheck("GraphType",pstr,"CS");
local ad_t_table = {CS = "ntype",SM = "default"};
setmetatable( ad_t_table, { __index = function() return "ntype" end; } );
--local adgstr = split("_",adgraph);

local gset = judge_initial(pstr);
local codechangeset = 1;
local nextgrade;
--[[
if not IsNetConnected() then
	if pm ~= 'PlayMode_Battle' and pm ~= 'PlayMode_Rave' then
		codechangeset = 1;
	end;
end;
]]
local getp;
local getplayer;
if GAMESTATE:GetNumPlayersEnabled() == 1 then
	if GAMESTATE:GetMasterPlayerNumber() == "PlayerNumber_P1" then 
		getplayer = "PlayerNumber_P1"
		getp = 1;
	else
		getplayer = "PlayerNumber_P2"
		getp = 2;
	end;
else
	if GAMESTATE:GetMasterPlayerNumber() == "PlayerNumber_P1" then
		getplayer = "PlayerNumber_P2"
		getp = 2;
	else
		getplayer = "PlayerNumber_P1"
		getp = 1;
	end;
end;

local songdir;
local cautogen = 0;
--local start = psStats:GetPlayedSongs()[1]:GetFirstSecond();
local stepseconds = 0;
local aliveseconds = 0;
local coursetype = true;
local SongOrCourse = CurSOSet();
local StepsOrTrail = CurSTSet(pn);
steps_count(hs,SongOrCourse,StepsOrTrail,pn,"C_Mines");
local mset = 0;
local iset = {0,0};
local st_set;
local diff_set;

if GAMESTATE:IsCourseMode() then
	local co_stage = SongOrCourse:GetEstimatedNumStages();
	local stindex = getenv("coursestindex");
	if stindex >= co_stage then
		stepseconds = stindex;
	else stepseconds = stindex + 10;
	end;
	if SongOrCourse:IsAutogen() then
		cautogen = 1;
	end;
	if SongOrCourse:GetCourseType() == 'CourseType_Endless' or SongOrCourse:GetCourseType() == 'CourseType_Survival' then
		cautogen = 1;
		coursetype = false;
	else songdir = SongOrCourse:GetCourseDir();
	end;
	aliveseconds = pnstats:GetSongsPassed();
else
	songdir = SongOrCourse:GetSongDir();
	stepseconds = psStats:GetPlayedSongs()[1]:GetLastSecond();
	aliveseconds = getenv("aseconds");
end;
if getenv("tstepsp"..p) then
	hs["TotalSteps"] = math.max(getenv("tstepsp"..p),hs["TotalSteps"]);
end;
if getenv("tholdsp"..p) then
	hs["RadarCategory_Holds"] = math.max(getenv("tholdsp"..p),hs["RadarCategory_Holds"]);
	if getenv("tholdsp"..p) > 0 then
		hs["RadarCategory_Rolls"] = 0;
	end;
end;
--SCREENMAN:SystemMessage(getenv("tstepsp"..p)..","..getenv("tholdsp"..p));

bs["TotalSteps"] = hs["TotalSteps"];
bs["RadarCategory_Holds"] = hs["RadarCategory_Holds"];
bs["RadarCategory_Rolls"] = hs["RadarCategory_Rolls"];

local nsetstd = st:GetStepsType().."_"..ToEnumShortString(StepsOrTrail:GetDifficulty());
local weight;
local todaycalories;

local statsCategoryValues = {
	{ Category = "TapNoteScore_W1" },
	{ Category = "TapNoteScore_W2" },
	{ Category = "TapNoteScore_W3" },
	{ Category = "HoldNoteScore_Held" },
	{ Category = "TapNoteScore_W4" },
	{ Category = "TapNoteScore_W5" },
	{ Category = "TapNoteScore_Miss" },
	{ Category = "MaxCombo" },
};

local restatsCategoryValues = {
	{ Category = "TapNoteScore_W1" , Color = Colors.Judgment["JudgmentLine_W1"] },
	{ Category = "TapNoteScore_W2" , Color = Colors.Judgment["JudgmentLine_W2"] },
	{ Category = "TapNoteScore_W3" , Color = Colors.Judgment["JudgmentLine_W3"] },
	{ Category = "TapNoteScore_W4" , Color = Colors.Judgment["JudgmentLine_W4"] },
	{ Category = "TapNoteScore_W5" , Color = Colors.Judgment["JudgmentLine_W5"] },
	{ Category = "TapNoteScore_Miss" , Color = Colors.Judgment["JudgmentLine_Miss"] },
	{ Category = "None" , Color = color("0.5,0.5,0.5,0.5") },
};
local restatsHoldCategoryValues = {
	{ Category = "HoldNoteScore_Held" , Color = Colors.Judgment["JudgmentLine_Held"] },
	{ Category = "HoldNoteScore_LetGo" , Color = Colors.Judgment["JudgmentLine_LetGo"] },
	{ Category = "None" , Color = color("0.5,0.5,0.5,0.5") },
};
--------------------------------------------------------------------------------------------------------
-- [ja] 今回のスコア
if pnstats then
	hs_set(hs,pnstats,"pnstats");
	hs["SurvivalSeconds"]	= pnstats:GetSurvivalSeconds();
	failed = pnstats:GetFailed();
	if icheck or tonumber(getenv("fcplayercheck_p"..p)) == 1 then
		iset[1] = 1;
	end;
end;
if failed then
	htGrade["ntype"] = "Grade_Failed";
	htGrade["default"] = "Grade_Failed";
end;

--[ja] ベストスコア
local scorelist;
local scores;
local topscore;
local snum = 1;

if SongOrCourse and StepsOrTrail then
	local profile = c_profile(pn);
	
	weight = profile:GetWeightPounds();
	todaycalories = profile:GetCaloriesBurnedToday();
	scorelist = profile:GetHighScoreList(SongOrCourse,StepsOrTrail);
	assert(scorelist);
	scores = scorelist:GetHighScores();
	topscore = scores[1];
	--SCREENMAN:SystemMessage(tostring(icheck));
	if not icheck and tonumber(getenv("fcplayercheck_p"..p)) == 0 then
		if topscore and #scores > 1 then
			if topscore:GetPercentDP() == pnstats:GetPercentDancePoints() then
				snum = snum + 1;
			end;
			snum = snum_set(snum,scores,pn);
			--SCREENMAN:SystemMessage(snum);
			if snum > 0 then
				topscore = scores[snum];
				if topscore then
					hs_set(bs,topscore,"normal");
					bs["MaxCombo"]				= topscore:GetMaxCombo();
					bs["SurvivalSeconds"]			= topscore:GetSurvivalSeconds()
					if tonumber(string.sub(bs["Grade"],-2)) ~= nil then
						if tonumber(string.sub(bs["Grade"],-2)) >= 7 and tonumber(string.sub(bs["Grade"],-2)) <= 20 then
							bs["Grade"] = "Grade_Tier07";
							btGrade["ntype"] = "Grade_Tier07";
							btGrade["default"] = "Grade_Tier07";
						end;
					end;
					fcheck = fullcombochecker(bs,stepseconds);
				end;
			end;
		end;
	end;
end;

local t = Def.ActorFrame{
	Name="EvaluationUpset"..pn;
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
	CodeMessageCommand=function(self,params)
		if params.PlayerNumber == pn then
			if codechangeset == 1 then
				if params.Name == "JudgeChange" then
					local g_return = {ntype = "default",default = "ntype"};
					gset = g_return[gset];
					MESSAGEMAN:Broadcast("JudgeSetting",{GSet = gset,Player = pn});
				end;
			end;
		end;
	end;
	UpdateNetEvalStatsMessageCommand=function(self, params)
		st_set = params.Steps;
		diff_set = params.Difficulty;
		iset[2] = 0;
		steps_count(ns,SongOrCourse,st_set,getplayer,"C_Mines");
		ns["Score"] = params.Score;
		self:queuecommand("NetSetting");
		--20160425
		if insertchecker(getplayer,params.PlayerOptions,"controller_auto") then
			iset[2] = 1;
		end;
	end;
	NetSettingCommand=function(self)
		pct = 0;
		ns["TapNoteScore_W1"] = tonumber(SCREENMAN:GetTopScreen():GetChild("W1NumberP"..getp):GetText());
		ns["TapNoteScore_W2"] = tonumber(SCREENMAN:GetTopScreen():GetChild("W2NumberP"..getp):GetText());
		ns["TapNoteScore_W3"] = tonumber(SCREENMAN:GetTopScreen():GetChild("W3NumberP"..getp):GetText());
		ns["TapNoteScore_W4"] = tonumber(SCREENMAN:GetTopScreen():GetChild("W4NumberP"..getp):GetText());
		ns["TapNoteScore_W5"] = tonumber(SCREENMAN:GetTopScreen():GetChild("W5NumberP"..getp):GetText());
		ns["TapNoteScore_Miss"] = tonumber(SCREENMAN:GetTopScreen():GetChild("MissNumberP"..getp):GetText());
		ns["HoldNoteScore_Held"] = tonumber(SCREENMAN:GetTopScreen():GetChild("HeldNumberP"..getp):GetText());
		ns["HoldNoteScore_LetGo"] = (ns["RadarCategory_Holds"] + ns["RadarCategory_Rolls"]) - ns["HoldNoteScore_Held"];
		ns["MaxCombo"] = tonumber(SCREENMAN:GetTopScreen():GetChild("MaxComboNumberP"..getp):GetText());
		
		if ns["RadarCategory_Mines"] > 0 then
			mset = 1;
		end;
		if ns["Score"] == hs["Score"] then
			pct = hs["PercentScore"];
			MESSAGEMAN:Broadcast("Net",{Pct = hs["PercentScore"],Step = st_set,Diff = diff_set});
		else
			local nMIGS = migschecker(ns,"ntype");
			local nMIGS_MAX = migsmaxchecker(ns,"ntype");
			local nGR_GO_BO_MICount = ns["TapNoteScore_W3"] + ns["TapNoteScore_W4"] + ns["TapNoteScore_W5"] + ns["TapNoteScore_Miss"];
			ns["PercentScore"] = nMIGS / nMIGS_MAX;
			ns["PercentScore"] = math.max(0,ns["PercentScore"]);
			ns["PercentScore"] = math.min(100,ns["PercentScore"]);
			pct = ns["PercentScore"];
			ns["Grade"] = "Grade_Tier07";
			if nGR_GO_BO_MICount == 0 then
				if ns["RadarCategory_Holds"] + ns["RadarCategory_Rolls"] == ns["HoldNoteScore_Held"] then
					if ns["TapNoteScore_W2"] == 0 then
						ns["Grade"] = "Grade_Tier01";
					else ns["Grade"] = "Grade_Tier02";
					end;
				end;
			else
				for i=1,6 do
					if ns["PercentScore"] >= PCheck("default","Grade_Tier0"..i) then
						ns["Grade"] = "Grade_Tier0"..i;
						break;
					end;
				end;
			end;
			MESSAGEMAN:Broadcast("NotNet",{Pct = ns["PercentScore"],Step = st_set,Diff = diff_set});
		end;
	end;
};

t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(playcommand,"JudgeSetting",{GSet = gset,Player = pn};);
	OnCommand=cmd(playcommand,"JudgeSetting",{GSet = gset,Player = pn});
	JudgeSettingMessageCommand=function(self,params)
		if params.Player ~= pn then return;
		end;
		pct = hs["PercentScore"];
		--[ja] 20150916修正
		--[ja] ターゲットスコア設定
		if adgraph ~= "Off" and adgraph ~= "nil" then
			tMIGS_MAX["ntype"] = migsmaxchecker(hs,"ntype");
			tMIGS_MAX["default"] = migsmaxchecker(hs,"default");
			targethsMIGS = migschecker(hs,ad_t_table[adtype]);
			if string.find(adgraph,"Tier") then
				adhoc["ntype"] = THEME:GetMetric("PlayerStageStats","GradePercentCS"..adgraph);
				adhoc["default"] = THEME:GetMetric("PlayerStageStats","GradePercent"..adgraph);
			elseif string.find(adgraph,"MyBest") then
			elseif string.find(adgraph,"^RIVAL_.*") then
				if getenv("resultmigsadhoc"..p) then
					tMIGS_MAX["ntype"] = getenv("resultmigsadhoc"..p);
					tMIGS_MAX["default"] = getenv("resultmigsadhoc"..p);
				end;
				adhoc["ntype"] = 1;
				adhoc["default"] = 1;
				--[ja] 20150922番号ズレ修正
				if adgraph == "RIVAL_TopScore" then
					local base_rt = 4;
					if adtype ~= "SM" then base_rt = 1;
					end;
					if getenv("sctable"..p)[base_rt] then
						rtset = "RIVAL_TopScore";
						adgraph = "RIVAL_"..getenv("sctable"..p)[base_rt];
					end;
				elseif adgraph == "RIVAL_On1rank" then
					local base_ro = 5;
					if adtype ~= "SM" then base_ro = 2;
					end;
					if getenv("sctable"..p)[base_ro] then
						rtset = "RIVAL_On1rank";
						adgraph = "RIVAL_"..getenv("sctable"..p)[base_ro];
					end;
				elseif adgraph == "RIVAL_Average" then
					local base_ra = 6;
					if adtype ~= "SM" then base_ra = 3;
					end;
					if getenv("sctable"..p)[base_ra] then
						tMIGS_MAX["ntype"] = getenv("sctable"..p)[base_ra];
						tMIGS_MAX["default"] = getenv("sctable"..p)[base_ra];
					end;
				end;
			else
				adhoc["ntype"] = adgraph;
				adhoc["default"] = adgraph;
			end;
		end;
		MIGS_MAX["ntype"] = migsmaxchecker(hs,"ntype");
		MIGS_MAX["default"] = migsmaxchecker(hs,"default");
		hsMIGS["ntype"] = migschecker(hs,"ntype");
		hsMIGS["default"] = migschecker(hs,"default");
		bsMIGS["ntype"] = migschecker(bs,"ntype");
		bsMIGS["default"] = migschecker(bs,"default");
		local t_mSet = {
			ntype = migsmaxchecker(hs,"ntype"),
			default = migsmaxchecker(hs,"default")
		};
		if t_mSet["ntype"] == MIGS_MAX[params.GSet] or t_mSet["default"] == MIGS_MAX[params.GSet] then
			if t_mSet[params.GSet] ~= MIGS_MAX[params.GSet] then
				MESSAGEMAN:Broadcast("JudgeSetting",{GSet = params.GSet,Player = pn});
			end;
		end;
		
		--[ja] MAX EXスコア
		--[ja] 今回のスコア
		--[ja] 20150909修正
		hs["Grade"] = gradechecker(hs,pnstats:GetGrade(),stepseconds,params.GSet,getenv("fullcjudgep"..p));
		htGrade["ntype"] = gradechecker(hs,pnstats:GetGrade(),stepseconds,"ntype",getenv("fullcjudgep"..p));
		htGrade["default"] = gradechecker(hs,pnstats:GetGrade(),stepseconds,"default",getenv("fullcjudgep"..p));
		--[ja] ベストスコア
		if topscore then
			bs["Grade"] = gradechecker(bs,topscore:GetGrade(),stepseconds,params.GSet,fcheck);
			btGrade["ntype"] = gradechecker(bs,topscore:GetGrade(),stepseconds,"ntype",fcheck);
			btGrade["default"] = gradechecker(bs,topscore:GetGrade(),stepseconds,"default",fcheck);
		end;
		ss["ntype"] = nGrade[htGrade["ntype"]];
		ss["default"] = nGradeSM[htGrade["default"]];
		--[ja] ターゲットはグレード評価の表示方法切り替えても数値は変わらない
		if string.find(adgraph,"MyBest") then
			targetset = bsMIGS[ad_t_table[adtype]];
		else
			targetset = math.ceil(tMIGS_MAX[ad_t_table[adtype]] * adhoc[ad_t_table[adtype]]);
			targetset = math.round(targetset);
		end;
		
	--[ja] SLoadフラググレードチェック/曲グレード ---------------------------------------------------------
		--[ja] 20160116修正
		local scfs_bsgrade = {22,22};
		if not icheck then
			if btGrade["ntype"] ~= "Grade_None" then
				if btGrade["ntype"] ~= "Grade_Failed" then
					if bs["SurvivalSeconds"] + 1 >= stepseconds then
						if tonumber(getenv("fcplayercheck_p"..p)) == 0 then
							scfs_bsgrade[1] = tonumber(string.sub(btGrade["ntype"],-2));
							scfs_bsgrade[2] = tonumber(string.sub(btGrade["default"],-2));
						else
							scfs_bsgrade[1] = 7;
							scfs_bsgrade[2] = 7;
						end;
					else
						scfs_bsgrade[1] = 21;
						scfs_bsgrade[2] = 21;
					end;
				else
					scfs_bsgrade[1] = 21;
					scfs_bsgrade[2] = 21;
				end;
			end;
			--[ja] 評価を更新した場合
			--20160718
			if not failed then
				if tonumber(aliveseconds) >= tonumber(stepseconds) then
					if tonumber(getenv("fcplayercheck_p"..p)) == 0 then
						if hs["PercentScore"] > bs["PercentScore"] then
							scfsst[p] = diff_n[ToEnumShortString(StepsOrTrail:GetDifficulty())];
						end;
					end;
				end;
			end;
		end;
		--Trace("scfsstP_"..p.." : "..scfsst[p]);
		setenv("resultsetflagp"..p,scfsst[p]);

		--[ja] 意図的にFailedさせた時の対策
		if IsAStage then
			if pn == PLAYER_1 then
				if htGrade[params.GSet] == "Grade_Failed" then
					setenv("onpurposefailgradep1","Grade_Failed");
				end;
			else
				if htGrade[params.GSet] == "Grade_Failed" then
					setenv("onpurposefailgradep2","Grade_Failed");
				end;
			end;
		end;
	-----------------------------------------------------------------------------------------------
	end;
	OffCommand=function(self)
		if not IsNetConnected() then
			if codechangeset == 1 then
				if pn == PLAYER_1 then
					SetAdhocPref("JudgeSet",gset,p1str);
				else SetAdhocPref("JudgeSet",gset,p2str);
				end;
			end;
		end;
	end;
};
--setenv("evaPercent",hsMIGS);

--------------------------------------------------------------------------------------------------------

if pm ~= 'PlayMode_Battle' and pm ~= 'PlayMode_Rave' then
	--[ja] 判定平均ボックス
	for x=1,#cboxset do
		t[#t+1] = Def.ActorFrame{
			InitCommand=cmd(visible,coursetype;x,GetGraphPosX(pn)-156.5;y,SCREEN_CENTER_Y-40+11.5;);
			LoadActor("judgegraph")..{
				InitCommand=cmd(horizalign,left;zoomtowidth,0;zoomtoheight,10;);
				OnCommand=cmd(stoptweening;cropright,1;sleep,0.4+(x*0.0075);linear,0.01;cropright,0;playcommand,"Set");
				SetCommand=function(self)
					self:diffuse(color("0.5,0.5,0.5"));
					--SCREENMAN:SystemMessage(tostring(icheck));
					if cautogen == 0 and not icheck and tonumber(getenv("fcplayercheck_p"..p)) == 0 then
						self:diffuse(JBoxColor[cboxset[x]]);
					end;
					self:diffusealpha(0.75);
					self:x( (judgewidth / #cboxset) * (x - 1) );
					local space = 1;
					if x == #cboxset then space = 0.5;
					end;
					self:zoomtowidth( math.round((judgewidth / #cboxset)) - space );
				end;
				NetMessageCommand=cmd(playcommand,"Set";);
				NotNetMessageCommand=cmd(diffuse,color("0.5,0.5,0.5,0.75" ););
			};
		};
	end;

	-- [ja] OKとNGの判定のグラフ
	for idx, cat in pairs(restatsHoldCategoryValues) do
		local restatsholdCategory = cat.Category;
		local restatsholdColor = cat.Color;
		t[#t+1] = Def.ActorFrame{
			InitCommand=cmd(visible,coursetype;x,GetGraphPosX(pn)-156.5;y,SCREEN_CENTER_Y-50+12;);
			LoadActor("judgegraph")..{
				InitCommand=cmd(horizalign,left;zoomtowidth,0;zoomtoheight,8;);
				OnCommand=function(self)
					j_w_set(self,restatsholdCategory,restatsholdColor,hs,idx,judgewidth,"Hold");
					(cmd(stoptweening;cropright,1;sleep,(idx*0.3);linear,0.3;cropright,0;))(self)
				end;
				NetMessageCommand=function(self)
					j_w_set(self,restatsholdCategory,restatsholdColor,hs,idx,judgewidth,"Hold");
					self:cropright(0);
				end;
				NotNetMessageCommand=function(self)
					j_w_set(self,restatsholdCategory,restatsholdColor,ns,idx,judgewidth,"Hold");
					self:cropright(0);
				end;
			};
		};
	end;

	-- [ja] OKとNG以外の各種判定のグラフ
	for idx, cat in pairs(restatsCategoryValues) do
		local restatsCategory = cat.Category;
		local restatsColor = cat.Color;
		t[#t+1] = Def.ActorFrame{
			InitCommand=cmd(visible,coursetype;x,GetGraphPosX(pn)-156.5;y,SCREEN_CENTER_Y-60+12;);
			LoadActor("judgegraph")..{
				InitCommand=cmd(horizalign,left;zoomtowidth,0;zoomtoheight,11;);
				OnCommand=function(self)
					j_w_set(self,restatsCategory,restatsColor,hs,idx,judgewidth,"Note");
					(cmd(stoptweening;cropright,1;sleep,(idx*0.1);linear,0.1;cropright,0;))(self)
				end;
				NetMessageCommand=function(self)
					j_w_set(self,restatsCategory,restatsColor,hs,idx,judgewidth,"Note");
					self:cropright(0);
				end;
				NotNetMessageCommand=function(self)
					j_w_set(self,restatsCategory,restatsColor,ns,idx,judgewidth,"Note");
					self:cropright(0);
				end;
			};
		};
	end;

	t[#t+1] = LoadFont("_shared4")..{
		InitCommand=cmd(visible,coursetype;x,GetGraphPosX(pn)-10;y,SCREEN_CENTER_Y-8;;zoom,0.5;strokecolor,Color("Black"));
		OnCommand=cmd(stoptweening;cropright,1;addx,-20;sleep,0.15;accelerate,0.4;cropright,0;addx,20;
					settext,THEME:GetString("ScreenEvaluation","HTScore"););
	};

--[ja] グレード・スコア・EXスコア net=非表示
	local setting = {
		y_set = {12,33,65},
		skew_y_set = {3,2,2},
		diff_y_set = {3,5,5},
		g_v_set = {true,false,false},
		num_v_set = {false,true,true},
		t_label_set = {false,false,true},
	};
	local function fc_mark_on(bc)
		local s_time = 0.05;
		if bc == "current" then s_time = 0.2;
		end;
		return cmd(stoptweening;diffusealpha,0;zoom,0.5;addx,-20;sleep,s_time;accelerate,0.4;diffusealpha,1;zoom,0.15;addx,20;);
	end;
	local function g_image_on(bc)
		local s_time = 0.1;
		if bc == "current" then s_time = 0.25;
		end;
		return cmd(stoptweening;diffusealpha,0;zoom,1.5;addx,-20;sleep,s_time;accelerate,0.4;diffusealpha,1;zoom,0.675;addx,20;);
	end;
	for g=1,3 do
		t[#t+1] = Def.ActorFrame{
			InitCommand=cmd(visible,coursetype;x,GetGraphPosX(pn);y,SCREEN_CENTER_Y+setting.y_set[g];);
			OnCommand=cmd(stoptweening;playcommand,"JudgeSetting",{GSet = gset,Player = pn});
			NetMessageCommand=cmd(visible,coursetype;playcommand,"JudgeSetting",{GSet = gset,Player = pn});
			NotNetMessageCommand=cmd(visible,false;);
	---------------------------------------------------------------------------------------------------------------------
			--[ja] 良い方にハイライトをつける
			Def.ActorFrame{
				Name="hr";
				InitCommand=cmd(skewx,-1;y,setting.skew_y_set[g];);
				Def.Quad{
					Name="highright";
					InitCommand=cmd(zoomto,78,14;);
					OnCommand=cmd(stoptweening;diffuse,color("1,1,0,0.4");diffuseleftedge,color("1,1,0,0.1");cropleft,1;sleep,0.15;accelerate,0.4;cropleft,0;);
				};
			};
			LoadActor("mark")..{
				InitCommand=cmd(x,-10;y,3);
				OnCommand=cmd(stoptweening;diffusealpha,0;zoom,1.5;addx,-20;sleep,0.15;accelerate,0.4;diffusealpha,1;zoom,1;addx,20;);
			};
	----------- 1 -------------------------------------------------------------------------------------------------------
			--[ja] ベストスコアのフルコンボマーク
			LoadActor(THEME:GetPathG("","graph_mini"))..{
				Name="best_fcmark";
				InitCommand=cmd(visible,setting.g_v_set[g];y,-6;shadowlength,2;);
				OnCommand=fc_mark_on("best");
			};
			--[ja] ベストスコアのグレード画像
			Def.Sprite{
				Name="best_grade";
				InitCommand=cmd(visible,setting.g_v_set[g];x,-40-10;shadowlength,2;);
				OnCommand=g_image_on("best");
			};
			--[ja] 今回のスコアのフルコンボマーク
			LoadActor(THEME:GetPathG("","graph_mini"))..{
				Name="current_fcmark";
				InitCommand=cmd(visible,setting.g_v_set[g];y,-6;shadowlength,2;);
				OnCommand=fc_mark_on("current");
			};
			--[ja] 今回のスコアのグレード画像
			Def.Sprite{
				Name="current_grade";
				InitCommand=cmd(visible,setting.g_v_set[g];x,41-8;shadowlength,2;);
				OnCommand=g_image_on("current");
			};

	----------- 2 and 3 --------------------------------------------------------------------------------------------------
			--[ja] ベストスコア
			LoadFont("_um")..{
				Name="best_score_num";
				InitCommand=cmd(visible,setting.num_v_set[g];x,-40+18;y,5;horizalign,right;maxwidth,110;diffuse,color("0,1,1,1");strokecolor,color("0,0.3,0.3,0.5");shadowlength,2;);
				OnCommand=cmd(stoptweening;diffusealpha,0;zoom,1.5;addx,-20;sleep,0.1;accelerate,0.4;diffusealpha,1;zoom,0.65;zoomx,0.585;addx,20;);
			};
			--[ja] 今回のスコア
			LoadFont("_um")..{
				Name="current_score_num";
				InitCommand=cmd(visible,setting.num_v_set[g];x,44+18;y,5;horizalign,right;maxwidth,110;diffuse,color("0,1,1,1");strokecolor,color("0,0.3,0.3,0.5");shadowlength,2;);
				OnCommand=cmd(stoptweening;diffusealpha,0;zoom,1.5;addx,-20;sleep,0.15;accelerate,0.4;diffusealpha,1;zoom,0.65;zoomx,0.585;addx,20;);
			};
	----------- 3 -------------------------------------------------------------------------------------------------------
			--[ja] 設定しているターゲットスコアのラベル
			LoadFont("_shared2")..{
				Name="target_set";
				InitCommand=cmd(visible,setting.t_label_set[g];x,-22;y,-14;zoom,0.5;horizalign,right;strokecolor,Color("Black");shadowlength,1;maxwidth,140;);
				OnCommand=cmd(stoptweening;diffusealpha,0;addx,-20;sleep,0.15;accelerate,0.4;diffusealpha,1;addx,20;);
			};
	---------------------------------------------------------------------------------------------------------------------
			--[ja] スコア差分
			LoadFont("_um")..{
				Name="diff_num";
				InitCommand=cmd(x,68;y,setting.diff_y_set[g];horizalign,left;strokecolor,Color("Black");maxwidth,110;);
				OnCommand=cmd(stoptweening;diffusealpha,0;zoom,1.5;addx,-20;sleep,0.2;accelerate,0.4;diffusealpha,1;zoom,0.45;addx,20;);
			};

			JudgeSettingMessageCommand=function(self,params)
				if params.Player ~= pn then return;
				end;
				local highright = self:GetChild('hr'):GetChild('highright');
				local diff_num = self:GetChild('diff_num');
				local best_fcmark = self:GetChild('best_fcmark');
				local best_grade = self:GetChild('best_grade');
				local current_fcmark = self:GetChild('current_fcmark');
				local current_grade = self:GetChild('current_grade');
				local best_score_num = self:GetChild('best_score_num');
				local current_score_num = self:GetChild('current_score_num');
				local target_set = self:GetChild('target_set');
				diff_num:visible(false);
				best_fcmark:visible(false);
				best_grade:visible(false);
				current_fcmark:visible(false);
				current_grade:visible(false);
				best_score_num:visible(false);
				current_score_num:visible(false);
				target_set:visible(false);
				
				highright:visible(true);
				highright:x(-53);
				if g == 1 then
					if btGrade[params.GSet] ~= "Grade_None" then
						if btGrade[params.GSet] ~= "Grade_Failed" then
							if htGrade[params.GSet] ~= "Grade_Failed" then
								if tonumber(string.sub(htGrade[params.GSet],-2)) == tonumber(string.sub(btGrade[params.GSet],-2)) then
									if getenv("fullcjudgep"..p) <= fcheck then
										highright:x(31);
									end;
								elseif tonumber(string.sub(htGrade[params.GSet],-2)) < tonumber(string.sub(btGrade[params.GSet],-2)) then
									highright:x(31);
								end;
							end;
						else
							if htGrade[params.GSet] ~= "Grade_Failed" then
								highright:x(31);
							end;
						end;
					else highright:x(31);
					end;
					if fcheck > 0 and fcheck < 5 then
						best_fcmark:visible(true);
						best_fcmark:x(-29-10);
						if btGrade[params.GSet] == "Grade_Tier01" then best_fcmark:x(-29-10+6);
						elseif btGrade[params.GSet] == "Grade_Tier02" then best_fcmark:x(-29-10+3);
						end;
						(cmd(diffuse,color(fullcombo_set_color[fcheck]);glowshift))(best_fcmark);
					end;
					if pm ~= 'PlayMode_Endless' then
						if btGrade[params.GSet] ~= "Grade_None" then
							best_grade:visible(true);
							best_grade:Load(THEME:GetPathG(low_pic_d,ToEnumShortString( btGrade[params.GSet] )));
						end;
						if htGrade[params.GSet] ~= "Grade_None" then
							current_grade:visible(true);
							current_grade:Load(THEME:GetPathG(low_pic_d,ToEnumShortString( htGrade[params.GSet] )));
						end;
					end;
					if getenv("fullcjudgep"..p) > 0 and getenv("fullcjudgep"..p) < 5 then
						current_fcmark:visible(true);
						current_fcmark:x(52-8);
						if htGrade[params.GSet] == "Grade_Tier01" then current_fcmark:x(52-8+6);
						elseif htGrade[params.GSet] == "Grade_Tier02" then current_fcmark:x(52-8+3);
						end;
						(cmd(diffuse,color(fullcombo_set_color[getenv("fullcjudgep"..p)]);glowshift))(current_fcmark);
					end;
					if not icheck and tonumber(getenv("fcplayercheck_p"..p)) == 0 then
						if htGrade[params.GSet] ~= "Grade_Failed" then
							diff_num:visible(true);
							if hsMIGS[params.GSet] == MIGS_MAX[params.GSet] then
								diff_num:settext("MAX");
							elseif ss[params.GSet] ~= nil then
								local nextGtext;
								local upTier = 0;
								if ss[params.GSet] == "MAX" then
									nextGtext = ss[params.GSet];
									upTier = 1;
								else
									nextGtext = THEME:GetString("Grade",ToEnumShortString(ss[params.GSet]));
									upTier = THEME:GetMetric("PlayerStageStats","GradePercentCS"..ToEnumShortString(ss[params.GSet]));
									if params.GSet == "default" then
										upTier = THEME:GetMetric("PlayerStageStats","GradePercent"..ToEnumShortString(ss[params.GSet]));
									end;
								end;
								local nextp = math.ceil(MIGS_MAX[params.GSet] * upTier);
								local nextTScore = hsMIGS[params.GSet] - nextp;
								diff_num:settext(nextGtext..":\n"..nextTScore);
							end;
						end;
					end;
				elseif g == 2 then
					if hsMIGS[params.GSet] >= bsMIGS[params.GSet] then highright:x(31);
					end;
					if not icheck and tonumber(getenv("fcplayercheck_p"..p)) == 0 then
						best_score_num:visible(true);
						best_score_num:settext( bsMIGS[params.GSet] );
						local m_diff = hsMIGS[params.GSet] - bsMIGS[params.GSet];
						if m_diff > 0 then
							diff_num:visible(true);
							diff_num:settext( string.format( "+".."%i",m_diff ) );
						else
							diff_num:visible(true);
							diff_num:settext( string.format( "%i",m_diff ) );
						end;
						color_return(diff_num,"Diff",m_diff);
					end;
					current_score_num:visible(true);
					current_score_num:settext( hsMIGS[params.GSet] );
				elseif g == 3 then
					if targethsMIGS >= targetset then highright:x(31);
					end;
					if not icheck and tonumber(getenv("fcplayercheck_p"..p)) == 0 then
						target_set:visible(true);
						if rtset ~= "" then
							if rtset == "RIVAL_On1rank" then
								target_set:settext(adtype.." Rival : On 1 rank");
							elseif rtset == "RIVAL_TopScore" then
								target_set:settext(adtype.." Rival : TopScore");
							end;
						else target_set:settext(settargettext(adtype,adgraph));
						end;
						best_score_num:visible(true);
						best_score_num:settext( targetset );
						local tm_diff = targethsMIGS - targetset;
						if tm_diff > 0 then
							diff_num:visible(true);
							diff_num:settext( string.format( "+".."%i",tm_diff ) );
						else
							diff_num:visible(true);
							diff_num:settext( string.format( "%i",tm_diff ) );
						end;
						color_return(diff_num,"Diff",tm_diff);
					end;
					current_score_num:visible(true);
					current_score_num:settext( targethsMIGS );
				end;
			end;
		};
	end;


--[ja] FAST/SLOW表示 net=非表示
	t[#t+1] = LoadActor("slash")..{
		InitCommand=function(self)
			self:x(GetGraphPosX(pn));
			self:y(SCREEN_CENTER_Y);
			if not coursetype then
				self:y(SCREEN_CENTER_Y+116+3);
			else self:y(SCREEN_CENTER_Y+156+3);
			end;
		end;
		OnCommand=cmd(stoptweening;diffusealpha,0;zoom,1.5;addx,-20;sleep,0.1;accelerate,0.4;diffusealpha,1;zoom,1;addx,20;);
	};
	for k=1,#getenv("fscountp"..p) do
		local x_set = {-22,74};
		setmetatable( x_set, { __index = function() return -22 end; } );
		t[#t+1] = Def.ActorFrame{
			InitCommand=function(self)
				self:x(GetGraphPosX(pn));
				self:y(SCREEN_CENTER_Y);
				if not coursetype then
					self:y(SCREEN_CENTER_Y+116);
				else self:y(SCREEN_CENTER_Y+156);
				end;
			end;
			LoadFont("_cum")..{
				InitCommand=cmd(x,x_set[k];horizalign,right;maxwidth,110;diffuse,color("0,1,1,1");strokecolor,color("0,0.3,0.3,0.5");shadowlength,2;);
				OnCommand=cmd(stoptweening;diffusealpha,0;zoom,1.5;addx,-20;sleep,0.15;accelerate,0.4;diffusealpha,1;zoom,0.65;zoomx,0.585;addx,20;
							playcommand,"JudgeSetting",{GSet = gset,Player = pn});
				JudgeSettingMessageCommand=function(self,params)
					if params.Player ~= pn then return;
					end;
					self:settext( getenv("fscountp"..p)[k] );
				end;
				--20160820
				NetMessageCommand=cmd(visible,true;playcommand,"JudgeSetting",{GSet = gset,Player = pn});
				NotNetMessageCommand=cmd(visible,false;);
			};
		};
	end;

	t[#t+1] = Def.ActorFrame{
		InitCommand=cmd(x,GetGraphPosX(pn);y,SCREEN_CENTER_Y;);
		Def.ActorFrame{
			InitCommand=function(self)
				if not coursetype then
					self:y(116);
				else self:y(156);
				end;
			end;
			LoadActor("slash")..{
				InitCommand=cmd(y,3;);
				OnCommand=cmd(stoptweening;diffusealpha,0;zoom,1.5;addx,-20;sleep,0.1;accelerate,0.4;diffusealpha,1;zoom,1;addx,20;);
			};
		};

--[ja] 今回のスコア・タイム net=表示変化あり
		LoadFont("_numbers5")..{
			InitCommand=function(self)
				self:x(100);
				if not coursetype then
					self:y(-58);
					self:maxwidth(200);
				else
					self:y(172);
					self:maxwidth(260);
				end;
				(cmd(shadowlength,0;horizalign,right;skewx,-0.2;diffuse,color("0,1,1,1");strokecolor,color("0,0.4,0.4,1");shadowlength,2;))(self)
			end;
			OnCommand=function(self)
				local s_zoom = 0.85;
				if not coursetype then
					--self:settext("32255:00.48");
					self:settext(SecondsToMMSSMsMs(hs["SurvivalSeconds"]));
				else
					self:settext(comma_value(string.format("%9d",hs["Score"]),scf,spo,spt));
					if tonumber(getenv("tempscorep"..p)) > 0 then
						self:settext(comma_value(string.format("%9d",tonumber(getenv("tempscorep"..p))),scf,spo,spt));
					end;
					s_zoom = 0.65;
				end;
				(cmd(stoptweening;diffusealpha,0;zoom,1.75;addx,-20;sleep,0.15;accelerate,0.4;diffusealpha,1;zoom,s_zoom;addx,20;))(self)
			end;
			NetMessageCommand=function(self)
				self:settext(comma_value(string.format("%9d",hs["Score"]),scf,spo,spt));
				if tonumber(getenv("tempscorep"..p)) > 0 then
					self:settext(comma_value(string.format("%9d",tonumber(getenv("tempscorep"..p))),scf,spo,spt));
				end;
			end;
			NotNetMessageCommand=function(self)
				self:settext(comma_value(string.format("%9d",ns["Score"]),scf,spo,spt));
			end;
		};
	};
end;

--[ja] 各種判定の数
for idx, cat in pairs(statsCategoryValues) do
	local statsCategory = cat.Category;
	t[#t+1] = Def.ActorFrame{
		InitCommand=cmd(x,GetGraphPosX(pn));
		Def.ActorFrame{
			InitCommand=function(self)
				if idx >= 5 then
					if idx == 8 then self:x(90);
					else self:x(-206+(math.abs((idx-4)*72)));
					end;
					if not coursetype then
						self:y(SCREEN_CENTER_Y+52+32);
					else self:y(SCREEN_CENTER_Y+92+32);
					end;
				else
					if idx == 4 then self:x(90);
					else self:x(-206+(math.abs(idx*72)));
					end;
					if not coursetype then
						self:y(SCREEN_CENTER_Y+52);
					else self:y(SCREEN_CENTER_Y+92);
					end;
				end;
			end;
			LoadActor("_judge_labels")..{
				InitCommand=cmd(animate,false;);
				OnCommand=function(self)
					self:setstate(idx-1);
					(cmd(stoptweening;cropbottom,1;addx,-20;sleep,idx*0.05;decelerate,0.4;cropbottom,0;addx,20;))(self)
				end;
			};
			
--[ja] 今回のスコアの判定数 net=表示変化あり
			LoadFont("_cum")..{
				InitCommand=function(self)
					(cmd(horizalign,left;x,-26;y,4;zoom,0.65;maxwidth,90;diffuse,color("0,1,1,1");strokecolor,color("0,0.3,0.3,0.5");shadowlength,2;))(self);
				end;
				OnCommand=function(self)
					(cmd(stoptweening;croptop,1;addx,6;addy,6;sleep,(idx*0.05)+0.1;decelerate,0.25;croptop,0;addx,-6;addy,-6;))(self)
					local value = hs[statsCategory];
					text_return(self,value);
				end;
				NetMessageCommand=function(self)
					text_return(self,hs[statsCategory]);
				end;
				NotNetMessageCommand=function(self)
					text_return(self,ns[statsCategory]);
				end;
			};

--[ja] 今回のスコアの判定数 - ベストスコアの判定数 = 各種判定数の差分 net=非表示
			LoadFont("_um")..{
				InitCommand=function(self)
					self:visible(false);
					if coursetype then
						if pm ~= 'PlayMode_Battle' and pm ~= 'PlayMode_Rave' then
							self:visible(true);
						end;
					end;
					(cmd(horizalign,right;x,32.5;y,19;zoom,0.45;maxwidth,110;strokecolor,Color("Black")))(self);
				end;
				OnCommand=function(self)
					(cmd(stoptweening;cropright,1;addx,6;sleep,(idx*0.05)+0.1;linear,0.25;cropright,0;addx,-6;))(self)
					if not icheck and tonumber(getenv("fcplayercheck_p"..p)) == 0 then
						local bhvalue = hs[statsCategory] - bs[statsCategory];
						if bhvalue > 0 then self:settext( string.format( "+".."%i",bhvalue ) );
						else self:settext( string.format( "%i",bhvalue ) );
						end;
						color_return(self,statsCategory,bhvalue);
					end;
				end;
				NetMessageCommand=function(self)
					self:diffusealpha(1);
					local bhvalue = hs[statsCategory] - bs[statsCategory];
					if bhvalue > 0 then self:settext( string.format( "+".."%i",bhvalue ) );
					else self:settext( string.format( "%i",bhvalue ) );
					end;
					color_return(self,statsCategory,bhvalue);
				end;
				NotNetMessageCommand=function(self)
					self:diffusealpha(1);
					local bhvalue = hs[statsCategory] - ns[statsCategory];
					if bhvalue > 0 then self:settext( string.format( "+".."%i",bhvalue ) );
					else self:settext( string.format( "%i",bhvalue ) );
					end;
					color_return(self,statsCategory,bhvalue);
				end;
			};
		};
	};
end;

--[ja] グラフ上の今回のグレード net=表示変化あり
if pm ~= 'PlayMode_Battle' and pm ~= 'PlayMode_Rave' then
	t[#t+1] = Def.Sprite{
		InitCommand=cmd(horizalign,right;vertalign,bottom;x,GetGraphPosX(pn)-26;y,SCREEN_CENTER_Y-70);
		OnCommand=cmd(stoptweening;zoom,0;sleep,2;zoomx,0.95;zoomy,5;accelerate,0.15;zoomy,0.95;
					playcommand,"JudgeSetting",{GSet = gset,Player = pn});
		JudgeSettingMessageCommand=function(self,params)
			if params.Player ~= pn then return;
			end;
			self:visible(false);
			if coursetype and htGrade[params.GSet] ~= "" then
				self:visible(true);
				self:Load(THEME:GetPathG("GradeDisplayEval",ToEnumShortString( htGrade[params.GSet] )));
			end;
		end;
		NetMessageCommand=function(self)
			self:visible(false);
			if htGrade["default"] ~= "" then
				self:visible(true);
				self:Load( THEME:GetPathG("GradeDisplayEval",ToEnumShortString(htGrade["default"])) );
				(cmd(zoomx,0.95;zoomy,0.95;))(self)
			end;
		end;
		NotNetMessageCommand=function(self)
			self:visible(false);
			if ns["Grade"] ~= "" then
				self:visible(true);
				self:Load( THEME:GetPathG("GradeDisplayEval",ToEnumShortString(ns["Grade"])) );
				(cmd(zoomx,0.95;zoomy,0.95;))(self)
			end;
		end;
	};

--[ja] グレード評価の表示方法 net=表示変化なし
	t[#t+1] = LoadFont("_shared4") .. {
		InitCommand=cmd(zoom,0.5;strokecolor,color("0.3,0.3,0.3,0.75");horizalign,right;vertalign,bottom;x,GetGraphPosX(pn)-38;y,SCREEN_CENTER_Y-75);
		OnCommand=cmd(stoptweening;zoom,0;sleep,2;zoomx,0.5;zoomy,5;accelerate,0.15;zoomy,0.5;
					playcommand,"JudgeSetting",{GSet = gset,Player = pn});
		JudgeSettingMessageCommand=function(self,params)
			if params.Player ~= pn then return;
			end;
			self:visible(false);
			if coursetype then
				local ope = {ntype = "CSGrade",default = "SMGrade"};
				setmetatable( ope, { __index = function() return "CSGrade" end; } );
				self:visible(true);
				self:diffuse(Colors.GradeJudge[params.GSet]);
				self:settext(THEME:GetString( "OptionExplanations",ope[params.GSet] ));
			end;
		end;
	};
end;

--[ja] 消費カロリー net=非表示
local cstr = pstr;
if PROFILEMAN:IsPersistentProfile(pn) then
	local profile = PROFILEMAN:GetProfile(pn);
	local pnname = PROFILEMAN:GetPlayerName(pn);
	if GetAdhocPref("ProfIDSetP"..p) == "P"..p then
		for i = 0,PROFILEMAN:GetNumLocalProfiles()-1 do
			local profileid = PROFILEMAN:GetLocalProfileIDFromIndex(i);
			local prof = PROFILEMAN:GetLocalProfileFromIndex(i);
			local dname = prof:GetDisplayName();
			if pnname == dname then
				cstr = profileid
				break;
			end;
		end;
	end;

	if weight > 0 and ProfIDPrefCheck("HandCheck",cstr,true) then
		for i=1,2 do
			local c_str_text = "Calories";
			local c_text = calories;
			local set_y = -34;
			if i == 2 then
				c_str_text = "TodayCalories";
				c_text = todaycalories;
				set_y = -46;
			end;
			if not coursetype then
				set_y = set_y - 40;
			end;
			t[#t+1] = Def.ActorFrame{
				InitCommand=function(self)
					self:x(GetGraphPosX(pn)+94);
					self:y(SCREEN_BOTTOM+set_y);
				end;
				
				LoadFont("_shared2") .. {
					InitCommand=cmd(horizalign,left;maxwidth,200;x,-190;zoom,0.5;strokecolor,Color("Black"););
					OnCommand=cmd(stoptweening;zoomy,0;sleep,0.5;linear,0.2;zoomy,0.5;playcommand,"Net";);
					NetMessageCommand=function(self)
						self:settext(THEME:GetString("ScreenSelectProfile",c_str_text).." :");
					end;
					NotNetMessageCommand=function(self)
						self:settext("");
					end;
				};
				LoadFont("_um")..{
					InitCommand=cmd(horizalign,right;x,-4;y,4.5;maxwidth,190;zoom,0.45;strokecolor,Color("Black"););
					OnCommand=cmd(stoptweening;zoomy,0;sleep,0.5;linear,0.2;zoomy,0.45;playcommand,"Net";);
					NetMessageCommand=function(self)
						self:settext(string.format("%.2f",c_text));
					end;
					NotNetMessageCommand=function(self)
						self:settext("");
					end;
				};
				LoadFont("_shared2") .. {
					InitCommand=cmd(horizalign,left;y,1;maxwidth,120;zoom,0.45;strokecolor,Color("Black"););
					OnCommand=cmd(stoptweening;zoomy,0;sleep,0.5;linear,0.2;zoomy,0.45;playcommand,"Net";);
					NetMessageCommand=function(self)
						self:settext("kcal");
					end;
					NotNetMessageCommand=function(self)
						self:settext("");
					end;
				};
			};
		end;
	end;
end;

--[ja] player options net=表示変化あり
t[#t+1] = LoadFont("OptionIcon text")..{
	InitCommand=function(self)
		if pn == PLAYER_1 then
			self:horizalign(left);
			self:x(GetGraphPosX(pn)-148);
		else
			self:horizalign(right);
			self:x(GetGraphPosX(pn)+114);
		end;
		(cmd(y,SCREEN_CENTER_Y+206+16;maxwidth,260))(self)
		self:settext(modstr..getenv("opstringp"..p));
	end;
	OnCommand=cmd(stoptweening;shadowlength,0;diffuse,PlayerColor(pn);diffusealpha,0;sleep,0.2;linear,0.4;diffusealpha,1;);
	UpdateNetEvalStatsMessageCommand=function(self, params)
		if params.Difficulty == pnstats:GetPlayedSteps()[1]:GetDifficulty() then
			if params.Score == hs["Score"] then
				self:settext(modstr..getenv("opstringp"..p));
			else self:settext(params.PlayerOptions);
			end;
		else self:settext(params.PlayerOptions);
		end;
	end;
};

--[ja] mine check net=表示変化あり
--[ja] insert check net=表示変化あり
local str_table = {"RScore","IScore"};
--20160428
local r_y = 30;
if pm == 'PlayMode_Rave' then
	r_y = 160;
end;
for i=1,2 do
	t[#t+1] = Def.ActorFrame{
		InitCommand=cmd(x,GetGraphPosX(pn)-22;y,SCREEN_CENTER_Y+r_y;);

		Def.Quad{
			Name="mc_back";
			InitCommand=cmd(diffuse,color("0,0,0,0.75");y,2;zoomtowidth,300;zoomtoheight,46;);
		};
		LoadFont("_shared2")..{
			Name="mc_text";
			InitCommand=cmd(diffuse,color("1,0.5,0,1");strokecolor,Color("Black");zoom,0.75;maxwidth,360;
						settext,THEME:GetString("ScreenEvaluation",str_table[i]););
		};
		OnCommand=function(self)
			local mc_back = self:GetChild('mc_back');
			local mc_text = self:GetChild('mc_text');
			mc_back:visible(false);
			mc_text:visible(false);
			if i == 2 and iset[1] == 1 then 
				mc_back:visible(true);
				mc_text:visible(true);
			end;
		end;
		NetMessageCommand=function(self)
			local mc_back = self:GetChild('mc_back');
			local mc_text = self:GetChild('mc_text');
			mc_back:visible(false);
			mc_text:visible(false);
			if i == 2 and iset[1] == 1 then 
				mc_back:visible(true);
				mc_text:visible(true);
			end;
		end;
		NotNetMessageCommand=function(self)
			local mc_back = self:GetChild('mc_back');
			local mc_text = self:GetChild('mc_text');
			mc_back:visible(false);
			mc_text:visible(false);
			if i == 1 and mset == 1 then 
				mc_back:visible(true);
				mc_text:visible(true);
			end;
			if mset == 0 then
				if i == 2 and iset[2] == 1 then 
					mc_back:visible(true);
					mc_text:visible(true);
				end;
			end;
		end;
	};
end;

---------------------------------------------------------------------------------------------------------------------------------------
--[ja] expoints net=非表示
if getenv("exflag") == "csc" and psStats:GetStage() ~= "Stage_Extra2" then
	if #GAMESTATE:GetHumanPlayers() < 2 then
		local ccstpoint = getenv("ccstpoint");	--[ja] 今までの総合ポイント
		local oldpoint = getenv("oldpoint");	--[ja] 今までのポイント
		local newpoint = getenv("newpoint");	--[ja] 今回のポイント
		if oldpoint == nil then oldpoint = 0;
		end;
		local cpoint = 0;
		local co = 0;
		
		t[#t+1] = LoadActor("eva_fpointframe")..{
			InitCommand=cmd(x,GetGraphPosX(pn)+52;y,SCREEN_CENTER_Y-76;diffusealpha,0;shadowlength,2;addx,-20;);
			OnCommand=cmd(sleep,2;decelerate,0.3;addx,20;diffusealpha,1;);
		};
		
		t[#t+1] = LoadFont("_cum") .. {
			InitCommand=cmd(horizalign,left;x,GetGraphPosX(pn)-20;y,SCREEN_CENTER_Y-90;
						shadowlength,2;zoomy,0;skewx,-0.25;maxwidth,68;diffuse,color("0,1,1,1");strokecolor,color("0,0.4,0.4,1"););
			OnCommand=cmd(sleep,2;decelerate,0.3;zoomy,1;playcommand,"Count";);
			CountCommand=function(self)
				local tpoint;
				if ccstpoint >= ccstpoint + (newpoint - oldpoint) then
					tpoint = ccstpoint.. " + 0";
				else tpoint = ccstpoint.." + "..newpoint - oldpoint;
				end;
				self:settext(tpoint);
			end;
		};

		t[#t+1] = LoadFont("CourseEntryDisplay","number") .. {
			InitCommand=cmd(horizalign,right;x,GetGraphPosX(pn)+122;y,SCREEN_CENTER_Y-90;
						shadowlength,2;addx,20;diffuse,color("0,1,1,0");strokecolor,color("0,0.4,0.4,1");skewx,-0.5;maxwidth,60;);
			OnCommand=cmd(sleep,2.2;decelerate,0.3;addx,-20;diffuse,color("0,1,1,1");playcommand,"Count";);
			CountCommand=function(self)
				--self:finishtweening();
				self:sleep(0.025);
				if ccstpoint >= ccstpoint + (newpoint - oldpoint) then
					cpoint = ccstpoint;
				else
					cpoint = ccstpoint + (newpoint - oldpoint);
				end;
				self:settext(co);
				co = co + 1;
				if co <= cpoint then
					self:queuecommand("Count");
				end;
				if getenv("omsflag") == 1 and psStats:GetStage() ~= "Stage_Extra2" then
					setenv("cpoint",cpoint);
				end;
			end;
		};
	end;
end;

--[[	
	t[#t+1] = LoadFont("Common Normal")..{
		InitCommand=cmd(x,SCREEN_RIGHT-100;y,SCREEN_TOP+66;horizalign,right;zoom,0.45;playcommand,"Set");
		SetCommand=function(self)
			self:settext(getenv("onpurposefailgradep1"));
			--self:settext(htGrade[params.GSet]);
		end;	
	};

	t[#t+1] = LoadFont("Common Normal")..{
		InitCommand=cmd(x,SCREEN_RIGHT-100;y,SCREEN_TOP+76;horizalign,right;zoom,0.45;playcommand,"Set");
		SetCommand=function(self)
			self:settext("step : "..stepseconds);
		end;	
	};
]]

return t;