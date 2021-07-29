local t = Def.ActorFrame{};

local pm = GAMESTATE:GetPlayMode();
local cStage = GAMESTATE:GetCurrentStage();
local iStage = cstage_set(cStage);

t[#t+1] = Def.Sprite {
	InitCommand=cmd(horizalign,right;shadowlength,2;);
	OnCommand=cmd(playcommand,"CurrentSongChangedMessage";);
	CurrentSongChangedMessageCommand=function(self)
		self:stoptweening();
		cStage = cstage_imagse_set(iStage);
		if cStage then
			self:Load( THEME:GetPathG("","_stages/_selmusic "..cStage) );
		end;
	end;
};

return t;
