return Def.ActorFrame{
	Def.Quad{
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_BOTTOM-34;diffuse,color("0.5,0.3,0,0.5");diffusealpha,0;zoomtowidth,0;zoomtoheight,1.5;);
		OnCommand=cmd(sleep,0.2;decelerate,0.30;zoomtowidth,SCREEN_WIDTH;diffusealpha,1);
	};
	Def.Quad{
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_TOP+76;diffuse,color("0.5,0.3,0,0.5");diffusealpha,0;zoomtowidth,0;zoomtoheight,1.5;);
		OnCommand=cmd(sleep,0.2;decelerate,0.30;zoomtowidth,SCREEN_WIDTH;diffusealpha,1);
	};
	LoadActor( THEME:GetPathB("","_ranking/mask") )..{
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_BOTTOM+2;zwrite,true;blend,'BlendMode_NoEffect';vertalign,bottom;);
	};
	Def.Quad{
		InitCommand=cmd(CenterX;y,SCREEN_TOP;valign,0;zoomto,SCREEN_WIDTH,78;zwrite,true;blend,'BlendMode_NoEffect';);
	};

	Def.ActorFrame{
		InitCommand=cmd(x,SCREEN_CENTER_X-180;y,SCREEN_TOP+22;);
		LoadActor(THEME:GetPathB("","_ranking/rankingglow"))..{
			OnCommand=cmd(zoomy,0;sleep,0.6;decelerate,0.1;zoomy,1;diffuseshift;effectcolor1,color("1,1,1,0");effectcolor2,color("1,1,1,0.4");effectperiod,2);
		};
		LoadActor(THEME:GetPathB("","_ranking/rankingtext"))..{
			OnCommand=cmd(zoomy,0;sleep,0.6;decelerate,0.1;zoomy,1;diffuseshift;effectcolor1,color("1,1,1,1");effectcolor2,color("1,1,1,0.3");effectperiod,2);
		};
	};
};