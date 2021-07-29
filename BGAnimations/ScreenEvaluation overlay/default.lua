local t = Def.ActorFrame{};

local pm = GAMESTATE:GetPlayMode();

local r_open = {false,false};
local p_count_check = false;
if #GAMESTATE:GetHumanPlayers() > 1 then
	p_count_check = true;
else r_open = {true,true};
end;

--[ja] 20160116修正
local rv_table = {};
local SongOrCourse = CurSOSet();

local ss_flag = {0,0};
for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
	local StepsOrTrail = CurSTSet(pn);
	local p = ( (pn == PLAYER_1) and 1 or 2 );
	if SongOrCourse and StepsOrTrail then
		local pstr = ProfIDSet(p);
		local profile = c_profile(pn);
		if PROFILEMAN:IsPersistentProfile(pn) then
			local pid_name = profile:GetGUID().."_"..profile:GetDisplayName();
			if #rival_table(pstr,profile,"") > 0 then
				rv_table[p] = rival_table(pstr,profile,pid_name);
			end;
		end;
	end;

	if THEME:GetMetric( Var "LoadingScreen","Summary" ) == false then
		if pm ~= 'PlayMode_Endless' and pm ~= 'PlayMode_Rave' and GAMESTATE:IsHumanPlayer(pn) then
			t[#t+1] = LoadActor("rival_display", pn)..{
				InitCommand=function(self)
					self:visible(not insertchecker(pn,"noset") and tonumber(getenv("fcplayercheck_"..ToEnumShortString(pn))) == 0);
					if p_count_check then
						if pn == PLAYER_1 then
							self:x(SCREEN_LEFT+math.min(186,WideScale(170,186)));
						else self:x(SCREEN_RIGHT-math.min(186,WideScale(170,186)));
						end;
					else
						r_open[p] = true;
						if pn == PLAYER_1 then
							self:x(SCREEN_RIGHT-math.min(186,WideScale(170,186)));
						else self:x(SCREEN_LEFT+math.min(186,WideScale(170,186)));
						end;
					end;
					self:y(SCREEN_CENTER_Y-66);
				end;
				OnCommand=function(self)
					self:playcommand("ROpen");
				end;
				CodeMessageCommand=function(self,params)
					if params.PlayerNumber == pn then
						if rv_table[p] then
							--[ja] 20160416修正
							if params.Name == "RivalOpen1" or params.Name == "RivalOpen2" or params.Name == "RivalOpen3" then
								if r_open[p] == false then
									r_open[p] = true;
								else r_open[p] = false;
								end;
								MESSAGEMAN:Broadcast("ROpen");
								SOUND:PlayOnce(THEME:GetPathS("ScreenTitleMenu","change"));
							end;
						end;
					end;
				end;
				ROpenMessageCommand=cmd(visible,r_open[p];);
			};
		end;
		t[#t+1] = LoadActor("fullcomboeva", pn);
	end;

	--evaluation screenshot
	--[ja] 20150808 三枚までしか撮れないように修正
	t[#t+1] = LoadFont("_shared4")..{
		InitCommand=cmd(x,GetGraphPosX(pn);y,SCREEN_TOP+80;);
		OnCommand=cmd(sleep,1.5;playcommand,"SPlus";);
		SPlusCommand=function(self)
			ss_flag[p] = 1;
		end;
		CodeMessageCommand=function(self, params)
			if params.PlayerNumber == pn and ss_flag[p] < 5 then
				if params.Name == "Screenshot1" or params.Name == "Screenshot2" or 
				params.Name == "Screenshot3" or params.Name == "Screenshot4" then
					SaveScreenshot(params.PlayerNumber, false, true);
					ss_flag[p] = ss_flag[p] + 1;
				end
			end;
		end;
	};
end;

return t;
