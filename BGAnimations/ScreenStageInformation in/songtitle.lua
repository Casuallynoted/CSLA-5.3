
local t = Def.ActorFrame{};

local coursemode = GAMESTATE:IsCourseMode();
local SongOrCourse = CurSOSet();
local sjacketPath ,sbannerpath ,scdimagepath, cbannerpath;
local SongOrCourseColor;
local brlist;

if coursemode then
	cbannerpath = SongOrCourse:GetBannerPath();
	SongOrCourseColor = getenv("wheelsectionetccolorfocus");
else
	--20170919
	local extracolor = THEME:GetMetric("MusicWheel","SongRealExtraColor");
	sbannerpath = SongOrCourse:GetBannerPath();
	sjacketpath = SongOrCourse:GetJacketPath();
	scdimagepath = SongOrCourse:GetCDImagePath();
	SongOrCourseColor = SONGMAN:GetSongColor(SongOrCourse);
	local bExtra1 = GAMESTATE:IsExtraStage();
	local bExtra2 = GAMESTATE:IsExtraStage2();
	local cflag = 0;
	local sectioncolorlist = getenv("sectioncolorlist");
	local sdirs = split("/",SongOrCourse:GetSongDir());
	if bExtra1 then
		local ssStats = STATSMAN:GetPlayedStageStats(1);
		local sssong = ssStats:GetPlayedSongs()[1];
		if getenv("exflag") ~= "csc" and
		(Ex1crsCheck(SongOrCourse,sssong,bExtra2) == "crs_ex" or Ex1crsCheck(SongOrCourse,sssong,bExtra2) == "n_ex") then
			SongOrCourseColor = extracolor;
			cflag = 1;
		end;
		
		local sectioncolorlist = getenv("sectioncolorlist");
		local sdirs = split("/",SongOrCourse:GetSongDir());
	elseif bExtra2 then
		SongOrCourseColor = extracolor;
		cflag = 1;
	end;
	if getenv("rnd_song") == 1 then
		brlist = GetGroupParameter(SongOrCourse:GetGroupName(),"BranchList");
		if getenv("exflag") == "csc" then
			brlist = GetGroupParameter(SongOrCourse:GetGroupName(),"Extra1Songs");
		end;
	end;
	if brlist and b_s_pr(brlist,SongOrCourse,"Color") then
		SongOrCourseColor = b_s_pr(brlist,SongOrCourse,"Color");
	else
		if cflag == 0 and sectioncolorlist ~= "" then
			if sectioncolorlist[SongOrCourse:GetGroupName().."/"..sdirs[4]] and getenv("rnd_song") ~= 1 then
				SongOrCourseColor = color(sectioncolorlist[SongOrCourse:GetGroupName().."/"..sdirs[4]]);
			elseif sectioncolorlist[SongOrCourse:GetGroupName()] then
				SongOrCourseColor = color(sectioncolorlist[SongOrCourse:GetGroupName()]);
			end;
		end;
	end;
end;

local showjacket = GetAdhocPref("WheelGraphics");

t[#t+1] = Def.ActorFrame{
	LoadFont("","_shared2")..{
		Name="MainorFullTitle1";
		InitCommand=cmd(diffuse,SongOrCourseColor;strokecolor,Color("Black");horizalign,right;
					maxwidth,225*1.7;x,SCREEN_RIGHT-20;zoomx,1;zoomy,0.9;shadowlength,2;);
	};
	LoadFont("","_shared2")..{
		Name="MainorFullTitle2";
		InitCommand=cmd(diffuse,SongOrCourseColor;strokecolor,Color("Black");horizalign,left;
					maxwidth,225*1.7;x,SCREEN_CENTER_X-192;zoomx,1;zoomy,0.9;shadowlength,2;);
	};
	
	LoadFont("","_shared2")..{
		Name="SubTitle1";
		InitCommand=cmd(diffuse,SongOrCourseColor;strokecolor,Color("Black");horizalign,right;
					maxwidth,392*1.7;x,SCREEN_RIGHT-20;zoomx,0.575;zoomy,0.565;shadowlength,2;);
	};
	LoadFont("","_shared2")..{
		Name="SubTitle2";
		InitCommand=cmd(diffuse,SongOrCourseColor;strokecolor,Color("Black");horizalign,left;
					maxwidth,392*1.7;x,SCREEN_CENTER_X-192;zoomx,0.575;zoomy,0.565;shadowlength,2;);
	};
	
	LoadFont("","_shared2")..{
		Name="Artist1";
		InitCommand=cmd(diffuse,SongOrCourseColor;strokecolor,Color("Black");horizalign,right;
					maxwidth,346*1.7;x,SCREEN_RIGHT-20;zoom,0.65;shadowlength,2;);
	};
	LoadFont("","_shared2")..{
		Name="Artist2";
		InitCommand=cmd(diffuse,SongOrCourseColor;strokecolor,Color("Black");horizalign,left;
					maxwidth,346*1.7;x,SCREEN_CENTER_X-192;zoom,0.65;shadowlength,2;);
	};
	OnCommand=function(self)
		local usesubtitle = 0;
		local tTextOne = self:GetChild('MainorFullTitle1');
		local tTextTwo = self:GetChild('MainorFullTitle2');
		local sTextOne = self:GetChild('SubTitle1');
		local sTextTwo = self:GetChild('SubTitle2');
		local aTextOne = self:GetChild('Artist1');
		local aTextTwo = self:GetChild('Artist2');

		tTextOne:visible(true);
		tTextTwo:visible(true);
		sTextOne:visible(true);
		sTextTwo:visible(true);
		aTextOne:visible(true);
		aTextTwo:visible(true);

		sTextOne:y(SCREEN_CENTER_Y-34);
		aTextOne:y(SCREEN_CENTER_Y-20);

		if not coursemode then
			if SongOrCourse:GetDisplaySubTitle() ~= "" then
				usesubtitle = -10;
				tTextOne:settext(SongOrCourse:GetDisplayMainTitle());
				tTextTwo:settext(SongOrCourse:GetDisplayMainTitle());
				sTextOne:settext(SongOrCourse:GetDisplaySubTitle());
				sTextTwo:settext(SongOrCourse:GetDisplaySubTitle());
			else
				tTextOne:settext(SongOrCourse:GetDisplayFullTitle());
				tTextTwo:settext(SongOrCourse:GetDisplayFullTitle());
				sTextOne:visible(false);
				sTextTwo:visible(false);
			end;
			aTextOne:settext(SongOrCourse:GetDisplayArtist());
			aTextTwo:settext(SongOrCourse:GetDisplayArtist());
			--20170919
			if getenv("rnd_song") == 1 then
				if b_s_pr(brlist,SongOrCourse,"Title") then
					tTextOne:settext(b_s_pr(brlist,SongOrCourse,"Title"));
					tTextTwo:settext(b_s_pr(brlist,SongOrCourse,"Title"));
					sTextOne:visible(false);
					sTextTwo:visible(false);
				end;
				aTextOne:visible(false);
				aTextTwo:visible(false);
				if b_s_pr(brlist,SongOrCourse,"Artist") then
					aTextOne:visible(true);
					aTextTwo:visible(true);
					aTextOne:settext(b_s_pr(brlist,SongOrCourse,"Artist"));
					aTextTwo:settext(b_s_pr(brlist,SongOrCourse,"Artist"));
				end;
			end;
			tTextOne:y(SCREEN_CENTER_Y-40+usesubtitle);
			tTextTwo:y(SCREEN_CENTER_Y+30+usesubtitle);
			sTextTwo:y(SCREEN_CENTER_Y+36);
			aTextTwo:y(SCREEN_CENTER_Y+50);
			if showjacket ~= "Off" then
				if not SongOrCourse:HasBanner() then
					tTextTwo:y(SCREEN_BOTTOM-70+usesubtitle);
					sTextTwo:y(SCREEN_BOTTOM-64);
					aTextTwo:y(SCREEN_BOTTOM-50);
				elseif SongOrCourse:HasBanner() and (SongOrCourse:HasJacket() or SongOrCourse:HasCDImage()) then
					tTextTwo:y(SCREEN_BOTTOM-70+usesubtitle);
					sTextTwo:y(SCREEN_BOTTOM-64);
					aTextTwo:y(SCREEN_BOTTOM-50);
				end;
			end;
		else
			sTextOne:visible(false);
			sTextTwo:visible(false);
			aTextOne:visible(false);
			aTextTwo:visible(false);

			tTextOne:settext(SongOrCourse:GetDisplayFullTitle());
			tTextTwo:settext(SongOrCourse:GetDisplayFullTitle());
			tTextOne:y(SCREEN_CENTER_Y-40);
			tTextTwo:y(SCREEN_CENTER_Y+30);
			if SongOrCourse:HasBanner() then
				if string.find(cbannerpath,"jacket") then tTextTwo:y(SCREEN_BOTTOM-70);
				end;
			else tTextTwo:y(SCREEN_BOTTOM-70);
			end;
		end;
		(cmd(zoomx,0;addx,SCREEN_WIDTH*0.5;decelerate,0.2;zoomx,1;
		addx,-SCREEN_WIDTH*0.5;sleep,1.2;accelerate,0.1;addy,-150;diffusealpha,0;))(tTextOne);
		(cmd(addx,-200;diffusealpha,0;sleep,1.4;accelerate,0.1;addx,200;diffusealpha,1;sleep,0.9+0.3;
		linear,0.1;rotationz,-45;linear,0.2;addx,100;addy,-100;diffusealpha,0;zoomy,0))(tTextTwo);
		(cmd(zoomx,0;addx,SCREEN_WIDTH*0.5;decelerate,0.2;zoomx,0.575;
		addx,-SCREEN_WIDTH*0.5;sleep,1.2;accelerate,0.1;addy,-300/2;diffusealpha,0;))(sTextOne);
		(cmd(addx,-200;diffusealpha,0;sleep,1.4;accelerate,0.1;addx,200;diffusealpha,1;sleep,0.9+0.3;
		linear,0.1;rotationz,-45;linear,0.2;addx,100;addy,-100;diffusealpha,0;zoomy,0))(sTextTwo);
		(cmd(zoomx,0;addx,SCREEN_WIDTH*0.5;decelerate,0.2;zoomx,0.65;
		addx,-SCREEN_WIDTH*0.5;sleep,1.2;accelerate,0.1;addy,-300/2;diffusealpha,0))(aTextOne);
		(cmd(addx,-200;diffusealpha,0;sleep,1.4;accelerate,0.1;addx,200;diffusealpha,1;sleep,0.9+0.3;
		linear,0.1;rotationz,-45;linear,0.2;addx,100;addy,-100;diffusealpha,0;zoomy,0))(aTextTwo);
	end;
};

return t;