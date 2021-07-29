local t = Def.ActorFrame{};
--20160718
P_Sort_Set("before");
for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
	local p = ( (pn == "PlayerNumber_P1") and 1 or 2 );
	local pstr = ProfIDSet(p);
	local ropen = ProfIDPrefCheck("SRivalOpen",pstr,1);
	local adgraph = ProfIDPrefCheck("ScoreGraph",pstr,"Off");
	setenv("s_rival_op"..p,ropen);
	setenv("scoregraphp"..p,adgraph);
	--20170914
	local pm = ToEnumShortString(GAMESTATE:GetPlayMode());
	if pm ~= 'Nonstop' and pm ~= 'Oni' and pm ~= 'Endless' then
		if #GAMESTATE:GetHumanPlayers() < 2 then
			--20171229
			local prof_ls = ProfIDPrefCheck("LastSortCh",pstr,"Group,ntype");
			local s_sort_c = split(",",prof_ls);
			if s_sort_c[2] ~= "ntype" and s_sort_c[2] ~= "default" then
				s_sort_c[2] = "ntype";
			end;
			prof_ls = string.gsub(s_sort_c[1],"P[12]","P"..p);
			--Trace("prof_ls : "..prof_ls);
			if prof_ls ~= "Group" then
				local sortset = sortmenuset(ToEnumShortString(pn),pstr);
				for i=1, #sortset do
					if prof_ls == sortset[i] then
						SortSetting(prof_ls,pstr);
						setenv("SortCh",prof_ls);
						SetAdhocPref("LastSortCh",getenv("SortCh")..","..s_sort_c[2],pstr);
					end;
				end;
			end;
		end;
	end;
end;

return t;
