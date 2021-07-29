local t=Def.ActorFrame{};

local st = GAMESTATE:GetCurrentStyle():GetStepsType();
local meter = 0;

local diff = {
	'Difficulty_Beginner',
	'Difficulty_Easy',
	'Difficulty_Medium',
	'Difficulty_Hard',
	'Difficulty_Challenge'
};

local diff_ma = 0;
local diff_ta = {0,0,0,0,0};

for difflist = 1, 5 do
	t[#t+1] = Def.ActorFrame {
		InitCommand=function(self)
			self:diffusealpha(1);
			diff_ma = 0;
			self:playcommand("Set");
		end;
		BeginCommand=function(self)
			diff_ma = 0;
			self:playcommand("Set");
		end;
		SetCommand=function(self)
			local song = GAMESTATE:GetCurrentSong();
			local dif_unlock = getenv("difunlock_flag");
			if song then
				if song:HasStepsTypeAndDifficulty(st,diff[difflist]) then
					if dif_unlock[difflist] then
						diff_ma = diff_ma + 92;
						diff_ta[difflist] = diff_ma;
					else
						diff_ma = diff_ma;
						diff_ta[difflist] = 10000;
					end;
				else
					diff_ma = diff_ma;
					diff_ta[difflist] = 10000;
				end;
			end;
			self:stoptweening();
			self:y(diff_ta[difflist]);
		end;
		OnCommand=function(self)
			diff_ma = 0;
			self:queuecommand("Set");
		end;
		CurrentSongChangedMessageCommand=function(self)
			diff_ma = 0;
			self:queuecommand("Set");
		end;

		LoadActor(THEME:GetPathG("", "_difftable"))..{
			InitCommand=function(self)
				(cmd(animate,false;setstate,0;playcommand,"Set"))(self)
			end;
			SetCommand=function(self)
				local song = GAMESTATE:GetCurrentSong();
				local dif_unlock = getenv("difunlock_flag");
				if song then
					self:setstate(difflist-1);
				end;
			end;
		};
		
		--20160821
		Def.ActorFrame{
			InitCommand=cmd(x,-1;y,40);
			Def.RollingNumbers {
				File=THEME:GetPathF("StepsDisplay","meter");
				InitCommand=function(self)
					(cmd(shadowlength,3;rotationz,90;horizalign,right;maxwidth,66;zoom,0.875;skewx,-0.5;))(self)
					if vcheck() ~= "5_2_0" then
						(cmd(Load,"RollingNumbersMeter";))(self)
					else
						self:set_chars_wide(1);
						self:set_text_format("%.0f");
						self:set_approach_seconds(dfApproachSeconds());
					end;
					self:playcommand("Set");
				end;
				BeginCommand=function(self)
					self:playcommand("Set");
				end;
				SetCommand=function(self)
					self:stoptweening();
					local song = GAMESTATE:GetCurrentSong();
					local dif_unlock = getenv("difunlock_flag");
					if song then
						if getenv("rnd_song") == 0 then
							if song:HasStepsTypeAndDifficulty(st,diff[difflist]) then
								if dif_unlock[difflist] then
									if GetAdhocPref("UserMeterType") == "CSStyle" then
										meter = GetConvertDifficulty(song,diff[difflist]);
									else
										meter = song:GetOneSteps(st,diff[difflist]):GetMeter();
									end;
									if vcheck() ~= "5_2_0" then
										self:diffuse(Colors.Difficulty[diff[difflist]]);
									else
										self:set_leading_attribute{Diffuse= Colors.Difficulty[diff[difflist]]};
										self:set_number_attribute{Diffuse= Colors.Difficulty[diff[difflist]]};
									end;
									self:strokecolor(DifficultyToDarkColor(diff[difflist]));
									self:visible(true);
								end;
							end;
						else
							if song:HasStepsTypeAndDifficulty(st,diff[difflist]) then
								if vcheck() ~= "5_2_0" then
									self:diffuse(Colors.Difficulty[diff[difflist]]);
								else
									self:set_leading_attribute{Diffuse= Colors.Difficulty[diff[difflist]]};
									self:set_number_attribute{Diffuse= Colors.Difficulty[diff[difflist]]};
								end;
								self:strokecolor(DifficultyToDarkColor(diff[difflist]));
								meter = 0;
								self:visible(false);
							end;
						end;
					end;
					if meter then
						if vcheck() ~= "5_2_0" then
							self:targetnumber(meter);
						else self:target_number(meter);
						end;
					end;
				end;
				OnCommand=function(self)
					self:playcommand("Set");
				end;
				CurrentSongChangedMessageCommand=function(self)
					self:queuecommand("Set");
				end;
			};
		};
	};
end;
return t;