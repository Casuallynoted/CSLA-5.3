--[[rival_display]]
--[ja] 20150909 判定テーブルも表示できるように修正

local pn = ...
assert(pn,"Must pass in a player, dingus");

local p_count_check = false;
if #GAMESTATE:GetHumanPlayers() > 1 then
	p_count_check = true;
end;

local cs_hs = {};
local sm_hs = {};

local rfc_hs = {
	'ntype',
	'default'
};
local rf_dp = {
	'CS',
	'SM'
};
setmetatable( rfc_hs, { __index = function() return 'ntype' end; } );
setmetatable( rf_dp, { __index = function() return 'CS' end; } );

local judgewidth = 192;
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

local SorCTime = 0;
local hsfcheck = 5;

local hs = {};
hs_local_set(hs,0);
hs["Assist"] = false;

local bs = {};
hs_local_set(bs,0);
bs["Assist"] = false;

local bsfcheck = 5;

local low_pic_d = "GradeLowPic/GradeDisplayEval";
local p = ( (pn == "PlayerNumber_P1") and 1 or 2 );
local pstr = ProfIDSet(p);
local gset = judge_initial(pstr);
local adgraph = ProfIDPrefCheck("ScoreGraph",pstr,"Off");
local adtype = ProfIDPrefCheck("GraphType",pstr,"CS");
local ad_t_table = {CS = "ntype",SM = "default"};
local st = GAMESTATE:GetCurrentStyle();
local pm = GAMESTATE:GetPlayMode();
local ssStats = STATSMAN:GetCurStageStats();
local psStats = STATSMAN:GetPlayedStageStats(1);
local pnstats = ssStats:GetPlayerStageStats(pn);
local failed = pnstats:GetFailed();

local profile;
local pid_name;
local scorelist;
local scores;
local topscore;
local assist;
local snum = 1;

local xset = {-30,30};

local SorCDir;
local stepseconds = 0;
local aliveseconds = 0;
local height = 44;
local cpn = {1,1};
local rank_update = {1,1};
local r_rcolor = {"0,0,0,0.75","0.5,0.5,0,0.75"};
local sttype;
local bIsCourseMode = GAMESTATE:IsCourseMode();

local coursetype = true;
local SongOrCourse = CurSOSet();
local StepsOrTrail = CurSTSet(pn);
steps_count(hs,SongOrCourse,StepsOrTrail,pn,"Course");
if bIsCourseMode then
	local co_stage = SongOrCourse:GetEstimatedNumStages();
	local stindex = getenv("coursestindex");
	if stindex >= co_stage then
		stepseconds = stindex;
	else
		stepseconds = stindex + 10;
	end;
	if SongOrCourse:IsAutogen() then
		coursetype = false;
	end;
	if SongOrCourse:GetCourseType() == 'CourseType_Endless' or SongOrCourse:GetCourseType() == 'CourseType_Survival' then
		coursetype = false;
	else
		songdir = SongOrCourse:GetCourseDir();
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

--20160504
if SongOrCourse and StepsOrTrail then
	if bIsCourseMode then
		sttype = GAMESTATE:GetCurrentStyle():GetStepsType();
		SorCTime = courselength(SongOrCourse,GAMESTATE:GetCurrentTrail(pn),sttype);
	else SorCTime = SongOrCourse:GetLastSecond();
	end;
	--SCREENMAN:SystemMessage(SorCTime);
end;

if coursetype then
	sdirs = split("/",songdir);
	if sdirs and sdirs[2] then
		sdirs[2] = additionaldir_to_songdir(sdirs[2]);
	end;
end;

local t = Def.ActorFrame{
	Name="EvaluationRivalDisplay"..pn;
	OnCommand=function(self)
		self:visible(GAMESTATE:IsHumanPlayer(pn));
	end;
	PlayerJoinedMessageCommand=function(self,param)
		if param.Player == pn then
			self:visible(coursetype);
		end;
	end;
	PlayerUnjoinedMessageCommand=function(self,param)
		if param.Player == pn then
			self:visible(false);
		end;
	end;
};

if PROFILEMAN:ProfileWasLoadedFromMemoryCard(pn) then
	coursetype = false;
end;

if not coursetype then return t;
end;
---------------------------------------------------------------------------------------------------------------------------------------
-- [ja] 今回のスコア
if pnstats then
	local modstr = GAMESTATE:GetPlayerState(pn):GetPlayerOptionsString("ModsLevel_Preferred");
	hs_set(hs,pnstats,"pnstats");
	hs["SurvivalSeconds"]			= pnstats:GetSurvivalSeconds();
	hs["Assist"]					= assistchecker(pn,modstr);
	if bIsCourseMode then
		hs["SurvivalSeconds"]		= SorCTime + 1;
	end;
	hsfcheck = fullcombochecker(hs,SorCTime);
end;

if failed then hs["Grade"] = "Grade_Failed"
end;
local rv_table;

if SongOrCourse and StepsOrTrail then
	if PROFILEMAN:IsPersistentProfile(pn) then
		profile = PROFILEMAN:GetProfile(pn);
		pid_name = profile:GetGUID().."_"..profile:GetDisplayName();
		if #rival_table(pstr,profile,"") > 0 then
			rv_table = rival_table(pstr,profile,pid_name);
		end;
		scorelist = profile:GetHighScoreList(SongOrCourse,StepsOrTrail);
		assert(scorelist);
		scores = scorelist:GetHighScores();
		topscore = scores[1];
		if topscore and #scores > 1 then
			if topscore:GetPercentDP() == pnstats:GetPercentDancePoints() then
				snum = snum + 1;
			end;
			snum = snum_set(snum,scores,pn);
			if snum > 0 then
				topscore = scores[snum];
				if topscore then
					hs_set(bs,topscore,"normal");
					bs["TotalSteps"]			= hs["TotalSteps"];
					bs["RadarCategory_Holds"]		= hs["RadarCategory_Holds"];
					bs["RadarCategory_Rolls"]		= hs["RadarCategory_Rolls"];
					bs["MaxCombo"]			= topscore:GetMaxCombo();
					bs["SurvivalSeconds"]		= topscore:GetSurvivalSeconds();
					bs["Assist"]				= assistchecker(pn,topscore:GetModifiers());
					if bIsCourseMode then
						bs["SurvivalSeconds"]	= SorCTime + 1;
					end;
					bsfcheck = fullcombochecker(bs,SorCTime);
				end;
			end;
		end;
	end;
end;

if not rv_table then return t;
end;

---------------------------------------------------------------------------------------------------------------------------------------
cs_hs = {};
sm_hs = {};
sttype = GAMESTATE:GetCurrentStyle():GetStepsType();
if SongOrCourse and StepsOrTrail then
	if coursetype then
		for r=1,#rv_table do
			local tmpo = "";
			local tmpogs = {"Grade_Tier22",5};
			local tmpojs = {0,0,0,0,0,0,0,0};
			local tmpolts = {0,0};
			local cr_path = "";
			local pcolor;
			local rcolor;
			local setgrade = "Grade_None";
			local jtt_set = "c_sc";
			local jtset;
			local bcheck = false;
			if r == 1 then
				jtset = "";
				cr_path = "CSRealScore/"..pid_name.."/"..sdirs[2].."/"..sdirs[3].."/"..sdirs[4].."/set_"..wpsetd.."_"..swpsetd;
				for rf=1,#rf_dp do
					local MIGS = 0;
					local fcheck = hsfcheck;
					if hs["Assist"] == true then
						hsfcheck = 9;
					end;
					local swset = {
						TapNoteScore_W1	= 0,
						TapNoteScore_W2	= 0,
						TapNoteScore_W3	= 0,
						TapNoteScore_W4	= 0,
						TapNoteScore_W5	= 0,
						TapNoteScore_Miss	= 0,
						HoldNoteScore_Held	= 0,
						HoldNoteScore_LetGo	= 0
					};
					pcolor = "1,1,1";
					rcolor = {"0,0,0,0.75","0,1,1,0.75"};
					hs["Grade"] = gradechecker(hs,pnstats:GetGrade(),SorCTime,rfc_hs[rf],hsfcheck);
					setgrade = hs["Grade"];
					MIGS = migschecker(hs,rfc_hs[rf]);
					swset = {
						TapNoteScore_W1	= hs["TapNoteScore_W1"],
						TapNoteScore_W2	= hs["TapNoteScore_W2"],
						TapNoteScore_W3	= hs["TapNoteScore_W3"],
						TapNoteScore_W4	= hs["TapNoteScore_W4"],
						TapNoteScore_W5	= hs["TapNoteScore_W5"],
						TapNoteScore_Miss	= hs["TapNoteScore_Miss"],
						HoldNoteScore_Held	= hs["HoldNoteScore_Held"],
						HoldNoteScore_LetGo	= hs["HoldNoteScore_LetGo"]
					};
					if topscore then
						--if rf == 1 then SCREENMAN:SystemMessage(bs["Grade"]);
						--end;
						--[ja] 20150909修正
						bs["Grade"] = gradechecker(bs,topscore:GetGrade(),SorCTime,rfc_hs[rf],bsfcheck);
						if migschecker(bs,rfc_hs[rf]) > migschecker(hs,rfc_hs[rf]) then
							MIGS = migschecker(bs,rfc_hs[rf]);
							swset = {
								TapNoteScore_W1	= bs["TapNoteScore_W1"],
								TapNoteScore_W2	= bs["TapNoteScore_W2"],
								TapNoteScore_W3	= bs["TapNoteScore_W3"],
								TapNoteScore_W4	= bs["TapNoteScore_W4"],
								TapNoteScore_W5	= bs["TapNoteScore_W5"],
								TapNoteScore_Miss	= bs["TapNoteScore_Miss"],
								HoldNoteScore_Held	= bs["HoldNoteScore_Held"],
								HoldNoteScore_LetGo	= bs["HoldNoteScore_LetGo"]
							};
						end;
						--[ja] 20151002修正
						if (hs["Grade"] == "Grade_Failed" or hs["Grade"] == "Grade_None") and 
						bs["Grade"] ~= "Grade_None" then
							--[ja] ハイスコアがNone以外で今回のスコアがFailedまたはNoneの時はハイスコアを返す
							bcheck = true;
						else
							--[ja] それ以外の時は比べる
							if hs["Grade"] ~= "Grade_Failed" and hs["Grade"] ~= "Grade_None" and
							bs["Grade"] ~= "Grade_Failed" and bs["Grade"] ~= "Grade_None" then
								if tonumber(string.sub(bs["Grade"],-2)) and tonumber(string.sub(hs["Grade"],-2)) then
									if tonumber(string.sub(bs["Grade"],-2)) < tonumber(string.sub(hs["Grade"],-2)) then
										--[ja] 比べてベストスコアが勝っている時
										bcheck = true;
									end;
								end;
							end;
						end;
						if bcheck then
							if bs["Assist"] == true then
								bsfcheck = 9;
							end;
							setgrade = bs["Grade"];
						end;
						--[ja] 20150909修正
						if tonumber(bsfcheck) < tonumber(hsfcheck) then
							fcheck = bsfcheck;
						end;
						if fcheck == 9 then
							pcolor = "0,1,0,1";
						else
							if FILEMAN:DoesFileExist( cr_path ) then
								if GetRSParameter( cr_path,sttype.."_"..ToEnumShortString(StepsOrTrail:GetDifficulty()) .."/"..rf_dp[rf]) ~= "" then
									tmpo = split( ":",GetRSParameter( cr_path,sttype.."_"..ToEnumShortString(StepsOrTrail:GetDifficulty()) .."/"..rf_dp[rf]) );
								end;
								--SCREENMAN:SystemMessage(tostring(bcheck));
								if bcheck or (tmpo[3] and migschecker(bs,rfc_hs[rf]) > migschecker(hs,rfc_hs[rf])) then
									jtt_set = "best_sc";
								end;
							
								if #tmpo >= 6 and tmpo[6] ~= "" then
									tmpolts = split(",",tmpo[6]);
									if tonumber(eachecker(tmpolts)) == 1 then
										pcolor = "1,0.5,0,1";
									elseif tonumber(eachecker(tmpolts)) == 2 then
										pcolor = "0,1,0,1";
									end;
								end;
							end;
						end;
					else pcolor = "1,1,1";
					end;

					if hs["Grade"] == "Grade_None" then		hs["Grade"] = "Grade_Tier22";
					elseif hs["Grade"] == "Grade_Failed" then	hs["Grade"] = "Grade_Tier21";
					end;
					if bs["Grade"] == "Grade_None" then		bs["Grade"] = "Grade_Tier22";
					elseif bs["Grade"] == "Grade_Failed" then	bs["Grade"] = "Grade_Tier21";
					end;
					if setgrade == "Grade_None" then		setgrade = "Grade_Tier22";
					elseif setgrade == "Grade_Failed" then		setgrade = "Grade_Tier21";
					end;
					
					if rf == 1 then
						cs_hs[1] = { 1,pid_name,setgrade.."/"..fcheck,MIGS,
								swset["TapNoteScore_W1"],swset["TapNoteScore_W2"],swset["TapNoteScore_W3"],swset["TapNoteScore_W4"],
								swset["TapNoteScore_W5"],swset["TapNoteScore_Miss"],swset["HoldNoteScore_Held"],swset["HoldNoteScore_LetGo"],pcolor,rcolor,r
						};
						--Trace("cs_hs : "..cs_hs[1][3]);
						if jtt_set == "best_sc" then
							if tmpo[4] then
								jtset = jbox_setting(tmpo[4],hs["TotalSteps"]);
							end;
						else
							if migschecker(bs,rfc_hs[rf]) <= migschecker(hs,rfc_hs[rf]) then
								if getenv("pjcountp"..p) then
									jtset = getenv("pjcountp"..p);
								end;
							end;
						end;
					else
						sm_hs[1] = { 1,pid_name,setgrade.."/"..fcheck,MIGS,
								swset["TapNoteScore_W1"],swset["TapNoteScore_W2"],swset["TapNoteScore_W3"],swset["TapNoteScore_W4"],
								swset["TapNoteScore_W5"],swset["TapNoteScore_Miss"],swset["HoldNoteScore_Held"],swset["HoldNoteScore_LetGo"],pcolor,rcolor,r
						};
					end;
					if jtset and jtset ~= "" then
						if rf == 1 then
							cs_hs[1][#cs_hs[1]+1] = jtset;
						else sm_hs[1][#sm_hs[1]+1] = jtset;
						end;
					end;
				end;
			else
				jtset = "";
				cr_path = "CSRealScore/"..rv_table[r].."/"..sdirs[2].."/"..sdirs[3].."/"..sdirs[4].."/set_"..wpsetd.."_"..swpsetd;
				for rf=1,#rf_dp do
					pcolor = "0.75,0.75,0.75";
					rcolor = {"0,0,0,0.75","0.5,0.25,0,0.75"};
					local checkset = 0;
					if FILEMAN:DoesFileExist( cr_path ) then
						if GetRSParameter( cr_path,sttype.."_"..ToEnumShortString(StepsOrTrail:GetDifficulty()) .."/"..rf_dp[rf]) ~= "" then
							tmpo = split( ":",GetRSParameter( cr_path,sttype.."_"..ToEnumShortString(StepsOrTrail:GetDifficulty()) .."/"..rf_dp[rf]) );
						end;
						if #tmpo >= 3 then
							if tmpo[2] ~= "" and #split("/",tmpo[2]) >= 2 then
								tmpogs = split("/",tmpo[2]);
							end;
							if #tmpo >= 5 and tmpo[5] ~= "" and #split(",",tmpo[5]) >= 6 then
								tmpojs = split(",",tmpo[5]);
							end;
							if tonumber(tmpogs[2]) == 9 then
								pcolor = "0,0.75,0";
							else
								if #tmpo >= 6 and tmpo[6] ~= "" and #split(",",tmpo[6]) >= 2 then
									tmpolts = split(",",tmpo[6]);
									if tonumber(eachecker(tmpolts)) == 1 then
										pcolor = "0.75,0.334,0";
									elseif tonumber(eachecker(tmpolts)) == 2 then
										pcolor = "0,0.75,0";
									end;
								end;
							end;
							if rf == 1 then
								cs_hs[r] = { 1,rv_table[r],tmpogs[1].."/"..tmpogs[2],tmpo[3],
										tmpojs[1],tmpojs[2],tmpojs[3],tmpojs[4],tmpojs[5],tmpojs[6],tmpojs[7],tmpojs[8],pcolor,rcolor,r };
								if tmpo[4] then
									jtset = jbox_setting(tmpo[4],hs["TotalSteps"]);
								end;
							else sm_hs[r] = { 1,rv_table[r],tmpogs[1].."/"..tmpogs[2],tmpo[3],
										tmpojs[1],tmpojs[2],tmpojs[3],tmpojs[4],tmpojs[5],tmpojs[6],tmpojs[7],tmpojs[8],pcolor,rcolor,r };
							end;
							if jtset and jtset ~= "" then
								if rf == 1 then
									cs_hs[1][#cs_hs[1]+1] = jtset;
								else sm_hs[1][#sm_hs[1]+1] = jtset;
								end;
							end;
							checkset = 1;
						end;
					end;
					if checkset == 0 then
						pcolor = "0.35,0.35,0.35";
						if rf == 1 then
							cs_hs[r] = { 1,rv_table[r],"Grade_Tier22/5",0,0,0,0,0,0,0,0,0,pcolor,rcolor,r };
						else sm_hs[r] = { 1,rv_table[r],"Grade_Tier22/5",0,0,0,0,0,0,0,0,0,pcolor,rcolor,r };
						end;
					end;
				end;
			end;
		end;
		local function SortScore(score1,score2)
			local score1sp
			local score2sp
			local grade1
			local grade2
			--[ja] ソート優先度: 1,スコア 2,アシスト 3,グレード 4,フルコンボ
			if tonumber(score1[4]) == tonumber(score2[4]) then
				if (score1[3] ~= nil and score1[3] ~= "") and (score2[3] ~= nil and score2[3] ~= "") then
					score1sp = split("/",score1[3])
					score2sp = split("/",score2[3])
					grade1 = string.sub(score1sp[1],-2)
					grade2 = string.sub(score2sp[1],-2)
					if tonumber(grade1) == tonumber(grade2) then
						if (score1sp[2] ~= nil and score1sp[2] ~= "") and (score2sp[2] ~= nil and score2sp[2] ~= "") then
							if tonumber(score1sp[2]) ~= tonumber(score2sp[2]) then
								return tonumber(score1sp[2]) < tonumber(score2sp[2])
							end
						end
						return tonumber(score1[15]) < tonumber(score2[15])
					else
						if (score1sp[2] ~= nil and score1sp[2] ~= "") and (score2sp[2] ~= nil and score2sp[2] ~= "") then
							if tonumber(score1sp[2]) == 9 or tonumber(score2sp[2]) == 9 then
								return tonumber(score1sp[2]) < tonumber(score2sp[2])
							elseif tonumber(grade1) and tonumber(grade2) then
								return tonumber(grade1) < tonumber(grade2)
							end;
						else return tonumber(score1[15]) < tonumber(score2[15])
						end;
					end
				end
			end
			return tonumber(score1[4]) > tonumber(score2[4])
		end
		table.sort(cs_hs,
			function(a, b)
				return SortScore(a,b)
			end
		);
		table.sort(sm_hs,
			function(a, b)
				return SortScore(a,b)
			end
		);
		local rank = 1;
		for csr=1,#cs_hs do
			if csr == 1 then
				cs_hs[csr][1] = 1;
			else 
				if tonumber(cs_hs[csr-1][4]) > tonumber(cs_hs[csr][4]) then
					rank = csr;
				end;
				cs_hs[csr][1] = rank;
			end;
			if cs_hs[csr][2] == pid_name then
				cpn[1] = csr;
				rank_update[1] = cpn[1];
			end;
		end;
		rank = 1;
		for smr=1,#sm_hs do
			if smr == 1 then
				sm_hs[smr][1] = 1;
			else
				if tonumber(sm_hs[smr-1][4]) > tonumber(sm_hs[smr][4]) then
					rank = smr;
				end;
				sm_hs[smr][1] = rank;
			end;
			if sm_hs[smr][2] == pid_name then
				cpn[2] = smr;
				rank_update[2] = cpn[2];
			end;
		end;
		
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
		end;
	end;
end;

---------------------------------------------------------------------------------------------------------------------------------------
t[#t+1] = LoadActor("evascorelistback")..{
	InitCommand=function(self)
		if coursetype then
			self:visible(true);
		else self:visible(false);
		end;
		local o_set = {20,1,right};
		if p_count_check then
			if pn == PLAYER_2 then
				o_set = {20,1,right};
			else o_set = {-20,-1,left};
			end;
		else
			if pn == PLAYER_2 then
				o_set = {-20,-1,left};
			else o_set = {20,1,right};
			end;
		end;
		(cmd(x,math.min(186,WideScale(170,186)+o_set[1]);y,110;horizalign,o_set[3];zoomx,o_set[2];))(self)
	end;
	OnCommand=function(self)
		local o_set = {xset[2],xset[1]};
		local diffuse = 0.65; 
		if p_count_check then
			diffuse = 0.925; 
			if pn == PLAYER_2 then
				o_set = {xset[2],xset[1]};
			else o_set = {xset[1],xset[2]};
			end;
		else
			if pn == PLAYER_2 then
				o_set = {xset[1],xset[2]};
			else o_set = {xset[2],xset[1]};
			end;
		end;
		(cmd(stoptweening;addx,o_set[1];diffusealpha,0;croptop,1;sleep,0.6;decelerate,0.5;addx,o_set[2];diffusealpha,diffuse;croptop,0;))(self);
	end;
};

t[#t+1] = LoadActor("rdata")..{
	InitCommand=function(self)
		self:x(50);
		self:y(-54);
		if pn == PLAYER_2 then
			self:x(-50);
		end;
	end;
	OnCommand=function(self)
		local o_set = {-6,6};
		if p_count_check then
			if pn == PLAYER_2 then
				o_set = {-6,6};
			else o_set = {6,-6};
			end;
		else
			if pn == PLAYER_2 then
				o_set = {6,-6};
			else o_set = {-6,6};
			end;
		end;
		(cmd(diffusealpha,0;addx,o_set[1];addy,-6;sleep,0.75;linear,0.2;diffusealpha,1;addx,o_set[2];addy,6;))(self)
	end;
};

local coset = {};
local b_xset,m_xset,you_set,t_set,l_set = -40,95,20,12,-20;
local rank_x = {-66,-5,-3};
local state_p = 0;
local jt_set_x = -76;
local rank_horiz = right;
if p_count_check then
	if pn == PLAYER_1 then
		b_xset,m_xset,you_set,t_set,l_set = -40,95,20,12,-60;
		rank_x = {150,5,3};
		jt_set_x = -116;
		state_p = 1;
		rank_horiz = left;
	else 
		b_xset,m_xset,you_set,t_set,l_set = 40,-95,-20,-12,-20;
	end;
else
	if pn == PLAYER_1 then
		b_xset,m_xset,you_set,t_set,l_set = 40,-95,-20,-12,-20;
	else
		b_xset,m_xset,you_set,t_set,l_set = -40,95,20,12,-60;
		rank_x = {150,5,3};
		jt_set_x = -116;
		state_p = 1;
		rank_horiz = left;
	end;
end;

local function edgecolor(self,c)
	if p_count_check then
		if pn == PLAYER_1 then
			self:diffuseleftedge(color(c));
		else self:diffuserightedge(color(c));
		end;
	else
		if pn == PLAYER_1 then
			self:diffuserightedge(color(c));
		else self:diffuseleftedge(color(c));
		end;
	end;
	return self
end;
local function you_sccheck(i,g_gset,cpn,cs_hs,sm_hs,pid)
	if g_gset == "ntype" then
		if cpn[1] == i then
			if cs_hs[cpn[1]] ~= nil and cs_hs[cpn[1]] ~= "" then
				if cs_hs[cpn[1]][2] == pid then
					return true
				end
			end
		end
	else
		if cpn[2] == i then
			if sm_hs[cpn[2]] ~= nil and sm_hs[cpn[2]] ~= "" then
				if sm_hs[cpn[2]][2] == pid then
					return true
				end
			end
		end
	end
	return false
end;

for i=1,#rv_table do
	local hsset = "";
	local hssetcheck = 0;
	coset[i] = 1;
	local sleeptime = i * 0.05
	
	t[#t+1] = Def.ActorFrame{
		InitCommand=function(self)
			if coursetype then
				self:visible(true);
			else self:visible(false);
			end;
			(cmd(x,b_xset;y,30;))(self);
		end;

		LoadActor("t_focus_back")..{
			OnCommand=cmd(animate,false;setstate,0;stoptweening;croptop,1;sleep,1+sleeptime;decelerate,0.15;croptop,0;
						playcommand,"JudgeSetting",{GSet = gset,Player = pn});
			JudgeSettingMessageCommand=function(self,params)
				if params.Player ~= pn then return;
				end;
				if SongOrCourse and StepsOrTrail then
					self:setstate(0);
					self:y(-10+(i-1)*height);
					self:diffuse(color("1,1,1,1"));
					if you_sccheck(i,params.GSet,cpn,cs_hs,sm_hs,pid_name) then
						self:setstate(1);
						self:diffuse(color("0,1,1,0"));
						edgecolor(self,"0,1,1,0.4");
					end;
					if string.sub(adgraph,7) ~= pid_name then
						if ad_t_table[adtype] == params.GSet then
							if you_sccheck(i,params.GSet,{i,i},cs_hs,sm_hs,string.sub(adgraph,7)) then
								self:setstate(1);
								self:diffuse(color("0.5,0.5,0,0"));
								edgecolor(self,"0.5,0.5,0,0.4");
							end;
						end;
					end;
				end;
			end;
		};
		
		LoadActor("f_set")..{
			OnCommand=cmd(animate,false;setstate,0+state_p;stoptweening;croptop,1;sleep,1+sleeptime;decelerate,0.15;croptop,0;
						playcommand,"JudgeSetting",{GSet = gset,Player = pn});
			JudgeSettingMessageCommand=function(self,params)
				if params.Player ~= pn then return;
				end;
				self:setstate(0+state_p);
				self:x(m_xset);
				if SongOrCourse and StepsOrTrail then
					self:y(-10+(i-1)*height);
					if you_sccheck(i,params.GSet,cpn,cs_hs,sm_hs,pid_name) then
						self:setstate(4+state_p);
						self:x(m_xset+you_set);
					end;
					if string.sub(adgraph,7) ~= pid_name then
						if ad_t_table[adtype] == params.GSet then
							if you_sccheck(i,params.GSet,{i,i},cs_hs,sm_hs,string.sub(adgraph,7)) then
								self:setstate(2+state_p);
								self:x(m_xset+t_set);
							end;
						end;
					end;
				end;
			end;
		};
	};
	
	t[#t+1] = Def.ActorFrame {
		InitCommand=cmd(x,l_set;);
		OnCommand=cmd(y,20;playcommand,"JudgeSetting",{GSet = gset,Player = pn});
		
		LoadActor("graphback")..{
			Name="graphback";
			InitCommand=cmd(stoptweening;addx,xset[1];diffusealpha,0;
						sleep,1+sleeptime;decelerate,0.15;addx,xset[2];diffusealpha,1;);
		};
		Def.Sprite{
			Name="avatar";
			InitCommand=cmd(horizalign,left;zoom,0.65;stoptweening;addx,xset[1];diffusealpha,0;
						sleep,1+sleeptime;decelerate,0.15;addx,xset[2];diffusealpha,1;);
		};
		LoadFont("_um") .. {
			Name="rank";
			InitCommand=cmd(horizalign,rank_horiz;skewx,-0.125;maxwidth,50;zoom,1.15;stoptweening;addx,xset[1];diffusealpha,0;
						sleep,1+sleeptime;decelerate,0.15;addx,xset[2];diffusealpha,1;);
		};
		LoadFont("_Shared2")..{
			Name="name";
			InitCommand=cmd(horizalign,left;zoom,0.65;stoptweening;strokecolor,Color("Black");addx,xset[1];
						diffusealpha,0;sleep,1+sleeptime;decelerate,0.15;addx,xset[2];diffusealpha,1;);
		};
		LoadActor(THEME:GetPathG("","graph_mini"))..{
			Name="graph_mini";
			InitCommand=cmd(zoom,0.15;stoptweening;addx,xset[1];diffusealpha,0;sleep,1+sleeptime;
						decelerate,0.15;addx,xset[2];diffusealpha,1;);
		};
		Def.Sprite{
			Name="grade";
			InitCommand=cmd(stoptweening;addx,xset[1];zoom,0.55;diffusealpha,0;sleep,1+sleeptime;
						decelerate,0.15;addx,xset[2];diffusealpha,1;);
		};
		LoadFont("_ul")..{
			Name="exscore";
			InitCommand=cmd(strokecolor,color("0,0,0,1");horizalign,left;zoom,0.5;stoptweening;addx,xset[1];diffusealpha,0;
						sleep,1+sleeptime;decelerate,0.15;addx,xset[2];diffusealpha,1;);
		};
		
		JudgeSettingMessageCommand=function(self,params)
			if params.Player ~= pn then return;
			end;
			local graphback = self:GetChild('graphback');
			local avatar = self:GetChild('avatar');
			local rank = self:GetChild('rank');
			local name = self:GetChild('name');
			local graph_mini = self:GetChild('graph_mini');
			local grade = self:GetChild('grade');
			local exscore = self:GetChild('exscore');
			local tmpogs = "";
			graphback:visible(false);
			avatar:visible(false);
			graph_mini:visible(false);
			grade:visible(false);
			
			if coursetype then
				self:visible(true);
			else self:visible(false);
			end;

			if params.GSet == "ntype" then
				if cs_hs[i] ~= nil and cs_hs[i] ~= "" then
					hsset = cs_hs[i];
				end;
			else
				if sm_hs[i] ~= nil and sm_hs[i] ~= "" then
					hsset = sm_hs[i];
				end;
			end;
			if hsset[2] ~= nil and hsset[2] ~= "" then
				hssetcheck = 1;
			end;
			if hsset[3] ~= nil and hsset[3] ~= "" then
				tmpogs = split("/",hsset[3]);
			end;
			if SongOrCourse and StepsOrTrail then
				graphback:visible(true);
				graph_mini:x(50);
				graph_mini:y(-16+(i-1)*height);
				grade:x(40);
				grade:y(-11+(i-1)*height);
				grade:shadowlength(0);
				graph_mini:shadowlength(0);
				name:shadowlength(0);
				exscore:shadowlength(0);
				if #tmpogs > 1 then
					local gccheck = 5;
					if GetAdhocPref("GoodCombo") ~= "TapNoteScore_W4" then
						gccheck = 4;
					end;
					if tonumber(tmpogs[2]) < gccheck then
						graph_mini:visible(true);
						if tmpogs[1] == "Grade_Tier01" then graph_mini:addx(4);
						elseif tmpogs[1] == "Grade_Tier02" then graph_mini:addx(1);
						else graph_mini:addx(0);
						end;
						graph_mini:diffuse(Colors.Judgment["JudgmentLine_W"..tmpogs[2]]);
						if tonumber(tmpogs[2]) <= 2 then graph_mini:glowshift();
						else graph_mini:stopeffect();
						end;
					end;

					if tmpogs[1] and tonumber(string.sub(tmpogs[1],-2)) then
						if tonumber(string.sub(tmpogs[1],-2)) < 22 then
							grade:visible(true);
							if tonumber(string.sub(tmpogs[1],-2)) == 21 then
								grade:Load(THEME:GetPathG(low_pic_d,ToEnumShortString( "Grade_Failed" )));
							elseif tonumber(string.sub(tmpogs[1],-2)) >= 8 and tonumber(string.sub(tmpogs[1],-2)) <= 20 then
								grade:Load(THEME:GetPathG(low_pic_d,ToEnumShortString( "Grade_Tier07" )));
							else grade:Load(THEME:GetPathG(low_pic_d,ToEnumShortString( tmpogs[1] )));
							end;
						end;
					end;
				else
					if hsset[3] and tonumber(string.sub(hsset[3],-2)) then
						if tonumber(string.sub(hsset[3],-2)) < 22 then
							grade:visible(true);
							if tonumber(string.sub(hsset[3],-2)) == 21 then
								grade:Load(THEME:GetPathG(low_pic_d,ToEnumShortString( "Grade_Failed" )));
							elseif tonumber(string.sub(hsset[3],-2)) >= 8 and tonumber(string.sub(hsset[3],-2)) <= 20 then
								grade:Load(THEME:GetPathG(low_pic_d,ToEnumShortString( "Grade_Tier07" )));
							else grade:Load(THEME:GetPathG(low_pic_d,ToEnumShortString( hsset[3] )));
							end;
						end;
					end;
				end;
				rank:visible(true);
				name:visible(true);
				exscore:visible(true);
				if hsset[13] then
					name:diffuse(color(hsset[13]));
					exscore:diffuse(color(hsset[13]));
					if string.sub(adgraph,7) ~= pid_name then
						if ad_t_table[adtype] == params.GSet then
							if you_sccheck(i,params.GSet,{i,i},cs_hs,sm_hs,string.sub(adgraph,7)) then
								name:diffuse(BoostColor(color(hsset[13]),1.5));
								exscore:diffuse(BoostColor(color(hsset[13]),1.5));
							end;
						end;
					end;
				end;
				if hsset[14] then
					rank:diffuse(color(hsset[14][1]));
					rank:strokecolor(color(hsset[14][2]));
				end;
				rank:x(rank_x[1]);
				if string.sub(hsset[2],1,16) == profile:GetGUID() then
					rank:x(rank_x[1]+rank_x[2]);
					grade:shadowlength(2);
					graph_mini:shadowlength(2);
					name:shadowlength(2);
					exscore:shadowlength(2);
				end;
				if string.sub(adgraph,7) ~= pid_name then
					if ad_t_table[adtype] == params.GSet then
						if you_sccheck(i,params.GSet,{i,i},cs_hs,sm_hs,string.sub(adgraph,7)) then
							rank:x(rank_x[1]+rank_x[3]);
							rank:diffuse(color(r_rcolor[1]));
							rank:strokecolor(color(r_rcolor[2]));
							grade:shadowlength(2);
							graph_mini:shadowlength(2);
							name:shadowlength(2);
							exscore:shadowlength(2);
						end;
					end;
				end;
				rank:y(8+(i-1)*height);
				rank:maxwidth(90);
				name:x(-54);
				name:y(-14+(i-1)*height);
				name:maxwidth(90);
				exscore:x(80);
				exscore:y(-9+((i-1)*height));
				exscore:maxwidth(110);
				if hsset then
					rank:settext( hsset[1] );
					name:settext( string.sub(hsset[2],18) );
					exscore:settext( hsset[4] );
				end;
			end;
			
			local path = "";
			if hssetcheck == 1 and coursetype then
				avatar:visible(false);
				--20161123
				local file = cs_avatar_set(hsset,rv_table,profile,pstr);
				if FILEMAN:DoesFileExist( file ) then
					avatar:visible(true);
					avatar:Load(file);
					avatar:scaletofit(0,0,40,40);
				end;
				avatar:y((i-1)*height);
			end;
			
			(cmd(x,40;))(graphback);
			if p_count_check then
				if pn == PLAYER_1 then
					(cmd(x,-108;))(avatar);
				else (cmd(x,148;))(avatar);
				end;

			else
				if pn == PLAYER_1 then
					(cmd(x,148;))(avatar);
				else (cmd(x,-108;))(avatar);
				end;
			end;
			graphback:y(8+(i-1)*height);
			
		end;
	};
	
	-- [ja] OKとNGの判定のグラフ
	for idx, cat in pairs(restatsHoldCategoryValues) do
		local restatsholdCategory = cat.Category;
		local restatsholdColor = cat.Color;
		t[#t+1] = Def.ActorFrame{
			InitCommand=function(self)
				if coursetype then
					self:visible(true);
				else self:visible(false);
				end;
				self:x(jt_set_x);
				self:y(28+(i-1)*height);
			end;
			LoadActor(THEME:GetPathB("ScreenEvaluation","decorations/judgegraph"))..{
				InitCommand=cmd(horizalign,left;zoomtowidth,0;zoomtoheight,6;);
				OnCommand=cmd(playcommand,"JudgeSetting",{GSet = gset,Player = pn});
				JudgeSettingMessageCommand=function(self,params)
					if params.Player ~= pn then return;
					end;
					self:visible(false);
					if cs_hs[i] ~= nil and cs_hs[i] ~= "" then
						hsset = cs_hs[i];
					end;
					if params.GSet ~= "ntype" then
						if sm_hs[i] ~= nil and sm_hs[i] ~= "" then
							hsset = sm_hs[i];
						end;
					end;
					local wset = {
						HoldNoteScore_Held	= 0,
						HoldNoteScore_LetGo	= 0,
						TotalSteps			= 0,
						RadarCategory_Holds	= 0,
						RadarCategory_Rolls	= 0
					};
					if hssetcheck == 1 then
						wset = {
							HoldNoteScore_Held	= hsset[11],
							HoldNoteScore_LetGo	= hsset[12],
							TotalSteps			= hs["TotalSteps"],
							RadarCategory_Holds	= hs["RadarCategory_Holds"],
							RadarCategory_Rolls	= hs["RadarCategory_Rolls"]
						};
						self:visible(true);
						j_w_set(self,restatsholdCategory,restatsholdColor,wset,idx,judgewidth,"Hold");
					end;
					if coset[i] == 1 then
						(cmd(stoptweening;cropright,1;sleep,1.1+sleeptime+(idx*0.05);linear,0.1;cropright,0;))(self);
					else (cmd(stoptweening;cropright,0;))(self);
					end;
				end;
			};
		};
	end;
	
	-- [ja] OKとNG以外の各種判定のグラフ
	for idx, cat in pairs(restatsCategoryValues) do
		local restatsCategory = cat.Category;
		local restatsColor = cat.Color;
		t[#t+1] = Def.ActorFrame{
			InitCommand=function(self)
				if coursetype then
					self:visible(true);
				else self:visible(false);
				end;
				self:x(jt_set_x);
				self:y(22+(i-1)*height);
			end;
			LoadActor(THEME:GetPathB("ScreenEvaluation","decorations/judgegraph"))..{
				InitCommand=cmd(horizalign,left;zoomtowidth,0;zoomtoheight,6;);
				OnCommand=cmd(playcommand,"JudgeSetting",{GSet = gset,Player = pn});
				JudgeSettingMessageCommand=function(self,params)
					if params.Player ~= pn then return;
					end;
					self:visible(false);
					if params.GSet == "ntype" then
						if cs_hs[i] ~= nil and cs_hs[i] ~= "" then
							hsset = cs_hs[i];
						end;
					else
						if sm_hs[i] ~= nil and sm_hs[i] ~= "" then
							hsset = sm_hs[i];
						end;
					end;
					local wset = {
						TapNoteScore_W1	= 0,
						TapNoteScore_W2	= 0,
						TapNoteScore_W3	= 0,
						TapNoteScore_W4	= 0,
						TapNoteScore_W5	= 0,
						TapNoteScore_Miss	= 0,
						TotalSteps			= 0,
						RadarCategory_Holds	= 0,
						RadarCategory_Rolls	= 0
					};
					if hssetcheck == 1 then
						wset = {
							TapNoteScore_W1	= hsset[5],
							TapNoteScore_W2	= hsset[6],
							TapNoteScore_W3	= hsset[7],
							TapNoteScore_W4	= hsset[8],
							TapNoteScore_W5	= hsset[9],
							TapNoteScore_Miss	= hsset[10],
							TotalSteps			= hs["TotalSteps"],
							RadarCategory_Holds	= hs["RadarCategory_Holds"],
							RadarCategory_Rolls	= hs["RadarCategory_Rolls"]
						};
						--Trace("aaaaa : "..hsset[5]..","..hsset[6]..","..hsset[7]..","..hsset[8]..","..hsset[9]..","..hsset[10])
						self:visible(true);
						j_w_set(self,restatsCategory,restatsColor,wset,idx,judgewidth,"Note");
					end;
					if coset[i] == 1 then
						(cmd(stoptweening;cropright,1;sleep,1.05+sleeptime+(idx*0.05);linear,0.1;cropright,0;))(self);
					else (cmd(stoptweening;cropright,0;))(self);
					end;
				end;
			};
		};
	end;

	--[ja] 判定平均ボックス
	for x=1,g_box_setcount() do
		t[#t+1] = Def.ActorFrame{
			InitCommand=function(self)
				if coursetype then
					self:visible(true);
				else self:visible(false);
				end;
				self:x(jt_set_x);
				self:y(34+(i-1)*height);
			end;
			LoadActor(THEME:GetPathB("ScreenEvaluation","decorations/judgegraph"))..{
				InitCommand=cmd(horizalign,left;zoomtowidth,0;zoomtoheight,6;);
				OnCommand=cmd(stoptweening;cropright,1;sleep,1+(i*0.1)+(x*0.0025);linear,0.01;cropright,0;
							playcommand,"JudgeSetting",{GSet = gset,Player = pn});
				JudgeSettingMessageCommand=function(self,params)
					if params.GSet == "ntype" then
						if cs_hs[i] ~= nil and cs_hs[i] ~= "" then
							hsset = cs_hs[i];
						end;
					else
						if sm_hs[i] ~= nil and sm_hs[i] ~= "" then
							hsset = sm_hs[i];
						end;
					end;
					self:visible(false);
					if hsset[16] and hsset[16] ~= "" then
						if (#hsset[16] > 0 and x <= #hsset[16]) then
							self:visible(true);
							self:diffuse(color("0.5,0.5,0.5"));
							--SCREENMAN:SystemMessage(tostring(icheck));
							self:diffuse(JBoxColor[hsset[16][x]]);
							self:diffusealpha(0.75);
							self:x( (judgewidth / #hsset[16]) * (x - 1) );
							local space = 1;
							if x == #hsset[16] then space = 0.5;
							end;
							local zx = math.round((judgewidth / #hsset[16]));
							self:zoomtowidth( zx - space );
						end;
					else
						if x == 1 then
							self:visible(true);
							self:diffuse(Colors.Grade["None"]);
							--SCREENMAN:SystemMessage(tostring(icheck));
							self:diffusealpha(0.75);
							self:zoomtowidth( judgewidth );
						end;
					end;
				end;
			};
		};
	end;

	t[#t+1] = LoadActor(THEME:GetPathB("ScreenEvaluation","decorations/mark"))..{
		Name="mark";
		InitCommand=cmd(x,32;y,-24;);
		OnCommand=cmd(diffusealpha,0;zoomy,0;sleep,0.95;linear,0.15;diffusealpha,1;zoomy,1;);
	};
	t[#t+1] = Def.ActorFrame{
		LoadFont("Common Normal")..{
			Name="update_b_a";
		};
		LoadFont("_um")..{
			Name="update_b";
		};
		LoadFont("Common Normal")..{
			Name="update_a_a";
		};
		LoadFont("_um")..{
			Name="update_a";
		};
		LoadFont("_Shared2")..{
			Name="rank_up";
		};			
		InitCommand=function(self)
			(cmd(horizalign,left;zoom,1.25;stoptweening;diffusealpha,0;zoomy,0;sleep,0.95;linear,0.15;diffusealpha,1;zoomy,1.25;))(self)
		end;
		OnCommand=function(self)
			(cmd(playcommand,"JudgeSetting",{GSet = gset,Player = pn};))(self)
			coset[i] = 0;
		end;
		JudgeSettingMessageCommand=function(self,params)
			if params.Player ~= pn then return;
			end;
			local update_b_a = self:GetChild('update_b_a');
			local update_b = self:GetChild('update_b');
			local update_a_a = self:GetChild('update_a_a');
			local update_a = self:GetChild('update_a');
			local rank_up = self:GetChild('rank_up');
			update_a:diffuse(Color("White"));
			update_a_a:diffuse(Color("White"));
			update_b_a:strokecolor(Color("Black"));
			update_a_a:strokecolor(Color("Black"));
			update_b:strokecolor(Color("Black"));
			update_a:strokecolor(Color("Black"));
			rank_up:strokecolor(Color("Black"));
			if SongOrCourse and StepsOrTrail then
				update_b_a:x(-40+30);
				update_b_a:y(-24);
				update_b_a:zoom(0.6);
				update_a_a:x(68+30);
				update_a_a:y(-24);
				update_a_a:zoom(0.6);
				update_b_a:maxwidth(50);
				update_a_a:maxwidth(50);
				update_b_a:settext(THEME:GetString( "ScreenEvaluation","Rank" ));
				update_a_a:settext(THEME:GetString( "ScreenEvaluation","Rank" ));
				rank_up:visible(false);
				rank_up:x(80);
				rank_up:y(-13);
				rank_up:zoom(0.4);
				rank_up:maxwidth(100);
				rank_up:diffuse(color("1,1,0,1"));
				rank_up:settext(THEME:GetString( "ScreenEvaluation","Rankup" ));

				update_b:x(-40);
				update_b:y(-20);
				update_a:x(68);
				update_a:y(-20);
				update_b:maxwidth(100);
				update_a:maxwidth(100);
				update_b:settext("-");
				update_a:settext("-");
				local rankpset = 1;
				local check_hs = cs_hs[i];
				if params.GSet ~= "ntype" then
					rankpset = 2;
					check_hs = sm_hs[i];
				end;
				--[ja] 20160116修正
				if check_hs ~= nil and check_hs ~= "" then
					update_a:settext( rank_update[rankpset] );
					if topscore and #scores > 1 and getenv("rival_c_rankp"..p) then
						update_b:settext( getenv("rival_c_rankp"..p)[rankpset] );
					end;
					if getenv("rival_c_rankp"..p) and rank_update[rankpset] < getenv("rival_c_rankp"..p)[rankpset] then
						update_a:diffuse(color("1,1,0,1"));
						update_a_a:diffuse(color("1,1,0,1"));
						rank_up:visible(true);
					end;
				end;
			end;
		end;
	};
end;

return t;