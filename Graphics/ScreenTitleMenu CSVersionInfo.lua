return LoadFont("_shared4") .. {
	InitCommand=function(self)
		--format ex : "Version L-2_Rev 01 Development",
		--format ex : "Rev 03 Precedence distribution version",
		local cslverstr = GetThemeInfo("CSLVerStr");
		local version = GetThemeInfo("Version");
		local rev = GetThemeInfo("Rev");
		local dev = GetThemeInfo("Dev");
		local pdv = GetThemeInfo("Pdv");	
		local vert = "";
		local revt = "";
		local pdt = "";
		if version ~= "" then
			vert = "Version "..version;
		end;
		if rev > 0 then
			if version ~= "" then
				revt = "_";
			end;
			revt = revt.."Rev "..string.format("%02i", rev);
		end;
		if dev then
			pdt = " Development";
		elseif pdv then
			pdt = " Precedence distribution version";
		end;
		self:settext(cslverstr.." : "..vert..revt..pdt);
	end;
};