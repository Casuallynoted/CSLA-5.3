local pn = ...;
assert(pn);

local difficultyFrames = {
	Difficulty_Beginner	= 0,
	Difficulty_Easy		= 1,
	Difficulty_Medium	= 2,
	Difficulty_Hard		= 3,
	Difficulty_Challenge	= 4,
	Difficulty_Edit		= 5,
};
local coursemode = GAMESTATE:IsCourseMode();

local t = Def.ActorFrame{};

if coursemode then
	t[#t+1] = Def.ActorFrame{
		InitCommand=cmd(y,6);
		BeginCommand=cmd(player,pn);
		PlayerJoinedMessageCommand=function(self,param)
			if param.Player == pn then
				self:visible(true);
			end;
		end;
		PlayerUnjoinedMessageCommand=function(self,param)
			if param.Player == pn then
				self:visible(false);
			end;
		end;
		Def.ActorFrame {
			InitCommand=cmd(x,2;y,7+10;player,pn);
			LoadActor(THEME:GetPathG("_StepsDisplayListRow cursor", string.lower(ToEnumShortString(pn))))..{
			};
		};
		Def.ActorFrame {
			Def.DifficultyIcon {
				File="_difftable";
				InitCommand=cmd(rotationz,-90;);
				SetCommand=function(self, params)
					local SongOrCourse = CurSOSet();
					local StepsOrTrail = CurSTSet(pn);
					if SongOrCourse and StepsOrTrail then
						local dc = StepsOrTrail:GetDifficulty()
						self:SetFromDifficulty( dc );
					else
						self:Unset();
					end;
				end;
				CurrentCourseChangedMessageCommand=cmd(playcommand,"Set");
				CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Set");
				CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Set");
			};
			LoadActor( THEME:GetPathG("StepsDisplay","autogen") )..{
				InitCommand=cmd(x,22;y,-2;);
				OnCommand=cmd(zoomy,0;sleep,0.2;linear,0.2;zoomy,1;);
				SetCommand=function(self, params)
					self:visible(false);
					self:finishtweening();
					local SongOrCourse = CurSOSet();
					if SongOrCourse then
						if SongOrCourse:IsAutogen() then
							self:visible(true);
							self:finishtweening();
							(cmd(glowshift;effectcolor1,color("0.7,1,0,0.5");effectcolor2,color("1,1,1,0");effectperiod,1))(self);
						end;
					end;
				end;
				CurrentCourseChangedMessageCommand=cmd(playcommand,"Set");
			};
		};
	};
end;

return t;