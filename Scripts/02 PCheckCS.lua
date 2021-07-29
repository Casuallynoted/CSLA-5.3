function PCheck(gset,tier)
	if gset == "ntype" then
		local gpCSTier = {
			Grade_Tier01		= THEME:GetMetric("PlayerStageStats", "GradePercentCSTier01"),
			Grade_Tier02		= THEME:GetMetric("PlayerStageStats", "GradePercentCSTier02"),
			Grade_Tier03		= THEME:GetMetric("PlayerStageStats", "GradePercentCSTier03"),
			Grade_Tier04		= THEME:GetMetric("PlayerStageStats", "GradePercentCSTier04"),
			Grade_Tier05		= THEME:GetMetric("PlayerStageStats", "GradePercentCSTier05"),
			Grade_Tier06		= THEME:GetMetric("PlayerStageStats", "GradePercentCSTier06"),
			Grade_Tier07		= THEME:GetMetric("PlayerStageStats", "GradePercentCSTier07"),
		};
		return gpCSTier[tier]
	else
		local gpTier = {
			Grade_Tier01		= THEME:GetMetric("PlayerStageStats", "GradePercentTier01"),
			Grade_Tier02		= THEME:GetMetric("PlayerStageStats", "GradePercentTier02"),
			Grade_Tier03		= THEME:GetMetric("PlayerStageStats", "GradePercentTier03"),
			Grade_Tier04		= THEME:GetMetric("PlayerStageStats", "GradePercentTier04"),
			Grade_Tier05		= THEME:GetMetric("PlayerStageStats", "GradePercentTier05"),
			Grade_Tier06		= THEME:GetMetric("PlayerStageStats", "GradePercentTier06"),
			Grade_Tier07		= THEME:GetMetric("PlayerStageStats", "GradePercentTier07"),
		};
		return gpTier[tier]
	end;
end;

wp =  {
	TapNoteScore_W1			= THEME:GetMetric("ScoreKeeperNormal","PercentScoreWeightW1"),
	TapNoteScore_W2			= THEME:GetMetric("ScoreKeeperNormal","PercentScoreWeightW2"),
	TapNoteScore_W3			= THEME:GetMetric("ScoreKeeperNormal","PercentScoreWeightW3"),
	TapNoteScore_W4			= THEME:GetMetric("ScoreKeeperNormal","PercentScoreWeightW4"),
	TapNoteScore_W5			= THEME:GetMetric("ScoreKeeperNormal","PercentScoreWeightW5"),
	TapNoteScore_Miss			= THEME:GetMetric("ScoreKeeperNormal","PercentScoreWeightMiss"),
	HoldNoteScore_Held			= THEME:GetMetric("ScoreKeeperNormal","PercentScoreWeightHeld"),
	HoldNoteScore_LetGo			= THEME:GetMetric("ScoreKeeperNormal","PercentScoreWeightLetGo"),
	HoldNoteScore_MissedHold		= THEME:GetMetric("ScoreKeeperNormal","PercentScoreWeightMissedHold"),
	TapNoteScore_HitMine		= THEME:GetMetric("ScoreKeeperNormal","PercentScoreWeightHitMine"),
	TapNoteScore_AvoidMine		= 0,
	TapNoteScore_CheckpointHit	= THEME:GetMetric("ScoreKeeperNormal","PercentScoreWeightCheckpointHit"),
	TapNoteScore_CheckpointMiss 	= THEME:GetMetric("ScoreKeeperNormal","PercentScoreWeightCheckpointMiss"),
};

swp =  {
	TapNoteScore_W1			= THEME:GetMetric("ScoreKeeperNormal","GradeWeightW1"),
	TapNoteScore_W2			= THEME:GetMetric("ScoreKeeperNormal","GradeWeightW2"),
	TapNoteScore_W3			= THEME:GetMetric("ScoreKeeperNormal","GradeWeightW3"),
	TapNoteScore_W4			= THEME:GetMetric("ScoreKeeperNormal","GradeWeightW4"),
	TapNoteScore_W5			= THEME:GetMetric("ScoreKeeperNormal","GradeWeightW5"),
	TapNoteScore_Miss			= THEME:GetMetric("ScoreKeeperNormal","GradeWeightMiss"),
	HoldNoteScore_Held			= THEME:GetMetric("ScoreKeeperNormal","GradeWeightHeld"),
	HoldNoteScore_LetGo			= THEME:GetMetric("ScoreKeeperNormal","GradeWeightLetGo"),
	HoldNoteScore_MissedHold		= THEME:GetMetric("ScoreKeeperNormal","GradeWeightMissedHold"),
	TapNoteScore_HitMine		= THEME:GetMetric("ScoreKeeperNormal","GradeWeightHitMine"),
	TapNoteScore_AvoidMine		= 0,
	TapNoteScore_CheckpointHit	= THEME:GetMetric("ScoreKeeperNormal","GradeWeightCheckpointHit"),
	TapNoteScore_CheckpointMiss 	= THEME:GetMetric("ScoreKeeperNormal","GradeWeightCheckpointMiss"),
};

wpsetd = wp["TapNoteScore_W1"]..""..wp["TapNoteScore_W2"]..""..wp["TapNoteScore_W3"]..
	""..wp["TapNoteScore_W4"]..""..wp["TapNoteScore_W5"]..""..wp["TapNoteScore_Miss"]..
	""..math.min(math.max(tonumber(wp["HoldNoteScore_Held"]),3),3)..""..wp["HoldNoteScore_LetGo"]..""..wp["TapNoteScore_HitMine"]..
	""..wp["TapNoteScore_AvoidMine"]..""..wp["TapNoteScore_CheckpointHit"]..""..wp["TapNoteScore_CheckpointMiss"];
swpsetd = swp["TapNoteScore_W1"]..""..swp["TapNoteScore_W2"]..""..swp["TapNoteScore_W3"]..
	""..swp["TapNoteScore_W4"]..""..swp["TapNoteScore_W5"]..""..swp["TapNoteScore_Miss"]..
	""..math.min(math.max(tonumber(swp["HoldNoteScore_Held"]),6),6)..""..swp["HoldNoteScore_LetGo"]..""..swp["TapNoteScore_HitMine"]..
	""..swp["TapNoteScore_AvoidMine"]..""..swp["TapNoteScore_CheckpointHit"]..""..swp["TapNoteScore_CheckpointMiss"];
	
tldsetd = GetLifeDifficulty()..","..GetTimingDifficulty();

function ProfIDSet(p)
	if GetAdhocPref("ProfIDSetP"..p) ~= nil and GetAdhocPref("ProfIDSetP"..p) ~= "nil" then
		return GetAdhocPref("ProfIDSetP"..p)
	end
	return "P"..p;
end

function ProfIDPrefCheck(str,id,default)
	if GetAdhocPref(str,id) ~= nil and GetAdhocPref(str,id) ~= "nil" then
		return GetAdhocPref(str,id)
	end
	return default
end

--[ja] 20160405修正
function fullcombochecker(hs,SorCTime,r_save)
	local gcombo = GetAdhocPref("GoodCombo");
	local fcheck = 5;
	if tonumber(hs["SurvivalSeconds"]) >= tonumber(SorCTime) then
		if tonumber(hs["TotalSteps"]) + tonumber(hs["RadarCategory_Holds"]) + tonumber(hs["RadarCategory_Rolls"]) > 0 then
			if hs["Grade"] ~= "Grade_None" and hs["Grade"] ~= "Grade_Failed" then
				if tonumber(hs["TapNoteScore_W5"]) + tonumber(hs["TapNoteScore_Miss"]) + 
				tonumber(hs["TapNoteScore_HitMine"]) + tonumber(hs["TapNoteScore_CheckpointMiss"]) == 0 then
					if tonumber(hs["TapNoteScore_W1"]) + tonumber(hs["TapNoteScore_W2"]) + tonumber(hs["TapNoteScore_W3"]) + 
					tonumber(hs["TapNoteScore_W4"]) + tonumber(hs["HoldNoteScore_Held"]) == tonumber(hs["TotalSteps"]) + 
					tonumber(hs["RadarCategory_Holds"]) + tonumber(hs["RadarCategory_Rolls"]) then
						if tonumber(hs["TapNoteScore_W4"]) > 0 then
							if gcombo == "TapNoteScore_W4" or r_save then
								if tonumber(hs["TapNoteScore_W5"]) == 0 then
									if fcheck > 4 then fcheck = 4;
									end;
								end;
							end;
						else
							if fcheck > 3 then fcheck = 3;
							end;
							if tonumber(hs["TapNoteScore_W3"]) == 0 then
								if fcheck > 2 then fcheck = 2;
								end;
								if tonumber(hs["TapNoteScore_W2"]) == 0 and tonumber(hs["PercentScore"]) == 1 then
									if fcheck > 1 then fcheck = 1;
									end;
								end;
							end;
						end;
					end;
				end;
			end;
		end;
	end;
	return fcheck
end

function migschecker(hs,gset)
	local MIGS = 0;
	local swpset;
	if gset == "ntype" then
		swpset = wp;
	else swpset = swp;
	end;
	MIGS = tonumber(hs["TapNoteScore_W1"]) * tonumber(swpset["TapNoteScore_W1"])
		+ tonumber(hs["TapNoteScore_W2"]) * tonumber(swpset["TapNoteScore_W2"])
		+ tonumber(hs["TapNoteScore_W3"]) * tonumber(swpset["TapNoteScore_W3"])
		+ tonumber(hs["TapNoteScore_W4"]) * tonumber(swpset["TapNoteScore_W4"])
		+ tonumber(hs["TapNoteScore_W5"]) * tonumber(swpset["TapNoteScore_W5"])
		+ tonumber(hs["TapNoteScore_Miss"]) * tonumber(swpset["TapNoteScore_Miss"])
		+ tonumber(hs["HoldNoteScore_Held"]) * tonumber(swpset["HoldNoteScore_Held"])
		+ tonumber(hs["HoldNoteScore_LetGo"]) * tonumber(swpset["HoldNoteScore_LetGo"])
		+ tonumber(hs["TapNoteScore_HitMine"]) * tonumber(swpset["TapNoteScore_HitMine"]);
	return MIGS
end

function migsmaxchecker(hs,gset)
	local MIGS_MAX = 0;
	local swpset;
	if gset == "ntype" then
		swpset = wp;
	else swpset = swp;
	end;
	MIGS_MAX = tonumber(hs["TotalSteps"]) * tonumber(swpset["TapNoteScore_W1"])
			+ tonumber(hs["RadarCategory_Holds"]) * tonumber(swpset["HoldNoteScore_Held"])
			+ tonumber(hs["RadarCategory_Rolls"]) * tonumber(swpset["HoldNoteScore_Held"]);
	return MIGS_MAX
end

--[ja] 20150915 ピッタリ乗ってるのにひとつ下のランクとして判別される問題を修正 (例:88.00%はA+のはずなのにA-になる)
function gradechecker(hs,topscoregrade,SorCTime,gset,fcheck)
	local grade = "Grade_None";
	if hs["Grade"] ~= "Grade_None" then
		if tonumber(hs["SurvivalSeconds"]) >= tonumber(SorCTime) then
			if gset == "ntype" then
				if hs["Grade"] ~= "Grade_Failed" then
					if round(hs["PercentScore"],6) >= PCheck("ntype","Grade_Tier01") then grade = "Grade_Tier01"
					elseif round(hs["PercentScore"],6) >= PCheck("ntype","Grade_Tier02") then grade = "Grade_Tier02"
					elseif round(hs["PercentScore"],6) >= PCheck("ntype","Grade_Tier03") then grade = "Grade_Tier03"
					elseif round(hs["PercentScore"],6) >= PCheck("ntype","Grade_Tier04") then grade = "Grade_Tier04"
					elseif round(hs["PercentScore"],6) >= PCheck("ntype","Grade_Tier05") then grade = "Grade_Tier05"
					elseif round(hs["PercentScore"],6) >= PCheck("ntype","Grade_Tier06") then grade = "Grade_Tier06"
					else grade = "Grade_Tier07"
					end;
				else grade = "Grade_Failed";
				end;
			else
				if hs["Grade"] ~= "Grade_Failed" then
					grade = topscoregrade;
					if topscoregrade ~= "Grade_Failed" and topscoregrade ~= "Grade_None" then
						if tonumber(string.sub(topscoregrade,-2)) >= 7 and tonumber(string.sub(topscoregrade,-2)) <= 20 then
							grade = "Grade_Tier07";
						end;
					end;
					if fcheck == 1 then grade = 'Grade_Tier01'
					elseif fcheck == 2 then grade = 'Grade_Tier02'
					end;
				else grade = "Grade_Failed";
				end;
			end;
		else grade = "Grade_Failed";
		end;
	end;
	return grade
end

function assistchecker(pn,mods)
	local assist = false;
	local ctable = {
		"little","nofakes","nohands","noholds","nojumps","nolifts","nomines","noquads",
		"norolls","nostretch","autoplay","autoplaycpu","playerautoplay","assisttick"
	};
	for i=1,#ctable do
		if mods == "noset" then
			local ps = GAMESTATE:GetPlayerState(pn);
			local modstr = ps:GetPlayerOptionsArray("ModsLevel_Preferred");
			for j=1,#modstr do
				if string.lower(modstr[j]) == ctable[i] then
					assist = true;
					break;
				end;
			end;
		else
			local mos_s = split(", ",mods)
			for j=1,#mos_s do
				if string.lower(mos_s[j]) == ctable[i] then
					assist = true;
					break;
				end;
			end;
		end;
		if assist == true then
			break;
		end;
	end;
	return assist
end

--20160425
function insertchecker(pn,mods,auto)
	local ctable = {
		"wide","big","quick","bmrize","skippy","echo","stomp",
		"planted","twister","holdrolls","mines"
	};
	if auto == "controller_auto" then
		if (GAMESTATE:GetPlayerState(pn):GetPlayerController() == 'PlayerController_Autoplay') or 
		(GAMESTATE:GetPlayerState(pn):GetPlayerController() == 'PlayerController_Cpu') then
			return true;
		else ctable[#ctable+1] = "playerautoplay";
		end;
	elseif auto == "auto" then
		ctable[#ctable+1] = "playerautoplay";
	end;
	for i=1,#ctable do
		if mods == "noset" then
			local ps = GAMESTATE:GetPlayerState(pn);
			local modstr = ps:GetPlayerOptionsArray("ModsLevel_Preferred");
			for j=1,#modstr do
				if string.lower(modstr[j]) == ctable[i] then
					return true;
				end;
			end;
		else
			local mos_s = split(", ",mods)
			for j=1,#mos_s do
				if string.lower(mos_s[j]) == ctable[i] then
					return true;
				end;
			end;
		end;
	end;
end

--[ja] 20150910修正
function eachecker(tmpolts)
	--0 = normal,1 = hard,2 = easy
	if tonumber(tmpolts[1]) and tonumber(tmpolts[2]) then
		if tonumber(tmpolts[1]) > 0 and tonumber(tmpolts[2]) > 0 then
			if tonumber(tmpolts[2]) > GetTimingDifficulty() then
				return 1;
			end;
			if tonumber(tmpolts[2]) < GetTimingDifficulty() then
				return 2;
			end;
			if tonumber(tmpolts[2]) == GetTimingDifficulty() then
				if tonumber(tmpolts[1]) > GetLifeDifficulty() then
					return 1;
				end;
				if tonumber(tmpolts[1]) < GetLifeDifficulty() then
					return 2;
				end;
			end;
		end;
	end;
	return 0;
end

function hs_local_set(hs,set)
--local hs ,local bs ,local ns ,local sctable ,local bhs
	hs["Grade"]					= "Grade_None";
	hs["Score"]					= set;
	hs["PercentScore"]				= set;
	hs["TapNoteScore_W1"]			= set;
	hs["TapNoteScore_W2"]			= set;
	hs["TapNoteScore_W3"]			= set;
	hs["TapNoteScore_W4"]			= set;
	hs["TapNoteScore_W5"]			= set;
	hs["TapNoteScore_Miss"]			= set;
	hs["HoldNoteScore_Held"]			= set;
	hs["HoldNoteScore_LetGo"]		= set;
	hs["TapNoteScore_HitMine"]		= set;
	hs["TapNoteScore_CheckpointHit"]	= set;
	hs["TapNoteScore_CheckpointMiss"]	= set;
	hs["MaxCombo"]				= set;
	hs["Date"]						= "-";
	hs["Modifiers"]					= "";
	hs["TotalSteps"]				= set;
	hs["RadarCategory_Holds"]			= set;
	hs["RadarCategory_Rolls"]			= set;
	hs["RadarCategory_Mines"]			= set;
	hs["RadarCategory_Lifts"]			= set;
	hs["SurvivalSeconds"]			= set;
end

function hs_set(hs,topscore,pnstats)
	if pnstats == "pnstats" then
		hs["Grade"]					= topscore:GetGrade();
		hs["Score"]					= topscore:GetScore();
		hs["PercentScore"]				= topscore:GetPercentDancePoints();
		hs["TapNoteScore_W1"]			= topscore:GetTapNoteScores('TapNoteScore_W1');
		hs["TapNoteScore_W2"]			= topscore:GetTapNoteScores('TapNoteScore_W2');
		hs["TapNoteScore_W3"]			= topscore:GetTapNoteScores('TapNoteScore_W3');
		hs["TapNoteScore_W4"]			= topscore:GetTapNoteScores('TapNoteScore_W4');
		hs["TapNoteScore_W5"]			= topscore:GetTapNoteScores('TapNoteScore_W5');
		hs["TapNoteScore_Miss"]			= topscore:GetTapNoteScores('TapNoteScore_Miss');
		hs["HoldNoteScore_Held"]			= topscore:GetHoldNoteScores('HoldNoteScore_Held');
		hs["HoldNoteScore_LetGo"]		= topscore:GetHoldNoteScores('HoldNoteScore_LetGo');
		hs["TapNoteScore_HitMine"]		= topscore:GetTapNoteScores('TapNoteScore_HitMine');
		hs["TapNoteScore_CheckpointMiss"]	= topscore:GetTapNoteScores('TapNoteScore_CheckpointMiss');
		hs["MaxCombo"]				= topscore:MaxCombo();
		hs["Date"]						= 0;
	else
		hs["Grade"]					= topscore:GetGrade();
		hs["Score"]					= topscore:GetScore();
		hs["PercentScore"]				= topscore:GetPercentDP();
		hs["TapNoteScore_W1"]			= topscore:GetTapNoteScore("TapNoteScore_W1");
		hs["TapNoteScore_W2"]			= topscore:GetTapNoteScore("TapNoteScore_W2");
		hs["TapNoteScore_W3"]			= topscore:GetTapNoteScore("TapNoteScore_W3");
		hs["TapNoteScore_W4"]			= topscore:GetTapNoteScore("TapNoteScore_W4");
		hs["TapNoteScore_W5"]			= topscore:GetTapNoteScore("TapNoteScore_W5");
		hs["TapNoteScore_Miss"]			= topscore:GetTapNoteScore("TapNoteScore_Miss");
		hs["HoldNoteScore_Held"]			= topscore:GetHoldNoteScore("HoldNoteScore_Held");
		hs["HoldNoteScore_LetGo"]		= topscore:GetHoldNoteScore("HoldNoteScore_LetGo");
		hs["TapNoteScore_HitMine"]		= topscore:GetTapNoteScore("TapNoteScore_HitMine");
		hs["TapNoteScore_CheckpointMiss"]	= topscore:GetTapNoteScore("TapNoteScore_CheckpointMiss");
		hs["MaxCombo"]				= topscore:GetMaxCombo();
		hs["Date"]						= string.sub( topscore:GetDate(),1,10 );
		hs["Modifiers"]					= topscore:GetModifiers();
	end
end

function snum_set(num,scores,pn)
	local setnum = 0;
	if scores then
		if #scores > 0 and #scores >= num then
			setnum = num;
			for i=1,#scores do
				if insertchecker(pn,scores[num]:GetModifiers(),"auto") then
					setnum = setnum + 1;
				else break;
				end;
				if i == #scores then
					setnum = 0;
				end;
			end;
		end;
	end;
	return setnum;
end

function c_profile(pn)
	if PROFILEMAN:IsPersistentProfile(pn) then
		return PROFILEMAN:GetProfile(pn);
	end;
	return PROFILEMAN:GetMachineProfile();
end

function judge_initial(pstr)
	local gset = "ntype";
	--if not IsNetConnected() then
		gset = ProfIDPrefCheck("JudgeSet",pstr,gset);
	--else gset = "default";
	--end;
	return gset;
end

function steps_count(hs,SongOrCourse,StepsOrTrail,pn,sorc)
	if SongOrCourse and StepsOrTrail then
		hs["TotalSteps"]		= StepsOrTrail:GetRadarValues(pn):GetValue('RadarCategory_TapsAndHolds');
		hs["RadarCategory_Holds"]	= StepsOrTrail:GetRadarValues(pn):GetValue('RadarCategory_Holds');
		hs["RadarCategory_Rolls"]	= StepsOrTrail:GetRadarValues(pn):GetValue('RadarCategory_Rolls');
		if sorc == "C_Mines" or sorc == "S_Mines" then
			hs["RadarCategory_Mines"]	= StepsOrTrail:GetRadarValues(pn):GetValue('RadarCategory_Mines');
		end;
		if (sorc == "Course" or sorc == "C_Mines") and GAMESTATE:IsCourseMode() then
			hs["TotalSteps"] = 0;
			hs["RadarCategory_Holds"] = 0;
			hs["RadarCategory_Rolls"] = 0;
			if sorc == "C_Mines" then
				hs["RadarCategory_Mines"]	= 0;
			end;
			local TrailEntries = StepsOrTrail:GetTrailEntries();
			for i = 1, #TrailEntries do
				hs["TotalSteps"] 		= hs["TotalSteps"] + TrailEntries[i]:GetSteps():GetRadarValues(pn):GetValue('RadarCategory_TapsAndHolds');
				hs["RadarCategory_Holds"] 	= hs["RadarCategory_Holds"] + TrailEntries[i]:GetSteps():GetRadarValues(pn):GetValue('RadarCategory_Holds');
				hs["RadarCategory_Rolls"] 	= hs["RadarCategory_Rolls"] + TrailEntries[i]:GetSteps():GetRadarValues(pn):GetValue('RadarCategory_Rolls');
				if sorc == "C_Mines" then
					hs["RadarCategory_Mines"]	= hs["RadarCategory_Mines"] + TrailEntries[i]:GetSteps():GetRadarValues(pn):GetValue('RadarCategory_Mines');
				end;
			end;
		end;
	end
end

--20160504
function courselength(course,trail,stype)
	local ctime = 0;
	if course:GetTotalSeconds(stype) then
		ctime = course:GetTotalSeconds(stype);
	else
		ctime = 0;
		local cstepseconds = 0;
		for n=1, course:GetEstimatedNumStages() do
			if trail:GetTrailEntries()[n] then
				cstepseconds = trail:GetTrailEntries()[n]:GetSong():MusicLengthSeconds();
			end;
			ctime = ctime + cstepseconds;
		end;
	end;
	return ctime;
end

function rival_set_count()
	return 5
end

--[ja] プロファイルから自分のプロファイルを除いたテーブル
--20160724
function OpdName(profile,iv)
	local opdfile = FILEMAN:GetDirListing( "CSRealScore/*" );
	local opdname = {};
--[[
	for b = 2,5 do
		opdname[#opdname+1] = "MyBest_"..b;
	end;
]]
	if #opdfile > 0 then
		for j=1, #opdfile do
			--[ja] 自分のGUIDは省く
			if profile then
				if opdfile[j] ~= profile:GetGUID() .."_"..profile:GetDisplayName() then
				--if opdfile[j] ~= profile:GetGUID() .."_.*$" then
					if string.find(opdfile[j],"^................_.*$") then
						if iv == "name" then
							opdname[opdfile[j]] = opdfile[j];
						else opdname[#opdname+1] = opdfile[j];
						end;
					end;
				end;
			end;
		end;
	end;
	return opdname;
end;

--[ja] アクティブにできるライバルをチェックする
function rival_table(pstr,profile,id_name)
	local rv = {};
	local rt = {};
	if id_name ~= "" then
		rt[#rt+1] = id_name;
	end;
	local rs;
	if ProfIDPrefCheck("RivalSet",pstr,"") ~= "" then
		rs = split("||",ProfIDPrefCheck("RivalSet",pstr,""));
		if #rs > 0 then
			if profile then
				for r=1,#rs do
				--[[
					if string.find(rs[r],"^MyBest_.*") then
						rv[#rv+1] = {split("_",rs[r])[2],rs[r]};
					else
				]]
						for o=1,#OpdName(profile,"index") do
							if OpdName(profile,"index")[o] == rs[r] then
								if rs[r] ~= id_name then
									rv[#rv+1] = {9,rs[r]};
								end;
							end;
						end;
					--end;
				end;
			end;
		end;
	end;
	local function SortRival(r1,r2)
		return tonumber(r1[1]) > tonumber(r2[1])
	end;
	table.sort(rv,
		function(a, b)
			return SortRival(a,b)
		end
	);
	tableslice(rv,rival_set_count());
	for rr = 1,#rv do
		rt[#rt+1] = rv[rr][2];
	end;
	return rt;
end

function jbox_setting(tjudgeset,totalsteps)
	local g_judge_t_set_tbl = {};
	--[ja] 20160416修正
	if not tonumber(totalsteps) then
		totalsteps = 0;
	end;
	if (tjudgeset and string.lower(tjudgeset) ~= "x") and tonumber(totalsteps) > 0 then
		local g_judge_t_check = string.gsub(tjudgeset,"[A-D7-9]","");
		local jcsteps = 0;
		local remnant_count = 0;
		local jcsteps_plus = 0;
		local gjt_count = 0;
		
		local dcount = math.min(tonumber(totalsteps),tonumber(g_box_setcount()));
		local jcsteps = totalsteps / dcount;			--[ja] 1個あたりのボックスの判定数
		local remnant_count = jcsteps;				--[ja] 次に1つ追加するボックスの位置
		
		for gjt = 1,totalsteps do
			if gjt <= #g_judge_t_check then
				if string.sub(g_judge_t_check,gjt,gjt) == "0" or string.lower(string.sub(g_judge_t_check,gjt,gjt)) == "x" then
					gjt_count = 6;	--[ja] ミス扱い
				else gjt_count = math.max(gjt_count,tonumber(string.sub(g_judge_t_check,gjt,gjt)));	--[ja] 悪い方に合わせる
				end;
			else gjt_count = 6;		--[ja] ミス扱い
			end;
			--[ja] 20150819修正 同じ数値でも切り下げないとダメみたいで…浮動小数点数か
			if gjt == totalsteps then
				remnant_count = math.floor(remnant_count);
			end;
			--Trace("Check : "..remnant_count..","..gjt_count);
			if gjt >= remnant_count then
				remnant_count = remnant_count + jcsteps;		--[ja] 次に1つ追加するボックスの位置
				g_judge_t_set_tbl[#g_judge_t_set_tbl+1] = gjt_count;	--[ja] 平均書き込み
				gjt_count = 0;		--[ja] 判定カウント数リセット
			end;
		end;
	end;
	return g_judge_t_set_tbl;
end

function r_t_table()
	local target_table = {
		base = {
			'Off','MyBest','Pacemaker : AAA','Pacemaker : AA','Pacemaker : A+',
			'Pacemaker : A-','Pacemaker : 100%','Pacemaker : 95%','Pacemaker : 90%',
			'Pacemaker : 85%','Pacemaker : 80%'
		},
		savebase = {
			'Off','MyBest','Tier01','Tier02','Tier03','Tier04','1','0.95','0.9','0.85','0.8'
		},
	}
	return target_table
end

function rtableset(pn)
	local target_table = r_t_table();
	local p = (pn == PLAYER_1) and 1 or 2;
	local pstr = ProfIDSet(p);
	local rv_table;
	local m_check = 0;
	local i_sn = 3;
	local i_n = 2;
	if PROFILEMAN:IsPersistentProfile(pn) then
		local profile = PROFILEMAN:GetProfile(pn);
		if #rival_table(pstr,profile,"") > 0 then
			rv_table = rival_table(pstr,profile,"");
		end;
		if rv_table then
			for rival in ivalues(rv_table) do
--[[
				if string.find(rival,"^MyBest.*") then
					table.insert(target_table.base, i_sn,"MyBest "..FormatNumberAndSuffix(split("_",rival)[2]));
					table.insert(target_table.savebase, i_sn,"MyBest_"..split("_",rival)[2]);
					--i_sn = i_sn + 1;
				elseif rival == OpdName(profile,"name")[rival] then
]]
				if rival == OpdName(profile,"name")[rival] then
					local r_d_id = string.sub(rival,18);
					target_table.base[#target_table.base+1] = "Rival : "..r_d_id;
					target_table.savebase[#target_table.savebase+1] = "RIVAL_"..rival;
					m_check = 1;
				end;
			end;
			local misc_table = {"Average","On 1 rank","TopScore"};
			if m_check > 0 then
				for misc in ivalues(misc_table) do
					target_table.base[#target_table.base+1] = "Rival : "..misc;
					if misc == "On 1 rank" then
						target_table.savebase[#target_table.savebase+1] = "RIVAL_On1rank";
					else target_table.savebase[#target_table.savebase+1] = "RIVAL_"..misc;
					end;
				end;
			end;
		end;
	end;
	return target_table
end;

--20161123
function cs_avatar_set(hsset,rv_table,profile,pstr)
	local path = "";
	local file = "";
	if string.sub(hsset[2],1,16) == profile:GetGUID() then 
		if FILEMAN:DoesFileExist( ProfIDPrefCheck("ProfAvatar",pstr,"Off") ) then
			file = ProfIDPrefCheck("ProfAvatar",pstr,"Off");
		end;
	else
		for o=1,2 do
			local pfacheck = false;
			for j=1,#rv_table do
				if rv_table[j] == hsset[2] then
					if o == 1 then
						path = "CSRealScore/"..rv_table[j].."/";
					elseif o == 2 then
						for p = 0,PROFILEMAN:GetNumLocalProfiles()-1 do
							local profid = PROFILEMAN:GetLocalProfileFromIndex(p);
							local pid = PROFILEMAN:GetLocalProfileIDFromIndex(p);
							if profid:GetGUID() == string.sub(rv_table[j],1,16) then
								path = PROFILEMAN:LocalProfileIDToDir(pid);
								if ProfIDPrefCheck("ProfAvatar",pid,"Off") ~= "Off" then
									path = ProfIDPrefCheck("ProfAvatar",pid,"Off");
									pfacheck = true;
								end;
								break;
							end;
						end;
					end;
					break;
				end;
			end;
			if path ~= "" then
				if not pfacheck then
					for k=1, #extension do
						local imgfile = FILEMAN:GetDirListing( path.."CSAvatar."..extension[k] );
						if #imgfile > 0 then
							for m=1, #imgfile do
								if imgfile[m] then
									file = path..""..string.lower(imgfile[1]);
									break;
								end;
							end;
						end;
					end;
				else file = path;
				end;
			else break;
			end;
			if pfacheck == true then
				break;
			end;
		end;
	end;
	return file;
end;

