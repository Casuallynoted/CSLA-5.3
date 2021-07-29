
--[[ PaneDisplay text ]]
scf = "^(-?[ %d]+)([ %d][ %d][ %d])";
spo = ",";
spt = "y";

local pn = ...
assert(pn,"Must pass in a player, dingus");

local SongOrCourse = "";
local StepsOrTrail = "";
local p = ( (pn == "PlayerNumber_P1") and 1 or 2 );
local pstr = ProfIDSet(p);
local p1str = ProfIDSet(1);
local p2str = ProfIDSet(2);
local ntable = {ntype = "CSGrade",default = "SMGrade"};
local sctable = {ntype = "CSGrade",default = "SMGrade"};

if GAMESTATE:IsHumanPlayer(pn) then
	local coverpos = 140;
	if ProfIDPrefCheck("CoverPos",pstr,"") ~= "" then
		coverpos = ProfIDPrefCheck("CoverPos",pstr,"");
		if getenv("coverpos"..pstr) then
			SetAdhocPref("CoverPos",getenv("coverpos"..pstr),pstr);
		else
			SetAdhocPref("CoverPos",coverpos,pstr);
		end;
	end;
	local graphdistance = "Far";
	if ProfIDPrefCheck("GraphDistance",pstr,"") ~= "" then
		graphdistance = ProfIDPrefCheck("GraphDistance",pstr,"");
		if getenv("graphdistance"..pstr) then
			SetAdhocPref("GraphDistance",getenv("graphdistance"..pstr),pstr);
		else
			SetAdhocPref("GraphDistance",graphdistance,pstr);
		end;
	end;
end;

local gset = judge_initial(pstr);
if pn == PLAYER_1 then setenv("judgesetp1",gset);
else setenv("judgesetp2",gset); 
end;

local yOffset = 16;

local SorCDir;
local sdirs;
local sttype;
local SorCTime = 0;
local bIsCourseMode = GAMESTATE:IsCourseMode();
local pm = GAMESTATE:GetPlayMode();
local kflag = 1;

local coursetype = true;
local endlesstype = true;

local paneCategoryValues = {
	{ Category = 'RadarCategory_TapsAndHolds'},
	{ Category = 'RadarCategory_Lifts'},
	{ Category = 'RadarCategory_Rolls'},
	{ Category = 'RadarCategory_Hands'},
	{ Category = 'RadarCategory_Mines'},
	{ Category = 'RadarCategory_Holds'},
	{ Category = 'RadarCategory_Jumps'},
};

local hs = {};
local sctable = {};
local fcheck = 5;
local fchecktemp = 9;
local firstfccheck = 5;
local ltcheck = 0;
local MIGS = {ntype = 0,default = 0};
local MIGS_MAX = {ntype = 0,default = 0};
local tGrade = {ntype = "Grade_None",default = "Grade_None"};

local graphwidth = 145;
local gradegraphwidth = {ntype = 0,default = 0};
local g_lowpic = "GradeLowPic/GradeDisplayEval";
local t = Def.ActorFrame{
	Name="PaneDisplay"..pn;
	BeginCommand=function(self)
		self:visible(GAMESTATE:IsHumanPlayer(pn));
		if getenv("exflag") == "csc" then
			self:playcommand("NoAnim");
		else
			if getenv("ReloadAnimFlag") == 1 then self:playcommand("NoAnim");
			else self:playcommand("Anim");
			end;
		end;
	end;
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
	CodeMessageCommand=function(self,params)
		--[ja] 表示グレードセット
		--if not IsNetConnected() then
			if params.PlayerNumber == pn then
				if params.Name == "JudgeChange" then
					local g_return = {ntype = "default",default = "ntype"};
					gset = g_return[gset];
					MESSAGEMAN:Broadcast("JudgeSetting",{GSet = gset,Player = pn});
				end;
			end;
		--else gset = "default";
		--end;
	end;
};

---------------------------------------------------------------------------------------------------------------------------------------
t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(playcommand,"JudgeSetting",{GSet = gset,Player = pn};);
	OnCommand=cmd(playcommand,"JudgeSetting",{GSet = gset,Player = pn});
	JudgeSettingMessageCommand=function(self,params)
		if params.Player ~= pn then return;
		end;
		setenv("judgesetp"..p,params.GSet);
		self:stoptweening();
		SongOrCourse = CurSOSet();
		StepsOrTrail = CurSTSet(pn);
		if bIsCourseMode then
			if SongOrCourse then
				if SongOrCourse:GetCourseType() == 'CourseType_Endless' or SongOrCourse:GetCourseType() == 'CourseType_Survival' then
					coursetype = false;
					if SongOrCourse:GetCourseType() == 'CourseType_Endless' then
						endlesstype = false;
					end;
				else
					coursetype = true;
					endlesstype = true;
				end;
			end;
		else
			coursetype = true;
			endlesstype = true;
		end;
		tGrade["ntype"]		= "Grade_None";
		tGrade["default"]	= "Grade_None";
		
		hs_local_set(hs,0);
		hs["CSurvivalSeconds"]	= 0;
		hs["MPercentScore"]		= 0;
		
		hs_local_set(sctable,0);
		sctable["CSurvivalSeconds"]	= 0;
		sctable["MPercentScore"]		= 0;
		
		fcheck = 5;
		fchecktemp = 9;
		firstfccheck = 5;
		gradegraphwidth["ntype"]	= 0;
		gradegraphwidth["default"]	= 0;
		--if getenv("wheelstop") == 1 and getenv("rnd_song") == 0 and endlesstype then
		if getenv("rnd_song") == 0 and endlesstype then
			--20160710
			if GAMESTATE:GetCurrentStyle() then
				sttype = GAMESTATE:GetCurrentStyle():GetStepsType();
			end;
			if SongOrCourse and StepsOrTrail then
				if bIsCourseMode then
					if endlesstype then
						--20160504
						if GAMESTATE:GetCurrentStyle() then
							sttype = GAMESTATE:GetCurrentStyle():GetStepsType();
						end;
						SorCTime = courselength(SongOrCourse,GAMESTATE:GetCurrentTrail(pn),sttype);
					end;
					SorCDir = SongOrCourse:GetCourseDir();
				else
					SorCTime = SongOrCourse:GetLastSecond();
					SorCDir = SongOrCourse:GetSongDir();
				end;
				steps_count(hs,SongOrCourse,StepsOrTrail,pn,"Song");

				local profile = c_profile(pn);
				local cr_path = "";
				local tmpo = "";
				local tmpogs = "";
				local tmpolts = "";
				if getenv("wheelstop") == 1 then
					if SorCDir ~= "" then
						sdirs = split("/",SorCDir);
						if sdirs and sdirs[2] then
							sdirs[2] = additionaldir_to_songdir(sdirs[2]);
						end;
						cr_path = "CSRealScore/"..profile:GetGUID().."_"..profile:GetDisplayName().."/"..sdirs[2].."/"..sdirs[3].."/"..sdirs[4].."/set_"..wpsetd.."_"..swpsetd;
						if FILEMAN:DoesFileExist( cr_path ) then
							local ntable = {ntype = "CS",default = "SM"};
							if GetRSParameter( cr_path,sttype.."_"..ToEnumShortString(StepsOrTrail:GetDifficulty()) .."/"..ntable[params.GSet]) ~= "" then
								tmpo = split( ":",GetRSParameter( cr_path,sttype.."_"..ToEnumShortString(StepsOrTrail:GetDifficulty()) .."/"..ntable[params.GSet]) );
							end;
						end;
					end;
				end;

				local scorelist = profile:GetHighScoreList(SongOrCourse,StepsOrTrail);
				assert(scorelist);
				local scores = scorelist:GetHighScores();
				local topscore = scores[1];
				local snum = snum_set(1,scores,pn);
				ltcheck = 0;
				if snum > 0 then
					topscore = scores[snum];
					if topscore then
						hs_set(hs,topscore,"normal");
						hs["SurvivalSeconds"]		= topscore:GetSurvivalSeconds();
						hs["CSurvivalSeconds"]		= topscore:GetSurvivalSeconds();
						
						if bIsCourseMode then
							hs["SurvivalSeconds"]	= SorCTime + 1;
						end;
						played = true;
						fcheck = 5;
						fchecktemp = 9;
						
						if not assistchecker(pn,hs["Modifiers"]) then
							firstfccheck = fullcombochecker(hs,SorCTime);
						else firstfccheck = 9;
						end;
						hs["Grade"] = gradechecker(hs,topscore:GetGrade(),SorCTime,params.GSet,firstfccheck);
						tGrade["ntype"] = gradechecker(hs,topscore:GetGrade(),SorCTime,"ntype",fcheck);
						tGrade["default"] = gradechecker(hs,topscore:GetGrade(),SorCTime,"default",fcheck);
						if tGrade[params.GSet] ~= "Grade_None" and tGrade[params.GSet] ~= "Grade_Failed" then
							if getenv("wheelstop") == 1 then
								if #scores >= 1 then
									local scset = math.min(#scores,5);
									if snum <= scset then
										for i=snum,scset do
											if scores[i] then
												sctable["TotalSteps"]				= hs["TotalSteps"];
												sctable["RadarCategory_Holds"]		= hs["RadarCategory_Holds"];
												sctable["RadarCategory_Rolls"]		= hs["RadarCategory_Rolls"];
												hs_set(sctable,scores[i],"normal");
												sctable["Score"]				= scores[i]:GetScore();
												sctable["PercentScore"]			= scores[i]:GetPercentDP();
												sctable["SurvivalSeconds"]			= scores[i]:GetSurvivalSeconds();
												sctable["CSurvivalSeconds"]		= scores[i]:GetSurvivalSeconds();
												sctable["Modifiers"]				= scores[i]:GetModifiers();
												if bIsCourseMode then
													sctable["SurvivalSeconds"]		= SorCTime + 1;
												end;
												if sctable["Grade"] ~= "Grade_None" and sctable["Grade"] ~= "Grade_Failed" then
													if not assistchecker(pn,sctable["Modifiers"]) then
														if fcheck > fullcombochecker(sctable,SorCTime) then
															--if sctable["PercentScore"] >= hs["PercentScore"] then
																fcheck = fullcombochecker(sctable,SorCTime);
																fchecktemp = fcheck;
															--end;
														end;
													else
														if fchecktemp == 9 then
															fcheck = 9;
														end;
													end;
												end;
											else break;
											end;
										end;
										--20171226
										tGrade["default"] = gradechecker(hs,topscore:GetGrade(),SorCTime,"default",firstfccheck);
									end;
								end;
							else
								if not assistchecker(pn,hs["Modifiers"]) then
									if fcheck > fullcombochecker(hs,SorCTime) then
										--if sctable["PercentScore"] >= hs["PercentScore"] then
											fcheck = fullcombochecker(hs,SorCTime);
											fchecktemp = fcheck;
										--end;
									end;
								else
									if fchecktemp == 9 then
										fcheck = 9;
									end;
								end;
								--20171226
								tGrade["default"] = gradechecker(hs,topscore:GetGrade(),SorCTime,"default",firstfccheck);
							end;
						end;
					end;
					if fcheck < 9 then
						if FILEMAN:DoesFileExist( cr_path ) then
							if #tmpo >= 6 then
								tmpolts = split(",",tmpo[6]);
								ltcheck = eachecker(tmpolts);
							end;
						end;
					end;
				else
					if tGrade[params.GSet] == "Grade_None" and coursetype then
						if FILEMAN:DoesFileExist( cr_path ) then
							if #tmpo >= 2 then
								tmpogs = split("/",tmpo[2]);
								if string.sub(tmpogs[1],1,10) == "Grade_Tier" then
									if tmpogs[1] == "Grade_Tier21" then
										tGrade[params.GSet] = "Grade_Failed";
									else tGrade[params.GSet] = tmpogs[1];
									end;
								end;
							end;
						end;
					end;
				end;
				MIGS["ntype"] = migschecker(hs,"ntype");
				MIGS["default"] = migschecker(hs,"default");
				MIGS_MAX["ntype"] = migsmaxchecker(hs,"ntype");
				MIGS_MAX["default"] = migsmaxchecker(hs,"default");
				if MIGS_MAX[params.GSet] <= 0 then MIGS_MAX[params.GSet] = 1; end;
				--gradegraphwidth = math.floor(MIGS / MIGS_MAX * graphwidth);
				gradegraphwidth["ntype"] = MIGS["ntype"] / MIGS_MAX["ntype"] * graphwidth;
				gradegraphwidth["ntype"] = math.max(0,gradegraphwidth["ntype"]);
				gradegraphwidth["ntype"] = math.min(graphwidth,gradegraphwidth["ntype"]);
				gradegraphwidth["default"] = MIGS["default"] / MIGS_MAX["default"] * graphwidth;
				gradegraphwidth["default"] = math.max(0,gradegraphwidth["default"]);
				gradegraphwidth["default"] = math.min(graphwidth,gradegraphwidth["default"]);
				local t_mSet = {
					ntype = migsmaxchecker(hs,"ntype"),
					default = migsmaxchecker(hs,"default")
				};
				if t_mSet["ntype"] == MIGS_MAX[params.GSet] or t_mSet["default"] == MIGS_MAX[params.GSet] then
					if t_mSet[params.GSet] ~= MIGS_MAX[params.GSet] then
						--20160818
						if IsNetConnected() then
							SetAdhocPref("JudgeSet",gset,pstr);
						end;
						MESSAGEMAN:Broadcast("JudgeSetting",{GSet = params.GSet,Player = pn});
					end;
				end;
			end;
		end;
	end;
	OffCommand=function(self)
		if not IsNetConnected() then
			SetAdhocPref("JudgeSet",gset,pstr);
		end;
	end;
};

---------------------------------------------------------------------------------------------------------------------------------------

local p_l_p_b = Def.ActorFrame{};
local p_l_p_l = Def.ActorFrame{};
local p_l_p_g = Def.ActorFrame{};
local p_l_p_p = Def.ActorFrame{};
local p_l_p_u = Def.ActorFrame{};

p_l_p_b[#p_l_p_b+1] = Def.Sprite{
	InitCommand=function(self)
		(cmd(x,105.5;y,4;zoomy,1;))(self)
		self:Load(THEME:GetPathG("","PaneDisplay text/frame_p"..p));
	end;
	AnimCommand=cmd(addx,20;cropleft,1;cropbottom,1;sleep,0.3;linear,0.4;addx,-20;cropleft,0;cropbottom,0;);
	NoAnimCommand=cmd(cropleft,0;cropbottom,0;);
	OffCommand=cmd(stoptweening;);
};

p_l_p_b[#p_l_p_b+1] = Def.Sprite{
	InitCommand=cmd(playcommand,"SetA");
	SetACommand=function(self)
		self:stoptweening();
		self:visible(false);
		if FILEMAN:DoesFileExist( ProfIDPrefCheck("ProfAvatar",pstr,"Off") ) then 
			self:visible(true);
			self:Load( ProfIDPrefCheck("ProfAvatar",pstr,"Off") );
			(cmd(stoptweening;scaletofit,0,0,40,40;x,-1;y,-8;))(self)
		end;
	end;
	AnimCommand=cmd(croptop,1;sleep,0.75;decelerate,0.15;croptop,0;);
	NoAnimCommand=cmd(croptop,0;);
	OffCommand=cmd(stoptweening;);
};

p_l_p_b[#p_l_p_b+1] = LoadFont("_shared4") .. {
	InitCommand=cmd(zoom,0.45;strokecolor,color("0.3,0.3,0.3,1");horizalign,right;vertalign,bottom;x,90;y,-22;
				playcommand,"JudgeSetting",{GSet = gset,Player = pn};);
	AnimCommand=cmd(diffusealpha,0;sleep,0.3;linear,0.3;diffusealpha,1;);
	NoAnimCommand=cmd(diffusealpha,1;);
	JudgeSettingMessageCommand=function(self,params)
		if params.Player ~= pn then return;
		end;
		self:stoptweening();
		self:diffuse(Colors.GradeJudge[params.GSet]);
		self:settext(THEME:GetString( "OptionExplanations",ntable[params.GSet] ));
	end;
};

for idx, cat in pairs(paneCategoryValues) do
	local paneCategory = cat.Category;
	p_l_p_l[#p_l_p_l+1] = Def.ActorFrame{
		LoadFont("_ul")..{
			Name="panecategory"..paneCategory;
			InitCommand=cmd(horizalign,right;shadowlength,0;zoom,0.45;strokecolor,color("0,0,0,1"););
			AnimCommand=cmd(diffusealpha,0;sleep,0.2+(idx/10);playcommand,"JudgeSetting",{GSet = gset,Player = pn});
			NoAnimCommand=cmd(diffusealpha,0;playcommand,"JudgeSetting",{GSet = gset,Player = pn});
			JudgeSettingMessageCommand=function(self,params)
				if params.Player ~= pn then return;
				end;
				--self:stoptweening();
				--self:visible(coursetype);
				self:x(0);
				self:y(4);
				if idx-1 >= 1 then
					self:y(15+4);
					self:x(math.abs((idx-1)*40)-4);
					self:maxwidth(76);
				else
					self:x(math.abs(idx-7)*40);
					self:maxwidth(96);
				end;

				local value = 0;
				--if getenv("wheelstop") == 1 then
				if endlesstype then
					if getenv("rnd_song") == 1 then
						value = 0;
					elseif SongOrCourse then
						-- we have a selection.
						-- Make sure there's something to grab values from.
						if StepsOrTrail then
							local rv = StepsOrTrail:GetRadarValues(pn);
							value = rv:GetValue(paneCategory);
							self:diffusealpha(1);
							if value == 0 or value == "?" then
								self:diffusealpha(0.5);
							end;
						end;
					end;
				end;
				value = value < 0 and "?" or value
				self:settext( value );
				self:diffuse( CPaneValueToColor(paneCategory,value) )
			end;
		};
	};
end;

-- PercentGraph
p_l_p_g[#p_l_p_g+1] = Def.ActorFrame{
	Def.Quad {
		Name="percentgraph";
		InitCommand=cmd(rotationy,180;x,-20.5+45;y,8;zoomx,0;zoomy,6;horizalign,right;
					playcommand,"JudgeSetting",{GSet = gset,Player = pn};);
		AnimCommand=cmd(cropleft,1;sleep,0.3;accelerate,0.4;cropleft,0;);
		NoAnimCommand=cmd(cropleft,0;);
		JudgeSettingMessageCommand=function(self,params)
			if params.Player ~= pn then return;
			end;
			self:stoptweening();
			self:visible(coursetype);
			--if getenv("wheelstop") == 1 then
			if endlesstype then
				local color1,color2 = "0,1,1,0.8","0,1,0.9,0.3";
				if tGrade[params.GSet] == "Grade_Failed" then
					color1,color2 = "1,0.15,0,0.8","1,0.15,0,0.3";
				else
					if fcheck == 9 or ltcheck == 2 then
						color1,color2 = "0,1,0,0.8","0,0.9,0,0.3";
					elseif gradegraphwidth[params.GSet] == graphwidth then
						color1,color2 = "1,1,0,0.8","1,0.5,0,0.3";
					elseif ltcheck == 1 then
						color1,color2 = "1,0.5,0,0.8","0.9,0.4,0,0.3";
					end;
				end;
				(cmd(diffuse,color(color1);diffusebottomedge,color(color2);decelerate,0.075;zoomx,math.min(graphwidth,gradegraphwidth[params.GSet])))(self);
			else (cmd(zoomx,0))(self);
			end;
			if not SongOrCourse then
				(cmd(zoomx,0))(self);
			end;
		end;
	};
};

--PercentTierLine
for i = 1, 6 do
	p_l_p_p[#p_l_p_p+1] = Def.ActorFrame{
		InitCommand=cmd(horizalign,right;x,-20.5+45;y,8;);
		Def.Quad {
			InitCommand=cmd(zoomtowidth,1.05;zoomtoheight,6;addx,-6;sleep,0.3;linear,0.2;addx,6;
						playcommand,"JudgeSetting",{GSet = gset,Player = pn};);
			AnimCommand=function(self)
				if IsNetConnected() then
					(cmd(diffusealpha,0;sleep,0.5;accelerate,0.2;diffusealpha,1;))(self)
				else (cmd(croptop,1;sleep,0.5;accelerate,0.2;croptop,0;))(self)
				end;
			end;
			NoAnimCommand=cmd(croptop,0;);
			JudgeSettingMessageCommand=function(self,params)
				if params.Player ~= pn then return;
				end;
				self:visible(false);
				self:stoptweening();
				self:diffusetopedge(color("0.3,0.3,0.3,0.15"));
				self:diffusebottomedge(color("0.5,0.5,0.5,0.5"));
				if coursetype then
					self:visible(true);
					if gradegraphwidth[params.GSet] == graphwidth then
						self:visible(false);
					elseif tGrade[params.GSet] == "Grade_Failed" then
						self:visible(false);
					else
						local Tier = {
							ntype = THEME:GetMetric("PlayerStageStats","GradePercentCSTier0"..i),
							default = THEME:GetMetric("PlayerStageStats","GradePercentTier0"..i)
						};	
						if params.GSet == "default" then
							if i <= 2 then
								self:visible(false);
							end;
						end;
						self:x(graphwidth * Tier[params.GSet]);
						--if getenv("wheelstop") == 1 then
						if endlesstype then
							if gradegraphwidth[params.GSet] >= graphwidth * Tier[params.GSet] then
								self:diffusetopedge(color("0,0.5,0.5,1"));
								self:diffusebottomedge(color("0,0.25,0.25,1"));
							end;
						end;
					end;
				end;
			end;
		};
	};
end;

p_l_p_b[#p_l_p_b+1] = Def.ActorFrame{
	InitCommand=cmd(playcommand,"JudgeSetting",{GSet = gset,Player = pn};);
	--fcmark
	LoadActor(THEME:GetPathG("","graph_mini"))..{
		Name="graph_mini";
		InitCommand=cmd(zoom,0.15;x,58;shadowlength,2;);
		AnimCommand=cmd(diffusealpha,0;addx,10;sleep,0.7;decelerate,0.3;diffusealpha,1;addx,-10;);
		NoAnimCommand=cmd(croptop,0;);
	};

	--grade
	Def.Sprite{
		Name="gradeimage";
		InitCommand=cmd(shadowlength,0;x,50;zoom,0.675;shadowlength,2;);
		AnimCommand=cmd(diffusealpha,0;addx,20;sleep,0.6;decelerate,0.3;diffusealpha,1;addx,-20;);
		NoAnimCommand=cmd(diffusealpha,1;);
	};
	
	--assisttext
	LoadFont("_shared4") .. {
		Name = "assisttext";
		InitCommand=cmd(zoom,0.45;strokecolor,color("0.3,0.3,0.3,1");horizalign,left;vertalign,bottom;x,30;y,0;);
		AnimCommand=cmd(diffusealpha,0;sleep,0.3;linear,0.3;diffusealpha,1;);
		NoAnimCommand=cmd(diffusealpha,1;);
	};

	Def.ActorFrame {
		--20160821
		Name="scpercent";
		--personal score
		LoadFont("_ul")..{
			Name="personal";
			InitCommand=function(self)
				self:visible(coursetype);
				(cmd(shadowlength,0;maxwidth,110;horizalign,right;zoomx,0.5;x,133;y,1;strokecolor,color("0,0,0,1");))(self)
			end;
			AnimCommand=function(self)
				if vcheck() ~= "5_2_0" then
					(cmd(zoomy,0;addx,20;sleep,0.75;decelerate,0.3;zoomy,0.6;addx,-20;))(self)
				else (cmd(zoomy,0.6;))(self)
				end;
			end;
			NoAnimCommand=cmd(zoomy,0.6;);
		};
		--score or time
		LoadFont("_numbers4")..{
			Name="time";
			InitCommand=cmd(maxwidth,260;shadowlength,0;diffuse,PlayerColor(pn);zoom,0.5;horizalign,right;x,224;y,-17;skewx,-0.2;strokecolor,color("0,0.4,0.4,1"););
			AnimCommand=function(self)
				if vcheck() ~= "5_2_0" then
					(cmd(zoomy,0;addx,20;sleep,0.5;decelerate,0.4;addx,-20;zoomy,0.5;))(self)
				else (cmd(zoomy,0.5;))(self)
				end;
			end;
			NoAnimCommand=cmd(zoomy,0.5;);
		};
	};
	JudgeSettingMessageCommand=function(self,params)
		if params.Player ~= pn then return;
		end;
		local graph_mini = self:GetChild('graph_mini');
		local gradeimage = self:GetChild('gradeimage');
		local assisttext = self:GetChild('assisttext');
		local scpercent = self:GetChild('scpercent');
		local personal = scpercent:GetChild('personal');
		local time = scpercent:GetChild('time');

		graph_mini:stoptweening();
		graph_mini:visible(false);
		assisttext:visible(false);
		assisttext:settext("Assist");
		assisttext:diffuse(color("0,1,0,1"));
		if ltcheck == 1 then
			assisttext:settext("Hard");
			assisttext:diffuse(color("1,0.5,0,1"));
		end;
		
		gradeimage:stoptweening();
		gradeimage:visible(false);
		personal:visible(coursetype);
		personal:stoptweening();
		--if getenv("wheelstop") == 1 then
		if endlesstype then
			if coursetype then
				if fcheck > 0 and fcheck < 5 then
					graph_mini:visible(true);
					--if pm ~= "PlayMode_Oni" and pm ~= "PlayMode_Nonstop" then
						if tGrade[params.GSet] == "Grade_Tier01" then graph_mini:x(61+6);
						elseif tGrade[params.GSet] == "Grade_Tier02" then graph_mini:x(61+1);
						else graph_mini:x(61);
						end;
					--else self:x(9);
					--end;
					graph_mini:diffuse(Colors.Judgment["JudgmentLine_W"..fcheck]);
					if fcheck <= 2 then graph_mini:glowshift();
					else graph_mini:stopeffect();
					end;
				end;
			end;
			
			if tGrade[params.GSet] ~= "Grade_None" then
				gradeimage:visible(coursetype);
				gradeimage:Load(THEME:GetPathG(g_lowpic,ToEnumShortString( tGrade[params.GSet] )));
			end;
			
			if fcheck == 9 or ltcheck == 1 or ltcheck == 2 then
				assisttext:visible(true);
			end;
			
			local ppercentsc = hs["PercentScore"] * 100;
			local ptext = "0%";
			personal:diffuse(color("0,1,1,0.6"));
			if ppercentsc == 100 then
				ptext = "100%";
				personal:diffuse(color("0,1,1,1"));
			elseif ppercentsc == 0 then
				ptext = "0%";
				personal:diffuse(color("0,1,1,0.6"));
			else
				ptext = string.format("%.2f%%", ppercentsc);
				if ppercentsc >= (PCheck(params.GSet,"Grade_Tier04") * 100) then
					personal:diffuse(color("0,1,1,1"));
				elseif ppercentsc < (PCheck(params.GSet,"Grade_Tier04") * 100) then
					personal:diffuse(color("0,0.85,0.85,1"));
				end;
			end;
			personal:settext(ptext);
			
			graph_mini:finishtweening();
			graph_mini:decelerate(0.1);
			graph_mini:y(-9-8);
			gradeimage:finishtweening();
			gradeimage:decelerate(0.1);
			gradeimage:y(-2-8);
			if not assisttext:GetVisible() then
				graph_mini:y(-9-4);
				gradeimage:y(-2-4);
			end;
		else
			personal:settext("0%");
			personal:diffuse(color("0,1,1,0.6"));
		end;
		
		time:stoptweening();
		--time:settext("0,000,000,000");
		if not coursetype then
			--time:settext(SecondsToMMSSMsMs(hs["SurvivalSeconds"]).." : "..SecondsToMMSSMsMs(SorCTime));
			--if getenv("wheelstop") == 1 then
				time:settext(SecondsToMMSSMsMs(hs["CSurvivalSeconds"]));
			--else time:settext(SecondsToMMSSMsMs(0));
			--end;
		else
			--if getenv("wheelstop") == 1 then
				time:settext(comma_value(string.format("%9d",hs["Score"]),scf,spo,spt));
			--else time:settext(comma_value(string.format("%9d",0),scf,spo,spt));
			--end;
			--time:settext(SecondsToMMSSMsMs(hs["SurvivalSeconds"]).." : "..SecondsToMMSSMsMs(SorCTime));
		end;
	end;
};

t[#t+1] = p_l_p_b;
t[#t+1] = p_l_p_l;
t[#t+1] = p_l_p_g;
t[#t+1] = p_l_p_p;
t[#t+1] = p_l_p_u;

if pn == PLAYER_1 then
	t.CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"JudgeSetting",{GSet = gset,Player = pn});
	t.CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"JudgeSetting",{GSet = gset,Player = pn});
else
	t.CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"JudgeSetting",{GSet = gset,Player = pn});
	t.CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"JudgeSetting",{GSet = gset,Player = pn});
end

t.CurrentSongChangedMessageCommand=cmd(playcommand,"JudgeSetting",{GSet = gset,Player = pn});
t.CurrentCourseChangedMessageCommand=cmd(playcommand,"JudgeSetting",{GSet = gset,Player = pn});

return t;
