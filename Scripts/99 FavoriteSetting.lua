--20180219
--favorite setting
f_color_set = {
	color("1,0.7,0.2"),color("#e44dff"),color("0,0.9,1"),color("0.2,1,0.2"),color("#ed0972"),
};
function mt_f_color(num)
	return f_color_set[num]
end;
f_flag_check = 0;
xwide_d_set = WideScale(SCREEN_CENTER_X,SCREEN_CENTER_X+30);
--str,num,num
favorite_s_table = {{},{},{},{},{}};
favorite_c_table = {};
favorite_tc_table = {};
fss_check = 0;
fss_cgroup = "";
f_max_set = 150;
fs_move = 10;
local swidth = 240;

function sl_f_file_read(ffile,count)
	favorite_s_table = {{},{},{},{},{}};
	if ffile then
		local f = RageFileUtil.CreateRageFile();
		f:Open(ffile,1);
		f:Seek(0);
		local l;
		local seccheck = 1;
		while true do
			l=f:GetLine();
			local ll=string.lower(l);
			if f:AtEOF() then
				seccheck = 0;
			end;
			--Trace("seccheck : "..seccheck);
			if seccheck > 0 then
				local ssp = split("/",l);
				local f_dir;
				if GetFolder2Song(ssp[1],ssp[2]) then
					f_dir = s_songdir(GetFolder2Song(ssp[1],ssp[2]):GetSongDir());
				end;
				if f_dir and count > 0 then
					favorite_s_table[count][f_dir] = l;
				end;
			else break;
			end;
		end;
		f:Close();
		f:destroy();
	end;
end;

function sl_f_file_write(ffile,count,extra)
	local frt_f = getenv("frt");
	local settopstring = "";
	local setstring = "";
	local sortkey = {};
	local f_sortstring = "";
	local n = 0;
	if favorite_s_table[count] then
		if not sortkey then
			sortkey = {};
		end;
		for key, val in pairs( favorite_s_table[count] ) do
			n = n + 1;
			if val then
				local c_val = "";
				c_val = string.sub(val,-1) == "/" and string.sub(val,1,-2) or string.sub(val,1,-1);
				sortkey[n] = {c_val.."\r\n",frt_f[c_val]};
			end;
		end;
		if n == 0 then
			settopstring = "";
		else settopstring = "--- Favorite "..count.."\r\n";
		end;
		table.sort(sortkey,
			function(a, b)
				if a[2] < b[2] then
					return true
				end;
			end
		);
	end;
	for t=1, #sortkey do
		f_sortstring = f_sortstring..sortkey[t][1];
	end;
	setstring = settopstring..f_sortstring;
	if extra then
		setstring = setstring..extra;
	end;
	--Trace("setstring : "..key..val);
	File.Write(ffile,string.sub(setstring,1,-1));
	settopstring = "";
	setstring = "";
	sortkey = {};
	n = 0;
end;

function check_f_table(group,num)
	if not favorite_c_table[group] then
		favorite_c_table[group] = {};
	end;
	if not favorite_c_table[group][num] then
		favorite_c_table[group][num] = 0;
	end;
	if not favorite_tc_table[num] then
		favorite_tc_table[num] = 0;
	end;
end;

function s_colorchange(self,f_table,tx,s,total)
	self:diffuse(DarkColor(Color("White")));
	if f_table[tx] then
		if f_table[tx][s] then
			if f_table[tx][s] > 0 then
				self:diffuse(f_color_set[s]);
			end;
		end;
	elseif total then
		self:diffuse(f_color_set[s]);
	end;
	return self;
end;
function s_textchange(self,f_table,tx,s)
	self:diffuse(DarkColor(Color("White")));
	if f_table[tx] then
		if f_table[tx][s] and f_table[tx][s] > 0 then
			self:settext(f_table[tx][s]);
			self:diffuse(Color("White"));
			--SCREENMAN:SystemMessage(f_table[tx][s]);
		else self:settext(0);
		end;
	end;
	return self;
end;

function favoritetotalsetting(f_table)
	local ft = Def.ActorFrame {};
	
	ft[#ft+1] = LoadActor( THEME:GetPathB("","fs_back") )..{
		InitCommand=cmd(x,xwide_d_set+140;y,107;shadowlength,2;);
	};
	for tc = 1,5 do
		ft[#ft+1] = Def.ActorFrame {
			InitCommand=cmd(x,xwide_d_set+10+(50*tc);y,100;);
			LoadActor( THEME:GetPathG("","star") )..{
				Name="Star";
				InitCommand=function(self)
					(cmd(zoom,0.4;shadowlength,1;))(self);
					s_colorchange(self,f_table,"",tc,"total");
				end;
				SetCommand=function(self)
					s_colorchange(self,f_table,"",tc,"total");
				end;
			};
			LoadFont("Common Normal") .. {
				Text= tc;
				InitCommand=cmd(x,-6;y,6;zoom,0.4;diffuse,Color("White");strokecolor,color("0,0,0,1");shadowlength,2;);
			};
			
			LoadFont("Common Normal") .. {
				Text= "/"..f_max_set;
				--Text= "/150";
				InitCommand=cmd(x,14;y,6;horizalign,left;maxwidth,50;zoom,0.4;diffuse,Color("White");strokecolor,color("0,0,0,1");shadowlength,2;);
			};
			LoadFont("Common Normal") .. {
				InitCommand=function(self)
					(cmd(x,10;y,-4;horizalign,left;maxwidth,50;zoom,0.6;strokecolor,color("0,0,0,1");shadowlength,2;))(self)
					self:settext(0);
				end;
				OnCommand=function(self)
					if not favorite_tc_table[tc] then favorite_tc_table[tc] = 0;
					end;
					self:settext(favorite_tc_table[tc]);
					--self:settext("300");
				end;
				SetCommand=function(self)
					if not favorite_tc_table[tc] then favorite_tc_table[tc] = 0;
					end;
					self:settext(favorite_tc_table[tc]);
				end;
			};
		};
	end;
	return ft;
end;

function bannerset(self,f_screen,cindex,tabletotal)
	local image_set = THEME:GetPathG("","_MusicWheelItem parts/_fallback_banner_low");
	if f_screen == "song" then
		if cindex < #tabletotal then
			local song = tabletotal[cindex];
			if song and song:HasBanner() then
				image_set = song:GetBannerPath();
			end;
		end;
	else
		if cindex < #tabletotal then
			local group_s = SONGMAN:GetSongGroupBannerPath(tabletotal[cindex]);
			if group_s ~= "" then
				image_set = group_s;
			end;
		end;
	end;
	self:Load( image_set );
	self:zoomto(160,50);
	return self;
end;

function jacketset(self,f_screen,cindex,tabletotal)
	local image_set = THEME:GetPathG("","_MusicWheelItem parts/_fallback_jacket_low");
	if f_screen == "song" then
		if cindex < #tabletotal then
			local song = tabletotal[cindex];
			if song and song:HasJacket() then
				image_set = song:GetJacketPath();
			end;
		end;
	else
		if cindex < #tabletotal then
			local group_s = tabletotal[cindex];
			for i=1,#extension do
				if FILEMAN:DoesFileExist("/Songs/"..group_s.."/jacket."..extension[i]) then
					image_set = "/Songs/"..group_s.."/jacket."..extension[i];
					do break; end;
				elseif FILEMAN:DoesFileExist("/AdditionalSongs/"..group_s.."/jacket."..extension[i]) then
					image_set = "/AdditionalSongs/"..group_s.."/jacket."..extension[i];
					break;
				end;
			end;
		end;
	end;
	self:Load( image_set );
	self:zoomto(160,160);
	return self;
end;

function f_sety(self,cindex,f_table)
	self:stoptweening();
	local sswidth = swidth / 2;
	local cwidth = swidth / (#f_table - 1);
	if cindex-1 == 0 then
		(cmd(decelerate,0.1;y,-sswidth))(self)
	else (cmd(decelerate,0.1;y,-sswidth+(cwidth*(cindex-1))))(self)
	end;
	return self;
end

function scrollerset()
	return Def.ActorFrame {
		Name="Scroller";
		InitCommand=cmd(visible,true;);
		LoadActor(THEME:GetPathG("ScrollBar","top")) .. {
			InitCommand=cmd(y,(-swidth/2)-28;);
		};
		LoadActor(THEME:GetPathG("ScrollBar","middle")) .. {
			InitCommand=cmd(zoomtoheight,swidth);
		};
		LoadActor(THEME:GetPathG("ScrollBar","bottom")) .. {
			InitCommand=cmd(y,(swidth/2)+28;);
		};

		LoadActor(THEME:GetPathG("ScrollBar","TickThumb/TickThumb")) .. {
			Name="TickThumb";
			RepeatCommand=cmd(blend,'BlendMode_Add';glowshift;effectperiod,3;effectcolor1,color("0,0,0,0");effectcolor2,color("0,1,1,0.4"););
		};
	};
end;

function f_cursorset(self,n,i,ftable)
	if n == "Up" then
		self:visible(true);
		if i <= 1 then
			self:visible(false);
		end;
	else
		self:visible(true);
		if i >= ftable then
			self:visible(false);
		end;
	end;
	return self;
end;

function nav_set()
	local n_prev = cmd(stoptweening;glow,color("1,1,0,1");y,12;decelerate,0.25;glow,color("0,0,0,0");y,0;);
	local n_next = cmd(stoptweening;glow,color("1,1,0,1");y,-12;decelerate,0.25;glow,color("0,0,0,0");y,0;);
	return Def.ActorFrame {
		Name="Nav";
		InitCommand=function(self)
			self:x(xwide_d_set);
			self:y(SCREEN_CENTER_Y);
		end;
		Def.ActorFrame{
			Name="Up";
			PreviousMessageCommand=n_prev;
			T_PreviousMessageCommand=n_prev;
			LoadActor( THEME:GetPathB("","arrow") )..{
				OnCommand=cmd(y,-60;rotationz,270;diffusealpha,0;sleep,0.3;queuecommand,"Repeat";);
				RepeatCommand=cmd(addy,16;diffusealpha,1;glow,color("1,0.7,0,1");linear,0.8;glow,color("0,0,0,0");addy,-16;diffusealpha,0;sleep,0.2;queuecommand,"Repeat";);
				OffCommand=cmd(stoptweening;);
			};
		};
		Def.ActorFrame{
			Name="Down";
			NextMessageCommand=n_next;
			T_NextMessageCommand=n_next;
			LoadActor( THEME:GetPathB("","arrow") )..{
				OnCommand=cmd(y,60;rotationz,90;diffusealpha,0;sleep,0.3;queuecommand,"Repeat";);
				RepeatCommand=cmd(addy,-16;diffusealpha,1;glow,color("1,0.7,0,1");linear,0.8;glow,color("0,0,0,0");addy,16;diffusealpha,0;sleep,0.2;queuecommand,"Repeat";);
				OffCommand=cmd(stoptweening;);
			};
		};
	};
end;

function c_profname(prof)
	return LoadFont("_shared2") .. {
		InitCommand=function(self)
			self:settext( prof:GetDisplayName() );
			(cmd(horizalign,left;x,SCREEN_LEFT+60;y,SCREEN_TOP+70;maxwidth,250;zoom,0.9;strokecolor,Color("Black");))(self)
		end;
	};
end;

function f_count_initial(pstr)
	local prof_fsortfiledir = PROFILEMAN:LocalProfileIDToDir(pstr).."CS_Favorite/SongManager Favorite";
	local f_path = "";
	local fci_flag = false;
	if GetAdhocPref("FavoriteCount",pstr) then
		f_path = prof_fsortfiledir..GetAdhocPref("FavoriteCount",pstr)..".txt";
	end;
	if f_path ~= "" and FILEMAN:DoesFileExist(f_path) then
		if sortfilecheck(f_path) then
			fci_flag = true;
		end;
	end;
	if not fci_flag then
		for fr=1,5 do
			f_path = prof_fsortfiledir..fr..".txt";
			if FILEMAN:DoesFileExist(f_path) then
				if sortfilecheck(f_path) then
					SetAdhocPref("FavoriteCount",fr,pstr);
					fci_flag = true;
					break;
				end;
			end;
		end;
	end;
	return fci_flag;
end;

function favoritesortopen()
	local scstr = string.sub(getenv("SortCh"),-1);
	local c_ws_csc = tonumber(string.sub(getenv("wheelsectioncsc"),-1));
	local f_flag = false;
	if scstr == "1" or scstr == "2" then
		local pstr = ProfIDSet(scstr);
		local prof_fsortfiledir = PROFILEMAN:LocalProfileIDToDir(pstr).."CS_Favorite/SongManager ";
		local ct_dic = THEME:GetCurrentThemeDirectory();
		local mainpath = ct_dic.."/Other/SongManager Main_New.txt";
		local f_path = prof_fsortfiledir.."Favorite"..c_ws_csc..".txt";
		if FILEMAN:DoesFileExist(f_path) then
			if sortfilecheck(f_path) then
				sl_f_file_read(f_path,c_ws_csc);
				sl_f_file_write(mainpath,c_ws_csc,extralinecheck(f_path));
				favorite_s_table = {{},{},{},{},{}};
				SONGMAN:SetPreferredSongs("Main_New.txt");
				setenv("ReloadFlag",{2,getenv("Timer")});
				f_flag = true;
				SetAdhocPref("FavoriteCount",c_ws_csc,pstr);
				SOUND:PlayOnce(THEME:GetPathS("","_swoosh"));
			end;
			local ns = IsNetConnected() and "ScreenNetSelectMusic" or SelectMusicExtra();
			SCREENMAN:SetNewScreen(ns);
		end;
	end;
	if not f_flag then
		SCREENMAN:SystemMessage(string.format( THEME:GetString("ScreenSelectMusic","NotFavoriteSort"),c_ws_csc ));
	end;
end;