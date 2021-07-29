--[[ScreenSelectMusicExtra background]]

local t = Def.ActorFrame{};

t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(fov,100);
	
	Def.Quad {
		InitCommand=cmd(FullScreen;diffuse,color("0.5,0,0,1");diffuserightedge,color("0,0,0,0"););
	};

--3dmodel
	Def.ActorFrame{
		InitCommand=cmd(fov,170);
		Def.ActorFrame{
			InitCommand=cmd(x,SCREEN_CENTER_X+320;y,SCREEN_CENTER_Y;rotationy,100;zoomx,0;zoomy,6;);
			OnCommand=function(self)
				local screenname = SCREENMAN:GetTopScreen():GetName();
				if THEME:GetMetric(screenname,"OptionScreenType") == 1 then self:playcommand("ASet");
				else self:playcommand("BSet");
				end;
			end;
			ASetCommand=cmd(addx,-10;addy,10;decelerate,0.7;addx,10;addy,-10;rotationy,-2;rotationz,0;zoomx,6;);
			BSetCommand=cmd(addx,-10;addy,10;decelerate,0.7;addx,10;addy,-10;rotationy,0;rotationz,100;zoomx,6;);
			LoadActor( THEME:GetPathB("_shared","models/_l_wall1") )..{
				OnCommand=cmd(diffuse,color("1,0,0,1");queuecommand,"Repeat";);
				RepeatCommand=cmd(spin;effectmagnitude,0,26,0;);
			};
		};
	};
	
	Def.ActorFrame{
		InitCommand=cmd(fov,100);
		Def.ActorFrame{
			InitCommand=cmd(x,SCREEN_LEFT+100;y,SCREEN_CENTER_Y+50;rotationx,-120;rotationz,-200;);
			OnCommand=cmd(addx,-400;zoom,0.2;decelerate,0.8;zoom,1.25;rotationx,0;rotationz,0;addx,400;queuecommand,"Repeat";);
			RepeatCommand=function(self)
				if THEME:GetMetric(SCREENMAN:GetTopScreen():GetName(),"OptionScreenType") == 1 then
					(cmd(spin;effectmagnitude,0,10,0;))(self)
				else
					(cmd(spin;effectmagnitude,0,-10,0;))(self)
				end;
			end;
			LoadActor( THEME:GetPathB("_shared","models/_l_2") )..{
				InitCommand=cmd(blend,'BlendMode_Add';diffusealpha,0.4;);
				OnCommand=cmd(spin;effectmagnitude,-3,20,6;);
			};
		};
	};
};
--under
--over
t[#t+1] = LoadActor( THEME:GetPathB("","_focus_gra/extra_gra") )..{
};

t[#t+1] = LoadActor( THEME:GetPathB("","_background_parts") )..{
};

t[#t+1] = LoadActor( THEME:GetPathB("","underlay") )..{
};

return t;