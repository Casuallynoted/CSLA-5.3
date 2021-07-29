local c;
local player = Var "Player";
local p = (player == PLAYER_1) and 1 or 2;
local pstr = ProfIDSet(p);
local adgraph = ProfIDPrefCheck("ScoreGraph",pstr,"Off");
local pndiff;
if GAMESTATE:IsCourseMode() then
	pndiff = GAMESTATE:GetCurrentTrail(player):GetDifficulty();
else
	pndiff = GAMESTATE:GetCurrentSteps(player):GetDifficulty();
end;

--[ja] 20150619修正
local chp = ProfIDPrefCheck("CHide",pstr,"No,No,No,No");
local chps = split(",",chp);
local chpflag = 0;
for d=1,#chps do
	if chps[d] == "Blind" then
		chpflag = 1;
		break;
	end;
end;

local chpro = ProfIDPrefCheck("CProTiming",pstr,"No,No,No");
local chpros = split(",",chpro);

local bShowProtiming = false;
local bShowFS = false;
local bShowMigs = false;
local migscheck = false;

if GAMESTATE:IsDemonstration() then
	adgraph = 0;
	chpflag = 0;
	bShowProtiming = false;
	bShowFS = false;
else
	--if GetUserPrefB("UserPrefShowLotsaOptions") == true then
		if adgraph == "Off" then
			adgraph = 0;
		else
			if GAMESTATE:IsCourseMode() and (GAMESTATE:GetCurrentCourse():GetCourseType() == 'CourseType_Endless' or 
			GAMESTATE:GetCurrentCourse():GetCourseType() == 'CourseType_Survival') then
				adgraph = 0;
			else adgraph = 1;
			end;
		end;
		if chpros[1] == "ProTiming" then
			bShowProtiming = true;
		end;
		if chpros[2] == "FAST/SLOW" then
			bShowFS = true;
		end;
	--else
		--adgraph = 0;
	--end;
end;

local function MakeAverage( t )
	local sum = 0;
	for i=1,#t do
		sum = sum + t[i];
	end
	return sum / #t
end

local tTotalJudgments = {};

local JudgeCmds = {
	TapNoteScore_W1 = THEME:GetMetric( "Judgment", "JudgmentW1Command" );
	TapNoteScore_W2 = THEME:GetMetric( "Judgment", "JudgmentW2Command" );
	TapNoteScore_W3 = THEME:GetMetric( "Judgment", "JudgmentW3Command" );
	TapNoteScore_W4 = THEME:GetMetric( "Judgment", "JudgmentW4Command" );
	TapNoteScore_W5 = THEME:GetMetric( "Judgment", "JudgmentW5Command" );
	TapNoteScore_Miss = THEME:GetMetric( "Judgment", "JudgmentMissCommand" );
};

local ProtimingCmds = {
	TapNoteScore_W1 = THEME:GetMetric( "Protiming", "ProtimingW1Command" );
	TapNoteScore_W2 = THEME:GetMetric( "Protiming", "ProtimingW2Command" );
	TapNoteScore_W3 = THEME:GetMetric( "Protiming", "ProtimingW3Command" );
	TapNoteScore_W4 = THEME:GetMetric( "Protiming", "ProtimingW4Command" );
	TapNoteScore_W5 = THEME:GetMetric( "Protiming", "ProtimingW5Command" );
	TapNoteScore_Miss = THEME:GetMetric( "Protiming", "ProtimingMissCommand" );
};

local AverageCmds = {
	Pulse = THEME:GetMetric( "Protiming", "AveragePulseCommand" );
};
local TextCmds = {
	Pulse = THEME:GetMetric( "Protiming", "TextPulseCommand" );
};
local EarlyTextCmds = {
	Pulse = THEME:GetMetric( "Protiming", "EarlyTextPulseCommand" );
};
local ExTextCmds = {
	Pulse = THEME:GetMetric( "Protiming", "ExTextPulseCommand" );
};

local TNSFrames = {
	TapNoteScore_W1 = 0;
	TapNoteScore_W2 = 1;
	TapNoteScore_W3 = 2;
	TapNoteScore_W4 = 3;
	TapNoteScore_W5 = 4;
	TapNoteScore_Miss = 5;
};
local t = Def.ActorFrame {};

local screen = SCREENMAN:GetTopScreen();

if screen then
	if screen:GetName() ~= "ScreenGameplaySyncMachine" then
		if not GAMESTATE:IsDemonstration() then
			t[#t+1] = LoadActor( "HSCover", player )..{
			};
		end;
	end;
end;

if chpflag == 0 then
	t[#t+1] = Def.ActorFrame {
		--20160703
		LoadFont("_um")..{
			Name="Migs";
			Text="";
			InitCommand=cmd(visible,false;strokecolor,Color("Black"));
			OnCommand=THEME:GetMetric("Protiming","MigsOnCommand");
			ResetCommand=cmd(finishtweening;stopeffect;visible,false;);
			LifeChangedMessageCommand=function(self,param)
				self:stoptweening();
				if param.Player == player then
					if param.LivesLeft == 0 then
						bShowMigs = false;
						if not GAMESTATE:IsCourseMode() then
							if not GAMESTATE:IsEventMode() and 
							GAMESTATE:GetCurrentStage() == "Stage_1st" and pndiff == 'Difficulty_Beginner' then
								bShowMigs = true;
							end;
						end;
					else bShowMigs = true;
					end;
				end;
			end;
			JudgmentMessageCommand=function(self, param)
				if param.Player == player then
					self:playcommand("Reset");
					self:queuecommand("Set");
					migscheck = true;
				end;
			end;
			MIGSSetMessageCommand=function(self,param)
				self:stoptweening();
				if param.Player == player then
					self:visible(bShowMigs);
					self:stoptweening();
					if adgraph == 1 and param.Migs and migscheck then
						migscheck = false;
						self:settext(param.Migs);
						if tonumber(param.Migs) > 0 then
							self:settext("+"..param.Migs);
							self:diffuse(Colors.Count["Plus"]);
						elseif tonumber(param.Migs) == 0 then
							self:diffuse(Color("White"));
						elseif tonumber(param.Migs) < 0 then
							self:diffuse(Colors.Count["Minus"]);
						end;
						ExTextCmds['Pulse'](self);
					end;
				end;
			end;
		};
	};

	t[#t+1] = Def.ActorFrame {
		LoadActor("_judgments") .. {
			Name="Judgment";
			InitCommand=cmd(pause;visible,false);
			--OnCommand=THEME:GetMetric("Judgment","JudgmentOnCommand");
			ResetCommand=cmd(finishtweening;stopeffect;visible,false);
		};
		LoadFont("_um") .. {
			Name="ProtimingDisplay";
			Text="";
			InitCommand=cmd(visible,false);
			OnCommand=THEME:GetMetric("Protiming","ProtimingOnCommand");
			ResetCommand=cmd(finishtweening;stopeffect;visible,false);
		};
		LoadFont("Common Normal") .. {
			Name="ProtimingAverage";
			Text="";
			InitCommand=cmd(visible,false);
			OnCommand=THEME:GetMetric("Protiming","AverageOnCommand");
			ResetCommand=cmd(finishtweening;stopeffect;visible,false);
		};
		LoadFont("Common Normal") .. {
			Name="ProtimingEarlyText";
			Text="";
			InitCommand=cmd(visible,false);
			OnCommand=THEME:GetMetric("Protiming","EarlyTextOnCommand");
			ResetCommand=cmd(finishtweening;stopeffect;visible,false);
		};
		LoadFont("Common Normal") .. {
			Name="TextDisplay";
			Text="MS";
			InitCommand=cmd(visible,false);
			OnCommand=THEME:GetMetric("Protiming","TextOnCommand");
			ResetCommand=cmd(finishtweening;stopeffect;visible,false);
		};
		Def.Quad {
			Name="ProtimingGraphBG";
			InitCommand=cmd(visible,false;y,32;zoomto,192,16);
			ResetCommand=cmd(finishtweening;diffusealpha,0.8;visible,false);
			OnCommand=cmd(diffuse,Color("Black");diffusetopedge,color("0.1,0.1,0.1,1");diffusealpha,0.8;shadowlength,2;);
		};
		Def.Quad {
			Name="ProtimingGraphWindowW3";
			InitCommand=cmd(visible,false;y,32;zoomto,192-4,16-4);
			ResetCommand=cmd(finishtweening;diffusealpha,1;visible,false);
			OnCommand=cmd(diffuse,Colors.Judgment["JudgmentLine_W3"];);
		};
		Def.Quad {
			Name="ProtimingGraphWindowW2";
			InitCommand=cmd(visible,false;y,32;zoomto,scale(PREFSMAN:GetPreference("TimingWindowSecondsW2"),0,PREFSMAN:GetPreference("TimingWindowSecondsW3"),0,192-4),16-4);
			ResetCommand=cmd(finishtweening;diffusealpha,1;visible,false);
			OnCommand=cmd(diffuse,Colors.Judgment["JudgmentLine_W2"];);
		};
		Def.Quad {
			Name="ProtimingGraphWindowW1";
			InitCommand=cmd(visible,false;y,32;zoomto,scale(PREFSMAN:GetPreference("TimingWindowSecondsW1"),0,PREFSMAN:GetPreference("TimingWindowSecondsW3"),0,192-4),16-4);
			ResetCommand=cmd(finishtweening;diffusealpha,1;visible,false);
			OnCommand=cmd(diffuse,Colors.Judgment["JudgmentLine_W1"];);
		};
		Def.Quad {
			Name="ProtimingGraphUnderlay";
			InitCommand=cmd(visible,false;y,32;zoomto,192-4,16-4);
			ResetCommand=cmd(finishtweening;diffusealpha,0.25;visible,false);
			OnCommand=cmd(diffuse,Color("Black");diffusealpha,0.25);
		};
		Def.Quad {
			Name="ProtimingGraphFill";
			InitCommand=cmd(visible,false;y,32;zoomto,0,16-4;horizalign,left;);
			ResetCommand=cmd(finishtweening;diffusealpha,1;visible,false);
			OnCommand=cmd(diffuse,Color("Red"););
		};
		Def.Quad {
			Name="ProtimingGraphAverage";
			InitCommand=cmd(visible,false;y,32;zoomto,2,7;);
			ResetCommand=cmd(finishtweening;diffusealpha,0.85;visible,false);
			OnCommand=cmd(diffuse,Color("Orange");diffusealpha,0.85);
		};
		Def.Quad {
			Name="ProtimingGraphCenter";
			InitCommand=cmd(visible,false;y,32;zoomto,2,16-4;);
			ResetCommand=cmd(finishtweening;diffusealpha,1;visible,false);
			OnCommand=cmd(diffuse,Color("White");diffusealpha,1);
		};
		InitCommand = function(self)
			c = self:GetChildren();
		end;

		LifeChangedMessageCommand=function(self,param)
			self:stoptweening();
			if param.Player == player then
				if param.LivesLeft == 0 then
					self:visible(false);
					if not GAMESTATE:IsCourseMode() then
						if not GAMESTATE:IsEventMode() and 
						GAMESTATE:GetCurrentStage() == "Stage_1st" and pndiff == 'Difficulty_Beginner' then
							self:visible(true);
						end;
					end;
				else
					self:visible(true);
				end;
			end;
		end;

		JudgmentMessageCommand=function(self, param)
			if param.Player ~= player then return end;
			if param.HoldNoteScore then return end;

			local iNumStates = c.Judgment:GetNumStates();
			local iFrame = TNSFrames[param.TapNoteScore];
			
			if not iFrame then return end
--[[
			if iNumStates == 12 then
				iFrame = iFrame * 2;
				if not param.Early then
					iFrame = iFrame + 1;
				end
			end
]]

			local fTapNoteOffset = param.TapNoteOffset;

			if param.HoldNoteScore then
				fTapNoteOffset = 1;
			else
				fTapNoteOffset = param.TapNoteOffset; 
			end
			
			if param.TapNoteScore == 'TapNoteScore_Miss' then
				fTapNoteOffset = 1;
				bUseNegative = true;
			else
	-- 			fTapNoteOffset = fTapNoteOffset;
				bUseNegative = false;
			end;

			if fTapNoteOffset ~= 1 then
				-- we're safe, you can push the values
				tTotalJudgments[#tTotalJudgments+1] = bUseNegative and fTapNoteOffset or math.abs( fTapNoteOffset );
			end
			
			self:playcommand("Reset");
			c.Judgment:visible( not bShowProtiming );
			c.Judgment:setstate( iFrame );
			JudgeCmds[param.TapNoteScore](c.Judgment);

			c.ProtimingDisplay:visible( bShowProtiming );
			c.ProtimingDisplay:settextf("%i",fTapNoteOffset * 1000);
			ProtimingCmds[param.TapNoteScore](c.ProtimingDisplay);
			
			c.ProtimingAverage:visible( bShowProtiming );
			c.ProtimingAverage:settextf("%.2f%%",clamp(100 - MakeAverage( tTotalJudgments ) * 1000 ,0,100));
			AverageCmds['Pulse'](c.ProtimingAverage);
			
			if param.TapNoteScore ~= 'TapNoteScore_W1' and param.TapNoteScore ~= 'TapNoteScore_Miss' and 
			param.TapNoteScore ~= 'TapNoteScore_HitMine' and param.TapNoteScore ~= 'TapNoteScore_AvoidMine' and
			param.TapNoteScore ~= 'TapNoteScore_CheckpointMiss' and param.TapNoteScore ~= 'TapNoteScore_CheckpointHit' and 
			param.HoldNoteScore ~= 'HoldNoteScore_LetGo' and param.HoldNoteScore ~= 'HoldNoteScore_Held' then
				c.ProtimingEarlyText:visible( bShowFS );
				c.ProtimingEarlyText:y(-15);
				if not bShowProtiming then
					c.ProtimingEarlyText:y(-26);
				end;
				if param.Early then
					c.ProtimingEarlyText:settext("FAST");
					c.ProtimingEarlyText:diffuse(Colors.Count["Plus"]);
				else
					c.ProtimingEarlyText:settext("SLOW");
					c.ProtimingEarlyText:diffuse(Colors.Count["Minus"]);
				end;
			else
				c.ProtimingEarlyText:visible(false);
			end;
			EarlyTextCmds['Pulse'](c.ProtimingEarlyText);
			
			c.TextDisplay:visible( bShowProtiming );
			TextCmds['Pulse'](c.TextDisplay);
			
			c.ProtimingGraphBG:visible( bShowProtiming );
			c.ProtimingGraphUnderlay:visible( bShowProtiming );
			c.ProtimingGraphWindowW3:visible( bShowProtiming );
			c.ProtimingGraphWindowW2:visible( bShowProtiming );
			c.ProtimingGraphWindowW1:visible( bShowProtiming );
			c.ProtimingGraphFill:visible( bShowProtiming );
			c.ProtimingGraphFill:finishtweening();
			c.ProtimingGraphFill:decelerate(1/60);
	-- 		c.ProtimingGraphFill:zoomtowidth( clamp(fTapNoteOffset * 188,-188/2,188/2) );
			c.ProtimingGraphFill:zoomtowidth( clamp(
				scale(
				fTapNoteOffset,
				0,PREFSMAN:GetPreference("TimingWindowSecondsW3"),
				0,188/2),
			-188/2,188/2)
			);
			c.ProtimingGraphAverage:visible( bShowProtiming );
			c.ProtimingGraphAverage:zoomtowidth( clamp(
				scale(
				MakeAverage( tTotalJudgments ),
				0,PREFSMAN:GetPreference("TimingWindowSecondsW3"),
				0,188),
			0,188)
			);
	-- 		c.ProtimingGraphAverage:zoomtowidth( clamp(MakeAverage( tTotalJudgments ) * 1880,0,188) );
			c.ProtimingGraphCenter:visible( bShowProtiming );
			local f_command = cmd(sleep,2;linear,0.5;diffusealpha,0);
			(f_command)(c.ProtimingGraphBG);
			(f_command)(c.ProtimingGraphUnderlay);
			(f_command)(c.ProtimingGraphWindowW3);
			(f_command)(c.ProtimingGraphWindowW2);
			(f_command)(c.ProtimingGraphWindowW1);
			(f_command)(c.ProtimingGraphFill);
			(f_command)(c.ProtimingGraphAverage);
			(f_command)(c.ProtimingGraphCenter);
		end;
	};
end;

return t;
