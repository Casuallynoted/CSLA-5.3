return Def.HelpDisplay {
	File = THEME:GetPathF("HelpDisplay", "text");
	InitCommand=function(self)
		self:stoptweening();
		local s = THEME:GetMetric(Var "LoadingScreen","HelpText");
		self:SetSecsBetweenSwitches(THEME:GetMetric("HelpDisplay","TipShowTime"));
		if s then
			self:SetTipsColonSeparated(s);
		end;
	end;
	SetHelpTextCommand=function(self, params)
		self:stoptweening();
		self:SetTipsColonSeparated( params.Text );
	end;
};