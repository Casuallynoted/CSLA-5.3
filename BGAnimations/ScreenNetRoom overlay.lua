
local t = Def.ActorFrame{};

setenv("gotopop",0);
for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
	--[ja] オンライン用オプションセット
	t[#t+1] = Def.ActorFrame {
		BeginCommand=function(self)
			local profile = c_profile(pn);
			local p = ( (pn == PLAYER_1) and 1 or 2 );

			local ps = GAMESTATE:GetPlayerState(pn);
			for pp = 0,PROFILEMAN:GetNumLocalProfiles()-1 do
				local profilename = profile:GetDisplayName();
				local profileidindex = PROFILEMAN:GetLocalProfileFromIndex(pp);
				local profileid = PROFILEMAN:GetLocalProfileIDFromIndex(pp);
				if PROFILEMAN:GetPlayerName(pn) == profileidindex:GetDisplayName() then
					--[ja] 独自オプション項目読み込みのためのIDセット
					SetAdhocPref("ProfIDSetP"..p,profileid);
					local opget = ProfIDPrefCheck("POptionsString_"..CurGameName(),profileid,"1x");
					ps:SetPlayerOptions("ModsLevel_Preferred", "default, " .. opget);
					--[ja] ネット対戦の時は基本はOFF
					GAMESTATE:SetCharacter(pn,"default");
					break;
				end;
			end;
		end;
	};
end;

return t;