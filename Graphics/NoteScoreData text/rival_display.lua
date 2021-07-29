
local pn = ...
assert(pn,"Must pass in a player, dingus");

local numPlayers = GAMESTATE:GetNumPlayersEnabled();
local p = ( (pn == "PlayerNumber_P1") and 1 or 2 );
local pstr = ProfIDSet(p);
local gset = judge_initial(pstr);
local rf_dp = {};
if gset == "ntype" then
	rf_dp[1] = 'CS';
else rf_dp[1] = 'SM';
end;
local profile;
local pid_name;
local scorelist;
local scores;
local topscore;
local snum = 1;
setenv("sctable"..p,"");

local SongOrCourse = "";
local StepsOrTrail = "";
local SorCDir;
local sdirs;
local sttype;
local bIsCourseMode = GAMESTATE:IsCourseMode();
local pm = GAMESTATE:GetPlayMode();

local coursetype = true;
local height = 44;
local cpn = {1,1};
local r_open = {0,0};
local notset_text = THEME:GetString( "OptionExplanations","NotSet" );
local g_lowpic = "GradeLowPic/GradeDisplayEval";
---------------------------------------------------------------------------------------------------------------------------------------
local cs_hs = {};
local sm_hs = {};

local migsav = {0,0};

local SorCTime = 0;
local fcheck = 5;
local t_fcheck = 5;
local hs = {};
local bhs = {};
--local mbest_t = {};
--local mbest_t_num = {ntype = 1,default = 1};

local t = Def.ActorFrame{
	Name="RivalDisplay"..pn;
	BeginCommand=function(self)
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

local rv_table;
if PROFILEMAN:IsPersistentProfile(pn) then
	pid_name = PROFILEMAN:GetProfile(pn):GetGUID().."_"..PROFILEMAN:GetProfile(pn):GetDisplayName();
	rv_table = rival_table(pstr,PROFILEMAN:GetProfile(pn),pid_name);
end;
--[ja] スコアグラフ
local rtnum = 1;
local rtset = notset_text;
local ttable = rtableset(pn);
local adgraph = ProfIDPrefCheck("ScoreGraph",pstr,"Off");
if adgraph ~= getenv("scoregraphp"..p) then
	adgraph = getenv("scoregraphp"..p);
	SetAdhocPref("ScoreGraph",adgraph,pstr);
end;
for h=1,#ttable.savebase do
	if adgraph == ttable.savebase[h] then
		rtset = ttable.base[h];
		rtnum = h;
		break;
	end;
end;
local curIndex = rtnum;
r_open[p] = math.min(1,tonumber(ProfIDPrefCheck("SRivalOpen",pstr,1)));
if not tonumber(getenv("s_rival_op"..p)) then
	setenv("s_rival_op"..p,1);
end;
if r_open[p] ~= getenv("s_rival_op"..p) then
	r_open[p] = math.min(1,tonumber(getenv("s_rival_op"..p)));
	SetAdhocPref("SRivalOpen",r_open[p],pstr);
end;

local adtype = ProfIDPrefCheck("GraphType",pstr,"CS");
local adhoc = {ntype = 0,default = 0};
local migsadhoc = {ntype = 0,default = 0};
local rival = {ntype = 1,default = 1};
local on1rank = {ntype = 1,default = 1};
local c_x_m = {16,10,0};
local graph_m_x = {ntype = 0,default = 0};
local setnum = {ntype = 1,default = 1};
local sleepset = 1;
local main_y = math.max(-52,WideScale(-36,-52));
local target_y = math.max(-72,WideScale(-50,-72));
local main_xset = 38;
local target_xset = 54;
local t_select_xset,t_select_sc = math.min(180,WideScale(130,180)),-40;
local ha_set = right;
local hb_set = left;
if pn == PLAYER_2 then
	main_xset = -38;
	target_xset = -54;
	t_select_xset,t_select_sc = math.max(-180,WideScale(-130,-180)),40;
	ha_set = left;
	hb_set = right;
end;
---------------------------------------------------------------------------------------------------------------------------------------
t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(playcommand,"JudgeSetting",{GSet = gset,Player = pn};);
	OnCommand=cmd(playcommand,"JudgeSetting",{GSet = gset,Player = pn};);
	JudgeSettingMessageCommand=function(self,params)
		if params.Player ~= pn then return;
		end;
		if r_open[p] == 0 then return;
		end;
		self:visible(false);
		if params.GSet then
			if params.GSet ~= getenv("judgesetp"..p) then
				gset = getenv("judgesetp"..p);
			end;
		end;
		
		hs_local_set(hs,0);
		fcheck = 5;
		t_fcheck = 5;
		--mbest_t = {};
		--mbest_t_num = {ntype = 1,default = 1};
		migsav = {0,0};
		if getenv("wheelstop") == 1 then
			SongOrCourse = CurSOSet();
			StepsOrTrail = CurSTSet(pn);
			--20160710
			if GAMESTATE:GetCurrentStyle() then
				sttype = GAMESTATE:GetCurrentStyle():GetStepsType();
			end;
			steps_count(hs,SongOrCourse,StepsOrTrail,pn,"Course");
			if SongOrCourse then
				if bIsCourseMode then
					if SongOrCourse:IsAutogen() or SongOrCourse:GetCourseType() == 'CourseType_Endless' or
					SongOrCourse:GetCourseType() == 'CourseType_Survival' then
					--[ja] AutogenコースやEndlessタイプコースはグラフ非表示
						coursetype = false;
					else coursetype = true;
					end;
					SorCDir = SongOrCourse:GetCourseDir();
					sdirs = split("/",SorCDir);
				else
					SorCDir = SongOrCourse:GetSongDir();
					sdirs = split("/",SorCDir);
					coursetype = true;
				end;
			end;
			if sdirs and sdirs[2] then
				sdirs[2] = additionaldir_to_songdir(sdirs[2]);
			end;
			if SongOrCourse and StepsOrTrail then
				if bIsCourseMode then
					--20160504
					if GAMESTATE:GetCurrentStyle() then
						sttype = GAMESTATE:GetCurrentStyle():GetStepsType();
					end;
					SorCTime = courselength(SongOrCourse,GAMESTATE:GetCurrentTrail(pn),sttype);
				else SorCTime = SongOrCourse:GetLastSecond();
				end;
				profile = c_profile(pn);
				scorelist = profile:GetHighScoreList(SongOrCourse,StepsOrTrail);
				assert(scorelist);
				scores = scorelist:GetHighScores();
				topscore = scores[1];
				snum = snum_set(1,scores,pn);
				if snum > 0 then
					topscore = scores[snum];
					if topscore then
						hs_set(hs,topscore,"normal");
						hs["SurvivalSeconds"] = topscore:GetSurvivalSeconds();
						if bIsCourseMode then
							hs["SurvivalSeconds"] = SorCTime + 1;
						end;
						if not assistchecker(pn,hs["Modifiers"]) then
							fcheck = fullcombochecker(hs,SorCTime);
						else fcheck = 9;
						end;
					end;
				end;
				if coursetype and rv_table then
					if params.GSet == "ntype" then
						rf_dp[1] = 'CS';
					else rf_dp[1] = 'SM';
					end;
					for r=1,#rv_table do
						local tmpo = "";
						local tmpogs = "";
						local tmpolts = "";
						local cr_path = "";
						local pcolor = "";
						local rcolor;
						local c_xset = c_x_m[3];
						if r == 1 or string.find(rv_table[r],"^MyBest_.*") then
							local hs_mset = hs;
							local c_fcheck = fcheck;
							local m_num = 1;
							pcolor = "1,1,1";
							rcolor = {"0,0,0,0.75","0,1,1,0.75"};
							c_xset = c_x_m[1];
							t_topscore = topscore;
							local c_pid_name = pid_name;
							if string.find(rv_table[r],"^MyBest_.*") then
								c_pid_name = "MyBest_";
								hs_mset = bhs;
								c_fcheck = t_fcheck;
								m_num = split("_",rv_table[r])[2];
								t_topscore = scores[tonumber(m_num)];
								Trace("t_topscore : "..m_num);
								if t_topscore then
									hs_set(hs_mset,t_topscore,"normal");
									hs_mset["SurvivalSeconds"] = t_topscore:GetSurvivalSeconds();
									if bIsCourseMode then
										hs_mset["SurvivalSeconds"] = SorCTime + 1;
									end;
									steps_count(hs_mset,SongOrCourse,StepsOrTrail,pn,"Course");
									if not assistchecker(pn,hs_mset["Modifiers"]) then
										c_fcheck = fullcombochecker(hs_mset,SorCTime);
										Trace("t_fcheck : "..c_fcheck);
									else c_fcheck = 5;
									end;
									Trace("SurvivalSeconds : "..hs_mset["SurvivalSeconds"].." : "..SorCTime);
									topscore = t_topscore;
								end;
								pcolor = "0.65,0.65,0.65";
								rcolor = {"0,0,0,0.75","0,0.5,0.5,0.75"};
								c_xset = c_x_m[3];
								--mbest_t[#mbest_t+1] = rv_table[r];
							end;
							cr_path = "CSRealScore/"..pid_name.."/"..sdirs[2].."/"..sdirs[3].."/"..sdirs[4].."/set_"..wpsetd.."_"..swpsetd;
							for i, rf in ipairs(rf_dp) do
								local MIGS = 0;
								if FILEMAN:DoesFileExist( cr_path ) then
									if GetRSParameter( cr_path,sttype.."_"..ToEnumShortString(StepsOrTrail:GetDifficulty()) .."/"..rf) ~= "" then
										tmpo = split( ":",GetRSParameter( cr_path,sttype.."_"..ToEnumShortString(StepsOrTrail:GetDifficulty()) .."/"..rf) );
									end;
								end;
								if t_topscore then
									if rf == "CS" then
										MIGS = migschecker(hs_mset,"ntype");
										hs_mset["Grade"] = gradechecker(hs_mset,t_topscore:GetGrade(),SorCTime,"ntype",c_fcheck);
									else
										MIGS = migschecker(hs_mset,"default");
										hs_mset["Grade"] = gradechecker(hs_mset,t_topscore:GetGrade(),SorCTime,"default",c_fcheck);
									end;
									if coursetype and getenv("rnd_song") == 0 then
										if #tmpo >= 6 then
											tmpolts = split(",",tmpo[6]);
											if tonumber(eachecker(tmpolts)) == 1 then
												pcolor = "1,0.5,0";
											elseif tonumber(eachecker(tmpolts)) == 2 then
												pcolor = "0,1,0";
											end;
										end;
									end;
								else
									if r == 1 then
										pcolor = "1,1,1";
										if #tmpo >= 2 then
											tmpogs = split("/",tmpo[2]);
											if string.sub(tmpogs[1],1,10) == "Grade_Tier" then
												hs_mset["Grade"] = tmpogs[1];
											end;
										end;
									else hs_mset["Grade"] = "Grade_None";
									end;
									MIGS = 0;
								end;
								if hs_mset["Grade"] == "Grade_None" then
									hs_mset["Grade"] = "Grade_Tier22";
								elseif hs_mset["Grade"] == "Grade_Failed" then
									hs_mset["Grade"] = "Grade_Tier21";
								end;
								if rf == "CS" then
									cs_hs[r] = { 1,c_pid_name,hs_mset["Grade"].."/"..c_fcheck,MIGS,pcolor,rcolor,c_xset,r,m_num };
								else sm_hs[r] = { 1,c_pid_name,hs_mset["Grade"].."/"..c_fcheck,MIGS,pcolor,rcolor,c_xset,r,m_num };
								end;
							end;
						else
							cr_path = "CSRealScore/"..rv_table[r].."/"..sdirs[2].."/"..sdirs[3].."/"..sdirs[4].."/set_"..wpsetd.."_"..swpsetd;
							for i, rf in ipairs(rf_dp) do
								pcolor = "0.35,0.35,0.35";
								if coursetype and getenv("rnd_song") == 0 then
									pcolor = "0.75,0.75,0.75";
								end;
								rcolor = {"0,0,0,0.75","0.5,0.25,0,0.75"};
								c_xset = c_x_m[3];
								if FILEMAN:DoesFileExist( cr_path ) then
									if GetRSParameter( cr_path,sttype.."_"..ToEnumShortString(StepsOrTrail:GetDifficulty()) .."/"..rf) ~= "" then
										tmpo = split( ":",GetRSParameter( cr_path,sttype.."_"..ToEnumShortString(StepsOrTrail:GetDifficulty()) .."/"..rf) );
									end;
									if #tmpo >= 3 then
										tmpogs = split("/",tmpo[2]);
										if #tmpogs > 1 then
											if coursetype and getenv("rnd_song") == 0 then
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
											end;
										else
											if string.find(tmpo[2],"Grade_Tier[0-9][0-9]") then
												tmpogs[1] = tmpo[2];
											else tmpogs[1] = "Grade_Tier22";
											end;
											tmpogs[2] = "5";
										end;
										if rf == "CS" then
											cs_hs[r] = { 1,rv_table[r],tmpogs[1].."/"..tmpogs[2],tmpo[3],pcolor,rcolor,c_xset,r,9 };
--[[
											if r == 2 then
												cs_hs[r] = { 1,string.sub(rv_table[r],18),"Grade_Tier04/2",100,pcolor };
											elseif r == 3 then
												cs_hs[r] = { 1,string.sub(rv_table[r],18),"Grade_Tier02/4",100,pcolor };
											else cs_hs[r] = { 1,string.sub(rv_table[r],18),"Grade_Tier06/9",100,pcolor };
											end;

]]
										else sm_hs[r] = { 1,rv_table[r],tmpogs[1].."/"..tmpogs[2],tmpo[3],pcolor,rcolor,c_xset,r,9 };
										end;
									else
										pcolor = "0.35,0.35,0.35";
										if rf == "CS" then
											cs_hs[r] = { 1,rv_table[r],"Grade_Tier22/5",0,pcolor,rcolor,c_xset,r,9 };
										else sm_hs[r] = { 1,rv_table[r],"Grade_Tier22/5",0,pcolor,rcolor,c_xset,r,9 };
										end;
									end;
								else
									pcolor = "0.35,0.35,0.35";
									if rf == "CS" then
										cs_hs[r] = { 1,rv_table[r],"Grade_Tier22/5",0,pcolor,rcolor,c_xset,r,9 };
									else sm_hs[r] = { 1,rv_table[r],"Grade_Tier22/5",0,pcolor,rcolor,c_xset,r,9 };
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
						if score2 then
							--[ja] ソート優先度: 1,スコア 2,アシスト 3,グレード 4,フルコンボ
							if coursetype and getenv("rnd_song") == 0 then
								if tonumber(score1[4]) == tonumber(score2[4]) then
									if (score1[3] ~= nil and score1[3] ~= "") and (score2[3] ~= nil and score2[3] ~= "") then
										score1sp = split("/",score1[3])
										score2sp = split("/",score2[3])
										grade1 = string.sub(score1sp[1],-2)
										grade2 = string.sub(score2sp[1],-2)
										if tonumber(grade1) == tonumber(grade2) then
											if tonumber(score1[9]) < tonumber(score2[9]) then
												return tonumber(score1[9]) < tonumber(score2[9])
											elseif (score1sp[2] ~= nil and score1sp[2] ~= "") and (score2sp[2] ~= nil and score2sp[2] ~= "") then
												if tonumber(score1sp[2]) ~= tonumber(score2sp[2]) then
													return tonumber(score1sp[2]) < tonumber(score2sp[2])
												end
											else 
												return tonumber(score1[8]) < tonumber(score2[8])
											end;
										else
											if (score1sp[2] ~= nil and score1sp[2] ~= "") and (score2sp[2] ~= nil and score2sp[2] ~= "") then
												if tonumber(score1sp[2]) == 9 or tonumber(score2sp[2]) == 9 then
													return tonumber(score1sp[2]) < tonumber(score2sp[2])
												elseif tonumber(grade1) and tonumber(grade2) then
													return tonumber(grade1) < tonumber(grade2)
												end;
											else
												if tonumber(score1[9]) < tonumber(score2[9]) then
													return tonumber(score1[9]) < tonumber(score2[9])
												end
												return tonumber(score1[8]) < tonumber(score2[8])
											end;
										end
									end
								end
								return tonumber(score1[4]) > tonumber(score2[4])
							end
							if tonumber(score1[8]) == tonumber(score2[8]) then
								return tonumber(score1[9]) < tonumber(score1[9])
							end
							return tonumber(score1[8]) < tonumber(score2[8])
						end
					end
					local rank = 1;
					local avg_count = 0;
					local avg_total = 0;
					local sctable = {"","",0,"","",0};
				--[[
					table.sort(mbest_t,
						function(a, b)
							return (string.upper(a) < string.upper(b))
						end
					);
				]]
					local pg_hs = {cs_hs,"ntype","CS",1,1};
					if params.GSet ~= "ntype" then
						pg_hs = {sm_hs,"default","",4,2};
					end;
					table.sort(pg_hs[1],
						function(a, b)
							return SortScore(a,b)
						end
					);
					
					for sr=1,#pg_hs[1] do
						local sr_rank = split("/",pg_hs[1][sr][3]);
						if sr_rank[1] ~= "Grade_Tier22" then
							avg_total = avg_total + pg_hs[1][sr][4];
							migsav[pg_hs[5]] = migsav[pg_hs[5]] + pg_hs[1][sr][4];
							avg_count = avg_count + 1;
						end;
						if sr == 1 then
							pg_hs[1][sr][1] = 1;
						else 
							if tonumber(pg_hs[1][sr-1][4]) > tonumber(pg_hs[1][sr][4]) then
								rank = sr;
							end;
							pg_hs[1][sr][1] = rank;
						end;
						if string.sub(pg_hs[1][sr][2],1,16) == profile:GetGUID() then
							cpn[pg_hs[5]] = sr;
						else
							if pg_hs[1][sr][2] == "MyBest_" then
								pg_hs[1][sr][2] = "MyBest_"..pg_hs[1][sr][9];
								--pg_hs[1][sr][2] = mbest_t[mbest_t_num[pg_hs[2]]];
								--mbest_t_num[pg_hs[2]] = mbest_t_num[pg_hs[2]] + 1;
								if adgraph == pg_hs[1][sr][2] then
									migsadhoc[pg_hs[2]] = pg_hs[1][sr][4];
									if pg_hs[1][sr][7] < c_x_m[1] then
										pg_hs[1][sr][7] = c_x_m[2];
									end;
								end;
							end;
						end;
						if string.sub(adgraph,7) == string.sub(pg_hs[1][sr][2],1) then
							rival[pg_hs[2]] = sr;
						end;
					end;
					if avg_total > 0 and avg_count > 0 then
						migsav[pg_hs[5]] = math.floor(avg_total / avg_count);
					end;
					
					if pg_hs[1][1] then
						sctable[pg_hs[4]] = pg_hs[1][1][2];
						sctable[pg_hs[4]+2] = migsav[pg_hs[5]];
					end;
					if cpn[pg_hs[5]] == 1 then
						if pg_hs[1][1] then
							sctable[pg_hs[4]+1] = pg_hs[1][1][2];
							on1rank[pg_hs[2]] = 1;
						end;
					elseif cpn[pg_hs[5]] > 1 then
						if pg_hs[1][cpn[pg_hs[5]]] then
							local v = pg_hs[1][cpn[pg_hs[5]]][1];
							while v > 1 do
								if pg_hs[1][v][1] == pg_hs[1][v-1][1] then
									v = v - 1;
								else
									sctable[pg_hs[4]+1] = pg_hs[1][v-1][2];
									on1rank[pg_hs[2]] = v-1;
									v = 0;
								end;
							end;
						end;
					end;
					if string.find(adgraph,"Tier") then
						adhoc[pg_hs[2]] = THEME:GetMetric("PlayerStageStats","GradePercent"..pg_hs[3]..adgraph);
						migsadhoc[pg_hs[2]] = math.ceil(migsmaxchecker(hs,pg_hs[2]) * tonumber(adhoc[pg_hs[2]]));
					elseif string.find(adgraph,"^MyBest_.*") then
					elseif adgraph == "MyBest" then
						if PROFILEMAN:IsPersistentProfile(pn) then
							migsadhoc[pg_hs[2]] = pg_hs[1][cpn[pg_hs[5]]][4];
						end;
					elseif string.find(adgraph,"^RIVAL_.*") then
						if adgraph ~= "RIVAL_Average" then
							if adgraph == "RIVAL_TopScore" then
								setnum[pg_hs[2]] = 1;
							elseif adgraph == "RIVAL_On1rank" then
								setnum[pg_hs[2]] = on1rank[pg_hs[2]];
							else setnum[pg_hs[2]] = rival[pg_hs[2]];
							end;
							if pg_hs[1][setnum[pg_hs[2]]][2] then
								migsadhoc[pg_hs[2]] = pg_hs[1][setnum[pg_hs[2]]][4];
								if pg_hs[1][setnum[pg_hs[2]]][7] < c_x_m[1] then
									pg_hs[1][setnum[pg_hs[2]]][7] = c_x_m[2];
								end;
							end;
						else
							migsadhoc[pg_hs[2]] = sctable[pg_hs[4]+2];
						end;
					elseif tonumber(adgraph) then
						migsadhoc[pg_hs[2]] = math.ceil(migsmaxchecker(hs,pg_hs[2]) * tonumber(adgraph));
					else migsadhoc[pg_hs[2]] = 0;
					end;

					--if sctable[1] then
						--Trace("sctable :"..sctable[1]);
					--end;
					if adgraph ~= getenv("scoregraphp"..p) then
						setenv("scoregraphp"..p,adgraph);
					end;
					self:stoptweening();
					self:sleep(1);
					self:visible(true);
					MESSAGEMAN:Broadcast("TableSetting",{GSet = params.GSet,Player = pn});
				end;
			end;
		else
			SongOrCourse = "";
			StepsOrTrail = "";
		end;
	end;
};

---------------------------------------------------------------------------------------------------------------------------------------
if rv_table then
	for i = 1,#rv_table do
		t[#t+1] = Def.ActorFrame {
			InitCommand=cmd(x,main_xset;zoom,math.min(1,WideScale(0.85,1)););
			LoadActor("t_focus")..{
				Name="focus";
			};
			LoadFont("_um") .. {
				Name="rank";
			};
			LoadFont("_Shared2")..{
				Name="name";
			};
			LoadActor(THEME:GetPathG("","graph_mini"))..{
				Name="graph_mini";
			};
			Def.Sprite{
				Name="grade";
			};
			LoadFont("_ul")..{
				Name="exscore";
			};
			LoadFont("_ul")..{
				Name="exscore_diff";
			};
			
			OnCommand=function(self)
				local focus = self:GetChild('focus');
				local rank = self:GetChild('rank');
				local name = self:GetChild('name');
				local graph_mini = self:GetChild('graph_mini');
				local grade = self:GetChild('grade');
				local exscore = self:GetChild('exscore');
				local exscore_diff = self:GetChild('exscore_diff');
				(cmd(visible,false;animate,false;setstate,0;y,main_y+16+(i-1)*height;stoptweening;
				croptop,1;sleep,sleepset;decelerate,0.15;croptop,0;))(focus);
				(cmd(visible,false;y,main_y+26+(i-1)*height;stoptweening;horizalign,ha_set;zoom,1.15;
				skewx,-0.125;maxwidth,50;croptop,1;sleep,sleepset;decelerate,0.15;croptop,0;))(rank);
				(cmd(visible,false;y,main_y+(i-1)*height;stoptweening;strokecolor,Color("Black");
				shadowlength,2;horizalign,hb_set;zoom,0.55;cropleft,1;sleep,sleepset;decelerate,0.15;cropleft,0;))(name);
				(cmd(visible,false;y,main_y+12+(i-1)*height;stoptweening;shadowlength,2;zoom,0.135;
				cropleft,1;sleep,sleepset;decelerate,0.15;cropleft,0;))(graph_mini);
				(cmd(visible,false;y,main_y+17+(i-1)*height;stoptweening;shadowlength,2;zoom,0.475;
				cropbottom,1;sleep,sleepset;decelerate,0.15;cropbottom,0;diffusealpha,1;))(grade);
				(cmd(visible,false;y,main_y+30+(i-1)*height;stoptweening;shadowlength,2;strokecolor,Color("Black");
				horizalign,hb_set;zoom,0.375;cropright,1;sleep,sleepset;decelerate,0.15;cropright,0;))(exscore);
				(cmd(visible,false;y,main_y+30+(i-1)*height;stoptweening;shadowlength,2;strokecolor,Color("Black");
				horizalign,hb_set;zoom,0.375;cropright,1;sleep,sleepset;decelerate,0.15;cropright,0;))(exscore_diff);
				(cmd(playcommand,"JudgeSetting",{GSet = gset,Player = pn};))(self);
			end;
			JudgeSettingMessageCommand=function(self,params)
				if params.Player ~= pn then return;
				end;
				if r_open[p] == 0 then return;
				end;
				if getenv("wheelstop") == 1 then
					(cmd(playcommand,"TableSetting",{GSet = params.GSet,Player = pn};))(self);
				end;
			end;
			TableSettingMessageCommand=function(self,params)
				self:stoptweening();
				if params.Player ~= pn then return;
				end;
				local focus = self:GetChild('focus');
				local rank = self:GetChild('rank');
				local name = self:GetChild('name');
				local graph_mini = self:GetChild('graph_mini');
				local grade = self:GetChild('grade');
				local exscore = self:GetChild('exscore');
				local exscore_diff = self:GetChild('exscore_diff');
				if params.Player ~= pn then return;
				end;
				local a_file = "";
				local state = {ntype = 0,default = 0};
				local tmpogs_n = {ntype = "Grade_Tier22/9",default = "Grade_Tier22/9"};
				local t_type = {ntype = nil,default = nil};
				local t_d_type = {ntype = nil,default = nil};
				local c_x = {ntype = 0,default = 0};
				local s_plus = 0;
				
				focus:visible(false);
				rank:visible(false);
				rank:maxwidth(90);
				rank:settext("1");
				name:visible(false);
				name:settext("");
				name:maxwidth(100);
				graph_mini:visible(false);
				grade:visible(false);
				exscore:visible(false);
				exscore:maxwidth(100);
				exscore:settext("0");
				exscore_diff:visible(false);
				exscore_diff:maxwidth(80);
				exscore_diff:settext("0");

				if getenv("wheelstop") == 1 then
					if SongOrCourse and StepsOrTrail then
						if cs_hs[i] ~= nil and cs_hs[i] ~= "" then
							if cs_hs[i][3] ~= nil and cs_hs[i][3] ~= "" then
								tmpogs_n["ntype"] = split("/",cs_hs[i][3]);
							end;
							if string.sub(cs_hs[i][2],1,16) == profile:GetGUID() or 
							string.find(cs_hs[i][2],"^MyBest_.*") then
								state["ntype"] = 4;
							elseif cs_hs[i][7] == c_x_m[2] then
								state["ntype"] = 2;
							else state["ntype"] = 0;
							end;
							c_x["ntype"] = cs_hs[i][7];
							t_type["ntype"] = cs_hs[i];
							if i == 1 then
								t_d_type["ntype"] = cs_hs[i+1];
							else t_d_type["ntype"] = cs_hs[i-1];
							end;
						else state["ntype"] = 0;
						end;
						if sm_hs[i] ~= nil and sm_hs[i] ~= "" then
							if sm_hs[i][3] ~= nil and sm_hs[i][3] ~= "" then
								tmpogs_n["default"] = split("/",sm_hs[i][3]);
							end;
							if string.sub(sm_hs[i][2],1,16) == profile:GetGUID() or 
							string.find(sm_hs[i][2],"^MyBest_.*") then
								state["default"] = 4;
							elseif sm_hs[i][7] == c_x_m[2] then
								state["default"] = 2;
							else state["default"] = 0;
							end;
							c_x["default"] = sm_hs[i][7];
							t_type["default"] = sm_hs[i];
							if i == 1 then
								t_d_type["default"] = sm_hs[i+1];
							else t_d_type["default"] = sm_hs[i-1];
							end;
						else state["default"] = 0;
						end;
						if coursetype and getenv("rnd_song") == 0 then
							if #rv_table > 1 then
								rank:visible(true);
							end;
							exscore:visible(true);
							--[ja] 20160214修正
							focus:visible(true);
							name:visible(true);
						end;
						if t_type[params.GSet] then
							if state[params.GSet] >= 4 then
								focus:shadowlength(2);
							else focus:shadowlength(0);
							end;
							if params.Player == PLAYER_2 then
								s_plus = 1;
							end;
							focus:setstate(state[params.GSet]+s_plus);
							rank:diffuse(color(t_type[params.GSet][6][1]));
							rank:strokecolor(color(t_type[params.GSet][6][2]));
							name:settext(string.sub(t_type[params.GSet][2],18));
							focus:glow(color("0,0,0,0"));
							name:diffuse(color(t_type[params.GSet][5]));
							rank:settext(t_type[params.GSet][1]);
							exscore:settext(t_type[params.GSet][4]);
							exscore:diffuse(color(t_type[params.GSet][5]));
							if string.find(t_type[params.GSet][2],"^MyBest_.*") then
								name:settext("MyBest".." "..FormatNumberAndSuffix(split("_",t_type[params.GSet][2])[2]));
								name:diffuse(color("0,1,1,0.7"));
								if c_x[params.GSet] > 0 then
									focus:glow(color("0.3,0.3,0,0.6"));
									name:diffuse(color("0,1,1,1"));
									exscore:diffuse(BoostColor(color(t_type[params.GSet][5]),1.5));
								else
									focus:glow(color("0,0,0.3,0.6"));
								end;
							else
								if string.sub(t_type[params.GSet][2],1,16) == profile:GetGUID() then
									if adgraph ~= "Off" and adgraph ~= "nil" then
										if coursetype and getenv("rnd_song") == 0 then
											exscore_diff:visible(true);
											exscore_diff:diffuse(color("0.75,0.75,0.75,1"));
											local t_set = t_type[params.GSet][4] - migsadhoc[params.GSet];
											if t_set ~= 0 then
												if t_set > 0 then
													exscore_diff:settext("+"..t_set);
													exscore_diff:diffuse(Colors.Count["Plus"]);
												else
													exscore_diff:settext(t_set);
													exscore_diff:diffuse(Colors.Count["Minus"]);
												end;
											end;
										end;
									end;
								else
									if state[params.GSet] == 2 then
										name:diffuse(BoostColor(color(t_type[params.GSet][5]),2));
										exscore:diffuse(BoostColor(color(t_type[params.GSet][5]),2));
									end;
								end;
							end;
							--name:settext("aaaaaaaaaaaaaaaaaaaa");
							if coursetype and getenv("rnd_song") == 0 then
								if #tmpogs_n[params.GSet] > 1 then
									local gccheck = 5;
									if GetAdhocPref("GoodCombo") ~= "TapNoteScore_W4" then
										gccheck = 4;
									end;
									if tonumber(tmpogs_n[params.GSet][2]) < gccheck then
										graph_mini:visible(true);
										if tmpogs_n[params.GSet][1] == "Grade_Tier01" then graph_m_x[params.GSet] = 6;
										elseif tmpogs_n[params.GSet][1] == "Grade_Tier02" then graph_m_x[params.GSet] = 2;
										else graph_m_x[params.GSet] = 0;
										end;
										graph_mini:diffuse(Colors.Judgment["JudgmentLine_W"..tmpogs_n[params.GSet][2]]);
										if tonumber(tmpogs_n[params.GSet][2]) <= 2 then graph_mini:glowshift();
										else graph_mini:stopeffect();
										end;
									end;
									if tonumber(string.sub(tmpogs_n[params.GSet][1],-2)) < 22 then
										grade:visible(true);
										if tonumber(string.sub(tmpogs_n[params.GSet][1],-2)) == 21 then
											grade:Load(THEME:GetPathG(g_lowpic,ToEnumShortString( "Grade_Failed" )));
										elseif tonumber(string.sub(tmpogs_n[params.GSet][1],-2)) >= 8 and tonumber(string.sub(tmpogs_n[params.GSet][1],-2)) <= 20 then
											grade:Load(THEME:GetPathG(g_lowpic,ToEnumShortString( "Grade_Tier07" )));
										else grade:Load(THEME:GetPathG(g_lowpic,ToEnumShortString( tmpogs_n[params.GSet][1] )));
										end;
									end;
								else
									if #tmpogs_n[params.GSet] > 0 then
										if tonumber(string.sub(t_type[params.GSet][3],-2)) < 22 then
											grade:visible(true);
											if tonumber(string.sub(t_type[params.GSet][3],-2)) == 21 then
												grade:Load(THEME:GetPathG(g_lowpic,ToEnumShortString( "Grade_Failed" )));
											elseif tonumber(string.sub(t_type[params.GSet][3],-2)) >= 8 and tonumber(string.sub(t_type[params.GSet][3],-2)) <= 20 then
												grade:Load(THEME:GetPathG(g_lowpic,ToEnumShortString( "Grade_Tier07" )));
											else grade:Load(THEME:GetPathG(g_lowpic,ToEnumShortString( t_type[params.GSet][3] )));
											end;
										end;
									end;
								end;
							end;
							if params.Player == PLAYER_1 then
								focus:x(4+c_x[params.GSet]);
								rank:x(60+c_x[params.GSet]);
								graph_mini:x(22+graph_m_x[params.GSet]);
								grade:x(15);
								exscore_diff:x(40);
							else
								focus:x(-4-c_x[params.GSet]);
								rank:x(-52-c_x[params.GSet]);
								graph_mini:x(-8+graph_m_x[params.GSet]);
								grade:x(-15);
								exscore_diff:x(-40);
							end;
						end;
					end;
				else self:visible(false);
				end;
			end;
		};
	end;
end;

t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(x,target_xset;y,target_y;zoom,math.min(1,WideScale(0.85,1)););
	LoadActor("t_focus")..{
		Name="f_terget";
	};
	LoadFont("_Shared2")..{
		Name="f_t_es_label";
	};
	LoadFont("_ul")..{
		Name="f_t_exscore";
	};
	OnCommand=function(self)
		local f_terget = self:GetChild('f_terget');
		local f_t_es_label = self:GetChild('f_t_es_label');
		local f_t_exscore = self:GetChild('f_t_exscore');
		(cmd(visible,false;animate,false;setstate,6;stoptweening;cropright,1;
		sleep,sleepset;decelerate,0.15;cropright,0;))(f_terget);
		if pn == PLAYER_2 then
			f_terget:setstate(7);
		end;
		(cmd(visible,false;y,-5;maxwidth,160;horizalign,hb_set;shadowlength,2;zoom,0.5;stoptweening;
		strokecolor,Color("Black");cropright,1;sleep,sleepset;decelerate,0.15;cropright,0;))(f_t_es_label);
		(cmd(visible,false;y,9;strokecolor,Color("Black");maxwidth,120;settext,0;horizalign,hb_set;shadowlength,2;
		zoom,0.375;stoptweening;cropright,1;sleep,sleepset;decelerate,0.15;cropright,0;))(f_t_exscore);
		(cmd(playcommand,"JudgeSetting",{GSet = gset,Player = pn};))(self);
	end;
	JudgeSettingMessageCommand=function(self,params)
		if params.Player ~= pn then return;
		end;
		if r_open[p] == 0 then return;
		end;
		if getenv("wheelstop") == 1 then
			(cmd(playcommand,"TableSetting",{GSet = params.GSet,Player = pn};))(self);
		end;
	end;
	TableSettingMessageCommand=function(self,params)
		if params.Player ~= pn then return;
		end;
		if r_open[p] == 0 then return;
		end;
		self:stoptweening();
		local f_terget = self:GetChild('f_terget');
		local f_t_es_label = self:GetChild('f_t_es_label');
		local f_t_exscore = self:GetChild('f_t_exscore');
		f_terget:visible(false);
		f_t_es_label:visible(false);
		f_t_exscore:visible(false);
		if getenv("wheelstop") == 1 then
			f_terget:visible(true);
			f_t_es_label:visible(true);
			if coursetype and getenv("rnd_song") == 0 then
				f_t_exscore:visible(true);
			end;
			if params.Player == PLAYER_1 then
				f_t_es_label:x(-16);
				f_t_exscore:x(-16);
			else
				f_t_es_label:x(16);
				f_t_exscore:x(16);
			end;
			if rtset ~= "Off" then
				f_t_es_label:settext(rtset);
				f_t_exscore:settext(migsadhoc[params.GSet]);
			else
				f_t_es_label:settext(notset_text);
				f_t_exscore:settext("0");
			end;
			--f_t_exscore:settext("000000000");
		end;
	end;
};

local space = 14;
local tst_width = 108;
function SetSection()
	local t = {};
	for i=1, #ttable.base do
		local ss = Def.ActorFrame {};
		ss[#ss+1]=LoadFont("_shared2") .. {
			InitCommand=cmd(playcommand,"Set";);
			DirectionButtonMessageCommand=cmd(playcommand,"Set";);
			SetCommand=function(self)
				self:strokecolor(Color("Black"));
				if ttable.base[i] ~= "Off" then
					self:settext(ttable.base[i]);
				else self:settext(notset_text);
				end;
				self:horizalign(hb_set);
				self:maxwidth(160);
			end;
		};
		t[#t+1]=ss;
	end;
	return t;
end;

t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(x,t_select_xset;y,10;);
	Def.Quad{
		OnCommand=cmd(visible,false;zoomto,tst_width,130;diffuse,color("0,0,0,0.8");fadetop,0.2;fadebottom,0.2;);
		JudgeSettingMessageCommand=function(self,params)
			if params.Player ~= pn then return;
			end;
			self:visible(false);
			if getenv("wheelstop") == 1 then
				if r_open[p] == 2 then
					self:visible(true);
				end;
			end;
		end;
	};
	Def.Quad{
		OnCommand=cmd(y,2;visible,false;zoomto,tst_width,18;diffuse,color("1,0.6,0,0.5");fadetop,0.2;fadebottom,0.2;);
		JudgeSettingMessageCommand=function(self,params)
			if params.Player ~= pn then return;
			end;
			self:visible(false);
			if getenv("wheelstop") == 1 then
				if r_open[p] == 2 then
					self:visible(true);
				end;
			end;
		end;
	};
	Def.Quad{
		Name="TopMask";
		OnCommand=cmd(y,52;zoomto,100,14;visible,false;valign,1;MaskSource);
		JudgeSettingMessageCommand=function(self,params)
			if params.Player ~= pn then return;
			end;
			self:visible(false);
			if getenv("wheelstop") == 1 then
				if r_open[p] == 2 then
					self:visible(true);
				end;
			end;
		end;
	};
	Def.ActorScroller{
		Name = 'Scroller';
		NumItemsToDraw=6;
		OnCommand=function(self)
			self:stoptweening();
			self:visible(false);
			self:clearzbuffer(true);
			self:zwrite(true);
			self:zbuffer(true);
			self:ztest(true);
			self:z(0);
			self:y(14);
			self:MaskDest();
			(cmd(SetFastCatchup,true;SetLoop,true;SetSecondsPerItem,0.001;SetDestinationItem,curIndex;))(self)
		end;
		TransformFunction=function(self, offset, itemIndex, numItems)
			self:x(t_select_sc);
			self:zoom(0.5);
			self:y(math.floor( offset*space ));
		end;
		CodeMessageCommand = function(self, params)
			self:SetDestinationItem( rtnum );
		end;
		JudgeSettingMessageCommand=function(self,params)
			if params.Player ~= pn then return;
			end;
			self:visible(false);
			if getenv("wheelstop") == 1 then
				if r_open[p] == 2 then
					self:visible(true);
				end;
			end;
		end;
		children = SetSection();
	};
	LoadFont("Common Normal") .. {
		OnCommand=cmd(y,-48;visible,false;zoom,0.5;maxwidth,194;strokecolor,Color("Black"););
		JudgeSettingMessageCommand=function(self,params)
			if params.Player ~= pn then return;
			end;
			self:settext(THEME:GetString( "ScreenWithMenuElements","HelpTextSelTarget" ));
			self:visible(false);
			if getenv("wheelstop") == 1 then
				if r_open[p] == 2 then
					self:visible(true);
				end;
			end;
		end;
	};
};

t.OnCommand=cmd(visible,tobool(r_open[p]););
t.CurrentSongChangedMessageCommand=function(self)
	SongOrCourse = "";
	self:visible(false);
	self:stoptweening();
	if getenv("wheelstop") == 1 then
		SongOrCourse = CurSOSet();
		if SongOrCourse then
			cs_hs = {};
			sm_hs = {};
			--20160824
			if getenv("exflag") == "csc" then
				self:queuecommand("On");
			end;
		end;
	end;
	r_open[p] = math.min(1,r_open[p]);
end;
t.CurrentCourseChangedMessageCommand=cmd(playcommand,"CurrentSongChangedMessage");
t.CodeMessageCommand=function(self, params)
	if params.PlayerNumber == pn then
		if getenv("wheelstop") == 1 and CurSOSet() then
			if params.Name == "RivalOpen1" or params.Name == "RivalOpen2" then
				if r_open[p] >= 0 and r_open[p] <= 1 then
					if r_open[p] == 1 then
						r_open[p] = 0;
					elseif r_open[p] == 0 then
						r_open[p] = 1;
					end;
					SOUND:PlayOnce(THEME:GetPathS("ScreenTitleMenu","change"));
					MESSAGEMAN:Broadcast("JudgeSetting",{GSet = getenv("judgesetp"..p),Player = pn});
				end;
			end;
			if params.Name == 'TargetSet1' or params.Name == 'TargetSet2' then
				if r_open[p] == 2 then
					if params.Name == 'TargetSet1' then
						if rtnum >= 1 then
							if rtnum == 1 then
								rtnum = #ttable.base;
							else rtnum = rtnum - 1;
							end;
						end;
						SOUND:PlayOnce(THEME:GetPathS("_common","value"));
					elseif params.Name == 'TargetSet2' then
						if rtnum <= #ttable.base then
							if rtnum == #ttable.base then
								rtnum = 1;
							else rtnum = rtnum + 1;
							end;
						end;
						SOUND:PlayOnce(THEME:GetPathS("_common","row"));
					end;
					rtset = ttable.base[rtnum];
					adgraph = ttable.savebase[rtnum];
					MESSAGEMAN:Broadcast("JudgeSetting",{GSet = getenv("judgesetp"..p),Player = pn});
				else r_open[p] = 1;
				end;
			elseif params.Name == 'TargetSetOpen1' or params.Name == 'TargetSetOpen2' then
				if r_open[p] > 0 then
					if r_open[p] == 2 then
						r_open[p] = 1;
					elseif r_open[p] == 1 then
						r_open[p] = 2;
					end;
					SOUND:PlayOnce(THEME:GetPathS("","_prompt"));
					MESSAGEMAN:Broadcast("JudgeSetting",{GSet = getenv("judgesetp"..p),Player = pn});
				else r_open[p] = 0;
				end;
			end;
			setenv("s_rival_op"..p,r_open[p]);
			--SCREENMAN:SystemMessage(tostring(r_open[p]));
		end;
	end;
end;
t.JudgeSettingMessageCommand=function(self,params)
	if params.Player ~= pn then return;
	end;
	self:visible(false);
	if getenv("wheelstop") == 1 then
		self:visible(tobool(r_open[p]));
	end;
end;
t.OffCommand=function(self)
	--[ja] 20160116修正
	if not IsNetConnected() then
		setenv("s_rival_op"..p,r_open[p]);
		setenv("scoregraphp"..p,adgraph);
	end;
end;
if pn == PLAYER_1 then
	t.CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"JudgeSetting",{GSet = gset,Player = pn};);
	t.CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"JudgeSetting",{GSet = gset,Player = pn};);
else
	t.CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"JudgeSetting",{GSet = gset,Player = pn};);
	t.CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"JudgeSetting",{GSet = gset,Player = pn};);
end;

local function update(self)
	local topScreenName = SCREENMAN:GetTopScreen():GetName();
	if IsNetConnected() and topScreenName == "ScreenNetSelectMusic" and getenv("gotopop") == 1 then
		setenv("gotopop",0);
		if adgraph ~= getenv("scoregraphp"..p) then
			adgraph = getenv("scoregraphp"..p);
			for h=1,#ttable.savebase do
				if adgraph == ttable.savebase[h] then
					rtset = ttable.base[h];
					rtnum = h;
					break;
				end;
			end;
			MESSAGEMAN:Broadcast("JudgeSetting",{GSet = getenv("judgesetp"..p),Player = pn});
		end;
	end;
end;

t.InitCommand=function(self)
	if IsNetConnected() then
		(cmd(SetUpdateFunction,update;))(self);
	end;
end;

return t;
