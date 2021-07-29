--[[DiffDisplay frame]]

--20160421

local pn = ...
assert(pn,"Needs a pn")

local t = Def.ActorFrame{};

local difficultyStates = {
	Difficulty_Beginner	= 0,
	Difficulty_Easy		= 2,
	Difficulty_Medium	= 4,
	Difficulty_Hard		= 6,
	Difficulty_Challenge	= 8,
	Difficulty_Edit		= 10,
};
--local stageindex = 0;
local IsUsingSoloSingles = PREFSMAN:GetPreference('Center1Player');
local NumPlayers = GAMESTATE:GetNumPlayersEnabled();
local strSide = GAMESTATE:GetCurrentStyle():GetStyleType();
local stylemode = GAMESTATE:GetCurrentStyle():GetStepsType();

local set_t = {right,20};
local diffsetx = SCREEN_CENTER_X-96;
if (IsUsingSoloSingles and NumPlayers == 1) or 
strSide == 'StyleType_OnePlayerTwoSides' or stylemode == 'StepsType_Dance_Solo' then
	diffsetx = SCREEN_CENTER_X+24;
end;
if pn == PLAYER_2 then
	set_t = {left,-20};
	diffsetx = SCREEN_CENTER_X+96;
	if (IsUsingSoloSingles and NumPlayers == 1) or 
	strSide == 'StyleType_OnePlayerTwoSides' or stylemode == 'StepsType_Dance_Solo' then
		diffsetx = SCREEN_CENTER_X-24;
	end;
end;
local framey = SCREEN_BOTTOM-33;
local descriptiony = SCREEN_BOTTOM-54;

t[#t+1] = Def.ActorFrame{
	InitCommand=function(self)
		--[ja] 20140825修正
		self:visible(GAMESTATE:IsHumanPlayer(pn));
		self:x(diffsetx);
	end;
	LoadActor("gameplay_frame")..{
		Name="Frame";
		InitCommand=cmd(animate,false;setstate,0;y,framey;shadowlength,1;zoom,0.7);
		OnCommand=cmd(croptop,1;sleep,0.6;accelerate,0.3;croptop,0);
	};
	
	LoadFont("StepsDisplay meter")..{
		Name="Meter";
		InitCommand=function(self)
			self:horizalign(set_t[1]);
			self:x(set_t[2]);
			(cmd(maxwidth,66;zoom,0.5;skewx,-0.5;y,framey;shadowlength,2;))(self)
		end;
		OnCommand=cmd(diffusealpha,0;sleep,0.6;accelerate,0.3;diffusealpha,1;);
	};
	
	LoadFont("_Shared2")..{
		Name="Description";
		InitCommand=function(self)
			self:horizalign(set_t[1]);
			self:x(set_t[2]);
			(cmd(zoom,0.5;maxwidth,300;y,descriptiony;strokecolor,Color("Black");))(self)
		end;
		OnCommand=cmd(diffusealpha,0;sleep,0.6;accelerate,0.3;diffusealpha,1;);
	};
	
	BeginCommand=cmd(playcommand,"Set");
	SetCommand=function(self)
		local l_frame = self:GetChild('Frame');
		local l_meter = self:GetChild('Meter');
		local l_description = self:GetChild('Description');
		local song = GAMESTATE:GetCurrentSong();
		local step = GAMESTATE:GetCurrentSteps(pn);
		local meter = 0;
		local state = difficultyStates["Difficulty_Beginner"];
		l_frame:visible(false);
		l_meter:settextf("%d",meter);
		l_description:visible(false);
		l_description:settext("");
		if song then
			if step then
			--20180210
				local stname = step:GetChartName() ~= "" and step:GetChartName() or step:GetDescription();
				--SCREENMAN:SystemMessage(pn..","..step:GetDifficulty());
				if song:HasStepsTypeAndDifficulty(stylemode,step:GetDifficulty()) then
					state = difficultyStates[step:GetDifficulty()];
					if state then
						if pn == PLAYER_2 then state = state + 1; end;
						l_frame:visible(true);
						l_frame:setstate(state);
					end;
					meter = step:GetMeter();
					if GetAdhocPref("UserMeterType") == "CSStyle" then
						if step:GetDifficulty() ~= "Difficulty_Edit" then
							meter = GetConvertDifficulty(song,step:GetDifficulty());
						else meter = GetConvertDifficulty(song,"Difficulty_Edit",step);
						end;
					end;
					if step:GetDifficulty() == "Difficulty_Edit" and stname ~= "" then
						--self:settext("aaaayaaaalqaaaagrwgexspaaqyugdfsspfoieaa");
						l_description:visible(true);
						l_description:settext(stname);
					end;
					l_meter:diffuse(Colors.Difficulty[step:GetDifficulty()]);
					l_meter:strokecolor(DifficultyToDarkColor(step:GetDifficulty()));
					l_meter:settextf("%d",meter);
					l_description:diffuse(Colors.Difficulty[step:GetDifficulty()]);
				end;
			end;
		end;
	end;
	--[ja] playcommandではダメ
	CurrentSongChangedMessageCommand=cmd(queuecommand,"Set";);
};

return t;