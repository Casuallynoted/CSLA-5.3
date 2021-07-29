
local t = Def.ActorFrame {};

--comma_value
scf = "^(-?[ %d]+)([ %d][ %d][ %d])";
spo = ",";
spt = "y";

local stagetable = {};
setmetatable( stagetable, { __index = function() return 1 end; } );
local fcheck = 5;
local mStages = STATSMAN:GetStagesPlayed();
local v = mStages;
local showjacket = GetAdhocPref("WheelGraphics");
local extracolor = THEME:GetMetric("MusicWheel","SongRealExtraColor");
local pm = GAMESTATE:GetPlayMode();
local codechangeset = 0;
if not IsNetConnected() then
	if pm ~= 'PlayMode_Battle' and pm ~= 'PlayMode_Rave' then
		codechangeset = 1;
	end;
end;

PREFSMAN:SetPreference("AllowExtraStage",GetAdhocPref("envAllowExtraStage"));
local wcop1 = 0;
local wcop2 = 0;
local maxStages = PREFSMAN:GetPreference("SongsPerPlay");

t[#t+1] = Def.ActorFrame {
	--evaluation screenshot
	CodeMessageCommand=function(self, params)
		if params.Name == "Screenshot1" or params.Name == "Screenshot2" or 
		params.Name == "Screenshot3" or params.Name == "Screenshot4" then
			SaveScreenshot(params.PlayerNumber, false, true);
		end
	end;
};

if pm == 'PlayMode_Battle' or pm == "PlayMode_Rave" then
	for y=1,2 do
		for tipset=1,5 do
			t[#t+1] = LoadActor("win_tip")..{
				InitCommand=cmd(Center;);
				OnCommand=function(self)
					self:addy(-110);
					local wcount = split(":",getenv("WinCheckP1"));
					if y == 1 then
						self:addx(-284+((tipset-1)*33)+80);
						(cmd(diffusealpha,0;sleep,0.2*tipset;decelerate,0.3;addx,-80;diffusealpha,1;))(self)
					else
						wcount = split(":",getenv("WinCheckP2"));
						self:addx(284-((tipset-1)*33)-80);
						(cmd(rotationy,180;diffusealpha,0;sleep,0.2*tipset;decelerate,0.3;addx,80;diffusealpha,1;))(self)
					end;
					if wcount[tipset+1] == "1" then self:diffuse(color("1,1,1,1"));
					elseif wcount[tipset+1] == "0" then self:diffuse(color("1,0.5,0,1"));
					elseif wcount[tipset+1] == nil then self:diffuse(color("0.5,0.5,0.5,1"));
					else self:diffuse(color("1,0,0.4,1"));
					end;
				end;
			};
		end;
	end;
end;

while v > 0 do
	local i = 1;
	if v then i = v;
	end;
	
	local w;
	if i == mStages then w = 1;
	elseif i == mStages - 1 then w = 2;
	elseif i == mStages - 2 then w = 3;
	elseif i == mStages - 3 then w = 4;
	elseif i == mStages - 4 then w = 5;
	elseif i == mStages - 5 then w = 6;
	elseif i == mStages - 6 then w = 7;
	else w = 1;
	end;
	
	local ssStats = STATSMAN:GetPlayedStageStats( i );
	local iStage = ssStats:GetStageIndex();
	iStage = iStage + 1;
	local pStage = ssStats:GetStage();
	local sssong = ssStats:GetPlayedSongs()[1];
	local y_stable = {0,40,0,-10,-30,-50,-70};
	setmetatable( y_stable, { __index = function() return 0 end; } );
	local s_yset = y_stable[mStages] + ((mStages - i) * 50);
	
	local stageStr = "1st";
	local cStage = estage_set(w,stagetable,pStage,sssong,maxStages);

	t[#t+1] = Def.ActorFrame {
		InitCommand=function(self)
			self:Center();
			local sety = 52;
			if pm == 'PlayMode_Battle' or pm == "PlayMode_Rave" then
				sety = 30;
			end;
			self:addy(s_yset - sety);
		end;
--back
		Def.Quad{
			InitCommand=cmd(addy,2;zoomtowidth,400;diffuse,color("0,0.9,1,0.3");diffusebottomedge,color("0,0,0,0.3");fadeleft,0.3;faderight,0.3;);
			OnCommand=cmd(zoomtoheight,0;sleep,(w / 5);linear,0.2;zoomtoheight,42;);
		};

		LoadActor( "players" ) .. {
			InitCommand=cmd(addx,-218;);
			OnCommand=cmd(cropright,1;sleep,(w / 5);linear,0.2;cropright,0;);
		};
		
		LoadActor( "players" ) .. {
			InitCommand=cmd(rotationy,180;addx,218;);
			OnCommand=cmd(cropright,1;sleep,(w / 5);linear,0.2;cropright,0;);
		};
	};

	for pn in ivalues(PlayerNumber) do
		local p = ( (pn == PLAYER_1) and 1 or 2 );
		local p1str = ProfIDSet(1);
		local p2str = ProfIDSet(2);
		local pstr = ProfIDSet(p);
		local gset = judge_initial(pstr);
		local pStageStats = ssStats:GetPlayerStageStats(pn);
		local failed = pStageStats:GetFailed();
		local ppercentsc = pStageStats:GetPercentDancePoints();
		local hs = {};
		hs_local_set(hs,0);

		if pStageStats then
			if pStageStats:GetPlayedSteps()[1] then
				steps_count(hs,sssong,pStageStats:GetPlayedSteps()[1],pn,"Song");
			end;
		
			t[#t+1] = Def.ActorFrame{
				InitCommand=cmd(playcommand,"Set";);
				SetCommand=function(self)
					fcheck = 5;
					hs_set(hs,pStageStats,"pnstats");
					
					if failed then hs["Grade"] = "Grade_Failed"
					end;
					--[ja] 意図的にFailedさせた時の対策
					if iStage == mStages then
						--if pStage == "Stage_Extra1" or pStage == "Stage_Extra2" then
							if getenv("onpurposefailgradep"..p) == "Grade_Failed" then
								hs["Grade"] = "Grade_Failed";
							end;
						--end;
					end;
					fcheck = fullcombochecker(hs,0);
					if hs["Grade"] ~= "Grade_Failed" then
						hs["Grade"] = gradechecker(hs,pStageStats:GetGrade(),0,gset,fcheck);
					end;
				end;
				CodeMessageCommand=function(self,params)
					if codechangeset == 1 then
						if params.Name == "JudgeChange" then
							if params.PlayerNumber == pn then
								if gset == "ntype" then
									gset = "default";
								elseif gset == "default" then
									gset = "ntype";
								end;
								self:playcommand("Set");
							end;
						end;
					end;
				end;
			};

			local difficultyStates = {
				Difficulty_Beginner	= 0,
				Difficulty_Easy		= 2,
				Difficulty_Medium	= 4,
				Difficulty_Hard		= 6,
				Difficulty_Challenge	= 8,
				Difficulty_Edit		= 10,
			};

			t[#t+1] = Def.ActorFrame {
				InitCommand=function(self)
					(cmd(player,pn;Center))(self)
					local sety = 42;
					if pm == 'PlayMode_Battle' or pm == "PlayMode_Rave" then
						sety = 20;
					end;
					self:addy(s_yset - sety);
				end;

		--fullcombo
				Def.ActorFrame {
					InitCommand=cmd(playcommand,"Set";);
					SetCommand=function(self)
						self:visible(false);
						if fcheck > 0 and fcheck < 5 then
							self:visible(true);
							if fcheck < 3 then
								self:glowshift();
							else self:stopeffect();
							end;
						end;
					end;

					LoadActor(THEME:GetPathG("","graph_mini"))..{
						InitCommand=cmd(playcommand,"Set";);
						SetCommand=function(self)
							self:visible(false);
							if fcheck > 0 and fcheck < 5 then
								self:visible(true);
								if pn == PLAYER_1 then
									self:x(-258);
									if hs["Grade"] == "Grade_Tier01" then self:x(-258+6);
									elseif hs["Grade"] == "Grade_Tier02" then self:x(-258+1);
									end;
								else
									self:x(288);
									if hs["Grade"] == "Grade_Tier01" then self:x(288+6);
									elseif hs["Grade"] == "Grade_Tier02" then self:x(288+1);
									end;
								end;
								self:diffuse(Colors.Judgment["JudgmentLine_W"..fcheck]);
								(cmd(spin;effectmagnitude,0,0,-200;))(self)
							end;
						end;
						OnCommand=cmd(zoom,0;sleep,(w / 5) + 0.05;linear,1;zoom,0.3;rotationy,-30;rotationx,70;rotationz,100;);
						CodeMessageCommand=function(self,params)
							if codechangeset == 1 then
								if params.Name == "JudgeChange" then
									if params.PlayerNumber == pn then
										self:playcommand("Set");
									end;
								end;
							end;
						end;
					};
					LoadActor(THEME:GetPathG("","graph_mini"))..{
						InitCommand=cmd(playcommand,"Set";);
						SetCommand=function(self)
							self:visible(false);
							if fcheck > 0 and fcheck < 5 then
								self:visible(true);
								if pn == PLAYER_1 then
									self:x(-258);
									if hs["Grade"] == "Grade_Tier01" then self:x(-258+6);
									elseif hs["Grade"] == "Grade_Tier02" then self:x(-258+1);
									end;
								else
									self:x(288);
									if hs["Grade"] == "Grade_Tier01" then self:x(288+6);
									elseif hs["Grade"] == "Grade_Tier02" then self:x(288+1);
									end;
								end;
								self:diffuse(Colors.Judgment["JudgmentLine_W"..fcheck]);
								(cmd(spin;effectmagnitude,60,100,-200;))(self)
							end;
						end;
						OnCommand=cmd(zoom,0;sleep,(w / 5) + 0.05;linear,1;zoom,0.3;rotationy,30;rotationx,70;rotationz,100;);
						CodeMessageCommand=function(self,params)
							if codechangeset == 1 then
								if params.Name == "JudgeChange" then
									if params.PlayerNumber == pn then
										self:playcommand("Set");
									end;
								end;
							end;
						end;
					};
				};

		--score 
				LoadFont( "_numbers4" ) .. {
					InitCommand=function(self)
						self:visible(false);
						self:zoom(0.425);
						self:y(-2);
						self:skewx(-0.2);
						self:diffuse(color("0,1,1,1"));
						self:strokecolor(color("0,0.4,0.4,1"));
						if GAMESTATE:GetPlayMode() ~= "PlayMode_Rave" and GAMESTATE:GetPlayMode() ~= "PlayMode_Battle" then
							self:visible(true);
							if pn == PLAYER_1 then
								self:addx(-183);
							else self:addx(183);
							end;
							self:settext( comma_value(string.format("%9d",hs["Score"]),scf,spo,spt) );
						end;
					end;
					OnCommand=cmd(zoomy,0;sleep,(w / 5) + 0.15;linear,0.2;zoomy,0.425;);
				};
		--percentscore
				LoadFont( "_numbers4" ) .. {
					InitCommand=function(self)
						self:visible(false);
						self:addy(-16);
						self:zoom(0.5);
						self:skewx(-0.2);
						self:horizalign(right);
						self:diffuse(color("0,1,1,1"));
						self:strokecolor(color("0,0.4,0.4,1"));
						if pm ~= "PlayMode_Rave" and pm ~= "PlayMode_Battle" then
							self:visible(true);
							--self:settext("51.25");
							if hs["PercentScore"] == 1 then self:settext("100");
							elseif hs["PercentScore"] == 0 then self:settext("0");
							else self:settextf("%.2f", hs["PercentScore"] * 100 );
							end;
							if pn == PLAYER_1 then
								self:addx(-132);
							else self:addx(182);
							end
						end;
					end;
					OnCommand=cmd(zoomy,0;sleep,(w / 5) + 0.15;linear,0.2;zoomy,0.5;);
				};
				LoadFont("_numbers4")..{
					InitCommand=function(self)
						self:visible(false);
						if pm ~= 'PlayMode_Battle' and pm ~= "PlayMode_Rave" then 
							(cmd(visible,true;addy,-13;horizalign,right;settext,"%";zoom,0.3;skewx,-0.2;))(self)
							if pn == PLAYER_1 then
								self:x(-132+11);
							else self:x(182+11);
							end;
							self:diffuse(color("0,1,1,1"));
							self:strokecolor(color("0,0.4,0.4,1"));
						end;
					end;
					OnCommand=cmd(zoomy,0;sleep,(w / 5) + 0.15;linear,0.2;zoomy,0.3;);
				};

		--grade
				Def.Sprite{
					InitCommand=cmd(playcommand,"Set";);
					SetCommand=function(self)
						self:visible(false);
						if pm ~= 'PlayMode_Battle' and pm ~= "PlayMode_Rave" then 
							self:visible(true);
							self:zoom(0.45);
							self:y(-10);
							if hs["Grade"] ~= "Grade_None" then
								self:visible(true);
								self:Load(THEME:GetPathG("GradeDisplayEval",ToEnumShortString( hs["Grade"] )));
								if pn == PLAYER_1 then self:x(-273);
								else self:x(273);
								end;
							end;
						end;
					end;
					OnCommand=cmd(zoomy,0;sleep,(w / 5) + 0.15;linear,0.2;zoomy,0.45;);
					CodeMessageCommand=function(self,params)
						if codechangeset == 1 then
							if params.Name == "JudgeChange" then
								if params.PlayerNumber == pn then
									self:playcommand("Set");
								end;
							end;
						end;
					end;
				};
		--difficulty
				LoadActor(THEME:GetPathG("DiffDisplay","frame/gameplay_frame"))..{
					InitCommand=function(self)
						(cmd(animate,false;setstate,0;zoom,0.65;addy,-18))(self)
						if pStageStats:GetPlayedSteps()[1] then
							local pDifficulty = pStageStats:GetPlayedSteps()[1]:GetDifficulty();
							local state = difficultyStates[pDifficulty];
							if pn == PLAYER_2 then
								state = state + 1;
								self:horizalign(right);
								if pm == 'PlayMode_Battle' or pm == "PlayMode_Rave" then
									self:addx(210);
									self:addy(8);
								else self:addx(252);
								end;
							else
								self:horizalign(left);
								if pm == 'PlayMode_Battle' or pm == "PlayMode_Rave" then
									self:addx(-210);
									self:addy(8);
								else self:addx(-252);
								end;
							end;
							self:setstate(state);
						end;
					end;
					OnCommand=cmd(zoomy,0;sleep,(w / 5) + 0.175;linear,0.2;zoomy,0.65;);
				};
				
				LoadFont("StepsDisplay meter")..{
					InitCommand=function(self)
						if pn == PLAYER_1 then
							self:horizalign(right);
							if pm == 'PlayMode_Battle' or pm == "PlayMode_Rave" then
								self:x(-158);
								self:addy(8);
							else self:x(-200);
							end;
						else
							self:horizalign(left);
							if pm == 'PlayMode_Battle' or pm == "PlayMode_Rave" then
								self:x(158);
								self:addy(8);
							else self:x(200);
							end;
						end;
						(cmd(maxwidth,66;zoom,0.4;addy,-18;skewx,-0.5;shadowlength,2;playcommand,"Set";))(self)
					end;
					OnCommand=cmd(zoomy,0;sleep,(w / 5) + 0.175;linear,0.2;zoomy,0.4;);
					SetCommand=function(self)
						if pStageStats:GetPlayedSteps()[1] then
							local step = pStageStats:GetPlayedSteps()[1];
							local meter = 0;
							if step then
								meter = step:GetMeter();
							end;
							if GetAdhocPref("UserMeterType") == "CSStyle" then
								if selection ~= "Difficulty_Edit" then
									meter = GetConvertDifficulty(sssong,step:GetDifficulty());
								else
									meter = GetConvertDifficulty(sssong,"Difficulty_Edit",step);
								end;
							end;
							self:settextf("%i",meter);
							--self:settext("22");
							self:strokecolor(DifficultyToDarkColor(step:GetDifficulty()));
							self:diffuse(Colors.Difficulty[step:GetDifficulty()]);
						end;
					end;
				};
				
				LoadFont("_shared4") .. {
					InitCommand=cmd(zoom,0.45;strokecolor,color("0.3,0.3,0.3,0.75");horizalign,right;vertalign,bottom;y,-33);
					BeginCommand=cmd(playcommand,"Set");
					SetCommand=function(self)
						if pm ~= 'PlayMode_Battle' and pm ~= "PlayMode_Rave" then 
							if i == mStages then
								self:visible(true);
								if pn == PLAYER_1 then self:x(-223);
								else self:x(302);
								end;
								if gset == "ntype" then
									self:diffuse(color("1,1,0,1"));
									self:settext(THEME:GetString( "OptionExplanations","CSGrade" ));
								else
									self:diffuse(color("0,1,1,1"));
									self:settext(THEME:GetString( "OptionExplanations","SMGrade" ));
								end;
							else self:visible(false);
							end;
						else self:visible(false);
						end;
					end;
					OnCommand=cmd(zoomy,0;sleep,0.5;accelerate,0.15;zoomy,0.45;);
					CodeMessageCommand=function(self,params)
						if codechangeset == 1 then
							if params.Name == "JudgeChange" then
								if params.PlayerNumber == pn then
									self:playcommand("Set");
								end;
							end;
						end;
					end;
					OffCommand=function(self)
						if not IsNetConnected() then
							if codechangeset == 1 then
								if pn == PLAYER_1 then
									SetAdhocPref("JudgeSet",gset,p1str);
								else SetAdhocPref("JudgeSet",gset,p2str);
								end;
							end;
						end;
					end;
				};
			};
		end;
	end;

	if pm == 'PlayMode_Battle' or pm == "PlayMode_Rave" then 
		for x=1,2 do
			--windisplay
			t[#t+1] = Def.Sprite{
				InitCommand=function(self)
					(cmd(Center;playcommand,"Set"))(self)
					self:addy(s_yset - 20);
				end;
				SetCommand=function(self)
					local wcount = split(":",getenv("WinCheckP"..x));
					self:zoom(0.45);
					self:addy(-10);
					if x == 1 then self:addx(-250);
					else self:addx(250);
					end;
					if wcount[iStage+1] == "1" then
						self:Load(THEME:GetPathG("ScreenEvaluation","WinDisplay/win"));
						if x == 1 then wcop1 = wcop1 + 1;
						else wcop2 = wcop2 + 1;
						end;
					elseif wcount[iStage+1] == "0" then self:Load(THEME:GetPathG("ScreenEvaluation","WinDisplay/draw"));
					else self:Load(THEME:GetPathG("ScreenEvaluation","WinDisplay/lose"));
					end;
				end;
				OnCommand=cmd(zoomy,0;sleep,(w / 5) + 0.15;linear,0.2;zoomy,0.45;);
			};
		end;
	end;
	
	local function Imgaddy(song)
		if song then
			if showjacket ~= "Off" then
				if song:HasJacket() then return -2
				elseif song:HasBanner() then return 0
				elseif song:HasCDImage() then return -2
				elseif song:HasBackground() then return -2
				end
			elseif song:HasBanner() then return -2
			end
		end
		return -2;
	end;

	t[#t+1] = Def.ActorFrame {
		InitCommand=function(self)
			local sety = 50;
			if pm == 'PlayMode_Battle' or pm == "PlayMode_Rave" then
				sety = 28;
			end;
			self:Center();
			self:addy(s_yset - sety);
		end;
--banner
		Def.Banner {
			InitCommand=function(self)
				self:addx(-112);
				self:horizalign(left);
				self:Load(GetSongImage(sssong));
				if GetSongImage(sssong) == sssong:GetBannerPath() then
					self:diffuserightedge(color("0,0,0,0"));
				end;
				(cmd(zoomtowidth,GetSongImageSize(sssong,"summary")[1];zoomtoheight,0;sleep,(w / 5) + 0.1;
				linear,0.2;addy,Imgaddy(sssong);zoomtoheight,GetSongImageSize(sssong,"summary")[2];))(self)
			end;
		};
--title
		Def.TextBanner {
			InitCommand=cmd(Load,"EvaluationTextBanner";SetFromString,"", "", "", "", "", "";);
			OnCommand=function(self)
				(cmd(zoom,0.65;addx,-50;zoomy,0;sleep,(w / 5) + 0.125;linear,0.2;zoomy,0.65))(self)
				if sssong then
					--20170919
					self:visible(true);
					sgbtsetting(self,sssong,pStage,mStages,maxStages);
				else self:visible(false);
				end;
			end;
		};
--stage
		Def.Sprite{
			InitCommand=function(self)
				self:shadowlength(2);
				self:zoom(0.45);
				self:addx(-120);
				self:horizalign(left);
				self:addy(-23);
				self:Load(THEME:GetPathB("ScreenStageInformation","in/stageregular_effect/_label "..cStage));
			end;
			OnCommand=cmd(zoomy,0;sleep,(w / 5) + 0.15;linear,0.2;zoomy,0.45;);
		};
	};

	v = v - 1;
end;

return t