
local t = Def.ActorFrame {
};

t[#t+1] = Def.ActorFrame {
	Def.ActorFrame {
		InitCommand=cmd(CenterX;y,SCREEN_CENTER_Y+4+20;);
		--p1
		Def.Quad {
			InitCommand=cmd(x,-233;zoomtowidth,152;zoomtoheight,364;diffuse,color("0,0,0,0.6"););
		};
		Def.Quad {
			InitCommand=cmd(x,-120;zoomtowidth,74;zoomtoheight,364;diffuse,color("0.2,0,0,0.6"););
		};
		
		--p2
		Def.Quad {
			InitCommand=cmd(x,157;zoomtowidth,152;zoomtoheight,364;diffuse,color("0,0,0,0.6"););
		};
		Def.Quad {
			InitCommand=cmd(x,270;zoomtowidth,74;zoomtoheight,364;diffuse,color("0.2,0,0,0.6"););
		};
		
		Def.Quad {
			InitCommand=cmd(x,-1;zoomtowidth,164;zoomtoheight,364;diffuse,color("0,0.4,0.4,0.6"););
		};
	};
};

t[#t+1] = Def.ActorFrame {
	Def.Quad{
		Name="TopMask";
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_TOP+62+20;zoomto,SCREEN_WIDTH,66+20;valign,1;MaskSource);
	};

	Def.Quad{
		Name="BottomMask";
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_BOTTOM-54+20;zoomto,SCREEN_WIDTH,60;valign,0;MaskSource);
	};

	Def.ActorProxy{
		OnCommand=function(self)
			local cScroller = SCREENMAN:GetTopScreen():GetChild('LineScroller');
			self:visible(true);
			self:MaskDest();
			self:SetTarget(cScroller);
			self:y(92);
		end;
	};
};

t[#t+1] = Def.ActorFrame {
	Def.ActorFrame {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_TOP+71;);

		--p1
		LoadFont("Common Normal") .. {
			InitCommand=function(self)
				self:settextf( ScreenString("%s slots"),"P1" );
				(cmd(x,-200;zoom,0.85;diffuse,PlayerColor(PLAYER_1);strokecolor,color("0,0,0,1");))(self)
			end;
		};

		--p2
		LoadFont("Common Normal") .. {
			InitCommand=function(self)
				self:settextf( ScreenString("%s slots"),"P2" );
				(cmd(x,200;zoom,0.85;diffuse,PlayerColor(PLAYER_2);strokecolor,color("0,0,0,1");))(self)
			end;
		};
	};
};

return t