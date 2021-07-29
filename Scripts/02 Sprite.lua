extension = {"png","jpg","jpeg","gif","bmp"};

function highdefcheck(img)
	if PREFSMAN:GetPreference("HighResolutionTextures") == "ForceOff" or 
	GetAdhocPref("CSHighResTexture") == "Low" then
		return "_low_"..img;
	else
		return img;
	end
end

function Sprite:LoadFromSongBanner(song)
	if song then
		local Path = song:GetBannerPath()
		if not Path then
			Path = THEME:GetPathG("Common","fallback banner")
		end

		self:LoadBanner( Path )
	else
		self:LoadBanner( THEME:GetPathG("Common","fallback banner") )
	end
end

function Sprite:LoadFromSongBackground(song)
	local Path = song:GetBackgroundPath()
	if not Path then
		Path = THEME:GetPathG("Common","fallback background")
	end

	self:LoadBackground( Path )
end

function LoadSongBackground()
	return Def.Sprite {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y),
		BeginCommand=cmd(LoadFromSongBackground,GAMESTATE:GetCurrentSong();scale_or_crop_background)
	}
end

function Sprite:LoadFromCurrentSongBackground()
	local song = GAMESTATE:GetCurrentSong()
	if not song then
		local trail = GAMESTATE:GetCurrentTrail(GAMESTATE:GetMasterPlayerNumber())
		local e = trail:GetTrailEntries()
		if #e > 0 then
			song = e[1]:GetSong()
		end
	end

	if not song then return end

	self:LoadFromSongBackground(song)
end

function Sprite:position( f )
	self:GetTexture():position( f )
end

function Sprite:loop( f )
	self:GetTexture():loop( f )
end

function Sprite:rate( f )
	self:GetTexture():rate( f )
end

function Sprite.LinearFrames(NumFrames, Seconds)
	local Frames = {}
	for i = 0,NumFrames-1 do
		Frames[#Frames+1] = {
			Frame = i,
			Delay = (1/NumFrames)*Seconds
		}
	end
	return Frames
end

function GetSongImage(sorc)
	local coursemode = GAMESTATE:IsCourseMode();
	local showjacket = GetAdhocPref("WheelGraphics");
	if sorc then
		local jacketpath;
		local sbannerpath = sorc:GetBannerPath()
		local cdimagepath;
		local sbackgroundpath = sorc:GetBackgroundPath()
		if not coursemode then
			jacketpath = sorc:GetJacketPath()
			cdimagepath = sorc:GetCDImagePath()
		end;
		
		if showjacket ~= "Off" then
			if coursemode then
				if sorc:HasBanner() then 		return sbannerpath
				elseif sorc:HasBackground() then return backgroundpath
				end
			else
				if sorc:HasJacket() then 		return jacketpath
				elseif sorc:HasBanner() then 	return sbannerpath
				elseif sorc:HasCDImage() then 	return cdimagepath
				elseif sorc:HasBackground() then return backgroundpath
				end
			end
		elseif sorc:HasBanner() then return sbannerpath
		end

	end
	return THEME:GetPathG("Common","fallback jacket");
end;

function GetSongImageSize(sorc,sc)
	local size = {
		normal_banner = 	{160,50},
		normal_square = 	{160,160},
		jukebox_banner = 	{192,60},
		jukebox_square = 	{160,160},
		summary_banner = 	{96,30},
		summary_square = 	{36,36},
	};
	if sorc then
		if GAMESTATE:IsCourseMode() then
			if sorc:HasBanner() then
				if string.find(string.lower(sorc:GetBannerPath()),"jacket") then
					return size[sc.."_square"]
				else return size[sc.."_banner"]
				end
			elseif sorc:HasBackground() then return size[sc.."_square"]
			end
		else
			if showjacket ~= "Off" then
				if sorc:HasJacket() then 		return size[sc.."_square"]
				elseif sorc:HasBanner() then 	return size[sc.."_banner"]
				elseif sorc:HasCDImage() then 	return size[sc.."_square"]
				elseif sorc:HasBackground() then 	return size[sc.."_square"]
				end
			elseif sorc:HasBanner() then return size[sc.."banner"]
			end
		end
	end
	return size[sc.."_square"]
end

function b_s_pr(brlist,song,f_set)
	if brlist ~= "" then
		--local chk_brlist = string.lower(brlist);
		local chk_brlist = brlist;
		chk_brlist = split(":",chk_brlist);
		for b=1, #chk_brlist do
			b_dir_s = split("|",chk_brlist[b]);
			if #b_dir_s > 1 then
				for bb=1, #b_dir_s do
					b_dir_ss = split(">",b_dir_s[bb]);
					if #b_dir_ss > 1 then
						if string.lower(b_dir_ss[1]) == string.lower(f_set) then
							if string.lower(f_set) == "banner" or string.lower(f_set) == "jacket" or string.lower(f_set) == "background" then
								local s_path = "/Songs/";
								if string.find(song:GetSongDir(),"^/AdditionalSongs/.*") then
									s_path = "/AdditionalSongs/";
								end;
								return s_path..song:GetGroupName().."/"..b_dir_ss[2];
							elseif string.lower(f_set) == "random" then
								local ddss = {};
								for d=2, #b_dir_ss do
									ddss[#ddss+1] = b_dir_ss[d];
								end;
								return ddss;
							end;
							return b_dir_ss[2];
						end;
					end;
				end;
			end;
		end;
	end;
end

function bUse3dModels()
	return GetAdhocPref("Enable3DModels");
end

-- (c) 2005 Glenn Maynard
-- All rights reserved.
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a
-- copy of this software and associated documentation files (the
-- "Software"), to deal in the Software without restriction, including
-- without limitation the rights to use, copy, modify, merge, publish,
-- distribute, and/or sell copies of the Software, and to permit persons to
-- whom the Software is furnished to do so, provided that the above
-- copyright notice(s) and this permission notice appear in all copies of
-- the Software and that both the above copyright notice(s) and this
-- permission notice appear in supporting documentation.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
-- OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
-- MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF
-- THIRD PARTY RIGHTS. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR HOLDERS
-- INCLUDED IN THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL INDIRECT
-- OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS
-- OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
-- OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
-- PERFORMANCE OF THIS SOFTWARE.
