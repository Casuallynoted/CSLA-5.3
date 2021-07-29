local t = Def.ActorFrame{}

---------------------------------------------------------------------------------------------------------------------------------------
local maxstage = PREFSMAN:GetPreference("SongsPerPlay");
local players = #GAMESTATE:GetHumanPlayers();
setenv("exdcount",0);
local mplayer = GAMESTATE:GetMasterPlayerNumber();

if PROFILEMAN:IsPersistentProfile(mplayer) then
	if players == 1 and maxstage >= 3 then
		if GAMESTATE:HasEarnedExtraStage() and GAMESTATE:IsExtraStage() then
			local ssStats = STATSMAN:GetPlayedStageStats(1);
			local st = GAMESTATE:GetCurrentStyle():GetStepsType();

			-- [ja] chk_XXX … group.iniに定義されている曲用 
			local chk_folders={};
			local chk_songs={};

			-- [ja] load_XXX … 実際に選曲できる曲用 
			local load_folders={};
			local load_songs={};
			local load_cnt=0;
			local load_jackets={};
			local load_songtitle={};
			local load_songartist={};
			local song_countnum = {};

			local dif_list={
				'Difficulty_Beginner',
				'Difficulty_Easy',
				'Difficulty_Medium',
				'Difficulty_Hard',
				'Difficulty_Challenge'
			};

			local sys_group = "";
			local sys_dif={4,4};
			-- [ja] 指定難易度が存在しないときに、 
			-- 上の難易度を選択するか下の難易度を選択するか記憶用変数 
			-- (移動前の番号) 
			local sys_dif_old={4,4};
			-- [ja] ホイール移動量 
			local sys_wheel=0.0;
			local sys_focus=0;

			-- [ja] (CS未使用) システム的にキー操作を受け付けるタイミング 
			--local sys_keyok=false;

			-- [ja] 対象グループ
			if ssStats then
				sys_group = ssStats:GetPlayedSongs()[1]:GetGroupName();
			end;

			-- [ja] (CS未使用)
			--local exstage = 1;
			--if GAMESTATE:GetCurrentStage() == 'Stage_Extra2' then exstage = 2;
			--end;

			-- [ja] (CS未使用) 選曲式か、強制確定か 
			--local sys_extype = GetGroupParameter(sys_group,"Extra1Type");
			--sys_extype = string.lower(sys_extype);

			-- [ja] 楽曲情報文字列（#ExtraXSongsの中身）
			local sys_songunlock = "";
			local sys_songunlockU = "";
			if GetGroupParameter(sys_group,"Extra1Songs") ~= "" then
				sys_songunlock = split(":",string.lower(GetGroupParameter(sys_group,"Extra1Songs")));
				sys_songunlockU = split(":",GetGroupParameter(sys_group,"Extra1Songs"));
			end;
			-- [ja] 難易度別条件取得（曲切り替えのたびに代入） 
			local sys_songunlock_prm1;
			local sys_songunlock_prm1U;
			-- [ja] 取得した難易度別条件をさらにパラメータごとに分割 
			local sys_songunlock_prm2;
			local sys_songunlock_prm2U;

			-- [ja] 難易度別解禁（曲を切り替えるたびに呼び出し）
			local sys_difunlock={true,true,true,true,true};

			local rnd_base = math.round(GetStageState("PDP", "Last", "+")*10000);
			local rnd_folder="";
			local rnd_song;
			local sp_songtitle="";
			local sp_songartist="";
			local sp_songjacket={"",""};
			local sp_songbanner={"",""};

			-- [ja] 出現条件を満たしている難易度を返す 
			-- foldername = Extra1List
			local function SetDifficultyFlag(groupname,foldername)
				local sdif_list={
					'$',
					'%-beginner$',
					'%-easy$',
					'%-medium$',
					'%-hard$',
					'%-challenge$'
				};
				-- [ja] 全譜面選択可能状態 
				local diflock={true,true,true,true,true};
				local expath;
				if File.Read( "/Songs/"..sys_group.."/group.ini" ) then
					expath =  "/Songs/"..sys_group.."/";
				elseif File.Read("/AdditionalSongs/"..sys_group.."/group.ini") then
					expath = "/AdditionalSongs/"..sys_group.."/";
				else
					expath = false;
				end;
				rnd_folder = "";
				sp_songtitle = "";
				sp_songartist = "";
				sp_songjacket = {"",""};
				sp_songbanner = {"",""};
				-- sys_songunlock = Extra1Songs
				-- [ja] group.iniに記載されている条件を満たさない譜面のフラグをfalseにする
				for k = 1, #sys_songunlock do
					if string.find(sys_songunlock[k],""..string.lower(foldername).."|",1,true) then  
						sys_songunlock_prm1 = split("|",sys_songunlock[k]);
						sys_songunlock_prm1U = split("|",sys_songunlockU[k]);
						if #sys_songunlock_prm1 >= 2 then	-- [ja] 曲フォルダ名,条件1...となるのでパラメータが2つ以上ないと不正 
							for l = 2, #sys_songunlock_prm1 do
								sys_songunlock_prm2 = split(">",sys_songunlock_prm1[l]);
								sys_songunlock_prm2U = split(">",sys_songunlock_prm1U[l]);
								if #sys_songunlock_prm2 > 1 then	-- [ja] パラメータが2つ以上ない場合は不正な書式として無視する 
									if sys_songunlock_prm2[1] == "random" then
										rnd_folder = sys_songunlock_prm2[(rnd_base%(#sys_songunlock_prm2-1))+2];
										rnd_song = GetFolder2Song(groupname,rnd_folder);
									elseif sys_songunlock_prm2[1] == "banner" then
										if File.Read(expath..""..sys_songunlock_prm2[2]) then
											sp_songbanner[0] = GetFolder2Song(groupname,foldername):GetSongDir();
											sp_songbanner[1] = expath..""..sys_songunlock_prm2[2];
											if load_jackets[""..foldername] == nil then
												load_jackets[""..foldername]=sp_songbanner[1];
											end;
										end;
									elseif sys_songunlock_prm2[1] == "jacket" then
										if File.Read(expath..""..sys_songunlock_prm2[2]) then
											sp_songjacket[0] = GetFolder2Song(groupname,foldername):GetSongDir();
											sp_songjacket[1] = expath..""..sys_songunlock_prm2[2];
											load_jackets[""..foldername] = sp_songjacket[1];
										end;
									elseif sys_songunlock_prm2[1] == "title" then
										sp_songtitle=sys_songunlock_prm2U[2];
										load_songtitle[""..foldername] = sp_songtitle;
									elseif sys_songunlock_prm2[1] == "artist" then
										sp_songartist=sys_songunlock_prm2U[2];
										load_songartist[""..foldername] = sp_songartist;
									elseif #sys_songunlock_prm2 == 3 then
										local chk_mode;
										if string.find(sys_songunlock_prm2[1],"^last.*") then
											chk_mode="last";
										elseif string.find(sys_songunlock_prm2[1],"^max.*") then
											chk_mode="max";
										elseif string.find(sys_songunlock_prm2[1],"^min.*") then
											chk_mode="min";
										elseif string.find(sys_songunlock_prm2[1],"^played.*") then
											chk_mode="played";
										else
											chk_mode="avg";
										end;
										-- [ja] めんどいんで数値以外を条件にした場合無視 
										local break_flag = false;
										if tonumber(sys_songunlock_prm2[2]) then
											-- [ja] 難易度別 
											for dif = 1,6 do
												if not break_flag then
													local ret = -9999999999;	--[ja] 目標数値
													if string.find(sys_songunlock_prm2[1],"^.*grade"..sdif_list[dif]) then
														ret = GetStageState("grade", chk_mode, sys_songunlock_prm2[3]);
													elseif string.find(sys_songunlock_prm2[1],"^.*pdp"..sdif_list[dif]) 
														or string.find(sys_songunlock_prm2[1],"^.*perdancepoints"..sdif_list[dif]) then	--[ja] DPより先にPDPを書いておかないと条件を満たしてしまう 
														ret = GetStageState("pdp", chk_mode, sys_songunlock_prm2[3])*100;
													elseif string.find(sys_songunlock_prm2[1],"^.*dp"..sdif_list[dif]) 
														or string.find(sys_songunlock_prm2[1],"^.*dancepoints"..sdif_list[dif]) then
														ret = GetStageState("dp", chk_mode, sys_songunlock_prm2[3]);
													elseif string.find(sys_songunlock_prm2[1],"^.*combo"..sdif_list[dif]) 
														or string.find(sys_songunlock_prm2[1],"^.*maxcombo"..sdif_list[dif]) then
														ret = GetStageState("combo", chk_mode, sys_songunlock_prm2[3]);
													elseif string.find(sys_songunlock_prm2[1],"^.*meter"..sdif_list[dif]) then
														ret = GetStageState("meter", chk_mode, sys_songunlock_prm2[3]);
													else
														ret = -9999999999;
													end;
													if ret > -9999999999 then
														if sys_songunlock_prm2[3] == "+" or sys_songunlock_prm2[3] == "over" then
															if ret < tonumber(sys_songunlock_prm2[2]) then
																if dif == 1 then
																	diflock = {false,false,false,false,false};
																else
																	diflock[dif-1] = false;
																end;
															else
																diflock[dif-1] = true;
															end;
															break_flag = true;
															
														elseif sys_songunlock_prm2[3] == "-" or sys_songunlock_prm2[3] == "under" then
															if ret > tonumber(sys_songunlock_prm2[2]) then
																if dif == 1 then
																	diflock = {false,false,false,false,false};
																else
																	diflock[dif-1] = false;
																end;
															else
																diflock[dif-1] = true;
															end;
														end;
														break_flag = true;
													end;
												end;
											end;
										else
										-- [ja] その結果バージョン1.1で苦労したっていう 
											for dif = 1,6 do
												if not break_flag then
													local ret = 0;
													if string.find(sys_songunlock_prm2[1],"^.*song"..sdif_list[dif]) then
														ret=GetStageState("song", sys_songunlock_prm2[2], sys_songunlock_prm2[3]);
													end;
													if sys_songunlock_prm2[3] == "+" or sys_songunlock_prm2[3] == "over" then
														if (chk_mode == "played" and ret == 0) or (chk_mode == "last" and ret < maxstage) then
															if dif == 1 then
																diflock = {false,false,false,false,false};
															else
																diflock[dif-1] = false;
															end;
														else
															diflock[dif-1] = true;
														end;
														break_flag = true;
													elseif sys_songunlock_prm2[3] == "-" or sys_songunlock_prm2[3] == "under" then
														if (chk_mode=="played" and ret > 0) or (chk_mode == "last" and ret == maxstage) then
															if dif == 1 then
																diflock = {false,false,false,false,false};
															else
																diflock[dif-1] = false;
															end;
														else
															diflock[dif-1] = true;
														end;
													end;
													break_flag = true;
												end;
											end;
										end;
									end;
								end;
								if diflock[1]==false or diflock[2]==false or diflock[3]==false 
								or diflock[4]==false or diflock[5]==false then
								--	break;
								end;
							end;
						end;
						break;
					end;
				end;
				return diflock;
			end;

			-- [ja] グローバル変数と混ざっててアレな関数 
			local function GetExFolderSongList()
				local txt_folders = GetGroupParameter(sys_group,"Extra1List");
				if txt_folders ~= "" then
					chk_folders = split(":",txt_folders);
				end;
				-- [ja] 選択可能な曲を取得
				local songstr = "";
				local groupsongcount = 0;
				local songex2flag = 0;
				for j = 1,#chk_folders do
					groupsongcount = groupsongcount + 1;
					-- foldername = Extra1List
					local gsong = GetFolder2Song(sys_group,chk_folders[j])
					if gsong then
						-- [ja] ここで選択可能な難易度をチェックして、全難易度選択不可能なら登録しない 
						sys_difunlock = SetDifficultyFlag(sys_group,chk_folders[j]);
						-- [ja] フラグfalse or 譜面自体が存在しない場合選択不可能に設定
						local unlock_chk = 0;
						for k = 1,5 do
							if ((not gsong:HasStepsTypeAndDifficulty(GAMESTATE:GetCurrentStyle():GetStepsType(),dif_list[k])) or sys_difunlock[k] == false) then
								-- [ja] ここではあくまでも曲の登録をするかの問題なので、フラグ自体をいじらない 
								unlock_chk = unlock_chk+1;
							end;
						end;
						if unlock_chk < 5 then
							load_cnt=load_cnt + 1;
							if j > 50 then
								songstr = songstr;
							elseif j == #chk_folders or j == 50 then
								songstr = songstr..""..j;
							else
								songstr = songstr..""..j..",";
							end;
							load_songs[load_cnt] = gsong;
							load_folders[load_cnt] = chk_folders[j];
						else
							if j > 50 then
								songstr = songstr;
							elseif j == #chk_folders or j == 50 then
								songstr = string.sub( songstr,1,-2 );
							else
								songstr = songstr.."";
							end;
						end;
						
					end;
				end;
				setenv("songstr",songstr);
				setenv("groupsongcount",groupsongcount);
			end;
			GetExFolderSongList();
			
			if File.Read( "/Songs/"..sys_group.."/group.ini" ) 
			or File.Read("/AdditionalSongs/"..sys_group.."/group.ini") then
				setenv("exdcount",load_cnt);
			end;
		end;
	end;
end;
---------------------------------------------------------------------------------------------------------------------------------------
if GAMESTATE:HasEarnedExtraStage() and THEME:GetMetric( Var "LoadingScreen","Summary" ) == false then
	t[#t+1] = LoadActor( THEME:GetPathS("ScreenEvaluation","try Extra1" ) ) .. {
		OnCommand=cmd(play);
	};
	
	t[#t+1] = Def.Sprite{
		InitCommand=function(self)
			if GAMESTATE:IsExtraStage() and not GAMESTATE:IsExtraStage2() then
				if players == 1 and tonumber(getenv("exdcount")) >= 1 then
					self:Load(THEME:GetPathG("ScreenEvaluation","TryExtraStage/_csc"));
				else
					self:Load(THEME:GetPathG("ScreenEvaluation","TryExtraStage/_extra1"));
				end;
			elseif GAMESTATE:IsExtraStage2() and not GAMESTATE:IsExtraStage() then
				self:Load(THEME:GetPathG("ScreenEvaluation","TryExtraStage/_extra2"));
			end;
			(cmd(glowshift;effectcolor1,color("1,0,1,0");effectcolor2,color("1,0,1,0.5");effectperiod,0.3;))(self)
		end;
		OnCommand=cmd(zoom,3;diffusealpha,0;sleep,2;accelerate,0.2;zoom,1;diffusealpha,1;);	
	};
end;

return t;