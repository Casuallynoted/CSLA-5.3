--[[LifeFrame]]

local pn = ...
assert(pn,"Must pass in a player, dingus");

local pm = GAMESTATE:GetPlayMode();
local setx,zoomxset,setaddx,afteraddx = GetPosition(pn)+stylecheckposition()-11,1,-100,100;
if pn == PLAYER_2 then setx,zoomxset,setaddx,afteraddx = GetPosition(pn)+stylecheckposition()+11,-1,100,-100;
end;

local numPlayers = GAMESTATE:GetNumPlayersEnabled();
local songpwidth = math.min(248,WideScale(200,248));

local mlevel = "ModsLevel_Preferred";
local op = GAMESTATE:GetSongOptionsString();
local opstr = string.lower(op);
local pop = GAMESTATE:GetPlayerState(pn):GetPlayerOptionsString(mlevel);
local popstr = string.lower(pop);
--Trace("popstr : "..popstr);
local maxlives,maxlivesstr;
local maxlivesnum = 0;

if string.find(opstr,"%d+lives") then
	maxlives,maxlivesstr = string.find(opstr,"%d+lives");
	if maxlives then
		maxlivesnum = tonumber(string.sub(opstr,maxlives,maxlivesstr-5));
	end;
elseif string.find(popstr,"%d+lives") then
	maxlives,maxlivesstr = string.find(popstr,"%d+lives");
	if maxlives then
		maxlivesnum = tonumber(string.sub(popstr,maxlives,maxlivesstr-5));
	end;
end;

local endless = 0;
if GAMESTATE:IsCourseMode() then
	SongOrCourse = GAMESTATE:GetCurrentCourse();
	if (SongOrCourse:GetCourseType() == 'CourseType_Endless' or
	SongOrCourse:GetCourseType() == 'CourseType_Survival') then
		endless = 1;
	end;
end;


local pm = GAMESTATE:GetPlayMode();

local t = Def.ActorFrame{
	Name="LifeFrame"..pn;
	BeginCommand=function(self)
		if not GAMESTATE:IsDemonstration() then
			if pm ~= 'PlayMode_Battle' and pm ~= 'PlayMode_Rave' then
				self:visible(GAMESTATE:IsHumanPlayer(pn));
			else self:visible(GAMESTATE:IsPlayerEnabled(pn));
			end;
		else self:visible(false);
		end;
	end;
	PlayerJoinedMessageCommand=function(self,param)
		if not GAMESTATE:IsDemonstration() then
			if param.Player == pn then
				self:visible(true);
			else self:visible(false);
			end;
		end;
	end;
	PlayerUnjoinedMessageCommand=function(self,param)
		if not GAMESTATE:IsDemonstration() then
			if param.Player == pn then
				self:visible(true);
			else self:visible(false);
			end;
		end;
	end;
};

--songmeterdisplayback
t[#t+1] = Def.ActorFrame{
	InitCommand=function(self)
		self:y(SCREEN_TOP+44.5);
		if pn == PLAYER_1 then
			self:skewx(1);
		else self:skewx(-1);
		end;
		(cmd(x,GetPosition(pn)+stylecheckposition();))(self)
	end;
	Def.Quad{
		InitCommand=cmd(zoomto,songpwidth,5;);
		OnCommand=function(self)
			if pn == PLAYER_1 then
				(cmd(croptop,1;diffuse,color("0,1,1,1");sleep,0.6;linear,0.3;croptop,0;
				diffuse,color("0,0.4,0.3,0.7");diffuserightedge,color("0.5,0.25,0,0.6");))(self)
			else
				(cmd(croptop,1;diffuse,color("0,1,1,1");sleep,0.6;linear,0.3;croptop,0;
				diffuse,color("0,0.4,0.3,0.7");diffuseleftedge,color("0.5,0.25,0,0.6");))(self)
			end;
		end;
	};
--[[
	Def.Quad{
		InitCommand=cmd(zoomto,songpwidth,0.5;y,2;);
		OnCommand=cmd(croptop,1;diffuse,color("0,1,1,1");diffuserightedge,color("1,0.5,0,0.6");sleep,0.6;linear,0.3;croptop,0;);
	};
]]
};

--lifeframe
t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(y,SCREEN_TOP+28);
	LoadActor(""..GetGameFrame().."_LifeFrame/lifeframe_left_frame")..{
		InitCommand=cmd(x,setx;zoomx,zoomxset;);
		OnCommand=cmd(diffusealpha,0;addx,setaddx;sleep,0.2;accelerate,0.2;diffusealpha,1;addx,afteraddx;
					glow,color("1,1,0,0");linear,0.05;glow,color("1,1,0,1");linear,0.4;glow,color("1,1,0,0"););
	};

	LoadActor("mclife",pn,maxlivesnum)..{
		InitCommand=function(self)
			self:visible(true);
			if pn == PLAYER_1 then
				(cmd(x,setx-106;y,3;skewx,1))(self)
			else (cmd(x,setx+106;y,3;skewx,-1))(self)
			end;
		end;
		OnCommand=cmd(zoomx,0;sleep,0.8;linear,0.2;zoomx,1;);
	};

	LoadActor(""..GetGameFrame().."_LifeFrame/lifeframe_life_frame")..{
		InitCommand=cmd(x,setx;zoomx,zoomxset;);
		OnCommand=cmd(diffusealpha,0;addy,20;sleep,0.4;decelerate,0.3;diffusealpha,1;addy,-20;
					glow,color("1,0.7,0,0");linear,0.05;glow,color("1,0.7,0,1");linear,0.4;glow,color("1,0.7,0,0"););
	};

	LoadActor(""..GetGameFrame().."_LifeFrame/lifeframe_right_frame")..{
		InitCommand=function(self)
			if pn == PLAYER_1 then
				(cmd(x,mplayerposition()+stylecheckposition()-182;zoomx,zoomxset;))(self)
			else (cmd(x,mplayerposition()+stylecheckposition()+182;zoomx,zoomxset;))(self)
			end;
		end;
		OnCommand=cmd(cropleft,1;zoomy,2;sleep,0.5;accelerate,0.2;cropleft,0;zoomy,1;glow,color("1,0.5,0,0");linear,0.05;glow,color("1,0.5,0,1");linear,0.4;glow,color("1,0.5,0,0"););
	};

	Def.ActorFrame{
		InitCommand=cmd(playcommand,"Check";);
		LoadActor(ToEnumShortString(pn).."_left_lamp")..{
			Name="left_lamp";
			InitCommand=function(self)
				if pn == PLAYER_1 then
					(cmd(x,setx-121;y,2;zoomx,zoomxset;))(self)
				else (cmd(x,setx+121;y,2;zoomx,zoomxset;))(self)
				end;
			end;
			OnCommand=cmd(stoptweening;diffusealpha,0;sleep,0.8;linear,0.2;diffusealpha,1;glow,color("0,1,1,0"););
		};
		LoadActor(ToEnumShortString(pn).."_right_lamp")..{
			Name="right_lamp";
			InitCommand=function(self)
				if pn == PLAYER_1 then
					(cmd(x,mplayerposition()+stylecheckposition()-65;y,-4;zoomx,zoomxset;))(self)
				else (cmd(x,mplayerposition()+stylecheckposition()+65;y,-4;zoomx,zoomxset;))(self)
				end;
			end;
			OnCommand=cmd(stoptweening;diffusealpha,0;sleep,0.8;linear,0.2;diffusealpha,1;glow,color("0,1,1,0"););
		};

		--[ja] 20150628修正
		LampUpdateP1MessageCommand=function(self)
			if pn == PLAYER_1 then
				local left_lamp = self:GetChild("left_lamp");
				local right_lamp = self:GetChild("right_lamp");
				(cmd(stoptweening;glow,PlayerColor(PLAYER_1);linear,1;glow,color("0,1,1,0");))(left_lamp);
				(cmd(stoptweening;glow,PlayerColor(PLAYER_1);linear,1;glow,color("0,1,1,0");))(right_lamp);
			end;
		end;
		LampUpdateP2MessageCommand=function(self)
			if pn == PLAYER_2 then
				local left_lamp = self:GetChild("left_lamp");
				local right_lamp = self:GetChild("right_lamp");
				(cmd(stoptweening;glow,PlayerColor(PLAYER_2);linear,1;glow,color("0,1,1,0");))(left_lamp);
				(cmd(stoptweening;glow,PlayerColor(PLAYER_2);linear,1;glow,color("0,1,1,0");))(right_lamp);
			end;
		end;
	};
	
	LoadActor(ToEnumShortString(pn).."_st")..{
		InitCommand=function(self)
			if pn == PLAYER_1 then
				(cmd(x,mplayerposition()+stylecheckposition()-101;y,12;))(self)
			else (cmd(x,mplayerposition()+stylecheckposition()+101;y,12;))(self)
			end;
		end;
		OnCommand=cmd(diffusealpha,0;sleep,0.8;linear,0.2;diffusealpha,1;glow,color("0,1,1,0"););
	};

	LoadFont("_numbers5")..{
		InitCommand=function(self)
			(cmd(y,-32;horizalign,right;zoom,0.85;skewx,-0.2;))(self)
			if pn == PLAYER_1 then
				self:x(setx-84);
			else self:x(setx+120);
			end;
			if pm ~= 'PlayMode_Battle' and pm ~= 'PlayMode_Rave' then
				self:settext("a");
			else self:settext("z");
			end;
		end;
		OnCommand=function(self)
			if pn == PLAYER_1 then
				(cmd(diffusealpha,0;addx,-20;sleep,0.6;decelerate,0.2;addx,20;diffusealpha,1;))(self)
			else (cmd(diffusealpha,0;addx,20;sleep,0.6;decelerate,0.2;addx,-20;diffusealpha,1;))(self)
			end;
		end;
	};
	
	Def.ActorFrame{
		InitCommand=function(self)
			self:visible(false);
			if pm ~= 'PlayMode_Battle' and pm ~= 'PlayMode_Rave' then
				if endless == 0 then
					self:visible(true);
				end;
			end;
		end;
		OnCommand=cmd(zoomy,0;sleep,0.55;linear,0.2;zoomy,1;);
		LoadFont("_numbers4")..{
			InitCommand=cmd(queuecommand,"Set";);
			OnCommand=cmd(queuecommand,"Set";);
			--UpdateCommand=cmd(queuecommand,"Set";);
			SetCommand=function(self)
				self:stoptweening();
				local pndp = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):GetPercentDancePoints()*100;
				self:settextf("%.2f",pndp);
				--self:settext("100");
				if pndp >= 100 then self:settext("100");
				end;
				(cmd(y,-16;horizalign,right;zoom,0.6;skewx,-0.2;))(self)
				if pn == PLAYER_1 then
					self:x(setx+76);
				else self:x(setx-16);
				end;
				self:diffuse(color("0,1,1,1"));
				self:strokecolor(color("0,0.4,0.4,1"));
			end;
			JudgmentMessageCommand=cmd(queuecommand,"Set";);
		};
		LoadFont("_numbers4")..{
			InitCommand=function(self)
				(cmd(y,-12;horizalign,right;settext,"%";zoom,0.35;skewx,-0.2;))(self)
				if pn == PLAYER_1 then
					self:x(setx+76+12);
				else self:x(setx-16+12);
				end;
				self:diffuse(color("0,1,1,1"));
				self:strokecolor(color("0,0.4,0.4,1"));
			end;
		};
	};
};

--stageimage
t[#t+1] = LoadActor("stage")..{
	InitCommand=cmd(x,mplayerposition()+stylecheckposition()+24;y,SCREEN_TOP+38;diffusealpha,0;addx,-20;);
	OnCommand=cmd(sleep,0.5;accelerate,0.4;diffusealpha,1;addx,20;glow,color("1,1,0,0");linear,0.05;glow,color("1,1,0,1");linear,0.4;glow,color("1,1,0,0"););
};

local playerlife;
if pm ~= 'PlayMode_Battle' and pm ~= 'PlayMode_Rave' then
	local mnum = Def.ActorFrame{};
	mnum[#mnum+1] = Def.ActorFrame {
		OnCommand=function(self)
			if pn == PLAYER_1 then
				(cmd(diffusealpha,0;addx,20;sleep,0.7;decelerate,0.2;addx,-20;diffusealpha,1;))(self)
			else (cmd(diffusealpha,0;addx,-20;sleep,0.7;decelerate,0.2;addx,20;diffusealpha,1;))(self)
			end;
		end;
		LoadFont("_numbers4")..{
			Name="Lifenum";
			InitCommand=function(self)
				(cmd(y,SCREEN_TOP+12;horizalign,right;zoom,0.6;skewx,-0.2;diffuse,color("0,1,1,1");strokecolor,color("0,0.4,0.4,1");settext,maxlivesnum;))(self)
				if pn == PLAYER_1 then
					self:x(setx-68);
				else self:x(setx+106);
				end;
			end;
			OnCommand=cmd(playcommand,"Check";);
			LifeChangedMessageCommand=cmd(queuecommand,"Check";);
			CheckCommand=function(self)
				local screen = SCREENMAN:GetTopScreen();
				--local lifenum = self:GetChild("Lifenum");
				self:stoptweening();
				local llcheck = 1;
				if maxlives then llcheck = 2;
				end;
				if GAMESTATE:IsCourseMode() then
					if GAMESTATE:GetCurrentCourse():GetCourseType() == 'CourseType_Survival' then
						llcheck = 1;
					end;
				end;
				if screen then
					--[ja] 20150728修正
					if string.find(screen:GetName(),"ScreenGameplay.*") then
						if numPlayers == 1 then
							--[ja] pnを使うとlogがWARNINGで埋まっちゃうので対策
							if GAMESTATE:IsHumanPlayer(PLAYER_1) then
								if screen:GetLifeMeter(PLAYER_1) then
									playerlife = screen:GetLifeMeter(PLAYER_1);
								end;
							else
								if screen:GetLifeMeter(PLAYER_2) then
									playerlife = screen:GetLifeMeter(PLAYER_2);
								end;
							end;
						else
							if screen:GetLifeMeter(pn) then
								playerlife = screen:GetLifeMeter(pn);
							end;
						end;
						if playerlife then
							--SCREENMAN:SystemMessage(llcheck);
							if llcheck == 2 then
								if playerlife:GetLivesLeft() < 2 then
									(cmd(linear,0.15;diffuse,color("1,0.5,0,1");strokecolor,color("0.4,0,0,1");))(self);
								else (cmd(linear,0.15;diffuse,color("0,1,1,1");strokecolor,color("0,0.4,0.4,1");))(self);
								end;
								self:settextf("%i",playerlife:GetLivesLeft());
							else
								--20171229
								local p_lset = math.floor(playerlife:GetLife()*100);
								if playerlife:GetLife() > 0 then
									p_lset = math.min(100,p_lset);
									p_lset = math.max(1,p_lset);
								end;
								if playerlife:IsInDanger() then
									(cmd(linear,0.15;diffuse,color("1,0.5,0,1");strokecolor,color("0.4,0,0,1");))(self);
								else (cmd(linear,0.15;diffuse,color("0,1,1,1");strokecolor,color("0,0.4,0.4,1");))(self);
								end;
								self:settextf("%i",p_lset);
							end;
						end;
					end;
					
				end;
			end;
		};
	};
	--[ja] Lives更新対策
	local function update(self)
		self:playcommand("Check");
	end;
	mnum.CurrentSongChangedMessageCommand=cmd(SetUpdateFunction,update;);

	t[#t+1] = mnum;
else
	t[#t+1] = Def.ActorFrame{
		OnCommand=function(self)
			if pn == PLAYER_1 then
				(cmd(diffusealpha,0;addx,20;sleep,0.7;decelerate,0.2;addx,-20;diffusealpha,1;))(self)
			else (cmd(diffusealpha,0;addx,-20;sleep,0.7;decelerate,0.2;addx,20;diffusealpha,1;))(self)
			end;
		end;
		LoadFont("_numbers4")..{
			Name="SuperMetetrnum";
			InitCommand=function(self)
				(cmd(y,SCREEN_TOP+12;horizalign,right;zoom,0.6;skewx,-0.2;diffuse,color("0,1,1,1");strokecolor,color("0,0.4,0.4,1");settext,1;))(self)
				if pn == PLAYER_1 then
					self:x(setx-88);
				else self:x(setx+108);
				end;
			end;
			OnCommand=function(self)
				if pn == PLAYER_1 then
					(cmd(diffusealpha,0;addx,30;sleep,0.7;decelerate,0.2;addx,-30;diffusealpha,1;queuecommand,"Set";))(self)
				else (cmd(diffusealpha,0;addx,-30;sleep,0.7;decelerate,0.2;addx,30;diffusealpha,1;queuecommand,"Set";))(self)
				end;
			end;
			UpdateCommand=cmd(queuecommand,"Set";);
			SetCommand=function(self)
				self:stoptweening();
				if split("%.",GAMESTATE:GetPlayerState(pn):GetSuperMeterLevel())[1] then
					self:settext(tonumber(split("%.",GAMESTATE:GetPlayerState(pn):GetSuperMeterLevel())[1])+1);
				else self:settext(1);
				end;
				self:diffuse(color("0,1,1,1"));
				self:strokecolor(color("0,0.4,0.4,1"));
			end;
			JudgmentMessageCommand=cmd(queuecommand,"Set";);
		};
	};
end;

return t;
