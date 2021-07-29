-- segment display: tells the player about various gimmicks used in the song timing.
local iconPath = "_timingicons"
local iconSpace = 11

local showCmd = cmd(visible,true;stoptweening;cropbottom,1;linear,0.1;cropbottom,0)
local hideCmd = cmd(visible,false)

local SegmentTypes = {
	Stops	=	{ Frame = 0, xPos = iconSpace*6, yPos = 0 },
	Warps	=	{ Frame = 2, xPos = iconSpace*5, yPos = 0 },
	Delays	=	{ Frame = 1, xPos = iconSpace*4, yPos = 0 },
	Attacks	=	{ Frame = 6, xPos = iconSpace*0, yPos = 0 },
	Scrolls	=	{ Frame = 3, xPos = iconSpace*3, yPos = 0 },
	Speeds	=	{ Frame = 4, xPos = iconSpace*2, yPos = 0 },
	Fakes	=	{ Frame = 5, xPos = iconSpace*1, yPos = 0 },
	SBpms	=	{ Frame = 7, xPos = iconSpace*7, yPos = 0 },
};

local t = Def.ActorFrame{
	InitCommand=cmd(draworder,95;zoom,0;sleep,1;zoom,1;playcommand,"SetIcons";playcommand,"SetAttacksIconMessage");
	--OffCommand=cmd( RunCommandsOnChildren,cmd(playcommand,"Hide") );
	
	LoadActor(iconPath)..{
		Name="WarpsIcon";
		InitCommand=cmd(vertalign,top;animate,false;x,SegmentTypes.Warps.xPos;y,SegmentTypes.Warps.yPos;setstate,SegmentTypes.Warps.Frame;);
		ShowCommand=showCmd;
		HideCommand=hideCmd;
	};
	LoadActor(iconPath)..{
		Name="StopsIcon";
		InitCommand=cmd(vertalign,top;animate,false;x,SegmentTypes.Stops.xPos;y,SegmentTypes.Stops.yPos;setstate,SegmentTypes.Stops.Frame;);
		ShowCommand=showCmd;
		HideCommand=hideCmd;
	};
	LoadActor(iconPath)..{
		Name="DelaysIcon";
		InitCommand=cmd(vertalign,top;animate,false;x,SegmentTypes.Delays.xPos;y,SegmentTypes.Delays.yPos;setstate,SegmentTypes.Delays.Frame;);
		ShowCommand=showCmd;
		HideCommand=hideCmd;
	};
	LoadActor(iconPath)..{
		Name="AttacksIcon";
		InitCommand=cmd(vertalign,top;animate,false;x,SegmentTypes.Attacks.xPos;y,SegmentTypes.Attacks.yPos;setstate,SegmentTypes.Attacks.Frame;);
		ShowCommand=showCmd;
		HideCommand=hideCmd;
	};
	LoadActor(iconPath)..{
		Name="ScrollsIcon";
		InitCommand=cmd(vertalign,top;animate,false;x,SegmentTypes.Scrolls.xPos;y,SegmentTypes.Scrolls.yPos;setstate,SegmentTypes.Scrolls.Frame;);
		ShowCommand=showCmd;
		HideCommand=hideCmd;
	};
	LoadActor(iconPath)..{
		Name="SpeedsIcon";
		InitCommand=cmd(vertalign,top;animate,false;x,SegmentTypes.Speeds.xPos;y,SegmentTypes.Speeds.yPos;setstate,SegmentTypes.Speeds.Frame;);
		ShowCommand=showCmd;
		HideCommand=hideCmd;
	};
	LoadActor(iconPath)..{
		Name="FakesIcon";
		InitCommand=cmd(vertalign,top;animate,false;x,SegmentTypes.Fakes.xPos;y,SegmentTypes.Fakes.yPos;setstate,SegmentTypes.Fakes.Frame;);
		ShowCommand=showCmd;
		HideCommand=hideCmd;
	};
	LoadActor(iconPath)..{
		Name="SBpmsIcon";
		InitCommand=cmd(vertalign,top;animate,false;x,SegmentTypes.SBpms.xPos;y,SegmentTypes.SBpms.yPos;setstate,SegmentTypes.SBpms.Frame;);
		ShowCommand=showCmd;
		HideCommand=hideCmd;
	};

	SetIconsCommand=function(self)
		local stops = self:GetChild("StopsIcon")
		local delays = self:GetChild("DelaysIcon")
		local warps = self:GetChild("WarpsIcon")
		local scrolls = self:GetChild("ScrollsIcon")
		local speeds = self:GetChild("SpeedsIcon")
		local fakes = self:GetChild("FakesIcon")
		local sbpms = self:GetChild("SBpmsIcon")

		-- hax
		MESSAGEMAN:Broadcast("SetAttacksIcon",{Player = GAMESTATE:GetMasterPlayerNumber()})
		warps:playcommand("Hide")
		stops:playcommand("Hide")
		delays:playcommand("Hide")
		scrolls:playcommand("Hide")
		speeds:playcommand("Hide")
		fakes:playcommand("Hide")
		sbpms:playcommand("Hide")
		local song = GAMESTATE:GetCurrentSong()
		if getenv("wheelstop") == 1 and getenv("rnd_song") == 0 and song then
			local timing = song:GetTimingData()
			if timing:HasWarps() then
				warps:playcommand("Show")
			end
			if timing:HasStops() then
				stops:playcommand("Show")
			end
			if timing:HasDelays() then
				delays:playcommand("Show")
			end
			if timing:HasScrollChanges() then
				scrolls:playcommand("Show")
			end
			if timing:HasSpeedChanges() then
				speeds:playcommand("Show")
			end
			if timing:HasFakes() then
				fakes:playcommand("Show")
			end
			
			local st=GAMESTATE:GetCurrentStyle():GetStepsType();
			local Difficulty = {
				"Difficulty_Beginner",
				"Difficulty_Easy",
				"Difficulty_Medium",
				"Difficulty_Hard",
				"Difficulty_Challenge",
				"Difficulty_Edit",
			};
			local check = false;
			for i=1,6 do
				if song:HasStepsTypeAndDifficulty(st,Difficulty[i]) then
					if song:IsStepsUsingDifferentTiming(song:GetOneSteps(st,Difficulty[i])) then
						check = true;
						break;
					end;
				end;
			end;
			if check then
				sbpms:playcommand("Show")
			end
		end
	end;
	SetAttacksIconMessageCommand=function(self,param)
		local attacks = self:GetChild("AttacksIcon")
		local song = GAMESTATE:GetCurrentSong()
		if song then
			local steps = GAMESTATE:GetCurrentSteps(param.Player)
			if steps then
				local hasAttacks = steps:HasAttacks()
				attacks:playcommand(hasAttacks and "Show" or "Hide")
			else attacks:playcommand("Hide")
			end
		else attacks:playcommand("Hide")
		end
	end;
	CurrentSongChangedMessageCommand=cmd(playcommand,"SetIcons";);
	CurrentStepsP1ChangedMessageCommand=function(self) MESSAGEMAN:Broadcast("SetAttacksIcon",{Player = PLAYER_1}) end;
	CurrentStepsP2ChangedMessageCommand=function(self) MESSAGEMAN:Broadcast("SetAttacksIcon",{Player = PLAYER_2}) end;
};

return t;