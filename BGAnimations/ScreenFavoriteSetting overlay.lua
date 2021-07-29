--[[ScreenFavoriteSetting overlay]]

SnamecolorSet("song");

local t = Def.ActorFrame {};

local f_screen = "group";
local profile= GAMESTATE:GetEditLocalProfile();
local profile_id= GAMESTATE:GetEditLocalProfileID();
local pid_name = profile:GetGUID().."_"..profile:GetDisplayName();
local sectioncolorlist = getenv("sectioncolorlist");
local sectionsubnamelist = getenv("sectionsubnamelist");
local prof_fsortfiledir = PROFILEMAN:LocalProfileIDToDir(profile_id).."CS_Favorite/SongManager ";
local expsc = "Favorite";

local key_open = 0;
local tpwidth = 240;
local space = 42;
local curIndex = 1;
local plus_exit = SONGMAN:GetSongGroupNames();
plus_exit[#plus_exit+1] = "Exit";

local yorn = 0;
local keynum = 0;

function DarkColor( color ) 
	local c = color
	return { c[1]*0.6, c[2]*0.6, c[3]*0.6, c[4] }
end

t.InitCommand=function(self)
	if fss_check == 0 then
		favorite_c_table = {};
		favorite_tc_table = {};
		favorite_s_table = {{},{},{},{},{}};
		for f_count = 1,5 do
			local rsetting;
			if FILEMAN:DoesFileExist( prof_fsortfiledir..expsc..f_count..".txt" ) then
				rsetting = prof_fsortfiledir..expsc..f_count..".txt";
			end;
			if rsetting then
				local f = RageFileUtil.CreateRageFile();
				f:Open(rsetting,1);
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
						if not favorite_c_table[ssp[1]] then
							favorite_c_table[ssp[1]] = {};
						end;
						if f_dir and f_count > 0 then
							if not favorite_tc_table[f_count] then
								favorite_tc_table[f_count] = 0;
							end;
							favorite_s_table[f_count][f_dir] = l;
							seccheck = 4;
							if seccheck == 4 then
								if not favorite_c_table[ssp[1]][f_count] then
									favorite_c_table[ssp[1]][f_count] = 0;
								end;
								if favorite_s_table[f_count][f_dir] then
									favorite_c_table[ssp[1]][f_count] = favorite_c_table[ssp[1]][f_count] + 1;
									--if favorite_c_table[ssp[1]][f_count] then
									--	Trace("f_count : "..f_dir.." : "..ssp[1].." : "..favorite_c_table[ssp[1]][f_count]);
									--end;
									favorite_tc_table[f_count] = favorite_tc_table[f_count] + 1;
								end;
								seccheck = 1;
							end;
						end;
					else break;
					end;
				end;
				f:Close();
				f:destroy();
			end;
		end;
		fss_check = 1;
	end;
end;

t.F_StartButtonMessageCommand=function(self)
	local settopstring = "";
	local setstring = "";
	local sortkey = {};
	local n = 0;
	for ff = 1,5 do
		if favorite_s_table[ff] then
			if not sortkey then
				sortkey = {};
			end;
			for key, val in pairs( favorite_s_table[ff] ) do
				n = n + 1;
				if val then
					local c_val = "";
					c_val = string.sub(val,-1) == "/" and string.sub(val,1,-2) or string.sub(val,1,-1);
					sortkey[n] = c_val.."\r\n";
				end;
			end;
			if n == 0 then
				settopstring = "";
			else settopstring = "--- "..expsc.." "..ff.."\r\n";
			end;
			table.sort(sortkey);
		end;
		setstring = settopstring..table.concat(sortkey);
		--Trace("setstring : "..key..val);
		File.Write(prof_fsortfiledir..expsc..ff..".txt",string.sub(setstring,1,-1));
		settopstring = "";
		setstring = "";
		sortkey = {};
		n = 0;
	end;
	favorite_s_table = {{},{},{},{},{}};
	fss_check = 0;
	fss_cgroup = "";
	f_flag_check = 0;
end;

t.GClearDecideMessageCommand=function(self)
	if curIndex < #plus_exit then
		favorite_c_table[plus_exit[curIndex]][keynum] = 0;
		local groupsong = SONGMAN:GetSongsInGroup(plus_exit[curIndex]);
		local tcccount = 0;
		for sg = 1,#groupsong do
			local songu = groupsong[sg]:GetSongDir();
			local songdir = s_songdir(songu);
			if favorite_s_table[keynum][songdir] then
				tcccount = tcccount + 1;
				favorite_s_table[keynum][songdir] = nil;
			end;
		end;
		favorite_tc_table[keynum] = favorite_tc_table[keynum] - tcccount;
		f_flag_check = 1;
	end;
	if curIndex == #plus_exit then
		for fr = 1,#plus_exit - 1 do
			if favorite_c_table[plus_exit[fr]] and favorite_c_table[plus_exit[fr]][keynum] then
				favorite_c_table[plus_exit[fr]][keynum] = 0;
			end;
		end;
		favorite_s_table[keynum] = nil;
		favorite_tc_table[keynum] = 0;
		f_flag_check = 1;
	end;
	self:playcommand("Set");
end;

function GetGroup()
	local t = {};
	for x = 1,#plus_exit do
		local groupset = Def.ActorFrame {};

		groupset[#groupset+1]= LoadActor( THEME:GetPathB("","NormalPart") )..{
			InitCommand=cmd(x,84;y,2;);
		};
		
		if x < #plus_exit then
			for s = 1,5 do
				groupset[#groupset+1]= Def.ActorFrame {
					InitCommand=cmd(x,-60+(50*s);y,8;);
					LoadActor( THEME:GetPathG("","star") )..{
						Name="Star";
						InitCommand=function(self)
							(cmd(zoom,0.4;shadowlength,1;))(self);
							s_colorchange(self,favorite_c_table,plus_exit[x],s);
						end;
						SetCommand=function(self)
							s_colorchange(self,favorite_c_table,plus_exit[x],s);
						end;
						GClearDecideMessageCommand=cmd(playcommand,"Set";);
					};
					LoadFont("Common Normal") .. {
						Text= s;
						InitCommand=cmd(x,-6;y,6;zoom,0.4;diffuse,DarkColor(Color("White"));strokecolor,color("0,0,0,1");shadowlength,2;);
					};
					LoadFont("Common Normal") .. {
						InitCommand=function(self)
							(cmd(x,4;y,0;horizalign,left;maxwidth,50;zoom,0.6;strokecolor,color("0,0,0,1");shadowlength,2;))(self)
							self:settext(0);
							s_textchange(self,favorite_c_table,plus_exit[x],s);
						end;
						SetCommand=function(self)
							s_textchange(self,favorite_c_table,plus_exit[x],s);
						end;
						GClearDecideMessageCommand=cmd(playcommand,"Set";);
					};
				};
			end;
			groupset[#groupset+1]= Def.ActorFrame {
				LoadFont("_Shared2") .. {
					Text= plus_exit[x];
					InitCommand=function(self)
						(cmd(x,-80;y,-10;horizalign,left;maxwidth,300;zoom,0.75;strokecolor,Color("Black");))(self)
						if sectioncolorlist[plus_exit[x]] then
							self:diffuse(color(sectioncolorlist[plus_exit[x]]));
						end;
						if sectionsubnamelist[plus_exit[x]] then
							self:settext(sectionsubnamelist[plus_exit[x]]);
						end;
					end;
				};
			};
		else
			groupset[#groupset+1]= Def.ActorFrame {
				LoadFont("Common Normal") .. {
					InitCommand=cmd(x,80;uppercase,true;maxwidth,300;strokecolor,color("0,0,0,1");zoom,0.75;
								diffuse,color("0,1,1,1");strokecolor,ColorDarkTone(color("1,0.5,0,1"));
								settext,THEME:GetString("ScreenTitleMenu","Exit"););
				};
			};
		end;
		t[#t+1]=groupset;
	end;
	
	return t
end;

local xwideset = WideScale(SCREEN_CENTER_X+100,SCREEN_CENTER_X+130);
local xwide_s_set = WideScale(SCREEN_CENTER_X-180,SCREEN_CENTER_X-220);

t[#t+1] = Def.Quad{
	InitCommand=cmd(horizalign,right;x,SCREEN_RIGHT;y,SCREEN_CENTER_Y+4;);
	OnCommand=cmd(diffuse,color("1,0.4,0,0.8");fadetop,0.2;fadebottom,0.2;
				zoomtowidth,SCREEN_RIGHT+(SCREEN_WIDTH*0.4);zoomtoheight,56;diffuseleftedge,color("1,0.4,0,0"));
};

t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(x,xwideset;);
	Def.Quad{
		Name="TopMask";
		InitCommand=cmd(x,40;y,SCREEN_TOP+64;zoomto,460,160;valign,1;clearzbuffer,true;zwrite,true;blend,Blend.NoEffect;);
	};

	Def.Quad{
		Name="BottomMask";
		InitCommand=cmd(x,40;y,SCREEN_BOTTOM-44;zoomto,460,160;valign,0;clearzbuffer,false;zwrite,true;blend,Blend.NoEffect;);
	};

	Def.ActorScroller{
		Name = 'Scroller';
		NumItemsToDraw=12;
		InitCommand=function(self)
			self:clearzbuffer(true);
			self:zwrite(true);
			self:zbuffer(true);
			self:ztest(true);
			self:z(0);
			(cmd(y,SCREEN_CENTER_Y;SetFastCatchup,true;SetSecondsPerItem,0.15;SetDestinationItem,curIndex;))(self)
		end;
		TransformFunction=function(self, offset, itemIndex, numItems)
			self:visible(false);
			self:x(-40);
			self:y(math.floor( (offset + 1)*space ));
			if offset == -1 then
				self:x(-60);
			end;
		end;
		DirectionButtonMessageCommand = function(self, params)
			self:SetDestinationItem( curIndex );
		end;
		children = GetGroup();
	};
};

t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(x,xwide_s_set;y,SCREEN_CENTER_Y;);
	Def.Banner{
		InitCommand=function(self)
			(cmd(vertalign,bottom;shadowlength,2;y,-12;))(self)
			bannerset(self,f_screen,curIndex,plus_exit);
		end;
		DirectionButtonMessageCommand = function(self)
			bannerset(self,f_screen,curIndex,plus_exit);
		end;
	};
	Def.Banner{
		InitCommand=function(self)
			(cmd(vertalign,bottom;shadowlength,2;y,160;))(self)
			jacketset(self,f_screen,curIndex,plus_exit);
		end;
		DirectionButtonMessageCommand = function(self)
			jacketset(self,f_screen,curIndex,plus_exit);
		end;
	};
};

t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(x,SCREEN_RIGHT-4;CenterY;);
	scrollerset();
	OnCommand=function(self)
		local thumb = self:GetChild('Scroller'):GetChild('TickThumb');
		f_sety(thumb,curIndex,plus_exit);
		thumb:queuecommand("Repeat");
	end;
	DirectionButtonMessageCommand=function(self)
		local thumb = self:GetChild('Scroller'):GetChild('TickThumb');
		f_sety(thumb,curIndex,plus_exit);
	end;
}
t[#t+1] = favoritetotalsetting(favorite_tc_table);

function inputs(event)
	local button = event.GameButton;
	local n_button = event.button;
	local d_button = event.DeviceInput.button;
	if event.type == "InputEventType_FirstPress" then
		if key_open == 2 then
			if button == "Back" then
				SOUND:PlayOnce(THEME:GetPathS("_Screen","cancel"));
				MESSAGEMAN:Broadcast("GClearCancel",{Num = keynum});
				key_open = 4;
				yorn = 0;
			end;
		elseif key_open == 4 then
			key_open = 0;
		end;
	end;
	if key_open == 0 then
		if event.type ~= "InputEventType_Release" then
			if button == 'MenuLeft' or button == 'MenuUp' or n_button == "EffectDown" then
				if curIndex > 1 then
					if n_button == "EffectDown" then
						curIndex = curIndex - math.min(curIndex - 1,fs_move);
					else curIndex = curIndex - 1;
					end;
					SOUND:PlayOnce(THEME:GetPathS("_common","row"));
					MESSAGEMAN:Broadcast("DirectionButton");
					MESSAGEMAN:Broadcast("Previous");
				end;
			end;
			if button == 'MenuRight' or button == 'MenuDown' or n_button == "EffectUp" then
				if curIndex < #plus_exit then
					if curIndex > 0 then
						if n_button == "EffectUp" then
							curIndex = curIndex + math.min(#plus_exit - curIndex,fs_move);
						else curIndex = curIndex + 1;
						end;
						SOUND:PlayOnce(THEME:GetPathS("_common","row"));
						MESSAGEMAN:Broadcast("DirectionButton");
						MESSAGEMAN:Broadcast("Next");
					end;
				end;
			end;
		end;
		if event.type == "InputEventType_FirstPress" then
			if button == 'Start' or button == 'Center' then
				if curIndex < #plus_exit then
					local set = 0;
					SOUND:PlayOnce(THEME:GetPathS("","_prompt"));
					fss_cgroup = SONGMAN:GetSongGroupNames()[curIndex];
					MESSAGEMAN:Broadcast("NScreen");
					SCREENMAN:AddNewScreenToTop("ScreenFavoriteSettingSong");
				end;
				if curIndex == #plus_exit then
					key_open = 3;
					MESSAGEMAN:Broadcast("F_StartButton");
					SOUND:PlayOnce(THEME:GetPathS("Common","start"));
					SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen");
				end;
			end;
			if button == "Back" then
				if f_flag_check > 0 then
					key_open = 2;
					SOUND:PlayOnce(THEME:GetPathS("","_prompt"));
					MESSAGEMAN:Broadcast("GClearOpen",{Num = keynum,Str = "FavoriteSaveCheckText"});
				else
					key_open = 3;
					MESSAGEMAN:Broadcast("BackButton");
					SOUND:PlayOnce(THEME:GetPathS("_Screen","cancel"));
					SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToPrevScreen");
				end;
			end;

			local d_button_str = string.gsub(d_button,"^DeviceButton_","");
			if tonumber(d_button_str) and (tonumber(d_button_str) >= 1 and tonumber(d_button_str) <= 5) then
				if curIndex < #plus_exit then
					if favorite_c_table[plus_exit[curIndex]] and favorite_c_table[plus_exit[curIndex]][tonumber(d_button_str)] then
						if favorite_c_table[plus_exit[curIndex]][tonumber(d_button_str)] > 0 then
							key_open = 1;
						end;
					end;
				else
					if favorite_tc_table[tonumber(d_button_str)] and favorite_tc_table[tonumber(d_button_str)] > 0 then
						key_open = 1;
					end;
				end;
				if key_open == 1 then
					keynum = tonumber(d_button_str);
					SOUND:PlayOnce(THEME:GetPathS("","_prompt"));
					--SCREENMAN:SystemMessage("GClearOpen : "..plus_exit[curIndex].." : "..d_button_str);
					MESSAGEMAN:Broadcast("GClearOpen",{Num = keynum,Str = "SectionDeleteCheckText"});
				end;
			end;
		end;
	end;
	if key_open == 1 or key_open == 2 then
		if event.type == "InputEventType_FirstPress" then
			if yorn == 0 and (button == 'MenuLeft' or button == 'MenuUp' or n_button == "EffectDown") then
				yorn = 1;
				SOUND:PlayOnce(THEME:GetPathS("_common","row"));
				MESSAGEMAN:Broadcast("GClearYNChanged");
			end;
			if yorn == 1 and (button == 'MenuRight' or button == 'MenuDown' or n_button == "EffectUp") then
				yorn = 0;
				SOUND:PlayOnce(THEME:GetPathS("_common","row"));
				MESSAGEMAN:Broadcast("GClearYNChanged");
			end;
			if button == "Back" then
				if key_open == 1 then
					SOUND:PlayOnce(THEME:GetPathS("_Screen","cancel"));
					MESSAGEMAN:Broadcast("GClearCancel",{Num = keynum});
					key_open = 0;
					yorn = 0;
				end;
			end;
			if button == 'Start' or button == 'Center' then
				SOUND:PlayOnce(THEME:GetPathS("Common","start"));
				if yorn == 1 then
					if key_open == 2 then
						key_open = 3;
						MESSAGEMAN:Broadcast("F_StartButton");
						SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen");
					elseif key_open == 1 then
						key_open = 0;
						MESSAGEMAN:Broadcast("GClearDecide");
						MESSAGEMAN:Broadcast("GClearCancel",{Num = keynum});
					end;
				else
					if key_open == 2 then
						key_open = 3;
						favorite_s_table = {{},{},{},{},{}};
						fss_check = 0;
						fss_cgroup = "";
						f_flag_check = 0;
						SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen");
					else
						MESSAGEMAN:Broadcast("GClearCancel",{Num = keynum});
					end;
					key_open = 0;
				end;
				yorn = 0;
			end;
		end;
	end;
	if key_open == 3 then fss_check = 0;
	end;
end;

t[#t+1] = Def.ActorFrame {
	OnCommand=function(self)
		SCREENMAN:GetTopScreen():lockinput(0.25);
		SCREENMAN:GetTopScreen():AddInputCallback(inputs);
	end;
};

t[#t+1] = Def.ActorFrame {
	nav_set();
	InitCommand=function(self)
		local down = self:GetChild('Nav'):GetChild('Down');
		local up = self:GetChild('Nav'):GetChild('Up');
		f_cursorset(down,"Down",curIndex,#plus_exit);
		f_cursorset(up,"Up",curIndex,#plus_exit);
	end;
	DirectionButtonMessageCommand=function(self)
		local down = self:GetChild('Nav'):GetChild('Down');
		local up = self:GetChild('Nav'):GetChild('Up');
		f_cursorset(down,"Down",curIndex,#plus_exit);
		f_cursorset(up,"Up",curIndex,#plus_exit);
	end;
};

t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(visible,false;y,SCREEN_CENTER_Y-19;);
	Def.Quad {
		Name="A_Back";
		InitCommand=cmd(zoomto,300,110;horizalign,right;vertalign,bottom;);
	};
	Def.Quad {
		Name="A_Focus";
		InitCommand=cmd(horizalign,right;vertalign,bottom;);
	};
	LoadFont("_Shared2") .. {
		Name="A_Group";
		InitCommand=cmd(y,-90;strokecolor,Color("Black");horizalign,left;vertalign,bottom;maxwidth,300;zoom,0.75;shadowlength,2;diffusealpha,0;);
	};
	Def.ActorFrame{
		Name="A_Star";
		InitCommand=cmd(y,-93;horizalign,left;);
		LoadActor( THEME:GetPathG("","star") )..{
			Name="Image";
			InitCommand=cmd(zoom,0.4;shadowlength,1;);
		};
		LoadFont("Common Normal") .. {
			Name="Index";
			InitCommand=cmd(x,-6;y,6;zoom,0.4;diffuse,Color("White");strokecolor,Color("Black");shadowlength,2;);
		};
		LoadFont("Common Normal") .. {
			Name="Num";
			InitCommand=cmd(x,4;y,0;settext,0;horizalign,left;maxwidth,50;zoom,0.6;strokecolor,Color("Black");shadowlength,2;);
		};
	};
	Def.Quad {
		Name="YN_Focus";
		InitCommand=cmd(y,-7;horizalign,center;vertalign,bottom;zoomto,100,24;diffusealpha,0;);
	};
	LoadFont("Common Normal") .. {
		Name="A_String";
		InitCommand=cmd(strokecolor,Color("Black");horizalign,left;vertalign,middle;wrapwidthpixels,360;zoom,0.65;shadowlength,2;diffusealpha,0;);
	};
	LoadFont("Common Normal") .. {
		Name="Notext";
		Text= THEME:GetString("MusicWheel","YesText");
		InitCommand=cmd(y,-20;horizalign,center;vertalign,bottom;maxwidth,90;zoom,0.75;strokecolor,Color("Black");shadowlength,2;diffusealpha,0;);
	};
	LoadFont("Common Normal") .. {
		Name="Yestext";
		Text= THEME:GetString("MusicWheel","NoText");
		InitCommand=cmd(y,-20;horizalign,center;vertalign,bottom;maxwidth,90;zoom,0.75;strokecolor,Color("Black");shadowlength,2;diffusealpha,0;);
	};
	GClearOpenMessageCommand=function(self,param)
		if curIndex < #plus_exit then
			check_f_table(plus_exit[curIndex],param.Num);
		end;
		local a_back = self:GetChild('A_Back');
		local a_focus = self:GetChild('A_Focus');
		local a_group = self:GetChild('A_Group');
		local a_star = self:GetChild('A_Star');
		local a_star_i = self:GetChild('A_Star'):GetChild('Image');
		local a_star_in = self:GetChild('A_Star'):GetChild('Index');
		local a_star_n = self:GetChild('A_Star'):GetChild('Num');
		local a_string = self:GetChild('A_String');
		local yn_focus = self:GetChild('YN_Focus');
		local notext = self:GetChild('Notext');
		local yestext = self:GetChild('Yestext');
		self:visible(true);
		(cmd(stoptweening;diffuse,color("0,0,0,0");linear,0.1;diffuse,color("0,0,0,0.75")))(a_back);
		a_string:settext(THEME:GetString("ScreenFavoriteSetting",param.Str));
		if param.Str ~= "FavoriteSaveCheckText" then
			a_group:visible(true);
			a_star:visible(true);
			a_focus:visible(true);
			a_string:y(-58);
			if curIndex < #plus_exit then
				self:x(xwide_d_set+(50*param.Num)+10);
				(cmd(x,0;y,40;zoomto,40,24;))(a_focus);
				a_group:settext(plus_exit[curIndex]);
				if sectioncolorlist[plus_exit[curIndex]] then
					a_group:diffuse(color(sectioncolorlist[plus_exit[curIndex]]));
				end;
				if sectionsubnamelist[plus_exit[curIndex]] then
					a_group:settext(sectionsubnamelist[plus_exit[curIndex]]);
				end;
			else
				self:x(xwide_d_set+(50*param.Num)-40);
				(cmd(x,70;y,0;zoomto,40,SCREEN_HEIGHT/2;))(a_focus);
				a_group:diffuse(f_color_set[param.Num]);
				a_group:settext(THEME:GetString("ScreenFavoriteSetting","FavoriteDeleteCheckText"));
			end;
			a_star_i:diffuse(f_color_set[param.Num]);
			a_star_in:settext(param.Num);
			if curIndex < #plus_exit then
				a_star_n:settext(favorite_c_table[plus_exit[curIndex]][param.Num]);
			else a_star_n:settext(favorite_tc_table[param.Num]);
			end;
			(cmd(stoptweening;x,-280+(math.min(300*0.75,a_group:GetWidth()*0.75))+20;diffusealpha,0;linear,0.1;diffusealpha,1))(a_star);
		else
			self:x(SCREEN_CENTER_X);
			a_string:y(-68);
			a_group:visible(false);
			a_star:visible(false);
			a_focus:visible(false);
		end;
		(cmd(stoptweening;diffuse,color("0,1,1,0");linear,0.1;diffuse,color("0,1,1,0.5")))(a_focus);
		(cmd(stoptweening;x,-280;diffusealpha,0;linear,0.1;diffusealpha,1))(a_group);
		(cmd(stoptweening;x,-100;diffuse,color("1,0.5,0,0");linear,0.1;diffuse,color("1,0.5,0,0.75")))(yn_focus);
		(cmd(stoptweening;x,-280;diffusealpha,0;linear,0.1;diffusealpha,1))(a_string);
		(cmd(stoptweening;x,-200;diffusealpha,0;linear,0.1;diffusealpha,1))(notext);
		(cmd(stoptweening;x,-100;diffusealpha,0;linear,0.1;diffusealpha,1))(yestext);
	end;
	GClearCancelMessageCommand=function(self,param)
		if curIndex < #plus_exit then
			check_f_table(plus_exit[curIndex],param.Num);
		end;
		local a_back = self:GetChild('A_Back');
		local a_focus = self:GetChild('A_Focus');
		local a_group = self:GetChild('A_Group');
		local a_star = self:GetChild('A_Star');
		local a_string = self:GetChild('A_String');
		local yn_focus = self:GetChild('YN_Focus');
		local notext = self:GetChild('Notext');
		local yestext = self:GetChild('Yestext');
		local disablecommand = cmd(stoptweening;linear,0.1;diffusealpha,0);
		
		(cmd(stoptweening;linear,0.1;diffuse,color("0,0,0,0")))(a_back);
		(cmd(stoptweening;linear,0.1;diffuse,color("0,1,1,0")))(a_focus);
		(disablecommand)(a_group);
		(disablecommand)(a_star);
		(disablecommand)(a_string);
		(cmd(stoptweening;linear,0.1;diffuse,color("1,0.5,0,0")))(yn_focus);
		(disablecommand)(yestext);
		(disablecommand)(notext);
	end;
	GClearYNChangedMessageCommand=function(self)
		local yn_focus = self:GetChild('YN_Focus');
		local xcheckt = {-100,-200};
		(cmd(stoptweening;x,xcheckt[yorn+1]))(yn_focus);
	end;
};

t.OnCommand=cmd(stoptweening;playcommand,"Set");
t.ExpandButtonMessageCommand=function(self)
	if key_open == 0 then
		self:playcommand("Set");
	end;
end;
t.NScreenMessageCommand=cmd(visible,false;);
t.BScreenMessageCommand=cmd(visible,true;);

t[#t+1]=c_profname(profile);

return t;