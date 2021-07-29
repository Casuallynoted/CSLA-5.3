local t = Def.ActorFrame{};

local SongOrCourse = CurSOSet();
local coursemode = GAMESTATE:IsCourseMode();
local bannerpath = THEME:GetPathG("Common","fallback jacket");
local jacketpath;
local cdimagepath;
if not coursemode then
	if SongOrCourse:HasJacket() then
		jacketpath = SongOrCourse:GetJacketPath();
	end;
	if SongOrCourse:HasCDImage() then
		cdimagepath = SongOrCourse:GetCDImagePath()
	end;
end;
if getenv("rnd_song") == 1 then
	local brlist = GetGroupParameter(SongOrCourse:GetGroupName(),"BranchList");
	if getenv("exflag") == "csc" then
		brlist = GetGroupParameter(SongOrCourse:GetGroupName(),"Extra1Songs");
	end;
	if b_s_pr(brlist,SongOrCourse,"Jacket") and FILEMAN:DoesFileExist( b_s_pr(brlist,SongOrCourse,"Jacket") ) then
		jacketpath = b_s_pr(brlist,SongOrCourse,"Jacket");
	end;
end;
if coursemode then
	if SongOrCourse:HasBanner() then
		bannerpath = SongOrCourse:GetBannerPath();
	end;
	if bannerpath then
		jacketpath = bannerpath;
	else jacketpath = THEME:GetPathG("Common fallback","jacket");
	end;
else
	if not jacketpath then
		if cdimagepath then
			jacketpath = cdimagepath;
		else jacketpath = THEME:GetPathG("Common fallback","jacket");
		end;
	end;
end;

t[#t+1] = Def.ActorFrame{
	-- song or course banner
	Def.Banner{
		InitCommand=cmd(Center;shadowlength,2;);
		OnCommand=function(self)
			self:Load( jacketpath );
			(cmd(x,SCREEN_RIGHT-146;y,SCREEN_CENTER_Y+60;zoomto,256,256;cropright,1;
			sleep,0.2;linear,0.2;cropright,0;sleep,1;linear,0.075;zoomtoheight,0;
			x,SCREEN_CENTER_X;zoomtowidth,300;linear,0.075;zoomtoheight,300;y,SCREEN_CENTER_Y-60;zoomtoheight,300;sleep,0.6+0.4;
			linear,0.1;rotationz,45;linear,0.1;addx,100;addy,-100;diffusealpha,0;zoomy,0))(self)
		end;
	};
};

return t;