return LoadFont("_shared4") .. {
	Text = PREFSMAN:GetPreference('SongsPerPlay');
	BeginCommand=function(self)
		if GAMESTATE:IsEventMode() or IsNetConnected() then
			self:settextf( Screen.String("EventMode") );
		elseif PREFSMAN:GetPreference('SongsPerPlay') == 1 then
			self:settextf( Screen.String("1Stage"), PREFSMAN:GetPreference('SongsPerPlay') );
		elseif PREFSMAN:GetPreference('SongsPerPlay') > 1 then
			self:settextf( Screen.String("MaxStages"), PREFSMAN:GetPreference('SongsPerPlay') );
		end
	end
};