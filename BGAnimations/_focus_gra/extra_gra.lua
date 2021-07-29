--[[_focus_gra]]

local t = Def.ActorFrame{};

local state = 0;
local song;
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
			self:diffuse(color("1,1,1,0.4"));
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
				song = CurSOSet();
				if song then
					if getenv("Ex1crsCheckSelMusic") == getenv("Ex1SelMusicSongDir") then
						state = 1;
					else state = 0;
					end;
				else state = 0;
				end;
				if state == 1 then self:playcommand("Repeat");
				else self:playcommand("Stop");
				end;
			end;
			SetCommand=function(self)
				state = 0;
				if getenv("wheelstop") == 1 and getenv("rnd_song") == 0 then
					song = CurSOSet();
					if song then
						if getenv("Ex1crsCheckSelMusic") == getenv("Ex1SelMusicSongDir") then
							state = 1;
						end;
					end;
				end;
				if state == 1 then
					self:playcommand("Repeat");
				else self:playcommand("Stop");
				end;
			end;
			RepeatCommand=function(self)
				self:finishtweening();
				if getenv("wheelstop") == 1 and getenv("rnd_song") == 0 then
					self:sleep(1);
					self:diffuse(color("1,1,1,0.4"));
					self:linear(0.05);
					self:diffuse(color("1,1,1,1"));
					self:linear(1);
					self:diffuse(color("1,1,1,0.4"));
					self:queuecommand("Repeat");
				end;
			end;
			StopCommand=function(self)
				self:finishtweening();
				self:linear(0.05);
				self:diffuse(color("1,1,1,0.4"));
			end;
			OffCommand=cmd(stoptweening;);
		};
	};
end;

t.UpdateCommand=cmd(queuecommand,"Set";);
t.CurrentSongChangedMessageCommand=function(self)
	SongOrCourse = "";
	self:stoptweening();
	if getenv("wheelstop") == 1 and getenv("rnd_song") == 0 then
		SongOrCourse = CurSOSet();
		if SongOrCourse then
			self:visible(true);
			self:queuecommand("Set");
		else self:queuecommand("Stop");
		end;
	end;
end;

return t;
