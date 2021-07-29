local x = Def.ActorFrame{
	LoadFont("_shared2")..{
		InitCommand=function(self)
			self:settext(Screen.String("Saving Profiles"));
			(cmd(horizalign,right;x,SCREEN_RIGHT-30;y,SCREEN_BOTTOM-30;diffuse,color("1,0.6,0,1");strokecolor,Color("Black");diffusealpha,0;zoom,0.65))(self);
		end;
		OnCommand=cmd(linear,0.15;diffusealpha,1);
		OffCommand=cmd(linear,0.15;diffusealpha,0);
	};
};

x[#x+1] = Def.Actor {
	BeginCommand=function(self)
		if SCREENMAN:GetTopScreen():HaveProfileToSave() then self:sleep(0.1); end;
		self:queuecommand("Load");
	end;
	LoadCommand=function() SCREENMAN:GetTopScreen():Continue(); end;
};

return x;