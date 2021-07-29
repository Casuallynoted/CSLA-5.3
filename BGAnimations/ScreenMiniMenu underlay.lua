local t = Def.ActorFrame {
	InitCommand=cmd(Center;);

	Def.Quad{
		BeginCommand=function(self)
			self:finishtweening();
			self:zoomtowidth(SCREEN_WIDTH);
			self:zoomtoheight(SCREEN_HEIGHT);
			self:diffuse(color("0,0,0,0"));
			self:linear(0.1);
			self:diffuse(color("0.025,0.21,0.2,0.85"));
		end;
	};
}

return t;
