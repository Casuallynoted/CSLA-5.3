setenv("playmusictextentry",false);
--Trace("BarAlpha: "..THEME:GetMetric("NoteField","Bar8thAlpha"));
local t = Def.ActorFrame{
	InitCommand=cmd(fov,100);
	
	Def.Quad{
		OnCommand=cmd(FullScreen;draworder,-100;diffuse,color("0.2,0.3,0.6,0.2"););
	};

	-- song background
	Def.Sprite{
		InitCommand=cmd(Center;);
		OnCommand=function(self)
			if not GAMESTATE:IsCourseMode() then
				local song = GAMESTATE:GetCurrentSong();
				if song then
					self:diffusealpha(0.45);
					local Path = THEME:GetPathG("Common fallback","background");
					if song:HasBackground() then
						Path = song:GetBackgroundPath();
					end;
					self:Load( Path );
					self:scale_or_crop_background();
				end;
			end;
		end;
	};

	Def.ActorFrame{
		InitCommand=function(self)
			if CAspect() >= 1.6 then
				self:visible(true);
			else
				self:visible(false);
			end;
		end;

		Def.Quad{
			InitCommand=cmd(diffuse,color("0,0,0,0.75");horizalign,left;x,SCREEN_LEFT;y,SCREEN_CENTER_Y;zoomtowidth,144;zoomtoheight,SCREEN_HEIGHT;);
		};
	
		Def.Quad{
			InitCommand=cmd(diffuse,color("0,0,0,0.75");horizalign,right;x,SCREEN_RIGHT;y,SCREEN_CENTER_Y;zoomtowidth,144;zoomtoheight,SCREEN_HEIGHT;);
		};
	};

	Def.Banner{
		InitCommand=cmd(x,SCREEN_LEFT+72;y,SCREEN_CENTER_Y+180;diffusealpha,0;);
		OnCommand=function(self)
			if not GAMESTATE:IsCourseMode() then
				local song = GAMESTATE:GetCurrentSong();
				if song then
					self:diffusealpha(0.45);
					local Path = THEME:GetPathG("Common fallback","banner");
					if song:HasBanner() then
						Path = song:GetBannerPath();
					end;
					self:Load( Path );
				end;
			end;
			(cmd(zoomtowidth,128*6;zoomtoheight,2;linear,0.2;zoomtowidth,128;diffusealpha,1;linear,0.3;zoomtoheight,40;))(self)
		end;
	};
};

return t;