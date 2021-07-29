local t = Def.ActorFrame{}

local jacketPath;
local cdimagepath;
local bannerpath = THEME:GetPathG("Common fallback","banner");
local SongOrCourse = CurSOSet();
if SongOrCourse:HasBanner() then
	bannerpath = SongOrCourse:GetBannerPath();
end;
if not coursemode then
	if SongOrCourse:HasJacket() then
		jacketpath = SongOrCourse:GetJacketPath();
	end;
	if SongOrCourse:HasCDImage() then
		cdimagepath = SongOrCourse:GetCDImagePath()
	end;
end;
if getenv("rnd_song") == 1 then
	jacketpath = THEME:GetPathG("Common","fallback jacket");
	bannerpath = THEME:GetPathG("Common","fallback banner");
	local brlist = GetGroupParameter(SongOrCourse:GetGroupName(),"BranchList");
	if getenv("exflag") == "csc" then
		brlist = GetGroupParameter(SongOrCourse:GetGroupName(),"Extra1Songs");
	end;
	if b_s_pr(brlist,SongOrCourse,"Jacket") and FILEMAN:DoesFileExist( b_s_pr(brlist,SongOrCourse,"Jacket") ) then
		jacketpath = b_s_pr(brlist,SongOrCourse,"Jacket");
	end;
	if b_s_pr(brlist,SongOrCourse,"Banner") and FILEMAN:DoesFileExist( b_s_pr(brlist,SongOrCourse,"Banner") ) then
		bannerpath = b_s_pr(brlist,SongOrCourse,"Banner");
	end;
end;
if not jacketpath then
	if cdimagepath then
		jacketpath = cdimagepath;
	else jacketpath = THEME:GetPathG("Common fallback","jacket");
	end;
end;

t[#t+1] = Def.ActorFrame{
	Def.Banner{
		InitCommand=cmd(Center;shadowlength,2;);
		OnCommand=function(self)
			self:Load( jacketpath );
			(cmd(diffusealpha,0;zoomto,384,110;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+10;
			sleep,1.4;zoomtowidth,300;linear,0.15;y,SCREEN_CENTER_Y-60;diffusealpha,1;zoomtoheight,300;sleep,1;
			linear,0.1;rotationz,45;linear,0.1;addx,100;addy,-100;diffusealpha,0;zoomy,0))(self)
		end;
	};

	Def.Banner{
		InitCommand=cmd(Center;shadowlength,2;);
		OnCommand=function(self)
			self:Load( bannerpath );
			(cmd(x,SCREEN_RIGHT-210;y,SCREEN_CENTER_Y+60;zoomto,384,110;cropright,1;
			sleep,0.2;linear,0.2;cropright,0;sleep,1;linear,0.075;
			x,SCREEN_CENTER_X;zoomtowidth,300;linear,0.15;zoomtoheight,300;y,SCREEN_CENTER_Y+10;diffusealpha,0))(self)
		end;
	};
};

return t;