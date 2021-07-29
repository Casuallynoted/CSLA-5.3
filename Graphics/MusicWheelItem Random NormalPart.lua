local ac = 1;
local drawindex = 0;

local t = Def.ActorFrame{
	OnCommand=function(self)
		if THEME:GetMetric( Var "LoadingScreen","ScreenType") == 0 then
			(cmd(linear,0.4;playcommand,"Flag"))(self)
		else
			(cmd(playcommand,"Flag"))(self)
		end;
	end;
	FlagCommand=function(self) ac = 0;
	end;
	SetMessageCommand=function(self, params)
		local items = THEME:GetMetric( "MusicWheel","NumWheelItems" ) + 2;
if params.DrawIndex then
		drawindex = params.DrawIndex;
		incommandset(self,ac,items,drawindex);
end;
	end;
	LoadActor(THEME:GetPathG("_MusicWheelItem","parts/random_jacket"))..{
		InitCommand=cmd(diffusealpha,1;y,111;rotationy,180;rotationz,180;zoomtowidth,178;zoomtoheight,178/4;
					diffusetopedge,color("0,0,0,0");diffusebottomedge,color("0.4,0.4,0.4,0.7"););
	};

	LoadActor(THEME:GetPathG("_MusicWheelItem","parts/random_jacket"))..{
		InitCommand=cmd(diffusealpha,1;zoomtowidth,178;zoomtoheight,178;);
	};
	
	LoadActor(THEME:GetPathG("","bannercover1"))..{
		InitCommand=cmd(vertalign,bottom;y,SCREEN_CENTER_Y-220;zoomtowidth,178;zoomtoheight,40;diffusealpha,0.8;blend,'BlendMode_Add';);
	};

	
	LoadActor(THEME:GetPathG("_MusicWheelItem","parts/que"))..{
		InitCommand=cmd(zoomto,160,28;fadeleft,0.15;faderight,0.15;texcoordvelocity,-0.25,0;diffuse,color("1,0.1,0.4,1"));
	};
	
	LoadFont("_shared2")..{
		InitCommand=cmd(zoomy,0.9;maxwidth,225;y,90;shadowlength,0;diffuse,color("1,0.1,0.4,1");strokecolor,Color("Black"););
		SetMessageCommand=function(self,params)
			self:visible(false);
			local randomtext = THEME:GetString("MusicWheel","Random")
			if params.HasFocus then
				self:visible(true);
				setenv("wheelsectionrandom",randomtext);
			end;
		end;
	};
};

return t;