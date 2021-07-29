
local pn = ...
assert(pn);

local t = Def.ActorFrame{};

local gset = "ntype";
local p = (pn == PLAYER_1) and 1 or 2;
local playername = GetAdhocPref("ProfIDSetP"..p);
if GetAdhocPref("P_ADCheck") ~= "OK" then
	playername = GAMESTATE:GetPlayerDisplayName(pn);
end;

local hs = {};
hs_local_set(hs,0);

setenv("fcplayercheck_p1",0);
setenv("fcplayercheck_p2",0);
local hsp1fullcombo = 5;
local hsp2fullcombo = 5;
setenv("fullcjudgep1",5);
setenv("fullcjudgep2",5);

setenv("evacountupflag",1);
--setenv("evacheckflag",1);

setenv("nomflagp1",0);
setenv("nomflagp2",0);
setenv("goexflagp1",0);
setenv("goexflagp2",0);

local bIsCourseMode = GAMESTATE:IsCourseMode();
local SongOrCourse = CurSOSet();
--local start = 0;
local soundset = 0;
local SorCTime = 0;
if bIsCourseMode then
	--20160504
	local sttype = GAMESTATE:GetCurrentStyle():GetStepsType();
	SorCTime = courselength(SongOrCourse,GAMESTATE:GetCurrentTrail(pn),sttype);
	--Trace( "cstepseconds: "..SorCTime );
else
	--start = SongOrCourse:GetFirstSecond();
	SorCTime = SongOrCourse:GetLastSecond();
end;
if not SorCTime then
	SorCTime = 0;
end;

local style = GAMESTATE:GetCurrentStyle();
local st = style:GetStepsType();
local fcacolor = "0,0,0";

local grade_set_point = {
	Tier01	= 3,
	Tier02	= 2,
	Tier03	= 1
};
local diff_set_point = {
	Beginner	= 2,
	Easy		= 2,
	Medium	= 3,
	Hard		= 4,
	Challenge	= 4
};
local fullcombo_set_point = {3,2,1};
local fullcombo_set_color = {"1,1,1","1,0.8,0.2","0,1,0.2","0.2,0.75,1"};

setmetatable( grade_set_point, { __index = function() return 0 end; } );
setmetatable( diff_set_point, { __index = function() return 0 end; } );
setmetatable( fullcombo_set_point, { __index = function() return 0 end; } );
setmetatable( fullcombo_set_color, { __index = function() return "1,1,1" end; } );

--[ja] オートプレイ時
if tonumber(getenv("fcplayercheck_p"..p)) == 0 then
	t[#t+1] = Def.ActorFrame {
		JudgmentMessageCommand=function(self, param)
			if param.Player == pn then
				--20160425
				if insertchecker(pn,"noset","controller_auto") then
					if param.TapNoteScore or param.HoldNoteScore then
						if param.Player == PLAYER_1 then setenv("fcplayercheck_p1",1);
						else setenv("fcplayercheck_p2",1);
						end;
					end;
				end;
			end;
		end;
	};
end;

t[#t+1] = Def.ActorFrame{
	InitCommand=function(self)
		self:diffusealpha(0);
		self:x( GetPosition(pn) );
	end;
	OffCommand=cmd(diffusealpha,1;playcommand,"Set";);
	SetCommand=function(self)
		self:stoptweening();
		self:visible(false);
		local ssStats = STATSMAN:GetCurStageStats();
		local pnstats = ssStats:GetPlayerStageStats(pn);
		steps_count(hs,SongOrCourse,GAMESTATE:GetCurrentSteps(pn),pn,"GamePlay");
		if getenv("tstepsp"..p) then
			hs["TotalSteps"]		= math.max(getenv("tstepsp"..p),hs["TotalSteps"]);
		end;
		if getenv("tholdsp"..p) then
			hs["RadarCategory_Holds"]	= math.max(getenv("tholdsp"..p),hs["RadarCategory_Holds"]);
			if getenv("tholdsp"..p) > 0 then
				hs["RadarCategory_Rolls"]			= 0;
			end;
		end;
		-- [ja] 今回のスコア
		hs_set(hs,pnstats,"pnstats");
		hs["SurvivalSeconds"]	 = GAMESTATE:GetSongPosition():GetMusicSeconds();
		if bIsCourseMode then
			hs["SurvivalSeconds"] = SorCTime + 1;
		end;
		setenv("aseconds",hs["SurvivalSeconds"]);
		--hscombo
		if tonumber(getenv("fcplayercheck_p"..p)) == 0 then
			if pn == PLAYER_1 then
				hsp1fullcombo = fullcombochecker(hs,SorCTime);
			else hsp2fullcombo = fullcombochecker(hs,SorCTime);
			end;
			local set = (pn == PLAYER_1) and hsp1fullcombo or hsp2fullcombo;
			--[ja] 20150726修正
			if tonumber(set) < 5 then
				fcacolor = fullcombo_set_color[tonumber(set)];
				--SCREENMAN:SystemMessage(fcacolor);
			else fcacolor = "0,0,0";
			end;
			--Trace("hspfullcombo: "..hsp1fullcombo.."/"..hsp2fullcombo);
		end;

		if not GAMESTATE:IsEventMode() then
			if not bIsCourseMode then
				if getenv("exflag") == "csc" and not GAMESTATE:IsExtraStage2() then
					local ccstpoint = getenv("ccstpoint");	--[ja] 今までの総合ポイント
					local oldpoint = 0;				--[ja] 今までのポイント
					local newpoint = 0;				--[ja] 今回のポイント
					
					local diffpoint = 0;
					local combopoint = 0;
					local gradepoint = 0;
					local gcsgrade = "Grade_None";
					if tonumber(getenv("fcplayercheck_p"..p)) == 0 then
						if not pnstats:GetFailed() then
							if tonumber(hs["SurvivalSeconds"]) >= tonumber(SorCTime) then
								if pn == PLAYER_1 then
									gcsgrade = gradechecker(hs,pnstats:GetGrade(),SorCTime,gset,hsp1fullcombo);
								else gcsgrade = gradechecker(hs,pnstats:GetGrade(),SorCTime,gset,hsp2fullcombo);
								end;
								local StepsOrTrail = GAMESTATE:GetCurrentSteps(pn);
								--[ja] 20150726修正
								gradepoint = grade_set_point[ToEnumShortString(gcsgrade)];
								diffpoint = diff_set_point[ToEnumShortString(StepsOrTrail:GetDifficulty())];
								if pn == PLAYER_1 then
									combopoint = fullcombo_set_point[hsp1fullcombo];
								else combopoint = fullcombo_set_point[hsp2fullcombo];
								end;
								--SCREENMAN:SystemMessage(gradepoint..","..diffpoint..","..combopoint);
								newpoint = gradepoint + diffpoint + combopoint;
								newpoint = math.min(10,newpoint);
							else
								newpoint = 0;
								gcsgrade = "Grade_Failed"
							end;
						else
							newpoint = 0;
							gcsgrade = "Grade_Failed"
						end;
					else
						newpoint = 0;
						gcsgrade = "Grade_Failed"
					end;
					setenv("newpoint",newpoint);
					--Trace("newpoint: "..gradepoint..","..diffpoint..","..combopoint);
					local cscgroup = "";
					if ssStats then
						cscgroup = ssStats:GetPlayedSongs()[1]:GetGroupName();
					end;
					local txt_folders = GetGroupParameter(cscgroup,"Extra1List");
					local chk_folders = "";
					if txt_folders ~= "" then
						chk_folders = split(":",txt_folders);
					end;
					local songst = getenv("songst");
					local cs_path = "/CSDataSave/"..playername.."_Save/0000_co "..cscgroup.."";
					local sys_songc =  "";
					if GetCSCParameter(cscgroup,"Status",playername) ~= "" then
						sys_songc = split(":",GetCSCParameter(cscgroup,"Status",playername));
					end;
					local stpoint = (#chk_folders * 7) + 1;
					local c_cset = 1;
					for l = 1, #sys_songc do
						local c_spoint = split(",",sys_songc[l]);
						if c_spoint[1] == songst then
							c_cset = 0;
						end;
					end;
					function GetCSCCount()
						local pointtext = {};
						local sys_spoint;
						local setpoint = 0;
						local setsong = "";
						if FILEMAN:DoesFileExist( cs_path ) then
							for k=1, #sys_songc + c_cset do
								if sys_songc[k] then
									sys_spoint = split(",",sys_songc[k]);
									if sys_spoint[1] == songst then
										--#sys_songc < #chk_folders == nil
										setsong = songst;
										if sys_spoint[2] then
											oldpoint = tonumber(sys_spoint[2]);
											if tonumber(sys_spoint[2]) < newpoint then
												setpoint = newpoint;
											else setpoint = sys_spoint[2];
											end;
										else setpoint = newpoint;
										end;
									else
										setsong = sys_spoint[1];
										if sys_spoint[2] then
											setpoint = sys_spoint[2];
										else setpoint = 0;
										end;
									end;
								else
									setsong = songst;
									setpoint = newpoint;
								end;
								pointtext[#pointtext+1] = { ""..setsong..","..setpoint..":" };
							end;
						else
							setsong = songst;
							setpoint = newpoint;
							pointtext[#pointtext+1] = { ""..setsong..","..setpoint..":" };
						end;
					
						return pointtext;
					end;

					local CSCList = GetCSCCount();
					local csctext = "#Status:";

					for i=1, #sys_songc + c_cset do
						if CSCList[i] then
							csctext = csctext..""..table.concat(CSCList[i]);
						else
							csctext = csctext;
						end;
					end;
					csctext = string.sub(csctext,1,-2);
					csctext = csctext..";\r\n";
					File.Write( cs_path , csctext );
					setenv("oldpoint",oldpoint);
					local neopoint = newpoint - oldpoint;
					if (newpoint - oldpoint) < 0 then neopoint = 0;
					end;
					if ccstpoint + neopoint >= stpoint then
						setenv("omsflag",1);
					else
						setenv("omsflag",0);
					end;
				else
					if GAMESTATE:IsExtraStage() then
						if ssStats then
							if tonumber(getenv("fcplayercheck_p"..p)) == 0 then
								if not pnstats:GetFailed() then
									if tonumber(hs["SurvivalSeconds"]) >= tonumber(SorCTime) then
										if hs["PercentScore"] >= PCheck(gset,"Grade_Tier03") then
											local pnSteps = GAMESTATE:GetCurrentSteps(pn):GetDifficulty();
											if SongOrCourse:GetOneSteps(st,"Difficulty_Challenge") then
												if SongOrCourse:GetOneSteps(st,"Difficulty_Hard") then
													if SongOrCourse:GetOneSteps(st,"Difficulty_Challenge"):GetMeter() >= 
													SongOrCourse:GetOneSteps(st,"Difficulty_Hard"):GetMeter() then
														if pnSteps == "Difficulty_Challenge" or pnSteps == "Difficulty_Hard" then
															if pn == PLAYER_1 then setenv("nomflagp1",1);
															else setenv("nomflagp2",1);
															end;
														end;
													else
														if pnSteps == "Difficulty_Hard" then
															if pn == PLAYER_1 then setenv("nomflagp1",1);
															else setenv("nomflagp2",1);
															end;
														end;
													end;
												else
													if pnSteps == "Difficulty_Challenge" then
														if pn == PLAYER_1 then setenv("nomflagp1",1);
														else setenv("nomflagp2",1);
														end;
													end;
												end;
											else
												if pnSteps == "Difficulty_Hard" then
													if pn == PLAYER_1 then setenv("nomflagp1",1);
													else setenv("nomflagp2",1);
													end;
												end;
											end;
										end;
									end;
								end;
							end;
						end;
					elseif GAMESTATE:GetCurrentStage() == "Stage_Final" then
						if GetAdhocPref("envAllowExtraStage") == true then
							if ssStats then
								if tonumber(getenv("fcplayercheck_p"..p)) == 0 then
									if not pnstats:GetFailed() then
										if tonumber(hs["SurvivalSeconds"]) >= tonumber(SorCTime) then
											if GAMESTATE:GetCurrentSteps(pn):GetDifficulty() == "Difficulty_Hard" or 
											GAMESTATE:GetCurrentSteps(pn):GetDifficulty() == "Difficulty_Challenge" then
												if hs["PercentScore"] >= PCheck(gset,"Grade_Tier03") then
													if pn == PLAYER_1 then setenv("goexflagp1",1);
													else setenv("goexflagp2",1);
													end;
												end;
											end;
										end;
									end;
								end;
							end;
							if getenv("goexflagp1") == 1 or getenv("goexflagp2") == 1 then
								PREFSMAN:SetPreference("AllowExtraStage",true);
							else
								PREFSMAN:SetPreference("AllowExtraStage",false);
							end;
						end;
					end;
				end;
			end;
		end;
		
		if tonumber(getenv("fcplayercheck_p"..p)) == 0 then
			if not assistchecker(pn,"noset") then
				if not pnstats:GetFailed() then
					--[ja] ScreenEvaluation overlayにもこの状態を送ります
					if pn == PLAYER_1 then
						if hsp1fullcombo > 0 and hsp1fullcombo < 5 then
							self:visible(true);
							setenv("fullcjudgep1",hsp1fullcombo );
						end;
					else
						if hsp2fullcombo > 0 and hsp2fullcombo < 5 then
							self:visible(true);
							setenv("fullcjudgep2",hsp2fullcombo );
						end;
					end;
				end;
			end;
			if hsp1fullcombo < 5 and hsp2fullcombo < 5 then
				if pn == PLAYER_1 then soundset = 1;
				end;
			else
				if hsp1fullcombo < 5 then
					if pn == PLAYER_1 then soundset = 1;
					end;
				elseif hsp2fullcombo < 5 then
					if pn == PLAYER_2 then soundset = 1;
					end;
				end;
			end;
		end;
	end;

	Def.Quad {
		InitCommand=cmd(shadowlength,0;draworder,102);
		BeginCommand=cmd(y,SCREEN_BOTTOM;vertalign,bottom;);
		SetCommand=function(self)
			(cmd(zoomtowidth,0;zoomtoheight,0;diffuse,color(fcacolor..",0.5");zoomtoheight,SCREEN_HEIGHT/9.5;
			accelerate,0.2;zoomtowidth,ColumnChecker()+48;linear,0.25;zoomtoheight,SCREEN_HEIGHT;linear,0.25;diffusealpha,0;))(self);
		end;
	};
	
	Def.Quad {
		InitCommand=cmd(shadowlength,0;draworder,103);
		BeginCommand=cmd(y,SCREEN_BOTTOM;vertalign,bottom;blend,'BlendMode_Add');
		SetCommand=function(self)
			(cmd(zoomtowidth,0;zoomtoheight,0;diffuse,color(fcacolor..",0.35");zoomtoheight,SCREEN_HEIGHT/8;
			accelerate,0.3;zoomtowidth,ColumnChecker()+48;linear,0.7;zoomtoheight,SCREEN_HEIGHT;diffusealpha,0;))(self);
		end;
	};
	
	Def.Quad {
		InitCommand=cmd(shadowlength,0;draworder,104);
		BeginCommand=cmd(y,SCREEN_CENTER_Y;);
		SetCommand=function(self)
			(cmd(diffusealpha,0;sleep,0.9;diffuse,color(fcacolor..",0.35");zoomtowidth,ColumnChecker()*0.5;
			zoomtoheight,SCREEN_HEIGHT;accelerate,0.25;zoomtowidth,ColumnChecker()*0.2;addx,-100;diffusealpha,0;))(self);
		end;
	};
	
	Def.Quad {
		InitCommand=cmd(shadowlength,0;draworder,105);
		BeginCommand=cmd(y,SCREEN_CENTER_Y;);
		SetCommand=function(self)
			(cmd(diffusealpha,0;sleep,0.9;diffuse,color(fcacolor..",0.35");zoomtowidth,ColumnChecker()*0.5;
			zoomtoheight,SCREEN_HEIGHT;accelerate,0.25;zoomtowidth,ColumnChecker()*0.2;addx,100;diffusealpha,0;))(self);
		end;
	};

	Def.Quad {
		InitCommand=cmd(shadowlength,0;draworder,106);
		BeginCommand=cmd(y,SCREEN_CENTER_Y;);
		SetCommand=function(self)
			(cmd(zoomtowidth,0;zoomtoheight,SCREEN_HEIGHT;diffuse,color(fcacolor..",0.5");
			sleep,0.5;diffusealpha,1;linear,0.5;zoomtowidth,SCREEN_WIDTH/2;diffusealpha,0;))(self);
		end;
	};
	
	Def.Quad {
		InitCommand=cmd(shadowlength,0;draworder,107);
		BeginCommand=cmd(y,SCREEN_CENTER_Y;blend,'BlendMode_Add');
		SetCommand=function(self)
			(cmd(diffusealpha,1;zoomtowidth,0;zoomtoheight,0;accelerate,0.25;zoomtoheight,SCREEN_HEIGHT;
			diffuse,color(fcacolor..",0.4");accelerate,0.75;zoomtowidth,SCREEN_WIDTH/2.25;diffusealpha,0;))(self);
		end;
	};
	
	LoadActor(THEME:GetPathB("","graph"))..{
		InitCommand=cmd(shadowlength,4;draworder,108);
		BeginCommand=cmd(y,SCREEN_CENTER_Y;);
		SetCommand=function(self)
			(cmd(addx,40;addy,20;zoom,0;linear,0.5;diffusealpha,0.7;glow,color(fcacolor..",0.6");zoom,0.75;rotationx,70;
			rotationy,-30;rotationz,100;linear,0.5;glow,color(fcacolor..",0");diffusealpha,0.7;rotationz,400;zoomx,5;diffusealpha,0;))(self);
		end;
	};
	
	LoadActor(THEME:GetPathB("","graph"))..{
		InitCommand=cmd(shadowlength,4;draworder,109);
		BeginCommand=cmd(y,SCREEN_CENTER_Y;);
		SetCommand=function(self)
			(cmd(addx,40;addy,20;zoom,0;linear,0.5;diffusealpha,0.7;glow,color(fcacolor..",1");zoom,0.75;rotationx,70;rotationy,30;rotationz,100;
			linear,0.5;rotationx,-100;rotationy,60;rotationz,200;glow,color(fcacolor..",0");linear,0.05;zoomx,5;diffusealpha,0;))(self);
		end;
	};

	LoadActor(THEME:GetPathG("","combo01"))..{
		InitCommand=cmd(shadowlength,0;draworder,110);
		BeginCommand=cmd(y,SCREEN_CENTER_Y;blend,'BlendMode_Add');
		SetCommand=function(self)
			(cmd(glow,color(fcacolor..",0.75");accelerate,0.25;diffusealpha,0.7;zoom,0;
			accelerate,1;glow,color(fcacolor..",0");zoom,2;diffusealpha,0;))(self);
		end;
	};

	LoadActor(THEME:GetPathG("","combo01"))..{
		InitCommand=cmd(shadowlength,4;draworder,111);
		BeginCommand=cmd(y,SCREEN_CENTER_Y;);
		SetCommand=function(self)
			(cmd(accelerate,0.25;diffusealpha,0.7;glow,color(fcacolor..",0.75");zoom,1.5;decelerate,0.75;
			glow,color(fcacolor..",0");diffuse,color(fcacolor..",1");zoom,1;sleep,0.5;linear,0.1;zoomx,0.5;diffusealpha,0;))(self);
		end;
	};
};

t[#t+1] = Def.Sound {
	InitCommand=function(self)
		self:load(THEME:GetPathS("","_fullcombo"));
		self:stop();
	end;
	OffCommand=cmd(playcommand,"Set");
	SetCommand=function(self)
		if CurGameName() == "dance" or CurGameName() == "pump" then
			if soundset == 1 then
				self:sleep(0.25);
				self:play();
			end;
		end;
	end;
};

--[[
	t[#t+1] = LoadFont("Common Normal")..{
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+10;horizalign,right;zoom,0.45;);
		SetCommand=function(self)
			self:settext("step : "..cstepseconds);
		end;	
	};
]]

return t;