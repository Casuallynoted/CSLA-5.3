SetAdhocPref("envAllowExtraStage",PREFSMAN:GetPreference("AllowExtraStage"));

local t = Def.ActorFrame{};
local style = {
	'StepsType_Dance_Single',
	'StepsType_Dance_Double',
	'StepsType_Dance_Solo'
};
if CurGameName() == "pump" then
	style = {
		'StepsType_Pump_Single',
		'StepsType_Pump_Halfdouble',
		'StepsType_Pump_Double'
	};
end;

local diff = {
	'Difficulty_Beginner',
	'Difficulty_Easy',
	'Difficulty_Medium',
	'Difficulty_Hard',
	'Difficulty_Challenge'
};
local chk = 0;

--[[
local grade = {
	'Grade_Tier01',
	'Grade_Tier02',
	'Grade_Tier03'
};
]]

for p = 0,PROFILEMAN:GetNumLocalProfiles()-1 do
	local profile = PROFILEMAN:GetLocalProfileFromIndex(p);
	local profilename = profile:GetDisplayName();
	local profileid = PROFILEMAN:GetLocalProfileIDFromIndex(p);
	local set = false;

	--[ja] 新しいフォルダにセーブデータをコピー
	if #FILEMAN:GetDirListing( PROFILEMAN:LocalProfileIDToDir(profileid).."/CS_Settings/") == 0 then
		PrefCopy(profileid);
	end;
	-- [ja] 新ファイルネームにコピー
	if GetAdhocPref("P_ADCheck") ~= "OK" then
		local allGroups = SONGMAN:GetNumSongGroups();
		for gro=1, allGroups do
			local gropnames = SONGMAN:GetSongGroupNames()[gro];
			local old_path = "CSDataSave/"..profilename.."_Save/0000_co "..gropnames.."";
			local new_path = "CSDataSave/"..profileid.."_Save/0000_co "..gropnames.."";
			if not FILEMAN:DoesFileExist( new_path ) and FILEMAN:DoesFileExist( old_path ) then
				local f_str = File.Read( old_path );
				File.Write( new_path , f_str );
			end;
		end;
		chk = 1;
	end;
	local cs_path = "CSDataSave/"..profileid.."_Save/0002_dt "..CurGameName().."";
	local cs_count_path = "CSDataSave/"..profileid.."_Save/0002_dt count";
	local sys_ps = "";
	local sys_tt = {};
	if FILEMAN:DoesFileExist( cs_path ) then
		if GetPDParameter("tt",profileid,CurGameName()) ~= "" then
			sys_tt = split(":",GetPDParameter("tt",profileid,CurGameName()));
		end;
	else set = true;
	end;
	if FILEMAN:DoesFileExist( cs_count_path ) then
		if GetPDParameter("ps",profileid,"count") ~= "" then
			sys_ps = split(":",GetPDParameter("ps",profileid,"count"));
		end;
	else set = true;
	end;
	if sys_ps then
		-- [ja] プロファイルを削除した後などのプロファイル重複のチェック
		if tonumber(sys_ps[1]) ~= profile:GetNumTotalSongsPlayed() then
			set = true;
		end;
	end;
	if tonumber(GetAdhocPref("SLoadCheckFlag")) == 2 then
		set = true;
	end;

	for q = 1,2 do
		-- [ja] プレイ後のセーブ前までに戻ってきた場合のチェック
		if GetAdhocPref("P"..q.."CurrentProfID") == profileid then
			set = true;
			SetAdhocPref("P"..q.."CurrentProfID","");
			break;
		end;
	end;

	if set then
		local weight = profile:GetWeightPounds();
		local weightset = false;

		local tt = {0,0,0,0};
		local tttotalst = 0;
		--local sp = {0,0,0,0};
		--local apotalst = 0;
		local tp = {0,0,0,0,0,0,0};

		local tttext;
		--local sptext;
		local tptext;
		local ptext;
		--20161130
		for q=1, #style do
			local pccountflag = 0;
			--[ja] 最後にプレイしたスタイルと違うときは計算せずにファイルの数値を返す
			if tonumber(GetAdhocPref("SLoadCheckFlag")) == 0 then
				if getenv("sloadcheckflag") then
					if getenv("sloadcheckflag")[1] and getenv("sloadcheckflag")[1] ~= nil then
						if getenv("sloadcheckflag")[1] ~= style[q] then
							if sys_tt[q] then
								if tonumber(sys_tt[q]) then
									tt[q] = tonumber(math.min(1,math.max(0,sys_tt[q])));
									pccountflag = 1;
								end;
							end;
						end;
					end;
				end;
			end;
			--20161201
			if pccountflag == 0 then
				for r=1, #diff do
					local spc = string.format("%.12f",math.min(1,math.max(0,profile:GetSongsPercentComplete( style[q], diff[r] ))));
--[[
					if q == 1 and r == 1 then
						spc = 1;
					end;
]]
					if not tonumber(spc) then spc = 0;
					end;
					if isnan(spc) then spc = 0;
					end;
					tt[q] = tonumber(tt[q]) + tonumber(spc);
--[[
					for s=1, #grade do
						local gs = 2;
						if s == 1 then gs = 5;
						elseif s == 2 then gs = 3;
						end;
						sp[q] = sp[q] + (profile:GetTotalStepsWithTopGrade( style[q], diff[r], grade[s] ) * gs);
					end;
]]
				end;
				--[ja] 20150412修正
				tt[q] = math.min(1,math.max(0,tonumber(tt[q]) / #diff));
				if isnan(tt[q]) then tt[q] = 0;
				end;
			end;
			tttotalst = tttotalst + tt[q];
			--apotalst = apotalst + sp[q];
		end;
		tt[4] = tttotalst;
		--sp[4] = apotalst;
		
		tp[1] = profile:GetTotalJumps();
		tp[2] = profile:GetTotalLifts();
		tp[3] = profile:GetTotalHolds();
		tp[4] = profile:GetTotalRolls();
		tp[5] = profile:GetTotalMines();
		tp[6] = profile:GetTotalHands();
		tp[7]  = tp[1] + tp[2] + tp[3] + tp[4] + tp[5] + tp[6];

		tttext = "#tt:"..tt[1]..":"..tt[2]..":"..tt[3]..":"..tt[4];
		--sptext = "#sp:"..sp[1]..":"..sp[2]..":"..sp[3]..":"..sp[4];
		tptext = "#tp:"..tp[1]..":"..tp[2]..":"..tp[3]..":"..tp[4]..":"..tp[5]..":"..tp[6]..":"..tp[7];
		--ptext = tttext..";\r\n"..sptext..";\r\n"..tptext..";\r\n";
		ptext = tttext;
		pcounttext = tptext..";\r\n".."#ps:"..profile:GetNumTotalSongsPlayed()..";\r\n";
		File.Write( cs_path , ptext );
		File.Write( cs_count_path , pcounttext );

		local ctp = 0;
		if #tp == 7 then
			ctp = heigest_status(tp);
			weightset = cal_flag_check(tp,weight)
		end;
		SetAdhocPref("HandCheck",weightset,profileid);
		--[ja] 20140921追加
		if FILEMAN:DoesFileExist( "CSRealScore/"..profile:GetGUID().."_"..profilename.."/0002_dt "..CurGameName() ) then
			File.Write( "CSRealScore/"..profile:GetGUID().."_"..profilename.."/0002_dt "..CurGameName() , ptext );
		end;
		if FILEMAN:DoesFileExist( "CSRealScore/"..profile:GetGUID().."_"..profilename.."/0002_dt count" ) then
			File.Write( "CSRealScore/"..profile:GetGUID().."_"..profilename.."/0002_dt count" , pcounttext );
		end;
	else
		--[ja] 20141125修正
		--if FILEMAN:DoesFileExist( "CSRealScore/"..profile:GetGUID().."_"..profilename ) then
			--if not FILEMAN:DoesFileExist( "CSRealScore/"..profile:GetGUID().."_"..profilename.."/0002_dt dance" ) then
				local opdsettext = "";
				if FILEMAN:DoesFileExist( cs_path ) then
					opdsettext = File.Read( cs_path );
				end;
				File.Write( "CSRealScore/"..profile:GetGUID().."_"..profilename.."/0002_dt "..CurGameName() , opdsettext );
				
				local countsettext = "";
				if FILEMAN:DoesFileExist( cs_count_path ) then
					countsettext = File.Read( cs_count_path );
				end;
				File.Write( "CSRealScore/"..profile:GetGUID().."_"..profilename.."/0002_dt count" , countsettext );
			--end;
		--end;
	end;
end;

if chk == 1 then
	SetAdhocPref("P_ADCheck","OK");
end;

SetAdhocPref("SLoadCheckFlag",0);

return t;
