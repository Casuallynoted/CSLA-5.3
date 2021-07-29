--[[
function GroupColorMidTone(c)
	return { c[1], c[2], c[3], "0.8" }
end
]]
--[ja] 20161212 d3d時のメモリリーク問題を修正

local showjacket = GetAdhocPref("WheelGraphics");
local cjacket = THEME:GetPathG("","_MusicWheelItem parts/_fallback_jacket_low");
local cbanner = THEME:GetPathG("","_MusicWheelItem parts/_fallback_banner_low");
if GAMESTATE:GetCurrentStyle() then
local st = GAMESTATE:GetCurrentStyle():GetStepsType();
end;
local sctext = getenv("SortCh");

local ac = 1;

--setenv("sortset","")
local t = Def.ActorFrame{};

local jacket_mirror_init = cmd(rotationy,180;rotationz,180;diffusetopedge,color("1,1,1,0");diffusebottomedge,color("1,1,1,0.2"));

	--back
t[#t+1] = Def.ActorFrame{
	OnCommand=function(self)
		if THEME:GetMetric( Var "LoadingScreen","ScreenType") == 0 then
			(cmd(linear,0.4;playcommand,"Flag"))(self)
		else
			(cmd(playcommand,"Flag"))(self)
		end;
	end;
	FlagCommand=function(self) ac = 0;
	end;
	
	LoadActor(THEME:GetPathG("_MusicWheelItem","parts/jacket_back"))..{
		Name="jacket_back";
		InitCommand=cmd(y,8;shadowlengthy,4);
	};

	--jacket_mirror
	Def.Sprite {
		Name="jacket_mirror";
		InitCommand=jacket_mirror_init;
	};
	Def.Banner {
		Name="jacket_mirror_B";
		InitCommand=jacket_mirror_init;
	};
	
	--jacket
	Def.Sprite {
		Name="jacket";
	};
	Def.Banner {
		Name="jacket_B";
	};

	--lamp
	LoadActor(THEME:GetPathG("_MusicWheelItem","parts/lamp"))..{
		Name="lamp";
		InitCommand=cmd(y,-84;zoomy,1;);
	};
	
	SetMessageCommand=function(self, params)
		local sort_sst = ToEnumShortString(GAMESTATE:GetSortOrder());
		local jacket_back = self:GetChild('jacket_back');
		local jacket_mirror = self:GetChild('jacket_mirror');
		local jacket_mirror_b = self:GetChild('jacket_mirror_B');
		local jacket = self:GetChild('jacket');
		local jacket_b = self:GetChild('jacket_B');
		local lamp = self:GetChild('lamp');

		local path = cbanner;
		local drawindex = 0;
		local items = 0;
		local song;
		local course;
		local groupcolor = color("0.5.0.5.0.5.1");
		local songcolor = color("0.5.0.5.0.5.1");
		drawindex = params.DrawIndex;
		song = params.Song;
		course = params.Course;
		items = THEME:GetMetric( "MusicWheel","NumWheelItems" ) + 2;
		incommandset(self,ac,items,drawindex);
		
		lamp:visible(false);

		local bExtra1 = GAMESTATE:IsExtraStage();
		local bExtra2 = GAMESTATE:IsExtraStage2();
		local extracolor = THEME:GetMetric("MusicWheel","SongRealExtraColor");
		--local brlist;
		--20161126
		if getenv("wheelstop") ~= 2 or (getenv("wheelstop") == 2 and drawindex == math.floor(items / 2)) then
			if song then
				groupcolor = colorcheck(song,"Song");
				jacket_back:diffuse(color("1,1,1,1"));
				jacket_back:diffusetopedge(color("0.5,0.5,0.5,1"));
				jacket_back:diffusebottomedge(color("0.5,0.5,0.5,0.8"));
				
				if bExtra1 or bExtra2 then
					if groupcolor[1]..","..groupcolor[2]..","..groupcolor[3]..","..groupcolor[4] 
					== extracolor[1]..","..extracolor[2]..","..extracolor[3]..","..extracolor[4] then
						jacket_back:diffuse(color("1,0,0,1"));
						jacket_back:diffusetopedge(color("0.8,0.1,0.2,1"));
						jacket_back:diffusebottomedge(color("0.8,0.1,0.2,0.8"));
					end;
				elseif song:IsLong() or song:IsMarathon() then
					jacket_back:diffuse(color("0,1,1,1"));
					jacket_back:diffusetopedge(color("0,1,1,1"));
					jacket_back:diffusebottomedge(color("0,0.7,0.7,0.8"));
				end;

				local songsection = song:GetGroupName();
				if string.find(sctext,"^UserCustom.*") then
					songsection = "csort_"..string.lower(SONGMAN:SongToPreferredSortSectionName(song));
					if getenv("sectioncolorlist")[songsection] then
						groupcolor = color(getenv("sectioncolorlist")[songsection]);
					end;
				end;
				
				--jacket_back:diffusebottomedge(GroupColorMidTone(groupcolor));
				lamp:visible(true);
				local sdirs = split("/",song:GetSongDir());
				local pcheck = true;
				local ss_l = sdirs[2].."/"..sdirs[3];
				local ss_lt = sdirs[3].."/"..sdirs[4];
				if getenv("SortCh") == "SongBranch" then
					if getenv("br_set")[ss_lt] and getenv("br_set")[ss_lt].folder == ss_lt then
						local ls = {"banner","jacket"};
						if showjacket == "Jacket" or showjacket == "BackGround" then
							ls = {"jacket","banner"};
						end;
						if getenv("br_set")[ss_lt][ls[1]] and 
						FILEMAN:DoesFileExist( ss_l.."/"..getenv("br_set")[ss_lt][ls[1]] ) then
							path = ss_l.."/"..getenv("br_set")[ss_lt][ls[1]];
							pcheck = false;
						elseif getenv("br_set")[ss_lt][ls[2]] and 
						FILEMAN:DoesFileExist( ss_l.."/"..getenv("br_set")[ss_lt][ls[2]] ) then
							path = ss_l.."/"..getenv("br_set")[ss_lt][ls[2]];
							pcheck = false;
						end;
						jacket_back:diffuse(color("1,0.65,0,1"));
						jacket_back:diffusetopedge(color("1,0.55,0,1"));
						jacket_back:diffusebottomedge(color("0.7,0.365,0,0.8"));
					end;
				end;
				if pcheck then
					if showjacket == "On" or showjacket == "Default" then
						path = cjacket;
						if song:HasJacket() then		path = song:GetJacketPath();
						elseif song:HasBanner() then	path = song:GetBannerPath();
						elseif song:HasBackground() then	path = song:GetBackgroundPath();
						elseif song:HasCDImage() then	path = song:GetCDImagePath();
						end;
					elseif showjacket == "Jacket" then
						path = cjacket;
						if song:HasJacket() then		path = song:GetJacketPath();
						elseif song:HasBackground() then	path = song:GetBackgroundPath();
						elseif song:HasBanner() then	path = song:GetBannerPath();
						elseif song:HasCDImage() then	path = song:GetCDImagePath();
						end;
					elseif showjacket == "BackGround" then
						path = cjacket;
						if song:HasBackground() then	path = song:GetBackgroundPath();
						elseif song:HasJacket() then	path = song:GetJacketPath();
						elseif song:HasBanner() then	path = song:GetBannerPath();
						elseif song:HasCDImage() then	path = song:GetCDImagePath();
						end;
					elseif showjacket == "Banner" then
						path = cbanner;
						if song:HasBanner() then		path = song:GetBannerPath();
						elseif song:HasJacket() then	path = song:GetJacketPath();
						elseif song:HasBackground() then	path = song:GetBackgroundPath();
						elseif song:HasCDImage() then	path = song:GetCDImagePath();
						end;
					else
						path = cbanner;
					end;
				end;
			elseif course then
				jacket_back:diffuse(color("1,1,1,1"));
				jacket_back:diffusetopedge(color("0.5,0.5,0.5,1"));
				jacket_back:diffusebottomedge(color("0.5,0.5,0.5,0.8"));
			
				lamp:visible(true);
				groupcolor = colorcheck(course,"Course");
				
				if showjacket == "On" or showjacket == "Default" or showjacket == "Jacket" then
					path = cjacket;
					if course:HasBanner() then
						path = course:GetBannerPath();
						if course:HasBackground() then
							path = course:GetBackgroundPath();
						end;
					elseif course:HasBackground() then
						path = course:GetBackgroundPath();
					end
				elseif showjacket == "BackGround" then
					path = cjacket;
					if course:HasBackground() then
						path = course:GetBackgroundPath();
					elseif course:HasBanner() then
						path = course:GetBannerPath();
					end
				elseif showjacket == "Banner" then
					path = cbanner;
					local jset;
					if course:HasBanner() then
						if string.find(string.lower(course:GetBannerPath()),"jacket") then
							path = jset;
						else
							path = course:GetBannerPath();
						end;
					else
						if course:HasBackground() then
							path = course:GetBackgroundPath();
						end;
					end
					if path == jset then
						path = course:GetBannerPath();
					end;
				else
					path = cbanner;
				end;
			end;
		else
			if song then
				if getenv("SortCh") ~= "SongBranch" then
					if song:HasBanner() then
						path = song:GetBannerPath();
					end;
				end;
			elseif course then
				if course:HasBanner() then
					path = course:GetBannerPath();
				end;
			end;
		end;
		lamp:diffuse(groupcolor);
		if string.find(string.lower(PREFSMAN:GetPreference("VideoRenderers")),"^opengl.*") then
			jacket_mirror_b:visible(false);
			jacket_mirror:Load(path);
			jacket_mirror:scaletofit(0,0,174,174);
			jacket_mirror:zoomtoheight(174*0.3);
			jacket_mirror:x(0);
			jacket_mirror:y(113);
			
			jacket_b:visible(false);
			jacket:diffusealpha(0.875);
			jacket:Load(path);
			jacket:scaletofit(0,0,174,174);
			jacket:x(0);
			jacket:y(0);
		else
			jacket_mirror:visible(false);
			jacket_mirror_b:LoadFromCachedBanner(path);
			jacket_mirror_b:scaletofit(0,0,174,174);
			jacket_mirror_b:zoomtoheight(174*0.3);
			jacket_mirror_b:x(0);
			jacket_mirror_b:y(113);
			
			jacket:visible(false);
			jacket_b:diffusealpha(0.875);
			jacket_b:LoadFromCachedBanner(path);
			jacket_b:scaletofit(0,0,174,174);
			jacket_b:x(0);
			jacket_b:y(0);
		end;
	end;

	SectionSetRMessageCommand=function(self)
		local jacket_back = self:GetChild('jacket_back');
		local jacket_mirror = self:GetChild('jacket_mirror');
		local jacket = self:GetChild('jacket');
		local lamp = self:GetChild('lamp');
		(cmd(stoptweening;y,0;zoomy,0;decelerate,0.1;y,8;zoomy,1;))(jacket_back);
		(cmd(stoptweening;y,113-8;linear,0.1;y,113;))(jacket_mirror);
		(cmd(stoptweening;y,-84-8;zoomy,10;accelerate,0.1;y,-84;zoomy,1;))(lamp);
		(cmd(stoptweening;y,8;croptop,1;linear,0.1;y,0;croptop,0;))(jacket);
	end;

--[[
	LoadFont("_shared2")..{
		InitCommand=cmd(maxwidth,146;shadowlength,0;strokecolor,Color("Black"););
		SetMessageCommand=function(self,params)
			self:settext(PREFSMAN:GetPreference("VideoRenderers"));
		end;
	};
]]
};


return t;