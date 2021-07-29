local t = Def.ActorFrame{};
local pm = GAMESTATE:GetPlayMode()

t[#t+1] = LoadActor(THEME:GetPathB("","_delay"),3);

if pm == 'PlayMode_Rave' then
	t[#t+1] = Def.ActorFrame{
		Def.Quad{
			BeginCommand=cmd(FullScreen;);
			OnCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;diffusealpha,0;sleep,1.6;linear,0.4;
						diffuse,color("0,0,0,0.75");sleep,1.6;linear,0.4;diffuse,color("0,0,0,1"););
		};

		LoadActor("analyse")..{
			InitCommand=cmd(x,SCREEN_RIGHT-194;y,SCREEN_BOTTOM-78;shadowlength,2;);
			OnCommand=cmd(diffuse,color("0,1,1,1");diffusealpha,0;sleep,1.6;linear,0.4;diffusealpha,1;sleep,1.6;linear,0.4;diffusealpha,0;);
		};
		
		LoadActor("line")..{
			InitCommand=cmd(x,SCREEN_RIGHT-88;y,SCREEN_BOTTOM-90;shadowlength,2;);
			OnCommand=cmd(diffuse,color("1,1,0,1");diffusealpha,0;sleep,1.6;linear,0.4;diffusealpha,1;sleep,1.6;linear,0.4;diffusealpha,0;);
		};
	};
else
	t[#t+1] = Def.ActorFrame{
		InitCommand=cmd(fov,100;);
		Def.Quad{
			InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_TOP;vertalign,top;zoomtowidth,SCREEN_WIDTH;);
			OnCommand=cmd(zoomtoheight,0;diffuse,color("0,0.5,0.4,0");fadebottom,0.4;sleep,1.9;
						accelerate,0.5;zoomtoheight,SCREEN_HEIGHT;diffuse,color("0,0.5,0.4,1");fadebottom,0;);
		};
		
		Def.Quad {
			InitCommand=cmd(Center;zoomtowidth,SCREEN_WIDTH;);
			OnCommand=cmd(diffuse,color("0,0,0,1");diffusealpha,0;zoomtoheight,0;sleep,2.1;linear,0.1;diffusealpha,0.8;accelerate,0.1;zoomtoheight,60;);
		};

		LoadActor("cleared")..{
			InitCommand=cmd(Center;);
			OnCommand=cmd(diffusealpha,0;zoomy,30;sleep,2.25;diffusealpha,1;accelerate,0.4;zoomy,1.5;decelerate,0.4;zoom,1;);
		};

		LoadActor("cleared")..{
			InitCommand=cmd(Center;);
			OnCommand=cmd(diffusealpha,0;sleep,2.6;diffusealpha,1;accelerate,0.2;zoom,2;decelerate,0.2;zoom,2.1;diffusealpha,0;);
		};
	};
end;

return t;