--[ja] 20150724修正
local t = Def.ActorFrame{
	CancelCommand=function(self)
		SOUND:PlayOnce(THEME:GetPathS("Common","coin"));
		self:sleep(0.4);
	end;
	
	Def.Quad{
		CancelCommand=cmd(Center;diffuse,color("0,1,1,0.4");zoomtowidth,SCREEN_WIDTH;zoomtoheight,0;fadetop,0.2;fadebottom,0.2;
				decelerate,0.2;fadetop,0;fadebottom,0;zoomtoheight,SCREEN_HEIGHT;);
	};

	Def.Quad{
		CancelCommand=cmd(diffuse,color("0,0,0,0");x,SCREEN_CENTER_X;y,SCREEN_TOP;vertalign,top;zoomtowidth,SCREEN_WIDTH;zoomtoheight,0;
				accelerate,0.2;diffuse,color("0,0,0,1");zoomtowidth,SCREEN_WIDTH;zoomtoheight,SCREEN_HEIGHT/2+10);
	};

	Def.Quad{
		CancelCommand=cmd(diffuse,color("0,0,0,0");x,SCREEN_CENTER_X;y,SCREEN_BOTTOM;vertalign,bottom;zoomtowidth,SCREEN_WIDTH;zoomtoheight,0;
				accelerate,0.2;diffuse,color("0,0,0,1");zoomtowidth,SCREEN_WIDTH;zoomtoheight,SCREEN_HEIGHT/2+10);
	};
};

return t;