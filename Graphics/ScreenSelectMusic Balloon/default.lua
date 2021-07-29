
local t = Def.ActorFrame{
	Def.Sprite{
		OnCommand=function(self)
			local topScreenName = SCREENMAN:GetTopScreen():GetName();
			if THEME:GetMetric(topScreenName,"ScreenType") == 2 then (cmd(cropbottom,0;diffusealpha,1;))(self)
			else (cmd(cropbottom,1;sleep,0.3;decelerate,0.2;cropbottom,0;diffusealpha,1;))(self)
			end;
		end;
		ShowCommand=cmd(visible,true;cropbottom,1;sleep,0.1;decelerate,0.2;cropbottom,0;diffusealpha,1;);
		HideCommand=cmd(visible,true;stoptweening;linear,0.1;diffusealpha,0;);
		NoSetCommand=cmd(visible,false;);
		SetCommand=function(self)
			if getenv("wheelstop") == 1 then
				self:stoptweening();
				local song = GAMESTATE:GetCurrentSong();
				if song then
					if song:IsLong() or song:IsMarathon() then
						self:playcommand("Show");
						if song:IsLong() then
							self:Load(THEME:GetPathG("ScreenSelectMusic","Balloon/_long"));
						elseif song:IsMarathon() then
							self:Load(THEME:GetPathG("ScreenSelectMusic","Balloon/_marathon"));
						end;
					else self:playcommand("Hide");	
					end;
				else self:playcommand("Hide");
				end;
			else self:playcommand("NoSet");
			end;
		end;
		CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
	};
};

return t;