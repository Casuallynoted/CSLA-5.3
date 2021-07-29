--20180222
if vcheck() and vcheck() ~= "5_2_0" then
	InitUserPrefs();
end;

THEME:ReloadMetrics();

local t = Def.ActorFrame {};

SetAdhocPref("FrameSet",frameGetCheck());
SetAdhocPref("G_Group","false");

--[ja] 選曲画面他でフラグとして使います
setenv("exdcount",0);
setenv("csflag",0);
setenv("exflag","");
setenv("songst","");
setenv("songstr","");
setenv("ExLifeLevel","Normal");
setenv("difunlock_flag","");
setenv("sys_difunlock","");
setenv("ctext","");
setenv("rsong","");
setenv("rnd_song",0);
setenv("ccstpoint",0);
setenv("pointset",0);
setenv("omsflag",0);
setenv("goexflagp1",0);
setenv("goexflagp2",0);
setenv("WinCheckP1",0);
setenv("WinCheckP2",0);
setenv("sectionCount",0);
setenv("playmusictextentry",true);
setenv("sectionsubnamelist","");
setenv("csort_sectioncolorlist","");
setenv("sectioncolorlist","");
setenv("wheelstop",1);
setenv("ReloadFlag",{0,0});
setenv("ReloadAnimFlag",0);
setenv("s_rival_op1",1);
setenv("s_rival_op2",1);
setenv("opst",{"",""});
setenv("smShortcut",0);

--[ja] プレイスタイル,プロファイルID,曲情報(曲名・難易度・譜面等),曲グレード,メーター,メータータイプ
local scf = {"None","Prof_Prof",0,{{0,0,0,0,0},{0,0,0,0,0}},{0,0,0,0,0},"Default"};
--20160718
if GetAdhocPref("SLoadCheckFlag") == nil or tonumber(GetAdhocPref("SLoadCheckFlag")) == 1 then
	scf[3] = 1;
	scf[4] = {{1,1,1,1,1},{1,1,1,1,1}};
	scf[5] = {1,1,1,1,1};
else s_envcheck(scf);
end;

for i=1,#scf[4] do
	for t=1,#scf[4][i] do
		if scf[4][i][t] == 2 then scf[4][i][t] = 0; end;
	end;
end;

if getenv("resultsetflagp1") and tonumber(getenv("resultsetflagp1")) > 0 then
	scf[4][1][getenv("resultsetflagp1")] = 1;
end;
if getenv("resultsetflagp2") and tonumber(getenv("resultsetflagp2")) > 0 then
	scf[4][2][getenv("resultsetflagp2")] = 1;
end;
setenv("resultsetflagp1",0);
setenv("resultsetflagp2",0);
setenv("sloadcheckflag",{scf[1],scf[2],scf[3],scf[4],scf[5],scf[6]});
--[[
SCREENMAN:SystemMessage("sloadcheckflag_title : "..scf[1]..":"..scf[2]..":"..scf[3]..":{"..scf[4][1][1]..":"..scf[4][1][2]..":"..scf[4][1][3]
..":"..scf[4][1][4]..":"..scf[4][1][5].."}:{"..scf[4][2][1]..":"..scf[4][2][2]..":"..scf[4][2][3]..":"..scf[4][2][4]
..":"..scf[4][2][5].."}:{"..scf[5][1]..":"..scf[5][2]..":"..scf[5][3]..":"..scf[5][4]..":"..scf[5][5].."}:"..scf[6]);
]]
--SCREENMAN:SystemMessage(GetAdhocPref("ProfIDSetP1"));
setenv("sortflag",0);
setenv("SortCh","Group");
SetAdhocPref("envAllowExtraStage",PREFSMAN:GetPreference("AllowExtraStage"));
--20160821
if vcheck() ~= "5_2_0" then
	GAMESTATE:ApplyGameCommand("sort,Preferred");
end;
InitPrefsOldP();
InitPrefsP();
SetAdhocPref("TempDefaultFail",InitPrefsFail());
PREFSMAN:SetPreference("PercentageScoring",true);

SetAdhocPref("InfoChoice","Frame1");
SetAdhocPref("CSLInfoChoice","Frame1");
SetAdhocPref("CRate","1");
SetAdhocPref("CBGMode","Default");
SetAdhocPref("SortGsetCheck","XXX,XXX");

if not File.Read( cc_path ) then
	if File.Read( cc_old_path ) then
		File.Write( cc_path , File.Read( cc_old_path ) );
	end;
end;

local csl_c = GetAdhocPref("CSLSetApp") == "00000001" or GetAdhocPref("CSLSetApp") == "32594786";
if GetAdhocPref("CSLSetApp") then
	if csl_c then
		SetAdhocPref("CSLSetApp","00000001")
		File.Write( cap_path , "00000001" );
	end;
end;

local ccgfile = "CSCoverGraphics/read_me.txt"
if not File.Read( ccgfile ) or not GetAdhocPref("ReadMeCSLFirst") then
	File.Write( ccgfile , THEME:GetString("ReadMeSet","SetText") );
	SetAdhocPref("ReadMeCSLFirst",true);
end;

local ccgfile = "CSRealScore/rival_read_me.txt"
if not File.Read( ccgfile ) or not GetAdhocPref("ReadMeCSLFirstRS") then
	File.Write( ccgfile , THEME:GetString("ReadMeSet","RSSetText") );
	SetAdhocPref("ReadMeCSLFirstRS",true);
end;

t[#t+1] = StandardDecorationFromFileOptional("VersionInfo","VersionInfo");
t[#t+1] = StandardDecorationFromFileOptional("CSVersionInfo","CSVersionInfo");
t[#t+1] = StandardDecorationFromFileOptional("Clock","Clock");
t[#t+1] = StandardDecorationFromFileOptional("CurrentGametype","CurrentGametype");
t[#t+1] = StandardDecorationFromFileOptional("LifeDifficulty","LifeDifficulty");
t[#t+1] = StandardDecorationFromFileOptional("TimingDifficulty","TimingDifficulty");
t[#t+1] = StandardDecorationFromFileOptional("MaxStages","MaxStages");
t[#t+1] = StandardDecorationFromFileOptional("SelectFrame","SelectFrame");

t[#t+1] = StandardDecorationFromFileOptional("NetworkStatus","NetworkStatus");


t[#t+1] = StandardDecorationFromFileOptional("NumSongs","NumSongs") .. {
	SetCommand=function(self)
		local InstalledSongs, AdditionalSongs, InstalledCourses, AdditionalCourses, Groups, Unlocked = 0;
		if SONGMAN:GetRandomSong() then
			InstalledSongs, AdditionalSongs, InstalledCourses, AdditionalCourses, Groups, Unlocked =
				SONGMAN:GetNumSongs(),
				SONGMAN:GetNumAdditionalSongs(),
				SONGMAN:GetNumCourses(),
				SONGMAN:GetNumAdditionalCourses(),
				SONGMAN:GetNumSongGroups(),
				SONGMAN:GetNumUnlockedSongs();
		else
			return
		end

		self:settextf(THEME:GetString("ScreenTitleMenu","%i Songs (%i Groups), %i Courses"), InstalledSongs, Groups, InstalledCourses);
-- 		self:settextf("%i (+%i) Songs (%i Groups), %i (+%i) Courses", InstalledSongs, AdditionalSongs, Groups, InstalledCourses, AdditionalCourses);
	end;
};

t[#t+1] = LoadActor( THEME:GetPathB("","_cfopen") )..{
};

return t