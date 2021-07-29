local t = Def.ActorFrame{};

local SongOrCourse = CurSOSet();
local backpath = THEME:GetPathG("Common","fallback background");
if SongOrCourse:HasBackground() then
	backpath = SongOrCourse:GetBackgroundPath();
end;
if getenv("rnd_song") == 1 then
	backpath = THEME:GetPathG("Common","fallback background");
	local brlist = GetGroupParameter(SongOrCourse:GetGroupName(),"BranchList");
	if getenv("exflag") == "csc" then
		brlist = GetGroupParameter(SongOrCourse:GetGroupName(),"Extra1Songs");
	end;
	if b_s_pr(brlist,SongOrCourse,"Background") and FILEMAN:DoesFileExist( b_s_pr(brlist,SongOrCourse,"Background") ) then
		backpath = b_s_pr(brlist,SongOrCourse,"Background");
	end;
end;

t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(fov,100;blend,'BlendMode_Add';);

	Def.Quad {
		InitCommand=function(self)
			local pm = GAMESTATE:GetPlayMode();
			self:FullScreen();
			self:diffuse(color("0,0.9,1,0.4"));
			if getenv("exflag") == "csc" then
				self:diffuse(color("0,0.5,0.5,0.4"));
				self:diffuserightedge(color("0,0.3,0.1,0.2"));
			elseif pm == "PlayMode_Nonstop" then
				self:diffuse(color("0,0.9,1,0.4"));
				self:diffuserightedge(color("0.6,0.6,0,0.2"));
			elseif pm == "PlayMode_Oni" then
				self:diffuse(color("0,0.9,1,0.4"));
				self:diffuserightedge(color("0.4,0,0.6,0.2"));
			elseif pm == "PlayMode_Endless" then
				self:diffuse(color("0,0.9,1,0.4"));
				self:diffuserightedge(color("0.6,0,0,0.2"));
			elseif GAMESTATE:GetCurrentStage() == 'Stage_Extra1' then
				self:diffuse(color("1,0,0,0.4"));
				self:diffuserightedge(color("0.5,0,0,0.7"));
			elseif GAMESTATE:GetCurrentStage() == 'Stage_Extra2' then
				self:diffuse(color("0,0.1,0.4,0.4"));
				self:diffuserightedge(color("0,0.6,1,1"));
			else
				self:diffuserightedge(color("0,0.9,1,0.2"));
			end;
		end;
	};

	Def.ActorFrame{
		Condition=getenv("exflag") == "csc" or getenv("omsflag") == 1;
		InitCommand=cmd(fov,100;x,SCREEN_CENTER_X+300;y,SCREEN_CENTER_Y;rotationx,-10;rotationy,-10;rotationz,10;);
		LoadActor(THEME:GetPathB("ScreenSelectMusicCS","background/cs_o"))..{
			OnCommand=function(self)
				(cmd(zoom,3;fadeleft,0.2;faderight,0.2;diffusealpha,0;decelerate,0.8;zoom,1;diffuse,color("0,0.8,0.9,1");sleep,2.3-0.8;accelerate,0.1;zoom,8;diffusealpha,0;))(self)
			end;
		};
	};

	Def.ActorFrame{
		InitCommand=cmd(x,SCREEN_LEFT+200;y,SCREEN_CENTER_Y+100;rotationx,-120;rotationz,-200;);
		OnCommand=cmd(addx,300;zoom,0.25;decelerate,1;addx,-300;zoom,1;rotationx,0;rotationz,90;sleep,2.7-0.8;decelerate,0.2;addy,-100;zoom,5;diffusealpha,0;);
		Def.ActorFrame{
			OnCommand=cmd(spin;effectmagnitude,16,2,-20;);

			LoadActor( THEME:GetPathB("_shared","models/_l_2") )..{
				InitCommand=function(self)
					if getenv("exflag") == "csc" or getenv("omsflag") == 1 then
						(cmd(x,-100;diffuse,color("0,1,1,1")))(self)
					elseif GAMESTATE:GetCurrentStage() == 'Stage_Extra1' then
						(cmd(x,-100;diffuse,color("0,0,0,1")))(self)
					else (cmd(blend,'BlendMode_Add';x,-100;diffuse,color("1,1,1,1")))(self)
					end;
				end;
			};
		};
	};
	Def.Quad{
		OnCommand=cmd(diffuse,color("0,0,0,1");FullScreen;diffusealpha,1;linear,0.5;diffusealpha,0;sleep,3.3-0.8;linear,0.2;diffusealpha,1;);
	};
	-- SongOrCoursebackground
	Def.Banner{
		InitCommand=cmd(Center;visible,true);
		OnCommand=function(self)
			self:Load( backpath );
			(cmd(diffuse,color("1,1,1,0.65");diffusebottomedge,color("1,1,1,0.1");scaletoclipped,SCREEN_WIDTH,SCREEN_HEIGHT;
			zoomtowidth,SCREEN_WIDTH*1.075;zoomtoheight,SCREEN_HEIGHT*1.075;linear,3.6-0.8;zoomtowidth,SCREEN_WIDTH;zoomtoheight,SCREEN_HEIGHT;
			accelerate,0.15;rotationx,50;rotationz,-30;zoomtowidth,SCREEN_WIDTH*2;zoomtoheight,SCREEN_HEIGHT*2;diffusealpha,0;))(self)
		end;
	};
};

return t;
