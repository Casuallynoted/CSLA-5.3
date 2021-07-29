local numPlayers = #GAMESTATE:GetHumanPlayers();

local function UpdateSingleBPM(self)
	local bpmDisplay = self:GetChild("BPMDisplay");
	local pn = GAMESTATE:GetMasterPlayerNumber();
	local pState = GAMESTATE:GetPlayerState(pn);
	local songPosition = pState:GetSongPosition();
	local now = songPosition:GetSongBeat();
	local bpm = songPosition:GetCurBPS() * 60;
	local stop = songPosition:GetFreeze();
	local cbpm = string.format("%01.0f",bpm);
	if stop then cbpm = 0;
	end;
	bpmDisplay:settext( cbpm );
	--[ja] Graphics/LifeFrame/mclifeにBPMの値を渡します
	setenv("playercurrentbpmp1",( cbpm ) );
	setenv("playercurrentbpmp2",( cbpm ) );
	--[ja] 20150628修正
	if tonumber(cbpm) > 0 and now >= 4 and math.floor(now) % 4 == 0 then
		if (pn == PLAYER_1) then
			MESSAGEMAN:Broadcast("LampUpdateP1");
		else MESSAGEMAN:Broadcast("LampUpdateP2");
		end;
	end;
end

local displaySingle = Def.ActorFrame{
	-- manual bpm displays
	LoadFont("","_numbers4")..{
		Name="BPMDisplay";
		Condition=not GAMESTATE:IsDemonstration();
		InitCommand=function(self)
			if GAMESTATE:IsHumanPlayer(PLAYER_1) then self:x(-117);
			else self:x(117);
			end;
			(cmd(diffuse,color("0,1,1,1");strokecolor,color("0,0.4,0.4,1");zoom,0.6;maxwidth,120;skewx,-0.2;))(self)
		end;
		OnCommand=cmd(addy,6;diffusealpha,0;sleep,0.575;decelerate,0.2;addy,-6;diffusealpha,1;);
	};
};

displaySingle.InitCommand=cmd(SetUpdateFunction,UpdateSingleBPM);

if numPlayers == 1 then
	return displaySingle
else
	local function Update2PBPM(self)
		local dispP1 = self:GetChild("DisplayP1");
		local dispP2 = self:GetChild("DisplayP2");

		-- needs current bpm for p1 and p2
		for pn in ivalues(PlayerNumber) do
			local bpmDisplay;
			if pn == PLAYER_1 then bpmDisplay = dispP1;
			else bpmDisplay = dispP2;
			end;
			local pState = GAMESTATE:GetPlayerState(pn);
			local songPosition = pState:GetSongPosition();
			local now = songPosition:GetSongBeat();
			local bpm = songPosition:GetCurBPS() * 60;
			local stop = songPosition:GetFreeze();
			local cbpm = string.format("%01.0f",bpm);
			if stop then cbpm = 0;
			end;
			bpmDisplay:settext( cbpm );
			--[ja] Graphics/LifeFrame/mclifeにBPMの値を渡します
			if (pn == PLAYER_1) then
				setenv("playercurrentbpmp1",( cbpm ) );
			else setenv("playercurrentbpmp2",( cbpm ) );
			end;
			--[ja] 20150628修正
			if tonumber(cbpm) > 0 and now >= 4 and math.floor(now) % 4 == 0 then
				if (pn == PLAYER_1) then
					MESSAGEMAN:Broadcast("LampUpdateP1");
				else MESSAGEMAN:Broadcast("LampUpdateP2");
				end;
			end;
		end
	end

	local displayTwoPlayers = Def.ActorFrame{
		-- manual bpm displays
		LoadFont("","_numbers4")..{
			Name="DisplayP1";
			Condition=GAMESTATE:IsHumanPlayer(PLAYER_1) and not GAMESTATE:IsDemonstration();
			InitCommand=cmd(x,-117;diffuse,color("0,1,1,1");strokecolor,color("0,0.4,0.4,1");zoom,0.6;maxwidth,120;skewx,-0.2;);
			OnCommand=cmd(addy,6;diffusealpha,0;sleep,0.575;decelerate,0.2;addy,-6;diffusealpha,1;);
		};
		LoadFont("","_numbers4")..{
			Name="DisplayP2";
			Condition=GAMESTATE:IsHumanPlayer(PLAYER_2) and not GAMESTATE:IsDemonstration();
			InitCommand=cmd(x,117;diffuse,color("0,1,1,1");strokecolor,color("0,0.4,0.4,1");zoom,0.6;maxwidth,120;skewx,-0.2;);
			OnCommand=cmd(addy,6;diffusealpha,0;sleep,0.575;decelerate,0.2;addy,-6;diffusealpha,1;);
		};
	};

	displayTwoPlayers.InitCommand=cmd(SetUpdateFunction,Update2PBPM);
	return displayTwoPlayers
end

-- should not get here
-- return Def.ActorFrame{}