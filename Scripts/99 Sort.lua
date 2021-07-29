function P_Sort_Set(sparam,dnm)
	--[ja] 20150331修正
	--[ja] 20150719システムを大幅修正
	--[ja] 20160718システムを大幅修正
	
	local function gefss_setting(exo_sDir,gropnames)
		if exo_sDir then
			--[ja] 20150719 曲を指定しきれていなかったので修正
			for ex_gro=1, SONGMAN:GetNumSongGroups() do
				local ex_gropnames = SONGMAN:GetSongGroupNames()[ex_gro];
				if GetFolder2Song(ex_gropnames,exo_sDir) then
					local ssdirset = split("/",GetFolder2Song(ex_gropnames,exo_sDir):GetSongDir());
					return gropnames.."/"..ssdirset[3].."/"..ssdirset[4];
				end;
			end;
			if GetSongName2Song(gropnames,exo_sDir) then
				local sdirset = split("/",GetSongName2Song(gropnames,exo_sDir):GetSongDir());
				return gropnames.."/"..sdirset[3].."/"..sdirset[4];
			end;
		end;
	end;

	local function dir_set(ex_song)
		local ex_u = string.lower(ex_song);
		local ex_s = split(":",ex_u)[1];
		local ex_s_Dir = ex_s;
		if string.find(ex_s_Dir,"\\") then
			ex_s_Dir = string.gsub(ex_s_Dir ,"\\","/");
		end;
		ex_s_Dir = split("/",ex_s_Dir);
		local ex_sDir_table = {};
		for i=1,#ex_s_Dir do
			if ex_s_Dir[i] ~= "" then
				ex_sDir_table[#ex_sDir_table+1] = ex_s_Dir[i];
			end;
		end
		return table.concat(ex_sDir_table,"/");
	end;
	
	local ct_dic = THEME:GetCurrentThemeDirectory();

	--[ja] プレイスタイル,プロファイルID,曲情報(曲名・難易度・譜面等),曲グレード,メーター,メータータイプ
	--[ja] env("sloadcheckflag",{"StepsType_Dance_Single","Prof_Prof",1,"2_2",{0,0,0,0,0}});
	local scf = {"None","Prof_Prof",0,{{0,0,0,0,0},{0,0,0,0,0}},{0,0,0,0,0},"Default"};
	s_envcheck(scf);

	if not GAMESTATE:IsCourseMode() then
	--[ja] セクション名文字コードチェック
	--20180217
		function gNumCheck(sDir) --,sTitle
--[[
			if sTitle and tonumber(string.byte(sTitle,1)) == 46 then
				return 1;
			end;
]]
			if (tonumber(string.byte(sDir,1)) >= 129 and tonumber(string.byte(sDir,1)) <= 159) or 
			(tonumber(string.byte(sDir,1)) >= 224 and tonumber(string.byte(sDir,1)) <= 239) then
				return 4;
			elseif tonumber(string.byte(sDir,1)) == 46 then
				return 1;
			elseif (tonumber(string.byte(sDir,1)) >= 33 and tonumber(string.byte(sDir,1)) <= 47) or 
			(tonumber(string.byte(sDir,1)) >= 58 and tonumber(string.byte(sDir,1)) <= 64) or 
			(tonumber(string.byte(sDir,1)) >= 91 and tonumber(string.byte(sDir,1)) <= 96) or 
			(tonumber(string.byte(sDir,1)) >= 123 and tonumber(string.byte(sDir,1)) <= 126) then
				return 3;
			end;
			return 2;
		end;

	--[ja] 難易度ソート
		local mt = GetAdhocPref("UserMeterType");
		local st = sparam ~= "favorite" and GAMESTATE:GetCurrentStyle():GetStepsType() or nil;
		local mplayer = GAMESTATE:GetMasterPlayerNumber();
		local allSongs = SONGMAN:GetAllSongs();
		if sparam ~= "favorite" then
			if scf[1] ~= st then
				scf[3] = 1;
				scf[4] = {{1,1,1,1,1},{1,1,1,1,1}};
				scf[5] = {1,1,1,1,1};
				scf[1] = st;
			end;
			if scf[6] ~= mt then
				scf[5] = {1,1,1,1,1};
				scf[6] = mt;
			end;
			scf[2] = GetAdhocPref("ProfOldIDSetP1").."_"..GetAdhocPref("ProfOldIDSetP2");
			local scs = split("_",scf[2]);
			for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
				local pp = ( (pn == "PlayerNumber_P1") and 1 or 2 );
				if scs[pp] ~= GetAdhocPref("ProfIDSetP"..pp) then
					scf[3] = 1;
					for t=1,#scf[4][pp] do
						if scf[4][pp][t] < 2 then scf[4][pp][t] = 1; end;
					end;
				end;
			end;
		--[[
		Trace("sloadcheckflag : "..scf[1]..":"..scf[2]..":"..scf[3]..":{"..scf[4][1][1]..":"..scf[4][1][2]..":"..scf[4][1][3]
		..":"..scf[4][1][4]..":"..scf[4][1][5].."}:{"..scf[4][2][1]..":"..scf[4][2][2]..":"..scf[4][2][3]..":"..scf[4][2][4]
		..":"..scf[4][2][5].."}:{"..scf[5][1]..":"..scf[5][2]..":"..scf[5][3]..":"..scf[5][4]..":"..scf[5][5].."}:"..scf[6]);
		]]
		end;
		local diff = {
			'Difficulty_Beginner',
			'Difficulty_Easy',
			'Difficulty_Medium',
			'Difficulty_Hard',
			'Difficulty_Challenge'
		};
		
		local diffset = {
			'BeginnerMeter',
			'EasyMeter',
			'MediumMeter',
			'HardMeter',
			'ChallengeMeter'
		};

		local allGroups = SONGMAN:GetNumSongGroups();
	--20180217
		local snsort = tobool(GetAdhocPref("SCustomNemeSort"));
		local allGroups_sub = {};
		if snsort then
			local sectionsubnamelist = getenv("sectionsubnamelist");
			for gro_s=1, allGroups do
				local sub_gropnames = SONGMAN:GetSongGroupNames()[gro_s];
				allGroups_sub[gro_s] = {Name = sub_gropnames, S_Sub = string.lower(sub_gropnames)};
				if sectionsubnamelist[sub_gropnames] then
					allGroups_sub[gro_s].S_Sub = string.lower(sectionsubnamelist[sub_gropnames]);
				end;
			end;
			table.sort(allGroups_sub,
				function(a, b)
					return (a.S_Sub < b.S_Sub)
				end
			);
		end;
		
		local g_exlist = {};
		local br_list = {};
		local br_set = {};
		local f_sortlist_c = 0;
		local sortlist_c = 0;
		local groupexsonglist = {};
		
		local mainpath = ct_dic.."/Other/SongManager Main_New.txt";
		local grpath = ct_dic.."/Other/SongManager Group_New.txt";
		local brpath = ct_dic.."/Other/SongManager B_Music_New.txt";
	---------------------------------------------------------------------------------------------------------------------------------------------------
		local grstr = {};
		local frt = getenv("frt") or {};
		-- [ja] すべての曲に存在していない難易度に関係したソートメニューのチェックに使う
		local diffcount = {0,0,0,0,0};
		
		if sparam == "before" or sparam == "favorite" then
			if scf[3] == 1 or not getenv("frt") or not FILEMAN:DoesFileExist( grpath ) or not FILEMAN:DoesFileExist( brpath ) or sparam == "favorite" then
			-- [ja] 楽曲並び順のオーダー/曲情報
				for gro=1, allGroups do
				--20180217
					local gropnames = snsort and allGroups_sub[gro].Name or SONGMAN:GetSongGroupNames()[gro];
					--local gropnames = SONGMAN:GetSongGroupNames()[gro];
					local extra_o_crs = OpenFile("/Songs/".. gropnames .."/extra1.crs")
					if not extra_o_crs then extra_o_crs = OpenFile("/AdditionalSongs/".. gropnames .."/extra1.crs")
					end
					local extra_t_crs = OpenFile("/Songs/".. gropnames .."/extra2.crs")
					if not extra_t_crs then extra_t_crs = OpenFile("/AdditionalSongs/".. gropnames .."/extra2.crs")
					end

					local f_sortlist = GetGroupParameter(gropnames,"SortList_Front");
					local sortlist = GetGroupParameter(gropnames,"SortList_Rear");
					local exsort = GetGroupParameter(gropnames,"ExtraAtEnd");
					local exlist = GetGroupParameter(gropnames,"Extra1List");
					local extlist = GetGroupParameter(gropnames,"Extra2List");
					local brlist = GetGroupParameter(gropnames,"BranchList");
				
					if f_sortlist ~= "" then
						local chk_f_sortlist = string.lower(f_sortlist);
						chk_f_sortlist = split(":",chk_f_sortlist);
						f_sortlist_c = #chk_f_sortlist;
						for frontfol = 1, #chk_f_sortlist do
							sflag = true;
							if g_exlist then
								for fol = 1, #g_exlist do
									if chk_f_sortlist[frontfol] == g_exlist[fol][1] then
										sflag = false;
										break;
									end;
								end;
							end;
							if sflag then g_exlist[#g_exlist+1] = { "front_"..string.format( "%d", frontfol ) , string.lower(gropnames).."/"..chk_f_sortlist[frontfol] };
							end;
						end;
					end;

					if sortlist ~= "" then
						local chk_sortlist = string.lower(sortlist);
						chk_sortlist = split(":",chk_sortlist);
						sortlist_c = #chk_sortlist;
						for endfol = 1, #chk_sortlist do
							sflag = true;
							if g_exlist then
								for fol = 1, #g_exlist do
									if chk_sortlist[endfol] == g_exlist[fol][1] then
										sflag = false;
										break;
									end;
								end;
							end;
							if sflag then g_exlist[#g_exlist+1] = { "rear_"..string.format( "%d", f_sortlist_c+endfol ) , string.lower(gropnames).."/"..chk_sortlist[endfol] };
							end;
						end;
					end;
					if exsort == "1" then
						--[ja] extra1.crs読み込んでメモリに保存
						if extra_o_crs then
							local exo_song = GetFileParameter(extra_o_crs ,"song");
							local exo_sDir = dir_set(exo_song);
							sflag = true;
							if g_exlist then
								for fol = 1, #g_exlist do
									if exo_sDir == g_exlist[fol][1] then
										sflag = false;
										break;
									end;
								end;
								if sflag then g_exlist[#g_exlist+1] = { "rear_"..string.format( "%d", f_sortlist_c+sortlist_c+1 ) , exo_sDir };
								end;
							end;
							if exo_sDir then
								groupexsonglist[#groupexsonglist+1] = gefss_setting(exo_sDir,gropnames);
							end;
						end;
						if extra_t_crs then
							local ext_song = GetFileParameter(extra_t_crs ,"song");
							local ext_sDir = dir_set(ext_song);
							sflag = true;
							if g_exlist then
								for fol = 1, #g_exlist do
									if ext_sDir == g_exlist[fol][1] then
										sflag = false;
										break;
									end;
								end;
								if sflag then g_exlist[#g_exlist+1] = { "rear_"..string.format( "%d", f_sortlist_c+sortlist_c+2 ) , ext_sDir };
								end;
							end;
						end;
						local cexlist_c = 0;
						if exlist ~= "" then
							local chk_exlist = string.lower(exlist);
							chk_exlist = split(":",chk_exlist);
							cexlist_c = #chk_exlist;
							for exfol = 1, #chk_exlist do
								sflag = true;
								if g_exlist then
									for fol = 1, #g_exlist do
										if chk_exlist[exfol] == g_exlist[fol][1] then
											sflag = false;
											break;
										end;
									end;
									if sflag then g_exlist[#g_exlist+1] = { "rear_"..string.format( "%d", f_sortlist_c+sortlist_c+3+exfol ) , string.lower(gropnames).."/"..chk_exlist[exfol] };
									end;
								end;
							end;
						end;
						if extlist ~= "" then
							local chk_exlist = string.lower(extlist);
							chk_extlist = split(":",chk_exlist);
							sflag = true;
							if g_exlist then
								for fol = 1, #g_exlist do
									if chk_extlist[1] == g_exlist[fol][1] then
										sflag = false;
										break;
									end;
								end;
								if sflag then g_exlist[#g_exlist+1] = { "rear_"..string.format( "%d", f_sortlist_c+sortlist_c+3+cexlist_c+1 ) , string.lower(gropnames).."/"..chk_extlist[1] };
								end;
							end;
						end;
					else
						--[ja] extra1.crs読み込んでメモリに保存
						if extra_o_crs then
							local exo_song = GetFileParameter(extra_o_crs ,"song");
							local exo_sDir = dir_set(exo_song);
							if exo_sDir then
								groupexsonglist[#groupexsonglist+1] = gefss_setting(exo_sDir,gropnames);
							end;
						end;
					end;
					CloseFile(extra_o_crs);
					CloseFile(extra_t_crs);

					local sgs = SONGMAN:GetSongsInGroup(gropnames);
					for grso=1, #sgs do
						--[ja] 20160325 対応数増加
						local gg_c_num = 2; 	--[ja] グループチェック番号
						local gg_num = 1;	--[ja] グループ番号
						local fset = 2; 		--[ja] ソートリスト前後番号
						local fnum = 1; 		--[ja] ソートリスト内番号
						local gs_c_num = 2;	--[ja] 曲チェック番号
						local gs_num = 1; 	--[ja] 曲番号
						--if (st and sgs[grso]:HasStepsType(st)) or sparam == "favorite" then
							if sparam ~= "favorite" then
								for p=1, #diff do
									if st and sgs[grso]:HasStepsType(st) and sgs[grso]:HasStepsTypeAndDifficulty(st,diff[p]) then
										diffcount[p] = 1;
									end;
								end;
							end;
							
							local songDir = sgs[grso]:GetSongDir();
							--20180217
							local sDir = s_songdir(songDir);
							local sDir_s = split("/",sDir);
							local sDir_s_l = sDir_s[1].."/"..sDir_s[2];

							if g_exlist then
								for cfol=1, #g_exlist do
									if g_exlist[cfol][2] == string.lower(sDir_s_l) then
										local frontcheck = split("_",g_exlist[cfol][1]);
										if frontcheck[1] == "front" then
											fset = 1;
											fnum = 1 + tonumber(frontcheck[2]);
										elseif frontcheck[1] == "rear" then
											fset = 3;
											fnum = 1 + tonumber(frontcheck[2]);
										else
											fset = 2;
											fnum = 1;
										end;
										break;
									end;
								end;
							end;
						--[ja] グループチェック番号 : 1～8まで
						--20180217
							gg_c_num = snsort and gNumCheck(allGroups_sub[gro].S_Sub) or gNumCheck(sDir_s[1]);
							if string.find(songDir,"^/Songs/.*") then
								gg_c_num = gg_c_num + 4;
							end;
							gg_c_num = string.format("%01d",gg_c_num);
						--[ja] グループ番号 : 1～999,999まで
							gg_num = math.min(gro,999999);
							gg_num = string.format("%06d",gg_num);
							
						--[ja] ソートリスト前後番号 : 1～3まで
							fset = string.format("%01d",fset);
						--[ja] ソートリスト内番号 : 1～999,999まで
							fnum = math.min(fnum,999999);
							fnum = string.format("%06d",fnum);

						--[ja] 曲チェック番号 : 1～3まで
							gs_c_num = gNumCheck(sDir_s[2]); --,sgs[grso]:GetDisplayMainTitle()
							gs_c_num = string.format("%01d",gs_c_num);
						--[ja] 曲番号 : 1～9,999,999まで
							gs_num = math.min(grso,9999999);
							gs_num = string.format("%07d",gs_num);
							
						--[ja] グループチェック番号 : グループ番号 : ソートリスト前後番号 : ソートリスト内番号 : 曲チェック番号 : 曲番号  
							frt[sDir_s[1].."/"..sDir_s[2]] = gg_c_num.."_"..gg_num.."_"..fset.."_"..fnum.."_"..gs_c_num.."_"..gs_num;
							--Trace(sDir_s[1].."/"..sDir_s[2].." : "..frt[sDir_s[1].."/"..sDir_s[2]]);
							grstr[#grstr+1] = { "", frt[sDir_s[1].."/"..sDir_s[2]] , sDir_s[1].."/"..sDir_s[2] };
							
							if sparam ~= "favorite" then
								local chk_brlist = split(":",brlist);
								for b=1, #chk_brlist do
									local b_dir_s = split("|",chk_brlist[b]);
									local s_dir_br = gropnames.."/"..b_dir_s[1];
									if #b_dir_s > 1 and string.lower(s_dir_br) == string.lower(sDir_s_l) then
										local c_fol;
										for bb=1, #b_dir_s do
											b_dir_ss = split(">",b_dir_s[bb]);
											if #b_dir_ss > 1 then
												if string.lower(b_dir_ss[1]) == "random" then
													if #b_dir_ss > 2 then
														if b_dir_ss[2] ~= "" and b_dir_ss[3] ~= "" and b_dir_ss[2] ~= b_dir_ss[3] then
															br_set[s_dir_br] = {folder = s_dir_br,jacket = nil,banner = nil,background = nil,title = nil};
															br_list[#br_list+1] = s_dir_br;
															br_set["check"] = tostring(true);
														end;
													end;
												end;
												if br_set[s_dir_br].folder then
													if string.lower(b_dir_ss[1]) == "jacket" then
														br_set[s_dir_br].jacket = b_dir_ss[2];
													elseif string.lower(b_dir_ss[1]) == "banner" then
														br_set[s_dir_br].banner = b_dir_ss[2];
													elseif string.lower(b_dir_ss[1]) == "title" then
														br_set[s_dir_br].title = b_dir_ss[2];
													end;
												else break;
												end;
											end;
										end;
									end;
								end;
							end;
						--end;
					end;
				end;
				--if sparam == "favorite" then
				--	return frt;
				--end;
				setenv("frt",frt);
			end;
			
		-- [ja] 曲情報
			if scf[3] == 1 or not FILEMAN:DoesFileExist( grpath ) then
				table.sort(grstr,
					function(a, b)
						if a[2] < b[2] then
							return true
						end;
					end
				);
			end
			
			if scf[3] == 1 or not FILEMAN:DoesFileExist( grpath ) or not FILEMAN:DoesFileExist( brpath ) then
				setenv("diffcount",diffcount);
			-- [ja] グループチェック/曲情報 -------------------------------------------------
				local grouptext = "";
				local cgroup = "";
				local groupcs = "";

				for t=1, #grstr do
					local s_grstr = split("/",grstr[t][3]);
					--local m_grstr = split(" .:",grstr[t][2]);
					if grstr[t] then
						if cgroup ~= s_grstr[1] then
							groupcs = "--- "..s_grstr[1].."\r\n";
							grstr[t][1] = groupcs;
							cgroup = s_grstr[1];
						else
							grstr[t][1] = "";
						end;
						if grstr[t][2] then
							grstr[t][2] = grstr[t][3].."\r\n";
						end;
						grouptext = grouptext..""..grstr[t][1]..""..grstr[t][2];
						--grouptext = grouptext..""..frt[grstr[t][3]].."_"..grstr[t][1]..""..grstr[t][2];
					else
						grouptext = grouptext;
					end;
				end;
				if grpath and grouptext then
					File.Write( grpath , grouptext );
					File.Write( mainpath , grouptext );
				end;
				setenv("groupexsonglist",table.concat(groupexsonglist,":"));
			
				if scf[3] == 1 or not FILEMAN:DoesFileExist( brpath ) then
					local brtext = "";
					for fol in ivalues(br_list) do
						brtext = brtext.."".. fol .."\r\n";
					end;
					if brpath and brtext then
						File.Write( brpath , brtext );
					end;
					if br_set then
						setenv("br_set",br_set);
					end;
				end;
				--Trace("groupexsonglist : "..getenv("groupexsonglist"));
			
				if FILEMAN:DoesFileExist( cc_path ) then
					--[ja] cgpセット
					local cgptable = {};
					local cgp_s;
					if GetCCParameter("cGp") then
						if GetCCParameter("cGp") ~= "" then
							cgp_s = split(":",GetCCParameter("cGp"));
						end;
						if cgp_s then
							for gp=1,#cgp_s do
								if cgp_s[gp] then
									cgptable[cgp_s[gp]] = cgp_s[gp];
								end;
							end;
							setenv("cgptable",cgptable);
						end;
					end;
				end;
			end;
		end;
		scf[3] = 0;
	---------------------------------------------------------------------------------------------------------------------------------------------------

	--[ja] メーター・グレードソート
		--if GAMESTATE:GetNumPlayersEnabled() == 1 then
			if sparam == "meter" or sparam == "grade" then
				--for p=1, #diff do
					local grapathP1;
					local grapathP2;
					local dmpath;

					local dstr = {};
					local cs_gstrP1 = {};
					local sm_gstrP1 = {};
					local cs_gstrP2 = {};
					local sm_gstrP2 = {};
					for q=1, #allSongs do
						local songDir = allSongs[q]:GetSongDir();
						--20180217
						local sDir = s_songdir(songDir);
						local songName = allSongs[q]:GetTranslitFullTitle();
						if not songName then songName = allSongs[q]:GetDisplayFullTitle();
						end;
						local steps = allSongs[q]:GetOneSteps(st, diff[dnm]);
						local sDir_s = split("/",sDir);	
						local stringg = string.sub(string.upper(sDir_s[1]),1,2);
						local stringg_l = string.sub(sDir_s[1],1);
						local stringb = string.sub(string.upper(songName),1,2);
						local stringb_l = string.sub(songName,1);
						local stringlg = string.len(sDir_s[1]);
						local stringl = string.len(sDir_s[2]);
						local gsnum = 2000000 + q;
					-- [ja] グループ/曲情報 -------------------------------------------------
						-- [ja] dmpathの記述場所がおかしかったので修正(20140613)
						if mt == "CSStyle" then
							dmpath = ct_dic.."/Other/SongManager "..ToEnumShortString(st).."_CSStyle_"..diffset[dnm].."_New.txt";
						else dmpath = ct_dic.."/Other/SongManager "..ToEnumShortString(st).."_Default_"..diffset[dnm].."_New.txt";
						end;

						if allSongs[q]:HasStepsTypeAndDifficulty(st,diff[dnm]) then
							if sparam == "meter" then
								-- [ja] メーター/曲情報 -------------------------------------------------
								if scf[5][dnm] == 1 or not FILEMAN:DoesFileExist( dmpath ) then
									-- [ja] メーターチェック
									local dnmeter = 0;
									if mt == "CSStyle" then
										dnmeter = tonumber(GetConvertDifficulty(allSongs[q],diff[dnm]));
									else
										dnmeter = tonumber(steps:GetMeter());
									end
									-- [ja] メーター_セクションと曲
									dstr[#dstr+1] = { "", string.format("%12d", dnmeter).." .:"..frt[sDir_s[1].."/"..sDir_s[2]] , sDir_s[1].."/"..sDir_s[2] };
								end;
							elseif sparam == "grade" then
								-- [ja] グレード/曲グレード -------------------------------------------------
								for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
									local pp = ( (pn == "PlayerNumber_P1") and 1 or 2 );
								-- [ja] グレードチェック
									local gra_cs_p_path = ct_dic.."/Other/SongManager "..ToEnumShortString(st).."_"..ToEnumShortString(pn).."_Grade_"..diffset[dnm].."_New.txt";
									local gra_sm_p_path = ct_dic.."/Other/SongManager "..ToEnumShortString(st).."_"..ToEnumShortString(pn).."_Grade_SM_"..diffset[dnm].."_New.txt";
									local profile =c_profile(pn);
									local cs_gradet = "Grade_None";
									local sm_gradet = "Grade_None";
									local hs = {};
									hs_local_set(hs,0);
									local fcheck = 5;
									local stepseconds = 0;
									if scf[4][pp][dnm] == 1 or (not FILEMAN:DoesFileExist( gra_cs_p_path ) or not FILEMAN:DoesFileExist( gra_sm_p_path )) then
										scf[4][pp][dnm] = 1;
										local scorelist = profile:GetHighScoreList(allSongs[q],steps);
										assert(scorelist);
										local scores = scorelist:GetHighScores();
										local topscore = scores[1];
										local snum = snum_set(1,scores,pn);
										local dpset = 1;
										if snum > 0 then
											topscore = scores[snum];
											if topscore then
												hs_set(hs,topscore,"normal");
												hs["TotalSteps"]					= steps:GetRadarValues(pn):GetValue('RadarCategory_TapsAndHolds');
												hs["RadarCategory_Holds"]				= steps:GetRadarValues(pn):GetValue('RadarCategory_Holds');
												hs["RadarCategory_Rolls"]				= steps:GetRadarValues(pn):GetValue('RadarCategory_Rolls');
												hs["Grade"]						= topscore:GetGrade();
												hs["SurvivalSeconds"]				= topscore:GetSurvivalSeconds();
												stepseconds = allSongs[q]:GetLastSecond();
												fcheck = fullcombochecker(hs,stepseconds);
												dpset = string.format("%1.4f",dpset - hs["PercentScore"]);
												dpset = string.format("%06d",dpset * 10000);
												--dpset = math.max(dpset,0);
												if hs["Grade"] ~= "Grade_None" then
													cs_gradet = gradechecker(hs,hs["Grade"],stepseconds,"ntype",fcheck);
													if cs_gradet == "Grade_Failed" then cs_gradet = "Grade_Tier21";
													end;
													sm_gradet = gradechecker(hs,hs["Grade"],stepseconds,"default",fcheck);
													if sm_gradet == "Grade_Failed" then sm_gradet = "Grade_Tier21";
													end;
												end;
											end;
										end;
										if cs_gradet == "Grade_None" then cs_gradet = "Grade_Tier22";
										end;
										if sm_gradet == "Grade_None" then sm_gradet = "Grade_Tier22";
										end;
										-- [ja] グレード_セクションと曲
										if pn == PLAYER_1 then
											cs_gstrP1[#cs_gstrP1+1] = { "", cs_gradet.." .:"..dpset .. frt[sDir_s[1].."/"..sDir_s[2]] , sDir_s[1].."/"..sDir_s[2] };
											sm_gstrP1[#sm_gstrP1+1] = { "", sm_gradet.." .:"..dpset .. frt[sDir_s[1].."/"..sDir_s[2]] , sDir_s[1].."/"..sDir_s[2] };
										else
											cs_gstrP2[#cs_gstrP2+1] = { "", cs_gradet.." .:"..dpset .. frt[sDir_s[1].."/"..sDir_s[2]] , sDir_s[1].."/"..sDir_s[2] };
											sm_gstrP2[#sm_gstrP2+1] = { "", sm_gradet.." .:"..dpset .. frt[sDir_s[1].."/"..sDir_s[2]] , sDir_s[1].."/"..sDir_s[2] };
										end;
									end;
								end;
							end;
						end;
					end;

				-- [ja] フォルダ/曲ディレクトリソート
					--for m=1, 2 do
						if sparam == "meter" then
							-- [ja] 曲情報
							if scf[5][dnm] == 1 or not FILEMAN:DoesFileExist( dmpath ) then
								table.sort(dstr,
									function(a, b)
										if a[2] < b[2] then
											return true
										end;
									end
								);
							end;
						elseif sparam == "grade" then
							-- [ja] 曲グレード
							for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
								local pp = ( (pn == "PlayerNumber_P1") and 1 or 2 );
								if scf[4][pp][dnm] == 1 then
									if pn == PLAYER_1 then
										table.sort(cs_gstrP1,
											function(a, b)
												if a[2] < b[2] then
													return true
												end;
											end
										);
										table.sort(sm_gstrP1,
											function(a, b)
												if a[2] < b[2] then
													return true
												end;
											end
										);
									else
										table.sort(cs_gstrP2,
											function(a, b)
												if a[2] < b[2] then
													return true
												end;
											end
										);
										table.sort(sm_gstrP2,
											function(a, b)
												if a[2] < b[2] then
													return true
												end;
											end
										);
									end;
								end;
							end;
						end;
					--end;
					
						if sparam == "meter" then
						-- [ja] メーターチェック/曲情報 -------------------------------------------------
							if scf[5][dnm] == 1 or not FILEMAN:DoesFileExist( dmpath ) then
								-- [ja] 仮メーター
								local sorttext = "";
								local cmeter = 100000000000;
								local stmeter = 0;
						
								for o=1, #dstr do
									local m_dstr = split(" .:",dstr[o][2]);
									local s_dstr = split("/",dstr[o][3]);
									if dstr[o] then
										stmeter = m_dstr[1];
										if tonumber(cmeter) ~= tonumber(stmeter) then
											stmeter = string.format( "%02i", stmeter );
											dstr[o][1] = "--- "..stmeter.."\r\n";
											cmeter = stmeter;
										else
											dstr[o][1] = "";
										end;
										if dstr[o][2] then
											dstr[o][2] = dstr[o][3].."\r\n";
										end;
										sorttext = sorttext..""..dstr[o][1]..""..dstr[o][2];
									else
										sorttext = sorttext;
									end;
								end;
								if dmpath and sorttext then
									File.Write( dmpath , sorttext );
									scf[5][dnm] = 0;
								end;
							end;
						elseif sparam == "grade" then
						-- [ja] グレードチェック/曲グレード -------------------------------------------------
							for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
								local gscheck = {};
								local pp = ( (pn == "PlayerNumber_P1") and 1 or 2 );
								local csgstr = cs_gstrP1;
								local smgstr = sm_gstrP1;
								if pn == PLAYER_2 then
									csgstr = cs_gstrP2;
									smgstr = sm_gstrP2;
								end;
								if scf[4][pp][dnm] == 1 then
									local cc_gstr;
									local gra_p_path;
									if #csgstr > 0 then gscheck[1] = "ntype";
									end;
									if #smgstr > 0 then gscheck[2] = "default"; 
									end;
									for gcset in ivalues(gscheck) do
										-- [ja] 仮グレード
										local gradetext = "";
										local cgrade = "Grade_Tier24";
										local stgrade = "Grade_Tier23";
										local setgrade = "";
										
										gra_p_path = ct_dic.."/Other/SongManager "..ToEnumShortString(st).."_"..ToEnumShortString(pn).."_Grade_"..diffset[dnm].."_New.txt";
										cc_gstr = csgstr;
										if gcset == "default" then
											gra_p_path = ct_dic.."/Other/SongManager "..ToEnumShortString(st).."_"..ToEnumShortString(pn).."_Grade_SM_"..diffset[dnm].."_New.txt";
											cc_gstr = smgstr;
										end;
										--Trace("gra_p_path : "..gra_p_path);
										for t=1, #cc_gstr do
											--Trace("num_cc_gstr : "..t);
											local g_gstr = split(" .:",cc_gstr[t][2]);
											local s_gstr = split("/",cc_gstr[t][3]);
											if cc_gstr[t] then
												stgrade = g_gstr[1];
												if stgrade ~= cgrade then
													if stgrade == "Grade_Tier01" then
														setgrade = "--- "..THEME:GetString("Grade","Tier01").."\r\n"
													elseif stgrade == "Grade_Tier02" then
														setgrade = "--- "..THEME:GetString("Grade","Tier02").."\r\n"
													elseif stgrade == "Grade_Tier03" then
														setgrade = "--- "..THEME:GetString("Grade","Tier03").."\r\n"
													elseif stgrade == "Grade_Tier04" then
														setgrade = "--- "..THEME:GetString("Grade","Tier04").."\r\n"
													elseif stgrade == "Grade_Tier05" then
														setgrade = "--- "..THEME:GetString("Grade","Tier05").."\r\n"
													elseif stgrade == "Grade_Tier06" then
														setgrade = "--- "..THEME:GetString("Grade","Tier06").."\r\n"
													elseif stgrade == "Grade_Tier07" then
														setgrade = "--- "..THEME:GetString("Grade","Tier07").."\r\n"
													elseif stgrade == "Grade_Tier21" then
														setgrade = "--- "..THEME:GetString("Grade","Failed").."\r\n"
													elseif stgrade == "Grade_Tier22" then
														setgrade = "--- "..THEME:GetString("Grade","NoneSectionText").."\r\n"
													end;
													cc_gstr[t][1] = setgrade;
													cgrade = stgrade;
												else
													cc_gstr[t][1] = "";
												end;

												if cc_gstr[t][2] then
													cc_gstr[t][2] = cc_gstr[t][3].."\r\n";
												end;
												gradetext = gradetext..""..cc_gstr[t][1]..""..cc_gstr[t][2];
											else
												gradetext = gradetext;
											end;
										end;
										if gra_p_path and gradetext then
											File.Write( gra_p_path , gradetext );
											scf[4][pp][dnm] = 2;
										end;
									end;
								end;
							end;
						end;
					--end;
				--end;
			end;
		--end;
		setenv("sloadcheckflag",{scf[1],scf[2],scf[3],scf[4],scf[5],scf[6]});
		--[[
		Trace("sloadcheckflag_after : "..scf[1]..":"..scf[2]..":"..scf[3]..":{"..scf[4][1][1]..":"..scf[4][1][2]..":"..scf[4][1][3]
		..":"..scf[4][1][4]..":"..scf[4][1][5].."}:{"..scf[4][2][1]..":"..scf[4][2][2]..":"..scf[4][2][3]..":"..scf[4][2][4]
		..":"..scf[4][2][5].."}:{"..scf[5][1]..":"..scf[5][2]..":"..scf[5][3]..":"..scf[5][4]..":"..scf[5][5].."}:"..scf[6]);
		Trace("garbage_usememory : "..collectgarbage("count"));
		]]
	end;
end;

--[ja] 20150718修正 すべての曲に存在していない難易度の難易度メーター・難易度別グレードのソートメニューを取り除く
--20180209 favorite
function sortmenuset(cpn,profile_id)
	local base = {
		"Group",
		"Title",
		"Artist",
		"Bpm"
	};
	local diff = {
		'Beginner',
		'Easy',
		'Medium',
		'Hard',
		'Challenge'
	};
	local pnset = "P1";
	if cpn == "P2" then
		pnset = {"P2","P1"};
	end;
	local prof_sortfiledir = PROFILEMAN:LocalProfileIDToDir(profile_id).."CustomSort/SongManager ";
	local prof_fsortfiledir = PROFILEMAN:LocalProfileIDToDir(profile_id).."CS_Favorite/SongManager ";
	local rsetting;
	local uc_dir = prof_sortfiledir.."CustomSort.txt";
	if FILEMAN:DoesFileExist(uc_dir) then
		if sortfilecheck(uc_dir) then
			rsetting = File.Read(uc_dir);
		end;
	end;
	local frsetting;
	for ff=1,5 do
		local ff_dir = prof_fsortfiledir.."Favorite"..ff..".txt";
		if FILEMAN:DoesFileExist(ff_dir) then
			if sortfilecheck(ff_dir) then
				frsetting = File.Read(ff_dir);
			end;
		end;
		if frsetting then break;
		end;
	end;
	for j=1,#diff do
		if getenv("diffcount")[j] > 0 then
			base[#base+1] = diff[j].."Meter";
		end;
	end;
	base[#base+1] = "Length";
	base[#base+1] = "Genre";
	for k=1,#diff do
		if getenv("diffcount")[k] > 0 then
			base[#base+1] = "TopGrades"..diff[k]..cpn;
		end;
	end;
	base[#base+1] = "Recent";
	base[#base+1] = "Popularity";
	if tobool(getenv("br_set")["check"]) and not IsNetConnected() then
		base[#base+1] = "SongBranch";
	end;
	if rsetting then
		base[#base+1] = "UserCustom"..cpn;
	end;
	if frsetting then
		base[#base+1] = "Favorite"..cpn;
	end;
	return base;
	--return table.concat(base,",");
end;

setdiffuse = {
	A = HSVA( (360/28)*2,0.5,1,1 );
	B = HSVA( (360/28)*3,0.5,1,1 );
	C = HSVA( (360/28)*4,0.5,1,1 );
	D = HSVA( (360/28)*5,0.5,1,1 );
	E = HSVA( (360/28)*6,0.5,1,1 );
	F = HSVA( (360/28)*7,0.5,1,1 );
	G = HSVA( (360/28)*8,0.5,1,1 );
	H = HSVA( (360/28)*9,0.5,1,1 );
	I = HSVA( (360/28)*10,0.5,1,1 );
	J = HSVA( (360/28)*11,0.5,1,1 );
	K = HSVA( (360/28)*12,0.5,1,1 );
	L = HSVA( (360/28)*13,0.5,1,1 );
	M = HSVA( (360/28)*14,0.5,1,1 );
	N = HSVA( (360/28)*15,0.5,1,1 );
	O = HSVA( (360/28)*16,0.5,1,1 );
	P = HSVA( (360/28)*17,0.5,1,1 );
	Q = HSVA( (360/28)*18,0.5,1,1 );
	R = HSVA( (360/28)*19,0.5,1,1 );
	S = HSVA( (360/28)*20,0.5,1,1 );
	T = HSVA( (360/28)*21,0.5,1,1 );
	U = HSVA( (360/28)*22,0.5,1,1 );
	V = HSVA( (360/28)*23,0.5,1,1 );
	W = HSVA( (360/28)*24,0.5,1,1 );
	X = HSVA( (360/28)*25,0.5,1,1 );
	Y = HSVA( (360/28)*26,0.5,1,1 );
	Z = HSVA( (360/28)*27,0.5,1,1 );
};
bnum = {};
lnum = {};
gnum = {};
bpmseccount = 0;
lengthseccount = 0;
genrecount = 0;

--20180219
function SortSetting(sctext,profile_id,mw)
	THEME:ReloadMetrics();
	local diff_n = {
		Beginner	= 1,
		Easy		= 2,
		Medium	= 3,
		Hard		= 4,
		Challenge	= 5,
	};
	setmetatable( diff_n, { __index = function() return 1 end; } );
	local rsetting;
	local sortfiledir = THEME:GetCurrentThemeDirectory().."Other/SongManager ";
	local prof_sortfiledir = PROFILEMAN:LocalProfileIDToDir(profile_id).."CustomSort/SongManager ";
	local prof_fsortfiledir = PROFILEMAN:LocalProfileIDToDir(profile_id).."CS_Favorite/SongManager ";
	--local sctext = getenv("SortCh");
if GAMESTATE:GetCurrentStyle() then
	local st = GAMESTATE:GetCurrentStyle():GetStepsType();
end;
	local mt = GetAdhocPref("UserMeterType");
	local gsetc = split(",",GetAdhocPref("SortGsetCheck"));
	if not GAMESTATE:IsCourseMode() then
	--if not GAMESTATE:IsAnExtraStage() then
		if sctext then
			GAMESTATE:SetCurrentSong( newsong );
			if sctext == "Group" then
				if FILEMAN:DoesFileExist( sortfiledir.."Group_New.txt") then
					rsetting = File.Read( sortfiledir.."Group_New.txt" );
				end;
			elseif string.find(sctext,"^.*Meter") then
				P_Sort_Set("meter",tonumber(diff_n[string.gsub(sctext,"Meter","")]));
				local m_dir = sortfiledir..ToEnumShortString(st).."_"..mt.."_"..sctext.."_New.txt";
				if FILEMAN:DoesFileExist(m_dir) then
					if sortfilecheck(m_dir) then
						rsetting = File.Read(m_dir);
					end;
				end;
			elseif string.find(sctext,"^TopGrades.*") then
				P_Sort_Set("grade",tonumber(diff_n[string.sub(sctext,10,-3)]));
				local gset_set = "";
				if getenv("judgesetp"..string.sub(sctext,-1)) == "default" then
					gset_set = "SM_";
				end;
				--20171229
				if gsetc[2] == "default" then
					gset_set = "SM_";
				end;
				SetAdhocPref("LastSortCh",sctext..","..gsetc[2],profile_id);
				local tg_dir = sortfiledir..ToEnumShortString(st).."_"..string.sub(sctext,-2).."_Grade_"..gset_set..string.sub(sctext,10,-3).."Meter_New.txt";
				if FILEMAN:DoesFileExist(tg_dir) then
					if sortfilecheck(tg_dir) then
						rsetting = File.Read(tg_dir);
					end;
				end;
			elseif string.find(sctext,"^UserCustom.*") then
				local uc_dir = prof_sortfiledir.."CustomSort.txt";
				if FILEMAN:DoesFileExist(uc_dir) then
					if sortfilecheck(uc_dir) then
						rsetting = File.Read(uc_dir);
						rsetting = rsetting..extralinecheck(uc_dir);
					end;
				end;
			elseif string.find(sctext,"^Favorite.*") then
				if f_count_initial(profile_id) then
					rsetting = "favorite";
				end;
			elseif sctext == "SongBranch" then
				local sb_dir = sortfiledir.."B_Music_New.txt";
				if FILEMAN:DoesFileExist(sb_dir) then
					if sortfilecheck(sb_dir) then
						rsetting = File.Read(sb_dir);
					end;
				end;
			end;
			if rsetting then
				if rsetting == "favorite" then
					local fc_pref = tonumber(GetAdhocPref("FavoriteCount",profile_id));
					local ff_dir = prof_fsortfiledir.."Favorite"..fc_pref..".txt";
					sl_f_file_read(ff_dir,tonumber(GetAdhocPref("FavoriteCount",profile_id)));
					sl_f_file_write(sortfiledir.."Main_New.txt",tonumber(GetAdhocPref("FavoriteCount",profile_id)),extralinecheck(ff_dir));
					favorite_s_table = {{},{},{},{},{}};
				else File.Write( sortfiledir.."Main_New.txt" , rsetting );
				end;
				if vcheck() ~= "5_2_0" then
					GAMESTATE:ApplyGameCommand("sort,Preferred");
				else
					if mw then
						mw:ChangeSort('Preferred');
					end;
				end;
				SONGMAN:SetPreferredSongs("Main_New.txt");
				return "r_ok";
			else
				if vcheck() ~= "5_2_0" then
					if string.find(sctext,"^UserCustom.*") or string.find(sctext,"^Favorite.*") or 
					sctext == "SongBranch" then
						GAMESTATE:ApplyGameCommand("sort,Group");
					else GAMESTATE:ApplyGameCommand("sort,"..sctext);
					end;
				else
					if mw then
						if string.find(sctext,"^UserCustom.*") or string.find(sctext,"^Favorite.*") or 
						sctext == "SongBranch" then
							mw:ChangeSort('Group');
						else
							if string.lower(sctext) == "bpm" then
								mw:ChangeSort('BPM');
							else mw:ChangeSort(sctext);
							end;
						end;
					end;
				end;
			end;
		else
			if vcheck() ~= "5_2_0" then
				GAMESTATE:ApplyGameCommand("sort,Group");
			else
				if mw then
					mw:ChangeSort('Group');
				end;
			end;
		end;

		--[ja] ランダム選曲
		if getenv("wheelsectioncsc") == randomtext then
			if getenv("rsong") ~= "" then
				local exs_oDir = split("/",getenv("rsong"));
				local exsgDir = exs_oDir[1];
				local exsDir = exs_oDir[2];
				GAMESTATE:SetCurrentSong( GetFolder2Song(exsgDir,exsDir) );
				GAMESTATE:SetPreferredSong( GetFolder2Song(exsgDir,exsDir) );
			end;
		end;
	end;
--[ja] セクションの数を計算
	local allSongs = SONGMAN:GetAllSongs();
	local bpmDivision = THEME:GetMetric("MusicWheel", "SortBPMDivision");
	local lengthDivision = THEME:GetMetric("MusicWheel", "SortLengthDivision");
	bnum = {};
	lnum = {};
	gnum = {};
	bpmseccount = 0;
	lengthseccount = 0;
	genrecount = 0;
	for t=1, #allSongs do
		local maxbpm = 0;
		local displayBPMs;
		local actualBPMs;
		local maxlength = allSongs[t]:MusicLengthSeconds();
		if not allSongs[t]:IsDisplayBpmSecret() then
			--not "???"
			displayBPMs = allSongs[t]:GetDisplayBpms();
			maxbpm = displayBPMs[2];
		else
			actualBPMs = allSongs[t]:GetTimingData():GetActualBPM();
			maxbpm = actualBPMs[2];
		end;
		local songgenre = allSongs[t]:GetGenre();

		maxbpm = math.floor(maxbpm);
		maxlength = math.floor(maxlength);

		local twbpm = (math.floor(maxbpm / bpmDivision) + 1);
		local bpmsec = twbpm * bpmDivision;
		local bpmsef = string.format( "%03i", bpmsec - bpmDivision).."-"..string.format( "%03i", bpmsec - 1);

		local twlength = (math.floor(maxlength / lengthDivision) + 1);
		local lengthsec = twlength * lengthDivision;
		local lengthsef = SecondsToMMSS(lengthsec - lengthDivision).."-"..SecondsToMMSS(lengthsec - 1);
		
		isBPMNew = true;
		for u=1, #bnum do
			if bpmsef == bnum[u][1] then
				isBPMNew = false;
				break;
			end;
		end;
		if isBPMNew then
			bnum[#bnum+1] = { bpmsef,tonumber(maxbpm) };
			bpmseccount = bpmseccount + 1;
		end;
		
		islengthNew = true;
		for v=1, #lnum do
			if lengthsef == lnum[v][1] then
				islengthNew = false;
				break;
			end;
		end;
		if islengthNew then
			lnum[#lnum+1] = { lengthsef,maxlength };
			lengthseccount = lengthseccount + 1;
		end;
		
		isgenreNew = true;
		for w=1, #gnum do
			if songgenre == gnum[w][1] then
				isgenreNew = false;
				break;
			end;
		end;
		if isgenreNew then
			gnum[#gnum+1] = { songgenre };
			genrecount = genrecount + 1;
		end;
	end;

	table.sort(bnum,
		function(a, b)
			return (a[2] < b[2])
		end
	);

	table.sort(lnum,
		function(a, b)
			return (a[2] < b[2])
		end
	);

	table.sort(gnum,
		function(a, b)
			return (a[1] < b[1])
		end
	);
end;

function csort_pset()
	local gsetpn = ToEnumShortString(GAMESTATE:GetMasterPlayerNumber());
	local gsetc = split(",",GetAdhocPref("SortGsetCheck"));
	if gsetc[1] == "P1" or gsetc[1] == "P2" then
		gsetpn = gsetc[1];
	end;
	local p = ( (gsetpn == "P1") and 1 or 2 );
	return p;
end;

function s_envcheck(scf)
	local scf_env = getenv("sloadcheckflag");
	if scf_env then
		for i = 1,#scf_env do
			if scf_env[i] then scf[i] = scf_env[i]; end;
		end;
	end;
	return scf;
end;

--20171229
function tp_gr_grade_set()
	local prof_ls = ProfIDPrefCheck("LastSortCh",ProfIDSet(csort_pset()),"Group,ntype");
	local s_sort_c = split(",",prof_ls);
	if s_sort_c[2] ~= "ntype" and s_sort_c[2] ~= "default" then
		s_sort_c[2] = "ntype";
	end;
	local gsetc = split(",",GetAdhocPref("SortGsetCheck"));
	gsetc[2] = s_sort_c[2];
	SetAdhocPref("SortGsetCheck",gsetc[1]..","..gsetc[2]);
end;

--20180209
--[ja] 読み込める曲があるか
function sortfilecheck(file)
	local f = RageFileUtil.CreateRageFile();
	f:Open(file,1);
	f:Seek(0);
	local l;
	local check = false;
	while true do
		l=f:GetLine();
		if f:AtEOF() then
			check = false;
			do break; end;
		else
			local ssp = split("/",l);
			if GetFolder2Song(ssp[1],ssp[2]) then
				check = true;
				break;
			end;
		end;
	end;
	f:Close();
	f:destroy();
	return check;
end;

--[ja] EXStageのソートにEXStageの曲が追加されていないとセクション表示が諸々おかしい問題の対策
function extralinecheck(file)
	local check = "";
	if not GAMESTATE:IsCourseMode() then
		if GAMESTATE:IsAnExtraStage() then
			local extrasong = "";
			local ssStats;
			local bExtra2 = GAMESTATE:IsExtraStage2();
			local bExtra = GAMESTATE:IsExtraStage();
			if bExtra2 then
				ssStats = STATSMAN:GetPlayedStageStats(2);
			elseif bExtra then
				ssStats = STATSMAN:GetPlayedStageStats(1);
			end;
			local ssSong = ssStats:GetPlayedSongs()[1];
			if ssStats then
				extrasong = Ex1crsCheckSelMusic(ssSong);
			end;
			local f = RageFileUtil.CreateRageFile();
			f:Open(file,1);
			f:Seek(0);
			local l;
			while true do
				l=string.lower(f:GetLine());
				if f:AtEOF() then
					check = extrasong.."\r\n";
					do break; end;
				else
					local ssp = split("/",l);
					if ssp and ssp[1] and ssp[2] then
						local songDir = ssp[1].."/"..ssp[2];
						if songDir == extrasong then
							check = "";
							break;
						end;
						--Trace("ExtraSong : "..extrasong.." : "..songDir)
					end;
				end;
			end;
			--Trace("ExtraSong : "..check)
			f:Close();
			f:destroy();
		end;
	end;
	return check;
end;
