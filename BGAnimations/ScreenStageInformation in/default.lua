local t = Def.ActorFrame{};

SetAdhocPref("FrameSet",frameGetCheck());
--[ja] 選曲画面でタイムのフラグとして使います
setenv("sortflag",0);
local randomtext = THEME:GetString("MusicWheel","CustomItemRandomText");
local players = #GAMESTATE:GetHumanPlayers();
local p1diff;
local p1step;
local p2diff;
local p2step;
local SongOrCourse = CurSOSet();
local bIsCourseMode = GAMESTATE:IsCourseMode();
local StepsOrTrail = "";
local SorCDir;
local sdirs;
local style = GAMESTATE:GetCurrentStyle();
local stepsType = style:GetStepsType();
local coursetype = true;
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

--[ja] 20150407修正
if not GetAdhocPref("CComboCount") then
	SetAdhocPref("CComboCount",false);
end;

--SCREENMAN:SystemMessage(tostring(THEME:GetMetric("Gameplay","ComboIsPerRow")));

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
	--[ja] グラフを新方式に修正してセット
	local p = ( (pn == "PlayerNumber_P1") and 1 or 2 );
	local pstr = ProfIDSet(p);
	local gset = judge_initial(pstr);
	local adgraph = ProfIDPrefCheck("ScoreGraph",pstr,"Off");
	local adgstr = split("_",adgraph);
	if #adgstr > 1 then
		if adgstr[1] ~= "RIVAL" then
			SetAdhocPref("GraphType",adgstr[1],pstr);
			SetAdhocPref("ScoreGraph",string.sub(adgraph,4),pstr);
		end;
	end;
	sc_change_diff_set(pn,p);

	--[ja] オンライン用オプションセット
	if not GAMESTATE:IsExtraStage() and not GAMESTATE:IsExtraStage2() then
		local modstr = GAMESTATE:GetPlayerState(pn):GetPlayerOptionsString("ModsLevel_Preferred");
		SetAdhocPref("POptionsString_"..CurGameName(),modstr,pstr);
	end;
	sc_change_rt_set(p,"sel");
	
	local cs_hs = {};
	local sm_hs = {};
	local rf_dp = {'CS','SM'};
	local hs = {};
	hs_local_set(hs,0);
	local cpn = {1,1};
	local migsav = {0,0};
	local fcheck = 5;
	local SorCTime = 0;
	local StepsOrTrail = CurSTSet(pn);
	steps_count(hs,SongOrCourse,StepsOrTrail,pn,"Course");
	local profile;
	local pid_name;
	local scorelist;
	local scores;
	local topscore;
	local snum = 1;
	local rv_table;
	if PROFILEMAN:IsPersistentProfile(pn) then
		pid_name = PROFILEMAN:GetProfile(pn):GetGUID().."_"..PROFILEMAN:GetProfile(pn):GetDisplayName();
		rv_table = rival_table(pstr,PROFILEMAN:GetProfile(pn),pid_name);
	end;

	if SongOrCourse and StepsOrTrail then
		if bIsCourseMode then
			--20160504
			SorCTime = courselength(SongOrCourse,GAMESTATE:GetCurrentTrail(pn),stepsType);
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
				hs["SurvivalSeconds"]	= topscore:GetSurvivalSeconds();
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
			for r=1,#rv_table do
				local tmpo = "";
				local tmpogs = "";
				local tmpolts = "";
				local cr_path = "";
				local rcolor;
				if r == 1 then
					cr_path = "CSRealScore/"..pid_name.."/"..sdirs[2].."/"..sdirs[3].."/"..sdirs[4].."/set_"..wpsetd.."_"..swpsetd;
					for i, rf in ipairs(rf_dp) do
						local MIGS = 0;
						if FILEMAN:DoesFileExist( cr_path ) then
							if GetRSParameter( cr_path,stepsType.."_"..ToEnumShortString(StepsOrTrail:GetDifficulty()) .."/"..rf) ~= "" then
								tmpo = split( ":",GetRSParameter( cr_path,stepsType.."_"..ToEnumShortString(StepsOrTrail:GetDifficulty()) .."/"..rf) );
							end;
						end;
						if topscore then
							if rf == "CS" then
								MIGS = migschecker(hs,"ntype");
								hs["Grade"] = gradechecker(hs,topscore:GetGrade(),SorCTime,"ntype",fcheck);
							else
								MIGS = migschecker(hs,"default");
								hs["Grade"] = gradechecker(hs,topscore:GetGrade(),SorCTime,"default",fcheck);
							end;
						else
							if #tmpo >= 2 then
								tmpogs = split("/",tmpo[2]);
								if string.sub(tmpogs[1],1,10) == "Grade_Tier" then
									hs["Grade"] = tmpogs[1];
								end;
							end;
							MIGS = 0;
						end;
						if hs["Grade"] == "Grade_None" then
							hs["Grade"] = "Grade_Tier22";
						elseif hs["Grade"] == "Grade_Failed" then
							hs["Grade"] = "Grade_Tier21";
						end;
						if rf == "CS" then
							cs_hs[r] = { 1,pid_name,hs["Grade"].."/"..fcheck,MIGS,r };
						else sm_hs[r] = { 1,pid_name,hs["Grade"].."/"..fcheck,MIGS,r };
						end;
					end;
				else
					cr_path = "CSRealScore/"..rv_table[r].."/"..sdirs[2].."/"..sdirs[3].."/"..sdirs[4].."/set_"..wpsetd.."_"..swpsetd;
					for i, rf in ipairs(rf_dp) do
						if FILEMAN:DoesFileExist( cr_path ) then
							if GetRSParameter( cr_path,stepsType.."_"..ToEnumShortString(StepsOrTrail:GetDifficulty()) .."/"..rf) ~= "" then
								tmpo = split( ":",GetRSParameter( cr_path,stepsType.."_"..ToEnumShortString(StepsOrTrail:GetDifficulty()) .."/"..rf) );
							end;
							if #tmpo >= 3 then
								tmpogs = split("/",tmpo[2]);
								if #tmpogs > 1 then
								else
									if string.find(tmpo[2],"Grade_Tier[0-9][0-9]") then
										tmpogs[1] = tmpo[2];
									else tmpogs[1] = "Grade_Tier22";
									end;
									tmpogs[2] = "5";
								end;
								if rf == "CS" then
									cs_hs[r] = { 1,rv_table[r],tmpogs[1].."/"..tmpogs[2],tmpo[3],r };
								else sm_hs[r] = { 1,rv_table[r],tmpogs[1].."/"..tmpogs[2],tmpo[3],r };
								end;
							else
								if rf == "CS" then
									cs_hs[r] = { 1,rv_table[r],"Grade_Tier22/5",0,r };
								else sm_hs[r] = { 1,rv_table[r],"Grade_Tier22/5",0,r };
								end;
							end;
						else
							if rf == "CS" then
								cs_hs[r] = { 1,rv_table[r],"Grade_Tier22/5",0,r };
							else sm_hs[r] = { 1,rv_table[r],"Grade_Tier22/5",0,r };
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
				if coursetype then
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
								return tonumber(score1[5]) < tonumber(score2[5])
							else
								if (score1sp[2] ~= nil and score1sp[2] ~= "") and (score2sp[2] ~= nil and score2sp[2] ~= "") then
									if tonumber(score1sp[2]) == 9 or tonumber(score2sp[2]) == 9 then
										return tonumber(score1sp[2]) < tonumber(score2sp[2])
									elseif tonumber(grade1) and tonumber(grade2) then
										return tonumber(grade1) < tonumber(grade2)
									end;
								else return tonumber(score1[5]) < tonumber(score2[5])
								end;
							end
						end
					end
					return tonumber(score1[4]) > tonumber(score2[4])
				end
				return tonumber(score1[5]) < tonumber(score2[5])
			end
			local rank = 1;
			local avg_count = 0;
			local avg_total = 0;
			local sctable = {"","",0,"","",0};
			local rf_g = {"ntype","default"};
			for i, rf in ipairs(rf_g) do
				if rf == "ntype" then
					table.sort(cs_hs,
						function(a, b)
							return SortScore(a,b)
						end
					);
					
					for csr=1,#cs_hs do
						local csr_rank = split("/",cs_hs[csr][3]);
						if csr_rank[1] ~= "Grade_Tier22" then
							avg_total = avg_total + cs_hs[csr][4];
							migsav[1] = migsav[1] + cs_hs[csr][4];
							avg_count = avg_count + 1;
						end;
						if csr == 1 then
							cs_hs[csr][1] = 1;
						else 
							if tonumber(cs_hs[csr-1][4]) > tonumber(cs_hs[csr][4]) then
								rank = csr;
							end;
							cs_hs[csr][1] = rank;
						end;
						if string.sub(cs_hs[csr][2],1,16) == profile:GetGUID() then
							cpn[1] = csr;
						end;
					end;
					if avg_total > 0 and avg_count > 0 then
						migsav[1] = math.floor(avg_total / avg_count);
					end;
					
					if cs_hs[1] then
						sctable[1] = cs_hs[1][2];
						sctable[3] = migsav[1];
					end;
					if cpn[1] == 1 then
						if cs_hs[1] then
							sctable[2] = cs_hs[1][2];
						end;
					elseif cpn[1] > 1 then
						if cs_hs[cpn[1]] then
							local v = cs_hs[cpn[1]][1];
							while v > 1 do
								if cs_hs[v][1] == cs_hs[v-1][1] then
									v = v - 1;
								else
									sctable[2] = cs_hs[v-1][2];
									v = 0;
								end;
							end;
						end;
					end;
				else
					table.sort(sm_hs,
						function(a, b)
							return SortScore(a,b)
						end
					);

					for smr=1,#sm_hs do
						local smr_rank = split("/",sm_hs[smr][3])
						if smr_rank[1] ~= "Grade_Tier22" then
							avg_total = avg_total + sm_hs[smr][4];
							migsav[2] = migsav[2] + sm_hs[smr][4];
							avg_count = avg_count + 1;
						end;
						if smr == 1 then
							sm_hs[smr][1] = 1;
						else
							if tonumber(sm_hs[smr-1][4]) > tonumber(sm_hs[smr][4]) then
								rank = smr;
							end;
							sm_hs[smr][1] = rank;
						end;
						if string.sub(sm_hs[smr][2],1,16) == profile:GetGUID() then
							cpn[2] = smr;
						end;
					end;
					if avg_total > 0 and avg_count > 0 then
						migsav[2] = math.floor(avg_total / avg_count);
					end;
					
					if sm_hs[1] then
						sctable[4] = sm_hs[1][2];
						sctable[6] = migsav[2];
					end;
					if cpn[2] == 1 then
						if sm_hs[1] then
							sctable[5] = sm_hs[1][2];
						end;
					elseif cpn[2] > 1 then
						if sm_hs[cpn[2]] then
							local u = sm_hs[cpn[2]][1];
							while u > 1 do
								if sm_hs[u][1] == sm_hs[u-1][1] then
									u = u - 1;
								else
									sctable[5] = sm_hs[u-1][2];
									u = 0;
								end;
							end;
						end;
					end;
				end;
			end;
			setenv("sctable"..p,{sctable[1],sctable[2],sctable[3],sctable[4],sctable[5],sctable[6]});
			--SCREENMAN:SystemMessage(getenv("sctable"..p)[1]..","..getenv("sctable"..p)[2].."\n"..
			--getenv("sctable"..p)[3]..","..getenv("sctable"..p)[4]..","..getenv("sctable"..p)[5]..","..getenv("sctable"..p)[6]);
		end;
	end;
	--[ja] 20160116修正
	setenv("rival_c_rankp"..p,cpn);
end;
-------------------------------------------------------------------------------------------------------------------------
if getenv("omsflag") == 1 and GAMESTATE:IsExtraStage2() then
	--20170921
	setenv("rnd_song",0);
	if players == 1 then
		--expoints_reset
		local psStats = STATSMAN:GetPlayedStageStats(1);
		local sys_group = "";
		local cscpoint = 0;
		local ccstpoint = getenv("ccstpoint");
		

		if psStats then
			sys_group = psStats:GetPlayedSongs()[1]:GetGroupName();
		end;

		local txt_folders = GetGroupParameter(sys_group,"Extra1List");
		local chk_folders = "";
		if txt_folders ~= "" then
			chk_folders = split(":",txt_folders);
		end;
		local songst = getenv("songst");
		local pn;
		if GAMESTATE:IsHumanPlayer(PLAYER_1) then pn = PLAYER_1;
		else pn = PLAYER_2;
		end;
		local p = (pn == PLAYER_1) and 1 or 2;
		local playername = GetAdhocPref("ProfIDSetP"..p);
		if GetAdhocPref("P_ADCheck") ~= "OK" then
			playername = GAMESTATE:GetPlayerDisplayName(pn);
		end;
		local cs_path = "CSDataSave/"..playername.."_Save/0000_co "..sys_group.."";
		function GetCSCCount()
			local pointtext = {};
			local sys_songc = "";
			if GetCSCParameter(sys_group,"Status",playername) ~= "" then
				sys_songc = split(":",GetCSCParameter(sys_group,"Status",playername));
			end;
			local sys_spoint;
			for k=1, #chk_folders do
				if FILEMAN:DoesFileExist( cs_path ) then
					if chk_folders[k] == songst then
						--#sys_songc < #chk_folders == nil
						if sys_songc[k] ~= nil and sys_songc[k] ~= "" then
							pointtext[#pointtext+1] = { ""..songst..",0:" };
						else
							pointtext[#pointtext+1] = { ""..chk_folders[k]..",0:" };
						end;
					else
						pointtext[#pointtext+1] = { ""..chk_folders[k]..",0:" };
					end;
				else
					if chk_folders[k] == songst then
						pointtext[#pointtext+1] = { ""..songst..",0:" };
					else
						pointtext[#pointtext+1] = { ""..chk_folders[k]..",0:" };
					end;
				end;
			end;
			return pointtext;
		end;
		
		local CSCList = GetCSCCount();
		local csctext = "#Status:";

		for i=1, #chk_folders do
			if CSCList[i] then
				csctext = csctext..""..table.concat(CSCList[i]);
			else
				csctext = csctext;
			end;
		end;
		csctext = string.sub(csctext,1,-2);
		csctext = csctext..";\r\n";
		File.Write( cs_path , csctext );

		local diffsetcrs = "Difficulty_Hard";
		local extracrs = OpenFile("/Songs/".. sys_group .."/extra2.crs")
		if not extracrs then
			extracrs = OpenFile("/AdditionalSongs/".. sys_group .."/extra2.crs")
		end
		if extracrs then
			local exsong = GetFileParameter(extracrs ,"song");
			local exu = "";
			local exs = "";
			if exsong ~= "" then
				exu = string.lower(exsong);
				exs = split(":",exu)[2];
				diffsetcrs = OldStyleStringToDifficulty(exs);
			end;
		end;
		CloseFile(extracrs);
		
		local bExtra2 = GAMESTATE:IsExtraStage2();
		local style = style;
		local song, steps = SONGMAN:GetExtraStageInfo( bExtra2, style );

		-- [ja] 楽曲情報文字列 (#ExtraXSongsの中身)
		-- [ja] gsongはgroup、songはcrs。正しい区別を
		local txt_folders = GetGroupParameter(sys_group,"Extra2List");
		local chk_folders = "";
		if txt_folders ~= "" then
			chk_folders = split(":",txt_folders);
		end;
		local gsong;
		--[ja] 20150411修正 フォルダ曲を全部回して有効なStepがある曲を設定。初めに書いてあるのが優先なのは今までどおり
		-- [ja] group曲とgroup曲のstep定義
		if #chk_folders > 0 then
			local diffacheck = false;
			for ch = 1,#chk_folders do
				gsong = GetFolder2Song(sys_group,chk_folders[ch]);
				if gsong then
					if #gsong:GetStepsByStepsType(stepsType) > 0 then
						local newstep = nil;
						if GetGroupParameter(sys_group,"Extra2Difficulty") ~= "" then
							local sys_difficulty = split(":",string.lower(GetGroupParameter(sys_group,"Extra2Difficulty")));
							if sys_difficulty[1] ~= "" then
								local diffset = "";
								if sys_difficulty[1] == "beginner" then diffset = "Difficulty_Beginner";
								elseif sys_difficulty[1] == "easy" then diffset = "Difficulty_Easy";
								elseif sys_difficulty[1] == "medium" then diffset = "Difficulty_Medium";
								elseif sys_difficulty[1] == "hard" then diffset = "Difficulty_Hard";
								elseif sys_difficulty[1] == "challenge" then diffset = "Difficulty_Challenge";
								end;
								if diffset ~= "" then
									newstep = gsong:GetOneSteps(stepsType,diffset);
								end;
							end;
						end;
						if newstep then
							GAMESTATE:SetCurrentSong(gsong);
							GAMESTATE:SetCurrentSteps('PlayerNumber_P'..p,newstep);
							diffacheck = true;
						end;
						--Trace("diffacheck1 :"..tostring(diffacheck));
						if not diffacheck then
							newstep = nil;
							local diffaset = {
								"Difficulty_Hard",
								"Difficulty_Challenge",
								"Difficulty_Medium",
								"Difficulty_Easy",
								"Difficulty_Beginner",
							};
							for di = 1,#diffaset do
								newstep = gsong:GetOneSteps(stepsType,diffaset[di]);
								if newstep then
									GAMESTATE:SetCurrentSong(gsong);
									GAMESTATE:SetCurrentSteps('PlayerNumber_P'..p,newstep);
									diffacheck = true;
									break;
								end;
							end;
						end;
						--Trace("diffacheck2 :"..tostring(diffacheck));
						if diffacheck then
							break;
						end;
					end;
				end;
			end;
			--Trace("diffacheck3 :"..tostring(diffacheck));
			if not diffacheck then
				-- [ja] crs曲とcrs曲のstep定義
				GAMESTATE:SetCurrentSong(song);
				GAMESTATE:SetCurrentSteps('PlayerNumber_P'..p,steps);
			end;
		else
			-- [ja] crs曲とcrs曲のstep定義
			GAMESTATE:SetCurrentSong(song);
			GAMESTATE:SetCurrentSteps('PlayerNumber_P'..p,steps);
		end;
		
		-- [ja] omsフラグの時のライフ設定
		-- [ja] ゲージの状態を指定（この時点では定義だけで、実際には反映されない） 
		local exlife = GetGroupParameter(sys_group,"Extra2LifeLevel");

		if string.lower(exlife)=="hard" then
			setenv("ExLifeLevel","Hard");
		elseif string.lower(exlife)=="1" then
			setenv("ExLifeLevel","1");
		elseif string.lower(exlife)=="2" then
			setenv("ExLifeLevel","2");
		elseif string.lower(exlife)=="3" then
			setenv("ExLifeLevel","3");
		elseif string.lower(exlife)=="4" then
			setenv("ExLifeLevel","4");
		elseif string.lower(exlife)=="5" then
			setenv("ExLifeLevel","5");
		elseif string.lower(exlife)=="6" then
			setenv("ExLifeLevel","6");
		elseif string.lower(exlife)=="7" then
			setenv("ExLifeLevel","7");
		elseif string.lower(exlife)=="8" then
			setenv("ExLifeLevel","8");
		elseif string.lower(exlife)=="9" then
			setenv("ExLifeLevel","9");
		elseif string.lower(exlife)=="10" then
			setenv("ExLifeLevel","10");
		elseif string.lower(exlife)=="pfc" or string.lower(exlife)=="w2fc" then
			setenv("ExLifeLevel","PFC");
		elseif string.lower(exlife)=="mfc" or string.lower(exlife)=="w1fc" then
			setenv("ExLifeLevel","MFC");
		elseif string.lower(exlife)=="hardnorecover" or string.lower(exlife)=="hex1" then
			setenv("ExLifeLevel","HardNoRecover");
		elseif string.lower(exlife)=="norecover" or string.lower(exlife)=="ex1" then
			setenv("ExLifeLevel","NoRecover");
		elseif string.lower(exlife)=="suddendeath" or string.lower(exlife)=="ex2" then
			setenv("ExLifeLevel","Suddendeath");
		else
			setenv("ExLifeLevel","Normal");
		end;
		-- [ja] 強制的に現在の設定を反映させることでEXステージでもプレイヤーオプションが初期化されない
		for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
			local ps = GAMESTATE:GetPlayerState(pn);
			local modstr = "default, " .. ps:GetPlayerOptionsString("ModsLevel_Stage");
			ps:SetPlayerOptions("ModsLevel_Stage", modstr);
			MESSAGEMAN:Broadcast( "PlayerOptionsChanged", {PlayerNumber = pn} )
		end
		--EXFolderLifeSetting();
	end;
end;

-- [ja] CSフラグの時のライフ設定
if getenv("exflag") == "csc" then
	-- [ja] 強制的に現在の設定を反映させることでEXステージでもプレイヤーオプションが初期化されない
	for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
		local ps = GAMESTATE:GetPlayerState(pn);
		local modstr = "default, " .. ps:GetPlayerOptionsString("ModsLevel_Stage");
		ps:SetPlayerOptions("ModsLevel_Stage", modstr);
		MESSAGEMAN:Broadcast( "PlayerOptionsChanged", {PlayerNumber = pn} )
	end
	--EXFolderLifeSetting();
end;

-------------------------------------------------------------------------------------------------------------------------
local sjacketPath ,sbannerpath ,scdimagepath, cbannerpath;
if bIsCourseMode then
	cbannerpath = SongOrCourse:GetBannerPath();
else
	sbannerpath = SongOrCourse:GetBannerPath();
	sjacketpath = SongOrCourse:GetJacketPath();
	scdimagepath = SongOrCourse:GetCDImagePath();
end;

--[ja] ランダム選曲
setenv("rsong","");
--[ja] 20160818 ソートを変えてから選曲画面に戻るとこの辺が悪さをして強制終了するため対策
if not IsNetConnected() then
	if getenv("wheelsectioncsc") == randomtext or (getenv("rnd_song") == 1 and getenv("exflag") ~= "csc") then
		if getenv("rnd_song") == 1 then
			local sset;
			local groupname = SongOrCourse:GetGroupName();
			local brlist = GetGroupParameter(groupname,"BranchList");
			if b_s_pr(brlist,SongOrCourse,"Random") then
				sset = b_s_pr(brlist,SongOrCourse,"Random");
				local ssset = sset[math.random(#sset)];
				local newstep = nil;
				GAMESTATE:SetCurrentSong(GetFolder2Song(groupname,ssset));
				SongOrCourse = CurSOSet();
			end;
		end;
		local songu = string.lower(SongOrCourse:GetSongDir());
		local songDir
		--[ja] 20150414修正
		if string.find(songu,"^/additionalsongs/") then
			songDir = string.gsub(songu,"^/additionalsongs/","");
		else songDir = string.gsub(songu,"^/songs/","");
		end;
		setenv("rsong",songDir);
		--SCREENMAN:SystemMessage(getenv("rsong"));
	--[ja] 難易度セット Branchソートなどの時に必ず必要
		local setdiff = {
			'Difficulty_Challenge',
			'Difficulty_Hard',
			'Difficulty_Medium',
			'Difficulty_Easy',
			'Difficulty_Beginner'
		};
	--20180210
		local ss = SongOrCourse:GetStepsByStepsType( stepsType );
		for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
			local p = (pn == PLAYER_1) and 1 or 2;
			local pstep;
			local pstr = ProfIDSet(p);
			local pdiff = ProfIDPrefCheck("ProfCDifficulty",pstr,"Difficulty_Beginner");
			if pdiff == 'Difficulty_Beginner' or pdiff == 'Difficulty_Easy' or pdiff == 'Difficulty_Medium' or 
			pdiff == 'Difficulty_Hard' or pdiff == 'Difficulty_Challenge' then
				pstep = SongOrCourse:GetOneSteps(stepsType,pdiff);
			else
				for o,s in pairs(ss) do
					if s:GetDifficulty() == 'Difficulty_Edit' then
						if GAMESTATE:GetCurrentSteps(pn):GetDescription() == s:GetDescription() then
							pstep = s;
							break;
						end;
					end;
				end;
				if not pstep then
					for i,j in pairs(setdiff) do
						if SongOrCourse:GetOneSteps(stepsType,j) then
							pstep = SongOrCourse:GetOneSteps(stepsType,j);
							break;
						end;
					end;
				end;
			end;
			if pn and pstep then
				GAMESTATE:SetCurrentSteps(pn,pstep);
			end;
		end;
	end;
end;

t[#t+1] = Def.ActorFrame{
	OnCommand=function(self)
		if getenv("omsflag") == 0 then
			if getenv("exflag") == "csc" then
				SOUND:PlayOnce(THEME:GetPathS("","_csstagedecide"));
			else
				SOUND:PlayOnce(THEME:GetPathS("","_stagedecide"));
			end;
		end
	end;
	LoadActor("stagesongback_effect")..{
	};
	LoadActor("stageback_effect")..{
	};
	
	Def.Quad{
		OnCommand=cmd(FullScreen;Center;diffuse,color("0,0,0");diffusealpha,1;linear,0.2;diffusealpha,0;);
	};
};

local showjacket = GetAdhocPref("WheelGraphics");
if showjacket ~= "Off" then
	if bIsCourseMode then
		if SongOrCourse:HasBanner() then
			if string.find(cbannerpath,"jacket") then
				t[#t+1] = LoadActor("jacket")..{};
			else
				t[#t+1] = LoadActor("banner")..{};
			end;
		else
			t[#t+1] = LoadActor("jacket")..{};
		end;
	else
		if (not SongOrCourse:HasBanner() and (SongOrCourse:HasJacket() or SongOrCourse:HasCDImage())) then
			t[#t+1] = LoadActor("jacket")..{};
		elseif SongOrCourse:HasBanner() and (SongOrCourse:HasJacket() or SongOrCourse:HasCDImage()) then
			t[#t+1] = LoadActor("plus")..{};
		elseif SongOrCourse:HasBanner() and not SongOrCourse:HasJacket() and not SongOrCourse:HasCDImage() then
			t[#t+1] = LoadActor("banner")..{};
		else
			t[#t+1] = LoadActor("jacket")..{};
		end;
	end;
else
	t[#t+1] = LoadActor("banner")..{};
end;
	
t[#t+1] = LoadActor("songtitle")..{
};

if not IsNetConnected() then
	t[#t+1] = LoadActor("stageregular_effect")..{
	};
end;

t[#t+1] = Def.ActorFrame{
	LoadActor("mode")..{
	};
	
	LoadActor("difficulty")..{
	};
};

--[ja] 20160818 ソートを変えてから選曲画面に戻るとこの辺が悪さをして強制終了するため対策
if not IsNetConnected() then
	if getenv("omsflag") == 1 and GAMESTATE:IsExtraStage2() then
		local co = getenv("cpoint");
		t[#t+1] = Def.ActorFrame{
			OnCommand=cmd(x,SCREEN_LEFT+60;y,SCREEN_TOP+140;zoom,2.5;sleep,2.5;linear,0.2;zoomy,0;);
			LoadFont("CourseEntryDisplay","number") .. {
				OnCommand=cmd(diffuse,color("0,1,1,1");strokecolor,color("0,0.4,0.4,1");blend,'BlendMode_Add';
							diffusealpha,0.5;horizalign,left;skewx,-0.5;maxwidth,80;sleep,0.5;linear,0.2;playcommand,"Count";);
				CountCommand=function(self)
					local ccount = getenv("cpoint")
					self:sleep(1.4/ccount);
					self:settext(co);
					co = co - 1;
					if co >= 0 then
						self:queuecommand("Count");
					end;
				end;
			};
		};
	end;

	--[ja] 20160124修正
	if SongOrCourse then
		if not bIsCourseMode and not GAMESTATE:IsExtraStage2() then
			GAMESTATE:SetPreferredSong(SongOrCourse);
			GAMESTATE:SetPreferredSongGroup(SongOrCourse:GetGroupName()); 
			for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
				GAMESTATE:SetPreferredDifficulty(pn,GAMESTATE:GetCurrentSteps(pn):GetDifficulty());
			end;
		end;
	end;
end;

return t;