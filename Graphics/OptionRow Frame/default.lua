
local t = Def.ActorFrame{};

local smeu_color = "0,0.6,0.6,0.7";
local cs_color = "1,0.8,0,0.7";

local kis_string = THEME:GetString("OptionTitles","Key/Input/Sound Options");
local db_string = THEME:GetString("OptionTitles","Display/Background Options");
local gljs_string = THEME:GetString("OptionTitles","Gameplay/Life/Judge/Section Options");
local ti_select_string = THEME:GetString("OptionTitles","Credits Select");
local ti_string = THEME:GetString("OptionTitles","Credits");
local ti_n_string = THEME:GetString("OptionTitles","Credits (Normal)");
local ti_s_string = THEME:GetString("OptionTitles","Credits (Special)");
local st_string = THEME:GetString("OptionTitles","Steps");
local sgf_string = THEME:GetString("OptionTitles","Select Game Frame");
local randomtext = THEME:GetString("MusicWheel","CustomItemRandomText");

local difficultyStates = {
	Difficulty_Beginner	= 0,
	Difficulty_Easy		= 2,
	Difficulty_Medium	= 4,
	Difficulty_Hard		= 6,
	Difficulty_Challenge	= 8,
	Difficulty_Edit		= 10,
};

t[#t+1] = LoadActor("highlight") .. {
	InitCommand=cmd(x,-54;);
	GainFocusCommand=cmd(stoptweening;diffuse,color("1,0.8,1,1"));
	LoseFocusCommand=cmd(stoptweening;decelerate,0.1;diffuse,color("0,0,0,0");stopeffect;);
};

t[#t+1] = LoadActor("bullet1") .. {
	OnCommand=function(self)
		self:shadowlength(2);
		local rtitle = self:GetParent():GetParent():GetChild("Title");
		if rtitle then
			if rtitle:GetText() == kis_string or rtitle:GetText() == db_string or rtitle:GetText() == gljs_string then
				self:glow(color(smeu_color));
			end;
			if optionrowcolorcheck(rtitle:GetText()) then
				self:glow(color(cs_color));	
			end;
		else self:glow(color("0,0.4,0.4,0.3"));
		end;
	end;
	GainFocusCommand=cmd(stoptweening;zoom,1.15;decelerate,0.2;glow,color("1,0.4,0,0.9"););
	LoseFocusCommand=function(self)
		local rtitle = self:GetParent():GetParent():GetChild("Title");
		local glowset = "0,0.4,0.4,0.3";
		if rtitle then
			if rtitle:GetText() == kis_string or rtitle:GetText() == db_string or rtitle:GetText() == gljs_string then
				glowset = smeu_color;
			end;
			if optionrowcolorcheck(rtitle:GetText()) then
				glowset = cs_color;
			end;
		end;
		(cmd(stoptweening;decelerate,0.2;zoom,1;glow,color(glowset);stopeffect;))(self)
	end;

};

t[#t+1] = LoadActor("bullet2") .. {
	OnCommand=function(self)
		self:glow(color("0,0,0,0"));
		local rtitle = self:GetParent():GetParent():GetChild("Title");
		if rtitle then
			if rtitle:GetText() == kis_string or rtitle:GetText() == db_string or rtitle:GetText() == gljs_string then
				self:glow(color("1,0.3,0,0.5"));
			end;
			if optionrowcolorcheck(rtitle:GetText()) then
				self:glow(color("0,1,1,0.5"));
			end;
		end;
	end;
	GainFocusCommand=cmd(stoptweening;decelerate,0.2;diffusealpha,1;);
	LoseFocusCommand=cmd(stoptweening;decelerate,0.2;diffusealpha,0.3;);
};

t[#t+1] = LoadFont("_shared4")..{
	InitCommand=cmd(horizalign,left;cropright,1;zoom,0.5;x,14;y,-14;settext,"SubMenu >>";diffuse,color("0,0,0,1");strokecolor,color("0,1,1,1"););
	GainFocusCommand=function(self)
		self:visible(false);
		local check = false;

		local rtitle = self:GetParent():GetParent():GetChild("Title");
		if rtitle then
			if GetAdhocPref("CSLTiCreditFlag") then
				if tonumber(GetAdhocPref("CSLTiCreditFlag")) >= 1 then
					if rtitle:GetText() == ti_select_string then
						check = true;
					end;
				end;
			elseif getenv("CSLTiCreditFlag") then
				if tonumber(getenv("CSLTiCreditFlag")) >= 1 then
					if rtitle:GetText() == ti_select_string then
						check = true;
					end;
				end;
			end;
			if rtitle:GetText() == kis_string or rtitle:GetText() == db_string or rtitle:GetText() == gljs_string then
				check = true;
			end;
			if check then
				(cmd(visible,true;stoptweening;decelerate,0.1;cropright,0;))(self)
			end;
		end;
	end;
	LoseFocusCommand=cmd(stoptweening;decelerate,0.1;cropright,1;);
};

--20180129 prof_image
t[#t+1] = Def.Sprite {
	OnCommand=function(self)
		self:visible(false);
		local screen = SCREENMAN:GetTopScreen();
		if screen and screen:GetName() == "ScreenOptionsManageProfiles" then
			self:scaletofit(0,0,42,42);
			self:x(460);
			self:y(0);
			local proftable = PROFILEMAN:GetLocalProfileDisplayNames();
			local pname = self:GetParent():GetParent():GetChild("Title");
			for i = 1,#proftable do
				if proftable[i] == pname:GetText() then
					local profileid = PROFILEMAN:GetLocalProfileIDFromIndex(i-1);
					if FILEMAN:DoesFileExist( ProfIDPrefCheck("ProfAvatar",profileid,"Off") ) then 
						self:visible(true);
						self:Load( ProfIDPrefCheck("ProfAvatar",profileid,"Off") );
					end;
					break;
				end;
			end;
		end;
	end;
};


t[#t+1] = LoadFont("Common Normal")..{
	OnCommand=function(self)
		self:visible(false);
		local check = false;
		local rtitle = self:GetParent():GetParent():GetChild("Title");
		if rtitle then
			if GetAdhocPref("Fctext") ~= "" then
				if rtitle:GetText() == sgf_string then
					check = true;
				end;
			end;

			if GetAdhocPref("CSLCreditFlag") then
				if tonumber(GetAdhocPref("CSLCreditFlag")) == 1 then
					if rtitle:GetText() == ti_string or rtitle:GetText() == ti_n_string then
						check = true;
					end;
				end;
			elseif getenv("CSLCreditFlag") then
				if tonumber(getenv("CSLCreditFlag")) == 1 then
					if rtitle:GetText() == ti_string or rtitle:GetText() == ti_n_string then
						check = true;
					end;
				end;
			end;
			if GetAdhocPref("CSLTiCreditFlag") then
				if tonumber(GetAdhocPref("CSLTiCreditFlag")) == 1 then
					if rtitle:GetText() == ti_select_string or rtitle:GetText() == ti_s_string then
						check = true;
					end;
				end;
			elseif getenv("CSLTiCreditFlag") then
				if tonumber(getenv("CSLTiCreditFlag")) == 1 then
					if rtitle:GetText() == ti_select_string or rtitle:GetText() == ti_s_string then
						check = true;
					end;
				end;
			end;
			if check then
				(cmd(visible,true;x,12;y,-10;uppercase,true;settext,"New!";
				shadowlength,2;diffuse,color("1,0,1,1");strokecolor,color("1,1,0,1");zoom,0.45;))(self)
			end;
		end;
	end;
};

local cc = {0,0};
for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
	local p = (pn == PLAYER_1) and 1 or 2;
	local xset = 0;
	local xset_m = 30;
	local horizset = "left";
	local horizset_m = "right";
	if pn == PLAYER_2 then
		xset = 440;
		xset_m = 410
		horizset = "right";
		horizset_m = "left";
	end;
	t[#t+1] = LoadActor(THEME:GetPathG("DiffDisplay","frame/gameplay_frame")) .. {
		InitCommand=function(self)
			(cmd(animate,false;visible,false;setstate,0;horizalign,horizset;zoom,0.8;x,xset;))(self)
		end;
		GainFocusCommand=function(self)
			self:visible(false);
			local rtitle = self:GetParent():GetParent():GetChild("Title");
			if rtitle then
				if rtitle:GetText() == st_string then
					local step;
					if not GAMESTATE:IsCourseMode() then
						step = GAMESTATE:GetCurrentSteps(pn);
					else step = GAMESTATE:GetCurrentTrail(pn);
					end;
					if step then
						local state = difficultyStates[step:GetDifficulty()];
						if state then
							if pn == PLAYER_2 then state = state + 1;
							end;
							self:setstate(state);
						end;
					end;
					(cmd(visible,true;stoptweening;))(self)
				else 
					self:visible(false);
				end;
			end;
		end;
		StepChangedMessageCommand=function(self,param)
			if param.pn == pn and param.step then
				self:playcommand("GainFocus");
			end;
		end;
		--LoseFocusCommand=function(self)
		--end;
	};
	--[ja] 20160124修正
	if getenv("wheelsectioncsc") ~= randomtext and getenv("rnd_song") ~= 1 then
		t[#t+1] = LoadFont("StepsDisplay meter")..{
			InitCommand=function(self)
				(cmd(x,xset_m;y,-1;horizalign,horizset;maxwidth,66;zoom,0.5;skewx,-0.5;shadowlength,2;))(self)
			end;
			BeginCommand=cmd(playcommand,"Set");
			GainFocusCommand=function(self)
				self:visible(false);
				local song = GAMESTATE:GetCurrentSong();
				local step = GAMESTATE:GetCurrentSteps(pn);
				local rtitle = self:GetParent():GetParent():GetChild("Title");
				if rtitle then
					if rtitle:GetText() == st_string then
						local meter = 0;
						if song then
							local stylemode = GAMESTATE:GetCurrentStyle():GetStepsType();
							if step then
								if song:HasStepsTypeAndDifficulty(stylemode,step:GetDifficulty()) then
									meter = step:GetMeter();
									if GetAdhocPref("UserMeterType") == "CSStyle" then
										if step:GetDifficulty() ~= "Difficulty_Edit" then
											meter = GetConvertDifficulty(song,step:GetDifficulty());
										else
											meter = GetConvertDifficulty(song,"Difficulty_Edit",step);
										end;
									end;
								end;
								self:diffuse(Colors.Difficulty[step:GetDifficulty()]);
								self:strokecolor(DifficultyToDarkColor(step:GetDifficulty()));
							end;
							self:settextf("%d",meter);
							--self:settext("22");
						end;
						(cmd(visible,true;stoptweening;))(self)
					else 
						self:visible(false);
					end;
				end;
			end;
			StepChangedMessageCommand=function(self,param)
				if param.pn == pn and param.step then
					self:playcommand("GainFocus");
				end;
			end;
		};
	end;
end;

return t;