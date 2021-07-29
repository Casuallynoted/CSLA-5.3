local t = Def.ActorFrame{}

local function sctextset(csongsectionText,song)
	csongsectionText:stoptweening();
	csongsectionText:settext(song:GetGroupName());
	local sectioncolorlist = getenv("sectioncolorlist");
	local sectiontextlist = getenv("sectionsubnamelist");
	if sectioncolorlist ~= "" then
		if sectioncolorlist[song:GetGroupName()] then
			csongsectionText:diffuse(color(sectioncolorlist[song:GetGroupName()]));
		end;
	end;
	if sectiontextlist ~= "" then
		if sectiontextlist[song:GetGroupName()] then
			csongsectionText:settext(sectiontextlist[song:GetGroupName()]);
		end;
	end;
end;

t[#t+1] = Def.ActorFrame{
	LoadFont("","_shared2")..{
		Name="GroupText";
		InitCommand=cmd(horizalign,center;zoomy,0.9;maxwidth,225;shadowlength,0);
	};
	LoadFont("","_shared2")..{
		Name="RandomExpText";
		InitCommand=cmd(horizalign,center;y,8;maxwidth,379;zoom,0.575;shadowlength,0);
	};
	LoadFont("","_shared2")..{
		Name="TitleText";
		InitCommand=cmd(horizalign,left;zoomy,0.9;maxwidth,225;shadowlength,0);
	};
	LoadFont("","_shared2")..{
		Name="SubTitleText";
		InitCommand=cmd(horizalign,left;zoom,0.575;y,2;maxwidth,379;shadowlength,0);
	};
	LoadFont("","_shared2")..{
		Name="ArtistText";
		InitCommand=cmd(horizalign,left;zoom,0.6;y,20;maxwidth,375;shadowlength,0);
	};
	LoadFont("","_shared2")..{
		Name="ExpandSectionText";
		InitCommand=cmd(horizalign,left;maxwidth,290;zoom,0.6;x,246;y,-174;shadowlength,0);
	};
	LoadFont("","_shared2")..{
		Name="CSongSectionText";
		InitCommand=cmd(horizalign,right;maxwidth,290;zoom,0.6;x,34;y,-27;shadowlength,0);
	};
	SetCommand=function(self)
		--[ja] 20150908 セクションの表示方法を修正
		local expsc = GAMESTATE:GetExpandedSectionName();
		--20160710
		local sort_sst;
		if GAMESTATE:GetSortOrder() then
			sort_sst = ToEnumShortString(GAMESTATE:GetSortOrder());
		end;
		local sectiontext = getenv("wheelnotsectionfocus");
		local sctext = getenv("SortCh");
		self:stoptweening();
		local groupText  = self:GetChild('GroupText');
		local titleText  = self:GetChild('TitleText');
		local subtitleText = self:GetChild('SubTitleText');
		local artistText = self:GetChild('ArtistText');
		local expandsectionText = self:GetChild('ExpandSectionText');
		local csongsectionText = self:GetChild('CSongSectionText');
		local randomexpText  = self:GetChild('RandomExpText');
		local ssStats = STATSMAN:GetPlayedStageStats(1);
		
		local song = GAMESTATE:GetCurrentSong();
		local course = GAMESTATE:GetCurrentCourse();
		local screen = SCREENMAN:GetTopScreen();
		local csctext = THEME:GetString("MusicWheel","CustomItemCSCText");
		local randomtext = THEME:GetString("MusicWheel","CustomItemRandomText");
		titleText:diffuse(color("1,1,1,1"));
		subtitleText:diffuse(color("1,1,1,1"));
		artistText:diffuse(color("1,1,1,1"));
		groupText:diffuse(color("1,1,1,1"));
		groupText:y(-2);
		expandsectionText:diffuse(color("1,1,1,1"));
		csongsectionText:diffuse(color("1,1,1,1"));
		randomexpText:diffuse(color("1,1,1,1"));
		titleText:strokecolor(Color("Black"));
		subtitleText:strokecolor(Color("Black"));
		artistText:strokecolor(Color("Black"));
		groupText:strokecolor(Color("Black"));
		expandsectionText:strokecolor(Color("Black"));
		csongsectionText:strokecolor(Color("Black"));
		randomexpText:strokecolor(Color("Black"));
		if not GAMESTATE:IsCourseMode() then
			local envgroup = getenv("wheelsectiongroup");
			local envsort = getenv("wheelsectionsort");
			local envrandom = getenv("wheelsectionrandom");
			local envcsc = getenv("wheelsectioncsc");
			--[ja] 20160205修正
			local musicwheel;
			if screen then
				musicwheel = SCREENMAN:GetTopScreen():GetChild('MusicWheel');
			end;
		--[[	
			if sort_sst == 'Roulette' then
				self:sleep(1);
				self:playcommand("SSet");
			end;
		]]
		--20180208
			local groupcolor = getenv("wheelnotsectioncolorfocus");
			if groupcolor == "" then
				groupcolor = color("1,1,1,1");
			end;
			local songcolor = getenv("wheelsectionetccolorfocus");
			if groupcolor == "" then
				songcolor = color("1,1,1,1");
			end;
			setenv("rnd_song",0);
			
			local rssettext_t = { {"AllMusic",""},{"CurrentSort",""},{"CurrentSection",""} };
			local rssettext = rssettext_t[1];
			if string.find(sctext,"^UserCustom.*") or string.find(sctext,"^Favorite.*") then
				rssettext_t[2][2] = THEME:GetString("ScreenSort",sctext.."Name");
				if string.find(sctext,"^Favorite.*") then
					local scstr = string.sub(getenv("SortCh"),-1);
					if scstr == "1" or scstr == "2" then
						local pstr = ProfIDSet(scstr);
						rssettext_t[2][2] = THEME:GetString("MusicWheel","CustomItemFavorite"..GetAdhocPref("FavoriteCount",pstr).."Text");
					end;
				end;
				rssettext = rssettext_t[2];
				if expsc ~= "" then
					rssettext_t[3][2] = expsc;
					rssettext = rssettext_t[3];
				end;
			elseif sctext == "SongBranch" then
				rssettext_t[2][2] = THEME:GetString("ScreenSort",sctext.."Name");
				rssettext = rssettext_t[2];
			elseif sort_sst == "Popularity" then
				rssettext_t[2][2] = THEME:GetString("ScreenSort",sctext.."Name");
				rssettext = rssettext_t[2];
			else
				if sort_sst == "Preferred" then
					if string.find(sctext,"^Group$") then
						if expsc ~= "" then
							rssettext_t[3][2] = expsc;
							rssettext = rssettext_t[3];
						end;
					elseif string.find(sctext,"^.*Meter") or string.find(sctext,"^TopGrades.*") then
						rssettext_t[2][2] = THEME:GetString("ScreenSort",sctext.."Name");
						rssettext = rssettext_t[2];
						if expsc ~= "" then
							rssettext_t[3][2] = expsc;
							rssettext = rssettext_t[3];
						end;
					end;
				else
					if expsc ~= "" then
						if expsc ~= "" then
							rssettext_t[3][2] = expsc;
							rssettext = rssettext_t[3];
						end;
					end;
				end;
			end;
			--SCREENMAN:SystemMessage(rssettext[1].." : "..rssettext[2]);
			if song then
				local songu = song:GetSongDir();
				local songDir;
				local exgpc = split("/",songu)
				songDir = exgpc[3].."/"..exgpc[4];
				local bExtra1 = GAMESTATE:IsExtraStage();
				local bExtra2 = GAMESTATE:IsExtraStage2();
				local extracolor = THEME:GetMetric("MusicWheel","SongRealExtraColor");
				titleText:diffuse(songcolor);
				subtitleText:diffuse(songcolor);
				artistText:diffuse(songcolor);
				
				if bExtra1 then
					setenv("Ex1SelMusicSongDir",string.lower(songDir));
				end;
				titleText:settext( song:GetDisplayMainTitle() );
				subtitleText:settext( song:GetDisplaySubTitle() );
				artistText:settext( song:GetDisplayArtist() );
				--20170920
				if getenv("SortCh") == "SongBranch" then
					if getenv("br_set")[songDir] and getenv("br_set")[songDir].folder == songDir then
						setenv("rnd_song",1);
						local brlist = GetGroupParameter(song:GetGroupName(),"BranchList");
						if b_s_pr(brlist,song,"Title") then
							titleText:settext( b_s_pr(brlist,song,"Title") );
						end;
						artistText:settext("");
						if b_s_pr(brlist,song,"Artist") then
							artistText:settext( b_s_pr(brlist,song,"Artist") );
						end;
						subtitleText:settext("");
					end;
				end;
				groupText:settext("");
				randomexpText:settext("");
				expandsectionText:settext(envgroup);
				sctextset(csongsectionText,song);
				if sort_sst == 'Group' then
					expandsectionText:settext("");
				elseif sctext == "Group" then
					expandsectionText:settext("");
				else
					expandsectionText:diffuse(color("0.5,1,0.1,1"));
				end;
				-- no subtitle no artist
				if subtitleText:GetText() == "" and artistText:GetText() == "" then
					if getenv("wheelstop") == 1 then
						(cmd(finishtweening;x,9+3;linear,0.15;x,14+3;y,-2))(titleText);
						(cmd(finishtweening;))(subtitleText);
						(cmd(finishtweening;))(artistText);
					else
						(cmd(stoptweening;x,14+3;y,-2))(titleText);
						(cmd(stoptweening;))(subtitleText);
						(cmd(stoptweening;))(artistText);
					end;
				--20180111
				-- no subtitle
				elseif subtitleText:GetText() == "" then
					if getenv("wheelstop") == 1 then
						(cmd(finishtweening;x,9+3;linear,0.15;x,14+3;y,-9))(titleText);
						(cmd(finishtweening;))(subtitleText);
						(cmd(finishtweening;x,20+3;linear,0.15;x,15+3;zoom,0.6;y,9))(artistText);
					else
						(cmd(stoptweening;x,14+3;y,-9))(titleText);
						(cmd(stoptweening;diffusealpha,0;))(subtitleText);
						(cmd(stoptweening;x,15+3;zoom,0.6;y,9))(artistText);
					end;
				-- yes subtitle
				else
					if getenv("wheelstop") == 1 then
						(cmd(finishtweening;x,9+2;y,-9;linear,0.15;zoomy,0.9;x,14+3;y,-23/2))(titleText);
						(cmd(finishtweening;x,17+3;y,2;zoomx,0.575;zoomy,0.565;diffusealpha,0;linear,0.15;diffusealpha,1;x,22+3))(subtitleText);
						(cmd(finishtweening;x,20+3;y,9;linear,0.15;x,15+3;zoom,0.6;zoomy,0.565;y,12))(artistText);
					else
						(cmd(stoptweening;zoomy,0.9;x,14+3;y,-23/2))(titleText);
						(cmd(stoptweening;zoomx,0.575;zoomy,0.565;diffusealpha,1;x,22+3))(subtitleText);
						(cmd(stoptweening;x,15+3;zoom,0.6;zoomy,0.565;y,12))(artistText);
					end;
				end;
			elseif envgroup ~= "" then
				if envgroup == THEME:GetString("MusicWheel","Empty") then
					groupText:settext(envgroup);
					groupText:diffuse(color("1,0.1,0.4,1"));
				else
					--20180209
					if sort_sst == 'Group' then
						groupText:settext(sectiontext or "");
						groupText:diffuse(groupcolor or Color("White"));
					elseif sctext == "Group" or string.find(sctext,"^UserCustom.*") or string.find(sctext,"^Favorite.*") then
						if sort_sst ~= 'Title' and sort_sst ~= 'Artist' then
							groupText:settext(sectiontext or "");
							groupText:diffuse(groupcolor or Color("White"));
						else
							groupText:settext(envgroup);
							groupText:diffuse(color("0.5,1,0.1,1"));
						end;
					else
						groupText:settext(envgroup);
						groupText:diffuse(color("0.5,1,0.1,1"));
					end;
				end;
				(cmd(finishtweening;x,116+9;linear,0.15;x,116+14;))(groupText);
				titleText:settext("");	
				subtitleText:settext("");
				artistText:settext("");
				expandsectionText:settext("");
				csongsectionText:settext("");
				randomexpText:settext("");
			elseif envrandom and musicwheel and musicwheel:GetSelectedType() == 'WheelItemDataType_Random' then
				groupText:settext(envrandom);
				groupText:diffuse(THEME:GetMetric("MusicWheel","RandomColor"));
				(cmd(finishtweening;x,116+9;linear,0.15;x,116+14;))(groupText);
				titleText:settext("");	
				subtitleText:settext("");
				artistText:settext("");
				expandsectionText:settext("");
				csongsectionText:settext("");
				randomexpText:settext("");
			elseif envcsc and musicwheel and musicwheel:GetSelectedType() == 'WheelItemDataType_Custom' then
				local sectiontextlist = getenv("sectionsubnamelist");
				csongsectionText:settext("");
				if envcsc == csctext then
					groupText:settext(""); 
					subtitleText:settext("");
					expandsectionText:settext("");
					randomexpText:settext("");
					titleText:settext(envcsc);
					titleText:diffuse(THEME:GetMetric("MusicWheel","CSCColor"));
					artistText:diffuse(THEME:GetMetric("MusicWheel","CSCColor"));
					if ssStats then
						artistText:settext( ssStats:GetPlayedSongs()[1]:GetGroupName() );
						if sectiontextlist ~= "" then
							if sectiontextlist[ssStats:GetPlayedSongs()[1]:GetGroupName()] then
								artistText:settext(sectiontextlist[ssStats:GetPlayedSongs()[1]:GetGroupName()]);
							end;
						end;
					else
						artistText:settext("Beginner's Package");	
					end;
					if getenv("wheelstop") == 1 then
						(cmd(finishtweening;x,9+3;linear,0.15;x,14+3;y,-9))(titleText);
						(cmd(finishtweening;x,20+3;linear,0.15;x,15+3;zoom,0.575;y,9))(artistText);
					else
						(cmd(stoptweening;x,14+3;y,-9))(titleText);
						(cmd(stoptweening;zoom,0.575;y,9))(artistText);
					end;
				elseif envcsc == randomtext then
					groupText:settext(randomtext);
					groupText:y(-8);
					groupText:diffuse(THEME:GetMetric("MusicWheel","RandomColor"));
					(cmd(finishtweening;x,116+9;linear,0.15;x,116+14;))(groupText);
				--20170822
					local r_sec_t = rssettext[2];
					if sectiontextlist ~= "" then
						if sectiontextlist[rssettext[2]] then
							r_sec_t = sectiontextlist[rssettext[2]];
						end;
					end;
					randomexpText:settext( string.format( THEME:GetString("MusicWheel",rssettext[1]),r_sec_t ) );
					randomexpText:diffuse(THEME:GetMetric("MusicWheel","RandomColor"));
					(cmd(finishtweening;x,121+14;linear,0.15;x,121+9;))(randomexpText);
					titleText:settext("");	
					subtitleText:settext("");
					artistText:settext("");
					expandsectionText:settext("");
				--20180208
				elseif envcsc == THEME:GetString("MusicWheel","CustomItemFavorite"..string.sub(envcsc,-1).."Text") then
					local favoritetext = THEME:GetString("MusicWheel","CustomItemFavorite"..string.sub(envcsc,-1).."Text");
					groupText:settext(favoritetext);
					groupText:diffuse(f_color_set[tonumber(string.sub(envcsc,-1))]);
					(cmd(finishtweening;x,116+9;linear,0.15;x,116+14;))(groupText);
					randomexpText:settext("");
					titleText:settext("");	
					subtitleText:settext("");
					artistText:settext("");
					expandsectionText:settext("");
				end;
			elseif sort_sst == 'ModeMenu' or (screen and screen:GetName() == "ScreenSort") then
				local sortmenu = envsort;
				groupText:settext(envsort);
				groupText:diffuse(GetSortColor(sortmenu));
				if getenv("wheelstop") == 1 then
					(cmd(finishtweening;x,116+9;linear,0.15;x,116+14;))(groupText);
				else
					(cmd(stoptweening;x,116+14;))(groupText);
				end;
				titleText:settext("");	
				subtitleText:settext("");
				artistText:settext("");
				expandsectionText:settext("");
				csongsectionText:settext("");
				randomexpText:settext("");
			else
				groupText:settext("");
				titleText:settext("");	
				subtitleText:settext("");
				artistText:settext("");
				expandsectionText:settext("");
				csongsectionText:settext("");
				randomexpText:settext("");
			end;
		elseif GAMESTATE:IsCourseMode() then
			local envgroup = getenv("wheelsectiongroup");
			if envgroup == THEME:GetString("MusicWheel","Empty") then
				groupText:settext(envgroup);
				groupText:diffuse(color("1,0.1,0.4,1"));
				(cmd(finishtweening;x,116+9;linear,0.15;x,116+14;))(groupText);
			else
				if course then
					groupText:diffuse(getenv("wheelsectionetccolorfocus"));
					groupText:settext(course:GetDisplayFullTitle());
					(cmd(finishtweening;x,116+9;linear,0.15;x,116+14;))(groupText);
				else
					groupText:settext("");
					titleText:settext("");
					subtitleText:settext("");
					artistText:settext("");
					expandsectionText:settext("");
					randomexpText:settext("");
				end;
			end;
		else
			groupText:settext("");
			titleText:settext("");
			subtitleText:settext("");
			artistText:settext("");
			randomexpText:settext("");
			return;
		end;
	end;
	OnCommand=cmd(playcommand,"Set");
	OffCommand=cmd(stoptweening;);
	UpdateCommand=cmd(playcommand,"Set";);
	SectionSetFMessageCommand=cmd(playcommand,"Set";);
	SSetCommand=function(self)
		--GAMESTATE:SetCurrentSong(SONGMAN:GetRandomSong());
		SCREENMAN:GetTopScreen():PostScreenMessage('SM_GoToNextScreen',0);
	end;
};

t.CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
t.CurrentCourseChangedMessageCommand=cmd(playcommand,"Set");

return t;