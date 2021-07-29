local t = Def.ActorFrame{};

local s_check = false;

local pstyle = {
	single		= "SINGLE",
	solo			= "SOLO",
	double		= "DOUBLE",
	halfdouble		= "H-DOUBLE",
	versus		= "VERSUS"
};
local pmode = {
	regular	= "DANCE",
	rave		= "BATTLE",
	nonstop	= "NONSTOP",
	oni		= "CHALLENGE",
	endless	= "ENDLESS"
};

function inputs(event)
	local dbutton = event.DeviceInput.button;
	if event.type == "InputEventType_Repeat" then
		if dbutton == "DeviceButton_left shift" or dbutton == "DeviceButton_right shift" then
			s_check = true;
			--Trace("Check_OK2");
			--SCREENMAN:SystemMessage("Check_OK");
		end;
	else
		s_check = false;
	end;
end;
t[#t+1] = Def.ActorFrame {
	OnCommand=function(self)
		SCREENMAN:GetTopScreen():AddInputCallback(inputs);
	end;
	OffCommand=function(self)
		if s_check and GAMESTATE:IsEventMode() and GAMESTATE:GetNumPlayersEnabled() == 1 then
			SnamecolorSet("course");

			for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
				local p = (pn == PLAYER_1) and 1 or 2;
				local pstr = ProfIDSet(p);
				if PROFILEMAN:IsPersistentProfile(pn) then
					--Trace("Check_OK3");
					--SCREENMAN:SystemMessage(pstr);
					if ProfIDPrefCheck("LastStyleMode",pstr,"StepsType_Dance_Single:PlayMode_Regular") then 
						--Trace("Check_OK4");
						local lsm_s = split(":",ProfIDPrefCheck("LastStyleMode",pstr,"StepsType_Dance_Single:PlayMode_Regular"));
						local st_s = split("_",lsm_s[1]);
						local pm_s = IsNetConnected() and "PlayMode_Regular" or lsm_s[2];
						if string.lower(st_s[2]) == string.lower(GAMESTATE:GetCurrentGame():GetName()) then
							GAMESTATE:SetCurrentStyle(st_s[3]);
							GAMESTATE:SetCurrentPlayMode(pm_s);
							setenv("smShortcut",1);
							local style_string = pstyle[string.lower(st_s[3])] .." STYLE";
							local mode_string = pmode[string.lower(ToEnumShortString(pm_s))].." MODE";
							if IsNetConnected() then
								SCREENMAN:SystemMessage("Shortcut Mode : "..style_string);
							else SCREENMAN:SystemMessage("Shortcut Mode : "..style_string .." - "..mode_string);
							end;
						end;
					end;
				end;
				if not IsNetConnected() then
					--[ja] キャラクターセットフラグ
					local charaset = ProfIDPrefCheck("CharacterSet",pstr,"default,0");
					local chastr = split(",",charaset);
					SetAdhocPref("CharacterSet",chastr[1]..",1",pstr);
				end;
				CustomcolorSet(pstr);
			end;
		end;
	end;
};

return t;