--[ja] ジャケット表示できるけどスペースの都合で大きさが小さいので実用向きではない
--[[
local jacketPath ,cdimagepath ,sbannerpath;

local showjacket = GetAdhocPref("WheelGraphics");

function GetSongImage_G(song)
	if song then
		jacketpath = song:GetJacketPath()
		sbannerpath = song:GetBannerPath()
		cdimagepath = song:GetCDImagePath()

		if showjacket ~= "Off" then
			if jacketpath then
				return jacketpath
			elseif sbannerpath then
				return sbannerpath
			elseif cdimagepath then
				return cdimagepath
			end
		elseif sbannerpath then
			return sbannerpath
		end

	end
	return THEME:GetPathG("common fallback","banner");
end

function GetSongImageSize_G(song)
	if song then
		jacketpath = song:GetJacketPath()
		sbannerpath = song:GetBannerPath()
		cdimagepath = song:GetCDImagePath()

		if showjacket ~= "Off" then
			if jacketpath then
				return 40,40
			elseif sbannerpath then
				return 104,30
			elseif cdimagepath then
				return 40,40
			end
		elseif sbannerpath then
			return 104,30
		end
	end
	return 104,30;
end

function SongImageY_G(song)
	if song then
		jacketpath = song:GetJacketPath()
		sbannerpath = song:GetBannerPath()
		cdimagepath = song:GetCDImagePath()

		if showjacket ~= "Off" then
			if jacketpath then
				return SCREEN_BOTTOM-22
			elseif sbannerpath then
				return SCREEN_BOTTOM-26
			elseif cdimagepath then
				return SCREEN_BOTTOM-22
			end
		elseif sbannerpath then
			return SCREEN_BOTTOM-20
		end
	end
	return SCREEN_BOTTOM-20;
end


local t = Def.ActorFrame{
	Def.Banner {
		Name="Banner";
		SetCommand=function(self)
			local song = GAMESTATE:GetCurrentSong();
			if not song then
				self:Load( THEME:GetPathG("common fallback","banner") );
			else
				self:Load(GetSongImage_G(song));
			end;
			self:ScaleToClipped(GetSongImageSize_G(song));
			(cmd(x,SCREEN_CENTER_X;y,SongImageY_G(song);))(self)
		end;
		InitCommand=cmd(queuecommand,"Set");
		OnCommand=cmd(diffusealpha,0;addy,-20;sleep,0.7;decelerate,0.5;diffusealpha,0.8;addy,20;);
		CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
	};
};

return t;
]]

local t = Def.ActorFrame{};

t[#t+1] = Def.ActorFrame{
	Def.Banner {
		Name="banner";
		InitCommand=cmd(x,mplayerposition()+stylecheckposition();y,SCREEN_BOTTOM-26;ScaleToClipped,104,30);
		OnCommand=cmd(diffusealpha,0;addy,-20;sleep,0.7;decelerate,0.5;diffusealpha,0.8;addy,20;);
	};

	Def.TextBanner {
		Name="textbanner";
		InitCommand=cmd(x,mplayerposition()+stylecheckposition()-73;y,SCREEN_BOTTOM-26;
					Load,"GamePlayTextBanner";SetFromString,"", "", "", "", "", "";);
		OnCommand=cmd(zoomx,0.575;zoomy,0;sleep,0.6;decelerate,0.4;zoomy,0.575;);
	};
	
	BeginCommand=cmd(playcommand,"Set");
	SetCommand=function(self)
		local banner = self:GetChild('banner');
		local textbanner = self:GetChild('textbanner');
		banner:visible(false);
		textbanner:visible(false);
		local song = GAMESTATE:GetCurrentSong();
		local bannerpath;
		if song then
			if getenv("rnd_song") == 1 then
				local brlist = GetGroupParameter(song:GetGroupName(),"BranchList");
				if getenv("exflag") == "csc" then
					brlist = GetGroupParameter(song:GetGroupName(),"Extra1Songs");
				end;
				if b_s_pr(brlist,song,"Banner") and FILEMAN:DoesFileExist( b_s_pr(brlist,song,"Banner") ) then
					bannerpath = b_s_pr(brlist,song,"Banner");
				end;
			else
				if song:HasBanner() then
					bannerpath = song:GetBannerPath();
				end;
			end;
			if bannerpath then
				banner:visible(true);
				banner:Load(bannerpath);
			else
				textbanner:visible(true);
				sgbtsetting(textbanner,song);
			end;
		end;
	end;
};

t.CurrentSongChangedMessageCommand=function(self)
	self:playcommand("Set");
end;

return t;