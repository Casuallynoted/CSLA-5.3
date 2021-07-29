local t = Def.ActorFrame{};

local gset;

local hs = {};
hs_local_set(hs,0);
hs["fcheck"]	= 5;
hs["Grade"]	= "Grade_Tier22";

local ymd = string.format("%04i",Year())..""..string.format("%02i",(MonthOfYear() + 1))..""..string.format("%02i",DayOfMonth());

local csl_c = GetAdhocPref("CSLSetApp") == "00000001" or GetAdhocPref("CSLSetApp") == "32594786";
local ccc = false;
if FILEMAN:DoesFileExist( cap_path ) then
	ccc = true;
else
	if GetAdhocPref("CSLSetApp") then
		if csl_c then
			ccc = true;
		end;
	end;
end;

local maxStages = PREFSMAN:GetPreference("SongsPerPlay");
local stageplay = not IsNetConnected() and not GAMESTATE:IsEventMode() and maxStages >= 3;

local pm = GAMESTATE:GetPlayMode();
local psStats = STATSMAN:GetPlayedStageStats(1);
local players = #GAMESTATE:GetHumanPlayers();
local ssStats = STATSMAN:GetCurStageStats();
local pnstats;
local failed;

local coursemode = GAMESTATE:IsCourseMode();
local stindex = 1;
local g_group = "false";
local cgp_s;
if GetCCParameter("cGp") ~= "" then
	cgp_s = split(":",GetCCParameter("cGp"));
end;

local extra = (getenv("exflag") ~= "csc" and psStats:GetStage() == "Stage_Extra1");
local extra2 = (getenv("exflag") ~= "csc" and getenv("omsflag") == 0 and psStats:GetStage() == "Stage_Extra2");
local cscex = (getenv("exflag") == "csc" and psStats:GetStage() == "Stage_Extra1");
local cscex2 = (getenv("exflag") == "csc" and getenv("omsflag") == 1 and psStats:GetStage() == "Stage_Extra2");

--[ja] 基準点
local point = {0,0};
local failpoint = {0,0};
local copoint = {0,0};
local expoint = {0,0};
local cgppoint = 0;
local espoint = 0;
local kpoint = 1;
local failcheck = 1;
if players > 1 then
	failcheck = failcheck * 2;
	if pm == 'PlayMode_Rave' then 
		kpoint = kpoint * 2;
	end;
end;
for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
	if pn then
		stindex = 1;
		local p = ( (pn == PLAYER_1) and 1 or 2 );
		local pstr = ProfIDSet(p);
		if not IsNetConnected() then
			if pn == PLAYER_1 then
				gset = ProfIDPrefCheck("JudgeSet",pstr,"ntype");
			else
				gset = ProfIDPrefCheck("JudgeSet",pstr,"ntype");
			end;
		else
			gset = "default";
		end;

		-- [ja] カバーポジション・グラフ位置 ---------------------------
		--local coverpos = ProfIDPrefCheck("CoverPos",pstr,140);
		if getenv("coverpos"..pstr) then
			SetAdhocPref("CoverPos",getenv("coverpos"..pstr),pstr);
		end;
		if getenv("graphdistance"..pstr) then
			SetAdhocPref("GraphDistance",getenv("graphdistance"..pstr),pstr);
		end;
		-----------------------------------------------
		--[ja] failedチェック
		if ssStats then
			pnstats = ssStats:GetPlayerStageStats(pn);
			if pnstats then
				hs_set(hs,pnstats,"pnstats");
				hs["SurvivalSeconds"]	= pnstats:GetSurvivalSeconds();
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
		steps_count(hs,SongOrCourse,StepsOrTrail,pn,"Course");
		if GAMESTATE:IsCourseMode() then
			local co_stage = SongOrCourse:GetEstimatedNumStages();
			local stindex = getenv("coursestindex");
			if stindex >= co_stage then
				stepseconds = stindex;
			else
				stepseconds = stindex + 10;
			end;
			if SongOrCourse:IsAutogen() then
				cautogen = 1;
			end;
			if SongOrCourse:GetCourseType() == 'CourseType_Endless' or SongOrCourse:GetCourseType() == 'CourseType_Survival' then
				cautogen = 1;
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
		--[ja] 20150426修正
		if tonumber(getenv("fcplayercheck_p"..p)) == 0 then
			if pnstats then
				hs["Grade"] = gradechecker(hs,pnstats:GetGrade(),stepseconds,gset,getenv("fullcjudgep"..p));
				--failed = tonumber(getenv("fcplayercheck_p"..p)) > 0 or pnstats:GetGrade() == "Grade_Failed" or pnstats:GetFailed();
				failed = hs["Grade"] == "Grade_Failed" or pnstats:GetFailed();
				if failed then
					failpoint[p] = kpoint;
					stindex = 0;
				else
					if coursemode then
						if (pm == 'PlayMode_Nonstop' and stindex >= 4) or 
						(pm == 'PlayMode_Oni' and stindex >= 5) then
							copoint[p] = kpoint;
						end;
					else
						if psStats:GetPlayedSongs()[1]:IsLong() then
							stindex = 2;
						elseif psStats:GetPlayedSongs()[1]:IsMarathon() then
							stindex = 3;
						end;
					end;
					if extra or extra2 or cscex or cscex2 then
						expoint[p] = kpoint;
					end;
				end;
				if coursemode then
					stindex = pnstats:GetSongsPassed();
				end;
				point[p] = kpoint * stindex;
			end;
		end;
	end;
end;
if failpoint[1] + failpoint[2] < failcheck then
--[ja] どちらか一人クリア
	if cgp_s then
		if #cgp_s == 2 or #cgp_s == 5 then
			cgppoint = 1;
		end;
	end;
	espoint = 1;

	if stageplay then
		if psStats:GetStage() == "Stage_1st" then
			g_group = psStats:GetPlayedSongs()[1]:GetGroupName();
			if cgp_s then
				for gp=1,#cgp_s do
					if cgp_s[gp] == g_group then
						g_group = "false";
						break;
					end;
				end;
			end;
		else
			if GetAdhocPref("G_Group") then
				g_group = GetAdhocPref("G_Group");
			end;
			--[ja] extraの時は確認しなくても問題ない。あとで再確認
			if psStats:GetStage() ~= "Stage_Extra1" and psStats:GetStage() ~= "Stage_Extra2" then
				if g_group ~= "false" then
					if cgp_s then
						for gp=1,#cgp_s do
							if cgp_s[gp] == g_group then
								g_group = "false";
								break;
							end;
						end;
					end;
					if g_group ~= psStats:GetPlayedSongs()[1]:GetGroupName() then
						g_group = "false";
					end;
				end;
			end;
		end;
	end;
else
--[ja] それ以外
	g_group = "false";
end;

local setpoint = point[1] + point[2];
local setfailpoint = failpoint[1] + failpoint[2];
local setcopoint = copoint[1] + copoint[2];
local setexpoint = expoint[1] + expoint[2];
--SCREENMAN:SystemMessage(setpoint..","..setfailpoint..","..setcopoint..","..setexpoint..","..cgppoint..","..espoint);
SetAdhocPref("G_Group",g_group);
--[ja] あとで再確認
local csffex = tostring(g_group) ~= "false" and psStats:GetStage() == "Stage_Extra2";
--SCREENMAN:SystemMessage(tostring(hs["Grade"]));
---------------------------------------------------------------------------------------------------------------------------------------
--coflag
	
if getenv("evacountupflag") == 1 then
	function CheckCountFlag(ccname,cpoint)
		local ccCount = cpoint;
		--up	-----------------------------------------
		if ccc then
			if ccname == "Sco" then
				if tonumber( ccCount ) < 1 then
					ccCount = 1;
				end;
			elseif ccname == "Non" then
				if tonumber( ccCount ) < 3 then
					ccCount = 3;
				end;
			elseif ccname == "Cha" then
				if tonumber( ccCount ) < 3 then
					ccCount = 3;
				end;
			elseif ccname == "Rav" then
				if tonumber( ccCount ) < 20 then
					ccCount = 20;
				end;
			elseif ccname == "End" then
				if tonumber( ccCount ) < 1 then
					ccCount = 1;
				end;
			end;
		end;

		if pm == 'PlayMode_Regular' then
			if stageplay then
				--ex		--------------------------------
				if ccname == "Ecco" and extra then
					ccCount = ccCount + setexpoint;
				elseif ccname == "Esco" and extra2 then
					ccCount = ccCount + setexpoint;
				elseif ccname == "Ccco" and cscex then
					ccCount = ccCount + setexpoint;
				elseif ccname == "Csco" and cscex2 then
					ccCount = ccCount + setexpoint;
				end;
				--cgp	--------------------------------
				if ccname == "Elco" then
					if csffex then
						if cgp_s then
							if #cgp_s == 2 or #cgp_s == 5 then
								ccCount = ccCount + cgppoint;
							end;
						end;
					end;
				end;
			end;
			if failpoint[1] + failpoint[2] < failcheck then
				if ccname == "Elco" and tobool(GetAdhocPref("CSLAEasterEggs")) == true then
					if tonumber( ccCount ) >= 1 and tonumber(ymd) >= 20160211 then
						ccCount = math.max(ccCount,2);
					elseif tonumber(ymd) >= 20151129 then
						ccCount = math.max(ccCount,1);
					end;
				end;
			end;
		--co		-----------------------------------------
		elseif ccname == "Non" and pm == 'PlayMode_Nonstop' then
			ccCount = ccCount + setcopoint;
		--co		-----------------------------------------
		elseif ccname == "Cha" and pm == 'PlayMode_Oni' then
			ccCount = ccCount + setcopoint;
		--po		-----------------------------------------
		elseif ccname == "Rav" and pm == 'PlayMode_Rave' then
			ccCount = ccCount + setpoint;
		end;
		--po		-----------------------------------------
		if ccname == "Sco" then
			ccCount = ccCount + setpoint;
		--po		-----------------------------------------
		elseif ccname == "Lco" then
			ccCount = ccCount + setpoint;
		--fail	-----------------------------------------
		elseif ccname == "End" then
			ccCount = ccCount + setfailpoint;
		end;

		return ccCount;
	end;

	function eCheckCountFlag(ecf,cpoint)
		local ecCount = cpoint;
		local ecsong = "";
		local ecf_d = "/Songs/"..ecf.."/";
		local ecf_ad = "/AdditionalSongs/"..ecf.."/";
		if psStats then
			for ps = 1, #psStats:GetPlayedSongs() do
				local ecfs = psStats:GetPlayedSongs()[ps]:GetSongDir();
				if ecf_d == ecfs or ecf_ad == ecfs then
					ecsong = ecfs;
					break;
				end;
			end;
		end;
		if ecsong ~= "" then
			ecCount = ecCount + espoint;
		end;
		return ecCount;
	end;

	function FlagUpper(cname,ccount,cfcount)
		local ecCount = cfcount;
		if cname == "Sco" then
			if tonumber( ccount ) >= 1 and tonumber( ccount ) < 20 then
				if tonumber( cfcount ) ~= 1 then ecCount = 0; end;
			elseif tonumber( ccount ) >= 20 and tonumber( ccount ) < 50 then
				if tonumber( cfcount ) ~= 2 then ecCount = 1; end;
			elseif tonumber( ccount ) >= 50 and tonumber( ccount ) < 100 then
				if tonumber( cfcount ) ~= 3 then ecCount = 2; end;
			elseif tonumber( ccount ) >= 100 and tonumber( ccount ) < 200 then
				if tonumber( cfcount ) ~= 4 then ecCount = 3; end;
			elseif tonumber( ccount ) >= 200 then
				if tonumber( cfcount ) ~= 5 then ecCount = 4; end;
			end;
		elseif ccName == "Lco" then
			if tonumber( ccount ) >= 50 then
				if tonumber( cfcount ) ~= 1 then ecCount = 0; end;
			end;
		elseif cname == "Ecco" or cname == "Esco" or cname == "Ccco" or cname == "Csco" then
			if tonumber( ccount ) >= 5 then
				if tonumber( cfcount ) ~= 1 then ecCount = 0; end;
			end;
		elseif cname == "Elco" then
			if tonumber( ccount ) == 1 then
				if tonumber( cfcount ) ~= 1 then ecCount = 0; end;
			elseif tonumber( ccount ) >= 2 then
				if tonumber( cfcount ) ~= 2 then ecCount = 1; end;
			end;
		elseif cname == "Non" or cname == "Cha" then
			if tonumber( ccount ) >= 3 then
				if tonumber( cfcount ) ~= 1 then ecCount = 0; end;
			end;
		elseif cname == "End" then
			if tonumber( ccount ) >= 1 then
				if tonumber( cfcount ) ~= 1 then ecCount = 0; end;
			end;
		elseif cname == "Rav" then
			if tonumber( ccount ) >= 20 then
				if tonumber( cfcount ) ~= 1 then ecCount = 0; end;
			end;
		elseif cname == "R7-4thMix" then
			if tonumber( ccount ) >= 1 then
				if tonumber( cfcount ) ~= 1 then ecCount = 0; end;
			end;
		end;
		return ecCount;
	end;

	local checktable = {
		{ Name = "Sco" , Count = 0 , Flagcount = 0 },
		{ Name = "Lco" , Count = 0 , Flagcount = 0 },
		{ Name = "Non" , Count = 0 , Flagcount = 0 },
		{ Name = "Cha" , Count = 0 , Flagcount = 0 },
		{ Name = "End" , Count = 0 , Flagcount = 0 },
		{ Name = "Rav" , Count = 0 , Flagcount = 0 },
		{ Name = "Ecco" , Count = 0 , Flagcount = 0 },
		{ Name = "Esco" , Count = 0 , Flagcount = 0 },
		{ Name = "Ccco" , Count = 0 , Flagcount = 0 },
		{ Name = "Csco" , Count = 0 , Flagcount = 0 },
		{ Name = "Elco" , Count = 0 , Flagcount = 0 },
	};
	local ecftable = {
		{ Ecf = "R7-4thMix -Phase 2 Phase-/Mercurio" , Name = "R7-4thMix" , Count = 0 , Flagcount = 0 },
	};

	function GetCheckCount(setc)
		local cpoint = {};
		local f_point;
		local settable;
		local f_flag = "";
		if GetCCParameter(setc) ~= "" then
			f_flag = split(":",GetCCParameter(setc));
		end;
		if setc == "Status" then
			settable = checktable;
		elseif setc == "e_Status" then
			settable = ecftable;
		end;
		if FILEMAN:DoesFileExist( cc_path ) then
			for idx, cat in pairs(settable) do
				local cF = "";
				if setc == "e_Status" then
					cF = cat.Ecf;
				end;
				local cName = cat.Name;
				local cCount = cat.Count;
				local cFcount = cat.Flagcount;
				local check = 1;
				if #f_flag > 0 then
					for fp=1,#f_flag do
						if f_flag[fp] ~= "" then
							f_point = split(",",f_flag[fp]);
							if #f_point >= 2 then
								if f_point[1] == cName then
									if tonumber(f_point[2]) then
										if tonumber(f_point[2]) <= 100001 then
											if tonumber(f_point[2]) >= tonumber(cCount) then
												if setc == "Status" then
													cCount = CheckCountFlag(cName,f_point[2]);
												elseif setc == "e_Status" then
													cCount = eCheckCountFlag(cF,f_point[2]);
												end;
											end;
										else
											cCount = 100001;
										end;
									else
										if setc == "Status" then
											cCount = CheckCountFlag(cName,0);
										elseif setc == "e_Status" then
											cCount = eCheckCountFlag(cF,0);
										end;
									end;
									if tonumber(f_point[3]) then
										cFcount = FlagUpper(cName,cCount,f_point[3]);
									end;
									check = 0;
								end;
							end;
						end;
					end;
				end;
				--[ja] 記述がないとフラグ確認せず0を書き込んで終了だったので20140831修正
				if check == 1 then
					if setc == "Status" then
						cCount = CheckCountFlag(cName,0);
					elseif setc == "e_Status" then
						cCount = eCheckCountFlag(cF,0);
					end;
					cFcount = FlagUpper(cName,cCount,0);
				end;
				cpoint[#cpoint+1] = { ""..cName..","..cCount..","..cFcount..":" };
			end;
		else
			for idx, cat in pairs(settable) do
				local cF = "";
				if setc == "e_Status" then
					cF = cat.Ecf;
				end;
				local cName = cat.Name;
				local cCount = cat.Count;
				local cFcount = cat.Flagcount;
				if setc == "Status" then
					cCount = CheckCountFlag(cName,0);
				elseif setc == "e_Status" then
					cCount = eCheckCountFlag(cF,0);
				end;
				cFcount = FlagUpper(cName,cCount,0);
				cpoint[#cpoint+1] = { ""..cName..","..cCount..","..cFcount..":" };
			end;
		end;
		return cpoint;
	end;
	local CCList = GetCheckCount("Status");
	local ccptext = "";
	local ECList = GetCheckCount("e_Status");
	local ecptext = "";

	for i=1, #checktable do
		if CCList[i] then
			ccptext = ccptext..""..table.concat(CCList[i]);
		else ccptext = ccptext;
		end;
	end;
	for j=1, #ecftable do
		if ECList[j] then
			ecptext = ecptext..""..table.concat(ECList[j]);
		else ecptext = ecptext;
		end;
	end;
	ccptext = string.sub(ccptext,1,-2);
	ecptext = string.sub(ecptext,1,-2);

	local cgptext = "";
	if csffex then
		if GetCCParameter("cGp") ~= "" then
			cgptext = cgptext..""..GetCCParameter("cGp")..":"..g_group;
		else cgptext = cgptext..""..g_group;
		end;
	else
		if GetCCParameter("cGp") ~= "" then
			cgptext = cgptext..""..GetCCParameter("cGp");
		end;
	end;
	--ccptext = ccptext..";\r\n"..ecptext..";\r\n"..cgptext..";\r\n";
	--File.Write( cc_path , ccptext );
	setenv("ffset",{ccptext,ecptext,cgptext});
	setenv("evacountupflag",0);
	setenv("evacheckflag",1);
	--MESSAGEMAN:Broadcast("CountCheck",{Status = ccptext , e_Status = ecptext , cGp = cgptext});
end;

---------------------------------------------------------------------------------------------------------------------------------------

return t;