--[[ScreenSelectCourse background]]

local t = Def.ActorFrame{};

if bUse3dModels() == 'On' then
	t[#t+1] = Def.ActorFrame{
		InitCommand=cmd(fov,170);
		Def.ActorFrame{
			InitCommand=cmd(x,SCREEN_CENTER_X+320;y,SCREEN_CENTER_Y;rotationy,100;zoomx,0;zoomy,6;);
			OnCommand=cmd(addx,-10;addy,10;decelerate,0.7;addx,10;addy,-10;rotationy,0;rotationz,20;zoomx,6;);
			LoadActor( THEME:GetPathB("_shared","models/_l_wall2") )..{
				OnCommand=cmd(diffuse,color("0.8,0.7,0.3,1");queuecommand,"Repeat";);
				RepeatCommand=cmd(spin;effectmagnitude,0,10,0;);
			};
		};
	};
	
	t[#t+1] = Def.ActorFrame{
		InitCommand=cmd(fov,100);
		Def.ActorFrame{
			InitCommand=cmd(x,SCREEN_LEFT+200;y,SCREEN_CENTER_Y+50;rotationx,-120;rotationz,-200;);
			OnCommand=function(self)
				if THEME:GetMetric(SCREENMAN:GetTopScreen():GetName(),"OptionScreenType") == 1 then
					self:x(SCREEN_RIGHT-200);
				else self:x(SCREEN_LEFT+200);
				end;
				(cmd(addx,-400;zoom,0.2;decelerate,0.8;zoom,0.75;rotationx,0;rotationz,0;addx,400;queuecommand,"Repeat";))(self)
			end;
			RepeatCommand=function(self)
				if THEME:GetMetric(SCREENMAN:GetTopScreen():GetName(),"OptionScreenType") == 1 then
					(cmd(spin;effectmagnitude,0,10,0;))(self)
				else
					(cmd(spin;effectmagnitude,0,-10,0;))(self)
				end;
			end;
			LoadActor( THEME:GetPathB("_shared","models/_l_2") )..{
				InitCommand=cmd(blend,'BlendMode_Add';diffusealpha,0.4;);
				OnCommand=cmd(spin;effectmagnitude,12,-16,-24;);
			};
		};
	};
else
	t[#t+1] = LoadActor( THEME:GetPathB("","_movie/_back_1") )..{
		InitCommand=cmd(Center;FullScreen);
	};
	t[#t+1] = Def.Quad {
		InitCommand=cmd(FullScreen;diffuse,color("0.15,0.15,0.15,1");diffuserightedge,color("0.15,0.15,0.15,0.35"););
	};
end;

--over
t[#t+1] = LoadActor( THEME:GetPathB("","_background_parts") )..{
};

t[#t+1] = LoadActor( THEME:GetPathB("","underlay") )..{
};

return t;