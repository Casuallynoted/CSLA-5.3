--[[ScreenCompany overlay]]
local t = Def.ActorFrame{};

--20160420
t[#t+1] = netstatecheck();

t[#t+1] = Def.Quad{
	InitCommand=cmd(FullScreen;draworder,-100;diffuse,color("0,0.2,0.2,1"););
};

t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(fov,170);
	Def.ActorFrame{
		InitCommand=cmd(x,SCREEN_CENTER_X+320;y,SCREEN_CENTER_Y;rotationy,30;rotationy,-2;rotationz,20;zoomx,6;zoomy,6;);
		LoadActor( THEME:GetPathB("_shared","models/_l_wall1") )..{
			InitCommand=cmd(diffuse,color("0.25,0.25,0.25,1");queuecommand,"Repeat";);
			RepeatCommand=cmd(spin;effectmagnitude,0,-3,0;);
		};
	};
};

t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(fov,100);
	Def.ActorFrame{
		InitCommand=function(self)
			self:x(SCREEN_LEFT+100);
			if CAspect() > 1.77778 then
				self:x(SCREEN_LEFT+400);
			end;
			(cmd(y,SCREEN_CENTER_Y+50;zoom,2;rotationx,0;rotationz,0;queuecommand,"Repeat";))(self)
		end;
		RepeatCommand=cmd(spin;effectmagnitude,0,-5,-6;);
		LoadActor( THEME:GetPathB("_shared","models/_l_2") )..{
			InitCommand=cmd(blend,'BlendMode_Add';diffusealpha,0.4;);
		};
	};
};

t[#t+1] = LoadActor("warning")..{
	InitCommand=cmd(x,SCREEN_RIGHT-270-10;y,SCREEN_CENTER_Y;zoom,1;shadowlength,3;);
	OnCommand=cmd(diffusealpha,0;linear,0.2;diffusealpha,1;sleep,6.7;linear,0.05;zoomtoheight,2;sleep,0.05;linear,0.05;zoomtowidth,2100;linear,0.2;diffusealpha,0;);
};

if FILEMAN:DoesFileExist( "Themes/_fallback/BGAnimations/ScreenInit background/ssc (doubleres).png") then
	t[#t+1] = Def.ActorFrame{
		Def.Quad{
			InitCommand=cmd(x,SCREEN_RIGHT-128-20;y,SCREEN_CENTER_Y-60;zoomto,256,96;shadowlength,3;);
			OnCommand=cmd(diffusealpha,0;sleep,7.1;linear,0.2;diffusealpha,1;sleep,4.8;linear,0.05;zoomtoheight,2;sleep,0.05;linear,0.05;zoomtowidth,2100;linear,0.2;diffusealpha,0;);
		};		
		LoadActor("../../../_fallback/BGAnimations/ScreenInit background/ssc")..{
			InitCommand=cmd(x,SCREEN_RIGHT-128-20;y,SCREEN_CENTER_Y-60;zoom,1;);
			OnCommand=cmd(diffusealpha,0;sleep,7.1;linear,0.2;diffusealpha,1;sleep,4.8;linear,0.05;zoomtoheight,2;sleep,0.05;linear,0.05;zoomtowidth,2100;linear,0.2;diffusealpha,0;);
		};
	};
end;
	
t[#t+1] = Def.ActorFrame{
	LoadActor("stepmania")..{
		InitCommand=cmd(x,SCREEN_RIGHT-245-10;y,SCREEN_CENTER_Y+60;zoom,1;shadowlength,3;);
		OnCommand=cmd(diffusealpha,0;sleep,7.1;linear,0.2;diffusealpha,1;sleep,4.8;linear,0.05;zoomtoheight,2;sleep,0.05;linear,0.05;zoomtowidth,2100;linear,0.2;diffusealpha,0;);
	};

	LoadActor("cstylepro")..{
		InitCommand=cmd(x,SCREEN_RIGHT-270-10;y,SCREEN_CENTER_Y-66;zoom,1;shadowlength,3;);
		OnCommand=cmd(diffusealpha,0;sleep,12.2;linear,0.2;diffusealpha,1;sleep,4.8;linear,0.05;zoomtoheight,2;sleep,0.05;linear,0.05;zoomtowidth,2100;linear,0.2;diffusealpha,0;);
	};
	LoadActor("cc")..{
		InitCommand=cmd(x,SCREEN_RIGHT-285-10;y,SCREEN_CENTER_Y+66;zoom,1;shadowlength,3;);
		OnCommand=cmd(diffusealpha,0;sleep,12.2;linear,0.2;diffusealpha,1;sleep,4.8;linear,0.05;zoomtoheight,2;sleep,0.05;linear,0.05;zoomtowidth,2100;linear,0.2;diffusealpha,0;);
	};
};

return t;
