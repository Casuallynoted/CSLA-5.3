--[[ScreenSelectMusic background]]

local t = Def.ActorFrame{};
local screen = SCREENMAN:GetTopScreen();

if GAMESTATE:GetCurrentStage() == 'Stage_Extra1' then
	t[#t+1] = LoadActor( THEME:GetPathB("ScreenSelectMusicExtra","background") )..{
	};
elseif GAMESTATE:GetCurrentStage() == 'Stage_Extra2' then
	t[#t+1] = LoadActor( THEME:GetPathB("ScreenSelectMusicExtra2","background") )..{
	};
else
	if bUse3dModels() == 'On' then
		t[#t+1] = Def.ActorFrame{
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
			--[ja] 特定のタイミングで表示視点が変わるコマンド(重い)
			--[[
				OnCommand=cmd(addx,-10;addy,10;decelerate,1;addx,10;addy,-10;rotationy,0;rotationz,-100;zoomx,8;zoomy,6;queuecommand,"Repeat2";);
				Repeat1Command=cmd(sleep,6;rotationx,0;rotationy,0;rotationz,-100;queuecommand,"Repeat2";);
				Repeat2Command=cmd(sleep,4;rotationx,50;rotationy,0;rotationz,20;queuecommand,"Repeat3";);
				Repeat3Command=cmd(sleep,5;rotationx,0;rotationy,-40;rotationz,0;queuecommand,"Repeat4";);
				Repeat4Command=cmd(sleep,5;rotationx,120;rotationy,-50;rotationz,0;queuecommand,"Repeat1";);
			]]
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
				OnCommand=cmd(addx,-400;zoom,0.2;decelerate,0.8;zoom,0.75;rotationx,0;rotationz,0;addx,400;queuecommand,"Repeat";);
				RepeatCommand=function(self)
					local screen = SCREENMAN:GetTopScreen();
					if screen then
						if THEME:GetMetric(screen:GetName(),"OptionScreenType") == 1 then
							(cmd(spin;effectmagnitude,0,10,0;))(self)
						else (cmd(spin;effectmagnitude,0,-10,0;))(self)
						end;
					else (cmd(spin;effectmagnitude,0,-10,0;))(self)
					end;
				end;
				LoadActor( THEME:GetPathB("_shared","models/_l_1") )..{
					InitCommand=cmd(blend,'BlendMode_Add';diffusealpha,0.4;);
					OnCommand=cmd(spin;effectmagnitude,-3,4,6;);
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
--[[
	t[#t+1] = Def.Quad {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-60;zoomtowidth,200;zoomtoheight,300;diffuse,color("0,1,1,0.7"););
	};
]]
	--over
	t[#t+1] = LoadActor( THEME:GetPathB("","_background_parts") )..{
	};

	t[#t+1] = LoadActor( THEME:GetPathB("","underlay") )..{
	};
end;

return t;