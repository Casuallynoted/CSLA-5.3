local t = Def.ActorFrame{};
local numPlayers = GAMESTATE:GetNumPlayersEnabled();
local setaddx_l_2 = 0;
local setx_l_2 = SCREEN_CENTER_X;
if numPlayers == 1 then
	if GAMESTATE:IsHumanPlayer(PLAYER_1) then
		setaddx_l_2 = 200;
		setx_l_2 = SCREEN_CENTER_X * 0.55
	else
		setaddx_l_2 = -200;
		setx_l_2 = SCREEN_CENTER_X * 1.55;
	end;
end;

if bUse3dModels() == 'On' then
	t[#t+1] = Def.ActorFrame{
		InitCommand=cmd(fov,170);
		Def.ActorFrame{
			InitCommand=cmd(x,SCREEN_CENTER_X+320;y,SCREEN_CENTER_Y;rotationy,-100;zoomx,0;zoomy,6;);
			OnCommand=cmd(addx,-10;addy,10;decelerate,0.7;addx,10;addy,-10;rotationy,0;rotationz,-100;zoomx,6;);
			LoadActor( THEME:GetPathB("_shared","models/_l_wall2") )..{
				OnCommand=cmd(diffuse,color("0.5,0.5,0.5,1");linear,0.75;diffuse,color("0.2,0.2,0.2,1");queuecommand,"Repeat";);
				RepeatCommand=cmd(spin;effectmagnitude,0,4,0;);
			};
		};
	};
	t[#t+1] = Def.ActorFrame{
		InitCommand=cmd(fov,100);
		Def.ActorFrame{
			InitCommand=cmd(y,SCREEN_CENTER_Y+50;rotationx,-120;rotationz,-200;queuecommand,"Set";);
			SetCommand=cmd(x,setx_l_2+setaddx_l_2;addy,100;zoom,0;decelerate,0.7;x,setx_l_2;addy,-100;zoom,0.4;queuecommand,"Repeat";);
			RepeatCommand=cmd(spin;effectmagnitude,0,-10,0;);
			LoadActor( THEME:GetPathB("_shared","models/_l_2") )..{
				InitCommand=cmd(blend,'BlendMode_Add';diffusealpha,0.4;);
				OnCommand=cmd(spin;effectmagnitude,-3,4,6;);
			};
		};
	};
else
	t[#t+1] = LoadActor( THEME:GetPathB("","_movie/_back_1") )..{
		InitCommand=cmd(Center;FullScreen);
	};
end;

--over
t[#t+1] = LoadActor( THEME:GetPathB("","_background_parts") )..{
};

t[#t+1] = LoadActor( THEME:GetPathB("","underlay") )..{
};

t[#t+1] = LoadActor( THEME:GetPathB("","eva_back") )..{
};

return t;