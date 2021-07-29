
-- [ja] group.iniから任意の値を取得 (グループ名,パラメータ名) 
function GetGroupParameter(group,prm)
	local gpath;
	if FILEMAN:DoesFileExist("/Songs/"..group.."/group.ini")  then
		gpath="/Songs/"..group.."/group.ini";
	elseif FILEMAN:DoesFileExist("/AdditionalSongs/"..group.."/group.ini") then
		gpath="/AdditionalSongs/"..group.."/group.ini";
	else
		return "";
	end;
	local f = RageFileUtil.CreateRageFile();
	f:Open(gpath,1);
	local tmp = GetSMParameter_f(f,prm);
	f:Close();
	f:destroy();
	return tmp;
end;

function GetCSCParameter(group,prm,pname)
	local gpath;
	if FILEMAN:DoesFileExist("CSDataSave/"..pname.."_Save/0000_co "..group.."")  then
		gpath = "CSDataSave/"..pname.."_Save/0000_co "..group.."";
	else
		return "";
	end;
	local f = RageFileUtil.CreateRageFile();
	f:Open(gpath,1);
	local tmp = GetSMParameter_f(f,prm);
	f:Close();
	f:destroy();
	return tmp;
end;

function GetCCParameter(prm)
	local gpath;
	if FILEMAN:DoesFileExist(cc_path)  then
		gpath = cc_path;
	else
		return "";
	end;
	local f = RageFileUtil.CreateRageFile();
	f:Open(gpath,1);
	local tmp = GetSMParameter_f(f,prm);
	f:Close();
	f:destroy();
	return tmp;
end;

function GetPDParameter(prm,pname,gname)
	local gpath;
	if FILEMAN:DoesFileExist("CSDataSave/"..pname.."_Save/0002_dt "..gname.."")  then
		gpath = "CSDataSave/"..pname.."_Save/0002_dt "..gname.."";
	else
		return "";
	end;
	local f = RageFileUtil.CreateRageFile();
	f:Open(gpath,1);
	local tmp = GetSMParameter_f(f,prm);
	f:Close();
	f:destroy();
	return tmp;
end;

function GetRSParameter(rf_path,prm)
	local gpath;
	if FILEMAN:DoesFileExist(rf_path)  then
		gpath = rf_path;
	else
		return "";
	end;
	local f = RageFileUtil.CreateRageFile();
	f:Open(gpath,1);
	local tmp = GetSMParameter_f(f,prm);
	f:Close();
	f:destroy();
	return tmp;
end;

--[ja] ボスフォルダ関係の命令
--[ja] 平均等取得用
grade = {
	Grade_Tier01=0,
	Grade_Tier02=1,
	Grade_Tier03=2,
	Grade_Tier04=3,
	Grade_Tier05=4,
	Grade_Tier06=5,
	Grade_Tier07=6,
	Grade_Tier08=7,
	Grade_Tier09=8,
	Grade_Tier10=9,
	Grade_Tier11=10,
	Grade_Tier12=11,
	Grade_Tier13=12,
	Grade_Tier14=13,
	Grade_Tier15=14,
	Grade_Tier16=15,
	Grade_Tier17=16,
	Grade_Tier18=17,
	Grade_Tier19=18,
	Grade_Tier20=19,
	Grade_Failed=20
};
local dif_list={
	'Difficulty_Beginner',
	'Difficulty_Easy',
	'Difficulty_Medium',
	'Difficulty_Hard',
	'Difficulty_Challenge',
};

--------------------------------------------------------------------------------------------------------
-- [ja] EXFolderのライフ設定 
function EXFolderLifeSetting()
	if (getenv("exflag") == "csc" or getenv("omsflag") == 1) and not GAMESTATE:IsEventMode() then
		local failtype = "FailType_Immediate";
		local so;
		local exll
		if getenv("ExLifeLevel") ~= "" then
			exll = getenv("ExLifeLevel");
		else
			exll = "Normal"
		end;
		if vcheck() then
			for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
				local ps = GAMESTATE:GetPlayerState(pn);
				if exll ~= "Normal" and exll ~= "Hard" and exll ~= "HardNoRecover" 
					and exll ~= "NoRecover" and exll ~= "Suddendeath" then
					ps:GetPlayerOptions("ModsLevel_Preferred"):LifeSetting("LifeType_Battery");
					ps:GetPlayerOptions("ModsLevel_Stage"):LifeSetting("LifeType_Battery");
					
					if exll == "MFC" or exll == "PFC" then
						ps:GetPlayerOptions("ModsLevel_Preferred"):BatteryLives(1);
						ps:GetPlayerOptions("ModsLevel_Stage"):BatteryLives(1);
					else
						ps:GetPlayerOptions("ModsLevel_Preferred"):BatteryLives(exll);
						ps:GetPlayerOptions("ModsLevel_Stage"):BatteryLives(exll);
					end;
				else
					ps:GetPlayerOptions("ModsLevel_Preferred"):LifeSetting("LifeType_Bar");
					ps:GetPlayerOptions("ModsLevel_Stage"):LifeSetting("LifeType_Bar");
					if exll == "HardNoRecover" then
						ps:GetPlayerOptions("ModsLevel_Preferred"):DrainSetting("DrainType_NoRecover");
						ps:GetPlayerOptions("ModsLevel_Stage"):DrainSetting("DrainType_NoRecover");
						setenv("ExLifeLevel","Hard");
					elseif exll == "NoRecover" then
						ps:GetPlayerOptions("ModsLevel_Preferred"):DrainSetting("DrainType_NoRecover");
						ps:GetPlayerOptions("ModsLevel_Stage"):DrainSetting("DrainType_NoRecover");
						setenv("ExLifeLevel","Normal");
					elseif exll == "Suddendeath" then
						ps:GetPlayerOptions("ModsLevel_Preferred"):DrainSetting("DrainType_SuddenDeath");
						ps:GetPlayerOptions("ModsLevel_Stage"):DrainSetting("DrainType_SuddenDeath");
					else
						ps:GetPlayerOptions("ModsLevel_Preferred"):DrainSetting("DrainType_Normal");
						ps:GetPlayerOptions("ModsLevel_Stage"):DrainSetting("DrainType_Normal");
					end;
				end;
				ps:GetPlayerOptions("ModsLevel_Preferred"):FailSetting(failtype);
				ps:GetPlayerOptions("ModsLevel_Stage"):FailSetting(failtype);
				MESSAGEMAN:Broadcast( "PlayerOptionsChanged", {PlayerNumber = pn} );
				--Trace("Fail : "..ps:GetPlayerOptions("ModsLevel_Preferred"):FailSetting())
			end;
		else
			if exll ~= "Normal" and exll ~= "Hard" and exll ~= "HardNoRecover" 
				and exll ~= "NoRecover" and exll ~= "Suddendeath" then
				if exll == "MFC" or exll == "PFC" then
					so = "battery,faildefault,1 life";
				else
					if exll == "1" then
						so = "battery,faildefault,1 life";
					else
						so = "battery,faildefault,"..exll.." lives";
					end;
				end;
			elseif exll == "HardNoRecover" then
				so = "bar,failimmediate,norecover";
				setenv("ExLifeLevel","Hard");
			elseif exll == "NoRecover" then
				so = "bar,failimmediate,norecover";
				setenv("ExLifeLevel","Normal");
			elseif exll == "Suddendeath" then
				so = "bar,failimmediate,suddendeath";
			else
				so = "bar,failimmediate,normal-drain";
			end;
			GAMESTATE:SetSongOptions( "ModsLevel_Stage", so );
			MESSAGEMAN:Broadcast( "SongOptionsChanged" );
		end;
	end;
end;

--[ja] 平均ステータス 第2パラメータは取得する内容（平均/MAX/MIN/ラスト） 第3パラメータは以上/以下（and over/and under） 
--[[
	例：過去[MAXSTAGE]ステージの平均ダンスポイント（％）を求め、1P、2Pの高いほうを返す
	ret = GetStageState("pdp", "AVG", "+")

	例：過去[MAXSTAGE]ステージの最高コンボ数を求め、1P、2Pの低いほうを返す
	ret = GetStageState("Combo", "MAX", "-")

	例：最終ステージのグレードを求め、1P、2Pの低い（※グレードは低いほうが上位）ほうを返す
	ret = GetStageState("Grade", "Last", "-")
--]]

function GetStageState(prm,mode,overunder)
	local maxstages = PREFSMAN:GetPreference("SongsPerPlay")
	--[ja] STAGE 1の時は取得不可能 
	if GAMESTATE:GetCurrentStageIndex() < 1 then return 0 end;
	local chk_stat = {0,0,"",""};	--[ja] 第二パラメータが数値の場合 
	local sprm = string.lower(prm);
	local smode = string.lower(mode);
	local chk_loop = ((smode == "last") and 1 or maxstages);
	if sprm == "grade" then
		for p=1,2 do
			local pn=((p==1) and PLAYER_1 or PLAYER_2);
			for i=1,chk_loop do
			local ss=STATSMAN:GetPlayedStageStats(i);
				if GAMESTATE:IsPlayerEnabled(pn) then
					local pss_grade=ss:GetPlayerStageStats(pn):GetGrade();
					local chk_var=grade[pss_grade];
					if i==1 then
						chk_stat[p]=chk_var
					elseif smode=="max" then
						if chk_var>chk_stat[p] then chk_stat[p]=chk_var end;
					elseif smode=="min" then
						if chk_var<chk_stat[p] then chk_stat[p]=chk_var end;
					else
						chk_stat[p]=chk_stat[p]+chk_var;
					end;
				end;
			end;
			if smode=="avg" then chk_stat[p]=chk_stat[p]/chk_loop end;
		end;
	elseif sprm == "dancepoints" or sprm == "dp" then
		for p=1,2 do
			local pn=((p==1) and PLAYER_1 or PLAYER_2);
			for i=1,chk_loop do
			local ss=STATSMAN:GetPlayedStageStats(i);
				if GAMESTATE:IsPlayerEnabled(pn) then
					local chk_var=ss:GetPlayerStageStats(pn):GetActualDancePoints();
					if i==1 then
						chk_stat[p]=chk_var
					elseif smode=="max" then
						if chk_var>chk_stat[p] then chk_stat[p]=chk_var end;
					elseif smode=="min" then
						if chk_var<chk_stat[p] then chk_stat[p]=chk_var end;
					else
						chk_stat[p]=chk_stat[p]+chk_var;
					end;
				end;
			end;
			if smode=="avg" then chk_stat[p]=chk_stat[p]/chk_loop end;
		end;
	elseif sprm == "perdancepoints" or sprm == "pdp" then
		for p=1,2 do
			local pn=((p==1) and PLAYER_1 or PLAYER_2);
			for i=1,chk_loop do
			local ss=STATSMAN:GetPlayedStageStats(i);
				if GAMESTATE:IsPlayerEnabled(pn) then
					local chk_var=ss:GetPlayerStageStats(pn):GetPercentDancePoints();
					if i==1 then
						chk_stat[p]=chk_var
					elseif smode=="max" then
						if chk_var>chk_stat[p] then chk_stat[p]=chk_var end;
					elseif smode=="min" then
						if chk_var<chk_stat[p] then chk_stat[p]=chk_var end;
					else
						chk_stat[p]=chk_stat[p]+chk_var;
					end;
				end;
			end;
			if smode=="avg" then chk_stat[p]=chk_stat[p]/chk_loop end;
		end;
	elseif sprm=="combo" or sprm=="maxcombo" then
		for p=1,2 do
			local pn=((p==1) and PLAYER_1 or PLAYER_2);
			for i=1,chk_loop do
			local ss=STATSMAN:GetPlayedStageStats(i);
				if GAMESTATE:IsPlayerEnabled(pn) then
					local chk_var=ss:GetPlayerStageStats(pn):MaxCombo();
					if i==1 then
						chk_stat[p]=chk_var
					elseif smode=="max" then
						if chk_var>chk_stat[p] then chk_stat[p]=chk_var end;
					elseif smode=="min" then
						if chk_var<chk_stat[p] then chk_stat[p]=chk_var end;
					else
						chk_stat[p]=chk_stat[p]+chk_var;
					end;
				end;
			end;
			if smode=="avg" then chk_stat[p]=chk_stat[p]/chk_loop end;
		end;
	elseif sprm=="meter" then
	--[ja] Meterは#METERTYPEの値によって変わるのであまり使わないほうがいいかも 
		for p=1,2 do
			local pn=((p==1) and PLAYER_1 or PLAYER_2);
			for i=1,chk_loop do
			local ss=STATSMAN:GetPlayedStageStats(i);
				if GAMESTATE:IsPlayerEnabled(pn) then
					local steps=ss:GetPlayerStageStats(pn):GetPlayedSteps();
					local chk_var=steps[#steps]:GetMeter();
					if i==1 then
						chk_stat[p]=chk_var
					elseif smode=="max" then
						if chk_var>chk_stat[p] then chk_stat[p]=chk_var end;
					elseif smode=="min" then
						if chk_var<chk_stat[p] then chk_stat[p]=chk_var end;
					else
						chk_stat[p]=chk_stat[p]+chk_var;
					end;
				end;
			end;
			if smode=="avg" then chk_stat[p]=chk_stat[p]/chk_loop end;
		end;
	elseif sprm=="combo" or sprm=="maxcombo" then
		for p=1,2 do
			local pn=((p==1) and PLAYER_1 or PLAYER_2);
			for i=1,chk_loop do
			local ss=STATSMAN:GetPlayedStageStats(i);
				if GAMESTATE:IsPlayerEnabled(pn) then
					local chk_var=ss:GetPlayerStageStats(pn):MaxCombo();
					if i==1 then
						chk_stat[p]=chk_var
					elseif smode=="max" then
						if chk_var>chk_stat[p] then chk_stat[p]=chk_var end;
					elseif smode=="min" then
						if chk_var<chk_stat[p] then chk_stat[p]=chk_var end;
					else
						chk_stat[p]=chk_stat[p]+chk_var;
					end;
				end;
			end;
			if smode=="avg" then chk_stat[p]=chk_stat[p]/chk_loop end;
		end;
	elseif sprm=="song" then
	-- [ja] Last か Playのみ使用可能（未指定・不正の場合Play） 
	-- [ja] ステージ数 or 0を返す 
		local songs=STATSMAN:GetAccumPlayedStageStats():GetPlayedSongs();
		for i=#songs - maxstages + 1,#songs do
			local ssong=string.lower(songs[i]:GetSongDir());
			if string.find(ssong,smode,0,true) then
				return i-(#songs - maxstages);
			end;
		end;
		return 0;
	end;
	if not GAMESTATE:IsPlayerEnabled(PLAYER_2) then
		return chk_stat[1];
	elseif not GAMESTATE:IsPlayerEnabled(PLAYER_1) then
		return chk_stat[2];
	elseif string.lower(overunder)=="over" or overunder=="+" then
		return ((chk_stat[1]>=chk_stat[2]) and chk_stat[1] or chk_stat[2]);
	elseif string.lower(overunder)=="under" or overunder=="-" then
		return ((chk_stat[1]<=chk_stat[2]) and chk_stat[1] or chk_stat[2]);
	else
		return (chk_stat[1]+chk_stat[2])/2;
	end;
end;
--------------------------------------------------------------------------------------------------------

