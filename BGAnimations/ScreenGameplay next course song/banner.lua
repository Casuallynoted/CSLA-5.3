local t = Def.ActorFrame{
	-- song or course banner
	Def.Banner{
		InitCommand=cmd(Center;shadowlength,2;);
		ChangeCourseSongInMessageCommand=cmd(diffusealpha,0;);
		StartCommand=function(self)
			self:visible(false);
			local songorcourse = SCREENMAN:GetTopScreen():GetNextCourseSong();
			local sbannerpath = songorcourse:GetBannerPath();
			local showjacket = GetAdhocPref("WheelGraphics");
			if showjacket ~= "Off" then
				if songorcourse:HasBanner() and not songorcourse:HasJacket() and not songorcourse:HasCDImage() then
					self:visible(true);
					self:Load( sbannerpath );
				end;
			else
				if songorcourse:HasBanner() then
					self:visible(true);
					self:Load( sbannerpath );
				else
					self:visible(true);
					self:Load( THEME:GetPathG("Common fallback","banner") );
				end;
			end;
			(cmd(x,SCREEN_RIGHT-210;y,SCREEN_CENTER_Y+60;zoomto,384,110;rotationz,0;diffusealpha,1;cropright,1;
			sleep,0.2;linear,0.2;cropright,0;sleep,1;linear,0.075;zoomtoheight,0;
			x,SCREEN_CENTER_X;linear,0.075;zoomtoheight,110;y,SCREEN_CENTER_Y-50;sleep,0.6+0.4;
			linear,0.1;rotationz,45;linear,0.1;addx,100;addy,-100;diffusealpha,0;zoomtoheight,0))(self)
		end;
		FinishCommand=cmd(finishtweening;diffusealpha,0;);
	};
};

return t;