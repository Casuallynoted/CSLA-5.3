local pn,maxlivesnum = ...;
assert(pn);
assert(maxlivesnum);

local t = Def.ActorFrame{};

local numPlayers = GAMESTATE:GetNumPlayersEnabled();
local sides = GAMESTATE:GetNumSidesJoined();
local twosides = (numPlayers == 1 and sides == 2);
local meterwidth = math.min(216,WideScale(213,216));
local meterheight = 14;
local pm = GAMESTATE:GetPlayMode();
local liveswidth = meterwidth / maxlivesnum;

local playerlife = 0;
local supermeter = 0;

local mframe = Def.ActorFrame{};
mframe[#mframe+1] = Def.ActorFrame{
	Def.Quad{
		Name="meterback";
		InitCommand=cmd(zoomto,meterwidth,meterheight;diffuse,color("0,0,0,0.7"));
		BeginCommand=function(self)
			if pn == PLAYER_1 then
				self:horizalign(left);
			else self:horizalign(right);
			end;
		end;
		ShowCommand=cmd(diffuse,color("0,0,0,0.7");diffuseshift;effectperiod,0.5;effectcolor1,color("0.6,0,0,1");effectcolor2,color("0,0,0,0.7"););
		HideCommand=cmd(stoptweening;stopeffect;diffuse,color("0,0,0,0.7"););
	};
	
	LoadActor("normalover")..{
		Name="meter";
		InitCommand=function(self)
			(cmd(visible,true;setsize,meterwidth,meterheight;diffuse,color("1,1,0,1");diffusetopedge,color("0.8,0.5,0,1");blend,"BlendMode_Add";))(self)
			if pn == PLAYER_1 then
				self:diffuseleftedge(color("1,0.3,0,1"));
			else self:diffuserightedge(color("1,0.3,0,1"));
			end;
		end;
		BeginCommand=function(self)
			if not GAMESTATE:IsPlayerEnabled(pn) then
				self:visible(false);
			end;
			if pn == PLAYER_1 then
				self:horizalign(left);
			else self:horizalign(right);
			end;
		end;
	};
	
	LoadActor("hotover")..{
		Name="lifehot";
		InitCommand=cmd(visible,true;setsize,meterwidth,meterheight;diffusealpha,0;blend,'BlendMode_Add';); 
		BeginCommand=function(self)
			if not GAMESTATE:IsPlayerEnabled(pn) then
				self:visible(false);
			end;
			if pm == 'PlayMode_Battle' or pm == 'PlayMode_Rave' then
				self:visible(false);	
			end;
			if pn == PLAYER_1 then
				self:horizalign(left);
			else self:horizalign(right);
			end;
		end;
		ShowCommand=cmd(finishtweening;diffusealpha,1;diffuse,color("0.6,0.6,0.6,0.5");rainbow;effectperiod,3;);
		HideCommand=cmd(stoptweening;linear,0.1;diffusealpha,0);
	};
	
	OnCommand=cmd(queuecommand,"Check";);
	LifeChangedMessageCommand=cmd(queuecommand,"Check";);
	CheckCommand=function(self)
		local hotline = self:GetChild("lifehot");
		local normalline = self:GetChild("meter");
		local bpmnormalmove = 0;
		local bpmhotmove = 0;
		local lifemove = 1;

		--[ja] ScreenGameplay BPMDisplayからBPMの値をもらいます
		local screen = SCREENMAN:GetTopScreen();
		if numPlayers == 1 then
			--[ja] 1人プレイ時にpnを使うとlogがWARNINGで埋まっちゃうので対策
			if GAMESTATE:IsHumanPlayer(PLAYER_1) then
				if pm ~= 'PlayMode_Battle' and pm ~= 'PlayMode_Rave' then
					if string.find(screen:GetName(),"ScreenGameplay.*") then playerlife = screen:GetLifeMeter(PLAYER_1):GetLife();
					end;
				else
					if split("%.",GAMESTATE:GetPlayerState(pn):GetSuperMeterLevel())[2] then
						playerlife = tonumber("0."..split("%.",GAMESTATE:GetPlayerState(pn):GetSuperMeterLevel())[2]);
					else playerlife = 0;
					end;
					supermeter = math.floor(GAMESTATE:GetPlayerState(pn):GetSuperMeterLevel()) + 1;
				end;
			else
				if pm ~= 'PlayMode_Battle' and pm ~= 'PlayMode_Rave' then
					if string.find(screen:GetName(),"ScreenGameplay.*") then playerlife = screen:GetLifeMeter(PLAYER_2):GetLife();
					end;
				else
					if split("%.",GAMESTATE:GetPlayerState(pn):GetSuperMeterLevel())[2] then
						playerlife = tonumber("0."..split("%.",GAMESTATE:GetPlayerState(pn):GetSuperMeterLevel())[2]);
					else playerlife = 0;
					end;
					supermeter = math.floor(GAMESTATE:GetPlayerState(pn):GetSuperMeterLevel()) + 1;
				end;
			end;
			if NumSides == 1 then lifemove = -1;
			end;	
			bpmnormalmove = ((0/60)*lifemove)/3.5;
			bpmhotmove = ((0/60)*lifemove)/3;
			if GAMESTATE:GetMasterPlayerNumber() == PLAYER_1 then
				if getenv("playercurrentbpmp1") then
					bpmnormalmove = ((getenv("playercurrentbpmp1")/60)*lifemove)/3.5;
					bpmhotmove = ((getenv("playercurrentbpmp1")/60)*lifemove)/3;
				end;
			else
				if getenv("playercurrentbpmp2") then
					bpmnormalmove = (getenv("playercurrentbpmp2")/60)/3.5;
					bpmhotmove = (getenv("playercurrentbpmp2")/60)/3;
				end;
			end;
		else
			if pm ~= 'PlayMode_Battle' and pm ~= 'PlayMode_Rave' then
				if string.find(screen:GetName(),"ScreenGameplay.*") then playerlife = screen:GetLifeMeter(pn):GetLife();
				end;
			else
				if split("%.",GAMESTATE:GetPlayerState(pn):GetSuperMeterLevel())[2] then
					playerlife = tonumber("0."..split("%.",GAMESTATE:GetPlayerState(pn):GetSuperMeterLevel())[2]);
				else playerlife = 0;
				end;
				supermeter = math.floor(GAMESTATE:GetPlayerState(pn):GetSuperMeterLevel()) + 1;
			end;
			if pn == PLAYER_1 then
				lifemove = -1;
				bpmnormalmove = ((0/60)*lifemove)/3.5;
				bpmhotmove = ((0/60)*lifemove)/3;
				if getenv("playercurrentbpmp1") then
					bpmnormalmove = ((getenv("playercurrentbpmp1")/60)*lifemove)/3.5;
					bpmhotmove = ((getenv("playercurrentbpmp1")/60)*lifemove)/3;
				end;
			else
				bpmnormalmove = (0/60)/3.5;
				bpmhotmove = (0/60)/3;
				if getenv("playercurrentbpmp2") then
					bpmnormalmove = (getenv("playercurrentbpmp2")/60)/3.5;
					bpmhotmove = (getenv("playercurrentbpmp2")/60)/3;
				end;
			end;
		end;
		
		normalline:stoptweening();
		if maxlivesnum > 0 then
			local lives = 1 / maxlivesnum;
			if playerlife == 1 then
				hotline:playcommand("Show");
				normalline:diffuse(Color("White"));
				normalline:diffusetopedge(color("0.5,0.5,0.5,1"));
			elseif playerlife <= lives then
				normalline:diffuse(color("0.6,0,0,1"));
				normalline:diffusetopedge(color("0.8,0,0,1"));
			else
				normalline:diffuse(color("0,1,1,1"));
				normalline:diffusetopedge(color("0,0.5,0.7,1"));
			end;
		end;
		local s_meter_color = {
			["1"] = {"#617db5ff","#23f7f8ff"},
			["2"] = {"#10fdefff","#feff3fff"},
			["3"] = {"#ffff3dff","#c6691cff"}
		};
		setmetatable( s_meter_color, { __index = function() return {"#617db5ff","#23f7f8ff"} end; } ); 
		if pn == PLAYER_1 then
			if pm ~= 'PlayMode_Battle' and pm ~= 'PlayMode_Rave' then
				normalline:bounceend(0.15);
			else
				normalline:bounceend(0.075);
				(cmd(diffuseleftedge,color(s_meter_color[tostring(supermeter)][1]);
				diffuserightedge,color(s_meter_color[tostring(supermeter)][2]);))(normalline);
			end;
			normalline:cropright(1 - playerlife);
		else
			if pm ~= 'PlayMode_Battle' and pm ~= 'PlayMode_Rave' then
				normalline:bounceend(0.15);
			else
				normalline:bounceend(0.075);
				(cmd(diffuserightedge,color(s_meter_color[tostring(supermeter)][1]);
				diffuseleftedge,color(s_meter_color[tostring(supermeter)][2]);))(normalline);
			end;
			normalline:cropleft(1 - playerlife);
		end;
		
		normalline:texcoordvelocity(bpmnormalmove,0);
		hotline:texcoordvelocity(bpmhotmove,0);
	end;

	HealthStateChangedMessageCommand=function(self,params)
		local screen = SCREENMAN:GetTopScreen();
		local meterback = self:GetChild('meterback');
		local meter = self:GetChild('meter');
		local lifehot = self:GetChild('lifehot');
		local mlevel = GAMESTATE:IsCourseMode() and "ModsLevel_Stage" or "ModsLevel_Preferred";
		local battery = GAMESTATE:GetPlayerState(pn):GetPlayerOptions(mlevel):LifeSetting() == "LifeType_Battery";
		--Trace("playerlife : "..tostring(battery));
		if pm ~= 'PlayMode_Battle' and pm ~= 'PlayMode_Rave' then
			local setst = 0;
			if params.PlayerNumber == pn then
				if battery then setst = 1;
				end;
				if maxlivesnum == 0 then
					if params.HealthState == 'HealthState_Hot' then
						(cmd(finishtweening;diffuse,Color("White");diffusetopedge,color("0.5,0.5,0.5,1");))(meter);
						if pn == PLAYER_1 then
							meter:diffuseleftedge(Color("White"));
						else meter:diffuserightedge(Color("White"));
						end;
						meterback:playcommand("Hide");
						lifehot:playcommand("Show");
					else
						(cmd(finishtweening;diffuse,color("1,1,0,1");diffusetopedge,color("0.8,0.5,0,1");))(meter)
						lifehot:playcommand("Hide");
						if pn == PLAYER_1 then
							meter:diffuseleftedge(color("1,0.3,0,1"));
						else meter:diffuserightedge(color("1,0.3,0,1"));
						end;
						if params.HealthState == 'HealthState_Danger' then
							meterback:playcommand("Show");
						else meterback:playcommand("Hide");
						end;
					end;
					if not GAMESTATE:IsDemonstration() then
						if not IsNetConnected() then
							if GAMESTATE:GetCurrentStage() ~= "Stage_1st" and 
							GAMESTATE:GetCurrentStage() ~= "Stage_2nd" then
								if GAMESTATE:GetPlayerState(pn):GetPlayerOptions(mlevel):FailSetting() == "FailType_Immediate" then
									setst = 1;
								end;
							end;
						end;
					end;
				else setst = 1;
				end;
				if setst == 1 then
					--Trace("playerlife : "..screen:GetLifeMeter(pn):GetLivesLeft());
					if battery then
						if screen:GetLifeMeter(pn):GetLivesLeft() < 2 then
							lifehot:playcommand("Hide");
							meter:diffuse(color("0.6,0,0,1"));
							meter:diffusetopedge(color("0.8,0,0,1"));
						elseif playerlife == 1 then
							lifehot:playcommand("Show");
							(cmd(finishtweening;diffuse,Color("White");diffusetopedge,color("0.5,0.5,0.5,1");))(meter);
							if pn == PLAYER_1 then
								meter:diffuseleftedge(Color("White"));
							else meter:diffuserightedge(Color("White"));
							end;
						else
							lifehot:playcommand("Hide");	
							(cmd(finishtweening;diffuse,color("1,1,0,1");diffusetopedge,color("0.8,0.5,0,1");))(meter)
							if pn == PLAYER_1 then
								meter:diffuseleftedge(color("1,0.3,0,1"));
							else meter:diffuserightedge(color("1,0.3,0,1"));
							end;
						end;
					else
						if params.HealthState == 'HealthState_Hot' then
							lifehot:playcommand("Show");
						else lifehot:playcommand("Hide");
						end;
					end;
				end;
			end;
		else
			meterback:playcommand("Hide");
			meter:finishtweening();
			meter:diffusetopedge(color("0.8,0.5,0,1"));
		end;
	end;
};

t[#t+1] = mframe;

if pm ~= 'PlayMode_Battle' and pm ~= 'PlayMode_Rave' then
	if maxlivesnum > 0 then
		if maxlivesnum > 0 and maxlivesnum <= 10 then
			maxlivesnum = maxlivesnum - 1;
			for i = 1, maxlivesnum do
				t[#t+1] = Def.Quad {
					InitCommand=cmd(zoomtoheight,meterheight;diffusealpha,1;);
					BeginCommand=function(self)
						self:zoomtowidth(3);
						if CAspect() >= 1.6 then
							self:zoomtowidth(4);
						end;
						if not GAMESTATE:IsPlayerEnabled(pn) then
							self:visible(false);
						end;
						self:diffusetopedge(color("0,1,1,0.75"));
						self:diffusebottomedge(color("0,0.3,0.3,0.9"));
						if pn == PLAYER_1 then
							self:horizalign(left);
							self:x( liveswidth * i - 2 );
						else
							self:horizalign(right);
							self:x( -liveswidth * i + 2 );
						end;
					end;

					HealthStateChangedMessageCommand=function(self,params)
						if params.PlayerNumber == pn then
							if params.HealthState == 'HealthState_Hot' then
								self:playcommand("Show");
							else self:playcommand("Hide");
							end;
						end;
					end;
					ShowCommand=cmd(diffusealpha,1;linear,0.1;diffusealpha,0.3;);
					HideCommand=cmd(stopeffect;stoptweening;linear,0.1;diffusealpha,1;);
				};
			end;	
		end;
	end;
end;

--[ja] Lives更新対策
local function update(self)
	self:playcommand("Check");
end;
t.CurrentSongChangedMessageCommand=cmd(SetUpdateFunction,update;);

return t;