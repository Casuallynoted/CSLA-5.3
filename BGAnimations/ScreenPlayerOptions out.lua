local pm = GAMESTATE:GetPlayMode();

if PREFSMAN:GetPreference( "ShowSongOptions" ) ~= "Maybe_Ask" or 
GAMESTATE:IsExtraStage() or GAMESTATE:IsExtraStage2() then
-- GAMESTATE:IsExtraStage() or GAMESTATE:IsExtraStage2() or pm == 'PlayMode_Oni' then
	return LoadActor( THEME:GetPathB("","other fade out/_i fade out to options") )..{
	};
end;

local t = Def.ActorFrame {};
if IsNetConnected() then
	t[#t+1] = LoadActor( THEME:GetPathB("","other fade out/_net options") )..{
	};
	return t;
end;

--20160424
local pm = GAMESTATE:GetPlayMode();

t[#t+1] = LoadActor( THEME:GetPathB("","other fade out/_i fade out to options") )..{
};

--20160625
--if pm == 'PlayMode_Regular' or pm == 'PlayMode_Nonstop' then
	t[#t+1] = Def.ActorFrame {	
		Def.ActorFrame {
			InitCommand=cmd(CenterY;);
			Def.Quad{
				InitCommand=cmd(horizalign,left;x,SCREEN_LEFT;y,-30;visible,false;pause;diffuse,color("0,0.9,0.8,0");zoomto,SCREEN_WIDTH,2;);
				AskForGoToOptionsCommand=cmd(visible,true;stoptweening;diffusealpha,0;sleep,0.19;linear,0.1;diffusealpha,1;linear,1.3;zoomtowidth,0;);
				GoToOptionsCommand=cmd(stoptweening;linear,0.1;zoomtowidth,0;);
			};
			
			Def.Quad{
				InitCommand=cmd(horizalign,right;x,SCREEN_RIGHT;y,30;visible,false;pause;diffuse,color("0,0.9,0.8,0");zoomto,SCREEN_WIDTH,2;);
				AskForGoToOptionsCommand=cmd(visible,true;stoptweening;diffusealpha,0;sleep,0.19;linear,0.1;diffusealpha,1;linear,1.3;zoomtowidth,0;);
				GoToOptionsCommand=cmd(stoptweening;linear,0.1;zoomtowidth,0;);
			};

			LoadFont( "_Shared2" ) .. {
				InitCommand=cmd(strokecolor,Color("Black");settext,THEME:GetString("ScreenSelectMusic","Press Start For Other Options");CenterX;y,-4;zoom,0.8;zoomy,0;visible,false);
				AskForGoToOptionsCommand=cmd(visible,true;diffusealpha,0;linear,0.15;zoomy,0.8;diffusealpha,1;sleep,1.35;linear,0.15;diffusealpha,0;zoomy,0;);
				GoToOptionsCommand=cmd(visible,false);
			};
			LoadFont( "_Shared2" ) .. {
				InitCommand=cmd(strokecolor,Color("Black");uppercase,true;settext,THEME:GetString("ScreenSelectMusic","Entering Options");CenterX;y,-4;zoom,0.8;visible,false);
				AskForGoToOptionsCommand=cmd(visible,false;);
				GoToOptionsCommand=cmd(visible,true;stoptweening;sleep,0.2;linear,0.2;zoomy,0;);
			};
		};
	};
--end;

return t;

