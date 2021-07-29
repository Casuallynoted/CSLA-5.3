function PlayerColor( pn )
	if pn == PLAYER_1 then return color("0,1,0.7,1") end
	if pn == PLAYER_2 then return color("0,0.7,1,1") end
	return color("1,1,1,1")
end

Colors = {
	Difficulty = {
		Beginner			= color("0,0.9,1"),
		Easy				= color("1,0.7,0.2"),
		Medium			= color("1,0.4,0.5"),
		Hard				= color("0.2,1,0.2"),
		Challenge			= color("0.5,0.4,1"),
		Edit				= color("0.8,0.8,0.8"),
		Difficulty_Beginner	= color("0,0.9,1"),
		Difficulty_Easy		= color("1,0.7,0.2"),
		Difficulty_Medium	= color("1,0.4,0.5"),
		Difficulty_Hard		= color("0.2,1,0.2"),
		Difficulty_Challenge	= color("0.5,0.4,1"),
		Difficulty_Edit		= color("0.8,0.8,0.8"),

		Couple			= color("#ed0972"),
		Routine			= color("#ff9a00"),
		Difficulty_Couple		= color("#ed0972"),
		Difficulty_Routine	= color("#ff9a00"),
	};
	Judgment = {
		JudgmentLine_W1		= color("1,1,1"),
		JudgmentLine_W2		= color("1,0.8,0.2"),
		JudgmentLine_W3		= color("0,1,0.2"),
		JudgmentLine_W4		= color("#34bfff"),
		JudgmentLine_W5		= color("#e44dff"),
		JudgmentLine_Held		= color("1,1,0.4"),
		JudgmentLine_Miss		= color("#ff3c3c"),
		JudgmentLine_LetGo		= color("#ff3c3c"),
		JudgmentLine_MaxCombo	= color("#ffc600")
	};
	--[ja] 20150914修正 ちょっと明るく
	Count = {
		Plus = color("0.6,0.35,1"),
		Minus = color("1,0.3,0.5"),
	};
	Grade = {
		Tier01 = color("1,1,1"),
		Tier02 = color("0,1,1"),
		Tier03 = color("#32D0CC"),
		Tier04 = color("#087A73"),
		Tier05 = color("#72BEF1"),
		Tier06 = color("#2D9CF4"),
		Tier07 = color("#B871A2"),
		Failed = color("#AA0004"),
		None = color("0.5,0.5,0.5")
	};
	GradeJudge = {
		ntype	= color("1,1,0,1"),
		default	= color("0,1,1,1")
	};
	PLevel = {
		L1 = color("0,1,1,1"),
		L2 = color("0.2,1,0.2,1"),
		L3 = color("1,1,0,1"),
		L4 = color("1,0.5,0.2,1")
	}
};

Colors.Difficulty["Crazy"] = Colors.Difficulty["Hard"]
Colors.Difficulty["Freestyle"] = Colors.Difficulty["Medium"]
Colors.Difficulty["Nightmare"] = Colors.Difficulty["Hard"]
Colors.Difficulty["HalfDouble"] = Colors.Difficulty["Medium"]

PaneColors = {
	NumSteps = {
		{ UpperLimit = 99, diffuse = Colors.PLevel["L1"] },
		{ UpperLimit = 179, diffuse = Colors.PLevel["L2"] },
		{ UpperLimit = 329, diffuse = Colors.PLevel["L3"] },
		{ UpperLimit = 499, diffuse = Colors.PLevel["L4"] },
	};
	CourseNumSteps = {
		{ UpperLimit = 599, diffuse = Colors.PLevel["L1"] },
		{ UpperLimit = 999, diffuse = Colors.PLevel["L2"] },
		{ UpperLimit = 1499, diffuse = Colors.PLevel["L3"] },
		{ UpperLimit = 1999, diffuse = Colors.PLevel["L4"] },
	};

	Jumps = {
		{ UpperLimit = 19, diffuse = Colors.PLevel["L1"] },
		{ UpperLimit = 39, diffuse = Colors.PLevel["L2"] },
		{ UpperLimit = 74, diffuse = Colors.PLevel["L3"] },
		{ UpperLimit = 99, diffuse = Colors.PLevel["L4"] },
	};
	CourseJumps = {
		{ UpperLimit = 49, diffuse = Colors.PLevel["L1"] },
		{ UpperLimit = 99, diffuse = Colors.PLevel["L2"] },
		{ UpperLimit = 164, diffuse = Colors.PLevel["L3"] },
		{ UpperLimit = 249, diffuse = Colors.PLevel["L4"] },
	};
	Holds = {
		{ UpperLimit = 14, diffuse = Colors.PLevel["L1"] },
		{ UpperLimit = 29, diffuse = Colors.PLevel["L2"] },
		{ UpperLimit = 49, diffuse = Colors.PLevel["L3"] },
		{ UpperLimit = 74, diffuse = Colors.PLevel["L4"] },
	};
	CourseHolds = {
		{ UpperLimit = 34, diffuse = Colors.PLevel["L1"] },
		{ UpperLimit = 69, diffuse = Colors.PLevel["L2"] },
		{ UpperLimit = 119, diffuse = Colors.PLevel["L3"] },
		{ UpperLimit = 179, diffuse = Colors.PLevel["L4"] },
	};
	Etc = {
		{ UpperLimit = 9, diffuse = Colors.PLevel["L4"] },
	};
	CourseEtc = {
		{ UpperLimit = 49, diffuse = Colors.PLevel["L4"] },
	};
};

JBoxColor = {
	Colors.Judgment["JudgmentLine_W1"],
	Colors.Judgment["JudgmentLine_W2"],
	Colors.Judgment["JudgmentLine_W3"],
	Colors.Judgment["JudgmentLine_W4"],
	Colors.Judgment["JudgmentLine_W5"],
	Colors.Judgment["JudgmentLine_Miss"]
};
setmetatable( JBoxColor, { __index = function() return Colors.Grade["None"] end; } );

function CustomDifficultyToColor( sCustomDifficulty ) 
	return Colors.Difficulty[sCustomDifficulty]
end

function CustomDifficultyToDarkColor( sCustomDifficulty ) 
	local c = Colors.Difficulty[sCustomDifficulty]
	return { c[1]/2, c[2]/2, c[3]/2, c[4] }
end

function CustomDifficultyToDarkColorDal( sCustomDifficulty ) 
	local c = Colors.Difficulty[sCustomDifficulty]
	return { c[1]/3, c[2]/3, c[3]/3, c[4] }
end

function CustomDifficultyToLightColor( sCustomDifficulty ) 
	local c = Colors.Difficulty[sCustomDifficulty]
	return { scale(c[1],0,1,0.5,1), scale(c[2],0,1,0.5,1), scale(c[3],0,1,0.5,1), c[4] }
end

function DifficultyToDarkColor( Difficulty ) 
	local c = Colors.Difficulty[Difficulty]
	return { c[1]/2, c[2]/2, c[3]/2, c[4] }
end

--20160418
function pnToDarkColor( pn )
	local c = PlayerColor(pn)
	return { c[1], c[2], c[3], c[4]*0.5 }
end

function CPaneValueToColor(category,value)
	numValue = tonumber(value)
	local t;
	local bIsCourseMode = GAMESTATE:IsCourseMode();
	if bIsCourseMode then
		if category == 'RadarCategory_TapsAndHolds' then t = PaneColors.CourseNumSteps;
		elseif category == 'RadarCategory_Jumps' then t = PaneColors.CourseJumps;
		elseif category == 'RadarCategory_Holds' then t = PaneColors.CourseHolds;
		elseif category == 'RadarCategory_Mines' then t = PaneColors.CourseEtc;
		elseif category == 'RadarCategory_Hands' then t = PaneColors.CourseEtc;
		elseif category == 'RadarCategory_Rolls' then t = PaneColors.CourseEtc;
		elseif category == 'RadarCategory_Lifts' then t = PaneColors.CourseEtc;
		end;
	else
		if category == 'RadarCategory_TapsAndHolds' then t = PaneColors.NumSteps;
		elseif category == 'RadarCategory_Jumps' then t = PaneColors.Jumps;
		elseif category == 'RadarCategory_Holds' then t = PaneColors.Holds;
		elseif category == 'RadarCategory_Mines' then t = PaneColors.Etc;
		elseif category == 'RadarCategory_Hands' then t = PaneColors.Etc;
		elseif category == 'RadarCategory_Rolls' then t = PaneColors.Etc;
		elseif category == 'RadarCategory_Lifts' then t = PaneColors.Etc;
		end;
	end;

	for i=1,#t do
		if numValue == nil or numValue == 0 then
			return color("0.3,0.3,0.3,0.7")
		elseif numValue <= t[i].UpperLimit then
			return t[i].diffuse
		end;
		if i == #t then
			if numValue > t[i].UpperLimit then
				return color("1,0,0.2,1")
			else return t[i].diffuse
			end;
		end;
	end
end

--20180206
function GetSortColor(sortmenu)
	if sortmenu then
		local crt = {
			{ name = "Group", color = color("0.5,1,0,1") },
			{ name = "Title", color = color("0,1,1,1") },
			{ name = "Artist", color = color("0,1,1,1") },
			{ name = "BeginnerMeter", color = Colors.Difficulty["Beginner"] },
			{ name = "EasyMeter", color = Colors.Difficulty["Easy"] },
			{ name = "MediumMeter", color = Colors.Difficulty["Medium"] },
			{ name = "HardMeter", color = Colors.Difficulty["Hard"] },
			{ name = "ChallengeMeter", color = Colors.Difficulty["Challenge"] },
			{ name = "TopGradesBeginner", color = Colors.Difficulty["Beginner"] },
			{ name = "TopGradesEasy", color = Colors.Difficulty["Easy"] },
			{ name = "TopGradesMedium", color = Colors.Difficulty["Medium"] },
			{ name = "TopGradesHard", color = Colors.Difficulty["Hard"] },
			{ name = "TopGradesChallenge", color = Colors.Difficulty["Challenge"] },
			{ name = "TopGradesBeginnerP1", color = Colors.Difficulty["Beginner"] },
			{ name = "TopGradesEasyP1", color = Colors.Difficulty["Easy"] },
			{ name = "TopGradesMediumP1", color = Colors.Difficulty["Medium"] },
			{ name = "TopGradesHardP1", color = Colors.Difficulty["Hard"] },
			{ name = "TopGradesChallengeP1", color = Colors.Difficulty["Challenge"] },
			{ name = "TopGradesBeginnerP2", color = Colors.Difficulty["Beginner"] },
			{ name = "TopGradesEasyP2", color = Colors.Difficulty["Easy"] },
			{ name = "TopGradesMediumP2", color = Colors.Difficulty["Medium"] },
			{ name = "TopGradesHardP2", color = Colors.Difficulty["Hard"] },
			{ name = "TopGradesChallengeP2", color = Colors.Difficulty["Challenge"] },
			{ name = "UserCustomP1", color = BoostColor(PlayerColor(PLAYER_1),1.3) },
			{ name = "UserCustomP2", color = BoostColor(PlayerColor(PLAYER_2),1.3) },
			{ name = "FavoriteP1", color = BoostColor(PlayerColor(PLAYER_1),1.3) },
			{ name = "FavoriteP2", color = BoostColor(PlayerColor(PLAYER_2),1.3) },
			{ name = "SongBranch", color = color("1,0.5,0,1") }
		};
		for i=1,#crt do
			if sortmenu == crt[i].name then
				return crt[i].color;
			end
		end
	end
	return THEME:GetMetric("MusicWheel","SortMenuColor")
end