local t = Def.ActorFrame {};

if vcheck() then
	for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
		local mlevel = GAMESTATE:IsCourseMode() and "ModsLevel_Stage" or "ModsLevel_Preferred";
		if vcheck() ~= "beta4" then
			GAMESTATE:GetPlayerState(pn):GetPlayerOptions(mlevel):FailSetting("FailType_"..string.sub(InitPrefsFail(),5,#InitPrefsFail()));
		else GAMESTATE:GetPlayerState(pn):GetPlayerOptions(mlevel):FailSetting(string.sub(InitPrefsFail(),5,#InitPrefsFail()));
		end;
	end;
end;

return t