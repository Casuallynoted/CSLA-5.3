
function GetGraphPosX(pn)
	local r = 0;
	if pn == PLAYER_1 then
		r = SCREEN_CENTER_X * 0.55;
	else r = SCREEN_CENTER_X * 1.55;
	end;
	return r;
end;

function j_w_set(self,restatsCategory,restatsColor,s,idx,judgewidth,setting)
	local value = 0;
	local cwx = 0;
	if setting == "Note" then
		local hsset = math.max(s["TapNoteScore_W1"] + s["TapNoteScore_W2"] + s["TapNoteScore_W3"] +
				s["TapNoteScore_W4"] + s["TapNoteScore_W5"] + s["TapNoteScore_Miss"],s["TotalSteps"]);
		if s["TapNoteScore_W1"] + s["TapNoteScore_W2"] + s["TapNoteScore_W3"] +
		s["TapNoteScore_W4"] + s["TapNoteScore_W5"] + s["TapNoteScore_Miss"] > 0 then
			if restatsCategory == 'TapNoteScore_W1' then
				value = s["TapNoteScore_W1"];
				cwx = 0;
			elseif restatsCategory == 'TapNoteScore_W2' then
				value = s["TapNoteScore_W2"];
				cwx = s["TapNoteScore_W1"];
			elseif restatsCategory == 'TapNoteScore_W3' then
				value = s["TapNoteScore_W3"];
				cwx = s["TapNoteScore_W1"] + s["TapNoteScore_W2"];
			elseif restatsCategory == 'TapNoteScore_W4' then
				value = s["TapNoteScore_W4"];
				cwx = s["TapNoteScore_W1"] + s["TapNoteScore_W2"] + s["TapNoteScore_W3"];
			elseif restatsCategory == 'TapNoteScore_W5' then
				value = s["TapNoteScore_W5"];
				cwx = s["TapNoteScore_W1"] + s["TapNoteScore_W2"] +
					s["TapNoteScore_W3"] + s["TapNoteScore_W4"];
			elseif restatsCategory == 'TapNoteScore_Miss' then
				value = s["TapNoteScore_Miss"];
				cwx = s["TapNoteScore_W1"] + s["TapNoteScore_W2"] +
					s["TapNoteScore_W3"] + s["TapNoteScore_W4"] + s["TapNoteScore_W5"];
			else value = hsset - s["TapNoteScore_W1"] - s["TapNoteScore_W2"] - s["TapNoteScore_W3"] -
					s["TapNoteScore_W4"] - s["TapNoteScore_W5"] - s["TapNoteScore_Miss"];
				cwx = s["TapNoteScore_W1"] + s["TapNoteScore_W2"] + s["TapNoteScore_W3"] + 
					s["TapNoteScore_W4"] + s["TapNoteScore_W5"] + s["TapNoteScore_Miss"];
			end;
			self:x( judgewidth * (cwx / hsset) );
			self:zoomtowidth( judgewidth * (value / hsset) );
			self:diffuse(restatsColor);
			self:diffusealpha(0.75);
		else
			self:diffuse(color("0.5,0.5,0.5,0.75"));
			self:x(0);
			self:zoomtowidth(0);
			if idx == 1 then
				self:zoomtowidth(judgewidth);
			end;
		end;
	else
		local stepscore = s["RadarCategory_Holds"] + s["RadarCategory_Rolls"];
		if s["HoldNoteScore_Held"] + s["HoldNoteScore_LetGo"] > 0 then
			if restatsCategory == 'HoldNoteScore_Held' then
				value = math.min(stepscore,s["HoldNoteScore_Held"]);
				cwx = 0;
			elseif restatsCategory == 'HoldNoteScore_LetGo' then
				value = stepscore - s["HoldNoteScore_Held"];
				cwx = s["HoldNoteScore_Held"];
			else value = 0;
				cwx = stepscore;
			end;
			--value = math.min(stepscore,math.max(value,0));
			cwx = math.min(stepscore,math.max(cwx,0));
			self:x( judgewidth * (cwx / stepscore) );
			self:zoomtowidth( judgewidth * (value / stepscore) );
			self:diffuse(restatsColor);
			self:diffusealpha(0.75);
		else
			self:diffuse(color("0.5,0.5,0.5,0.75"));
			self:x(0);
			self:zoomtowidth(0);
			if idx == 1 then
				self:zoomtowidth(judgewidth);
			end;
		end;
	end;
end;

function color_return(self,statsCategory,value)
	if statsCategory == 'TapNoteScore_W1' or statsCategory == 'TapNoteScore_W2' or statsCategory == 'Diff' or
	statsCategory == 'TapNoteScore_W3' or statsCategory == 'HoldNoteScore_Held' or statsCategory == 'MaxCombo' then
		if value == 0 then self:diffuse(Color("White"));
		elseif value > 0 then self:diffuse(Colors.Count["Plus"]);
		elseif value < 0 then self:diffuse(Colors.Count["Minus"]);
		else self:diffuse(Color("White"));
		end;
	else
		if value == 0 then self:diffuse(Color("White"));
		elseif value < 0 then self:diffuse(Colors.Count["Plus"]);
		elseif value > 0 then self:diffuse(Colors.Count["Minus"]);
		else self:diffuse(Color("White"));
		end;
	end;
end

function text_return(self,value)
	if value >= 0 and value <= 9 then
		self:settext( string.format("xxx".."%i",value) );
	elseif value >= 10 and value <= 99 then
		self:settext( string.format("xx".."%2i",value) );
	elseif value >= 100 and value <= 999 then
		self:settext( string.format("x".."%3i",value) );
	else
		self:settext( string.format("%4i",value) );
	end;
end;

function next_c(self,params,pnstats,hs)
	if params.Difficulty == pnstats:GetPlayedSteps()[1]:GetDifficulty() then
		if params.Score == hs["Score"] then
			self:queuecommand("Net");
		else self:queuecommand("NotNet");
		end;
	else self:queuecommand("NotNet");
	end;
end;