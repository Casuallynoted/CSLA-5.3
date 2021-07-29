--20180208 favorite
local t = Def.ActorFrame{};
local limit = getenv("Timer") + 1;
setenv("sortflag",1);
local gsetc = split(",",GetAdhocPref("SortGsetCheck"));
local p = csort_pset();

local tpwidth = 240;
local space = 32;
local xwideset = SCREEN_CENTER_X;
local setxwidth = 0;
local tg_str_width = 0;
local basezoom = 0.45;
local backwidth = 330;

local key_open = 0;
local curIndex = 1;
local sortset = sortmenuset(gsetc[1],ProfIDSet(p));
for i=1, #sortset do
	if getenv("SortCh") == sortset[i] then
		curIndex = i;
	end;
end;
local settingon = cmd(stoptweening;zoomy,0;y,SCREEN_BOTTOM;decelerate,0.15;CenterY;zoomy,1;);
local settingoff = cmd(stoptweening;accelerate,0.1;y,SCREEN_BOTTOM;zoomy,0;);

--SCREENMAN:SystemMessage(GetAdhocPref("SortGsetCheck") or "");
local f_set = 0;

local gset = {"ntype","ntype"};
--20160816
gset[1] = getenv("judgesetp1");
gset[2] = getenv("judgesetp2");

local uc_image;
local f_jacket = THEME:GetPathG("_MusicWheelItem","parts/_fallback_jacket_low");
local sheight = 124;
local sp_plus = 114;
local function sety(self,cindex)
	self:stoptweening();
	local ssheight = sheight / 2;
	local cheight = sheight / (#sortset - 1);
	if cindex == 0 then
		(cmd(decelerate,0.1;y,-ssheight+sp_plus))(self)
	else (cmd(decelerate,0.1;y,-ssheight+(cheight*cindex)+sp_plus))(self)
	end;
	return self;
end

function SetSort()
	local t = {};
	local sort_sst = ToEnumShortString(GAMESTATE:GetSortOrder());
	if sort_sst == 'Title' and sort_sst ~= getenv("SortCh") then
		setenv("SortCh",sort_sst); 
	end;
	for i=1, #sortset do
		if getenv("SortCh") == sortset[i] then
			curIndex = i;
		end;
		local ss = Def.ActorFrame {};
		
		if string.find(sortset[i],"^Group$") then
			ss[#ss+1]=Def.Quad{
				InitCommand=cmd(zoomto,backwidth,space-4;x,0;);
				OnCommand=cmd(playcommand,"Set";);
				DirectionButtonMessageCommand=cmd(playcommand,"Set";);
				SetCommand=function(self)
					self:stoptweening();
					if curIndex == i then
						self:linear(0.001);
						self:diffuse(GetSortColor(sortset[i]));
						self:diffusealpha(0);
					else
						self:linear(0.2);
						self:diffuse(GetSortColor(sortset[i]));
						self:diffusealpha(0.3);
					end;
				end;
			};
		end;
		ss[#ss+1]=Def.Quad{
			InitCommand=cmd(zoomto,4,space-4;x,-136;);
			OnCommand=cmd(playcommand,"Set";);
			DirectionButtonMessageCommand=cmd(playcommand,"Set";);
			SetCommand=function(self)
				self:diffuse(GetSortColor(sortset[i]));
			end;
		};
		if string.find(sortset[i],"^TopGrades.*") or string.find(sortset[i],"^UserCustom.*") or string.find(sortset[i],"^Favorite.*") then
			local tg_str_s;
			if THEME:GetString("ScreenSort",sortset[i].."Name") then
				tg_str_s = split("-",THEME:GetString("ScreenSort",sortset[i].."Name"));
			end;
			local stname = "TopGradesName";
			local desname = "TopGradesDes";
			local g_set_visible = true;
			local tg_str_text = THEME:GetString("ScreenSort",stname);
			local tg_str_diff_text = "";
			if tg_str_s[2] then
				tg_str_diff_text = tg_str_s[2];
			end;
			if string.find(sortset[i],"^UserCustom.*") or string.find(sortset[i],"^Favorite.*") then
				if string.find(sortset[i],"^UserCustom.*") then
					stname = "UserCustomName";
					desname = "UserCustomDes";
				else
					stname = "FavoriteName";
					desname = "FavoriteDes";
				end;
				g_set_visible = false;
				tg_str_text = "";
				tg_str_diff_text = THEME:GetString("ScreenSort",sortset[i].."Name");
			end;
			ss[#ss+1]=Def.ActorFrame {
				InitCommand=cmd(playcommand,"Set";);
				DirectionButtonMessageCommand=cmd(playcommand,"Set";);
				LoadFont("_shared2") .. {
					Name="tg_str";
					InitCommand=cmd(horizalign,left;playcommand,"Set";);
				};
				LoadFont("_shared2") .. {
					Name="tg_str_diff";
					InitCommand=cmd(horizalign,left;playcommand,"Set";);
				};
				SetCommand=function(self)
					local tg_str = self:GetChild('tg_str');
					local tg_str_diff = self:GetChild('tg_str_diff');
					tg_str:diffuse(color("0.75,0.75,0.75,1"));
					tg_str:strokecolor(Color("Black"));
					tg_str:settext(tg_str_text);
					tg_str_diff:diffuse(Color("White"));
					tg_str_diff:strokecolor(Color("Black"));
					tg_str_diff:settext(THEME:GetString("ScreenSort",sortset[i].."Name"));
					tg_str_diff:settext(tg_str_diff_text);
					local tg_str_width = math.min(tg_str:GetWidth()*0.55,180*0.55);
					if i == curIndex then
						tg_str_diff:diffuse(GetSortColor(sortset[i]));
					end;
					(cmd(maxwidth,180;y,5;zoom,0.55;))(tg_str);
					(cmd(maxwidth,320;x,tg_str_width;y,2;zoom,0.8;))(tg_str_diff);
					self:x(-((tg_str_width + (tg_str_diff:GetWidth()*0.8))/2));
				end;
				
			};
			ss[#ss+1]=Def.ActorFrame {
				InitCommand=cmd(y,-10;playcommand,"Set";);
				LoadFont("_shared4") .. {
					Name="topgrade_des";
					InitCommand=cmd(horizalign,left;playcommand,"Set";);
				};
				LoadFont("_shared4") .. {
					Name="pnset";
					InitCommand=cmd(horizalign,left;playcommand,"Set";);
				};
				LoadFont("_shared4") .. {
					Name="gset";
					InitCommand=cmd(horizalign,left;visible,g_set_visible;playcommand,"Set";);
				};
				SetCommand=function(self)
					tg_str_width = 0;
					local tg_des = self:GetChild('topgrade_des');
					local pn_set = self:GetChild('pnset');
					local g_set = self:GetChild('gset');
					
					local ntable = {ntype = "CSGrade",default = "SMGrade"};
					local p = ( string.find(sortset[i],"^.*P1") and 1 or 2 );
					
					tg_des:diffuse(color("0.75,0.75,0.75,1"));
					tg_des:strokecolor(Color("Black"));
					pn_set:strokecolor(Color("Black"));
					g_set:strokecolor(Color("Black"));
					
					tg_des:settext(THEME:GetString("ScreenSort",desname));
					(cmd(maxwidth,280;zoom,basezoom;))(tg_des);
					local tg_des_width = math.min(tg_des:GetWidth()*basezoom,280*basezoom);
					
					if #GAMESTATE:GetHumanPlayers() > 1 then
						if string.find(sortset[i],"^.*P1") then
							pn_set:diffuse(PlayerColor(PLAYER_1));
							pn_set:settext(" (PLAYER 1)");
						else
							pn_set:diffuse(PlayerColor(PLAYER_2));
							pn_set:settext(" (PLAYER 2)");
						end;
					end;
					(cmd(maxwidth,320;x,tg_des_width;zoom,basezoom;))(pn_set);
					
					if gset[p] == "ntype" then
						g_set:diffuse(color("1,1,0,1"));
					else g_set:diffuse(color("0,1,1,1"));
					end;
					g_set:settext("");
					if string.find(sortset[i],"^TopGrades.*") then
						g_set:settext(" "..THEME:GetString( "OptionExplanations",ntable[gset[p]] ));
					end;
					(cmd(maxwidth,320;x,tg_des_width + (pn_set:GetWidth()*basezoom);zoom,basezoom;))(g_set);
					
					tg_str_width = tg_des_width + (pn_set:GetWidth()*basezoom) + (g_set:GetWidth()*basezoom);
					self:x(-(tg_str_width/2));
				end;
			};
		else
			ss[#ss+1]=LoadFont("_shared2") .. {
				InitCommand=cmd(playcommand,"Set";);
				DirectionButtonMessageCommand=cmd(playcommand,"Set";);
				SetCommand=function(self)
					--self:settext("aaaaaaaaaaaaaaaaaaaaaaaaaaaa");
					--self:settext(sortset[i]);
					self:diffuse(Color("White"));
					self:settext(THEME:GetString("ScreenSort",sortset[i].."Name"));
					if i == curIndex then
						self:diffuse(GetSortColor(sortset[i]));
					end;
					(cmd(strokecolor,Color("Black");maxwidth,320;y,2;zoom,0.8;))(self)
				end;
			};
			ss[#ss+1]=Def.ActorFrame {
				LoadFont("_shared4") .. {
					InitCommand=cmd(playcommand,"Set";);
					SetCommand=function(self)
						--self:settext("aaaaaaaaaaaaaaaaaaaaaaaaaaaa");
						--self:settext(sortset[i]);
						if string.find(sortset[i],"^.*Meter") then
							self:settext(THEME:GetString("ScreenSort","MeterDes"));
						else self:settext(THEME:GetString("ScreenSort",sortset[i].."Des"));
						end;
						(cmd(diffuse,color("0.75,0.75,0.75,1");strokecolor,Color("Black");maxwidth,480;y,-10;zoom,basezoom;))(self)
					end;
				};
			};
		end;
		t[#t+1]=ss;
	end;
	return t;
end;


t[#t+1] = Def.ActorFrame {
	LimitCommand=function(self)
		key_open = 4;
		self:playcommand("Off");
		SOUND:PlayOnce(THEME:GetPathS("MusicWheel","sort"));
		SCREENMAN:GetTopScreen():PostScreenMessage('SM_GoToPrevScreen',1);
	end;
	SelectBMessageCommand=function(self)
		key_open = 4;
		self:playcommand("Off");
		SCREENMAN:GetTopScreen():PostScreenMessage('SM_GoToPrevScreen',1);
	end;
	Def.ActorFrame {
		InitCommand=cmd(visible,true;CenterX;);
		OnCommand=settingon;
		CancelCommand=settingoff;
		OffCommand=settingoff;
		Def.Quad{
			InitCommand=cmd(zoomto,backwidth,SCREEN_HEIGHT;);
			OnCommand=cmd(diffuse,color("0,0,0,0");croptop,1;decelerate,0.15;diffusetopedge,color("0,0,0,1");diffusebottomedge,color("0,0,0,0.75");croptop,0;);
		};
		Def.Quad{
			InitCommand=cmd(y,114;zoomto,330,38;diffuse,color("1,0.2,0,0.45");fadetop,0.1;fadebottom,0.1;);
			OnCommand=cmd(cropright,1;accelerate,0.05;cropright,0;);
			--DirectionButtonMessageCommand=cmd(stoptweening;cropright,1;accelerate,0.05;cropright,0;);
		};
		
		LoadActor(THEME:GetPathG("_MusicWheelItem","parts/section_back"))..{
			InitCommand=cmd(y,10-116;diffuse,color("0.5,0.5,0.5,0.5"););
		};
		Def.Sprite{
			InitCommand=function(self)
				(cmd(y,-100;diffusealpha,0;decelerate,0.3;diffusealpha,0.875;playcommand,"Set";))(self)
			end;
			DirectionButtonMessageCommand=cmd(playcommand,"Set";);
			SetCommand=function(self)
				--20180209
				if string.find(sortset[curIndex],"^UserCustom.*") or string.find(sortset[curIndex],"^Favorite.*") then
					for i=1, #extension do
						if string.find(sortset[curIndex],"^UserCustom.*") then
							uc_image = prof_custom_imagedir(ProfIDSet(p),"CustomSort/","main",extension[i],f_jacket);
						else uc_image = prof_custom_imagedir(ProfIDSet(p),"CS_Favorite/","main",extension[i],f_jacket);
						end;
						if uc_image then break;
						end;
					end;
					if uc_image then self:Load(uc_image);
					end;
				elseif string.find(sortset[curIndex],"^TopGrades.*") then
					self:Load(THEME:GetPathG("_MusicWheelItem","parts/sortsection_jacket_"..string.sub(sortset[curIndex],1,-3)));
				else self:Load(THEME:GetPathG("_MusicWheelItem","parts/sortsection_jacket_"..sortset[curIndex]));
				end;
				(cmd(stoptweening;scaletofit,-87,-187,87,-13;diffusealpha,0.875;))(self)
			end;
		};
		Def.Quad {
			InitCommand=cmd(y,-47-100;zoomtowidth,174;zoomtoheight,80;playcommand,"Set";);
			DirectionButtonMessageCommand=cmd(playcommand,"Set";);
			SetCommand=function(self)
				self:visible(false);
				if string.find(sortset[curIndex],"^TopGrades.*") or string.find(sortset[curIndex],"^UserCustom.*") or string.find(sortset[curIndex],"^Favorite.*") then
					if #GAMESTATE:GetHumanPlayers() > 1 then
						self:visible(true);
						if string.find(sortset[curIndex],"^.*P1") then
							self:diffuse(PlayerColor(PLAYER_1));
						else self:diffuse(PlayerColor(PLAYER_2));
						end;
						self:fadebottom(0.4);
						(cmd(stoptweening;diffusealpha,0;decelerate,0.3;diffusealpha,0.4;))(self)
					end;
				end;
			end;
		};
		LoadFont("Common Normal")..{
			InitCommand=cmd(x,80;y,-68-100;shadowlength,0;horizalign,right;maxwidth,180;zoom,0.85;playcommand,"Set";);
			DirectionButtonMessageCommand=cmd(playcommand,"Set";);
			SetCommand=function(self)
				self:visible(false);
				if string.find(sortset[curIndex],"^TopGrades.*") or string.find(sortset[curIndex],"^UserCustom.*") or string.find(sortset[curIndex],"^Favorite.*") then
					if #GAMESTATE:GetHumanPlayers() > 1 then
						self:visible(true);
						self:diffuse(Color("Black"));
						if string.find(sortset[curIndex],"^.*P1") then
							self:settext("PLAYER 1");
							self:strokecolor(PlayerColor(PLAYER_1));
						else
							self:settext("PLAYER 2");
							self:strokecolor(PlayerColor(PLAYER_2));
						end;
					end;
					(cmd(stoptweening;diffusealpha,0;decelerate,0.3;diffusealpha,1;))(self)
				end;
			end;
		};
		Def.HelpDisplay {
			File = THEME:GetPathF("HelpDisplay", "text");
			InitCommand=function(self)
				(cmd(y,-216;zoom,0.55;stoptweening;maxwidth,530;))(self)
				local s = THEME:GetString(Var "LoadingScreen","HelpTextSelectGroup");
				self:SetSecsBetweenSwitches(THEME:GetMetric("HelpDisplay","TipShowTime"));
				if s then
					self:SetTipsColonSeparated(s);
				end;
			end;
			OnCommand=cmd(zoomy,0.55;diffuseshift;effectperiod,2.5;
						effectcolor1,color("1,1,0.9,1");effectcolor2,color("0.7,1,1,0.9"));
			SetHelpTextCommand=function(self, params)
				self:stoptweening();
				self:SetTipsColonSeparated( params.Text );
			end;
		};
		LoadFont("Common Normal")..{
			InitCommand=cmd(y,-197;shadowlength,0;maxwidth,300;zoom,0.55;playcommand,"Set";);
			SetCommand=function(self)
				self:visible(false);
				if #GAMESTATE:GetHumanPlayers() > 1 then
					self:visible(true);
					self:strokecolor(Color("Black"));
					if gsetc[1] == "P1" then
						self:settext("PLAYER 1 "..THEME:GetString("ScreenSort","Selection"));
						self:diffuse(PlayerColor(PLAYER_1));
					else
						self:settext("PLAYER 2 "..THEME:GetString("ScreenSort","Selection"));
						self:diffuse(PlayerColor(PLAYER_2));
					end;
				end;
				(cmd(stoptweening;diffusealpha,0;decelerate,0.3;diffusealpha,1;))(self)
			end;
		};
	};

	Def.Quad{
		Name="TopMask";
		InitCommand=cmd(CenterX;y,SCREEN_BOTTOM;zoomto,backwidth,8;valign,1;MaskSource);
	};
	
	Def.ActorFrame {
		InitCommand=cmd(x,xwideset;);
		LimitCommand=cmd(playcommand,"Off");
		OnCommand=settingon;
		CancelCommand=settingoff;
		OffCommand=settingoff;
		Def.ActorScroller{
			Name = 'Scroller';
			NumItemsToDraw=8;
			OnCommand=function(self)
				self:clearzbuffer(true);
				self:zwrite(true);
				self:zbuffer(true);
				self:ztest(true);
				self:z(0);
				self:MaskDest();
				self:ScrollThroughAllItems();
				(cmd(y,146;SetFastCatchup,true;SetLoop,true;SetSecondsPerItem,0.035;SetDestinationItem,curIndex;))(self)
			end;
			TransformFunction=function(self, offset, itemIndex, numItems)
				self:visible(false);
				self:x(0);
				self:zoom(1);
				if offset + 1 >= 1 then
					self:y(5 + math.floor( offset*space ));
				elseif offset + 1 <= -1 then
					self:y(math.floor( offset*space ) - 5);
				else
					self:y(math.floor( offset*space ));
					self:zoom(1.1);
				end;
				
			end;
			DirectionButtonMessageCommand=function(self)
				self:SetDestinationItem( curIndex );
			end;
			children = SetSort();
		};
	};
	
	Def.ActorFrame{
		InitCommand=cmd(visible,true;x,SCREEN_CENTER_X+158;);
		LimitCommand=cmd(playcommand,"Off");
		OnCommand=settingon;
		CancelCommand=settingoff;
		OffCommand=settingoff;
		LoadActor(THEME:GetPathG("ScrollBar","top")) .. {
			InitCommand=cmd(y,(-sheight/2)-28+sp_plus;);
		};
		LoadActor(THEME:GetPathG("ScrollBar","middle")) .. {
			InitCommand=cmd(zoomtoheight,sheight;y,sp_plus;);
		};
		LoadActor(THEME:GetPathG("ScrollBar","bottom")) .. {
			InitCommand=cmd(y,(sheight/2)+28+sp_plus;);
		};

		LoadActor(THEME:GetPathG("ScrollBar","TickThumb/TickThumb")) .. {
			InitCommand=cmd(playcommand,"Changed";);
			OnCommand=cmd(queuecommand,"Repeat";);
			RepeatCommand=cmd(blend,'BlendMode_Add';glowshift;effectperiod,3;effectcolor1,color("0,0,0,0");effectcolor2,color("0,1,1,0.4"););
			DirectionButtonMessageCommand=cmd(playcommand,"Changed");
			ChangedCommand=function(self)
				sety(self,curIndex-1);
			end;
		};
	};

	Def.ActorFrame{
		InitCommand=cmd(x,SCREEN_CENTER_X+134;);
		LimitCommand=cmd(playcommand,"Off");
		OnCommand=settingon;
		CancelCommand=settingoff;
		OffCommand=settingoff;
		Def.ActorFrame{
			LeftSetMessageCommand=cmd(playcommand,"Changed");
			ChangedCommand=cmd(stoptweening;glow,color("1,1,0,1");y,12;decelerate,0.25;glow,color("0,0,0,0");y,0;);
			-- left
			LoadActor( THEME:GetPathB("","arrow") )..{
				OnCommand=cmd(y,64-16;rotationz,-90;diffusealpha,0;queuecommand,"Repeat";);
				RepeatCommand=cmd(addy,12;diffusealpha,0.8;glow,color("1,0.7,0,1");linear,1;glow,color("0,0,0,0");addy,-12;diffusealpha,0;queuecommand,"Repeat";);
				OffCommand=cmd(stoptweening;);
			};
		
			LoadActor( THEME:GetPathB("","arrow") )..{
				OnCommand=cmd(y,64;rotationz,-90;diffusealpha,0;sleep,0.11;queuecommand,"Repeat";);
				RepeatCommand=cmd(addy,16;diffusealpha,0.8;glow,color("1,0.7,0,1");linear,0.8;glow,color("0,0,0,0");addy,-16;diffusealpha,0;sleep,0.2;queuecommand,"Repeat";);
				OffCommand=cmd(stoptweening;);
			};
		};
		Def.ActorFrame{
			RightSetMessageCommand=cmd(playcommand,"Changed");
			ChangedCommand=cmd(stoptweening;glow,color("1,1,0,1");y,-12;decelerate,0.25;glow,color("0,0,0,0");y,0;);
			-- right
			LoadActor( THEME:GetPathB("","arrow") )..{
				OnCommand=cmd(y,164+16;rotationz,90;diffusealpha,0;queuecommand,"Repeat";);
				RepeatCommand=cmd(addy,-12;diffusealpha,0.8;glow,color("1,0.7,0,1");linear,1;glow,color("0,0,0,0");addy,12;diffusealpha,0;queuecommand,"Repeat";);
				OffCommand=cmd(stoptweening;);
			};
		
			LoadActor( THEME:GetPathB("","arrow") )..{
				OnCommand=cmd(y,164;rotationz,90;diffusealpha,0;sleep,0.11;queuecommand,"Repeat";);
				RepeatCommand=cmd(addy,-16;diffusealpha,0.8;glow,color("1,0.7,0,1");linear,0.8;glow,color("0,0,0,0");addy,16;diffusealpha,0;sleep,0.2;queuecommand,"Repeat";);
				OffCommand=cmd(stoptweening;);
			};
		};
	};
	SelectNMessageCommand=function(self)
		SCREENMAN:GetTopScreen():Cancel();
	end;
};

local function update(self)
	local limit = getenv("Timer");
	if limit > 0 then
		if limit <= s_v2_close_time_limit() then
			setenv("ReloadFlag",{2,limit});
			if key_open ~= 4 then
				self:playcommand("Limit");
			end;
		end;
	end;
end;

--20180206
function inputs(event)
	local pn= event.PlayerNumber
	if not pn then return false end
	local button = event.GameButton
	--[ja] metricsのPrevScreenやNextScreenではメニュータイマーの情報を送れないので対策 (タイムを0にしてから次の画面に移行するため0しか送れない)
	--[ja] 画面を行き来する際のソートフラグ
	if limit > 10 or IsNetConnected() then
		if key_open == 0 then
			if event.type ~= "InputEventType_Release" then
				if button == 'MenuLeft' or button == 'MenuUp' then
					MESSAGEMAN:Broadcast("LeftSet");
					if curIndex > 1 then
						curIndex = curIndex - 1;
						SOUND:PlayOnce(THEME:GetPathS("_common","row"));
						MESSAGEMAN:Broadcast("DirectionButton");
					elseif curIndex == 1 then
						curIndex = #sortset;
						SOUND:PlayOnce(THEME:GetPathS("_common","row"));
						MESSAGEMAN:Broadcast("DirectionButton");
					end;
				end;
				if button == 'MenuRight' or button == 'MenuDown' then
					MESSAGEMAN:Broadcast("RightSet");
					if curIndex < #sortset then
						if curIndex > 0 then
							curIndex = curIndex + 1;
							SOUND:PlayOnce(THEME:GetPathS("_common","row"));
							MESSAGEMAN:Broadcast("DirectionButton");
						end;
					elseif curIndex == #sortset then
						curIndex = 1;
						SOUND:PlayOnce(THEME:GetPathS("_common","row"));
						MESSAGEMAN:Broadcast("DirectionButton");
					end;
				end;
			end;
			if event.type == "InputEventType_FirstPress" then
				if button == "Start" or button == "Center" then
					key_open = 1;
					local p = ( string.find(sortset[curIndex],"^.*P1") and 1 or 2 );
					if string.find(sortset[curIndex],"^TopGrades.*") and gsetc[2] ~= getenv("judgesetp"..p) then
						setenv("SortCh",sortset[curIndex]);
						gsetc[2] = getenv("judgesetp"..p);
						SetAdhocPref("SortGsetCheck",gsetc[1]..","..gsetc[2]);
						SortSetting(sortset[curIndex],ProfIDSet(p));
						setenv("ReloadFlag",{1,getenv("Timer")});
						setenv("ReloadAnimFlag",1);
					elseif string.find(sortset[curIndex],"^UserCustom.*") and gsetc[2] ~= "UserCustomSort" then
						setenv("SortCh",sortset[curIndex]);
						gsetc[2] = "UserCustomSort";
						SetAdhocPref("SortGsetCheck",gsetc[1]..","..gsetc[2]);
						SortSetting(sortset[curIndex],ProfIDSet(p));
						setenv("ReloadFlag",{1,getenv("Timer")});
						setenv("ReloadAnimFlag",1);
					elseif string.find(sortset[curIndex],"^Favorite.*") and gsetc[2] ~= "Favorite" then
						setenv("SortCh",sortset[curIndex]);
						gsetc[2] = "Favorite";
						SetAdhocPref("SortGsetCheck",gsetc[1]..","..gsetc[2]);
						SortSetting(sortset[curIndex],ProfIDSet(p));
						setenv("ReloadFlag",{1,getenv("Timer")});
						setenv("ReloadAnimFlag",1);
					elseif sortset[curIndex] ~= getenv("SortCh") then
						--SCREENMAN:SystemMessage(sortset[curIndex]..","..getenv("SortCh"));
						setenv("SortCh",sortset[curIndex]);
						SortSetting(sortset[curIndex],ProfIDSet(p));
						setenv("ReloadFlag",{1,getenv("Timer")});
						setenv("ReloadAnimFlag",1);
					else
						setenv("ReloadFlag",{2,getenv("Timer")});
						f_set = 2;
					end;
					if getenv("ReloadFlag")[1] == 1 then
						for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
							local pp = ( (pn == "PlayerNumber_P1") and 1 or 2 );
							--20160816
							--if not IsNetConnected() then
								SetAdhocPref("JudgeSet",getenv("judgesetp"..pp),ProfIDSet(pp));
							--end;
							sc_change_diff_set(pn,pp);
							sc_change_rt_set(pp,"sel");
						end;
						f_set = 1
					end;
					SOUND:PlayOnce(THEME:GetPathS("MusicWheel","sort"));
				end;
				--20161109
				if button == "Back" then
					setenv("ReloadFlag",{2,getenv("Timer")});
					f_set = 2;
					SOUND:PlayOnce(THEME:GetPathS("MusicWheel","sort"));
				end;
			end;
		end;
		if f_set == 1 then
			MESSAGEMAN:Broadcast("SelectN");
		elseif f_set == 2 then
			key_open = 3;
			MESSAGEMAN:Broadcast("SelectB");
		end;
	end;
end;

t.InitCommand=cmd(SetUpdateFunction,update;);
t.OnCommand=function(self)
	SOUND:PlayOnce(THEME:GetPathS("MusicWheel","sort"));
	SCREENMAN:GetTopScreen():lockinput(0.5);
	SCREENMAN:GetTopScreen():AddInputCallback(inputs);
end;

return t;