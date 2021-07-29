--[[ ScreenSelectMusic decorations ]]

local t = LoadFallbackB();

t[#t+1] = StandardDecorationFromFileOptional( "BannerFrame","BannerFrame" );
t[#t+1] = StandardDecorationFromFileOptional( "StageDisplay", "StageDisplay" );
t[#t+1] = StandardDecorationFromFileOptional( "SortDisplay", "SortDisplay" );
--t[#t+1] = StandardDecorationFromFileOptional( "BPMDisplay", "BPMDisplay" );
t[#t+1] = StandardDecorationFromFileOptional( "SongLength", "SongLength" );	-- plus machine rank
t[#t+1] = StandardDecorationFromFileOptional( "GrooveRadar", "GrooveRadar" );
t[#t+1] = StandardDecorationFromFileOptional( "SecDiffiList", "SecDiffiList" );
t[#t+1] = StandardDecorationFromFileOptional( "DifficultyList", "DifficultyList" );
t[#t+1] = StandardDecorationFromFileOptional( "CourseContents", "CourseContents" );
t[#t+1] = StandardDecorationFromFileOptional( "NumCourseSongs", "NumCourseSongs" );
t[#t+1] = StandardDecorationFromFileOptional( "CourseHasMods", "CourseHasMods" );
t[#t+1] = StandardDecorationFromFileOptional( "Balloon", "Balloon" );
t[#t+1] = StandardDecorationFromFileOptional( "PaneDisplayTextP1","PaneDisplayTextP1" );
t[#t+1] = StandardDecorationFromFileOptional( "PaneDisplayTextP2","PaneDisplayTextP2" );
t[#t+1] = StandardDecorationFromFileOptional( "NoteScoreDataP1","NoteScoreDataP1" );
t[#t+1] = StandardDecorationFromFileOptional( "NoteScoreDataP2","NoteScoreDataP2" );
t[#t+1] = StandardDecorationFromFileOptional( "SegmentDisplay","SegmentDisplay" );
t[#t+1] = StandardDecorationFromFileOptional( "WheelScrollBar","WheelScrollBar" );
t[#t+1] = StandardDecorationFromFileOptional("TLDifficulty","TLDifficulty");
t[#t+1] = StandardDecorationFromFileOptional("Clock","Clock");

--20160718
local scfs = {"StepsType_Dance_Single","Prof_Prof",0,{{0,0,0,0,0},{0,0,0,0,0}},{0,0,0,0,0},"Default"};
s_envcheck(scfs);

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
	local p = ( (pn == "PlayerNumber_P1") and 1 or 2 );
	scfs[4][p][getenv("resultsetflagp"..p)] = 1;
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
		
		--[ja] キャラクターセット
		local charaset = ProfIDPrefCheck("CharacterSet",pstr,"default,0");
		local chastr = split(",",charaset);
		local chara = PROFILEMAN:GetProfile(pn):GetCharacter():GetCharacterID();
		if tonumber(chastr[2]) == 1 then
			GAMESTATE:SetCharacter(pn,chara);
			SetAdhocPref("CharacterSet",chara..",0",pstr);
		end;
	end;
end;

setenv("sloadcheckflag",{scfs[1],scfs[2],scfs[3],scfs[4],scfs[5],scfs[6]});

if GAMESTATE:IsCourseMode() then
	for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
		local diffIcon = LoadActor( THEME:GetPathG( Var "LoadingScreen", "DifficultyIcon" ), pn );
		t[#t+1] = StandardDecorationFromTable( "DifficultyIcon" .. ToEnumShortString(pn), diffIcon );
	end
end;

t[#t+1] = StandardDecorationFromFileOptional("SongOptions","SongOptions");

t[#t+1] = Def.ActorFrame{
	Name="OptionIcons";
	InitCommand=function(self)
		-- xxx: encapsulate this into a function
		self:y(SCREEN_CENTER_Y+210);
		self:draworder(96);
		if getenv("ReloadAnimFlag") == 1 then self:playcommand("NoAnim");
		else self:playcommand("Anim");
		end;
	end;

	LoadActor("OptionIconsSel", PLAYER_1)..{
		InitCommand=cmd(player,PLAYER_1;x,(SCREEN_CENTER_X*0.575)-70.5;);
		AnimCommand=cmd(zoom,0.78;zoomy,0;sleep,0.5;linear,0.3;zoomy,0.78);
		NoAnimCommand=cmd(zoom,0.78;);
	};

	LoadActor("OptionIconsSel", PLAYER_2)..{
		InitCommand=cmd(player,PLAYER_2;x,(SCREEN_CENTER_X*1.425)-16;);
		AnimCommand=cmd(zoom,0.78;zoomy,0;sleep,0.5;linear,0.3;zoomy,0.78);
		NoAnimCommand=cmd(zoom,0.78;);
	};
};

--[[
t[#t+1] = Def.ActorProxy{
	OnCommand=function(self)
		local wheel = SCREENMAN:GetTopScreen():GetChild('MusicWheel');
		self:SetTarget(wheel);
	end;
};
]]
return t;