local t = Def.ActorFrame{};
--20180210
local function format_bpm(bpm)
	return ("%.0f"):format(bpm)
end
function inputs(event)
	local button = event.GameButton
	if button then
		MESSAGEMAN:Broadcast("DirectionButton");
	end;
end;

local row2y = THEME:GetMetric("EditMenu","Row2Y");
local value2x = THEME:GetMetric("EditMenu","Value2X");

t[#t+1] = Def.ActorFrame {
	OnCommand=function(self)
		SCREENMAN:GetTopScreen():AddInputCallback(inputs);
	end;
};

local song;
if GAMESTATE:GetCurrentSong() then
	song = GAMESTATE:GetCurrentSong();
end;
local song_bpms = {};
local bpm_text = "???";
local time_text = "0:00";

t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(x,value2x-58;y,row2y+30;);
	OnCommand=cmd(playcommand,"DirectionButton";);
	LoadFont("_ul") .. {
		Text="BPM : ";
		InitCommand=cmd(horizalign,right;maxwidth,80);
		OnCommand=cmd(shadowlength,2;diffuse,color("0.75,0.75,0.75,1");strokecolor,Color("Black");zoom,0.5);
	};
	LoadFont("_cum") .. {
		Name="BpmText",
		InitCommand=cmd(x,4;y,-4;horizalign,left;maxwidth,220);
		OnCommand=cmd(shadowlength,2;diffuse,color("0.75,0.75,0.75,1");strokecolor,Color("Black");zoom,0.5);
	};
	LoadFont("_ul") .. {
		Text="TIME : ";
		InitCommand=cmd(x,166;horizalign,right;maxwidth,80);
		OnCommand=cmd(shadowlength,2;diffuse,color("0.75,0.75,0.75,1");strokecolor,Color("Black");zoom,0.5);
	};
	LoadFont("_cum") .. {
		Name="TimeText",
		InitCommand=cmd(x,170;y,-4;horizalign,left;maxwidth,220);
		OnCommand=cmd(shadowlength,2;diffuse,color("0.75,0.75,0.75,1");strokecolor,Color("Black");zoom,0.5);
	};
	DirectionButtonMessageCommand=function(self)
		local grouptext = self:GetParent():GetParent():GetChild("EditMenu"):GetChild("Value1"):GetText();
		local titletext = self:GetParent():GetParent():GetChild("EditMenu"):GetChild("SongTextBanner"):GetChild("Title"):GetText();
		local subtitletext = self:GetParent():GetParent():GetChild("EditMenu"):GetChild("SongTextBanner"):GetChild("Subtitle"):GetText();
		local bpm_txt = self:GetChild("BpmText");
		local time_txt = self:GetChild("TimeText");
		
		if subtitletext ~= "" then
			subtitletext = " "..subtitletext;
		else subtitletext = "";
		end;
		if not GetSongName2Song(grouptext,titletext..""..subtitletext) then
			local allGroups = SONGMAN:GetNumSongGroups();
			for gro=1, allGroups do
				local gropnames = SONGMAN:GetSongGroupNames()[gro];
				local s_gropnames = SONGMAN:ShortenGroupName(gropnames);
				if gropnames == grouptext or s_gropnames == grouptext then
					c_group = gropnames;
					break;
				end;
			end;
		else c_group = grouptext;
		end;
		if GetSongName2Song(c_group,titletext..""..subtitletext) then
			song = GetSongName2Song(c_group,titletext..""..subtitletext);
			song_bpms = song:GetDisplayBpms();
			song_bpms[1] = math.round(song_bpms[1])
			song_bpms[2] = math.round(song_bpms[2])
			if song_bpms[1] == song_bpms[2] then
				bpm_text = format_bpm(song_bpms[1])
			else
				bpm_text = format_bpm(song_bpms[1]) .. "~" .. format_bpm(song_bpms[2])
			end;
			time_text = SecondsToMSSMsMs(song:MusicLengthSeconds());
			--SCREENMAN:SystemMessage(grouptext.."/\n"..titletext..""..subtitletext.."/\n"..bpm_text);
			
			bpm_txt:settext(bpm_text);
			time_txt:settext(time_text);
		end;
	end;
};

return t;