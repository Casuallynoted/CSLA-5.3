local t = Def.ActorFrame{};

local bvisible = false;
local bwidth = 60;
if CAspect() >= 2.66666 then
	bvisible = true;
	bwidth = SCREEN_WIDTH/4.5;
elseif CAspect() >= 1.77778 then
	bvisible = true;
end;

t[#t+1] = Def.ActorFrame{
	Def.Quad{
		InitCommand=cmd(visible,bvisible;horizalign,left;x,SCREEN_LEFT;y,SCREEN_CENTER_Y;zoomtowidth,bwidth;zoomtoheight,SCREEN_HEIGHT;faderight,0.2);
		OnCommand=cmd(diffuse,color("1,0,0,1");sleep,0.5;decelerate,0.45;cropright,1;);
	};
	
	Def.Quad{
		InitCommand=cmd(visible,bvisible;horizalign,right;x,SCREEN_RIGHT;y,SCREEN_CENTER_Y;zoomtowidth,bwidth;zoomtoheight,SCREEN_HEIGHT;fadeleft,0.2);
		OnCommand=cmd(diffuse,color("1,0,0,1");sleep,0.5;decelerate,0.45;cropleft,1;);
	};
};

t[#t+1] = Def.ActorFrame{
	LoadActor(THEME:GetPathB("","_delay"),2);

	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X-387;y,SCREEN_TOP-38+32;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.45;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};	
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X-387;y,SCREEN_TOP+64-3+32;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.4;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X-387;y,SCREEN_TOP+166-6+32;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.45;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X-387;y,SCREEN_TOP+268-9+32;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.45;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X-387;y,SCREEN_TOP+370-12+32;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.4;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X-387;y,SCREEN_TOP+472-15+32;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.4;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};
	

	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X-301;y,SCREEN_TOP+51-8;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.4;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X-301;y,SCREEN_TOP+153-3-8;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.4;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X-301;y,SCREEN_TOP+255-6-8;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.35;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X-301;y,SCREEN_TOP+357-9-8;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.35;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X-301;y,SCREEN_TOP+459-12-8;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.4;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};
	
	
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X-215;y,SCREEN_TOP-38+32;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.3;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};	
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X-215;y,SCREEN_TOP+64-3+32;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.2;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X-215;y,SCREEN_TOP+166-6+32;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.3;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X-215;y,SCREEN_TOP+268-9+32;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.25;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X-215;y,SCREEN_TOP+370-12+32;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.25;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X-215;y,SCREEN_TOP+472-15+32;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.3;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};
	

	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X-129;y,SCREEN_TOP+51-8;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.2;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X-129;y,SCREEN_TOP+153-3-8;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.25;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X-129;y,SCREEN_TOP+255-6-8;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.25;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X-129;y,SCREEN_TOP+357-9-8;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.2;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X-129;y,SCREEN_TOP+459-12-8;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.3;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};

	
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X-43;y,SCREEN_TOP-38+32;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.2;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};	
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X-43;y,SCREEN_TOP+64-3+32;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.15;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X-43;y,SCREEN_TOP+166-6+32;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.1;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X-43;y,SCREEN_TOP+268-9+32;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X-43;y,SCREEN_TOP+370-12+32;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.15;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X-43;y,SCREEN_TOP+472-15+32;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.2;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};
	
	
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X+43;y,SCREEN_TOP+51-8;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.2;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X+43;y,SCREEN_TOP+153-3-8;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X+43;y,SCREEN_TOP+255-6-8;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.1;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X+43;y,SCREEN_TOP+357-9-8;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.2;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X+43;y,SCREEN_TOP+459-12-8;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.15;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};


	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X+129;y,SCREEN_TOP-38+32;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.2;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};	
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X+129;y,SCREEN_TOP+64-3+32;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.2;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X+129;y,SCREEN_TOP+166-6+32;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.25;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X+129;y,SCREEN_TOP+268-9+32;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.3;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X+129;y,SCREEN_TOP+370-12+32;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.25;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X+129;y,SCREEN_TOP+472-15+32;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.3;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};
	
	
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X+215;y,SCREEN_TOP+51-8;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.3;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X+215;y,SCREEN_TOP+153-3-8;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.4;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X+215;y,SCREEN_TOP+255-6-8;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.35;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X+215;y,SCREEN_TOP+357-9-8;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.35;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X+215;y,SCREEN_TOP+459-12-8;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.35;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};


	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X+301;y,SCREEN_TOP-38+32;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.35;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};	
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X+301;y,SCREEN_TOP+64-3+32;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.4;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X+301;y,SCREEN_TOP+166-6+32;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.35;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X+301;y,SCREEN_TOP+268-9+32;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.4;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X+301;y,SCREEN_TOP+370-12+32;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.4;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X+301;y,SCREEN_TOP+472-15+32;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.4;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};
	
	
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X+387;y,SCREEN_TOP+51-8;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.45;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X+387;y,SCREEN_TOP+153-3-8;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.4;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X+387;y,SCREEN_TOP+255-6-8;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.45;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X+387;y,SCREEN_TOP+357-9-8;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.45;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};
	LoadActor(THEME:GetPathB("","hexwar"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X+387;y,SCREEN_TOP+459-12-8;zoom,1);
		OnCommand=cmd(diffusealpha,0;sleep,0.15;diffusealpha,1;sleep,0.4;rotationz,-40;linear,0.1;rotationz,0;diffusealpha,0;);
	};
	
	Def.Quad{
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoomtowidth,SCREEN_WIDTH;zoomtoheight,SCREEN_HEIGHT;);
		OnCommand=cmd(diffuse,color("1,0,0,1");sleep,0.2;diffusealpha,0;);
	};
	
	LoadActor(THEME:GetPathB("","warback"))..{
		InitCommand=cmd(Center;);
		OnCommand=cmd(diffusealpha,1;sleep,0.05;diffusealpha,0;sleep,0.05;diffusealpha,1;sleep,0.05;diffusealpha,0;);
	};
};

return t;