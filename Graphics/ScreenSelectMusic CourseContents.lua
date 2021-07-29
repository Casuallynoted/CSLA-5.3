
local st = GAMESTATE:GetCurrentStyle():GetStepsType();
local lockdiff;
if vcheck() ~= "beta4" then
	lockdiff = PREFSMAN:GetPreference("LockCourseDifficulties");
else lockdiff = true;
end;
--SCREENMAN:SystemMessage(vcheck());

local pnflag = 0;
local playerset = "PlayerNumber_P1";
if lockdiff then
	playerset = GAMESTATE:GetMasterPlayerNumber();
end;
if GAMESTATE:IsHumanPlayer(PLAYER_1) and not GAMESTATE:IsHumanPlayer(PLAYER_2) then
	pnflag = 1;
elseif GAMESTATE:IsHumanPlayer(PLAYER_2) and not GAMESTATE:IsHumanPlayer(PLAYER_1) then
	pnflag = 2;
else
	pnflag = 3;
end;

local difficultyToFrame = {
	Difficulty_Beginner	= 0,
	Difficulty_Easy		= 2,
	Difficulty_Medium	= 4,
	Difficulty_Hard		= 6,
	Difficulty_Challenge	= 8,
	Difficulty_Edit		= 10,
};

local t = Def.ActorFrame{};

t[#t+1] = Def.Quad {
	InitCommand=cmd(zoomto,SCREEN_WIDTH,73;diffuse,color("0,0,0,0.4"););
	ShowCommand=cmd(finishtweening;cropleft,1;sleep,0.2;linear,0.15;cropleft,0;);
};

t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(rotationz,-90;x,274;zoom,0.9;);
	--20161126
	CurrentSongChangedMessageCommand=function(self)
		self:visible(false);
		if getenv("wheelstop") == 1 then self:visible(true);
		end;
	end;

	Def.CourseContentsList {
		--CourseContents Main
		MaxSongs = 50;
		NumItemsToDraw = math.floor(SCREEN_WIDTH/90);
		ShowCommand=function(self)
			--20160710
			local coursestages = 0;
			if GAMESTATE:GetCurrentCourse() then
				coursestages = GAMESTATE:GetCurrentCourse():GetEstimatedNumStages();
			end;
			self:finishtweening();
			self:SetDestinationItem(0);
			self:SetCurrentAndDestinationItem(2);
			self:SetFromGameState();
			self:PositionItems();
			self:SetTransformFromHeight(202);
			self:SetLoop(false);
		
			if GAMESTATE:GetPlayMode() == 'PlayMode_Endless' then
				self:setsecondsperitem(0);
				self:stoptweening();
			elseif coursestages < 3 or coursestages == nil then
				self:setsecondsperitem(0);
				self:stoptweening();
			else
				self:sleep(2.5);
				self:queuecommand("ScrollDown");
			end;
		end;
		ScrollDownCommand = function(self)
			local coursestages = GAMESTATE:GetCurrentCourse():GetEstimatedNumStages();
			self:finishtweening();
			self:setsecondsperitem(1);
			self:SetDestinationItem(self:GetNumItems());
			self:sleep(math.min(coursestages,10)*2-2.5);
			self:SetSecondsPauseBetweenItems(1);
			self:queuecommand("ScrollUp");
		end;
		ScrollUpCommand = function(self)
			self:finishtweening();
			self:setsecondsperitem(0.0001);
			self:SetDestinationItem(0);
			self:SetCurrentAndDestinationItem(2);
			self:sleep(2.5);
			self:queuecommand("ScrollDown");
		end;
		CurrentTrailP1ChangedMessageCommand=function(self)
			self:SetCurrentAndDestinationItem(2);
			self:PositionItems();
			self:playcommand("Show");
		end;
		CurrentTrailP2ChangedMessageCommand=function(self)
			self:SetCurrentAndDestinationItem(2);
			self:PositionItems();
			self:playcommand("Show");
		end;

		--Parts
		Display = Def.ActorFrame {
			InitCommand=cmd(setsize,0,0;);

			Def.Quad {
				InitCommand=cmd(zoomto,81,200;diffuse,color("0,0.5,0.7,0.7");diffuseleftedge,color("0,0,0,0.5");diffusebottomedge,color("0,0,0,0.8"););
				ShowCommand=cmd(finishtweening;croptop,1;sleep,0.2;accelerate,0.15;croptop,0;);
			};

			Def.Sprite {
				ShowCommand=cmd(rotationz,90;diffusealpha,0;x,-8;y,54;accelerate,0.3;x,0;diffusealpha,1;);
				SetSongCommand=function(self, params)
					self:finishtweening();
					if getenv("wheelstop") == 1 then
						if GAMESTATE:GetPlayMode() ~= 'PlayMode_Endless' then
							self:diffuse(color("1,1,1,1"));
							self:diffusebottomedge(color("1,1,1,1"));
							--self:diffuseleftedge(color("1,1,1,0.8"));
							local song = params.Song;
							local showjacket = GetAdhocPref("WheelGraphics");
							local path = THEME:GetPathG("Common","fallback jacket");
							local zoom = 80;
							if not GAMESTATE:GetCurrentCourse():GetCourseEntries()[params.Number]:IsSecret() then
								if song then
									local jacketpath = song:GetJacketPath();
									local sbannerpath = song:GetBannerPath();
									local cdimagepath = song:GetCDImagePath();
									local sbackgroundpath = song:GetBackgroundPath();
									if showjacket == "On" or showjacket == "Default" or
									showjacket == "Jacket" or showjacket == "BackGround" then
										if song:HasJacket() then 
											path = jacketpath;
											self:diffusebottomedge(color("0.3,0.3,0.3,1"));
										elseif song:HasBanner() then
											path = sbannerpath;
											zoom = 25;
										elseif song:HasBackground() then
											path = sbackgroundpath;
										elseif song:HasCDImage() then
											path = cdimagepath;
										end;
									elseif showjacket == "Banner" then
										if song:HasBanner() then
											path = sbannerpath;
											zoom = 25;
										elseif song:HasJacket() then 
											path = jacketpath;
											self:diffusebottomedge(color("0.3,0.3,0.3,1"));
										elseif song:HasBackground() then
											path = sbackgroundpath;
										elseif song:HasCDImage() then
											path = cdimagepath;
										end;
									else
										zoom = 25;
									end;
								end;
							end;
							self:Load(path);
							self:zoomtowidth(80);
							self:zoomtoheight(zoom);
						end;
					end;
				end;
			};

			LoadFont("_um") .. {
				InitCommand=cmd(rotationz,90;x,14;y,-92;horizalign,left;skewx,-0.125;zoom,1.65;maxwidth,50;diffuse,color("0,0,0,0.45");strokecolor,color("1,0.5,0,0.45"););
				ShowCommand=cmd(diffusealpha,0;addy,-10;accelerate,0.3;diffusealpha,1;addy,10;);
				SetSongCommand=function(self, params)
					self:finishtweening();
					if getenv("wheelstop") == 1 then
						self:visible(true);
						local numStages = GAMESTATE:GetCurrentCourse():GetEstimatedNumStages();
						if params.Number <= numStages then
							self:settext(string.format("%i", params.Number)); 
						end;
					end;
				end;
			};
			
		--p1side
			LoadActor( THEME:GetPathB("ScreenStageInformation","in/diffback") )..{
				InitCommand=function(self)
					self:x(22-5);
					if #GAMESTATE:GetHumanPlayers() == 1 then
						self:x(0-5);
					end;
				end;
				ShowCommand=cmd(croptop,1;addx,10;accelerate,0.3;croptop,0;addx,-10;);
				SetSongCommand=function(self, params)
					self:visible(false);
					--[ja] 難易度固定時は非表示
					if not lockdiff and pnflag == 3 then
						if getenv("wheelstop") == 1 then
							(cmd(visible,true;rotationz,90;y,-88;zoom,0.65;shadowlength,2;horizalign,left;glow,pnToDarkColor(PLAYER_1)))(self)
						end;
					end;
				end;
			};
			LoadActor( THEME:GetPathG("DiffDisplay","frame/gameplay_frame") )..{
				InitCommand=cmd(rotationz,90;y,-68;zoom,0.675;shadowlength,2;horizalign,left;animate,false);
				ShowCommand=cmd(diffusealpha,0;addx,-10;accelerate,0.3;diffusealpha,1;addx,10;);
				SetSongCommand=function(self, params)
					self:visible(false);
					self:finishtweening();
					self:x(23);
					if #GAMESTATE:GetHumanPlayers() == 1 or lockdiff then
						self:x(1);
					end;
					--[ja] 難易度固定時1P側はON
					if (pnflag == 1 or pnflag == 3) or (lockdiff and pnflag == 2) then
						local trail;
						if getenv("wheelstop") == 1 then
							trail = GAMESTATE:GetCurrentTrail(playerset);
							if trail then
								if trail:GetTrailEntries()[params.Number] then
									if trail:GetTrailEntries()[params.Number]:GetSteps():GetDifficulty() then
										self:visible(true);
										self:setstate(difficultyToFrame[trail:GetTrailEntries()[params.Number]:GetSteps():GetDifficulty()]);
									end;
								end;
							end;
						end;
					end;
				end;
			};
			LoadFont("StepsDisplay meter") .. {
				InitCommand=cmd(rotationz,90;y,-32;shadowlength,2;zoom,0.675;horizalign,left;skewx,-0.5;maxwidth,60);
				ShowCommand=cmd(diffusealpha,0;addy,10;accelerate,0.3;diffusealpha,1;addy,-10;);
				SetSongCommand=function(self, params)
					self:x(27);
					if #GAMESTATE:GetHumanPlayers() == 1 or lockdiff then
						self:x(5);
					end;
					self:visible(false);
					self:finishtweening();
					if (pnflag == 1 or pnflag == 3) or (lockdiff and pnflag == 2) then
						local song;
						local trail;
						local tstep;
						local meter = 0;
						if getenv("wheelstop") == 1 then
							song = params.Song;
							trail = GAMESTATE:GetCurrentTrail(playerset);
							if song then
								if trail then
									if trail:GetTrailEntries()[params.Number] then
										if song:HasStepsTypeAndDifficulty(st,trail:GetTrailEntries()[params.Number]:GetSteps():GetDifficulty()) then
											tstep = trail:GetTrailEntries()[params.Number]:GetSteps();
										end;
									end;
									if tstep then
										self:visible(true);
										if not GAMESTATE:GetCurrentCourse():GetCourseEntries()[params.Number]:IsSecret() then
											if GetAdhocPref("UserMeterType") == "CSStyle" then
												if tstep:GetDifficulty() ~= "Difficulty_Edit" then
													meter = GetConvertDifficulty(song,tstep:GetDifficulty());
												else
													meter = GetConvertDifficulty(song,"Difficulty_Edit",tstep);
												end;
											else
												meter = params.Meter
											end;
											self:settextf("%d",meter);
										else self:settext("?");
										end;
										self:diffuse(CustomDifficultyToColor(tstep:GetDifficulty()));
										self:strokecolor(CustomDifficultyToDarkColor(tstep:GetDifficulty()));
									end;
								end;
							end;
						end;
					end;
				end;
			};
			
		--p2side
			LoadActor( THEME:GetPathB("ScreenStageInformation","in/diffback") )..{
				InitCommand=function(self)
					self:x(-4-5);
					if #GAMESTATE:GetHumanPlayers() == 1 then
						self:x(0-5);
					end;
				end;
				ShowCommand=cmd(croptop,1;addx,10;accelerate,0.3;croptop,0;addx,-10;);
				SetSongCommand=function(self, params)
					self:visible(false);
					--[ja] 難易度固定時は非表示
					if not lockdiff and pnflag == 3 then
						if getenv("wheelstop") == 1 then
							(cmd(visible,true;rotationz,90;y,-88;zoom,0.65;shadowlength,2;horizalign,left;glow,pnToDarkColor(PLAYER_2)))(self)
						end;
					end;
				end;
			};
			LoadActor( THEME:GetPathG("DiffDisplay","frame/gameplay_frame") )..{
				InitCommand=cmd(rotationz,90;y,-68;zoom,0.675;shadowlength,2;horizalign,left;animate,false);
				ShowCommand=cmd(diffusealpha,0;addx,-10;accelerate,0.3;diffusealpha,1;addx,10;);
				SetSongCommand=function(self, params)
					self:visible(false);
					self:finishtweening();
					self:x(-3);
					if #GAMESTATE:GetHumanPlayers() == 1 then
						self:x(1);
					end;
					--[ja] 難易度固定時2P側はOFF
					if (not lockdiff and (pnflag == 2 or pnflag == 3)) then
						local trail;
						if getenv("wheelstop") == 1 then
							trail = GAMESTATE:GetCurrentTrail(PLAYER_2);
							if trail then
								if trail:GetTrailEntries()[params.Number] then
									if trail:GetTrailEntries()[params.Number]:GetSteps():GetDifficulty() then
										self:visible(true);
										self:setstate(difficultyToFrame[trail:GetTrailEntries()[params.Number]:GetSteps():GetDifficulty()]);
									end;
								end;
							end;
						end;
					end;
				end;
			};
			LoadFont("StepsDisplay meter") .. {
				InitCommand=cmd(rotationz,90;y,-32;shadowlength,2;zoom,0.675;horizalign,left;skewx,-0.5;maxwidth,60);
				ShowCommand=cmd(diffusealpha,0;addy,10;accelerate,0.3;diffusealpha,1;addy,-10;);
				SetSongCommand=function(self, params)
					self:visible(false);
					self:finishtweening();
					self:x(1);
					if #GAMESTATE:GetHumanPlayers() == 1 then
						self:x(5);
					end;
					if (not lockdiff and (pnflag == 2 or pnflag == 3)) then
						local song;
						local trail;
						local tstep;
						local meter = 0;
						if getenv("wheelstop") == 1 then
							song = params.Song;
							trail = GAMESTATE:GetCurrentTrail(PLAYER_2);
							if song then
								if trail then
									if trail:GetTrailEntries()[params.Number] then
										if song:HasStepsTypeAndDifficulty(st,trail:GetTrailEntries()[params.Number]:GetSteps():GetDifficulty()) then
											tstep = trail:GetTrailEntries()[params.Number]:GetSteps();
										end;
									end;
									if tstep then
										self:visible(true);
										if not GAMESTATE:GetCurrentCourse():GetCourseEntries()[params.Number]:IsSecret() then
											if GetAdhocPref("UserMeterType") == "CSStyle" then
												if tstep:GetDifficulty() ~= "Difficulty_Edit" then
													meter = GetConvertDifficulty(song,tstep:GetDifficulty());
												else
													meter = GetConvertDifficulty(song,"Difficulty_Edit",tstep);
												end;
											else
												meter = params.Meter
											end;
											self:settextf("%d",meter);
										else self:settext("?");
										end;
										self:diffuse(CustomDifficultyToColor(tstep:GetDifficulty()));
										self:strokecolor(CustomDifficultyToDarkColor(tstep:GetDifficulty()));
									end;
								end;
							end;
						end;
					end;
				end;
			};
			
			Def.ActorFrame {
				ShowCommand=cmd(rotationz,90;x,38;y,-132;zoomy,0;sleep,0.2;linear,0.1;zoomy,1;);
				Def.TextBanner {
					InitCommand=cmd(x,32;y,68;Load,"CourseTextBanner";SetFromString,"", "", "", "", "", "");
					SetSongCommand=function(self, params)
						self:finishtweening();
						self:SetFromString( "??????????", "??????????", "", "", "", "" );
						if getenv("wheelstop") == 1 then
							self:diffuse( color("#FFFFFF") );
							if params.Song then
								if not GAMESTATE:GetCurrentCourse():GetCourseEntries()[params.Number]:IsSecret() then
									self:SetFromSong( params.Song );
									--20170114
									--self:SetFromString( params.Song:GetDisplayMainTitle(), params.Song:GetTranslitMainTitle(), params.Song:GetDisplaySubTitle(), 
									--params.Song:GetTranslitSubTitle(), params.Song:GetDisplayArtist(), params.Song:GetTranslitArtist() );
									self:diffuse( SONGMAN:GetSongColor(params.Song) );
									local sectioncolorlist = getenv("sectioncolorlist");
									local sdirs = split("/",params.Song:GetSongDir());
									if sectioncolorlist ~= "" then
										if sectioncolorlist[params.Song:GetGroupName().."/"..sdirs[4]] then
											self:diffuse(color(sectioncolorlist[params.Song:GetGroupName().."/"..sdirs[4]]));
										elseif sectioncolorlist[params.Song:GetGroupName()] then
											self:diffuse(color(sectioncolorlist[params.Song:GetGroupName()]));
										end;
									end;
								end;
							end
						end;
						(cmd(zoom,0.75))(self);
					end;
				};
			};

			LoadActor( THEME:GetPathG("StepsDisplay","autogen") )..{
				InitCommand=cmd(rotationz,90;x,-14;y,-42;zoom,0.85;shadowlength,2;);
				ShowCommand=cmd(zoomy,0;sleep,0.2;linear,0.2;zoomy,0.85;);
				SetSongCommand=function(self, params)
					self:finishtweening();
					if getenv("wheelstop") == 1 then
						if params.Steps:IsAutogen() then
							self:visible(true);
							self:finishtweening();
							(cmd(glowshift;effectcolor1,color("0.7,1,0,0.5");effectcolor2,color("1,1,1,0");effectperiod,1))(self);
						else
							self:visible(false);
							self:finishtweening();
						end;
					end;
				end;
			};
			LoadActor( THEME:GetPathB("","arrow") )..{
				SetSongCommand=function(self, params)
					self:finishtweening();
					if getenv("wheelstop") == 1 then
						local coursestages = GAMESTATE:GetCurrentCourse():GetEstimatedNumStages();
						if params.Number > 1 and params.Number <= coursestages then self:visible(true);
						else self:visible(false);
						end;
					end;
				end;
				ShowCommand=cmd(rotationz,90;x,20;y,-98;rotationz,90;diffusealpha,0;sleep,0.5;queuecommand,"Repeat";);
				ScrollDownCommand=cmd(queuecommand,"Repeat";);
				ScrollUpCommand=cmd(queuecommand,"Repeat";);
				RepeatCommand=cmd(addy,-12;diffusealpha,1;glow,color("1,0.7,0,1");linear,1;glow,color("0,0,0,0");addy,12;diffusealpha,0;queuecommand,"Repeat";);
			};
		};
	};
};
return t;