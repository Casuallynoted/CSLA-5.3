--[[ScreenGamePlay underlay]]

local t = Def.ActorFrame{};
local pm = GAMESTATE:GetPlayMode();
local screen = SCREENMAN:GetTopScreen();
local st = GAMESTATE:GetCurrentStyle();

if not GAMESTATE:IsDemonstration() then
	if screen then
		if screen:GetName() ~= "ScreenGameplaySyncMachine" then
--[[
			for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
				t[#t+1] = Def.ActorFrame{
					OnCommand=function(self)
						local csize = split(",",ProfIDPrefCheck("CNoteSize",GetAdhocPref("ProfIDSet" .. ToEnumShortString(pn)),"New,0"))
						local mlevel = GAMESTATE:IsCourseMode() and "ModsLevel_Stage" or "ModsLevel_Preferred";
						local mini_set = GAMESTATE:GetPlayerState(pn):GetPlayerOptions(mlevel):Mini();
						local filterzoom = scale(mini_set,0.98,-1,0.5,1.5);
						SCREENMAN:SystemMessage(filterzoom);
						if csize[1] == "Old" and filterzoom < 0.99494 then
							local cp = SCREENMAN:GetTopScreen():GetChild("Player"..ToEnumShortString(pn));
							if cp then
								local nfield = cp:GetChild("NoteField");
								if nfield then
									local nc_actors = nfield:get_column_actors();
									local one = tonumber(THEME:GetMetric("ArrowEffects","ArrowSpacing"));
									local cpp = tonumber(GAMESTATE:GetCurrentStyle():ColumnsPerPlayer());
									local fzc = scale(filterzoom,0.5,1,0.75,0);
									for i=1,#nc_actors do
										local sc = scale(i,1,#nc_actors,-#nc_actors/2,#nc_actors/2);
										nc_actors[i]:addx((sc*one)*fzc);
									end;
								end;
							end;
						end;
					end;
				};
			end;
]]
			if st:GetStyleType() ~= 'StyleType_TwoPlayersSharedSides' then
				for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
					--if GetUserPrefB("UserPrefShowLotsaOptions") == true then
						t[#t+1] = LoadActor("ScreenFilter_Normal", pn)..{
						};
					--end;
					--[ja] Rave・Battle以外の時はグラフ読み込み
					if pm ~= 'PlayMode_Battle' and pm ~= 'PlayMode_Rave' then
						t[#t+1] = LoadActor("tgraph_one", pn)..{
							InitCommand=cmd(draworder,94;);
						};
					end;
					
				end;
			end;
		end;
	end;
end;

return t;