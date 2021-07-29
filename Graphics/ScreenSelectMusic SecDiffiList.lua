local t = Def.ActorFrame{};

local csctext = THEME:GetString("MusicWheel","CustomItemCSCText");
local cdiff;
local pdiff;
local song;
local course;
local dif_st = {
	Difficulty_Beginner	= 0,
	Difficulty_Easy		= 1,
	Difficulty_Medium	= 2,
	Difficulty_Hard		= 3,
	Difficulty_Challenge	= 4,
	Difficulty_Edit		= 4
};
local cdiffnum = {0,0};
local cdiffx = {0,0};

if GAMESTATE:GetCurrentStyle() then
local style = GAMESTATE:GetCurrentStyle();
local stepsType = style:GetStepsType();
end;

--[ja] 難易度カーソル
--[ja] 20160102 セクション表示時にも難易度一覧を表示し、なおかつ変更可能に
for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
	local p = ( (pn == "PlayerNumber_P1") and 1 or 2 );
	t[#t+1] = Def.ActorFrame {
		InitCommand=cmd(x,-20;);
		LoadActor(THEME:GetPathG("_StepsDisplayListRow cursor", ToEnumShortString(pn)))..{
			InitCommand=cmd(rotationz,90;playcommand,"CC";);
			PlayerJoinedMessageCommand=function(self, params)
				if params.Player == pn then
					self:visible(true);
				end;
			end;
			PlayerUnjoinedMessageCommand=function(self, params)
				if params.Player == pn then
					self:visible(true);
				end;
			end;
			OnCommand=function(self)
				cdiff = GAMESTATE:GetCurrentSteps(pn):GetDifficulty();
				if cdiff then
					GAMESTATE:SetPreferredDifficulty(pn,cdiff);
				end;
				self:playcommand("CC");
			end;
			PreferredDifficultyP1ChangedMessageCommand=cmd(playcommand,"CC");
			PreferredDifficultyP2ChangedMessageCommand=cmd(playcommand,"CC");
			CurrentSongChangedMessageCommand=function(self)
				self:visible(false);
				song = GAMESTATE:GetCurrentSong();
				course = GAMESTATE:GetCurrentCourse();
				if not song and not course then
					self:visible(true);
					self:playcommand("CC");
				else
					--[ja] 20160102 セクション表示時と選曲項目表示時の難易度を一致させる
					if pn and GAMESTATE:GetCurrentSteps(pn) then
						cdiff = GAMESTATE:GetCurrentSteps(pn):GetDifficulty();
if stepsType then
						local cstep = song:GetOneSteps(stepsType,GAMESTATE:GetPreferredDifficulty(pn));
else
song:GetOneSteps(1,GAMESTATE:GetPreferredDifficulty(pn));
end;
						GAMESTATE:SetCurrentSteps(pn,cstep);
					end;
				end;
			end;
			CurrentCourseChangedMessageCommand=cmd(playcommand,"CurrentSongChangedMessage");
			CCCommand=function(self)
				if not self:GetVisible() then return;
				end;
				if #GAMESTATE:GetHumanPlayers() > 1 then
					local pdiff1 = GAMESTATE:GetPreferredDifficulty(PLAYER_1);
					local pdiff2 = GAMESTATE:GetPreferredDifficulty(PLAYER_2);
					if pdiff1 == pdiff2 then
						cdiffx[1] = -11;
					else cdiffx[1] = 0;
					end;
					self:x(cdiffx[p]);
				end;
				pdiff = GAMESTATE:GetPreferredDifficulty(pn);
				if pdiff then
					cdiffnum[p] = dif_st[pdiff];
					self:decelerate(0.05);
					self:y(cdiffnum[p] * 92);
				else
					self:decelerate(0.05);
					self:y(0);
				end;
				--self:finishtweening();
			end;
			OffCommand=function(self)
				cdiff = GAMESTATE:GetCurrentSteps(pn):GetDifficulty();
				if cdiff and pdiff then
					GAMESTATE:SetPreferredDifficulty(pn,cdiff);
				end;
			end;
			--PDiffSetMessageCommand=cmd(playcommand,"Off";);
		};
	};
end;

--[ja] 難易度一覧
for difflist = 1, 5 do
	t[#t+1] = Def.ActorFrame {
		InitCommand=function(self)
			self:stoptweening();
			self:y((difflist-1) * 92);
		end;
		OnCommand=function(self)
			self:visible(false);
		end;
		CurrentSongChangedMessageCommand=function(self)
			self:visible(false);
			song = GAMESTATE:GetCurrentSong();
			course = GAMESTATE:GetCurrentCourse();
			if not song and not course then
				self:visible(true);
			end;
		end;
		CurrentCourseChangedMessageCommand=cmd(playcommand,"CurrentSongChangedMessage");
		LoadActor(THEME:GetPathG("", "_difftable"))..{
			InitCommand=function(self)
				(cmd(visible,false;animate,false;setstate,0;playcommand,"Set"))(self)
			end;
			CurrentSongChangedMessageCommand=function(self)
				local song = GAMESTATE:GetCurrentSong();
				self:visible(false);
				if not song then
					self:visible(true);
					self:setstate(difflist-1);
				end;
			end;
		};
	};
end;

return t;
