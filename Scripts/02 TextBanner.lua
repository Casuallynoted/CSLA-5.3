
local titleMaxWidth = 225;
local subtitleMaxWidth = 379;
local artistMaxWidth = 375;

function colorcheck(song,sorc)
	local groupcolor = color("0.5.0.5.0.5.1");
	local sectioncolorlist = getenv("sectioncolorlist");
	if sorc == "Song" then
		if song then
			groupcolor = SONGMAN:GetSongColor(song);
			if sectioncolorlist ~= "" then
				local sdirs = split("/",song:GetSongDir());
				if sectioncolorlist[song:GetGroupName().."/"..sdirs[4]] then
					groupcolor = color(sectioncolorlist[song:GetGroupName().."/"..sdirs[4]]);
				elseif sectioncolorlist[song:GetGroupName()] then
					groupcolor = color(sectioncolorlist[song:GetGroupName()]);
				end;
				if getenv("SortCh") == "SongBranch" and (getenv("br_set")[song:GetGroupName().."/"..sdirs[4]] and 
				getenv("br_set")[song:GetGroupName().."/"..sdirs[4]].folder == song:GetGroupName().."/"..sdirs[4]) then
					groupcolor = color(sectioncolorlist[song:GetGroupName()]);
				end;
			end;
			local bExtra1 = GAMESTATE:IsExtraStage();
			local bExtra2 = GAMESTATE:IsExtraStage2();
			local extracolor = THEME:GetMetric("MusicWheel","SongRealExtraColor");
			if bExtra1 or bExtra2 then
				local songu = string.lower(song:GetSongDir());
				local songDir;
				local exgpc = split("/",songu);
				songDir = exgpc[3].."/"..exgpc[4];
				if bExtra1 then
					if getenv("Ex1crsCheckSelMusic") == songDir then
						groupcolor = extracolor;
					end;
				elseif bExtra2 then
					local style = GAMESTATE:GetCurrentStyle();
					local extrasong, extrasteps;
					if style then
						extrasong, extrasteps = SONGMAN:GetExtraStageInfo(bExtra2, style);
					end;
					local extrasongu = string.lower(extrasong:GetSongDir());
					local extrasongDir;
					local exgpc = split("/",extrasongu)
					extrasongDir = exgpc[3].."/"..exgpc[4];
					if extrasongDir == songDir then
						groupcolor = extracolor;
					end;
				end;
			end;
		end;
	else
		if song then
			groupcolor = color("1,1,1,1");
			if not song:IsAutogen() and sectioncolorlist ~= "" then
				if sectioncolorlist[song:GetGroupName()] then
					groupcolor = color(sectioncolorlist[song:GetGroupName()]);
				end;
			else groupcolor = color("1,0.1,0.4,1");
			end;
		end;
	end;
	return groupcolor
end;

TextBanner.SelMusicTextBannerTitleSet = function(self, params)
	self:settext("");
	self:strokecolor(color("0,0,0,1"));
	local groupcolor = color("0.5.0.5.0.5.1");
	if not GAMESTATE:IsCourseMode() then
		if params then
			songorcourse = params.Song;
		end;
		if songorcourse then
			groupcolor = colorcheck(songorcourse,"Song");
			if params.HasFocus then
				setenv("wheelsectionetccolorfocus",groupcolor);
			end;
			self:diffuse(groupcolor);
			if songorcourse:GetDisplayMainTitle() == "DVNO" then
				self:diffuse("1,0.8,0,1");
			end;
			local ttitle = songorcourse:GetDisplayMainTitle();
			local sdirs = split("/",songorcourse:GetSongDir());
			if getenv("SortCh") == "SongBranch" then
				if getenv("br_set")[sdirs[3].."/"..sdirs[4]] and getenv("br_set")[sdirs[3].."/"..sdirs[4]].title then
					ttitle = getenv("br_set")[sdirs[3].."/"..sdirs[4]].title;
				end;
			end;
			if songorcourse:GetDisplayMainTitle() ~= "" then
				self:settext( ttitle );
				if #ttitle >= 21 then
					if #ttitle > 22 then
						if #ttitle > strchk(21,36,ttitle) then
							self:settext( string.sub(ttitle,1,strchk(21,36,ttitle)).." ..." );
						end;
					end;
				end;
			end;
		end;
	elseif GAMESTATE:IsCourseMode() then
		if params then
			songorcourse = params.Course;
		end;
		if songorcourse then
			groupcolor = colorcheck(songorcourse,"Course");
			if params.HasFocus then
				setenv("wheelsectionetccolorfocus",groupcolor);
			end;
			self:diffuse(groupcolor);
			self:settext(songorcourse:GetDisplayFullTitle());
			if #songorcourse:GetDisplayFullTitle() >= 21 then
				if #songorcourse:GetDisplayFullTitle() > 22 then
					if #songorcourse:GetDisplayFullTitle() > strchk(21,36,songorcourse:GetDisplayFullTitle()) then
						self:settext( string.sub(songorcourse:GetDisplayFullTitle(),1,strchk(21,36,songorcourse:GetDisplayFullTitle())).." ..." );
					end;
				end;
			end;
		end;
	end;
end;

TextBanner.SelMusicTextBannerSubTitleSet = function(self, params)
	local song;
	if params then
		song = params.Song;
	end;
	self:settext("");
	self:strokecolor(color("0,0,0,1"));
	local groupcolor = color("0.5.0.5.0.5.1");
	if not GAMESTATE:IsCourseMode() then
		if song then
			groupcolor = colorcheck(song,"Song");
			self:diffuse(groupcolor);
			if song:GetDisplayMainTitle() == "DVNO" then
				self:diffuse("1,0.8,0,1");
			end;
			if song:GetDisplaySubTitle() ~= "" then
				self:settext( song:GetDisplaySubTitle() );
				if #song:GetDisplaySubTitle() >= 24 then
					if #song:GetDisplaySubTitle() > 25 then
						if #song:GetDisplaySubTitle() > strchk(24,39,song:GetDisplaySubTitle()) then
							self:settext( string.sub(song:GetDisplaySubTitle(),1,strchk(24,39,song:GetDisplaySubTitle())).." ..." );
						end;
					end;
				end;
			end;
		end;
	end;
end;

function TextBannerAfterSet(self,param)
	local Title = self:GetChild("Title");
	local Subtitle = self:GetChild("Subtitle");
	local Artist = self:GetChild("Artist");
	-- no subtitle
	Artist:visible(false);
	if Subtitle:GetText() == "" then
		( cmd(maxwidth,titleMaxWidth/1.44;y,-9;shadowlength,0;) )(Title);
		( cmd(visible,false) )(Subtitle);
			
	-- yes subtitle
	else
		( cmd(maxwidth,titleMaxWidth/1.44;zoomy,0.9;y,-23/2;shadowlength,0;) )(Title);
		( cmd(maxwidth,subtitleMaxWidth/1.44;zoomx,0.575;zoomy,0.565;x,4;y,2;visible,true;shadowlength,0;) )(Subtitle);
	end;
end;

function SelMusicBannerAfterSet(self,param)
	local Title = self:GetChild("Title");
	local Subtitle = self:GetChild("Subtitle");
	local Artist = self:GetChild("Artist");

	-- no subtitle
	if Subtitle:GetText() == "" then
		( cmd(maxwidth,titleMaxWidth;x,15;y,-9;shadowlength,0;strokecolor,Color("Black");) )(Title);
		( cmd(visible,false) )(Subtitle);
		( cmd(zoom,0.575;maxwidth,artistMaxWidth;x,15;y,9;shadowlength,0;strokecolor,Color("Black");) )(Artist);
	-- yes subtitle
	else
		( cmd(maxwidth,titleMaxWidth;zoomy,0.9;x,15;y,-23/2;shadowlength,0;strokecolor,Color("Black");) )(Title);
		( cmd(maxwidth,subtitleMaxWidth;zoomx,0.575;zoomy,0.565;x,22;y,2;visible,true;shadowlength,0;strokecolor,Color("Black");) )(Subtitle);
		( cmd(maxwidth,artistMaxWidth;zoomx,0.6;zoomy,0.565;x,15;y,12;shadowlength,0;strokecolor,Color("Black");) )(Artist);
	end;

	-- hack I stole from AJ 187's moonlight
	if Title:GetText() == "DVNO" then
	-- four capital letters, printed in gold
		local attr = {
			Length = 4;
			Diffuse = color("1,0.8,0,1");
		};
		Title:AddAttribute(0,attr);
	-- details make the girls sweat even more
	end;
end;

function CourseTextBannerAfterSet(self,param)
	local Title = self:GetChild("Title");
	local Subtitle = self:GetChild("Subtitle");
	local Artist = self:GetChild("Artist");

	-- no subtitle
	if Subtitle:GetText() == "" then
		( cmd(maxwidth,titleMaxWidth;x,15;y,-6;shadowlength,0;strokecolor,Color("Black");) )(Title);
		( cmd(visible,false) )(Subtitle);
		( cmd(visible,false) )(Artist);
	-- yes subtitle
	else
		( cmd(maxwidth,titleMaxWidth;zoomy,0.9;x,15;y,-20/2;shadowlength,0;strokecolor,Color("Black");) )(Title);
		( cmd(maxwidth,subtitleMaxWidth;zoomx,0.575;zoomy,0.565;x,15;y,4;visible,true;shadowlength,0;strokecolor,Color("Black");) )(Subtitle);
		( cmd(visible,false) )(Artist);
	end;

	-- and the DVNO hack again
	if Title:GetText() == "DVNO" then
	-- four capital letters, printed in gold
		local attr = {
			Length = 4;
			Diffuse = color("1,0.8,0,1");
		};
		Title:AddAttribute(0,attr);
	-- no need to ask my name to figure out how cool I am -asg
	end;
end;

function EvaluationTextBannerAfterSet(self,param)
	local Title = self:GetChild("Title");
	local Subtitle = self:GetChild("Subtitle");
	local Artist = self:GetChild("Artist");

	-- no subtitle
	if Subtitle:GetText() == "" then
		( cmd(maxwidth,titleMaxWidth;x,15;y,-9;shadowlength,0;strokecolor,Color("Black");) )(Title);
		( cmd(visible,false) )(Subtitle);
		( cmd(zoom,0.575;maxwidth,artistMaxWidth;x,15;y,9;shadowlength,0;strokecolor,Color("Black");) )(Artist);
	-- yes subtitle
	else
		( cmd(maxwidth,titleMaxWidth;zoomy,0.9;x,15;y,-23/2;shadowlength,0;strokecolor,Color("Black");) )(Title);
		( cmd(maxwidth,subtitleMaxWidth;zoomx,0.575;zoomy,0.565;x,22;y,2;visible,true;shadowlength,0;strokecolor,Color("Black");) )(Subtitle);
		( cmd(maxwidth,artistMaxWidth;zoomx,0.6;zoomy,0.565;x,15;y,12;shadowlength,0;strokecolor,Color("Black");) )(Artist);
	end;

	-- hack I stole from AJ 187's moonlight
	if Title:GetText() == "DVNO" then
	-- four capital letters, printed in gold
		local attr = {
			Length = 4;
			Diffuse = color("1,0.8,0,1");
		};
		Title:AddAttribute(0,attr);
	-- details make the girls sweat even more
	end;
end;

function DemoTextBannerAfterSet(self,param)
	local Title = self:GetChild("Title");
	local Subtitle = self:GetChild("Subtitle");
	local Artist = self:GetChild("Artist");

	-- no subtitle
	if Subtitle:GetText() == "" then
		( cmd(maxwidth,titleMaxWidth;x,15;y,-9;shadowlength,0;strokecolor,Color("Black");) )(Title);
		( cmd(visible,false) )(Subtitle);
		( cmd(zoom,0.575;maxwidth,artistMaxWidth;x,15;y,9;shadowlength,0;strokecolor,Color("Black");) )(Artist);
	-- yes subtitle
	else
		( cmd(maxwidth,titleMaxWidth;zoomy,0.9;x,15;y,-23/2;shadowlength,0;strokecolor,Color("Black");) )(Title);
		( cmd(maxwidth,subtitleMaxWidth;zoomx,0.575;zoomy,0.565;x,8;y,2;visible,true;shadowlength,0;strokecolor,Color("Black");) )(Subtitle);
		( cmd(maxwidth,artistMaxWidth;zoomx,0.6;zoomy,0.565;x,15;y,12;shadowlength,0;strokecolor,Color("Black");) )(Artist);
	end;

	-- hack I stole from AJ 187's moonlight
	if Title:GetText() == "DVNO" then
	-- four capital letters, printed in gold
		local attr = {
			Length = 4;
			Diffuse = color("1,0.8,0,1");
		};
		Title:AddAttribute(0,attr);
	-- details make the girls sweat even more
	end;
end;

function GamePlayTextBannerAfterSet(self,param)
	local Title = self:GetChild("Title");
	local Subtitle = self:GetChild("Subtitle");
	local Artist = self:GetChild("Artist");

	-- no subtitle
	if Subtitle:GetText() == "" then
		( cmd(maxwidth,titleMaxWidth;x,15;y,-9;shadowlength,2;strokecolor,Color("Black");) )(Title);
		( cmd(visible,false) )(Subtitle);
		( cmd(zoom,0.575;maxwidth,artistMaxWidth;x,15;y,9;shadowlength,2;strokecolor,Color("Black");) )(Artist);
	-- yes subtitle
	else
		( cmd(maxwidth,titleMaxWidth;zoomy,0.9;x,15;y,-23/2;shadowlength,2;strokecolor,Color("Black");) )(Title);
		( cmd(maxwidth,subtitleMaxWidth;zoomx,0.575;zoomy,0.565;x,22;y,2;visible,true;shadowlength,2;strokecolor,Color("Black");) )(Subtitle);
		( cmd(maxwidth,artistMaxWidth;zoomx,0.6;zoomy,0.565;x,15;y,12;shadowlength,2;strokecolor,Color("Black");) )(Artist);
	end;

	-- hack I stole from AJ 187's moonlight
	if Title:GetText() == "DVNO" then
	-- four capital letters, printed in gold
		local attr = {
			Length = 4;
			Diffuse = color("1,0.8,0,1");
		};
		Title:AddAttribute(0,attr);
	-- details make the girls sweat even more
	end;
end;