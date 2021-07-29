local t = Def.ActorFrame{}

t[#t+1] = Def.ActorFrame{
	-- song or course banner
	Def.Banner{
		InitCommand=cmd(Center;shadowlength,2;);
		StartCommand=function(self)
			self:visible(false);
			local songorcourse = SCREENMAN:GetTopScreen():GetNextCourseSong();
			local sjacketpath = songorcourse:GetJacketPath();
			local scdimagepath = songorcourse:GetCDImagePath();
			if songorcourse:HasBanner() and (songorcourse:HasJacket() or songorcourse:HasCDImage()) then
				self:visible(true);
				if songorcourse:HasJacket() then self:Load( sjacketpath );
				else self:Load( scdimagepath );
				end;
				(cmd(diffusealpha,0;zoomto,384,110;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+10;
				sleep,1.4;zoomtowidth,300;linear,0.15;y,SCREEN_CENTER_Y-60;rotationz,0;diffusealpha,1;zoomtoheight,300;sleep,1;
				linear,0.1;rotationz,45;linear,0.1;addx,100;addy,-100;diffusealpha,0;zoomtoheight,0))(self)
			end;
		end;
		FinishCommand=cmd(finishtweening;diffusealpha,0;);
	};

	Def.Banner{
		InitCommand=cmd(Center;shadowlength,2;);
		StartCommand=function(self)
			self:visible(false);
			local songorcourse = SCREENMAN:GetTopScreen():GetNextCourseSong();
			local sbannerpath = songorcourse:GetBannerPath();
			if songorcourse:HasBanner() and (songorcourse:HasJacket() or songorcourse:HasCDImage()) then
				self:visible(true);
				self:Load( sbannerpath );
				(cmd(x,SCREEN_RIGHT-210;y,SCREEN_CENTER_Y+60;zoomto,384,110;diffusealpha,1;cropright,1;
				sleep,0.2;linear,0.2;cropright,0;sleep,1;linear,0.075;
				x,SCREEN_CENTER_X;zoomtowidth,300;linear,0.15;zoomtoheight,300;y,SCREEN_CENTER_Y+10;diffusealpha,0))(self)
			end;
		end;
		FinishCommand=cmd(finishtweening;diffusealpha,0;);
	};
};

return t;