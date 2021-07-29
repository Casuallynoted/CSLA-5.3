
--[[ScreenSelectMusicCS scroller]]

local index = Var("GameCommand"):GetIndex();
local text = Var("GameCommand"):GetText();
local ttindex = index;

setenv("sortflag",1);

local t = Def.ActorFrame{};

local ssStats = STATSMAN:GetPlayedStageStats(1);
local pn;
if GAMESTATE:IsHumanPlayer(PLAYER_1) then pn = PLAYER_1
else  pn = PLAYER_2
end;
local p = (pn == PLAYER_1) and 1 or 2;
local playername = GetAdhocPref("ProfIDSetP"..p);
if GetAdhocPref("P_ADCheck") ~= "OK" then
	playername = GAMESTATE:GetPlayerDisplayName(pn);
end;

local st = GAMESTATE:GetCurrentStyle():GetStepsType();
local maxstage = PREFSMAN:GetPreference("SongsPerPlay");

local key_open = 0;
local song;
local sdif_p1 = 0;
local sdif_p2 = 0;
local cccsong = ""
---------------------------------------------------------------------------------------------------------------------------------------

-- [ja] chk_XXX … group.iniに定義されている曲用 
local chk_folders={};
local chk_songs={};

-- [ja] load_XXX … 実際に選曲できる曲用 
local load_folders={};
local load_songs={};
local load_cnt=0;
local load_jackets={};
local load_banners={};
local load_songtitle={};
local load_songartist={};
local load_songcolor={};

local dif_list = {
	'Difficulty_Beginner',
	'Difficulty_Easy',
	'Difficulty_Medium',
	'Difficulty_Hard',
	'Difficulty_Challenge'
};

local dif_st = {
	Difficulty_Beginner	= 1,
	Difficulty_Easy		= 2,
	Difficulty_Medium	= 3,
	Difficulty_Hard		= 4,
	Difficulty_Challenge	= 5
};

local sys_group ="";
-- [ja] 対象グループ
if ssStats then
	sys_group = ssStats:GetPlayedSongs()[1]:GetGroupName();
else sys_group = "Beginner's Package";
end;

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
local sys_difunlock = {false,false,false,false,false};

-- [ja] ゲージの状態を指定（この時点では定義だけで、実際には反映されない） 
local exlife = "";
if GetGroupParameter(sys_group,"Extra1LifeLevel") ~= "" then
	exlife = GetGroupParameter(sys_group,"Extra1LifeLevel");
end;

if string.lower(exlife)=="hard" then
	setenv("ExLifeLevel","Hard");
elseif string.lower(exlife)=="1" then
	setenv("ExLifeLevel","1");
elseif string.lower(exlife)=="2" then
	setenv("ExLifeLevel","2");
elseif string.lower(exlife)=="3" then
	setenv("ExLifeLevel","3");
elseif string.lower(exlife)=="4" then
	setenv("ExLifeLevel","4");
elseif string.lower(exlife)=="5" then
	setenv("ExLifeLevel","5");
elseif string.lower(exlife)=="6" then
	setenv("ExLifeLevel","6");
elseif string.lower(exlife)=="7" then
	setenv("ExLifeLevel","7");
elseif string.lower(exlife)=="8" then
	setenv("ExLifeLevel","8");
elseif string.lower(exlife)=="9" then
	setenv("ExLifeLevel","9");
elseif string.lower(exlife)=="10" then
	setenv("ExLifeLevel","10");
elseif string.lower(exlife)=="pfc" or string.lower(exlife)=="w2fc" then
	setenv("ExLifeLevel","PFC");
elseif string.lower(exlife)=="mfc" or string.lower(exlife)=="w1fc" then
	setenv("ExLifeLevel","MFC");
elseif string.lower(exlife)=="hardnorecover" or string.lower(exlife)=="hex1" then
	setenv("ExLifeLevel","HardNoRecover");
elseif string.lower(exlife)=="norecover" or string.lower(exlife)=="ex1" then
	setenv("ExLifeLevel","NoRecover");
elseif string.lower(exlife)=="suddendeath" or string.lower(exlife)=="ex2" then
	setenv("ExLifeLevel","Suddendeath");
else
	setenv("ExLifeLevel","Normal");
end;

local rnd_base = math.round(GetStageState("PDP", "Last", "+")*10000);
local rnd_folder="";
local rnd_song;
local sp_songtitle="";
local sp_songartist="";
local sp_songcolor = "";
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
	sp_songcolor = "";
	sp_songjacket = {"",""};
	sp_songbanner = {"",""};
	-- sys_songunlock = Extra1Songs
	-- [ja] group.iniに記載されている条件を満たさない譜面のフラグをfalseにする
	for k = 1, #sys_songunlock do
		--[ja] 20150621に修正したけど20150810に再修正
		--foldername = string.lower(foldername);
		if string.find(sys_songunlock[k],""..string.lower(foldername).."|",1,true) then
		-- [ja] 1.32追加部分 
			_t1,_t2 = string.find(sys_songunlock[k],""..string.lower(foldername).."|",1,true);
			if _t1==1 then
		-- [ja] 1.32追加部分ここまで（ifの閉じも必要） 
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
									load_banners[""..foldername]=sp_songbanner[1];
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
							elseif sys_songunlock_prm2[1] == "color" then
								sp_songcolor=sys_songunlock_prm2U[2];
								load_songcolor[""..foldername] = sp_songcolor;
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
	end;
	return diflock;
end;


-- [ja] グローバル変数と混ざっててアレな関数 
local function GetExFolderSongList()
	local txt_folders = "";
	if GetGroupParameter(sys_group,"Extra1List") ~= "" then
		txt_folders = GetGroupParameter(sys_group,"Extra1List");
	end;
	chk_folders = split(":",txt_folders);
	-- [ja] 選択可能な曲を取得 
	--local str = "";
	--getenv("songstr")
	--for j = string.sub(getenv("songstr"),1,1), string.sub(getenv("songstr"),-1) do
	for j=1,#chk_folders do
		-- foldername = Extra1List
		local gsong = GetFolder2Song(sys_group,chk_folders[j])
		if gsong then
			-- [ja] ここで選択可能な難易度をチェックして、全難易度選択不可能なら登録しない 
			sys_difunlock = SetDifficultyFlag(sys_group,chk_folders[j]);
			-- [ja] フラグfalse or 譜面自体が存在しない場合選択不可能に設定   
			local unlock_chk = 0;
			for k = 1,#dif_list do
				if ((not gsong:HasStepsTypeAndDifficulty(st,dif_list[k])) or sys_difunlock[k] == false) then
					-- [ja] ここではあくまでも曲の登録をするかの問題なので、フラグ自体をいじらない 
					unlock_chk = unlock_chk+1;
				end;
			end;
			if unlock_chk < 5 then 
				load_cnt=load_cnt + 1;
				load_songs[load_cnt] = gsong;
				load_folders[load_cnt] = chk_folders[j];
			end;
		end;
	end;
end;
GetExFolderSongList();

--[[
t[#t+1] = LoadFont("Common Normal")..{
	InitCommand=cmd(shadowlength,1;strokecolor,color("0,0,0,1");horizalign,left;);
	BeginCommand=function(self)
		(cmd(settext,tostring(sys_difunlock[1])..","..tostring(sys_difunlock[2])..","..tostring(sys_difunlock[3])..","..tostring(sys_difunlock[4])..","..tostring(sys_difunlock[5])))(self)
	end;
};

t[#t+1] = LoadFont("Common Normal")..{
	InitCommand=cmd(y,-16;shadowlength,1;strokecolor,color("0,0,0,1");horizalign,right;);
	BeginCommand=function(self)
		(cmd(settext,GAMESTATE:GetCurrentSteps('PlayerNumber_P1'):GetDifficulty();))(self)
	end;
	CodeCommand=function(self)
		(cmd(settext,GAMESTATE:GetCurrentSteps('PlayerNumber_P1'):GetDifficulty();))(self)
	end;
};

t[#t+1] = LoadFont("Common Normal")..{
	InitCommand=cmd(y,-14;shadowlength,1;strokecolor,color("0,0,0,1");horizalign,right;);
	BeginCommand=function(self)
		local dif_unlock = getenv("sys_difunlock");
		if dif_unlock[0] == true then (cmd(settext,"tt"))(self)
		else (cmd(settext,"ss"))(self)
		end;
	end;
};

t[#t+1] = LoadFont("Common Normal")..{
	InitCommand=cmd(y,14;shadowlength,1;strokecolor,color("0,0,0,1");horizalign,right;playcommand,"Set");
	CodeMessageCommand = function(self, params)
		if (params.Name == 'Up' or params.Name == 'Up2') then
			self:playcommand("Set");
		elseif (params.Name == 'Down' or params.Name == 'Down2') then
			self:playcommand("Set");
		end;
	end;
	SetCommand=function(self)
		(cmd(settext,THEME:GetMetric( "ScreenSelectMusicCS", "DefaultChoice" )))(self)
	end;
	GainFocusCommand=cmd(playcommand,"Set");
	LoseFocusCommand=cmd(playcommand,"Set");
};


t[#t+1] = LoadFont("Common Normal")..{
	InitCommand=cmd(y,28;shadowlength,1;strokecolor,color("0,0,0,1");horizalign,right;);
	BeginCommand=function(self)
		if getenv("rnd_song") == 1 then
			(cmd(settext,"11"))(self)
		else
			(cmd(settext,"00"))(self)
		end;
	end;
	GainFocusCommand=cmd(playcommand,"Begin");
	LoseFocusCommand=cmd(playcommand,"Begin");
};
]]
setenv("rnd_song",0);
local sset;
local cc = 1;
--[ja] 難易度変更チェック系
t[#t+1] = Def.ActorFrame{
	Def.ActorFrame{
		InitCommand=function(self)
			sset = self;
		end;
		OnCommand=function(self)
			setenv("rnd_song",0);
			setenv("exsong_chg",false);
			if text == THEME:GetMetric( "ScreenSelectMusicCS", "DefaultChoice" ) then
				if cc == 1 then
					self:queuecommand("GainFocus");
				else self:queuecommand("SSet");
				end;
			else self:queuecommand("LoseFocus");
			end;
			SCREENMAN:GetTopScreen():AddInputCallback(inputs);
		end;
		LoseFocusCommand=function(self)
			song = "";
		end;
		GainFocusCommand=function(self)
			cindex = index;
			if cc == 1 then
				cc = 0;
				self:playcommand("SSet");
			end;
			--SCREENMAN:SystemMessage(index);
		end;
		SSetCommand=function(self)
			setenv("rnd_song",0);
			sys_difunlock = SetDifficultyFlag(sys_group,load_folders[cindex+1]);
			if rnd_folder ~= "" then
				song  = rnd_song;
				setenv("rnd_song",1);
			else song = load_songs[cindex+1];
			end;
			setenv("songst",load_folders[cindex+1]);
			if song ~= "" and song ~= nil then
				setenv("wheelstop",1);
				GAMESTATE:SetCurrentSong(song);
				if getenv("wheelstop") == 1 then
					MESSAGEMAN:Broadcast("CSCSongSet",{
						Song = song,
						Banner = load_banners,
						Jacket = load_jackets,
						LoadSong = load_songs,
						Folder = load_folders[cindex+1],
						SColor = load_songcolor[load_folders[cindex+1]],
						STitle = load_songtitle[load_folders[cindex+1]],
						SArtist = load_songartist[load_folders[cindex+1]]
					});
					setenv("difunlock_flag",SetDifficultyFlag(sys_group,load_folders[cindex+1]));
					setenv("sys_difunlock",sys_difunlock);
					setenv("ctext",text);
				end;
			end;
		end;
		NoSSetCommand=function(self)
			setenv("rnd_song",0);
			if ttindex ~= cindex then
				if rnd_folder ~= "" then
					song  = rnd_song;
					setenv("rnd_song",1);
				else song = load_songs[cindex+1];
				end;
			
				GAMESTATE:SetCurrentSong(song);
				MESSAGEMAN:Broadcast("CSCSongSet",{
					Song = song,
					Banner = load_banners,
					Jacket = load_jackets,
					LoadSong = load_songs,
					Folder = load_folders[cindex+1],
					SColor = load_songcolor[load_folders[cindex+1]],
					STitle = load_songtitle[load_folders[cindex+1]],
					SArtist = load_songartist[load_folders[cindex+1]]
				});
				setenv("difunlock_flag",SetDifficultyFlag(sys_group,load_folders[cindex+1]));
				setenv("sys_difunlock",sys_difunlock);
				setenv("ctext",text);
			end;
		end;
	};
};

function inputs(event)
	local pn= event.PlayerNumber
	if not pn then return false end
	local button = event.GameButton
	local wheelsel = 1;
	if event.type == "InputEventType_Repeat" then
		if button == "MenuLeft" or button == "MenuRight" then
			setenv("wheelstop",0);
			wheelsel = 0;
			sset:playcommand("NoSSet");
		end;
	else
		if button ~= "MenuLeft" and button ~= "MenuRight" then
			if wheelsel == 0 then
				setenv("wheelstop",0);
				sset:playcommand("NoSSet");
			end;
		else
			wheelsel = 1;
			sset:playcommand("SSet");
		end;
	end;
end;


---------------------------------------------------------------------------------------------------------------------------------------
local function imageset(self)
	local path = THEME:GetPathG("Common","fallback jacket");
	local rnd_flag = "normal";
	song = load_songs[index+1];

	if song then
		if load_jackets[load_folders[index+1]] ~= nil then
			path = load_jackets[load_folders[index+1]];
		else
			if song:HasJacket() then 			path = song:GetJacketPath();
			elseif song:HasBackground() then 	path = song:GetBackgroundPath();
			elseif song:HasBanner() then 		path = song:GetBannerPath();
			end;
		end;
		if sp_songjacket[0] == song:GetSongDir() then
			if sp_songjacket[1] then
				path = sp_songjacket[1];
			end;
		elseif sp_songbanner[0] == song:GetSongDir() then
			if sp_songbanner[1] then
				path = sp_songbanner[1];
			end;
		end;
	end;
	self:Load( path );
	self:zoomtowidth(100);
	self:zoomtoheight(100);
end;


t[#t+1] = Def.ActorFrame {
	OnCommand=function(self)
		if text == THEME:GetMetric( "ScreenSelectMusicCS", "DefaultChoice" ) then
			self:queuecommand("GainFocus");
		else self:queuecommand("LoseFocus");
		end;
	end;
	GainFocusCommand=function(self)
		local pzoom = 0.75;
		local fzoom = 1.15;
		if bUse3dModels() == 'On' then
			pzoom = 1;
			fzoom = 1.5;
		end;
		self:diffusealpha(0.4);
		self:zoom(pzoom);
		self:linear(0.02);
		self:zoom(fzoom);
		self:diffusealpha(0.9);
		self:queuecommand("Repeat");
	end;
	LoseFocusCommand=function(self)
		local fzoom = 1.15;
		local pzoom = 0.75;
		if bUse3dModels() == 'On' then
			fzoom = 1.5;
			pzoom = 1;
		end;
		self:diffusealpha(0.9);
		self:zoom(fzoom);
		self:linear(0.02);
		self:diffusealpha(0.3);
		self:zoom(pzoom);
		self:queuecommand("Repeat");
	end;
	RepeatCommand=function(self)
		self:spin();
		self:effectmagnitude(0,-30,0);
	end;

	Def.Sprite {
		OnCommand=function(self)
			imageset(self);
		end;
	};
};

if bUse3dModels() == 'On' then
	t[#t+1] = Def.ActorFrame {
		OnCommand=function(self)
			if text == THEME:GetMetric( "ScreenSelectMusicCS", "DefaultChoice" ) then
				self:ztest(true);
				self:ztestmode("ZTestMode_Off");
				self:queuecommand("GainFocus");
			else
				self:ztest(true);
				self:ztestmode("ZTestMode_Off");
				self:queuecommand("LoseFocus");
			end;
		end;
		GainFocusCommand=function(self)
			self:diffusealpha(0.3);
			self:zoom(0.65);
			self:linear(0.02);
			self:zoom(1);
			self:diffusealpha(0.5);
			self:queuecommand("Repeat");
		end;
		LoseFocusCommand=function(self)
			self:diffusealpha(0.5);
			self:zoom(1);
			self:linear(0.02);
			self:zoom(0.65);
			self:diffusealpha(0.3);
			self:queuecommand("Repeat");
		end;
		RepeatCommand=function(self)
			self:spin();
			self:effectmagnitude(0,-30,0);
		end;
		
		LoadActor( THEME:GetPathB("_shared","models/_08_sr") )..{
			OnCommand=function(self)
				--20170918
				local cstr = math.min(359.999999,(360/load_cnt)*(index+1));
				self:zwrite(true);
				self:glow(HSVA( cstr,1,1,0.2 ));
			end;
		};

		LoadActor( THEME:GetPathB("_shared","models/_08_sq") )..{
			OnCommand=function(self)
				self:zwrite(true);
			end;
		};
	};
else
	t[#t+1] = Def.ActorFrame {
		OnCommand=function(self)
			if text == THEME:GetMetric( "ScreenSelectMusicCS", "DefaultChoice" ) then
				self:queuecommand("GainFocus");
			else self:queuecommand("LoseFocus");
			end;
		end;
		GainFocusCommand=function(self)
			local pzoom = 1.4;
			local fzoom = 2;
			self:diffusealpha(0.4);
			self:zoom(pzoom);
			self:linear(0.02);
			self:zoom(fzoom);
			self:diffusealpha(0.8);
			self:queuecommand("Repeat");
		end;
		LoseFocusCommand=function(self)
			local fzoom = 2;
			local pzoom = 1.4;
			self:diffusealpha(0.8);
			self:zoom(fzoom);
			self:linear(0.02);
			self:diffusealpha(0.4);
			self:zoom(pzoom);
			self:queuecommand("Repeat");
		end;
		RepeatCommand=function(self)
			self:spin();
			self:effectmagnitude(0,-30,0);
		end;

		Def.Sprite {
			OnCommand=function(self)
				self:rotationy(100);
				self:rotationz(-20);
				imageset(self);
			end;
		};
	};
end;

local stateset;
stateset = Def.ActorFrame{
	LoadFont("_cum") .. {
		OnCommand=function(self)
			self:x(50);
			self:y(30);
			self:rotationz(-10);
			self:diffuse(color("1,0.5,0,0.75"));
			self:strokecolor(color("0,0,0,0.75"));
			self:zoom(1);
			self:skewx(-0.25);
		end;
		CodeMessageCommand=function(self,params)
			if params.Name == "SetState" then
				if getenv("pointset") == 0 then
					setenv("pointset",1);
					--[ja] 20160124修正
					SOUND:PlayOnce(THEME:GetPathS("","_prompt"));
				end;
			end;
		end;
		SetCommand=function(self)
			self:stoptweening();
			if getenv("pointset") == 1 then
				local point = 0;
				local l = 1;
				local cs_path = "CSDataSave/"..playername.."_Save/0000_co "..sys_group.."";
				if File.Read( cs_path ) then
					local sys_songc = "";
					if GetCSCParameter(sys_group,"Status",playername) ~= "" then
						sys_songc = split(":",GetCSCParameter(sys_group,"Status",playername));
					end;
					for l = 1, #sys_songc do
						if sys_songc[l] ~= nil then
							local sys_spoint = split(",",sys_songc[l]);
							if load_folders[index+1] == sys_spoint[1] then
								point = sys_spoint[2];
							end;
						end;
					end;
				end;
				self:settext(point);
			end;
		end;
		NoSetCommand=function(self)
			self:stoptweening();
			self:settext("");
		end;
	};
};

local function update(self)
	if getenv("pointset") == 1 then
		self:queuecommand("Set");
	else self:queuecommand("NoSet");
	end;
end;

stateset.InitCommand=function(self)
	self:SetUpdateFunction(update);
end;

t[#t+1] = stateset;

return t;