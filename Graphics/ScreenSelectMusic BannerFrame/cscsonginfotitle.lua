local t = Def.ActorFrame{
	LoadFont("","_shared2")..{
		Name="TitleText";
		InitCommand=cmd(horizalign,left;zoomy,0.9;maxwidth,225;shadowlength,0);
	};
	LoadFont("","_shared2")..{
		Name="SubTitleText";
		InitCommand=cmd(horizalign,left;zoom,0.575;y,14;maxwidth,379;shadowlength,0);
	};
	LoadFont("","_shared2")..{
		Name="ArtistText";
		InitCommand=cmd(horizalign,left;zoom,0.6;y,20;maxwidth,375;shadowlength,0);
	};
	CSCSongSetMessageCommand=function(self,params)
		self:stoptweening();
		local titleText  = self:GetChild('TitleText');
		local subtitleText = self:GetChild('SubTitleText');
		local artistText = self:GetChild('ArtistText');
		
		local song = params.Song;
		local songtitle = params.STitle;
		local songartist = params.SArtist;
		local songcolor = params.SColor;
		local screen = SCREENMAN:GetTopScreen();
		local sdirs;
		if not GAMESTATE:IsCourseMode() then
			if song ~= nil and song ~= "" then
				local groupcolor = color("0.5.0.5.0.5.1");
				local sectioncolorlist = getenv("sectioncolorlist");
				sdirs = split("/",song:GetSongDir());
				groupcolor = SONGMAN:GetSongColor(song);
				--20170919
				if sectioncolorlist ~= "" then
					if sectioncolorlist[song:GetGroupName().."/"..sdirs[4]] and getenv("rnd_song") ~= 1 then
						groupcolor = color(sectioncolorlist[song:GetGroupName().."/"..sdirs[4]]);
					elseif sectioncolorlist[song:GetGroupName()] then
						groupcolor = color(sectioncolorlist[song:GetGroupName()]);
					end;
				end;
				
				titleText:diffuse(groupcolor);
				subtitleText:diffuse(groupcolor);
				artistText:diffuse(groupcolor);
				
				if songtitle then titleText:settext( songtitle );
				else titleText:settext( song:GetDisplayMainTitle() );
				end;
				if getenv("rnd_song") == 1 then
					subtitleText:settext("");
					artistText:settext("");
					if songartist then
						artistText:settext( songartist );
					end;
				else
					subtitleText:settext( song:GetDisplaySubTitle() );
					if songartist then artistText:settext( songartist );
					else artistText:settext( song:GetDisplayArtist() );
					end;
				end;

				titleText:strokecolor(Color("Black"));
				subtitleText:strokecolor(Color("Black"));
				artistText:strokecolor(Color("Black"));
				-- no subtitle no artist
				if subtitleText:GetText() == "" and artistText:GetText() == "" then
					(cmd(finishtweening;x,9+3;linear,0.15;x,14+3;y,-2))(titleText);
					(cmd(finishtweening;))(subtitleText);
					(cmd(finishtweening;))(artistText);
				-- no subtitle
				elseif subtitleText:GetText() == "" then
					(cmd(finishtweening;x,9+3;linear,0.15;x,14+3;y,-9))(titleText);
					(cmd(finishtweening;))(subtitleText);
					(cmd(finishtweening;x,20+3;linear,0.15;x,15+3;zoom,0.575;y,9))(artistText);
				-- yes subtitle
				else
					(cmd(finishtweening;x,9+2;y,-9;linear,0.15;zoomy,0.9;x,14+3;y,-23/2))(titleText);
					(cmd(finishtweening;x,17+3;y,2;zoomx,0.575;zoomy,0.565;diffusealpha,0;linear,0.15;diffusealpha,1;x,22+3))(subtitleText);
					(cmd(finishtweening;x,20+3;y,9;linear,0.15;x,15+3;zoom,0.6;zoomy,0.565;y,12))(artistText);
				end;
			else
				titleText:settext("");	
				subtitleText:settext("");
				artistText:settext("");
			end;
		else
			titleText:settext("");	
			subtitleText:settext("");
			artistText:settext("");	
		end;
	end;
	OnCommand=cmd(playcommand,"Set";);
	OffCommand=cmd(stoptweening;);
};

return t;