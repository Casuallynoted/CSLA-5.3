--[[ ScreenSelectMusicCS decorations ]]
local t = LoadFallbackB();

setenv("exflag","csc");
setenv("keycount",0);

t[#t+1] = StandardDecorationFromFileOptional( "BannerFrame","BannerFrame" );
t[#t+1] = StandardDecorationFromFileOptional( "StageDisplay", "StageDisplay" );
t[#t+1] = StandardDecorationFromFileOptional( "SongLength", "SongLength" );	-- plus machine rank
t[#t+1] = StandardDecorationFromFileOptional( "PointDisplay", "PointDisplay" );
t[#t+1] = StandardDecorationFromFileOptional( "GrooveRadar", "GrooveRadar" );
t[#t+1] = StandardDecorationFromFileOptional( "PaneDisplayTextP1","PaneDisplayTextP1" );
t[#t+1] = StandardDecorationFromFileOptional( "PaneDisplayTextP2","PaneDisplayTextP2" );
t[#t+1] = StandardDecorationFromFileOptional( "NoteScoreDataP1","NoteScoreDataP1" );
t[#t+1] = StandardDecorationFromFileOptional( "NoteScoreDataP2","NoteScoreDataP2" );
t[#t+1] = StandardDecorationFromFileOptional("TLDifficulty","TLDifficulty");

if GAMESTATE:IsCourseMode() then
	for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
		local diffIcon = LoadActor( THEME:GetPathG( Var "LoadingScreen", "DifficultyIcon" ), pn );
		t[#t+1] = StandardDecorationFromTable( "DifficultyIcon" .. ToEnumShortString(pn), diffIcon );
	end
end;

--t[#t+1] = StandardDecorationFromFileOptional("SongOptions","SongOptions");

t[#t+1] = Def.ActorFrame{
	Name="OptionIcons";
	InitCommand=function(self)
		-- xxx: encapsulate this into a function
		self:y(SCREEN_CENTER_Y+210);
		self:draworder(96);
	end;

	LoadActor(THEME:GetPathB("ScreenSelectMusic","decorations/OptionIconsSel"), PLAYER_1)..{
		InitCommand=cmd(player,PLAYER_1;x,(SCREEN_CENTER_X*0.575)-70.5;);
		OnCommand=cmd(zoom,0.78;zoomy,0;sleep,0.5;linear,0.3;zoomy,0.78);
	};

	LoadActor(THEME:GetPathB("ScreenSelectMusic","decorations/OptionIconsSel"), PLAYER_2)..{
		InitCommand=cmd(player,PLAYER_2;x,(SCREEN_CENTER_X*1.425)-16;);
		OnCommand=cmd(zoom,0.78;zoomy,0;sleep,0.5;linear,0.3;zoomy,0.78);
	};
};

--[ja] 難易度変更インプット系
local sys_dif = {4,4};
local sys_dif_old={4,4};

local dif_list = {
	'Difficulty_Beginner',
	'Difficulty_Easy',
	'Difficulty_Medium',
	'Difficulty_Hard',
	'Difficulty_Challenge'
};

local dif_st = {
	Difficulty_Beginner	= 1,
	Difficulty_Easy		= 2,
	Difficulty_Medium	= 3,
	Difficulty_Hard		= 4,
	Difficulty_Challenge	= 5
};
local key_open = 0;
local song;
local cccsong = ""
local sys_difunlock;
local pn;
if GAMESTATE:IsHumanPlayer(PLAYER_1) then pn = PLAYER_1
else  pn = PLAYER_2
end;
local p = (pn == PLAYER_1) and 1 or 2;
local st = GAMESTATE:GetCurrentStyle():GetStepsType();

local diff_ta = {0,0,0,0,0};
local dwidth = 92;
local diff_ma = dwidth;
local c_diff = {1,1};
local tempx = {0,0};
local pnSteps;
local cscheck = {0,0};

t[#t+1] = Def.ActorFrame{
	OnCommand=function(self)
		key_open = 1;
		--[ja] 20150206修正 難易度が正しくセットされない問題
		self:playcommand("CC");
	end;
	CodeMessageCommand = function(self, params)
		if GAMESTATE:IsHumanPlayer(params.PlayerNumber) then
			song = GAMESTATE:GetCurrentSong();
			if (params.Name == 'Up' or params.Name == 'Up2') then
				local upcheck = {0,0};
				if key_open == 1 then
					local sys_dif_tmp = sys_dif[p];
					local count = sys_dif_tmp;
					if song then
						if sys_dif_tmp > 1 then
							count = count - 1;
							while count > 0 do
								if getenv("sys_difunlock")[count] == true and song:HasStepsTypeAndDifficulty(st,dif_list[count]) then
									upcheck[p] = 1;
									cscheck[p] = 1;
									break;
								end;
								if upcheck[p] == 0 then
									count = count - 1;
								end;
							end;
						end;
					end;
					if upcheck[p] == 1 then
						sys_dif[p] = count;
						MESSAGEMAN:Broadcast("UpDifficulty");
						sys_dif_old[p] = sys_dif[p];
						self:playcommand("CC");
					end;
				end;
			elseif (params.Name == 'Down' or params.Name == 'Down2') then
				local downcheck = {0,0};
				if key_open == 1 then
					local sys_dif_tmp = sys_dif[p];
					local count = sys_dif_tmp;
					if song then
						if sys_dif_tmp < #dif_list then
							count = count + 1;
							while count <= #dif_list do
								if getenv("sys_difunlock")[count] == true and song:HasStepsTypeAndDifficulty(st,dif_list[count]) then
									downcheck[p] = 1;
									cscheck[p] = 1;
									break;
								end;
								if downcheck[p] == 0 then
									count = count + 1;
								end;
							end;
						end;
					end;
					if downcheck[p] == 1 then
						sys_dif[p] = count;
						MESSAGEMAN:Broadcast("DownDifficulty");
						sys_dif_old[p] = sys_dif[p];
						self:playcommand("CC");
					end;
				end;
			elseif params.Name=="Start" or params.Name == "Start2" or 
			params.Name == "Center" or params.Name == "Center2" then
				if CurGameName() == "dance" then
					key_open = 0;
				end;
			end;
		end;
	end;
	CurrentSongChangedMessageCommand=function(self)
		if song then
			self:playcommand("CC");
		end;
	end;
	CCCommand=function(self)
		-- [ja] 選択可能難易度確認
		song = GAMESTATE:GetCurrentSong();
		local newstep;
		if GAMESTATE:IsHumanPlayer('PlayerNumber_P'..p) then
			if song then
				local check = {0,0};
				if cscheck[p] == 0 then
					local count = 5;
					while count > 0 do
						if getenv("sys_difunlock")[sys_dif_old[p]] == true and song:HasStepsTypeAndDifficulty(st,dif_list[sys_dif_old[p]]) then
							check[p] = 2;
							break;
						end;
						if getenv("sys_difunlock")[sys_dif[p]] == true and song:HasStepsTypeAndDifficulty(st,dif_list[sys_dif[p]]) then
							check[p] = 1;
							break;
						end;
						if check[p] == 0 then
							sys_dif[p] = count;
							count = count - 1;
						end;
					end;
					if check[p] == 2 then
						newstep = song:GetOneSteps(st,dif_list[sys_dif_old[p]]);
						sys_dif[p] = sys_dif_old[p];
					else newstep = song:GetOneSteps(st,dif_list[sys_dif[p]]);
					end;
				else
					newstep = song:GetOneSteps(st,dif_list[sys_dif_old[p]]);
					sys_dif[p] = sys_dif_old[p];
					cscheck[p] = 0;
				end;
			end;
			if newstep then
				GAMESTATE:SetCurrentSteps('PlayerNumber_P'..p,newstep);
			end;
		end;
	end;
};

--[ja] 難易度カーソル
for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
	t[#t+1] = Def.ActorFrame{
		InitCommand=function(self)
			self:zoom(0.8);
			self:x(SCREEN_CENTER_X-154-73.5);
			self:y(SCREEN_CENTER_Y+130);
		end;
		OnCommand=cmd(addx,-20;decelerate,0.5;addx,20;);
		
		LoadActor(THEME:GetPathG("_StepsDisplayListRow cursor", ToEnumShortString(pn)))..{
			InitCommand=function(self)
				self:playcommand("Set");
			end;
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
				self:playcommand("CC");
			end;
			CurrentStepsP1ChangedMessageCommand=function(self)
				self:playcommand("CC");
			end;
			CurrentStepsP2ChangedMessageCommand=function(self)
				self:playcommand("CC");
			end;
			CurrentSongChangedMessageCommand=function(self)
				if sys_dif[p] ~= sys_dif_old[p] and diff_ta[sys_dif_old[p]] > 0 then
					c_diff[p] = sys_dif_old[p];
				else c_diff[p] = sys_dif[p];
				end;
				if song then
					self:playcommand("CC");
				end;
				--SCREENMAN:SystemMessage(sys_dif[p]..","..sys_dif_old[p]);
			end;
			CCCommand=function(self)
				pnSteps = GAMESTATE:GetCurrentSteps(pn);
				diff_ma = dwidth;
				song = GAMESTATE:GetCurrentSong();
				local dif_unlock = getenv("sys_difunlock");
				local cdiffnum = {5,5};
				for difflist = 1, 5 do
					if song then
						if getenv("sys_difunlock")[difflist] == true and song:HasStepsTypeAndDifficulty(st,dif_list[difflist]) then
							diff_ma = diff_ma + dwidth;
							diff_ta[difflist] = diff_ma;
							cdiffnum = 1
						else
							diff_ma = diff_ma;
							diff_ta[difflist] = 0;
						end;
						
					end;
					
				end;
				self:finishtweening();
				self:playcommand("Set");
			end;
			SetCommand=function(self)
				if GAMESTATE:IsHumanPlayer(pn) then
					pnSteps = GAMESTATE:GetCurrentSteps(pn);
					if pnSteps then
						self:x(tempx[p]);
						self:decelerate(0.05);
						self:x(diff_ta[dif_st[pnSteps:GetDifficulty()]]);
						c_diff[p] = sys_dif[p];
						tempx[p] = diff_ta[dif_st[pnSteps:GetDifficulty()]];
					end;
				end;
			end;
		};
	};
end;

--[ja] 難易度一覧
t[#t+1] = LoadActor("difflist")..{
	InitCommand=cmd(x,SCREEN_CENTER_X-153.5;y,SCREEN_CENTER_Y+114;draworder,90;);
	OnCommand=cmd(rotationz,-90;zoom,0.8;addx,-20;decelerate,0.5;addx,20;);
};

return t;