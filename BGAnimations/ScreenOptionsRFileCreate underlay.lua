local t = Def.ActorFrame{};

t[#t+1] = Def.ActorFrame{
	OffCommand=cmd(playcommand,"Set");
	--UpdateCommand=cmd(playcommand,"Set";);
	SetCommand=function(self)
		local style = {
			'StepsType_Dance_Single','StepsType_Dance_Double','StepsType_Dance_Solo',
			'StepsType_Pump_Single','StepsType_Pump_Halfdouble','StepsType_Pump_Double'
		};
--[[
		local style2 = {
			'StepsType_Bm_Single5','StepsType_Bm_Double5',
			'StepsType_Bm_Single7','StepsType_Bm_Double7',
			'StepsType_Kb7_Single',
			'StepsType_Maniax_Single','StepsType_Maniax_Double'
		};
		local style3 = {
			'StepsType_Ez2_Single','StepsType_Ez2_Double','StepsType_Ez2_Real',
			'StepsType_Para_Single',
			'StepsType_Ds3ddx_Single',
			'StepsType_Pnm_Five','StepsType_Pnm_Nine'
		};
		local style4 = {
			'StepsType_Techno_Single4','StepsType_Techno_Single5','StepsType_Techno_Single8',
			'StepsType_Techno_Double4','StepsType_Techno_Double5','StepsType_Techno_Double8'
		};
		local mode = {
			dance = 1,pump = 1,
			bm = 2,kb7 = 2,maniax = 2,
			ez2 = 3,para = 3,ds3ddx = 3,pnm = 3,
			techno = 4
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

		local hs = {};
		hs_local_set(hs,0);
		--20161216
		hs["fcheck"]	= 5;
		hs["Grade"]	= "Grade_Tier22";

		local date = string.format("%04i-%02i-%02i_%02i-%02i", Year(), MonthOfYear()+1,DayOfMonth(), Hour(), Minute());
		local profile;
		local profd;
		local profileid;
		for p = 0,PROFILEMAN:GetNumLocalProfiles()-1 do
			profile = PROFILEMAN:GetLocalProfileFromIndex(p);
			--local profilename = profile:GetDisplayName();
			profileid = PROFILEMAN:GetLocalProfileIDFromIndex(p);
			profd = profile:GetGUID()..":"..profile:GetDisplayName();
			local songdir;
			local sdirs;
			local rf_path;

			if profile then
				local cs_path = "CSDataSave/"..profileid.."_Save/0002_dt dance";
				local cs_pump_path = "CSDataSave/"..profileid.."_Save/0002_dt pump";
				local cs_count_path = "CSDataSave/"..profileid.."_Save/0002_dt count";

				local opdsettext = "";
				if FILEMAN:DoesFileExist( cs_path ) then
					opdsettext = File.Read( cs_path );
				end;
				File.Write( "CSRealScore/"..profile:GetGUID().."_"..profile:GetDisplayName().."/0002_dt dance" , opdsettext );
				
				local oppsettext = "";
				if FILEMAN:DoesFileExist( cs_pump_path ) then
					oppsettext = File.Read( cs_pump_path );
				end;
				File.Write( "CSRealScore/"..profile:GetGUID().."_"..profile:GetDisplayName().."/0002_dt pump" , oppsettext );
				
				local countsettext = "";
				if FILEMAN:DoesFileExist( cs_count_path ) then
					countsettext = File.Read( cs_count_path );
				end;
				File.Write( "CSRealScore/"..profile:GetGUID().."_"..profile:GetDisplayName().."/0002_dt count" , countsettext );

				for soc=1,2 do
					local allGroups = 0;
					if soc == 1 then
						allGroups = SONGMAN:GetNumSongGroups();
					else allGroups = 1;
					end;
					for gro=1, allGroups do
						local groupnames = "";
						local groupSongs = "";
						if soc == 1 then
							groupnames = SONGMAN:GetSongGroupNames()[gro];
							groupSongs = SONGMAN:GetSongsInGroup(groupnames);
						else
							groupSongs = SONGMAN:GetAllCourses(false);
						end;
						if groupSongs then
							for gns=1, #groupSongs do
								if soc == 1 then
									songdir = groupSongs[gns]:GetSongDir();
								else songdir = groupSongs[gns]:GetCourseDir();
								end;
								--[ja] 20150727修正 なんでこれを下の方に書いてるんだ
								sdirs = split("/",songdir);
								if sdirs and sdirs[2] then
									sdirs[2] = additionaldir_to_songdir(sdirs[2]);
								end;
								rf_path = "CSRealScore/"..profile:GetGUID().."_"..profile:GetDisplayName().."/"..sdirs[2].."/"..sdirs[3].."/"..sdirs[4].."/set_"..wpsetd.."_"..swpsetd;
								if FILEMAN:DoesFileExist( rf_path ) then
									File.Write( rf_path.."_BackUp" , File.Read( rf_path ) );
								end;
								--tld = GetLifeDifficulty()..":"..GetTimingDifficulty();
								local rf_str = "";
								local rf_t = {};
								for st=1, #style do
									local steps;
									for d=1, #rf_diff do
										local std;
										local nsetstd;
										local scorelist;
										local scores;
										local topscore;
										local SorCTime = 0;
										local scorecheck = false;
										local statsset;
										local snum = 0;
										local trail_set;
										if soc == 1 then
											if groupSongs[gns]:HasStepsTypeAndDifficulty(style[st],"Difficulty_"..rf_diff[d]) then
												std = songdir..":"..style[st]..":"..rf_diff[d];
												nsetstd = style[st].."_"..rf_diff[d];
												steps = groupSongs[gns]:GetOneSteps(style[st], "Difficulty_"..rf_diff[d]);
												scorelist = profile:GetHighScoreList(groupSongs[gns],steps); 
												assert(scorelist);
												scores = scorelist:GetHighScores();
												topscore = scores[1];
												steps_count(hs,groupSongs[gns],steps,PLAYER_1,"Song");
												hs["RadarCategory_Mines"]	= steps:GetRadarValues(PLAYER_1):GetValue('RadarCategory_Mines');
											end;
										else
											local trails = groupSongs[gns]:GetAllTrails();
											for trail=1,#trails do
												if trails[trail]:GetStepsType() == style[st] then
													if ToEnumShortString(trails[trail]:GetDifficulty()) == rf_diff[d] then
														std = songdir..":"..style[st]..":"..ToEnumShortString(trails[trail]:GetDifficulty());
														nsetstd = style[st].."_"..ToEnumShortString(trails[trail]:GetDifficulty());
														scorelist = profile:GetHighScoreList(groupSongs[gns],trails[trail]); 
														assert(scorelist);
														scores = scorelist:GetHighScores();
														topscore = scores[1];
														steps_count(hs,groupSongs[gns],trails[trail],PLAYER_1,"Course");
														hs["RadarCategory_Mines"]	= trails[trail]:GetRadarValues(PLAYER_1):GetValue('RadarCategory_Mines');
														trail_set = trails[trail];
														break;
													end;
												end;
											end;
										end;
										--[ja] 20150830修正
										snum = snum_set(1,scores,PLAYER_1);
										if snum > 0 then
											topscore = scores[snum];
											if topscore then
												--hs["RadarCategory_Lifts"]	= topscore:GetRadarValues():GetValue('RadarCategory_Lifts');
												hs_set(hs,topscore,"normal");
												hs["fcheck"]			= 5;
												hs["SurvivalSeconds"]	= topscore:GetSurvivalSeconds();
												
												if soc == 1 then
													if groupSongs[gns]:GetLastSecond() then
														SorCTime = groupSongs[gns]:GetLastSecond();
													end;
												else
													--20160504
													SorCTime = courselength(groupSongs[gns],trail_set,style[st]);
												end;
												statsset =	hs["TapNoteScore_W1"]..","..hs["TapNoteScore_W2"]..","..hs["TapNoteScore_W3"]..","..
														hs["TapNoteScore_W4"]..","..hs["TapNoteScore_W5"]..","..hs["TapNoteScore_Miss"]..","..
														hs["HoldNoteScore_Held"]..","..hs["HoldNoteScore_LetGo"];
												scorecheck = true;
											end;
										end;
										if scorecheck then
											if not assistchecker("none",hs["Modifiers"]) then
												hs["fcheck"] = fullcombochecker(hs,SorCTime);
											else hs["fcheck"] = 9;
											end;
											local pgset;
											local swpm = 0;
											for rf=1,#rf_dp do
												pgset = "ntype";
												if rf == 2 then
													pgset = "default";
												end;
												swpm = migschecker(hs,pgset);
												--[ja] 20150909修正
												if gradechecker(hs,topscore:GetGrade(),SorCTime,pgset,hs["fcheck"]) ~= "Grade_Failed" then
													hs["Grade"] = gradechecker(hs,topscore:GetGrade(),SorCTime,pgset,hs["fcheck"]);
												else hs["Grade"] = "Grade_Tier21";
												end;

												if not FILEMAN:DoesFileExist( rf_path ) then
													if rf == 2 then 
														if hs["fcheck"] == 1 then
															hs["Grade"] = "Grade_Tier01";
														elseif hs["fcheck"] >= 2 and hs["fcheck"] <= 3 then
															if hs["fcheck"] == 3 then
																hs["Grade"] = "Grade_Tier03";
															else hs["Grade"] = "Grade_Tier02";
															end;
														end;
													end;
													rf_t[#rf_t+1] = { "#"..nsetstd.."/"..rf_dp[rf] , date..":"..hs["Grade"].."/"..hs["fcheck"]..":"..swpm };
												else
													local tcheck = 1;
													if GetRSParameter(rf_path,style[st].."_"..rf_diff[d].."/"..rf_dp[rf]) ~= "" then
														local tmpo = split(":",GetRSParameter(rf_path,style[st].."_"..rf_diff[d].."/"..rf_dp[rf]));
														local tmpogs;
														if tmpo[2] then
															tmpo[2] = hs["Grade"].."/"..hs["fcheck"];
														end;
														if #tmpo >= 3 then
															local tjudgeset = "x";
															if tonumber(tmpo[3]) == swpm then
																--[ja] ハイスコアと情報が一致している時(そのまま)
																local tlds = "0,0";
																if tmpo[4] ~= "x" and tmpo[4] ~= "" and tmpo[4] ~= nil then
																	tjudgeset = tmpo[4];
																end;
																if tmpo[5] ~= "" and tmpo[5] ~= nil then
																	statsset = tmpo[5];
																end;
																if tmpo[6] ~= "" and tmpo[6] ~= nil then
																	tlds = tmpo[6];
																end;
																rf_t[#rf_t+1] = { "#"..style[st].."_"..rf_diff[d].."/"..rf_dp[rf] , 
																			tmpo[1]..":"..tmpo[2]..":"..tmpo[3]..":"..tjudgeset..":"..statsset..":"..tlds  };
															else
																--[ja] ハイスコアと情報が一致しない時(新規)
																rf_t[#rf_t+1] = { "#"..style[st].."_"..rf_diff[d].."/"..rf_dp[rf] , 
																			date..":"..hs["Grade"].."/"..hs["fcheck"]..":"..swpm..":x:"..statsset..":0,0" };
															end;
															tcheck = 0;
														end;
													end;
													if tcheck == 1 then
														--[ja] 情報がない時(新規)
														if nsetstd == style[st].."_"..rf_diff[d] then
															rf_t[#rf_t+1] = { "#"..nsetstd.."/"..rf_dp[rf] , 
																		date..":"..hs["Grade"].."/"..hs["fcheck"]..":"..swpm..":x:"..statsset..":0,0" };
														end;
													end;
												end;
											end;
										end;
									end;
								end;
								if rf_t ~= "" then
									for n=1,#rf_t do
										rf_str = rf_str..""..rf_t[n][1]..":"..rf_t[n][2]..";\n";
									end;
								end;
								if rf_str ~= "" then
									File.Write( rf_path , "#Prof:"..profd..";\n#SongDir:"..sdirs[3].."/"..sdirs[4]..";\n"..rf_str );
								end;
							end;
						end;
					end;
				end;
			end;
		end;
	end;
};

t[#t+1] = LoadFont("Common Normal")..{
	InitCommand=function(self)
		self:settext(Screen.String("RFile Create"));
		(cmd(Center;diffuse,Color("White");diffusealpha,0))(self);
	end;
	OnCommand=cmd(linear,0.15;diffusealpha,1);
	OffCommand=cmd(linear,0.15;diffusealpha,0);
};
--20180301
collectgarbage("collect");

return t;