local c;
local cf;
local player = Var "Player";

local W1Cmds = {
	Pulse = THEME:GetMetric( "Judgment", "JudgmentW1Command" );
};

local lsatWorstJudge = {0,0};
local ShowComboAt = THEME:GetMetric("Combo", "ShowComboAt");
local NumberPulse = THEME:GetMetric("Combo", "NumberPulseCommand");
local LabelPulse = THEME:GetMetric("Combo", "LabelPulseCommand");

local aCombo = {0,0};
local ANumberPulse = THEME:GetMetric("Combo", "ANumberPulseCommand");
local ALabelPulse = THEME:GetMetric("Combo", "ALabelPulseCommand");

local NumberMinZoom = THEME:GetMetric("Combo", "NumberMinZoom");
local NumberMaxZoom = THEME:GetMetric("Combo", "NumberMaxZoom");
local NumberMaxZoomAt = THEME:GetMetric("Combo", "NumberMaxZoomAt");

local Number = THEME:GetMetric( "Protiming", "TextPulseCommand" );

local LabelMinZoom = THEME:GetMetric("Combo", "LabelMinZoom");
local LabelMaxZoom = THEME:GetMetric("Combo", "LabelMaxZoom");

local ShowFlashyCombo = false;
if GetUserPrefB("UserPrefFlashyCombo") ~= nil and GetUserPrefB("UserPrefFlashyCombo") ~= "" then
	ShowFlashyCombo = GetUserPrefB("UserPrefFlashyCombo");
end;
local p = ((player == 'PlayerNumber_P1') and 1 or 2);
--[ja] 20150619修正
local pstr = ProfIDSet(p);
local chp = ProfIDPrefCheck("CHide",pstr,"No,No,No,No");
local chps = split(",",chp);
local chpflag = 0;
if not GAMESTATE:IsDemonstration() then
	for d=1,#chps do
		if chps[d] == "Combo" then
			chpflag = 1;
			break;
		end;
	end;
end;

local t = Def.ActorFrame{};

if chpflag > 0 then return t; end;

t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(vertalign,bottom);
 	LoadActor(THEME:GetPathG("Combo","100Milestone")) .. {
		Name="OneHundredMilestone";
		InitCommand=cmd(visible,ShowFlashyCombo);
		FiftyMilestoneCommand=cmd(playcommand,"Milestone");
	};

	Def.ActorFrame {
		Name="ComboFrame";
		LoadFont( "Combo", "numbers" ) .. {
			Name="Number";
			OnCommand = THEME:GetMetric("Combo", "NumberOnCommand");
		};
		LoadActor("_combo") .. {
			Name="Label";
			OnCommand = THEME:GetMetric("Combo", "LabelOnCommand");
		};
	};

	InitCommand = function(self)
		c = self:GetChildren();
		cf = c.ComboFrame:GetChildren();
		cf.Number:visible(false);
		cf.Label:visible(false);
		lsatWorstJudge[1]=0;
		lsatWorstJudge[2]=0;
	end;
	
 	TwentyFiveMilestoneCommand=function(self,parent)
		if ShowFlashyCombo then
			(cmd(skewy,-0.125;decelerate,0.325;skewy,0))(self);
		end;
	end;
	JudgmentMessageCommand = function(self, params)
		if (params.Player == PLAYER_1 and p == 1) or (params.Player == PLAYER_2 and p == 2) then
			if params.FullComboW1 or params.TapNoteScore == 'TapNoteScore_W1' and lsatWorstJudge[p] < 1 then
				lsatWorstJudge[p] = 1;
			elseif params.FullComboW2 or params.TapNoteScore== 'TapNoteScore_W2' and lsatWorstJudge[p] < 2 then
				lsatWorstJudge[p] = 2;
			elseif params.FullComboW3 or params.TapNoteScore == 'TapNoteScore_W3' and lsatWorstJudge[p] < 3 then
				lsatWorstJudge[p] = 3;
			elseif params.FullComboW4 or params.TapNoteScore == 'TapNoteScore_W4' then
				if GetAdhocPref("GoodCombo") == "TapNoteScore_W4" then
					if lsatWorstJudge[p] < 4 then
						lsatWorstJudge[p] = 4;
					end;
				else
					lsatWorstJudge[p] = 1;
				end;
			elseif params.TapNoteScore == 'TapNoteScore_CheckpointMiss' 
			or params.TapNoteScore == 'TapNoteScore_W5' 
			or params.TapNoteScore == 'TapNoteScore_Miss' then
				lsatWorstJudge[p] = 1;
			end;
			if not params.HoldNoteScore then
				if params.TapNoteScore ~= 'TapNoteScore_AvoidMine' and params.TapNoteScore ~= 'TapNoteScore_HitMine' then
					local screen = SCREENMAN:GetTopScreen();
					if screen then
						if THEME:GetMetric( screen:GetName() , "Class" ) ~= "ScreenEdit" then
							--20160425
							if insertchecker(player,"noset","controller_auto") and GAMESTATE:GetPlayerState(player):GetPlayerController() == 'PlayerController_Autoplay' then
								aCombo[p] = aCombo[p] + 1;
							else aCombo[p] = 0;
--[[
							else
							
								if params.TapNoteScore == 'TapNoteScore_W1' or params.TapNoteScore== 'TapNoteScore_W2' or 
								params.TapNoteScore== 'TapNoteScore_W3' then
									aCombo[p] = aCombo[p] + 1;	
								elseif params.TapNoteScore == 'TapNoteScore_W4' then
									if GetAdhocPref("GoodCombo") == "TapNoteScore_W4" then
										aCombo[p] = aCombo[p] + 1;
									else aCombo[p] = 0;
									end;
								else aCombo[p] = 0;
								end;
]]
							end;
						end;
					end;
					if not aCombo[p] or aCombo[p] < ShowComboAt then
						cf.Number:visible(false);
						cf.Label:visible(false);
						return;
					end;
					cf.Label:visible(true);
					cf.Number:finishtweening();
					cf.Number:visible(true);
					cf.Number:settext( string.format("%i", aCombo[p]) );
					(cmd(stopeffect;diffuseshift;effectperiod,1;effectcolor1,color("1,1,1,1");effectcolor2,color("0.75,0.75,0.75,1");strokecolor,color("0.5,0.5,0.5,1")))(cf.Number);
					
					ANumberPulse( cf.Number, aCombo[p] );
					ALabelPulse( cf.Label, aCombo[p] );
				end;
			end;
		end;
	end;
	ComboCommand=function(self, param)
		local iCombo = param.Combo;
		if not iCombo or iCombo < ShowComboAt then
			cf.Number:visible(false);
			cf.Label:visible(false);
			return;
		end
		cf.Label:visible(false);
		
		param.Zoom = scale( iCombo, 0, NumberMaxZoomAt, NumberMinZoom, NumberMaxZoom );
		param.Zoom = clamp( param.Zoom, NumberMinZoom, NumberMaxZoom );
		
		param.LabelZoom = scale( iCombo, 0, NumberMaxZoomAt, LabelMinZoom, LabelMaxZoom );
		param.LabelZoom = clamp( param.LabelZoom, LabelMinZoom, LabelMaxZoom );

		cf.Label:visible(true);
		cf.Number:finishtweening();
		cf.Number:visible(true);
		cf.Number:settext( string.format("%i", iCombo) );

		if param.Combo and lsatWorstJudge[p] == 1 then
			(cmd(stopeffect;diffuseshift;effectperiod,1;effectcolor1,color("1,1,1,1");effectcolor2,color("0.75,0.75,0.75,1");strokecolor,color("0.5,0.5,0.5,1")))(cf.Number);
		elseif param.Combo and lsatWorstJudge[p] == 2 then
			(cmd(stopeffect;diffuse,color("1,0.9,0.3,1");strokecolor,color("0.2,0.1,0,1")))(cf.Number);
		elseif param.Combo and lsatWorstJudge[p] == 3 then
			(cmd(stopeffect;diffuse,color("0.5,1,0.4,1");strokecolor,color("0,0.2,0,1")))(cf.Number);
		elseif GetAdhocPref("GoodCombo") == "TapNoteScore_W4" then
			if param.Combo and lsatWorstJudge[p] == 4 then
				(cmd(stopeffect;diffuse,color("0.2,0.75,1,1");strokecolor,color("0,0,0.2,1")))(cf.Number);
			end;
		elseif param.Combo then
			cf.Number:stopeffect();
		else
			(cmd(stopeffect;diffuse,color("1,0,0,1");strokecolor,color("0.5,0,0,1")))(cf.Number);
			(cmd(diffuse,Color("Red");diffusebottomedge,color("0.5,0,0,1")))(cf.Label);
		end;
		NumberPulse( cf.Number, param );
		LabelPulse( cf.Label, param );
	end;
};

return t;
