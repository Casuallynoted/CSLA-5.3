local PlayerNumber = ...;
assert( PlayerNumber );

local t = LoadFont("_um") .. {
	Name="RemainingTime";
	Text="";
	JudgmentMessageCommand=function(self,params)
		if params.Player == PlayerNumber then
			if (GAMESTATE:GetPlayerState(params.Player):GetPlayerController() ~= 'PlayerController_Autoplay') and 
			(GAMESTATE:GetPlayerState(params.Player):GetPlayerController() ~= 'PlayerController_Cpu') then
				if params.TapNoteScore then
					local tns = ToEnumShortString(params.TapNoteScore)
					self:strokecolor(color("0,0,0,1"));
					if PREFSMAN:GetPreference(string.format("TimeMeterSecondsChange%s", tns)) > 0 then
						self:diffuse(Colors.Count["Plus"]);
					elseif PREFSMAN:GetPreference(string.format("TimeMeterSecondsChange%s", tns)) < 0 then
						self:diffuse(Colors.Count["Minus"]);
					else self:diffuse(color("1,1,1,1"));	
					end;
					self:playcommand( "GainSeconds" );
					self:playcommand( tns );
					self:settextf( "%+1.1f sec", PREFSMAN:GetPreference(string.format("TimeMeterSecondsChange%s", tns)) );
				else
					return
				end
			else
				return
			end
		else
			return
		end
	end;
};
return t