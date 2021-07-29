--20160504
setenv("edit_c_beat",0);

local t = Def.ActorFrame{};

local function get_stops(ostep)
	return ostep:GetTimingData():GetStops();
end;
local function get_bpms(ostep)
	return ostep:GetTimingData():GetBPMsAndTimes();
end;

local s_display = {false,false};
local s_display_temp = {false,false};

function inputs(event)
	local button = event.GameButton;
	local dbutton = event.DeviceInput.button;
	local n_set = 1;
	if dbutton == "DeviceButton_left mouse button" or dbutton == "DeviceButton_right mouse button" then
		if SCREENMAN:GetTopScreen():GetEditState() == 'EditState_Edit' then
			if event.type == "InputEventType_FirstPress" then
				if dbutton == "DeviceButton_right mouse button" then
					n_set = 2;
				end;
				if s_display[n_set] == false then
					s_display[n_set] = true;
					s_display_temp[n_set] = true;
				else
					s_display[n_set] = false;
					s_display_temp[n_set] = false;
				end;
				MESSAGEMAN:Broadcast("Check");
				SOUND:PlayOnce(THEME:GetPathS("_common","value"));
			end;
		else MESSAGEMAN:Broadcast("Check_n");
		end;
	else
		if button then
			if SCREENMAN:GetTopScreen():GetEditState() == 'EditState_Edit' then
				local cc = split("\n",SCREENMAN:GetTopScreen():GetChild("Info"):GetText());
				if cc[2] then
					cc = string.gsub(cc[2],"  ","");
					--SCREENMAN:SystemMessage(cc);
					setenv("edit_c_beat",cc);
					MESSAGEMAN:Broadcast("Check");
				end;
				if s_display_temp[1] == true then
					s_display[1] = true;
					MESSAGEMAN:Broadcast("Check");
				end;
				if s_display_temp[2] == true then
					s_display[2] = true;
					MESSAGEMAN:Broadcast("Check");
				end;
			else
				MESSAGEMAN:Broadcast("Check_n");
				MESSAGEMAN:Broadcast("Check");
			end;
		end;
	end;
end;

local SongOrCourse = CurSOSet();
local StepsOrTrail;
local curStyle = GAMESTATE:GetCurrentStyle();
local stepsType = curStyle:GetStepsType();
local pn = GAMESTATE:GetMasterPlayerNumber();
local ccstep = GAMESTATE:GetCurrentSteps(pn);
local sstep;
local ss;
local ps = GAMESTATE:GetPlayerState(pn);

local song_b_s_list = {{},{}};
local song_b_s_string = {"",""};
local bs_check = {false,false};
local bsh = {1,1};
local bsht = {1,1};
local bsfy = {0,0};
local bsy = {0,0};
local bsi = {1,1};
local bsi_string = {"",""};

local stroh = 12;
local strh = SCREEN_HEIGHT / stroh;

local name_set = {"Bpm","Stop"};
local color_set = {"0,0.5,0.5","0,0.3,0.3"};
local focus_color = "1,0.5,0";
local x_set = {0,70};
for l=1,2 do
	t[#t+1] = Def.ActorFrame {
		Def.Quad{
			Name=name_set[l].."Back";
			InitCommand=cmd(horizalign,left;x,SCREEN_LEFT+30+x_set[l];y,SCREEN_CENTER_Y;zoomtowidth,70;zoomtoheight,SCREEN_HEIGHT;);
		};
		Def.Quad{
			Name=name_set[l].."Focus";
			InitCommand=cmd(horizalign,left;x,SCREEN_LEFT+30+x_set[l];y,SCREEN_TOP+25+stroh;zoomtowidth,70;zoomtoheight,stroh;);
		};
		LoadFont("Common normal") .. {
			Name=name_set[l].."String";
			InitCommand=cmd(strokecolor,Color("Black");shadowlength,1;horizalign,left;vertalign,top;
						zoom,0.5;x,SCREEN_LEFT+40+x_set[l];y,SCREEN_TOP+10;wrapwidthpixels,(SCREEN_WIDTH*2)-30;);
		};
		
		OnCommand=cmd(playcommand,"Set");
		CheckMessageCommand=cmd(playcommand,"Set");
		SetCommand=function(self)
			local c_back = self:GetChild(name_set[l]..'Back');
			local c_focus = self:GetChild(name_set[l]..'Focus');
			local c_string = self:GetChild(name_set[l]..'String');
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
				if s_display[l] == true then
					(cmd(stoptweening;linear,0.1;diffuse,color(color_set[l]..",0.8");))(c_back);
					(cmd(stoptweening;linear,0.1;diffuse,color(focus_color..",0.8");))(c_focus);
					(cmd(stoptweening;linear,0.1;diffusealpha,1;))(c_string);
				else
					(cmd(stoptweening;linear,0.1;diffuse,color(color_set[l]..",0");))(c_back);
					(cmd(stoptweening;linear,0.1;diffuse,color(focus_color..",0");))(c_focus);
					(cmd(stoptweening;linear,0.1;diffusealpha,0;))(c_string);
				end;
				if sstep then
					if l == 1 then
						song_b_s_list[l] = get_bpms(sstep);
						song_b_s_string[l] = "BPMs : "
					else
						song_b_s_list[l] = get_stops(sstep);
						song_b_s_string[l] = "Stops : "
					end;
					bsh[l] = 1;
					bsht[l] = 1;
					bsy[l] = 0;
					bsfy[l] = SCREEN_TOP+25+(stroh*#song_b_s_list[l]);
					for i=0,#song_b_s_list[l] do
						if i == 0 then
							song_b_s_string[l] = song_b_s_string[l]..#song_b_s_list[l].."\n";
							bs_check[l] = true;
						else
							local bs_sand = split("=", song_b_s_list[l][i]);
							if bs_check[l] then
								if tonumber(bs_sand[1]) >= tonumber(getenv("edit_c_beat")) then
									bsfy[l] = SCREEN_TOP+25+(stroh*i);
									c_focus:y(bsfy[l]);
									bsi[l] = i;
									bs_check[l] =false;
								end;
								if i == #song_b_s_list[l] then
									bsi[l] = #song_b_s_list[l];
									bs_check[l] =false;
								end;
							end;
							if l == 1 then
								bsi_string[l] = string.format("%.3f",bs_sand[2]);
							else bsi_string[l] = string.format("%.3f",bs_sand[1]);
							end;
							if i <= bsi[l] - strh - 1 then
								bsi_string[l] = "";
							end;
							if i >= bsi[l] + strh then
								bsi_string[l] = "";
							end;
							--SCREENMAN:SystemMessage(bsi[l]);
							song_b_s_string[l] = song_b_s_string[l].."\n"..bsi_string[l];
						end;
					end;
					if s_display[l] == true then
						if l == 2 and #song_b_s_list[l] == 0 then
							bsfy[l] = SCREEN_TOP+25+stroh;
							(cmd(stoptweening;linear,0.1;diffuse,color(focus_color..",0");))(c_focus);
						end;
						
						bsy[l] = 0;
						c_string:y(SCREEN_TOP+10);
						c_focus:y(bsfy[l]);
						local tt = {5,7};
						while true do
							if bsht[l] > 1 then
								tt = {9+bsht[l],11+bsht[l]};
							end;
							if bsfy[l] >= (SCREEN_HEIGHT * bsht[l]) - (stroh * tt[1]) then
								bsy[l] = ((SCREEN_HEIGHT * bsht[l]) - (stroh * tt[2]));
								bsht[l] = bsht[l] + 1;
								c_string:y(-bsy[l]);
								c_focus:y(-bsy[l]+bsfy[l]-10);
							else break;
							end;
						end;
						c_string:settext(song_b_s_string[l]);
					else c_string:settext("");
					end;
				end;
			end;
		end;
	};
end;

t[#t+1] = Def.ActorFrame {
	OnCommand=function(self)
		SCREENMAN:GetTopScreen():AddInputCallback(inputs);
	end;
	Check_nMessageCommand=function(self)
		s_display = {false,false};
	end;
};

return t;