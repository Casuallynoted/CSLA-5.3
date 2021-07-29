local t = Def.ActorFrame{};

local pn;
if GAMESTATE:IsHumanPlayer(PLAYER_1) then pn = PLAYER_1;
else pn = PLAYER_2;
end;
local p = (pn == PLAYER_1) and 1 or 2;
local playername = GetAdhocPref("ProfIDSetP"..p);
if GetAdhocPref("P_ADCheck") ~= "OK" then
	playername = GAMESTATE:GetPlayerDisplayName(pn);
end;
local ssStats = STATSMAN:GetPlayedStageStats(1);
local cscgroup = "";
if ssStats then
	cscgroup = ssStats:GetPlayedSongs()[1]:GetGroupName();
end;
local cs_path = "CSDataSave/"..playername.."_Save/0000_co "..cscgroup.."";
local point = 0;
local txt_folders = GetGroupParameter(cscgroup,"Extra1List");
local chk_folders = "";
if txt_folders ~= "" then
	chk_folders = split(":",txt_folders);
end;

if FILEMAN:DoesFileExist( cs_path ) then
	local sys_songc = split(":",GetCSCParameter(cscgroup,"Status",playername));
	if chk_folders ~= "" then
		for k = 1, #chk_folders do
			--#sys_songc < #chk_folders == nil
			if sys_songc ~= "" then
				for l = 1, #sys_songc do
					if sys_songc[l] ~= nil and sys_songc[l] ~= "" then
						local sys_spoint = split(",",sys_songc[l]);
						if chk_folders[k] == sys_spoint[1] and tonumber(sys_spoint[2]) then
							point = point + sys_spoint[2];
						else
							point = point + 0;
						end;
					else
						point = point + 0;
					end;
				end;
			end;
		end;
	end;
end;
setenv("ccstpoint",point);

t[#t+1] = LoadFont("CourseEntryDisplay","number") .. {
	InitCommand=cmd(shadowlength,2;diffuse,color("0,1,1,1");strokecolor,color("0,0.4,0.4,1");skewx,-0.5;maxwidth,60;);
	SetCommand=cmd(settext,point);
	CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
	CurrentCourseChangedMessageCommand=cmd(playcommand,"Set");
};

return t;