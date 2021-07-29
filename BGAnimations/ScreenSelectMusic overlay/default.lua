--[[ScreenSelectMusic overlay]]
--20160821
local t = Def.ActorFrame{};
local key_count = 0;
local v2_key_set = 1;
local csc_key_set = 1;
local csctext = THEME:GetString("MusicWheel","CustomItemCSCText");
local randomtext = THEME:GetString("MusicWheel","CustomItemRandomText");
local bSSetting = GetAdhocPref("CustomSpeed");

local bpmDivision = THEME:GetMetric("MusicWheel", "SortBPMDivision");
local lengthDivision = THEME:GetMetric("MusicWheel", "SortLengthDivision");
local popsetn = THEME:GetMetric("MusicWheel", "MostPlayedSongsToShow");
local recsetn = THEME:GetMetric("MusicWheel", "RecentSongsToShow");
local n_set_s = 0;

function rcindex()
	local gsetc = split(",",GetAdhocPref("SortGsetCheck"));
	local sortset = sortmenuset(gsetc[1],ProfIDSet(csort_pset()));
	local curIndex = 1;
	for i=1, #sortset do
		if getenv("SortCh") == sortset[i] then
			curIndex = i;
			return sortset[curIndex]
		end;
	end;
end;

if GAMESTATE:GetCurrentStage() == "Stage_Final" or GAMESTATE:IsExtraStage() then
	PREFSMAN:SetPreference("AllowExtraStage",GetAdhocPref("envAllowExtraStage"));
end;
setenv("exflag","");
local limit = getenv("Timer") + 1;
local pm = GAMESTATE:GetPlayMode();
local eset = false;
local gsetc = split(",",GetAdhocPref("SortGsetCheck"));
local sctext = getenv("SortCh");
if GAMESTATE:GetCurrentStyle() then
local st = GAMESTATE:GetCurrentStyle():GetStepsType();
end;
local mt = GetAdhocPref("UserMeterType");
local musicwheel;
local mindex = 0;

if vcheck() ~= "5_2_0" then
	if tonumber(getenv("ReloadFlag")[1]) == 0 then
		--20171229
		tp_gr_grade_set();
		SortSetting(getenv("SortCh"),ProfIDSet(csort_pset()));
		--SCREENMAN:SystemMessage(getenv("ReloadFlag")[1]);
	else
		--SCREENMAN:SystemMessage(getenv("ReloadFlag")[1]);
		setenv("ReloadFlag",{0,0});
	end;
else
	if tonumber(getenv("ReloadFlag")[1]) <= 1 then
		if rcindex() == "Group" then
			SONGMAN:SetPreferredSongs("Main_New.txt");
		end;
		--20171229
		tp_gr_grade_set();
		t[#t+1] = Def.ActorFrame{
			OnCommand=function(self)
				--SCREENMAN:SystemMessage(getenv("SortCh"));
				if SCREENMAN:GetTopScreen() then
					musicwheel = SCREENMAN:GetTopScreen():GetChild('MusicWheel');
				end;
				if musicwheel then
					SortSetting(rcindex(),ProfIDSet(csort_pset()),musicwheel);
					if tonumber(getenv("ReloadFlag")[1]) == 0 then
						musicwheel:Move(1);
						musicwheel:Move(-1);
						musicwheel:Move(0);
					end;
				end;
			end;

		};
	end;
	if tonumber(getenv("ReloadFlag")[1]) > 0 then
		setenv("ReloadFlag",{0,0});
	end;
end;

local p_check = {2,2,0};
for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
	local p = (pn == PLAYER_1) and 1 or 2;
	p_check[p] = 0;
end;

if not IsNetConnected() then
	if pm == "PlayMode_Battle" or pm == "PlayMode_Rave" then
		local so = GAMESTATE:GetDefaultSongOptions();
		GAMESTATE:SetSongOptions( "ModsLevel_Stage", so );
		MESSAGEMAN:Broadcast( "SongOptionsChanged" );
	elseif not GAMESTATE:IsCourseMode() then
		if GAMESTATE:IsAnExtraStage() then
			local bExtra2 = GAMESTATE:IsExtraStage2();
			local bExtra = GAMESTATE:IsExtraStage();

			local ssStats;
			if bExtra2 then
				ssStats = STATSMAN:GetPlayedStageStats(2);
			elseif bExtra then
				ssStats = STATSMAN:GetPlayedStageStats(1);
			end;
			local ssSong = ssStats:GetPlayedSongs()[1];

			if GAMESTATE:GetPreferredSongGroup() == "---Group All---" then
				setenv("SortCh","Group");
				if vcheck() ~= "5_2_0" then
					GAMESTATE:ApplyGameCommand("sort,Preferred");
				end;
				SONGMAN:SetPreferredSongs("Group_New.txt");
				GAMESTATE:SetPreferredSongGroup( ssSong:GetGroupName() );
			end;

			local style = GAMESTATE:GetCurrentStyle();
			local song, steps = SONGMAN:GetExtraStageInfo( bExtra2, style );
			local po, so;
			local defaultmods;
			local extracrs;
			--[ja] 20150302修正
			if bExtra2 then
				extracrs = OpenFile("/Songs/".. ssSong:GetGroupName() .."/extra2.crs");
				if not extracrs then
					extracrs = OpenFile("/AdditionalSongs/".. ssSong:GetGroupName() .."/extra2.crs");
				end;
				defaultmods = "OMESStageModifiers";
			else
				extracrs = OpenFile("/Songs/".. ssSong:GetGroupName() .."/extra1.crs");
				if not extracrs then
					extracrs = OpenFile("/AdditionalSongs/".. ssSong:GetGroupName() .."/extra1.crs");
				end;
				defaultmods = "ExtraStageStageModifiers";
				
				--[ja] ScreenSelectMusic BannerFrame/songinfotitleから移動(20150120)
				local extrast = "";
				if ssStats then
					setenv("Ex1crsCheckSelMusic",Ex1crsCheckSelMusic(ssSong));
				end;
			end;
			if extracrs then
				local exsong = GetFileParameter(extracrs ,"song");
				local exu = "";
				local exs = "";
				local exs_oDir = "";
				local exsgDir = "";
				local exsDir = "";
				if exsong ~= "" then
					exu = string.lower(exsong);
					exs = split(":",exsong)[1];
					if string.find(exs,"\\") then exs_oDir = split("\\",exs);
					else exs_oDir = split("/",exs);
					end;
					exsgDir = exs_oDir[1];
					exsDir = exs_oDir[2];
					if exs_oDir[1] == "" then
						exsgDir = exs_oDir[2]
						exsDir = exs_oDir[3]
					end;
				end;
				-- [ja] 指定先の曲が無い場合のチェックができていなかったので修正(20150302)
				if GetFolder2Song(exsgDir,exsDir) then
					GAMESTATE:SetCurrentSong( GetFolder2Song(exsgDir,exsDir) );
					GAMESTATE:SetPreferredSong( GetFolder2Song(exsgDir,exsDir) );
					GAMESTATE:SetPreferredSongGroup( GetFolder2Song(exsgDir,exsDir):GetGroupName() );
				elseif GetSongName2Song(ssSong:GetGroupName(),exs) then
					GAMESTATE:SetCurrentSong( GetSongName2Song(ssSong:GetGroupName(),exs) );
					GAMESTATE:SetPreferredSong( GetSongName2Song(ssSong:GetGroupName(),exs) );
					GAMESTATE:SetPreferredSongGroup( GetSongName2Song(ssSong:GetGroupName(),exs):GetGroupName() );
				else
					GAMESTATE:SetCurrentSong( song );
					GAMESTATE:SetPreferredSong( song );
					GAMESTATE:SetPreferredSongGroup( song:GetGroupName() );
				end;

				local opt = split(":",exu)[3];
				local gain = GetFileParameter(extracrs,"gainseconds");
				local life = GetFileParameter(extracrs,"lives");
				local dtype = "DrainType_SuddenDeath";
				if bExtra then
					dtype = "DrainType_NoRecover";
				end;
				--Trace("life : "..life);
				--20161123
				if opt ~= nil then
					if vcheck() then
						if string.find(opt,"norecover",0,true) then
							dtype = "DrainType_NoRecover";
						elseif string.find(opt,"suddendeath",0,true) then
							dtype = "DrainType_SuddenDeath";
						end;
					end;
					opt = string.gsub(opt ,",",", ");
					opt = ", "..opt;
				else opt = "";
				end;
				CloseFile(extracrs);
				for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
					local ps = GAMESTATE:GetPlayerState(pn);
					po = "default, " .. ps:GetPlayerOptionsString("ModsLevel_Preferred") .. opt;
					ps:SetPlayerOptions("ModsLevel_Preferred", po);
					ps:SetPlayerOptions('ModsLevel_Song', po);
					if vcheck() then
						ps:GetPlayerOptions("ModsLevel_Preferred"):FailSetting("FailType_Immediate");
						ps:GetPlayerOptions("ModsLevel_Song"):FailSetting("FailType_Immediate");
						if gain ~= "" then
							ps:GetPlayerOptions("ModsLevel_Preferred"):DrainSetting("DrainType_Normal");
							ps:GetPlayerOptions("ModsLevel_Song"):DrainSetting("DrainType_Normal");
							ps:GetPlayerOptions("ModsLevel_Preferred"):LifeSetting("LifeType_Time");
							ps:GetPlayerOptions("ModsLevel_Song"):LifeSetting("LifeType_Time");
						--20170617
						elseif (life ~= "" and life ~= 0) or string.find(opt,"battery",0,true) then
							ps:GetPlayerOptions("ModsLevel_Preferred"):DrainSetting("DrainType_Normal");
							ps:GetPlayerOptions("ModsLevel_Song"):DrainSetting("DrainType_Normal");
							ps:GetPlayerOptions("ModsLevel_Preferred"):LifeSetting("LifeType_Battery");
							ps:GetPlayerOptions("ModsLevel_Song"):LifeSetting("LifeType_Battery");
							ps:GetPlayerOptions("ModsLevel_Preferred"):BatteryLives(life);
							ps:GetPlayerOptions("ModsLevel_Song"):BatteryLives(life);
						else
							ps:GetPlayerOptions("ModsLevel_Preferred"):LifeSetting("LifeType_Bar");
							ps:GetPlayerOptions("ModsLevel_Song"):LifeSetting("LifeType_Bar");
							ps:GetPlayerOptions("ModsLevel_Preferred"):DrainSetting(dtype);
							ps:GetPlayerOptions("ModsLevel_Song"):DrainSetting(dtype);
						end;
					end;
					MESSAGEMAN:Broadcast( "PlayerOptionsChanged", {PlayerNumber = pn} )
				end;
				--GAMESTATE:SetSongOptions( "ModsLevel_Stage", so );
			else
				for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
					local ps = GAMESTATE:GetPlayerState(pn);
					po = "default, " .. ps:GetPlayerOptionsString("ModsLevel_Preferred");
					ps:SetPlayerOptions("ModsLevel_Preferred", po);
					ps:SetPlayerOptions('ModsLevel_Song', po);
					MESSAGEMAN:Broadcast( "PlayerOptionsChanged", {PlayerNumber = pn} )
				end;
				so = THEME:GetMetric("SongManager",defaultmods);
				GAMESTATE:SetCurrentSong( song );
				GAMESTATE:SetPreferredSong( song );
				GAMESTATE:SetPreferredSongGroup( song:GetGroupName() );
			end

			local difficulty = steps:GetDifficulty()
			local Reverse = PlayerNumber:Reverse()

			for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
				--[ja] ↓AutoSetStyleがOFFの時、2重にStyleがセットされてしまう問題の対策
		--[[
				if THEME:GetMetric("Common","AutoSetStyle") == true then
					GAMESTATE:SetCurrentSteps( pn, steps );
				end
		]]
				GAMESTATE:SetCurrentSteps( pn, steps );
				--[ja] 20150718修正
				local p = (pn == PLAYER_1) and 1 or 2;
				local pstr = ProfIDSet(p);
				difficulty = ProfIDPrefCheck("ProfCDifficulty",pstr,difficulty);
				if string.find(sctext,"^.*Meter") then
					difficulty = "Difficulty_"..string.sub(sctext,1,-6);
				elseif string.find(sctext,"^TopGrades.*") then
					if tonumber(string.sub(sctext,-1)) == p then
						difficulty = "Difficulty_"..string.sub(sctext,10,-3);
					end;
				end;
				GAMESTATE:SetPreferredDifficulty( pn, difficulty )
				MESSAGEMAN:Broadcast( "PlayerOptionsChanged", {PlayerNumber = pn} );
			end

			--GAMESTATE:SetSongOptions( "ModsLevel_Stage", so );
			MESSAGEMAN:Broadcast( "SongOptionsChanged" );
		else
			--[ja] Fail設定
			SetFail();
			for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
				--[ja] 20150718修正
				local p = (pn == PLAYER_1) and 1 or 2;
				local pstr = ProfIDSet(p);
				local diff_s = ProfIDPrefCheck("ProfCDifficulty",pstr,"Difficulty_Beginner");
				if string.find(sctext,"^.*Meter") then
					diff_s = "Difficulty_"..string.sub(sctext,1,-6);
				elseif string.find(sctext,"^TopGrades.*") then
					if tonumber(string.sub(sctext,-1)) == p then
						diff_s = "Difficulty_"..string.sub(sctext,10,-3);
					end;
				end;
				GAMESTATE:SetPreferredDifficulty( pn, diff_s );
			end;
		end;
	end;
end;

if not GAMESTATE:IsExtraStage2() then
	t[#t+1] = wheel_movecursor();
end;

t[#t+1] = Def.ActorFrame{
	EnvSetCommand=function(self)
		SCREENMAN:SetNewScreen("ScreenCSOpen");
	end;
	OffCommand=function(self)
		setenv("ReloadAnimFlag",0);
	end;
};

--selsort
if not GAMESTATE:IsCourseMode() and not IsNetConnected() then
	t[#t+1] = Def.ActorFrame{
		CodeMessageCommand=function(self,params)
			if not GAMESTATE:IsExtraStage2() then
				if v2_key_set == 1 then
					if params.Name == "SelectSort1" or params.Name == "SelectSort2" or 
					params.Name == "SelectSort3" or params.Name == "SelectSort4" then
						if params.PlayerNumber == PLAYER_1 then
							gsetc[1] = "P1";
						else gsetc[1] = "P2";
						end;
						SetAdhocPref("SortGsetCheck",gsetc[1]..","..gsetc[2]);
						MESSAGEMAN:Broadcast("V2SortSet");
					end;
				end;
			end;
		end;
		V2SortSetMessageCommand=function(self)
			SCREENMAN:AddNewScreenToTop("ScreenV2Sort");
		end;
		MiniMenuCSCSetMessageCommand=function(self)
			SCREENMAN:AddNewScreenToTop("ScreenMiniMenuCSC");
		end;

		Def.ActorFrame{
			SelectOMessageCommand=cmd(stoptweening;linear,1.75;queuecommand,"NextScreenP");
			ShowEOMessageCommand=cmd(stoptweening;queuecommand,"NextScreenP");
			NextScreenPCommand=function(self)
				MESSAGEMAN:Broadcast("HidePSFO");
				(cmd(stoptweening;linear,0.125;queuecommand,"NextScreen"))(self)
			end;
			NextScreenCommand=function(self)
				--[ja] 選択している難易度・選択しているソート・開いているセクションを判別してその中からランダム曲を決定するシステム
				--[ja] 名づけてでそせらくん
				--[ja] 20160125修正
				local curStyle = GAMESTATE:GetCurrentStyle();
				local stepsType = curStyle:GetStepsType();
				local cmtdiff = string.gsub(sctext,"Meter","");
				local so = GAMESTATE:GetSortOrder();
				local expsc = GAMESTATE:GetExpandedSectionName();
				local diff_s_num = {
					Difficulty_Beginner	= 1,
					Difficulty_Easy		= 1,
					Difficulty_Medium	= 1,
					Difficulty_Hard		= 2,
					Difficulty_Challenge	= 2
				};
				local diff = {
					{
						'Difficulty_Beginner',
						'Difficulty_Easy',
						'Difficulty_Medium',
						'Difficulty_Hard',
						'Difficulty_Challenge'
					},
					{
						'Difficulty_Challenge',
						'Difficulty_Hard',
						'Difficulty_Medium',
						'Difficulty_Easy',
						'Difficulty_Beginner'
					}
				};
				local allSongs = SONGMAN:GetAllSongs();
				local d_n_table = {};
				local d_s_table = {};
				local jt_set = {"PlayerNumber_P1","ntype"};
				if gsetc[1] ~= "P1" then
					jt_set[1] = "PlayerNumber_P2";
				end;
				if gsetc[2] ~= "ntype" then
					jt_set[2] = "default";
				end;
				local rsetting;
				local profile = c_profile(jt_set[1]);
				local atable = {};
				local stable = {};
				if so then
					local sort = ToEnumShortString(so);
					if sort == "Popularity" then
						--[ja] 選択できない曲で順位が50位以降にずれてしまう場合の対策
						local pos = {1,tonumber(popsetn)};
						while true do
							if SONGMAN:GetPopularSongs()[pos[1]]:HasStepsType(stepsType) then
								stable[#stable+1] = SONGMAN:GetPopularSongs()[pos[1]];
								--Trace("PSong"..pos[1].." : "..SONGMAN:GetPopularSongs()[pos[1]]:GetSongDir());
							else pos[2] = pos[2] + 1;
							end;
							pos[1] = pos[1] + 1;
							if pos[1] > pos[2] then
								break;
							end;
						end;
						allSongs = stable;
					elseif sort == "Preferred" then
						rsetting = rsettingset(sctext);
					end;
				end;
				
				if rsetting then
					--[ja] カスタム・分岐曲ソート
					--[ja] Open : そのセクションから
					--[ja] Close : このソートの曲の中から
					local f = RageFileUtil.CreateRageFile();
					f:Open(rsetting,1);
					f:Seek(0);
					local l;
					local seccheck = 1;
					while true do
						l=f:GetLine();
						local ll=string.lower(l);
						if f:AtEOF() then
							seccheck = 0;
						else
							if expsc ~= "" and string.find(ll,"^---%s?.*"..string.lower(expsc).."") then
								seccheck = 2;
							end;
						end;
						--Trace("seccheck : "..seccheck);
						if seccheck > 0 then
							local ssp = split("/",l);
							if seccheck == 2 then
								if GetFolder2Song(ssp[1],ssp[2]) then
									stable[#stable+1] = GetFolder2Song(ssp[1],ssp[2]);
								end;
								if string.find(ll,"^---%s?") then
									if not string.find(ll,"^---%s?.*"..string.lower(expsc).."") then
										seccheck = 0;
									end;
								end;
							else
								if GetFolder2Song(ssp[1],ssp[2]) then
									atable[#atable+1] = GetFolder2Song(ssp[1],ssp[2]);
								end;
							end;
						else break;
						end;
					end;
					f:Close();
					f:destroy();
					
					if #stable > 0 then
						allSongs = stable;
						--Trace("stable : "..#allSongs);
					else
						allSongs = atable;
						--Trace("atable : "..#allSongs);
					end;
				end;
				
				for t=1, #allSongs do
					local mcheck = false;
					if n_set_s == 1 then
						mcheck = true;
					else
						if so then
							local sort = ToEnumShortString(so);
							--if sort == "Recent" then
								--[ja] 履歴ソート
								--[ja] 全曲
							if sort == "Popularity" then
								--[ja] 人気度ソート
								--[ja] このソートの曲の中から
								mcheck = true;
							else
								if sort == "Preferred" then
									if rsetting then
										mcheck = true;
									else
										if string.find(sctext,"^Group$") then
											--[ja] グループソート
											--[ja] Open : そのセクションから
											--[ja] Close : 全曲
											if expsc ~= "" then
												if string.upper(allSongs[t]:GetGroupName()) == string.upper(expsc) then
													mcheck = true;
												end;
											else mcheck = true;
											end;
										elseif string.find(sctext,"^.*Meter") then
											--[ja] 難易度ソート
											--[ja] Open : そのセクションから
											--[ja] Close : 選択している難易度ソートから
											if allSongs[t]:HasStepsTypeAndDifficulty(stepsType,"Difficulty_"..cmtdiff) then
												if expsc ~= "" then
													if GetConvertDifficulty(allSongs[t],"Difficulty_"..cmtdiff) == tonumber(expsc) then
														mcheck = true;
													end;
												else mcheck = true;
												end;
											end;
										elseif string.find(sctext,"^TopGrades.*") then
											--[ja] グレードソート
											--[ja] Open : そのセクションから
											--[ja] Close : 選択しているグレードソートから
											if allSongs[t]:HasStepsTypeAndDifficulty(stepsType,"Difficulty_"..string.sub(sctext,10,-3)) then
												if expsc ~= "" then
													local csteps = allSongs[t]:GetOneSteps(stepsType,"Difficulty_"..string.sub(sctext,10,-3));
													local gradet = "Grade_None";
													local hs = {};
													hs_local_set(hs,0);
													local fcheck = 5;
													local stepseconds = 0;
													local scorelist = profile:GetHighScoreList(allSongs[t],csteps);
													assert(scorelist);
													local scores = scorelist:GetHighScores();
													local topscore = scores[1];
													local snum = snum_set(1,scores,jt_set[1]);
													if snum > 0 then
														topscore = scores[snum];
														if topscore then
															hs_set(hs,topscore,"normal");
															hs["TotalSteps"]					= csteps:GetRadarValues(jt_set[1]):GetValue('RadarCategory_TapsAndHolds');
															hs["RadarCategory_Holds"]				= csteps:GetRadarValues(jt_set[1]):GetValue('RadarCategory_Holds');
															hs["RadarCategory_Rolls"]				= csteps:GetRadarValues(jt_set[1]):GetValue('RadarCategory_Rolls');
															hs["Grade"]						= topscore:GetGrade();
															hs["SurvivalSeconds"]				= topscore:GetSurvivalSeconds();
															stepseconds = allSongs[t]:GetLastSecond();
															fcheck = fullcombochecker(hs,stepseconds);
															if hs["Grade"] ~= "Grade_None" then
																gradet = gradechecker(hs,hs["Grade"],stepseconds,jt_set[2],fcheck);
															end;
														end;
													end;
													if gradet == "Grade_None" then
														if THEME:GetString("Grade", "NoneSectionText") == expsc then
															mcheck = true;
														end;
													elseif THEME:GetString("Grade", ToEnumShortString(gradet)) == expsc then
														mcheck = true;
													end;
												else mcheck = true;
												end;
											end;
										end;
									end;
								else
									if expsc ~= "" then
										--[ja] (タイトル/アーティスト/BPM/Length/ジャンル)ソート
										--[ja] Open : そのセクションから
										--[ja] Close : 全曲
										if sort == "Title" or sort == "Artist" then
											local di = allSongs[t]:GetDisplayMainTitle();
											local tr = allSongs[t]:GetTranslitMainTitle();
											if sort == "Artist" then
												di = allSongs[t]:GetDisplayArtist();
												tr = allSongs[t]:GetTranslitArtist();
											end;
											local dpl = {1,1};
											if string.sub(di,1,1) == "." then dpl[1] = 2;
											end;
											if string.sub(tr,1,1) == "." then dpl[2] = 2;
											end;
											if expsc ~= "0-9" and string.upper(expsc) ~= string.upper(THEME:GetString("Sort","Other")) then
												if string.sub(string.upper(di),dpl[1],dpl[1]) == string.upper(expsc) then
													mcheck = true;
												elseif string.sub(string.upper(tr),dpl[2],dpl[2]) == string.upper(expsc) then
													mcheck = true;
												end;
											else
												if expsc == "0-9" then
													if string.find(string.sub(di,dpl[1],dpl[1]),"^[0-9]$") then
														mcheck = true;
													elseif string.find(string.sub(tr,dpl[2],dpl[2]),"^[0-9]$") then
														mcheck = true;
													end;
												elseif string.upper(expsc) == string.upper(THEME:GetString("Sort","Other")) then
													if string.find(string.sub(string.upper(tr),dpl[2],dpl[2]),"^[^A-Z0-9]$") then
														mcheck = true;
													end;
												end;
											end;
										elseif sort == "BPM" then
											local maxbpm = 0;
											local displayBPMs;
											local actualBPMs;
											if not allSongs[t]:IsDisplayBpmSecret() then
												--not "???"
												displayBPMs = allSongs[t]:GetDisplayBpms();
												maxbpm = displayBPMs[2];
											else
												actualBPMs = allSongs[t]:GetTimingData():GetActualBPM();
												maxbpm = actualBPMs[2];
											end;
											maxbpm = math.floor(maxbpm);
											if maxbpm < 0 then
												maxbpm = 0;
											elseif maxbpm >= 10000000000 then
												maxbpm = -2147483640;
											end;
											local twbpm = (math.floor(maxbpm / bpmDivision) + 1);
											local bpmsec = twbpm * bpmDivision;
											local bpmsef = string.format( "%03i", bpmsec - bpmDivision).."-"..string.format( "%03i", bpmsec - 1);
											if bpmsef == expsc then
												mcheck = true;
											end;
										elseif sort == "Length" then
											local maxlength = allSongs[t]:MusicLengthSeconds();
											maxlength = math.floor(maxlength);
											local twlength = (math.floor(maxlength / lengthDivision) + 1);
											local lengthsec = twlength * lengthDivision;
											local lengthsef = SecondsToMMSS(lengthsec - lengthDivision).."-"..SecondsToMMSS(lengthsec - 1);
											if lengthsef == expsc then
												mcheck = true;
											end;
										elseif sort == "Genre" then
											if string.upper(allSongs[t]:GetGenre()) == string.upper(expsc) then
												mcheck = true;
											elseif string.upper(allSongs[t]:GetGenre()) == "" and THEME:GetString("Sort","NotAvailable") == string.upper(expsc) then
												mcheck = true;
											end;
										end;
									else mcheck = true;
									end;
								end;
							end;
						end;
					end;
					
					if mcheck then
						--[ja] 難易度チェック
						--[ja] 優先順位 選択中の難易度がある曲 > 選択中以外の難易度がある曲
						--[ja] 優先順位のいずれにも該当しない曲は曲リストには入らない
						local cst = {0,0};
						local c_diffs = {"",""};
						for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
							local p = (pn == PLAYER_1) and 1 or 2;
							local cpdiff = GAMESTATE:GetPreferredDifficulty(pn);
							if cpdiff == "Difficulty_Edit" then
								cpdiff = "Difficulty_Challenge";
							end;
							c_diffs[p] = cpdiff;
							if not allSongs[t]:HasStepsTypeAndDifficulty(stepsType,cpdiff) then
								--[ja] 選択中の難易度の譜面がない曲は別の難易度の譜面をチェック
								local ds_num = diff_s_num[cpdiff];
								for i=1,5 do
									if allSongs[t]:HasStepsTypeAndDifficulty(stepsType,diff[ds_num][i]) then
										c_diffs[p] = diff[ds_num][i];
										cst[p] = 1;
										break;
									end;
								end;
							else cst[p] = 2;
							end;
						end;
						--Trace("cst : "..cst[1].." : "..cst[2]);
						--[ja] 曲・1P難易度・2P難易度
						local p_t;
						if #GAMESTATE:GetHumanPlayers() > 1 then
							if cst[1] == 2 and cst[2] == 2 then p_t = "d_s";
							else
								if cst[1] > 0 and cst[2] > 0 then p_t = "d_n";
								end;
							end;
						else
							if cst[1] == 2 or cst[2] == 2 then p_t = "d_s";
							else
								if cst[1] > 0 or cst[2] > 0 then p_t = "d_n";
								end;
							end;
						end;
						if p_t then
							if p_t == "d_s" then
								d_s_table[#d_s_table+1] = {allSongs[t],c_diffs[1],c_diffs[2]};
								--Trace("d_s_table : "..d_s_table[#d_s_table][1]:GetDisplayFullTitle().." : "..d_s_table[#d_s_table][2].." : "..d_s_table[#d_s_table][3]);
							elseif p_t == "d_n" then
								d_n_table[#d_n_table+1] = {allSongs[t],c_diffs[1],c_diffs[2]};
								--Trace("d_n_table : "..d_n_table[#d_n_table][1]:GetDisplayFullTitle().." : "..d_n_table[#d_n_table][2].." : "..d_n_table[#d_n_table][3]);
							end;
						end;
					end;
				end;
				--Trace("d_s_table : "..#d_s_table);
				--Trace("d_n_table : "..#d_n_table);
				--[ja] 優先順にチェックして曲・難易度を決定
				local set_s;
				if #d_s_table > 0 then
					set_s = d_s_table[math.random(#d_s_table)];
				elseif #d_n_table > 0 then
					set_s = d_n_table[math.random(#d_n_table)];
				end;
				if set_s then
					GAMESTATE:SetCurrentSong(set_s[1]);
					--GAMESTATE:SetPreferredSong(set_s[1]); 
					--GAMESTATE:SetPreferredSongGroup( set_s[1]:GetGroupName() ); 
					for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
						local p = (pn == PLAYER_1) and 1 or 2;
						GAMESTATE:SetPreferredDifficulty(pn,set_s[1+p]);
						GAMESTATE:SetCurrentSteps( pn, GAMESTATE:GetCurrentSong():GetOneSteps(stepsType,set_s[1+p]) );
					end;
					if p_check[3] == 3 then
						SCREENMAN:SetNewScreen("ScreenPlayerOptions");
					elseif p_check[3] == 1 then
						SCREENMAN:SetNewScreen("ScreenStageInformation");
					end;
				else
					if n_set_s == 0 then
						--[ja] もしも該当曲が見つからない場合は全曲に広げてもう一度やり直し
						n_set_s = 1;
						self:playcommand("NextScreen");
					else
						--[ja] それでも見つからない場合はメッセージを出して画面遷移をしない
						SCREENMAN:SystemMessage(THEME:GetString("ScreenSelectMusic","NotRandomSong"));
						p_check[3] = 0;
						MESSAGEMAN:Broadcast("ClosePSFO");
					end;
				end;
				--[ja] でそせらくんここまで
			end;
		};
	};
	
	t[#t+1] = LoadActor( THEME:GetPathB("","_goto_options_in") )..{};
end;

--20161130
function inputs(event)
	local pn= event.PlayerNumber
	if not pn then return false end
	local p = (pn == PLAYER_1) and 1 or 2;
	local button = event.GameButton
	local n_button = event.button
	local dbutton = event.DeviceInput.button;
	local wheelsel = 1;
	local check = 0;
	--[ja] WheelSpeedがNormal以上の速度
	local musicwheel = SCREENMAN:GetTopScreen():GetChild('MusicWheel');
	if tonumber(PREFSMAN:GetPreference("MusicWheelSwitchSpeed")) >= 10 then
		if event.type == "InputEventType_Repeat" then
			if button == "MenuLeft" or button == "MenuRight" then
				setenv("wheelstop",0);
				wheelsel = 0;
			end;
		else
			if getenv("wheelstop") == 2 and event.type == "InputEventType_Release" then
				check = 1;
			end;
			if button ~= "MenuLeft" and button ~= "MenuRight" then
				if wheelsel == 0 then
					setenv("wheelstop",0);
				end;
			else
				wheelsel = 1;
				setenv("wheelstop",1);
			end;
		end;
		if musicwheel then
			if musicwheel:GetSelectedType() == 'WheelItemDataType_Custom' then
			--20180219
				if string.find(getenv("wheelsectioncsc"),"^Favorite.*") then
					if button == "Start" or button == "Center" then
						favoritesortopen();
					end;
				else
					if csc_key_set == 1 then
						if getenv("wheelsectioncsc") == csctext and getenv("csflag") == 0 then
							if button == "Start" or button == "Center" then
								if event.type == "InputEventType_FirstPress" then
									setenv("csflag",1);
									MESSAGEMAN:Broadcast("MiniMenuCSCSet");
								end;
							end;
						end;
					end;
					--[ja] 20160415修正
					if getenv("wheelsectioncsc") == randomtext then
						p_check = next_s_check(p_check,event,pn,p,"play");
					else p_check = next_unc(p_check,"kp");
					end;
				end;
			else p_check = next_unc(p_check,"kp");
			end;
		end;
	end;
	--[ja] ScrollBarの挙動
	if SCREENMAN:GetTopScreen() then
		if musicwheel then
			wheel_s_bar_set(musicwheel,button,event.type);
			if n_button == "EffectUp" or n_button == "EffectDown" then
				if DISPLAY:GetFPS() >= 20 then
					wheel_shortcut(musicwheel,n_button);
				end;
				if event.type == "InputEventType_Repeat" then
					setenv("wheelstop",2);
				elseif event.type == "InputEventType_FirstPress" then
					setenv("wheelstop",1);
					SCREENMAN:GetTopScreen():lockinput(0.5);
				else
					setenv("wheelstop",1);
					if check == 1 then
						check = 0;
						musicwheel:Move(1);
						musicwheel:Move(-1);
						musicwheel:Move(0);
					end;
				end;
			end;
		end;
	end;
end;

t[#t+1] = Def.ActorFrame{
	OnCommand=function(self)
		SCREENMAN:GetTopScreen():AddInputCallback(inputs);
	end;
	StepsChosenMessageCommand=function(self, param)
		local p = (param.Player == PLAYER_1) and 1 or 2;
		p_check[p] = 2;
		--SCREENMAN:SystemMessage(getenv("wheelsectioncsc"));
	end;
	CurrentSongChangedMessageCommand=function(self)
		p_check = next_unc(p_check,"none");
	end;
	CurrentCourseChangedMessageCommand=cmd(playcommand,"CurrentSongChanged");
};

t[#t+1] = LoadActor("pump")..{
	InitCommand=cmd(Center;);
};

local function update(self)
	if getenv("csflag") == 2 then
		--SCREENMAN:SetNewScreen("ScreenCSOpen");
		self:queuecommand("EnvSet");
	end;
	if tonumber(getenv("ReloadFlag")[1]) == 1 then
		SCREENMAN:SetNewScreen(SelectMusicExtra());
	end;
	local limit = getenv("Timer");
	if limit > 0 then
		if limit <= s_v2_close_time_limit() - 1 then
			if v2_key_set ~= 3 then
				v2_key_set = 3;
			end;
		end;
		if limit <= csc_close_time_limit() - 1 then
			if csc_key_set ~= 3 then
				csc_key_set = 3;
			end;
		end;
--[[
	else
		if not GAMESTATE:GetCurrentSong() then
			SCREENMAN:GetTopScreen():PostScreenMessage( 'SM_DoneFadingIn', 1 );
			--SOUND:PlayOnce(THEME:GetPathS("Common","start"));
			MESSAGEMAN:Broadcast("SelectO");
			--MESSAGEMAN:Broadcast("ShowPSFO");
			--p_check[3] = 1;
		end;
]]
	end;
end;

t.InitCommand=cmd(SetUpdateFunction,update;);

return t;