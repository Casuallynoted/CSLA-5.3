
local p = (pn == PLAYER_1) and 1 or 2;

setenv("exflag","");

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

local tpwidth = 240;
local profset = {1,1};
local keyset = {0,0};
local profnum = PROFILEMAN:GetNumLocalProfiles();
local players = #GAMESTATE:GetHumanPlayers();

if not PROFILEMAN:IsPersistentProfile(PLAYER_1) then
	keyset[1] = 3;
end;
if not PROFILEMAN:IsPersistentProfile(PLAYER_2) then
	keyset[2] = 3;
end;

function LoadPlayerStuff(pn)
	local t = {};

	if not PROFILEMAN:IsPersistentProfile(pn) then
		return t;
	end;
	if GAMESTATE:IsHumanPlayer(pn) then
		local profile=PROFILEMAN:GetProfile(pn);
		local profilename = profile:GetDisplayName();
		local sys_tt = {0,0,0,0};
		local sys_tp = {0,0,0,0,0,0,0};
		setmetatable( sys_tt, { __index = function() return 0 end; } ); 
		setmetatable( sys_tp, { __index = function() return 0 end; } ); 
		local sys_ps = {profile:GetNumTotalSongsPlayed()};
		local actotalst = 0;
		local pp = (pn == PLAYER_1) and 1 or 2;
		local profileid = ProfIDSet(pp);
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
		
		local plus = profile:GetNumTotalSongsPlayed() - tonumber(sys_ps[1]);
		local tt = {0,0,0,0};
		local tp = {0,0,0,0,0,0,0};
		setmetatable( tt, { __index = function() return 0 end; } ); 
		setmetatable( tp, { __index = function() return 0 end; } ); 
		tp[1] = profile:GetTotalJumps();
		tp[2] = profile:GetTotalLifts();
		tp[3] = profile:GetTotalHolds();
		tp[4] = profile:GetTotalRolls();
		tp[5] = profile:GetTotalMines();
		tp[6] = profile:GetTotalHands();
		tp[7]  = tp[1] + tp[2] + tp[3] + tp[4] + tp[5] + tp[6];

		--20161130
		local tttotalst = 0;
		for q=1, #style do
			--20160821
			if vcheck() ~= "5_2_0" then
				for r=1, #diff do
					local spc = string.format("%.12f",math.min(1,math.max(0,profile:GetSongsPercentComplete( style[q], diff[r] ))));
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
			end;
			tt[q] = math.min(1,math.max(0,tonumber(tt[q]) / #diff));
			if isnan(tt[q]) then tt[q] = 0;
			end;
			tttotalst = tttotalst + tt[q];
			--apotalst = apotalst + sp[q];
		end;
		tt[4] = tttotalst;

		tttext = "#tt:"..tt[1]..":"..tt[2]..":"..tt[3]..":"..tt[4];
		--sptext = "#sp:"..sp[1]..":"..sp[2]..":"..sp[3]..":"..sp[4];
		tptext = "#tp:"..tp[1]..":"..tp[2]..":"..tp[3]..":"..tp[4]..":"..tp[5]..":"..tp[6]..":"..tp[7];
		--ptext = tttext..";\r\n"..sptext..";\r\n"..tptext..";\r\n";
		ptext = tttext;
		pptext = tptext..";\r\n".."#ps:"..profile:GetNumTotalSongsPlayed()..";\r\n";
		File.Write( cs_path , ptext );
		File.Write( cs_count_path , pptext );
		local mtp = 0;
		if #tp == 7 then
			mtp = heigest_status(tp);
			weightset = cal_flag_check(tp,weight);
		end;
		--SCREENMAN:SystemMessage(mmtext(tp,mtp)..","..mmtext(sys_tp,mtp));
		
		if GetAdhocPref("P"..pp.."CurrentProfID") == profileid then
			SetAdhocPref("HandCheck",weightset,profileid);
			SetAdhocPref("P"..pp.."CurrentProfID","");
		end;
		
		--[ja] 20150216 修正
		if FILEMAN:DoesFileExist( "CSRealScore/"..profile:GetGUID().."_"..profilename.."/0002_dt count" ) then
			File.Write( "CSRealScore/"..profile:GetGUID().."_"..profilename.."/0002_dt count" , ptext );
		end;
		if FILEMAN:DoesFileExist( "CSRealScore/"..profile:GetGUID().."_"..profilename.."/0002_dt "..CurGameName() ) then
			File.Write( "CSRealScore/"..profile:GetGUID().."_"..profilename.."/0002_dt "..CurGameName() , ptext );
		end;

		t[#t+1]=Def.ActorFrame {
			LoadActor(THEME:GetPathB("ScreenSelectProfile","overlay/pro_back"))..{
			};
			
			LoadActor(THEME:GetPathB("ScreenSelectProfile","overlay/"..ToEnumShortString(pn).."_back"))..{
			};

			LoadActor(THEME:GetPathB("ScreenSelectProfile","overlay/pd_g"))..{
				Name = 'PD';
				InitCommand=cmd(x,74;y,-160;);
			};
			
			LoadActor(THEME:GetPathB("ScreenSelectProfile","overlay/status"))..{
				Name = 'StatusFrame';
			};
		};

		t[#t+1]=prof_card_set("After",profile,profileid,tt,tp,sys_ps,sys_tt,sys_tp,mtp,plus,tpwidth,weightset,totalcalories,todaycalories);
		
		t[#t+1]=Def.ActorFrame {
			LoadActor(THEME:GetPathB("ScreenSelectProfile","overlay/swback"))..{
				InitCommand=cmd(y,156;);
			};
			
			LoadFont("_shared2") .. {
				Text=THEME:GetString("ScreenAfterProfileCheck","ExitText");
				InitCommand=function(self)
					if MEMCARDMAN:GetCardState(pn) == 'MemoryCardState_none' then
						self:settext(THEME:GetString("ScreenAfterProfileCheck","ExitText"));
					else
						self:settext(THEME:GetString("ScreenAfterProfileCheck","MemText").."\n"..THEME:GetString("ScreenAfterProfileCheck","ExitText"));
					end;
					(cmd(vertalign,bottom;y,154;zoom,0.7;maxwidth,340;diffuse,color("0,1,1,1");strokecolor,Color("Black");))(self)
				end;
			};
			
			Def.ActorFrame {
				LoadActor( THEME:GetPathB("ScreenSelectProfile","overlay/pname") )..{
					Name = 'Pnameimg';
					InitCommand=cmd(x,-86;y,-134);
				};
				LoadActor( THEME:GetPathB("ScreenSelectProfile","overlay/avatar_frame") )..{
					Name = 'AvatarFrame';
					InitCommand=cmd(x,-90;y,-156);
				};
				Def.Sprite {
					Name = 'Avatar';
				};

				OnCommand=function(self)
					local pnameimg = self:GetChild('Pnameimg');
					local aframe = self:GetChild('AvatarFrame');
					local avatar = self:GetChild('Avatar');
					avatar:visible(false);
					aframe:visible(false);
					pnameimg:visible(true);
					if FILEMAN:DoesFileExist( ProfIDPrefCheck("ProfAvatar",profileid,"Off") ) then 
						avatar:visible(true);
						avatar:Load( ProfIDPrefCheck("ProfAvatar",profileid,"Off") );
						(cmd(scaletofit,0,0,60,60;x,-90;y,-156))(avatar);
						aframe:visible(true);
						pnameimg:visible(false);
					end;
				end;
			};
		};
	end;

	return t;
end;

local key_count = 0;

function UpdateInternal3(self, pn)
	local pp = (pn == PLAYER_1) and 1 or 2;
	local frame = self:GetChild(string.format('P%uFrame', pp));

	if GAMESTATE:IsHumanPlayer(pn) then
		if PROFILEMAN:IsPersistentProfile(pn) then
			frame:visible(true);
			if pn == PLAYER_1 then
				if keyset[1] == 0 then 
					keyset[1] = 1;
				end;
				if keyset[1] == 2 then
					frame:playcommand('Off');
				end;
				if keyset[1] == 3 then
					if players > 1 then
						if keyset[1] == 3 and keyset[2] == 3 then
							self:playcommand('NextSet');
							key_count = 1;
						end;
					else
						if keyset[1] == 3 or keyset[2] == 3 then
							self:playcommand('NextSet');
							key_count = 1;
						end;
					end;
				end;
			end;
			if pn == PLAYER_2 then
				if keyset[2] == 0 then
					keyset[2] = 1;
				end;
				if keyset[2] == 2 then
					frame:playcommand('Off');
				end;
				if keyset[2] == 3 then
					if players > 1 then
						if keyset[1] == 3 and keyset[2] == 3 then
							self:playcommand('NextSet');
							key_count = 1;
						end;
					else
						if keyset[1] == 3 or keyset[2] == 3 then
							self:playcommand('NextSet');
							key_count = 1;
						end;
					end;
				end;
			end;
		else
			frame:visible(false);
		end;
	else
		frame:visible(false);
	end;
end;

local t = Def.ActorFrame {
	CodeMessageCommand = function(self, params)
		if params.Name == 'Start' or params.Name == 'Center' then
			if players > 1 then
				if keyset[1] == 2 and keyset[2] == 2 then
					self:queuecommand('UpdateInternal2');
				end;
			else
				if keyset[1] == 2 or keyset[2] == 2 then
					self:queuecommand('UpdateInternal2');
				end;
			end;
			if keyset[1] == 1 then
				if params.PlayerNumber == PLAYER_1 then
					keyset[1] = 2;
					MESSAGEMAN:Broadcast("StartButton");
					self:queuecommand('UpdateInternal2');
				end;
				if players > 1 then
					if keyset[1] == 2 and keyset[2] == 2 then
						self:queuecommand('UpdateInternal2');
					end;
				else
					if keyset[1] == 2 or keyset[2] == 2 then
						self:queuecommand('UpdateInternal2');
					end;
				end;	
			end;
			if keyset[2] == 1 then
				if params.PlayerNumber == PLAYER_2 then
					keyset[2] = 2;
					MESSAGEMAN:Broadcast("StartButton");
					self:queuecommand('UpdateInternal2');
				end;
				if players > 1 then
					if keyset[1] == 2 and keyset[2] == 2 then
						self:queuecommand('UpdateInternal2');
					end;
				else
					if keyset[1] == 2 or keyset[2] == 2 then
						self:queuecommand('UpdateInternal2');
					end;
				end;	
			end;
		end;
	end;
	OnCommand=function(self, params)
		self:queuecommand('UpdateInternal2');
	end;
	UpdateInternal2Command=function(self)
		UpdateInternal3(self, PLAYER_1);
		UpdateInternal3(self, PLAYER_2);
	end;

	children = {
		Def.ActorFrame {
			Name = 'P2Frame';
			InitCommand=cmd(horizalign,right;x,math.floor(scale(2.25/3,0,1,SCREEN_LEFT,SCREEN_RIGHT));y,SCREEN_CENTER_Y+24;fov,100;ztest,false);
			OnCommand=cmd(addx,-SCREEN_WIDTH/5;diffusealpha,0;rotationy,90;decelerate,0.5;rotationy,0;addx,SCREEN_WIDTH/5;diffusealpha,1;);
			OffCommand=function(self)
				(cmd(zoomy,1;decelerate,0.2;zoomy,0;diffusealpha,0;))(self)
				keyset[2] = 3;
				self:queuecommand("UpdateInternal2");
			end;
			children = LoadPlayerStuff(PLAYER_2);
		};
		
		Def.ActorFrame {
			Name = 'P1Frame';
			InitCommand=cmd(horizalign,left;x,math.floor(scale(0.75/3,0,1,SCREEN_LEFT,SCREEN_RIGHT));y,SCREEN_CENTER_Y+24;fov,100;ztest,false);
			OnCommand=cmd(addx,-SCREEN_WIDTH/5;diffusealpha,0;rotationy,30;decelerate,0.5;rotationy,0;addx,SCREEN_WIDTH/5;diffusealpha,1;);
			OffCommand=function(self)
				(cmd(zoomy,1;decelerate,0.2;zoomy,0;diffusealpha,0;))(self)
				keyset[1] = 3;
				self:queuecommand("UpdateInternal2");
			end;
			children = LoadPlayerStuff(PLAYER_1);
		};
		
		Def.Quad{
			InitCommand=cmd(Center;diffuse,color("0,0,0,0"));
			NextSetCommand=cmd(stoptweening;diffuse,color("0,1,1,0.4");zoomtowidth,SCREEN_WIDTH;zoomtoheight,0;fadetop,0.2;fadebottom,0.2;
						sleep,0.2;decelerate,0.2;fadetop,0;fadebottom,0;zoomtoheight,SCREEN_HEIGHT;linear,0.2;diffuse,color("0,0,0,0"););
		};

		Def.Quad{
			InitCommand=cmd(diffuse,color("0,0,0,0");x,SCREEN_CENTER_X;y,SCREEN_TOP;);
			NextSetCommand=cmd(stoptweening;diffuse,color("0,0,0,0");vertalign,top;zoomtowidth,SCREEN_WIDTH;zoomtoheight,0;
						sleep,0.2;accelerate,0.2;diffuse,color("0,0,0,1");zoomtowidth,SCREEN_WIDTH;zoomtoheight,SCREEN_HEIGHT/2+10);
		};

		Def.Quad{
			InitCommand=cmd(diffuse,color("0,0,0,0");x,SCREEN_CENTER_X;y,SCREEN_BOTTOM;);
			NextSetCommand=cmd(stoptweening;diffuse,color("0,0,0,0");vertalign,bottom;zoomtowidth,SCREEN_WIDTH;zoomtoheight,0;
						sleep,0.2;accelerate,0.2;diffuse,color("0,0,0,1");zoomtowidth,SCREEN_WIDTH;zoomtoheight,SCREEN_HEIGHT/2+10);
		};
		
		Def.ActorFrame{
			NextSetCommand=cmd(stoptweening;linear,0.8;queuecommand,"NextScreen");
			NextScreenCommand=function(self)
				if key_count == 1 then
					SCREENMAN:GetTopScreen():PostScreenMessage('SM_GoToNextScreen',0);
				end;
			end;
		};

		-- sounds
		LoadActor( THEME:GetPathS("Common","start") )..{
			StartButtonMessageCommand=cmd(play);
		};
	};
};

local function update(self)
	local limit = getenv("Timer") + 1;
	if key_count == 0 then
		if limit == 0 then
			self:playcommand("NextSet");
			key_count = 1;
		end;
	end;
end;

t.InitCommand=cmd(SetUpdateFunction,update;);

return t;
