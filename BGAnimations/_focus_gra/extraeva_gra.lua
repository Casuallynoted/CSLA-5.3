--[[_focus_gra]]

local t = Def.ActorFrame{};

local state = 0;
local bExtra = GAMESTATE:IsExtraStage();
local style = GAMESTATE:GetCurrentStyle();
local song = GAMESTATE:GetCurrentSong();
local ssStats = STATSMAN:GetPlayedStageStats(2);
local sssong = ssStats:GetPlayedSongs()[1];
local extrasong, steps = SONGMAN:GetExtraStageInfo( bExtra, style );

for i = 1, 2 do
	local function yset()
		local y = 300;
		if i == 1 then y = 300;
		else y = 1092;
		end;
		return y
	end;

	t[#t+1] = Def.ActorFrame{
		InitCommand=function(self)
			self:fov(100);
			self:x(SCREEN_RIGHT+40);
			self:y(SCREEN_CENTER_Y-170);
			self:rotationx(160);
			self:rotationy(140);
			self:rotationz(220);
		end;
		OnCommand=function(self)
			self:zoom(2);
			self:accelerate(0.5);
			self:zoom(0.5);
			self:rotationx(200);
			self:rotationy(180);
			self:rotationz(200);
		end;
		LoadActor("3dwarback")..{
			InitCommand=function(self)
				self:y(yset());
				self:diffusealpha(0.4);
				self:fadeleft(0.2);
				if (Ex1crsCheck(song,sssong,bExtra) == "crs_ex" or Ex1crsCheck(song,sssong,bExtra) == "n_ex") then
					state = 1;
				else
					if extrasong == song then
						state = 1;
					else
						state = 0;
					end;
				end;
				if state == 1 then self:playcommand("Repeat");
				else self:playcommand("Stop");
				end;
			end;
			SetCommand=function(self)
				if (Ex1crsCheck(song,sssong,bExtra) == "crs_ex" or Ex1crsCheck(song,sssong,bExtra) == "n_ex") then
					state = 1;
				else
					if extrasong == song then
						state = 1;
					else
						state = 0;
					end;
				end;
				if state == 1 then self:playcommand("Repeat");
				else self:playcommand("Stop");
				end;
			end;
			RepeatCommand=function(self)
				self:stoptweening();
				self:sleep(1);
				self:diffuse(color("1,1,1,0.4"));
				self:linear(0.05);
				self:diffuse(color("1,1,1,1"));
				self:linear(1);
				self:diffuse(color("1,1,1,0.4"));
				self:queuecommand("Repeat");
			end;
			StopCommand=function(self)
				self:linear(0.05);
				self:diffuse(color("1,1,1,0.4"));
				self:finishtweening();
			end;
			OffCommand=cmd(stoptweening;);
			OnCommand=cmd(playcommand,"Set";);
		};
	};
end;

return t;
