--[[ScreenFavoriteSettingSong overlay]]

local t = Def.ActorFrame {};

local f_screen = "song";
local profile= GAMESTATE:GetEditLocalProfile();
local profile_id= GAMESTATE:GetEditLocalProfileID();
local pid_name = profile:GetGUID().."_"..profile:GetDisplayName();
local sectioncolorlist = getenv("sectioncolorlist");
local sectionsubnamelist = getenv("sectionsubnamelist");
local ft_count = 0;

local key_open = 0;
local tpwidth = 240;
local space = 42;
local T_curIndex = 1;
local plus_back = SONGMAN:GetSongsInGroup(fss_cgroup);
plus_back[#plus_back+1] = "Back";

function colorchange(self,tx,s)
	if tx < #plus_back then
		self:diffuse(color("0.5,0.5,0.5,1"));
		local c_songu = plus_back[tx]:GetSongDir();
		local c_songDir = s_songdir(c_songu);
		if favorite_s_table[s] and favorite_s_table[s][c_songDir] then
			self:diffuse(f_color_set[s]);
		end;
	end;
	return self;
end;
function t_count_check(t)
	local t_count = 0;
	for key, val in pairs( t ) do
		t_count = t_count + 1;
	end;
	return t_count;
end;

function GetSong()
	local t = {};
	for tx = 1,#plus_back do
		local songset = Def.ActorFrame {};

		songset[#songset+1]= LoadActor( THEME:GetPathB("","NormalPart") )..{
			InitCommand=cmd(x,74;y,2;);
		};
		
		if tx < #plus_back then
			for s = 1,5 do
				songset[#songset+1]= Def.ActorFrame {
					InitCommand=cmd(x,-110+(20*s););
					LoadActor( THEME:GetPathG("","star") )..{
						Name="Star";
						InitCommand=function(self)
							(cmd(zoom,0.5;shadowlength,1;))(self);
							local cc_song_dir = plus_back[tx]:GetSongDir();
							local tc_song_dir = plus_back[T_curIndex]:GetSongDir();
							cc_song_dir = s_songdir(cc_song_dir);
							tc_song_dir = s_songdir(tc_song_dir);
							colorchange(self,tx,s);
						end;
						SetCommand=function(self)
							colorchange(self,tx,s);
						end;
					};
					LoadFont("Common Normal") .. {
						Text= s;
						InitCommand=cmd(x,6;y,6;zoom,0.5;strokecolor,color("0,0,0,1");shadowlength,2;);
					};
				};
			end;
			songset[#songset+1]= Def.TextBanner {
				InitCommand=cmd(x,-5;Load,"EvaluationTextBanner";SetFromString,"", "", "", "", "", "";);
				OnCommand=function(self)
					local song = plus_back[tx];
					self:visible(true);
					if song then
						self:SetFromSong( song );
						self:diffuse(SONGMAN:GetSongColor(song));
						local sdirs = split("/",song:GetSongDir());
						if sectioncolorlist ~= "" then
							if sectioncolorlist[song:GetGroupName().."/"..sdirs[4]] then
								self:diffuse(color(sectioncolorlist[song:GetGroupName().."/"..sdirs[4]]));
							elseif sectioncolorlist[song:GetGroupName()] then
								self:diffuse(color(sectioncolorlist[song:GetGroupName()]));
							end;
						end;
					end;
				end;
			};
		else
			songset[#songset+1]= Def.ActorFrame {
				LoadFont("Common Normal") .. {
					InitCommand=cmd(x,80;uppercase,true;maxwidth,300;zoom,0.75;diffuse,color("0,1,1,1");
								strokecolor,ColorDarkTone(color("1,0.5,0,1"));settext,THEME:GetString("GameButton","Back"););
				};
			};
		end;
		t[#t+1]=songset;
	end;
	
	return t
end;

local xwideset = WideScale(SCREEN_CENTER_X+50,SCREEN_CENTER_X+80);
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
			(cmd(y,SCREEN_CENTER_Y;SetFastCatchup,true;SetSecondsPerItem,0.15;SetDestinationItem,T_curIndex;))(self)
		end;
		TransformFunction=function(self, offset, itemIndex, numItems)
			self:visible(false);
			self:x(20);
			self:y(math.floor( (offset + 1)*space ));
			if offset == -1 then
				self:x(0);
			end;
		end;
		T_DirectionButtonMessageCommand = function(self, params)
			self:SetDestinationItem( T_curIndex );
		end;
		children = GetSong();
	};
};

t[#t+1]= LoadFont("_Shared2") .. {
	Text= fss_cgroup;
	InitCommand=function(self)
		(cmd(x,xwide_s_set+120;y,SCREEN_CENTER_Y-80;horizalign,right;maxwidth,300;zoom,0.75;strokecolor,Color("Black");))(self)
		if sectioncolorlist[fss_cgroup] then
			self:diffuse(color(sectioncolorlist[fss_cgroup]));
		end;
		if sectionsubnamelist[fss_cgroup] then
			self:settext(sectionsubnamelist[fss_cgroup]);
		end;
	end;
};

t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(x,xwide_s_set;y,SCREEN_CENTER_Y;);
	 Def.Banner{
		InitCommand=function(self)
			(cmd(vertalign,bottom;shadowlength,2;y,-12;))(self)
			bannerset(self,f_screen,T_curIndex,plus_back);
		end;
		T_DirectionButtonMessageCommand = function(self)
			bannerset(self,f_screen,T_curIndex,plus_back);
		end;
	};
	Def.Banner{
		InitCommand=function(self)
			(cmd(vertalign,bottom;shadowlength,2;y,160;))(self)
			jacketset(self,f_screen,T_curIndex,plus_back);
		end;
		T_DirectionButtonMessageCommand = function(self)
			jacketset(self,f_screen,T_curIndex,plus_back);
		end;
	};
};

t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(x,SCREEN_RIGHT-4;CenterY;);
	scrollerset();
	OnCommand=function(self)
		local thumb = self:GetChild('Scroller'):GetChild('TickThumb');
		f_sety(thumb,T_curIndex,plus_back);
		thumb:queuecommand("Repeat");
	end;
	DirectionButtonMessageCommand=function(self)
		local thumb = self:GetChild('Scroller'):GetChild('TickThumb');
		f_sety(thumb,T_curIndex,plus_back);
	end;
	T_DirectionButtonMessageCommand=function(self)
		local thumb = self:GetChild('Scroller'):GetChild('TickThumb');
		f_sety(thumb,T_curIndex,plus_back);
	end;
}
t[#t+1] = favoritetotalsetting(favorite_tc_table);

function inputs(event)
	local button = event.GameButton
	local n_button = event.button;
	local d_button = event.DeviceInput.button;
	if key_open == 0 then
		if event.type ~= "InputEventType_Release" then
			if button == 'MenuLeft' or button == 'MenuUp' or n_button == "EffectDown" then
				if T_curIndex > 1 then
					if n_button == "EffectDown" then
						T_curIndex = T_curIndex - math.min(T_curIndex - 1,fs_move);
					else T_curIndex = T_curIndex - 1;
					end;
					SOUND:PlayOnce(THEME:GetPathS("_common","row"));
					MESSAGEMAN:Broadcast("T_DirectionButton");
					MESSAGEMAN:Broadcast("T_Previous");
				end;
			end;
			if button == 'MenuRight' or button == 'MenuDown' or n_button == "EffectUp" then
				if T_curIndex < #plus_back then
					if T_curIndex > 0 then
						if n_button == "EffectUp" then
							T_curIndex = T_curIndex + math.min(#plus_back - T_curIndex,fs_move);
						else T_curIndex = T_curIndex + 1;
						end;
						SOUND:PlayOnce(THEME:GetPathS("_common","row"));
						MESSAGEMAN:Broadcast("T_DirectionButton");
						MESSAGEMAN:Broadcast("T_Next");
					end;
				end;
			end;
		end;
		if event.type == "InputEventType_FirstPress" then
			if button == 'Start' or button == 'Center' then
				if T_curIndex == #plus_back then
					key_open = 1;
					MESSAGEMAN:Broadcast("BackButton");
					SOUND:PlayOnce(THEME:GetPathS("Common","start"));
					MESSAGEMAN:Broadcast("BScreen");
					SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen");
				end;
			end;
			if button == "Back" then
				key_open = 1;
				MESSAGEMAN:Broadcast("BackButton");
				SOUND:PlayOnce(THEME:GetPathS("Common","start"));
				MESSAGEMAN:Broadcast("BScreen");
				SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToPrevScreen");
			end;

			if T_curIndex < #plus_back then
				local d_button_str = string.gsub(d_button,"^DeviceButton_","");
				ft_count = 0;
				if tonumber(d_button_str) and (tonumber(d_button_str) >= 1 and tonumber(d_button_str) <= 5) then
					if favorite_s_table[tonumber(d_button_str)] then
						for key, val in pairs( favorite_s_table[tonumber(d_button_str)] ) do
							ft_count = ft_count + 1;
						end;
					else favorite_s_table[tonumber(d_button_str)] = {};
					end;
					local songu = plus_back[T_curIndex]:GetSongDir();
					local songdir = s_songdir(songu);
					
					if ft_count <= f_max_set then
						if favorite_s_table[tonumber(d_button_str)][songdir] and favorite_s_table[tonumber(d_button_str)][songdir] ~= nil then
							check_f_table(fss_cgroup,tonumber(d_button_str));
							if favorite_c_table[fss_cgroup][tonumber(d_button_str)] then
								favorite_c_table[fss_cgroup][tonumber(d_button_str)] = 
									math.max(0,(favorite_c_table[fss_cgroup][tonumber(d_button_str)] - 1));
								favorite_tc_table[tonumber(d_button_str)] = 
									math.max(0,(favorite_tc_table[tonumber(d_button_str)] - 1));
							end;
							favorite_s_table[tonumber(d_button_str)][songdir] = nil;
							f_flag_check = 1;
							--SCREENMAN:SystemMessage(tostring(favorite_s_table[tonumber(d_button_str)][songdir]));
							SOUND:PlayOnce(THEME:GetPathS("MusicWheel","expand"));
						else
							if ft_count < f_max_set then
								favorite_s_table[tonumber(d_button_str)][songdir] = songdir;
								check_f_table(fss_cgroup,tonumber(d_button_str));
								favorite_c_table[fss_cgroup][tonumber(d_button_str)] = 
									math.max(0,(favorite_c_table[fss_cgroup][tonumber(d_button_str)] + 1));
								favorite_tc_table[tonumber(d_button_str)] = 
									math.max(0,(favorite_tc_table[tonumber(d_button_str)] + 1));
								--SCREENMAN:SystemMessage(tostring(favorite_s_table[tonumber(d_button_str)][songdir]));
								f_flag_check = 1;
								SOUND:PlayOnce(THEME:GetPathS("MusicWheel","expand"));
							else SOUND:PlayOnce(THEME:GetPathS("MusicWheel","locked"));
							end;
						end;
					else SOUND:PlayOnce(THEME:GetPathS("MusicWheel","locked"));
					end;
					MESSAGEMAN:Broadcast("ExpandButton");
				end;
			end;
		end;
	end;

	--if ft_count then
		--SCREENMAN:SystemMessage(ft_count);
	--end;
end;
t[#t+1] = Def.ActorFrame {
	OnCommand=function(self)
		SCREENMAN:GetTopScreen():lockinput(0.25);
		SCREENMAN:GetTopScreen():AddInputCallback(inputs);
		--ft_count = t_count_check();
	end;
};

t[#t+1] = Def.ActorFrame {
	nav_set();
	InitCommand=function(self)
		local down = self:GetChild('Nav'):GetChild('Down');
		local up = self:GetChild('Nav'):GetChild('Up');
		f_cursorset(down,"Down",T_curIndex,#plus_back);
		f_cursorset(up,"Up",T_curIndex,#plus_back);
	end;
	T_DirectionButtonMessageCommand=function(self)
		local down = self:GetChild('Nav'):GetChild('Down');
		local up = self:GetChild('Nav'):GetChild('Up');
		f_cursorset(down,"Down",T_curIndex,#plus_back);
		f_cursorset(up,"Up",T_curIndex,#plus_back);
	end;
};

t.OnCommand=cmd(stoptweening;playcommand,"Set");
t.ExpandButtonMessageCommand=function(self)
	if key_open == 0 then
		self:playcommand("Set");
	end;
end;

t[#t+1]=c_profname(profile);

return t;