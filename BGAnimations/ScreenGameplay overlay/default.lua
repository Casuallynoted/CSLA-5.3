--[[ScreenGamePlay overlay]]

local coursemode = GAMESTATE:IsCourseMode();
local mlevel = coursemode and "ModsLevel_Stage" or "ModsLevel_Preferred";

local t = Def.ActorFrame{};

--20160421
local function setcoursemod(pn,stage,mlevel)
	local ps = GAMESTATE:GetPlayerState(pn);
	local p = ( (pn == "PlayerNumber_P1") and 1 or 2 );
	local modstr = "default, " .. ps:GetPlayerOptionsString(mlevel);
	if GAMESTATE:GetCurrentCourse():GetCourseEntries()[tonumber(stage)] then
		local coursemod = GAMESTATE:GetCurrentCourse():GetCourseEntries()[tonumber(stage)]:GetNormalModifiers();
		ps:SetPlayerOptions("ModsLevel_Song", modstr..","..coursemod);
	end;
end;

--20160503
local function setattackmod(pn,mlevel)
	local ps = GAMESTATE:GetPlayerState(pn);
	local p = ( (pn == "PlayerNumber_P1") and 1 or 2 );
	local modstr = "default, " .. ps:GetPlayerOptionsString(mlevel);
	if SCREENMAN:GetTopScreen() then
		local aastr = SCREENMAN:GetTopScreen():GetChild("ActiveAttackListP"..p);
		if aastr and (aastr:GetText() and aastr:GetText() ~= "") then
			local asset = string.gsub(aastr:GetText(),"\n",", ");
			ps:SetPlayerOptions("ModsLevel_Song", modstr..","..asset);
		end;
	end;
end;

if not GAMESTATE:IsDemonstration() then
	local pm = GAMESTATE:GetPlayMode();
	if pm == 'PlayMode_Battle' or pm == 'PlayMode_Rave' then
		--combframe
		t[#t+1] = Def.ActorFrame{
			InitCommand=cmd(y,SCREEN_TOP+50;);
			LoadActor("combframe")..{
				InitCommand=cmd(x,SCREEN_CENTER_X-WideScale(250,310)+14;horizalign,right;);
				OnCommand=cmd(addx,-30;diffusealpha,0;sleep,0.3;decelerate,0.3;addx,30;diffusealpha,1;
							glow,color("1,0,0,0");linear,0.05;glow,color("1,0,0,1");linear,0.4;glow,color("1,0,0,0"););
			};
			
			LoadActor("combframe")..{
				InitCommand=cmd(x,SCREEN_CENTER_X+WideScale(250,310)-14;zoomx,-1;horizalign,right;);
				OnCommand=cmd(addx,30;diffusealpha,0;sleep,0.3;decelerate,0.3;addx,-30;diffusealpha,1;
							glow,color("1,0,0,0");linear,0.05;glow,color("1,0,0,1");linear,0.4;glow,color("1,0,0,0"););
			};
		};
	end;
	
	local iStage = 0;
	local numPlayers = GAMESTATE:GetNumPlayersEnabled();
	local deadcheck = {"Alive","Alive"};
	local batterynum = {0,0};
	local batteryf = {0,0};
	local op = GAMESTATE:GetSongOptionsString();
	local opstr = string.lower(op);
	local maxlives,maxlivesstr;
	maxlives,maxlivesstr = string.find(opstr,"%d+lives");
	if maxlives then
		batterynum[1] = tonumber(string.sub(opstr,maxlives,maxlivesstr-5));
		batterynum[2] = tonumber(string.sub(opstr,maxlives,maxlivesstr-5));
	end;
	
	local p1str = ProfIDSet(1);
	local p2str = ProfIDSet(2);
	local hsp1 = ProfIDPrefCheck("CAppearance",p1str,"Off");
	local hsp2 = ProfIDPrefCheck("CAppearance",p2str,"Off");
	--[ja] 20150619修正
	local chp1 = ProfIDPrefCheck("CHide",p1str,"No,No,No,No");
	local chp2 = ProfIDPrefCheck("CHide",p2str,"No,No,No,No");
	local chp1s = split(",",chp1);
	local chp2s = split(",",chp2);

	local hss = {0,0};

	local screen = SCREENMAN:GetTopScreen();
	local setblindstr = {"",""};

	if screen then
		if screen:GetName() ~= "ScreenGameplaySyncMachine" then
			local p1amodstr = {'0% Hidden','0% Sudden','0% Stealth','0% Blink'};	--CAppearance
			local p2amodstr = {'0% Hidden','0% Sudden','0% Stealth','0% Blink'};	--CAppearance
			local p1hmodstr = {'0% Dark','0% Blind','0% Cover'};	--CHide
			local p2hmodstr = {'0% Dark','0% Blind','0% Cover'};	--CHide
--[[
			local haste,hastestr = string.find(opstr,"Haste");
			if haste then
				screen:HasteTurningPoints({-1, 0, 0.3, 1});
				screen:HasteAddAmounts({-0.5, 0, 0.2, 0.5});
				screen:HasteTimeBetweenUpdates(4);
			end;
]]
		
			for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
				t[#t+1] = LoadActor("fullcombo", pn)..{
				};
				local p = ( (pn == "PlayerNumber_P1") and 1 or 2 );
				local ps = GAMESTATE:GetPlayerState(pn);
				--local pst = ( (pn == "PlayerNumber_P1") and p1str or p2str );
				local hsp = ( (pn == "PlayerNumber_P1") and hsp1 or hsp2 );				--CAppearance
				local amodstr = ( (pn == "PlayerNumber_P1") and p1amodstr or p2amodstr );	--CAppearance
				local chps = ( (pn == "PlayerNumber_P1") and chp1s or chp2s );			--CHide
				local hmodstr = ( (pn == "PlayerNumber_P1") and p1hmodstr or p2hmodstr );	--CHide
				local pop = ps:GetPlayerOptions("ModsLevel_Preferred");
				local post = ps:GetPlayerOptions("ModsLevel_Stage");
				local posn = ps:GetPlayerOptions("ModsLevel_Song");
				local poc = ps:GetPlayerOptions("ModsLevel_Current");

				--t[#t+1] = Def.Quad{
					--InitCommand=function(self)
						--self:visible(false);
						--[ja] 20150514修正
						local modstr = "default, " .. ps:GetPlayerOptionsString(mlevel);
						local pnmaxlives,pnmaxlivesstr = string.find(modstr,"%d+Lives");
					--CAppearance
					--amodstr
						if hsp == "Off" or hsp == "Hidden" or hsp == "Sudden" or 
						hsp == "Stealth" or hsp == "Blink" then
							hss[p] = 0;
							if hsp ~= "Off" then
								for e=1,#amodstr do
									local sp_amodstr = split(" ",amodstr[e]);
									if sp_amodstr[2] == hsp then
										amodstr[e] = hsp;
									end;
								end;
							end;
						else
							if hsp == "Hidden+" then
								hss[p] = 1;
							elseif hsp == "Sudden+" then
								hss[p] = 2;
							elseif hsp == "Hid++Sud+" then
								hss[p] = 3;
							end;
						end;
						Trace("hss1: "..hss[1]);
						Trace("hss2: "..hss[2]);
					--CHide
					--hmodstr
						if chps ~= "" then
							for d=1,#chps do
								if chps[d] ~= "No" then
									for c=1,#hmodstr do
										local sp_hmodstr = split(" ",hmodstr[c]);
										if sp_hmodstr[2] == chps[d] then
											if chps[d] ~= "Blind" then
												--[ja] Blind以外はオプションを登録
												if chps[d] == "Cover" then
													hmodstr[c] = "100% Cover";
													break;
												end;
												if chps[d] ~= "Cover" then
													hmodstr[c] = chps[d];
													break;
												end;
											else
												--[ja] Blindはオプション名だけ登録
												setblindstr[p] = ", Blind";
												break;
											end;
										end;
									end;
								end;
							end;
						end;
						local setstr = amodstr[1]..","..amodstr[2]..","..amodstr[3]..","..amodstr[4];
						--[ja] 20150514修正
						ps:SetPlayerOptions(mlevel, modstr..","..setstr..","..hmodstr[1]..","..hmodstr[2]..","..hmodstr[3]);
						if pnmaxlives then
							batterynum[p] = tonumber(string.sub(modstr,pnmaxlives,pnmaxlivesstr-5));
							pop:LifeSetting('LifeType_Battery');
							post:LifeSetting('LifeType_Battery');
							posn:LifeSetting('LifeType_Battery');
							poc:LifeSetting('LifeType_Battery');
							pop:BatteryLives(batterynum[p]);
							post:BatteryLives(batterynum[p]);
							posn:BatteryLives(batterynum[p]);
							poc:BatteryLives(batterynum[p]);
						end;
						if coursemode and GAMESTATE:GetCurrentCourse():GetCourseType() == 'CourseType_Survival' then
							pop:LifeSetting('LifeType_Time');
							post:LifeSetting('LifeType_Time');
							posn:LifeSetting('LifeType_Time');
							poc:LifeSetting('LifeType_Time');
						end;
					--end;
				--};

				local battery = ps:GetPlayerOptions(mlevel):LifeSetting() == "LifeType_Battery";
				if battery and batterynum[p] > 0 then
					t[#t+1] = Def.ActorFrame{
						HealthStateChangedMessageCommand=function(self,params)
							if params.PlayerNumber == pn then
								if numPlayers == 1 then
									if params.HealthState == 'HealthState_Dead' then
										SCREENMAN:GetTopScreen():PostScreenMessage('SM_Pause', 0.5);
										SCREENMAN:GetTopScreen():PostScreenMessage('SM_BeginFailed', 0.5);
										local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn);
										pss:FailPlayer();
									end;
								else
									if pn == PLAYER_1 then
										local p1health = GAMESTATE:GetPlayerState(PLAYER_1):GetHealthState();
										if deadcheck[1] ~= "Dead" and p1health == 'HealthState_Dead' then
											deadcheck[1] = "Dead";
											local p1ss = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1);
											p1ss:FailPlayer();
											MESSAGEMAN:Broadcast("LivesFailed",{Player = PLAYER_1});
										else deadcheck[1] = "Alive";
										end;
									end;
									if pn == PLAYER_2 then
										local p2health = GAMESTATE:GetPlayerState(PLAYER_2):GetHealthState();
										if deadcheck[2] ~= "Dead" and p2health == 'HealthState_Dead' then
											deadcheck[2] = "Dead";
											local p2ss = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2);
											p2ss:FailPlayer();
											MESSAGEMAN:Broadcast("LivesFailed",{Player = PLAYER_2});
										else deadcheck[2] = "Alive";
										end;
									end;
									if deadcheck[1] == 'Dead' and deadcheck[2] == 'Dead' then
										SCREENMAN:GetTopScreen():PostScreenMessage('SM_Pause', 0.5);
										SCREENMAN:GetTopScreen():PostScreenMessage('SM_BeginFailed', 0.5);
									end;
								end;
								--SCREENMAN:SystemMessage(deadcheck[1]..","..deadcheck[2]);
							end;
						end;
					};
				else
					t[#t+1] = LoadActor("dangerline")..{
						InitCommand=cmd(zoom,0.6;y,SCREEN_TOP+31;diffusealpha,0;);
						BeginCommand=function(self)
							if pn == PLAYER_1 then
								self:horizalign(left);
								self:x(GetPosition(pn)+stylecheckposition()-11);
							else
								self:horizalign(right);
								self:addx(GetPosition(pn)+stylecheckposition()+11);
							end;
						end;
						HealthStateChangedMessageCommand=function(self,params)
							if params.PlayerNumber == pn then
								if params.HealthState == 'HealthState_Danger' then
									self:playcommand("Show");
								else self:playcommand("Hide");
								end;
							end;
						end;
						ShowCommand=cmd(diffusealpha,1;diffuseshift;effectcolor1,color("0.6,0.6,0.6,1");effectcolor2,color("1,0,0,1");effectperiod,0.5;);
						HideCommand=cmd(stoptweening;stopeffect;linear,0.25;diffusealpha,0;);
					};
				end;
			end;

			local scroll = {false,false};
			local scroll_per = {0,0};

			speedscroll = Def.ActorFrame{
				Def.Quad{
					InitCommand=cmd(visible,false);
					CodeMessageCommand=function(self,params)
						local pn = params.PlayerNumber;
						local p = ( (pn == "PlayerNumber_P1") and 1 or 2 );
						local ps = GAMESTATE:GetPlayerState(pn);
						local po = ps:GetPlayerOptions(mlevel);
						local modstr = "default, " .. ps:GetPlayerOptionsString(mlevel);
						local pnmaxlives,pnmaxlivesstr = string.find(modstr,"%d+Lives");
						local pop = ps:GetPlayerOptions("ModsLevel_Preferred");
						local post = ps:GetPlayerOptions("ModsLevel_Stage");
						local posn = ps:GetPlayerOptions("ModsLevel_Song");
						local poc = ps:GetPlayerOptions("ModsLevel_Current");
						local speedinc = ProfIDPrefCheck("GamePlaySpeedIncrement",ProfIDSet(p),25);
						if string.find(modstr,"^.*Reverse.*") and (not scroll[p]) then
							scroll[p] = true;
							scroll_per[p] = 1;
						end;

						local hsp = ( (pn == "PlayerNumber_P1") and hsp1 or hsp2 );
						if hsp ~= "Off" and hsp ~= "Hidden+" and hsp ~= "Sudden+" and hsp ~= "Hid++Sud+" then
							hss[p] = 0;
							modstr = modstr .. ", "..hsp;
							ps:SetPlayerOptions(mlevel, modstr);
						else
							modstr = modstr .. ", 0% Hidden, 0% Sudden, 0% Stealth, 0% Blink";
							ps:SetPlayerOptions(mlevel, modstr);
							if hsp == "Hidden+" then
								hss[p] = 1;
							elseif hsp == "Sudden+" then
								hss[p] = 2;
							elseif hsp == "Hid++Sud+" then
								hss[p] = 3;
							end;
						end;
						
						--20160423
						if params.Name == "ScrollNomal" or params.Name == "ScrollNomal2" or 
						params.Name == "ScrollReverse" or params.Name == "ScrollReverse2" then
							if (params.Name == "ScrollNomal" or params.Name == "ScrollNomal2") then
								scroll_per[p] = 0;
							elseif (params.Name == "ScrollReverse" or params.Name == "ScrollReverse2") then
								scroll_per[p] = 1;
							end;
							pop:Reverse(scroll_per[p],1);
							post:Reverse(scroll_per[p],1);
							posn:Reverse(scroll_per[p],1);
							poc:Reverse(scroll_per[p],1);
						end;
						
						--[ja] 参考 : http://pastebin.com/mbSq9X14
						--[ja] 20150303修正
						--[ja] CSではGamePlaySpeedIncrementの数値で次の変更候補を決めます

						-- Each PlayerOptions function takes up to 2 values, and returns 2 (old) values
						-- First one is the value, second one is approach speed
						-- [ja] PlayerOptionsの各関数は2つまでの値を取り、2つの (変更前の) 値を返す
						-- [ja] 最初の値は設定値、2番目の値は推移速度
						-- Example: speed, approach = PlayerOptions:XMod();
						-- Example: speed = ({PlayerOptions:MMod()})[1];
						-- Example: PlayerOptions:CMod(250); -- C250
						-- Example: PlayerOptions:Hidden(0.7, 1.4); -- *1.4 70% hidden
						if ({pop:CMod()})[1] then
							-- C-Mod
							local speed = ({pop:CMod()})[1];
							local speedccheck = speedinc;
							speed = math.floor(speed / speedinc + 0.5) * speedinc;

							local speedDelta = 0;
							if params.Name == "HiSpeedUp" or params.Name == "HiSpeedUp2" then
								if speed < 2000 then
									speedDelta = speedinc;
								end;
							elseif params.Name == "HiSpeedDown" or params.Name == "HiSpeedDown2" then
								speedDelta = -speedinc;
								if speed + speedDelta > 100 then
									speedDelta = speedDelta;
								else speedDelta = 0;
								end;
							end;

							speed = speed + speedDelta;

							pop:CMod(speed);
							post:CMod(speed);
							posn:CMod(speed);
							poc:CMod(speed);
						elseif ({pop:MMod()})[1] then
							-- m-Mod
							local speed = ({pop:MMod()})[1];
							local speedccheck = speedinc;
							speed = math.floor(speed / speedccheck + 0.5) * speedccheck;
							
							local speedDelta = 0;
							if params.Name == "HiSpeedUp" or params.Name == "HiSpeedUp2" then
								if speed < 2000 then
									speedDelta = speedinc;
								end;
							elseif params.Name == "HiSpeedDown" or params.Name == "HiSpeedDown2" then
								speedDelta = -speedinc;
								if speed + speedDelta > 100 then
									speedDelta = speedDelta;
								else speedDelta = 0;
								end;
							end;

							speed = speed + speedDelta;

							pop:MMod(speed);
							post:MMod(speed);
							posn:MMod(speed);
							poc:MMod(speed);
						elseif ({pop:XMod()})[1] then
							-- x-Mod
							local speed = ({pop:XMod()})[1];
							
							local speedDelta = 0;
							if params.Name == "HiSpeedUp" or params.Name == "HiSpeedUp2" then
								if speed < 10 then
									speedDelta = speedinc / 100;
								end;
							elseif params.Name == "HiSpeedDown" or params.Name == "HiSpeedDown2" then
								speedDelta = -speedinc / 100;
								if speed + speedDelta > 0.25 then
									speedDelta = speedDelta;
								else speedDelta = 0;
								end;
							end;

							speed = speed + speedDelta;

							pop:XMod(speed);
							post:XMod(speed);
							posn:XMod(speed);
							poc:XMod(speed);
						end;
						
						if pnmaxlives then
							batterynum[p] = tonumber(string.sub(modstr,pnmaxlives,pnmaxlivesstr-5));
							pop:LifeSetting('LifeType_Battery');
							post:LifeSetting('LifeType_Battery');
							posn:LifeSetting('LifeType_Battery');
							poc:LifeSetting('LifeType_Battery');
							pop:BatteryLives(batterynum[p]);
							post:BatteryLives(batterynum[p]);
							posn:BatteryLives(batterynum[p]);
							poc:BatteryLives(batterynum[p]);
						end;
						--SCREENMAN:SystemMessage(SCREENMAN:GetTopScreen():GetChild("ActiveAttackListP"..p):GetText());
					end;
					--20160421
					CurrentSongChangedMessageCommand=function(self)
						if coursemode then
							iStage = iStage + 1;
							for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
								setcoursemod(pn,math.max(1,iStage),mlevel);
							end;
						end;
					end;
				};
			};
			--20160423
			local function spsc_update(self)
				for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
					if coursemode then
						setcoursemod(pn,math.max(1,iStage),mlevel);
					else setattackmod(pn,mlevel);
					end;
				end;
			end;

			speedscroll.InitCommand=cmd(SetUpdateFunction,spsc_update;);
			t[#t+1] = speedscroll;

			-- [ja] 倍速表示 
			for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
				local p = ( (pn == "PlayerNumber_P1") and 1 or 2 );
				t[#t+1] = Def.ActorFrame{
					OnCommand=cmd(diffusealpha,0;sleep,0.6;linear,0.2;diffusealpha,1);
					LoadFont("OptionIcon text")..{
						InitCommand=function(self)
							if pn == PLAYER_1 then
								self:x(GetPosition(pn)-150+stylecheckposition());
								self:horizalign(left);
								self:diffuse(PlayerColor(PLAYER_1));
							else
								self:x(GetPosition(pn)+150+stylecheckposition());
								self:horizalign(right);
								self:diffuse(PlayerColor(PLAYER_2));
							end;
							(cmd(zoom,0.9;y,SCREEN_BOTTOM-17;maxwidth,SCREEN_WIDTH/2-76;))(self)
							self:playcommand("Set");
						end;
						SetCommand=function(self)
							local op = GAMESTATE:GetPlayerState(pn):GetPlayerOptionsString('ModsLevel_Preferred');
							local pp = "";
							--local hmodstr = ( (pn == "PlayerNumber_P1") and p1modstr or p2modstr );
							self:finishtweening();
							if hss[p] == 1 then
								pp = pp..", Hidden+"
							elseif hss[p] == 2 then
								pp = pp..", Sudden+"
							elseif hss[p] == 3 then
								pp = pp..", Hid++Sud+"
							end;
							self:settext(op..""..pp..""..setblindstr[p]);
							--[ja] リザルト画面に追加オプション項目の情報を送ります
							setenv("opstringp"..p,pp..""..setblindstr[p]);
						end;
						CodeMessageCommand=function(self,params)
							if params.PlayerNumber == pn then
								self:playcommand("Set");
							end;
						end;
					};
				};
			end;
		end;
	end;
end;

-- DeltaSeconds
if GAMESTATE:GetCurrentCourse() then
	if GAMESTATE:GetCurrentCourse():GetCourseType() == "CourseType_Survival" then
		for pn in ivalues(PlayerNumber) do
			local MetricsName = "DeltaSeconds" .. PlayerNumberToString(pn);
			t[#t+1] = LoadActor( THEME:GetPathG( Var "LoadingScreen", "DeltaSeconds"), pn ) .. {
				InitCommand=function(self) 
					self:player(pn); 
					self:name(MetricsName); 
					ActorUtil.LoadAllCommandsAndSetXY(self,Var "LoadingScreen"); 
				end;
			};
		end
	end;
end;

return t;