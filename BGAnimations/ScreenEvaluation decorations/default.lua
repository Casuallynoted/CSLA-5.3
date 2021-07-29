--[[ScreenEvaluation decorations]]

local SongOrCourse = CurSOSet();
local t = LoadFallbackB();
local endless = 0;
if GAMESTATE:IsCourseMode() then
	local course = GAMESTATE:GetCurrentCourse();
	if (course:GetCourseType() == 'CourseType_Endless' or course:GetCourseType() == 'CourseType_Survival') then
		endless = 1;
	end;
end;

t[#t+1] = StandardDecorationFromFileOptional( "StageDisplay", "StageDisplay" );
t[#t+1] = StandardDecorationFromFileOptional( "WinDisplay", "WinDisplay" );

local pm = GAMESTATE:GetPlayMode();

-- life graph
local function GraphDisplay( pn )
	local t = Def.ActorFrame {
		Def.GraphDisplay {
			InitCommand=cmd(Load,"GraphDisplay"..ToEnumShortString(pn););
			BeginCommand=function(self)
				local ss = SCREENMAN:GetTopScreen():GetStageStats();
				self:Set( ss, ss:GetPlayerStageStats(pn) );
				self:player( pn );
				if pm == 'PlayMode_Battle' or pm == "PlayMode_Rave" then
					if pn == PLAYER_1 then
						self:rotationz(180);
						self:rotationy(180);
					end;
				end;
			end;
		};
	};
	return t;
end

if endless == 0 then
	if ShowStandardDecoration("GraphDisplay") then
		for pn in ivalues(PlayerNumber) do
			t[#t+1] = StandardDecorationFromTable( "GraphDisplay" .. ToEnumShortString(pn), GraphDisplay(pn) );
		end
	end
end

-- combo graph
local function ComboGraph( pn )
	local t = Def.ActorFrame {
		Def.ComboGraph {
			InitCommand=cmd(Load,"ComboGraph"..ToEnumShortString(pn););
			BeginCommand=function(self)
				local ss = SCREENMAN:GetTopScreen():GetStageStats();
				self:Set( ss, ss:GetPlayerStageStats(pn) );
				self:player( pn );
			end
		};
	};
	return t;
end

if ShowStandardDecoration("ComboGraph") then
	for pn in ivalues(PlayerNumber) do
		t[#t+1] = StandardDecorationFromTable( "ComboGraph" .. ToEnumShortString(pn), ComboGraph(pn) );
	end
end


local function PercentScoreText( pn )
	local hs = {};
	hs_local_set(hs,0);
	local SongOrCourse = CurSOSet();
	local StepsOrTrail = CurSTSet(pn);
	steps_count(hs,SongOrCourse,StepsOrTrail,pn,"C_Mines");
	local ssStats = STATSMAN:GetCurStageStats();
	local pnstats = ssStats:GetPlayerStageStats(pn);

	if pnstats then
		hs_set(hs,pnstats,"pnstats");
	end;
	
	local function pointsset(self,pct)
		if pct == 100 then
			self:settext("100");
		elseif pct == 0 then
			self:settext("0");
		else self:settext( string.format( "%.2f",pct ));
		end;
	end;
	
	local t = Def.ActorFrame {
		InitCommand=function(self)
			self:visible(false);
			local HeaderTitle = THEME:GetMetric( Var "LoadingScreen" , "HeaderTitle" );
			if HeaderTitle ~= "Summary" then
				self:visible(true);
			end;
		end;
		
		LoadFont("_numbers5")..{
			InitCommand=cmd(player,pn);
			BeginCommand=cmd(playcommand,"Set");
			SetCommand=function(self)
				(cmd(y,-0.5;horizalign,right;vertalign,bottom;maxwidth,180;diffuse,color("0,1,1,1");strokecolor,color("0,0.4,0.4,1");skewx,-0.2))(self)
				pct = math.floor(hs["PercentScore"]*10000)/100;
				pointsset(self,pct);
				(cmd(zoom,0;sleep,1.85;zoomx,0.8;zoomy,5;accelerate,0.15;zoomy,0.8))(self)
			end;
			NetMessageCommand=function(self, params)
				pointsset(self,math.floor(params.Pct*10000)/100);
				(cmd(zoomx,0.8;zoomy,0.8))(self)
			end;
			NotNetMessageCommand=function(self, params)
				pointsset(self,math.floor(params.Pct*10000)/100);
				(cmd(zoomx,0.8;zoomy,0.8))(self)
			end;
		};
		LoadFont("_numbers4")..{
			InitCommand=cmd(player,pn;horizalign,left;vertalign,bottom;settext,"%";zoom,0.45;skewx,-0.2;
						diffuse,color("0,1,1,1");strokecolor,color("0,0.4,0.4,1"));
			BeginCommand=cmd(playcommand,"Set");
			SetCommand=cmd(zoom,0;sleep,1.85;zoomx,0.45;zoomy,5;accelerate,0.15;zoomy,0.45);
		};
	};
	return t;
end

--if ShowStandardDecoration("PercentScore") then
if pm ~= 'PlayMode_Battle' and pm ~= 'PlayMode_Rave' then
	if endless == 0 then
		for pn in ivalues(PlayerNumber) do
			t[#t+1] = StandardDecorationFromTable( "PercentScore" .. ToEnumShortString(pn), PercentScoreText(pn) );
		end
	end
end;
--end

local difficultyStates = {
	Difficulty_Beginner	= 0,
	Difficulty_Easy		= 2,
	Difficulty_Medium	= 4,
	Difficulty_Hard		= 6,
	Difficulty_Challenge	= 8,
	Difficulty_Edit		= 10,
};

t[#t+1] = StandardDecorationFromFileOptional("TLDifficulty","TLDifficulty");
t[#t+1] = StandardDecorationFromFileOptional("SongInformation","SongInformation");
t[#t+1] = StandardDecorationFromFileOptional( "TryExtraStage", "TryExtraStage" );

for pn in ivalues(PlayerNumber) do
	local p = ( (pn == PLAYER_1) and 1 or 2 );
	local pstr = ProfIDSet(p);
	local MetricsName = "MachineRecord" .. PlayerNumberToString(pn);
	t[#t+1] = LoadActor( THEME:GetPathG(Var "LoadingScreen", "MachineRecord"), pn ) .. {
		InitCommand=function(self) 
			self:player(pn); 
			self:name(MetricsName);
			ActorUtil.LoadAllCommandsAndSetXY(self,Var "LoadingScreen"); 
		end;
	};

	if GAMESTATE:IsCourseMode() then
		t[#t+1] = LoadActor("cleared_stage_frame")..{
			InitCommand=cmd(player,pn;draworder,88;x,GetGraphPosX(pn)+60;y,SCREEN_CENTER_Y-83;);
			OnCommand=cmd(cropright,1;addx,-20;addy,-20;sleep,1.8;decelerate,0.4;cropright,0;addx,20;addy,20;);
		};
	end;

	local MetricsName = "PersonalRecord" .. PlayerNumberToString(pn);
	t[#t+1] = LoadActor( THEME:GetPathG(Var "LoadingScreen", "PersonalRecord"), pn ) .. {
		InitCommand=function(self) 
			self:player(pn); 
			self:name(MetricsName); 
			ActorUtil.LoadAllCommandsAndSetXY(self,Var "LoadingScreen"); 
		end;
	};
	local st = GAMESTATE:GetCurrentStyle():GetStepsType();
	local StepsOrTrail = CurSTSet(pn);
	
	local function ed_check(SongOrCourse,StepsOrTrail,diff)
		if diff ~= "Difficulty_Edit" then
			return GetConvertDifficulty(SongOrCourse,diff);
		end;
		return GetConvertDifficulty(SongOrCourse,"Difficulty_Edit",StepsOrTrail);
	end;

	local t2 = Def.ActorFrame{
		InitCommand=cmd(player,pn);
		LoadActor("profback")..{
			InitCommand=function(self)
				self:y(-2);
				if pn == PLAYER_1 then
					self:x(-22);
				else
					self:x(22);	
					self:rotationy(180);
				end;
			end;
			BeginCommand=cmd(playcommand,"Set";);
			SetCommand=function(self)
				if pn == PLAYER_1 then
					(cmd(addx,40;sleep,0.7;decelerate,0.15;addx,-40;))(self)
				else (cmd(addx,-40;sleep,0.7;decelerate,0.15;addx,40;))(self)
				end;
			end;
		};
		Def.Sprite{
			InitCommand=function(self)
				self:visible(false);
				if FILEMAN:DoesFileExist( ProfIDPrefCheck("ProfAvatar",pstr,"Off") ) then 
					self:visible(true);
					self:Load( ProfIDPrefCheck("ProfAvatar",pstr,"Off") );
					self:scaletofit(0,0,44,44);
				end;
				self:y(-10);
				if pn == PLAYER_1 then
					self:x(-30);
				else self:x(30);
				end;
			end;
			BeginCommand=cmd(playcommand,"Set";);
			SetCommand=cmd(croptop,1;sleep,0.85;decelerate,0.05;croptop,0;);
			UpdateNetEvalStatsMessageCommand=function(self, params)
				local ssStats = STATSMAN:GetCurStageStats();
				local pnstats = ssStats:GetPlayerStageStats(pn);
				if pnstats:GetPlayedSteps()[1] then
					if params.Difficulty == pnstats:GetPlayedSteps()[1]:GetDifficulty() then
						if params.Score == pnstats:GetScore() then
							self:queuecommand("Net");
						else self:queuecommand("NotNet");
						end;
					end;
				else self:queuecommand("NotNet");
				end;
			end;
			NetCommand=function(self)
				self:diffuse(color("1,1,1,1"));
			end;
			NotNetCommand=function(self)
				self:diffuse(color("0,0,0,0"));
			end;
		};
		Def.ActorFrame{
			LoadActor( THEME:GetPathB("ScreenStageInformation","in/diffback") )..{
				InitCommand=function(self)
					if pn == PLAYER_1 then
						self:x(20+38);
					else
						self:x(-20-38);	
						self:rotationy(180);
					end;
					self:playcommand("Update");
				end;
				UpdateCommand=cmd(croptop,1;sleep,0.8;linear,0.2;croptop,0;);
			};
			LoadActor( THEME:GetPathG("DiffDisplay","frame/frame") )..{
				InitCommand=function(self)
					if pn == PLAYER_1 then
						self:x(42);
					else self:x(-42);
					end;
					(cmd(animate,false;playcommand,"Update"))(self)
				end;
				BeginCommand=cmd(playcommand,"Set");
				SetCommand=function(self)
					if StepsOrTrail then
						local state = difficultyStates[StepsOrTrail:GetDifficulty()];
						if pn == PLAYER_2 then state = state + 1; end;
						self:setstate(state);
					end;
				end;
				UpdateNetEvalStatsMessageCommand=function(self,params)
					local state = difficultyStates[params.Difficulty];
					if pn == PLAYER_2 then state = state + 1; end;
					self:setstate(state);
				end;
			};
			LoadFont("StepsDisplay meter")..{
				InitCommand=function(self)
					if pn == PLAYER_1 then
						self:x(44+42);
						self:horizalign(left);
					else
						self:x(-44-42);
						self:horizalign(right);
					end;
					(cmd(shadowlength,0;maxwidth,60;zoom,0.65;skewx,-0.5;playcommand,"Update"))(self)
				end;
				BeginCommand=cmd(playcommand,"Set");
				SetCommand=function(self)
					if not GAMESTATE:IsCourseMode() then
						self:stoptweening();
						if SongOrCourse then
							if SongOrCourse:HasStepsTypeAndDifficulty(st,StepsOrTrail:GetDifficulty()) then
								local meter = StepsOrTrail:GetMeter();
								if GetAdhocPref("UserMeterType") == "CSStyle" then
									meter = ed_check(SongOrCourse,StepsOrTrail,StepsOrTrail:GetDifficulty());
								end;
								self:settextf("%d",meter);
								self:diffuse(CustomDifficultyToColor(StepsOrTrail:GetDifficulty()));
								self:strokecolor(CustomDifficultyToDarkColor(StepsOrTrail:GetDifficulty()));
							end;
						end;
					else self:settext("");
					end;
				end;
				NetMessageCommand=function(self, params)
					local meter = params.Step:GetMeter();
					if GetAdhocPref("UserMeterType") == "CSStyle" then
						meter = ed_check(SongOrCourse,params.Step,params.Diff);
					end;
					self:settextf("%d",meter);
					self:diffuse(CustomDifficultyToColor(params.Diff));
					self:strokecolor(CustomDifficultyToDarkColor(params.Diff));
				end;
				NotNetMessageCommand=function(self, params)
					local meter = params.Step:GetMeter();
					if GetAdhocPref("UserMeterType") == "CSStyle" then
						meter = ed_check(SongOrCourse,params.Step,params.Diff);
					end;
					self:settextf("%d",meter);
					self:diffuse(CustomDifficultyToColor(params.Diff));
					self:strokecolor(CustomDifficultyToDarkColor(params.Diff));
				end;
			};
		};
	};
	t[#t+1] = StandardDecorationFromTable( "StepsDisplay" .. ToEnumShortString(pn), t2 );
end

--20160623 SongOptions Display
t[#t+1] = LoadFont("OptionIcon text")..{
	InitCommand=cmd(diffuse,color("0,1,1,1");horizalign,left;y,SCREEN_TOP+8;shadowlength,0;maxwidth,240;playcommand,"Update");
	OnCommand=cmd(diffusealpha,0;sleep,0.2;linear,0.4;diffusealpha,1;);
	BeginCommand=function(self)
		local tldiff = SCREENMAN:GetTopScreen():GetChild("TLDifficulty");
		local xset = tldiff:GetX() + (tldiff:GetWidth() * 0.5) + 30;
		self:x(xset);
		self:playcommand("Set");
	end;
	SetCommand=function(self)
		self:stoptweening();
		self:settext(GAMESTATE:GetSongOptions('ModsLevel_Preferred'));
	end;
	NetMessageCommand=function(self, params)
		self:stoptweening();
		self:settext(GAMESTATE:GetSongOptions('ModsLevel_Preferred'));
	end;
	NotNetMessageCommand=function(self, params)
		self:stoptweening();
		self:settext("");
	end;
};

t[#t+1] = Def.ActorFrame {
	OffCommand=function(self)
		local sttype = GAMESTATE:GetCurrentStyle():GetStepsType();
		local playmode = GAMESTATE:GetPlayMode();
		for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
			SetAdhocPref("LastStyleMode",sttype..":"..playmode,GetAdhocPref("ProfIDSet" .. ToEnumShortString(pn)));
		end;
	end;
};

--[[
t[#t+1] = LoadFont("Common Normal") .. {
	InitCommand=function(self)
		local song = GAMESTATE:GetCurrentSong();
		local bssStats = STATSMAN:GetPlayedStageStats(2);
		local bsong = bssStats:GetPlayedSongs()[1];
		(cmd(Center;settext,Ex1crsCheck(song,bsong)))(self)
	end;
};
]]

if THEME:GetMetric( Var "LoadingScreen","Summary" ) == false then
	for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
		t[#t+1] = LoadActor("upset", pn)..{
			InitCommand=cmd(draworder,73);
		};
	end;
	t[#t+1] = LoadActor("ufr");
	t[#t+1] = StandardDecorationFromFileOptional( "FOpen", "FOpen" );
end;

return t;