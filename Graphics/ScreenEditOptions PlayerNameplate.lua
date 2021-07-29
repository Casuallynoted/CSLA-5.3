--20160430
local pn = ...
assert( pn )

local SongOrCourse = CurSOSet();
local StepsOrTrail;
local curStyle = GAMESTATE:GetCurrentStyle();
local stepsType = curStyle:GetStepsType();
local ccstep = GAMESTATE:GetCurrentSteps(pn);
local ps = GAMESTATE:GetPlayerState(pn);
local sstep;
local ss;
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
local song_bpms = 0;

local function get_bpm(ostep,cbeat)
	return ostep:GetTimingData():GetBPMAtBeat(cbeat);
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
	BeginCommand= function(self)
		StepsOrTrail = CurSTSet(pn);
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
			if sstep then
				song_bpms = get_bpm(sstep,0);
				check = true;
			end;
		end;

		if check then
			song_bpms = math.round(song_bpms)
			bpm_text= format_bpm(song_bpms)
		end;
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
		local c_beat = 0;
		if SCREENMAN:GetTopScreen() then
			--c_beat = tonumber(split("\n",SCREENMAN:GetTopScreen():GetChild("CurrentBeat"):GetText())[2]);
		end;
		
		local cmode = param.mode;
		local cspeed = param.speed;
		if SongOrCourse then
			if param.step then
				if SongOrCourse:GetOneSteps(stepsType,param.step:GetDifficulty()) then
					song_bpms = get_bpm(sstep,tonumber(getenv("edit_c_beat")));
					checks = true;
				end;
			end;
		end;
		if checks then
			song_bpms = math.round(song_bpms)
			bpm_text= format_bpm(song_bpms)
		end;
		if cmode == "x" then
			bpmold:visible(true);
			rate:visible(true);
			equal:visible(true);
			ratext= "x ".. cspeed * 0.01
			if bpm_text == "??? - ???" then
				rntext = "???";
				bpmtext = "???";
			else
				rntext= format_bpm(song_bpms * cspeed * 0.01)
				bpmtext = bpm_text;
			end
			no_change= cspeed == 100
		elseif cmode == "C" then
			rate:visible(false);
			bpmold:visible(false);
			equal:visible(false);
			rntext= cmode .. cspeed
			no_change= cspeed == song_bpms and song_bpms == song_bpms
		else
			rate:visible(false);
			bpmold:visible(false);
			equal:visible(false);
			no_change= cspeed == song_bpms
			rntext= cmode .. cspeed
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
		StepsOrTrail = GAMESTATE:GetCurrentSteps(pn);
		if StepsOrTrail then
			self:playcommand("SpeedChoiceChanged", {pn= pn, mode= setmode, speed= setspeed, step= StepsOrTrail})
		end;
	end;
}

return t