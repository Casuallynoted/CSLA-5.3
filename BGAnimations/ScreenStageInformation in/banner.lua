local t = Def.ActorFrame{};

local SongOrCourse = CurSOSet();
local bannerpath = THEME:GetPathG("Common fallback","banner");
if SongOrCourse:HasBanner() then
	bannerpath = SongOrCourse:GetBannerPath();
end;
if getenv("rnd_song") == 1 then
	bannerpath = THEME:GetPathG("Common","fallback banner");
	local brlist = GetGroupParameter(SongOrCourse:GetGroupName(),"BranchList");
	if getenv("exflag") == "csc" then
		brlist = GetGroupParameter(SongOrCourse:GetGroupName(),"Extra1Songs");
	end;
	if b_s_pr(brlist,SongOrCourse,"Banner") and FILEMAN:DoesFileExist( b_s_pr(brlist,SongOrCourse,"Banner") ) then
		bannerpath = b_s_pr(brlist,SongOrCourse,"Banner");
	end;
end;

t[#t+1] = Def.ActorFrame{
	-- song or course banner
	Def.Banner{
		InitCommand=cmd(Center;shadowlength,2;);
		OnCommand=function(self)
			self:Load( bannerpath );
			(cmd(x,SCREEN_RIGHT-210;y,SCREEN_CENTER_Y+60;zoomto,384,110;cropright,1;
			sleep,0.2;linear,0.2;cropright,0;sleep,1;linear,0.075;zoomtoheight,0;
			x,SCREEN_CENTER_X;linear,0.075;zoomtoheight,110;y,SCREEN_CENTER_Y-50;sleep,0.6+0.4;
			linear,0.1;rotationz,45;linear,0.1;addx,100;addy,-100;diffusealpha,0;zoomy,0))(self)
		end;
	};
};

return t;