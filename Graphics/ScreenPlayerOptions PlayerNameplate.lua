local pn = ...
assert( pn )

local SongOrCourse = CurSOSet();
local StepsOrTrail = CurSTSet(pn);
local bIsCourseMode = GAMESTATE:IsCourseMode();
local curStyle = GAMESTATE:GetCurrentStyle();
local stepsType = curStyle:GetStepsType();
local ccstep = GAMESTATE:GetCurrentSteps(pn)
local sstep;
local ss;
local coursesong;
local check = false;
local tempdiff;
local randomtext = THEME:GetString("MusicWheel","CustomItemRandomText");

local bpm_text_zoom = 0.5

local diff = {
	'Difficulty_Beginner',
	'Difficulty_Easy',
	'Difficulty_Medium',
	'Difficulty_Hard',
	'Difficulty_Challenge'
};


local bpm_text= "??? - ???"
local function format_bpm(bpm)
	return ("%.0f"):format(bpm)
end

local setmode = "x";
local setspeed = "100";
local song_bpms = {};

if bIsCourseMode then
	if SongOrCourse and StepsOrTrail then
		if StepsOrTrail:GetStepsType() == GAMESTATE:GetCurrentStyle():GetStepsType() then
			if StepsOrTrail:GetTrailEntries() then
				for te=1,#StepsOrTrail:GetTrailEntries() do
					if not SongOrCourse:GetCourseEntries()[te]:IsSecret() then
						local coursesong = StepsOrTrail:GetTrailEntries()[te]:GetSong();
						local sorcstep = StepsOrTrail:GetTrailEntries()[te]:GetSteps();
						if coursesong:GetOneSteps(stepsType,sorcstep:GetDifficulty()) then
							if not coursesong:IsDisplayBpmSecret() and not coursesong:IsDisplayBpmRandom() then
								check = true;
								if te == 1 then
									song_bpms[1] = math.round(coursesong:GetOneSteps(stepsType,sorcstep:GetDifficulty()):GetDisplayBpms()[1]);
									song_bpms[2] = math.round(coursesong:GetOneSteps(stepsType,sorcstep:GetDifficulty()):GetDisplayBpms()[2]);
								else
									song_bpms[1] = math.min(song_bpms[1],math.round(coursesong:GetOneSteps(stepsType,sorcstep:GetDifficulty()):GetDisplayBpms()[1]));
									song_bpms[2] = math.max(song_bpms[2],math.round(coursesong:GetOneSteps(stepsType,sorcstep:GetDifficulty()):GetDisplayBpms()[2]));
								end;
							else
								check = false;
								break;
							end;
						else
							for difflist = 1, #diff do
								if SongOrCourse:GetOneSteps(stepsType,diff[difflist]) then
									song_bpms = SongOrCourse:GetOneSteps(stepsType,diff[difflist]):GetDisplayBpms();
									check = true;
									break;
								end;
							end;
						end;
					else
						check = false;
						break;
					end;
				end;
			end;
		end;
	end;
else
	if getenv("wheelsectioncsc") ~= randomtext and getenv("rnd_song") ~= 1 then
		if SongOrCourse and StepsOrTrail then
			ss = SongOrCourse:GetStepsByStepsType( stepsType );
			if ss then
				if StepsOrTrail:GetDifficulty() == 'Difficulty_Edit' then
					for i,s in pairs(ss) do
						if s:GetDifficulty() == 'Difficulty_Edit' then
							if StepsOrTrail:GetDescription() == s:GetDescription() then
								sstep = s;
								break;
							end;
						end;
					end;
				else sstep = StepsOrTrail;
				end;
			end;
			if SongOrCourse:GetOneSteps(stepsType,sstep:GetDifficulty()) then
				if not SongOrCourse:IsDisplayBpmSecret() and not SongOrCourse:IsDisplayBpmRandom() then
					song_bpms = SongOrCourse:GetOneSteps(stepsType,sstep:GetDifficulty()):GetDisplayBpms();
					check = true;
				end;
			else
				if not SongOrCourse:IsDisplayBpmSecret() and not SongOrCourse:IsDisplayBpmRandom() then
					for difflist = 1, #diff do
						if SongOrCourse:GetOneSteps(stepsType,diff[difflist]) then
							song_bpms = SongOrCourse:GetOneSteps(stepsType,diff[difflist]):GetDisplayBpms();
							check = true;
							tempdiff = SongOrCourse:GetOneSteps(stepsType,diff[difflist]);
							break;
						end;
					end;
				end;
			end;
		end;
	end;
end;
if check then
	song_bpms[1] = math.round(song_bpms[1])
	song_bpms[2] = math.round(song_bpms[2])
	if song_bpms[1] == song_bpms[2] then
		bpm_text= format_bpm(song_bpms[1])
	else
		bpm_text= format_bpm(song_bpms[1]) .. " - " .. format_bpm(song_bpms[2])
	end;
end;

local t = Def.ActorFrame {};

local function pnToDarkColor( pn )
	local c = PlayerColor(pn)
	return { c[1], c[2], c[3], c[4]*0.3 }
end

t[#t+1] = LoadActor( THEME:GetPathB("ScreenStageInformation","in/diffback") )..{
	InitCommand=function(self)
		self:x(-3);
		self:y(6);
		self:rotationy(180);
		if pn == PLAYER_1 then
			self:glow(pnToDarkColor(pn));
		else
			self:glow(pnToDarkColor(pn));
		end;
	end;
	OnCommand=cmd(croptop,1;sleep,0.3;linear,0.2;croptop,0;);
};
local setx = {-6,6};
if pn == PLAYER_2 then
	setx = {6,-6};
end;

t[#t+1] = Def.ActorFrame {
	OnCommand=cmd(addx,setx[1];diffusealpha,0;sleep,0.45;decelerate,0.25;addx,setx[2];diffusealpha,1);
	LoadFont("_shared4") .. {
		Text=bpm_text;
		Name="BPMRangeOld",
		InitCommand=cmd(x,6;horizalign,right;maxwidth,88/bpm_text_zoom),
		OnCommand=cmd(shadowlength,1;strokecolor,Color("Black");zoom,bpm_text_zoom)
	},
	LoadFont("_shared4") .. {
		Text="1x";
		Name="BPMRate",
		InitCommand=cmd(x,10;horizalign,left;maxwidth,88/bpm_text_zoom;strokecolor,Color("Black");shadowlength,1;zoom,bpm_text_zoom);
		BPMWillNotChangeCommand=cmd(diffuse,Color("White")),
		BPMWillChangeCommand=cmd(diffuse,color("0,1,1,1")),
	},
	LoadFont("_shared4") .. {
		Text="= ";
		Name="Equals_sign",
		InitCommand=cmd(x,-40;y,10;horizalign,right;maxwidth,88/bpm_text_zoom;diffuse,Color("White");
					strokecolor,Color("Black");shadowlength,1;zoom,bpm_text_zoom);
	},
	LoadFont("_shared4") .. {
		Text="100 - 200000";
		Name="BPMRangeNew",
		InitCommand=cmd(x,-38;y,10;horizalign,left;maxwidth,88/bpm_text_zoom;strokecolor,Color("Black");shadowlength,1;zoom,bpm_text_zoom);
		BPMWillNotChangeCommand=cmd(diffuse,Color("White")),
		BPMWillChangeCommand=cmd(diffuse,color("1,0.5,0,1")),
	},
	InitCommand= function(self)
		local speed, mode= GetSpeedModeAndValueFromPoptions(pn)
		self:playcommand("SpeedChoiceChanged", {pn= pn, mode= mode, speed= speed, step= sstep})
	end;
	SpeedChoiceChangedMessageCommand= function(self, param)
		local checks = false;
		local bpmold = self:GetChild('BPMRangeOld');
		local rate = self:GetChild('BPMRate');
		local equal = self:GetChild('Equals_sign');
		local range = self:GetChild('BPMRangeNew');
		if not PREFSMAN:GetPreference("LockCourseDifficulties") then
			if param.pn ~= pn then return end
		end;
		local rntext = "";
		local ratext = "";
		local bpmtext = "";
		local no_change= true
		
		local cmode = param.mode;
		if setmode ~= param.mode then
			cmode = setmode;
		end;
		local cspeed = param.speed;
		if setspeed ~= param.speed then
			cspeed = setspeed;
		end;
		if bIsCourseMode then
			if SongOrCourse then
				if param.step then
					StepsOrTrail = param.step;
					if SongOrCourse and StepsOrTrail then
						if StepsOrTrail:GetStepsType() == GAMESTATE:GetCurrentStyle():GetStepsType() then
							if StepsOrTrail:GetTrailEntries() then
								for te=1,#StepsOrTrail:GetTrailEntries() do
									if not SongOrCourse:GetCourseEntries()[te]:IsSecret() then
										local coursesong = StepsOrTrail:GetTrailEntries()[te]:GetSong();
										local sorcstep = StepsOrTrail:GetTrailEntries()[te]:GetSteps();
										if coursesong:GetOneSteps(stepsType,sorcstep:GetDifficulty()) then
											if not coursesong:IsDisplayBpmSecret() and not coursesong:IsDisplayBpmRandom() then
												checks = true;
												if te == 1 then
													song_bpms[1] = math.round(coursesong:GetOneSteps(stepsType,sorcstep:GetDifficulty()):GetDisplayBpms()[1]);
													song_bpms[2] = math.round(coursesong:GetOneSteps(stepsType,sorcstep:GetDifficulty()):GetDisplayBpms()[2]);
												else
													song_bpms[1] = math.min(song_bpms[1],math.round(coursesong:GetOneSteps(stepsType,sorcstep:GetDifficulty()):GetDisplayBpms()[1]));
													song_bpms[2] = math.max(song_bpms[2],math.round(coursesong:GetOneSteps(stepsType,sorcstep:GetDifficulty()):GetDisplayBpms()[2]));
												end;
											else
												checks = false;
												break;
											end;
										else
											if tempdiff then
												song_bpms = SongOrCourse:GetOneSteps(stepsType,diff[difflist]):GetDisplayBpms();
												checks = true;
											end;
										end;
									else
										checks = false;
										break;
									end;
								end;
							end;
						end;
					end;
				end;
			end;
		else
			if getenv("wheelsectioncsc") ~= randomtext and getenv("rnd_song") ~= 1 then
				if SongOrCourse then
					if not SongOrCourse:IsDisplayBpmSecret() and not SongOrCourse:IsDisplayBpmRandom() then
						if param.step then
							if SongOrCourse:GetOneSteps(stepsType,param.step:GetDifficulty()) then
								song_bpms= SongOrCourse:GetOneSteps(stepsType,param.step:GetDifficulty()):GetDisplayBpms();
								checks = true;
							else
								if tempdiff then
									song_bpms = tempdiff:GetDisplayBpms();
									checks = true;
								end;
							end;
						end;
					end;
				end;
			end;
		end;
		if checks then
			song_bpms[1]= math.round(song_bpms[1])
			song_bpms[2]= math.round(song_bpms[2])
			if song_bpms[1] == song_bpms[2] then
				bpm_text= format_bpm(song_bpms[1])
			else
				bpm_text= format_bpm(song_bpms[1]) .. " - " .. format_bpm(song_bpms[2])
			end;
		end;
		if cmode == "x" then
			bpmold:visible(true);
			rate:visible(true);
			equal:visible(true);
			--20161026
			ratext= "x ".. round2(cspeed * 0.01,3)
			if bpm_text == "??? - ???" then
				rntext = "???";
				bpmtext = "???";
			else
				if song_bpms[1] == song_bpms[2] then
					rntext= format_bpm(song_bpms[1] * cspeed * 0.01)
					bpmtext = bpm_text;
				else
					rntext= format_bpm(song_bpms[1] * cspeed * 0.01) .. " - " ..
						format_bpm(song_bpms[2] * cspeed * 0.01)
					bpmtext = bpm_text;
				end
			end
			no_change= cspeed == 100
		elseif cmode == "C" then
			rate:visible(false);
			bpmold:visible(false);
			equal:visible(false);
			rntext= cmode .. cspeed
			no_change= cspeed == song_bpms[2] and song_bpms[1] == song_bpms[2]
		else
			rate:visible(false);
			bpmold:visible(false);
			equal:visible(false);
			no_change= cspeed == song_bpms[2]
			if song_bpms[1] == song_bpms[2] then
				rntext= cmode .. cspeed
			else
				local factor= song_bpms[1] / song_bpms[2]
				if not OptionRowBpmShow(coursesong) then
					rntext = cmode .. cspeed;
				else
					rntext = cmode .. format_bpm(cspeed * factor) .. " - "
						.. cmode .. cspeed
				end;
			end
		end;
		bpmold:settext(bpmtext);
		range:settext(rntext);
		rate:settext(ratext);
		if no_change then
			rate:queuecommand("BPMWillNotChange");
			range:queuecommand("BPMWillNotChange");
		else
			rate:queuecommand("BPMWillChange");
			range:queuecommand("BPMWillChange");
		end
	end;
	SpeedSaveChangedMessageCommand= function(self, param)
		if not PREFSMAN:GetPreference("LockCourseDifficulties") then
			if param.pn ~= pn then return end
		end;
		if param.speed ~= setspeed then
			setspeed = param.speed
		end;
		if param.mode ~= setmode then
			setmode = param.mode
		end;
		if bIsCourseMode then
			StepsOrTrail = GAMESTATE:GetCurrentTrail(pn);
		else
			StepsOrTrail = GAMESTATE:GetCurrentSteps(pn);
		end;
		if StepsOrTrail then
			self:playcommand("SpeedChoiceChanged", {pn= pn, mode= setmode, speed= setspeed, step= StepsOrTrail})
		end;
	end;
}

return t