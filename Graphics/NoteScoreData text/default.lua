
--[[ NoteScoreData text ]]

local pn = ...
assert(pn,"Must pass in a player, dingus");

local pm = GAMESTATE:GetPlayMode();
local SongOrCourse = "";
local StepsOrTrail = "";
local SorCTime = 0;
local bIsCourseMode = GAMESTATE:IsCourseMode();
local coursetype = true;

local p = ( (pn == "PlayerNumber_P1") and 1 or 2 );
local pstr = ProfIDSet(p);
local gset = judge_initial(pstr);

local t = Def.ActorFrame{
	Name="NoteScoreData"..pn;
	BeginCommand=function(self)
		self:visible(GAMESTATE:IsHumanPlayer(pn));
	end;
	PlayerJoinedMessageCommand=function(self,param)
		if param.Player == pn then
			self:visible(coursetype);
		end;
	end;
	PlayerUnjoinedMessageCommand=function(self,param)
		if param.Player == pn then
			self:visible(false);
		end;
	end;
};

local statsCategoryValues = {
	{ Category = "HoldNoteScore_Held" , Color = Colors.Judgment["JudgmentLine_Held"]},
	{ Category = "TapNoteScore_Miss" , Color = Colors.Judgment["JudgmentLine_Miss"]},
	{ Category = "TapNoteScore_W5" , Color = Colors.Judgment["JudgmentLine_W5"]},
	{ Category = "TapNoteScore_W4" , Color = Colors.Judgment["JudgmentLine_W4"]},
	{ Category = "TapNoteScore_W3" , Color = Colors.Judgment["JudgmentLine_W3"]},
	{ Category = "TapNoteScore_W2" , Color = Colors.Judgment["JudgmentLine_W2"]},
	{ Category = "TapNoteScore_W1" , Color = Colors.Judgment["JudgmentLine_W1"]},
};

local hs = {};


local nGrade = {
	Grade_Tier01 = "MAX";
	Grade_Tier02 = "Grade_Tier01";
	Grade_Tier03 = "Grade_Tier02";
	Grade_Tier04 = "Grade_Tier03";
	Grade_Tier05 = "Grade_Tier04";
	Grade_Tier06 = "Grade_Tier05";
	Grade_Tier07 = "Grade_Tier06";
	Grade_Failed = nil;
	Grade_None = nil;
};

local nGradeSM = {
	Grade_Tier01 = "MAX";
	Grade_Tier02 = "MAX";
	Grade_Tier03 = "Grade_Tier02";
	Grade_Tier04 = "Grade_Tier03";
	Grade_Tier05 = "Grade_Tier04";
	Grade_Tier06 = "Grade_Tier05";
	Grade_Tier07 = "Grade_Tier06";
	Grade_Failed = nil;
	Grade_None = nil;
};


local MIGS = {ntype = 0,default = 0};
local MIGS_MAX = {ntype = 0,default = 0};
local tGrade = {ntype = "Grade_None",default = "Grade_None"};
local ss = {ntype = "Grade_None",default = "Grade_None"};
local fcheck = 5;
local topscore;
local stl = {ntype = "CS",default = "SM"};
if GAMESTATE:GetCurrentStyle() then
local st = GAMESTATE:GetCurrentStyle();
local sttype = st:GetStepsType();
end;
local judgewidth = 288;
local g_judge_t_set_tbl = {};
local SorCDir;
local sdirs;
local cr_path = "";
local tmpo = "";
local pid_name;
local rv_table;
if PROFILEMAN:IsPersistentProfile(pn) then
	pid_name = PROFILEMAN:GetProfile(pn):GetGUID().."_"..PROFILEMAN:GetProfile(pn):GetDisplayName();
	if #rival_table(pstr,PROFILEMAN:GetProfile(pn),"") > 0 then
		rv_table = rival_table(pstr,PROFILEMAN:GetProfile(pn),pid_name);
	end;
end;
local adgraph = ProfIDPrefCheck("ScoreGraph",pstr,"Off");
local adtype = ProfIDPrefCheck("GraphType",pstr,"CS");
---------------------------------------------------------------------------------------------------------------------------------------
t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(playcommand,"JudgeSetting",{GSet = gset,Player = pn};);
	OnCommand=cmd(playcommand,"JudgeSetting",{GSet = gset,Player = pn};);
	JudgeSettingMessageCommand=function(self,params)
		if params.Player ~= pn then return;
		end;
		self:visible(false);
		if params.GSet then
			if params.GSet ~= getenv("judgesetp"..p) then
				gset = getenv("judgesetp"..p); 
			end;
		end;
		MIGS["ntype"]						= 0;
		MIGS["default"]						= 0;
		MIGS_MAX["ntype"]					= 0;
		MIGS_MAX["default"]					= 0;
		tGrade["ntype"]						= "Grade_None";
		tGrade["default"]					= "Grade_None";
		ss["ntype"]						= "Grade_None";
		ss["default"]						= "Grade_None";
		hs_local_set(hs,0);
		gradegraphwidth						= 0;

		if getenv("wheelstop") == 1 then
			SongOrCourse = CurSOSet();
			StepsOrTrail = CurSTSet(pn);
			steps_count(hs,SongOrCourse,StepsOrTrail,pn,"Course");
			if getenv("rnd_song") == 1 then
				tGrade["ntype"]						= "Grade_None";
				tGrade["default"]					= "Grade_None";
				ss["ntype"]						= "Grade_None";
				ss["default"]						= "Grade_None";
				hs_local_set(hs,"?");
				gradegraphwidth						= "?";	
			elseif SongOrCourse and StepsOrTrail then
				if bIsCourseMode then
					--20160504
					SorCTime = courselength(SongOrCourse,GAMESTATE:GetCurrentTrail(pn),st:GetStepsType());
					SorCDir = SongOrCourse:GetCourseDir();
					--SCREENMAN:SystemMessage(SorCTime);
				else
					SorCTime = SongOrCourse:GetLastSecond();
					SorCDir = SongOrCourse:GetSongDir();
				end;

				local profile = c_profile(pn);
				if PROFILEMAN:IsPersistentProfile(pn) then
					pid_name = profile:GetGUID().."_"..profile:GetDisplayName();
				end;
				if SorCDir ~= "" then
					sdirs = split("/",SorCDir);
					if sdirs and sdirs[2] then
						sdirs[2] = additionaldir_to_songdir(sdirs[2]);
					end;
					if pid_name then
						cr_path = "CSRealScore/"..pid_name.."/"..sdirs[2].."/"..sdirs[3].."/"..sdirs[4].."/set_"..wpsetd.."_"..swpsetd;
					end;
				end;

				local scorelist = profile:GetHighScoreList(SongOrCourse,StepsOrTrail);
				assert(scorelist);
				local scores = scorelist:GetHighScores();
				topscore = scores[1];
				local snum = snum_set(1,scores,pn);
				if snum > 0 then
					topscore = scores[snum];
					if topscore then
						hs_set(hs,topscore,"normal");
						hs["SurvivalSeconds"]		= topscore:GetSurvivalSeconds();
						if bIsCourseMode then
							hs["SurvivalSeconds"]	= SorCTime + 1;
						end;
						fcheck = fullcombochecker(hs,SorCTime);
						hs["Grade"] = gradechecker(hs,topscore:GetGrade(),SorCTime,params.GSet,fcheck);
						tGrade["ntype"] = gradechecker(hs,topscore:GetGrade(),SorCTime,"ntype",fcheck);
						tGrade["default"] = gradechecker(hs,topscore:GetGrade(),SorCTime,"default",fcheck);
					end;
				end;
				MIGS["ntype"] = migschecker(hs,"ntype");
				MIGS["default"] = migschecker(hs,"default");
				MIGS_MAX["ntype"] = migsmaxchecker(hs,"ntype");
				MIGS_MAX["default"] = migsmaxchecker(hs,"default");
				if MIGS_MAX[params.GSet] <= 0 then MIGS_MAX[params.GSet] = 1; end;
			end;
			ss["ntype"] = nGrade[tGrade["ntype"]];
			ss["default"] = nGradeSM[tGrade["default"]];
			self:finishtweening();
			self:sleep(1);
			self:visible(true);
		else
			SongOrCourse = "";
			StepsOrTrail = "";
		end;
	end;
};

if pm ~= 'PlayMode_Endless' and pm ~= 'PlayMode_Rave' and GAMESTATE:IsHumanPlayer(pn) then
	t[#t+1] = LoadActor("rival_display", pn)..{
	};
end;

t[#t+1] = Def.Sprite{
	InitCommand=cmd(y,80;);
	OnCommand=function(self)
		self:visible(false);
		if GAMESTATE:IsHumanPlayer(pn) then
			if coursetype and getenv("wheelstop") == 1 then
				local xset = { {8,-30,30},{-8,30,-30} };
				self:visible(true);
				self:Load(THEME:GetPathG("NoteScoreData","text/"..p.."_jadgeback"));
				(cmd(stoptweening;x,xset[p][1];addx,xset[p][2];diffusealpha,0;sleep,1;decelerate,0.15;addx,xset[p][3];diffusealpha,1;))(self);
			end;
		end;
	end;
};

--[ja] 20160126修正 判定平均ボックスのオーバーフロー問題を修正
--[ja] 20160129修正 引き続きホイールを高速で回すとセクションなどの時に曲情報をとってしまいダイアログが出てしまう問題を修正
local stable = Def.ActorFrame{};
stable[#stable+1] = Def.ActorFrame{
	OnCommand=cmd(playcommand,"SJudgeSetting",{GSet = gset,Player = pn};);
	SJudgeSettingMessageCommand=function(self,params)
		g_judge_t_set_tbl = {};
		if getenv("wheelstop") == 1 and getenv("rnd_song") == 0 and SongOrCourse then
		--[ja] 判定平均ボックス ---------------------------------------------------------------------------
		--[ja] 20150916修正
			if FILEMAN:DoesFileExist( cr_path ) and sttype and StepsOrTrail then
				if StepsOrTrail ~= "" and StepsOrTrail:GetDifficulty() then
					if GetRSParameter( cr_path,sttype.."_"..ToEnumShortString(StepsOrTrail:GetDifficulty()) .."/"..stl[params.GSet]) ~= "" then
						tmpo = split( ":",GetRSParameter( cr_path,sttype.."_"..ToEnumShortString(StepsOrTrail:GetDifficulty()) .."/"..stl[params.GSet]) );
						if tmpo[3] then
							if MIGS[params.GSet] <= tonumber(tmpo[3]) then
								if tmpo[4] then
									g_judge_t_set_tbl = jbox_setting(tmpo[4],hs["TotalSteps"]);
								end;
							end;
						end;
					end;
				end;
			end;
			MESSAGEMAN:Broadcast("TSet",{GSet = gset,Player = pn});
		end;
	end;
};
--judgetable
local bxset = {29,-29};
local rx_set = 0;
if pn == PLAYER_2 then
	rx_set = 180;
end;
for j=1,g_box_setcount() do
	stable[#stable+1] = Def.ActorFrame{
		InitCommand=cmd(x,bxset[p];y,-85;rotationz,90;rotationy,rx_set);
		LoadActor(THEME:GetPathB("","ScreenEvaluation decorations/judgegraph"))..{
			InitCommand=cmd(horizalign,left;zoomtowidth,0;zoomtoheight,10;);
			OnCommand=cmd(stoptweening;cropright,1;sleep,1;playcommand,"JudgeSetting",{GSet = gset,Player = pn};);
			TSetMessageCommand=function(self,params)
				self:visible(false);
				if getenv("wheelstop") == 1 and getenv("rnd_song") == 0 and SongOrCourse then
					if #g_judge_t_set_tbl > 0 and j <= #g_judge_t_set_tbl then
						--[ja] 20150920修正
						local sl_set = math.max(0,scale(j,1,#g_judge_t_set_tbl,0.0025,0.125));
						self:visible(true);
						self:diffuse(color("0.5,0.5,0.5"));
						self:diffuse(JBoxColor[g_judge_t_set_tbl[j]]);
						self:diffusealpha(0.85);
						self:x( (judgewidth / #g_judge_t_set_tbl) * (j - 1) );
						(cmd(sleep,sl_set;linear,0.005;cropright,0;))(self)
						local space = 1;
						local zx = math.round((judgewidth / #g_judge_t_set_tbl));
						self:zoomtowidth( zx - space );
						self:skewx(scale(#g_judge_t_set_tbl,1,g_box_setcount(),0.0175,1.025));
					end;
				end;
			end;
		};
	};
end;
t[#t+1] = stable;

--notescore
for idx, cat in pairs(statsCategoryValues) do
	local statsCategory = cat.Category;
	local statsColor = cat.Color;

	t[#t+1] = Def.ActorFrame{
		OnCommand=cmd(playcommand,"JudgeSetting",{GSet = gset,Player = pn};);
		JudgeSettingMessageCommand=function(self,params)
			if params.Player ~= pn then return;
			end;
			if coursetype and getenv("wheelstop") == 1 then
				self:visible(true);
			else self:visible(false);
			end;
		end;
		LoadFont("_ul")..{
			InitCommand=cmd(zoom,0.45;sleep,idx/10;shadowlength,0;strokecolor,color("0,0,0,1"));
			OnCommand=cmd(stoptweening;diffusealpha,0;sleep,1.05;linear,0.1;diffusealpha,1;playcommand,"JudgeSetting",{GSet = gset,Player = pn};);
			JudgeSettingMessageCommand=function(self,params)
				if params.Player ~= pn then return;
				end;
				local value = "0";
				if getenv("wheelstop") == 1 then
					if pn == PLAYER_1 then
						(cmd(player,PLAYER_1;horizalign,left;rotationz,-45;x,-6;))(self);
					else (cmd(player,PLAYER_2;horizalign,right;rotationz,45;x,6;))(self);
					end;
					self:maxwidth(120);
					self:y(58+(math.abs(idx-7)*26));
					local value = 0;
					self:diffuse(statsColor);
					if getenv("rnd_song") == 1 then
						value = "?";
					elseif SongOrCourse and StepsOrTrail then
						if topscore then
							if not StepsOrTrail then
								self:diffusealpha(0.3);
								value = "0";
							elseif not SongOrCourse then
								self:diffusealpha(0.3);
								value = "0";
							else
								self:diffusealpha(1);
								value = hs[statsCategory];
							end;
						else
							self:diffusealpha(0.3);
							value = "0";
						end;
					else
						self:diffusealpha(0.3);
						value = "0";
					end;
					self:settext( value );
				end;
			end;
		};
	};
end;

--data
t[#t+1] = Def.ActorFrame{
	OnCommand=cmd(playcommand,"JudgeSetting",{GSet = gset,Player = pn};);
	JudgeSettingMessageCommand=function(self,params)
		if params.Player ~= pn then return;
		end;
		if coursetype and getenv("wheelstop") == 1 then
			self:visible(true);
		else self:visible(false);
		end;
	end;

	LoadFont("_ul")..{
		InitCommand=cmd(zoom,0.45;strokecolor,color("0,0,0,1"));
		OnCommand=cmd(stoptweening;diffusealpha,0;sleep,1.05;linear,0.1;diffusealpha,1;playcommand,"JudgeSetting",{GSet = gset,Player = pn};);
		JudgeSettingMessageCommand=function(self,params)
			if params.Player ~= pn then return;
			end;
			self:settext("");
			if getenv("wheelstop") == 1 then
				if SongOrCourse and StepsOrTrail then
					if pn == PLAYER_1 then
						(cmd(player,PLAYER_1;horizalign,left;rotationz,-45;x,-12;y,-15;))(self);
						self:settext("  "..MIGS[params.GSet].."\n:"..MIGS_MAX[params.GSet]);
					else
						(cmd(player,PLAYER_2;horizalign,right;rotationz,45;x,10;y,-17;))(self);
						self:settext(MIGS[params.GSet].."  \n:"..MIGS_MAX[params.GSet]);
					end;
				end;
			end;
		end;
	};

	LoadFont("_ul")..{
		InitCommand=cmd(horizalign,left;zoom,0.45;strokecolor,color("0,0,0,1"));
		OnCommand=cmd(stoptweening;diffusealpha,0;sleep,1.05;linear,0.1;diffusealpha,1;playcommand,"JudgeSetting",{GSet = gset,Player = pn};);
		JudgeSettingMessageCommand=function(self,params)
			if params.Player ~= pn then return;
			end;
			self:settext("");
			if getenv("wheelstop") == 1 then
				if SongOrCourse and StepsOrTrail then
					if pn == PLAYER_1 then
						(cmd(player,PLAYER_1;horizalign,left;rotationz,-45;x,-14;y,25))(self);
					else (cmd(player,PLAYER_2;horizalign,right;rotationz,45;x,10;y,21;))(self);
					end;
					local nextGrade = nGrade[tGrade[params.GSet]];
					if getenv("rnd_song") ~= 1 and tGrade[params.GSet] ~= "Grade_Failed" then
						--SCREENMAN:SystemMessage(MIGS[params.GSet]..","..MIGS_MAX[params.GSet]);
						if MIGS[params.GSet] == MIGS_MAX[params.GSet] then
							if pn == PLAYER_1 then
								self:settext("  MAX");
							else self:settext("MAX ");
							end;
						elseif ss[params.GSet] ~= nil then
							local nextGtext;
							local upTier = 0;
							if ss[params.GSet] == "MAX" then
								nextGtext = ss[params.GSet];
								upTier = 1;
							else
								nextGtext = THEME:GetString("Grade",ToEnumShortString(ss[params.GSet]));
								if params.GSet == "ntype" then
									upTier = THEME:GetMetric("PlayerStageStats","GradePercentCS"..ToEnumShortString(ss["ntype"]));
								else upTier = THEME:GetMetric("PlayerStageStats","GradePercent"..ToEnumShortString(ss["default"]));
								end;
							end;
							local nextp = math.ceil(MIGS_MAX[params.GSet] * upTier);
							local nextTScore = MIGS[params.GSet] - nextp;
							if pn == PLAYER_1 then
								self:settext("  :"..nextGtext.."\n"..nextTScore);
							else self:settext(":"..nextGtext.."  \n"..nextTScore);
							end;
						end;
					end;
				end;
			end;
		end;
	};
};

t.CurrentSongChangedMessageCommand=function(self)
	SongOrCourse = "";
	self:visible(false);
	self:stoptweening();
	if getenv("wheelstop") == 1 then
		SongOrCourse = CurSOSet();
		if SongOrCourse then
			if coursetype then
				self:visible(true);
				self:playcommand("On");
			end;
		end;
	end;
end;
t.CurrentCourseChangedMessageCommand=cmd(playcommand,"CurrentSongChangedMessage");

--[ja] 20160126修正
if pn == PLAYER_1 then
	t.CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"JudgeSetting",{GSet = gset,Player = pn});
	t.CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"JudgeSetting",{GSet = gset,Player = pn});
	stable.CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"SJudgeSetting",{GSet = gset,Player = pn});
	stable.CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"SJudgeSetting",{GSet = gset,Player = pn});
else
	t.CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"JudgeSetting",{GSet = gset,Player = pn});
	t.CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"JudgeSetting",{GSet = gset,Player = pn});
	stable.CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"SJudgeSetting",{GSet = gset,Player = pn});
	stable.CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"SJudgeSetting",{GSet = gset,Player = pn});
end;

return t;