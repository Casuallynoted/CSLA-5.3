return LoadFont("_titleMenu_scroller")..{
	AltText="";
	--20160702
	BeginCommand=function(self)
		local st = GAMESTATE:GetCurrentStyle();
		local cp = st:ColumnsPerPlayer();
		local tld = "TLDifficulty";
		if CAspect() < 1.6 and cp > 6 and st:GetStyleType() == 'StyleType_OnePlayerTwoSides' then
			local screen = SCREENMAN:GetTopScreen();
			if screen then
				if string.find(screen:GetName(),"ScreenGameplay.*") then
					tld = "TLDifficulty43";
				end;
			end;
		end;
		self:settextf( THEME:GetString("ScreenWithMenuElements",tld), LifeDiffSetStr(), GetTimingDifficulty() );
	end
};