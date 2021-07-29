local function radarSet(self,player)
	local SongOrCourse = nil;
	local StepsOrTrail = nil;
	if player then
		self:visible(true);
		if getenv("wheelstop") == 1 then
			SongOrCourse = CurSOSet();
			StepsOrTrail = CurSTSet(player);
			if SongOrCourse and StepsOrTrail then
				if getenv("rnd_song") == 0 then
					self:SetFromRadarValues(player, StepsOrTrail:GetRadarValues(player));
				else self:SetFromValues( player, {0,0,0,0,0} )
				end;
			else self:SetFromValues( player, {0,0,0,0,0} )
			end;
		else self:SetFromValues( player, {0,0,0,0,0} )
		end;
	else
		self:visible(false);
		self:SetFromValues( player, {0,0,0,0,0} );
	end;
end

local t = Def.ActorFrame {
	Name="Radar";
	InitCommand=cmd(x,SCREEN_CENTER_X-320+152;y,330);
	Def.GrooveRadar {
		OnCommand=function(self)
			if getenv("ReloadAnimFlag") == 1 then self:playcommand("NoAnim");
			else self:playcommand("Anim");
			end;
			for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
				radarSet(self, pn);
			end;
		end;
		AnimCommand=cmd(zoom,0;sleep,0.583;decelerate,0.150;zoom,1);
		NoAnimCommand=cmd(zoom,1);
		CurrentSongChangedMessageCommand=function(self)
			for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
				radarSet(self, pn);
			end;
		end;
		CurrentStepsP1ChangedMessageCommand=function(self) radarSet(self, PLAYER_1); end;
		CurrentStepsP2ChangedMessageCommand=function(self) radarSet(self, PLAYER_2); end;
		CurrentTrailP1ChangedMessageCommand=function(self) radarSet(self, PLAYER_1); end;
		CurrentTrailP2ChangedMessageCommand=function(self) radarSet(self, PLAYER_2); end;
	};
};

return t;