
local pn = ...;
assert(pn);

--local csize = split(",",ProfIDPrefCheck("CNoteSize",GetAdhocPref("ProfIDSet" .. ToEnumShortString(pn)),"New,0"))
 --[ja] Player.cpp 858～860行
local mlevel = GAMESTATE:IsCourseMode() and "ModsLevel_Stage" or "ModsLevel_Preferred";
local mini_set = GAMESTATE:GetPlayerState(pn):GetPlayerOptions(mlevel):Mini();
local tiny_set = GAMESTATE:GetPlayerState(pn):GetPlayerOptions(mlevel):Tiny();
if tiny_set == 1 then
	tiny_set = scale(mini_set,0.98,-1,0.5,1.5);
end;
local filterzoom = scale(mini_set+tiny_set,0.98,-1,0.5,1.5);
--[[
if csize[1] == "Old" and filterzoom < 0.99494 then
	mini_set = 1;
	tiny_set = 0;
	filterzoom = 1;
end;
]]

local t = Def.ActorFrame{};

local p = ( (pn == "PlayerNumber_P1") and 1 or 2 );
local realsaveflag = 1;
local mb_realsaveflag = 1;
local rf_style = {
	'StepsType_Dance_Single','StepsType_Dance_Double','StepsType_Dance_Solo',
	'StepsType_Pump_Single','StepsType_Pump_Halfdouble','StepsType_Pump_Double',
};
--[[
local rf_style2 = {
	'StepsType_Bm_Single5','StepsType_Bm_Double5',
	'StepsType_Bm_Single7','StepsType_Bm_Double7',
	'StepsType_Kb7_Single',
	'StepsType_Maniax_Single','StepsType_Maniax_Double',
};
local rf_style3 = {
	'StepsType_Ez2_Single','StepsType_Ez2_Double','StepsType_Ez2_Real',
	'StepsType_Para_Single',
	'StepsType_Ds3ddx_Single',
	'StepsType_Pnm_Five','StepsType_Pnm_Nine',
};
local rf_style4 = {
	'StepsType_Techno_Single4','StepsType_Techno_Single5','StepsType_Techno_Single8',
	'StepsType_Techno_Double4','StepsType_Techno_Double5','StepsType_Techno_Double8',
};
local mode = {
	dance = 1,pump = 1,
	bm = 2,kb7 = 2,maniax = 2,
	ez2 = 3,para = 3,ds3ddx = 3,pnm = 3,
	techno = 4,
};
]]
local rf_diff = {
	'Beginner',
	'Easy',
	'Medium',
	'Hard',
	'Challenge'
};

local rf_dp = {
	'CS',
	'SM'
};

--[ja] ベストスコア
local bs = {};
hs_local_set(bs,0);
bs["bsMIGS"] = 0;
local mbs = {};
hs_local_set(mbs,0);
mbs["bsMIGS"] = 0;
local sc_ps = {0,0,0,0,0};

local pnhealth;
--[ja] 20150911修正
--[ja] 0から足してく。そうでないとjcheckの分としてAが書き込まれてしまう。バグるから変えない
local jcheck = "TapNoteScore_AvoidMine";
local rftimelinecount = 0;
local st = GAMESTATE:GetCurrentStyle();
--local sttype = split("_",st:GetStepsType());
local profile;
local rf_path;
local m_rf_path;
local pid_name;
local scorelist;
local scores;
local topscore;
local mb_topscore;
local SongOrCourse = CurSOSet();
local StepsOrTrail = CurSTSet(pn);
local songdir;
local cautogen = 0;
local graphvisible = true;
local judgetvisible = true;
local tapsource = 1;
local assist = assistchecker(pn,"noset");
local icheck = insertchecker(pn,"noset","none");
if icheck then
	tapsource = 0;
end;
local tsteps = 0;
local tholds = 0;
local temp_grade_set = "Grade_Tier01";

if GAMESTATE:IsCourseMode() then
	songdir = SongOrCourse:GetCourseDir();
	if SongOrCourse:IsAutogen() or SongOrCourse:GetCourseType() == 'CourseType_Endless' or
	SongOrCourse:GetCourseType() == 'CourseType_Survival' then
	--[ja] AutogenコースやEndlessタイプコースはグラフ非表示
		cautogen = 1;
		graphvisible = false;
	end;
else songdir = SongOrCourse:GetSongDir();
end;
--[ja] Dance以外はグラフ非表示
--[[
if sttype[2] ~= "Dance" then graphvisible = false;
end;
]]
--[ja] LotsaOptionsがfalseの場合はグラフ・判定テーブル非表示
--[[
if GetUserPrefB("UserPrefShowLotsaOptions") ~= true then
	graphvisible = false;
	judgetvisible = false;
end;
]]

local sdirs;
--local tld;
local std;
local nsetstd;
local tmprs;
local rf_ps;
local date = string.format("%04i-%02i-%02i_%02i-%02i", Year(), MonthOfYear()+1,DayOfMonth(), Hour(), Minute());
local snum = 1;
local rv_table;

--[ja] AutogenコースやEndlessタイプコースではない時
if cautogen == 0 then
	sdirs = split("/",songdir);
	if sdirs then
		if sdirs[2] then
			sdirs[2] = additionaldir_to_songdir(sdirs[2]);
		end;
	end;
	--tld = GetLifeDifficulty()..":"..GetTimingDifficulty();
	std = songdir..":"..st:GetStepsType()..":"..ToEnumShortString(StepsOrTrail:GetDifficulty());
	nsetstd = st:GetStepsType().."_"..ToEnumShortString(StepsOrTrail:GetDifficulty());
	--[ja] Danceモードの時
	--if sttype[2] == "Dance" then
		if PROFILEMAN:IsPersistentProfile(pn) then
			profile = PROFILEMAN:GetProfile(pn);
			pid_name = profile:GetGUID().."_"..profile:GetDisplayName();
			rf_path = "CSRealScore/"..pid_name.."/"..sdirs[2].."/"..sdirs[3].."/"..sdirs[4].."/set_"..wpsetd.."_"..swpsetd;
--[[
			if CurGameName() ~= "dance" and CurGameName() ~= "pump" then
				rf_path = rf_path.."_"..mode[CurGameName()];
			end;
]]
			rf_ps = split("/",rf_path);
			scorelist = profile:GetHighScoreList(SongOrCourse,StepsOrTrail);
			assert(scorelist);
			scores = scorelist:GetHighScores();
			topscore = scores[1];
			snum = snum_set(1,scores,pn);
			if snum > 0 then
				topscore = scores[snum];
				if topscore then
					hs_set(bs,topscore,"normal");
				end;
			end;
			for i=1,5 do
				if scores[i] then
					sc_ps[i] = scores[i]:GetPercentDP();
				end;
			end;
		end;
	--end;
end;
local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn);
local pstr = ProfIDSet(p);

local g_judge_t_set_tbl = {{},{}};
setenv("pjcountp1",g_judge_t_set_tbl[1]);
setenv("pjcountp2",g_judge_t_set_tbl[2]);

local fscountp1 = {0,0};
local fscountp2 = {0,0};
setenv("fscountp1",{0,0});
setenv("fscountp2",{0,0});

--[ja] 判定進捗書き込み
local tjudgeset_s = {
	TapNoteScore_W1 = "1",
	TapNoteScore_W2 = "2",
	TapNoteScore_W3 = "3",
	TapNoteScore_W4 = "4",
	TapNoteScore_W5 = "5",
	TapNoteScore_Miss = "6",
	HoldNoteScore_Held = "7",
	HoldNoteScore_LetGo = "8",
	HoldNoteScore_MissedHold = "9",
	TapNoteScore_AvoidMine = "A",
	TapNoteScore_HitMine = "B",
	TapNoteScore_CheckpointHit = "C",
	TapNoteScore_CheckpointMiss = "D",
};
setmetatable(tjudgeset_s, { __index = function() return "X" end; });

local tjudgeset_rs = {
	n0 = "TapNoteScore_None",
	n1 = "TapNoteScore_W1",
	n2 = "TapNoteScore_W2",
	n3 = "TapNoteScore_W3",
	n4 = "TapNoteScore_W4",
	n5 = "TapNoteScore_W5",
	n6 = "TapNoteScore_Miss",
	n7 = "HoldNoteScore_Held",
	n8 = "HoldNoteScore_LetGo",
	n9 = "HoldNoteScore_MissedHold",
	nA = "TapNoteScore_AvoidMine",
	nB = "TapNoteScore_HitMine",
	nC = "TapNoteScore_CheckpointHit",
	nD = "TapNoteScore_CheckpointMiss",
	nN = "TapNoteScore_None"
};
setmetatable(tjudgeset_rs, { __index = function() return "TapNoteScore_None" end; });

local tjudgeset = "";

local cav_plus_set = {
	W1	= 5,
	W2	= 4,
	W3	= 3,
	W4	= 2,
	W5	= 1,
	Miss	= 6
};
setmetatable(cav_plus_set, { __index = function() return 0 end; });

--[ja] スコアグラフ位置
local graphdistance = ProfIDPrefCheck("graphdistance",pstr,"Far");
if getenv("graphdistance"..pstr) then
	graphdistance = getenv("graphdistance"..pstr);
end;

--[ja] 判定テーブル
local chpro = ProfIDPrefCheck("CProTiming",pstr,"No,No,No");
local chpros = split(",",chpro);
if chpros[3] ~= "JudgeTable" then
	judgetvisible = false; 
end;
--[ja] スコアグラフ
local adgraph = ProfIDPrefCheck("ScoreGraph",pstr,"Off");
local adtype = ProfIDPrefCheck("GraphType",pstr,"CS");
if adgraph == "Off" or adgraph == "nil" then
	graphvisible = false;
end;

if PROFILEMAN:IsPersistentProfile(pn) then
	if #rival_table(pstr,profile,"") > 0 then
		rv_table = rival_table(pstr,profile,pid_name);
	end;
	if string.find(adgraph,"^MyBest_.*") then
		mb_topscore = scores[split("_",adgraph)[2]];
		if mb_topscore then
			hs_set(mbs,mb_topscore,"normal");
			m_rf_path = "CSRealScore/"..pid_name.."/"..sdirs[2].."/"..sdirs[3].."/"..sdirs[4].."/set_"..wpsetd.."_"..swpsetd.."_MB2_5";
		end;
	end;
else 
	if string.find(adgraph,"^RIVAL_.*") then
		adgraph = "Off";
		graphvisible = false;
	end;
end;

--local adgstr = split("_",adgraph);
local wpswp = wp;
local gset = "ntype";
if adtype == "SM" then
	wpswp = swp;
	gset = "default";
end;

local ps = GAMESTATE:GetPlayerState(pn);
local modstr = "default, " .. string.lower(ps:GetPlayerOptionsString("ModsLevel_Preferred"));

local IsUsingSoloSingles = PREFSMAN:GetPreference('Center1Player');
local numpn = GAMESTATE:GetNumPlayersEnabled();
local cp = st:ColumnsPerPlayer();

--[ja] パネル数で読み込む画像とグラフの横幅を変更
local imageloadnum,graphwidth = 6,26;

--[ja] 判定テーブル縦座標
local jtablesety = SCREEN_TOP+140;
--[ja] 2人プレイ時スコアグラフ縦座標
local graph2psety = SCREEN_TOP+100+4;
local graph2ptergettexty = SCREEN_TOP+100+19;
local graph2ptargetbacky = SCREEN_TOP+112;

if judgetvisible then
	--[ja] 判定テーブルがONの時スコアグラフ縦座標を下にする
	if (adgraph ~= "Off" and adgraph ~= "nil") then
		graph2psety = SCREEN_TOP+190+4;
		graph2ptergettexty = SCREEN_TOP+190+19;
		graph2ptargetbacky = SCREEN_TOP+202;
	end;
end;
--[ja] REVERSE時
if string.find(modstr,"^.*reverse.*") then
	jtablesety = SCREEN_BOTTOM-140;
	graph2psety = SCREEN_BOTTOM-130+4;
	graph2ptergettexty = SCREEN_BOTTOM-148;
	graph2ptargetbacky = SCREEN_BOTTOM-130;
	if judgetvisible then
		--[ja] 判定テーブルがONの時スコアグラフ縦座標を上にする
		if (adgraph ~= "Off" and adgraph ~= "nil") then
			graph2psety = SCREEN_BOTTOM-224+4;
			graph2ptergettexty = SCREEN_BOTTOM-214-28;
			graph2ptargetbacky = SCREEN_BOTTOM-224;
		end;
	end;
end;

local asstcheck = CAspect() < 1.6 and cp > 6 and st:GetStyleType() == 'StyleType_OnePlayerTwoSides';

--[ja] 判定テーブル・スコアグラフの横移動チェック。1は移動、0は固定
local ctable = {1,1};

local stsetx = 94;
local cc_fz = (ColumnChecker()*filterzoom)/2;
local setx,jtablesetx,setaddx,afteraddx = GetPosition(pn)+cc_fz+stsetx,GetPosition(pn)+cc_fz+stsetx+120,80,-80;
if pn == PLAYER_2 then
	setx,jtablesetx,setaddx,afteraddx = GetPosition(pn)-cc_fz-stsetx,GetPosition(pn)-cc_fz-stsetx-120,-80,80;
end;

--[ja] アスペクト比1.6未満
if CAspect() < 1.6 then
	if IsUsingSoloSingles then
		ctable[1] = 0;
	end;
	if cp >= 6 then
		--[ja] 6パネル以上の時はスコアグラフ・判定テーブル場所固定
		ctable[1] = 0;
		ctable[2] = 0;

		--[ja] 7パネル以上の時は横幅を縮めた画像を呼び出した上でグラフ幅を縮める
		if cp >= 7 then imageloadnum,graphwidth = 8,13;
		end;

		--[ja] 小さいアスペクト比で5パネル以上の時は各種オブジェクトの間隔を詰める
		stsetx = 66;
		if pn == PLAYER_2 then stsetx = 61;
		end;
	end;

	setx = GetPosition(pn)+(ColumnChecker()/2)+stsetx;
	if ctable[1] == 0 then
		if graphdistance == "Far" or icheck then
			setx = SCREEN_RIGHT-WideScale(66,72);
		end;
		jtablesetx = GetPosition(pn)-(ColumnChecker()/2)-stsetx;
		if pn == PLAYER_2 then
			if graphdistance == "Far" or icheck then
				setx = SCREEN_LEFT+WideScale(66,72);
			end;
			jtablesetx = GetPosition(pn)+(ColumnChecker()/2)+stsetx;
		end;
	else
		--[ja] スコアグラフOffの時は判定テーブルをノート側に寄せる
		if graphdistance == "Far" or icheck then
			setx = SCREEN_RIGHT-WideScale(66,72);
			jtablesetx = GetPosition(pn)+(ColumnChecker()/2)+stsetx;
		end;
		if pn == PLAYER_2 then
			if graphdistance == "Far" or icheck then
				setx = SCREEN_LEFT+WideScale(66,72);
				jtablesetx = GetPosition(pn)-(ColumnChecker()/2)-stsetx;
			end;
		end;
		if adgraph == "Off" or adgraph == "nil" then
			jtablesetx = setx;
		end;
		if not graphvisible then
			jtablesetx = setx;
		end;
	end;

	if cp >= 6 and st:GetStyleType() == 'StyleType_OnePlayerTwoSides' then
		--[ja] 小さいアスペクト比でDoubleなどの際は判定テーブルをノート側に寄せる
		jtablesetx = GetPosition(pn)-(ColumnChecker()/2)-50;
	end;
	if pn == PLAYER_2 then
		setx = GetPosition(pn)-(ColumnChecker()/2)-stsetx;
		if cp >= 6 and st:GetStyleType() == 'StyleType_OnePlayerTwoSides' then
			--[ja] 小さいアスペクト比でDoubleなどの際は判定テーブルをノート側に寄せる
			jtablesetx = GetPosition(pn)+(ColumnChecker()/2)+50;
		end;
	end;
--[ja] アスペクト比1.6以上
else
	if cp >= 6 then
		ctable[1] = 0;
	else
		if IsUsingSoloSingles then
			ctable[1] = 0;
		end;
	end;

	--[ja] 6パネル以上の時は判定テーブル場所固定
	if ctable[1] == 0 then
		if graphdistance == "Far" or icheck then
			setx = SCREEN_RIGHT-WideScale(66,72);
		end;
		jtablesetx = GetPosition(pn)-(ColumnChecker()/2)-stsetx;
		if pn == PLAYER_2 then
			if graphdistance == "Far" or icheck then
				setx = SCREEN_LEFT+WideScale(66,72);
			end;
			jtablesetx = GetPosition(pn)+(ColumnChecker()/2)+stsetx;
		end;
	else
		--[ja] スコアグラフOffの時は判定テーブルをノート側に寄せる
		if graphdistance == "Far" or icheck then
			setx = SCREEN_RIGHT-WideScale(66,72);
			jtablesetx = GetPosition(pn)+(ColumnChecker()/2)+stsetx;
		end;
		if pn == PLAYER_2 then
			if graphdistance == "Far" or icheck then
				setx = SCREEN_LEFT+WideScale(66,72);
				jtablesetx = GetPosition(pn)-(ColumnChecker()/2)-stsetx;
			end;
		end;
		if adgraph == "Off" or adgraph == "nil" then
			jtablesetx = setx;
		end;
		if not graphvisible then
			jtablesetx = setx;
		end;
	end;
	--[ja] アスペクト比1.6を含む2サイドプレイ時
	if CAspect() <= 1.6 and cp > 6 and st:GetStyleType() == 'StyleType_OnePlayerTwoSides' then
		--[ja] 小さいアスペクト比でDoubleなどの際は各種オブジェクトの間隔を詰める
		stsetx = 66;
		ctable[2] = 0;
		if pn == PLAYER_2 then stsetx = 61;
		end;
		setx = GetPosition(pn)+(ColumnChecker()/2)+stsetx;
		jtablesetx = GetPosition(pn)-(ColumnChecker()/2)-stsetx;
		if pn == PLAYER_2 then
			setx = GetPosition(pn)-(ColumnChecker()/2)-stsetx;
			jtablesetx = GetPosition(pn)+(ColumnChecker()/2)+stsetx;
		end;
	end;
end;
if not graphvisible then ctable[2] = 0;
end;

setenv("migsp1",0);
setenv("migsp2",0);

local statsCategoryValues = {
	{ Category = "TapNoteScore_W1" , Color = Colors.Judgment["JudgmentLine_W1"] , Text = "FA"},
	{ Category = "TapNoteScore_W2" , Color = Colors.Judgment["JudgmentLine_W2"] , Text = "WO"},
	{ Category = "TapNoteScore_W3" , Color = Colors.Judgment["JudgmentLine_W3"] , Text = "GR"},
	{ Category = "TapNoteScore_W4" , Color = Colors.Judgment["JudgmentLine_W4"] , Text = "GO"},
	{ Category = "TapNoteScore_W5" , Color = Colors.Judgment["JudgmentLine_W5"] , Text = "BA"},
	{ Category = "TapNoteScore_Miss" , Color = Colors.Judgment["JudgmentLine_Miss"] , Text = "PO"},
	{ Category = "HoldNoteScore_Held" , Color = Colors.Judgment["JudgmentLine_Held"] , Text = "OK"},
};

--[ja] 判定数
local stats = {
	TotalSteps					= 0,
	RadarCategory_Holds			= 0,
	RadarCategory_Rolls			= 0,
	RadarCategory_Mines			= 0,
	RadarCategory_Lifts			= 0,
	TapNoteScore_W1			= 0,
	TapNoteScore_W2			= 0,
	TapNoteScore_W3			= 0,
	TapNoteScore_W4			= 0,
	TapNoteScore_W5			= 0,
	TapNoteScore_Miss			= 0,
	HoldNoteScore_Held			= 0,
	HoldNoteScore_LetGo			= 0,
	TapNoteScore_HitMine		= 0,
	TapNoteScore_AvoidMine		= 0,
	TapNoteScore_CheckpointHit	= 0,
	TapNoteScore_CheckpointMiss	= 0,
	MaxCombo					= 0,
	HoldNoteScore_MissedHold		= 0,
	SurvivalSeconds				= 0,
	PercentScore				= 0
};

local mbs = {
	TotalSteps					= 0,
	RadarCategory_Holds			= 0,
	RadarCategory_Rolls			= 0,
	RadarCategory_Mines			= 0,
	RadarCategory_Lifts			= 0,
	TapNoteScore_W1			= 0,
	TapNoteScore_W2			= 0,
	TapNoteScore_W3			= 0,
	TapNoteScore_W4			= 0,
	TapNoteScore_W5			= 0,
	TapNoteScore_Miss			= 0,
	HoldNoteScore_Held			= 0,
	HoldNoteScore_LetGo			= 0,
	TapNoteScore_HitMine		= 0,
	TapNoteScore_AvoidMine		= 0,
	TapNoteScore_CheckpointHit	= 0,
	TapNoteScore_CheckpointMiss	= 0,
	MaxCombo					= 0,
	HoldNoteScore_MissedHold		= 0,
	SurvivalSeconds				= 0,
	PercentScore				= 0
};

local MIGS = 0;				--[ja] 現在スコア
local MIGS_MAX = 0;			--[ja] 最終スコア
local cMIGS_MAX = 0;			--[ja] 目標スコア
local iMIGS_MAX = 0;			--[ja] 暫定スコア
local cscoregraphheight = 0;	--[ja] user進捗高さ
local targetcoregraphheight = 0;	--[ja] target進捗高さ
local graphheight = 220;		--[ja] グラフの最大高さ
local adhoc = 0;
local migsadhoc = 0;			--[ja] 最終目標
local cmigsadhoc = 0;			--[ja] 現在の目標
local ccheckheight = 0;
local total_st_ho = 0;
local total_st_ho_mi = 0;

local rscoredata = {};
local rscorecheck = false;
local migsnum = 0;

--[ja] 20150111修正 Dance以外時に判定平均ボックスで必要な関数が取れなかった問題を修正
steps_count(bs,SongOrCourse,StepsOrTrail,pn,"C_Mines");
stats["TotalSteps"] = bs["TotalSteps"];
stats["RadarCategory_Holds"] = bs["RadarCategory_Holds"];
stats["RadarCategory_Rolls"] = bs["RadarCategory_Rolls"];
stats["RadarCategory_Mines"] = bs["RadarCategory_Mines"];
stats["RadarCategory_Lifts"] = bs["RadarCategory_Lifts"];
total_st_ho = bs["TotalSteps"] + bs["RadarCategory_Holds"] + bs["RadarCategory_Rolls"];
total_st_ho_mi = total_st_ho + bs["RadarCategory_Mines"];

steps_count(mbs,SongOrCourse,StepsOrTrail,pn,"C_Mines");
mbs["TotalSteps"] = bs["TotalSteps"];
mbs["RadarCategory_Holds"] = bs["RadarCategory_Holds"];
mbs["RadarCategory_Rolls"] = bs["RadarCategory_Rolls"];
mbs["RadarCategory_Mines"] = bs["RadarCategory_Mines"];
mbs["RadarCategory_Lifts"] = bs["RadarCategory_Lifts"];

---------------------------------------------------------------------------------------------------------------------------------------
--[ja] 20150909 先頭にAが入っている場合の対策
local function s_check(tmprs,total_st_ho_mi)
	if #tmprs == total_st_ho_mi + 1 then
		return 1;
	end;
	return 0;
end;
local cs_p = 0;

local function sc_t_set(rf_str,rf_t,mb,bs,stats,rf_dp,date,gradeset,pgset,fccheck,wpmigs,swpmigs,tjudgeset,statsset,tldsetd,pnhealth)
	for m=1,#rf_dp do
		local pgset = "ntype";
		local swpm = wpmigs;
		local wMIGS_MAX = migsmaxchecker(bs,pgset);
		if m == 2 then
			pgset = "default";
			swpm = swpmigs;
			wMIGS_MAX = migsmaxchecker(bs,pgset);
		end;
		local m_set = date..":"..gradeset.."/"..fccheck..":"..swpm..":"..tjudgeset..":"..statsset..":"..tldsetd;
		if mb == "MyBest" then
			m_set = m_set..":"..stats["PercentScore"];
		end;
		if pnhealth ~= 'HealthState_Dead' then
			stats["PercentScore"] = tonumber(swpm / wMIGS_MAX);
			gradeset = gradechecker(stats,gradeset,0,pgset,fccheck);
		end;
		--date - 1: gradeset - 2: swpm - 3: tjudgeset - 4: judgecount - 5: tldsetd - 6;
		rf_t[#rf_t+1] = { "#"..nsetstd.."/"..rf_dp[m] , m_set };
	end;
	if rf_t ~= "" then
		for n=1,#rf_t do
			rf_str = rf_str..""..rf_t[n][1]..":"..rf_t[n][2]..";\n";
		end;
	end;
	return rf_str
end;

--scoreset
t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(playcommand,"Set");
	--UpdateCommand=cmd(playcommand,"Set";);
	SetCommand=function(self)
		self:stoptweening();
	--	setenv("csperp","Grade_Tier01");
	--	(cmd(horizalign,left;zoom,0.85;shadowlength,0;))(self)
		--Trace("Asc: "..dcount.."/"..jcsteps);
		if graphvisible then
			MIGS_MAX = migsmaxchecker(bs,gset);
			bs["bsMIGS"] = migschecker(bs,gset);
			if adgraph ~= "Off" and adgraph ~= "nil" then
				if string.find(adgraph,"Tier") then
					if adtype == "SM" then
						adhoc = THEME:GetMetric("PlayerStageStats","GradePercent"..adgraph);
					else adhoc = THEME:GetMetric("PlayerStageStats","GradePercentCS"..adgraph);
					end;
					ccheckheight = adhoc;
					migsadhoc = math.ceil(MIGS_MAX * ccheckheight);
				elseif string.find(adgraph,"^MyBest_.*") then
					if PROFILEMAN:IsPersistentProfile(pn) then
						mbs["bsMIGS"] = migschecker(mbs,gset);
						migsadhoc = mbs["bsMIGS"];
						ccheckheight = migsadhoc/MIGS_MAX;
					end;
					if cautogen == 0 and FILEMAN:DoesFileExist( m_rf_path ) then
						if GetRSParameter(m_rf_path,nsetstd.."/"..adtype) ~= "" then
							tmprs = split(":",GetRSParameter(m_rf_path,nsetstd.."/"..adtype);
						end;
						if tmprs and #tmprs >= 4 and tonumber(tmprs[3]) >= tonumber(mbs["bsMIGS"]) then
							migsadhoc = tonumber(mbs["bsMIGS"]);
							ccheckheight = migsadhoc/tonumber(MIGS_MAX);
							if string.sub(tmprs[4],1,1) ~= "x" then
								cs_p = s_check(tmprs[4],total_st_ho_mi);
								for p=1 + cs_p,total_st_ho_mi + cs_p do
									if string.sub(tmprs[4],p,p) ~= "" then
										rscoredata[p] = wpswp[tjudgeset_rs["n"..string.sub(tmprs[4],p,p)]];
									else rscoredata[p] = 0;
									end;
									if p == total_st_ho_mi + cs_p then
										rscorecheck = true;
									end;
								end;
							end;
						end;
					end;
				elseif adgraph == "MyBest" then
					if PROFILEMAN:IsPersistentProfile(pn) then
						migsadhoc = bs["bsMIGS"];
						ccheckheight = migsadhoc/MIGS_MAX;
					end;
					if cautogen == 0 and FILEMAN:DoesFileExist( rf_path ) then
						if GetRSParameter(rf_path,nsetstd.."/"..adtype) ~= "" then
							tmprs = split(":",GetRSParameter(rf_path,nsetstd.."/"..adtype));
						end;
						if tmprs and #tmprs >= 4 and tonumber(tmprs[3]) >= tonumber(bs["bsMIGS"]) then
							migsadhoc = tonumber(tmprs[3]);
							ccheckheight = tonumber(tmprs[3])/tonumber(MIGS_MAX);
							if string.sub(tmprs[4],1,1) ~= "x" then
								cs_p = s_check(tmprs[4],total_st_ho_mi);
								for p=1 + cs_p,total_st_ho_mi + cs_p do
									if string.sub(tmprs[4],p,p) ~= "" then
										rscoredata[p] = wpswp[tjudgeset_rs["n"..string.sub(tmprs[4],p,p)]];
									else rscoredata[p] = 0;
									end;
									if p == total_st_ho_mi + cs_p then
										rscorecheck = true;
									end;
								end;
							end;
						end;
					end;
				elseif string.find(adgraph,"^RIVAL_.*") then
					--{sctable[1],sctable[2],sctable[3],sctable[4],sctable[5],sctable[6]};
					--CS_TopScore,CS_On1rank,CS_Average,SM_TopScore,SM_On1rank,SM_Average
					--[ja] ライバルはcr_path
					local cr_path = "";
					if adgraph == "RIVAL_TopScore" then
						local base_rt = 4;
						if adtype ~= "SM" then base_rt = 1;
						end;
						if getenv("sctable"..p)[base_rt] then
							adgraph = "RIVAL_"..getenv("sctable"..p)[base_rt];
						end;
					elseif adgraph == "RIVAL_On1rank" then
						local base_ro = 5;
						if adtype ~= "SM" then base_ro = 2;
						end;
						if getenv("sctable"..p)[base_ro] then
							adgraph = "RIVAL_"..getenv("sctable"..p)[base_ro];
						end;
					elseif adgraph == "RIVAL_Average" then
						local base_ra = 6;
						if adtype ~= "SM" then base_ra = 3;
						end;
						if getenv("sctable"..p)[base_ra] then
							migsadhoc = getenv("sctable"..p)[base_ra];
							ccheckheight = migsadhoc/tonumber(MIGS_MAX);
						end;
					end;
					if adgraph ~= "RIVAL_Average" then
						cr_path = "CSRealScore/"..string.sub(adgraph,7).."/"..sdirs[2].."/"..sdirs[3].."/"..sdirs[4].."/set_"..wpsetd.."_"..swpsetd;
						local ggset = true;
						if cautogen == 0 and FILEMAN:DoesFileExist( cr_path ) then
							if GetRSParameter(cr_path,nsetstd.."/"..adtype) ~= "" then
								tmprs = split(":",GetRSParameter(cr_path,nsetstd.."/"..adtype));
							end;
							if tmprs and #tmprs >= 3 then
								--[ja] 自スコアの場合ベストとグラフのスコアを比べてベストが大きい場合はグラフの数値を返さない
								if string.sub(adgraph,7) == pid_name and bs["bsMIGS"] > tonumber(tmprs[3]) then
									ggset = false;
									migsadhoc = tonumber(bs["bsMIGS"]);
									ccheckheight = tonumber(bs["bsMIGS"])/tonumber(MIGS_MAX);
								end;
								
								if ggset then
									migsadhoc = tonumber(tmprs[3]);
									ccheckheight = tonumber(tmprs[3])/tonumber(MIGS_MAX);
									if tmprs[4] then
										if string.sub(tmprs[4],1,1) ~= "x" then
											cs_p = s_check(tmprs[4],total_st_ho_mi);
											for p=1,total_st_ho_mi do
												if string.sub(tmprs[4],p,p) ~= "" then
													rscoredata[p] = wpswp[tjudgeset_rs["n"..string.sub(tmprs[4],p,p)]];
												else rscoredata[p] = 0;
												end;
												if p == total_st_ho_mi + cs_p then
													rscorecheck = true;
												end;
											end;
										end;
									end;
								end;
							end;
						end;
					end;
				elseif tonumber(adgraph) then
					ccheckheight = tonumber(adgraph);
					migsadhoc = math.ceil(MIGS_MAX * ccheckheight);
				else
					migsadhoc = 0;
					ccheckheight = 0;
				end;
				--[ja] リザルト画面でも使用するライバルターゲットスコア
				setenv("resultmigsadhoc"..p,migsadhoc);
				if getenv("rnd_song") == 1 then
					migsadhoc = 0;
					ccheckheight = 0;
				end;
			end;
		end;
	end;
	JudgmentMessageCommand=function(self, params)
		self:stoptweening();
		if params.Player == pn then
			-- [ja] insertオプションチェック
--[[
				if params.Notes then
					for track, tapnote in pairs(params.Notes) do
						if tapnote:GetTapNoteSource() == 'TapNoteSource_Original' then
							tapsource = 1;
						else tapsource = 0;
						end;
					end;
				end;
]]
			--[ja] 20140820修正 Mineの取得がすごいのでひと工夫
			--20160425
			icheck = insertchecker(pn,"noset","controller_auto");
			if tapsource == 1 and icheck then
				tapsource = 0;
			end;
			pnhealth = ps:GetHealthState();
			if (params.TapNoteScore ~= 'TapNoteScore_Invalid' and params.TapNoteScore ~= 'TapNoteScore_None') then
				stats[params.HoldNoteScore or params.TapNoteScore] = stats[params.HoldNoteScore or params.TapNoteScore] + 1;
				if params.TapNoteScore ~= 'TapNoteScore_AvoidMine' and params.TapNoteScore ~= 'TapNoteScore_HitMine' then
					if not params.HoldNoteScore and params.TapNoteScore then
						if cav_plus_set[ToEnumShortString(params.TapNoteScore)] > 0 then
							if tapsource == 0 then
								tsteps = tsteps + 1;
							end;
							-- [ja] FAST/SLOW回数記憶
							if cav_plus_set[ToEnumShortString(params.TapNoteScore)] < 5 then
								if params.Early then
									if pn == PLAYER_1 then fscountp1[1] = fscountp1[1] + 1;
									else fscountp2[1] = fscountp2[1] + 1;
									end;
								else
									if pn == PLAYER_1 then fscountp1[2] = fscountp1[2] + 1;
									else fscountp2[2] = fscountp2[2] + 1;
									end;
								end;
								--SCREENMAN:SystemMessage(fscountp1[1]..","..fscountp1[2]);
							end;
						end;
					elseif params.HoldNoteScore then
						if params.HoldNoteScore ~= "HoldNoteScore_None" then
							if tapsource == 0 then
								tholds = tholds + 1;
							end;
						end;
					end;
					--SCREENMAN:SystemMessage(tsteps..","..tholds);
					if tapsource == 1 and cautogen == 0 then
						--Trace("tpparam : "..params.HoldNoteScore or params.TapNoteScore)
					
						--[ja] CSRealScore
						if pnhealth ~= 'HealthState_Dead' then
							tjudgeset = tjudgeset..tjudgeset_s[params.HoldNoteScore or params.TapNoteScore];
						else tjudgeset = tjudgeset.."X";
						end;
						jcheck = "OK";
					end;
					--Trace("FAST/SLOW:".. fscountp1[1].."/"..fscountp1[2] .."/"..stats["TapNoteScore_W2"]+stats["TapNoteScore_W3"]+stats["TapNoteScore_W4"]+stats["TapNoteScore_W5"]+stats["TapNoteScore_Miss"]);
				else jcheck = params.HoldNoteScore or params.TapNoteScore;
				end;
			end;
		end;
	end;
	--[ja] 20150818修正
	ScoreChangedMessageCommand=function(self, params)
		self:stoptweening();
		if params.PlayerNumber == pn then
			--stats["MaxCombo"] = pss:MaxCombo();
			--[ja] スコアグラフ進捗チェック
			--[ja] 0の時は書き込まないようにする。バグるから変えない (92行目付近を参照)
			if rftimelinecount >= 1 then
				MIGS = migschecker(stats,gset);
				--[ja] CSRealScore
				pnhealth = ps:GetHealthState();
				if cautogen == 0 then
					if tapsource == 1 then
						iMIGS_MAX = ((stats["TapNoteScore_W1"] + stats["TapNoteScore_W2"] + 
								stats["TapNoteScore_W3"] + stats["TapNoteScore_W4"] + 
								stats["TapNoteScore_W5"] + stats["TapNoteScore_Miss"]) * wpswp["TapNoteScore_W1"]) + 
								((stats["TapNoteScore_CheckpointHit"] + stats["TapNoteScore_CheckpointMiss"]) * wpswp["TapNoteScore_CheckpointHit"]) + 
								((stats["HoldNoteScore_Held"] + stats["HoldNoteScore_LetGo"]) * wpswp["HoldNoteScore_Held"]) + 
								(stats["HoldNoteScore_MissedHold"] * wpswp["HoldNoteScore_Held"]);
					end;
					if jcheck ~= "OK" then
						if pnhealth ~= 'HealthState_Dead' then
							tjudgeset = tjudgeset..tjudgeset_s[jcheck];
						else tjudgeset = tjudgeset.."X";
						end;
					end;
					--Trace("tjudgeset:".. tjudgeset);
					jcheck = "TapNoteScore_AvoidMine";

					if adgraph == "MyBest" or string.find(adgraph,"^MyBest_.*") then
						if tapsource == 1 then
							if rscorecheck then
								--[ja] CSRealScoreチェック
								if rscoredata[rftimelinecount] then
									cMIGS_MAX = cMIGS_MAX + rscoredata[rftimelinecount];
								end;
							else
								if PROFILEMAN:IsPersistentProfile(pn) then
									--hold or roll
									if string.find(string.sub(tjudgeset,rftimelinecount,rftimelinecount),"^[7-9]$") then
										cMIGS_MAX = cMIGS_MAX + 
												(bs["HoldNoteScore_Held"] * wpswp["HoldNoteScore_Held"]) / 
												(bs["RadarCategory_Holds"] + bs["RadarCategory_Rolls"]);
									--mine
									elseif string.find(string.sub(tjudgeset,rftimelinecount,rftimelinecount),"^[AB]$") then
										--[ja] 何もしない(tapに振替)
										cMIGS_MAX = cMIGS_MAX;
									else
									--tap
										if string.find(adgraph,"^MyBest_.*") then
											cMIGS_MAX = cMIGS_MAX + 
													(mbs["bsMIGS"] - (bs["HoldNoteScore_Held"] * 
													wpswp["HoldNoteScore_Held"])) / bs["TotalSteps"];

										else
											cMIGS_MAX = cMIGS_MAX + 
													(bs["bsMIGS"] - (bs["HoldNoteScore_Held"] * 
													wpswp["HoldNoteScore_Held"])) / bs["TotalSteps"];
										end;
									end;
								end;
							end;
						end;
						cscoregraphheight = math.floor(MIGS / MIGS_MAX * graphheight);
						cmigsadhoc = cMIGS_MAX;
						targetcoregraphheight = math.floor(cmigsadhoc / MIGS_MAX * graphheight);
					elseif string.find(adgraph,"^RIVAL_.*") then
						if tapsource == 1 then
							if rscorecheck then
								--[ja] CSRealScoreチェック
								if rscoredata[rftimelinecount] then
									cMIGS_MAX = cMIGS_MAX + rscoredata[rftimelinecount];
								end;
							else
								if migsadhoc > 0 then
									if string.find(string.sub(tjudgeset,rftimelinecount,rftimelinecount),"^[AB]$") then
										--[ja] 何もしない(tapに振替)
										cMIGS_MAX = cMIGS_MAX;
									else
									--tap
										cMIGS_MAX = cMIGS_MAX + 
												(migsadhoc / (total_st_ho));
									end;
								end;
							end;
						end;
						cscoregraphheight = math.floor(MIGS / MIGS_MAX * graphheight);
						cmigsadhoc = cMIGS_MAX;
						targetcoregraphheight = math.floor(cmigsadhoc / MIGS_MAX * graphheight);
					else
						if tapsource == 1 then
							cMIGS_MAX = iMIGS_MAX
						end;
						--[ja] 20140120修正
						cscoregraphheight = math.floor(MIGS / MIGS_MAX * graphheight);
						cmigsadhoc = math.ceil(cMIGS_MAX * ccheckheight);
						targetcoregraphheight = math.floor( (cMIGS_MAX * ccheckheight ) / MIGS_MAX * graphheight);
					end;
					
				end;
			end;

			cscoregraphheight = math.round(cscoregraphheight);
			targetcoregraphheight = math.round(targetcoregraphheight);
			cmigsadhoc = math.round(cmigsadhoc);
			cscoregraphheight = math.max(0,cscoregraphheight);
			cscoregraphheight = math.min(graphheight,cscoregraphheight);
			targetcoregraphheight = math.max(0,targetcoregraphheight);
			targetcoregraphheight = math.min(graphheight,targetcoregraphheight);
			if tapsource == 1 then
				rftimelinecount = rftimelinecount + 1;
			end;
			--tapsource = 1;
			MESSAGEMAN:Broadcast("TSet");
		end;
	end;
	OffCommand=function(self)
		self:stoptweening();
		pnhealth = ps:GetHealthState();
		setenv("tempscorep"..p,0);
		--[ja] 20150213修正
		if getenv("fcplayercheck_p"..p) == 1 then
			setenv("tempscorep"..p,STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):GetScore());
			STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):SetScore(0);
		end;
		
		if pn == PLAYER_1 then
--[[
			for x=1,dcount do
				Trace("Count"..x.." : ".. pjcountp1[x]);
			end;
]]
			setenv("fscountp1",fscountp1);
			setenv("tstepsp1",tsteps);
			setenv("tholdsp1",tholds);
		else
			setenv("fscountp2",fscountp2);
			setenv("tstepsp2",tsteps);
			setenv("tholdsp2",tholds);
		end;
		
		(cmd(sleep,0.5;playcommand,"SetWrite"))(self)
	end;
	SetWriteCommand=function(self)
		self:stoptweening();
		if getenv("fcplayercheck_p"..p) == 0 and tapsource == 1 then
		--[ja] CSRealScore -----------------------------------------------------------------------------------------------------------
			--[ja] AutogenコースやEndlessタイプコースではない時
			if cautogen == 0 then
				--[ja] 判定平均ボックス ---------------------------------------------------------------------------
				g_judge_t_set_tbl[p] = jbox_setting(tjudgeset,bs["TotalSteps"]);

				--local ct_dic = THEME:GetCurrentThemeDirectory();
				--File.Write( ct_dic.."/Other/g_tjudgeset.txt" , table.concat(g_judge_t_set_tbl[p]) );
				if PROFILEMAN:IsPersistentProfile(pn) then
					local wpmigs = migschecker(stats,"ntype");
					local swpmigs = migschecker(stats,"default");
					local statsset =	stats["TapNoteScore_W1"]..","..stats["TapNoteScore_W2"]..","..stats["TapNoteScore_W3"]..","..
								stats["TapNoteScore_W4"]..","..stats["TapNoteScore_W5"]..","..stats["TapNoteScore_Miss"]..","..
								stats["HoldNoteScore_Held"]..","..stats["HoldNoteScore_LetGo"];
					local fccheck = 5;
					if not assist then
						if total_st_ho > 0 then
							if pnhealth ~= 'HealthState_Dead' then
								--[ja] 20160405修正
								fccheck = fullcombochecker(stats,0,"r_save");
							end;
						end;
					else fccheck = 9;
					end;
					local pnscore = pss:GetPercentDancePoints();
					--local pnscore = pss:GetScore();
					local gradeset = "Grade_Tier21";
					--#Prof : pid_name - 1:2;
					--#SongDir : songdir - 1;
					--Trace("deadc : "..pnhealth);
					if StepsOrTrail:GetDifficulty() ~= 'Difficulty_Edit' then
						if not FILEMAN:DoesFileExist( rf_path ) then
							if cautogen == 0 then
								if realsaveflag == 1 then
									--if pnhealth ~= 'HealthState_Dead' then
										local rf_str = "";
										local rf_t = {};
										rf_str = sc_t_set(rf_str,rf_t,"none",bs,stats,rf_dp,date,gradeset,pgset,fccheck,wpmigs,swpmigs,tjudgeset,statsset,tldsetd,pnhealth);
										File.Write( rf_path , "#Prof:"..pid_name..";\n#SongDir:"..sdirs[3].."/"..sdirs[4]..";\n"..rf_str );
									--end;
									realsaveflag = 0;
								end;
							end;
						else
							if cautogen == 0 then
								if realsaveflag == 1 then
									local rf_str = "";
									local rf_t = {};
									for i=1,#rf_style do
										local rfs = rf_style[i];
										for j=1,#rf_diff do
											local rfd = rf_diff[j];
											for l=1,#rf_dp do
												local tcheck = 1;
												local tmpo = "";
												if GetRSParameter(rf_path,rfs.."_"..rfd.."/"..rf_dp[l]) ~= "" then
													tmpo = split(":",GetRSParameter(rf_path,rfs.."_"..rfd.."/"..rf_dp[l]));
												end;
												--[ja] プレイした難易度と同じ
												if nsetstd == rfs.."_"..rfd then
													local pgset = "ntype";
													local swpm = wpmigs;
													if l == 2 then
														pgset = "default";
														swpm = swpmigs;
													end;
													local wMIGS_MAX = migsmaxchecker(bs,pgset);
													--local bestscore = migschecker(bs,pgset);
													if pnhealth ~= 'HealthState_Dead' then
														stats["PercentScore"] = tonumber(swpm / wMIGS_MAX);
														gradeset = gradechecker(stats,gradeset,0,pgset,fccheck);
													end;
													if GetRSParameter(rf_path,rfs.."_"..rfd.."/"..rf_dp[l]) ~= "" then
														if #tmpo > 0 then
															local tmpot = {};
															local tmpostr = "";
															local tmpogs = {};
															local tmpogss;
															tmpogs[1] = "Grade_Tier21";
															if tmpo[2] ~= "" and tmpo[2] ~= nil then
																tmpogss = split("/",tmpo[2]);
																tmpogs[1] = tmpogss[1];
																tmpogs[2] = tmpogss[2];
															end;
															--[ja] 情報がないとき(確認)
															--date - 1: gradeset - 2: swpm - 3: tjudgeset - 4: judgecount - 5: tldsetd - 6;
															if tostring(rf_ps[6]) == "set_"..wpsetd.."_"..swpsetd then
																--if pnhealth ~= 'HealthState_Dead' then
																	--if swpm >= bestscore then
																	if pnscore >= bs["PercentScore"] then
																		--[ja] スコア更新(書き換え)
																		tmpot[1] = date;
																		if tonumber(string.sub(gradeset,-2)) < tonumber(string.sub(tmpogs[1],-2)) then
																			tmpogs[1] = gradeset;
																		end;
																		Trace("gradeset3 : "..tonumber(string.sub(tmpogs[1],-2)));
																		if #tmpogs >= 2 then
																			if tonumber(tmpogs[2]) > fccheck then
																				tmpot[2] = tmpogs[1].."/"..fccheck;
																			else tmpot[2] = tmpogs[1].."/"..tmpogs[2];
																			end;
																		else tmpot[2] = tmpogs[1].."/"..fccheck;
																		end;
																		tmpot[3] = swpm;
																		tmpot[4] = tjudgeset;
																		tmpot[5] = statsset;
																		tmpot[6] = tldsetd;
																		for tmc=1,#tmpot do
																			if tmpot[tmc] ~= "" then
																				tmpostr = table.concat(tmpot,":");
																			end;
																		end;
																	else
																		--[ja] スコア未更新(そのままコピー)
																		for tmc=1,#tmpo do
																			if tmpo[tmc] ~= "" then
																				tmpostr = table.concat(tmpo,":");
																			end;
																		end;
																	end;
																--end;
															end;
															rf_t[#rf_t+1] ={ "#"..rfs.."_"..rfd.."/"..rf_dp[l] , tmpostr };
															tcheck = 0;
														end;
													end;
													if tcheck == 1 then
														--[ja] 情報がないとき(新規)
														--if pnhealth ~= 'HealthState_Dead' then
															rf_t[#rf_t+1] = { "#"..nsetstd.."/"..rf_dp[l] , 
																		date..":"..gradeset.."/"..fccheck..":"..swpm..":"..tjudgeset..":"..statsset..":"..tldsetd };
														--end;
													end;
												else
												--[ja] プレイした難易度と違う(そのままコピー)
													if GetRSParameter(rf_path,rfs.."_"..rfd.."/"..rf_dp[l]) ~= "" then
														local tmpot = {};
														local tmpostr = "";
														if #tmpo > 0 then
															for tmc=1,#tmpo do
																if tmpo[tmc] ~= "" then
																	tmpot[tmc] = tmpo[tmc];
																	tmpostr = table.concat(tmpot,":");
																end;
															end;
															if #tmpostr ~= "" then
																rf_t[#rf_t+1] ={ "#"..rfs.."_"..rfd.."/"..rf_dp[l] , tmpostr };
															end;
														end;
													end;
												end;
											end;
										end;
									end;
									if #rf_t > 0 then
										for k=1,#rf_t do
											rf_str = rf_str..""..rf_t[k][1]..":"..rf_t[k][2]..";\n";
										end;
									end;
									if rf_str ~= "" then
										File.Write( rf_path , "#Prof:"..pid_name..";\n#SongDir:"..sdirs[3].."/"..sdirs[4]..";\n"..rf_str );
									end;
									realsaveflag = 0;
								end;
							end;
						end;
						if bs["PercentScore"] > pnscore then
							if not FILEMAN:DoesFileExist( m_rf_path ) then
								if cautogen == 0 then
									if mb_realsaveflag == 1 then
										--if pnhealth ~= 'HealthState_Dead' then
											local rf_str = "";
											local rf_t = {};
											rf_str = sc_t_set(rf_str,rf_t,"MyBest",bs,stats,rf_dp,date,gradeset,pgset,fccheck,wpmigs,swpmigs,tjudgeset,statsset,tldsetd,pnhealth);
											File.Write( m_rf_path , "#Prof:"..pid_name..";\n#SongDir:"..sdirs[3].."/"..sdirs[4]..";\n"..rf_str );
										--end;
										mb_realsaveflag = 0;
									end;
								end;
							else
								if cautogen == 0 then
									if mb_realsaveflag == 1 then
										local rf_str = "";
										local rf_t = {};
										for i=1,#rf_style do
											local rfs = rf_style[i];
											for j=1,#rf_diff do
												local rfd = rf_diff[j];
												local mb_table = {};
												for l=1,#rf_dp do
													for mb=1,6 do
														mb_table[mb] = {};
														local tcheck = 1;
														local tmpo = "";
														--[ja] プレイした難易度と同じ
														if nsetstd == rfs.."_"..rfd then
															local pgset = "ntype";
															local swpm = wpmigs;
															if l == 2 then
																pgset = "default";
																swpm = swpmigs;
															end;
															local wMIGS_MAX = migsmaxchecker(bs,pgset);
															--local bestscore = migschecker(bs,pgset);
															
															if mb == 1 then

																if pnhealth ~= 'HealthState_Dead' then
																	mbs
																	local wpmigs = migschecker(mbs,"ntype");
																	local swpmigs = migschecker(mbs,"default");
																	pss:
																	stats["PercentScore"] = tonumber(swpm / wMIGS_MAX);
																	gradeset = gradechecker(stats,gradeset,0,pgset,fccheck);
																end;
																local tmpot = {};
																local tmpostr = "";
																local tmpogs = {};
																local tmpogss;
																tmpot[1] = date;
																if tonumber(string.sub(gradeset,-2)) < tonumber(string.sub(tmpogs[1],-2)) then
																	tmpogs[1] = gradeset;
																end;
																if #tmpogs >= 2 then
																	if tonumber(tmpogs[2]) > fccheck then
																		tmpot[2] = tmpogs[1].."/"..fccheck;
																	else tmpot[2] = tmpogs[1].."/"..tmpogs[2];
																	end;
																else tmpot[2] = tmpogs[1].."/"..fccheck;
																end;
																tmpot[3] = swpm;
																tmpot[4] = tjudgeset;
																tmpot[5] = statsset;
																tmpot[6] = tldsetd;
																tmpot[7] = pnscore;
																for tmc=1,#tmpot do
																	if tmpot[tmc] ~= "" then
																		tmpostr = table.concat(tmpot,":");
																	end;
																end;
																if #tmpostr ~= "" then
																	mb_table[mb][l] ={ "#"..rfs.."_"..rfd.."/"..rf_dp[l].."/"..[mb] , tmpostr };
																end;
															else
																if GetRSParameter(m_rf_path,rfs.."_"..rfd.."/"..rf_dp[l].."/"..[mb]) ~= "" then
																	local tmpot = {};
																	local tmpostr = "";
																	if #tmpo > 0 then
																		for tmc=1,#tmpo do
																			if tmpo[tmc] ~= "" then
																				tmpot[tmc] = tmpo[tmc];
																				tmpostr = table.concat(tmpot,":");
																			end;
																		end;
																		if #tmpostr ~= "" then
																			mb_table[mb][l] ={ "#"..rfs.."_"..rfd.."/"..rf_dp[l].."/"..[mb] , tmpostr };
																		end;
																	end;
																end;
															end;
														else
														--[ja] プレイした難易度と違う(そのままコピー)
															if GetRSParameter(m_rf_path,rfs.."_"..rfd.."/"..rf_dp[l].."/"..[mb]) ~= "" then
																local tmpot = {};
																local tmpostr = "";
																if #tmpo > 0 then
																	for tmc=1,#tmpo do
																		if tmpo[tmc] ~= "" then
																			tmpot[tmc] = tmpo[tmc];
																			tmpostr = table.concat(tmpot,":");
																		end;
																	end;
																	if #tmpostr ~= "" then
																		rf_t[#rf_t+1] = { "#"..rfs.."_"..rfd.."/"..rf_dp[l].."/"..[mb] , tmpostr };
																	end;
																end;
															end;
														end;
													end;
													table.sort(mb_table,
														function(a, b)
															score1sp = split(":",a[1][2]);
															score2sp = split(":",b[1][2]);
															return score1sp[7] > score2sp[7]
														end
													);
													tableslice(mb_table,5);
												end;
											end;
										end;
										if #rf_t > 0 then
											for k=1,#rf_t do
												rf_str = rf_str..""..rf_t[k][1]..":"..rf_t[k][2]..";\n";
											end;
										end;
										if rf_str ~= "" then
											File.Write( m_rf_path , "#Prof:"..pid_name..";\n#SongDir:"..sdirs[3].."/"..sdirs[4]..";\n"..rf_str );
										end;
										mb_realsaveflag = 0;
									end;
								end;
							end;
						end;
					end;
				end;
			end;
		end;
		if pn then
			setenv("pjcountp"..p,g_judge_t_set_tbl[p]);
		end;
	end;
};

---------------------------------------------------------------------------------------------------------------------------------------
local Tierset = {0,0,0,0};

if graphvisible and tapsource == 1 then
	if (adgraph ~= "Off" and adgraph ~= "nil") then
		local g_l_1p_b = Def.ActorFrame{};
		local g_l_1p_l = Def.ActorFrame{};
		local g_l_1p_g = Def.ActorFrame{};
		local g_l_2p = Def.ActorFrame{};
		local g_l_m = Def.ActorFrame{};
		
		if numpn >= 2 then
			if CAspect() >= 1.6 then
				g_l_2p[#g_l_2p+1] = Def.ActorFrame {
					Def.Sprite{
						Name="target_back";
						OnCommand=cmd(diffusealpha,0;zoomy,10;addy,-40;sleep,0.2;linear,0.4;diffusealpha,1;zoomy,1;addy,40;);
						YSetCommand=cmd(finishtweening;decelerate,0.15;y,graph2ptargetbacky;);
					};
					LoadFont("_ul")..{
						Name="migs";
						OnCommand=cmd(settext,MIGS..":\n"..migsadhoc;diffusealpha,0;addy,200;
									sleep,0.2;decelerate,0.4;diffusealpha,1;addy,-200;);
						UpSetCommand=function(self)
							self:stoptweening();
							self:diffuse(Color("White"));
							migsnum = MIGS - cmigsadhoc;
							MESSAGEMAN:Broadcast("MIGSSet",{Player = pn,Migs = migsnum});
							if migsnum > 0 then
								migsnum = "+"..migsnum;
								self:diffuse(Colors.Count["Plus"]);
							elseif migsnum == 0 then self:diffuse(Color("White"));
							elseif migsnum < 0 then self:diffuse(Colors.Count["Minus"]);
							end;
							self:settext(MIGS..":\n"..migsnum);
						end;
						YSetCommand=cmd(finishtweening;decelerate,0.15;y,graph2psety;);
					};
					LoadFont("_Shared2")..{
						Name="target_text";
						OnCommand=cmd(diffusealpha,0;addy,200;sleep,0.2;decelerate,0.4;diffusealpha,1;addy,-200;);
						YSetCommand=cmd(finishtweening;decelerate,0.15;y,graph2ptergettexty;);
					};
					InitCommand=function(self)
						local target_back = self:GetChild('target_back');
						local migs = self:GetChild('migs');
						local target_text = self:GetChild('target_text');
						self:x(SCREEN_CENTER_X);
						
						if pn == PLAYER_1 then
							target_back:x(-26);
							migs:x(-4);
							target_text:x(-4);
						else
							target_back:x(26);
							migs:x(48);
							target_text:x(48);
						end;
						target_back:Load(THEME:GetPathB("ScreenGameplay","underlay/target_back_2players_p"..p));
						target_back:y(graph2ptargetbacky);
						(cmd(y,graph2psety;zoom,0.45;maxwidth,100;shadowlength,0;horizalign,right))(migs);
						(cmd(y,graph2ptergettexty;zoom,0.45;maxwidth,100;shadowlength,0;horizalign,right;strokecolor,Color("Black")))(target_text);
						target_text:settext(settargettext(adtype,adgraph));
					end;
					TSetMessageCommand=function(self)
						local migs = self:GetChild('migs');
						if getenv("fcplayercheck_p"..p) == 0 then
							migs:queuecommand("UpSet");
						end;
					end;
					OffCommand=function(self)
						MESSAGEMAN:Broadcast("TSet");
					end;
				};
			else
				--20160703
				g_l_2p[#g_l_2p+1] = Def.ActorFrame {
					Name="migs";
					UpSetCommand=function(self)
						migsnum = MIGS - cmigsadhoc;
						MESSAGEMAN:Broadcast("MIGSSet",{Player = pn,Migs = migsnum});
					end;
					TSetMessageCommand=function(self)
						if getenv("fcplayercheck_p"..p) == 0 then
							self:queuecommand("UpSet");
						end;
					end;
					OffCommand=function(self)
						MESSAGEMAN:Broadcast("TSet");
					end;
				};
			end;
		else
		--if string.find(st:GetStyleType(),"OneSide") then
			g_l_1p_b[#g_l_1p_b+1] = Def.ActorFrame{
				OnCommand=cmd(finishtweening;diffusealpha,0;addx,setaddx;sleep,0.2;decelerate,0.4;diffusealpha,1;addx,afteraddx;);
				XSetCommand=cmd(finishtweening;decelerate,0.15;x,setx;);
				LoadActor("tiergraph_back_"..imageloadnum)..{
					Name="tiergraph_back";
				};
				LoadActor("tiergraph_up_"..ToEnumShortString(pn).."_"..imageloadnum)..{
					Name="tiergraph_up";
				};
				
				LoadFont("_cml")..{
					Name="maxexscore";
					OnCommand=cmd(stoptweening;settext,migsadhoc;);
				};
				LoadFont("_cml")..{
					Name="exscore";
					--SetCommand=cmd(stoptweening;settext,jscc.." : "..ctcsteps;);
					OnCommand=cmd(stoptweening;settext,MIGS;);
					TSetMessageCommand=cmd(stoptweening;settext,MIGS;);
				};
				LoadActor("tiergraph_max_"..ToEnumShortString(pn).."_"..imageloadnum)..{
					Name="tiergraph_max";
				};
			--targetgraphtext
				LoadFont("_Shared2")..{
					Name="targetgraphtext";
				};
				--[ja] 暫定グレード
				LoadFont("_um")..{
					Name="temp_grade";
					OnCommand=function(self)
						self:settext(THEME:GetString("Grade","Tier01"));
						self:diffuse(Colors.Grade["Tier01"]);
					end;
					TSetMessageCommand=function(self)
						if MIGS / iMIGS_MAX >= PCheck(gset,"Grade_Tier01") then
							temp_grade_set = "Grade_Tier01";
							if gset == "default" then
								if stats["TapNoteScore_W2"] + stats["TapNoteScore_W3"] + stats["TapNoteScore_W4"] + 
								stats["TapNoteScore_W5"] + stats["TapNoteScore_Miss"] + stats["TapNoteScore_CheckpointMiss"] + 
								stats["HoldNoteScore_LetGo"] + stats["TapNoteScore_AvoidMine"] > 0 then
									temp_grade_set = "Grade_Tier02";
									Tierset[1] = 2;
								end;
							end;
						elseif MIGS / iMIGS_MAX >= PCheck(gset,"Grade_Tier02") then temp_grade_set = "Grade_Tier02";
						elseif MIGS / iMIGS_MAX >= PCheck(gset,"Grade_Tier03") then temp_grade_set = "Grade_Tier03";
						elseif MIGS / iMIGS_MAX >= PCheck(gset,"Grade_Tier04") then temp_grade_set = "Grade_Tier04";
						elseif MIGS / iMIGS_MAX >= PCheck(gset,"Grade_Tier05") then temp_grade_set = "Grade_Tier05";
						elseif MIGS / iMIGS_MAX >= PCheck(gset,"Grade_Tier06") then temp_grade_set = "Grade_Tier06";
						else temp_grade_set = "Grade_Tier07";
						end;
						self:settext(THEME:GetString("Grade",ToEnumShortString( temp_grade_set )));
						self:diffuse(Colors.Grade[ToEnumShortString( temp_grade_set )]);
						self:strokecolor(Color("Black"));
					end;
					OffCommand=function(self)
						MESSAGEMAN:Broadcast("TSet");
					end;
				};
				InitCommand=function(self)
					(cmd(x,setx;y,SCREEN_CENTER_Y))(self)
					local tiergraph_back = self:GetChild('tiergraph_back');
					local tiergraph_up = self:GetChild('tiergraph_up');
					local maxexscore = self:GetChild('maxexscore');
					local exscore = self:GetChild('exscore');
					local tiergraph_max = self:GetChild('tiergraph_max');
					local targetgraphtext = self:GetChild('targetgraphtext');
					local temp_grade = self:GetChild('temp_grade');
					temp_grade:settext(THEME:GetString("Grade","Tier01"));
					
					maxexscore:maxwidth(100);
					exscore:maxwidth(100);
					tiergraph_max:horizalign(right);
					if adtype ~= "SM" then
						tiergraph_max:visible(true);
					else tiergraph_max:visible(false);
					end;
					if getenv("rnd_song") == 0 then
						targetgraphtext:settext(settargettext(adtype,adgraph));
					end;
					if asstcheck then
						temp_grade:y(-132-26);
						maxexscore:y(-132+26);
						exscore:y(-136-2);
						tiergraph_max:y(-113.5+28);
						targetgraphtext:y(162);
						if pn == PLAYER_1 then
							(cmd(x,-37;zoomx,1))(tiergraph_back);
							tiergraph_up:x(-37);
							temp_grade:x(-53);
							maxexscore:x(-54);
							exscore:x(-54);
							tiergraph_max:x(0);
							targetgraphtext:x(-30);
						else
							(cmd(x,32;zoomx,-1))(tiergraph_back);
							tiergraph_up:x(32);
							temp_grade:x(4);
							maxexscore:x(4);
							exscore:x(4);
							tiergraph_max:x(58);
							--[ja] 20160303修正
							targetgraphtext:x(26);
						end;
					else
						temp_grade:y(-132-26);
						maxexscore:y(-132);
						exscore:y(-136-11);
						tiergraph_max:x(54);
						tiergraph_max:y(-113.5-6);
						targetgraphtext:y(124);
						if pn == PLAYER_1 then
							(cmd(x,14;zoomx,1))(tiergraph_back);
							tiergraph_up:x(14);
							temp_grade:x(-48);
							maxexscore:x(-48);
							exscore:x(-48);
							targetgraphtext:x(29.5);
						else
							(cmd(x,-18;zoomx,-1))(tiergraph_back);
							tiergraph_up:x(-18);
							temp_grade:x(0);
							maxexscore:x(0);
							exscore:x(0);
							targetgraphtext:x(-33.5);
						end;
					end;
					(cmd(stoptweening;horizalign,left;zoom,0.525))(temp_grade);
					(cmd(strokecolor,Color("Black");horizalign,left;zoom,0.45;shadowlength,0))(maxexscore);
					(cmd(strokecolor,Color("Black");horizalign,left;zoom,0.45;shadowlength,0))(exscore);
					(cmd(zoom,0.45;maxwidth,116;shadowlength,0;diffusealpha,1;strokecolor,Color("Black")))(targetgraphtext);
				end;
			};

		--tiergraph_target_line
			for i = 1, 4 do
				local Tiernum = THEME:GetMetric("PlayerStageStats","GradePercentCSTier0"..i);
				if adtype == "SM" then Tiernum = THEME:GetMetric("PlayerStageStats","GradePercentTier0"..i);
				end;

				g_l_1p_l[#g_l_1p_l+1] = Def.ActorFrame{
					Name="t_line"..i;
					InitCommand=function(self)
						self:visible(true);
						self:x(setx);
						self:y(SCREEN_CENTER_Y-116.5);
						(cmd(finishtweening;diffusealpha,0;addx,setaddx;sleep,0.2;decelerate,0.4;diffusealpha,1;addx,afteraddx;))(self)
					end;
					XSetCommand=cmd(x,setx;);
					Def.ActorFrame{
						InitCommand=function(self)
							if asstcheck then
								if pn == PLAYER_2 then
									self:x(57);
								end;
								self:addy(graphheight * (1-Tiernum)+35);
							else
								self:x(53);
								self:addy(graphheight * (1-Tiernum)+1);
							end;
						end;
						Def.Quad{
							Name="line";
							InitCommand=function(self)
								self:visible(true);
								if adtype == "SM" and i == 1 then
									self:visible(false);
								end;
							end;
							OnCommand=function(self)
								(cmd(horizalign,right;zoomtoheight,1.05;))(self)
								self:diffuse(ColorDarkTone(color("0.75,0.75,0.75,0.75")));
								if asstcheck then
									self:zoomtowidth(57);
									if pn == PLAYER_1 then
										self:x(-3);
									else self:x(-2);
									end;
								else self:zoomtowidth(110);
								end;
							end;
							UpSetCommand=function(self)
								if pn == PLAYER_1 then
									self:diffuserightedge(color("1,1,0,1"));
								else self:diffuseleftedge(color("1,1,0,1"));
								end;
							end;
						};
						LoadFont("_shared4")..{
							Name="text";
							InitCommand=function(self)
								self:y(3);
								if adtype == "SM" and i == 1 then
									self:y(-6);
								end;
							end;
							OnCommand=function(self)
								(cmd(settext,THEME:GetString("Grade","Tier0"..i);zoom,0.5;))(self)
								self:diffuse(ColorDarkTone(Color("White")));
								self:strokecolor(Color("Black"));
								if asstcheck then
									self:maxwidth(30);
									if pn == PLAYER_1 then
										self:horizalign(left);
										self:x(-18);
									else
										self:horizalign(right);
										self:x(-44);
									end;
								else
									self:maxwidth(72);
									if pn == PLAYER_1 then
										self:horizalign(left);
										self:x(-27);
									else
										self:horizalign(right);
										self:x(-81);
									end;
								end;
							end;
							UpSetCommand=function(self)
								self:diffuse(Colors.Grade["Tier0"..i]);
								self:diffuse(BoostColor(Colors.Grade["Tier0"..i],1.4));
								self:strokecolor(ColorDarkTone(Colors.Grade["Tier0"..i]));
								Tierset[i] = 1;
							end;
						};
						TSetMessageCommand=function(self)
							local t_line = self:GetChild('line');
							local t_text = self:GetChild('text');
							self:stoptweening();
							local c_set = true;
							if cscoregraphheight >= math.ceil(graphheight * Tiernum) and Tierset[i] == 0 then
								t_line:queuecommand("UpSet");
								t_text:queuecommand("UpSet");
							end;
						end;
						OffCommand=function(self)
							MESSAGEMAN:Broadcast("TSet");
						end;
					};
				};
			end;

		--graph
			local nextTiernum = 4;
			g_l_1p_g[#g_l_1p_g+1] = Def.ActorFrame{
				OnCommand=cmd(finishtweening;visible,true;diffusealpha,0;addx,setaddx;sleep,0.2;decelerate,0.4;diffusealpha,1;addx,afteraddx;);
				XSetCommand=cmd(finishtweening;decelerate,0.15;x,setx;);
				--[ja] user進捗
				Def.Quad{
					Name="t_user";
					UpSetCommand=cmd(stoptweening;zoomtoheight,cscoregraphheight);
				};
				Def.Quad{
					Name="t_user_w";
					UpSetCommand=cmd(finishtweening;zoomtoheight,cscoregraphheight;diffuse,color("1,1,1,0.75");linear,1;diffusealpha,0;);
				};
				--[ja] target最終
				Def.Quad{
					Name="t_max";
					OnCommand=function(self)
						local height = ccheckheight * graphheight;
						if ccheckheight < 0 then height = 0;
						elseif ccheckheight > graphheight then height = graphheight;
						end;
						(cmd(zoomtoheight,height+1;))(self)
					end;
				};
				--[ja] target進捗
				Def.Quad{
					Name="t_current";
					UpSetCommand=cmd(stoptweening;zoomtoheight,targetcoregraphheight;);
				};
			
				Def.ActorFrame{
					Name="terget";
					--InitCommand=cmd(visible,true;x,setx;y,SCREEN_BOTTOM-146;shadowlength,0);
					OnCommand=cmd(diffusealpha,0;addy,200;sleep,0.2;decelerate,0.4;diffusealpha,1;addy,-200;);
					UpSetCommand=function(self)
						self:stoptweening();
						self:diffuse(Color("White"));
						migsnum = MIGS - cmigsadhoc;
						MESSAGEMAN:Broadcast("MIGSSet",{Player = pn,Migs = migsnum});
						if migsnum > 0 then self:diffuse(Colors.Count["Plus"]);
						elseif migsnum == 0 then self:diffuse(Color("White"));
						elseif migsnum < 0 then self:diffuse(Colors.Count["Minus"]);
						end;
					end;
					LoadFont("_ul")..{
						Name="text";
					};
					LoadFont("_ul")..{
						Name="migs";
						UpSetCommand=function(self)
							self:stoptweening();
							if migsnum > 0 then
								migsnum = "+"..MIGS - cmigsadhoc;
							end;
							self:settext(migsnum);
						end;
					};
				};
				
				InitCommand=function(self)
					local t_user = self:GetChild('t_user');
					local t_max = self:GetChild('t_max');
					local t_current = self:GetChild('t_current');
					local t_user_w = self:GetChild('t_user_w');
					
					local terget = self:GetChild('terget');
					local text = terget:GetChild('text');
					local migs = terget:GetChild('migs');
					self:x(setx);
					
					terget:y(SCREEN_BOTTOM-146);
					text:settext("TARGET:");
					migs:settext(MIGS);
					if asstcheck then
						t_user:y(SCREEN_CENTER_Y+138);
						t_user_w:y(SCREEN_CENTER_Y+138);
						t_max:y(SCREEN_CENTER_Y+138);
						t_current:y(SCREEN_CENTER_Y+138);
						text:y(29);
						migs:y(26+13);
						if pn == PLAYER_1 then
							t_user:x(-50);
							t_user_w:x(-50);
							t_max:x(-33);
							t_current:x(-33);
							text:x(-6);
							migs:x(-6);
						else
							t_user:x(26);
							t_user_w:x(26);
							t_max:x(44);
							t_current:x(44);
							text:x(48);
							migs:x(48);
						end;
					else
						t_user:y(SCREEN_CENTER_Y+103);
						t_user_w:y(SCREEN_CENTER_Y+103);
						t_max:y(SCREEN_CENTER_Y+103);
						t_current:y(SCREEN_CENTER_Y+103);
						t_max:x(-4);
						t_current:x(-4);
						text:y(-7);
						migs:y(3);
						if pn == PLAYER_1 then
							t_user:x(-38);
							t_user_w:x(-38);
							text:x(52);
							migs:x(52);
						else
							t_user:x(30);
							t_user_w:x(30);
							text:x(-6);
							migs:x(-6);
						end;
					end;

					(cmd(zoomx,graphwidth;vertalign,bottom;diffusealpha,0;))(t_user_w);
					(cmd(zoomx,graphwidth;zoomy,cscoregraphheight;vertalign,bottom;
					diffuse,color("0,1,1,0.8");diffusebottomedge,color("0,1,1,0.3")))(t_user);
					(cmd(zoomx,graphwidth+2;zoomy,0.01;vertalign,bottom;
					diffuse,color("0.7,0.7,0.7,0.8");diffusebottomedge,color("0.3,0.3,0.3,0.3")))(t_max);
					(cmd(zoomx,graphwidth;zoomy,targetcoregraphheight;vertalign,bottom;
					diffuse,color("1,0.5,0,0.8");diffusebottomedge,color("1,0.5,0,0.3")))(t_current);
					
					(cmd(shadowlength,0))(terget);
					(cmd(strokecolor,Color("Black");horizalign,right;maxwidth,100;shadowlength,0;zoom,0.45))(text);
					(cmd(strokecolor,Color("Black");horizalign,right;maxwidth,120;shadowlength,0;zoom,0.45))(migs);
				end;
				TSetMessageCommand=function(self)
					local t_user = self:GetChild('t_user');
					local t_current = self:GetChild('t_current');
					local terget = self:GetChild('terget');
					local t_user_w = self:GetChild('t_user_w');
					if getenv("fcplayercheck_p"..p) == 0 then
						t_user:queuecommand("UpSet");
						t_current:queuecommand("UpSet");
						terget:queuecommand("UpSet");
						local up_check = false;
						if nextTiernum > 0 then
							local nextTier = THEME:GetMetric("PlayerStageStats","GradePercentCSTier0"..nextTiernum);
							if cscoregraphheight >= math.ceil(graphheight * nextTier) and Tierset[nextTiernum] == 0 then
								nextTiernum = nextTiernum - 1;
								up_check = true;
							end;
						end;
						if up_check then
							t_user_w:queuecommand("UpSet");
						end;
					end;
				end;
				OffCommand=function(self)
					MESSAGEMAN:Broadcast("TSet");
				end;
			};
		--cst
		--end;
		end;

		t[#t+1] = g_l_1p_b;
		t[#t+1] = g_l_1p_l;
		t[#t+1] = g_l_1p_g;
		t[#t+1] = g_l_2p;
	end;
--adgraph
end;

if judgetvisible then
	--judge table
	t[#t+1] = Def.Sprite{
		InitCommand=function(self)
			if numpn >= 2 then
				if CAspect() < 1.6 then
					self:visible(false);
				else
					self:visible(true);
					self:Load(THEME:GetPathB("ScreenGameplay","underlay/judge_back_2players_p"..p));
					if pn == PLAYER_1 then
						self:x(SCREEN_CENTER_X-26);
					else self:x(SCREEN_CENTER_X+26);
					end;
				end;
			else
				self:visible(true);
				self:x(jtablesetx+6);
				self:Load(THEME:GetPathB("ScreenGameplay","underlay/judge_back_default"));
				if pn == PLAYER_2 then
					self:x(jtablesetx-6);
					if asstcheck then
						self:Load(THEME:GetPathB("ScreenGameplay","underlay/judge_back_p2_8"));
					end;
				end;
			end;
			self:y(jtablesety-9);

		end;
		OnCommand=cmd(diffusealpha,0;zoomy,10;addy,-40;sleep,0.2;linear,0.4;diffusealpha,1;zoomy,1;addy,40;);
		XSetCommand=cmd(finishtweening;decelerate,0.15;x,pn == PLAYER_1 and jtablesetx+6 or jtablesetx-6;);
		YSetCommand=cmd(finishtweening;decelerate,0.15;y,jtablesety-9;);
	};

	for idx, cat in pairs(statsCategoryValues) do
		local statsCategory = cat.Category;
		local statsColor = cat.Color;
		local statsText = cat.Text;

	--[ja] 判定数
		t[#t+1] = Def.ActorFrame{
			InitCommand=function(self)
				if CAspect() < 1.6 then
					if numpn >= 2 then
						self:visible(false);
					else
						self:visible(true);
						self:x(jtablesetx);
						if numpn >= 2 then
							self:x(SCREEN_CENTER_X);
						end;
					end;
				else
					self:visible(true);
					self:x(jtablesetx);
					if numpn >= 2 then
						self:x(SCREEN_CENTER_X);
					end;
				end;
				self:y(jtablesety-46);
			end;
			OnCommand=cmd(diffusealpha,0;addy,200;sleep,0.2;decelerate,0.4;diffusealpha,1;addy,-200;);
			XSetCommand=cmd(finishtweening;decelerate,0.15;x,jtablesetx;);
			YSetCommand=cmd(finishtweening;decelerate,0.15;y,jtablesety-46;);

			LoadFont("_ul")..{
				InitCommand=function(self)
					if numpn >= 2 then
						self:visible(false);
					else
						self:visible(true);
						self:x(-12);
						if pn == PLAYER_2 then self:x(-24);
						end;
						self:y(5+math.abs(idx*10));
						self:diffuse(statsColor);
						if asstcheck then
							self:x(6);
							if pn == PLAYER_2 then self:x(-24);
							end;
						end;
						(cmd(strokecolor,Color("Black");zoom,0.45;shadowlength,0;diffusealpha,1;horizalign,right;maxwidth,38;settext,statsText..":"))(self)
					end;
				end;
			};

			LoadFont("_cml")..{
				InitCommand=function(self)
					self:visible(true);
					self:y(2+math.abs(idx*10));
					self:settext( 0 );
					self:maxwidth(120);
					if numpn >= 2 then
						self:diffuse(statsColor);
						if pn == PLAYER_1 then
							self:x(-4);
						else self:x(48);
						end;
					else
						self:diffuse(Color("White"));
						if asstcheck then
							self:maxwidth(80);
							self:x(40);
							if pn == PLAYER_2 then self:x(9);
							end;
						else
							self:x(40);
							if pn == PLAYER_2 then self:x(28);
							end;
						end;
					end;
					(cmd(strokecolor,Color("Black");zoom,0.45;zoomx,0.4;shadowlength,0;diffusealpha,1;horizalign,right;))(self)
				end;
				TSetMessageCommand=function(self)
					self:stoptweening();
					self:settext(stats[statsCategory]);
				end;
				OffCommand=function(self)
					MESSAGEMAN:Broadcast("TSet");
				end;
			};
		};
	end;
end;

t.CurrentSongChangedMessageCommand=function(self)
	self:playcommand("Set");
end;

--20160629
t.CodeMessageCommand=function(self,params)
	if params.PlayerNumber == pn then
		if numpn == 1 then
			if params.Name == "GraphRight" then
				if ctable[1] == 1 and ctable[2] == 1 then
					if pn == PLAYER_1 then
						setx = SCREEN_RIGHT-WideScale(66,72);
						if (adgraph ~= "Off" and adgraph ~= "nil") then
							jtablesetx = GetPosition(pn)+cc_fz+stsetx;
							graphdistance = "Far";
						end;
					else
						setx = GetPosition(pn)-cc_fz-stsetx;
						if (adgraph ~= "Off" and adgraph ~= "nil") then
							jtablesetx = GetPosition(pn)-cc_fz-stsetx-120;
							graphdistance = "Near";
						end;
					end;
				else
					if ctable[2] == 1 then
						if pn == PLAYER_1 then
							setx = SCREEN_RIGHT-WideScale(66,72);
							graphdistance = "Far";
						else
							setx = GetPosition(pn)-cc_fz-stsetx;
							graphdistance = "Near";
						end;
					end;
					if ctable[1] == 1 then
						if pn == PLAYER_1 then
							jtablesetx = SCREEN_RIGHT-WideScale(66,72);
							graphdistance = "Far";
						else
							jtablesetx = GetPosition(pn)-cc_fz-stsetx;
							graphdistance = "Near";
						end;
					end;
				end;
				self:playcommand("XSet");
				setenv("graphdistance"..pstr,graphdistance);
			elseif params.Name == "GraphLeft" then
				if ctable[1] == 1 and ctable[2] == 1 then
					if pn == PLAYER_1 then
						setx = GetPosition(pn)+cc_fz+stsetx;
						if (adgraph ~= "Off" and adgraph ~= "nil") then
							jtablesetx = GetPosition(pn)+cc_fz+stsetx+120;
							graphdistance = "Near";
						end;
					else
						setx = SCREEN_LEFT+WideScale(66,72);
						if (adgraph ~= "Off" and adgraph ~= "nil") then
							jtablesetx = GetPosition(pn)-cc_fz-stsetx;
							graphdistance = "Far";
						end;
					end;
				else
					if ctable[2] == 1 then
						if pn == PLAYER_1 then
							setx = GetPosition(pn)+cc_fz+stsetx;
							graphdistance = "Near";
						else
							setx = SCREEN_LEFT+WideScale(66,72);
							graphdistance = "Far";
						end;
					end;
					if ctable[1] == 1 then
						if pn == PLAYER_1 then
							jtablesetx = GetPosition(pn)+cc_fz+stsetx;
							graphdistance = "Near";
						else
							jtablesetx = SCREEN_LEFT+WideScale(66,72);
							graphdistance = "Far";
						end;
					end;
				end;
				self:playcommand("XSet");
				setenv("graphdistance"..pstr,graphdistance);
			end;
			if judgetvisible then
				if params.Name == "ScrollNomal" or params.Name == "ScrollNomal2" then
					jtablesety = SCREEN_TOP+140;
					self:playcommand("YSet");
				elseif params.Name == "ScrollReverse" or params.Name == "ScrollReverse2" then
					jtablesety = SCREEN_BOTTOM-140;
					self:playcommand("YSet");
				end;
			end;
		else
			if CAspect() >= 1.6 then
				if params.Name == "ScrollNomal" or params.Name == "ScrollNomal2" then
					jtablesety = SCREEN_TOP+140;
					if judgetvisible then
						if (adgraph ~= "Off" and adgraph ~= "nil") then
							graph2psety = SCREEN_TOP+190+4;
							graph2ptergettexty = SCREEN_TOP+190+19;
							graph2ptargetbacky = SCREEN_TOP+202;
						end;
					else
						graph2psety = SCREEN_TOP+100+4;
						graph2ptergettexty = SCREEN_TOP+100+19;
						graph2ptargetbacky = SCREEN_TOP+112;
					end;
					self:playcommand("YSet");
				elseif params.Name == "ScrollReverse" or params.Name == "ScrollReverse2" then
					jtablesety = SCREEN_BOTTOM-140;
					if judgetvisible then
						if (adgraph ~= "Off" and adgraph ~= "nil") then
							graph2psety = SCREEN_BOTTOM-224+4;
							graph2ptergettexty = SCREEN_BOTTOM-214-28;
							graph2ptargetbacky = SCREEN_BOTTOM-224;
						end;
					else
						graph2psety = SCREEN_BOTTOM-130+4;
						graph2ptergettexty = SCREEN_BOTTOM-148;
						graph2ptargetbacky = SCREEN_BOTTOM-130;
					end;
					self:playcommand("YSet");
				end;
			end;
		end;
		--SCREENMAN:SystemMessage(ctable[1].." : "..ctable[2].." : "..graphdistance.." : "..params.Name);
	end;
end;

return t;