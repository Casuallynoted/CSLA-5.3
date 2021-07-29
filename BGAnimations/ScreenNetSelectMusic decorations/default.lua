--[[ ScreenNetSelectMusic decorations ]]

local t = LoadFallbackB();

t[#t+1] = StandardDecorationFromFileOptional( "BannerFrame","BannerFrame" );
t[#t+1] = StandardDecorationFromFileOptional( "SortDisplay", "SortDisplay" );
--t[#t+1] = StandardDecorationFromFile( "BPMDisplay", "BPMDisplay" );
t[#t+1] = StandardDecorationFromFile( "SongLength", "SongLength" );
t[#t+1] = StandardDecorationFromFileOptional( "DifficultyList", "DifficultyList" );
t[#t+1] = StandardDecorationFromFileOptional( "Balloon", "Balloon" );
t[#t+1] = StandardDecorationFromFileOptional( "PaneDisplayTextP1","PaneDisplayTextP1" );
t[#t+1] = StandardDecorationFromFileOptional( "PaneDisplayTextP2","PaneDisplayTextP2" );
t[#t+1] = StandardDecorationFromFileOptional( "NoteScoreDataP1","NoteScoreDataP1" );
t[#t+1] = StandardDecorationFromFileOptional( "NoteScoreDataP2","NoteScoreDataP2" );
t[#t+1] = StandardDecorationFromFileOptional( "WheelScrollBar","WheelScrollBar" );
t[#t+1] = StandardDecorationFromFileOptional( "SegmentDisplay","SegmentDisplay" );
t[#t+1] = StandardDecorationFromFileOptional("TLDifficulty","TLDifficulty");
t[#t+1] = StandardDecorationFromFileOptional("Clock","Clock");

--[[
for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
	local diffIcon = LoadActor( THEME:GetPathG( Var "LoadingScreen", "DifficultyIcon" ), pn );
	t[#t+1] = StandardDecorationFromTable( "DifficultyIcon" .. ToEnumShortString(pn), diffIcon );
end
]]

--20160816
local scfs = {"StepsType_Dance_Single","Prof_Prof",0,{{0,0,0,0,0},{0,0,0,0,0}},{0,0,0,0,0},"Default"};
s_envcheck(scfs);

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
	--[ja] オンライン用オプションセット
	local p = ( (pn == PLAYER_1) and 1 or 2 );
	t[#t+1] = Def.ActorFrame {
		BeginCommand=function(self)
			local gmode = GAMESTATE:GetCurrentGame():GetName();

			local ps = GAMESTATE:GetPlayerState(pn);
			for pp = 0,PROFILEMAN:GetNumLocalProfiles()-1 do
				local profileidindex = PROFILEMAN:GetLocalProfileFromIndex(pp);
				local profileid = PROFILEMAN:GetLocalProfileIDFromIndex(pp);
				if PREFSMAN:GetPreference("DefaultLocalProfileIDP"..p) == profileid then
					--[ja] 独自オプション項目読み込みのためのIDセット
					SetAdhocPref("ProfIDSetP"..p,profileid);
					local opget = ProfIDPrefCheck("POptionsString_"..gmode,profileid,"1x");
					ps:SetPlayerOptions("ModsLevel_Preferred", "default, " .. opget);
					break;
				end;
			end;
		end;
	};

	local pstr = ProfIDSet(p);
	--[ja] グラフを新方式に修正してセット
	local adgraph = ProfIDPrefCheck("ScoreGraph",pstr,"Off");
	local adgstr = split("_",adgraph);
	if #adgstr > 1 then
		if adgstr[1] ~= "RIVAL" then
			SetAdhocPref("GraphType",adgstr[1],pstr);
			SetAdhocPref("ScoreGraph",string.sub(adgraph,4),pstr);
		end;
	end;

	if PROFILEMAN:IsPersistentProfile(pn) then
		--[ja] ノートスキンセット
		local noteset = ProfIDPrefCheck("NoteSkinSet",pstr,"default,0");
		local notstr = split(",",noteset);
		local ps = GAMESTATE:GetPlayerState(pn);
		if tonumber(notstr[2]) == 1 then
			ps:GetPlayerOptions("ModsLevel_Preferred"):NoteSkin(notstr[1]);
			ps:GetPlayerOptions("ModsLevel_Song"):NoteSkin(notstr[1]);
			ps:GetPlayerOptions("ModsLevel_Stage"):NoteSkin(notstr[1]);
			ps:GetPlayerOptions("ModsLevel_Current"):NoteSkin(notstr[1]);
		end;
		SetAdhocPref("NoteSkinSet",ps:GetPlayerOptions("ModsLevel_Preferred"):NoteSkin()..",0",pstr);
	end;
end;

setenv("sloadcheckflag",{scfs[1],scfs[2],scfs[3],scfs[4],scfs[5],scfs[6]});

t[#t+1] = wheel_movecursor();

--[[
GAMESTATE:SetCurrentSong( newsong );
GAMESTATE:ApplyGameCommand("sort,Group");
setenv("psflag","Group");
]]

--20161223
function inputs(event)
	local pn= event.PlayerNumber
	if not pn then return false end
	local button = event.GameButton
	local n_button = event.button
	local wheelsel = 1;
	local check = 0;
	--[ja] WheelSpeedがNormal以上の速度
	local musicwheel = SCREENMAN:GetTopScreen():GetChild('MusicWheel');
	if tonumber(PREFSMAN:GetPreference("MusicWheelSwitchSpeed")) >= 10 then
		if event.type == "InputEventType_Repeat" then
			if button == "MenuLeft" or button == "MenuRight" then
				setenv("wheelstop",0);
				wheelsel = 0;
			end;
		else
			if getenv("wheelstop") == 2 and event.type == "InputEventType_Release" then
				check = 1;
			end;
			if button ~= "MenuLeft" and button ~= "MenuRight" then
				if wheelsel == 0 then
					setenv("wheelstop",0);
				end;
			else
				wheelsel = 1;
				setenv("wheelstop",1);
			end;
		end;
	end;
	
	if musicwheel then
		if musicwheel:GetSelectedType() == 'WheelItemDataType_Custom' then
		--20180219
			if string.find(getenv("wheelsectioncsc"),"^Favorite.*") then
				if button == "Start" or button == "Center" then
					favoritesortopen();
				end;
			end;
		end;
	end;
	--[ja] ScrollBarの挙動
	if SCREENMAN:GetTopScreen() then
		if musicwheel then
			wheel_s_bar_set(musicwheel,button,event.type);
			if n_button == "EffectUp" or n_button == "EffectDown" then
				if DISPLAY:GetFPS() >= 20 then
					wheel_shortcut(musicwheel,n_button);
				end;
				if event.type == "InputEventType_Repeat" then
					setenv("wheelstop",2);
				elseif event.type == "InputEventType_FirstPress" then
					setenv("wheelstop",1);
					SCREENMAN:GetTopScreen():lockinput(0.5);
				else
					setenv("wheelstop",1);
					if check == 1 then
						check = 0;
						musicwheel:Move(1);
						musicwheel:Move(-1);
						musicwheel:Move(0);
					end;
				end;
			else
				if button == "MenuLeft" then
					MESSAGEMAN:Broadcast("PreviousSong");
				elseif button == "MenuRight" then
					MESSAGEMAN:Broadcast("NextSong");
				end;
			end;
		end;
	end;
end

t[#t+1] = Def.ActorFrame{
	OnCommand=function(self)
		SCREENMAN:GetTopScreen():AddInputCallback(inputs);
	end;
	--CurrentSongChangedMessageCommand=cmd(playcommand,"On");
	--CurrentCourseChangedMessageCommand=cmd(playcommand,"CurrentSongChangedMessage");
};

--[[
t[#t+1] = LoadFont("Common Normal")..{
	InitCommand=cmd(x,SCREEN_RIGHT-70;y,SCREEN_TOP+68;shadowlength,1;strokecolor,color("0,0,0,1");horizalign,right;zoom,0.45;zoomy,0;sleep,0.5;linear,0.4;zoomy,0.45;);
	OnCommand=function(self)
		(cmd(settext, getenv("wheelstop")))(self)
	end;
	CurrentSongChangedMessageCommand=cmd(playcommand,"On");
	CurrentCourseChangedMessageCommand=cmd(playcommand,"CurrentSongChangedMessage");
};
]]

return t;