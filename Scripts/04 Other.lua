--20180312
function vcheck()
	local monthnum = {
		jan = 1, feb = 2, mar = 3, apr = 4, may = 5, jun = 6,
		jul = 7, aug = 8, sep = 9, oct =10, nov = 11, dec = 12,
	};
	local vds = split(" ",VersionDate());
	local vdatest = 0;
	if #vds > 1 then
		vdatest = string.format("%04i",vds[6])..string.format("%02i",monthnum[string.lower(vds[2])])..string.format("%02i",vds[3]);
	else vdatest = VersionDate();
	end;
	local pds = split("%.",ProductVersion());
	if 20160905 >= tonumber(vdatest) then
		if tonumber(pds[2]) == 1 or string.find(ProductVersion(),"^5.1.*") then
			return "5_2_0";
		end;
		if 20140930 <= tonumber(vdatest) then
			if 20151031 <= tonumber(vdatest) then
				return "5_0_10";
			elseif 20150331 <= tonumber(vdatest) then
				return "5_0_7";
			elseif 20150213 <= tonumber(vdatest) then
				return "5_0_5";
			elseif 20140930 <= tonumber(vdatest) then 
				return "beta4";
			end;
		end;
	else
		if tonumber(pds[2]) == 1 or string.find(ProductVersion(),"^5.1.*") then
			return "5_1_0";
		else return "5_0_10";
		end;
	end;
	return false
end;

function TitleMenuChoice()
	if tonumber(GetAdhocPref("CSLCreditFlag")) >= 1 then
		return "1,3,5,6,7,GH,10"
	elseif getenv("CSLCreditFlag") then
		if tonumber(getenv("CSLCreditFlag")) >= 1 then
			return "1,3,5,6,7,GH,10"
		else
			return "1,3,5,6,GH,10"
		end
	else
		return "1,3,5,6,GH,10"
	end
end

--[ja] 追加ゲームフレーム確認
function SelectFrameSet()
	local f_flag = "";
	local cset = {};
	local f_point;

	local checktable = {
		{ St = "Regular", Check = "Sco" , Count = 1 },
		{ St = "White", Check = "Sco" , Count = 20 },
		{ St = "Black", Check = "Sco" , Count = 50 },
		{ St = "Gold", Check = "Sco" , Count = 100 },
		{ St = "Metal", Check = "Sco" , Count = 200 },
		{ St = "Cutie", Check = "Lco" , Count = 50 },
		{ St = "Ocean", Check = "Lco" , Count = 0 },
		{ St = "Nonstop", Check = "Non" , Count = 3 },
		{ St = "Challenge", Check = "Cha" , Count = 3 },
		{ St = "Endless", Check = "End" , Count = 1 },
		{ St = "Rave", Check = "Rav" , Count = 20 },
		{ St = "Extra", Check = "Ecco" , Count = 5 },
		{ St = "Special", Check = "Esco" , Count = 5 },
		{ St = "Cyan", Check = "Ccco" , Count = 5 },
		{ St = "Cyan_Special", Check = "Csco" , Count = 5 },
		{ St = "Cs1", Check = "Elco" , Count = 1 },
		{ St = "Cs6", Check = "Elco" , Count = 2 },
	};
	local ecftable = {
		{ St = "R7-4thMix" , Check = "R7-4thMix" , Count = 0.001 },
	};
	local ct = {checktable,ecftable};
	local setsta = {"Status","e_Status"};
	if File.Read( cc_path ) then
		for k=1,#ct do
			for idx, cat in pairs(ct[k]) do
				if GetCCParameter(setsta[k]) ~= "" then
					f_flag = split(":",GetCCParameter(setsta[k]));
				end;
				local cSt = cat.St;
				local cCheck = cat.Check;
				local cCount = cat.Count;
				if cSt == "Ocean" then
					if vnumcheck("20150816") then
						cset[#cset+1] = cSt;
					end;
				else
					if #f_flag > 0 then
						for fp=1,#f_flag do
							if f_flag[fp] ~= "" then
								f_point = split(",",f_flag[fp]);
								if #f_point >= 2 then
									if f_point[1] == cCheck then
										if tonumber(f_point[2]) then
											if tonumber(f_point[2]) >= cCount then
												cset[#cset+1] = cSt;
											end;
										end;
									end;
								end;
							end;
						end;
					end;
				end;
			end;
		end;
	end;
	return table.concat(cset,",");
end

function vnumcheck(num)
	local date = GetThemeInfo("Date");
	--[ja] 20150901修正
	if tonumber(date) >= tonumber(num) then
		return true
	end;
	return false
end

function SelectFrameDefault()
	local set = "Default"
	if SelectFrameSet() ~= "" and SelectFrameSet() ~= nil then
		set = "Default,"..SelectFrameSet()
	end
	return set
end

function frameGetCheck()
	local pref = GetAdhocPref("FrameSet");
	local sf_s;
	local sf_check = false;
	if SelectFrameSet() ~= "" then
		sf_s = split(",",SelectFrameSet())
		for i=1,#sf_s do
			if sf_s[i] == pref then
				sf_check = true;
				break;
			end;
		end;
	end;
	if not sf_check then
		pref = "Default";
	end;
	return pref;
end;

--[ja] ゲームフレームセクション描画数
function FrameSelectDraw()
	local cf = split(",",THEME:GetMetric("ScreenOptionsFrameSet","ChoiceNames"));
	return math.min(#cf,9);
end

function CAspect()
	return round(GetScreenAspectRatio(),5)
end

function OptionsNavigation()
	if PREFSMAN:GetPreference("ArcadeOptionsNavigation") == 1 then
		return Screen.String("HelpTextPlayerOptionsArcade");
	else return Screen.String("HelpTextPlayerOptionsSM");
	end
end

function HelpTextInitialOptions()
	local file = FILEMAN:GetDirListing( "Data/UserPrefs/CyberiaStyle8/" )
	if #file > 0 then
		return Screen.String("HelpTextDataMigration")
	else return Screen.String("HelpTextInitialOptions")
	end
end

function GraphDisplayWidth()
	local pm = GAMESTATE:GetPlayMode()
	if pm == 'PlayMode_Battle' or pm == "PlayMode_Rave" then 
		return 572;
	else return 280;
	end
end

function GraphDisplayHeight()
	local pm = GAMESTATE:GetPlayMode()
	if pm == 'PlayMode_Battle' or pm == "PlayMode_Rave" then
		return 72;
	else return 52;
	end
end

--20170617
function SummaryHelpText()
	local pm = GAMESTATE:GetPlayMode()
	if not IsNetConnected() then
		if pm ~= 'PlayMode_Battle' and pm ~= "PlayMode_Rave" then
			return Screen.String("HelpTextEvaluationSummary");
		else return Screen.String("HelpTextNoSelGradeEvaluation");
		end
	else return Screen.String("HelpTextEvaluationSummary");
	end
end

function NameEntryTimer()
	if PREFSMAN:GetPreference("MenuTimer") then
		return 30;
	else return -1;
	end
end

function SortMenuTimer()
	--local timelimit = getenv("Timer") + 1
	local timelimit = getenv("Timer")
	if not PREFSMAN:GetPreference("MenuTimer") then timelimit = 99
	end
	return timelimit
end

cs1md = MonthOfYear() + 1 == 11 and DayOfMonth() == 29;
cs6md = MonthOfYear() + 1 == 2 and DayOfMonth() == 11;

function styleicon(xy)
	local set_6 = ((CScreen(Var("LoadingScreen")) and GetAdhocPref("FrameSet") == "Cs6") or cs6md);
	local set_1 = ((CScreen(Var("LoadingScreen")) and GetAdhocPref("FrameSet") == "Cs1") or cs1md);
	if xy == "x" then
		if tobool(GetAdhocPref("CSLAEasterEggs")) == true then
			if set_6 then return SCREEN_RIGHT-136;
			elseif set_1 then return SCREEN_RIGHT-126;
			end;
		end;
		return SCREEN_RIGHT-152;
	else
		if tobool(GetAdhocPref("CSLAEasterEggs")) == true then
			if set_6 then return SCREEN_TOP+26;
			elseif set_1 then return SCREEN_TOP+18;
			end;
		end;
		return SCREEN_TOP+24;
	end;
end;

function GetGameFrame()
	local frame
	local gamem = GAMESTATE:GetPlayMode()
	local gamemode = ToEnumShortString(gamem)
	local stage = STATSMAN:GetCurStageStats():GetStage()
	local pref = GetAdhocPref("FrameSet")
	local setect = ""
	if not GAMESTATE:IsCourseMode() then
		local ecf = {"R7-4thMix -Phase 2 Phase-/Mercurio"}
		local songdir = GAMESTATE:GetCurrentSong():GetSongDir();
		for l=1, #ecf do
			local ecf_d = "/Songs/".. ecf[l].."/";
			local ecf_ad = "/AdditionalSongs/".. ecf[l].."/";
			if ecf_d == songdir or ecf_ad == songdir then
				if ecf[l] == "R7-4thMix -Phase 2 Phase-/Mercurio" then setect = "R7-4thMix";
				end;
				break;
			end;
		end;
	end;
	if setect ~= "" and gamem == "PlayMode_Regular" then
		frame = setect
	else
		if tobool(GetAdhocPref("CSLAEasterEggs")) == true then
			if cs1md or cs6md then
				if cs1md then frame = "Cs1"
				elseif cs6md then frame = "Cs6"
				end
			else frame = pref
			end
		else
			if pref == "Default" or pref == nil then
				if gamem == "PlayMode_Regular" then
					if GAMESTATE:IsExtraStage2() then
						if getenv("omsflag") == 1 then frame = "Csc_Special"
						elseif getenv("omsflag") == 0 then frame = "Special"
						end
					elseif GAMESTATE:IsExtraStage() then
						if getenv("exflag") == "csc" then frame = "Csc"
						elseif getenv("exflag") ~= "csc" then frame = "Extra"
						end
					else frame = gamemode
					end
				elseif gamem then frame = gamemode
				end
			else
				if pref == "Challenge" then frame = "Oni"
				elseif pref == "Cyan" then frame = "Csc"
				elseif pref == "Cyan_Special" then frame = "Csc_Special"
				else frame = pref
				end
			end
		end
	end
	--[ja] 20160320修正
	if frame == "Default" or frame == nil then
		frame = "Regular";
	end;
	return frame
end

--[ja] 20150715修正
function SelectMusicTimeStart()
	if PREFSMAN:GetPreference("MenuTimer") then
		if getenv("sortflag") ~= 1 then
			return 90
		else 
			if tonumber(getenv("Timer")) >= 90 then
				return 90
			end;
			if tonumber(getenv("ReloadFlag")[2]) >= 90 then
				return 90
			end;
			return getenv("ReloadFlag")[2] + 1
		end
	end
	return 99
end

function GetPOScreenType()
	if IsNetConnected() then return 1
	else return 0
	end
end

function NetPOTimer()
	if IsNetConnected() then return -1
	else return 60
	end
end

function CScreen(sname)
	local check = false;
	if getenv("exflag") == "csc" and getenv("omsflag") == 1 then
		return false;
	end;
	if sname ~= "ScreenEvaluationExtra" and GAMESTATE:IsExtraStage2() then
		check = true;
	end;
	if check then
		if string.find(tostring(sname),"ScreenSelectMusic",0,true) or sname == "ScreenPlayerOptions" or sname == "ScreenSongOptions" or
		(string.find(tostring(sname),"ScreenEvaluation") and not string.find(tostring(sname),"ScreenEvaluationSummary")) then
			return true;
		end;
	end;
	return false;
end;

--20180208 favorite
function ExCustom()
	local f_string = "";
	if string.find(getenv("SortCh"),"^Favorite.*") then
		local scstr = string.sub(getenv("SortCh"),-1);
		local favorite_sort_table = {"Favorite1","Favorite2","Favorite3","Favorite4","Favorite5"};
		local favorite_remove_c = 0;
		local favorite_default = 0;
		local pstr;
		if scstr == "1" or scstr == "2" then
			pstr = ProfIDSet(scstr);
			local prof_fsortfiledir = PROFILEMAN:LocalProfileIDToDir(pstr).."CS_Favorite/SongManager ";
			for ft=1,5 do
				local favorite_c_dir = prof_fsortfiledir..favorite_sort_table[ft]..".txt";
				if FILEMAN:DoesFileExist(favorite_c_dir) then
					if sortfilecheck(favorite_c_dir) then
						favorite_default = ft;
						break;
					end;
				end;
			end;
			if GetAdhocPref("FavoriteCount",pstr) then
				favorite_c_dir = prof_fsortfiledir..favorite_sort_table[tonumber(GetAdhocPref("FavoriteCount",pstr))]..".txt";
				if FILEMAN:DoesFileExist(favorite_c_dir) then
					if sortfilecheck(favorite_c_dir) then
						favorite_remove_c = tonumber(GetAdhocPref("FavoriteCount",pstr));
						favorite_default = 0;
					end;
				end;
			end;
			for fr=5,1,-1 do
				local f_path = prof_fsortfiledir..favorite_sort_table[fr]..".txt";
				if fr == favorite_remove_c or fr == favorite_default then
					table.remove(favorite_sort_table,fr);
					SetAdhocPref("FavoriteCount",fr,pstr);
				else
					if not FILEMAN:DoesFileExist(f_path) then
						table.remove(favorite_sort_table,fr);
					else
						if not sortfilecheck(f_path) then
							table.remove(favorite_sort_table,fr);
						end;
					end;
				end;
			end;
		else favorite_sort_table = nil;
		end;
		if favorite_sort_table ~= nil then
			f_string = table.concat(favorite_sort_table,",");
		end;
	end;
	local maxStages = PREFSMAN:GetPreference("SongsPerPlay")
	if IsNetConnected() then
		return f_string..""
	elseif GAMESTATE:IsExtraStage2() then
		return ""
	elseif tonumber(getenv("exdcount")) >= 1 then
		if f_string ~= "" then f_string = f_string..",";
		end;
		if maxStages >= 3 then
			if #GAMESTATE:GetHumanPlayers() > 1 then
				return f_string.."Random"
			else return f_string.."Random,CSC"
			end
		else return f_string.."Random"
		end
	else
		if f_string ~= "" then f_string = f_string..",";
		end;
		return f_string.."Random"
	end
end

function ChatBoxX()
	if #GAMESTATE:GetHumanPlayers() < 2 then
		if GAMESTATE:IsHumanPlayer(PLAYER_1) then
			return SCREEN_CENTER_X*1.5+4
		else return SCREEN_CENTER_X*0.5+4
		end
	end
	return SCREEN_CENTER_X*1.5+4
end

function ChatInOutX()
	if #GAMESTATE:GetHumanPlayers() < 2 then
		if GAMESTATE:IsHumanPlayer(PLAYER_1) then
			return (SCREEN_CENTER_X*1.5)*0.75+4
		else return (SCREEN_CENTER_X*0.5)*0.25+4
		end
	end
	return (SCREEN_CENTER_X*1.5)*0.75+4
end

function DifficultyListNetMode()
	if IsNetConnected() then return math.min(4,math.round(WideScale(3,4)))
	else return 5
	end
	--return 4
end

function DifficultyListX()
	if #GAMESTATE:GetHumanPlayers() < 2 then
		if GAMESTATE:IsHumanPlayer(PLAYER_1) then
			return SCREEN_CENTER_X*0.5
		else return SCREEN_CENTER_X*1.05
		end
	end
	return SCREEN_CENTER_X*0.5
end

function BalloonX()
	if #GAMESTATE:GetHumanPlayers() < 2 then
		if GAMESTATE:IsHumanPlayer(PLAYER_1) then
			return SCREEN_CENTER_X*0.6
		else return SCREEN_CENTER_X*1.4
		end
	end
	return SCREEN_CENTER_X-130
end

function RoomInfoX()
	if #GAMESTATE:GetHumanPlayers() < 2 then
		if GAMESTATE:IsHumanPlayer(PLAYER_1) then
			return SCREEN_CENTER_X-290
		else return SCREEN_CENTER_X-10
		end
	end
	return SCREEN_CENTER_X-290
end

function UsersX()
	if #GAMESTATE:GetHumanPlayers() < 2 then
		if GAMESTATE:IsHumanPlayer(PLAYER_1) then
			return SCREEN_CENTER_X*0.2
		else return SCREEN_CENTER_X*1.05
		end
	end
	return SCREEN_CENTER_X*0.2
end

function SCBoardX(p,x1,x2)
	if ProfIDPrefCheck("ScoreGraph",ProfIDSet(p),"Off") ~= "Off" and 
	ProfIDPrefCheck("ScoreGraph",ProfIDSet(p),"Off") ~= "nil" then
		if getenv("graphdistance"..ProfIDSet(p)) then
			if getenv("graphdistance"..ProfIDSet(p)) == "Far" then
				if p == 1 then
					return SCREEN_RIGHT-160- x1;
				else return SCREEN_LEFT+160+ x1;
				end
			else
				if p == 1 then
					return GetPosition("PlayerNumber_P"..p)+(ColumnChecker()/2)+ x2 +280;
				else return GetPosition("PlayerNumber_P"..p)-(ColumnChecker()/2)- x2 -280;
				end
			end
		else
			if ProfIDPrefCheck("graphdistance",ProfIDSet(p),"Far") == "Far" then
				if p == 1 then
					return SCREEN_RIGHT-160- x1;
				else return SCREEN_LEFT+160+ x1;
				end
			else
				if p == 1 then
					return GetPosition("PlayerNumber_P"..p)+(ColumnChecker()/2)+ x2 +280;
				else return GetPosition("PlayerNumber_P"..p)-(ColumnChecker()/2)- x2 -280;
				end
			end
		end
		if p == 1 then
			return SCREEN_RIGHT-160- x1;
		else return SCREEN_LEFT+160+ x1;
		end
	end
	if p == 1 then
		return SCREEN_RIGHT-WideScale(0,160)- x1;
	else return SCREEN_LEFT+WideScale(0,160)+ x1;
	end
end

function SCBoardCo(p)
	local graphvisivle = ProfIDPrefCheck("ScoreGraph",ProfIDSet(p),"Off") ~= "Off" and ProfIDPrefCheck("ScoreGraph",ProfIDSet(p),"Off") ~= "nil";
	if (CAspect() < 1.77778 and graphvisivle) or PREFSMAN:GetPreference('Center1Player') or 
	GAMESTATE:GetCurrentStyle():GetStyleType() ~= 'StyleType_OnePlayerOneSide' then
		return false
	else return true
	end
end

function OpenFile(filePath)
	if not FILEMAN:DoesFileExist(filePath) then
		return nil;
	end;
	local f=RageFileUtil.CreateRageFile();
	f:Open(filePath,1);
	if not f then
		return "";
	end;
	return f;
end;

function CloseFile(f)
	if f then
		f:Close();
		f:destroy();
		return true;
	else
		return false;
	end;
end;

function GetFileParameter(f,prm)
	return GetSMParameter_f(f,prm);
end;
function GetSMParameter_f(f,prm)
	if not f then
		return "";
	end;
	f:Seek(0);
	local gl="";
	local pl=string.lower(prm);
	local l;
	while true do
		l=f:GetLine();
		local ll=string.lower(l);
		if string.find(ll,"#notes:.*") or f:AtEOF() then
			break;
		elseif (string.find(ll,"^.*#"..pl..":.*") and (not string.find(ll,"^%/%/.*"))) or gl~="" then
			gl=gl..""..split("//",l)[1];
			if string.find(ll,".*;") then
				break;
			end;
		end;
	end;
	local tmp={};
	if gl=="" then
		tmp={""};
	else
		tmp=split(":",gl);
		if tmp[2]==";" then
			tmp[1]="";
		else
			if #tmp>2 then
				tmp[1]=tmp[2];
				for i=3,#tmp do
					tmp[1]=tmp[1]..":"..split(";",tmp[i])[1];
				end;
			else
				tmp[1]=split(";",tmp[2])[1];
			end;
		end;
	end;
	return tmp[1];
end;

--[ja] フォルダ名からSong型を返す 
function GetFolder2Song(group,folder)
	local gsongs=SONGMAN:GetSongsInGroup(group);
	for i=1,#gsongs do
		if string.find(string.lower(gsongs[i]:GetSongDir()),"/"..string.lower(folder).."",0,true) then
			return gsongs[i];
		end;
	end;
	return false;
end;

--[ja] 曲名からSong型を返す 
function GetSongName2Song(group,sname)
	local gsongs=SONGMAN:GetSongsInGroup(group);
	for i=1,#gsongs do
		if string.lower(gsongs[i]:GetDisplayFullTitle()) == string.lower(sname) then
			return gsongs[i];
		end;
	end;
	return false;
end;

--[ja] レーンカバーカスタム
function CGraphicFile()
	local cset = {}
	local csetstr = ""
	local count = 1
	for i=1, #extension do
		local file = FILEMAN:GetDirListing( "CSCoverGraphics/*."..extension[i] )
		if #file > 0 then
			for j=1, #file do
				if file[j] then
					cset[count] = file[j]
					count = count + 1
				end
			end
		end
	end
	return table.concat(cset,",");
end

function CGraphicList()
	local csetss = "Off"
	if CGraphicFile() ~= "" then
		local csets = split(",", CGraphicFile())
		for k=1, #csets do
			local exst = -5
			if string.find(csets[k],".jpeg") then exst = -6
			end;
			if string.find(csets[k],"(doubleres)") then exst = exst - 11
			end;
			csets[k] = string.sub(csets[k],1,exst)
			if string.len(csets[k]) > 15 then
				csets[k] = string.sub(csets[k],1,15).." ..."
			end;
			csetss = csetss..","..csets[k]
		end
		if #csets >= 2 then
			csetss = csetss..",Random"
		--else
			--csetss = string.sub(csetss,1,-2)
		end
	end
	return csetss
end

--[ja] SPEEDオプションBPM表示
function OptionRowBpmShow(coursesong)
	local randomtext = THEME:GetString("MusicWheel","CustomItemRandomText");
	local bIsCourseMode = GAMESTATE:IsCourseMode();
	local SongOrCourse = CurSOSet();
	if bIsCourseMode then
		if SongOrCourse then
			if coursesong then
				if coursesong:IsDisplayBpmSecret() then return false; end;
				if coursesong:IsDisplayBpmRandom() then return false; end;
			end;
		else return false;
		end;
	else
		if SongOrCourse then
			if SongOrCourse:IsDisplayBpmSecret() then return false; end;
			if SongOrCourse:IsDisplayBpmRandom() then return false; end;
		else return false;
		end;
	end;
	if getenv("wheelsectioncsc") == randomtext then return false; end
	--if getenv("rnd_song") == 1 then return false; end;
	return true;
end;

--[ja] オプション画面タイトル表示
function SelOptionsTitleShow()
	local randomtext = THEME:GetString("MusicWheel","CustomItemRandomText");
	local song = GAMESTATE:GetCurrentSong();
	--[ja] 20150414修正
	local course = GAMESTATE:GetCurrentCourse();
	if song then
		if getenv("wheelsectioncsc") == randomtext then return false; end
		--if getenv("rnd_song") == 1 then return false; end;
	elseif course then
		return true;
	end;
	return true;
end;

function CSCDefaultSet()
	local check = 1
	if getenv("ctext") ~= "" then
		return getenv("ctext")
	else
		if string.sub(getenv("songstr"),3,3) == "," then
			check = 2
		end
	end
	return string.sub(getenv("songstr"),1,check);
end;

--[ja] ホイール項目名文字数チェック
function strchk(num,maxset,strset)
	local sst2set = 0;
	for j = 1,num do
		if string.byte(strset,j,j) < 192 then
			if string.byte(strset,j,j) < 128 then
				-- 1byte
				sst2set = sst2set + 1;
			end;
		elseif string.byte(strset,j,j) >= 224 then
			-- 3byte
			sst2set = sst2set + 3;
		else
			-- 2byte
			sst2set = sst2set + 2;
		end;
		if sst2set >= maxset then
			break;
		end;
	end;
	return sst2set;
end;

--[ja] ピリオド・カンマ・未到達の桁の判別
--[ja] 参考(http://kki.ajworld.net/wiki/Theme_Element_Library/Misc#Commify_Value_.28_For_Rolling_Numbers_.29)
function comma_value(amount,format,po,pt)
	local formatted = amount
	while true do
		formatted, k = string.gsub(formatted,format,
			function(a,b)
				if string.find(a,"-?%d+") then
					return a..""..po..""..b
				end
				return a..""..pt..""..b
			end
		)
		if (k==0) then
			break
		end
	end
	return formatted
end

--[ja] ターゲットスコアのラベル
function settargettext(adtype,adgraph,sel)
	local settargettext = { 'Off','MyBest','AAA','AA','A+','A-','100%','95%','90%','85%','80%' };
	local text = ""
	if sel and sel == "SelSC" then
		if adgraph == 'MyBest' then					text = settargettext[2]
		elseif adgraph == 'Tier01' then				text = "Pacemaker : "..settargettext[3]
		elseif adgraph == 'Tier02' then				text = "Pacemaker : "..settargettext[4]
		elseif adgraph == 'Tier03' then				text = "Pacemaker : "..settargettext[5]
		elseif adgraph == 'Tier04' then				text = "Pacemaker : "..settargettext[6]
		elseif adgraph == '1' then					text = "Pacemaker : "..settargettext[7]
		elseif adgraph == '0.95' then				text = "Pacemaker : "..settargettext[8]
		elseif adgraph == '0.9' then					text = "Pacemaker : "..settargettext[9]
		elseif adgraph == '0.85' then				text = "Pacemaker : "..settargettext[10]
		elseif adgraph == '0.8' then					text = "Pacemaker : "..settargettext[11]
		elseif adgraph == "RIVAL_Average" then		text = " Rival : AVG"
		elseif string.sub(adgraph,1,6) == "RIVAL_" then	text = "Rival : "..string.sub(adgraph,24)
		else					text = THEME:GetString( "OptionExplanations","NotSet" )
		end;
	else
		if adgraph == 'MyBest' then					text = adtype.." "..settargettext[2]
		elseif adgraph == 'Tier01' then				text = adtype.." "..settargettext[3]
		elseif adgraph == 'Tier02' then				text = adtype.." "..settargettext[4]
		elseif adgraph == 'Tier03' then				text = adtype.." "..settargettext[5]
		elseif adgraph == 'Tier04' then				text = adtype.." "..settargettext[6]
		elseif adgraph == '1' then					text = adtype.." "..settargettext[7]
		elseif adgraph == '0.95' then				text = adtype.." "..settargettext[8]
		elseif adgraph == '0.9' then					text = adtype.." "..settargettext[9]
		elseif adgraph == '0.85' then				text = adtype.." "..settargettext[10]
		elseif adgraph == '0.8' then					text = adtype.." "..settargettext[11]
		elseif adgraph == "RIVAL_Average" then		text = adtype.." Rival : AVG"
		elseif string.sub(adgraph,1,6) == "RIVAL_" then	text = adtype.." "..string.sub(adgraph,24)
		else					text = THEME:GetString( "OptionExplanations","NotSet" )
		end;
	end;
	return text
end;

function CSComboPerRow()
	if CurGameName() == "pump" then
		return true
	else return GetAdhocPref("CComboCount")
	end
end;

local groupcolors = {
	"1,0.6,0,1",
	"0.3,0.8,1,1",
	"1,1,0,1",
	"0.65,1,0.65,1",
	"1,0.7,0.4,1",
	"0.75,0.65,1,1",
	"1,0.5,0.5,1",
	"0.7,1,0.2,1",
	"0.6,1,1,1",
	"1,0.7,1,1",
	"1,0.8,0.2,1",
	"0,1,1,1",
	"1,0.6,0.6,1",
	"0.4,0.9,0.4,1",
	"1,1,0.45,1",
	"0.55,0.8,1,1",
	"1,0.55,0.35,1",
	"0.2,1,0.8,1",
	"1,1,0.7,1",
	"1,0.5,0.7,1"
};

function SnamecolorSet(c)
	local groupcount = 1;
	local allGroups = SONGMAN:GetNumSongGroups();
	local sectionsubname = {};
	local colorset = {};
	for gro=1, allGroups do
		local gropnames = SONGMAN:GetSongGroupNames()[gro];
		local sectiontext = GetGroupParameter(gropnames,"Name");
		local mcolorlist = GetGroupParameter(gropnames,"MENUCOLOR");
		local gr_name_s;
		local m_dir_s;
		if sectiontext ~= "" then
			sectionsubname[gropnames] = sectiontext;
		end;
		colorset[gropnames] = groupcolors[groupcount];
		if mcolorlist ~= "" then
			gr_name_s = split(":",mcolorlist);
			for s=1, #gr_name_s do
				m_dir_s = split("|",gr_name_s[s]);
				if #m_dir_s > 1 then
					for scolor=2,#m_dir_s do
						colorset[gropnames.."/"..m_dir_s[scolor]] = m_dir_s[1];
					end;
				else colorset[gropnames] = m_dir_s[1];
				end;
			end;
		end;
		groupcount = groupcount + 1;
		if groupcount > #groupcolors then
			groupcount = 1;
		end;
	end;
	if c == "course" then
		local CourseallGroups = SONGMAN:GetNumCourseGroups();
		groupcount = 1;
		for grc=1, CourseallGroups do
			local gropnames = SONGMAN:GetCourseGroupNames()[grc];
			if not colorset[gropnames] then
				colorset[gropnames] = groupcolors[groupcount];
				groupcount = groupcount + 1;
			end;
			if groupcount > #groupcolors then
				groupcount = 1;
			end;
		end;
	end;
	setenv("sectionsubnamelist",sectionsubname);
	setenv("sectioncolorlist",colorset);
end

function CustomcolorSet(profile_id)
	local groupcount = 1;
	local colorset = {};
	local prof_sortfiledir = PROFILEMAN:LocalProfileIDToDir(profile_id).."CustomSort/SongManager ";
	if FILEMAN:DoesFileExist( prof_sortfiledir.."CustomSort.txt" ) then
		local gpath = prof_sortfiledir.."CustomSort.txt";
		local f = RageFileUtil.CreateRageFile();
		f:Open(gpath,1);
		f:Seek(0);
		local l;
		while true do
			l=f:GetLine();
			local ll=string.lower(l);
			if f:AtEOF() then
				break;
			elseif string.find(ll,"^---.*") then
				--[ja] 20160122修正
				local gropnames = string.gsub(ll,"(---)(%s*)","",3);
				--Trace("gropnames : "..gropnames);
				if not colorset["csort_"..gropnames] then
					colorset["csort_"..gropnames] = groupcolors[groupcount];
					groupcount = groupcount + 1;
				end;
			end;
			if groupcount > #groupcolors then
				groupcount = 1;
			end;
		end;
		f:Close();
		f:destroy();
	end;
	setenv("csort_sectioncolorlist",colorset);
end

--[ja] 現在のプロファイル
function Pid(profile)
	for p = 0,PROFILEMAN:GetNumLocalProfiles()-1 do
		local prof = PROFILEMAN:GetLocalProfileFromIndex(p);
		if prof:GetGUID() == profile:GetGUID() then
			return PROFILEMAN:GetLocalProfileIDFromIndex(p);
		end;
	end;
end;

function optionrowcolorcheck(st)
	local op_st = {
		THEME:GetString("OptionTitles","Select Game Frame"),
		THEME:GetString("OptionTitles","Handicap"),
		THEME:GetString("OptionTitles","CAppearance"),
		THEME:GetString("OptionTitles","MiniList"),
		THEME:GetString("OptionTitles","CS Options"),
		THEME:GetString("OptionTitles","CSHighResTexture"),
		THEME:GetString("OptionTitles","Enable3DModels"),
		THEME:GetString("OptionTitles","WheelGraphics"),
		THEME:GetString("OptionTitles","UserPrefFlashyCombo"),
		THEME:GetString("OptionTitles","UserPrefComboUnderField"),
		THEME:GetString("OptionTitles","GoodCombo"),
		THEME:GetString("OptionTitles","CComboIsPerRow"),
		THEME:GetString("OptionTitles","UserPrefComboOnRolls"),
		THEME:GetString("OptionTitles","HoldArrowJudge"),
		THEME:GetString("OptionTitles","ComboHMissBreak"),
		THEME:GetString("OptionTitles","MeterType"),
		THEME:GetString("OptionTitles","UserPrefScoringMode"),
		THEME:GetString("OptionTitles","P1ScoreGraph"),
		THEME:GetString("OptionTitles","P2ScoreGraph"),
		THEME:GetString("OptionTitles","GraphType"),
		THEME:GetString("OptionTitles","ScreenFilter"),
		THEME:GetString("OptionTitles","CCover"),
		THEME:GetString("OptionTitles","CProTiming"),
		THEME:GetString("OptionTitles","GamePlaySpeedIncrement"),
		THEME:GetString("OptionTitles","Credits Select"),
		THEME:GetString("OptionTitles","Credits"),
		THEME:GetString("OptionTitles","Credits (Normal)"),
		THEME:GetString("OptionTitles","Credits (Special)"),
		THEME:GetString("OptionTitles","DiffListAnimation"),
		THEME:GetString("OptionTitles","CSLAEasterEggs"),
		THEME:GetString("OptionTitles","EditorDefaultNoteskin"),
		THEME:GetString("OptionTitles","Method Of Operation")
	};
	for i=1,#op_st do
		if op_st[i] == st then
			return true
		end;
	end
	return false
end;

function op_optionrowcolorcheck(st)
	local op_st = {
		"ItemSelectWarp",
		"SectionClose",
		"GradeSelect",
		"RivalData",
		"RivalDataSelect",
		"NetSortMenu",
		"SpeedChangeDown",
		"SpeedChangeUp",
		"ReverseOn",
		"ReverseOff",
		"StepLaneCoverUp",
		"StepLaneCoverDown",
		"StepLaneCoverVisible",
		"EditMouseLeft",
		"EditMouseRight"
	};
	for i=1,#op_st do
		if op_st[i] == st then
			return true
		end;
	end
	return false
end;

function additionaldir_to_songdir(dir)
	if dir then
		if string.find(dir,"^Additional") then
			return string.gsub(dir,"^Additional","");
		end;
	end;
	return dir
end;

function dfApproachSeconds()
	if tonumber(GetAdhocPref("DiffListAnimation")) then
		return tonumber(GetAdhocPref("DiffListAnimation"));
	end;
	return 0.15;
end;

function opsubheadertitle()
	local settitle = {
		["IC"] = "ICOptions",
		["DB"] = "DCOptions",
		["GJ"] = "GCOptions",
		["SC"] = "Options"
	};
	if getenv("opst")[1] ~= "" then
		return settitle[getenv("opst")[1]];
	end
	return "Options"
end;

function netstatecheck()
	local ns = Def.ActorFrame {};
	ns[#ns+1] = Def.ActorFrame {
		OnCommand=cmd(playcommand,"NCheck");
		NCheckCommand=function(self)
			GAMESTATE:SetTemporaryEventMode(false);
			if IsNetConnected() then
				GAMESTATE:SetTemporaryEventMode(true);
			end;
		end;
		NetConnectionSuccessMessageCommand=function(self)
			GAMESTATE:SetTemporaryEventMode(true);
		end;
		NetConnectionFailedMessageCommand=function(self)
			GAMESTATE:SetTemporaryEventMode(false);
		end;
	};
	return ns;
end;

--20161026 
--http://lua-users.org/wiki/SimpleRound
function round2(num, idp)
  return tonumber(string.format("%." .. (idp or 0) .. "f", num))
end

--20161130
--http://stackoverflow.com/questions/12102222/how-to-test-for-1-ind-indeterminate-in-lua
function isnan(x) 
    if (x ~= x) then
        --print(string.format("NaN: %s ~= %s", x, x));
        return true;
    end;
    if type(x) ~= "number" then
       return false; 
    end;
    if tostring(x) == tostring((-1)^0.5) then
        --print("NaN: x = sqrt(-1)");
        return true; 
    end;
    return false;
end

--20180130
function s_songdir(dir,low)
	local songDir;
	if low and low == "lower" then
		if string.find(dir,"^/additionalsongs/") then
			songDir = string.gsub(dir,"^/additionalsongs/","");
		else songDir = string.gsub(dir,"^/songs/","");
		end;
	else
		if string.find(dir,"^/AdditionalSongs/") then
			songDir = string.gsub(dir,"^/AdditionalSongs/","");
		else songDir = string.gsub(dir,"^/Songs/","");
		end;
	end;
	return songDir;
end;

function prof_custom_imagedir(prof,dir,section,ext,fallback)
	local imagedir;
	local prof_section_idir = string.lower(PROFILEMAN:LocalProfileIDToDir(prof)..dir..section.."_jacket."..ext);
	if FILEMAN:DoesFileExist(prof_section_idir) then
		imagedir = prof_section_idir;
		return imagedir;
	elseif string.find(section,"^Favorite.*") then
		prof_section_idir = string.gsub(prof_section_idir,"favorite *","favorite");
		if FILEMAN:DoesFileExist(prof_section_idir) then
			imagedir = prof_section_idir;
			return imagedir;
		end;
	end;
	if ext == extension[#extension] then
		return fallback;
	else return nil;
	end;
end;
