local t = Def.ActorFrame{};

if IsNetConnected() then
	setenv("gotopop",1);
end;

if getenv("exflag") == "csc" and not GAMESTATE:IsEventMode() then
	local ssStats = STATSMAN:GetPlayedStageStats(1);
	if ssStats then
		group = ssStats:GetPlayedSongs()[1]:GetGroupName();
	else group = "Beginner's Package";
	end;

	t[#t+1] = Def.Sound {
		InitCommand=function(self)
			local bgm = GetGroupParameter(group,"Extra1SelectBGM");
			if bgm ~= "" and FILEMAN:DoesFileExist("/Songs/"..group.."/"..bgm) then
				self:load("/Songs/"..group.."/"..bgm);
			elseif bgm ~= "" and FILEMAN:DoesFileExist("/AdditionalSongs/"..group.."/"..bgm) then
				self:load("/AdditionalSongs/"..group.."/"..bgm);
			else
				self:load(THEME:GetPathS("","_csc_type1"));
			end;
			self:stop();
			self:play();
		end;
	};
end;

local index = 0;
local row = "";
local name = "";
local choice = 0;

function setting(self,screen,pn)
	index = screen:GetCurrentRowIndex(pn);
	row = screen:GetOptionRow(index);
	name = row:GetName();
	choice = row:GetChoiceInRowWithFocus(pn);
	(cmd(zoom,0.55;wrapwidthpixels,494;horizalign,left;strokecolor,Color("Black")))(self)
	self:settext(THEME:GetString("OptionExplanations",name));
	if PREFSMAN:GetPreference("ArcadeOptionsNavigation") == 0 then
		choice = 1 + choice;
	end;
	if name ~= "Exit" then
		if THEME:GetMetric( "ScreenOptionsMaster",name.."Explanation" ) then
			self:settext(THEME:GetString("OptionItemExplanations",THEME:GetMetric( "ScreenOptionsMaster",name.."Explanation" )..""..choice));
		else self:settext("");
		end;
	end;
	return self;
end;

--if not IsNetConnected() then
	if GAMESTATE:IsHumanPlayer(PLAYER_1) then
		t[#t+1] = LoadFont("_shared4")..{
			InitCommand=cmd(x,(SCREEN_CENTER_X*0.575)-158;y,SCREEN_BOTTOM-50;settext,"";);
			OnCommand=cmd(settext,"";);
			SetP1Command=function(self)
				local screen = SCREENMAN:GetTopScreen();
				if screen then
					setting(self,screen,PLAYER_1);
				end;
			end;
			MenuLeftP1MessageCommand=cmd(playcommand,"SetP1");
			MenuRightP1MessageCommand=cmd(playcommand,"SetP1");
			MenuUpP1MessageCommand=cmd(playcommand,"SetP1");
			MenuDownP1MessageCommand=cmd(playcommand,"SetP1");
		};
	end;

	if GAMESTATE:IsHumanPlayer(PLAYER_2) then
		t[#t+1] = LoadFont("_shared4")..{
			InitCommand=cmd(x,(SCREEN_CENTER_X*1.425)-104;y,SCREEN_BOTTOM-50;settext,"";);
			OnCommand=cmd(settext,"";);
			SetP2Command=function(self)
				local screen = SCREENMAN:GetTopScreen();
				if screen then
					setting(self,screen,PLAYER_2);
				end;
			end;
			MenuLeftP2MessageCommand=cmd(playcommand,"SetP2");
			MenuRightP2MessageCommand=cmd(playcommand,"SetP2");
			MenuUpP2MessageCommand=cmd(playcommand,"SetP2");
			MenuDownP2MessageCommand=cmd(playcommand,"SetP2");
		};
	end;
--end;

--[ja] オプション画面に入った時にCBarDrain()がオプション画面に表示されていないとBatteryが設定されないので対策
local batterynum = {0,0};
if GAMESTATE:IsCourseMode() then
	if GAMESTATE:GetCurrentCourse():GetCourseType() == 'CourseType_Oni' or
	GAMESTATE:GetCurrentCourse():GetCourseType() == 'CourseType_Survival' then
		for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
			local p = ( (pn == "PlayerNumber_P1") and 1 or 2 );
			local ps = GAMESTATE:GetPlayerState(pn);
			local modstr = ps:GetPlayerOptionsString("ModsLevel_Stage");
			local pnmaxlives,pnmaxlivesstr = string.find(modstr,"%d+Lives");
			local pop = ps:GetPlayerOptions("ModsLevel_Preferred");
			local post = ps:GetPlayerOptions("ModsLevel_Stage");
			local posn = ps:GetPlayerOptions("ModsLevel_Song");
			local poc = ps:GetPlayerOptions("ModsLevel_Current");
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
			if GAMESTATE:GetCurrentCourse():GetCourseType() == 'CourseType_Survival' then
				pop:LifeSetting('LifeType_Time');
				post:LifeSetting('LifeType_Time');
				posn:LifeSetting('LifeType_Time');
				poc:LifeSetting('LifeType_Time');
			end;
		end;
	end;
end;

return t;