
local pay;
local premium;
local coincheck = false;

local tpwidth = 240;
local profset = {1,1};
local keyset = {0,0};
setenv("PSetP1","");
setenv("PSetP2","");
local profnum = PROFILEMAN:GetNumLocalProfiles();
local nextset = 0;
local initmenutimer = 0;

--[ja] 20150907 カーソル位置取得方法をidからguidに修正

function GetLocalProfiles(Player)
	local t = {};
	local pn = (Player == PLAYER_1) and 1 or 2;
	for p = 0,profnum-1 do
		local sys_tt = {0,0,0,0};
		local sys_tp = {0,0,0,0,0,0,0};
		local sys_ps = {0};
		local actotalst = 0;
		local profile = PROFILEMAN:GetLocalProfileFromIndex(p);
		--[ja] カーソル位置読み出し
		--[ja] 20151023修正 プロファイルが1つだけの時に0が入ってこの画面で止まる問題
		if profnum > 1 then
			local guid = PROFILEMAN:GetLocalProfileFromIndex(math.max(p,0)):GetGUID();
			if getenv("PSetP"..pn) == guid or GetAdhocPref("ProfSetP"..pn) == guid then
				profset[pn] = p+1;
			end;
		end;
		local profilename = profile:GetDisplayName();
		local profileid = PROFILEMAN:GetLocalProfileIDFromIndex(p);
		local cs_path = "CSDataSave/"..profileid.."_Save/0002_dt "..CurGameName().."";
		local cs_count_path = "CSDataSave/"..profileid.."_Save/0002_dt count";
		local weight = profile:GetWeightPounds();
		local weightset = false;
		local todaycalories = profile:GetCaloriesBurnedToday();
		local totalcalories = profile:GetTotalCaloriesBurned();

		if FILEMAN:DoesFileExist( cs_path ) then
			if GetPDParameter("tt",profileid,CurGameName()) ~= "" then
				local sys_tt_s = split(":",GetPDParameter("tt",profileid,CurGameName()));
				for k=1,4 do
					if tonumber(sys_tt_s[k]) then
						sys_tt[k] = sys_tt_s[k];
					end;
				end;
			end;
		end;
		if FILEMAN:DoesFileExist( cs_count_path ) then
			if GetPDParameter("tp",profileid,"count") ~= "" then
				local sys_tp_s = split(":",GetPDParameter("tp",profileid,"count"));
				for m=1,7 do
					if tonumber(sys_tp_s[m]) then
						sys_tp[m] = sys_tp_s[m];
					end;
				end;
			end;
			if GetPDParameter("ps",profileid,"count") ~= "" then
				local sys_ps_s = split(":",GetPDParameter("ps",profileid,"count"));
				if tonumber(sys_ps_s[1]) then
					sys_ps[1] = sys_ps_s[1];
				end;
			end;
		end;

		local mtp = 0;
		if #sys_tp == 7 then
			mtp = heigest_status(sys_tp);
			weightset = cal_flag_check(sys_tp,weight);
		end;
		
		t[#t+1]=prof_card_set("Select",profile,profileid,sys_tt,sys_tp,sys_ps,{""},{""},mtp,0,tpwidth,weightset,totalcalories,todaycalories);
	end;

	return t;
end;

function GetArrowLeft(Player)
	local t = {};

	local ArrowL = Def.ActorFrame {
		LoadActor( THEME:GetPathB("","arrow") )..{
			InitCommand=cmd(x,-142;y,-200;rotationz,180;diffusealpha,0;sleep,0.5;queuecommand,"Repeat";);
			RepeatCommand=cmd(addx,12;diffusealpha,1;glow,color("1,0.7,0,1");linear,1;glow,color("0,0,0,0");addx,-12;diffusealpha,0;queuecommand,"Repeat";);
		};
	};
	t[#t+1]=ArrowL;

	return t;
end;

function GetArrowRight(Player)
	local t = {};

	local ArrowR = Def.ActorFrame {
		LoadActor( THEME:GetPathB("","arrow") )..{
			InitCommand=cmd(x,138;y,-200;diffusealpha,0;sleep,0.5;queuecommand,"Repeat";);
			RepeatCommand=cmd(addx,-12;diffusealpha,1;glow,color("1,0.7,0,1");linear,1;glow,color("0,0,0,0");addx,12;diffusealpha,0;queuecommand,"Repeat";);
		};
	};
	t[#t+1]=ArrowR;

	return t;
end;

function LoadCard()
	local t = Def.ActorFrame {
		LoadActor("pro_back");
	};
	return t
end
function LoadPlayerStuff(Player)
	local t = {};
	t[#t+1] = LoadActor("scback")..{
		Name = 'ScBack';
		InitCommand=cmd(y,-199;);
	};
	t[#t+1] = Def.ActorFrame {
		Name = 'JoinFrame';
		LoadCard();
		LoadFont("_shared2") .. {
			Name = 'JoinText';
			InitCommand=function(self)
				(cmd(zoom,0.9;maxwidth,268;diffuseshift;effectperiod,0.4;
				effectcolor1,color("1,0.9,0.2,1");effectcolor2,color("1,0.3,0.4,1");strokecolor,Color("Black");))(self)
				self:settext(THEME:GetString("ScreenSelectProfile","JoinText"));
			end;
		};
	};

	t[#t+1] = Def.ActorFrame {
		Name = 'BigFrame';
		LoadCard();
	};
	t[#t+1] = LoadActor(ToEnumShortString(Player).."_back")..{
		Name = 'SmallFrame';
		PlayerJoinedMessageCommand=function(self,param)
			if param.Player == Player then
				(cmd(zoomy,1))(self);
			end;
		end;
		PlayerUnjoinedMessageCommand=function(self,param)
			if param.Player == Player then
				(cmd(zoomy,0))(self);
			end;
		end;
	};
	t[#t+1] = LoadActor("pd_g")..{
		Name = 'PD';
		InitCommand=cmd(x,74;y,-160;);
	};
	t[#t+1] = LoadActor("status")..{
		Name = 'StatusFrame';
	};

	t[#t+1] = Def.ActorScroller{
		Name = 'Scroller';
		NumItemsToDraw=1;
		InitCommand=cmd(SetFastCatchup,true;SetSecondsPerItem,0.001;);
		OnCommand=cmd(x,16;y,-208;);
		TransformFunction=function(self, offset, itemIndex, numItems)
			self:visible(false);
			self:x(0);
		end;
		children = GetLocalProfiles(Player);
	};
	
	t[#t+1] = LoadActor("swback")..{
		Name = 'SWBack';
		InitCommand=cmd(y,156;);
	};

	t[#t+1] = LoadFont("_shared2") .. {
		Name = 'SelectedProfileText';
		InitCommand=cmd(zoom,0.9;strokecolor,Color("Black"););
	};
	
	t[#t+1] = LoadFont("_shared2") .. {
		Name = 'StartText';
		InitCommand=cmd(settext,THEME:GetString("ScreenSelectProfile","StartText");
					vertalign,bottom;y,154;zoom,0.7;maxwidth,340;diffuse,color("0,1,1,1");strokecolor,Color("Black"););
	};
	
	t[#t+1] = LoadFont("_shared2") .. {
		Name = 'ProfSelText';
		Text=THEME:GetString("ScreenSelectProfile","ProfSelText");
		InitCommand=cmd(vertalign,bottom;y,136;zoom,0.7;maxwidth,340;diffuse,color("0,1,1,1");strokecolor,Color("Black"););
	};
	
	t[#t+1] = LoadFont("_shared2") .. {
		Name = 'CProfText';
		InitCommand=cmd(ztest,true;y,-204;diffuse,PlayerColor(Player);maxwidth,200;strokecolor,Color("Black"););
	};
	
	t[#t+1] = LoadFont("_shared2") .. {
		Name = 'PageNumText';
		InitCommand=cmd(horizalign,right;maxwidth,100;x,140;y,-186;zoom,0.5;strokecolor,Color("Black"););
	};
	
	t[#t+1] = LoadActor("pname")..{
		Name = 'Pnameimg';
		InitCommand=cmd(x,-86;y,-140);
	};

	t[#t+1] = LoadActor("avatar_frame")..{
		Name = 'AvatarFrame';
		InitCommand=cmd(x,-90;y,-156);
	};

	t[#t+1] = Def.Sprite {
		Name = 'Avatar';
	};
	
	t[#t+1] = Def.ActorFrame {
		Name = 'ArrowLeft';
		children = GetArrowLeft(Player);
	};
	
	t[#t+1] = Def.ActorFrame {
		Name = 'ArrowRight';
		children = GetArrowRight(Player);
	};

	return t;
end;

function UpdateInternal3(self, Player)
	local pn = (Player == PLAYER_1) and 1 or 2;
	local frame = self:GetChild(string.format('P%uFrame', pn));
	local scroller = frame:GetChild('Scroller');
	local scback = frame:GetChild('ScBack');
	local pname = frame:GetChild('SelectedProfileText');
	local joinframe = frame:GetChild('JoinFrame');
	local jointext = joinframe:GetChild('JoinText');
	local smallframe = frame:GetChild('SmallFrame');
	local bigframe = frame:GetChild('BigFrame');
	local statusframe = frame:GetChild('StatusFrame');
	local pd = frame:GetChild('PD');
	local starttext = frame:GetChild('StartText');
	local profseltext = frame:GetChild('ProfSelText');
	local swback = frame:GetChild('SWBack');
	local cproftext = frame:GetChild('CProfText');
	local pagetext = frame:GetChild('PageNumText');
	local arrowleft = frame:GetChild('ArrowLeft');
	local arrowright = frame:GetChild('ArrowRight');
	local pnameimg = frame:GetChild('Pnameimg');
	local avatar = frame:GetChild('Avatar');
	local aframe = frame:GetChild('AvatarFrame');
	pay = GAMESTATE:GetCoinMode() == 'CoinMode_Pay';
	premium = GAMESTATE:GetPremium();
	
	--[ja] 20160218 DoubleFor1Creditの時に1クレジットでVERSUSが出来てしまう問題を修正
	if pay then
		if premium == 'Premium_Off' or premium == 'Premium_DoubleFor1Credit' then
			if GAMESTATE:EnoughCreditsToJoin() then
				coincheck = true;
			else coincheck = false;
			end;
		else coincheck = true;
		end;
	else coincheck = true;
	end;
	--20160816
	if profnum <= 1 or IsNetConnected() then
		local nj_string = "NoJoinText";
		if IsNetConnected() then
			nj_string = "NetNoJoinText";
		end;
		if keyset[1] >= 1 and keyset[2] >= 1 then
			SCREENMAN:GetTopScreen():SetProfileIndex(PLAYER_2, -2);
			keyset[2] = 0;
			jointext:settext(THEME:GetString("ScreenSelectProfile",nj_string));
		else
			if (keyset[1] == 1 or keyset[2] == 1) then
				jointext:settext(THEME:GetString("ScreenSelectProfile",nj_string));
			else
				if (keyset[1] < 1 and keyset[2] < 1) then
					jointext:settext(THEME:GetString("ScreenSelectProfile","JoinText"));
				end;
			end;
		end;
	else
		if coincheck then
			jointext:settext(THEME:GetString("ScreenSelectProfile","JoinText"));
		else jointext:settext(THEME:GetString("ScreenTitleJoin","HelpTextWait"));
		end;
	end;

	if GAMESTATE:IsHumanPlayer(Player) then
		if keyset[1] == 0 and Player == PLAYER_1 then
			keyset[1] = 1;
		elseif keyset[2] == 0 and Player == PLAYER_2 then
			keyset[2] = 1;
		end;
		frame:visible(true);
		smallframe:visible(false);
		if MEMCARDMAN:GetCardState(Player) == 'MemoryCardState_none' then
			local ind = SCREENMAN:GetTopScreen():GetProfileIndex(Player);
			--[ja] 20150814修正
			local set_ind;
			local key_ind;
			if Player == PLAYER_1 then
				set_ind = {PLAYER_1,PLAYER_2};
				key_ind = {keyset[1],keyset[2]};
			else
				set_ind = {PLAYER_2,PLAYER_1};
				key_ind = {keyset[2],keyset[1]};
			end;
			if SCREENMAN:GetTopScreen():GetProfileIndex(set_ind[1]) == 
			SCREENMAN:GetTopScreen():GetProfileIndex(set_ind[2]) then
				if key_ind[1] == 2 and key_ind[2] < 2 then
					if SCREENMAN:GetTopScreen():GetProfileIndex(set_ind[1]) == profnum then
						SCREENMAN:GetTopScreen():SetProfileIndex(set_ind[2], SCREENMAN:GetTopScreen():GetProfileIndex(set_ind[2])-1 );
					else SCREENMAN:GetTopScreen():SetProfileIndex(set_ind[2], SCREENMAN:GetTopScreen():GetProfileIndex(set_ind[2])+1 );
					end;
				end;
			end;
			--using profile if any
			joinframe:visible(false);
			bigframe:visible(true);
			smallframe:visible(true);
			statusframe:visible(true);
			pd:visible(true);
			pname:visible(false);
			scroller:visible(true);
			scback:visible(false);
			cproftext:visible(false);
			pagetext:visible(false);
			arrowleft:visible(false);
			arrowright:visible(false);
			pnameimg:visible(true);
			avatar:visible(false);
			aframe:visible(false);
			swback:visible(true);
			if keyset[pn] < 2 then
				if ind > 1 then
					arrowleft:visible(true);
				end;
				if ind < PROFILEMAN:GetNumLocalProfiles() then
					arrowright:visible(true);
				end;
				scback:visible(true);
				cproftext:visible(true);
				pagetext:visible(true);
				starttext:visible(true);
				profseltext:visible(true);
				starttext:settext(THEME:GetString("ScreenSelectProfile","StartText"));
			else
				scback:visible(false);
				cproftext:visible(false);
				pagetext:visible(false);
				starttext:visible(true);
				starttext:settext(THEME:GetString("ScreenSelectProfile","WaitText"));
				profseltext:visible(false);
			end;
			if ind > 0 then
				scroller:SetDestinationItem(ind-1);
				pname:settext(PROFILEMAN:GetLocalProfileFromIndex(ind-1):GetDisplayName());
				cproftext:settext(PROFILEMAN:GetLocalProfileFromIndex(ind-1):GetDisplayName());
				pagetext:settext((ind).."/"..profnum);
				local profileid = PROFILEMAN:GetLocalProfileIDFromIndex(ind-1);
				pnameimg:visible(true);
				if FILEMAN:DoesFileExist( ProfIDPrefCheck("ProfAvatar",profileid,"Off") ) then 
					pnameimg:visible(false);
					avatar:visible(true);
					aframe:visible(true);
					avatar:Load( ProfIDPrefCheck("ProfAvatar",profileid,"Off") );
					(cmd(scaletofit,0,0,60,60;x,-90;y,-156;))(avatar);
				end;
			else
				if SCREENMAN:GetTopScreen():SetProfileIndex(Player, profset[pn]) then
					scroller:SetDestinationItem(0);
					self:queuecommand('UpdateInternal2');
				elseif SCREENMAN:GetTopScreen():SetProfileIndex(Player, profset[pn]-1) then
					scroller:SetDestinationItem(0);
					self:queuecommand('UpdateInternal2');
				elseif SCREENMAN:GetTopScreen():SetProfileIndex(Player, 1) then
					scroller:SetDestinationItem(0);
					self:queuecommand('UpdateInternal2');
				else
					joinframe:visible(true);
					bigframe:visible(false);
					smallframe:visible(false);
					statusframe:visible(false);
					pd:visible(false);
					starttext:visible(false);
					pname:visible(true);
					pname:settext('No profile');
					scroller:visible(false);
					scback:visible(false);
					pnameimg:visible(false);
					avatar:visible(false);
					aframe:visible(false);
				end;
			end;
		else
			--using card
			joinframe:visible(false);
			bigframe:visible(true);
			smallframe:visible(true);
			statusframe:visible(false);
			pd:visible(false);
			pname:visible(true);
			scroller:visible(false);
			scback:visible(false);
			profseltext:visible(false);
			pname:settext("MemoryCard:\n"..MEMCARDMAN:GetName(Player));
			SCREENMAN:GetTopScreen():SetProfileIndex(Player, 0);
			starttext:visible(true);
			if keyset[pn] < 2 then
				starttext:settext(THEME:GetString("ScreenSelectProfile","StartText"));
			else starttext:settext(THEME:GetString("ScreenSelectProfile","WaitText"));
			end;
			swback:visible(true);
			cproftext:visible(false);
			pagetext:visible(false);
			arrowleft:visible(false);
			arrowright:visible(false);
			pnameimg:visible(false);
			avatar:visible(false);
			aframe:visible(false);
		end;
	else
		joinframe:visible(true);
		bigframe:visible(false);
		smallframe:visible(false);
		statusframe:visible(false);
		pd:visible(false);
		pname:visible(false);
		scroller:visible(false);
		scback:visible(false);
		starttext:visible(false);
		profseltext:visible(false);
		swback:visible(false);
		cproftext:visible(false);
		pagetext:visible(false);
		arrowleft:visible(false);
		arrowright:visible(false);
		pnameimg:visible(false);
		avatar:visible(false);
		aframe:visible(false);
	end;
end;

--20160418
local function sp_check(self,pn,ind,keyset,p_table,mp)
	if SCREENMAN:GetTopScreen():SetProfileIndex(pn, ind + p_table[1] ) then
		if keyset[1] == 2 or keyset[2] == 2 then
			if SCREENMAN:GetTopScreen():GetProfileIndex(PLAYER_1) == 
			SCREENMAN:GetTopScreen():GetProfileIndex(PLAYER_2) then
				if mp == "minus" then
					if ind + p_table[2] > 0 then
						if SCREENMAN:GetTopScreen():SetProfileIndex(pn, ind + p_table[2] ) then
							SCREENMAN:GetTopScreen():SetProfileIndex(pn, ind + p_table[2] );
						else SCREENMAN:GetTopScreen():SetProfileIndex(pn, ind );
						end;
					else SCREENMAN:GetTopScreen():SetProfileIndex(pn, ind );
					end;
				else
					if SCREENMAN:GetTopScreen():SetProfileIndex(pn, ind + p_table[2] ) then
						SCREENMAN:GetTopScreen():SetProfileIndex(pn, ind + p_table[2] );
					else SCREENMAN:GetTopScreen():SetProfileIndex(pn, ind );
					end;
				end;
			else SCREENMAN:GetTopScreen():SetProfileIndex(pn, ind + p_table[1] );
			end;
			SOUND:PlayOnce(THEME:GetPathS("_common","value"));
			self:queuecommand('UpdateInternal2');
		else
			SCREENMAN:GetTopScreen():SetProfileIndex(pn, ind + p_table[1] );
			SOUND:PlayOnce(THEME:GetPathS("_common","value"));
			self:queuecommand('UpdateInternal2');
		end;
	end;
end;

local function k_check(self,pn,pp,players,keyset,p_table)
	if pn == pp then
		if players > 1 then
			if keyset[p_table[1]] == 2 or keyset[p_table[2]] == 2 then
				if SCREENMAN:GetTopScreen():GetProfileIndex(PLAYER_1) == 
				SCREENMAN:GetTopScreen():GetProfileIndex(PLAYER_2) then
					keyset[p_table[1]] = 1;
				else keyset[p_table[1]] = 2;
				end;
			else keyset[p_table[1]] = 2;
			end;
		else keyset[p_table[1]] = 2;
		end;
		if keyset[p_table[1]] == 2 then
			SOUND:PlayOnce(THEME:GetPathS("Common","start"));
			self:queuecommand('UpdateInternal2');
		end;
	end;
	if players > 1 then
		if keyset[p_table[1]] == 2 and keyset[p_table[2]] == 2 then
			self:queuecommand('UpdateInternal4');
		end;
	else
		if keyset[p_table[1]] == 2 or keyset[p_table[2]] == 2 then
			self:queuecommand('UpdateInternal4');
		end;
	end;
	return keyset;
end;

local function fs_check(self,pn,keyset,p_table)
	SOUND:PlayOnce(THEME:GetPathS("MusicWheel","expand"));
	keyset[p_table[1]] = 0;
	SCREENMAN:GetTopScreen():SetProfileIndex(pn, -2);
	return keyset;
end;

local function fc_check(self,pn,keyset,p_table)
	SOUND:PlayOnce(THEME:GetPathS("MusicWheel","expand"));
	keyset[p_table[1]] = 1;
	self:queuecommand('UpdateInternal2');
	return keyset;
end;

local t = Def.ActorFrame {
	InitCommand=function(self)
		--[ja] メニュータイマーフラグ
		if PREFSMAN:GetPreference("MenuTimer") then
			initmenutimer = 1;
		end
	end;

	StorageDevicesChangedMessageCommand=function(self, params)
		self:queuecommand('UpdateInternal2');
	end;

	--20160418
	CodeMessageCommand=function(self, params)
		local pn = params.PlayerNumber;
		local p = (pn == PLAYER_1) and 1 or 2;
		local players = #GAMESTATE:GetHumanPlayers();
		local ind = SCREENMAN:GetTopScreen():GetProfileIndex(pn);
		local guid = PROFILEMAN:GetLocalProfileFromIndex(math.max(ind-1,0)):GetGUID();
		if params.Name == 'Up' or params.Name == 'Up2' or params.Name == 'DownLeft' or
		params.Name == 'Left' or params.Name == 'Left2' then
			if GAMESTATE:IsHumanPlayer(pn) then
				if keyset[p] == 1 then
					if ind > 1 then
						sp_check(self,pn,ind,keyset,{-1,-2},"minus");
					end;
				end;
			end;
		end;
		if params.Name == 'Down' or params.Name == 'Down2' or params.Name == 'DownRight' or
		params.Name == 'Right' or params.Name == 'Right2' then
			if GAMESTATE:IsHumanPlayer(pn) then
				if keyset[p] == 1 then
					if ind > 0 then
						sp_check(self,pn,ind,keyset,{1,2},"plus");
					end;
				end;
			end;
		end;
		if params.Name == 'Start' or params.Name == 'Center' then
			if players > 1 then
				if keyset[1] == 2 and keyset[2] == 2 then
					self:queuecommand('UpdateInternal4');
				end;
			else
				if keyset[1] == 2 or keyset[2] == 2 then
					self:queuecommand('UpdateInternal4');
				end;
			end;	
			if keyset[1] == 1 then
				keyset = k_check(self,pn,PLAYER_1,players,keyset,{1,2});
			end;
			if keyset[2] == 1 then
				keyset = k_check(self,pn,PLAYER_2,players,keyset,{2,1});
			end;
			if not GAMESTATE:IsHumanPlayer(pn) then
				--20160816
				if (profnum <= 1 or IsNetConnected()) and (keyset[1] == 1 or keyset[2] == 1) then
				else
					if coincheck then
						keyset[p] = 1;
						--SOUND:PlayOnce(THEME:GetPathS("Common","start"));
						SCREENMAN:GetTopScreen():SetProfileIndex(pn, -1);
						if pay then
							premium = GAMESTATE:GetPremium();
							if premium == 'Premium_Off' or premium == 'Premium_DoubleFor1Credit' then
								if GAMESTATE:GetCoins() >= GAMESTATE:GetCoinsNeededToJoin() then
									GAMESTATE:InsertCoin(-GAMESTATE:GetCoinsNeededToJoin());
								else GAMESTATE:InsertCoin(-GAMESTATE:GetCoins());
								end;
							end;
						end;
					end;
				end;
			end;
		end;
		if params.Name == 'Back' then
			if not pay then
				if initmenutimer == 0 then
					if players == 0 then
						--SOUND:PlayOnce(THEME:GetPathS("MusicWheel","expand"));
						SCREENMAN:GetTopScreen():Cancel();
					end;
					if keyset[1] == 1 and pn == PLAYER_1 then
						keyset = fs_check(self,pn,keyset,{1,2});
					end;
					if keyset[2] == 1 and pn == PLAYER_2 then
						keyset = fs_check(self,pn,keyset,{2,1});
					end;
					if keyset[1] == 2 and pn == PLAYER_1 then
						keyset = fc_check(self,pn,keyset,{1,2});
					end;
					if keyset[2] == 2 and pn == PLAYER_2 then
						keyset = fc_check(self,pn,keyset,{2,1});
					end;
					if (keyset[1] == 2 and keyset[2] == 0) or (keyset[1] == 0 and keyset[2] == 2) then
						self:queuecommand('UpdateInternal4');
					end;
				end;
			end;
		end;
		if keyset[1] == 2 then
			setenv("PSetP1",guid);
		end;
		if keyset[2] == 2 then
			setenv("PSetP2",guid);
		end;
	end;

	PlayerJoinedMessageCommand=function(self, params)
		self:queuecommand('UpdateInternal2');
	end;
	PlayerUnjoinedMessageCommand=function(self, params)
		self:queuecommand('UpdateInternal2');
	end;
	CoinInsertedMessageCommand=function(self)
		self:queuecommand('UpdateInternal2');
	end;
	CoinModeChangedMessageCommand=function(self)
		self:queuecommand('UpdateInternal2');
	end;
	--20180110
	NetConnectionSuccessMessageCommand=function(self)
		self:queuecommand('UpdateInternal2');
	end;
	NetConnectionFailedMessageCommand=function(self)
		self:queuecommand('UpdateInternal2');
	end;

	OnCommand=function(self, params)
		self:queuecommand('UpdateInternal2');
	end;
	
	OffCommand=function(self, params)
		--[ja] ID・カーソル位置保存
		for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
			if MEMCARDMAN:GetCardState(pn) == 'MemoryCardState_none' then
				local ind = SCREENMAN:GetTopScreen():GetProfileIndex(pn);
				local id = PROFILEMAN:GetLocalProfileIDFromIndex(ind-1);
				local guid = PROFILEMAN:GetLocalProfileFromIndex(math.max(ind-1,0)):GetGUID();
				if ind > 0 then
					if pn == "PlayerNumber_P1" then
						SetAdhocPref("ProfSetP1",guid);
						SetAdhocPref("ProfIDSetP1",id);
					else
						SetAdhocPref("ProfSetP2",guid);
						SetAdhocPref("ProfIDSetP2",id);
					end;
				end;
			else
				local memind = MEMCARDMAN:GetName(pn);
				if pn == "PlayerNumber_P1" then
					SetAdhocPref("ProfIDSetP1","_mem_"..memind);
				else SetAdhocPref("ProfIDSetP2","_mem_"..memind);
				end;
			end;
		end;
	end;

	UpdateInternal2Command=function(self)
		--[ja] 20150814修正
		local set_t = {PLAYER_1,PLAYER_2};
		if keyset[2] == 2 then
			set_t = {PLAYER_2,PLAYER_1};
		end;
		UpdateInternal3(self, set_t[1]);
		UpdateInternal3(self, set_t[2]);
	end;
	
	UpdateInternal4Command=function(self)
		SCREENMAN:GetTopScreen():Finish();
	end;

	children = {
		Def.ActorFrame {
			Name = 'P2Frame';
			InitCommand=cmd(horizalign,right;x,math.floor(scale(2.25/3,0,1,SCREEN_LEFT,SCREEN_RIGHT));y,SCREEN_CENTER_Y+40;fov,100;ztest,false);
			OnCommand=cmd(addx,-SCREEN_WIDTH/5;diffusealpha,0;rotationy,90;decelerate,0.3;rotationy,0;addx,SCREEN_WIDTH/5;diffusealpha,1;);
			OffCommand=cmd(diffusealpha,0;);
			children = LoadPlayerStuff(PLAYER_2);
		};
		Def.ActorFrame {
			Name = 'P1Frame';
			InitCommand=cmd(horizalign,left;x,math.floor(scale(0.75/3,0,1,SCREEN_LEFT,SCREEN_RIGHT));y,SCREEN_CENTER_Y+40;fov,100;ztest,false);
			OnCommand=cmd(addx,-SCREEN_WIDTH/5;diffusealpha,0;rotationy,30;sleep,0.1;decelerate,0.3;rotationy,0;addx,SCREEN_WIDTH/5;diffusealpha,1;);
			OffCommand=cmd(diffusealpha,0;);
			children = LoadPlayerStuff(PLAYER_1);
		};
--[[
		Def.ActorMultiVertex{
			InitCommand= function(self)
				self:SetVertices{
					{{0, -50, 0}, color("#ffbe35")}, {{40, -22, 0}, color("#ffffff")},
					{{40, 22, 0}, color("#00ff37")}, {{0, 50, 0}, color("#3bffff")},
					{{-40, 22, 0}, color("#ff2b32")}, {{-40, -22, 0}, color("#ff60ff")},
					{{0, -50, 0}, color("#ffbe35")}
				}
				self:SetDrawState{Mode= "DrawMode_LineStrip"};
				self:y(SCREEN_CENTER_Y);
				self:x(SCREEN_CENTER_X);
				self:visible(true);
				self:diffusealpha(0.75);
			end;
		};
]]
	};
	
};


--[ja] 20160407修正 タイムオーバーの時の処理修正
local c_set_c = 0;
local c_set = 0;
local s_set_c = 0;
local function Update(self)
	if PREFSMAN:GetPreference("MenuTimer") then
		local limit = getenv("Timer");
		if limit + 2 <= 1 then
		--[ja] 1の場合は返還
		--[ja] どっちも2以下
			if keyset[1] < 2 and keyset[2] < 2 then
				SCREENMAN:GetTopScreen():Cancel();
			--[ja] どっちも1 - 2人共返還
				if keyset[1] > 0 and keyset[2] > 0 then
					if GAMESTATE:GetCoinMode() == 'CoinMode_Pay' and c_set_c == 0 then
						premium = GAMESTATE:GetPremium();
						if premium == 'Premium_Off' or premium == 'Premium_DoubleFor1Credit' then
							c_set = #GAMESTATE:GetHumanPlayers();
						else c_set = 1;
						end;
						c_set_c = 1;
					end;
			--[ja] どっちか1でどっちか0 - 1人分返還
				elseif (keyset[1] > 0 and keyset[2] == 0) or (keyset[2] > 0 and keyset[1] == 0) then
					if GAMESTATE:GetCoinMode() == 'CoinMode_Pay' and c_set_c == 0 then
						c_set = 1;
						c_set_c = 1;
					end;
				end;
		--[ja] どっちか2以下
			elseif keyset[1] < 2 or keyset[2] < 2 then
			--[ja] どっちか2でどっちか1 - 1人分返還
				if (keyset[1] == 2 and keyset[2] == 1) or (keyset[2] == 2 and keyset[1] == 1) then
					if GAMESTATE:GetCoinMode() == 'CoinMode_Pay' and c_set_c == 0 then
						c_set = 1;
						c_set_c = 1;
					end;
				end;
				if keyset[1] < 2 then
					SCREENMAN:GetTopScreen():SetProfileIndex(PLAYER_1, -2);
				elseif keyset[2] < 2 then
					SCREENMAN:GetTopScreen():SetProfileIndex(PLAYER_2, -2);
				end;
				if keyset[1] >= 2 and s_set_c == 0 then s_set_c = 1; end;
				if keyset[2] >= 2 and s_set_c == 0 then s_set_c = 1; end;
			end;
			if c_set_c == 1 then
				c_set_c = 2;
				self:playcommand("ReturnCoin");
			end;
			if s_set_c == 1 then
				s_set_c = 2;
				self:playcommand("SSoundSet");
			end;
		end;
	end;
end;

t.InitCommand=cmd(SetUpdateFunction,Update)

t.ReturnCoinCommand=function(self)
	GAMESTATE:InsertCoin(GAMESTATE:GetCoinsNeededToJoin() * c_set);
end;
t.SSoundSetCommand=function(self)
	SOUND:PlayOnce(THEME:GetPathS("Common","start"));
end;

--20160420
t[#t+1] = netstatecheck();

return t;
