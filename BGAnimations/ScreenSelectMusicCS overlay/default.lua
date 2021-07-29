
local t = Def.ActorFrame{};

local key_open = 0;

local pm = GAMESTATE:GetPlayMode();

local maxStages = PREFSMAN:GetPreference("SongsPerPlay");
local ssStats = STATSMAN:GetPlayedStageStats(1);
local group;
if ssStats then
	group = ssStats:GetPlayedSongs()[1]:GetGroupName();
else group = "Beginner's Package";
end;
local bSSetting = GetAdhocPref("CustomSpeed");
local initmenutimer = 0;

local p_check = {2,2,0};
for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
	local p = (pn == PLAYER_1) and 1 or 2;
	p_check[p] = 0;
end;

t[#t+1] = Def.ActorFrame {
	UpDifficultyMessageCommand=function(self)
		SOUND:PlayOnce(THEME:GetPathS("ScreenSelectMusic","difficulty easier"));
	end;
	DownDifficultyMessageCommand=function(self)
		SOUND:PlayOnce(THEME:GetPathS("ScreenSelectMusic","difficulty harder"));
	end;
	-- BGM
	Def.Sound {
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
			self:sleep(1);
			self:queuecommand("Play");
		end;
		PlayCommand=cmd(play);
	};
};

GAMESTATE:SetCurrentSong( newsong );

if pm == "PlayMode_Battle" or pm == "PlayMode_Rave" then
	local so = GAMESTATE:GetDefaultSongOptions();
	GAMESTATE:SetSongOptions( "ModsLevel_Stage", so );
	MESSAGEMAN:Broadcast( "SongOptionsChanged" );
elseif GAMESTATE:IsAnExtraStage() then
	EXFolderLifeSetting();
end

t[#t+1] = Def.ActorFrame{
	InitCommand=function(self)
		if GAMESTATE:IsCourseMode() then self:x(SCREEN_CENTER_X-100);
		else self:x(SCREEN_CENTER_X);
		end;
		--[ja] メニュータイマーフラグ
		if PREFSMAN:GetPreference("MenuTimer") then
			initmenutimer = 1;
		end
	end;
	Def.ActorFrame{
		Condition=not GAMESTATE:IsExtraStage2();
		InitCommand=cmd(y,SCREEN_CENTER_Y-30;);
		-- left
		LoadActor( THEME:GetPathB("","arrow") )..{
			OnCommand=cmd(x,-120+60-16;rotationz,180;diffusealpha,0;sleep,1;queuecommand,"Repeat";);
			RepeatCommand=cmd(addx,12;diffusealpha,1;glow,color("1,0.7,0,1");linear,1;glow,color("0,0,0,0");addx,-12;diffusealpha,0;queuecommand,"Repeat";);
			OffCommand=cmd(stoptweening;);
		};
	
		LoadActor( THEME:GetPathB("","arrow") )..{
			OnCommand=cmd(x,-120+60;rotationz,180;diffusealpha,0;sleep,1.11;queuecommand,"Repeat";);
			RepeatCommand=cmd(addx,16;diffusealpha,1;glow,color("1,0.7,0,1");linear,0.8;glow,color("0,0,0,0");addx,-16;diffusealpha,0;sleep,0.2;queuecommand,"Repeat";);
			OffCommand=cmd(stoptweening;);
		};
	};
	Def.ActorFrame{
		Condition=not GAMESTATE:IsExtraStage2();
		InitCommand=cmd(y,SCREEN_CENTER_Y-30;);
		-- right
		LoadActor( THEME:GetPathB("","arrow") )..{
			OnCommand=cmd(x,120+60+16;diffusealpha,0;sleep,1;queuecommand,"Repeat";);
			RepeatCommand=cmd(addx,-12;diffusealpha,1;glow,color("1,0.7,0,1");linear,1;glow,color("0,0,0,0");addx,12;diffusealpha,0;queuecommand,"Repeat";);
			OffCommand=cmd(stoptweening;);
		};
	
		LoadActor( THEME:GetPathB("","arrow") )..{
			OnCommand=cmd(x,120+60;diffusealpha,0;sleep,1.11;queuecommand,"Repeat";);
			RepeatCommand=cmd(addx,-16;diffusealpha,1;glow,color("1,0.7,0,1");linear,0.8;glow,color("0,0,0,0");addx,16;diffusealpha,0;sleep,0.2;queuecommand,"Repeat";);
			OffCommand=cmd(stoptweening;);
		};
	};
};
--clock
t[#t+1] = LoadFont("_titleMenu_scroller")..{
	InitCommand=function(self)
		(cmd(x,SCREEN_RIGHT-12;y,SCREEN_TOP+58;diffuse,color("0,0,0,1");strokecolor,color("1,0.75,0,0.6");horizalign,right;))(self)
		if getenv("ReloadAnimFlag") == 1 then self:playcommand("NoAnim");
		else self:playcommand("Anim");
		end;
	end;
	AnimCommand=cmd(zoom,0.45;zoomy,0;sleep,0.5;linear,0.4;zoomy,0.45;);
	NoAnimCommand=cmd(zoom,0.45;);
	BeginCommand=cmd(settext, string.format("%04i/%i/%i %i:%02i", Year(), MonthOfYear()+1,DayOfMonth(), Hour(), Minute());sleep,1;queuecommand,"Begin");
};

--[[
t[#t+1] = LoadFont("Common Normal")..{
	InitCommand=cmd(x,SCREEN_RIGHT-70;y,SCREEN_TOP+68;shadowlength,1;strokecolor,color("0,0,0,1");horizalign,right;zoom,0.45;zoomy,0;sleep,0.5;linear,0.4;zoomy,0.45;);
	BeginCommand=cmd(settext, GAMESTATE:GetCurrentSong():GetDisplayMainTitle();sleep,1;queuecommand,"Begin");
};
]]

t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(stoptweening;linear,1.25;queuecommand,"Key");
	KeyCommand=function(self)
		key_open = 1;
	end;

	Def.ActorFrame{
		SelectOMessageCommand=cmd(stoptweening;linear,1.75;queuecommand,"NextScreenP");
		ShowEOMessageCommand=cmd(stoptweening;queuecommand,"NextScreenP");
		NextScreenPCommand=function(self)
			MESSAGEMAN:Broadcast("HidePSFO");
			(cmd(stoptweening;linear,0.125;queuecommand,"NextScreen"))(self)
		end;
		NextScreenCommand=function(self)
			if p_check[3] == 3 then
				SCREENMAN:SetNewScreen("ScreenPlayerOptions");
			elseif p_check[3] == 1 then
				SCREENMAN:SetNewScreen("ScreenStageInformation");
			end;
		end;
	};
};

t[#t+1] = LoadActor(THEME:GetPathB("ScreenSelectMusic","overlay/pump"))..{
	InitCommand=cmd(Center;);
};

t[#t+1] = LoadActor( THEME:GetPathB("","_goto_options_in") )..{};

--[ja] 20160415修正
function inputs_o(event)
	local pn= event.PlayerNumber
	if not pn then return false end
	local p = (pn == PLAYER_1) and 1 or 2;
	local button = event.GameButton
	if key_open == 1 then
		p_check = next_s_check(p_check,event,pn,p,"none");
	else p_check[3] = 0;
	end;
	--SCREENMAN:SystemMessage(button);
end;

t[#t+1] = Def.ActorFrame{
	OnCommand=function(self)
		SCREENMAN:GetTopScreen():AddInputCallback(inputs_o);
	end;
	StepsChosenMessageCommand=function(self, param)
		local p = (param.Player == PLAYER_1) and 1 or 2;
		p_check[p] = 2;
		--SCREENMAN:SystemMessage(getenv("wheelsectioncsc"));
	end;
};

local function update(self)
	local limit = getenv("Timer") + 1;
	if initmenutimer == 1 then
		if p_check[3] == 0 then
			if limit == 0 then
				MESSAGEMAN:Broadcast("SelectO");
				p_check[3] = 1;
			end;
		end;
	end;
end;

t.InitCommand=cmd(SetUpdateFunction,update;);

--[[
t[#t+1] = LoadFont("Common Normal")..{
	InitCommand=cmd(x,SCREEN_RIGHT-70;y,SCREEN_TOP+68;shadowlength,1;strokecolor,color("0,0,0,1");horizalign,right;zoom,0.45;zoomy,0;sleep,0.5;linear,0.4;zoomy,0.45;);
	SelectOMessageCommand=function(self)
		(cmd(settext,p_check[3]))(self)
	end;
};


local function update(self)
	self:playcommand("Count");
end;

t.InitCommand=cmd(SetUpdateFunction,update;);


t[#t+1] = LoadFont("Common Normal")..{
	InitCommand=cmd(x,SCREEN_RIGHT-70;y,SCREEN_TOP+68;shadowlength,1;strokecolor,color("0,0,0,1");horizalign,right;zoom,0.45;zoomy,0;sleep,0.5;linear,0.4;zoomy,0.45;);
	RefreshCommand=function(self)
		local musicwheel = SCREENMAN:GetTopScreen():GetChild('MusicWheel');
		local curIndex = musicwheel:GetWheelItem( math.floor(WheelItems()/2+0.5) );
		local groupname = GAMESTATE:GetPreferredSongGroup();
		self:settext(groupname);
	end;
	CurrentSongChangedMessageCommand=cmd(playcommand,"Refresh");
};
]]

return t;