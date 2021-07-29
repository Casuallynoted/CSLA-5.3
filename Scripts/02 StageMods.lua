function AreStagePlayerModsForced()
	return GAMESTATE:IsAnExtraStage() or (GAMESTATE:GetPlayMode() == "PlayMode_Oni")
end

function AreStageSongModsForced()
	local pm = GAMESTATE:GetPlayMode()
	local bOni = pm == "PlayMode_Oni"
	local bBattle = pm == "PlayMode_Battle"
	local bRave = pm == "PlayMode_Rave"
	return GAMESTATE:IsAnExtraStage() or bOni or bBattle or bRave
end

function SetFail()
	for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
		local failtype = "FailType_Immediate";
		local mlevel = GAMESTATE:IsCourseMode() and "ModsLevel_Stage" or "ModsLevel_Preferred";
		local pop = GAMESTATE:GetPlayerState(pn):GetPlayerOptionsString(mlevel);
		local popstr = string.lower(pop);
		local maxlives,maxlivesstr;
		local maxlivesnum = 0;
		local excheck = 0;
		local pndiff = 'Difficulty_Medium';
		if GAMESTATE:GetCurrentSteps(pn) then
			pndiff = GAMESTATE:GetCurrentSteps(pn):GetDifficulty();
		end;
		if InitPrefsFail() ~= GetAdhocPref("TempDefaultFail") then
			failtype = "FailType_"..string.sub(GetAdhocPref("TempDefaultFail"),5,#GetAdhocPref("TempDefaultFail"));
		else failtype = "FailType_"..string.sub(InitPrefsFail(),5,#InitPrefsFail());
		end;
		if IsNetConnected() then
			failtype = "FailType_EndOfSong";
		else
			if not GAMESTATE:IsEventMode() then
				if getenv("exflag") == "csc" then
					excheck = 1;
				end;
				if getenv("omsflag") == 1 then
					excheck = 1;
				end;

				if string.find(popstr,"%d+lives") then
					maxlives,maxlivesstr = string.find(popstr,"%d+lives");
					if maxlives then
						maxlivesnum = tonumber(string.sub(popstr,maxlives,maxlivesstr-5));
					end;
				end;
				if pndiff == 'Difficulty_Beginner' then
					if vcheck() ~= "beta4" and PREFSMAN:GetPreference('FailOffInBeginner') then
						maxlivesnum = 0;
						failtype = "FailType_Off";
					else
						if GAMESTATE:GetCurrentStage() == "Stage_1st" then
							maxlivesnum = 0;
							failtype = "FailType_Off";
						else
							failtype = "FailType_EndOfSong";
						end;
					end;
				elseif pndiff == 'Difficulty_Easy' then
					if vcheck() ~= "beta4" and PREFSMAN:GetPreference('FailOffForFirstStageEasy') then
						if GAMESTATE:GetCurrentStage() == "Stage_1st" then
							maxlivesnum = 0;
							failtype = "FailType_Off";
						elseif GAMESTATE:GetCurrentStage() == "Stage_2nd" then
							failtype = "FailType_EndOfSong";
						end;
					else
						failtype = "FailType_EndOfSong";
					end;
				end;
			end;
			if excheck == 0 then
				if maxlivesnum > 0 then
					failtype = "FailType_Immediate";
				end;
				if GAMESTATE:IsExtraStage() or GAMESTATE:IsExtraStage2() then
					failtype = "FailType_Immediate";
				end;
			else
				failtype = "EX";
			end;
			if GAMESTATE:IsCourseMode() then
				if GAMESTATE:GetCurrentCourse():GetCourseType() == 'CourseType_Survival' or 
				GAMESTATE:GetCurrentCourse():GetCourseType() == 'CourseType_Oni' or 
				GAMESTATE:GetCurrentCourse():GetCourseType() == 'CourseType_Endless' then
					failtype = "FailType_Immediate";
				end;
			end;
		end;
		if failtype ~= "EX" then
			GAMESTATE:GetPlayerState(pn):GetPlayerOptions(mlevel):FailSetting(failtype);
			MESSAGEMAN:Broadcast( "PlayerOptionsChanged", {PlayerNumber = pn} )
			--Trace("Fail : "..GAMESTATE:GetPlayerState(pn):GetPlayerOptions(mlevel):FailSetting())
		else EXFolderLifeSetting();
		end;
	end;
end

--[[
function SongManager:SetMod()
	local ps = GAMESTATE:GetPlayerState(pn)
	local noteskinstr = ps:GetPlayerOptions("ModsLevel_Preferred"):NoteSkin()
	if noteskinstr == "" then noteskinstr = "default" end
	return noteskinstr
end
]]

function ScreenSelectMusic:setupmusicstagemods()
	Trace( "setupmusicstagemods" )
	local pm = GAMESTATE:GetPlayMode()

	if pm == "PlayMode_Battle" or pm == "PlayMode_Rave" then
		local so = GAMESTATE:GetDefaultSongOptions()
		GAMESTATE:SetSongOptions( "ModsLevel_Stage", so )
		MESSAGEMAN:Broadcast( "SongOptionsChanged" )
	elseif GAMESTATE:IsAnExtraStage() then
		if GAMESTATE:GetPreferredSongGroup() == "---Group All---" then
			local psStats = STATSMAN:GetPlayedStageStats(1);
			local song = psStats:GetPlayedSongs()[1];
			--20160821
			if vcheck() ~= "5_2_0" then
				GAMESTATE:ApplyGameCommand("sort,Group");
			end;
			GAMESTATE:SetPreferredSongGroup( song:GetGroupName() );
		end

		local bExtra2 = GAMESTATE:IsExtraStage2()
		local style = GAMESTATE:GetCurrentStyle()
		local song, steps = SONGMAN:GetExtraStageInfo( bExtra2, style )
		local po, so
		--setenv("oldpo",GAMESTATE:GetPlayerState(pn):GetPlayerOptions('ModsLevel_Preferred'));
		if bExtra2 then
			po = THEME:GetMetric("SongManager","OMESPlayerModifiers")
			so = THEME:GetMetric("SongManager","OMESStageModifiers")
		else
			po = THEME:GetMetric("SongManager","ExtraStagePlayerModifiers")
			so = THEME:GetMetric("SongManager","ExtraStageStageModifiers")
		end
		
		local difficulty = steps:GetDifficulty()
		local Reverse = PlayerNumber:Reverse()

		GAMESTATE:SetCurrentSong( song )
		GAMESTATE:SetPreferredSong( song )

		for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
			--[ja] ↓AutoSetStyleがOFFの時、2重にStyleがセットされてしまう問題の対策
			if THEME:GetMetric("Common","AutoSetStyle") == true then
				GAMESTATE:SetCurrentSteps( pn, steps )
			end

			GAMESTATE:GetPlayerState(pn):SetPlayerOptions( "ModsLevel_Stage", po )
			GAMESTATE:SetPreferredDifficulty( pn, difficulty )
			MESSAGEMAN:Broadcast( "PlayerOptionsChanged", {PlayerNumber = pn} )
		end

		GAMESTATE:SetSongOptions( "ModsLevel_Stage", so )
		MESSAGEMAN:Broadcast( "SongOptionsChanged" )
	end
end

function ScreenSelectMusic:setupcoursestagemods()
	local mode = GAMESTATE:GetPlayMode()

	if mode == "PlayMode_Oni" then
		local po = "clearall,default"
		-- Let SSMusic set battery.
		--local sob = "failimmediate,battery"
		local so = "failimmediate"
		local Reverse = PlayerNumber:Reverse()

		for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
--			GAMESTATE:GetPlayerState(pn):SetPlayerOptions( "ModsLevel_Stage", po )
			MESSAGEMAN:Broadcast( "PlayerOptionsChanged", {PlayerNumber = pn} )
		end

		GAMESTATE:SetSongOptions( "ModsLevel_Stage", so )
		MESSAGEMAN:Broadcast( "SongOptionsChanged" )
	end
end

-- (c) 2006-2007 Steve Checkoway
-- All rights reserved.
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a
-- copy of this software and associated documentation files (the
-- "Software"), to deal in the Software without restriction, including
-- without limitation the rights to use, copy, modify, merge, publish,
-- distribute, and/or sell copies of the Software, and to permit persons to
-- whom the Software is furnished to do so, provided that the above
-- copyright notice(s) and this permission notice appear in all copies of
-- the Software and that both the above copyright notice(s) and this
-- permission notice appear in supporting documentation.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
-- OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
-- MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF
-- THIRD PARTY RIGHTS. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR HOLDERS
-- INCLUDED IN THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL INDIRECT
-- OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS
-- OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
-- OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
-- PERFORMANCE OF THIS SOFTWARE.

