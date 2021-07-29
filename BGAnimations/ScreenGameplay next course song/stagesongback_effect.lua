local t = Def.ActorFrame{};

local coursemode = GAMESTATE:IsCourseMode();

t[#t+1] = Def.ActorFrame{
	StartCommand=cmd(fov,100;diffusealpha,1;blend,'BlendMode_Add';);
	FinishCommand=cmd(finishtweening;diffusealpha,0;);

	Def.Quad {
		StartCommand=cmd(FullScreen;diffuse,color("0,0,0,1");diffusealpha,0;linear,1;diffusealpha,1;);
		FinishCommand=cmd(finishtweening;diffusealpha,1;linear,0.1;diffusealpha,0;);
	};
	
	Def.Quad {
		StartCommand=function(self)
			local pm = GAMESTATE:GetPlayMode();
			self:FullScreen();
			self:diffusealpha(1);
			self:diffuse(color("0,0.9,1,0.4"));
			if pm == "PlayMode_Nonstop" then
				self:diffuse(color("0,0.9,1,0.4"));
				self:diffuserightedge(color("0.6,0.6,0,0.2"));
			elseif pm == "PlayMode_Oni" then
				self:diffuse(color("0,0.9,1,0.4"));
				self:diffuserightedge(color("0.4,0,0.6,0.2"));
			elseif pm == "PlayMode_Endless" then
				self:diffuse(color("0,0.9,1,0.4"));
				self:diffuserightedge(color("0.6,0,0,0.2"));
			elseif GAMESTATE:GetCurrentStage() == 'Stage_Extra1' then
				self:diffuse(color("0.5,0,0,0.4"));
				self:diffuserightedge(color("0.3,0,0.1,0.2"));
			elseif GAMESTATE:GetCurrentStage() == 'Stage_Extra2' then
				self:diffuse(color("1,1,1,0.4"));
				self:diffuserightedge(color("0,0,0,0.2"));
			else
				self:diffuserightedge(color("0,0.9,1,0.2"));
			end;
		end;
		FinishCommand=cmd(finishtweening;diffusealpha,1;linear,0.1;diffusealpha,0;);
	};

	Def.ActorFrame{
		StartCommand=cmd(diffusealpha,1;x,SCREEN_LEFT+200;y,SCREEN_CENTER_Y;rotationx,-120;rotationz,-200;
					addx,300;zoom,0.25;decelerate,1;addx,-300;zoom,1;rotationx,0;rotationz,90;sleep,2.7-0.8;addy,100;decelerate,0.2;addy,-100;zoom,5;diffusealpha,0;);
		FinishCommand=cmd(finishtweening;diffusealpha,1;linear,0.1;diffusealpha,0;);
		Def.ActorFrame{
			StartCommand=cmd(diffusealpha,1;spin;effectmagnitude,16,2,-20;);
			FinishCommand=cmd(finishtweening;diffusealpha,1;linear,0.1;diffusealpha,0;);
			LoadActor( THEME:GetPathB("_shared","models/_l_2") )..{
				StartCommand=cmd(addx,200;addx,-200;blend,'BlendMode_Add';diffuse,color("1,1,1,1"););
				FinishCommand=cmd(finishtweening;diffusealpha,1;linear,0.1;diffusealpha,0;);
			};
		};
	};
	Def.Quad{
		StartCommand=cmd(diffuse,color("0,0,0,1");FullScreen;diffusealpha,1;linear,0.5;diffusealpha,0;sleep,3.3-0.8;linear,0.2;diffusealpha,1;);
		FinishCommand=cmd(finishtweening;diffusealpha,1;linear,0.1;diffusealpha,0;);
	};
	-- songorcoursebackground
	Def.Banner{
		StartCommand=function(self)
			local songorcourse = SCREENMAN:GetTopScreen():GetNextCourseSong();
			local backpath = songorcourse:GetBackgroundPath();
			if not songorcourse:HasBackground() then
				backpath = THEME:GetPathG("Common","fallback background");
			end;
			self:Load( backpath );
			(cmd(rotationx,0;rotationz,0;Center;visible,true;diffuse,color("1,1,1,0.65");diffusebottomedge,color("1,1,1,0.1");scaletoclipped,SCREEN_WIDTH,SCREEN_HEIGHT;
			zoomtowidth,SCREEN_WIDTH*1.075;zoomtoheight,SCREEN_HEIGHT*1.075;linear,3.6-0.8;zoomtowidth,SCREEN_WIDTH;zoomtoheight,SCREEN_HEIGHT;
			accelerate,0.15;rotationx,50;rotationz,-30;zoomtowidth,SCREEN_WIDTH*2;zoomtoheight,SCREEN_HEIGHT*2;diffusealpha,0;))(self)
		end;
		FinishCommand=cmd(finishtweening;diffusealpha,0;);
	};
};

return t;
