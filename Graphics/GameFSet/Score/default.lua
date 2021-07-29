--[[ScoreFrame]]

local pn = ...
assert(pn,"Must pass in a player, dingus");

local pm = GAMESTATE:GetPlayMode();
local p = ( (pn == PLAYER_1) and 1 or 2 );
local setx,zoomxset,setaddx,afteraddx = GetPosition(pn)+stylecheckposition()-8,1,-100,100;
local calsetx = GetPosition(pn)+stylecheckposition()-100;
if pn == PLAYER_2 then
	setx,zoomxset,setaddx,afteraddx = GetPosition(pn)+stylecheckposition()+8,-1,100,-100;
	calsetx = GetPosition(pn)+stylecheckposition()+100;
end;

local songpwidth = math.min(248,WideScale(200,248));

--comma_value
scf = "^(-?[ %d]+)([ %d][ %d][ %d])";
spo = ",";
spt = "y";

local pnsc = 0;
local oldsc = 0;
local oldscst = comma_value(string.format("%9d",oldsc),scf,spo,spt);
local countc = 1;
local pncb = 0;
local oldpncb = 0;

local endless = 0;
if GAMESTATE:IsCourseMode() then
	SongOrCourse = GAMESTATE:GetCurrentCourse();
	if (SongOrCourse:GetCourseType() == 'CourseType_Endless' or
	SongOrCourse:GetCourseType() == 'CourseType_Survival') then
		endless = 1;
	end;
end;

local t = Def.ActorFrame{
	Name="ScoreFrame"..pn;
	BeginCommand=function(self)
		if not GAMESTATE:IsDemonstration() then
			if pm ~= 'PlayMode_Battle' and pm ~= 'PlayMode_Rave' then
				self:visible(GAMESTATE:IsHumanPlayer(pn));
			else self:visible(GAMESTATE:IsPlayerEnabled(pn));
			end;
		end;
	end;
	PlayerJoinedMessageCommand=function(self,param)
		if not GAMESTATE:IsDemonstration() then
			if param.Player == pn then
				self:visible(true);
			end;
		end;
	end;
	PlayerUnjoinedMessageCommand=function(self,param)
		if not GAMESTATE:IsDemonstration() then
			if param.Player == pn then
				self:visible(true);
			end;
		end;
	end;
};

--songmeterdisplayback
t[#t+1] = Def.ActorFrame{
	InitCommand=function(self)
		self:y(SCREEN_BOTTOM-44.5);
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
				diffuse,color("0,0.4,0.3,0.7");diffuseleftedge,color("0.5,0.25,0,0.6");))(self)
			else
				(cmd(croptop,1;diffuse,color("0,1,1,1");sleep,0.6;linear,0.3;croptop,0;
				diffuse,color("0,0.4,0.3,0.7");diffuserightedge,color("0.5,0.25,0,0.6");))(self)
			end;
		end;
	};
--[[
	Def.Quad{
		InitCommand=cmd(zoomto,songpwidth,0.5;y,-2;);
		OnCommand=cmd(croptop,1;diffuse,color("0,1,1,1");diffuserightedge,color("1,0.5,0,0.6");sleep,0.6;linear,0.3;croptop,0;);
	};
]]
};

--scoreframe
t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(y,SCREEN_BOTTOM-28);
	LoadActor(""..GetGameFrame().."_ScoreFrame/scoreframe_left_frame")..{
		InitCommand=cmd(x,setx;zoomx,zoomxset;y,3;);
		OnCommand=cmd(diffusealpha,0;addx,setaddx;decelerate,0.3;diffusealpha,1;addx,afteraddx;
					glow,color("1,1,0,0");linear,0.05;glow,color("1,1,0,1");linear,0.4;glow,color("1,1,0,0"););
	};

	LoadActor(""..GetGameFrame().."_ScoreFrame/scoreframe_right_frame")..{
		InitCommand=function(self)
			if pn == PLAYER_1 then
				(cmd(x,mplayerposition()+stylecheckposition()-176;y,3;zoomx,zoomxset;))(self)
			else (cmd(x,mplayerposition()+stylecheckposition()+176;y,3;zoomx,zoomxset;))(self)
			end;
		end;
		OnCommand=cmd(cropleft,1;zoomy,2;sleep,0.3;decelerate,0.4;cropleft,0;zoomy,1;glow,color("1,0.5,0,0");linear,0.05;glow,color("1,0.5,0,1");linear,0.4;glow,color("1,0.5,0,0"););
	};
	
	LoadActor(""..GetGameFrame().."_ScoreFrame/bpmframe")..{
		InitCommand=function(self)
			if pn == PLAYER_1 then
				(cmd(x,mplayerposition()+stylecheckposition()-114;y,17;zoomx,zoomxset;))(self)
			else (cmd(x,mplayerposition()+stylecheckposition()+114;y,17;zoomx,zoomxset;))(self)
			end;
		end;
		OnCommand=cmd(cropleft,1;sleep,0.2;decelerate,0.2;cropleft,0;glow,color("1,0.5,0,0");linear,0.05;glow,color("1,0.5,0,1");linear,0.4;glow,color("1,0.5,0,0"););
	};

	LoadActor(ToEnumShortString(pn).."_left_lamp")..{
		InitCommand=function(self)
			if pn == PLAYER_1 then
				(cmd(x,setx-127;y,-4;zoomx,zoomxset;))(self)
			else (cmd(x,setx+127;y,-4;zoomx,zoomxset;))(self)
			end;
		end;
		OnCommand=cmd(diffusealpha,0;sleep,0.8;linear,0.2;diffusealpha,1;glow,color("0,1,1,0"););
		
		--[ja] 20150628修正
		LampUpdateP1MessageCommand=function(self)
			if pn == PLAYER_1 then
				(cmd(stoptweening;glow,PlayerColor(PLAYER_1);linear,1;glow,color("0,1,1,0");))(self);
			end;
		end;
		LampUpdateP2MessageCommand=function(self)
			if pn == PLAYER_2 then
				(cmd(stoptweening;glow,PlayerColor(PLAYER_2);linear,1;glow,color("0,1,1,0");))(self);
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
			UpdateCommand=cmd(queuecommand,"Set";);
			SetCommand=function(self)
				countc = 1;
				(cmd(y,-4;horizalign,right;zoom,0.55;skewx,-0.2;))(self)
				if pn == PLAYER_1 then
					self:x(setx+42);
				else self:x(setx+106);
				end;
				self:finishtweening();
				--if tonumber(getenv("fcplayercheck_p"..p)) == 1 then
				--[[
					pnsc = 0;
					self:settext(oldscst);
					if oldsc > pnsc then
						self:queuecommand("Count");
					else oldsc = pnsc;
					end;
				]]
				--else
					pnsc = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):GetScore();
					self:settext(oldscst);
					if oldsc < pnsc then
						self:queuecommand("Count");
					else oldsc = pnsc;
					end;
				--end;

				self:diffuse(color("0,1,1,1"));
				self:strokecolor(color("0,0.4,0.4,1"));
			end;
			CountCommand=function(self)
				self:finishtweening();
				countc = countc * 2;
				--if tonumber(getenv("fcplayercheck_p"..p)) == 1 then
				--[[
					pnsc = 0;
					oldsc = 0;
					oldscst = comma_value(string.format("%9d",0),scf,spo,spt);
					self:sleep(0.01);
					self:settext(oldscst);
					oldsc = pnsc;
					self:queuecommand("Set");
				]]
				--else
					pnsc = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):GetScore();
					oldsc = math.min(oldsc + countc,pnsc);
					oldscst = comma_value(string.format("%9d",oldsc),scf,spo,spt);
					self:linear(0.01);
					self:settext(oldscst);
					if oldsc < pnsc then
						self:queuecommand("Count");
					else
						oldsc = pnsc;
						--self:queuecommand("Set");
					end;
				--end;
			end;
			ScoreChangedMessageCommand=cmd(queuecommand,"Set";);
		};
	};
--[[
	Def.ActorFrame{
		OnCommand=cmd(zoomy,0;sleep,0.55;linear,0.2;zoomy,1;);
		Def.RollingNumbers{
			File=THEME:GetPathF("","_numbers4");
			InitCommand=function(self)
				self:Load("RollingNumbers");
				self:diffuse(color("0,1,1,1"));
				self:strokecolor(color("0,0.4,0.4,1"));
				if pn == PLAYER_1 then
					(cmd(x,setx+96;y,-30;horizalign,right;zoom,0.6;skewx,-0.2;))(self)
				else (cmd(x,setx-36;y,-30;horizalign,right;zoom,0.6;skewx,-0.2;))(self)
				end;
				self:targetnumber(csc);
				self:queuecommand("Set");
			end;
			OnCommand=cmd(playcommand,"Set";);
			UpdateCommand=cmd(playcommand,"Set";);
			SetCommand=function(self)
				pnsc = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):GetScore();
				if csc ~= pnsc then
					self:targetnumber(pnsc);
					csc =pnsc;
				end;
			end;
			ScoreChangedMessageCommand=cmd(queuecommand,"Set");
		};
	};
]]
};

local pstr = ProfIDSet(p);
local cstr = pstr;
local profile = PROFILEMAN:GetProfile(pn);
local pnname = PROFILEMAN:GetPlayerName(pn);
if PROFILEMAN:IsPersistentProfile(pn) then
	if GetAdhocPref("ProfIDSetP"..p) == "P"..p then
		for i = 0,PROFILEMAN:GetNumLocalProfiles()-1 do
			local profileid = PROFILEMAN:GetLocalProfileIDFromIndex(i);
			local prof = PROFILEMAN:GetLocalProfileFromIndex(i);
			local dname = prof:GetDisplayName();
			if pnname == dname then
				cstr = profileid
				break;
			end;
		end;
	end;

	local weight = profile:GetWeightPounds();
	if weight > 0 then
		if ProfIDPrefCheck("HandCheck",cstr,true) then
			t[#t+1] = Def.ActorFrame{
				InitCommand=cmd(y,SCREEN_BOTTOM-28;);
				OnCommand=cmd(zoomy,0;sleep,0.55;linear,0.2;zoomy,1;);
				LoadFont("_numbers4")..{
					InitCommand=cmd(maxwidth,120;diffuse,color("0,1,1,1");strokecolor,color("0,0.4,0.4,1");queuecommand,"Set";);
					OnCommand=cmd(queuecommand,"Set";);
					UpdateCommand=cmd(queuecommand,"Set";);
					SetCommand=function(self)
						self:stoptweening();
						(cmd(x,calsetx;y,-26;horizalign,right;zoom,0.35;skewx,-0.2;))(self)
						pncb = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):GetCaloriesBurned();
						self:settextf("%0.2f",pncb);
						if oldpncb ~= pncb then
							oldpncb = pncb;
						end;
						self:sleep(0.1);
						self:queuecommand("Set");
						--self:settext("22222.00");
					end;
				};
				LoadFont("_numbers5")..{
					InitCommand=function(self)
						(cmd(y,-32;horizalign,left;settext,"b";zoom,0.75;skewx,-0.2;))(self)
						if pn == PLAYER_1 then
							self:x(calsetx+4);
						else self:x(calsetx+4);
						end;
						self:diffuse(color("0,1,1,1"));
						self:strokecolor(color("0,0.4,0.4,1"));
					end;
				};
			};
		end;
	end;
end;

--bpmimage
t[#t+1] = LoadActor("bpm")..{
	InitCommand=function(self)
		if pn == PLAYER_1 then
			(cmd(x,mplayerposition()+stylecheckposition()-64;y,SCREEN_BOTTOM-4;diffusealpha,0;addy,-6;))(self)
		else (cmd(x,mplayerposition()+stylecheckposition()+64;y,SCREEN_BOTTOM-4;diffusealpha,0;addy,-6;))(self)
		end;
	end;
	OnCommand=cmd(sleep,0.5;decelerate,0.2;diffusealpha,1;addy,6;glow,color("1,1,0,0");linear,0.05;glow,color("1,1,0,1");linear,0.4;glow,color("1,1,0,0"););
};

return t;