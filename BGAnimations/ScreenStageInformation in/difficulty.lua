--20180210
local t = Def.ActorFrame{};

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
	local st = GAMESTATE:GetCurrentStyle():GetStepsType();
	local SongOrCourse = CurSOSet();
	local StepsOrTrail = CurSTSet(pn);
	t[#t+1] = Def.ActorFrame{
		InitCommand=function(self)
			self:y(SCREEN_TOP+60);
			if pn == PLAYER_1 then
				self:horizalign(left);
				self:x(SCREEN_LEFT+60);
			else
				self:horizalign(right);
				self:x(SCREEN_RIGHT-60);
			end;
		end;
		LoadActor("diffback")..{
			InitCommand=function(self)
				if pn == PLAYER_1 then
					self:x(34);
				else
					self:x(-34);	
					self:rotationy(180);
				end;
			end;
			OnCommand=cmd(croptop,1;sleep,0.45;linear,0.2;croptop,0;sleep,1.95;linear,0.2;croptop,1;);
		};
		LoadActor( THEME:GetPathG("DiffDisplay","frame/frame") )..{
			Name="Frame";
			InitCommand=cmd(animate,false;playcommand,"Update");
		};
		LoadFont("StepsDisplay meter")..{
			Name="Meter";
			InitCommand=function(self)
				self:y(-4);
				if pn == PLAYER_1 then
					self:x(62);
					self:horizalign(left);
				else
					self:x(-62);
					self:horizalign(right);
				end;
				(cmd(maxwidth,60;zoom,0.8;skewx,-0.5;shadowlength,3;))(self)
			end;
		};
		Def.Sprite{
			Name="P_Label";
			InitCommand=function(self)
				self:shadowlength(1);
				self:y(-30);
				if pn == PLAYER_1 then
					self:x(-56);
					self:horizalign(left);
				else
					self:x(56);
					self:horizalign(right);
				end;
			end;
		};
		
		LoadFont("_Shared2")..{
			Name="Author";
			InitCommand=function(self)
				(cmd(y,22;zoom,0.5;maxwidth,240;shadowlength,1;))(self)
				if pn == PLAYER_1 then
					self:x(-38);
					self:horizalign(left);
				else
					self:x(38);
					self:horizalign(right);
				end;
			end;
		};
		LoadFont("_Shared2")..{
			Name="Description";
			InitCommand=function(self)
				(cmd(y,34;zoom,0.5;maxwidth,240;shadowlength,1;))(self)
				if pn == PLAYER_1 then
					self:x(-38);
					self:horizalign(left);
				else
					self:x(38);
					self:horizalign(right);
				end;
			end;
		};
		OnCommand=function(self)
			local s_frame = self:GetChild('Frame');
			local s_meter = self:GetChild('Meter');
			local s_p_label = self:GetChild('P_Label');
			local s_author = self:GetChild('Author');
			local s_description = self:GetChild('Description');
			local difficultyStates = {
				Difficulty_Beginner	= 0,
				Difficulty_Easy		= 2,
				Difficulty_Medium	= 4,
				Difficulty_Hard		= 6,
				Difficulty_Challenge	= 8,
				Difficulty_Edit		= 10,
			};
			s_frame:visible(false);
			if StepsOrTrail then
				local state = difficultyStates[StepsOrTrail:GetDifficulty()];
				if pn == PLAYER_2 then state = state + 1; end;
				s_frame:visible(true);
				s_frame:setstate(state);
				(cmd(cropbottom,1;sleep,0.5;accelerate,0.15;cropbottom,0;sleep,1.95;linear,0.2;cropbottom,1;))(s_frame)
			end;
			
			s_meter:visible(false);
			s_description:visible(false);
			if not GAMESTATE:IsCourseMode() then
				s_meter:stoptweening();
				s_meter:settext("");
				s_author:settext("");
				s_description:settext("");
				if SongOrCourse then
					if SongOrCourse:HasStepsTypeAndDifficulty(st,StepsOrTrail:GetDifficulty()) then
						local meter = StepsOrTrail:GetMeter();
						local stname = StepsOrTrail:GetChartName() ~= "" and StepsOrTrail:GetChartName() or StepsOrTrail:GetDescription();
						local aname = StepsOrTrail:GetAuthorCredit();
						if GetAdhocPref("UserMeterType") == "CSStyle" then
							if StepsOrTrail:GetDifficulty() ~= "Difficulty_Edit" then
								meter = GetConvertDifficulty(SongOrCourse,StepsOrTrail:GetDifficulty());
							else
								meter = GetConvertDifficulty(SongOrCourse,"Difficulty_Edit",StepsOrTrail);
							end;
						end;
						s_meter:visible(true);
						s_meter:settextf("%d",meter);
						s_meter:diffuse(CustomDifficultyToColor(StepsOrTrail:GetDifficulty()));
						s_meter:strokecolor(CustomDifficultyToDarkColor(StepsOrTrail:GetDifficulty()));
						s_author:visible(true);
						s_author:settext(aname);
						s_description:visible(true);
						s_description:settext(stname);
					end;
				end;
			end;
			
			local xmove = -10;
			s_p_label:Load(THEME:GetPathB("ScreenEvaluation","underlay/_player1"));
			if pn == PLAYER_2 then
				xmove = 10;
				s_p_label:Load(THEME:GetPathB("ScreenEvaluation","underlay/_player2"));
			end;
			(cmd(addx,xmove;addy,10;diffusealpha,0;sleep,0.55;linear,0.1;addx,xmove*-1;addy,-10;
			diffusealpha,1;sleep,1.95;linear,0.2;addx,xmove;addy,10;diffusealpha,0;))(s_meter);
			(cmd(addy,6;diffusealpha,0;sleep,1.25;decelerate,0.3;addy,-6;
			diffusealpha,1;sleep,1.1;accelerate,0.2;addx,xmove;zoomy,0;diffusealpha,0;))(s_author);
			(cmd(addy,6;diffusealpha,0;sleep,1.35;decelerate,0.3;addy,-6;
			diffusealpha,1;sleep,1.25;accelerate,0.2;addx,xmove;zoomy,0;diffusealpha,0;))(s_description);
			(cmd(croptop,1;sleep,0.7;linear,0.15;croptop,0;sleep,1.95;linear,0.2;addx,xmove;addy,10;diffusealpha,0;))(s_p_label)
		end;
	};
end;

return t;