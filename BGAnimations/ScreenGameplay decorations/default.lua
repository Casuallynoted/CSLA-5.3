local t = LoadFallbackB();

if not GAMESTATE:IsDemonstration() then
	local cst = GAMESTATE:GetCurrentStyle():GetStyleType();
	local pm = GAMESTATE:GetPlayMode();
	setenv("sload",1);

	local players = #GAMESTATE:GetHumanPlayers();
	local p1diff;
	local p2diff;
	if players > 1 then
		SetAdhocPref("P1CurrentProfID",GetAdhocPref("ProfIDSetP1"));
		SetAdhocPref("P2CurrentProfID",GetAdhocPref("ProfIDSetP2"));
	else
		if GAMESTATE:IsHumanPlayer(PLAYER_1) then
			SetAdhocPref("P1CurrentProfID",GetAdhocPref("ProfIDSetP1"));
			SetAdhocPref("P2CurrentProfID","");
		else
			SetAdhocPref("P1CurrentProfID","");
			SetAdhocPref("P2CurrentProfID",GetAdhocPref("ProfIDSetP2"));
		end;
	end;

	t[#t+1] = StandardDecorationFromFileOptional( "DiffDisplayP1","DiffDisplayP1" );
	t[#t+1] = StandardDecorationFromFileOptional( "DiffDisplayP2","DiffDisplayP2" );
	--[[ top of screen ]]
	t[#t+1] = StandardDecorationFromFileOptional( "LifeFrameP1", "LifeFrameP1" );
	t[#t+1] = StandardDecorationFromFileOptional( "LifeFrameP2", "LifeFrameP2" );
	t[#t+1] = StandardDecorationFromFileOptional( "ScoreFrameP1", "ScoreFrameP1" );
	t[#t+1] = StandardDecorationFromFileOptional( "ScoreFrameP2", "ScoreFrameP2" );
	t[#t+1] = StandardDecorationFromFileOptional("BPMDisplay","BPMDisplay");
	t[#t+1] = StandardDecorationFromFileOptional( "StageDisplay", "StageDisplay" );
	t[#t+1] = StandardDecorationFromFileOptional( "StageFrame", "StageFrame" );
	t[#t+1] = StandardDecorationFromFileOptional( "BannerFrame", "BannerFrame" );
	t[#t+1] = StandardDecorationFromFileOptional("TLDifficulty","TLDifficulty");
	--t[#t+1] = StandardDecorationFromFile( "SongTitle", "SongTitle" );
	t[#t+1] = StandardDecorationFromFile( "BannerTitle", "BannerTitle" );

	--[[ bottom of screen ]]
	t[#t+1] = StandardDecorationFromFile( "SongPosition", "SongPosition" );

	--[ja] https://twitter.com/waiei/status/548140727876591616という情報を発見したので正式公開版で対応予定
	if not THEME:GetMetric( "Gameplay","UseInternalScoring" ) then
		t[#t+1] = Def.Actor{
			Name="JudgmentController";
			JudgmentMessageCommand = function(self, params)
				self:stoptweening();
				Scoring[GetAdhocPref("CSScoringMode")](params, 
					STATSMAN:GetCurStageStats():GetPlayerStageStats(params.Player))
			end;
		};
	end;

	local mlevel = GAMESTATE:IsCourseMode() and "ModsLevel_Stage" or "ModsLevel_Preferred";
	
	local p1ps = GAMESTATE:GetPlayerState(PLAYER_1);
	local p1modstr = "default, " .. p1ps:GetPlayerOptionsString(mlevel);
	local p1maxlives,p1maxlivesstr = string.find(p1modstr,"%d+Lives");
	
	local p2ps = GAMESTATE:GetPlayerState(PLAYER_2);
	local p2modstr = "default, " .. p2ps:GetPlayerOptionsString(mlevel);
	local p2maxlives,p2maxlivesstr = string.find(p2modstr,"%d+Lives");

	local op = GAMESTATE:GetSongOptionsString();
	local opstr = string.lower(op);
	local maxlives,maxlivesstr = string.find(opstr,"%d+lives");

	if pm ~= 'PlayMode_Battle' and pm ~= 'PlayMode_Rave' then
	--livesfailed
		if maxlives or p1maxlives then
			t[#t+1] = LoadActor("livesfailed",PLAYER_1)..{
				InitCommand=cmd(x,GetPosition(PLAYER_1)-140;y,SCREEN_CENTER_Y;draworder,93);
			};
		end;
		if maxlives or p2maxlives then
			t[#t+1] = LoadActor("livesfailed",PLAYER_2)..{
				InitCommand=cmd(x,GetPosition(PLAYER_2)+140;y,SCREEN_CENTER_Y;draworder,93);
			};
		end;
	end;

	t[#t+1] = Def.Quad{
		BeginCommand=cmd(FullScreen;draworder,92;);
		OnCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;diffuse,color("0,0,0,1");linear,1;diffuse,color("0,0,0,0"););
	};
--demo
end;

return t;