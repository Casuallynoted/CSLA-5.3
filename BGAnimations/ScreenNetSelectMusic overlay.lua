
local t = Def.ActorFrame{};

local gsetc = split(",",GetAdhocPref("SortGsetCheck"));
local sctext = getenv("SortCh");
--SCREENMAN:SystemMessage(sctext..","..getenv("ReloadFlag")[1])
if tonumber(getenv("ReloadFlag")[1]) == 0 then
	--20171229
	tp_gr_grade_set();
	SortSetting(getenv("SortCh"),ProfIDSet(csort_pset()));
else setenv("ReloadFlag",{0,0});
end;

--selsort
if not GAMESTATE:IsCourseMode() then
	t[#t+1] = Def.ActorFrame{
		CodeMessageCommand=function(self,params)
			if params.Name == "SelectSort1" or params.Name == "SelectSort2" or 
			params.Name == "SelectSort3" or params.Name == "SelectSort4" then
				if params.PlayerNumber == PLAYER_1 then
					gsetc[1] = "P1";
				else gsetc[1] = "P2";
				end;
				SetAdhocPref("SortGsetCheck",gsetc[1]..","..gsetc[2]);
				--SCREENMAN:SetNewScreen("ScreenSort");
				SCREENMAN:AddNewScreenToTop("ScreenV2Sort");
			end;
		end;
	};
end;

local function update(self)
	if tonumber(getenv("ReloadFlag")[1]) == 1 then
		SCREENMAN:SetNewScreen("ScreenNetSelectMusic");
	end;
end;

t.InitCommand=cmd(SetUpdateFunction,update;);

return t;