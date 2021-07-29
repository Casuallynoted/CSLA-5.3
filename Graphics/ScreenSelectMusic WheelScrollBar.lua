local t = Def.ActorFrame{};
local swidth = 240;
local oldindexnum = 0
local sectionCount = tonumber(getenv("sectionCount"));
local sec_check = false;
local sound_check = true;

local function s_sec_check(so)
	local sort = ToEnumShortString(so);
	local check = true;
	local rsetting;
	if sort == "Popularity" or sort == "Recent" then
		check = false;
	elseif sort == "Preferred" then
		if rsettingset(getenv("SortCh")) then
			rsetting = rsettingset(getenv("SortCh"));
			if rsetting then
				local f = RageFileUtil.CreateRageFile();
				f:Open(rsetting,1);
				f:Seek(0);
				local l;
				while true do
					if f:AtEOF() then
						check = false;
						break;
					else
						l=f:GetLine();
						local ll=string.lower(l);
						if string.find(ll,"^---%s?.*") then
							check = true;
							break;
						end;
					end;
				end;
				f:Close();
				f:destroy();
			end;
		end;
	end;
	return check;
end;

local function setx(self,seco)
	self:stoptweening();
	--[ja] 20160205修正
	local musicwheel;
	if SCREENMAN:GetTopScreen() then
		musicwheel = SCREENMAN:GetTopScreen():GetChild('MusicWheel');
	end;
	if musicwheel then
		local expsc = GAMESTATE:GetExpandedSectionName();
		local numitems = musicwheel:GetNumItems();
		local sswidth = swidth / 2;
		local cindex = musicwheel:GetCurrentIndex();
		local cwidth = swidth / (numitems - 1);
		if cindex == 0 then
			(cmd(decelerate,0.1;y,-sswidth))(self)
		else (cmd(decelerate,0.1;y,-sswidth+(cwidth*cindex)))(self)
		end;
		--SCREENMAN:SystemMessage(tostring(sec_check).." : "..expsc);
		--[ja] 20160322修正
		if not GAMESTATE:IsCourseMode() then
			if seco and seco == "seco" then
				if sec_check and expsc == "" and sound_check then
					sec_check = false;
					MESSAGEMAN:Broadcast("SectionSetFSound");
				end;
				if not sec_check and expsc ~= "" then
					sec_check = true;
				end;
			end;
		end;
	end;
	return self;
end

t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(visible,true;rotationz,-90;);
	LoadActor(THEME:GetPathG("ScrollBar","top")) .. {
		InitCommand=cmd(y,(-swidth/2)-28;);
	};
	LoadActor(THEME:GetPathG("ScrollBar","middle")) .. {
		InitCommand=cmd(zoomtoheight,swidth);
	};
	LoadActor(THEME:GetPathG("ScrollBar","bottom")) .. {
		InitCommand=cmd(y,(swidth/2)+28;);
	};

	LoadActor(THEME:GetPathG("ScrollBar","TickThumb/TickThumb")) .. {
		InitCommand=cmd(playcommand,"CurrentSongChangedMessage";);
		OnCommand=function(self)
			if getenv("ReloadAnimFlag") == 1 then self:playcommand("NoAnim");
			else self:playcommand("Anim");
			end;
			sec_check = true;
		end;
		AnimCommand=cmd(zoomy,0;linear,0.3;zoomy,1;queuecommand,"Repeat";);
		NoAnimCommand=cmd(zoomy,1;queuecommand,"Repeat";);
		RepeatCommand=cmd(blend,'BlendMode_Add';glowshift;effectperiod,3;effectcolor1,color("0,0,0,0");effectcolor2,color("0,1,1,0.4"););
		CurrentSongChangedMessageCommand=function(self)
			setx(self,"seco");
		end;
		CurrentCourseChangedMessageCommand=cmd(playcommand,"CurrentSongChangedMessage";);
		SectionSetMessageCommand=function(self)
			sec_check = false;
			local expsc = GAMESTATE:GetExpandedSectionName();
			if expsc == getenv("wheelsectiongroup") then
				sec_check = true;
			end;
			setx(self);
		end;
		SectionSetFSoundMessageCommand=function(self)
			SOUND:PlayOnce(THEME:GetPathS("MusicWheel","expand"));
		end;
	};
};

t[#t+1] = Def.ActorFrame{
	OnCommand=function(self)
		local so = GAMESTATE:GetSortOrder();
		if so then
			sound_check = s_sec_check(so);
		end;
	end;
	SortOrderChangedMessageCommand=cmd(playcommand,"On";);
};

return t;