local t = Def.ActorFrame{};

if bUse3dModels() == 'On' then
	t[#t+1] = Def.ActorFrame{
		InitCommand=cmd(fov,170);
		Def.ActorFrame{
			InitCommand=cmd(x,SCREEN_CENTER_X+320;y,SCREEN_CENTER_Y;rotationy,100;zoomx,0;zoomy,6;);
			OnCommand=function(self)
				self:playcommand("BSet");
			end;
			ASetCommand=cmd(addx,-10;addy,10;decelerate,0.7;addx,10;addy,-10;rotationy,-2;rotationz,0;zoomx,6;);
			BSetCommand=cmd(rotationy,0;rotationz,0;zoomx,6;);
			LoadActor( THEME:GetPathB("_shared","models/_l_wall2") )..{
				OnCommand=cmd(diffuse,color("0.5,0.5,0.5,1");queuecommand,"Repeat";);
				RepeatCommand=cmd(spin;effectmagnitude,0,10,0;);
			};
		};
	};
	
	t[#t+1] = Def.ActorFrame{
		InitCommand=cmd(fov,100);
		Def.ActorFrame{
			InitCommand=cmd(x,SCREEN_RIGHT-400;y,SCREEN_CENTER_Y+50;rotationx,-120;rotationz,-200;);
			OnCommand=cmd(zoom,0.75;rotationx,0;rotationz,0;queuecommand,"Repeat";);
			RepeatCommand=function(self)
				if THEME:GetMetric(SCREENMAN:GetTopScreen():GetName(),"OptionScreenType") == 1 then
					(cmd(spin;effectmagnitude,0,10,0;))(self)
				else
					(cmd(spin;effectmagnitude,0,-10,0;))(self)
				end;
			end;
			LoadActor( THEME:GetPathB("_shared","models/_l_1") )..{
				InitCommand=cmd(blend,'BlendMode_Add';diffusealpha,0.4;);
				OnCommand=cmd(spin;effectmagnitude,-10,10,-10;);
			};
		};
	};
else
	t[#t+1] = LoadActor( THEME:GetPathB("","_movie/_default_back") )..{
		InitCommand=cmd(Center;FullScreen);
	};
	t[#t+1] = Def.Quad {
		InitCommand=cmd(FullScreen;diffuse,color("0.15,0.15,0.15,1");diffuserightedge,color("0.15,0.15,0.15,0.35"););
	};
end;
--under
--etc

return t;